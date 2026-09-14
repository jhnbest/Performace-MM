/**
 * 管理员密码重置脚本（服务端离线执行，直接写入数据库）。
 *
 * 用法：
 *   交互式（推荐）：node resetPassword.js <工号>
 *   自动化（可供脚本批量调用，密码经环境变量传入，不占终端）：RESET_PASSWORD='新密码' node resetPassword.js <工号>
 *
 * 说明：
 *   1) 新密码摘要与前端 computePasswordDigest 完全一致：
 *      PBKDF2-HMAC-SHA256（10 万次迭代，盐 = SHA256(账号)），落库前再经 scrypt 加固，
 *      确保与登录/改密链路的校验约定匹配（传明文或 md5 均会导致无法登录）。
 *   2) 默认要求密码强度：8 位以上且至少包含 3 类字符（大写/小写字母、数字、符号）。
 *   3) 脚本直接写库、不带登录鉴权，仅允许在受控服务器上运行，勿暴露到公网。
 */
const crypto = require('crypto')
const mysql = require('mysql')
const db = require('./config/db')
const { hashPassword } = require('./utils/passwordHash')

const ITERATIONS = 100000
const KEYLEN = 32

// 生成与前端完全一致的 PBKDF2-HMAC-SHA256 摘要
function computeDigest (account, password) {
  const salt = crypto.createHash('sha256').update(String(account)).digest()
  return crypto.pbkdf2Sync(password, salt, ITERATIONS, KEYLEN, 'sha256').toString('hex')
}

// 密码强度校验（与前端要求一致的简化实现）
function isStrongEnough (pwd) {
  if (!pwd || pwd.length < 8) return false
  const hasLower = /[a-z]/.test(pwd)
  const hasUpper = /[A-Z]/.test(pwd)
  const hasDigit = /[0-9]/.test(pwd)
  const hasPunct = /[^a-zA-Z0-9]/.test(pwd)
  return [hasLower, hasUpper, hasDigit, hasPunct].filter(Boolean).length >= 3
}

// 静默读取一行密码（不回显，支持退格与 Ctrl+C 取消）
function readSecret (prompt) {
  process.stdout.write(prompt)
  return new Promise((resolve, reject) => {
    const stdin = process.stdin
    let line = ''
    stdin.setRawMode(true)
    stdin.resume()
    stdin.setEncoding('utf8')
    const onData = (char) => {
      for (const ch of char) {
        if (ch === '\u0003') { // Ctrl+C
          cleanup()
          process.stdout.write('\n')
          return reject(new Error('已取消操作'))
        }
        if (ch === '\r' || ch === '\n') {
          process.stdout.write('\n')
          cleanup()
          return resolve(line)
        }
        if (ch === '\u007f' || ch === '\b') { // 退格
          if (line.length > 0) {
            line = line.slice(0, -1)
            process.stdout.write('\b \b')
          }
        } else {
          line += ch
          process.stdout.write('*')
        }
      }
    }
    const cleanup = () => {
      stdin.removeListener('data', onData)
      stdin.setRawMode(false)
      stdin.pause()
    }
    stdin.on('data', onData)
  })
}

// Promise 化的查询
function query (pool, sql, params) {
  return new Promise((resolve, reject) => {
    pool.query(sql, params, (err, rows) => (err ? reject(err) : resolve(rows)))
  })
}

async function main () {
  const account = (process.argv[2] || '').trim()
  if (!account) {
    console.error('用法：node resetPassword.js <工号>')
    process.exit(1)
  }

  const pool = mysql.createPool(db)
  try {
    // 校验账号是否真实存在
    const rows = await query(pool, 'select id, account, name from users where account = ?', [account])
    if (!rows.length) {
      console.error(`未找到工号：${account}`)
      process.exitCode = 1
      return
    }
    const user = rows[0]
    console.log(`目标用户：${account}（${user.name || ''}）`)

    // 取新密码：优先环境变量（自动化场景），否则交互式静默输入两遍
    let password = process.env.RESET_PASSWORD
    if (password && password.length > 0) {
      console.log('已从环境变量 RESET_PASSWORD 读取新密码（不显示明文）')
    } else {
      const p1 = await readSecret('请输入新密码：')
      const p2 = await readSecret('请再次输入确认：')
      if (p1 !== p2) {
        console.error('两次输入不一致，已中止')
        process.exitCode = 1
        return
      }
      password = p1
    }

    if (!isStrongEnough(password)) {
      console.error('密码强度不足：需 8 位以上，且至少包含 3 类字符（大写/小写字母、数字、符号）')
      process.exitCode = 1
      return
    }

    // 生成强摘要并 scrypt 加固后落库
    const digest = computeDigest(account, password)
    const stored = hashPassword(digest)
    const result = await query(pool, 'update users set password = ? where account = ?', [stored, account])
    if (result.affectedRows === 1) {
      console.log(`✔ 已重置 ${account} 的密码（scrypt 加固存储）`)
    } else {
      console.error('重置失败（账号未匹配，可能状态异常）')
      process.exitCode = 1
    }
  } catch (e) {
    console.error('出错：', e && e.message ? e.message : e)
    process.exitCode = 1
  } finally {
    pool.end(() => {})
  }
}

main()
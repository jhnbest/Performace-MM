/**
 * JWT/密钥配置：消除硬编码密钥。
 * 优先读取环境变量 JWT_SECRET；未配置时生成随机密钥并持久化到 git 忽略文件，
 * 确保服务重启后同样 Token 有效，且密钥不写入源码库。
 */
const crypto = require('crypto')
const fs = require('fs')
const path = require('path')

// 获取 JWT 签名密钥
function getJwtSecret () {
  if (process.env.JWT_SECRET) {
    return process.env.JWT_SECRET
  }
  const secretFile = path.join(__dirname, '.jwt-secret')
  if (fs.existsSync(secretFile)) {
    return fs.readFileSync(secretFile, 'utf8').trim()
  }
  // 生成随机 256 位密钥并落盘（wx 表示文件已存在则失败，保证并发安全）
  const secret = crypto.randomBytes(32).toString('hex')
  try {
    fs.writeFileSync(secretFile, secret, { encoding: 'utf8', mode: 0o600, flag: 'wx' })
  } catch (e) {
    // 并发下文件被其他进程创建，重读即可
    if (fs.existsSync(secretFile)) {
      return fs.readFileSync(secretFile, 'utf8').trim()
    }
    // 极端情况下退回内存随机值（重启后旧 Token 失效）
    return secret
  }
  return secret
}

module.exports = {
  jwtSecret: getJwtSecret()
}
/**
 * 密码安全哈希工具。
 * 安全方案（无 HTTPS 环境，兼顾缓解离线爆破）：
 *   - 客户端先用 PBKDF2-HMAC-SHA256（高迭代 + 账号盐）生成强摘要，不再传明文/弱 md5；
 *   - 服务端对收到的强摘要再做 scrypt 加固后存储（数据库离线安全仍为慢哈希强度）；
 *   - 存量无盐 MD5 账号无法用强摘要校验，登录时返回“需重置”，由管理员重置。
 */
const crypto = require('crypto')

// scrypt 成本参数；p = 1 单线程，降低大量并发时的 DoS 风险；maxmem 需大于 N*r*128 的估算值
const SCRYPT_OPTIONS = { N: 16384, r: 8, p: 1, maxmem: 128 * 1024 * 1024 }
const KEYLEN = 32 // 派生密钥长度（字节）

// 判断存量密码是否为旧版无盐 MD5（32 位十六进制）——此类账号需重置，无法用强摘要校验
function isLegacyMD5 (stored) {
  return typeof stored === 'string' && /^[a-f0-9]{32}$/i.test(stored)
}

// 生成密码哈希（对客户端强摘要再做 scrypt），存储格式：scrypt$N$r$p$saltHex$hashHex
function hashPassword (digest) {
  if (typeof digest !== 'string' || digest.length === 0) {
    throw new Error('密码摘要不能为空')
  }
  const salt = crypto.randomBytes(16).toString('hex')
  const hash = crypto.scryptSync(digest, salt, KEYLEN, SCRYPT_OPTIONS)
  return `scrypt$${SCRYPT_OPTIONS.N}$${SCRYPT_OPTIONS.r}$${SCRYPT_OPTIONS.p}$${salt}$${hash.toString('hex')}`
}

// 校验客户端 PBKDF2 强摘要是否与 scrypt 存储值匹配
function verifyPassword (digest, stored) {
  if (typeof digest !== 'string' || !stored) {
    return false
  }
  const parts = stored.split('$')
  if (parts.length !== 6 || parts[0] !== 'scrypt') {
    return false
  }
  // 校验失败同样走一次 scrypt，避免通过响应时间差异探测账号密码格式
  let expected
  try {
    expected = Buffer.from(parts[5], 'hex')
  } catch (e) {
    return false
  }
  const calc = crypto.scryptSync(digest, parts[4], expected.length, {
    N: Number(parts[1]),
    r: Number(parts[2]),
    p: Number(parts[3]),
    maxmem: 128 * 1024 * 1024
  })
  return crypto.timingSafeEqual(calc, expected)
}

module.exports = {
  hashPassword,
  verifyPassword,
  isLegacyMD5
}
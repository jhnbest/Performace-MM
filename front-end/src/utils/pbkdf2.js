/**
 * 客户端密码摘要工具：PBKDF2-HMAC-SHA256（高迭代）+ 基于账号的确定性盐。
 * 用于无 HTTPS 环境下，把「弱的 md5 摘要」升级为「慢哈希摘要」，缓解被嗅探摘要的离线爆破。
 * 使用 Web Crypto 实现，异步非阻塞。
 */
export async function computePasswordDigest (account, password, iterations = 100000) {
  const enc = new TextEncoder()
  // 确定性盐：对账号做 SHA-256，保证跨账号差异、无需额外传输或存储
  const salt = await crypto.subtle.digest('SHA-256', enc.encode(String(account)))
  const baseKey = await crypto.subtle.importKey(
    'raw',
    enc.encode(password),
    'PBKDF2',
    false,
    ['deriveBits']
  )
  const bits = await crypto.subtle.deriveBits(
    {
      name: 'PBKDF2',
      hash: 'SHA-256',
      salt: salt,
      iterations: iterations
    },
    baseKey,
    256
  )
  // 转为 64 位小写十六进制
  return Array.from(new Uint8Array(bits))
    .map(b => ('0' + b.toString(16)).slice(-2))
    .join('')
}
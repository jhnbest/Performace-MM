/**
 * 修改密码失败限流模块
 * 记录每个账号连续校验旧密码失败的次数，达到阈值后锁定一段时间，防止暴力破解旧密码
 */

// 连续失败次数上限
const MAX_FAIL_COUNT = 5
// 锁定时间（毫秒），默认 15 分钟
const LOCK_MS = 15 * 60 * 1000

// 失败记录缓存：account -> { failCount, lockUntil }
const failRecords = {}

/**
 * 检查指定账号当前是否处于锁定状态
 * @param {string} account 账号
 * @returns {boolean} true 表示已锁定
 */
function isLocked (account) {
  let record = failRecords[account]
  if (!record) return false
  // 已锁定且未到期
  if (record.lockUntil && record.lockUntil > Date.now()) return true
  // 锁定时间已过，清除记录
  if (record.lockUntil) delete failRecords[account]
  return false
}

/**
 * 获取指定账号的剩余锁定时间
 * @param {string} account 账号
 * @returns {number} 剩余锁定毫秒数，未锁定时返回 0
 */
function getRemainLockTime (account) {
  let record = failRecords[account]
  if (!record || !record.lockUntil) return 0
  let remain = record.lockUntil - Date.now()
  return remain > 0 ? remain : 0
}

/**
 * 记录一次旧密码校验失败，失败次数达到阈值时触发锁定
 * @param {string} account 账号
 */
function recordFail (account) {
  let record = failRecords[account] || { failCount: 0, lockUntil: 0 }
  record.failCount = record.failCount + 1
  if (record.failCount >= MAX_FAIL_COUNT) {
    record.lockUntil = Date.now() + LOCK_MS
    record.failCount = 0
  }
  failRecords[account] = record
}

/**
 * 校验成功后清除该账号的失败记录
 * @param {string} account 账号
 */
function reset (account) {
  delete failRecords[account]
}

module.exports = {
  MAX_FAIL_COUNT,
  LOCK_MS,
  isLocked,
  getRemainLockTime,
  recordFail,
  reset
}

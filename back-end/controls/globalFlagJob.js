/**
 * GlobalFlag 定时任务控制器
 * 用于在 globalflag 表中插入或更新指定的 flag 记录
 * 功能：设置上一月份的相关任务已截止申报的标志
 */

const { RCPDDatabase } = require('../utils/async-db')

/**
 * 获取上一月份的第一天时间
 * @returns {string} 格式: YYYY-MM-DD HH:mm:ss
 */
function getLastMonthFirstDay() {
    const now = new Date()
    const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1)
    const year = lastMonth.getFullYear()
    const month = String(lastMonth.getMonth() + 1).padStart(2, '0')
    return `${year}-${month}-01 00:00:00`
}

/**
 * 在 globalflag 表中插入或更新 flag 记录
 * 设置上一月份的任务截止标志
 * @param {string} flagType - flag类型
 * @param {string} flagValue - flag值
 * @param {string} description - 描述
 */
async function insertOrUpdateGlobalFlag(flagType, flagValue, description) {
    try {
        const setTime = getLastMonthFirstDay()
        console.log(`[${description}] 开始执行: flagType=${flagType}, flagValue=${flagValue}, setTime=${setTime}`)
        
        // 检查上一月份是否已有该类型的记录
        let checkSql = `SELECT id FROM globalflag WHERE flagType = ? AND setTime = ?`
        let existingRecords = await RCPDDatabase(checkSql, [flagType, setTime])
        
        let result
        if (existingRecords.length > 0) {
            // 上一月份记录已存在，更新 flagValue
            let updateSql = `UPDATE globalflag SET flagValue = ? WHERE flagType = ? AND setTime = ?`
            result = await RCPDDatabase(updateSql, [flagValue, flagType, setTime])
            console.log(`[${description}] 更新成功: flagType=${flagType}, setTime=${setTime}, flagValue=${flagValue}`)
        } else {
            // 插入上一月份的新记录
            let insertSql = `INSERT INTO globalflag (setTime, flagType, flagValue) VALUES (?, ?, ?)`
            result = await RCPDDatabase(insertSql, [setTime, flagType, flagValue])
            console.log(`[${description}] 插入成功: flagType=${flagType}, setTime=${setTime}, flagValue=${flagValue}`)
        }
        
        return {
            success: true,
            flagType: flagType,
            flagValue: flagValue,
            setTime: setTime,
            operation: existingRecords.length > 0 ? 'UPDATE' : 'INSERT',
            affectedRows: result.affectedRows
        }
        
    } catch (error) {
        console.error(`[${description}] 执行失败:`, error)
        throw error
    }
}

/**
 * 执行 AMEvaDeadline 定时任务
 * 在 globalflag 表中插入/更新 flagType='AMEvaDeadline', flagValue='1'
 * 表示上一月份的 AME 成效评价已截止申报
 */
async function executeAMEvaDeadlineJob() {
    return await insertOrUpdateGlobalFlag(
        'AMEvaDeadline',
        '1',
        'AMEvaDeadline任务'
    )
}

/**
 * 执行 MutualEvaSubmit 定时任务
 * 在 globalflag 表中插入/更新 flagType='multualEvaSubmit', flagValue='1'
 * 表示上一月份的互评提交已截止
 */
async function executeMutualEvaSubmitJob() {
    return await insertOrUpdateGlobalFlag(
        'multualEvaSubmit',
        '1',
        'MutualEvaSubmit任务'
    )
}

/**
 * 执行 WorkTimeSubmit 定时任务
 * 在 globalflag 表中插入/更新 flagType='workTimeSubmit', flagValue='1'
 * 表示上一月份的工时提交已截止
 */
async function executeWorkTimeSubmitJob() {
    return await insertOrUpdateGlobalFlag(
        'workTimeSubmit',
        '1',
        'WorkTimeSubmit任务'
    )
}

module.exports = {
    executeAMEvaDeadlineJob,
    executeMutualEvaSubmitJob,
    executeWorkTimeSubmitJob,
    insertOrUpdateGlobalFlag
}

/**
 * ResetAssignProject 定时任务控制器
 * 用于将 assignprojectlist 表中的 isFilled 字段更新为 0
 */

const { RCPDDatabase } = require('../utils/async-db')

/**
 * 执行重置 assignprojectlist 的 isFilled 字段任务
 * 将所有记录的 isFilled 字段更新为 0
 */
async function executeResetAssignProjectJob() {
    try {
        console.log('ResetAssignProjectJob 开始执行')
        
        // 先统计总记录数和已填充的记录数
        let countSql = `SELECT COUNT(*) as total, SUM(CASE WHEN isFilled = 1 THEN 1 ELSE 0 END) as filledCount FROM assignprojectlist`
        let countResult = await RCPDDatabase(countSql, [])
        let totalCount = countResult[0].total
        let filledCount = countResult[0].filledCount || 0
        
        console.log(`统计: 总记录数=${totalCount}, 已填充记录数=${filledCount}`)
        
        // 更新 isFilled 为 0 (assignprojectlist表没有updateTime字段)
        let updateSql = `UPDATE assignprojectlist SET isFilled = 0 WHERE isFilled != 0 AND obsoleteStatus != 1 AND process != 100`
        let updateResult = await RCPDDatabase(updateSql, [])
        
        let affectedRows = updateResult.affectedRows
        console.log(`ResetAssignProjectJob 执行完成: 更新了 ${affectedRows} 条记录`)
        
        return {
            success: true,
            totalRecords: totalCount,
            previouslyFilledRecords: filledCount,
            resetRecords: affectedRows
        }
        
    } catch (error) {
        console.error('ResetAssignProjectJob 执行失败:', error)
        throw error
    }
}

module.exports = {
    executeResetAssignProjectJob
}

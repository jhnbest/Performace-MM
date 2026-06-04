/**
 * CleanProgress 定时任务控制器
 * 用于清理未正确申报工时的项目阶段进展
 * 
 * 清理规则：
 * 1. 已填写进展但未申报工时的项目阶段进展，重置为上月进展
 * 2. 已填写进展且已申报工时但审批未通过的项目阶段进展，重置为上月进展
 */

const { RCPDDatabase } = require('../utils/async-db')
const moment = require('moment')

/**
 * 获取上月的月份名称
 * @returns {string} - 上月的月份名称
 */
function getLastMonthName() {
    let lastMonth = moment().subtract(1, 'months')
    let monthNum = lastMonth.month() + 1
    let monthNames = ['', 'January', 'February', 'March', 'April', 'May', 'June', 
                      'July', 'August', 'September', 'October', 'November', 'December']
    return {
        monthName: monthNames[monthNum],
        year: lastMonth.year(),
        monthNum: monthNum
    }
}

/**
 * 执行清理项目阶段进展任务
 * 将未正确申报工时的项目阶段进展重置为上月进展
 */
async function executeCleanProgressJob() {
    try {
        // console.log('CleanProgressJob 开始执行')

        let lastMonthInfo = getLastMonthName()
        let lastMonthName = lastMonthInfo.monthName
        let lastMonthYear = lastMonthInfo.year
        let lastMonthNum = lastMonthInfo.monthNum

        // console.log(`清理月份: ${lastMonthYear}年${lastMonthNum}月`)
        
        // 查询所有未完成的项目阶段
        let querySql = `
            SELECT 
                apd.id as apdID,
                apd.aPLID,
                apd.projectStageName,
                mp.id as mpID,
                mp.year,
                mp.${lastMonthName} as lastMonthProcess
            FROM assignprojectdetail apd
            LEFT JOIN monthprocess mp ON mp.aPDID = apd.id AND mp.year = ? AND mp.type = 'fact' AND mp.obsoleteStatus != 1
            WHERE apd.obsoleteStatus != 1 AND apd.process != 100
        `
        let queryResult = await RCPDDatabase(querySql, [lastMonthYear])

        // console.log(`查询到 ${queryResult.length} 个未完成的项目阶段`)
        
        let updateCount = 0
        let skipCount = 0
        let cleanedDetails = []
        
        for (let item of queryResult) {
            // 计算上月的上月（用于获取上上月进展）
            let preLastMonthNum = lastMonthNum - 1
            let preLastMonthYear = lastMonthYear
            let preLastMonthName = ['', 'January', 'February', 'March', 'April', 'May', 'June',
                                    'July', 'August', 'September', 'October', 'November', 'December'][preLastMonthNum]

            if (preLastMonthNum === 0) {
                preLastMonthNum = 12
                preLastMonthYear = lastMonthYear - 1
                preLastMonthName = 'December'
            }

            // 获取上上月的进展
            let preProcessSql = `
                SELECT ${preLastMonthName} as preProcess
                FROM monthprocess
                WHERE aPDID = ? AND year = ? AND type = 'fact' AND obsoleteStatus != 1
            `
            let preProcessResult = await RCPDDatabase(preProcessSql, [item.apdID, preLastMonthYear])

            let preProcess = 0
            if (preProcessResult.length > 0 && preProcessResult[0].preProcess !== null) {
                preProcess = preProcessResult[0].preProcess
            }

            // 如果上月（3月）没有进展记录，但上上月（2月）有进展数据
            // 需要将上月的进展填充为上上月的进展（以便后续月份能正确计算工时）
            // 注意：上上月的数据可能是自动填充的，不一定有对应的工时申报
            if ((!item.lastMonthProcess || item.lastMonthProcess === null) && preProcess > 0) {
                // 上月无进展，但上上月有进展数据，需要填充上月进展

                if (item.mpID) {
                    let updateSql = `UPDATE monthprocess SET ${lastMonthName} = ? WHERE id = ?`
                    await RCPDDatabase(updateSql, [preProcess, item.mpID])

                    cleanedDetails.push({
                        projectStageName: item.projectStageName,
                        apdID: item.apdID,
                        aplID: item.aPLID,
                        monthProcessID: item.mpID,
                        lastMonth: `${lastMonthYear}年${lastMonthNum}月`,
                        lastMonthProcess: 0,
                        preMonth: `${preLastMonthYear}年${preLastMonthNum}月`,
                        preMonthProcess: preProcess,
                        resetReason: `上上月(${preLastMonthYear}年${preLastMonthNum}月)有进展，填充${lastMonthNum}月进展以便后续计算`
                    })

                    // console.log(`填充项目阶段 "${item.projectStageName}": ${lastMonthName}月进展从 null 填充为 ${preProcess}%（上上月有数据）`)
                    updateCount++
                }
                continue
            }

            // 以下是原有的逻辑：如果上月有进展但没有申报工时，重置为上上月进展
            if (!item.lastMonthProcess || item.lastMonthProcess === null) {
                skipCount++
                continue
            }

            // 检查上月进展是否已申报工时且审批通过
            let checkCurrentMonthWorkTimeSql = `
                SELECT COUNT(*) as count FROM worktimelist wl
                WHERE wl.obsoleteStatus != 1
                AND wl.applyMonth LIKE ?
                AND wl.apdID = ?
                AND wl.reviewStatus = 1
            `
            let currentMonthPattern = `${lastMonthYear}-${String(lastMonthNum).padStart(2, '0')}%`
            let checkCurrentResult = await RCPDDatabase(checkCurrentMonthWorkTimeSql, [currentMonthPattern, item.apdID])

            let hasCurrentMonthApprovedWorkTime = checkCurrentResult[0].count > 0

            if (!hasCurrentMonthApprovedWorkTime) {
                // 没有审批通过的工时申报，需要清理进展

                // 如果上月进展和上上月进展相同，不需要重置
                if (item.lastMonthProcess === preProcess) {
                    skipCount++
                    continue
                }

                // 更新上月进展为上上月进展（或0）
                if (item.mpID) {
                    let updateSql = `UPDATE monthprocess SET ${lastMonthName} = ? WHERE id = ?`
                    await RCPDDatabase(updateSql, [preProcess, item.mpID])

                    cleanedDetails.push({
                        projectStageName: item.projectStageName,
                        apdID: item.apdID,
                        aplID: item.aPLID,
                        monthProcessID: item.mpID,
                        lastMonth: `${lastMonthYear}年${lastMonthNum}月`,
                        lastMonthProcess: item.lastMonthProcess,
                        preMonth: `${preLastMonthYear}年${preLastMonthNum}月`,
                        preMonthProcess: preProcess,
                        resetReason: `${lastMonthYear}年${lastMonthNum}月进展未申报工时，重置为${preLastMonthNum}月进展`
                    })

                    // console.log(`清理项目阶段 "${item.projectStageName}": ${lastMonthName}月进展从 ${item.lastMonthProcess}% 重置为 ${preProcess}%`)
                    updateCount++
                }
            } else {
                skipCount++
            }
        }
        
        // console.log(`CleanProgressJob 执行完成: 清理了 ${updateCount} 条记录, 跳过 ${skipCount} 条记录`)
        
        return {
            success: true,
            cleanedRecords: updateCount,
            skippedRecords: skipCount,
            targetMonth: `${lastMonthYear}-${lastMonthNum}`,
            cleanedDetails: cleanedDetails,
            cleanedSummary: `共清理 ${updateCount} 条记录，详细信息如下：${cleanedDetails.map(d =>
                `\n  - 项目阶段: ${d.projectStageName} (APDID: ${d.apdID}), APLID: ${d.aplID}` +
                `\n    ${d.lastMonth}进展: ${d.lastMonthProcess}%, 重置为${d.preMonth}的${d.preMonthProcess}%` +
                `\n    原因: ${d.resetReason}`
            ).join('')}`
        }
        
    } catch (error) {
        console.error('CleanProgressJob 执行失败:', error)
        throw error
    }
}

module.exports = {
    executeCleanProgressJob
}

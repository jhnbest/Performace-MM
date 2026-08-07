/**
 * 月总结自动提交定时任务控制器
 * 功能：自动检测未提交月总结的员工并生成空白总结
 * 创建时间: 2026-01-22
 */
const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')
const moment = require('moment')

/**
 * 数据库操作封装
 */
function RCPDDatabase(sql, arrayParams) {
    return new Promise(function (resolve, reject) {
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                reject(err)
            } else {
                result = JSON.parse(JSON.stringify(result))
                resolve(result)
            }
        })
    })
}

/**
 * 月总结维度配置
 * dimension说明:
 * 1: 本月工作回顾
 * 2: 下月工作计划
 * 3: 建议
 * 4: 成效自评(普通员工)
 * 5: 成效自评(组长及以上)
 */
const CONCLUSION_DIMENSIONS = {
    NORMAL_EMPLOYEE: [1, 2, 3, 4],    // 普通员工: 4个维度
    TEAM_LEADER: [1, 2, 3, 4, 5]      // 组长及以上: 5个维度
}

// **2026年5月起：打造精品工程+创建专业团队合并为月度总结（dimension 1），移除dimension 2
const CONCLUSION_DIMENSIONS_MERGED = {
    NORMAL_EMPLOYEE: [1, 3, 4],       // 普通员工: 3个维度
    TEAM_LEADER: [1, 3, 4, 5]          // 组长及以上: 4个维度
}
const CONCLUSION_MERGE_DATE = { year: 2026, month: 5 }

/**
 * 获取所有在职员工列表
 * @returns {Promise<Array>} 员工列表
 */
async function getAllActiveUsers() {
    let sql = $sql.user.selectUsersList1
    let result = await RCPDDatabase(sql, [])
    return result
}

/**
 * 获取员工已提交的月总结维度
 * @param {number} userId 用户ID
 * @param {number} year 年份
 * @param {number} month 月份
 * @returns {Promise<Array>} 已提交的维度数组
 */
async function getUserSubmittedDimensions(userId, year, month) {
    let sql = `SELECT dimension FROM newconclusion 
               WHERE userID = ? AND conclusionYear = ? AND conclusionMonth = ? AND submitStatus = 1`
    let result = await RCPDDatabase(sql, [userId, year, month])
    return result.map(row => row.dimension)
}

/**
 * 检查用户是否为组长及以上级别
 * duty说明：
 * - 1: 处经理（不需要提交月总结）
 * - 2: 组长
 * - 3: 组员
 * @param {Object} user 用户对象
 * @returns {boolean} 是否为组长及以上
 */
function isTeamLeaderOrAbove(user) {
    // 处经理(duty=1)不需要提交月总结
    if (!user.duty || user.duty === 1) {
        return false
    }
    // 组长(duty=2)及以上
    return user.duty === 2
}

/**
 * 检查用户是否需要提交月总结
 * @param {Object} user 用户对象
 * @returns {boolean} 是否需要提交
 */
function shouldSubmitConclusion(user) {
    // 处经理(duty=1)不需要提交月总结
    return user.duty && user.duty !== 1
}

/**
 * 为用户生成空白月总结
 * @param {Object} user 用户对象
 * @param {number} year 年份
 * @param {number} month 月份
 * @param {Array} dimensions 需要生成的维度
 * @returns {Promise<Array>} 生成的总结ID数组
 */
async function generateBlankConclusions(user, year, month, dimensions) {
    let generatedIds = []
    let submitTime = $time.formatTime()
    let updateTime = submitTime
    
    for (let dimension of dimensions) {
        try {
            let sql = $sql.conclusion.submitMonthConclusionNew
            let arrayParams = [
                user.id,           // userID
                1,                 // conclusionType: 月总结
                year,              // conclusionYear
                month,             // conclusionMonth
                dimension,         // dimension
                '超时未提交，系统自动生成空白月总结',  // content: 自动填充内容
                submitTime,        // submitTime
                updateTime,        // updateTime
                1                  // submitStatus: 1=已提交(系统自动提交)
            ]
            
            let result = await RCPDDatabase(sql, arrayParams)
            if (result && result.insertId) {
                generatedIds.push(result.insertId)
            }
        } catch (error) {
            console.error(`为用户${user.name}(ID:${user.id})生成维度${dimension}总结失败:`, error)
            throw error
        }
    }
    
    return generatedIds
}

/**
 * 将某员工目标月份的"暂存"月总结批量转为"已提交"
 * - content 为空或仅空白字符时，填充为默认提示文本
 * - content 有值时，保留原内容
 * - submitStatus 由 2 改为 1
 * @param {Object} user 用户对象
 * @param {number} year 目标年份
 * @param {number} month 目标月份
 * @returns {Promise<Array<number>>} 被更新的记录 ID 列表
 */
async function submitDraftConclusions(user, year, month) {
    const DEFAULT_CONTENT = '超时未提交，系统自动生成空白月总结'
    let updatedIds = []

    // 先查询暂存记录（仅用于日志统计与结果返回）
    let drafts = await RCPDDatabase($sql.conclusion.getDraftConclusionIds, [user.id, year, month])
    if (!drafts || drafts.length === 0) {
        return updatedIds
    }

    let now = $time.formatTime()
    await RCPDDatabase(
        $sql.conclusion.submitDraftConclusions,
        [DEFAULT_CONTENT, now, user.id, year, month]
    )

    drafts.forEach(row => updatedIds.push(row.id))
    console.log(`用户${user.name}(ID:${user.id})已将 ${updatedIds.length} 条暂存月总结转为已提交`)
    return updatedIds
}

/**
 * 记录执行日志
 * @param {Object} logData 日志数据
 * @returns {Promise<number>} 日志ID
 */
async function insertExecutionLog(logData) {
    let sql = `INSERT INTO auto_conclusion_log 
               (execution_time, target_month, target_year, total_users, processed_users, 
                success_count, failed_count, execution_status, error_message) 
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`
    let arrayParams = [
        logData.execution_time,
        logData.target_month,
        logData.target_year,
        logData.total_users,
        logData.processed_users,
        logData.success_count,
        logData.failed_count,
        logData.execution_status,
        logData.error_message || null
    ]
    
    let result = await RCPDDatabase(sql, arrayParams)
    return result.insertId
}

/**
 * 更新执行日志
 * @param {number} logId 日志ID
 * @param {Object} updateData 更新数据
 */
async function updateExecutionLog(logId, updateData) {
    let sets = []
    let arrayParams = []
    
    for (let key in updateData) {
        sets.push(`${key} = ?`)
        arrayParams.push(updateData[key])
    }
    
    if (sets.length === 0) return
    
    arrayParams.push(logId)
    let sql = `UPDATE auto_conclusion_log SET ${sets.join(', ')} WHERE id = ?`
    await RCPDDatabase(sql, arrayParams)
}

/**
 * 记录处理详情
 * @param {Object} detailData 详情数据
 */
async function insertProcessingDetail(detailData) {
    let sql = `INSERT INTO auto_conclusion_detail 
               (log_id, user_id, user_name, user_duty, conclusion_month, conclusion_year, 
                dimensions_required, dimensions_generated, processing_status, error_message, conclusion_ids) 
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
    
    let arrayParams = [
        detailData.logId,
        detailData.userId,
        detailData.userName,
        detailData.userDuty,
        detailData.conclusionMonth,
        detailData.conclusionYear,
        detailData.dimensionsRequired,
        detailData.dimensionsGenerated,
        detailData.processingStatus,
        detailData.errorMessage || null,
        JSON.stringify(detailData.conclusionIds || [])
    ]
    
    await RCPDDatabase(sql, arrayParams)
}

/**
 * 执行月总结自动提交任务
 * 此函数被cronJobManager调用
 */
async function executeAutoConclusionJob() {
    let startTime = new Date()
    let logId = null
    
    try {
        console.log('========== 月总结自动提交任务开始执行 ==========')
        console.log('执行时间:', startTime.toISOString())
        
        // 获取当前月份的上一个月(因为是月总结，应该处理上个月的总结)
        let targetMoment = moment().subtract(1, 'months')
        let targetYear = parseInt(targetMoment.format('YYYY'))
        let targetMonth = parseInt(targetMoment.format('M'))
        
        console.log(`目标月份: ${targetYear}-${targetMonth}`)
        
        // 获取所有在职员工
        let users = await getAllActiveUsers()
        console.log(`在职员工总数: ${users.length}`)
        
        // 计算需要处理的员工数量（排除处经理）
        let usersToProcess = users.filter(user => user.duty !== 1)
        console.log(`需要处理的用户数: ${usersToProcess.length}`)
        
        // 初始化执行日志
        let logData = {
            execution_time: startTime,
            target_month: targetMonth,
            target_year: targetYear,
            total_users: usersToProcess.length,
            processed_users: 0,
            success_count: 0,
            failed_count: 0,
            execution_status: 0  // 执行中
        }
        
        logId = await insertExecutionLog(logData)
        console.log(`执行日志ID: ${logId}`)
        
        let successCount = 0
        let failedCount = 0
        let draftSubmittedCount = 0   // 累计自动提交（从暂存转为已提交）的用户数（按用户计）
        
        // 遍历每个员工
        for (let user of users) {
            try {
                console.log(`\n处理用户: ${user.name}(ID: ${user.id}, Duty: ${user.duty})`)
                
        // 处经理(duty=1)不需要提交月总结，跳过
        if (user.duty === 1) {
          console.log(`用户${user.name}为处经理，不需要提交月总结，跳过`)

          await insertProcessingDetail({
            logId: logId,
            userId: user.id,
            userName: user.name,
            userDuty: user.duty,
            conclusionMonth: targetMonth,
            conclusionYear: targetYear,
            dimensionsRequired: 0,   // 处经理不提交，0个已提交
            dimensionsGenerated: 0,  // 0个需要生成
            processingStatus: 3,  // 3=已跳过
            errorMessage: null,
            conclusionIds: []
          })
          continue
        }

                // 1) 先把"暂存"状态的记录全部转为"已提交"
                //    - 其他维度：content 为空时填充默认文本，有值时保留原内容
                //    - dimension=4（意见建议）：不自动填充默认内容
                let draftSubmittedIds = await submitDraftConclusions(user, targetYear, targetMonth)
                if (draftSubmittedIds.length > 0) {
                    // 按用户计数：只要该用户有任意一条暂存被自动提交，计为 1
                    draftSubmittedCount += 1
                }

                // 获取用户已提交的维度（此时已包含刚转正的暂存记录，避免重复生成空白记录）
                let submittedDimensions = await getUserSubmittedDimensions(user.id, targetYear, targetMonth)
                console.log(`已提交维度: ${submittedDimensions.join(', ') || '无'}`)
                
                // 确定需要生成的维度
                let isLeader = isTeamLeaderOrAbove(user)
                let useMergedDimensions = (targetYear > CONCLUSION_MERGE_DATE.year) ||
                    (targetYear === CONCLUSION_MERGE_DATE.year && targetMonth >= CONCLUSION_MERGE_DATE.month)
                let requiredDimensions = isLeader
                    ? (useMergedDimensions ? CONCLUSION_DIMENSIONS_MERGED.TEAM_LEADER : CONCLUSION_DIMENSIONS.TEAM_LEADER)
                    : (useMergedDimensions ? CONCLUSION_DIMENSIONS_MERGED.NORMAL_EMPLOYEE : CONCLUSION_DIMENSIONS.NORMAL_EMPLOYEE)
                
                console.log(`需要维度: ${requiredDimensions.join(', ')}`)
                console.log(`是否为组长及以上: ${isLeader}`)
                
                // 找出缺失的维度
                let missingDimensions = requiredDimensions.filter(d => !submittedDimensions.includes(d))
                
                if (missingDimensions.length === 0) {
                    console.log(`用户${user.name}已提交所有必需维度，跳过`)
                    
                    // 记录跳过详情
                    await insertProcessingDetail({
                        logId: logId,
                        userId: user.id,
                        userName: user.name,
                        userDuty: user.duty,
                        conclusionMonth: targetMonth,
                        conclusionYear: targetYear,
                        dimensionsRequired: submittedDimensions.length,  // 已提交的维度数（4或5）
                        dimensionsGenerated: 0,                          // 0个需要生成
                        processingStatus: 3,  // 3=已跳过
                        errorMessage: null,
                        conclusionIds: []
                    })
                    continue
                }
                
                console.log(`缺失维度: ${missingDimensions.join(', ')}`)
                
                // 生成空白总结
                let generatedIds = await generateBlankConclusions(user, targetYear, targetMonth, missingDimensions)
                
                console.log(`成功生成 ${generatedIds.length} 个维度总结`)
                
                // 记录处理详情
                await insertProcessingDetail({
                    logId: logId,
                    userId: user.id,
                    userName: user.name,
                    userDuty: user.duty,
                    conclusionMonth: targetMonth,
                    conclusionYear: targetYear,
                    dimensionsRequired: submittedDimensions.length,     // 已提交的维度数
                    dimensionsGenerated: generatedIds.length,           // 实际生成的维度数（需要生成的维度数）
                    processingStatus: generatedIds.length === missingDimensions.length ? 1 : 2,
                    errorMessage: generatedIds.length < missingDimensions.length ? '部分维度生成失败' : null,
                    conclusionIds: generatedIds
                })
                
                if (generatedIds.length === missingDimensions.length) {
                    successCount++
                } else {
                    failedCount++
                }
                
            } catch (error) {
                console.error(`处理用户${user.name}失败:`, error)
                
                await insertProcessingDetail({
                    logId: logId,
                    userId: user.id,
                    userName: user.name,
                    userDuty: user.duty,
                    conclusionMonth: targetMonth,
                    conclusionYear: targetYear,
                    dimensionsRequired: 0,
                    dimensionsGenerated: 0,
                    processingStatus: 2,  // 失败
                    errorMessage: error.message,
                    conclusionIds: []
                })
                
                failedCount++
            }
            
            // 更新进度
            await updateExecutionLog(logId, {
                processed_users: ++logData.processed_users,
                success_count: successCount,
                failed_count: failedCount
            })
        }
        
        // 更新最终状态
        // 判断逻辑：
        // - 如果没有需要处理的用户 -> 成功(1)
        // - 如果处理的全部成功 -> 成功(1)
        // - 如果处理的全部失败 -> 全部失败(3)
        // - 如果有成功有失败 -> 部分失败(2)
        let needToProcessCount = successCount + failedCount
        let finalStatus
        if (needToProcessCount === 0) {
          // 没有需要处理的用户，全部跳过
          finalStatus = 1  // 成功
        } else if (failedCount === 0) {
          // 处理的全部成功
          finalStatus = 1  // 成功
        } else if (successCount === 0) {
          // 处理的全部失败
          finalStatus = 3  // 全部失败
        } else {
          // 有成功有失败
          finalStatus = 2  // 部分失败
        }
        await updateExecutionLog(logId, {
            processed_users: needToProcessCount,
            success_count: successCount,
            failed_count: failedCount,
            execution_status: finalStatus
        })
        
        let endTime = new Date()
        let duration = endTime - startTime
        
        console.log('\n========== 任务执行完成 ==========')
        console.log(`成功: ${successCount} 用户`)
        console.log(`失败: ${failedCount} 用户`)
        console.log(`跳过: ${users.length - successCount - failedCount} 用户`)
        console.log(`暂存自动提交: ${draftSubmittedCount} 用户`)
        console.log(`耗时: ${duration}ms`)
        console.log('=================================\n')

        return {
                success: true,
                logId: logId,
                summary: {
                    total_users: users.length,
                    success_count: successCount,
                    failed_count: failedCount,
                    skipped_count: users.length - successCount - failedCount,
                    draft_submitted_count: draftSubmittedCount
                }
            }
        
    } catch (error) {
        console.error('月总结自动提交任务执行失败:', error)
        
        if (logId) {
            await updateExecutionLog(logId, {
                execution_status: 3,  // 全部失败
                error_message: error.message
            })
        }
        
        return {
            success: false,
            error: error.message
        }
    }
}

/**
 * 获取执行日志列表
 * @param {Object} params 查询参数
 * @returns {Promise<Array>} 日志列表
 */
async function getExecutionLogs(params = {}) {
    let sql = `SELECT * FROM auto_conclusion_log ORDER BY execution_time DESC`
    
    if (params.limit) {
        sql += ` LIMIT ?`
    }
    
    let arrayParams = params.limit ? [params.limit] : []
    return await RCPDDatabase(sql, arrayParams)
}

/**
 * 获取执行日志详情
 * @param {number} logId 日志ID
 * @returns {Promise<Array>} 详情列表
 */
async function getExecutionDetails(logId) {
    let sql = `SELECT * FROM auto_conclusion_detail WHERE log_id = ? ORDER BY id`
    return await RCPDDatabase(sql, [logId])
}

/**
 * 获取执行统计数据
 * @param {number} year 年份
 * @param {number} month 月份
 * @returns {Promise<Object>} 统计数据
 */
async function getExecutionStatistics(year, month) {
    let sql = `SELECT 
                    COUNT(*) as total_count,
                    SUM(CASE WHEN execution_status = 1 THEN 1 ELSE 0 END) as success_count,
                    SUM(CASE WHEN execution_status = 2 THEN 1 ELSE 0 END) as partial_count,
                    SUM(CASE WHEN execution_status = 3 THEN 1 ELSE 0 END) as failed_count,
                    SUM(total_users) as total_users,
                    SUM(success_count) as total_success_users,
                    SUM(failed_count) as total_failed_users
               FROM auto_conclusion_log 
               WHERE target_year = ? AND target_month = ?`
    
    let result = await RCPDDatabase(sql, [year, month])
    return result[0] || {}
}

module.exports = {
    executeAutoConclusionJob,
    getExecutionLogs,
    getExecutionDetails,
    getExecutionStatistics,
    CONCLUSION_DIMENSIONS
}
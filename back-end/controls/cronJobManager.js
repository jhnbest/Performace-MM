const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const cron = require('cron')
const mutualRate = require('./mutualRate')
const autoConclusionJob = require('./autoConclusionJob')
const globalFlagJob = require('./globalFlagJob')
const resetAssignProjectJob = require('./resetAssignProjectJob')
const cleanProgressJob = require('./cleanProgressJob')
const moment = require('moment')

// 定时任务配置类型
const CRON_JOB_TYPES = {
    MUTUAL_RATE_FILL: 'mutualRateFillCron',
    AUTO_CONCLUSION: 'autoConclusionCron',
    AM_EVA_DEADLINE: 'amevaDeadlineCron',
    MUTUAL_EVA_SUBMIT: 'mutualEvaSubmitCron',
    WORK_TIME_SUBMIT: 'workTimeSubmitCron',
    RESET_ASSIGN_PROJECT: 'resetAssignProjectCron',
    CLEAN_PROGRESS: 'cleanProgressCron'
}

// 默认定时任务配置
const DEFAULT_CRON_CONFIG = {
    [CRON_JOB_TYPES.MUTUAL_RATE_FILL]: '0 0 2 3 * *',      // 每月3日02:00执行
    [CRON_JOB_TYPES.AUTO_CONCLUSION]: '0 0 3 5 * *',       // 每月5日03:00执行
    [CRON_JOB_TYPES.AM_EVA_DEADLINE]: '0 0 0 1 * *',       // 每月1日00:00执行
    [CRON_JOB_TYPES.MUTUAL_EVA_SUBMIT]: '0 0 0 1 * *',     // 每月1日00:00执行
    [CRON_JOB_TYPES.WORK_TIME_SUBMIT]: '0 0 0 1 * *',      // 每月1日00:00执行
    [CRON_JOB_TYPES.RESET_ASSIGN_PROJECT]: '0 0 0 1 * *',  // 每月1日00:00执行
    [CRON_JOB_TYPES.CLEAN_PROGRESS]: '0 0 1 1 * *'         // 每月1日01:00执行
}

// 当前运行的定时任务
let runningJobs = {}

// 定时任务执行记录
let jobExecutionRecords = {}

/**
 * 数据库操作封装
 * @param {string} sql - SQL语句
 * @param {Array} arrayParams - SQL参数
 * @returns {Promise} - 数据库操作结果
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
 * 获取所有员工列表
 * @returns {Promise<Array>} - 员工列表
 */
async function getAllUsers() {
    let sql = $sql.user.selectUsersList1
    let result = await RCPDDatabase(sql, [])
    return result
}

/**
 * 获取定时任务配置
 * @param {string} jobType - 定时任务类型
 * @returns {Promise<Object>} - 定时任务配置对象
 */
async function getCronJobConfig(jobType) {
    let sql = $sql.common.getCronJobConfig
    let result = await RCPDDatabase(sql, [jobType])
    
    if (result.length > 0) {
        return {
            cronExpr: result[0].cron_expr,
            jobName: result[0].job_name || '',
            jobDescription: result[0].job_description || '',
            isEnabled: result[0].is_enabled
        }
    } else {
        // 如果没有配置，插入默认配置
        let defaultConfig = DEFAULT_CRON_CONFIG[jobType]
        let defaultDescription = ''
        let defaultJobName = ''
        if (jobType === CRON_JOB_TYPES.MUTUAL_RATE_FILL) {
            defaultDescription = '互评填充任务 - 每月自动填充互评数据'
            defaultJobName = '互评填充任务'
        } else if (jobType === CRON_JOB_TYPES.AUTO_CONCLUSION) {
            defaultDescription = '月总结自动提交任务 - 每月自动为未提交月总结的员工生成空白总结'
            defaultJobName = '月总结自动提交任务'
        } else if (jobType === CRON_JOB_TYPES.AM_EVA_DEADLINE) {
            defaultDescription = 'AMEva截止任务 - 每月自动设置AMEva截止标志'
            defaultJobName = 'AMEva截止任务'
        } else if (jobType === CRON_JOB_TYPES.MUTUAL_EVA_SUBMIT) {
            defaultDescription = '互评提交任务 - 每月自动设置互评提交标志'
            defaultJobName = '互评提交任务'
        } else if (jobType === CRON_JOB_TYPES.WORK_TIME_SUBMIT) {
            defaultDescription = '工时提交任务 - 每月自动设置工时提交标志'
            defaultJobName = '工时提交任务'
        } else if (jobType === CRON_JOB_TYPES.RESET_ASSIGN_PROJECT) {
            defaultDescription = '重置分配项目任务 - 每月自动重置分配项目的是否填充状态'
            defaultJobName = '重置分配项目任务'
        } else if (jobType === CRON_JOB_TYPES.CLEAN_PROGRESS) {
            defaultDescription = '清理进展任务 - 每月自动清理未申报工时的项目阶段进展'
            defaultJobName = '清理进展任务'
        }
        await insertDefaultCronConfig(jobType, defaultJobName, defaultConfig, defaultDescription)
        return {
            cronExpr: defaultConfig,
            jobDescription: defaultDescription
        }
    }
}

/**
 * 插入默认定时任务配置
 * @param {string} jobType - 定时任务类型
 * @param {string} jobName - 任务名称
 * @param {string} cronExpr - cron表达式
 * @param {string} jobDescription - 任务描述
 */
async function insertDefaultCronConfig(jobType, jobName, cronExpr, jobDescription = '') {
    let sql = $sql.common.insertCronJobConfig
    let now = new Date()
    await RCPDDatabase(sql, [jobType, jobName, cronExpr, jobDescription, now, now])
}

/**
 * 更新定时任务配置
 * @param {string} jobType - 定时任务类型
 * @param {string} cronExpr - cron表达式
 * @param {string} jobDescription - 任务描述
 */
async function updateCronJobConfig(jobType, cronExpr, jobDescription = '') {
    let sql = $sql.common.updateCronJobConfig
    let now = new Date()
    await RCPDDatabase(sql, [cronExpr, jobDescription, now, jobType])
    // 重启定时任务
    await restartCronJob(jobType)
}

/**
 * 设置定时任务下次执行时间
 * @param {string} jobType - 定时任务类型
 * @param {number} day - 日期（1-31）
 * @param {number} hour - 小时（0-23）
 * @param {number} minute - 分钟（0-59）
 */
async function setNextExecution(jobType, day, hour = 0, minute = 0) {
    let cronExpr = `0 ${minute} ${hour} ${day} * *`
    let sql = $sql.common.updateCronJobConfig
    let now = new Date()
    await RCPDDatabase(sql, [cronExpr, '', now, jobType])
    // 重启定时任务
    await restartCronJob(jobType)
    return { success: true, cronExpr: cronExpr }
}

/**
 * 执行互评填充定时任务
 */
async function executeMutualRateFillJob() {
    let startTime = new Date()
    let executionStatus = 'success'
    let errorMessage = null
    let executionResult = null
    
    try {
        jobExecutionRecords[CRON_JOB_TYPES.MUTUAL_RATE_FILL] = {
            lastExecutionTime: startTime,
            lastExecutionStatus: 'running'
        }
        
        // 获取当前月份的上一个月
        let currentMonth = moment().subtract(1, 'months').format('YYYY-MM')
        // 获取所有员工列表
        let users = await getAllUsers()
        
        // console.log('互评填充定时任务开始执行:', {
        //     rateMonth: currentMonth,
        //     totalUsers: users.length,
        //     startTime: startTime.toISOString()
        // })
        
        // 创建模拟请求对象
        let mockReq = {
            body: {
                users: users,
                rateMonth: currentMonth
            }
        }
        
        // 调用handleFillMul函数并等待完成
        let result = await mutualRate.handleFillMul(mockReq, {})
        
        let endTime = new Date()
        let executionDuration = endTime - startTime
        
        // 解析填充详情
        let fillDetails = result.data && result.data.fillDetails ? result.data.fillDetails : null

        // console.log('互评填充定时任务执行结果:', {
        //     code: result.code,
        //     message: result.message,
        //     usersToFill: fillDetails ? fillDetails.usersToFill : [],
        //     totalUsersToFill: fillDetails ? fillDetails.usersToFill.length : 0,
        //     totalFilled: fillDetails ? fillDetails.totalFilled : 0,
        //     executionDuration: executionDuration + 'ms'
        // })
        
        // 生成结构化的执行结果
        if (fillDetails) {
            executionResult = {
                rateMonth: currentMonth,
                usersToFill: fillDetails.usersToFill,
                totalUsersToFill: fillDetails.usersToFill.length,
                totalRecordsFilled: fillDetails.totalFilled,
                fillRecords: fillDetails.fillRecords,
                executionDuration: executionDuration + 'ms',
                executionTime: endTime.toISOString()
            }
        } else {
            executionResult = {
                rateMonth: currentMonth,
                message: '执行完成但无填充数据',
                executionDuration: executionDuration + 'ms',
                executionTime: endTime.toISOString()
            }
        }
        
    } catch (error) {
        executionStatus = 'failed'
        errorMessage = error.message
        let errorTime = new Date()
        let executionDuration = errorTime - startTime
        
        console.error('互评填充定时任务执行失败:', {
            error: error.message,
            stack: error.stack,
            executionDuration: executionDuration + 'ms'
        })
        
        executionResult = {
            error: error.message,
            rateMonth: moment().subtract(1, 'months').format('YYYY-MM'),
            executionDuration: executionDuration + 'ms'
        }
    } finally {
        // 记录日志
        await logJobExecution(CRON_JOB_TYPES.MUTUAL_RATE_FILL, {
            status: executionStatus,
            executionDuration: new Date() - startTime,
            summary: JSON.stringify(executionResult),
            errorMessage: errorMessage
        })
        
        // 更新执行记录
        jobExecutionRecords[CRON_JOB_TYPES.MUTUAL_RATE_FILL] = {
            lastExecutionTime: startTime,
            lastExecutionStatus: executionStatus,
            errorMessage: errorMessage
        }
    }
}

    /**
     * 执行月总结自动提交定时任务
     */
    async function executeAutoConclusionJob() {
        try {
            let startTime = new Date()
            jobExecutionRecords[CRON_JOB_TYPES.AUTO_CONCLUSION] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: 'running'
            }
            
            // console.log('月总结自动提交定时任务开始执行:', {
            //     startTime: startTime.toISOString()
            // })
            
            // 调用autoConclusionJob的执行函数
            let result = await autoConclusionJob.executeAutoConclusionJob()
            
            let endTime = new Date()
            
            // 更新执行记录
            jobExecutionRecords[CRON_JOB_TYPES.AUTO_CONCLUSION] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result.summary
            }
            
            // console.log('月总结自动提交定时任务执行结果:', result)
            
            // 记录日志到通用日志表
            await logJobExecution(CRON_JOB_TYPES.AUTO_CONCLUSION, {
                status: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result.summary,
                errorMessage: result.error || null
            })
            
        } catch (error) {
            let errorTime = new Date()
            console.error('月总结自动提交定时任务执行失败:', {
                error: error.message,
                stack: error.stack,
                errorTime: errorTime.toISOString()
            })
            
            // 更新执行记录为失败
            jobExecutionRecords[CRON_JOB_TYPES.AUTO_CONCLUSION] = {
                lastExecutionTime: new Date(),
                lastExecutionStatus: 'failed',
                errorMessage: error.message
            }
            
            // 记录日志到通用日志表
            await logJobExecution(CRON_JOB_TYPES.AUTO_CONCLUSION, {
                status: 'failed',
                executionDuration: new Date() - startTime,
                summary: null,
                errorMessage: error.message
            })
        }
    }

    /**
     * 执行AMEva截止定时任务
     * 在globalflag表中插入/更新flagType='AMEvaDeadline', flagValue='1'
     */
    async function executeAMEvaDeadlineJob() {
        try {
            let startTime = new Date()
            jobExecutionRecords[CRON_JOB_TYPES.AM_EVA_DEADLINE] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: 'running'
            }
            
            // console.log('AMEva截止定时任务开始执行:', {
            //     startTime: startTime.toISOString()
            // })
            
            let result = await globalFlagJob.executeAMEvaDeadlineJob()
            
            let endTime = new Date()
            
            jobExecutionRecords[CRON_JOB_TYPES.AM_EVA_DEADLINE] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            }
            
            // console.log('AMEva截止定时任务执行结果:', result)
            
            // 记录日志
            logJobExecution(CRON_JOB_TYPES.AM_EVA_DEADLINE, {
                status: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            })
            
        } catch (error) {
            let errorTime = new Date()
            console.error('AMEva截止定时任务执行失败:', {
                error: error.message,
                stack: error.stack,
                errorTime: errorTime.toISOString()
            })
            
            jobExecutionRecords[CRON_JOB_TYPES.AM_EVA_DEADLINE] = {
                lastExecutionTime: new Date(),
                lastExecutionStatus: 'failed',
                errorMessage: error.message
            }
            
            // 记录失败日志
            logJobExecution(CRON_JOB_TYPES.AM_EVA_DEADLINE, {
                status: 'failed',
                errorMessage: error.message
            })
        }
    }

    /**
     * 执行互评提交定时任务
     * 在globalflag表中插入/更新flagType='multualEvaSubmit', flagValue='1'
     */
    async function executeMutualEvaSubmitJob() {
        try {
            let startTime = new Date()
            jobExecutionRecords[CRON_JOB_TYPES.MUTUAL_EVA_SUBMIT] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: 'running'
            }
            
            // console.log('互评提交定时任务开始执行:', {
            //     startTime: startTime.toISOString()
            // })
            
            let result = await globalFlagJob.executeMutualEvaSubmitJob()
            
            let endTime = new Date()
            
            jobExecutionRecords[CRON_JOB_TYPES.MUTUAL_EVA_SUBMIT] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            }
            
            // console.log('互评提交定时任务执行结果:', result)
            
            // 记录日志
            logJobExecution(CRON_JOB_TYPES.MUTUAL_EVA_SUBMIT, {
                status: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            })
            
        } catch (error) {
            let errorTime = new Date()
            console.error('互评提交定时任务执行失败:', {
                error: error.message,
                stack: error.stack,
                errorTime: errorTime.toISOString()
            })
            
            jobExecutionRecords[CRON_JOB_TYPES.MUTUAL_EVA_SUBMIT] = {
                lastExecutionTime: new Date(),
                lastExecutionStatus: 'failed',
                errorMessage: error.message
            }
            
            // 记录失败日志
            logJobExecution(CRON_JOB_TYPES.MUTUAL_EVA_SUBMIT, {
                status: 'failed',
                errorMessage: error.message
            })
        }
    }

    /**
     * 执行工时提交定时任务
     * 在globalflag表中插入/更新flagType='workTimeSubmit', flagValue='1'
     */
    async function executeWorkTimeSubmitJob() {
        try {
            let startTime = new Date()
            jobExecutionRecords[CRON_JOB_TYPES.WORK_TIME_SUBMIT] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: 'running'
            }
            
            // console.log('工时提交定时任务开始执行:', {
            //     startTime: startTime.toISOString()
            // })
            
            let result = await globalFlagJob.executeWorkTimeSubmitJob()
            
            let endTime = new Date()
            
            jobExecutionRecords[CRON_JOB_TYPES.WORK_TIME_SUBMIT] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            }
            
            // console.log('工时提交定时任务执行结果:', result)
            
            // 记录日志
            logJobExecution(CRON_JOB_TYPES.WORK_TIME_SUBMIT, {
                status: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            })
            
        } catch (error) {
            let errorTime = new Date()
            console.error('工时提交定时任务执行失败:', {
                error: error.message,
                stack: error.stack,
                errorTime: errorTime.toISOString()
            })
            
            jobExecutionRecords[CRON_JOB_TYPES.WORK_TIME_SUBMIT] = {
                lastExecutionTime: new Date(),
                lastExecutionStatus: 'failed',
                errorMessage: error.message
            }
            
            // 记录失败日志
            logJobExecution(CRON_JOB_TYPES.WORK_TIME_SUBMIT, {
                status: 'failed',
                errorMessage: error.message
            })
        }
    }

    /**
     * 执行重置分配项目定时任务
     * 将assignprojectlist表中的isFilled字段更新为0
     */
    async function executeResetAssignProjectJob() {
        try {
            let startTime = new Date()
            jobExecutionRecords[CRON_JOB_TYPES.RESET_ASSIGN_PROJECT] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: 'running'
            }
            
            // console.log('重置分配项目定时任务开始执行:', {
            //     startTime: startTime.toISOString()
            // })
            
            let result = await resetAssignProjectJob.executeResetAssignProjectJob()
            
            let endTime = new Date()
            
            jobExecutionRecords[CRON_JOB_TYPES.RESET_ASSIGN_PROJECT] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            }
            
            // console.log('重置分配项目定时任务执行结果:', result)
            
            // 记录日志
            logJobExecution(CRON_JOB_TYPES.RESET_ASSIGN_PROJECT, {
                status: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            })
            
        } catch (error) {
            let errorTime = new Date()
            console.error('重置分配项目定时任务执行失败:', {
                error: error.message,
                stack: error.stack,
                errorTime: errorTime.toISOString()
            })
            
            jobExecutionRecords[CRON_JOB_TYPES.RESET_ASSIGN_PROJECT] = {
                lastExecutionTime: new Date(),
                lastExecutionStatus: 'failed',
                errorMessage: error.message
            }
            
            // 记录失败日志
            logJobExecution(CRON_JOB_TYPES.RESET_ASSIGN_PROJECT, {
                status: 'failed',
                errorMessage: error.message
            })
        }
    }

    /**
     * 手动执行AMEva截止任务（供API调用）
     */
    async function executeAMEvaDeadlineJobManual() {
        return await executeAMEvaDeadlineJob()
    }

    /**
     * 手动执行互评提交任务（供API调用）
     */
    async function executeMutualEvaSubmitJobManual() {
        return await executeMutualEvaSubmitJob()
    }

    /**
     * 手动执行工时提交任务（供API调用）
     */
    async function executeWorkTimeSubmitJobManual() {
        return await executeWorkTimeSubmitJob()
    }

    /**
     * 手动执行重置分配项目任务（供API调用）
     */
    async function executeResetAssignProjectJobManual() {
        return await executeResetAssignProjectJob()
    }

    /**
     * 执行清理进展定时任务
     * 清理未申报工时的项目阶段进展
     */
    async function executeCleanProgressJob() {
        try {
            let startTime = new Date()
            jobExecutionRecords[CRON_JOB_TYPES.CLEAN_PROGRESS] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: 'running'
            }
            
            // console.log('清理进展定时任务开始执行:', {
            //     startTime: startTime.toISOString()
            // })
            
            let result = await cleanProgressJob.executeCleanProgressJob()
            
            let endTime = new Date()
            
            jobExecutionRecords[CRON_JOB_TYPES.CLEAN_PROGRESS] = {
                lastExecutionTime: startTime,
                lastExecutionStatus: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            }
            
            // console.log('清理进展定时任务执行结果:', result)
            
            // 记录日志
            logJobExecution(CRON_JOB_TYPES.CLEAN_PROGRESS, {
                status: result.success ? 'success' : 'failed',
                executionDuration: endTime - startTime,
                summary: result
            })
            
            return result
            
        } catch (error) {
            let errorTime = new Date()
            console.error('清理进展定时任务执行失败:', {
                error: error.message,
                stack: error.stack,
                errorTime: errorTime.toISOString()
            })
            
            jobExecutionRecords[CRON_JOB_TYPES.CLEAN_PROGRESS] = {
                lastExecutionTime: new Date(),
                lastExecutionStatus: 'failed',
                errorMessage: error.message
            }
            
            // 记录失败日志
            logJobExecution(CRON_JOB_TYPES.CLEAN_PROGRESS, {
                status: 'failed',
                errorMessage: error.message
            })
            
            return { success: false, error: error.message }
        }
    }

    /**
     * 手动执行清理进展任务（供API调用）
     */
    async function executeCleanProgressJobManual() {
        return await executeCleanProgressJob()
    }

/**
 * 启动定时任务
 * @param {string} jobType - 定时任务类型
 */
async function startCronJob(jobType) {
    // 先停止已有的定时任务
    if (runningJobs[jobType]) {
        runningJobs[jobType].stop()
        delete runningJobs[jobType]
    }
    
    // 获取定时任务配置
    let cronConfig = await getCronJobConfig(jobType)
    let cronExpr = cronConfig.cronExpr
    
    // 创建并启动定时任务
    let job = null

    // console.log(`尝试启动定时任务 - ${jobType}: "${cronExpr}"`)

    // 转换为6字段格式（秒 分 时 日 月 周），移除年份字段
    let parts = cronExpr.split(' ')
    // console.log(`原始cron表达式字段数: ${parts.length}`)

    if (parts.length > 6) {
        // 只保留前6个字段
        cronExpr = parts.slice(0, 6).join(' ')
        // console.log(`转换为6字段cron表达式: "${cronExpr}"`)
    } else if (parts.length < 6) {
        // 如果字段不足，补充默认值*
        // console.warn(`cron表达式字段不足: "${cronExpr}", 当前字段数: ${parts.length}`)
        while (parts.length < 6) {
            parts.push('*')
        }
        cronExpr = parts.join(' ')
        // console.log(`补全后的cron表达式: "${cronExpr}"`)
    }

    // 备选方案：将?替换为*，解决cron v3.x兼容性问题
    const altExpr = cronExpr.replace(/\?/g, '*')
    if (altExpr !== cronExpr) {
        // console.log(`转换为兼容格式: "${altExpr}"`)
        cronExpr = altExpr
    }

    switch (jobType) {
        case CRON_JOB_TYPES.MUTUAL_RATE_FILL:
            try {
                // console.log(`准备创建CronJob，表达式: "${cronExpr}"`)
                job = new cron.CronJob(cronExpr, executeMutualRateFillJob, null, true, 'Asia/Shanghai')
                // console.log(`定时任务创建成功 - ${jobType}`)
            } catch (error) {
                // console.error(`定时任务创建失败 - ${jobType}:`, error)
                throw error
            }
            break
        case CRON_JOB_TYPES.AUTO_CONCLUSION:
            try {
                // console.log(`准备创建月总结自动提交任务，表达式: "${cronExpr}"`)
                job = new cron.CronJob(cronExpr, executeAutoConclusionJob, null, true, 'Asia/Shanghai')
                // console.log(`定时任务创建成功 - ${jobType}`)
            } catch (error) {
                // console.error(`定时任务创建失败 - ${jobType}:`, error)
                throw error
            }
            break
        case CRON_JOB_TYPES.AM_EVA_DEADLINE:
            try {
                // console.log(`准备创建AMEva截止任务，表达式: "${cronExpr}"`)
                job = new cron.CronJob(cronExpr, executeAMEvaDeadlineJob, null, true, 'Asia/Shanghai')
                // console.log(`定时任务创建成功 - ${jobType}`)
            } catch (error) {
                // console.error(`定时任务创建失败 - ${jobType}:`, error)
                throw error
            }
            break
        case CRON_JOB_TYPES.MUTUAL_EVA_SUBMIT:
            try {
                // console.log(`准备创建互评提交任务，表达式: "${cronExpr}"`)
                job = new cron.CronJob(cronExpr, executeMutualEvaSubmitJob, null, true, 'Asia/Shanghai')
                // console.log(`定时任务创建成功 - ${jobType}`)
            } catch (error) {
                // console.error(`定时任务创建失败 - ${jobType}:`, error)
                throw error
            }
            break
        case CRON_JOB_TYPES.WORK_TIME_SUBMIT:
            try {
                // console.log(`准备创建工时提交任务，表达式: "${cronExpr}"`)
                job = new cron.CronJob(cronExpr, executeWorkTimeSubmitJob, null, true, 'Asia/Shanghai')
                // console.log(`定时任务创建成功 - ${jobType}`)
            } catch (error) {
                // console.error(`定时任务创建失败 - ${jobType}:`, error)
                throw error
            }
            break
        case CRON_JOB_TYPES.RESET_ASSIGN_PROJECT:
            try {
                // console.log(`准备创建重置分配项目任务，表达式: "${cronExpr}"`)
                job = new cron.CronJob(cronExpr, executeResetAssignProjectJob, null, true, 'Asia/Shanghai')
                // console.log(`定时任务创建成功 - ${jobType}`)
            } catch (error) {
                // console.error(`定时任务创建失败 - ${jobType}:`, error)
                throw error
            }
            break
        case CRON_JOB_TYPES.CLEAN_PROGRESS:
            try {
                // console.log(`准备创建清理进展任务，表达式: "${cronExpr}"`)
                job = new cron.CronJob(cronExpr, executeCleanProgressJob, null, true, 'Asia/Shanghai')
                // console.log(`定时任务创建成功 - ${jobType}`)
            } catch (error) {
                // console.error(`定时任务创建失败 - ${jobType}:`, error)
                throw error
            }
            break
        default:
            // console.error('未知的定时任务类型:', jobType)
            return
    }

    runningJobs[jobType] = job
    // console.log(`定时任务已启动 - ${jobType}: ${cronExpr}`)
}

/**
 * 重启定时任务
 * @param {string} jobType - 定时任务类型
 */
async function restartCronJob(jobType) {
    await startCronJob(jobType)
}

/**
 * 停止定时任务
 * @param {string} jobType - 定时任务类型
 */
async function stopCronJob(jobType) {
    if (runningJobs[jobType]) {
        runningJobs[jobType].stop()
        delete runningJobs[jobType]
    }
    let sql = $sql.common.updateCronJobEnabled
    await RCPDDatabase(sql, [0, new Date(), jobType])
}

/**
 * 启动指定定时任务
 * @param {string} jobType - 定时任务类型
 */
async function startCronJobByType(jobType) {
    let sql = $sql.common.updateCronJobEnabled
    await RCPDDatabase(sql, [1, new Date(), jobType])
    await startCronJob(jobType)
}

/**
 * 启动所有定时任务
 */
async function startAllCronJobs() {
    for (let jobType in CRON_JOB_TYPES) {
        let jobKey = CRON_JOB_TYPES[jobType]
        let config = await getCronJobConfig(jobKey)
        if (config && config.isEnabled !== 0) {
            await startCronJob(jobKey)
        }
    }
}

/**
 * 获取当前运行的定时任务状态
 * @returns {Object} - 定时任务状态
 */
function getCronJobStatus() {
    let status = {}
    for (let jobType in CRON_JOB_TYPES) {
        let jobKey = CRON_JOB_TYPES[jobType]
        let executionRecord = jobExecutionRecords[jobKey] || {}
        
        if (runningJobs[jobKey]) {
            status[jobKey] = {
                running: runningJobs[jobKey].running,
                nextDate: runningJobs[jobKey].nextDate(),
                lastExecutionTime: executionRecord.lastExecutionTime,
                lastExecutionStatus: executionRecord.lastExecutionStatus,
                executionSummary: executionRecord.summary
            }
        } else {
            status[jobKey] = {
                running: false,
                nextDate: null,
                lastExecutionTime: executionRecord.lastExecutionTime,
                lastExecutionStatus: executionRecord.lastExecutionStatus,
                executionSummary: executionRecord.summary
            }
        }
    }
    return status
}

/**
 * 获取执行日志列表
 * @param {Object} params 查询参数
 * @returns {Promise<Array>} 日志列表
 */
async function getAutoConclusionLogs(params = {}) {
    return await autoConclusionJob.getExecutionLogs(params)
}

/**
 * 获取执行日志详情
 * @param {number} logId 日志ID
 * @returns {Promise<Array>} 详情列表
 */
async function getAutoConclusionDetails(logId) {
    return await autoConclusionJob.getExecutionDetails(logId)
}

/**
 * 获取执行统计数据
 * @param {number} year 年份
 * @param {number} month 月份
 * @returns {Promise<Object>} 统计数据
 */
async function getAutoConclusionStatistics(year, month) {
    return await autoConclusionJob.getExecutionStatistics(year, month)
}

/**
 * 手动执行月总结自动提交任务
 */
async function executeAutoConclusionJobManual() {
    let startTime = new Date()
    let result = null
    
    // 更新执行记录为执行中
    jobExecutionRecords[CRON_JOB_TYPES.AUTO_CONCLUSION] = {
        lastExecutionTime: startTime,
        lastExecutionStatus: 'running'
    }
    
    try {
        result = await autoConclusionJob.executeAutoConclusionJob()
        
        // 更新执行记录
        jobExecutionRecords[CRON_JOB_TYPES.AUTO_CONCLUSION] = {
            lastExecutionTime: startTime,
            lastExecutionStatus: result.success ? 'success' : 'failed',
            executionDuration: new Date() - startTime,
            summary: result.summary
        }
        
        // 记录日志到通用日志表
        await logJobExecution(CRON_JOB_TYPES.AUTO_CONCLUSION, {
            status: result.success ? 'success' : 'failed',
            executionDuration: new Date() - startTime,
            summary: result.summary,
            errorMessage: result.error || null
        })
        
        return result
    } catch (error) {
        console.error('手动执行月总结自动提交任务失败:', error)
        
        // 更新执行记录为失败
        jobExecutionRecords[CRON_JOB_TYPES.AUTO_CONCLUSION] = {
            lastExecutionTime: new Date(),
            lastExecutionStatus: 'failed',
            errorMessage: error.message
        }
        
        // 记录失败日志
        await logJobExecution(CRON_JOB_TYPES.AUTO_CONCLUSION, {
            status: 'failed',
            executionDuration: new Date() - startTime,
            summary: null,
            errorMessage: error.message
        })
        
        return {
            success: false,
            error: error.message
        }
    }
}

/**
 * 获取任务名称
 * @param {string} jobType - 任务类型
 * @returns {string} - 任务名称
 */
function getJobName(jobType) {
    const jobNames = {
        [CRON_JOB_TYPES.MUTUAL_RATE_FILL]: '互评填充任务',
        [CRON_JOB_TYPES.AUTO_CONCLUSION]: '月总结自动提交任务',
        [CRON_JOB_TYPES.AM_EVA_DEADLINE]: 'AMEva截止任务',
        [CRON_JOB_TYPES.MUTUAL_EVA_SUBMIT]: '互评提交任务',
        [CRON_JOB_TYPES.WORK_TIME_SUBMIT]: '工时提交任务',
        [CRON_JOB_TYPES.RESET_ASSIGN_PROJECT]: '重置分配项目任务'
    }
    return jobNames[jobType] || '未知任务'
}

/**
 * 记录任务执行日志
 * @param {string} jobType - 任务类型
 * @param {Object} result - 执行结果
 */
async function logJobExecution(jobType, result) {
    try {
        let sql = $sql.cronJobExecutionLog.insert
        
        let executionTime = new Date()
        let executionDuration = result.executionDuration || 0
        let executionResult = result.summary ? JSON.stringify(result.summary) : null
        let errorMessage = result.errorMessage || null
        let jobName = getJobName(jobType)
        
        let arrayParams = [
            jobType,
            jobName,
            executionTime,
            result.status === 'running' ? 0 : (result.status === 'success' ? 1 : 2),
            executionDuration,
            executionResult,
            errorMessage
        ]
        
        await RCPDDatabase(sql, arrayParams)
        // console.log(`任务执行日志已记录 - ${jobType}`)

    } catch (error) {
        // console.error('记录任务执行日志失败:', error)
    }
}

/**
 * 获取任务执行日志列表
 * @param {Object} params 查询参数
 * @returns {Promise<Array>} 日志列表
 */
async function getJobExecutionLogs(params = {}) {
    try {
        let sql = `SELECT * FROM cron_job_execution_log WHERE 1=1`
        let arrayParams = []
        
        if (params.jobType) {
            sql += ` AND job_type = ?`
            arrayParams.push(params.jobType)
        }
        
        if (params.startTime) {
            sql += ` AND execution_time >= ?`
            arrayParams.push(params.startTime)
        }
        
        if (params.endTime) {
            sql += ` AND execution_time <= ?`
            arrayParams.push(params.endTime)
        }
        
        sql += ` ORDER BY execution_time DESC LIMIT ?`
        arrayParams.push(params.limit || 50)
        
        let result = await RCPDDatabase(sql, arrayParams)
        return result
        
    } catch (error) {
        console.error('获取任务执行日志失败:', error)
        return []
    }
}

/**
 * 获取任务执行日志详情
 * @param {number} logId 日志ID
 * @returns {Promise<Object>} 日志详情
 */
async function getJobExecutionDetail(logId) {
    try {
        let sql = $sql.cronJobExecutionLog.selectById
        let result = await RCPDDatabase(sql, [logId])
        return result.length > 0 ? result[0] : null
        
    } catch (error) {
        console.error('获取任务执行日志详情失败:', error)
        return null
    }
}

/**
 * 获取任务执行统计
 * @param {number} year 年份
 * @param {number} month 月份
 * @returns {Promise<Object>} 统计数据
 */
async function getJobExecutionStatistics(year, month) {
    try {
        let startTime = new Date(year, month - 1, 1)
        let endTime = new Date(year, month, 0)
        
        let sql = $sql.cronJobExecutionLog.selectStatistics
        
        let result = await RCPDDatabase(sql, [startTime, endTime])
        return result
        
    } catch (error) {
        console.error('获取任务执行统计失败:', error)
        return []
    }
}

module.exports = {
    CRON_JOB_TYPES,
    getCronJobConfig,
    updateCronJobConfig,
    startCronJob,
    stopCronJob,
    restartCronJob,
    startAllCronJobs,
    getCronJobStatus,
    executeMutualRateFillJob,
    // 月总结自动提交任务相关
    executeAutoConclusionJobManual,
    getAutoConclusionLogs,
    getAutoConclusionDetails,
    getAutoConclusionStatistics,
    // 新增任务的手动执行函数
    executeAMEvaDeadlineJobManual,
    executeMutualEvaSubmitJobManual,
    executeWorkTimeSubmitJobManual,
    executeResetAssignProjectJobManual,
    executeCleanProgressJobManual,
    // 统一日志功能
    getJobExecutionLogs,
    getJobExecutionDetail,
    getJobExecutionStatistics,
    // 设置下次执行时间
    setNextExecution,
    // 启动/停止定时任务
    stopCronJob,
    startCronJobByType
}
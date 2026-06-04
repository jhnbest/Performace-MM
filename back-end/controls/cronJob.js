const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')
const cronJobManager = require('./cronJobManager')

const cronJobs = {
    // ***获取定时任务配置
    getCronJobConfig (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let jobType = req.body.jobType || cronJobManager.CRON_JOB_TYPES.MUTUAL_RATE_FILL
          let config = await cronJobManager.getCronJobConfig(jobType)
          return $http.writeJson(res, {code: 1, data: { 
            cronExpr: config.cronExpr, 
            jobType: jobType,
            jobName: config.jobName,
            jobDescription: config.jobDescription 
          }, message: 'success'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '获取定时任务配置失败'})
        }
      })
    },
    
    // ***更新定时任务配置
    updateCronJobConfig (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          let jobType = sendData.jobType || cronJobManager.CRON_JOB_TYPES.MUTUAL_RATE_FILL
          let cronExpr = sendData.cronExpr
          let jobDescription = sendData.jobDescription || ''
          
          if (!cronExpr) {
            return $http.writeJson(res, {code: -1, message: 'cron表达式不能为空'})
          }
          
          await cronJobManager.updateCronJobConfig(jobType, cronExpr, jobDescription)
          // 重启定时任务以应用新配置
          console.log(`准备重启定时任务 - ${jobType}`)
          await cronJobManager.restartCronJob(jobType)
          console.log(`定时任务已重启 - ${jobType}`)
          return $http.writeJson(res, {code: 1, data: { 
            cronExpr: cronExpr, 
            jobType: jobType,
            jobDescription: jobDescription 
          }, message: '更新定时任务配置成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '更新定时任务配置失败'})
        }
      })
    },
    
    // ***获取定时任务状态
    getCronJobStatus (req, res) {
      $http.userVerify(req, res, () => {
        try {
          let status = cronJobManager.getCronJobStatus()
          return $http.writeJson(res, {code: 1, data: status, message: '获取定时任务状态成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '获取定时任务状态失败'})
        }
      })
    },
    
    // ***手动执行互评填充任务
    executeMutualRateFill (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          await cronJobManager.executeMutualRateFillJob()
          return $http.writeJson(res, {code: 1, message: '手动执行互评填充任务成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '手动执行互评填充任务失败'})
        }
      })
    },
    
    // ***手动执行月总结自动提交任务
    executeAutoConclusion (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let result = await cronJobManager.executeAutoConclusionJobManual()
          if (result.success) {
            return $http.writeJson(res, {code: 1, data: result, message: '手动执行月总结自动提交任务成功'})
          } else {
            return $http.writeJson(res, {code: -1, err: result.error, message: '月总结自动提交任务执行失败'})
          }
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '手动执行月总结自动提交任务失败'})
        }
      })
    },
    
    // ***手动执行AMEva截止任务
    executeAMEvaDeadline (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          await cronJobManager.executeAMEvaDeadlineJobManual()
          return $http.writeJson(res, {code: 1, message: '手动执行AMEva截止任务成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '手动执行AMEva截止任务失败'})
        }
      })
    },
    
    // ***手动执行互评提交任务
    executeMutualEvaSubmit (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          await cronJobManager.executeMutualEvaSubmitJobManual()
          return $http.writeJson(res, {code: 1, message: '手动执行互评提交任务成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '手动执行互评提交任务失败'})
        }
      })
    },
    
    // ***手动执行工时提交任务
    executeWorkTimeSubmit (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          await cronJobManager.executeWorkTimeSubmitJobManual()
          return $http.writeJson(res, {code: 1, message: '手动执行工时提交任务成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '手动执行工时提交任务失败'})
        }
      })
    },
    
    // ***手动执行重置分配项目任务
    executeResetAssignProject (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          await cronJobManager.executeResetAssignProjectJobManual()
          return $http.writeJson(res, {code: 1, message: '手动执行重置分配项目任务成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '手动执行重置分配项目任务失败'})
        }
      })
    },
    
    // ***手动执行清理进展任务
    executeCleanProgress (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let result = await cronJobManager.executeCleanProgressJobManual()
          if (result.success) {
            return $http.writeJson(res, {code: 1, data: result, message: '手动执行清理进展任务成功'})
          } else {
            return $http.writeJson(res, {code: -1, err: result.error, message: '清理进展任务执行失败'})
          }
        } catch (error) {
          console.error('清理进展任务执行失败:', error)
          return $http.writeJson(res, {code: -2, err: error.message, message: '手动执行清理进展任务失败'})
        }
      })
    },
    
    // ***获取执行日志列表
    getAutoConclusionLogs (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          let params = {
            limit: sendData.limit || 20
          }
          let logs = await cronJobManager.getAutoConclusionLogs(params)
          return $http.writeJson(res, {code: 1, data: logs, message: '获取执行日志成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '获取执行日志失败'})
        }
      })
    },
    
    // ***获取执行日志详情
    getAutoConclusionDetails (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          if (!sendData.logId) {
            return $http.writeJson(res, {code: -1, message: '日志ID不能为空'})
          }
          let details = await cronJobManager.getAutoConclusionDetails(sendData.logId)
          return $http.writeJson(res, {code: 1, data: details, message: '获取执行详情成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '获取执行详情失败'})
        }
      })
    },
    
    // ***获取执行统计数据
    getAutoConclusionStatistics (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          let year = sendData.year || new Date().getFullYear()
          let month = sendData.month || new Date().getMonth() + 1
          let statistics = await cronJobManager.getAutoConclusionStatistics(year, month)
          return $http.writeJson(res, {code: 1, data: statistics, message: '获取统计数据成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '获取统计数据失败'})
        }
      })
    },
    
    // ***获取所有任务的执行日志列表
    getAllJobExecutionLogs (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          let params = {
            jobType: sendData.jobType || null,
            startTime: sendData.startTime || null,
            endTime: sendData.endTime || null,
            limit: sendData.limit || 50
          }
          let logs = await cronJobManager.getJobExecutionLogs(params)
          return $http.writeJson(res, {code: 1, data: logs, message: '获取任务执行日志成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '获取任务执行日志失败'})
        }
      })
    },
    
    // ***获取任务执行日志详情
    getJobExecutionDetail (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          if (!sendData.logId) {
            return $http.writeJson(res, {code: -1, message: '日志ID不能为空'})
          }
          let detail = await cronJobManager.getJobExecutionDetail(sendData.logId)
          return $http.writeJson(res, {code: 1, data: detail, message: '获取任务执行详情成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '获取任务执行详情失败'})
        }
      })
    },
    
    // ***获取任务执行统计
    getJobExecutionStatistics (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          let year = sendData.year || new Date().getFullYear()
          let month = sendData.month || new Date().getMonth() + 1
          let statistics = await cronJobManager.getJobExecutionStatistics(year, month)
          return $http.writeJson(res, {code: 1, data: statistics, message: '获取任务执行统计成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '获取任务执行统计失败'})
        }
      })
    },
    
    // ***更新任务名称
    updateJobName (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          if (!sendData.jobType) {
            return $http.writeJson(res, {code: -1, message: '任务类型不能为空'})
          }
          if (!sendData.jobName) {
            return $http.writeJson(res, {code: -1, message: '任务名称不能为空'})
          }
          let sql = $sql.common.updateJobName
          let arrayParams = [sendData.jobName, new Date(), sendData.jobType]
          await new Promise((resolve, reject) => {
            $http.connPool(sql, arrayParams, (err, result) => {
              if (err) reject(err)
              else resolve(result)
            })
          })
          return $http.writeJson(res, {code: 1, message: '更新任务名称成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '更新任务名称失败'})
        }
      })
    },
    
    // ***设置定时任务下次执行时间
    setNextExecution (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          if (!sendData.jobType) {
            return $http.writeJson(res, {code: -1, message: '任务类型不能为空'})
          }
          if (!sendData.day || sendData.day < 1 || sendData.day > 31) {
            return $http.writeJson(res, {code: -1, message: '日期必须为1-31之间的数字'})
          }
          let day = sendData.day
          let hour = sendData.hour || 2
          let minute = sendData.minute || 0
          let result = await cronJobManager.setNextExecution(sendData.jobType, day, hour, minute)
          return $http.writeJson(res, {code: 1, data: result, message: '设置下次执行时间成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '设置下次执行时间失败'})
        }
      })
    },
    
    // ***停止定时任务
    stopCronJob (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          if (!sendData.jobType) {
            return $http.writeJson(res, {code: -1, message: '任务类型不能为空'})
          }
          await cronJobManager.stopCronJob(sendData.jobType)
          return $http.writeJson(res, {code: 1, message: '停止定时任务成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '停止定时任务失败'})
        }
      })
    },
    
    // ***启动定时任务
    startCronJob (req, res) {
      $http.userVerify(req, res, async () => {
        try {
          let sendData = req.body
          if (!sendData.jobType) {
            return $http.writeJson(res, {code: -1, message: '任务类型不能为空'})
          }
          await cronJobManager.startCronJobByType(sendData.jobType)
          return $http.writeJson(res, {code: 1, message: '启动定时任务成功'})
        } catch (error) {
          return $http.writeJson(res, {code: -2, err: error, message: '启动定时任务失败'})
        }
      })
    }
}

module.exports = cronJobs
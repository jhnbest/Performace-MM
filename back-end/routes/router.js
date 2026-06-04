// 接口地址管理
let express = require('express');
let user = require('../controls/user');
let performance = require('../controls/performance');
let workStation = require('../controls/workStation');
let mutualRates = require('../controls/mutualRate');
let conclusion = require('../controls/conclusion');
let achievementsEva = require('../controls/achievementsEva')
let common = require('../controls/common')
let performanceBonus = require('../controls/performanceBonus')
let cronJob = require('../controls/cronJob')
let api = require('../config/api');

let router = express.Router();

// 通用模块
router.post(api.getTypeGlobalFlag, common.getTypeGlobalFlag)
router.post(api.getGlobalFlagByType, common.getGlobalFlagByType)
router.post(api.updateGlobalFlagVal, common.updateGlobalFlagVal)
router.post(api.getEvaCoef, common.getEvaCoef)
router.post(api.getGlobalFlagByTime, common.getGlobalFlagByTime)
// user-用户管理
router.post(api.userLogin, user.login);
router.post(api.userLogout, user.logout);
router.post(api.userAdd, user.add);
router.post(api.userUpdateInfo, user.updateInfo);
router.post(api.userUpdateState, user.updateState);
router.post(api.usersList, user.listTest);
router.post(api.getUsersList, user.getUsersList);
router.post(api.getGroupUserName, user.getGroupUserName);
router.post(api.oldPasswordAuth, user.oldPasswordAuth);
router.post(api.updateNewPassword, user.updateNewPassword);

// Performance-工时管理
router.post(api.performanceAdd, performance.add);
router.post(api.getWorkTime, performance.getWorkTime)
router.post(api.getProjectType, performance.getProjectType)
router.post(api.getWorkTimeNew, performance.getWorkTimeNew)
router.post(api.workTimeSubmit, performance.workTimeSubmit)
router.post(api.workTimeTemporary, performance.workTimeTemporary)
router.post(api.getProjectList, performance.getProjectList)
router.post(api.getWorkAssign, performance.getWorkAssign)
router.post(api.getProjectInfo, performance.getProjectInfo)
router.post(api.changeSubmitStatus, performance.changeSubmitStatus)
router.post(api.deleteWorkTimeSubmit, performance.deleteWorkTimeSubmit)
router.post(api.updateWorkTimeAssignReview, performance.updateWorkTimeAssignReview)
router.post(api.getSubmitWorkTimeCount, performance.getSubmitWorkTimeCount)
router.post(api.submitReviewPass, performance.submitReviewPass)
router.post(api.getGroupWorkTimeList, performance.getGroupWorkTimeList)
router.post(api.getAllWorkTimeList, performance.getAllWorkTimeList)
router.post(api.getIsWorkTimeReviewFinish, performance.getIsWorkTimeReviewFinish)
router.post(api.getCurApplyAbleMonth, performance.getCurApplyAbleMonth)
router.post(api.submitProjectWorkTimeApply, performance.submitProjectWorkTimeApply)
router.post(api.updateWorkTimeListReviewStatus, performance.updateWorkTimeListReviewStatus)
router.post(api.getWorkTimeAssignInfo, performance.getWorkTimeAssignInfo)
router.post(api.getWorkTimeListInfo, performance.getWorkTimeListInfo)
router.post(api.savePMData, performance.savePMData)
router.post(api.savePMDataV2, performance.savePMDataV2)
router.post(api.savePMDataV3, performance.savePMDataV3)
router.post(api.updatePMData, performance.updatePMData)
router.post(api.updatePMDataV2, performance.updatePMDataV2)
router.post(api.updatePMDataV3, performance.updatePMDataV3)
router.post(api.getPMData, performance.getPMData)
router.post(api.test, performance.test)
router.post(api.mianshenheWorkTimeSubmit, performance.mianshenheWorkTimeSubmit)
router.post(api.getWorkTimeListByType, performance.getWorkTimeListByType)
router.post(api.getWorkHourStatistics, performance.getWorkHourStatistics)

// workStation-个人工作台
router.post(api.getAssignProjectList, workStation.getAssignProjectList)
router.post(api.getAssignProjectDetail, workStation.getAssignProjectDetail)
router.post(api.getAssignProjectDetailV2, workStation.getAssignProjectDetailV2)
router.post(api.submitProcess, workStation.submitProcess)
router.post(api.submitAssignWorkDetail, workStation.submitAssignWorkDetail)
router.post(api.getAssignedProject, workStation.getAssignedProject)
router.post(api.updateAssignProjectList, workStation.updateAssignProjectList)
router.post(api.deleteAssignProject, workStation.deleteAssignProject)
router.post(api.updateAssignProjectFilled, workStation.updateAssignProjectFilled)
router.post(api.updateAssignProjectStageInfo, workStation.updateAssignProjectStageInfo)
router.post(api.getAssignWorkDetail, workStation.getAssignWorkDetail)
router.post(api.getPlanInfo, workStation.getPlanInfo)
router.post(api.getAssignedProjectPlan, workStation.getAssignedProjectPlan)
router.post(api.getAssignProjectStageList, workStation.getAssignProjectStageList)
router.post(api.getWorkTimeListOfProjectStage, workStation.getWorkTimeListOfProjectStage)
router.post(api.updateEditProjectStage, workStation.updateEditProjectStage)
router.post(api.getIsSubmitAllow, workStation.getIsSubmitAllow)
router.post(api.getCurGroupWorkTimeReviewFinish, workStation.getCurGroupWorkTimeReviewFinish)
router.post(api.getManagerMultualRateFinish, workStation.getManagerMultualRateFinish)
router.post(api.getPerformanceIsPublish, workStation.getPerformanceIsPublish)
router.post(api.performanceInfoPublish, workStation.performanceInfoPublish)
router.post(api.getUnFilledProjectList, workStation.getUnFilledProjectList)
router.post(api.projectDetailIsApplyWorkTime, workStation.projectDetailIsApplyWorkTime)
router.post(api.projectDetailIsApplyWorkTimeV2, workStation.projectDetailIsApplyWorkTimeV2)
router.post(api.repairErrorData, workStation.repairErrorData)
router.post(api.repairErrorData2, workStation.repairErrorData2)
router.post(api.setProjectFinish, workStation.setProjectFinish)
router.post(api.getTypeProjectList, workStation.getTypeProjectList)
router.post(api.getMonthProcess, workStation.getMonthProcess)
router.post(api.getLatestProcessBeforeMonth, workStation.getLatestProcessBeforeMonth)
router.post(api.updateAssignProjectInfo, workStation.updateAssignProjectInfo) // ***更新项目信息***
router.post(api.getAssignProjectTotalWorkTime, workStation.getAssignProjectTotalWorkTime) // ***获取项目总工时***

// 互评模块
router.post(api.getUserRates, mutualRates.getUserRates)
router.post(api.submitRatesResult, mutualRates.submitRatesResult)
router.post(api.updateUserRate, mutualRates.updateUserRate)
router.post(api.getAllUserRates, mutualRates.getAllUserRates)
router.post(api.getPerformanceIsCount, mutualRates.getPerformanceIsCount)
router.post(api.getMonthEva, mutualRates.getMonthEva)
router.post(api.handleFillMul, mutualRates.handleFillMul)
router.post(api.getPerformanceRates, mutualRates.getPerformanceRates)
router.post(api.getAllQTEvaedData, mutualRates.getAllQTEvaedData)

// 成效评价模块
router.post(api.getAllAchievements, achievementsEva.getAllAchievements)
router.post(api.getUserofAchievementToAnotherUser, achievementsEva.getUserofAchievementToAnotherUser)
router.post(api.submitAMEvaData, achievementsEva.submitAMEvaData)
router.post(api.updateAMEvaData, achievementsEva.updateAMEvaData)
router.post(api.getAchievementEvaOfConclusionDimension, achievementsEva.getAchievementEvaOfConclusionDimension)
router.post(api.getUserConclusionEvaedData, achievementsEva.getUserConclusionEvaedData)
router.post(api.addFailedAMEvaData, achievementsEva.addFailedAMEvaData)
router.post(api.getFailedAMEvaData, achievementsEva.getFailedAMEvaData)
router.post(api.getAllFailedAMEvaData, achievementsEva.getAllFailedAMEvaData)
router.post(api.updateFailedAMEvaRetrySuccess, achievementsEva.updateFailedAMEvaRetrySuccess)
router.post(api.deleteFailedAMEvaData, achievementsEva.deleteFailedAMEvaData)
router.post(api.clearFailedAMEvaData, achievementsEva.clearFailedAMEvaData)

// 总结模块
router.post(api.getCurMonthConclusionOverviewData, conclusion.getCurMonthConclusionOverviewData)
router.post(api.submitMonthConclusionData, conclusion.submitMonthConclusionData)
router.post(api.updateMonthConclusionData, conclusion.updateMonthConclusionData)
router.post(api.updateMonthConclusionStatus, conclusion.updateMonthConclusionStatus)
router.post(api.submitEvaData, conclusion.submitEvaData)
router.post(api.updateWorkTimeListIdOfConclusion, conclusion.updateWorkTimeListIdOfConclusion)
router.post(api.submitMonthConclusionNew, conclusion.submitMonthConclusionNew)
router.post(api.updateMonthConclusionNew, conclusion.updateMonthConclusionNew)
router.post(api.getCurMonthConclusionOverviewDataNew, conclusion.getCurMonthConclusionOverviewDataNew)
router.post(api.getCurMonthConclusionOverviewDataNewV2, conclusion.getCurMonthConclusionOverviewDataNewV2)
router.post(api.getCurMonthConclusionOverviewDataNewV3, conclusion.getCurMonthConclusionOverviewDataNewV3)
router.post(api.getCurYearConclusionOverviewData, conclusion.getCurYearConclusionOverviewData)

// **绩效加分模块
router.post(api.getPMBDataByUserID, performanceBonus.getPMBDataByUserID)
router.post(api.getPBData, performanceBonus.getPBData)
router.post(api.getPMBRules, performanceBonus.getPMBRules)
router.post(api.getPMBRulesByID, performanceBonus.getPMBRulesByID)
router.post(api.submitPBData, performanceBonus.submitPBData)
router.post(api.updatePBData, performanceBonus.updatePBData)

// 定时任务模块
router.post(api.getCronJobConfig, cronJob.getCronJobConfig)
router.post(api.updateCronJobConfig, cronJob.updateCronJobConfig)
router.post(api.getCronJobStatus, cronJob.getCronJobStatus)
router.post(api.executeMutualRateFill, cronJob.executeMutualRateFill)
router.post(api.executeAutoConclusion, cronJob.executeAutoConclusion)
router.post(api.getAutoConclusionLogs, cronJob.getAutoConclusionLogs)
router.post(api.getAutoConclusionDetails, cronJob.getAutoConclusionDetails)
router.post(api.getAutoConclusionStatistics, cronJob.getAutoConclusionStatistics)
// 新增定时任务路由
router.post(api.executeAMEvaDeadline, cronJob.executeAMEvaDeadline)
router.post(api.executeMutualEvaSubmit, cronJob.executeMutualEvaSubmit)
router.post(api.executeWorkTimeSubmit, cronJob.executeWorkTimeSubmit)
router.post(api.executeResetAssignProject, cronJob.executeResetAssignProject)
router.post(api.executeCleanProgress, cronJob.executeCleanProgress)
// 统一任务日志路由
router.post(api.getAllJobExecutionLogs, cronJob.getAllJobExecutionLogs)
router.post(api.getJobExecutionDetail, cronJob.getJobExecutionDetail)
router.post(api.getJobExecutionStatistics, cronJob.getJobExecutionStatistics)
// 任务名称更新路由
router.post(api.updateJobName, cronJob.updateJobName)
// 设置下次执行时间路由
router.post(api.setNextExecution, cronJob.setNextExecution)
// 停止定时任务路由
router.post(api.stopCronJob, cronJob.stopCronJob)
// 启动定时任务路由
router.post(api.startCronJob, cronJob.startCronJob)

module.exports = router;
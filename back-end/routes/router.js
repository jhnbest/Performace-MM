// 接口地址管理
let express = require('express');
let user = require('../controls/user');
let weekly = require('../controls/weekly');
let performance = require('../controls/performance');
let workStation = require('../controls/workStation');
let mutualRates = require('../controls/mutualRate');
let api = require('../config/api');

let router = express.Router();

// user-用户管理 
router.post(api.userLogin, user.login);
router.post(api.userLogout, user.logout);
router.post(api.userAdd, user.add);
router.post(api.userUpdateInfo, user.updateInfo);
router.post(api.userUpdateState, user.updateState);
router.post(api.userDetail, user.detail);
router.post(api.userList, user.list);
router.post(api.usersList, user.listTest);
router.post(api.getUsersName, user.getUsersName);
router.post(api.getGroupUserName, user.getGroupUserName);
router.post(api.oldPasswordAuth, user.oldPasswordAuth);
router.post(api.updateNewPassword, user.updateNewPassword);

// weekly-周报管理
router.post(api.weeklyAdd, weekly.add);
router.post(api.weeklyUpdateInfo, weekly.updateInfo);
router.post(api.weeklyUpdateState, weekly.updateState);
router.post(api.weeklyDetail, weekly.detail);
router.post(api.weeklyList, weekly.list);

// Performance-工时管理
router.post(api.performanceAdd, performance.add);
router.post(api.workTypeList, performance.workTypeList)
router.post(api.getWorkTime, performance.getWorkTime)
router.post(api.getProjectType, performance.getProjectType)
router.post(api.getWorkTimeNew, performance.getWorkTimeNew)
router.post(api.workTimeSubmit, performance.workTimeSubmit)
router.post(api.workTimeTemporary, performance.workTimeTemporary)
router.post(api.getProjectList, performance.getProjectList)
router.post(api.getWorkAssign, performance.getWorkAssign)
router.post(api.getProjectInfo, performance.getProjectInfo)
router.post(api.changeSubmitStatus, performance.changeSubmitStatus)
router.post(api.deleteProject, performance.deleteProject)
router.post(api.updateWorkTimeAssignReview, performance.updateWorkTimeAssignReview)
router.post(api.getUnReviewProjectCount, performance.getUnReviewProjectCount)
router.post(api.submitReviewPass, performance.submitReviewPass)
router.post(api.getAssignWorkTime, performance.getAssignWorkTime)
router.post(api.getGroupWorkTimeList, performance.getGroupWorkTimeList)
router.post(api.getAllWorkTimeList, performance.getAllWorkTimeList)
router.post(api.getIsWorkTimeReviewFinish, performance.getIsWorkTimeReviewFinish)
router.post(api.getCurApplyAbleMonth, performance.getCurApplyAbleMonth)
router.post(api.submitProjectWorkTimeApply, performance.submitProjectWorkTimeApply)
router.post(api.repairErrorData3, performance.repairErrorData3)

// workStation-个人工作台
router.post(api.getAssignProjectList, workStation.getAssignProjectList)
router.post(api.getAssignProjectDetail, workStation.getAssignProjectDetail)
router.post(api.submitPlanProcess, workStation.submitPlanProcess)
router.post(api.submitAssignWorkDetail, workStation.submitAssignWorkDetail)
router.post(api.getMonthProcessDiff, workStation.getMonthProcessDiff)
router.post(api.getAssignedProject, workStation.getAssignedProject)
router.post(api.updateAssignProjectList, workStation.updateAssignProjectList)
router.post(api.deleteAssignProject, workStation.deleteAssignProject)
router.post(api.updateAssignProjectFilled, workStation.updateAssignProjectFilled)
router.post(api.updateAssignWork, workStation.updateAssignWork)
router.post(api.getAssignWorkDetail, workStation.getAssignWorkDetail)
router.post(api.submitPersonalProject, workStation.submitPersonalProject)
router.post(api.submitMonthPlanProcess, workStation.submitMonthPlanProcess)
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
router.post(api.repairErrorData, workStation.repairErrorData)
router.post(api.repairErrorData2, workStation.repairErrorData2)

// 互评模块
router.post(api.getUserRates, mutualRates.getUserRates)
router.post(api.submitRatesResult, mutualRates.submitRatesResult)
router.post(api.updateUserRate, mutualRates.updateUserRate)
router.post(api.getCurMutualRate, mutualRates.getCurMutualRate)
router.post(api.getAllUserRates, mutualRates.getAllUserRates)
router.post(api.getPerformanceIsCount, mutualRates.getPerformanceIsCount)
router.post(api.getPreMonthEva, mutualRates.getPreMonthEva)
router.post(api.handleFillMul, mutualRates.handleFillMul)

module.exports = router;
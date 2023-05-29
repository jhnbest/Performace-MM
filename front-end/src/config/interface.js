// 接口配置

export const urlGetTypeGlobalFlag = '/common/getTypeGlobalFlag'
export const urlGetGlobalFlagByType = '/common/getGlobalFlagByType'
export const urlUpdateGlobalFlagVal = '/common/updateGlobalFlagVal' // 更新某种类型的全局标志位
export const urlGetEvaCoef = '/common/getEvaCoef' // 从数据库获取各种评价系数

export const urlUserLogin = '/user/login' // 用户登录
export const urlUserLogout = '/user/logout' // 用户登出
export const urlGetUsersList = '/user/getUsersList' // 获取用户信息
export const urlGetGroupUserName = '/user/getGroupUserName' // 获取组员信息
export const urlUpdateNewPassword = '/user/updateNewPassword' // 修改密码
export const urlOldPasswordAuth = '/user/oldPasswordAuth' // 旧密码认证

export const urlGetProjectType = '/performance/projectType' // 获取项目类型
export const urlWorkTimeSubmit = '/performance/workTimeSubmit' // 提交工时申报
export const ulrGetWorkTimeNew = '/performance/getWorkTimeNew' // 获取项目类型对应的工时
export const urlWorkTimeTemporary = '/performance/workTimeTemporary' // 暂存工时申报信息
export const urlGetProjectList = '/performance/getProjectList' // 获取工时申报信息
export const urlGetWorkAssign = '/performance/getWorkAssign' // 获取工时分配信息
export const getProjectInfo = '/performance/getProjectInfo' // 获取工时申报详情
export const urlChangeSubmitStatus = '/performance/changeSubmitStatus' // 改变提交状态
export const urlDeleteWorkTimeSubmit = '/performance/deleteWorkTimeSubmit' // 删除工时申报
export const updateWorkTimeAssignReview = '/performance/updateWorkTimeAssignReview' // 提交工时分配审核结果
export const urlGetSubmitWorkTimeCount = '/performance/getSubmitWorkTimeCount' // 获取提交的工时申报数量
export const submitReviewPass = '/performance/submitReviewPass' // 审核通过
export const getGroupWorkTimeList = '/performance/getGroupWorkTimeList' // 获取小组已申报工时列表
export const urlGetAllWorkTimeList = '/performance/getAllWorkTimeList' // 获取全处已申报工时列表
export const getIsWorkTimeReviewFinish = '/performance/getIsWorkTimeReviewFinish' // 判断工时是否都已审核完毕
export const urlGetCurApplyAbleMonth = '/performance/getCurApplyAbleMonth' // 获取当前可申报的月份
export const urlSubmitProjectWorkTimeApply = '/performance/submitProjectWorkTimeApply' // 提交项目工时申报
export const repairErrorData3 = '/performance/repairErrorData3' // 修复错误数据3
export const urlUpdateWorkTimeListReviewStatus = '/performance/updateWorkTimeListReviewStatus' // 更新工时条目审核状态
export const urlGetWorkTimeAssignInfo = '/performance/getWorkTimeAssignInfo' // 获取工时分配信息
export const urlGetWorkTimeListInfo = '/performance/getWorkTimeListInfo' // 获取工时申报信息
export const urlSavePMData = '/performance/savePMData' // 写入绩效数据
export const urlUpdatePMData = '/performance/updatePMData' // 更新绩效数据
export const urlGetPMData = '/performance/getPMData' // 获取绩效数据

export const getAssignProjectList = '/workStation/getAssignProjectList' // 获取未完成的指派项目列表
export const getAssignProjectDetail = '/workStation/getAssignProjectDetail' // 获取未完成的指派项目明细
export const urlgetAssignProjectDetailV2 = '/workStation/getAssignProjectDetailV2' // 获取未完成的指派项目明细
export const urlSubmitProcess = '/workStation/submitProcess' // 提交进展
export const submitAssignWorkDetail = '/workStation/submitAssignWorkDetail' // 保存指派项目
export const getAssignedProject = '/workStation/getAssignedProject' // 获取已指派项目列表
export const updateAssignProjectList = '/workStation/updateAssignProjectList' // 获取已指派项目列表
export const deleteAssignProject = '/workStation/deleteAssignProject' // 删除已指派项目列表
export const updateAssignProjectFilled = '/workStation/updateAssignProjectFilled' // 删除已指派项目列表
export const updateAssignWork = '/workStation/updateAssignWork' // 更新项目
export const getAssignWorkDetail = '/workStation/getAssignWorkDetail' // 获取项目明细
export const submitPersonalProject = '/workStation/submitPersonalProject' // 提交个人申报项目
export const submitMonthPlanProcess = '/workStation/submitMonthPlanProcess' // 提交计划至计划进展表
export const getPlanInfo = '/workStation/getPlanInfo' // 获取计划列表
export const getAssignedProjectPlan = '/workStation/getAssignedProjectPlan' // 获取指派的项目信息(计划查询)‘
export const getAssignProjectStageList = '/workStation/getAssignProjectStageList' // 获取指派的项目阶段
export const getWorkTimeListOfProjectStage = '/workStation/getWorkTimeListOfProjectStage' // 获取项目阶段对应的工时申报
export const updateEditProjectStage = '/workStation/updateEditProjectStage' // 更新项目阶段
export const urlGetIsSubmitAllow = '/workStation/getIsSubmitAllow' // 获取是否可以申报工时和提交互评
export const getCurGroupWorkTimeReviewFinish = '/workStation/getCurGroupWorkTimeReviewFinish' // 获取当前小组工时审核是否都已完毕
export const getManagerMultualRateFinish = '/workStation/getManagerMultualRateFinish' // 当月领导者是否已经评价完毕
export const urlGetPerformanceIsPublish = '/workStation/getPerformanceIsPublish' // 当月绩效是否已经发布
export const performanceInfoPublish = '/workStation/performanceInfoPublish' // 是否发布首页绩效信息
export const getUnFilledProjectList = '/workStation/getUnFilledProjectList' // 获取未填报的项目列表
export const projectDetailIsApplyWorkTime = '/workStation/projectDetailIsApplyWorkTime' // 查看项目阶段当月是否已填报工时
export const urlProjectDetailIsApplyWorkTime = '/workStation/projectDetailIsApplyWorkTime' // 查看项目阶段当月是否已填报工时
export const urlProjectDetailIsApplyWorkTimeV2 = '/workStation/projectDetailIsApplyWorkTimeV2' // 查看项目阶段当月是否已填报工时
export const urlSetProjectFinish = '/workStation/setProjectFinish' // 将项目置为已完成状态
export const urlGetTypeProjectList = '/workStation/getTypeProjectList' // 获取特定类型的项目列表

export const getUserRates = '/mutualRates/getUserRates' // 获取互评信息
export const submitRatesResult = '/mutualRates/submitRatesResult' // 提交互评结果
export const updateUserRate = '/mutualRates/updateUserRate' // 更新互评结果
export const getCurMutualRate = '/mutualRates/getCurMutualRate' // 获取本人互评得分
export const getAllUserRates = '/mutualRates/getAllUserRates' // 获取本处员工互评得分
export const urlGetAllUserRates = '/mutualRates/getAllUserRates' // 获取本处员工互评得分
export const getPerformanceIsCount = '/mutualRates/getPerformanceIsCount' // 获取绩效信息统计标志
export const urlGetMonthEva = '/mutualRates/getMonthEva' // 获取定性评价数据
export const handleFillMul = '/mutualRates/handleFillMul' // 一键填充定性评价
export const urlGetPerformanceRates = '/mutualRates/getPerformanceRates' // 获取成效评价历史数据
export const urlGetAllQTEvaedData = '/mutualRates/getAllQTEvaedData' // 获取全处员工定性评价数据(被评价人为对象)

export const urlGetAllAchievements = '/achievementsEva/getAllAchievements' // 获取全处成效评价数据
export const urlGetUserofAchievementToAnotherUser = '/achievementsEva/getUserofAchievementToAnotherUser' // 获取用户的成效评价
export const urlSubmitAMEvaData = '/achievementsEva/submitAMEvaData' // 提交成效评价
export const urlUpdateAMEvaData = '/achievementsEva/updateAMEvaData' // 更新成效评价
export const urlGetAchievementEvaOfConclusionDimension = '/achievementsEva/getAchievementEvaOfConclusionDimension' // 获取对某个总结的所有评价
export const urlGetUserConclusionEvaedData = '/achievementsEva/getUserConclusionEvaedData' // 获取某个用户的所有被评价数据

export const urlGetCurMonthConclusionOverviewData = '/conclusion/getCurMonthConclusionOverviewData' // 获取月总结概览信息
export const urlSubmitMonthConclusionData = '/conclusion/submitMonthConclusionData' // 提交月总结
export const urlGetConclusionDataById = '/conclusion/getConclusionDataById' // 提交月总结
export const urlUpdateMonthConclusionData = '/conclusion/updateMonthConclusionData' // 更新月总结
export const urlUpdateMonthConclusionStatus = '/conclusion/updateMonthConclusionStatus' // 更新月总结状态
export const urlSubmitEvaData = '/conclusion/submitEvaData' // 提交评价数据
export const urlUpdateWorkTimeListIdOfConclusion = '/conclusion/updateWorkTimeListIdOfConclusion' // 更新总结对应的工时ID
export const urlSubmitMonthConclusionNew = '/conclusion/submitMonthConclusionNew' // 提交月总结（新）
export const urlUpdateMonthConclusionNew = '/conclusion/updateMonthConclusionNew' // 更新月总结（新）
export const urlGetCurMonthConclusionOverviewDataNew = '/conclusion/getCurMonthConclusionOverviewDataNew' // 获取月总结概览信息（新）
export const urlGetCurYearConclusionOverviewData = '/conclusion/getCurYearConclusionOverviewData' // 获取本年份总结概览数据
export const urlGetCurMonthConclusionOverviewDataNewV2 = '/conclusion/getCurMonthConclusionOverviewDataNewV2' // 获取月总结概览信息V2

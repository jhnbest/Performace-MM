// 接口配置

export const urlGetTypeGlobalFlag = '/common/getTypeGlobalFlag'
export const urlGetGlobalFlagByType = '/common/getGlobalFlagByType'
export const urlUpdateGlobalFlagVal = '/common/updateGlobalFlagVal' // 更新某种类型的全局标志位

export const userLogin = '/user/login' // 用户登录
export const userLogout = '/user/logout' // 用户登出
export const userAdd = '/user/add' // 新增用户
export const userUpdateInfo = '/user/updateInfo' // 更新用户信息
export const userUpdateState = '/user/updateState' // 更新用户状态
export const userDetail = '/user/detail' // 获取用户详情
export const userList = '/user/list' // 获取用户列表
export const usersList = '/user/listTest' // 获取用户列表test
export const getUsersName = '/user/getUsersName' // 获取用户名字
export const getGroupUserName = '/user/getGroupUserName' // 获取组员信息
export const updateNewPassword = '/user/updateNewPassword' // 修改密码
export const oldPasswordAuth = '/user/oldPasswordAuth' // 旧密码认证
export const urlGetAllUsersInfo = '/user/getUsersName' // 获取全处员工信息

export const weeklyAdd = '/weekly/add' // 新增周报
export const weeklyUpdateInfo = '/weekly/updateInfo' // 更新周报信息
export const weeklyUpdateState = '/weekly/updateState' // 更新周报状态
export const weeklyDetail = '/weekly/detail' // 获取周报详情
export const weeklyList = '/weekly/list' // 获取周报列表

export const getProjectType = '/performance/projectType' // 获取项目类型
export const getWorkTime = '/performance/getWorkTime' // 查询工时
export const workTimeSubmit = '/performance/workTimeSubmit' // 提交工时申报
export const getWorkTimeNew = '/performance/getWorkTimeNew'
export const workTimeTemporary = '/performance/workTimeTemporary' // 暂存工时申报信息
export const getProjectList = '/performance/getProjectList' // 获取工时申报信息
export const getWorkAssign = '/performance/getWorkAssign' // 获取工时分配信息
export const getProjectInfo = '/performance/getProjectInfo' // 获取工时分配信息
export const changeSubmitStatus = '/performance/changeSubmitStatus' // 改变提交状态
export const deleteProject = '/performance/deleteProject' // 删除项目
export const updateWorkTimeAssignReview = '/performance/updateWorkTimeAssignReview' // 提交工时分配审核结果
export const getUnReviewProjectCount = '/performance/getUnReviewProjectCount' // 获取待审数量
export const submitReviewPass = '/performance/submitReviewPass' // 审核通过
export const getAssignWorkTime = '/performance/getAssignWorkTime' // 获取分配的工时
export const getGroupWorkTimeList = '/performance/getGroupWorkTimeList' // 获取小组已申报工时列表
export const urlGetAllWorkTimeList = '/performance/getAllWorkTimeList' // 获取全处已申报工时列表
export const getIsWorkTimeReviewFinish = '/performance/getIsWorkTimeReviewFinish' // 判断工时是否都已审核完毕
export const urlGetCurApplyAbleMonth = '/performance/getCurApplyAbleMonth' // 获取当前可申报的月份
export const submitProjectWorkTimeApply = '/performance/submitProjectWorkTimeApply' // 提交项目工时申报
export const repairErrorData3 = '/performance/repairErrorData3' // 修复错误数据3
export const urlUpdateWorkTimeListReviewStatus = '/performance/updateWorkTimeListReviewStatus' // 更新工时条目审核状态
export const urlGetWorkTimeAssignInfo = '/performance/getWorkTimeAssignInfo' // 获取工时分配信息
export const urlGetWorkTimeListInfo = '/performance/getWorkTimeListInfo' // 获取工时申报信息

export const getAssignProjectList = '/workStation/getAssignProjectList' // 获取未完成的指派项目列表
export const getAssignProjectDetail = '/workStation/getAssignProjectDetail' // 获取未完成的指派项目明细
export const submitPlanProcess = '/workStation/submitPlanProcess' // 保存计划和进展
export const submitAssignWorkDetail = '/workStation/submitAssignWorkDetail' // 保存指派项目
export const getMonthProcessDiff = '/workStation/getMonthProcessDiff' // 获取每月进展对应工时
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
export const getIsSubmitAllow = '/workStation/getIsSubmitAllow' // 获取是否可以申报工时和提交互评
export const getCurGroupWorkTimeReviewFinish = '/workStation/getCurGroupWorkTimeReviewFinish' // 获取当前小组工时审核是否都已完毕
export const getManagerMultualRateFinish = '/workStation/getManagerMultualRateFinish' // 当月领导者是否已经评价完毕
export const urlGetPerformanceIsPublish = '/workStation/getPerformanceIsPublish' // 当月绩效是否已经发布
export const performanceInfoPublish = '/workStation/performanceInfoPublish' // 是否发布首页绩效信息
export const getUnFilledProjectList = '/workStation/getUnFilledProjectList' // 获取未填报的项目列表
export const projectDetailIsApplyWorkTime = '/workStation/projectDetailIsApplyWorkTime' // 查看项目阶段当月是否已填报工时
export const repairErrorData = '/workStation/repairErrorData' // 修复错误数据
export const repairErrorData2 = '/workStation/repairErrorData2' // 修复错误数据2
export const urlSetProjectFinish = '/workStation/setProjectFinish' // 将项目置为已完成状态
export const urlGetTypeProjectList = '/workStation/getTypeProjectList' // 获取特定类型的项目列表

export const getUserRates = '/mutualRates/getUserRates' // 获取互评信息
export const submitRatesResult = '/mutualRates/submitRatesResult' // 提交互评结果
export const updateUserRate = '/mutualRates/updateUserRate' // 更新互评结果
export const getCurMutualRate = '/mutualRates/getCurMutualRate' // 获取本人互评得分
export const getAllUserRates = '/mutualRates/getAllUserRates' // 获取本处员工互评得分
export const urlGetAllUserRates = '/mutualRates/getAllUserRates' // 获取本处员工互评得分
export const getPerformanceIsCount = '/mutualRates/getPerformanceIsCount' // 获取绩效信息统计标志
export const getPreMonthEva = '/mutualRates/getPreMonthEva' // 提取上月互评结果
export const handleFillMul = '/mutualRates/handleFillMul' // 一键填充定性评价
export const urlGetPerformanceRates = '/mutualRates/getPerformanceRates' // 获取成效评价历史数据
export const urlGetAllPerformanceRate = '/mutualRates/getAllPerformanceRate' // 获取全处成效评价数据

export const urlGetCurMonthConclusionOverviewData = '/conclusion/getCurMonthConclusionOverviewData' // 获取总结数据
export const urlSubmitMonthConclusionData = '/conclusion/submitMonthConclusionData' // 提交月总结
export const urlGetConclusionDataById = '/conclusion/getConclusionDataById' // 提交月总结
export const urlUpdateMonthConclusionData = '/conclusion/updateMonthConclusionData' // 更新月总结
export const urlUpdateMonthConclusionStatus = '/conclusion/updateMonthConclusionStatus' // 更新月总结状态
export const urlSubmitEvaData = '/conclusion/submitEvaData' // 提交评价数据
export const urlUpdateWorkTimeListIdOfConclusion = '/conclusion/updateWorkTimeListIdOfConclusion' // 更新总结对应的工时ID

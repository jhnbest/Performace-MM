let path = '/api';

module.exports = {
    // 通用模块
    getTypeGlobalFlag: path + '/common/getTypeGlobalFlag',
    getGlobalFlagByType: path + '/common/getGlobalFlagByType',
    updateGlobalFlagVal: path + '/common/updateGlobalFlagVal',
    getEvaCoef: path + '/common/getEvaCoef',
    getGlobalFlagByTime: path + '/common/getGlobalFlagByTime',

    // user-用户管理
    userLogin: path + '/user/login', // 用户登录
    userLogout: path + '/user/logout', // 用户登出
    userAdd: path + '/user/add', // 新增用户
    userUpdateInfo: path + '/user/updateInfo', // 更新用户信息
    userUpdateState: path + '/user/updateState', // 更新用户状态
    usersList: path + '/user/listTest',
    getUsersList: path + '/user/getUsersList', //获取用户姓名
    getGroupUserName: path + '/user/getGroupUserName', // 获取组员信息
    oldPasswordAuth: path + '/user/oldPasswordAuth', // 旧密码认证
    updateNewPassword: path + '/user/updateNewPassword', // 更新密码

    // Performance-工时管理
    performanceAdd: path + '/performance/add',
    getProjectType: path + '/performance/projectType',
    getWorkTime: path + '/performance/getWorkTime', // 查询工时
    getWorkTimeNew: path + '/performance/getWorkTimeNew',
    workTimeSubmit: path + '/performance/workTimeSubmit', //新增工时申报
    workTimeTemporary: path + '/performance/workTimeTemporary', // 暂存工时申报信息
    getProjectList: path + '/performance/getProjectList', // 获取工时申报信息
    getWorkAssign: path + '/performance/getWorkAssign', // 获取工时分配信息
    getProjectInfo: path + '/performance/getProjectInfo', //获取项目信息
    changeSubmitStatus: path + '/performance/changeSubmitStatus', //改变提交状态
    deleteWorkTimeSubmit: path + '/performance/deleteWorkTimeSubmit', // 删除项目
    updateWorkTimeAssignReview: path + '/performance/updateWorkTimeAssignReview', // 提交工时分配审核结果
    getSubmitWorkTimeCount: path + '/performance/getSubmitWorkTimeCount', // 获取提交的工时申报数量
    submitReviewPass: path + '/performance/submitReviewPass', // 审核通过,
    getGroupWorkTimeList: path + '/performance/getGroupWorkTimeList', // 获取小组已审工时列表
    getAllWorkTimeList: path + '/performance/getAllWorkTimeList', // 获取全处已审工时列表
    getIsWorkTimeReviewFinish: path + '/performance/getIsWorkTimeReviewFinish', // 判断工时是否都已审核完毕
    getCurApplyAbleMonth: path + '/performance/getCurApplyAbleMonth', // 获取当前可申报的月份
    submitProjectWorkTimeApply: path + '/performance/submitProjectWorkTimeApply', // 提交项目工时申报
    updateWorkTimeListReviewStatus: path + '/performance/updateWorkTimeListReviewStatus', // 更新工时条目审核状态
    getWorkTimeAssignInfo: path + '/performance/getWorkTimeAssignInfo', // 获取工时分配信息
    getWorkTimeListInfo: path + '/performance/getWorkTimeListInfo', // 获取工时申报信息
    savePMData: path + '/performance/savePMData', // 写入绩效数据
    savePMDataV2: path + '/performance/savePMDataV2', // 写入绩效数据
    savePMDataV3: path + '/performance/savePMDataV3', // 写入绩效数据
    updatePMData: path + '/performance/updatePMData', // 更新绩效数据
    updatePMDataV2: path + '/performance/updatePMDataV2', // 更新绩效数据
    updatePMDataV3: path + '/performance/updatePMDataV3', // 更新绩效数据
    getPMData: path + '/performance/getPMData', // 获取绩效数据
    test: path + '/performance/test', // 测试
    mianshenheWorkTimeSubmit: path + '/performance/mianshenheWorkTimeSubmit', // 提交免审核工时
    getWorkTimeListByType: path + '/performance/getWorkTimeListByType', // ***根据项目类型获取工时列表***
    getWorkHourStatistics: path + '/performance/getWorkHourStatistics', // ***获取工时统计（按组/按人/按项目类型）***


    // workStation-个人工作台
    getAssignProjectList: path + '/workStation/getAssignProjectList',
    getAssignProjectDetail: path + '/workStation/getAssignProjectDetail', // 获取未完成的指派项目明细
    getAssignProjectDetailV2: path + '/workStation/getAssignProjectDetailV2', // 获取未完成的指派项目明细
    submitProcess: path + '/workStation/submitProcess', //提交进展
    submitAssignWorkDetail: path + '/workStation/submitAssignWorkDetail', //保存指派项目
    getAssignedProject: path + '/workStation/getAssignedProject', // 获取每月进展对应工时
    updateAssignProjectList: path + '/workStation/updateAssignProjectList', // 更新已指派项目
    deleteAssignProject: path + '/workStation/deleteAssignProject', // 删除已指派项目
    updateAssignProjectFilled: path + '/workStation/updateAssignProjectFilled', // 更新指派项目是否填报字段
    updateAssignProjectStageInfo: path + '/performance/updateAssignProjectStageInfo', // ***更新项目阶段信息***
    getAssignWorkDetail: path + '/workStation/getAssignWorkDetail', // 获取项目明细
    getPlanInfo: path + '/workStation/getPlanInfo', // 获取计划列表
    getAssignedProjectPlan: path + '/workStation/getAssignedProjectPlan', // 获取指派项目列表(计划查询)
    getAssignProjectStageList: path + '/workStation/getAssignProjectStageList', // 获取指派阶段列表
    getWorkTimeListOfProjectStage: path + '/workStation/getWorkTimeListOfProjectStage', // 获取项目阶段对应的工时申报
    updateEditProjectStage: path + '/workStation/updateEditProjectStage', // 更新项目阶段
    getIsSubmitAllow: path + '/workStation/getIsSubmitAllow', // 获取是否可以申报工时和提交互评
    getCurGroupWorkTimeReviewFinish: path + '/workStation/getCurGroupWorkTimeReviewFinish', // 获取当前小组工时审核是否都已完毕
    getManagerMultualRateFinish: path + '/workStation/getManagerMultualRateFinish', // 当月领导者是否已经评价完毕
    getPerformanceIsPublish: path + '/workStation/getPerformanceIsPublish', // 当月互评是否已经发布
    performanceInfoPublish: path + '/workStation/performanceInfoPublish', // 是否发布首页绩效信息
    getUnFilledProjectList: path + '/workStation/getUnFilledProjectList', // 获取未填报的项目列表
    projectDetailIsApplyWorkTime: path + '/workStation/projectDetailIsApplyWorkTime', // 查看项目阶段当月是否已填报工时
    projectDetailIsApplyWorkTimeV2: path + '/workStation/projectDetailIsApplyWorkTimeV2', // 查看项目阶段当月是否已填报工时
    repairErrorData: path + '/workStation/repairErrorData', // 修复错误数据
    repairErrorData2: path + '/workStation/repairErrorData2', // 修复错误数据2
    setProjectFinish: path + '/workStation/setProjectFinish', // 将项目置为已完成状态
    getTypeProjectList: path + '/workStation/getTypeProjectList', // 获取特定类型的项目列表
    getMonthProcess: path + '/performance/getMonthProcess', // ***根据项目阶段获取项目进展***
    getLatestProcessBeforeMonth: path + '/workStation/getLatestProcessBeforeMonth', // ***获取项目在某年某月之前的最近申报进展***
    updateAssignProjectInfo: path + '/performance/updateAssignProjectInfo', // ***更新项目信息***
    getAssignProjectTotalWorkTime: path + '/workStation/getAssignProjectTotalWorkTime', // ***获取项目总工时***

    // 互评模块
    getUserRates: path + '/mutualRates/getUserRates', // 获取互评信息
    submitRatesResult: path + '/mutualRates/submitRatesResult', // 提交互评结果
    updateUserRate: path + '/mutualRates/updateUserRate', // 更新互评结果
    getAllUserRates: path + '/mutualRates/getAllUserRates', // 获取本处员工互评得分
    getPerformanceIsCount: path + '/mutualRates/getPerformanceIsCount', // 获取绩效信息统计标志
    getMonthEva: path + '/mutualRates/getMonthEva', // 提取定性评价数据
    handleFillMul: path + '/mutualRates/handleFillMul', // 一键填充定性评价
    getPerformanceRates: path + '/mutualRates/getPerformanceRates', // 获取成效评价历史数据
    getAllQTEvaedData: path + '/mutualRates/getAllQTEvaedData', // 获取全处员工定性评价数据(被评价人为对象)

    // 成效评价模块
    getAllAchievements: path + '/achievementsEva/getAllAchievements', // 获取全处成效评价历史数据
    getUserofAchievementToAnotherUser: path + '/achievementsEva/getUserofAchievementToAnotherUser', // 获取用户的成效评价
    submitAMEvaData: path + '/achievementsEva/submitAMEvaData', // 提交成效评价
    updateAMEvaData: path + '/achievementsEva/updateAMEvaData', // 更新成效评价
    getAchievementEvaOfConclusionDimension: path + '/achievementsEva/getAchievementEvaOfConclusionDimension', // 获取对某个总结的所有评价
    getUserConclusionEvaedData: path + '/achievementsEva/getUserConclusionEvaedData', // 获取某个用户的所有被评价数据
    addFailedAMEvaData: path + '/achievementsEva/addFailedAMEvaData', // 添加失败成效评价数据
    getFailedAMEvaData: path + '/achievementsEva/getFailedAMEvaData', // 获取失败成效评价数据
    getAllFailedAMEvaData: path + '/achievementsEva/getAllFailedAMEvaData', // 获取所有失败成效评价数据（监控用）
    updateFailedAMEvaRetrySuccess: path + '/achievementsEva/updateFailedAMEvaRetrySuccess', // 更新失败成效评价为重试成功
    deleteFailedAMEvaData: path + '/achievementsEva/deleteFailedAMEvaData', // 删除失败成效评价数据
    clearFailedAMEvaData: path + '/achievementsEva/clearFailedAMEvaData', // 清除失败成效评价数据

    // 总结模块
    getCurMonthConclusionOverviewData: path + '/conclusion/getCurMonthConclusionOverviewData', // 获取总结数据
    submitMonthConclusionData: path + '/conclusion/submitMonthConclusionData', // 提交月总结
    updateMonthConclusionData: path + '/conclusion/updateMonthConclusionData', // 更新月总结
    updateMonthConclusionStatus: path + '/conclusion/updateMonthConclusionStatus', // 更新月总结状态
    submitEvaData: path + '/conclusion/submitEvaData', // 提交评价数据
    updateWorkTimeListIdOfConclusion: path + '/conclusion/updateWorkTimeListIdOfConclusion', // 更新总结对应的工时ID
    submitMonthConclusionNew: path + '/conclusion/submitMonthConclusionNew', // 提交月总结（新）
    updateMonthConclusionNew: path + '/conclusion/updateMonthConclusionNew', // 更新月总结（新）
    getCurMonthConclusionOverviewDataNew: path + '/conclusion/getCurMonthConclusionOverviewDataNew', // 获取月总结概览信息（新）
    getCurMonthConclusionOverviewDataNewV2: path + '/conclusion/getCurMonthConclusionOverviewDataNewV2', // 获取月总结概览信息V2
    getCurMonthConclusionOverviewDataNewV3: path + '/conclusion/getCurMonthConclusionOverviewDataNewV3', // 获取当月月总结中的下月计划
    getCurYearConclusionOverviewData: path + '/conclusion/getCurYearConclusionOverviewData', // 获取本年份总结概览数据

    getPMBDataByUserID: path + '/pmbData/getPMBDataByUserID', // **获取绩效加分数据(通过用户ID)
    getPBData: path + '/pmbData/getPBData', // **获取绩效加分数据
    getPMBRules: path + '/pmbData/getPMBRules', // **获取绩效加分标准
    getPMBRulesByID: path + '/pmbData/getPMBRulesByID', // **获取绩效加分标准(通过ID)
    submitPBData: path + '/pmbData/submitPBData', // **提交绩效加分数据
    updatePBData: path + '/pmbData/updatePBData', // **更新绩效加分数据
    
    // 定时任务模块
    getCronJobConfig: path + '/cronJob/getCronJobConfig', // 获取定时任务配置
    updateCronJobConfig: path + '/cronJob/updateCronJobConfig', // 更新定时任务配置
    getCronJobStatus: path + '/cronJob/getCronJobStatus', // 获取定时任务状态
    executeMutualRateFill: path + '/cronJob/executeMutualRateFill', // 手动执行互评填充任务
    executeAutoConclusion: path + '/cronJob/executeAutoConclusion', // 手动执行月总结自动提交任务
    getAutoConclusionLogs: path + '/cronJob/getAutoConclusionLogs', // 获取执行日志列表
    getAutoConclusionDetails: path + '/cronJob/getAutoConclusionDetails', // 获取执行日志详情
    getAutoConclusionStatistics: path + '/cronJob/getAutoConclusionStatistics', // 获取执行统计数据
    // 新增定时任务
    executeAMEvaDeadline: path + '/cronJob/executeAMEvaDeadline', // 手动执行AMEva截止任务
    executeMutualEvaSubmit: path + '/cronJob/executeMutualEvaSubmit', // 手动执行互评提交任务
    executeWorkTimeSubmit: path + '/cronJob/executeWorkTimeSubmit', // 手动执行工时提交任务
    executeResetAssignProject: path + '/cronJob/executeResetAssignProject', // 手动执行重置分配项目任务
    executeCleanProgress: path + '/cronJob/executeCleanProgress', // 手动执行清理进展任务
    // 统一任务日志
    getAllJobExecutionLogs: path + '/cronJob/getAllJobExecutionLogs', // 获取所有任务的执行日志列表
    getJobExecutionDetail: path + '/cronJob/getJobExecutionDetail', // 获取任务执行日志详情
    getJobExecutionStatistics: path + '/cronJob/getJobExecutionStatistics', // 获取任务执行统计
    // 任务名称更新
    updateJobName: path + '/cronJob/updateJobName', // 更新任务名称
    // 设置下次执行时间
     setNextExecution: path + '/cronJob/setNextExecution', // 设置定时任务下次执行时间
     // 停止定时任务
     stopCronJob: path + '/cronJob/stopCronJob', // 停止定时任务
     // 启动定时任务
     startCronJob: path + '/cronJob/startCronJob' // 启动定时任务
};
let path = '/demo-weekly/back-end/api';
// let path = '/api';

module.exports = {
    // user-用户管理
    userLogin: path + '/user/login', // 用户登录
    userLogout: path + '/user/logout', // 用户登出
    userAdd: path + '/user/add', // 新增用户
    userUpdateInfo: path + '/user/updateInfo', // 更新用户信息
    userUpdateState: path + '/user/updateState', // 更新用户状态
    userDetail: path + '/user/detail', // 获取用户详情
    userList: path + '/user/list', // 获取用户列表
    usersList: path + '/user/listTest',
    getUsersName: path + '/user/getUsersName', //获取用户姓名
    getGroupUserName: path + '/user/getGroupUserName', // 获取组员信息
    oldPasswordAuth: path + '/user/oldPasswordAuth', // 旧密码认证
    updateNewPassword: path + '/user/updateNewPassword', // 更新密码

    // weekly-周报管理
    weeklyAdd: path + '/weekly/add', // 新增周报
    weeklyUpdateInfo: path + '/weekly/updateInfo', // 更新周报信息
    weeklyUpdateState: path + '/weekly/updateState', // 更新周报状态
    weeklyDetail: path + '/weekly/detail', // 获取周报详情
    weeklyList: path + '/weekly/list', // 获取周报列表

    // Performance-工时管理
    performanceAdd: path + '/performance/add',
    getProjectType: path + '/performance/projectType',
    workTypeList: path + '/performance/workTypeList',
    getWorkTime: path + '/performance/getWorkTime', // 查询工时
    getWorkTimeNew: path + '/performance/getWorkTimeNew',
    workTimeSubmit: path + '/performance/workTimeSubmit', //新增工时申报
    workTimeTemporary: path + '/performance/workTimeTemporary', // 暂存工时申报信息
    getProjectList: path + '/performance/getProjectList', // 获取工时申报信息
    getWorkAssign: path + '/performance/getWorkAssign', // 获取工时分配信息
    getProjectInfo: path + '/performance/getProjectInfo', //获取项目信息
    changeSubmitStatus: path + '/performance/changeSubmitStatus', //改变提交状态
    deleteProject: path + '/performance/deleteProject', // 删除项目
    updateWorkTimeAssignReview: path + '/performance/updateWorkTimeAssignReview', // 提交工时分配审核结果
    getUnReviewProjectCount: path + '/performance/getUnReviewProjectCount', // 获取待审数量
    submitReviewPass: path + '/performance/submitReviewPass', // 审核通过,
    getAssignWorkTime: path + '/performance/getAssignWorkTime', // 获取分配的工时数
    getGroupWorkTimeList: path + '/performance/getGroupWorkTimeList', // 获取小组已审工时列表
    getAllWorkTimeList: path + '/performance/getAllWorkTimeList', // 获取全处已审工时列表
    getIsWorkTimeReviewFinish: path + '/performance/getIsWorkTimeReviewFinish', // 判断工时是否都已审核完毕
    getCurApplyAbleMonth: path + '/performance/getCurApplyAbleMonth', // 获取当前可申报的月份
    submitProjectWorkTimeApply: path + '/performance/submitProjectWorkTimeApply', // 提交项目工时申报

    // workStation-个人工作台
    getAssignProjectList: path + '/workStation/getAssignProjectList',
    getAssignProjectDetail: path + '/workStation/getAssignProjectDetail', // 获取未完成的指派项目明细
    submitPlanProcess: path + '/workStation/submitPlanProcess', //保存计划进展
    submitAssignWorkDetail: path + '/workStation/submitAssignWorkDetail', //保存指派项目
    getMonthProcessDiff: path + '/workStation/getMonthProcessDiff', // 获取每月进展对应工时
    getAssignedProject: path + '/workStation/getAssignedProject', // 获取每月进展对应工时
    updateAssignProjectList: path + '/workStation/updateAssignProjectList', // 更新已指派项目
    deleteAssignProject: path + '/workStation/deleteAssignProject', // 删除已指派项目
    updateAssignProjectFilled: path + '/workStation/updateAssignProjectFilled', // 更新指派项目是否填报字段
    updateAssignWork: path + '/workStation/updateAssignWork', // 更新项目明细
    getAssignWorkDetail: path + '/workStation/getAssignWorkDetail', // 获取项目明细
    submitPersonalProject: path + '/workStation/submitPersonalProject', // 提交个人申报项目
    submitMonthPlanProcess: path + '/workStation/submitMonthPlanProcess', // 提交计划至计划进展表
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
    repairErrorData: path + '/workStation/repairErrorData', // 修复错误数据
    repairErrorData2: path + '/workStation/repairErrorData2', // 修复错误数据2

    // 互评模块
    getUserRates: path + '/mutualRates/getUserRates', // 获取互评信息
    submitRatesResult: path + '/mutualRates/submitRatesResult', // 提交互评结果
    updateUserRate: path + '/mutualRates/updateUserRate', // 更新互评结果
    getCurMutualRate: path + '/mutualRates/getCurMutualRate', // 获取本人互评得分
    getAllUserRates: path + '/mutualRates/getAllUserRates', // 获取本处员工互评得分
    getPerformanceIsCount: path + '/mutualRates/getPerformanceIsCount', // 获取绩效信息统计标志
    getPreMonthEva: path + '/mutualRates/getPreMonthEva' // 提取上月互评结果
};
// let path = '/demo-weekly/back-end/api';
let path = '/api';

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
    submitMonthPlanProcess: path + '/workStation/submitMonthPlanProcess' // 提交计划至计划进展表
};
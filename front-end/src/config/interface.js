// 接口配置
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

export const weeklyAdd = '/weekly/add' // 新增周报
export const weeklyUpdateInfo = '/weekly/updateInfo' // 更新周报信息
export const weeklyUpdateState = '/weekly/updateState' // 更新周报状态
export const weeklyDetail = '/weekly/detail' // 获取周报详情
export const weeklyList = '/weekly/list' // 获取周报列表

export const performanceAdd = '/performance/add' // 新增工时申报
export const workTypeList = '/performance/workTypeList' // 获取工时类型
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

export const getUserRates = '/mutualRates/getUserRates' // 获取互评信息
export const submitRatesResult = '/mutualRates/submitRatesResult' // 提交互评结果

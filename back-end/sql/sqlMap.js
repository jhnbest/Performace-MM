const sqlMap = {
  user: {
    // 登陆
    //login: 'select * from user where name = ? and password = ? and state != 0',
    login: 'select * from users where account = ? and password = ? and status != 0',
    // 新增用户
    add: 'insert IGNORE into user (name, password, email, create_time, update_time) values (?, ?, ?, ?, ?)',
    // 更新用户信息
    updateInfo: 'update user set name = ?, password = ?, email = ?, update_time = ? where id = ? and type != 1 and status != 0',
    // 更改用户状态
    updateState: 'update user set status = ?, update_time = ? where id = ? and type != 1 and state != 0',
    // 获取用户信息
    getDetail: 'select * from user where id = ? and status != 0',
    // 查询周报列表条数
    selectTotal: 'select count(*) as totalCount from user where status != 0',
    // 用户列表
    selectList: 'select id, name, email, type, create_time, update_time, status from user where status != 0',
    // 用户列表Test
    selectList1: 'select * from users where status != 0',
    // 查询周报列表条数Test
    selectTotal1: 'select count(*) as totalCount from users where status != 0',
    // 查询用户姓名
    selectUsersName: 'select id, account, dept, name, groupName from users where status != 0',
    // 查询组员信息
    getGroupUserName: 'select id, name, groupName from users where groupName = ? and status != 0',
    // 查询全员信息
    getAllUserName: 'select id, name, groupName from users where status != 0',
    // 用户旧密码认证
    oldPasswordAuth: 'select password from users where account = ?',
    // 更新密码
    updateNewPassword: 'update users set password = ? where account = ?',
    // 查询用户姓名
    getUserNameByID: 'select name from users where id = ? and status != 0'
  },
  weekly: {
    // 新增周报
    add: 'insert into weekly (userId, startTime, endTime, title, thisWeekWork, nextWeekWork, collaboration, create_time, update_time) values (?, ?, ?, ?, ?, ?, ?, ?, ?)',
    // 更新周报信息
    updateInfo: 'update weekly set startTime = ?, endTime = ?, title = ?, thisWeekWork = ?, nextWeekWork = ?, collaboration = ?, update_time = ? where id = ? and status != 0',
    // 更新周报状态
    updateState: 'update weekly set status = ?, update_time = ? where id = ? and status != 0',
    // 查询周报列表条数
    selectTotal: 'select count(*) as totalCount from weekly where status != 0',
     // 查询周报列表
    selectList: 'select weekly.id, userId, user.name as userName, startTime, endTime, title, weekly.create_time, weekly.update_time, weekly.status from weekly,user where weekly.userId = user.id and weekly.status != 0',
    // 以id为主条件查询某篇周报详情
    getDetail: 'select weekly.id, userId, user.name as userName, startTime, endTime, title, thisWeekWork, nextWeekWork, collaboration, weekly.create_time, weekly.update_time, weekly.status from weekly,user where weekly.userId = user.id and weekly.status != 0 and weekly.id=?'
  },
  performance: {
    //新增工时申报
    add: 'insert into projectlist (userId, title, workType, workTime, participants) values (?, ?, ?, ?, ?)',
    selectWorkTypeTotal: 'select count(distinct projecttype.projectLevel1) as totalCount from projecttype',
    selectWorkTypeList: 'select distinct projecttype.projectLevel1 from projecttype',
    selectSubWorkType1List: 'select distinct projectLevel2 from projecttype where projecttype.projectLevel1 = ?',
    selectSubWorkType2List: 'select distinct projectLevel3 from projecttype where projecttype.projectLevel2 = ?',
    selectSubWorkType3List: 'select distinct projectLevel4 from projecttype where projecttype.projectLevel2 = ? and projecttype.projectLevel3 = ?',
    selectWorkTime: 'select distinct workTime, dynamicKValue, defaultKValue, defaultCofficient from projecttype where projecttype.projectLevel2 = ? and projecttype.projectLevel4 = ?',
    selectProjectTypeFirst: 'select projectTypeID, projectName from projecttypenew where projectParentID = ? or projectParentID = 0',
    selectProjectType: 'select projectTypeID, projectName from projecttypenew where projectParentID = ? and obsoleteStatus != 1',
    selectProjectTime: 'select projectTypeID, projectName, workTime, dynamicKValue, isConference, defaultAssignWorkTime ' +
        'from projecttypenew where projectTypeID = ?',
    addProject: 'insert into worktimelist (submitID, projectTypeID, applyKValue, reviewKValue, applyCofficient, reviewCofficient, submitTime, ' +
        'updateTime, applyMonth, submitStatus, submitComments, avaiableWorkTime, applyProcess, apdID, aplID, monthID, applyType, lastProcess, ' +
        'applyBaseWorkTime) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    addWorkAssign: 'insert into worktimeassign (userID, projectID, workTime, assignRole) values (?, ?, ?, ?)',
    updateProject: 'update worktimelist set submitID = ?, projectTypeID = ?, applyKValue = ?, reviewKValue = ?, applyCofficient = ?, ' +
        'reviewCofficient = ?, updateTime = ?, applyMonth = ?, submitStatus = ?, submitComments = ?, applyProcess = ?, ' +
        'avaiableWorkTime = ?, applyBaseWorkTime = ? where id = ?',
    updateRejectProject: 'update worktimelist set submitID = ?, projectTypeID = ?, applyKValue = ?, reviewKValue = ?, applyCofficient = ?, ' +
        'reviewCofficient = ?, updateTime = ?, applyMonth = ?, submitStatus = ?, reviewStatus = ?, submitComments = ?, ' +
        'applyProcess = ?, avaiableWorkTime = ?, applyBaseWorkTime = ? where id = ?',
    updateWorkAssign: 'update worktimeassign set reviewWorkTime = ? where id = ?',
    updateWorkAssignEdit: 'update worktimeassign set userID = ?, projectID = ?, ' +
        'workTime = ?, assignRole = ?, reviewWorkTime = ? where id = ?',
    deleteWorkAssign: 'update worktimeassign set obsoleteStatus = 1 where id = ?',
    // getProjectList: 'SELECT * from worktimelist WHERE submitID = ? and applyMonth = ? and obsoleteStatus != 1', //查找项目列表
    getProjectList: 'SELECT wl.*, apl.projectName, apl.projectType as parentTypeID, apd.projectStageName, users.name as reviewerName, ' +
        'pjn.isConference from worktimelist wl left join projecttypenew pjn on wl.projectTypeID = pjn.projectTypeID left join ' +
        'assignprojectlist apl on wl.aplID = apl.id left join assignprojectdetail apd on wl.apdID = apd.id left join users on wl.reviewer = ' +
        'users.id WHERE wl.submitID = ? and wl.applyMonth = ? ' +
        'and wl.obsoleteStatus != 1',
    // getProjectListNew: 'SELECT * FROM worktimelist WHERE id IN (SELECT projectID FROM worktimeassign WHERE userID = ? and obsoleteStatus != 1) and applyMonth = ? and obsoleteStatus != 1',
    getProjectListNew: 'select wl.*, apl.projectName, apd.projectStageName, u.name as reviewerName from worktimelist wl left join ' +
        'projecttypenew pjn on wl.projectTypeID = pjn.projectTypeID left join assignprojectlist apl on wl.aplID ' +
        '= apl.id left join assignprojectdetail apd on wl.apdID = apd.id left join users u on wl.reviewer = u.id' +
        ' where wl.id in (select projectID from worktimeassign where userID = ? ' +
        'and obsoleteStatus != 1) and wl.applyMonth = ? and wl.obsoleteStatus != 1',
    getProjectListTotal: 'SELECT count(*) as totalCount from worktimelist WHERE submitID = ? and applyMonth = ? and obsoleteStatus != 1',
    getProjectListTotalNew: 'SELECT count(*) as totalCount from worktimelist where id IN (SELECT projectID FROM worktimeassign WHERE userID = ? and obsoleteStatus != 1) ' +
        'and applyMonth = ? and obsoleteStatus != 1',
    getReviewedProjecTotal: 'SELECT count(*) as totalCount from worktimelist WHERE submitID = ? and applyMonth = ? ' +
        'and obsoleteStatus != 1 and reviewStatus != 0 and submitStatus = 1 and applyType = "fact"',
    getUnReviewProjecTotal: 'SELECT count(*) as totalCount from worktimelist WHERE submitID = ? and applyMonth = ? ' +
        'and obsoleteStatus != 1 and reviewStatus = 0 and submitStatus = 1 and applyType = "fact"',
    getWorkAssign: 'SELECT u.name, u.groupName, u.id as userID, wa.id, wa.workTime, wa.reviewWorkTime, wa.projectID, wa.assignRole from worktimeassign ' +
        'wa INNER JOIN users u ON wa.userID = u.id WHERE wa.projectID = ? and wa.obsoleteStatus != 1',
    getProjectInfo: 'select wl.*, apd.projectStageName from worktimelist wl left join assignprojectdetail apd on ' +
        'wl.apdID = apd.id where wl.id = ? and wl.obsoleteStatus != 1',
    getWorkAssignInfo: 'select * from worktimeassign where projectID = ? and obsoleteStatus != 1',
    getFullProjectType: 'select projectParentID, projectName, workTime, dynamicKValue, ' +
        'isConference, defaultAssignWorkTime from projecttypenew ' +
        'where projectTypeID = ?',
    changeSubmitStatus: 'update worktimelist set submitStatus = ? where id = ?',
    changeRejectProjectSubmitStatus: 'update worktimelist set submitStatus = ?, updateTime = ?, reviewStatus = ? where id = ?',
    deleteProject: 'update worktimelist set obsoleteStatus = 1 where id = ?',
    deleteWorkTimeAssign: 'update worktimeassign set obsoleteStatus = 1 where projectID = ?',
    getReviewStatus: 'select reviewStatus from worktimelist where id = ? and obsoleteStatus != 1',
    submitReviewPass: 'update worktimelist set reviewKValue = ?, reviewCofficient = ?, reviewStatus = ?, reviewTime = ?, reviewComments = ?, ' +
        'reviewer = ?, monthID = ? where id = ?',
    submitReviewRejectOrWithdraw: 'update worktimelist set reviewKValue = ?, reviewCofficient = ?, reviewStatus = ?, reviewTime = ?, reviewComments = ?, ' +
        'reviewer = ? where id = ?',
    updateProjectWorkTimeAssignReviewStatus: 'update worktimelist set workTimeAssignReviewStatus = ? where id = ?',
    getAssignWorkTime: 'select reviewWorkTime from worktimeassign where projectID = ? and userID = ? and obsoleteStatus != 1',
    getGroupWorkTimeList: 'select u.id, u.name, wa.reviewWorkTime, wl.applyMonth from worktimeassign wa left join worktimelist ' +
        'wl on wa.projectID = wl.id left join users u on wa.userID = u.id where wl.applyMonth = ? and u.groupName = ? and ' +
        ' wl.reviewStatus = 1 and wa.obsoleteStatus != 1 and u.status != 0',
    getAllWorkTimeList: 'select u.id, u.name, u.groupName as groupID, wa.reviewWorkTime, wl.applyMonth from worktimeassign wa left join worktimelist ' +
        'wl on wa.projectID = wl.id left join users u on wa.userID = u.id where wl.applyMonth = ? and ' +
        ' wl.reviewStatus = 1 and wa.obsoleteStatus != 1 and u.status != 0',
    getIsWorkTimeReviewFinish: 'select * from worktimelist where applyMonth = ? and obsoleteStatus != 1 and reviewStatus = 0 ' +
        'and applyType = "fact" and submitStatus = 1',
    getCurApplyAbleMonth: 'select * from globalflag where flagType = "curApplyMonth"'
  },
  workStation: {
    getAssignProjectListUn: 'select apl.*, users.name as assigner from assignprojectlist apl left join users on apl.assignerID = users.id where ' +
        'apl.userID = ? and apl.projectType = ? and apl.process != 100.0 and apl.isFilled = 0 and apl.obsoleteStatus != 1',
    getAssignProjectListUnCount: 'select count(*) as totalCount from assignprojectlist apl where ' +
        'apl.userID = ? and apl.projectType = ? and apl.process != 100.0 and apl.isFilled = 0 and apl.obsoleteStatus != 1',
    getAssignProjectList: 'select apl.*, users.name as assigner from assignprojectlist apl left join users on apl.assignerID = users.id where ' +
        'apl.userID = ? and apl.projectType = ? and apl.process = 100.0 and apl.obsoleteStatus != 1',
    getAssignProjectListCount: 'select count(*) as totalCount from assignprojectlist apl where ' +
        'apl.userID = ? and apl.projectType = ? and apl.process = 100.0 and apl.obsoleteStatus != 1',
    getAssignProjectListed: 'select apl.*, users.name as assigner from assignprojectlist apl left join users on apl.assignerID = users.id where ' +
        'apl.userID = ? and apl.projectType = ? and apl.process != 100.0 and apl.isFilled = 1 and apl.obsoleteStatus != 1',
    getAssignProjectListedCount: 'select count(*) as totalCount from assignprojectlist apl where ' +
        'apl.userID = ? and apl.projectType = ? and apl.process != 100.0 and apl.isFilled = 1 and apl.obsoleteStatus != 1',
    // getAssignProjectDetail: 'select id, projectStage, baseWorkTime, kValue, coefficient, avaiableWorkTime, process from assignprojectdetail where aPLID = ?',
    getAssignProjectDetail: 'select apd.id as apdID, apd.projectStage as projectStageID, apd.kValue, apd.coefficient, apd.avaiableWorkTime, ' +
        'apd.process, apd.baseWorkTime, apd.projectStageName, apd.isFinish, pjn.dynamicKValue, pjn.isConference, pjn.defaultAssignWorkTime ' +
        'from assignprojectdetail apd left join projecttypenew pjn on apd.projectStage = pjn.projectTypeID where apd.aPLID = ? and apd.obsoleteStatus != 1',
    getMonthProcess: 'select id, aPDID, year, type, January, February, March, April, May, June, July, August, September, ' +
        'October, November, December from monthprocess where aPDID = ? and year = ? and obsoleteStatus != 1',
    // getProjectDetailProcess: 'select id, aPDID, year, type, months, process from monthprocess where aPDID = ? and year = ?',
    submitPlanProcessE: 'update assignprojectdetail set kValue = ?, coefficient = ?, isFinish = ? where id = ?;' +
        'update monthprocess set January = ?, February = ?, March = ?, April = ?, May = ?, June = ?, July = ?, August = ?, ' +
        'September = ?, October = ?, November = ?, December = ? where id = ?',
    submitPlanProcessU: 'update assignprojectdetail set kValue = ?, coefficient = ?, isFinish = ? where id = ?;' +
        'insert into monthprocess (aPDID, year, type, January, February, March, April, May, June, July, August, September, ' +
        'October, November, December) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    getAssignProjectStageByID: 'select January, February, March, April, May, June, July, August, September, October, November, December from monthprocess where ' +
        'aPDID = ? and type = "fact" and obsoleteStatus != 1',
    projectStageProcessInsert: 'update assignprojectdetail set process = ? where id = ?;select aPLID from assignprojectdetail where id = ?',
    getProjectStageProcess: 'select count(*) as totalCount from assignprojectdetail where aPLID = ? and obsoleteStatus != 1;' +
        'select process from assignprojectdetail where aPLID = ? and obsoleteStatus != 1',
    projectProcessUpdate: 'update assignprojectlist set process = ? where id = ?',
    insertAssignProjectList: 'insert into assignprojectlist (userID, assignDate, projectType, projectName, assignerID, totalWorkTime, projectLevel, ' +
        'reviewStatus, isFilled) values (?, ?, ?, ?, ?, ?, ?, ?, ?)',
    insertAssignProjectDetail: 'insert into assignprojectdetail (aPLID, projectStage, projectStageName, baseWorkTime, kValue, avaiableWorkTime) value ' +
        '(?, ?, ?, ?, ?, ?)',
    getMonthProcessDiffOP: 'select * from monthprocess where aPDID = ? and type = ? and obsoleteStatus != 1',
    selectAssignProjectDetial: 'select * from assignprojectdetail where id = ? and obsoleteStatus != 1',
    getAssignProject: 'select apd.id as apdID, apd.aPLID, apd.projectStage, apd.projectStageName, apd.baseWorkTime, apd.kValue, apd.coefficient, ' +
        'apd.process as apdProcess, apl.id as aplID, apl.userID, apl.assignDate, apl.projectType, apl.projectName, apl.process as aplProcess, ' +
        'apl.assignerID, apl.totalWorkTime, apl.gettedWorkTime, apl.isFilled from assignprojectdetail apd left join assignprojectlist apl on ' +
        'apd.aPLID = apl.id where apd.id = ? and apd.obsoleteStatus != 1',
    getAssignedProject: 'select apl.id, apl.assignDate, apl.projectName, apl.projectType as projectTypeID, ' +
        'apl.userID as projectManagerID, apl.process, apl.projectLevel, pjn.projectName ' +
        'as projectType, users.name as projectManager from assignprojectlist apl left join projecttypenew pjn on ' +
        'apl.projectType = pjn.projectTypeID left join users on apl.userID = users.id where apl.assignerID = ? and apl.obsoleteStatus != 1',
    updateAssignProjectList: 'update assignprojectlist set userID = ?, projectName = ?, projectLevel = ? where id = ?',
    deleteAssignProjectList: 'update assignprojectlist set obsoleteStatus = 1 where id = ?',
    deleteAssignProjectDetail: 'update assignprojectdetail set obsoleteStatus = 1 where aPLID = ?',
    getAssignProjectDetailID: 'select id from assignprojectdetail where aPLID = ?',
    updateMonthProcessObsoleteStatus: 'update monthprocess set obsoleteStatus = 1 where aPDID in (',
    updateAssignProjectFilled: 'update assignprojectlist set isFilled = 1 where id = ?',
    getAssignWorkDetail: 'select apd.id as apdID, apd.aPLID as aplID, apl.projectLevel from assignprojectdetail apd left join' +
        ' assignprojectlist apl on apd.aPLID = apl.id where apd.id = ?',
    UpdateAssignWorkDetail: 'update assignprojectdetail set projectStageName = ?, kValue = ?, ' +
        'coefficient = ?, avaiableWorkTime = ?, baseWorkTime = ? where id = ?',
    UpdateAssignWorkList: 'update assignprojectlist set totalWorkTime = ? where id = ?',
    GetProjectTotalWorkTime: 'select sum(avaiableWorkTime)totalWorkTime from assignprojectdetail where aPLID = ?',
    deleteWorkTimeList: 'update worktimelist set obsoleteStatus = 1 where aplID = ?',
    getWorkTimeAssignItem: 'select id from worktimelist where aplID = ?',
    updateWorkTimeAssignObsoleteStatus: 'update worktimeassign set obsoleteStatus = 1 where projectID in (',
    getMonthProcessByID: 'select * from monthprocess where id = ?',
    getPlanInfo: 'select * from worktimelist where submitID = ? and applyType = "plan" and applyMonth = ?' +
        ' and obsoleteStatus != 1',
    assignProjectList: 'select apl.*, pjn.projectName as projectTypeName from assignprojectlist apl ' +
        'left join projecttypenew pjn on apl.projectType = pjn.projectTypeID where apl.userID = ? and ' +
        'apl.obsoleteStatus != 1',
    getWorkTimeListOfProjectStage: 'select * from worktimelist where apdID = ? and obsoleteStatus != 1',
    updateProjectStage: 'update assignprojectdetail set projectStageName = ?, ' +
        'baseWorkTime = ?, kValue = ?, avaiableWorkTime = ? where id = ?',
    insertNewProjectStage: 'insert into assignprojectdetail (aPLID, projectStage, projectStageName, baseWorkTime, kValue, ' +
        'avaiableWorkTime) values (?, ?, ?, ?, ?, ?)',
    deleteProjectStage: 'update assignprojectdetail set obsoleteStatus = 1 where id = ?',
    getIsSubmitAllow: 'select * from globalflag where year(setTime) = ? and month(setTime) = ? and flagType = ?',
    getCurGroupWorkTimeReviewFinish: 'select wl.* from worktimelist wl left join users u on wl.submitID = u.id where u.groupName = ? ' +
        'and wl.applyMonth = ? and wl.obsoleteStatus != 1 and wl.reviewStatus = 0 and wl.applyType = "fact" and wl.submitStatus = 1',
    getManagerMultualRateFinish: 'select * from mutualrate where ratePersion = 26 and rateMonth = ?',
    getPerformanceIsPublish: 'select * from globalflag where year(setTime) = ? and month(setTime) = ? and flagType = ?',
    updatePerformanceInfoPublish: 'update globalflag set flagValue = ? where id = ?',
    insertPerformanceInfoPublish: 'insert into globalflag (setTime, flagType, flagValue) values (?, ?, ?)',
    getUnFilledProjectList: 'select * from assignprojectlist where userID = ? and isFilled = 0 and obsoleteStatus != 1 and process != 100.0',
    getFilledProjectList: 'select * from assignprojectlist where userID = ? and isFilled = 1 and obsoleteStatus != 1 and process != 100.0',
    getCompleteProjectList: 'select * from assignprojectlist where userID = ? and obsoleteStatus != 1 and process = 100.0',
    projectDetailIsApplyWorkTime: 'select * from worktimelist where apdID = ? and applyMonth = ? and applyType = ? and obsoleteStatus != 1',
    repairErrorDataCheck: 'select mp.*, wl.applyProcess from monthprocess mp left join worktimelist wl on mp.aPDID = wl.apdID where ' +
        'ISNULL(mp.January) and wl.applyMonth = "2021-01" and wl.obsoleteStatus != 1 and wl.applyType = "fact" and ' +
        'mp.type = "fact" and mp.year = 2021',
    repairErrorData2Check: 'select mp.*, wl.applyProcess from monthprocess mp left join worktimelist wl on mp.aPDID = wl.apdID where ' +
        'wl.applyMonth = "2021-01" and wl.obsoleteStatus != 1 and wl.applyType = "fact" and mp.type = "fact" and mp.year = ' +
        '2021 and wl.applyProcess != mp.January and wl.reviewStatus = 1',
    repairErrorDataModify: 'update monthprocess set January = ? where id = ?',
    repairErrorData2Modify: 'update monthprocess set January = ? where id = ?',
    repairErrorData3Check: 'select * from worktimelist where applyMonth = "2021-01" and applyType = "fact" and reviewStatus = 1',
    repairErrorData3Check2: 'select count(*) as totalCount from monthprocess where year = ? and aPDID = ? and type = "fact"',
    repairErrorData3Check3: 'select u.name, apl.projectName, wl.* from assignprojectdetail apd left join assignprojectlist apl ' +
        'on apd.aPLID = apl.id left join users u on apl.userID = u.id left join worktimelist wl on wl.apdID = apd.id where apd.id = ? ' +
        'and wl.applyMonth = "2021-01" and wl.applyType = "fact"'
  },
  mutualRates: {
    getUserRates: 'select mr.*, u.name as ratedPersionName from mutualrate mr left join users u on ' +
        'mr.ratedPersion = u.id where mr.ratePersion = ? and mr.rateMonth = ?',
    submitRatesResult: 'insert into mutualrate (ratePersion, ratedPersion, rateMonth, rate, rateType, rateTime, updateTime) ' +
        'values (?, ?, ?, ?, ?, ?, ?)',
    updateUserRate: 'update mutualrate set rate = ?, updateTime = ? where id = ?',
    getCurMutualRate: 'select * from mutualrate where ratedPersion = ? and rateMonth = ?',
    getRateData: 'select * from mutualrate where ratePersion = ? and rateMonth = ?',
    getPerformanceIsCount: 'select * from globalflag where year(setTime) = ? and month(setTime) = ? and flagType = ?',
    getPreMonthEva: 'select mr.*, u.name as ratedPersionName from mutualrate mr left join users u on mr.ratedPersion = ' +
        'u.id where mr.rateMonth = ? and mr.ratePersion = ?',
    handleFillMul: 'select count(*) as totalCount from mutualrate where ratePersion = ? and rateMonth = ?',
    handleFillMulCheck: 'select * from mutualrate where ratePersion = ? and rateMonth = "2021-01"',
    handleFillMulFill: 'insert into mutualrate (ratePersion, ratedPersion, rateMonth, rate, rateType, rateTime, updateTime) ' +
        'values (?, ?, ?, ?, ?, ?, ?)'
  }
}
module.exports = sqlMap;
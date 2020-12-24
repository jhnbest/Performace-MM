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
    selectList1: 'select account, dept, groupName, name, role, status from users where status != 0',
    // 查询周报列表条数Test
    selectTotal1: 'select count(*) as totalCount from users where status != 0',
    // 查询用户姓名
    selectUsersName: 'select id, account, dept, name, groupName from users where status != 0',
    // 查询组员信息
    getGroupUserName: 'select id, name from users where groupName = ? and status != 0',
    // 查询全员信息
    getAllUserName: 'select id, name from users where status != 0',
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
    selectProjectTime: 'select projectTypeID, projectName, workTime, dynamicKValue, isConference, defaultAssignWorkTime from projecttypenew where projectTypeID = ?',
    addProject: 'insert into worktimelist (submitID, projectTypeID, applyKValue, reviewKValue, applyCofficient, reviewCofficient, submitTime, ' +
        'updateTime, applyMonth, submitStatus, submitComments, avaiableWorkTime, applyProcess, apdID, aplID, monthID, applyType, lastProcess, ' +
        'applyBaseWorkTime) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    addWorkAssign: 'insert into worktimeassign (userID, projectID, workTime, assignRole) values (?, ?, ?, ?)',
    updateProject: 'update worktimelist set submitID = ?, projectTypeID = ?, applyKValue = ?, reviewKValue = ?, applyCofficient = ?, ' +
        'reviewCofficient = ?, updateTime = ?, applyMonth = ?, submitStatus = ?, submitComments = ?, applyProcess = ?, ' +
        'avaiableWorkTime = ? where id = ?',
    updateRejectProject: 'update worktimelist set submitID = ?, projectTypeID = ?, applyKValue = ?, reviewKValue = ?, applyCofficient = ?, ' +
        'reviewCofficient = ?, updateTime = ?, applyMonth = ?, submitStatus = ?, reviewStatus = ?, submitComments = ?, ' +
        'applyProcess = ?, avaiableWorkTime = ? where id = ?',
    updateWorkAssign: 'update worktimeassign set userID = ?, projectID = ?, workTime = ?, assignRole = ?, reviewWorkTime = ? where id = ?',
    deleteWorkAssign: 'update worktimeassign set obsoleteStatus = 1 where id = ?',
    // getProjectList: 'SELECT * from worktimelist WHERE submitID = ? and applyMonth = ? and obsoleteStatus != 1', //查找项目列表
    getProjectList: 'SELECT wl.*, apl.projectName, apl.projectType as parentTypeID, apd.projectStageName, users.name as reviewerName, ' +
        'pjn.isConference from worktimelist wl left join projecttypenew pjn on wl.projectTypeID = pjn.projectTypeID left join ' +
        'assignprojectlist apl on wl.aplID = apl.id left join assignprojectdetail apd on wl.apdID = apd.id left join users on wl.reviewer = ' +
        'users.id WHERE wl.submitID = ? and wl.applyMonth = ? ' +
        'and wl.obsoleteStatus != 1',
    // getProjectListNew: 'SELECT * FROM worktimelist WHERE id IN (SELECT projectID FROM worktimeassign WHERE userID = ? and obsoleteStatus != 1) and applyMonth = ? and obsoleteStatus != 1',
    getProjectListNew: 'select wl.*, apl.projectName, apd.projectStageName from worktimelist wl left join ' +
        'projecttypenew pjn on wl.projectTypeID = pjn.projectTypeID left join assignprojectlist apl on wl.aplID = apl.id left join assignprojectdetail apd ' +
        'on wl.apdID = apd.id where wl.id in (select projectID from worktimeassign where userID = ? ' +
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
    getFullProjectType: 'select projectParentID, projectName, workTime, dynamicKValue, isConference, defaultAssignWorkTime from projecttypenew ' +
        'where projectTypeID = ? and obsoleteStatus != 1',
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
    getGroupWorkTimeList: 'select wl.*, users.account, users.name, users.groupName from worktimelist wl left join users ' +
        ''
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
    getProjectStageProcess: 'select count(*) as totalCount from assignprojectdetail where aPLID = ?;select process from assignprojectdetail where aPLID = ? and obsoleteStatus != 1',
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
    getAssignedProject: 'select apl.id, apl.projectName, apl.userID as projectManagerID, apl.process, apl.projectLevel, pjn.projectName ' +
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
    UpdateAssignWorkDetail: 'update assignprojectdetail set projectStageName = ?, kValue = ?, coefficient = ?, avaiableWorkTime = ? where id = ?',
    UpdateAssignWorkList: 'update assignprojectlist set totalWorkTime = ? where id = ?',
    GetProjectTotalWorkTime: 'select sum(avaiableWorkTime)totalWorkTime from assignprojectdetail where aPLID = ?',
    deleteWorkTimeList: 'update worktimelist set obsoleteStatus = 1 where aplID = ?',
    getWorkTimeAssignItem: 'select id from worktimelist where aplID = ?',
    updateWorkTimeAssignObsoleteStatus: 'update worktimeassign set obsoleteStatus = 1 where projectID in ('
  }
}
module.exports = sqlMap;
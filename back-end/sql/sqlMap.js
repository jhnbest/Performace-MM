const sqlMap = {
  common: {
    getTypeGlobalFlag: 'select * from globalflag where year(setTime) = ? and month(setTime) = ? and flagType = ?',
    getGlobalFlagByType: 'select * from globalflag where flagType in (?)',
    updateGlobalFlagVal: 'update globalflag set flagValue = ? where flagType = ?',
    getGlobalFlagByTime: 'select * from globalflag where flagType in (?) and year(setTime) = ? and month(setTime) = ?'
  },
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
    // 查询周报列表条数
    selectTotal: 'select count(*) as totalCount from user where status != 0',
    // 用户列表
    selectList: 'select id, name, email, type, create_time, update_time, status from user where status != 0',
    // 用户列表Test
    selectList1: 'select * from users where status != 0',
    // 查询周报列表条数Test
    selectTotal1: 'select count(*) as totalCount from users where status != 0',
    // 查询用户信息1
    selectUsersList1: 'select * from users where status != 0',
    // 查询用户信息2
    selectUsersList2: 'select * from users where groupName = ? and status != 0',
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
  performance: {
    //新增工时申报
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
        'applyProcess = ?, avaiableWorkTime = ?, applyBaseWorkTime = ?, workTimeAssignReviewStatus = 0 where id = ?',
    updateWorkAssign: 'update worktimeassign set reviewWorkTime = ? where id = ?',
    updateWorkAssignEdit: 'update worktimeassign set userID = ?, projectID = ?, ' +
        'workTime = ?, assignRole = ?, reviewWorkTime = ? where id = ?',
    deleteWorkAssign: 'update worktimeassign set obsoleteStatus = 1 where id = ?',
    // getProjectList: 'SELECT * from worktimelist WHERE submitID = ? and applyMonth = ? and obsoleteStatus != 1', //查找项目列表
    getProjectList: 'SELECT wl.*, apl.assignerID, apl.projectName, apl.assigner, ' +
        'apl.projectType as parentTypeID, apd.projectStageName, users.name as reviewerName, ' +
        'pjn.isConference from worktimelist wl left join projecttypenew pjn on wl.projectTypeID = pjn.projectTypeID left join ' +
        '(select apl.*, u.name as assigner from assignprojectlist apl left join users u on apl.assignerID = u.id) apl on ' +
        'wl.aplID = apl.id left join assignprojectdetail apd on wl.apdID = apd.id left join users on wl.reviewer = ' +
        'users.id WHERE wl.submitID = ? and wl.applyMonth = ? and wl.obsoleteStatus != 1',
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
    getProjectInfo: 'select wl.*, apd.projectStageName, apl.projectName, apl.id as aplID from worktimelist wl left join assignprojectdetail apd on ' +
        'wl.apdID = apd.id left join assignprojectlist apl on wl.aplID = apl.id where wl.id = ? and wl.obsoleteStatus != 1',
    getWorkAssignInfo: 'select * from worktimeassign where projectID = ? and obsoleteStatus != 1',
    getFullProjectType: 'select * from projecttypenew where projectTypeID = ?',
    changeSubmitStatus: 'update worktimelist set submitStatus = ?, updateTime = ?, reviewStatus = ? where id = ?',
    changeRejectProjectSubmitStatus: 'update worktimelist set submitStatus = ?, updateTime = ?, reviewStatus = ? where id = ?',
    deleteWorkTimeSubmit: 'update worktimelist set obsoleteStatus = 1 where id = ?',
    deleteWorkTimeAssign: 'update worktimeassign set obsoleteStatus = 1 where projectID = ?',
    getReviewStatus: 'select reviewStatus from worktimelist where id = ? and obsoleteStatus != 1',
    submitReviewPass: 'update worktimelist set reviewKValue = ?, reviewCofficient = ?, reviewStatus = ?, reviewTime = ?, reviewComments = ?, ' +
        'reviewer = ?, monthID = ? where id = ?',
    submitReviewRejectOrWithdraw: 'update worktimelist set reviewKValue = ?, reviewCofficient = ?, reviewStatus = ?, reviewTime = ?, reviewComments = ?, ' +
        'reviewer = ?, submitStatus = ? where id = ?',
    updateProjectWorkTimeAssignReviewStatus: 'update worktimelist set workTimeAssignReviewStatus = ? where id = ?',
    getGroupWorkTimeList: 'select u.id, u.name, wa.reviewWorkTime, wl.applyMonth from worktimeassign wa left join worktimelist ' +
        'wl on wa.projectID = wl.id left join users u on wa.userID = u.id where wl.applyMonth = ? and u.groupName = ? and ' +
        ' wl.reviewStatus = 1 and wa.obsoleteStatus != 1 and u.status != 0',
    getAllWorkTimeList: 'select u.id, u.name, u.duty, u.groupName as groupID, wa.reviewWorkTime, wl.applyMonth from worktimeassign wa left join worktimelist ' +
        'wl on wa.projectID = wl.id left join users u on wa.userID = u.id where wl.applyMonth = ? and ' +
        ' wl.reviewStatus = 1 and wa.obsoleteStatus != 1 and u.status != 0',
    getIsWorkTimeReviewFinish: 'select * from worktimelist where applyMonth = ? and obsoleteStatus != 1 and reviewStatus = 0 ' +
        'and applyType = "fact" and submitStatus = 1',
    getCurApplyAbleMonth: 'select date_format((select setTime from globalflag where flagType = "curApplyMonth"), "%Y-%m-%d") as setTime',
    updateWorkTimeListReviewStatus: 'update worktimelist set reviewKValue = ?, reviewCofficient = ?, reviewer = ?, reviewTime = ? ' +
        ', reviewStatus = ? where id = ?; update worktimeassign set reviewWorkTime = workTime where projectID = ?',
    getWorkTimeAssignInfo: 'select * from worktimeassign where projectID = ?',
    getWorkTimeListInfo: 'select * from worktimelist where id = ?',
    savePMData: 'insert into performancedata (userID, applyDate, totalWorkTime, QYEvaRank, QYEvaScoreNor, CSQTEvaScoreUnN, '
    + 'CSQTEvaScoreNor, CSQTEvaRank, MGQTEvaScoreUnN, MGQTEvaRank, MGQTEvaScoreNor, AMEvaScoreUnN, AMEvaScoreNor, AMEvaRank, '
    + 'PMScoreUnN, PMScoreNor, PMRank, dimension1CSAveStar, dimension1GPEvaStar, dimension2CSAveStar, dimension2GPEvaStar, userDuty, userJob) '
    + 'values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    updatePMData: 'update performancedata set totalWorkTime = ?, QYEvaRank = ?, QYEvaScoreNor = ?, CSQTEvaScoreUnN = ?, '
    + 'CSQTEvaScoreNor = ?, CSQTEvaRank = ?, MGQTEvaScoreUnN = ?, MGQTEvaRank = ?, MGQTEvaScoreNor = ?, AMEvaScoreUnN = ?, '
    + 'AMEvaScoreNor = ?, AMEvaRank = ?, PMScoreUnN = ?, PMScoreNor = ?, PMRank = ?, dimension1CSAveStar = ?, '
    + 'dimension1GPEvaStar = ?, dimension2CSAveStar = ?, dimension2GPEvaStar = ? where id = ?',
    getPMData: 'select pm.*, u.name, u.groupName as groupID from performancedata pm left join users u on pm.userID = u.id where pm.applyDate = ?',
    getWorkTimeAssign: 'select u.name, wa.* from worktimeassign wa left join users u on '
    + 'wa.userID = u.id where wa.projectID in (?) and wa.obsoleteStatus != 1',
    test1: 'select apd.id from monthprocess m left join assignprojectdetail apd on m.aPDID = apd.id where m.year in (2022) and' +
          ' m.type = "fact" and apd.process != 0 and apd.process != 100 and m.obsoleteStatus != 1 group by apd.id order by apd.id',
    test2: 'select * from monthprocess m where m.year = 2023 and m.aPDID = ? and m.type = "fact" and m.obsoleteStatus != 1',
    test3: 'insert into monthprocess (aPDID, year, type) values (?, ?, ?)',
    mianshenheWorkTimeSubmit: 'insert into worktimelist (apdID, aplID, monthID, submitID, projectTypeID, applyKValue, '
    + 'reviewKValue, applyCofficient, reviewCofficient, submitTime, updateTime, applyMonth, submitStatus, reviewStatus, reviewTime, '
    + 'workTimeAssignReviewStatus, reviewer, avaiableWorkTime, applyProcess, lastProcess, applyType, applyBaseWorkTime, '
    + 'obsoleteStatus) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    insertmianshenheWorktimeassign: 'insert into worktimeassign (userID, projectID, workTime, reviewWorkTime, assignRole) values (?, ?, ?, ?, ?)',
    getWorkTimeListByType: 'select * from worktimelist where submitID = ? and applyMonth = ? and projectTypeID = ?'
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
    getAssignProjectListAll: 'select apl.*, users.name as assigner from assignprojectlist apl left join users on apl.assignerID = users.id where ' +
        'apl.userID = ? and apl.projectType = ? and apl.obsoleteStatus != 1',
    getAssignProjectListAllCount: 'select count(*) as totalCount from assignprojectlist apl where ' +
        'apl.userID = ? and apl.projectType = ? and apl.obsoleteStatus != 1',
    // getAssignProjectDetail: 'select id, projectStage, baseWorkTime, kValue, coefficient, avaiableWorkTime, process from assignprojectdetail where aPLID = ?',
    getAssignProjectDetail: 'select apd.aPLID as aplID, apd.id as apdID, apd.projectStage as projectStageID, apd.kValue, apd.coefficient, apd.avaiableWorkTime, ' +
        'apd.process, apd.baseWorkTime, apd.projectStageName, apd.isFinish, pjn.dynamicKValue, pjn.isConference, pjn.defaultAssignWorkTime ' +
        'from assignprojectdetail apd left join projecttypenew pjn on apd.projectStage = pjn.projectTypeID where apd.aPLID = ? and apd.obsoleteStatus != 1',
    // getMonthProcess: 'select id, aPDID, year, type, January, February, March, April, May, June, July, August, September, ' +
    //     'October, November, December from monthprocess where aPDID = ? and year = ? and obsoleteStatus != 1',
    getMonthProcess: 'select * from monthprocess where aPDID = ? and year = ? and obsoleteStatus != 1',
    getMonthProcessV2: 'select * from monthprocess where aPDID in (?) and year in (?) and obsoleteStatus != 1 and type = "fact"',
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
    getAssignProjectV2: 'select * from assignprojectlist where id = ?',
    getAssignedProject: 'select apl.id, apl.assignDate, apl.projectName, apl.projectType as projectTypeID, ' +
        'apl.userID as projectManagerID, apl.process, apl.projectLevel, pjn.projectName ' +
        'as projectType, users.name as projectManager from assignprojectlist apl left join projecttypenew pjn on ' +
        'apl.projectType = pjn.projectTypeID left join users on apl.userID = users.id where apl.assignerID = ? and' +
        'apl.obsoleteStatus != 1',
    updateAssignProjectList: 'update assignprojectlist set userID = ?, projectName = ?, projectLevel = ? where id = ?',
    updateAssignProjectInfo: 'update assignprojectlist set userID = ?, projectType = ?, projectName = ?,' +
      'process = ?, assignerID = ?, totalWorkTime = ?, isFilled = ?, projectLevel = ?, reviewStatus = ?,' +
      'obsoleteStatus = ? where id = ?',
    deleteAssignProjectList: 'update assignprojectlist set obsoleteStatus = 1 where id = ?',
    deleteAssignProjectDetail: 'update assignprojectdetail set obsoleteStatus = 1 where aPLID = ?',
    getAssignProjectDetailID: 'select id from assignprojectdetail where aPLID = ?',
    updateMonthProcessObsoleteStatus: 'update monthprocess set obsoleteStatus = 1 where aPDID in (',
    updateAssignProjectFilled: 'update assignprojectlist set isFilled = 1 where id = ?',
    getAssignWorkDetail: 'select apd.id as apdID, apd.aPLID as aplID, apl.projectLevel from assignprojectdetail apd left join' +
        ' assignprojectlist apl on apd.aPLID = apl.id where apd.id = ?',
    updateAssignProjectStageInfo: 'update assignprojectdetail set projectStageName = ?, kValue = ?, ' +
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
    projectDetailIsApplyWorkTime: 'select wl.*, apl.projectName, apd.projectStageName from worktimelist wl left join assignprojectdetail apd on wl.apdID = apd.id left join' +
    ' assignprojectlist apl on wl.aplID = apl.id where wl.apdID = ? and wl.applyMonth = ? and wl.applyType = ? and wl.obsoleteStatus != 1',
    projectDetailIsApplyWorkTimeV2: 'select wl.*, apl.projectName, apd.projectStageName from worktimelist wl left join assignprojectdetail apd on wl.apdID = apd.id left join' +
    ' assignprojectlist apl on wl.aplID = apl.id where wl.apdID in (?) and wl.applyMonth = ? and wl.applyType = ? and wl.obsoleteStatus != 1',
    repairErrorDataCheck: 'select count(*) as totalCount from monthprocess where aPDID = ? and type = "fact" and obsoleteStatus != 1;' +
        'select id, type, year, aPDID from monthprocess where aPDID = ? and obsoleteStatus != 1',
    repairErrorData2Check: 'select mp.*, wl.applyProcess from monthprocess mp left join worktimelist wl on mp.aPDID = wl.apdID where ' +
        'wl.applyMonth = "2021-01" and wl.obsoleteStatus != 1 and wl.applyType = "fact" and mp.type = "fact" and mp.year = ' +
        '2021 and wl.applyProcess != mp.January and wl.reviewStatus = 1',
    repairErrorDataModify: 'update monthprocess set January = ? where id = ?',
    repairErrorData2Modify: 'update monthprocess set January = ? where id = ?',
    repairErrorData3Check: 'select * from worktimelist where applyMonth = "2021-01" and applyType = "fact" and reviewStatus = 1',
    repairErrorData3Check2: 'select count(*) as totalCount from monthprocess where year = ? and aPDID = ? and type = "fact"',
    repairErrorData3Check3: 'select u.name, apl.projectName, wl.* from assignprojectdetail apd left join assignprojectlist apl ' +
        'on apd.aPLID = apl.id left join users u on apl.userID = u.id left join worktimelist wl on wl.apdID = apd.id where apd.id = ? ' +
        'and wl.applyMonth = "2021-01" and wl.applyType = "fact"',
    setProjectFinish: 'update assignprojectlist set process = 100.0 where id = ?; ' +
        'update assignprojectdetail set process = 100.0 where aPLID = ?',
    getTypeProjectList: 'select apl.*, users.name as assigner, u.name as projectManager' +
        ' from assignprojectlist apl left join users on apl.assignerID = users.id ' +
        'left join users u on apl.userID = u.id where ' +
        'apl.projectType = ? and apl.obsoleteStatus != 1',
    getTypeProjectListUn: 'select apl.*, users.name as assigner, u.name as projectManager' +
        ' from assignprojectlist apl left join users on apl.assignerID = users.id ' +
        'left join users u on apl.userID = u.id where ' +
        "apl.projectType = ? and apl.process != 100.0 and apl.obsoleteStatus != 1",
    getTypeProjectListUnV2: 'select apl.*, users.name as assigner, u.name as projectManager' +
        ' from assignprojectlist apl left join users on apl.assignerID = users.id ' +
        'left join users u on apl.userID = u.id where ' +
        "apl.process != 100.0 and apl.obsoleteStatus != 1 and (apl.projectType = 213 or apl.projectType = 275)",
    getTypeProjectListed: 'select apl.*, users.name as assigner, u.name as projectManager' +
        ' from assignprojectlist apl left join users on apl.assignerID = users.id left join users u on apl.userID = u.id ' +
        'where apl.projectType = ? and apl.process == 100.0 and apl.obsoleteStatus != 1',
    getProjectStageByPID: 'select * from assignprojectdetail where aPLID = ?',
    getMonthProcessByProjectStageID: 'select m.*, apd.id as apdID, apd.projectStageName, apl.id as aplID, apl.projectName, ' +
        'apl.process as totalProjectStageProcess, u.name as projectManager from monthprocess m left join assignprojectdetail apd ' +
        'on m.aPDID = apd.id left join assignprojectlist apl on apd.aPLID = apl.id left join users u on apl.userID = u.id' +
        ' where m.aPDID = ? and m.year = ?',
    mianshenheProjectInsert: 'insert into assignprojectlist (userID, assignDate, projectType, projectName, process, assignerID, totalWorkTime,'
    + ' gettedWorkTime, isFilled, projectLevel, reviewStatus, obsoleteStatus) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    mianshenheProjectDetailInsert: 'insert into assignprojectdetail (aPLID, projectStage, projectStageName, baseWorkTime, kValue, coefficient,'
    + ' avaiableWorkTime, process, obsoleteStatus, isFinish) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    getAssignProjectTotalWorkTime: 'select sum(avaiableWorkTime)totalWorkTime from assignprojectdetail where aPLID = ?'
  },
  mutualRates: {
    getUserRates: 'select mr.*, u.name as ratedPersionName from mutualrate mr left join users u on ' +
        'mr.ratedPersion = u.id where mr.ratePersion = ? and mr.rateMonth = ? and u.status != 0',
    submitRatesResult: 'insert into mutualrate (ratePersion, ratedPersion, rateMonth, rate, rateType, rateTime, updateTime) ' +
        'values (?, ?, ?, ?, ?, ?, ?)',
    updateUserRate: 'update mutualrate set rate = ?, updateTime = ? where id = ?',
    getCurMutualRate: 'select ml.*, u.name as ratedPersionName, u.duty from mutualrate ml left join users u on ml.ratePersion = u.id where ' +
        'ml.ratedPersion = ? and ml.rateMonth = ?',
    getRateData: 'select ml.*, u.duty, u.groupName from mutualrate ml left join users u on ml.ratedPersion = u.id ' +
        'where ml.ratePersion = ? and ml.rateMonth = ?',
    getRateDataByRatePersion: 'select * from mutualrate where ratePersion = ? and rateMonth = ?',
    getPerformanceIsCount: 'select * from globalflag where year(setTime) = ? and month(setTime) = ? and flagType = ?',
    getMonthEva: 'select mr.*, u.name as ratedPersionName from mutualrate mr left join users u on mr.ratedPersion = ' +
        'u.id where mr.rateMonth = ? and mr.ratePersion = ? and u.status != 0',
    handleFillMul: 'select count(*) as totalCount from mutualrate where ratePersion = ? and rateMonth = ?',
    handleFillMulCheck: 'select * from mutualrate where ratePersion = ? and rateMonth = ?',
    handleFillMulFill: 'insert into mutualrate (ratePersion, ratedPersion, rateMonth, rate, rateType, rateTime, updateTime) ' +
        'values (?, ?, ?, ?, ?, ?, ?)',
    getPerformanceRates: 'select pr.*, u.name as ratedPersionName, u.duty from performancerate pr left join users u on pr.ratedPersion = u.id ' +
        'where pr.ratePersion = ? and pr.rateMonth = ? and u.status != 0',
    getPerformanceRatedData: 'select pr.*, u.duty, u.groupName from performancerate pr left join users u on pr.ratePersion = u.id where ' +
        'pr.ratedPersion = ? and pr.rateMonth = ?',
    getAllQTEvaedData: 'select ml.*, u.duty as ratePersionDuty from mutualrate ml left join users u on ml.ratePersion' +
        ' = u.id where ml.ratedPersion = ? and ml.rateMonth = ?'
  },
  conclusion: {
    getCurMonthConclusionOverviewData: 'select c.*, u.name from conclusion c left join users u on c.submitter = u.id where c.submitYear = ? ' +
        'and c.submitMonth = ? and c.submitter = ? and c.obsoleteStatus != 1',
    submitMonthConclusionData: 'insert into conclusion (conclusionType, submitter, conclusionTitle, submitTime, ' +
        'updateTime, submitYear, submitMonth, submitStatus, managerRateStar, curConclusion, nextPlan, curAdvice) ' +
        'values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
    updateMonthConclusionData: 'update conclusion set conclusionType = ?, conclusionTitle = ?, updateTime = ?, ' +
        'submitYear = ?, submitMonth = ?, submitStatus = ?, curConclusion = ?, nextPlan = ?, curAdvice = ? where id = ?',
    updateMonthConclusionStatus: 'update conclusion set submitStatus = ?, updateTime = ? where id = ?',
    submitEvaData: 'update conclusion set managerRateStar = ?, getWorkTime = ?, managerEva = ?, evaTime = ?, evaStatus = ?' +
        ' where id = ?',
    updateWorkTimeListIdOfConclusion: 'update conclusion set workTimeListId = ? where id = ?',
    submitMonthConclusionNew: 'insert into newconclusion (userID, conclusionType, conclusionYear, conclusionMonth,' +
    ' dimension, content, submitTime, updateTime, submitStatus) values (?, ?, ?, ?, ?, ?, ?, ?, ?)',
    updateMonthConclusionNew: 'update newconclusion set content = ?, submitStatus = ?, updateTime = ? where id = ?',
    getCurMonthConclusionOverviewDataNew: 'select nc.*, u.name from newconclusion nc left join users u on' +
    ' nc.userID = u.id where nc.conclusionYear = ? and nc.conclusionMonth = ? and nc.userID in (?)',
    getCurMonthConclusionOverviewDataNewV2: 'select nc.*, u.name from newconclusion nc left join users u on' +
    ' nc.userID = u.id where nc.conclusionYear = ? and nc.conclusionMonth = ? and nc.userID in (?) and nc.dimension != 3',
    getPreMonthConclusionOverviewDataNewV2: 'select nc.*, u.name from newconclusion nc left join users u on' +
    ' nc.userID = u.id where nc.conclusionYear = ? and nc.conclusionMonth = ? and nc.userID in (?) and nc.dimension = 3'
  },
  achievementsEva: {
    getUserofAchievementToAnotherUser: 'select nce.*, u.name, nc.userID as evaedUserID from newconclusionevadata nce left join users u on' +
                        ' nce.evaUserID = u.id left join newconclusion nc on nce.dimensionID = nc.id where nce.dimensionID in (?) and evaUserID = ?',
    submitAMEvaData: 'insert into newconclusionevadata (evaUserID, dimensionID, evaStar, submitTime, updateTime)' +
                    ' values (?, ?, ?, ?, ?)',
    updateAMEvaData: 'update newconclusionevadata set evaStar = ?, updateTime = ? where id = ?',
    getAchievementEvaOfConclusionDimension: 'select nc.*, n.userID as evaedUserID, n.dimension from newconclusionevadata' +
                     ' nc left join newconclusion n on nc.dimensionID = n.id where nc.dimensionID = ?',
    getUserConclusionEvaedData: 'select n.userID as evaedUserID, n.dimension, nc.*, u1.duty as evaedUserDuty, u1.name as evaedUserName,' +
                     ' u1.groupName as evaedUserGroupID, u2.name as evaUserName, u2.duty as evaUserDuty, u2.groupName as evaUserGroupID' +
                     ' from newconclusionevadata nc left' +
                     ' join newconclusion n on' +
                     ' n.id = nc.dimensionID left join users u1 on n.userID = u1.id left join users u2 on nc.evaUserID = u2.id' +
                     ' where n.userID = ? and n.conclusionYear = ? and n.conclusionMonth = ? and n.dimension != 3 and n.dimension != 4',
    getOtherUserConclusionEvaedData: 'select nce.*, u.name as evaUserName, u.duty as evaUserDuty, u.groupName as' +
                     ' evaUserGroupID, nc.dimension, nc.userID as evaedUserID from newconclusionevadata nce left' +
                     ' join users u on nce.evaUserID = u.id left join' +
                     ' newconclusion nc on nce.dimensionID = nc.id where nce.dimensionID in (?)'
  }
}
module.exports = sqlMap;
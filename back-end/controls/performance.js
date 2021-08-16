const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')
const $workStation = require('./workStation')

function formatData(rows) {
    return rows.map(row => {
        if(row.create_time) {
            row.create_time = $time.formatTime(row.create_time)
        }
        if(row.update_time) {
            row.update_time = $time.formatTime(row.update_time)
        }
        if (row.submitTime) {
            row.submitTime = $time.formatTime(row.submitTime)
        }
        if (row.updateTime) {
            row.updateTime = $time.formatTime(row.updateTime)
        }
        if (row.reviewTime) {
            row.reviewTime = $time.formatTime(row.reviewTime)
        }
        if (row.groupName) {
            switch (row.groupName) {
                case 1:
                    row.groupName = '技术标准组'
                    break
                case 2:
                    row.groupName = '工程组'
                    break
                case 3:
                    row.groupName = '通信组'
                    break
                case 4:
                    row.groupName = '处经理'
                    break
            }
        }
        let type = row.type
        if(type){
            switch(type) {
                case 1:
                    row.role = '管理员'
                    break
                case 2:
                    row.role = '普通用户'
                    break
            }
        }
        return Object.assign({}, row)
    })
}

function workTimeAssignDelete(id) {
    return new Promise(function (resolve, reject) {
        let sql = $sql.performance.deleteWorkAssign
        let arrayParams = [id]
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData)
            } else {
                result = JSON.parse(JSON.stringify(result))
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData)
            }
        })
    })

}

function workTimeAssign(projectInsertID, data, i, j) {
    return new Promise(function(resolve, reject) {
        let sql = null
        let userID = data.data[i].workTimeAssign[j].id
        let projectID = projectInsertID
        let workTime = data.data[i].workTimeAssign[j].assignWorkTime
        let assignRole = data.data[i].workTimeAssign[j].applyRole
        let reviewWorkTime = data.data[i].workTimeAssign[j].reviewWorkTime
        let arrayParams = []
        if (data.submitType === 'insert') {
            sql = $sql.performance.addWorkAssign
            arrayParams = [userID, projectID, workTime, assignRole, reviewWorkTime]
        } else if (data.submitType === 'update') {
            if (j + 1 > data.data[i].workTimeAssignInsertID.length) {
                sql = $sql.performance.addWorkAssign
                arrayParams = [userID, projectID, workTime, assignRole, reviewWorkTime]
            } else {
                sql = $sql.performance.updateWorkAssignEdit
                arrayParams = [userID, projectID, workTime, assignRole, reviewWorkTime, data.data[i].workTimeAssignInsertID[j]]
            }
        }
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData)
            } else if (result.affectedRows !== 1) {
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData);
            } else {
                result = JSON.parse(JSON.stringify(result))
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData);
            }
        })
    })
}

function workTimeInsertOP(params, i, operate) {
    return new Promise(function(resolve, reject) {
        let submitTime = $time.formatTime()
        let sql = null
        let arrayParams = []
        let submitID = params.userId
        let applyMonth = params.submitDate
        let projectTypeID = params.data[i].projectTypeID
        let applyKValue = params.data[i].defaultKValue
        let reviewKValue = params.data[i].reviewKValue
        let applyCofficient = params.data[i].defaultCofficient
        let reviewCofficient = params.data[i].reviewCofficient
        let avaiableWorkTime = params.data[i].avaiableWorkTime
        let applyProcess = params.data[i].applyProcess
        let lastProcess = params.data[i].lastProcess
        let monthID = params.data[i].monthID
        let applyType = params.applyType
        let applyBaseWorkTime = params.data[i].baseWorkTime
        let updateTime = $time.formatTime()
        let submitStatus = null
        let reviewStatus = 0
        if (operate === '1') { // 提交
            submitStatus = 1
        } else { // 暂存
            submitStatus = 0
        }
        let submitComments = params.data[i].submitComments
        if (params.submitType === 'insert') {  //新增
            let apdID = params.data[i].apdID
            let aplID = params.data[i].aplID
            sql = $sql.performance.addProject
            arrayParams = [submitID, projectTypeID, applyKValue, reviewKValue, applyCofficient, reviewCofficient, submitTime,
                updateTime, applyMonth, submitStatus, submitComments, avaiableWorkTime, applyProcess, apdID, aplID, monthID,
                applyType, lastProcess, applyBaseWorkTime]
        } else if (params.submitType === 'update') { //更新
            applyBaseWorkTime = params.data[i].applyBaseWorkTime
            if (operate === '1') { // 提交
                sql = $sql.performance.updateRejectProject
                arrayParams = [submitID, projectTypeID, applyKValue, reviewKValue, applyCofficient, reviewCofficient, updateTime, applyMonth,
                    submitStatus, reviewStatus, submitComments, applyProcess, avaiableWorkTime, applyBaseWorkTime, params.projectID]
            } else { // 暂存
                sql = $sql.performance.updateProject
                arrayParams = [submitID, projectTypeID, applyKValue, reviewKValue, applyCofficient, reviewCofficient, updateTime, applyMonth,
                    submitStatus, submitComments, applyProcess, avaiableWorkTime, applyBaseWorkTime, params.projectID]
            }
        }
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData)
            } else if (result.affectedRows !== 1 && params.submitType === 'insert') {
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData);
            } else {
                result = JSON.parse(JSON.stringify(result))
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData);
            }
        })
    });
}

async function workTimeInsert(sendData, res, operate) {
    let workTimeInsertResult = null
    let workTimeAssignResult = null
    for (let i = 0; i < sendData.data.length; i++) { // 逐条插入工时项目
        workTimeInsertResult = await workTimeInsertOP(sendData, i, operate)
        if (workTimeInsertResult.err) {
            return $http.writeJson(res, {code: -2, message: '失败', errMsg: workTimeInsertResult.err})
        } else if (workTimeInsertResult.result.affectedRows !== 1 && sendData.submitType === 'insert') {
            return $http.writeJson(res, {code: 2, message: '添加工时记录失败'})
        }
        // 插入/更新工时分配信息
        for (let j = 0;j < sendData.data[i].workTimeAssign.length; j++) {
            let insertID = null
            if (sendData.submitType === 'insert') {
                insertID = workTimeInsertResult.result.insertId
            } else if (sendData.submitType === 'update') {
                insertID = sendData.projectID
            }
            workTimeAssignResult = await workTimeAssign(insertID, sendData, i, j)
            if (workTimeAssignResult.err) {
                return $http.writeJson(res, {code: -2, message: '失败', errMsg: workTimeInsertResult.err})
            } else if (workTimeAssignResult.result.affectedRows !== 1 && sendData.submitType === 'insert') {
                return $http.writeJson(res, {code: 2, message: '添加协作记录失败'})
            }
            if (i === sendData.data.length - 1 && j === sendData.data[i].workTimeAssign.length - 1) {
                // 更新的工时分配信息小于修改前
                if (sendData.submitType === 'update') {
                    if (sendData.data[i].workTimeAssign.length < sendData.data[i].workTimeAssignInsertID.length) {  //更新的工时分配信息条数小于修改前，删除多余的条目
                        for (let k = 0; k < sendData.data[i].workTimeAssignInsertID.length - sendData.data[i].workTimeAssign.length; k++) {
                            await workTimeAssignDelete(sendData.data[i].workTimeAssignInsertID[sendData.data[i].workTimeAssign.length + k])
                        }
                    }
                }
                let result = {insertID: insertID}
                return $http.writeJson(res, {code: 1, data: result,message: '提交成功'})
            }
        }
    }
}

function workTimeInsertTmp(sendData, operate) {
    let promises1 = []
    let promises2 = []
    let count1 = 0
    let count2 = 0
    return new Promise(function (resolve, reject) {
        for (let i = 0; i < sendData.data.length; i++) { // 逐条插入工时项目
            promises1[count1++] = workTimeInsertOP(sendData, i, operate)
        }
        Promise.all(promises1).then(result1 => {
            // 插入/更新工时分配信息
            for (let i = 0; i < sendData.data.length; i++) {
                for (let j = 0;j < sendData.data[i].workTimeAssign.length; j++) {
                    let insertID = null
                    if (sendData.submitType === 'insert') {
                        insertID = result1[i].result.insertId
                    } else if (sendData.submitType === 'update') {
                        insertID = sendData.projectID
                    }
                    promises2[count2++] = workTimeAssign(insertID, sendData, i, j)
                }
            }
            Promise.all(promises2).then(result2 => {
                resolve(result2)
            }).catch(err2 => {
                reject(new Error(err2))
            })
        })
    })
}

function getGroupID(groupName) {
    switch (groupName) {
        case '技术标准组':
            return 1
        case '工程组':
            return 2
        case '通信组':
            return 3
        default:
            return -1
    }
}

function projectTypeRecursion(params) {
    return new Promise(function (resolve, reject) {
        let sql = $sql.performance.selectProjectType
        for (let i = 0; i < params.length; i++) {
            let arrayParams = [params[i].projectTypeID]
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    return $http.writeJson(res, {code:-2, message:'失败'})
                } else {
                    result = JSON.stringify(result)
                    result = JSON.parse(result)
                    if (result.length !== 0) {
                        params[i].children = result
                        projectTypeRecursion(result)
                    }
                }
            })
        }
    })
}

function updateWorkTimeAssign(data) {
    return new Promise(function (resolve, reject) {
        let reviewWorkTime = data.reviewWorkTime
        let id = data.id
        let sql = $sql.performance.updateWorkAssign
        let arrayParams = [reviewWorkTime, id]
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData)
            } else {
                result = JSON.parse(JSON.stringify(result))
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData);
            }
        })
    })
}

function fGetUnReviewProjectOP(data, applyMonth, type) {
    return new Promise(function (resolve, reject) {
        let sqlGetUnReviewProjectTotal = $sql.performance.getUnReviewProjecTotal
        let sqlGetReviewedProjectTotal = $sql.performance.getReviewedProjecTotal
        let arrayParams = [data.id, applyMonth, data.id, applyMonth]
        let sql = sqlGetUnReviewProjectTotal + ';' + sqlGetReviewedProjectTotal
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData)
            } else {
                result = JSON.parse(JSON.stringify(result))
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData);
            }
        })
    })
}

function updateProjectWorkTimeAssignReviewStatus (projectID, status) {
    return new Promise(function (resolve, reject) {
        let sql = $sql.performance.updateProjectWorkTimeAssignReviewStatus
        let arrayParams = [status, projectID]
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData)
            } else {
                result = JSON.parse(JSON.stringify(result))
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData);
            }
        })
    })
}

function getWorkTimeNewOP (checkID, sql, req, res) {
    return new Promise(function (resolve, reject) {
        $http.userVerify(req, res, () => {
            $http.connPool(sql, checkID, (err, result) => {
                if (err) {
                    reject(-1)
                } else {
                    result = JSON.parse(JSON.stringify(result))
                    let obj = {
                        projectTypeID: result[0].projectTypeID,
                        workTime: result[0].workTime,
                        dynamicKValue: result[0].dynamicKValue,
                        projectName: result[0].projectName,
                        isConference: result[0].isConference,
                        defaultAssignWorkTime: result[0].defaultAssignWorkTime
                    }
                    resolve(obj)
                }
            })
        })
    })
}

function getFullProjectTypeOPSQL(sql, arrayParams) {
    return new Promise(function(resolve, reject) {
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData)
            } else {
                result = JSON.parse(JSON.stringify(result))
                let returnData = {
                    result: result,
                    err: err
                }
                resolve(returnData);
            }
        })
    });
}

async function getFullProjectType(res, projectTypeID, resultData) {
    if (projectTypeID !== 0 && projectTypeID !== 1 && projectTypeID !== 2 && projectTypeID !== 3) {
        let sql = $sql.performance.getFullProjectType
        let arrayParams = [projectTypeID]
        resultData.projectTypeCheck.push(projectTypeID) // 存储项目类型结构
        let checkResult = await getFullProjectTypeOPSQL(sql, arrayParams)
        if (checkResult.result[0].workTime !== 0) {  // 保存最后一级项目类型
            resultData.projectName = checkResult.result[0].projectName
            resultData.workTime = checkResult.result[0].workTime
            resultData.dynamicKValue = checkResult.result[0].dynamicKValue
            resultData.isConference = checkResult.result[0].isConference
            resultData.defaultAssignWorkTime = checkResult.result[0].defaultAssignWorkTime
        }
        if (checkResult.err) {
            return $http.writeJson(res, {code: -2, message: '失败', errMsg: checkResult.err})
        }
        await getFullProjectType(res, checkResult.result[0].projectParentID, resultData)  // 递归查询项目类型结构
    } else {
        resultData.projectTypeCheck.reverse()
        return $http.writeJson(res, {code: 1, data: resultData, message: '成功'})
    }
}

async function workTimeAssignReview(data, projectID, res) {
    let workTimeInsertResult = null
    //---------------------- 更新工时分配审核结果--------------------------
    for (let item of data) {
        workTimeInsertResult = await updateWorkTimeAssign(item)
        if (workTimeInsertResult.err) {
            return $http.writeJson(res, {code: -2, message: '失败', errMsg: workTimeInsertResult.err})
        }
    }
    //---------------------- 更新工时项目审核状态--------------------------
    workTimeInsertResult = await updateProjectWorkTimeAssignReviewStatus(projectID, 1)
    if (workTimeInsertResult.err) {
        return $http.writeJson(res, {code: -2, message: '失败', errMsg: workTimeInsertResult.err})
    } else {
        return $http.writeJson(res, {code: 1, message: '成功'})
    }
}

async function fGetUnReviewProject(data, res) {
    let resultData = []
    for (let item of data.searchPerson) {
        let workTimeInsertResult = await fGetUnReviewProjectOP(item, data.applyMonth, data.type)
        if (workTimeInsertResult.err) {
            return $http.writeJson(res, {code: -2, message: '失败', errMsg: workTimeInsertResult.err})
        } else {
            let obj = {
                id: item.id,
                name: item.name,
                unReviewProjectCount: workTimeInsertResult.result[0][0].totalCount,
                reviewedProjectCount: workTimeInsertResult.result[1][0].totalCount
            }
            resultData.push(obj)
        }
    }
    return $http.writeJson(res, {code: 1, data: resultData, message: '成功'})
}

function setWorkTimeListPass(sql, arrayParams) {
    return new Promise(function (resolve, reject) {
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                reject(err)
            } else {
                resolve(result)
            }
        })
    })
}

function updateProjectProcess(data, monthProcessExistParam) {
    let monthProcessExist = null
    if (monthProcessExistParam) {
        monthProcessExist = monthProcessExistParam[0]
    }
    return new Promise(function (resolve, reject) {
        let param = {}
        if (!monthProcessExist) {
            param = {
                id: data.monthID,
                kValue: data.reviewKValue,
                coefficient: data.reviewCofficient,
                aPDID: data.apdID,
                year: data.applyYear,
                type: 'fact',
                applyProcess: data.applyProcess,
                January: null,
                February: null,
                March: null,
                April: null,
                May: null,
                June: null,
                July: null,
                August: null,
                September: null,
                October: null,
                November: null,
                December: null,
            }
        } else {
            monthProcessExist.kValue = data.reviewKValue
            monthProcessExist.coefficient = data.reviewCofficient
            monthProcessExist.applyProcess = data.applyProcess
            param = monthProcessExist
        }
        param[data.applyMonthString] = data.applyProcess
        $workStation.saveProcess(param).then(res0 => {
            $workStation.projectStageProcessCal(data.apdID, data.applyYear).then(res1 => { //计算该阶段进展
                $workStation.projectStageProcessUpdate(data.apdID, res1).then(res2 => { //更新该阶段进展
                    $workStation.projectProcessCal(res2).then(res3 => { //计算项目总进展
                        $workStation.projectProcessUpdate(res2, res3).then(() => { //更新项目总进展
                            resolve(res0)
                        })
                    })
                })
            })
        })
    })
}

function getMonthProcessByID(id) {
    return new Promise(function (resolve, reject) {
        let sql = $sql.workStation.getMonthProcessByID
        let arrayParams = [id]
        $http.connPool(sql, arrayParams, (err, result) =>{
            if (err) {
                reject(-1)
            } else {
                result = JSON.parse(JSON.stringify(result))
                resolve(result)
            }
        })
    })
}

function RCPDDatabase(sql, arrayParams) {
    return new Promise(function (resolve, reject) {
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                reject(err)
            } else {
                result = JSON.parse(JSON.stringify(result))
                resolve(result)
            }
        })
    })
}

 // 更新项目月工时申报状态
function updateAssignProjectFilled (assignProjectID) {
    let sql = $sql.workStation.updateAssignProjectFilled
    let arrayParams = [assignProjectID]
    return new Promise(function (resolve, reject) {
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            RCPDDatabaseRes = JSON.parse(JSON.stringify(RCPDDatabaseRes))
            resolve(RCPDDatabaseRes)
        }).catch(RCPDDatabaseErr => {
            reject(RCPDDatabaseErr)
        })
    })
}

function deleteExistWorkTimeSubmit(workTimeSubmitData) {
    let promises = []
    let count = 0
    return new Promise(function (resolve, reject) {
        for (let workTimeSubmitDataItem of workTimeSubmitData) {
            if (workTimeSubmitDataItem.isApplyWorkTime > 0) {
                for (let workTimeSubmitDataItemID of workTimeSubmitDataItem.id) {
                    let sqlDeleteProject = $sql.performance.deleteProject
                    let deleteWorkTimeAssign = $sql.performance.deleteWorkTimeAssign
                    let arrayParams = [workTimeSubmitDataItemID, workTimeSubmitDataItemID]
                    let sql = sqlDeleteProject + ';' + deleteWorkTimeAssign
                    promises[count++] = RCPDDatabase(sql, arrayParams)
                }
            }
        }
        if (count > 0) {
            Promise.all(promises).then(result => {
                resolve(result)
            }).catch(error => {
                reject(new Error(error))
            })
        } else {
            resolve()
        }
    })
}

const performance = {
    // 加周报 start
    add (req, res) {
        let params = req.body
        $http.userVerify(req, res, () => {
            let curTime = $time.formatTime()
            let userId = params.userId
            let title = params.title
            let workType = params.workType
            let workTime = params.workTime
            let participants = params.participants
            if(!title || !workType || !workTime || !participants) $http.writeJson(res, {code: 2, message:'参数有误'})
            else {
                let sql = $sql.performance.add
                let arrayParams = [userId, title, workType, workTime, participants]
                $http.connPool(sql, arrayParams, (err, result) => {
                    if(err) return $http.writeJson(res, {code:-2, message:'失败',errMsg: err})
                    if(result.affectedRows != 1) return $http.writeJson(res, {code: 2, message:'添加失败'})
                    return $http.writeJson(res, {code: 1, message: '工时申报成功'})
                })
            }
        })
    },
    // 找申报工时类型
    workTypeList (req, res) {
        let params = req.body
        let sql = ''
        let arrayParams = []
        if (params.queryType === 1) {
            sql = $sql.performance.selectWorkTypeList
        }
        else if (params.queryType === 2) {
            sql = $sql.performance.selectSubWorkType1List
        }
        else if (params.queryType === 3) {
            sql = $sql.performance.selectSubWorkType2List
        }
        else if (params.queryType === 4) {
            sql = $sql.performance.selectSubWorkType3List
        }
        $http.userVerify(req, res, () => {
            let pageNum = params.pageNum
            let pageSize = !params.pageSize ? 10 : params.pageSize
            if(!pageNum) {
                $http.writeJson(res, {code: 2, message:'参数有误'})
            } else {
                // 分页查询入参 start
                let limitFirst = (pageNum-1)*pageSize;
                let limitLast = pageSize;
                // 分页查询入参 end
                sql += " order by id limit ?,?"; // id倒序排
                if (params.queryType === 1) {
                    arrayParams = [limitFirst, limitLast]
                }
                else if (params.queryType === 2) {        // 申报子类型1
                    arrayParams = [params.workTypeLabel, limitFirst, limitLast]
                }
                else if (params.queryType === 3) {        // 申报子类型2
                    arrayParams = [params.subWorkTypeL1abel, limitFirst, limitLast]
                }
                else if (params.queryType === 4) {        // 申报子类型3
                    arrayParams = [params.subWorkTypeL1abel, params.subWorkTypeL2abel, limitFirst, limitLast]
                }
                $http.connPool(sql, arrayParams, (err, result) => {
                    if(err) {
                        return $http.writeJson(res, {code:-2, message:'失败'})
                    } else {
                        let resultData = {}
                        resultData.list = result
                        return $http.writeJson(res, {code: 1, data: resultData, message: '获取列表成功'})
                    }
                })
            }
        })
    },
    // 计算工时数
    getWorkTime (req, res) {
        let params = req.body
        let sql = ''
        let arrayParams = []
        let resultData = {
            subWorkType3Label: [],
            workTime: [],
            dynamicKValue: [],
            defaultKValue: [],
            defaultCofficient:[]
        }
        $http.userVerify(req, res, () => {
            for (let i = 0; i < params.selectWorkTypeNum; i++) {
                sql = $sql.performance.selectWorkTime
                arrayParams = [params.subWorkType1Label[i], params.subWorkType3Label[i]]
                $http.connPool(sql, arrayParams, (err, result) => {
                    if(err) {
                         return $http.writeJson(res, {code:-2, message:'失败'})
                    } else {
                        result = JSON.stringify(result)
                        result = JSON.parse(result)
                        resultData.subWorkType3Label.push(params.subWorkType3Label[i])
                        resultData.workTime.push(result[0].workTime)
                        resultData.dynamicKValue.push(result[0].dynamicKValue)
                        resultData.defaultKValue.push(result[0].defaultKValue)
                        resultData.defaultCofficient.push(result[0].defaultCofficient)
                        if (i === params.selectWorkTypeNum - 1) {
                            return $http.writeJson(res, {code: 1, data: resultData, message: '获取列表成功'})
                        }
                    }
                })
            }
        })
    },
    // 获取项目类型
    getProjectType (req, res) {
        let params = req.body
        let sql = ''
        let arrayParams = []
        let resultData = []
        let groupID = null
        $http.userVerify(req, res, () => {
            groupID = getGroupID(params.projectParentID)
            sql = $sql.performance.selectProjectTypeFirst
            arrayParams = [groupID]
            $http.connPool(sql, arrayParams, (err, result) => {
                if(err) {
                    return $http.writeJson(res, {code:-2, message:'失败'})
                } else {
                    result = JSON.stringify(result)
                    result = JSON.parse(result)
                    setTimeout(function () {
                        return $http.writeJson(res, {code: 1, data: result, message: '获取列表成功'})
                    }, 1000)
                    projectTypeRecursion(result)
                }
            })
        })
    },
    // 获取项目类型对应的工时详情
    async getWorkTimeNew (req, res) {
        let data = req.body
        let sql = $sql.performance.selectProjectTime
        let resultData = []
        for (let i = 0; i < data.checkID.length; i++) {
            await getWorkTimeNewOP(data.checkID[i], sql, req, res).then(result => {
                resultData.push(result)
                if (i === data.checkID.length - 1) {
                    getWorkTimeNewOP(data.parentID, sql, req, res).then(result => {
                        resultData.push(result.projectName)
                        return $http.writeJson(res, {code: 1, data: resultData, message: '获取列表成功'})
                    })
                }
            })
        }
    },
    // 新增工时申报
    workTimeSubmit (req, res) {
        let data = req.body
        workTimeInsert(data, res, '1').then()
    },
    // 暂存工时申报
    workTimeTemporary (req, res) {
        let data = req.body
        workTimeInsert(data, res, '0')
    },
    // 获取工时申报详情
    getProjectList (req, res) {
        let data = req.body
        $http.userVerify(req, res, () => {
            let searchID = data.searchID
            let searchMon = data.searchMon
            let pageNum = data.pageNum
            let pageSize = data.pageSize
            // 分页查询入参 start
            let limitFirst = (pageNum - 1) * pageSize
            let limitLast = pageSize
            let arrayParams = [searchID, searchMon, searchID, searchMon]
            let sqlGetProjectList = $sql.performance.getProjectList
            let sqlGetProjectTotal = $sql.performance.getProjectListTotal
            let sql = ''
            if (data.searchType === 'review') {  //审核页面请求
                if (data.reviewType === 'unReview') {
                    sql= sqlGetProjectTotal + ' and reviewStatus = 0' + '; ' +
                        sqlGetProjectList + ' and wl.submitStatus = 1' + ' and wl.reviewStatus = 0'
                } else if (data.reviewType === 'reviewed') {
                    sql= sqlGetProjectTotal + ' and reviewStatus != 0' + '; ' +
                        sqlGetProjectList + ' and wl.submitStatus = 1' + ' and wl.reviewStatus != 0'
                }
            } else {  //申报页面请求
                sqlGetProjectTotal = $sql.performance.getProjectListTotalNew
                sqlGetProjectList = $sql.performance.getProjectListNew
                sql= sqlGetProjectTotal + '; ' + sqlGetProjectList
                arrayParams = [searchID, searchMon, searchID, searchMon]
            }
            sql = sql + " order by submitTime desc" // 提交时间倒序排
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    return $http.writeJson(res, {code:-2, message:'失败'})
                } else {
                    let resultData = {}
                    resultData.totalCount = result[0][0]['totalCount']
                    resultData.list = formatData(result[1])
                    return $http.writeJson(res, {code: 1, data: resultData, message: '获取工时申报成功'})
                }
            })
        })
    },
    // 获取工时分配信息
    getWorkAssign (req, res) {
        let data = req.body
        $http.userVerify(req, res, () => {
            let checkID = data.projectID
            let sql = $sql.performance.getWorkAssign
            let arrayParams = [checkID]
            if (data.searchType === 'applyer') {
                let sqlGetReviewStatus = $sql.performance.getReviewStatus
                sql = sql + ';' + sqlGetReviewStatus
                arrayParams.push(checkID)
            }
            $http.connPool(sql, arrayParams, (err, result) =>{
                if (err) {
                    return $http.writeJson(res, {code: -2, message: '失败'})
                } else {
                    if (data.searchType === 'applyer') {
                        result[0] = formatData(result[0])
                        result[1] = formatData(result[1])
                    } else {
                        result = formatData(result)
                    }
                    return $http.writeJson(res, {code: 1, data: result, message: '获取工时分配成功'})
                }
            })
        })
    },
    // 获取项目信息
    getProjectInfo (req, res) {
        let data = req.body
        $http.userVerify(req, res, () => {
            let checkID = data.id
            let sqlGetProjectInfo = $sql.performance.getProjectInfo
            let sqlGetWorkAssignInfo = $sql.performance.getWorkAssignInfo
            let sql = sqlGetProjectInfo + ';' + sqlGetWorkAssignInfo
            let arrayParams = [checkID, checkID]
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    return $http.writeJson(res, {code: -2, message: '失败'})
                } else {
                    let resultData = {}
                    resultData.workTimeList = formatData(result[0])
                    resultData.workTimeAssign = formatData(result[1])
                    resultData.projectTypeCheck = []
                    getFullProjectType(res, resultData.workTimeList[0].projectTypeID, resultData)
                }
            })
        })
    },
    // 改变提交状态
    changeSubmitStatus (req, res) {
        let data = req.body
        let sql = $sql.performance.changeSubmitStatus
        let arrayParams = [data.submitStatus, data.id]
        if (data.submitStatus) {
            let updateTime = $time.formatTime()
            let reviewStatus = 0
            sql = $sql.performance.changeRejectProjectSubmitStatus
            arrayParams = [data.submitStatus, updateTime, reviewStatus, data.id]
        }
        $http.userVerify(req, res, () => {
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    return $http.writeJson(res, {code: -2, message: '失败'})
                } else {
                    return $http.writeJson(res, {code: 1, message: '改变提交状态成功'})
                }
            })
        })
    },
    // 删除项目
    deleteProject (req, res) {
        $http.userVerify(req, res, () => {
            let data = req.body
            let sqlDeleteProject = $sql.performance.deleteProject
            let deleteWorkTimeAssign = $sql.performance.deleteWorkTimeAssign
            let arrayParams = [data.id, data.id]
            let sql = sqlDeleteProject + ';' + deleteWorkTimeAssign
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    return $http.writeJson(res, {code: -2, message: '失败'})
                } else {
                    return $http.writeJson(res, {code: 1, message: '删除成功'})
                }
            })
        })
    },
    // 提交工时分配审核结果
    updateWorkTimeAssignReview (req, res) {
        $http.userVerify(req, res, () => {
            let data = req.body
            workTimeAssignReview(data.reviewResult, data.projectID, res).then()
        })
    },
    // 获取待审数量
    getUnReviewProjectCount (req, res) {
        $http.userVerify(req, res, () => {
            let data = req.body
            fGetUnReviewProject(data, res).then()
        })
    },
    // 审核通过
    submitReviewPass (req, res) {
        $http.userVerify(req, res, () => {
            let curTime = $time.formatTime()
            let data = req.body
            let sql = null
            let arrayParams = []
            if (data.reviewStatus === 1) { // 审核通过
                if (data.monthID === null) {  // 月份进展无记录时
                    updateProjectProcess(data, null).then(res0 => {
                        sql = $sql.performance.submitReviewPass
                        arrayParams = [data.reviewKValue, data.reviewCofficient, data.reviewStatus, curTime, data.reviewComments,
                            data.reviewer, res0.monthID, data.id]
                        setWorkTimeListPass(sql, arrayParams).then(() => {
                            return $http.writeJson(res, { code: 1, message: '成功' })
                        })
                    })
                } else { // 更新已有的月份进展
                    getMonthProcessByID(data.monthID).then(res0 => { // 获取已有月份进展
                        updateProjectProcess(data, res0).then(res1 => {
                            sql = $sql.performance.submitReviewPass
                            arrayParams = [data.reviewKValue, data.reviewCofficient, data.reviewStatus, curTime, data.reviewComments,
                                data.reviewer, res1.monthID, data.id]
                            setWorkTimeListPass(sql, arrayParams).then(() => {
                                return $http.writeJson(res, { code: 1, message: '成功' })
                            })
                        })
                    })
                }
            } else { // 撤回或者驳回
                sql = $sql.performance.submitReviewRejectOrWithdraw
                arrayParams = [data.reviewKValue, data.reviewCofficient, data.reviewStatus, curTime, data.reviewComments, data.reviewer,
                    data.id]
                setWorkTimeListPass(sql, arrayParams).then(() => {
                    return $http.writeJson(res, { code: 1, message: '成功' })
                })
            }
        })
    },
    // 获取分配的工时
    async getAssignWorkTime (req, res) {
        $http.userVerify(req, res, async () => {
            let data = req.body
            let sql = $sql.performance.getAssignWorkTime
            let arrayParams = []
            let resultData = []
            for (let item of data.projectData) {
                arrayParams = [item.id, data.userID]
                await RCPDDatabase(sql, arrayParams).then(res0 => {
                    res0[0].index = item.index
                    resultData.push(res0[0])
                })
            }
            return $http.writeJson(res, {code: 1, data: resultData, message: '成功'})
        })
    },
    // 获取小组申报工时列表
    getGroupWorkTimeList (req, res) {
        $http.userVerify(req, res, () => {
            let data = req.body
            let sql = $sql.performance.getGroupWorkTimeList
            let arrayParams = [data.applyMonth, data.groupID]
            RCPDDatabase(sql, arrayParams).then(result => {
                return $http.writeJson(res, {code: 1, data: result, message: '失败'})
            }).catch(err => {
                return $http.writeJson(res, {code: -2, message: '失败', errMsg: err})
            })
        })
    },
    // 获取全处已审工时列表
    getAllWorkTimeList (req, res) {
        let sendData = req.body
        let sql = $sql.performance.getAllWorkTimeList
        let arrayParams = [sendData.applyMonth]
        RCPDDatabase(sql, arrayParams).then(result => {
            return $http.writeJson(res, {code: 1, data: result, message: '失败'})
        }).catch(err => {
            return $http.writeJson(res, {code: -2, message: '失败', errMsg: err})
        })
    },
    // 判断工时是否都已审核完毕
    getIsWorkTimeReviewFinish (req, res) {
        let sendData = req.body
        let sql = $sql.performance.getIsWorkTimeReviewFinish
        let arrayParams = [sendData.applyMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, data: RCPDDatabaseErr, message: 'err'})
        })
    },
    // 获取当前可申报的月份
    getCurApplyAbleMonth (req, res) {
        let sql = $sql.performance.getCurApplyAbleMonth
        let arrayParams = []
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, data: RCPDDatabaseErr, message: 'err'})
        })
    },
    // 提交项目工时申报
    submitProjectWorkTimeApply (req, res) {
        let sendData = req.body
        sendData.workTimeInfo.userId = sendData.userId
        workTimeInsertTmp(sendData.workTimeInfo, '1').then(() => {
            deleteExistWorkTimeSubmit(sendData.workTimeInfo.data).then(() => {
                updateAssignProjectFilled(sendData.projectID).then((updateAssignProjectFilledRes) => {
                    return $http.writeJson(res, {code: 1, data: updateAssignProjectFilledRes, message: 'success'})
                }).catch(updateAssignProjectFilledErr => {
                    return $http.writeJson(res, {code: -2, data: updateAssignProjectFilledErr, message: 'err'})
                })
            }).catch(deleteExistWorkTimeSubmitErr => {
                return $http.writeJson(res, {code: -2, data: deleteExistWorkTimeSubmitErr, message: 'err'})
            })
        }).catch(workTimeInsertTmpErr => {
            return $http.writeJson(res, {code: -2, data: workTimeInsertTmpErr, message: 'err'})
        })
    },
    // 修复错误数据
    repairErrorData3 (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.repairErrorData3Check
        let arrayParams = []
        let promises = []
        let promises2 = []
        let promise3 = []
        let count = 0
        let count2 = 0
        let count3 = 0
        let finalResult = []
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            for (let RCPDDatabaseItem of RCPDDatabaseRes) {
                sql = $sql.workStation.repairErrorData3Check2
                arrayParams = [2021, RCPDDatabaseItem.apdID]
                promises[count++] = RCPDDatabase(sql, arrayParams)
            }
            Promise.all(promises).then(result => {
                result = JSON.parse(JSON.stringify(result))
                for (let i = 0; i < result.length; i++) {
                    if (result[i][0].totalCount === 0) {
                        result[i][0].apdID = RCPDDatabaseRes[i].apdID
                        finalResult.push(result[i])
                    }
                }
                for (let finalResultItem of finalResult) {
                    sql = $sql.workStation.repairErrorData3Check3
                    arrayParams = [finalResultItem[0].apdID]
                    promises2[count2++] = RCPDDatabase(sql, arrayParams)
                }
                Promise.all(promises2).then(result2 => {
                    for (let i = 0; i < result2.length; i++) {
                        result2[i][0].totalCount = finalResult[i][0].totalCount
                        result2[i][0].applyYear = 2021
                        result2[i][0].applyMonthString = 'January'
                        // promise3[count3++] = updateProjectProcess(result2[i][0], null)
                    }
                    return $http.writeJson(res, { code: 1, data: result2, message: 'success' })
                    // Promise.all(promise3).then(result3 => {
                    //     return $http.writeJson(res, { code: 1, data: result3, message: 'success' })
                    // })
                })
            })
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, { code: -2, data: RCPDDatabaseErr, message: 'error' })
        })
    },
    // 更新工时条目审核状态
    updateWorkTimeListReviewStatus (req, res) {
        let sendData = req.body
        let sql = $sql.performance.updateWorkTimeListReviewStatus
        let reviewTime = $time.formatTime()
        let arrayParams = [sendData.reviewKValue, sendData.reviewCofficient, sendData.reviewer, reviewTime,
            sendData.reviewStatus, sendData.id, sendData.id]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 获取工时分配信息
    getWorkTimeAssignInfo (req, res) {
        let sendData = req.body
        let sql = $sql.performance.getWorkTimeAssignInfo
        let arrayParams = [sendData.workTimeListId]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 获取工时分配信息
    getWorkTimeListInfo (req, res) {
        let sendData = req.body
        let sql = $sql.performance.getWorkTimeListInfo
        let arrayParams = [sendData.workTimeListId]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    }
}

module.exports = performance
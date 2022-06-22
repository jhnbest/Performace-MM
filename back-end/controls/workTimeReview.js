const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')

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
        let arrayParams = []
        if (data.submitType === 'insert') {
            sql = $sql.performance.addWorkAssign
            arrayParams = [userID, projectID, workTime, assignRole]
        } else if (data.submitType === 'update') {
            if (j + 1 > data.data[i].workTimeAssignInsertID.length) {
                sql = $sql.performance.addWorkAssign
                arrayParams = [userID, projectID, workTime, assignRole]
            } else {
                sql = $sql.performance.updateWorkAssign
                arrayParams = [userID, projectID, workTime, assignRole, data.data[i].workTimeAssignInsertID[j]]
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
        let submitTime = null
        let sql = null
        let arrayParams = []
        let submitID = params.userId
        let applyMonth = params.submitDate
        let projectName = params.data[i].projectName
        let projectTypeID = params.data[i].projectTypeID
        let applyKValue = params.data[i].defaultKValue
        let applyCofficient = params.data[i].defaultCofficient
        let updateTime = $time.formatTime()
        let submitStatus = null
        if (operate === '1') {
            submitStatus = 1
        } else {
            submitStatus = 0
        }
        let submitComments = params.data[i].submitComments
        if (params.submitType === 'insert') {
            submitTime = $time.formatTime()
            sql = $sql.performance.addProject
            arrayParams = [submitID, projectName, projectTypeID, applyKValue, applyCofficient, submitTime, updateTime, applyMonth,
                submitStatus, submitComments]
        } else if (params.submitType === 'update') {
            sql = $sql.performance.updateProject
            arrayParams = [submitID, projectName, projectTypeID, applyKValue, applyCofficient, updateTime, applyMonth,
                submitStatus, submitComments, params.projectID]
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

async function workTimeInsert(data, res, operate) {
    let workTimeInsertResult = null
    let workTimeAssignResult = null
    for (let i = 0; i < data.data.length; i++) {
        workTimeInsertResult = await workTimeInsertOP(data, i, operate);
        if (workTimeInsertResult.err) {
            return $http.writeJson(res, {code: -2, message: '失败', errMsg: workTimeInsertResult.err})
        } else if (workTimeInsertResult.result.affectedRows !== 1 && data.submitType === 'insert') {
            return $http.writeJson(res, {code: 2, message: '添加工时记录失败'})
        }
        // 插入/更新工时分配信息
        for (let j = 0;j < data.data[i].workTimeAssign.length; j++) {
            let insertID = null
            if (data.submitType === 'insert') {
                insertID = workTimeInsertResult.result.insertId

            } else if (data.submitType === 'update') {
                insertID = data.projectID
            }
            workTimeAssignResult = await workTimeAssign(insertID, data, i, j)
            if (workTimeAssignResult.err) {
                return $http.writeJson(res, {code: -2, message: '失败', errMsg: workTimeInsertResult.err})
            } else if (workTimeAssignResult.result.affectedRows !== 1 && data.submitType === 'insert') {
                return $http.writeJson(res, {code: 2, message: '添加协作记录失败'})
            }
            if (i === data.data.length - 1 && j === data.data[i].workTimeAssign.length - 1) {
                // 更新的工时分配信息小于修改前处理
                if (data.submitType === 'update') {
                    if (data.data[i].workTimeAssign.length < data.data[i].workTimeAssignInsertID.length) {  //更新的工时分配信息条数小于修改前，删除多余的条目
                        for (let k = 0; k < data.data[i].workTimeAssignInsertID.length - data.data[i].workTimeAssign.length; k++) {
                            await workTimeAssignDelete(data.data[i].workTimeAssignInsertID[data.data[i].workTimeAssign.length + k])
                        }
                    }
                }
                return $http.writeJson(res, {code: 1, message: '提交成功'})
            }
        }
    }
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
        resultData.projectTypeCheck.push(projectTypeID)
        let checkResult = await getFullProjectTypeOPSQL(sql, arrayParams)
        if (checkResult.result[0].workTime !== 0) {
            resultData.projectName = checkResult.result[0].projectName
            resultData.workTime = checkResult.result[0].workTime
            resultData.dynamicKValue = checkResult.result[0].dynamicKValue
        }
        if (checkResult.err) {
            return $http.writeJson(res, {code: -2, message: '失败', errMsg: checkResult.err})
        }
        await getFullProjectType(res, checkResult.result[0].projectParentID, resultData)
    } else {
        resultData.projectTypeCheck.reverse()
        return $http.writeJson(res, {code: 1, data: resultData, message: '成功'})
    }
}

const performance = {
    /*添加周报 start*/
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
    /*查找申报工时类型*/
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
    /* 计算工时数 */
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
    /* 获取项目类型 */
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
    /* 获取项目类型对应的工时详情 */
    getWorkTimeNew (req, res) {
        let data = req.body
        let sql = ''
        let arrayParams = []
        let resultData = []
        $http.userVerify(req, res, () => {
            for (let i = 0; i < data.checkID.length; i++) {
                sql = $sql.performance.selectProjectTime
                arrayParams = [data.checkID[i]]
                $http.connPool(sql, arrayParams, (err, result) => {
                    if (err) {
                        return $http.writeJson(res, {code:-2, message:'失败'})
                    } else {
                        if (result) {
                            result = JSON.stringify(result)
                            result = JSON.parse(result)
                            let obj = {
                                projectTypeID: result[0].projectTypeID,
                                workTime: result[0].workTime,
                                dynamicKValue: result[0].dynamicKValue,
                                projectName: result[0].projectName
                            }
                            resultData.push(obj)
                            if (i === data.checkID.length - 1) {
                                return $http.writeJson(res, {code: 1, data: resultData, message: '获取列表成功'})
                            }
                        }
                    }
                })
            }
        })
    },
    /* 新增工时申报 */
    workTimeSubmit (req, res) {
        let data = req.body
        workTimeInsert(data, res, '1')
    },
    /* 获取工时申报详情 */
    getProjectList (req, res) {
        let data = req.body
        $http.userVerify(req, res, () => {
            let searchID = data.searchID
            let searchMon = data.searchMon
            let pageNum = data.pageNum
            let pageSize = data.pageSize
            // 分页查询入参 start
            let limitFirst = (pageNum - 1) * pageSize;
            let limitLast = pageSize;
            let arrayParams = [searchID, searchMon, searchID, searchMon, limitFirst, limitLast]
            let sqlGetProjectList = $sql.performance.getProjectList
            let sqlGetProjectTotal = $sql.performance.getProjectListTotal
            let sql= sqlGetProjectTotal + '; ' + sqlGetProjectList
            sql = sql + " order by submitTime desc limit ?, ?" // 提交时间倒序排
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
    /*获取工时分配信息*/
    getWorkAssign (req, res) {
        let data = req.body
        $http.userVerify(req, res, () => {
            let checkID = data.projectID
            let sql = $sql.performance.getWorkAssign
            let arrayParams = [checkID]
            $http.connPool(sql, arrayParams, (err, result) =>{
                if (err) {
                    return $http.writeJson(res, {code: -2, message: '失败'})
                } else {

                    result = formatData(result)
                    return $http.writeJson(res, {code: 1, data: result, message: '获取工时分配成功'})
                }
            })
        })
    },
    /* 获取项目信息 */
    getProjectInfo (req, res) {
        let data = req.body
        $http.userVerify(req, res, () => {
            let checkID = data.id
            let sqlGetProjectInfo = $sql.performance.getProjectInfo
            let sqlGetWorkAssignInfo = $sql.performance.getWorkAssignInfo
            let sql = sqlGetProjectInfo + ';' + sqlGetWorkAssignInfo
            let arrayParams = [checkID, checkID]
            $http.connPool(sql, arrayParams, (err, result) =>{
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
    /* 改变提交状态 */
    changeSubmitStatus (req, res) {
        let data = req.body
        let sql = $sql.performance.changeSubmitStatus
        let arrayParams = [data.submitStatus, data.id]
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
    /* 删除项目 */
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
    }
}

module.exports = performance
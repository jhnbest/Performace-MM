const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')
const moment = require('moment')

function formatData(rows) {
    return rows.map(row => {
        if(row.create_time) {
            row.create_time = $time.formatTime(row.create_time)
        }
        if(row.assignDate) {
            row.assignDate = $time.formatTime(row.assignDate)
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
        if (type) {
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

function trimSpace (array){
    for(let i = 0 ; i < array.length; i++) {
        if(array[i] == " " || array[i] == null || typeof(array[i]) == "undefined") {
            array.splice(i,1);
            i = i - 1;
        }
    }
    return array;
}

function fillPlanMonthData(obj, preResult, year, aPDID) {
    const fillData = {
        id: null,
        aPDID: aPDID,
        year: year,
        type: 'plan',
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
        December: null
    }
    Object.assign(obj, preResult, fillData)
}

function fillFactMonthData(obj, preResult, year, aPDID) {
    const fillData = {
        id: null,
        aPDID: aPDID,
        year: year,
        type: 'fact',
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
        December: null
    }
    Object.assign(obj, preResult, fillData)
}

function getMonthProcess(id, year, preResult, resultData) {
  return new Promise(function (resolve, reject) {
    let sql = $sql.workStation.getMonthProcess
    let arrayParams = [id, year]
    $http.connPool(sql, arrayParams, (err, result) => {
      if (err) {
        reject(-1)
      } else {
        result = JSON.parse(JSON.stringify(result))
        if (result.length === 0) { //无任何进展数据
          let obj = {}
          fillPlanMonthData(obj, preResult, year, id)
          resultData.push(obj)
          obj = {}
          fillFactMonthData(obj, preResult, year, id)
          resultData.push(obj)
          resolve(1)
        } else if (result.length === 1) { //仅有一个进展数据
          if (result[0].type === 'plan') { // 计划进展在前
            let obj = {}
            Object.assign(obj, preResult, result[0])
            resultData.push(obj)
            obj = {}
            fillFactMonthData(obj, preResult, year, id)
            resultData.push(obj)
            resolve(1)
          } else if (result[0].type === 'fact') { //实际进展在前
            let obj = {}
            fillPlanMonthData(obj, preResult, year, id)
            resultData.push(obj)
            obj = {}
            Object.assign(obj, preResult, result[0])
            resultData.push(obj)
            resolve(1)
          }
        } else { //有完整进展数据
          if (result[0].type === 'fact') { // 实际进展在前
            for (let i = result.length - 1; i >= 0; i--) {
              let obj = {}
              Object.assign(obj, preResult, result[i])
              resultData.push(obj)
              if (i === 0) {
                resolve(1)
              }
            }
          } else {
            for (let i = 0; i < result.length;i++) {
              let obj = {}
              Object.assign(obj, preResult, result[i])
              resultData.push(obj)
              if (i === result.length - 1) {
                resolve(1)
              }
            }
          }
        }
      }
    })
  })
}

async function getAssignProjectDetailMonthProcess(result, resultData, data, res) {
    for (let i = 0; i < result.length; i++) {
        await getMonthProcess(result[i].apdID, data.year, result[i], resultData).then(() => {
            if (i === result.length - 1) {
                return $http.writeJson(res, {code: 1, data: resultData, message: '成功'})
            }
        })
    }
}

function getAssignProjectDetailOP(data) {
    return new Promise(function (resolve, reject) {
        let sql = $sql.workStation.getAssignProjectDetail
        let arrayParams = [data.id]
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

async function getAssignProjectDetailPlan(data) {
    for (let item of data) {
        await getAssignProjectDetailOP(item).then(res0 => {
            item.projectDetail = res0
        })
    }
    return new Promise(function (resolve, reject) {
        resolve(data)
    })
}

function insertAssignProjectDetailOP(sql, arrayParams) {
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

async function insertAssignProjectDetail(sql, arrayParams, data, insertID, res) {
    let aplID = insertID
    let i = 0
    let result = []
    for (let item of data) {
        let projectStage = item.projectTypeID
        let baseWorkTime = item.workTime
        let kValue = item.kValue
        let avaiableWorkTime = item.avaiableWorkTime
        let projectStageName = item.workType
        arrayParams = [aplID, projectStage, projectStageName, baseWorkTime, kValue, avaiableWorkTime]
        await insertAssignProjectDetailOP(sql, arrayParams).then(res1 => {
            let obj = {
                projectStage: projectStage,
                insertID: res1.insertId,
                aplID: aplID
            }
            result.push(obj)
            if (i++ === data.length - 1) {
                return $http.writeJson(res, {code: 1, data: result, message: '成功'})
            }
        })
    }
}

function getMonthProcessDiffOP(applyMonth, applyYear, lastMonth, lastYear, data, type) {
  let sql = $sql.workStation.getMonthProcessDiffOP
  let arrayParams = [data.aPDID, type]
  return new Promise(function (resolve, reject) {
    $http.connPool(sql, arrayParams, (err, result) => {
      if (err) {
        reject(-1)
      } else {
        result = JSON.parse(JSON.stringify(result))
        let applyMonthProcess = null
        let lastMonthProcess = null
        for (let item of result) {
          if (item.year === applyYear && item.year === lastYear) {
            applyMonthProcess = item[applyMonth]
            lastMonthProcess = item[lastMonth]
          } else if (item.year === applyYear) {
            applyMonthProcess = item[applyMonth]
          } else if (item.year === lastYear) {
            lastMonthProcess = item[lastMonth]
          }
        }
        if (lastMonthProcess == null || applyMonthProcess === null) {
          if (lastMonthProcess == null) {
            lastMonthProcess = 0
          } else {
            applyMonthProcess = 0
          }
        }
        let obj = {
          applyMonthProcess: applyMonthProcess,
          lastMonthProcess: lastMonthProcess
        }
        resolve(obj)
      }
    })
  })
}

function processWorkTimeCal(preRes, data) {
    let sql = $sql.workStation.getAssignProject
    let arrayParams = [data.aPDID]
    return new Promise(function (resolve, reject) {
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                reject(-1)
            } else {
                result = JSON.parse(JSON.stringify(result))
                resolve(result[0])
            }
        })
    })
}

function updateMonthProcessObsoleteStatus(data) {
    return new Promise(function (resolve, reject) {
        if (data.length !== 0) {
            let sql = $sql.workStation.updateMonthProcessObsoleteStatus
            let arrayParams = []
            for (let item of data) {
                arrayParams.push(item.id)
                sql += '?,'
            }
            sql = sql.substr(0, sql.length - 1)
            sql += ')'
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    reject(-1)
                } else {
                    result = JSON.parse(JSON.stringify(result))
                    resolve(result)
                }
            })
        } else {
            resolve(1)
        }
    })
}

function updateWorkTimeAssignObsoleteStatus(data) {
    return new Promise(function (resolve, reject) {
        if (data.length !== 0) {
            let sql = $sql.workStation.updateWorkTimeAssignObsoleteStatus
            let arrayParams = []
            for (let item of data) {
                arrayParams.push(item.id)
                sql += '?,'
            }
            sql = sql.substr(0, sql.length - 1)
            sql += ')'
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    reject(-1)
                } else {
                    result = JSON.parse(JSON.stringify(result))
                    resolve(result)
                }
            })
        } else {
            resolve(1)
        }
    })
}

function getAssignedProjects(data) {
    return new Promise(function (resolve, reject) {
        let sql = $sql.workStation.assignProjectList
        let arrayParams = [data.userID]
        $http.connPool(sql, arrayParams, (err, result) =>{
            if (err) {
                reject(err)
            } else {
                result = JSON.parse(JSON.stringify(result))
                resolve(result)
            }
        })
    })
}

async function getAssignProjectMonthProcessPlan(data, year) {
    for (let item of data) {
        for (let i = 0; i < item.projectDetail.length; i++) {
            let resultData = []
            await getMonthProcess(item.projectDetail[i].apdID, Number(year), item.projectDetail[i], resultData).then(() => {
                item.projectDetail[i] = []
                for (let item1 of resultData) {
                    item.projectDetail[i].push(item1)
                }
            })
        }
    }
    return new Promise(function (resolve, reject) {
        resolve(data)
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

function fGetProjectTypeList(projectType, isFinish) {
    let sql = null
    let arrayParams = [projectType]
    //***基础平台类项目同时查询工程组和通信组的 */
    if (projectType === 213) {
      if (isFinish === 0) { // 获取未完成项目
        sql = $sql.workStation.getTypeProjectListUnV2
      } else if (isFinish === 1) { // 获取已完成项目
          sql = $sql.workStation.getTypeProjectListed
      } else if (isFinish === -1) { // 获取所有项目
          sql = $sql.workStation.getTypeProjectList
      }
    } else {
      if (isFinish === 0) { // 获取未完成项目
        sql = $sql.workStation.getTypeProjectListUn
      } else if (isFinish === 1) { // 获取已完成项目
          sql = $sql.workStation.getTypeProjectListed
      } else if (isFinish === -1) { // 获取所有项目
          sql = $sql.workStation.getTypeProjectList
      }
    }
    return new Promise(function (resolve, reject) {
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            resolve(RCPDDatabaseRes)
        }).catch(err => {
            reject(err)
        })
    })
}

function getProjectStageByPID(project) {
    let sql = $sql.workStation.getProjectStageByPID
    let arrayParams = [project.id]
    return new Promise(function (resolve, reject) {
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            resolve(RCPDDatabaseRes)
        }).catch(err => {
            reject(err)
        })
    })
}

function getMonthProcessByProjectStageID(projectStageList, curApplyYear) {
    let promise = []
    let count = 0
    return new Promise(function (resolve, reject) {
        for (let projectStageListItem of projectStageList) {
            let sql = $sql.workStation.getMonthProcessByProjectStageID
            let arrayParams = [projectStageListItem.id, curApplyYear]
            promise[count++] = RCPDDatabase(sql, arrayParams)
        }
        Promise.all(promise).then(result => {
            resolve(result)
        }).catch(err => {
            reject(err)
        })
    })
}

const workStation = {
    // 获取指派任务列表
    getAssignProjectList (req, res) {
        $http.userVerify(req, res, () => {
            let data = req.body
            let sql = null
            if (data.searchType === 'unFilled') {
                sql = $sql.workStation.getAssignProjectListUn + ';' + $sql.workStation.getAssignProjectListUnCount
            } else if (data.searchType === 'completed') {
                sql = $sql.workStation.getAssignProjectList + ';' + $sql.workStation.getAssignProjectListCount
            } else if (data.searchType === 'Filled') {
                sql = $sql.workStation.getAssignProjectListed + ';' + $sql.workStation.getAssignProjectListedCount
            } else if (data.searchType === 'all') {
                sql = $sql.workStation.getAssignProjectListed + ';' + $sql.workStation.getAssignProjectListedCount
            }
            let arrayParams = [data.id, data.projectType, data.id, data.projectType]
            RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
                RCPDDatabaseRes[0] = JSON.parse(JSON.stringify(RCPDDatabaseRes[0]))
                RCPDDatabaseRes[1] = JSON.parse(JSON.stringify(RCPDDatabaseRes[1]))
                RCPDDatabaseRes[0] = formatData(RCPDDatabaseRes[0])
                return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: '成功'})
            }).catch(RCPDDatabaseResErr => {
                return $http.writeJson(res, {code: -2, data: RCPDDatabaseResErr, message: '失败'})
            })
        })
    },
    // 获取未完成的指派项目明细
    getAssignProjectDetail (req, res) {
      $http.userVerify(req, res, () => {
        let data = req.body
        let sql = $sql.workStation.getAssignProjectDetail
        let arrayParams = [data.id]
        RCPDDatabase(sql, arrayParams).then(res0 => {
          let resultData = []
          getAssignProjectDetailMonthProcess(res0, resultData, data, res)
        }).catch(err => {
          return $http.writeJson(res, {code: -2, err: err, message: 'err'})
        })
      })
    },
    // 获取未完成的指派项目明细
    getAssignProjectDetailV2 (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.workStation.getAssignProjectDetail
        let arrayParams = [sendData.id]
        RCPDDatabase(sql, arrayParams).then(response1 => {
          let projectDetail = response1
          let checkApdID = []
          for (let item of projectDetail) {
            item.monthProcess = []
            item.preMonthProcessArray = []
            checkApdID.push(item.apdID)
          }
          sql = $sql.workStation.getMonthProcessV2
          let preYear = sendData.year - 1
          let years = [sendData.year, preYear]
          arrayParams = [checkApdID, years]
          RCPDDatabase(sql, arrayParams).then(response2 => {
            let monthProcess = response2
            for (let item of projectDetail) {
              item.monthProcess = monthProcess.filter(monthProcessItem => {
                return (monthProcessItem.aPDID === item.apdID && monthProcessItem.year === sendData.year)
              })
              item.preMonthProcessArray = monthProcess.filter(monthProcessItem => {
                return (monthProcessItem.aPDID === item.apdID && monthProcessItem.year === preYear)
              })
            }
            return $http.writeJson(res, {code: 1, data: projectDetail, message: '成功'})
          }).catch(err => {
            return $http.writeJson(res, {code: -2, err: err, message: 'err'})
          })
        }).catch(err => {
          return $http.writeJson(res, {code: -2, err: err, message: 'err'})
        })
      })
    },
    // 获取项目阶段列表
    getAssignProjectStageList (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.getAssignProjectDetail
        let arrayParams = [sendData.projectID]
        RCPDDatabase(sql, arrayParams).then(res0 => {
            return $http.writeJson(res, {code: 1, data: res0, message: 'success'})
        }).catch(err => {
            return $http.writeJson(res, {code: -2, data: err, message: 'error'})
        })
    },
    // 更新项目阶段
    updateEditProjectStage (req, res) {
        let recvData = req.body
        let promises = []
        let count = 0
        let sql = null
        let arrayParams = []
        for (let item of recvData.updateProjectStage) {
            sql = $sql.workStation.updateProjectStage
            arrayParams = [item.projectStageName, item.baseWorkTime, item.kValue, item.baseWorkTime * item.kValue, item.apdID]
            promises[count++] = RCPDDatabase(sql, arrayParams)
        }
        for (let item of recvData.newProjectStage) {
            sql = $sql.workStation.insertNewProjectStage
            arrayParams = [item.aplID, item.projectStageID, item.projectStageName, item.baseWorkTime,
                item.kValue, item.baseWorkTime * item.kValue]
            promises[count++] = RCPDDatabase(sql, arrayParams)
        }
        for (let item of recvData.deleteApdID) {
            sql = $sql.workStation.deleteProjectStage
            arrayParams = [item]
            promises[count++] = RCPDDatabase(sql, arrayParams)
        }
        Promise.all(promises).then(() => {
            return $http.writeJson(res, {code: 1, data: 'success', message: 'success'})
        }).catch(err => {
            return $http.writeJson(res, {code: -2, err: err, message: 'error'})
        })
    },
    // 计算该阶段进展
    projectStageProcessCal (id, year) {
        return new Promise(function (resolve, reject) {
            let sql = $sql.workStation.getAssignProjectStageByID
            let arrayParams = [id, year]
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    return -1
                } else {
                    result = JSON.parse(JSON.stringify(result))
                    let maxProcess = 0.0
                    for (let item of result) {
                        let resultArr = Object.values(item)
                        for (let i = 0;i < resultArr.length; i++) {
                            if (resultArr[i] == null) {
                                resultArr[i] = 0
                            }
                        }
                        let maxProcessTmp = Math.max.apply(null, resultArr)
                        if (maxProcessTmp > maxProcess) {
                            maxProcess = maxProcessTmp
                        }
                    }
                    resolve(maxProcess)
                }
            })
        })
    },
    // 更新该阶段进展
    projectStageProcessUpdate (id, process) {
        return new Promise(function (resolve, reject) {
            let sql = $sql.workStation.projectStageProcessInsert
            let arrayParams = [process, id, id]
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    reject(err)
                } else {
                    result = JSON.parse(JSON.stringify(result))
                    resolve(result[1][0])
                }
            })
        })
    },
    // 保存进展
    saveProcess(data) {
      return new Promise(function (resolve, reject) {
        let sql = null
        let arrayParams = null
        let isFinish = 0
        if (data.applyProcess === 100 && data.type === 'fact') {
          isFinish = 1
        }
        if (data.id !== null) {
          sql = $sql.workStation.submitPlanProcessE
          arrayParams = [data.kValue, data.coefficient, isFinish, data.aPDID, data.January, data.February, data.March,
              data.April, data.May, data.June, data.July, data.August, data.September, data.October, data.November, data.December,
              data.id]
        } else {
          sql = $sql.workStation.submitPlanProcessU
          arrayParams = [data.kValue, data.coefficient, isFinish, data.aPDID, data.aPDID, data.year, data.type,
              data.January, data.February, data.March, data.April, data.May, data.June, data.July, data.August, data.September,
              data.October, data.November, data.December]
        }
        $http.connPool(sql, arrayParams, (err, result) => {
          if (err) {
            reject(err)
          } else {
            let resultData = {}
            result = JSON.parse(JSON.stringify(result))
            resultData = data.id === null? { monthID: result[1].insertId } : { monthID: data.id }
            resolve(resultData)
          }
        })
      })
    },
    // 计算项目总进展
    projectProcessCal(params) {
        return new Promise(function (resolve, reject) {
            let sql = $sql.workStation.getProjectStageProcess
            let arrayParams = [params.aPLID, params.aPLID]
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    reject(-1)
                } else {
                    result = JSON.parse(JSON.stringify(result))
                    let totalCount = result[0][0].totalCount
                    let totalProcess = 0.0
                    for (let item of result[1]) {
                        totalProcess += item.process * 0.01 * (1 / totalCount)
                    }
                    resolve(totalProcess * 100.0)
                }
            })
        })
    },
    // 更新项目总进展
    projectProcessUpdate(id, process) {
        return new Promise(function (resolve, reject) {
            let sql = $sql.workStation.projectProcessUpdate
            let arrayParams = [process, id.aPLID]
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    reject(err)
                } else {
                    resolve(1)
                }
            })
        })
    },
    // 提交进展
    submitProcess (req, res) {
      let sendData = req.body
      let count = 0
      let promises = []
      for (let i = 0; i < sendData.length; i++) {
        promises[count++] = workStation.saveProcess(sendData[i])
      }
      Promise.all(promises).then((allResponse) => { //保存进展
        return $http.writeJson(res, {code: 1, data: allResponse, message: '成功'})
      }).catch(err => {
        return $http.writeJson(res, {code: -2, err: err, message: '失败'})
      })
    },
    // 保存指派项目
    submitAssignWorkDetail (req, res) {
        let data = req.body
        let sql = null
        let arrayParams = []
        let projectTypeID = data.parentID
        let projectName = data.projectName
        let userID = data.tableData[0].projectManagerID
        let assignerID = data.userId
        let totalWorkTime = 0
        let projectLevel = data.projectLevel
        let reviewStatus = 1
        let isFilled = 0
        if (data.isFilled === 1) {
            isFilled = 1
        }
        if (projectTypeID === 5) { //非标项目
            reviewStatus = 0
        }
        for (let item of data.tableData) {
            totalWorkTime += item.workTime
        }
        let curTime = $time.formatTime()
        sql = $sql.workStation.insertAssignProjectList
        arrayParams = [userID, curTime, projectTypeID, projectName, assignerID, totalWorkTime, projectLevel, reviewStatus, isFilled]
        RCPDDatabase(sql, arrayParams).then( res1 => {
            let insertID = res1.insertId
            sql = $sql.workStation.insertAssignProjectDetail
            arrayParams = []
            insertAssignProjectDetail(sql, arrayParams, data.tableData, insertID, res).then()
        })
    },
    // 提交个人申报项目
    async submitPersonalProject (req, res) {
        // let data = req.body
        // for (let item of data.tableData) {
        //     let params = {
        //         id: null,
        //         kValue: item.defaultKValue,
        //         coefficient: item.defaultCofficient,
        //         avaiableWorkTime: item.avaiableWorkTime,
        //         aPDID: item.apdID,
        //         type: data.type,
        //         year: data.year,
        //         January: null,
        //         February: null,
        //         March: null,
        //         April: null,
        //         May: null,
        //         June: null,
        //         July: null,
        //         August: null,
        //         September: null,
        //         October: null,
        //         November: null,
        //         December: null
        //     }
        //     params[data.monthString] = item.applyProcess
        //     await saveProcess(params).then(res0 => {
        //         projectStageProcessCal(params.aPDID, data.year).then(res1 => { //计算该阶段进展
        //             projectStageProcessUpdate(params.aPDID, res1).then(res2 => { //更新该阶段进展
        //                 projectProcessCal(res2).then(res3 => { //计算项目总进展
        //                     projectProcessUpdate(res2, res3).then(() => { //更新项目总进展
        //                     })
        //                 })
        //             })
        //         })
        //     })
        // }
        // return $http.writeJson(res, {code: 1, message: '成功'})
    },
    // 获取每月进展对应工时
    async getMonthProcessDiff (req, res) {
      let params = req.body
      let applyMonth = params.applyMonth
      let applyYear = params.applyYear
      let lastMonth = params.lastMonth
      let lastYear = params.lastYear
      let type = params.type
      let resultData = []
      for (let i = 0;i < params.data.length;i++) {
        await getMonthProcessDiffOP(applyMonth, applyYear, lastMonth, lastYear, params.data[i], type).then( res1 => { // 查询申报月份进展
          processWorkTimeCal(res1, params.data[i]).then(res2 => {
            res2.sendParams = params.data[i]
            res2.processDiff = res1
            resultData.push(res2)
            if (i === params.data.length - 1) {
                return $http.writeJson(res, {code: 1, data: resultData, message: '成功'})
            }
          })
        })
      }
    },
    // 获取已指派项目列表
    getAssignedProject (req, res) {
        let data = req.body
        let sql = $sql.workStation.getAssignedProject
        let arrayParams = [data.assignerID]
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                return $http.writeJson(res, { code: -2, message: '失败', errMsg: err })
            } else {
                result = JSON.parse(JSON.stringify(result))
                result = formatData(result)
                return  $http.writeJson(res, {code: 1, data: result, message: '成功'})
            }
        })
    },
    // 更新已指派项目
    updateAssignProjectList (req, res) {
        let data = req.body.data
        let sql = $sql.workStation.updateAssignProjectList
        let arrayParams = [data.projectManagerID, data.projectName, data.projectLevel, data.id]
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                return $http.writeJson(res, { code: -2, message: '失败', errMsg: err })
            } else {
                return $http.writeJson(res, {code: 1, message: '成功'})
            }
        })
    },
    // 删除已指派项目
    deleteAssignProject (req, res) {
        let data = req.body
        let sql = $sql.workStation.deleteAssignProjectList + ';'
            + $sql.workStation.deleteAssignProjectDetail + ';'
            + $sql.workStation.getAssignProjectDetailID + ';'
            + $sql.workStation.deleteWorkTimeList + ';'
            + $sql.workStation.getWorkTimeAssignItem
        let arrayParams = [data.id, data.id, data.id, data.id, data.id]
        $http.userVerify(req, res, () =>{
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    return $http.writeJson(res, { code: -2, message: '失败', errMsg: err })
                } else {
                    result[0] = JSON.parse(JSON.stringify(result[0]))
                    result[1] = JSON.parse(JSON.stringify(result[1]))
                    result[2] = JSON.parse(JSON.stringify(result[2]))
                    result[3] = JSON.parse(JSON.stringify(result[3]))
                    result[4] = JSON.parse(JSON.stringify(result[4]))
                    updateMonthProcessObsoleteStatus(result[2]).then(() => {
                        updateWorkTimeAssignObsoleteStatus(result[4]).then(() => {
                            return $http.writeJson(res, { code: 1, message: '成功' })
                        })
                    })
                }
            })
        })
    },
    // ***更新项目阶段信息***
    updateAssignProjectStageInfo (req, res) {
      let data = req.body
      let sqlUpdateAssignWorkDetail = $sql.workStation.updateAssignProjectStageInfo
      let sqlUpdateAssignWorkList = $sql.workStation.UpdateAssignWorkList
      let sqlGetProjectTotalWorkTime = $sql.workStation.GetProjectTotalWorkTime
      let sql = sqlUpdateAssignWorkDetail
      let kValue = data.assignProjectDetail.kValue
      let coefficient = data.assignProjectDetail.coefficient
      let avaiableWorkTime = data.assignProjectDetail.avaiableWorkTime
      let projectStageName = data.assignProjectDetail.projectStageName
      let applyBaseWorkTime = data.assignProjectDetail.applyBaseWorkTime
      let apdID = data.assignProjectDetail.apdID
      let arrayParams = [projectStageName, kValue, coefficient, avaiableWorkTime, applyBaseWorkTime, apdID]
      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
        return $http.writeJson(res, { code: 1, data: RCPDDatabaseRes, message: 'success' })
      }).catch(RCPDDatabaseErr => {
        return $http.writeJson(res, { code: -2, data: RCPDDatabaseErr, message: 'error' })
      })
    },
    // ***获取项目明细
    getAssignWorkDetail (req, res) {
      let data = req.body
      let sql = $sql.workStation.getAssignWorkDetail
      let arrayParams = [data.apdID]
      $http.connPool(sql, arrayParams, (err, result) => {
        if (err) {
          return $http.writeJson(res, {code: -2, message:'失败', errMsg: err})
        } else {
            result = JSON.parse(JSON.stringify(result))
          return $http.writeJson(res, {code: 1, data: result[0], message: '成功'})
        }
      })
    },
    // 更新项目月工时申报状态
    updateAssignProjectFilled (req, res) {
        let data = req.body
        let sql = $sql.workStation.updateAssignProjectFilled
        let arrayParams = [data.assignProjectID]
        $http.userVerify(req, res, () => {
            $http.connPool(sql, arrayParams, (err, result) => {
                if (err) {
                    return $http.writeJson(res, {code: -2, message: '失败', errMsg: err})
                } else {
                    result = JSON.parse(JSON.stringify(result))
                    return $http.writeJson(res, {code: 1, data: result, message: '成功'})
                }
            })
        })
    },
    // 提交计划至计划进展表
    async submitMonthPlanProcess (req, res) {
        let data = req.body
        let i = 0
        for (let item of data.paramsData) {
            await workStation.saveProcess(item)
            if (i++ === data.paramsData.length - 1) {
                return $http.writeJson(res, {code: 1, message: '成功'})
            }
        }
    },
    // 获取项目列表
    getPlanInfo (req, res) {
        let data = req.body
        let sql = $sql.workStation.getPlanInfo
        let arrayParams = [data.id, data.title]
        $http.connPool(sql, arrayParams, (err, result) => {
        })
    },
    // 获取指派项目列表(计划查询)
    async getAssignedProjectPlan (req, res) {
        let data = req.body
        getAssignedProjects(data).then(res0 => { // 获取指派的项目列表
            getAssignProjectDetailPlan(res0).then(res1 => { // 获取各项目对应的项目阶段
                getAssignProjectMonthProcessPlan(res1, data.year).then(res2 => { // 获取项目阶段月份进展
                    return $http.writeJson(res, {code: 1, data: res2, message: '成功'})
                })
            })
        })
    },
    // 获取项目阶段对应的工时申报
    getWorkTimeListOfProjectStage (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.getWorkTimeListOfProjectStage
        let arrayParams = [sendData.apdID]
        RCPDDatabase(sql, arrayParams).then(res0 => {
            return $http.writeJson(res, {code: 1, data: res0, message: 'success'})
        }).catch(err => {
            return $http.writeJson(res, {code: -2, err: err, message: 'error'})
        })
    },
    // 获取是否可以申报工时和提交互评
    getIsSubmitAllow (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.getIsSubmitAllow
        let arrayParams = [sendData.applyYear, sendData.applyMonth, sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(res0 => {
            return $http.writeJson(res, { code: 1, data: res0, message: 'success' })
        }).catch(err => {
            return $http.writeJson(res, { code: -2, data: err, message: 'err' })
        })
    },
    // 获取当前小组工时审核是否都已完毕
    getCurGroupWorkTimeReviewFinish (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.getCurGroupWorkTimeReviewFinish
        let arrayParams = [sendData.groupID, sendData.applyMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, { code: 1, data: RCPDDatabaseRes, message: 'success' })
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, { code: -2, data: RCPDDatabaseErr, message: 'error' })
        })
    },
    // ***当月领导者是否已经评价完毕
    getManagerMultualRateFinish (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.getManagerMultualRateFinish
        let arrayParams = [sendData.applyMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, { code: 1, data: RCPDDatabaseRes, message: 'success' })
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, { code: -2, data: RCPDDatabaseErr, message: 'error' })
        })
    },
    // 当月绩效评价结果是否已经发布
    getPerformanceIsPublish (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.getPerformanceIsPublish
        let arrayParams = [sendData.applyYear, sendData.applyMonth, sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(res0 => {
            return $http.writeJson(res, { code: 1, data: res0, message: 'success' })
        }).catch(err => {
            return $http.writeJson(res, { code: -2, data: err, message: 'err' })
        })
    },
    // 是否发布首页绩效信息
    performanceInfoPublish (req, res) {
        let sendData = req.body
        let sql = null
        let arrayParams = null
        let applyDateTime = null
        if (sendData.flagID !== -1) {
            sql = $sql.workStation.updatePerformanceInfoPublish
            arrayParams = [sendData.flagValue, sendData.flagID]
        } else {
            sql = $sql.workStation.insertPerformanceInfoPublish
            applyDateTime = moment().set({'year': sendData.applyYear, 'month': sendData.applyMonth - 1})
                .format('YYYY-MM-DD HH:mm:ss')
            arrayParams = [applyDateTime, sendData.flagType, sendData.flagValue]
        }
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, { code: 1, data: RCPDDatabaseRes, message: 'success' })
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, { code: -2, data: RCPDDatabaseErr, message: 'error' })
        })
    },
    // 获取未填报的项目列表
    getUnFilledProjectList (req, res) {
        let sendData = req.body
        let sql = null
        let arrayParams = [sendData.userID]
        if (sendData.searchType === 'unFilled') {
            sql = $sql.workStation.getUnFilledProjectList
        } else if (sendData.searchType === 'Filled') {
            sql = $sql.workStation.getFilledProjectList
        } else if (sendData.searchType === 'completed') {
            sql = $sql.workStation.getCompleteProjectList
        }
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, { code: 1, data: RCPDDatabaseRes, message: 'success' })
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, { code: -2, data: RCPDDatabaseErr, message: 'error' })
        })
    },
    // 查看项目阶段当月是否已填报工时
    projectDetailIsApplyWorkTime (req, res) {
      let sendData = req.body
      let applyMonth = sendData.applyMonth
      let type = sendData.type
      let promises = []
      let count = 0
      let sql = $sql.workStation.projectDetailIsApplyWorkTime
      for (let sendDataItem of sendData.projectDetailID) {
        let arrayParams = [sendDataItem, applyMonth, type]
        promises[count++] = RCPDDatabase(sql, arrayParams)
      }
      Promise.all(promises).then(result => {
        return $http.writeJson(res, { code: 1, data: result, message: 'success' })
      }).catch(error => {
        return $http.writeJson(res, { code: -2, data: error, message: 'error' })
      })
    },
    // 查看项目阶段当月是否已填报工时V2
    projectDetailIsApplyWorkTimeV2 (req, res) {
      let sendData = req.body
      let sql = $sql.workStation.projectDetailIsApplyWorkTimeV2
      let arrayParams = [sendData.projectDetailID, sendData.applyMonth, sendData.type]
      RCPDDatabase(sql, arrayParams).then(result => {
        return $http.writeJson(res, { code: 1, data: result, message: 'success' })
      }).catch(error => {
        return $http.writeJson(res, { code: -2, data: error, message: 'error' })
      })
    },
    // 修复错误数据
    repairErrorData (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.repairErrorDataCheck
        let arrayParams = []
        let promises = []
        let ErrResult = []
        let count = 0
        for (let i = 1; i < 3332; i++) {
            arrayParams = [i, i]
            promises[count++] = RCPDDatabase(sql, arrayParams)
        }
        Promise.all(promises).then(result => {
            for (let resultItem of result) {
                if (resultItem[0][0].totalCount > 1) {
                    ErrResult.push(resultItem[1])
                }
            }
            return $http.writeJson(res, { code: 1, data: ErrResult, message: 'success' })
        })
    },
    // 修复错误数据
    repairErrorData2 (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.repairErrorData2Check
        let arrayParams = []
        let promises = []
        let count = 0
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            for (let item of RCPDDatabaseRes) {
                sql = $sql.workStation.repairErrorData2Modify
                arrayParams = [item.applyProcess, item.id]
                promises[count++] = RCPDDatabase(sql, arrayParams)
            }
            Promise.all(promises).then(result => {
                return $http.writeJson(res, { code: 1, data: result, message: 'success' })
            })
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, { code: -2, data: RCPDDatabaseErr, message: 'error' })
        })
    },
    // 将项目置为已完成状态
    setProjectFinish (req, res) {
        let sendData = req.body
        let sql = $sql.workStation.setProjectFinish
        let arrayParams = [sendData.aplId, sendData.aplId]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 获取特定类型的项目列表
    getTypeProjectList (req, res) {
      let promises = []
      let count = 0
      let sendData = req.body
      fGetProjectTypeList(sendData.projectType, sendData.isFinish).then(getProjectTypeListRes => { // get 项目列表
        for (let getProjectTypeListItem of getProjectTypeListRes) {
          promises[count++] = getProjectStageByPID(getProjectTypeListItem) // get 项目阶段
        }
        Promise.all(promises).then(getProjectStageByPIDRes => {
          let result = {
            projectList: getProjectTypeListRes,
            projectStage: getProjectStageByPIDRes
          }
          return $http.writeJson(res, {code: 1, data: result, message: 'success'})
        })
      }).catch(getProjectListErr => {
        return $http.writeJson(res, {code: -2, err: getProjectListErr, message: 'false'})
      })
    },
    // ***根据项目阶段获取项目进展***
    getMonthProcess (req, res) {
      let sendData = req.body
      getMonthProcessByProjectStageID(sendData.projectStage, sendData.submitYear).then(RCPDDatabaseRes => {
        return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
        return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      }) // get 项目阶段计划、实际进展
    },
    // ***更新项目信息***
    updateAssignProjectInfo (req, res) {
      let sendData = req.body
      let arrayParams = [sendData.userID, sendData.projectType, sendData.projectName, sendData.process, sendData.assignerID,
        sendData.totalWorkTime, sendData.isFilled, sendData.projectLevel, sendData.reviewStatus, sendData.obsoleteStatus,
        sendData.id]
      let sql = $sql.workStation.updateAssignProjectInfo
      RCPDDatabase(sql, arrayParams).then((RCPDDatabaseRes) => {
        return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
        return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
    },
    // ***获取项目总工时***
    getAssignProjectTotalWorkTime (req, res) {
      let sendData = req.body
      let arrayParams = [sendData.aplID]
      let sql = $sql.workStation.getAssignProjectTotalWorkTime
      RCPDDatabase(sql, arrayParams).then((RCPDDatabaseRes) => {
        return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
        return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
    }
}

module.exports = workStation
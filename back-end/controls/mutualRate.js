const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')
const moment = require('moment')

function starToRates(star) {
    switch (star) {
        case 1:
            return 82.5
        case 2:
            return 85
        case 3:
            return 87.5
        case 4:
            return 90
        case 5:
            return 92.5
        default:
            return 87.5
    }
}

function starToRatesNew(star) {
  switch (star) {
      case 1:
          return 85
      case 2:
          return 87.5
      case 3:
          return 90
      case 4:
          return 92.5
      case 5:
          return 95
      default:
          return 90
  }
}

const rateTypes = [{
    id: 1,
    rateTypeName: 't1Star'
}, {
    id: 2,
    rateTypeName: 't2Star'
}, {
    id: 3,
    rateTypeName: 't3Star'
}, {
    id: 4,
    rateTypeName: 't4Star'
}, {
    id: 5,
    rateTypeName: 't5Star'
}, {
    id: 6,
    rateTypeName: 't6Star'
}]

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

const mutualRate = {
    // ***获取互评信息
    getUserRates (req, res) {
      $http.userVerify(req, res, () => {
        let data = req.body
        let sql = $sql.mutualRates.getUserRates
        let arrayParams = [data.userID, data.rateMonth]
        $http.connPool(sql, arrayParams, (err, result) => {
          if (err) {
            return $http.writeJson(res, {code: -2, message: '失败',errMsg: err})
          } else {
            result = JSON.parse(JSON.stringify(result))
            return $http.writeJson(res, {code: 1, data: result, message: '成功'})
          }
        })
      })
    },
    // 提交互评信息
    submitRatesResult (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let promises = []
        // ***首先查询提交人在该月是否已经提交过定性评价（正常是不会，排查重复提交BUG用）
        let ratePersion = sendData.userID
        let rateMonth = sendData.title
        let sql = $sql.mutualRates.getRateDataByRatePersion
        let arrayParams = [ratePersion, rateMonth]
        RCPDDatabase(sql, arrayParams).then(res1 => {
          // ***如果还未提交过定性评价，再写入数据库
          if (res1.length === 0) {
            for (let item1 of sendData.data) {
              for (let item2 of rateTypes) {
                let rate = starToRatesNew(item1[item2.rateTypeName])
                let rateType = item2.id
                let ratedPersion = item1.ratedPersion
                sql = $sql.mutualRates.submitRatesResult
                let rateTime = $time.formatTime()
                arrayParams = [ratePersion, ratedPersion, rateMonth, rate, rateType, rateTime, rateTime]
                promises.push(RCPDDatabase(sql, arrayParams))
              }
            }
            Promise.all(promises).then(() => {
              return $http.writeJson(res, {code: 1, data: 'yes', message: '成功'})
            }).catch(err => {
              return $http.writeJson(res, {code: -2, err: err, message: 'false'})
            })
          } else { // ***如果数据库里面已有定性评价数据，报错
            return $http.writeJson(res, {code: -1, data: '数据库当月已有定性评价数据', message: '数据库当月已有定性评价数据'})
          }
        })
      })
    },
    // 更新互评信息
    updateUserRate (req, res) {
      $http.userVerify(req, res, () => {
        let data = req.body
        let sql = $sql.mutualRates.updateUserRate
        let updateTime = $time.formatTime()
        let arrayParams = []
        let promises = []
        for (let i = 0; i < data.ratesToUpdate.length; i++) {
            arrayParams = [data.ratesToUpdate[i].rate, updateTime, data.ratesToUpdate[i].id]
            promises[i] = RCPDDatabase(sql, arrayParams)
        }
        Promise.all(promises).then(() => {
            return $http.writeJson(res, {code: 1, data: 'success', message: '成功'})
        })
      })
    },
    // 获取本处员工互评得分
    getAllUserRates (req, res) {
      $http.userVerify(req, res, () => {
        let data = req.body
        let resultData = []
        let promises = []
        let sql = null
        let arrayParams = []
        for (let i = 0; i < data.usersData.length; i++) {
            sql = $sql.mutualRates.getCurMutualRate
            arrayParams = [data.usersData[i].id, data.rateMonth]
            promises.push(RCPDDatabase(sql, arrayParams))
            sql = $sql.mutualRates.getRateData
            promises.push(RCPDDatabase(sql, arrayParams))
        }
        Promise.all(promises).then(result => {
            let j = 0
            for (let i = 0; i < data.usersData.length; i++) {
                j = i * 2
                let obj = {
                    id: data.usersData[i].id,
                    name: data.usersData[i].name,
                    groupName: data.usersData[i].groupName,
                    duty: data.usersData[i].duty,
                    ratedData: result[j],
                    rateData: result[j + 1]
                }
                resultData.push(obj)
            }
            return $http.writeJson(res, { code: 1, data: resultData, message: '成功' })
        }).catch(err => {
            return $http.writeJson(res, {code: -2, err: err, message: 'false'})
        })
      })
    },
    // ***获取本处员工互评得分
    getAllQTEvaedData (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.mutualRates.getAllQTEvaedData
        let arrayParams = []
        let promises = []
        let count = 0
        for (let user of sendData.usersList) {
          arrayParams = [user.id, sendData.applyDate]
          promises[count++] = RCPDDatabase(sql, arrayParams)
        }
        Promise.all(promises).then(allResponse => {
          let result = []
          for (let i = 0; i < sendData.usersList.length; i++) {
            let obj = {
              ratedPersion: sendData.usersList[i].id,
              ratedPersionName: sendData.usersList[i].name,
              ratedPersionGroupID: sendData.usersList[i].groupID,
              ratedPersionGroupName: sendData.usersList[i].groupName,
              ratedPersionDuty: sendData.usersList[i].duty,
              QTEvaedData: allResponse[i]
            }
            result.push(obj)
          }
          return $http.writeJson(res, {code: 1, data: result, message: 'success'})
        }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    },
    // ***获取绩效信息统计标志
    getPerformanceIsCount (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.mutualRates.getPerformanceIsCount
        let arrayParams = [sendData.year, sendData.month, sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(res0 => {
            return $http.writeJson(res, {code: 1, data: res0, message: 'success'})
        }).catch(err => {
            return $http.writeJson(res, {code: -2, err: err, message: 'false'})
        })
      })
    },
    // 提取上月互评结果
    getMonthEva (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.mutualRates.getMonthEva
        let arrayParams = [sendData.rateMonth, sendData.rateUserID]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    },
    // ***一键填充定性评价
    handleFillMul (req, res) {
      // 定义核心业务逻辑函数
      const fillMutualRate = () => {
        return new Promise((resolve, reject) => {
            let sendData = req.body
            let sql = $sql.mutualRates.handleFillMul
            let arrayParams = []
            let promises = []
            let promises2 = []
            let promise3 = []
            let count = 0
            let count2 = 0
            let count3 = 0
            
            // 收集填充详情信息
            let fillDetails = {
                usersToFill: [],  // 需要填充的用户列表
                fillRecords: [],  // 填充的记录详情
                totalFilled: 0,   // 总填充条数
                userNameMap: {}   // 用户ID到姓名的映射
            }

            // 建立用户ID到姓名的映射
            for (let user of sendData.users) {
                let userName = user.name || user.NAME || user.userName || user.user_name || ''
                fillDetails.userNameMap[user.id] = userName
            }

            // ***********查询各员工在查询月份的定性评价数量***********
            for (let usersItem of sendData.users) {
              arrayParams = [usersItem.id, sendData.rateMonth]
              promises[count++] = RCPDDatabase(sql, arrayParams)
            }
            Promise.all(promises).then(result => {
              for (let i = 0; i < result.length; i++) {
                  let userName = sendData.users[i].name || sendData.users[i].NAME || sendData.users[i].userName || sendData.users[i].user_name || ''
                  result[i][0].userName = userName
                  result[i][0].userID = sendData.users[i].id
              }
              // ***********如果查询数量为0，则为待填充的对象，继续查询待填充对象上月份的成效评价数据
              for (let resultItem of result) {
                if (resultItem[0].totalCount === 0) {
                  // 记录需要填充的用户
                  fillDetails.usersToFill.push({
                      userID: resultItem[0].userID,
                      userName: resultItem[0].userName
                  })
                  
                  let preMonth = moment(sendData.rateMonth).subtract(1, 'months').format('YYYY-MM')
                  sql = $sql.mutualRates.handleFillMulCheck
                  arrayParams = [resultItem[0].userID, preMonth]
                  promises2[count2++] = RCPDDatabase(sql, arrayParams)
                }
              }
              // ***根据待填充对象在上月的互评数据，填充至本月的互评数据
              Promise.all(promises2).then(result2 => {
                let rateTime = $time.formatTime()
                for (let result2Item of result2) {
                  for (let result2ItemItem of result2Item) {
                    sql = $sql.mutualRates.handleFillMulFill // ***填充需要填充的月份的数据
                    arrayParams = [result2ItemItem.ratePersion, result2ItemItem.ratedPersion, sendData.rateMonth, result2ItemItem.rate,
                        result2ItemItem.rateType, rateTime, rateTime]
                    
                    // 记录填充详情
                    fillDetails.fillRecords.push({
                        ratedPerson: result2ItemItem.ratedPersion,
                        ratedPersonName: fillDetails.userNameMap[result2ItemItem.ratedPersion] || result2ItemItem.ratedPersion,
                        ratePerson: result2ItemItem.ratePersion,
                        ratePersonName: fillDetails.userNameMap[result2ItemItem.ratePersion] || result2ItemItem.ratePersion,
                        rateMonth: sendData.rateMonth,
                        rate: result2ItemItem.rate,
                        rateType: result2ItemItem.rateType
                    })
                    
                    promise3[count3++] = RCPDDatabase(sql, arrayParams)
                  }
                }
                Promise.all(promise3).then(result3 => {
                    fillDetails.totalFilled = result3.length
                    
                    // 打印数据库执行结果详情
                    console.log('互评填充数据库执行结果:', {
                        usersToFill: fillDetails.usersToFill,
                        totalUsersToFill: fillDetails.usersToFill.length,
                        totalInserted: fillDetails.totalFilled,
                        executionTime: new Date().toISOString()
                    });
                    
                    resolve({
                        code: 1, 
                        data: {
                            result: result3,
                            fillDetails: fillDetails
                        }, 
                        message: 'success'
                    })
                }).catch(error => {
                    reject(error)
                })
              }).catch(error => {
                  reject(error)
              })
            }).catch(error => {
                reject(error)
            })
        })
      }
      
      // 检查是否为内部调用（定时任务），内部调用直接执行，外部调用需要验证
      if (req.headers && req.headers.token) {
        // 外部HTTP请求，需要用户验证
        $http.userVerify(req, res, () => {
            fillMutualRate().then(result => {
                return $http.writeJson(res, result)
            }).catch(error => {
                return $http.writeJson(res, {code: -2, err: error, message: 'false'})
            })
        })
      } else {
        // 内部调用（定时任务），直接执行核心逻辑，返回Promise
        return fillMutualRate()
      }
    },
    // 获取个人成效评价历史数据
    getPerformanceRates (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.mutualRates.getPerformanceRates
        let arrayParams = [sendData.ratePersion, sendData.rateMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    }
}

module.exports = mutualRate
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
    // 获取互评信息
    getUserRates (req, res) {
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
    },
    // 提交互评信息
    submitRatesResult (req, res) {
        let sendData = req.body
        let promises = []
        for (let item1 of sendData.data) {
            for (let item2 of rateTypes) {
                let rate = starToRates(item1[item2.rateTypeName])
                let rateType = item2.id
                let ratedPersion = item1.ratedPersion
                let ratePersion = sendData.userID
                let rateMonth = sendData.title
                let sql = $sql.mutualRates.submitRatesResult
                let rateTime = $time.formatTime()
                let arrayParams = [ratePersion, ratedPersion, rateMonth, rate, rateType, rateTime, rateTime]
                promises.push(RCPDDatabase(sql, arrayParams))
            }
        }
        Promise.all(promises).then(() => {
            return $http.writeJson(res, {code: 1, data: 'yes', message: '成功'})
        }).catch(err => {
          return $http.writeJson(res, {code: -2, err: err, message: 'false'})
        })
    },
    // 更新互评信息
    async updateUserRate (req, res) {
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
    },
    // 获取本人互评得分
    getCurMutualRate (req, res) {
        let data = req.body
        let sql = $sql.mutualRates.getCurMutualRate
        let arrayParams = [data.userID, data.rateMonth]
        RCPDDatabase(sql, arrayParams).then(res0 => {
            return $http.writeJson(res, { code: 1, data: res0, message: 'success'})
        })
    },
    // 获取本处员工互评得分
    getAllUserRates (req, res) {
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
    },
    // 获取本处员工互评得分
    getAllQTEvaedData (req, res) {
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
    },
    // 获取绩效信息统计标志
    getPerformanceIsCount (req, res) {
        let sendData = req.body
        let sql = $sql.mutualRates.getPerformanceIsCount
        let arrayParams = [sendData.year, sendData.month, sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(res0 => {
            return $http.writeJson(res, {code: 1, data: res0, message: 'success'})
        }).catch(err => {
            return $http.writeJson(res, {code: -2, err: err, message: 'false'})
        })
    },
    // 提取上月互评结果
    getMonthEva (req, res) {
        let sendData = req.body
        let sql = $sql.mutualRates.getMonthEva
        let arrayParams = [sendData.rateMonth, sendData.rateUserID]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 一键填充定性评价
    handleFillMul (req, res) {
      let sendData = req.body
      let sql = $sql.mutualRates.handleFillMul
      let arrayParams = []
      let promises = []
      let promises2 = []
      let promise3 = []
      let count = 0
      let count2 = 0
      let count3 = 0

      for (let usersItem of sendData.users) {
        arrayParams = [usersItem.id, sendData.rateMonth]
        promises[count++] = RCPDDatabase(sql, arrayParams)
      }
      Promise.all(promises).then(result => {
        for (let i = 0; i < result.length; i++) {
            result[i][0].userName = sendData.users[i].name
            result[i][0].userID = sendData.users[i].id
        }
        for (let resultItem of result) {
          if (resultItem[0].totalCount === 0) {
            let preMonth = moment(sendData.rateMonth).subtract(1, 'months').format('YYYY-MM')
            sql = $sql.mutualRates.handleFillMulCheck // 找上上月份的评价数据
            arrayParams = [resultItem[0].userID, preMonth]
            promises2[count2++] = RCPDDatabase(sql, arrayParams)
          }
        }
        Promise.all(promises2).then(result2 => {
          let rateTime = $time.formatTime()
          for (let result2Item of result2) {
            for (let result2ItemItem of result2Item) {
              sql = $sql.mutualRates.handleFillMulFill // 填充需要填充的月份的数据
              arrayParams = [result2ItemItem.ratePersion, result2ItemItem.ratedPersion, sendData.rateMonth, result2ItemItem.rate,
                  result2ItemItem.rateType, rateTime, rateTime]
              promise3[count3++] = RCPDDatabase(sql, arrayParams)
            }
          }
          Promise.all(promise3).then(result3 => {
              return $http.writeJson(res, {code: 1, data: result3, message: 'success'})
          })
        })
      }).catch(error => {
          return $http.writeJson(res, {code: -2, err: error, message: 'false'})
      })
    },
    // 获取个人成效评价历史数据
    getPerformanceRates (req, res) {
        let sendData = req.body
        let sql = $sql.mutualRates.getPerformanceRates
        let arrayParams = [sendData.ratePersion, sendData.rateMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    }
}

module.exports = mutualRate
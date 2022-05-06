const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')
const moment = require('moment')

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

function formatData(rows) {
    return rows.map(row => {
        return Object.assign({}, row)
    })
}

function getCurMonthConclusionOverviewData (submitYear, submitMonth, submitter) {
  return new Promise(function (resolve, reject) {
    let sql = $sql.conclusion.getCurMonthConclusionOverviewData
    let arrayParams = [submitYear, submitMonth, submitter]
    RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
      resolve(RCPDDatabaseRes)
    }).catch(RCPDDatabaseErr => {
      reject(RCPDDatabaseErr)
    })
  })
}

function getCurMonthConclusionOverviewDataNew (conclusionYear, conclusionMonth, checkUserID, evaUserDuty, evaUserID) {
  return new Promise(function (resolve, reject) {
    let sql = $sql.conclusion.getCurMonthConclusionOverviewDataNew
    let arrayParams = []
    let finalResult = {
        conclusionData: [],
        AMEvaedData: []
    }
    arrayParams = [conclusionYear, conclusionMonth, checkUserID]
    RCPDDatabase(sql, arrayParams).then(conclusionData => {
      let checkConclusionID = []
      for (let i = 0; i < conclusionData.length; i++) {
        if (conclusionData[i].submitStatus === 1 &&
            (conclusionData[i].dimension === 1 || conclusionData[i].dimension === 2)) { // 提交状态为已提交且类型为1或2的月总结
            checkConclusionID.push(conclusionData[i].id)
        }
      }
      if (checkConclusionID.length === 0) {
        checkConclusionID = [-1]
      }
      if (evaUserDuty !== 1) { // 如果是普通成员，只获取本人对该用户的评价
        sql = $sql.achievementsEva.getUserofAchievementToAnotherUser
        arrayParams = [checkConclusionID, evaUserID]
      } else { // 如果是处经理，获取所有人对该用户的评价
        sql = $sql.achievementsEva.getOtherUserConclusionEvaedData
        arrayParams = [checkConclusionID]
      }
      RCPDDatabase(sql, arrayParams).then(AMEvaedData => {
        finalResult.conclusionData = conclusionData
        finalResult.AMEvaedData = AMEvaedData
        resolve(finalResult)
      }).catch(err => {
        reject(err)
      })
    }).catch(err => {
      reject(err)
    })
  })
}

const conclusion = {
  // 提交月总结
  submitMonthConclusionData (req, res) {
      let sendData = req.body
      let sql = $sql.conclusion.submitMonthConclusionData
      let submitTime = $time.formatTime()
      let updateTime = submitTime
      let arrayParams = [sendData.conclusionType, sendData.submitter, sendData.conclusionTitle, submitTime, updateTime, sendData.submitYear, sendData.submitMonth,
          sendData.submitStatus, sendData.managerRateStar, sendData.curConclusion, sendData.nextPlan, sendData.curAdvice]

      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
  },
  // 更新月总结
  updateMonthConclusionData (req, res) {
      let sendData = req.body
      let sql = $sql.conclusion.updateMonthConclusionData
      let updateTime = $time.formatTime()
      let arrayParams = [sendData.conclusionType, sendData.conclusionTitle, updateTime, sendData.submitYear,
          sendData.submitMonth, sendData.submitStatus, sendData.curConclusion, sendData.nextPlan, sendData.curAdvice,
          sendData.id]

      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
  },
  // 更新月总结状态
  updateMonthConclusionStatus (req, res) {
      let sendData = req.body
      let sql = $sql.conclusion.updateMonthConclusionStatus
      let updateTime = $time.formatTime()
      let arrayParams = [sendData.submitStatus, updateTime, sendData.id]

      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
  },
  // 提交评价数据
  submitEvaData (req, res) {
      let sendData = req.body
      let sql = $sql.conclusion.submitEvaData
      let evaTime = $time.formatTime()
      let arrayParams = [sendData.managerRateStar, sendData.getWorkTime, sendData.managerEva, evaTime,
          sendData.evaStatus, sendData.id]

      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
  },
  // 更新总结对应的工时ID
  updateWorkTimeListIdOfConclusion (req, res) {
      let sendData = req.body
      let sql = $sql.conclusion.updateWorkTimeListIdOfConclusion
      let arrayParams = [sendData.workTimeListId, sendData.conclusionId]

      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
  },
  // 提交月总结（新）
  submitMonthConclusionNew (req, res) {
      let sendData = req.body
      let sql = $sql.conclusion.submitMonthConclusionNew
      let submitTime = $time.formatTime()
      let updateTime = submitTime
      let arrayParams = [sendData.userID, sendData.conclusionType, sendData.conclusionYear, sendData.conclusionMonth,
                          sendData.dimension, sendData.content, submitTime, updateTime, sendData.submitStatus]
      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
  },
  // 更新月总结（新）
  updateMonthConclusionNew (req, res) {
      let sendData = req.body
      let sql = $sql.conclusion.updateMonthConclusionNew
      let updateTime = $time.formatTime()
      let arrayParams = [sendData.content, sendData.submitStatus, updateTime, sendData.id]
      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
  },
  // 获取月总结概览数据
  getCurMonthConclusionOverviewData (req, res) {
    let sendData = req.body
    let sql = $sql.conclusion.getCurMonthConclusionOverviewData
    let arrayParams = [sendData.submitYear, sendData.submitMonth, sendData.submitter]
    RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
        return $http.writeJson(res, {code: 1, data: formatData(RCPDDatabaseRes)[0], message: 'success'})
    }).catch(RCPDDatabaseErr => {
        return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
    })
  },
  // 获取月总结概览信息及相应的评价信息（新）
  getCurMonthConclusionOverviewDataNew (req, res) {
    let sendData = req.body
    let sql = $sql.conclusion.getCurMonthConclusionOverviewDataNew
    let arrayParams = []
    let finalResult = {
        conclusionData: [],
        AMEvaedData: []
    }
    arrayParams = [sendData.conclusionYear, sendData.conclusionMonth, sendData.checkUserID]
    RCPDDatabase(sql, arrayParams).then(conclusionData => {
      let checkConclusionID = []
      for (let i = 0; i < conclusionData.length; i++) {
        if (conclusionData[i].submitStatus === 1 &&
           (conclusionData[i].dimension === 1 || conclusionData[i].dimension === 2)) { // 提交状态为已提交且类型为1或2的月总结
            checkConclusionID.push(conclusionData[i].id)
        }
      }
      if (checkConclusionID.length === 0) {
        checkConclusionID = [-1]
      }
      if (sendData.evaUserDuty !== 1) { // 如果是普通成员，只获取本人对该用户的评价
        sql = $sql.achievementsEva.getUserofAchievementToAnotherUser
        arrayParams = [checkConclusionID, sendData.evaUserID]
      } else { // 如果是处经理，获取所有人对该用户的评价
        sql = $sql.achievementsEva.getOtherUserConclusionEvaedData
        arrayParams = [checkConclusionID]
      }
      RCPDDatabase(sql, arrayParams).then(AMEvaedData => {
        finalResult.conclusionData = conclusionData
        finalResult.AMEvaedData = AMEvaedData
        return $http.writeJson(res, {code: 1, data: finalResult, message: 'success'})
      }).catch(err => {
        return $http.writeJson(res, {code: -2, err: err, message: 'err'})
      })
    }).catch(err => {
      return $http.writeJson(res, {code: -2, err: err, message: 'err'})
    })
  },
  // 获取本年份总结概览数据
  getCurYearConclusionOverviewData (req, res) {
    let sendData = req.body
    let promises = []
    for (let i = 0; i < 12; i++) {
      let titleMonth = String(sendData.submitYear) + '-' + String((i + 1) < 10 ? '0' + String(i + 1) : String(i + 1))
      if (moment(titleMonth).isBefore(sendData.newRulesDate)) { // 请求的月份在新规则实施月份之前
        promises[i] = getCurMonthConclusionOverviewData(sendData.submitYear, i + 1, sendData.submitter)
      } else {
        promises[i] = getCurMonthConclusionOverviewDataNew(sendData.submitYear, i + 1, [sendData.submitter], null, null, null)
      }
    }
    Promise.all(promises).then(allResponse => {
      return $http.writeJson(res, {code: 1, data: allResponse, message: 'success'})
    }).catch(err => {
      return $http.writeJson(res, {code: -2, err: err, message: 'err'})
    })
  }
}

module.exports = conclusion
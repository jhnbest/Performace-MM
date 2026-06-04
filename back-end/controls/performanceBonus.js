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

// function getPMBRulesRecursion(params) {
//   let promises = []
//   let count = 0

//   return new Promise(function (resolve, reject) {
//     let sql = $sql.performanceBonus.getPMBRules
//     for (let i = 0; i < params.length; i++) {
//       let arrayParams = [params[i].id]
//       RCPDDatabase(sql, arrayParams).then(result => {
//         if (result.length !== 0) {
//           console.log('result')
//           console.log(result)
//           params.children = result
//           getPMBRulesRecursion(result)
//         } else {
//           console.log('============')
//           resolve(result)
//         }
//       }).catch(err => {
//         reject(err)
//       })
//     }
//   })
// }

function PMBRulesRecursion(params) {
  return new Promise(function (resolve, reject) {
    let sql = $sql.performanceBonus.getPMBRules
    for (let i = 0; i < params.length; i++) {
      let arrayParams = [params[i].id]
      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
        RCPDDatabaseRes = JSON.stringify(RCPDDatabaseRes)
        RCPDDatabaseRes = JSON.parse(RCPDDatabaseRes)
        if (RCPDDatabaseRes.length !== 0) {
          params[i].children = RCPDDatabaseRes
          PMBRulesRecursion(RCPDDatabaseRes)
        }
      })
    }
  })
}

const performanceBonus = {
  // **获取绩效加分数据(通过用户ID)
  getPMBDataByUserID (req, res) {
    $http.userVerify(req, res, () => {
      let sendData = req.body
      let sql = $sql.performanceBonus.getPMBDataByUserID
      let arrayParams = [sendData.userID]

      RCPDDatabase(sql, arrayParams).then(PMBData => {
        let checkID = []
        for (let item of PMBData) {
          item.submitTime = moment(item.submitTime).format('YYYY-MM-DD hh:mm:ss')
          checkID.push(item.id)
        }
        if (checkID.length === 0) {
          checkID.push(-1)
        }
        sql = $sql.performanceBonus.getPMBAssignDataByPBID
        arrayParams = [checkID]
        RCPDDatabase(sql, arrayParams).then(PBScoreAssign => {
          for (let item of PMBData) {
            item.PBScoreAssign = PBScoreAssign.filter(item2 => { return item2.PBDataID === item.id })
          }
          return $http.writeJson(res, {code: 1, data: PMBData, message: 'success'})
        }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
    })
  },
  // **获取绩效加分数据
  getPBData (req, res) {
    $http.userVerify(req, res, () => {
      let sendData = req.body
      let sql = $sql.performanceBonus.getPMBData
      let arrayParams = [sendData.applyYear, sendData.applyMonth]

      RCPDDatabase(sql, arrayParams).then(PBData => {
        let checkID = []
        for (let item of PBData) {
          item.submitTime = moment(item.submitTime).format('YYYY-MM-DD hh:mm:ss')
          checkID.push(item.id)
        }
        if (PBData.length !== 0) {
          sql = $sql.performanceBonus.getPMBAssignDataByPBID
          arrayParams = [checkID]
          RCPDDatabase(sql, arrayParams).then(PBScoreAssign => {
            for (let item of PBData) {
              item.PBScoreAssign = PBScoreAssign.filter(item2 => { return item2.PBDataID === item.id })
            }
            return $http.writeJson(res, {code: 1, data: PBData, message: 'success'})
          }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
          })
        } else {
          return $http.writeJson(res, {code: 1, data: PBData, message: 'success'})
        }
      }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
    })
  },
  // **获取绩效加分规则（老方案，需要优化）
  getPMBRules (req, res) {
    $http.userVerify(req, res, () => {
      let sql = $sql.performanceBonus.getPMBRules
      let arrayParams = [0]

      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
        setTimeout(function () {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: '获取列表成功'})
        }, 250)
        PMBRulesRecursion(RCPDDatabaseRes)
      }).catch(RCPDDatabaseErr => {
        return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
    })
  },
  // // **获取绩效加分规则(优化方案，还没写完)
  // getPMBRules (req, res) {
  //   let sql = $sql.performanceBonus.getPMBRules
  //   let arrayParams = [0]
  //   let count = 0
  //   let promises = []

  //   RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
  //     getPMBRulesRecursion(RCPDDatabaseRes).then(() => {
  //       return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
  //     })
  //   }).catch(RCPDDatabaseErr => {
  //       return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
  //   })
  // }

  // **获取绩效加分标准(通过ID)
  getPMBRulesByID (req, res) {
    $http.userVerify(req, res, () => {
      let sql = $sql.performanceBonus.getPMBRulesByID
      let sendData = req.body
      let arrayParams = [sendData.id]

      RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
        return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
      }).catch(RCPDDatabaseErr => {
        return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
      })
    })
  },

  // **提交绩效加分数据
  submitPBData (req, res) {
    $http.userVerify(req, res, () => {
      let sql = null
      let sendData = req.body
      let arrayParams = []
      let promises = []
      let count = 0
      let submitTime = $time.formatTime()
      let updateTime = submitTime
      let reviewStatus = 0
      let obsoleteStatus = 0
      let submitPBDataLen = sendData.PBRuleIDs.length
      for (let i = 0; i < submitPBDataLen; i++) {
        sql = $sql.performanceBonus.submitPBData
        arrayParams = [sendData.PBName, sendData.userID, submitTime, updateTime, sendData.applyYear, sendData.applyMonth,
                       sendData.PBRuleIDs[i], sendData.kValue[i], sendData.submitStatus, reviewStatus, sendData.PBComments[i], obsoleteStatus]
        promises[count++] = RCPDDatabase(sql, arrayParams)
      }
      Promise.all(promises).then(result1 => {
        for (let i = 0; i < result1.length; i++) {
          sql = $sql.performanceBonus.submitPBAssignData
          for (let j = 0; j < sendData.PBScoreAssign[i].length; j++) {
            arrayParams = [result1[i].insertId, sendData.PBScoreAssign[i][j].userID, sendData.PBScoreAssign[i][j].role,
                           sendData.PBScoreAssign[i][j].assignScore, obsoleteStatus]
            promises = []
            count = 0
            promises[count++] = RCPDDatabase(sql, arrayParams)
          }
        }
        Promise.all(promises).then((result2) => {
          return $http.writeJson(res, {code: 1, data: result2, message: 'success'})
        }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    })
  },

  // **更新绩效加分数据
  updatePBData (req, res) {
    $http.userVerify(req, res, () => {
      let sql = null
      let sendData = req.body
      let promises = []
      let count = 0
      let arrayParams = []
      let updateTime = $time.formatTime()
      let submitStatus = sendData.submitStatus
      let reviewStatus = sendData.reviewStatus
      let obsoleteStatus = 0
      sql = $sql.performanceBonus.updatePBData
      arrayParams = [sendData.PBName, sendData.userID, updateTime, sendData.applyYear, sendData.applyMonth,
        sendData.PBRuleID, sendData.kValue, submitStatus, reviewStatus, sendData.PBComments, obsoleteStatus, sendData.id]
      promises[count++] = RCPDDatabase(sql, arrayParams)

      sql = $sql.performanceBonus.getPMBAssignDataByPBID
      arrayParams = [[sendData.id]]
      promises[count++] = RCPDDatabase(sql, arrayParams)
      Promise.all(promises).then((result1) => {
        promises = []
        count = 0
        // ***(1)先更新原有的分配人员数据或新增分配人员数据
        for (let i = 0; i < sendData.PBScoreAssign.length; i++) {
          if (sendData.PBScoreAssign[i].id !== null) { // **更新已有分配人员数据
            sql = $sql.performanceBonus.updatePBAssignData
            arrayParams = [sendData.PBScoreAssign[i].PBDataID, sendData.PBScoreAssign[i].userID,
                            sendData.PBScoreAssign[i].role, sendData.PBScoreAssign[i].assignScore,
                            obsoleteStatus, sendData.PBScoreAssign[i].id]
            promises[count++] = RCPDDatabase(sql, arrayParams)
          } else {
            sql = $sql.performanceBonus.submitPBAssignData // **新增分配人员数据
            arrayParams = [sendData.PBScoreAssign[i].PBDataID, sendData.PBScoreAssign[i].userID,
                            sendData.PBScoreAssign[i].role, sendData.PBScoreAssign[i].assignScore,
                            obsoleteStatus]
            promises[count++] = RCPDDatabase(sql, arrayParams)
          }
        }
        // ***(2)删除原有的分配人员数据（若有）
        for (let result1Item of result1[1]) {
          let findIndex = sendData.PBScoreAssign.findIndex(item => { return item.id === result1Item.id })
          if (findIndex === -1) {
            sql = $sql.performanceBonus.deletePBAssignData
            obsoleteStatus = 1
            arrayParams = [obsoleteStatus, result1Item.id]
            promises[count++] = RCPDDatabase(sql, arrayParams)
          }
        }
        Promise.all(promises).then((result2) => {
          return $http.writeJson(res, {code: 1, data: result2, message: 'success'})
        }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    })
  }
}

module.exports = performanceBonus
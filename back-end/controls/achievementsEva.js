const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')

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

const achievementsEva = {
    // 获取全处成效评价历史数据
    getAllAchievements (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let resultData = []
        let promises = []
        let sql = null
        let arrayParams = []
        for (let i = 0; i < sendData.userList.length; i++) {
            sql = $sql.mutualRates.getPerformanceRatedData
            arrayParams = [sendData.userList[i].id, sendData.rateMonth]
            promises.push(RCPDDatabase(sql, arrayParams))
            sql = $sql.mutualRates.getPerformanceRates
            promises.push(RCPDDatabase(sql, arrayParams))
        }
        Promise.all(promises).then(result => {
            let j = 0
            for (let i = 0; i < sendData.userList.length; i++) {
                j = i * 2
                let obj = {
                    id: sendData.userList[i].id,
                    name: sendData.userList[i].name,
                    groupName: sendData.userList[i].groupName,
                    duty: sendData.userList[i].duty,
                    ratedData: result[j],
                    rateData: result[j + 1]
                }
                resultData.push(obj)
            }
            return $http.writeJson(res, { code: 1, data: resultData, message: '成功' })
        })
      })
    },
    // 获取某个用户对某个用户的成效评价
    getUserofAchievementToAnotherUser (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.achievementsEva.getUserofAchievementToAnotherUser
        let arrayParams = [sendData.conclusionID, sendData.evaUserID]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    },
    // **提交成效评价
    submitAMEvaData (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.achievementsEva.submitAMEvaData
        let submitTime = $time.formatTime()
        let updateTime = submitTime
        let arrayParams = [sendData.evaUserID, sendData.dimensionID, sendData.evaStar, submitTime, updateTime]
        RCPDDatabase(sql, arrayParams).then(RCPDatabaseRes => {
            if (RCPDatabaseRes && RCPDatabaseRes.affectedRows === 1) {
                return $http.writeJson(res, {code: 1, data: RCPDatabaseRes, message: 'success'})
            } else {
                return $http.writeJson(res, {code: -2, message: '评价数据保存失败，请重试'})
            }
        }).catch(RCPDatabaseErr => {
            let errMsg = RCPDatabaseErr && RCPDatabaseErr.message ? RCPDatabaseErr.message : ''
            if (errMsg.includes('Duplicate entry')) {
                return $http.writeJson(res, {code: -3, message: '该评价已存在，请勿重复提交'})
            } else if (errMsg.includes('foreign key constraint')) {
                return $http.writeJson(res, {code: -4, message: '评价维度不存在或已失效'})
            }
            return $http.writeJson(res, {code: -2, err: RCPDatabaseErr, message: '评价数据保存失败'})
        })
      })
    },
    // 更新成效评价
    updateAMEvaData (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.achievementsEva.updateAMEvaData
        let updateTime = $time.formatTime()
        let arrayParams = [sendData.evaStar, updateTime, sendData.evaDataID]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    },
    // 获取对某个总结的所有评价
    getAchievementEvaOfConclusionDimension (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.achievementsEva.getAchievementEvaOfConclusionDimension
        let arrayParams = [sendData.conclusionID]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    },
    // 获取某个用户的所有被评价数据
    getUserConclusionEvaedData (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.achievementsEva.getUserConclusionEvaedData
        let arrayParams = [sendData.evaedUserID, sendData.conclusionYear, sendData.conclusionMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDatabaseRes, message: 'success'})
        }).catch(RCPDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDatabaseErr, message: 'false'})
        })
      })
    },
    // 获取某个用户的所有被评价数据
    getUserConclusionEvaedData (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.achievementsEva.getUserConclusionEvaedData
        let arrayParams = [sendData.evaedUserID, sendData.conclusionYear, sendData.conclusionMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDatabaseRes, message: 'success'})
        }).catch(RCPDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDatabaseErr, message: 'false'})
        })
      })
    },
    // ***添加失败成效评价数据
    addFailedAMEvaData (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.failedAMEvaData.add
        let arrayParams = [
          sendData.evaUserID,
          sendData.evaUserName,
          sendData.evaedUserID,
          sendData.evaedUserName,
          sendData.dimensionID,
          sendData.dimension,
          sendData.dimensionName,
          sendData.evaStar,
          sendData.conclusionYear,
          sendData.conclusionMonth,
          sendData.errorCode,
          sendData.errorMessage
        ]
        RCPDDatabase(sql, arrayParams).then(RCPDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDatabaseRes, message: 'success'})
        }).catch(RCPDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDatabaseErr, message: 'false'})
        })
      })
    },
    // ***获取失败成效评价数据
    getFailedAMEvaData (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.failedAMEvaData.getByEvaUserID
        let arrayParams = [sendData.evaUserID, sendData.conclusionYear, sendData.conclusionMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDatabaseRes, message: 'success'})
        }).catch(RCPDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDatabaseErr, message: 'false'})
        })
      })
    },
    // ***获取所有失败成效评价数据（监控用）
    getAllFailedAMEvaData (req, res) {
      $http.userVerify(req, res, () => {
        let sql = $sql.failedAMEvaData.getAll
        RCPDDatabase(sql, []).then(RCPDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDatabaseRes, message: 'success'})
        }).catch(RCPDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDatabaseErr, message: 'false'})
        })
      })
    },
    // ***更新失败成效评价为重试成功
    updateFailedAMEvaRetrySuccess (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.failedAMEvaData.updateRetrySuccess
        let arrayParams = [sendData.evaUserID, sendData.dimensionID]
        RCPDDatabase(sql, arrayParams).then(RCPDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDatabaseRes, message: 'success'})
        }).catch(RCPDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDatabaseErr, message: 'false'})
        })
      })
    },
    // ***删除失败成效评价数据
    deleteFailedAMEvaData (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.failedAMEvaData.delete
        let arrayParams = [sendData.id]
        RCPDDatabase(sql, arrayParams).then(RCPDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDatabaseRes, message: 'success'})
        }).catch(RCPDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDatabaseErr, message: 'false'})
        })
      })
    },
    // ***清除失败成效评价数据
    clearFailedAMEvaData (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.failedAMEvaData.deleteByEvaUserID
        let arrayParams = [sendData.evaUserID, sendData.conclusionYear, sendData.conclusionMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDatabaseRes, message: 'success'})
        }).catch(RCPDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDatabaseErr, message: 'false'})
        })
      })
  }
}

module.exports = achievementsEva
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
    },
    // 获取某个用户对某个用户的成效评价
    getUserofAchievementToAnotherUser (req, res) {
        let sendData = req.body
        let sql = $sql.achievementsEva.getUserofAchievementToAnotherUser
        let arrayParams = [sendData.conclusionID, sendData.evaUserID]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 提交成效评价
    submitAMEvaData (req, res) {
        let sendData = req.body
        let sql = $sql.achievementsEva.submitAMEvaData
        let submitTime = $time.formatTime()
        let updateTime = submitTime
        let arrayParams = [sendData.evaUserID, sendData.dimensionID, sendData.evaStar, submitTime, updateTime]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 更新成效评价
    updateAMEvaData (req, res) {
        let sendData = req.body
        let sql = $sql.achievementsEva.updateAMEvaData
        let updateTime = $time.formatTime()
        let arrayParams = [sendData.evaStar, updateTime, sendData.evaDataID]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 获取对某个总结的所有评价
    getAchievementEvaOfConclusionDimension (req, res) {
        let sendData = req.body
        let sql = $sql.achievementsEva.getAchievementEvaOfConclusionDimension
        let arrayParams = [sendData.conclusionID]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 获取某个用户的所有被评价数据
    getUserConclusionEvaedData (req, res) {
        let sendData = req.body
        let sql = $sql.achievementsEva.getUserConclusionEvaedData
        let arrayParams = [sendData.evaedUserID, sendData.conclusionYear, sendData.conclusionMonth]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    }
}

module.exports = achievementsEva
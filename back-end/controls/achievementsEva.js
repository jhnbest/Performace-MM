const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')

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
    }
}

module.exports = achievementsEva
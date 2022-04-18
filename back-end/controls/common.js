const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')
const res = require('express/lib/response')

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

const common = {
    // 根据时间获取某个类型数据的全局标志位
    getTypeGlobalFlag(req, res) {
        let sendData = req.body
        let sql = $sql.common.getTypeGlobalFlag
        let arrayParams = [sendData.applyYear, sendData.applyMonth, sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 根据数据类型获取全局标志位
    getGlobalFlagByType(req, res) {
        let sendData = req.body
        let sql = $sql.common.getGlobalFlagByType
        let arrayParams = [sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 更新某种类型的全局标志位
    updateGlobalFlagVal (req, res) {
        let sendData = req.body
        let sql = $sql.common.updateGlobalFlagVal
        let arrayParams = [sendData.flagValue, sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 从数据库获取各种评价系数
    getEvaCoef (req, res) {
      let sql = $sql.common.getGlobalFlagByType
      let evaCoefType = ['CSMutualCoef', 'MGEvaCoef', 'quantitativeCoef', 'PMEvaCoef', 'CSManagerAMEvaCoef'
      , 'CSGroupLeaderAMEvaCoef', 'CScommonStaffAMEvaCoef', 'GPManagerAMEvaCoef', 'GPCommonStaffAMEvaCoef'
      , 'AMBuildBoutiqueProjectCoef', 'AMBuildProTeamCoef']
      let arrayParams = []
      let promise = []
      let count = 0
      for (let item of evaCoefType) {
        arrayParams = [item]
        promise[count++] = RCPDDatabase(sql, arrayParams)
      }
      Promise.all(promise).then(allResponse => {
        return $http.writeJson(res, {code: 1, data: allResponse, message: 'success'})
      }).catch(err => {
        return $http.writeJson(res, {code: -2, err: err, message: 'false'})
      })
    }
}
module.exports = common
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

function formatData(rows) {
  return rows.map(row => {
    if(row.create_time) {
      row.create_time = $time.formatTime(row.create_time)
    }
    if(row.update_time) {
      row.update_time = $time.formatTime(row.update_time)
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
    let role = row.role
    if (role) {
      switch (role) {
        case 1:
          row.role = '管理员'
          break
        case 2:
          row.role = '组长'
          break
        case 3:
          row.role = '普通成员'
          break
      }
    }
    let dept = row.dept
    if (dept) {
      switch (dept) {
        case 1:
          row.dept = '通信工程处'
      }
    }
    row.groupID = row.groupName
    if (row.groupName) {
      switch (row.groupName) {
        case 1:
          row.groupName = '管理组'
          break
        case 2:
          row.groupName = '多媒体应用组'
          break
        case 3:
          row.groupName = '数字物联组'
          break
        case 4:
          row.groupName = '综合业务组'
          break
        case 5:
          row.groupName = '通信组'
          break
      }
    }
    return Object.assign({}, row)
  })
}

const common = {
    // 根据时间获取某个类型数据的全局标志位
    getTypeGlobalFlag(req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.common.getTypeGlobalFlag
        let arrayParams = [sendData.applyYear, sendData.applyMonth, sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    },
    // 根据数据类型获取全局标志位
    getGlobalFlagByType(req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.common.getGlobalFlagByType
        let arrayParams = [sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    },
    // 更新某种类型的全局标志位
    updateGlobalFlagVal (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.common.updateGlobalFlagVal
        let arrayParams = [sendData.flagValue, sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    },
    // 从数据库获取各种评价系数
    getEvaCoef (req, res) {
      $http.userVerify(req, res, () => {
        let sql = $sql.common.getGlobalFlagByType
        let checkType = ['CSMutualCoef', 'MGEvaCoef', 'quantitativeCoef', 'PMEvaCoef', 'CSManagerAMEvaCoef'
        , 'CSGroupLeaderAMEvaCoef', 'CScommonStaffAMEvaCoef', 'GPManagerAMEvaCoef', 'GPCommonStaffAMEvaCoef'
        , 'AMBuildBoutiqueProjectCoef', 'AMBuildProTeamCoef', 'AMDimension1CoefV2', 'AMDimension2CoefV2']
        let arrayParams = [checkType]
        RCPDDatabase(sql, arrayParams).then(allResponse => {
          return $http.writeJson(res, {code: 1, data: allResponse, message: 'success'})
        }).catch(err => {
          return $http.writeJson(res, {code: -2, err: err, message: 'false'})
        })
      })
    },
    // ***根据时间获取全局标志位
    getGlobalFlagByTime (req, res) {
      $http.userVerify(req, res, () => {
        let sendData = req.body
        let sql = $sql.common.getGlobalFlagByTime
        let arrayParams = [sendData.flagType, sendData.year, sendData.month]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
          return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
          return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
      })
    }
}
module.exports = common
const moment = require('moment')
const $http = require('../sql/http')

const $common = {
  RCPDDatabase(sql, arrayParams) {
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
}

module.exports = $common
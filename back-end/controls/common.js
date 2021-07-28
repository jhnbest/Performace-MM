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

const common = {
}
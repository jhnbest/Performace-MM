const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')

const mutualRate = {
    // 获取互评信息
    getUserRates (req, res) {
        let data = req.body
        let sql = $sql.mutualRates.getUserRates
        let arrayParams = [data.userID, data.rateMonth]
        $http.connPool(sql, arrayParams, (err, result) =>{
            if (err) {
                return $http.writeJson(res, {code: -2, message: '失败',errMsg: err})
            } else {
                result = JSON.parse(JSON.stringify(result))
                console.log(result)
                return $http.writeJson(res, {code: 1, data: result, message: '成功'})
            }
        })
    },
    // 提交互评信息
    submitRatesResult (req, res) {
        let data = req.body
    }
}

module.exports = mutualRate
/**
 * 数据库操作封装模块
 * 提供异步数据库操作功能
 */
const $http = require('../sql/http')

/**
 * 数据库操作封装 - 返回Promise
 * @param {string} sql - SQL语句
 * @param {Array} arrayParams - 参数数组
 * @returns {Promise<Object>} 查询结果
 */
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

module.exports = {
    RCPDDatabase
}

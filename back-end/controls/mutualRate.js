const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')

function starToRates(star) {
    switch (star) {
        case 1:
            return 82.5
        case 2:
            return 85
        case 3:
            return 87.5
        case 4:
            return 90
        case 5:
            return 92.5
        default:
            return 87.5
    }
}

const rateTypes = [{
    id: 1,
    rateTypeName: 't1Star'
}, {
    id: 2,
    rateTypeName: 't2Star'
}, {
    id: 3,
    rateTypeName: 't3Star'
}, {
    id: 4,
    rateTypeName: 't4Star'
}, {
    id: 5,
    rateTypeName: 't5Star'
}, {
    id: 6,
    rateTypeName: 't6Star'
}]

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

async function ratesResultFun (param) {
    for (let item1 of param.data) {
        for (let item2 of rateTypes) {
            let rate = starToRates(item1[item2.rateTypeName])
            let rateType = item2.id
            let ratedPersion = item1.ratedID
            let ratePersion = param.userID
            let rateMonth = param.title
            let sql = $sql.mutualRates.submitRatesResult
            let rateTime = $time.formatTime()
            let updateTime = rateTime
            let arrayParams = [ratePersion, ratedPersion, rateMonth, rate, rateType, rateTime, updateTime]
            await RCPDDatabase(sql, arrayParams)
        }
    }
}

const mutualRate = {
    // 获取互评信息
    getUserRates (req, res) {
        let data = req.body
        let sql = $sql.mutualRates.getUserRates
        let arrayParams = [data.userID, data.rateMonth]
        $http.connPool(sql, arrayParams, (err, result) => {
            if (err) {
                return $http.writeJson(res, {code: -2, message: '失败',errMsg: err})
            } else {
                result = JSON.parse(JSON.stringify(result))
                return $http.writeJson(res, {code: 1, data: result, message: '成功'})
            }
        })
    },
    // 提交互评信息
    submitRatesResult (req, res) {
        let data = req.body
        ratesResultFun(data).then()
        return $http.writeJson(res, {code: 1, data: 'yes', message: '成功'})
    },
    // 更新互评信息
    async updateUserRate (req, res) {
        let data = req.body
        let sql = $sql.mutualRates.updateUserRate
        let updateTime = $time.formatTime()
        let arrayParams = []
        console.log(data)
        for (let item of data.ratesToUpdate) {
            arrayParams = [item.rate, updateTime, item.id]
            await RCPDDatabase(sql, arrayParams)
        }
        return $http.writeJson(res, {code: 1, data: 'success', message: '成功'})
    },
    // 获取本人互评得分
    getCurMutualRate (req, res) {
        let data = req.body
        let sql = $sql.mutualRates.getCurMutualRate
        let arrayParams = [data.userID, data.rateMonth]
        RCPDDatabase(sql, arrayParams).then(res0 => {
            return $http.writeJson(res, { code: 1, data: res0, message: 'success'})
        })
    },
    // 获取本处员工互评得分
    async getAllUserRates (req, res) {
        let data = req.body
        let resultData = []
        for (let item of data.usersData) {
            let sql = $sql.mutualRates.getCurMutualRate
            let arrayParams = [item.id, data.rateMonth]
            await RCPDDatabase(sql, arrayParams).then(async (res0) => {
                sql = $sql.mutualRates.getRateData
                await RCPDDatabase(sql, arrayParams).then(async (res1) => {
                    let obj = {
                        id: item.id,
                        name: item.name,
                        groupName: item.groupName,
                        ratedData: res0,
                        rateData: res1
                    }
                    resultData.push(obj)
                })
            })
        }
        return $http.writeJson(res, { code: 1, data: resultData, message: '成功' })
    }
}

module.exports = mutualRate
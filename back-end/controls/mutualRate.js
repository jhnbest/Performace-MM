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
        let sendData = req.body
        let promises = []
        for (let item1 of sendData.data) {
            for (let item2 of rateTypes) {
                let rate = starToRates(item1[item2.rateTypeName])
                let rateType = item2.id
                let ratedPersion = item1.ratedPersion
                let ratePersion = sendData.userID
                let rateMonth = sendData.title
                let sql = $sql.mutualRates.submitRatesResult
                let rateTime = $time.formatTime()
                let arrayParams = [ratePersion, ratedPersion, rateMonth, rate, rateType, rateTime, rateTime]
                promises.push(RCPDDatabase(sql, arrayParams))
            }
        }
        Promise.all(promises).then(() => {
            return $http.writeJson(res, {code: 1, data: 'yes', message: '成功'})
        })
    },
    // 更新互评信息
    async updateUserRate (req, res) {
        let data = req.body
        let sql = $sql.mutualRates.updateUserRate
        let updateTime = $time.formatTime()
        let arrayParams = []
        let promises = []
        for (let i = 0; i < data.ratesToUpdate.length; i++) {
            arrayParams = [data.ratesToUpdate[i].rate, updateTime, data.ratesToUpdate[i].id]
            promises[i] = RCPDDatabase(sql, arrayParams)
        }
        Promise.all(promises).then(() => {
            return $http.writeJson(res, {code: 1, data: 'success', message: '成功'})
        })
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
    // // 获取本处员工互评得分
    // async getAllUserRates (req, res) {
    //     let data = req.body
    //     let resultData = []
    //     for (let item of data.usersData) {
    //         let sql = $sql.mutualRates.getCurMutualRate
    //         let arrayParams = [item.id, data.rateMonth]
    //         await RCPDDatabase(sql, arrayParams).then(async (res0) => {
    //             sql = $sql.mutualRates.getRateData
    //             await RCPDDatabase(sql, arrayParams).then(async (res1) => {
    //                 let obj = {
    //                     id: item.id,
    //                     name: item.name,
    //                     groupName: item.groupName,
    //                     ratedData: res0,
    //                     rateData: res1
    //                 }
    //                 resultData.push(obj)
    //             })
    //         })
    //     }
    //     return $http.writeJson(res, { code: 1, data: resultData, message: '成功' })
    // },
    // 获取本处员工互评得分
    async getAllUserRates (req, res) {
        let data = req.body
        let resultData = []
        let promises = []
        let sql = null
        let arrayParams = []
        for (let i = 0; i < data.usersData.length; i++) {
            sql = $sql.mutualRates.getCurMutualRate
            arrayParams = [data.usersData[i].id, data.rateMonth]
            promises.push(RCPDDatabase(sql, arrayParams))
            sql = $sql.mutualRates.getRateData
            promises.push(RCPDDatabase(sql, arrayParams))
        }
        Promise.all(promises).then(result => {
            let j = 0
            for (let i = 0; i < data.usersData.length; i++) {
                j = i * 2
                let obj = {
                    id: data.usersData[i].id,
                    name: data.usersData[i].name,
                    groupName: data.usersData[i].groupName,
                    ratedData: result[j],
                    rateData: result[j + 1]
                }
                resultData.push(obj)
            }
            return $http.writeJson(res, { code: 1, data: resultData, message: '成功' })
        })
    },
    // 获取绩效信息统计标志
    getPerformanceIsCount (req, res) {
        let sendData = req.body
        let sql = $sql.mutualRates.getPerformanceIsCount
        let arrayParams = [sendData.year, sendData.month, sendData.flagType]
        RCPDDatabase(sql, arrayParams).then(res0 => {
            return $http.writeJson(res, {code: 1, data: res0, message: 'success'})
        }).catch(err => {
            return $http.writeJson(res, {code: -2, err: err, message: 'false'})
        })
    },
    // 提取上月互评结果
    getPreMonthEva (req, res) {
        let sendData = req.body
        let sql = $sql.mutualRates.getPreMonthEva
        console.log(sendData)
        let arrayParams = [sendData.rateMonth, sendData.userID]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    }
}

module.exports = mutualRate
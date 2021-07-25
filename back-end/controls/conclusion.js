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

const conclusion = {
    // 提交月总结
    submitMonthConclusionData (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.submitMonthConclusionData
        let submitTime = $time.formatTime()
        let updateTime = submitTime
        let arrayParams = [sendData.submitter, sendData.title, submitTime, updateTime, sendData.submitYear, sendData.submitMonth,
            sendData.submitStatus, sendData.managerRateStar, sendData.curConclusion, sendData.nextPlan, sendData.curAdvice]

        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            console.log('err')
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 获取月总结概览数据
    getCurMonthConclusionOverviewData (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.getCurMonthConclusionOverviewData
        let arrayParams = [sendData.submitYear, sendData.submitMonth, sendData.submitter]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 一键填充定性评价
    handleFillMul (req, res) {
        let sendData = req.body
        let sql = $sql.mutualRates.handleFillMul
        let arrayParams = []
        let promises = []
        let promises2 = []
        let promise3 = []
        let count = 0
        let count2 = 0
        let count3 = 0
        for (let i = 0; i < sendData.users.length; i++) {
            if (sendData.users[i].id === 26) {
                sendData.users.splice(i, 1)
            }
        }
        for (let usersItem of sendData.users) {
            if (usersItem.id !== 26) {
                arrayParams = [usersItem.id, sendData.rateMonth]
                promises[count++] = RCPDDatabase(sql, arrayParams)
            }
        }
        Promise.all(promises).then(result => {
            for (let i = 0; i < result.length; i++) {
                result[i][0].userName = sendData.users[i].name
                result[i][0].userID = sendData.users[i].id
            }
            for (let resultItem of result) {
                if (resultItem[0].totalCount === 0) {
                    sql = $sql.mutualRates.handleFillMulCheck // 找上上月份的评价数据
                    arrayParams = [resultItem[0].userID]
                    promises2[count2++] = RCPDDatabase(sql, arrayParams)
                }
            }
            Promise.all(promises2).then(result2 => {
                let rateTime = $time.formatTime()
                for (let result2Item of result2) {
                    for (let result2ItemItem of result2Item) {
                        sql = $sql.mutualRates.handleFillMulFill
                        arrayParams = [result2ItemItem.ratePersion, result2ItemItem.ratedPersion, '2021-06', result2ItemItem.rate,
                            result2ItemItem.rateType, rateTime, rateTime]
                        promise3[count3++] = RCPDDatabase(sql, arrayParams)
                    }
                }
                Promise.all(promise3).then(result3 => {
                    return $http.writeJson(res, {code: 1, data: result3, message: 'success'})
                })
            })
        }).catch(error => {
            return $http.writeJson(res, {code: -2, err: error, message: 'false'})
        })

    }
}

module.exports = conclusion
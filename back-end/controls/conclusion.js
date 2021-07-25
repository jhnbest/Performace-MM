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
        let arrayParams = [sendData.conclusionType, sendData.submitter, sendData.conclusionTitle, submitTime, updateTime, sendData.submitYear, sendData.submitMonth,
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
    }
}

module.exports = conclusion
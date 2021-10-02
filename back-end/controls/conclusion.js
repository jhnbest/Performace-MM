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

function formatData(rows) {
    return rows.map(row => {
        return Object.assign({}, row)
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
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 更新月总结
    updateMonthConclusionData (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.updateMonthConclusionData
        let updateTime = $time.formatTime()
        let arrayParams = [sendData.conclusionType, sendData.conclusionTitle, updateTime, sendData.submitYear,
            sendData.submitMonth, sendData.submitStatus, sendData.curConclusion, sendData.nextPlan, sendData.curAdvice,
            sendData.id]

        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 获取月总结概览数据
    getCurMonthConclusionOverviewData (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.getCurMonthConclusionOverviewData
        let arrayParams = [sendData.submitYear, sendData.submitMonth, sendData.submitter]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: formatData(RCPDDatabaseRes)[0], message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 更新月总结状态
    updateMonthConclusionStatus (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.updateMonthConclusionStatus
        let updateTime = $time.formatTime()
        let arrayParams = [sendData.submitStatus, updateTime, sendData.id]

        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 提交评价数据
    submitEvaData (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.submitEvaData
        let evaTime = $time.formatTime()
        let arrayParams = [sendData.managerRateStar, sendData.getWorkTime, sendData.managerEva, evaTime,
            sendData.evaStatus, sendData.id]

        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 更新总结对应的工时ID
    updateWorkTimeListIdOfConclusion (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.updateWorkTimeListIdOfConclusion
        let arrayParams = [sendData.workTimeListId, sendData.conclusionId]

        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    }
}

module.exports = conclusion
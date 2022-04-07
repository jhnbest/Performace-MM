const $sql = require('../sql/sqlMap')
const $http = require('../sql/http')
const $time = require('../utils/time')
const moment = require('moment')

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
    },
    // 提交月总结（新）
    submitMonthConclusionNew (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.submitMonthConclusionNew
        let submitTime = $time.formatTime()
        let updateTime = submitTime
        let arrayParams = [sendData.userID, sendData.conclusionType, sendData.conclusionYear, sendData.conclusionMonth,
                            sendData.dimension, sendData.content, submitTime, updateTime, null, sendData.submitStatus]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // 更新月总结（新）
    updateMonthConclusionNew (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.updateMonthConclusionNew
        let updateTime = $time.formatTime()
        let arrayParams = [sendData.content, sendData.submitStatus, updateTime, sendData.id]
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    },
    // // 获取月总结概览信息（新）
    // getCurMonthConclusionOverviewDataNew (req, res) {
    //     let sendData = req.body
    //     let sql = $sql.conclusion.getCurMonthConclusionOverviewDataNew
    //     let arrayParams = [sendData.conclusionYear, sendData.conclusionMonth, sendData.userID]
    //     RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
    //         return $http.writeJson(res, {code: 1, data: RCPDDatabaseRes, message: 'success'})
    //     }).catch(RCPDDatabaseErr => {
    //         return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
    //     })
    // }
    // 获取月总结概览信息及相应的评价信息（新）
    getCurMonthConclusionOverviewDataNew (req, res) {
        let sendData = req.body
        let sql = $sql.conclusion.getCurMonthConclusionOverviewDataNew
        let arrayParams = [sendData.conclusionYear, sendData.conclusionMonth, sendData.userID]
        let obj = {
            conclusionData: [],
            AMEvaedData: []
        }
        RCPDDatabase(sql, arrayParams).then(RCPDDatabaseRes => {
            let conclusionData = RCPDDatabaseRes
            if (conclusionData.length > 0) { // 月总结数据库里有数据
                if (conclusionData[0].submitStatus === 1) { // 提交状态为已提交
                    let promises = []
                    let count = 0
                    let sql2 = null
                    let arrayParams2 = []
                    for (let conclusionDataItem of conclusionData) {
                        if (conclusionDataItem.dimension === 1 || conclusionDataItem.dimension === 2) {
                            if (sendData.evaUserDuty !== 1) { // 如果是普通成员，只获取本人对该用户的评价
                                sql2 = $sql.achievementsEva.getUserofAchievementToAnotherUser
                                arrayParams2 = [conclusionDataItem.id, sendData.evaUserID]
                                promises[count++] = RCPDDatabase(sql2, arrayParams2)
                            } else { // 如果是处经理，获取所有人对该用户的评价
                                sql2 = $sql.achievementsEva.getOtherUserConclusionEvaedData
                                arrayParams2 = [conclusionDataItem.id]
                                promises[count++] = RCPDDatabase(sql2, arrayParams2)
                            }
                        }
                    }
                    Promise.all(promises).then(allResponse => {
                        let AMEvaedData = []
                        for (let allResponseItem of allResponse) {
                            AMEvaedData = AMEvaedData.concat(allResponseItem)
                        }
                        obj.conclusionData = conclusionData
                        obj.AMEvaedData = AMEvaedData
                        return $http.writeJson(res, {code: 1, data: obj, message: 'success'})
                    })
                } else { // 提交状态为暂存
                    return $http.writeJson(res, {code: 1, data: obj, message: 'success'})
                }
            } else { // 未提交月总结
                return $http.writeJson(res, {code: 1, data: obj, message: 'success'})
            }
        }).catch(RCPDDatabaseErr => {
            return $http.writeJson(res, {code: -2, err: RCPDDatabaseErr, message: 'false'})
        })
    }
}

module.exports = conclusion
import { http } from '../config/http'
import {
    urlGetAllWorkTimeList
} from '../config/interface'
import { getUsersList } from '@/utils/users'
import { getPerformanceIsPublish } from '@/utils/common'
import { getAllUserRates } from '@/utils/multual'

import moment from 'moment'
import { apply } from 'core-js/fn/reflect'

// 获取全处工时信息
export function getAllWorkTimeList (applyDate) {
    const url = urlGetAllWorkTimeList
    let params = {
        applyMonth: applyDate
    }
    return new Promise(function (resolve, reject) {
        http(url, params).then(res => {
            if (res.code === 1) {
                let recvData = res.data
                resolve(recvData)
            } else {
                reject(new Error('getAllWorkTimeList recv error'))
            }
    }).catch((err) => {
        reject(new Error(err + '请求失败'))
    })
    })
}

// 获取全处绩效数据
export function getPMData (applyDate) {
    let applyYear = moment(applyDate).year()
    let applyMonth = moment(applyDate).month() + 1
    let promises = []
    let count = 0
    getPerformanceIsPublish(applyYear, applyMonth).then(response => {
        if (response.length > 0) {
            if (response[0].flagValue > 0) {
                getUsersList().then(responseGetUsersList => {
                    promises[count++] = getAllWorkTimeList(applyDate)
                    promises[count++] = getAllUserRates(responseGetUsersList, applyDate)
                    if (moment('2022-02-01').isAfter('2022-01-01', 'month')) { // 2022-02新增成效评价模式
                        console.log('applyDate')
                        console.log(applyDate)
                    }
                    Promise.all(promises).then(responseAll => {
                        console.log('responseAll')
                        console.log(responseAll)
                    })
                })
            }
        }
    })
}

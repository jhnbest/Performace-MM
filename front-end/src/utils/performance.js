import { http } from '../config/http'
import {
    urlGetAllWorkTimeList
} from '../config/interface'
import { getUsersList } from '@/utils/users'
import { getPerformanceIsPublish } from '@/utils/common'
import moment from 'moment'

// 获取全处工时信息
export function getAllWorkTimeList (applyMonth) {
    const url = urlGetAllWorkTimeList
    let params = {
        applyMonth: applyMonth
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
    let applyYear = moment(applyDate).year
    let applyMonth = moment(applyDate).month + 1
    getPerformanceIsPublish(applyYear, applyMonth).then(response => {
        if (response.length > 0) {
            if (response[0].flagValue > 0) {
            }
        }
    })
}

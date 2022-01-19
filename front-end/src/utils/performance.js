import { http } from '../config/http'
import {
    urlGetAllWorkTimeList
} from '../config/interface'

// 获取全处工时信息
export function getAllWorkTimeList (applyMonth) {
    console.log('applyMonth:', applyMonth)
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

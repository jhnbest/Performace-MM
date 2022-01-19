import { http } from '../config/http'
import {
  urlGetAllPerformanceRate
} from '../config/interface'

// 获取全处成效评价结果
export function getAllPerformanceRate (userList, rateMonth) {
  const url = urlGetAllPerformanceRate
  const params = {
    userList: userList,
    rateMonth: rateMonth
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.data)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

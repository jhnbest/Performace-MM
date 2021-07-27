import { http } from '../config/http'
import {
  urlGetCurApplyAbleMonth
} from '../config/interface'

// 获取当前可申报的月份
export function getCurApplyAbleMonth () {
  const url = urlGetCurApplyAbleMonth
  let params = {}
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

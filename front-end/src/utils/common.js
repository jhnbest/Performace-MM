import { http } from '../config/http'
import {
  urlGetCurApplyAbleMonth,
  urlGetAllUsersInfo
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

// 获取全处员工信息
export function getAllUsersInfo () {
  const url = urlGetAllUsersInfo
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

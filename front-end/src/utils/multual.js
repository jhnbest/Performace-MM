import { http } from '../config/http'
import {
  urlGetAllUserRates
} from '@/config/interface'

// 获取全处员工互评信息
export function getAllUserRates (users, rateMonth) {
  const url = urlGetAllUserRates
  let params = {
    usersData: users,
    rateMonth: rateMonth
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        console.log(res.err)
        reject(new Error('getAllUserRates recv error!'))
      }
    }).catch(err => {
      console.log(err)
      reject(new Error('getAllUserRates send error!'))
    })
  })
}

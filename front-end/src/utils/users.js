import { http } from '@/config/http'
import {
    urlGetUsersList
} from '@/config/interface'

// 获取用户列表
export function getUsersList (checkGroupID) {
  const url = urlGetUsersList
  let params = {
    checkGroupID: checkGroupID
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data.list)
      } else {
        reject(new Error(res.code))
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// 组别代码文字转换
export function groupName2String (groupCode) {
    switch (groupCode) {
        case 1:
            return '技术标准组'
        case 2:
            return '工程组'
        case 3:
            return '通信组'
        case 4:
            return '处经理'
    }
}

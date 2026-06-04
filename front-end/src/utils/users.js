import { http } from '@/config/http'
import {
    urlGetUsersList
} from '@/config/interface'

// **获取用户列表
// **checkGroupID: 0->全部员工；2->多媒体应用组；3->数字物联组；4->综合业务组；5->通信组
export function getUsersList (groupID) {
  const url = urlGetUsersList
  let params = {
    groupID: groupID
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

// **组别代码文字转换
export function groupID2Name (groupID) {
    switch (groupID) {
      case 1:
          return '管理组'
      case 2:
          return '多媒体应用组'
      case 3:
          return '数字物联组'
      case 4:
          return '综合业务组'
      case 5:
          return '通信组'
      default:
          return '错误'
    }
}

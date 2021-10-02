import { http } from '../config/http'
import {
  urlGetTypeProjectList
} from '../config/interface'
import store from '@/store'

// 获取特定类型的项目列表
export function getTypeProjectList (projectType, isFinish, curApplyYear) {
  const url = urlGetTypeProjectList
  let params = {
    projectType: projectType,
    isFinish: isFinish,
    curApplyYear: curApplyYear
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.code)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

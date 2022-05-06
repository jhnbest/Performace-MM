import { http } from '../config/http'
import {
  urlGetTypeProjectList,
  urlgetAssignProjectDetailV2
} from '../config/interface'

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

 // 获取指派项目计划&进展明细
 export function getAssignProjectDetailV2 (projectID, yearNum) {
   return new Promise(function (resolve, reject) {
    const url = urlgetAssignProjectDetailV2
    let params = {
      id: projectID,
      year: yearNum
    }
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
   })
}

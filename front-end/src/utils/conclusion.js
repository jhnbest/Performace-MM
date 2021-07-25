import axios from 'axios'
import store from '../store'
import router from '../router'
import common from '../assets/js/common.js'
import { http } from '../config/http'
import {
  urlGetCurMonthConclusionOverviewData,
  urlSubmitMonthConclusionData
} from '../config/interface'

export function getCurMonthConclusionOverviewData (submitMonth, submitYear, submitter) {
  const url = urlGetCurMonthConclusionOverviewData
  let params = {
    submitYear: submitYear,
    submitMonth: submitMonth,
    submitter: submitter
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res)
      } else {
        reject(res)
      }
    }).catch(err => {
      reject(err)
    })
  })
}
// 提交月总结
export function submitMonthConclusionData (submitYear, submitMonth, submitter, title, submitStatus,
                                           curConclusion, nextPlan, curAdvice, managerRateStar) {
  const url = urlSubmitMonthConclusionData
  let params = {
    submitYear: submitYear,
    submitMonth: submitMonth,
    submitter: submitter,
    title: title,
    submitStatus: submitStatus,
    curConclusion: curConclusion,
    nextPlan: nextPlan,
    curAdvice: curAdvice,
    managerRateStar: managerRateStar
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res)
      } else {
        console.log('res code error')
        reject(res)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

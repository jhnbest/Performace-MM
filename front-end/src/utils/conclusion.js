import { http } from '../config/http'
import {
  urlGetCurMonthConclusionOverviewData,
  urlSubmitMonthConclusionData,
  urlGetConclusionDataById,
  urlUpdateMonthConclusionData,
  urlUpdateMonthConclusionStatus,
  urlGetAllUsersMonthConclusionData,
  urlSubmitEvaData,
  urlUpdateWorkTimeListIdOfConclusion
} from '../config/interface'
import { conclusionManagerEvaStarToWorkTime } from '@/utils/common'

// 获取月总结概览信息
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
export function submitMonthConclusionData (submitYear, submitMonth, submitter, conclusionTitle, submitStatus,
                                           curConclusion, nextPlan, curAdvice, managerRateStar) {
  const url = urlSubmitMonthConclusionData
  let params = {
    conclusionType: 1,
    submitYear: submitYear,
    submitMonth: submitMonth,
    submitter: submitter,
    conclusionTitle: conclusionTitle,
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
        reject(res)
      }
    }).catch(err => {
      reject(err)
    })
  })
}
// 更新月总结
export function updateMonthConclusionData (id, submitYear, submitMonth, submitter, conclusionTitle, submitStatus,
                                           curConclusion, nextPlan, curAdvice, managerRateStar) {
  const url = urlUpdateMonthConclusionData
  let params = {
    id: id,
    conclusionType: 1,
    submitYear: submitYear,
    submitMonth: submitMonth,
    submitter: submitter,
    conclusionTitle: conclusionTitle,
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
        reject(res)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// 更新月总结状态
export function updateMonthConclusionStatus (id, submitStatus) {
  const url = urlUpdateMonthConclusionStatus
  let params = {
    id: id,
    submitStatus: submitStatus
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

// 根据id获取月总结数据
export function getConclusionDataById (id) {
  const url = urlGetConclusionDataById
  let params = {
    id: id
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

// 提交评价数据
export function submitEvaData (id, managerRateStar, managerEva, evaStatus) {
  const url = urlSubmitEvaData
  let params = {
    id: id,
    managerRateStar: managerRateStar,
    getWorkTime: conclusionManagerEvaStarToWorkTime(managerRateStar),
    managerEva: managerEva,
    evaStatus: evaStatus
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

// 更新总结对应的工时ID
export function updateWorkTimeListIdOfConclusion (conclusionId, workTimeListId) {
  const url = urlUpdateWorkTimeListIdOfConclusion
  let params = {
    workTimeListId: workTimeListId,
    conclusionId: conclusionId
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

import { http } from '../config/http'
import {
  urlGetCurMonthConclusionOverviewData,
  urlSubmitMonthConclusionData,
  urlGetConclusionDataById,
  urlUpdateMonthConclusionData,
  urlUpdateMonthConclusionStatus,
  urlSubmitEvaData,
  urlSubmitMonthConclusionNew,
  urlUpdateWorkTimeListIdOfConclusion,
  urlUpdateMonthConclusionNew,
  urlGetCurMonthConclusionOverviewDataNew,
  urlGetCurYearConclusionOverviewData,
  urlGetCurMonthConclusionOverviewDataNewV2
} from '../config/interface'
import { conclusionManagerEvaStarToWorkTime } from '@/utils/common'
import store from '@/store'
import moment from 'moment'

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

// 获取月总结概览信息（新）
export function getCurMonthConclusionOverviewDataNew (conclusionYear, conclusionMonth, checkUserID, evaUserID, evaUserDuty) {
  const url = urlGetCurMonthConclusionOverviewDataNew
  let params = {
    conclusionYear: conclusionYear,
    conclusionMonth: conclusionMonth,
    checkUserID: checkUserID,
    evaUserID: evaUserID,
    evaUserDuty: evaUserDuty
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

// 获取月总结概览信息v2
export function getCurMonthConclusionOverviewDataNewV2 (conclusionYear, conclusionMonth, checkUserID, evaUserID, evaUserDuty) {
  const url = urlGetCurMonthConclusionOverviewDataNewV2
  let params = {
    conclusionYear: conclusionYear,
    conclusionMonth: conclusionMonth,
    checkUserID: checkUserID,
    evaUserID: evaUserID,
    evaUserDuty: evaUserDuty
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

// 获取本年份总结概览数据
export function getCurYearConclusionOverviewData (submitYear, submitter) {
  const url = urlGetCurYearConclusionOverviewData
  let params = {
    submitYear: submitYear,
    submitter: submitter,
    newRulesDate: store.state.newRulesDate
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      resolve(res.data)
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
// 提交月总结（新）
export function submitMonthConclusionNew (userID, conclusionYear, conclusionMonth, conclusionType, dimension, content, submitStatus) {
  const url = urlSubmitMonthConclusionNew
  let params = {
    userID: userID,
    conclusionType: conclusionType,
    conclusionYear: conclusionYear,
    conclusionMonth: conclusionMonth,
    dimension: dimension,
    content: content,
    submitStatus: submitStatus
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(response => {
      if (response.code === 1) {
        resolve(response.data)
      } else {
        reject(response.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// 更新月总结（新）
export function updateMonthConclusionNew (id, content, submitStatus) {
  const url = urlUpdateMonthConclusionNew
  let params = {
    id: id,
    content: content,
    submitStatus: submitStatus
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(response => {
      if (response.code === 1) {
        resolve(response.data)
      } else {
        reject(response.err)
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

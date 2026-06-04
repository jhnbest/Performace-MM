import { http } from '../config/http'
import {
  urlGetPMBDataByUserID,
  urlGetPMBRules,
  urlGetPMBRulesByID,
  urlSubmitPBData,
  urlUpdatePBData,
  urlGetPBData
} from '../config/interface'
import { sortObjectArrayByParams,
         NorCal,
         starToRatesNew,
         NorCalV2 } from '@/utils/common'
import store from '@/store'

// ************获取绩效加分数据************
export function getPMBDataByUserID (userID) {
  const url = urlGetPMBDataByUserID
  let params = {
    userID: userID
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

// ************获取绩效加分数据************
export function getPBData (applyYear, applyMonth) {
  const url = urlGetPBData
  let params = {
    applyYear: applyYear,
    applyMonth: applyMonth
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

// ************获取绩效加分标准************
export function getPMBRules () {
  const url = urlGetPMBRules
  let params = {}
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

// ************获取绩效加分标准(通过ID)************
export function getPMBRulesByID (id) {
  const url = urlGetPMBRulesByID
  let params = {
    id: id
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

// ************提交绩效加分数据************
export function submitPBData (PBName, userID, applyYear, applyMonth, submitStatus, PBRuleIDs, PBComments, kValue, PBScoreAssign) {
  const url = urlSubmitPBData
  let params = {
    PBName: PBName,
    userID: userID,
    applyYear: applyYear,
    applyMonth: applyMonth,
    PBRuleIDs: PBRuleIDs,
    PBComments: PBComments,
    kValue: kValue,
    PBScoreAssign: PBScoreAssign,
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

// ************更新绩效加分数据************
export function updatePBData (id, PBName, userID, applyYear, applyMonth, submitStatus, reviewStatus, PBRuleID, kValue, PBComments, PBScoreAssign) {
  const url = urlUpdatePBData
  let params = {
    id: id,
    PBName: PBName,
    userID: userID,
    applyYear: applyYear,
    applyMonth: applyMonth,
    submitStatus: submitStatus,
    reviewStatus: reviewStatus,
    PBRuleID: PBRuleID,
    kValue: kValue,
    PBComments: PBComments,
    PBScoreAssign: PBScoreAssign
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

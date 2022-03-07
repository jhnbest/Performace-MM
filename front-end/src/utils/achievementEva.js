import { http } from '../config/http'
import {
  urlGetUserofAchievementToAnotherUser,
  urlSubmitAMEvaData,
  urlUpdateAMEvaData,
  urlGetAchievementEvaOfConclusionDimension,
  urlGetConclusionEvaData
} from '../config/interface'
import store from '@/store'

// 获取用户的成效评价
export function getUserofAchievementToAnotherUser (conclusionID, evaUserID) {
  const url = urlGetUserofAchievementToAnotherUser
  let params = {
    conclusionID: conclusionID,
    evaUserID: evaUserID
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

// 获取对某个总结的所有评价
export function getAchievementEvaOfConclusionDimension (conclusionID) {
  const url = urlGetAchievementEvaOfConclusionDimension
  let params = {
    conclusionID: conclusionID
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

// 提交成效评价
export function submitAMEvaData (evaUserID, dimensionID, evaStar) {
  const url = urlSubmitAMEvaData
  let params = {
    evaUserID: evaUserID,
    dimensionID: dimensionID,
    evaStar: evaStar
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
// 更新成效评价
export function updateAMEvaData (evaDataID, evaStar) {
  const url = urlUpdateAMEvaData
  let params = {
    evaStar: evaStar,
    evaDataID: evaDataID
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

export function genAMEvaScoreData (genAMEvaScoreData) {
  let AMEvaScoreArray = []
  for (let genAMEvaScoreDataItem of genAMEvaScoreData) {
    if (genAMEvaScoreDataItem.length !== 0) {
      for (let genAMEvaScoreDataItemItem of genAMEvaScoreDataItem) {
        let findIndex = AMEvaScoreArray.findIndex(AMEvaScoreArrayItem => {
          return AMEvaScoreArrayItem.evaedUserID === genAMEvaScoreDataItemItem.evaedUserID
        })
        if (findIndex === -1) {
          let obj = {
            evaedUserID: genAMEvaScoreDataItemItem.evaedUserID,
            AMEvaData: [genAMEvaScoreDataItemItem]
          }
          AMEvaScoreArray.push(obj)
        } else {
          AMEvaScoreArray[findIndex].AMEvaData.push(genAMEvaScoreDataItemItem)
        }
      }
    }
  }
  if (AMEvaScoreArray.length !== 0) {
    for (let AMEvaScoreArrayItem of AMEvaScoreArray) {
    }
  }
  console.log('AMEvaScoreArray')
  console.log(AMEvaScoreArray)
}
// 获取某个用户的对其他人的成效评价
export function getConclusionEvaData (conclusionYear, conclusionMonth, evaUserID) {
  const url = urlGetConclusionEvaData
  let params = {
    conclusionYear: conclusionYear,
    conclusionMonth: conclusionMonth,
    evaUserID: evaUserID
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

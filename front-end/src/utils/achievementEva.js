import { http } from '../config/http'
import {
  urlGetUserofAchievementToAnotherUser,
  urlSubmitAMEvaData,
  urlUpdateAMEvaData,
  urlGetAchievementEvaOfConclusionDimension,
  urlGetUserConclusionEvaedData
} from '../config/interface'
import { newStarToRates,
         sortBy,
         PMScoreNorCal,
         sortObjectArrayByParams } from '@/utils/common'
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
// 生成成效评价数据
export function genAMEvaScoreData (allAMEvaedData,
   AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef,
   CSManagerAMEvaCoef, CSGroupLeaderAMEvaCoef,
   CScommonStaffAMEvaCoef, GPManagerAMEvaCoef,
   GPCommonStaffAMEvaCoef, QYEvaScoreData,
   standAndEngineerGroupNum, commuincationGroupNum) {
  let AMEvaScoreArray = []
  // 按照被评价人为主体整理数据
  for (let allAMEvaDataItem of allAMEvaedData) {
    if (allAMEvaDataItem.allAMEvaedData.length !== 0) {
      for (let allAMEvaDataItemItem of allAMEvaDataItem.allAMEvaedData) {
        let findIndex = AMEvaScoreArray.findIndex(AMEvaScoreArrayItem => {
          return AMEvaScoreArrayItem.evaedUserID === allAMEvaDataItemItem.evaedUserID
        })
        if (findIndex === -1) { // 首次插入该数组
          let obj = {
            evaedUserID: allAMEvaDataItemItem.evaedUserID,
            evaedUserDuty: allAMEvaDataItemItem.evaedUserDuty,
            evaedUserGroupID: allAMEvaDataItemItem.evaedUserGroupID,
            AMEvaedData: [allAMEvaDataItemItem],
            AMCSEvaTotalScore: 0,
            AMCSEvaTotalNum: 0,
            AMCSEvaAveScore: 0,
            AMGPEvaScore: 0,
            AMMGEvaScore: 0,
            AMEvaScoreUnN: 0,
            AMEvaScoreNor: 0,
            AMEvaScoreRank: 0,
            totalWorkTime: 0,
            dimension1AveStar: 0,
            dimension2AveStar: 0
          }
          // 统计2个评价维度的总分和总评价人数
          if (allAMEvaDataItemItem.dimension === 1) { // 评价维度是打造精品工程
            if (allAMEvaDataItemItem.evaUserDuty === 1) { // 处室经理评价
              obj.AMMGEvaScore += newStarToRates(allAMEvaDataItemItem.evaStar) * AMBuildBoutiqueProjectCoef
            } else if (allAMEvaDataItemItem.evaUserDuty === 2) { // 组长评价
              if (allAMEvaDataItemItem.evaUserGroupID === allAMEvaDataItemItem.evaedUserGroupID) { // 本组组长
                obj.AMGPEvaScore += newStarToRates(allAMEvaDataItemItem.evaStar) * AMBuildBoutiqueProjectCoef
                obj.dimension1AveStar += allAMEvaDataItemItem.evaStar
              } else { // 其他组组长
                obj.AMCSEvaTotalScore += newStarToRates(allAMEvaDataItemItem.evaStar) * AMBuildBoutiqueProjectCoef
                obj.dimension1AveStar += allAMEvaDataItemItem.evaStar
                obj.AMCSEvaTotalNum++
              }
            } else if (allAMEvaDataItemItem.evaUserDuty === 3) { // 组员评价
              obj.AMCSEvaTotalScore += newStarToRates(allAMEvaDataItemItem.evaStar) * AMBuildBoutiqueProjectCoef
              obj.dimension1AveStar += allAMEvaDataItemItem.evaStar
              obj.AMCSEvaTotalNum++
            }
          } else if (allAMEvaDataItemItem.dimension === 2) { // 评价维度是创建专业团队
            if (allAMEvaDataItemItem.evaUserDuty === 1) { // 处室经理评价
              obj.AMMGEvaScore += newStarToRates(allAMEvaDataItemItem.evaStar) * AMBuildProTeamCoef
            } else if (allAMEvaDataItemItem.evaUserDuty === 2) { // 组长评价
              if (allAMEvaDataItemItem.evaUserGroupID === allAMEvaDataItemItem.evaedUserGroupID) { // 本组组长
                obj.AMGPEvaScore += newStarToRates(allAMEvaDataItemItem.evaStar) * AMBuildProTeamCoef
                obj.dimension2AveStar += allAMEvaDataItemItem.evaStar
              } else { // 其他组组长
                obj.AMCSEvaTotalScore += newStarToRates(allAMEvaDataItemItem.evaStar) * AMBuildProTeamCoef
                obj.dimension2AveStar += allAMEvaDataItemItem.evaStar
                obj.AMCSEvaTotalNum++
              }
            } else if (allAMEvaDataItemItem.evaUserDuty === 3) { // 组员评价
              obj.AMCSEvaTotalScore += newStarToRates(allAMEvaDataItemItem.evaStar) * AMBuildProTeamCoef
              obj.dimension2AveStar += allAMEvaDataItemItem.evaStar
              obj.AMCSEvaTotalNum++
            }
          }
          AMEvaScoreArray.push(obj)
        } else { // 数组中已有相关数据
          // 统计2个评价维度的总分和总评价人数
          if (allAMEvaDataItemItem.dimension === 1) { // 评价维度是打造精品工程
            if (allAMEvaDataItemItem.evaUserDuty === 1) { // 处室经理评价
              AMEvaScoreArray[findIndex].AMMGEvaScore += newStarToRates(allAMEvaDataItemItem.evaStar) *
                                                              AMBuildBoutiqueProjectCoef
            } else if (allAMEvaDataItemItem.evaUserDuty === 2) { // 组长评价
              if (allAMEvaDataItemItem.evaUserGroupID === allAMEvaDataItemItem.evaedUserGroupID) { // 本组组长
                AMEvaScoreArray[findIndex].AMGPEvaScore += newStarToRates(allAMEvaDataItemItem.evaStar) *
                                                              AMBuildBoutiqueProjectCoef
                AMEvaScoreArray[findIndex].dimension1AveStar += allAMEvaDataItemItem.evaStar
              } else { // 其他组组长
                AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaDataItemItem.evaStar) *
                                                              AMBuildBoutiqueProjectCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
                AMEvaScoreArray[findIndex].dimension1AveStar += allAMEvaDataItemItem.evaStar
              }
            } else if (allAMEvaDataItemItem.evaUserDuty === 3) { // 组员评价
              AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaDataItemItem.evaStar) *
                                                              AMBuildBoutiqueProjectCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
                AMEvaScoreArray[findIndex].dimension1AveStar += allAMEvaDataItemItem.evaStar
            }
          } else if (allAMEvaDataItemItem.dimension === 2) { // 评价维度是创建专业团队
            if (allAMEvaDataItemItem.evaUserDuty === 1) { // 处室经理评价
              AMEvaScoreArray[findIndex].AMMGEvaScore += newStarToRates(allAMEvaDataItemItem.evaStar) *
                                                              AMBuildProTeamCoef
            } else if (allAMEvaDataItemItem.evaUserDuty === 2) { // 组长评价
              if (allAMEvaDataItemItem.evaUserGroupID === allAMEvaDataItemItem.evaedUserGroupID) { // 本组组长
                AMEvaScoreArray[findIndex].AMGPEvaScore += newStarToRates(allAMEvaDataItemItem.evaStar) *
                                                              AMBuildProTeamCoef
                AMEvaScoreArray[findIndex].dimension2AveStar += allAMEvaDataItemItem.evaStar
              } else { // 其他组组长
                AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaDataItemItem.evaStar) *
                                                              AMBuildProTeamCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
                AMEvaScoreArray[findIndex].dimension2AveStar += allAMEvaDataItemItem.evaStar
              }
            } else if (allAMEvaDataItemItem.evaUserDuty === 3) { // 组员评价
              AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaDataItemItem.evaStar) *
                                                              AMBuildProTeamCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
                AMEvaScoreArray[findIndex].dimension2AveStar += allAMEvaDataItemItem.evaStar
            }
          }
          AMEvaScoreArray[findIndex].AMEvaedData.push(allAMEvaDataItemItem)
        }
      }
    }
  }
  // 计算普通员工平均评价得分，经理评价得分
  for (let AMEvaScoreArrayItem of AMEvaScoreArray) {
    // 计算普通员工评价的平均分
    AMEvaScoreArrayItem.AMCSEvaTotalNum /= 2
    AMEvaScoreArrayItem.AMCSEvaAveScore = AMEvaScoreArrayItem.AMCSEvaTotalScore / AMEvaScoreArrayItem.AMCSEvaTotalNum
    AMEvaScoreArrayItem.dimension1AveStar /= (AMEvaScoreArrayItem.AMEvaedData.length / 2)
    AMEvaScoreArrayItem.dimension2AveStar /= (AMEvaScoreArrayItem.AMEvaedData.length / 2)
    // 处理处室经理的处室评价得分
    if (AMEvaScoreArrayItem.AMMGEvaScore === 0 && AMEvaScoreArrayItem.AMGPEvaScore === 0) { // 如果处室经理和组长都还未评价，取普通员工的评价平均分
      AMEvaScoreArrayItem.AMMGEvaScore = AMEvaScoreArrayItem.AMCSEvaAveScore
    } else if (AMEvaScoreArrayItem.AMMGEvaScore === 0) { // 仅处室经理还未评价,取平均
      AMEvaScoreArrayItem.AMMGEvaScore = (AMEvaScoreArrayItem.AMCSEvaTotalScore + AMEvaScoreArrayItem.AMGPEvaScore) /
                                          (AMEvaScoreArrayItem.AMCSEvaTotalNum + 1)
    }
    // 计算成效评价未标准化得分
    if (AMEvaScoreArrayItem.evaedUserDuty === 2) { // 被评价的人为组长
      AMEvaScoreArrayItem.AMEvaScoreUnN = AMEvaScoreArrayItem.AMCSEvaAveScore * GPCommonStaffAMEvaCoef +
                                          AMEvaScoreArrayItem.AMMGEvaScore * GPManagerAMEvaCoef
      AMEvaScoreArrayItem.totalWorkTime = QYEvaScoreData.find(QYEvaScoreDataItem => {
        return QYEvaScoreDataItem.id === AMEvaScoreArrayItem.evaedUserID
      }).totalWorkTime
    } else if (AMEvaScoreArrayItem.evaedUserDuty === 3) { // 被评价的人为普通成员
      AMEvaScoreArrayItem.AMEvaScoreUnN = AMEvaScoreArrayItem.AMCSEvaAveScore * CScommonStaffAMEvaCoef +
                                          AMEvaScoreArrayItem.AMMGEvaScore * CSManagerAMEvaCoef +
                                          AMEvaScoreArrayItem.AMGPEvaScore * CSGroupLeaderAMEvaCoef
      AMEvaScoreArrayItem.totalWorkTime = QYEvaScoreData.find(QYEvaScoreDataItem => {
        return QYEvaScoreDataItem.id === AMEvaScoreArrayItem.evaedUserID
      }).totalWorkTime
    }
  }
  let SEAMEvaScoreArray = [] // 存放技术组和工程组
  let CMAMEvaScoreArrty = [] // 存放通信组
  for (let AMEvaScoreArrayItem of AMEvaScoreArray) {
    if (AMEvaScoreArrayItem.evaedUserGroupID === 1 || AMEvaScoreArrayItem.evaedUserGroupID === 2) { // 技术标准组或工程组
      SEAMEvaScoreArray.push(AMEvaScoreArrayItem)
    } else if (AMEvaScoreArrayItem.evaedUserGroupID === 3) {
      CMAMEvaScoreArrty.push(AMEvaScoreArrayItem)
    }
  }
  SEAMEvaScoreArray = sortObjectArrayByParams(JSON.parse(JSON.stringify(SEAMEvaScoreArray)), 'AMEvaScoreUnN', 'totalWorkTime')
  CMAMEvaScoreArrty = sortObjectArrayByParams(JSON.parse(JSON.stringify(CMAMEvaScoreArrty)), 'AMEvaScoreUnN', 'totalWorkTime')
  // 计算成效评价标准化得分
  for (let i = 0; i < SEAMEvaScoreArray.length; i++) {
    SEAMEvaScoreArray[i].AMEvaScoreRank = i + 1
    SEAMEvaScoreArray[i].AMEvaScoreNor = PMScoreNorCal(standAndEngineerGroupNum, i + 1)
  }
  for (let i = 0; i < CMAMEvaScoreArrty.length; i++) {
    CMAMEvaScoreArrty[i].AMEvaScoreRank = i + 1
    CMAMEvaScoreArrty[i].AMEvaScoreNor = PMScoreNorCal(commuincationGroupNum, i + 1)
  }
  console.log('AMEvaScoreArray')
  console.log(AMEvaScoreArray)
  console.log('SEAMEvaScoreArray')
  console.log(SEAMEvaScoreArray)
  console.log('CMAMEvaScoreArrty')
  console.log(CMAMEvaScoreArrty)
  return AMEvaScoreArray
}
// 获取某个用户的对其他人的成效评价
export function getUserConclusionEvaedData (conclusionYear, conclusionMonth, evaedUserID) {
  const url = urlGetUserConclusionEvaedData
  let params = {
    conclusionYear: conclusionYear,
    conclusionMonth: conclusionMonth,
    evaedUserID: evaedUserID
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

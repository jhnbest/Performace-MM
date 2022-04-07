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
         sortObjectArrayByParams,
         NorCal } from '@/utils/common'
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
export function genAMEvaScoreData (tableData,
   AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef,
   CSManagerAMEvaCoef, CSGroupLeaderAMEvaCoef,
   CScommonStaffAMEvaCoef, GPManagerAMEvaCoef,
   GPCommonStaffAMEvaCoef, QYEvaScoreData) {
  let AMEvaScoreArray = []
  // 按照被评价人为主体整理数据
  for (let tableDataItem of tableData) {
    if (tableDataItem.allAMEvaedData.length !== 0) {
      for (let allAMEvaedDataItem of tableDataItem.allAMEvaedData) {
        let findIndex = AMEvaScoreArray.findIndex(AMEvaScoreArrayItem => {
          return AMEvaScoreArrayItem.evaedUserID === allAMEvaedDataItem.evaedUserID
        })
        if (findIndex === -1) { // 首次插入该数组
          let obj = {
            evaedUserID: allAMEvaedDataItem.evaedUserID,
            evaedUserDuty: allAMEvaedDataItem.evaedUserDuty,
            evaedUserGroupID: allAMEvaedDataItem.evaedUserGroupID,
            AMEvaedData: [allAMEvaedDataItem],
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
            dimension2AveStar: 0,
            dimension1CSAveStar: 0, // 评价维度1的其他员工平均评价星级
            dimension2CSAveStar: 0, // 评价维度2的其他员工平均评价星级
            dimension1CSEvaNum: 0, // 评价维度1的其他员工评价数量
            dimension2CSEvaNum: 0, // 评价维度2的其他员工评价数量
            dimension1GPEvaStar: 0, // 评价维度1的组长评价星级
            dimension2GPEvaStar: 0 // 评价维度2的组长评价星级
          }
          // 统计2个评价维度的总分和总评价人数
          if (allAMEvaedDataItem.dimension === 1) { // 评价维度是打造精品工程
            if (allAMEvaedDataItem.evaUserDuty === 1) { // 处室经理评价
              obj.AMMGEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
              obj.dimension1AveStar += allAMEvaedDataItem.evaStar
            } else if (allAMEvaedDataItem.evaUserDuty === 2) { // 组长评价
              if (allAMEvaedDataItem.evaUserGroupID === allAMEvaedDataItem.evaedUserGroupID) { // 本组组长
                obj.AMGPEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
                obj.dimension1GPEvaStar += allAMEvaedDataItem.evaStar
              } else { // 其他组组长
                obj.AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
                obj.AMCSEvaTotalNum++
                obj.dimension1CSAveStar += allAMEvaedDataItem.evaStar
                obj.dimension1CSEvaNum++
              }
              obj.dimension1AveStar += allAMEvaedDataItem.evaStar
            } else if (allAMEvaedDataItem.evaUserDuty === 3) { // 组员评价
              obj.AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
              obj.dimension1AveStar += allAMEvaedDataItem.evaStar
              obj.AMCSEvaTotalNum++
              obj.dimension1CSAveStar += allAMEvaedDataItem.evaStar
              obj.dimension1CSEvaNum++
            }
          } else if (allAMEvaedDataItem.dimension === 2) { // 评价维度是创建专业团队
            if (allAMEvaedDataItem.evaUserDuty === 1) { // 处室经理评价
              obj.AMMGEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
              obj.dimension2AveStar += allAMEvaedDataItem.evaStar
            } else if (allAMEvaedDataItem.evaUserDuty === 2) { // 组长评价
              if (allAMEvaedDataItem.evaUserGroupID === allAMEvaedDataItem.evaedUserGroupID) { // 本组组长
                obj.AMGPEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
                obj.dimension2GPEvaStar += allAMEvaedDataItem.evaStar
              } else { // 其他组组长
                obj.AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
                obj.AMCSEvaTotalNum++
                obj.dimension2CSAveStar += allAMEvaedDataItem.evaStar
                obj.dimension2CSEvaNum++
              }
              obj.dimension2AveStar += allAMEvaedDataItem.evaStar
            } else if (allAMEvaedDataItem.evaUserDuty === 3) { // 组员评价
              obj.AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
              obj.dimension2AveStar += allAMEvaedDataItem.evaStar
              obj.AMCSEvaTotalNum++
              obj.dimension2CSAveStar += allAMEvaedDataItem.evaStar
              obj.dimension2CSEvaNum++
            }
          }
          AMEvaScoreArray.push(obj)
        } else { // 数组中已有相关数据
          // 统计2个评价维度的总分和总评价人数
          if (allAMEvaedDataItem.dimension === 1) { // 评价维度是打造精品工程
            if (allAMEvaedDataItem.evaUserDuty === 1) { // 处室经理评价
              AMEvaScoreArray[findIndex].AMMGEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
              AMEvaScoreArray[findIndex].dimension1AveStar += allAMEvaedDataItem.evaStar
            } else if (allAMEvaedDataItem.evaUserDuty === 2) { // 组长评价
              if (allAMEvaedDataItem.evaUserGroupID === allAMEvaedDataItem.evaedUserGroupID) { // 本组组长
                AMEvaScoreArray[findIndex].AMGPEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
                AMEvaScoreArray[findIndex].dimension1GPEvaStar += allAMEvaedDataItem.evaStar
              } else { // 其他组组长
                AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
                AMEvaScoreArray[findIndex].dimension1CSAveStar += allAMEvaedDataItem.evaStar
                AMEvaScoreArray[findIndex].dimension1CSEvaNum++
              }
              AMEvaScoreArray[findIndex].dimension1AveStar += allAMEvaedDataItem.evaStar
            } else if (allAMEvaedDataItem.evaUserDuty === 3) { // 组员评价
              AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
              AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
              AMEvaScoreArray[findIndex].dimension1AveStar += allAMEvaedDataItem.evaStar
              AMEvaScoreArray[findIndex].dimension1CSAveStar += allAMEvaedDataItem.evaStar
              AMEvaScoreArray[findIndex].dimension1CSEvaNum++
            }
          } else if (allAMEvaedDataItem.dimension === 2) { // 评价维度是创建专业团队
            if (allAMEvaedDataItem.evaUserDuty === 1) { // 处室经理评价
              AMEvaScoreArray[findIndex].AMMGEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
              AMEvaScoreArray[findIndex].dimension2AveStar += allAMEvaedDataItem.evaStar
            } else if (allAMEvaedDataItem.evaUserDuty === 2) { // 组长评价
              if (allAMEvaedDataItem.evaUserGroupID === allAMEvaedDataItem.evaedUserGroupID) { // 本组组长
                AMEvaScoreArray[findIndex].AMGPEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
                AMEvaScoreArray[findIndex].dimension2GPEvaStar += allAMEvaedDataItem.evaStar
              } else { // 其他组组长
                AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
                AMEvaScoreArray[findIndex].dimension2CSAveStar += allAMEvaedDataItem.evaStar
                AMEvaScoreArray[findIndex].dimension2CSEvaNum++
              }
              AMEvaScoreArray[findIndex].dimension2AveStar += allAMEvaedDataItem.evaStar
            } else if (allAMEvaedDataItem.evaUserDuty === 3) { // 组员评价
              AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
              AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
              AMEvaScoreArray[findIndex].dimension2AveStar += allAMEvaedDataItem.evaStar
              AMEvaScoreArray[findIndex].dimension2CSAveStar += allAMEvaedDataItem.evaStar
              AMEvaScoreArray[findIndex].dimension2CSEvaNum++
            }
          }
          AMEvaScoreArray[findIndex].AMEvaedData.push(allAMEvaedDataItem)
        }
      }
    }
  }
  if (AMEvaScoreArray.length !== 0) {
    // 计算普通员工平均评价得分，经理评价得分
    for (let AMEvaScoreArrayItem of AMEvaScoreArray) {
      // 计算普通员工评价的平均分
      AMEvaScoreArrayItem.AMCSEvaTotalNum /= 2
      AMEvaScoreArrayItem.AMCSEvaAveScore = AMEvaScoreArrayItem.AMCSEvaTotalScore / AMEvaScoreArrayItem.AMCSEvaTotalNum
      // 计算两个维度的所有人平均评价星级
      AMEvaScoreArrayItem.dimension1AveStar /= (AMEvaScoreArrayItem.AMEvaedData.length / 2)
      AMEvaScoreArrayItem.dimension2AveStar /= (AMEvaScoreArrayItem.AMEvaedData.length / 2)
      AMEvaScoreArrayItem.dimension1AveStar = Number(AMEvaScoreArrayItem.dimension1AveStar.toFixed(0))
      AMEvaScoreArrayItem.dimension2AveStar = Number(AMEvaScoreArrayItem.dimension2AveStar.toFixed(0))
      // 计算两个维度的普通成员评价评价星级
      if (AMEvaScoreArrayItem.dimension1CSEvaNum === 0) {
        AMEvaScoreArrayItem.dimension1CSAveStar = 0
        AMEvaScoreArrayItem.dimension2CSAveStar = 0
      } else {
        AMEvaScoreArrayItem.dimension1CSAveStar /= AMEvaScoreArrayItem.dimension1CSEvaNum
        AMEvaScoreArrayItem.dimension2CSAveStar /= AMEvaScoreArrayItem.dimension2CSEvaNum
      }
      // 如果处室经理还未评价，将其评价星级重置为平均评价星级,并计算星级对应的得分
      if (AMEvaScoreArrayItem.AMMGEvaScore === 0) {
        let dimension1AveScore = newStarToRates(AMEvaScoreArrayItem.dimension1AveStar)
        let dimension2AveScore = newStarToRates(AMEvaScoreArrayItem.dimension2AveStar)
        AMEvaScoreArrayItem.AMMGEvaScore = dimension1AveScore * AMBuildBoutiqueProjectCoef + dimension2AveScore * AMBuildProTeamCoef
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
    AMEvaScoreArray = sortObjectArrayByParams(AMEvaScoreArray, 'AMEvaScoreUnN', 'totalWorkTime')
    for (let i = 0; i < AMEvaScoreArray.length; i++) {
      AMEvaScoreArray[i].AMEvaScoreRank = i + 1
      AMEvaScoreArray[i].AMEvaScoreNor = PMScoreNorCal(AMEvaScoreArray.length + 1, i + 1)
    }
  }
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

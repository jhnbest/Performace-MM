import { http } from '../config/http'
import {
  urlGetUserofAchievementToAnotherUser,
  urlSubmitAMEvaData,
  urlUpdateAMEvaData,
  urlGetAchievementEvaOfConclusionDimension,
  urlGetConclusionEvaData
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
export function genAMEvaScoreData (genAMEvaScoreData,
   AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef,
   CSManagerAMEvaCoef, CSGroupLeaderAMEvaCoef,
   CScommonStaffAMEvaCoef, GPManagerAMEvaCoef,
   GPCommonStaffAMEvaCoef, QYEvaScoreData,
   standAndEngineerGroupNum, commuincationGroupNum) {
  console.log('genAMEvaScoreData')
  console.log(genAMEvaScoreData)
  console.log('QYEvaScoreData')
  console.log(QYEvaScoreData)
  let AMEvaScoreArray = []
  // 按照被评价人为主体整理数据
  for (let genAMEvaScoreDataItem of genAMEvaScoreData) {
    if (genAMEvaScoreDataItem.length !== 0) {
      for (let genAMEvaScoreDataItemItem of genAMEvaScoreDataItem) {
        let findIndex = AMEvaScoreArray.findIndex(AMEvaScoreArrayItem => {
          return AMEvaScoreArrayItem.evaedUserID === genAMEvaScoreDataItemItem.evaedUserID
        })
        if (findIndex === -1) { // 首次插入该数组
          let obj = {
            evaedUserID: genAMEvaScoreDataItemItem.evaedUserID,
            evaedUserDuty: genAMEvaScoreDataItemItem.evaedUserDuty,
            evaedUserGroupID: genAMEvaScoreDataItemItem.evaedUserGroupID,
            AMEvaedData: [genAMEvaScoreDataItemItem],
            AMCSEvaTotalScore: 0,
            AMCSEvaTotalNum: 0,
            AMCSEvaAveScore: 0,
            AMGPEvaScore: 0,
            AMMGEvaScore: 0,
            AMEvaScoreUnN: 0,
            AMEvaScoreNor: 0,
            AMEvaScoreRank: 0,
            totalWorkTime: 0
          }
          // 统计2个评价维度的总分和总评价人数
          if (genAMEvaScoreDataItemItem.dimension === 1) { // 评价维度是打造精品工程
            if (genAMEvaScoreDataItemItem.evaUserDuty === 1) { // 处室经理评价
              obj.AMMGEvaScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) * AMBuildBoutiqueProjectCoef
            } else if (genAMEvaScoreDataItemItem.evaUserDuty === 2) { // 组长评价
              if (genAMEvaScoreDataItemItem.evaUserGroupID === genAMEvaScoreDataItemItem.evaedUserGroupID) { // 本组组长
                obj.AMGPEvaScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) * AMBuildBoutiqueProjectCoef
              } else { // 其他组组长
                obj.AMCSEvaTotalScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) * AMBuildBoutiqueProjectCoef
                obj.AMCSEvaTotalNum++
              }
            } else if (genAMEvaScoreDataItemItem.evaUserDuty === 3) { // 组员评价
              obj.AMCSEvaTotalScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) * AMBuildBoutiqueProjectCoef
              obj.AMCSEvaTotalNum++
            }
          } else if (genAMEvaScoreDataItemItem.dimension === 2) { // 评价维度是创建专业团队
            if (genAMEvaScoreDataItemItem.evaUserDuty === 1) { // 处室经理评价
              obj.AMMGEvaScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) * AMBuildProTeamCoef
            } else if (genAMEvaScoreDataItemItem.evaUserDuty === 2) { // 组长评价
              if (genAMEvaScoreDataItemItem.evaUserGroupID === genAMEvaScoreDataItemItem.evaedUserGroupID) { // 本组组长
                obj.AMGPEvaScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) * AMBuildProTeamCoef
              } else { // 其他组组长
                obj.AMCSEvaTotalScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) * AMBuildProTeamCoef
                obj.AMCSEvaTotalNum++
              }
            } else if (genAMEvaScoreDataItemItem.evaUserDuty === 3) { // 组员评价
              obj.AMCSEvaTotalScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) * AMBuildProTeamCoef
              obj.AMCSEvaTotalNum++
            }
          }
          AMEvaScoreArray.push(obj)
        } else { // 数组中已有相关数据
          // 统计2个评价维度的总分和总评价人数
          if (genAMEvaScoreDataItemItem.dimension === 1) { // 评价维度是打造精品工程
            if (genAMEvaScoreDataItemItem.evaUserDuty === 1) { // 处室经理评价
              AMEvaScoreArray[findIndex].AMMGEvaScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) *
                                                             AMBuildBoutiqueProjectCoef
            } else if (genAMEvaScoreDataItemItem.evaUserDuty === 2) { // 组长评价
              if (genAMEvaScoreDataItemItem.evaUserGroupID === genAMEvaScoreDataItemItem.evaedUserGroupID) { // 本组组长
                AMEvaScoreArray[findIndex].AMGPEvaScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) *
                                                             AMBuildBoutiqueProjectCoef
              } else { // 其他组组长
                AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) *
                                                             AMBuildBoutiqueProjectCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
              }
            } else if (genAMEvaScoreDataItemItem.evaUserDuty === 3) { // 组员评价
              AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) *
                                                             AMBuildBoutiqueProjectCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
            }
          } else if (genAMEvaScoreDataItemItem.dimension === 2) { // 评价维度是创建专业团队
            if (genAMEvaScoreDataItemItem.evaUserDuty === 1) { // 处室经理评价
              AMEvaScoreArray[findIndex].AMMGEvaScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) *
                                                             AMBuildProTeamCoef
            } else if (genAMEvaScoreDataItemItem.evaUserDuty === 2) { // 组长评价
              if (genAMEvaScoreDataItemItem.evaUserGroupID === genAMEvaScoreDataItemItem.evaedUserGroupID) { // 本组组长
                AMEvaScoreArray[findIndex].AMGPEvaScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) *
                                                             AMBuildProTeamCoef
              } else { // 其他组组长
                AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) *
                                                             AMBuildProTeamCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
              }
            } else if (genAMEvaScoreDataItemItem.evaUserDuty === 3) { // 组员评价
              AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(genAMEvaScoreDataItemItem.evaStar) *
                                                             AMBuildProTeamCoef
                AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
            }
          }
          AMEvaScoreArray[findIndex].AMEvaedData.push(genAMEvaScoreDataItemItem)
        }
      }
    }
  }
  // 计算普通员工平均评价得分，经理评价得分
  for (let AMEvaScoreArrayItem of AMEvaScoreArray) {
    // 计算普通员工评价的平均分
    AMEvaScoreArrayItem.AMCSEvaTotalNum /= 2
    AMEvaScoreArrayItem.AMCSEvaAveScore = AMEvaScoreArrayItem.AMCSEvaTotalScore / AMEvaScoreArrayItem.AMCSEvaTotalNum
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

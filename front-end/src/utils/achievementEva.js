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
         NorCal,
         starToRatesNew } from '@/utils/common'
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
// 根据月总结类型的评价得分计算加权分
function calAMRateMid (evaStar, dimension, AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef) {
  switch (dimension) {
    case 1:
      return starToRatesNew(evaStar) * AMBuildBoutiqueProjectCoef
    case 2:
      return starToRatesNew(evaStar) * AMBuildProTeamCoef
    default:
      return 0
  }
}
// 生成成效评价数据
export function genAMEvaScoreData (tableData,
   AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef,
   CSManagerAMEvaCoef, CSGroupLeaderAMEvaCoef,
   CScommonStaffAMEvaCoef, GPManagerAMEvaCoef,
   GPCommonStaffAMEvaCoef, QYEvaScoreData) {
  // ======================================按照被评价人为主体，计算普通成员、组长和处经理的评价得分======================================================
  for (let tableDataItem of tableData) {
    let allAMEvaedDataLength = tableDataItem.allAMEvaedData.length
    let AMCSEvaNum = 0
    tableDataItem.AMMGEvaScore = 0
    tableDataItem.AMGPEvaScore = 0
    tableDataItem.AMCSEvaTotalScore = 0
    for (let i = 0; i < allAMEvaedDataLength; i++) {
      let evaStar = tableDataItem.allAMEvaedData[i].evaStar
      let dimension = tableDataItem.allAMEvaedData[i].dimension
      let evaUserDuty = tableDataItem.allAMEvaedData[i].evaUserDuty
      let evaUserGroupID = tableDataItem.allAMEvaedData[i].evaUserGroupID
      if (evaUserDuty === 1) { // 如果评价的人是处经理
        // 计算处经理的成效评价总分
        tableDataItem.AMMGEvaScore += calAMRateMid(evaStar, dimension, AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef)
      } else if (evaUserDuty === 2 && evaUserGroupID === tableDataItem.groupID) { // 如果评价的人是本组组长
        // 计算组长的成效评价总分
        tableDataItem.AMGPEvaScore += calAMRateMid(evaStar, dimension, AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef)
        // 记录组长的评价星级
        tableDataItem.AMD1GPEvaStar = dimension === 1 ? evaStar : tableDataItem.AMD1GPEvaStar
        tableDataItem.AMD2GPEvaStar = dimension === 2 ? evaStar : tableDataItem.AMD2GPEvaStar
      } else { // 如果评价的人是普通成员或其他组组长
        // 计算普通成员的成效评价总分
        tableDataItem.AMCSEvaTotalScore += calAMRateMid(evaStar, dimension, AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef)
        // 计算普通员工的总评价星级
        tableDataItem.AMD1CSEvaTotalStar = dimension === 1 ? tableDataItem.AMD1CSEvaTotalStar + evaStar : tableDataItem.AMD1CSEvaTotalStar
        tableDataItem.AMD2CSEvaTotalStar = dimension === 2 ? tableDataItem.AMD2CSEvaTotalStar + evaStar : tableDataItem.AMD2CSEvaTotalStar
        // 计算普通员工的总评价人数（2倍）
        AMCSEvaNum++
      }
    }
    tableDataItem.AMCSEvaAveScore = AMCSEvaNum === 0 ? 0 : tableDataItem.AMCSEvaTotalScore / (AMCSEvaNum / 2)
    tableDataItem.AMD1CSEvaAveStar = AMCSEvaNum === 0 ? 0 : tableDataItem.AMD1CSEvaTotalStar / (AMCSEvaNum / 2)
    tableDataItem.AMD2CSEvaAveStar = AMCSEvaNum === 0 ? 0 : tableDataItem.AMD2CSEvaTotalStar / (AMCSEvaNum / 2)
    tableDataItem.totalWorkTime = QYEvaScoreData.find(item => { return item.id === tableDataItem.id }).totalWorkTime

    // 如果处经理还未对该用户评价
    if (tableDataItem.AMMGEvaScore === 0) {
      let AMD1AveStar = 0
      let AMD2AveStar = 0
      if (tableDataItem.AMCSEvaTotalScore !== 0 && tableDataItem.AMGPEvaScore !== 0) { // 如果普通成员和组长都评价了，则设置成他们的平均星级取整
        AMD1AveStar = Number(((tableDataItem.AMD1CSEvaTotalStar + tableDataItem.AMD1GPEvaStar) / (AMCSEvaNum / 2 + 1)).toFixed(0))
        AMD2AveStar = Number(((tableDataItem.AMD2CSEvaTotalStar + tableDataItem.AMD2GPEvaStar) / (AMCSEvaNum / 2 + 1)).toFixed(0))
      } else if (tableDataItem.AMCSEvaTotalScore === 0 && tableDataItem.AMGPEvaScore !== 0) { // 如果普通成员还未有人评价，组长评价了，则设置成组长的评价星级
        AMD1AveStar = tableDataItem.AMD1GPEvaStar
        AMD2AveStar = tableDataItem.AMD2GPEvaStar
      } else if (tableDataItem.AMCSEvaTotalScore !== 0 && tableDataItem.AMGPEvaScore === 0) { // 如果普通成员有人评价了，组长还没评价，则设置成普通成员的评价评价星级取整
        AMD1AveStar = Number(((tableDataItem.AMD1CSEvaTotalStar) / (AMCSEvaNum / 2)).toFixed(0))
        AMD2AveStar = Number(((tableDataItem.AMD2CSEvaTotalStar) / (AMCSEvaNum / 2)).toFixed(0))
      }
      tableDataItem.AMD1MGEvaStarV = AMD1AveStar
      tableDataItem.AMD2MGEvaStarV = AMD2AveStar
      tableDataItem.AMMGEvaScore = calAMRateMid(AMD1AveStar, 1, AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef) +
                                   calAMRateMid(AMD2AveStar, 2, AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef)
    }
  }
  // ===================================================计算成效评价的标准化得分=========================================================
  for (let tableDataItem of tableData) {
    let evaedUserDuty = tableDataItem.duty
    if (evaedUserDuty === 3) {
      tableDataItem.AMEvaScoreUnN = tableDataItem.AMCSEvaAveScore * CScommonStaffAMEvaCoef +
                                    tableDataItem.AMGPEvaScore * CSGroupLeaderAMEvaCoef +
                                    tableDataItem.AMMGEvaScore * CSManagerAMEvaCoef
    } else if (evaedUserDuty === 2) {
      tableDataItem.AMEvaScoreUnN = tableDataItem.AMCSEvaAveScore * GPCommonStaffAMEvaCoef +
                                    tableDataItem.AMMGEvaScore * GPManagerAMEvaCoef
    }
  }
  tableData = sortObjectArrayByParams(JSON.parse(JSON.stringify(tableData)), 'AMEvaScoreUnN', 'totalWorkTime')
  for (let i = 0; i < tableData.length; i++) {
    tableData[i].AMEvaScoreRank = i + 1
    tableData[i].AMEvaScoreNor = NorCal(tableData.length + 1, i + 1)
  }

  return tableData
}
// // 生成成效评价数据
// export function genAMEvaScoreData (tableData,
//    AMBuildBoutiqueProjectCoef, AMBuildProTeamCoef,
//    CSManagerAMEvaCoef, CSGroupLeaderAMEvaCoef,
//    CScommonStaffAMEvaCoef, GPManagerAMEvaCoef,
//    GPCommonStaffAMEvaCoef, QYEvaScoreData) {
//   let AMEvaScoreArray = []
//   // 按照被评价人为主体整理数据
//   for (let tableDataItem of tableData) {
//     if (tableDataItem.allAMEvaedData.length !== 0) {
//       for (let allAMEvaedDataItem of tableDataItem.allAMEvaedData) {
//         let findIndex = AMEvaScoreArray.findIndex(AMEvaScoreArrayItem => {
//           return AMEvaScoreArrayItem.evaedUserID === allAMEvaedDataItem.evaedUserID
//         })
//         if (findIndex === -1) { // 首次插入该数组
//           let obj = {
//             evaedUserID: allAMEvaedDataItem.evaedUserID,
//             evaedUserDuty: allAMEvaedDataItem.evaedUserDuty,
//             evaedUserGroupID: allAMEvaedDataItem.evaedUserGroupID,
//             AMEvaedData: [allAMEvaedDataItem],
//             AMCSEvaTotalScore: 0,
//             AMCSEvaTotalNum: 0,
//             AMCSEvaAveScore: 0,
//             AMGPEvaScore: 0,
//             AMMGEvaScore: 0,
//             AMEvaScoreUnN: 0,
//             AMEvaScoreNor: 0,
//             AMEvaScoreRank: 0,
//             totalWorkTime: 0,
//             dimension1AveStar: 0,
//             dimension2AveStar: 0,
//             dimension1CSAveStar: 0, // 评价维度1的其他员工平均评价星级
//             dimension2CSAveStar: 0, // 评价维度2的其他员工平均评价星级
//             dimension1CSEvaNum: 0, // 评价维度1的其他员工评价数量
//             dimension2CSEvaNum: 0, // 评价维度2的其他员工评价数量
//             dimension1GPEvaStar: 0, // 评价维度1的组长评价星级
//             dimension2GPEvaStar: 0 // 评价维度2的组长评价星级
//           }
//           // 统计2个评价维度的总分和总评价人数
//           if (allAMEvaedDataItem.dimension === 1) { // 评价维度是打造精品工程
//             if (allAMEvaedDataItem.evaUserDuty === 1) { // 处室经理评价
//               obj.AMMGEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
//               obj.dimension1AveStar += allAMEvaedDataItem.evaStar
//             } else if (allAMEvaedDataItem.evaUserDuty === 2) { // 组长评价
//               if (allAMEvaedDataItem.evaUserGroupID === allAMEvaedDataItem.evaedUserGroupID) { // 本组组长
//                 obj.AMGPEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
//                 obj.dimension1GPEvaStar += allAMEvaedDataItem.evaStar
//               } else { // 其他组组长
//                 obj.AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
//                 obj.AMCSEvaTotalNum++
//                 obj.dimension1CSAveStar += allAMEvaedDataItem.evaStar
//                 obj.dimension1CSEvaNum++
//               }
//               obj.dimension1AveStar += allAMEvaedDataItem.evaStar
//             } else if (allAMEvaedDataItem.evaUserDuty === 3) { // 组员评价
//               obj.AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
//               obj.dimension1AveStar += allAMEvaedDataItem.evaStar
//               obj.AMCSEvaTotalNum++
//               obj.dimension1CSAveStar += allAMEvaedDataItem.evaStar
//               obj.dimension1CSEvaNum++
//             }
//           } else if (allAMEvaedDataItem.dimension === 2) { // 评价维度是创建专业团队
//             if (allAMEvaedDataItem.evaUserDuty === 1) { // 处室经理评价
//               obj.AMMGEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
//               obj.dimension2AveStar += allAMEvaedDataItem.evaStar
//             } else if (allAMEvaedDataItem.evaUserDuty === 2) { // 组长评价
//               if (allAMEvaedDataItem.evaUserGroupID === allAMEvaedDataItem.evaedUserGroupID) { // 本组组长
//                 obj.AMGPEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
//                 obj.dimension2GPEvaStar += allAMEvaedDataItem.evaStar
//               } else { // 其他组组长
//                 obj.AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
//                 obj.AMCSEvaTotalNum++
//                 obj.dimension2CSAveStar += allAMEvaedDataItem.evaStar
//                 obj.dimension2CSEvaNum++
//               }
//               obj.dimension2AveStar += allAMEvaedDataItem.evaStar
//             } else if (allAMEvaedDataItem.evaUserDuty === 3) { // 组员评价
//               obj.AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
//               obj.dimension2AveStar += allAMEvaedDataItem.evaStar
//               obj.AMCSEvaTotalNum++
//               obj.dimension2CSAveStar += allAMEvaedDataItem.evaStar
//               obj.dimension2CSEvaNum++
//             }
//           }
//           AMEvaScoreArray.push(obj)
//         } else { // 数组中已有相关数据
//           // 统计2个评价维度的总分和总评价人数
//           if (allAMEvaedDataItem.dimension === 1) { // 评价维度是打造精品工程
//             if (allAMEvaedDataItem.evaUserDuty === 1) { // 处室经理评价
//               AMEvaScoreArray[findIndex].AMMGEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
//               AMEvaScoreArray[findIndex].dimension1AveStar += allAMEvaedDataItem.evaStar
//             } else if (allAMEvaedDataItem.evaUserDuty === 2) { // 组长评价
//               if (allAMEvaedDataItem.evaUserGroupID === allAMEvaedDataItem.evaedUserGroupID) { // 本组组长
//                 AMEvaScoreArray[findIndex].AMGPEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
//                 AMEvaScoreArray[findIndex].dimension1GPEvaStar += allAMEvaedDataItem.evaStar
//               } else { // 其他组组长
//                 AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
//                 AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
//                 AMEvaScoreArray[findIndex].dimension1CSAveStar += allAMEvaedDataItem.evaStar
//                 AMEvaScoreArray[findIndex].dimension1CSEvaNum++
//               }
//               AMEvaScoreArray[findIndex].dimension1AveStar += allAMEvaedDataItem.evaStar
//             } else if (allAMEvaedDataItem.evaUserDuty === 3) { // 组员评价
//               AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildBoutiqueProjectCoef
//               AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
//               AMEvaScoreArray[findIndex].dimension1AveStar += allAMEvaedDataItem.evaStar
//               AMEvaScoreArray[findIndex].dimension1CSAveStar += allAMEvaedDataItem.evaStar
//               AMEvaScoreArray[findIndex].dimension1CSEvaNum++
//             }
//           } else if (allAMEvaedDataItem.dimension === 2) { // 评价维度是创建专业团队
//             if (allAMEvaedDataItem.evaUserDuty === 1) { // 处室经理评价
//               AMEvaScoreArray[findIndex].AMMGEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
//               AMEvaScoreArray[findIndex].dimension2AveStar += allAMEvaedDataItem.evaStar
//             } else if (allAMEvaedDataItem.evaUserDuty === 2) { // 组长评价
//               if (allAMEvaedDataItem.evaUserGroupID === allAMEvaedDataItem.evaedUserGroupID) { // 本组组长
//                 AMEvaScoreArray[findIndex].AMGPEvaScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
//                 AMEvaScoreArray[findIndex].dimension2GPEvaStar += allAMEvaedDataItem.evaStar
//               } else { // 其他组组长
//                 AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
//                 AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
//                 AMEvaScoreArray[findIndex].dimension2CSAveStar += allAMEvaedDataItem.evaStar
//                 AMEvaScoreArray[findIndex].dimension2CSEvaNum++
//               }
//               AMEvaScoreArray[findIndex].dimension2AveStar += allAMEvaedDataItem.evaStar
//             } else if (allAMEvaedDataItem.evaUserDuty === 3) { // 组员评价
//               AMEvaScoreArray[findIndex].AMCSEvaTotalScore += newStarToRates(allAMEvaedDataItem.evaStar) * AMBuildProTeamCoef
//               AMEvaScoreArray[findIndex].AMCSEvaTotalNum++
//               AMEvaScoreArray[findIndex].dimension2AveStar += allAMEvaedDataItem.evaStar
//               AMEvaScoreArray[findIndex].dimension2CSAveStar += allAMEvaedDataItem.evaStar
//               AMEvaScoreArray[findIndex].dimension2CSEvaNum++
//             }
//           }
//           AMEvaScoreArray[findIndex].AMEvaedData.push(allAMEvaedDataItem)
//         }
//       }
//     }
//   }
//   if (AMEvaScoreArray.length !== 0) {
//     // 计算普通员工平均评价得分，经理评价得分
//     for (let AMEvaScoreArrayItem of AMEvaScoreArray) {
//       // 计算普通员工评价的平均分
//       AMEvaScoreArrayItem.AMCSEvaTotalNum /= 2
//       AMEvaScoreArrayItem.AMCSEvaAveScore = AMEvaScoreArrayItem.AMCSEvaTotalScore / AMEvaScoreArrayItem.AMCSEvaTotalNum
//       // 计算两个维度的所有人平均评价星级
//       AMEvaScoreArrayItem.dimension1AveStar /= (AMEvaScoreArrayItem.AMEvaedData.length / 2)
//       AMEvaScoreArrayItem.dimension2AveStar /= (AMEvaScoreArrayItem.AMEvaedData.length / 2)
//       AMEvaScoreArrayItem.dimension1AveStar = Number(AMEvaScoreArrayItem.dimension1AveStar.toFixed(0))
//       AMEvaScoreArrayItem.dimension2AveStar = Number(AMEvaScoreArrayItem.dimension2AveStar.toFixed(0))
//       // 计算两个维度的普通成员评价评价星级
//       if (AMEvaScoreArrayItem.dimension1CSEvaNum === 0) {
//         AMEvaScoreArrayItem.dimension1CSAveStar = 0
//         AMEvaScoreArrayItem.dimension2CSAveStar = 0
//       } else {
//         AMEvaScoreArrayItem.dimension1CSAveStar /= AMEvaScoreArrayItem.dimension1CSEvaNum
//         AMEvaScoreArrayItem.dimension2CSAveStar /= AMEvaScoreArrayItem.dimension2CSEvaNum
//       }
//       // 如果处室经理还未评价，将其评价星级重置为平均评价星级,并计算星级对应的得分
//       if (AMEvaScoreArrayItem.AMMGEvaScore === 0) {
//         let dimension1AveScore = newStarToRates(AMEvaScoreArrayItem.dimension1AveStar)
//         let dimension2AveScore = newStarToRates(AMEvaScoreArrayItem.dimension2AveStar)
//         AMEvaScoreArrayItem.AMMGEvaScore = dimension1AveScore * AMBuildBoutiqueProjectCoef + dimension2AveScore * AMBuildProTeamCoef
//       }
//       // 计算成效评价未标准化得分
//       if (AMEvaScoreArrayItem.evaedUserDuty === 2) { // 被评价的人为组长
//         AMEvaScoreArrayItem.AMEvaScoreUnN = AMEvaScoreArrayItem.AMCSEvaAveScore * GPCommonStaffAMEvaCoef +
//                                             AMEvaScoreArrayItem.AMMGEvaScore * GPManagerAMEvaCoef
//         AMEvaScoreArrayItem.totalWorkTime = QYEvaScoreData.find(QYEvaScoreDataItem => {
//           return QYEvaScoreDataItem.id === AMEvaScoreArrayItem.evaedUserID
//         }).totalWorkTime
//       } else if (AMEvaScoreArrayItem.evaedUserDuty === 3) { // 被评价的人为普通成员
//         AMEvaScoreArrayItem.AMEvaScoreUnN = AMEvaScoreArrayItem.AMCSEvaAveScore * CScommonStaffAMEvaCoef +
//                                             AMEvaScoreArrayItem.AMMGEvaScore * CSManagerAMEvaCoef +
//                                             AMEvaScoreArrayItem.AMGPEvaScore * CSGroupLeaderAMEvaCoef
//         AMEvaScoreArrayItem.totalWorkTime = QYEvaScoreData.find(QYEvaScoreDataItem => {
//           return QYEvaScoreDataItem.id === AMEvaScoreArrayItem.evaedUserID
//         }).totalWorkTime
//       }
//     }
//     AMEvaScoreArray = sortObjectArrayByParams(AMEvaScoreArray, 'AMEvaScoreUnN', 'totalWorkTime')
//     for (let i = 0; i < AMEvaScoreArray.length; i++) {
//       AMEvaScoreArray[i].AMEvaScoreRank = i + 1
//       AMEvaScoreArray[i].AMEvaScoreNor = PMScoreNorCal(AMEvaScoreArray.length + 1, i + 1)
//     }
//   }
//   console.log('AMEvaScoreArray')
//   console.log(AMEvaScoreArray)
//   return AMEvaScoreArray
// }
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

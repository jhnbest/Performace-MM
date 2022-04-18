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
    tableDataItem.AMD1CSEvaTotalStar = 0
    tableDataItem.AMD2CSEvaTotalStar = 0
    tableDataItem.AMD1GPEvaStar = 0
    tableDataItem.AMD2GPEvaStar = 0
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
      } else { // 如果都还没有人评价
        AMD1AveStar = store.state.defaultStar
        AMD2AveStar = store.state.defaultStar
      }
      // 构建评价维度1的处经理虚拟评价
      let obj = {
        evaUserID: store.state.userInfo.id,
        evaStar: AMD1AveStar,
        evaUserDuty: store.state.userInfo.duty,
        dimension: 1,
        evaUserGroupID: store.state.userInfo.groupID
      }
      // 把构建的处经理虚拟评价插入表格数据中
      tableDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj)))
      // 构建评价维度2的处经理虚拟评价
      obj.evaStar = AMD2AveStar
      obj.dimension = 2
      // 把构建的处经理虚拟评价插入表格数据中
      tableDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj)))

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
    tableData[i].AMEvaRank = i + 1
    tableData[i].AMEvaScoreNor = NorCal(tableData.length + 1, i + 1)
  }

  return tableData
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

import { http } from '../config/http'
import {
  urlGetAllUserRates, urlGetAllQTEvaedData
} from '@/config/interface'
import { sortObjectArrayByParams, NorCal } from '@/utils/common'

// 获取全处员工定性评价数据(已评价人为对象)
export function getAllUserRates (users, rateMonth) {
  const url = urlGetAllUserRates
  let params = {
    usersData: users,
    rateMonth: rateMonth
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        console.log(res.err)
        reject(new Error('getAllUserRates recv error!'))
      }
    }).catch(err => {
      console.log(err)
      reject(new Error('getAllUserRates send error!'))
    })
  })
}
// 获取全处员工定性评价数据(被评价人为对象)
export function getAllQTEvaedData (usersList, applyDate) {
  const url = urlGetAllQTEvaedData
  let params = {
    usersList: usersList,
    applyDate: applyDate
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        console.log(res.err)
        reject(new Error('getAllUserRates recv error!'))
      }
    }).catch(err => {
      console.log(err)
      reject(new Error('getAllUserRates send error!'))
    })
  })
}
// 计算定性评价各维度总分分数
export function calPerformanceEvaScore (t1Score, t2Score, t3Score, t4Score, t5Score, t6Score) {
  return t1Score * 0.15 + t2Score * 0.2 + t3Score * 0.1 + t4Score * 0.1 + t5Score * 0.3 + t6Score * 0.15
}
// 根据某个评价类型的评价得分计算加权分
function calQTRateMid (rate, rateType) {
  switch (rateType) {
    case 1:
      return rate * 0.15
    case 2:
      return rate * 0.2
    case 3:
      return rate * 0.1
    case 4:
      return rate * 0.1
    case 5:
      return rate * 0.3
    case 6:
      return rate * 0.15
    default:
      return 0
  }
}
// // 生成定性评价数据
// export function genQualiEvaData (multualData) {
//   let multualEvaScoreArr = []
//   for (let multualDataItem of multualData) { // res.data格式：[{groupName: ; id: ;name: ; rateData: [{}]; ratedData: [{}]}, {...}]
//     let obj = {
//       id: multualDataItem.id,
//       name: multualDataItem.name,
//       groupName: multualDataItem.groupName,
//       duty: multualDataItem.duty,
//       isRate: multualDataItem.rateData.length !== 0
//     }
//     let ratesTableTmp = []
//     let manageRate = 0
//     let totalRate = 0
//     let count = 0
//     for (let ratedData of multualDataItem.ratedData) {
//       if (ratedData.length !== null) {
//         // =======================整理从数据库获取的数据，按照被评价人结合评价项分组=====================
//         let index = ratesTableTmp.findIndex((itemInside) => {
//           return ratedData.ratePersion === itemInside.ratePersion
//         })
//         if (index === -1) {
//           let obj = {
//             ratePersion: ratedData.ratePersion,
//             duty: ratedData.duty,
//             groupName: groupName2String(ratedData.groupName)
//           }
//           obj[rateTypeSwitch(ratedData.rateType)] = ratedData.rate
//           ratesTableTmp.push(obj)
//         } else {
//           ratesTableTmp[index][rateTypeSwitch(ratedData.rateType)] = ratedData.rate
//         }
//       }
//     }
//     console.log('ratesTableTmp')
//     console.log(ratesTableTmp)
//     // ========================计算各被评价人评价得分总分===============================
//     for (let item of ratesTableTmp) {
//       item.totalScore = calPerformanceEvaScore(item.t1Star, item.t2Star, item.t3Star, item.t4Star,
//         item.t5Star, item.t6Star)
//       if (item.duty === 1) { // 经理评价
//         manageRate = item.totalScore
//       } else {
//         count++
//         totalRate += item.totalScore
//       }
//     }
//     console.log('multualDataItem')
//     console.log(multualDataItem)
//     console.log('totalRate')
//     console.log(totalRate)
//     console.log('count')
//     console.log(count)
//     // ==============================计算各评价人领导评价和普通员工评价平均分（未标准化的）===============================
//     if (manageRate === 0) { // 领导者尚未评价,重置为默认评分
//       let defaultRate = starToRates(store.state.defaultStar)
//       manageRate = calPerformanceEvaScore(defaultRate, defaultRate, defaultRate,
//         defaultRate, defaultRate, defaultRate)
//     }
//     if (obj.duty === 1) {
//       manageRate = 0
//     }
//     if (count === 0) {
//       count = 1 // 防止NAN
//     }
//     obj.CSMutualScoreAve = Number((totalRate / count).toFixed(5))
//     obj.MGQualiEvaScoreUnN = Number(manageRate.toFixed(5))
//     multualEvaScoreArr.push(obj)
//   }
//   let allUserRates = JSON.parse(JSON.stringify(multualEvaScoreArr))
//   let managerIndex = allUserRates.findIndex(allUserRatesItem => {
//     return allUserRatesItem.duty === 1
//   })
//   if (managerIndex !== -1) {
//     allUserRates.splice(managerIndex, 1)
//   }
//   let standAndEngineerRates = []
//   let communicationRates = []
//   for (let item of allUserRates) {
//     if (item.groupName === '技术标准组' || item.groupName === '工程组') {
//       standAndEngineerRates.push(item)
//     } else if (item.groupName === '通信组') {
//       communicationRates.push(item)
//     }
//   }
//   // =================================定性评价排序===============================================
//   // 技术标准组&工程组员工互评排序
//   for (let i = 0; i < standAndEngineerRates.length - 1; i++) {
//     for (let j = 0; j < standAndEngineerRates.length - 1 - i; j++) {
//       if (standAndEngineerRates[j].CSMutualScoreAve < standAndEngineerRates[j + 1].CSMutualScoreAve) {
//         [standAndEngineerRates[j], standAndEngineerRates[j + 1]] =
//           [standAndEngineerRates[j + 1], standAndEngineerRates[j]]
//       }
//     }
//   }
//   // 通信组员工互评排序
//   for (let i = 0; i < communicationRates.length - 1; i++) {
//     for (let j = 0; j < communicationRates.length - 1 - i; j++) {
//       if (communicationRates[j].CSMutualScoreAve < communicationRates[j + 1].CSMutualScoreAve) {
//         [communicationRates[j], communicationRates[j + 1]] =
//           [communicationRates[j + 1], communicationRates[j]]
//       }
//     }
//   }
//   // 全处员工领导评价排序
//   for (let i = 0; i < allUserRates.length - 1; i++) {
//     for (let j = 0; j < allUserRates.length - 1 - i; j++) {
//       if (allUserRates[j].MGQualiEvaScoreUnN < allUserRates[j + 1].MGQualiEvaScoreUnN) {
//         [allUserRates[j], allUserRates[j + 1]] =
//           [allUserRates[j + 1], allUserRates[j]]
//       }
//     }
//   }
//   // =================================定性评价得分计算===============================================
//   // 技术标准组与工程组互评排名&得分计算
//   let tmpCSMutualScoreAve = -1
//   let count = 1
//   // 技术标准组和工程组互评排名&得分计算
//   for (let i = 0; i < standAndEngineerRates.length; i++) {
//     if (standAndEngineerRates[i].CSMutualScoreAve === tmpCSMutualScoreAve) {
//       standAndEngineerRates[i].CSMutualScoreAveRank = standAndEngineerRates[i - 1].CSMutualScoreAveRank
//     } else {
//       standAndEngineerRates[i].CSMutualScoreAveRank = count
//       tmpCSMutualScoreAve = standAndEngineerRates[i].CSMutualScoreAve
//     }
//     count++
//     standAndEngineerRates[i].CSMutualScoreNor =
//       calGetScore(standAndEngineerRates.length, standAndEngineerRates[i].CSMutualScoreAveRank)
//   }
//   // 通信组互评排名&得分计算
//   tmpCSMutualScoreAve = -1
//   count = 1
//   for (let i = 0; i < communicationRates.length; i++) {
//     if (communicationRates[i].CSMutualScoreAve === tmpCSMutualScoreAve) {
//       communicationRates[i].CSMutualScoreAveRank = communicationRates[i - 1].CSMutualScoreAveRank
//     } else {
//       communicationRates[i].CSMutualScoreAveRank = count
//       tmpCSMutualScoreAve = communicationRates[i].CSMutualScoreAve
//     }
//     count++
//     communicationRates[i].CSMutualScoreNor =
//       calGetScore(communicationRates.length, communicationRates[i].CSMutualScoreAveRank)
//   }
//   // 全处员工领导评价排名&得分计算
//   let tmpMGQualiEvaScoreUnN = -1
//   count = 1
//   for (let i = 0; i < allUserRates.length; i++) {
//     if (allUserRates[i].MGQualiEvaScoreUnN === tmpMGQualiEvaScoreUnN) {
//       allUserRates[i].MGQualiEvaScoreRank = allUserRates[i - 1].MGQualiEvaScoreRank
//     } else {
//       allUserRates[i].MGQualiEvaScoreRank = count
//       tmpMGQualiEvaScoreUnN = allUserRates[i].MGQualiEvaScoreUnN
//     }
//     count++
//     allUserRates[i].MGQualiEvaScoreNor =
//       PMScoreNorCal(allUserRates.length, allUserRates[i].MGQualiEvaScoreRank)
//   }
//   let allQualiEvaScore = []
//   allQualiEvaScore = standAndEngineerRates.concat(communicationRates)
//   console.log('allQualiEvaScore')
//   console.log(allQualiEvaScore)
//   return allQualiEvaScore
// }

// 生成定性评价数据
export function genQualiEvaData (QTEvaedData, QYEvaScoreData) {
  let QTEvaScoreData = []
  let SEGroupQTEvaData = [] // 技术标准和工程组互评数据
  let CMGroupQTEvaData = [] // 通信组互评数据
  for (let QTEvaedDataItem of QTEvaedData) {
    let isMGEva = false
    let QTEvaedDataLength = QTEvaedDataItem.QTEvaedData.length
    let obj = {
      id: QTEvaedDataItem.ratedPersion,
      name: QTEvaedDataItem.ratedPersionName,
      groupName: QTEvaedDataItem.ratedPersionGroupName,
      groupID: QTEvaedDataItem.ratedPersionGroupID,
      dyty: QTEvaedDataItem.ratedPersionDuty,
      CSMutualScoreTotal: 0,
      CSMutualScoreAve: 0,
      CSMutualScoreAveRank: 0,
      CSMutualScoreNor: 0,
      MGQualiEvaScoreUnN: 0,
      MGQualiEvaScoreRank: 0,
      MGQualiEvaScoreNor: 0,
      totalWorkTime: typeof (QYEvaScoreData.find(item => { return item.id === QTEvaedDataItem.ratedPersion })) !== 'undefined'
        ? QYEvaScoreData.find(item => { return item.id === QTEvaedDataItem.ratedPersion }).totalWorkTime : 0
    }
    // 根据评价的类型计算加权分值
    for (let i = 0; i < QTEvaedDataLength; i++) {
      if (QTEvaedDataItem.QTEvaedData[i].ratePersionDuty === 1) { // 如果评价的人是处经理
        obj.MGQualiEvaScoreUnN += calQTRateMid(QTEvaedDataItem.QTEvaedData[i].rate, QTEvaedDataItem.QTEvaedData[i].rateType)
        isMGEva = true
      } else { // 评价的人不是处经理
        obj.CSMutualScoreTotal += calQTRateMid(QTEvaedDataItem.QTEvaedData[i].rate, QTEvaedDataItem.QTEvaedData[i].rateType)
      }
    }
    if (QTEvaedDataLength !== 0) {
      obj.CSMutualScoreAve = isMGEva ? obj.CSMutualScoreTotal / ((QTEvaedDataLength / 6) - 1) : obj.CSMutualScoreTotal / (QTEvaedDataLength / 6)
    }
    if (obj.groupID === 1 || obj.groupID === 2) {
      SEGroupQTEvaData.push(obj)
    } else if (obj.groupID === 3) {
      CMGroupQTEvaData.push(obj)
    }
  }
  // 根据定性评分值和总工时排序
  SEGroupQTEvaData = sortObjectArrayByParams(JSON.parse(JSON.stringify(SEGroupQTEvaData)), 'CSMutualScoreAve', 'totalWorkTime')
  CMGroupQTEvaData = sortObjectArrayByParams(JSON.parse(JSON.stringify(CMGroupQTEvaData)), 'CSMutualScoreAve', 'totalWorkTime')
  for (let i = 0; i < SEGroupQTEvaData.length; i++) {
    SEGroupQTEvaData[i].CSMutualScoreAveRank = i + 1
    SEGroupQTEvaData[i].CSMutualScoreNor = NorCal(SEGroupQTEvaData.length, i + 1)
  }
  for (let i = 0; i < CMGroupQTEvaData.length; i++) {
    CMGroupQTEvaData[i].CSMutualScoreAveRank = i + 1
    CMGroupQTEvaData[i].CSMutualScoreNor = NorCal(CMGroupQTEvaData.length, i + 1)
  }
  // 拼接3个组的定性评价计算成果
  QTEvaScoreData = SEGroupQTEvaData.concat(CMGroupQTEvaData)
  QTEvaScoreData = sortObjectArrayByParams(JSON.parse(JSON.stringify(QTEvaScoreData)), 'MGQualiEvaScoreUnN', 'totalWorkTime')
  for (let i = 0; i < QTEvaScoreData.length; i++) {
    QTEvaScoreData[i].MGQualiEvaScoreRank = i + 1
    QTEvaScoreData[i].MGQualiEvaScoreNor = NorCal(QTEvaScoreData.length + 1, i + 1)
  }

  return QTEvaScoreData
}

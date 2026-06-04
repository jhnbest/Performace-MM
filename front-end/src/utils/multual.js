import { http } from '../config/http'
import {
  urlGetAllUserRates, urlGetAllQTEvaedData, urlGetMonthEva
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
// ***获取全处员工定性评价数据(被评价人为对象)
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

// ***生成定性评价数据
// ***  QTEvaedData:定性互评数据； QYEvaScoreData：定量评价数据
export function genQualiEvaData (QTEvaedData, QYEvaScoreData) {
  let QTEvaScoreData = []
  let intelligentGroupQTEvaData = [] // ***智能化相关组互评数据
  let CMGroupQTEvaData = [] // ***通信组互评数据
  for (let QTEvaedDataItem of QTEvaedData) {
    let isMGEva = false
    let QTEvaedDataLength = QTEvaedDataItem.QTEvaedData.length
    // ***构造定性评价数据基本单元
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
    // ***根据评价的类型计算加权分值
    for (let i = 0; i < QTEvaedDataLength; i++) {
      if (QTEvaedDataItem.QTEvaedData[i].ratePersionDuty === 1) { // ***如果评价的人是处经理，则赋值处经理评价得分字段
        obj.MGQualiEvaScoreUnN += calQTRateMid(QTEvaedDataItem.QTEvaedData[i].rate, QTEvaedDataItem.QTEvaedData[i].rateType)
        isMGEva = true
      } else { // ***如果评价的人不是处经理，则对员工评价数据进行加权累加
        obj.CSMutualScoreTotal += calQTRateMid(QTEvaedDataItem.QTEvaedData[i].rate, QTEvaedDataItem.QTEvaedData[i].rateType)
      }
    }
    // ***计算员工互评的平均分
    if (QTEvaedDataLength !== 0) {
      obj.CSMutualScoreAve = isMGEva ? obj.CSMutualScoreTotal / ((QTEvaedDataLength / 6) - 1) : obj.CSMutualScoreTotal / (QTEvaedDataLength / 6)
    }
    // ***根据被评价人组别填充相应的定性评价元素入数组
    if (obj.groupID === 2 || obj.groupID === 3 || obj.groupID === 4) { // **智能化相关组
      intelligentGroupQTEvaData.push(obj)
    } else if (obj.groupID === 5) { // ***通信组
      CMGroupQTEvaData.push(obj)
    }
  }
  // ***根据定性评分值和总工时排序，如果定性评价得分一样，则按照工时排序
  intelligentGroupQTEvaData = sortObjectArrayByParams(JSON.parse(JSON.stringify(intelligentGroupQTEvaData)), 'CSMutualScoreAve', 'totalWorkTime')
  CMGroupQTEvaData = sortObjectArrayByParams(JSON.parse(JSON.stringify(CMGroupQTEvaData)), 'CSMutualScoreAve', 'totalWorkTime')
  // ***根据被评价人的员工互评得分排名计算员工定性互评标准化得分
  for (let i = 0; i < intelligentGroupQTEvaData.length; i++) {
    intelligentGroupQTEvaData[i].CSMutualScoreAveRank = i + 1
    intelligentGroupQTEvaData[i].CSMutualScoreNor = NorCal(intelligentGroupQTEvaData.length, i + 1)
  }
  for (let i = 0; i < CMGroupQTEvaData.length; i++) {
    CMGroupQTEvaData[i].CSMutualScoreAveRank = i + 1
    CMGroupQTEvaData[i].CSMutualScoreNor = NorCal(CMGroupQTEvaData.length, i + 1)
  }
  // ***拼接所有组的定性评价计算成果
  QTEvaScoreData = intelligentGroupQTEvaData.concat(CMGroupQTEvaData)
  // ***根据管理者评价得分进行排序
  QTEvaScoreData = sortObjectArrayByParams(JSON.parse(JSON.stringify(QTEvaScoreData)), 'MGQualiEvaScoreUnN', 'totalWorkTime')
  // ***根据被评价人的管理者评价得分排名计算员工管理者评价计算标准化得分
  for (let i = 0; i < QTEvaScoreData.length; i++) {
    QTEvaScoreData[i].MGQualiEvaScoreRank = i + 1
    QTEvaScoreData[i].MGQualiEvaScoreNor = NorCal(QTEvaScoreData.length + 1, i + 1)
  }
  return QTEvaScoreData
}

// 提取上月互评结果
export function getMonthEva (rateUserID, rateMonth) {
  const url = urlGetMonthEva
  let params = {
    rateUserID: rateUserID,
    rateMonth: rateMonth
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        if (res.data.length === 0) {
          reject(new Error('查询月份未评价'))
        } else {
          resolve(res.data)
        }
      } else {
        console.log(res.err)
        reject(new Error('getPreMonthEva send error!'))
      }
    }).catch(err => {
      console.log(err)
      reject(new Error('getPreMonthEva send error!'))
    })
  })
}

// 评分类型转文字
export function rateTypeToText (rateType) {
  switch (rateType) {
    case 1:
      return 't1Star'
    case 2:
      return 't2Star'
    case 3:
      return 't3Star'
    case 4:
      return 't4Star'
    case 5:
      return 't5Star'
    case 6:
      return 't6Star'
  }
}

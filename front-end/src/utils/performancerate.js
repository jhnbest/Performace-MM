import { http } from '../config/http'
import {
  urlGetAllAchievements
} from '../config/interface'
import { groupName2String } from './users'
import { rateTypeSwitch, calGetScore, starToRates } from './common'
import store from '@/store'

// 计算成效评价分数
export function calPerformanceEvaScore (t1Star, t2Star, t3Star, t4Star, t5Star, t6Star) {
  return t1Star * 0.15 + t2Star * 0.2 + t3Star * 0.1 + t4Star * 0.1 + t5Star * 0.3 + t6Star * 0.15
}

// 获取全处成效评价结果
export function getAllAchievements (userList, applyDate) {
  const url = urlGetAllAchievements
  const params = {
    userList: userList,
    rateMonth: applyDate
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.data)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// 生成成效评价数据
export function genPerformanceEvaData (performanceEvaData, evaCoefObj) {
  let PMEvaScoreArr = []
  // ========================根据从成效评价数据库获取的数据计算每个人的成效得分========================
  for (let performanceEvaDataItem of performanceEvaData) {
    let obj = {
      id: performanceEvaDataItem.id,
      name: performanceEvaDataItem.name,
      groupName: performanceEvaDataItem.groupName,
      duty: performanceEvaDataItem.duty,
      isRate: performanceEvaDataItem.rateData.length !== 0
    }
    let ratesTableTmp = []
    let manageRate = 0
    let groupRate = 0
    let totalRate = 0
    let count = 0
    for (let ratedData of performanceEvaDataItem.ratedData) {
      if (ratedData.length !== null) {
        // =======================整理从数据库获取的数据，按照被评价人结合评价项分组=====================
        let index = ratesTableTmp.findIndex((itemInside) => {
          return ratedData.ratePersion === itemInside.ratePersion
        })
        if (index === -1) {
          let obj = {
            ratePersion: ratedData.ratePersion,
            duty: ratedData.duty,
            groupName: groupName2String(ratedData.groupName)
          }
          obj[rateTypeSwitch(ratedData.rateType)] = ratedData.rate
          ratesTableTmp.push(obj)
        } else {
          ratesTableTmp[index][rateTypeSwitch(ratedData.rateType)] = ratedData.rate
        }
      }
    }
    // ========================计算各被评价人成效评价得分总分===============================
    for (let item of ratesTableTmp) {
      item.totalScore = calPerformanceEvaScore(item.t1Star, item.t2Star, item.t3Star, item.t4Star,
        item.t5Star, item.t6Star)
      if (item.duty === 1) { // 经理评价
        manageRate = item.totalScore
      } else if (item.duty === 2 && (item.groupName === performanceEvaDataItem.groupName)) { // 本组组长评价
        groupRate = item.totalScore
      } else {
        count++
        totalRate += item.totalScore
      }
    }
    // ==============================计算各评价人领导评价和普通员工评价平均分（未标准化的）===============================
    if (manageRate === 0) { // 领导者尚未评价,重置为默认评分
      let defaultRate = starToRates(store.state.defaultStar)
      manageRate = calPerformanceEvaScore(defaultRate, defaultRate, defaultRate,
        defaultRate, defaultRate, defaultRate)
    }
    if (count === 0) {
      count = 1 // 防止NAN
    }
    obj.CSPMEvaScoreAve = Number((totalRate / count).toFixed(5))
    obj.GPPMEvaScoreUnN = Number(groupRate.toFixed(5))
    obj.MGEvaScoreUnN = Number(manageRate.toFixed(5))
    if (obj.duty === 2) {
      obj.PMEvaScoreUnN = obj.CSPMEvaScoreAve * evaCoefObj.GPCommonStaffPMEvaCoef +
       obj.MGEvaScoreUnN * evaCoefObj.GPManagerPMEvaCoef
    } else if (obj.duty === 3) {
      obj.PMEvaScoreUnN = obj.CSPMEvaScoreAve * evaCoefObj.CScommonStaffPMEvaCoef +
       obj.MGEvaScoreUnN * evaCoefObj.CSManagerPMEvaCoef +
       obj.GPPMEvaScoreUnN * evaCoefObj.CSGroupLeaderPMEvaCoef
    } else {
      obj.PMEvaScoreUnN = 0
    }
    obj.PMEvaScoreUnN = Number(obj.PMEvaScoreUnN.toFixed(5))
    PMEvaScoreArr.push(obj)
  }
  // =================================按照成员所属组别计算成效标准化得分======================================
  let allPerformanceEvaRates = JSON.parse(JSON.stringify(PMEvaScoreArr))
  let managerIndex = allPerformanceEvaRates.findIndex(allUserRatesItem => {
    return allUserRatesItem.id === 26
  })
  // 去除处经理
  if (managerIndex !== -1) {
    allPerformanceEvaRates.splice(managerIndex, 1)
  }
  // =================按组别存放=====================
  let standAndEngineerRates = []
  let communicationRates = []
  for (let item of allPerformanceEvaRates) {
    if (item.groupName === '技术标准组' || item.groupName === '工程组') {
      standAndEngineerRates.push(item)
    } else if (item.groupName === '通信组') {
      communicationRates.push(item)
    }
  }
  // ===================成效评价排序=======================
  // 技术标准组&工程组员工成效评价排序
  for (let i = 0; i < standAndEngineerRates.length - 1; i++) {
    for (let j = 0; j < standAndEngineerRates.length - 1 - i; j++) {
      if (standAndEngineerRates[j].PMEvaScoreUnN < standAndEngineerRates[j + 1].PMEvaScoreUnN) {
        [standAndEngineerRates[j], standAndEngineerRates[j + 1]] =
          [standAndEngineerRates[j + 1], standAndEngineerRates[j]]
      }
    }
  }
  // 通信组员工成效评价排序
  for (let i = 0; i < communicationRates.length - 1; i++) {
    for (let j = 0; j < communicationRates.length - 1 - i; j++) {
      if (communicationRates[j].PMEvaScoreUnN < communicationRates[j + 1].PMEvaScoreUnN) {
        [communicationRates[j], communicationRates[j + 1]] =
          [communicationRates[j + 1], communicationRates[j]]
      }
    }
  }
  // ====================成效评价得分计算=======================
  // 技术标准组与工程组成效评价排名计算并根据排名计算标准化成效得分
  let tmpPMEvaScore = -1
  let count1 = 1
  for (let i = 0; i < standAndEngineerRates.length; i++) {
    if (standAndEngineerRates[i].PMEvaScoreUnN === tmpPMEvaScore) {
      standAndEngineerRates[i].PMEvaScoreUnNRank = standAndEngineerRates[i - 1].PMEvaScoreUnNRank
    } else {
      standAndEngineerRates[i].PMEvaScoreUnNRank = count1
      tmpPMEvaScore = standAndEngineerRates[i].PMEvaScoreUnN
    }
    count1++
    standAndEngineerRates[i].PMEvaScoreNor =
      calGetScore(standAndEngineerRates.length, standAndEngineerRates[i].PMEvaScoreUnNRank)
  }
  // 通信组成效评价排名计算并根据排名计算标准化成效得分
  tmpPMEvaScore = -1
  count1 = 1
  for (let i = 0; i < communicationRates.length; i++) {
    if (communicationRates[i].PMEvaScoreUnN === tmpPMEvaScore) {
      communicationRates[i].PMEvaScoreUnNRank = communicationRates[i - 1].PMEvaScoreUnNRank
    } else {
      communicationRates[i].PMEvaScoreUnNRank = count1
      tmpPMEvaScore = communicationRates[i].PMEvaScoreUnN
    }
    count1++
    communicationRates[i].PMEvaScoreNor =
      calGetScore(communicationRates.length, communicationRates[i].PMEvaScoreUnNRank)
  }
  // =================================成效评价结果合并===============================================
  let allPMEvaScore = standAndEngineerRates.concat(communicationRates)
  return allPMEvaScore
}

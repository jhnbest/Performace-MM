import { http } from '../config/http'
import {
    urlGetAllWorkTimeList,
    urlSavePMData
} from '../config/interface'
import { getUsersList } from '@/utils/users'
import { getPerformanceIsPublish,
        calGetScore,
        compare,
        getEvaCoef,
        PMScoreNorCal,
        sortBy,
        sortObjectArrayByParams } from '@/utils/common'
import { getAllUserRates, genQualiEvaData } from '@/utils/multual'
import { getAllAchievements, genPerformanceEvaData } from '@/utils/performancerate'
import store from '@/store'

import moment from 'moment'

// 获取全处工时信息
export function getAllWorkTimeList (applyDate) {
  const url = urlGetAllWorkTimeList
  let params = {
    applyMonth: applyDate
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
          let recvData = res.data
          resolve(recvData)
      } else {
          reject(new Error('getAllWorkTimeList recv error'))
      }
    }).catch((err) => {
      reject(new Error(err + '请求失败'))
    })
  })
}

// 生成定量数据
export function genQYEvaScoreData (users, quantativeData, applyMonth) {
  let QYEvaScoreData = []
  // =============================对当月无工时申报的员工填充0工时==================================
  for (let item of users) {
    let findItem = quantativeData.findIndex(quantativeDataItem => {
      return quantativeDataItem.id === item.id
    })
    if (findItem === -1 && item.groupName !== '处经理') {
        let obj = {
          applyMonth: applyMonth,
          groupID: item.groupID,
          id: item.id,
          name: item.name,
          reviewWorkTime: 0
        }
        quantativeData.push(obj)
    }
  }
  // ===============================将所有工时申报信息按组存放===================================
  let groupedWorkTimeList = []
  for (let item of quantativeData) {
    if (item.id !== store.state.managerID) {
      let index = groupedWorkTimeList.findIndex(itemInside => {
          return itemInside.groupID === item.groupID
      })
      if (index === -1) {
          let obj = {
              groupID: item.groupID,
              workTimeList: []
          }
          obj.workTimeList.push(item)
          groupedWorkTimeList.push(obj)
      } else {
          groupedWorkTimeList[index].workTimeList.push(item)
      }
    }
  }
  // --------------------------分别计算小组内每个人的工时数、排名和得分--------------------------
  for (let groupedWorkTimeListItem of groupedWorkTimeList) {
    let totalWorkTimeCal = []
    if (groupedWorkTimeListItem.workTimeList.length > 0) {
      for (let item1 of groupedWorkTimeListItem.workTimeList) { // 将各组工时信息按照个人统计
        let index = totalWorkTimeCal.findIndex(totalWorkTimeCalItem => {
            return totalWorkTimeCalItem.id === item1.id
        })
        if (index === -1) {
            let obj = {
                id: item1.id,
                name: item1.name,
                totalWorkTime: item1.reviewWorkTime
            }
            totalWorkTimeCal.push(obj)
        } else {
            totalWorkTimeCal[index].totalWorkTime += item1.reviewWorkTime
        }
      }
      // ===========================计算组内工时排名==================================
      totalWorkTimeCal.sort(compare('totalWorkTime')) // 根据总工时排序
      let preWorkTime = -1
      let preRank = 1
      let count = 1
      for (let item of totalWorkTimeCal) { // 计算排名
        if (item.totalWorkTime === preWorkTime) {
          item.rank = preRank
        } else {
          item.rank = count
          preRank = count
        }
        count++
        preWorkTime = item.totalWorkTime
      }
      // ==============================计算定量指标得分=======================================
      for (let totalWorkTimeCalItem of totalWorkTimeCal) { // 根据排名计算定量指标得分
        totalWorkTimeCalItem.QYEvaScoreNor = calGetScore(totalWorkTimeCal.length, totalWorkTimeCalItem.rank)
      }
    }
    groupedWorkTimeListItem.caledQYEvaData = totalWorkTimeCal

    for (let itemInside of groupedWorkTimeListItem.caledQYEvaData) {
        QYEvaScoreData.push(itemInside)
    }
  }
  return QYEvaScoreData
}

// 生成绩效得分与排名数据(新)
export function genPerformanceScore (usersList, QYEvaScoreData, QTEvaScoreData, AMEvaScoreData, evaCoefObj) {
    let userPMScoreData = []
    // ==============================绩效得分(未标准化)计算================================
    for (let user of usersList) {
      let itemQuantativeScore = QYEvaScoreData.find(quantativeDataItem => { // 找出初始表格成员对应的定量数据
        return quantativeDataItem.id === user.id
      })
      let itemMultualEvaScore = QTEvaScoreData.find(multualEvaDataItem => { // 找出初始表格成员对应的定性数据
        return multualEvaDataItem.id === user.id
      })
      let itemAMEvaObj = AMEvaScoreData.find(AMEvaScoreDataItem => { // 找出初始表格成员对应的成效评价数据
        return AMEvaScoreDataItem.evaedUserID === user.id
      })
      let obj = {}
      // 计算未标准化的绩效得分
      if (itemQuantativeScore && itemMultualEvaScore && itemAMEvaObj) {
        obj.PMScoreUnN =
            itemQuantativeScore.QYEvaScoreNor * evaCoefObj.quantitativeCoef + // 定量评价乘上相应系数
            itemMultualEvaScore.CSMutualScoreNor * evaCoefObj.CSMutualCoef + // 定性评价（员工互评）乘上相应系数
            itemMultualEvaScore.MGQualiEvaScoreNor * evaCoefObj.MGEvaCoef + // 定性评价（经理评价）乘上相应系数
            itemAMEvaObj.AMEvaScoreNor * evaCoefObj.PMEvaCoef // 成效评价乘上相应系数

            obj.totalWorkTime = Number(itemQuantativeScore.totalWorkTime.toFixed(2))
            obj.QYEvaRank = itemQuantativeScore.rank
            obj.QYEvaScoreNor = itemQuantativeScore.QYEvaScoreNor
            obj.MGQTEvaScoreUnN = itemMultualEvaScore.MGQualiEvaScoreUnN
            obj.MGQTEvaRank = itemMultualEvaScore.MGQualiEvaScoreRank
            obj.MGQTEvaScoreNor = itemMultualEvaScore.MGQualiEvaScoreNor
            obj.CSQTEvaScoreUnN = itemMultualEvaScore.CSMutualScoreAve
            obj.CSQTEvaRank = itemMultualEvaScore.CSMutualScoreAveRank
            obj.CSQTEvaScoreNor = itemMultualEvaScore.CSMutualScoreNor
            obj.AMEvaScoreUnN = itemAMEvaObj.AMEvaScoreUnN
            obj.AMEvaRank = itemAMEvaObj.AMEvaScoreRank
            obj.AMEvaScoreNor = itemAMEvaObj.AMEvaScoreNor
      }
      userPMScoreData.push(obj)
    }
    userPMScoreData = sortObjectArrayByParams(JSON.parse(JSON.stringify(userPMScoreData)), 'PMScoreUnN', 'totalWorkTime')
    for (let i = 0; i < userPMScoreData.length; i++) {
      userPMScoreData[i].PMRank = i + 1 // 绩效排名计算
      userPMScoreData[i].PMScoreNor = PMScoreNorCal(usersList.length, i + 1)
    }
    return userPMScoreData
}

// 生成绩效得分与排名数据(旧)
export function genPerformanceScoreOld (usersList, quantativeData, multualEvaData) {
    let userPMScoreData = []
    // ==============================绩效得分(未标准化)计算================================
    for (let user of usersList) {
      let itemQuantativeScore = quantativeData.find(quantativeDataItem => { // 找出初始表格成员对应的定量数据
        return quantativeDataItem.id === user.id
      })
      let itemMultualEvaScore = multualEvaData.find(multualEvaDataItem => { // 找出初始表格成员对应的定性数据
        return multualEvaDataItem.id === user.id
      })
      let obj = {
          id: user.id,
          name: user.name,
          groupName: user.groupName
      }
      // 计算未标准化的绩效得分
      if (itemQuantativeScore && itemMultualEvaScore) {
        if (user.id === 7 || user.id === 11 || user.id === 31) { // 主任岗
            obj.PMScoreUnN =
              itemQuantativeScore.QYEvaScoreNor * 0.5 + // 定量评价乘上相应系数
              itemMultualEvaScore.CSMutualScoreNor * 0.2 + // 定性评价（员工互评）乘上相应系数
              itemMultualEvaScore.MGQualiEvaScoreNor * 0.3 // 定性评价（经理评价）乘上相应系数
          } else if (user.id === 13 || user.id === 17 || user.id === 33) { // 组长
            obj.PMScoreUnN =
              itemQuantativeScore.QYEvaScoreNor * 0.3 + // 定量评价乘上相应系数
              itemMultualEvaScore.CSMutualScoreNor * 0.3 + // 定性评价（员工互评）乘上相应系数
              itemMultualEvaScore.MGQualiEvaScoreNor * 0.4 // 定性评价（经理评价）乘上相应系数
          } else { // 普通员工
            obj.PMScoreUnN =
              itemQuantativeScore.QYEvaScoreNor * 0.7 + // 定量评价乘上相应系数
              itemMultualEvaScore.CSMutualScoreNor * 0.1 + // 定性评价（员工互评）乘上相应系数
              itemMultualEvaScore.MGQualiEvaScoreNor * 0.2 // 定性评价（经理评价）乘上相应系数
          }

            obj.totalWorkTime = Number(itemQuantativeScore.totalWorkTime.toFixed(2))
            obj.QYEvaRank = itemQuantativeScore.rank
            obj.QYEvaScoreNor = itemQuantativeScore.QYEvaScoreNor
            obj.MGQTEvaScoreUnN = itemMultualEvaScore.MGQualiEvaScoreUnN
            obj.MGQTEvaRank = itemMultualEvaScore.MGQualiEvaScoreRank
            obj.MGQTEvaScoreNor = itemMultualEvaScore.MGQualiEvaScoreNor
            obj.CSQTEvaScoreUnN = itemMultualEvaScore.CSMutualScoreAve
            obj.CSQTEvaRank = itemMultualEvaScore.CSMutualScoreAveRank
            obj.CSQTEvaScoreNor = itemMultualEvaScore.CSMutualScoreNor
      }
      userPMScoreData.push(obj)
    }
    userPMScoreData.sort(sortBy('PMScoreUnN'))
    // ====================================绩效排名与标准化绩效得分计算======================================
    let count = 0
    let prePMScoreUnN = -1
    let rankTmp = []
    let count1 = -1
    let count2 = 1
    // 把绩效得分相同的人员存进对象数组同一个元素里面
    for (let i = 0; i < userPMScoreData.length; i++) {
      if (userPMScoreData[i].PMScoreUnN === prePMScoreUnN) {
        rankTmp[count1].push(userPMScoreData[i])
      } else {
        count1++
        if (!rankTmp[count1]) {
          rankTmp[count1] = []
        }
        rankTmp[count1].push(userPMScoreData[i])
        prePMScoreUnN = userPMScoreData[i].PMScoreUnN
      }
    }
    // 绩效得分相同的人员根据工时多少进行排序
    for (let i = 0; i < rankTmp.length; i++) {
      rankTmp[i].sort(sortBy('totalWorkTime'))
      for (let j = 0; j < rankTmp[i].length; j++) {
        userPMScoreData[count++] = rankTmp[i][j]
      }
    }
    for (let item of userPMScoreData) {
      item.PMRank = count2++ // 绩效排名计算
      item.PMScoreNor = PMScoreNorCal(usersList.length, item.PMRank)
    }
    return userPMScoreData
}

// 获取全处绩效数据
export function calPMData (applyDate) {
  let applyYear = moment(applyDate).year()
  let applyMonth = moment(applyDate).month() + 1
  let promises0 = []
  let count0 = 0
  let promises = []
  let count = 0
  return new Promise(function (resolve, reject) {
    getPerformanceIsPublish(applyYear, applyMonth).then(response => {
      if (response.length > 0) {
          if (response[0].flagValue > 0) {
              promises0[count0++] = getEvaCoef() // get各种系数
              promises0[count0++] = getUsersList() // get用户列表
              Promise.all(promises0).then(responseAll0 => {
                let evaCoef = responseAll0[0]
                let usersList = responseAll0[1]
                let MGIndex = usersList.findIndex(user => {
                    return user.duty == 1
                })
                usersList.splice(MGIndex, 1) // 删除管理者
                promises[count++] = getAllWorkTimeList(applyDate) // get工时信息
                promises[count++] = getAllUserRates(usersList, applyDate) // get定性评价信息
                if (moment(applyDate).isAfter('2022-01')) { // 2022-02新增成效评价模式
                    promises[count++] = getAllAchievements(usersList, applyDate) // get成效评价信息
                }
                Promise.all(promises).then(responseAll1 => {
                  let allWorkTimeList = responseAll1[0]
                  let allUserRates = responseAll1[1]
                  let allAchievements = responseAll1[2]
                  let QYEvaScoreData = genQYEvaScoreData(usersList, allWorkTimeList, applyDate)
                  let QTEvaScoreData = genQualiEvaData(allUserRates)
                  let AMEvaScoreData = null
                  let PMData = null
                  if (moment(applyDate).isAfter('2022-01')) { // 2022-02新增成效评价模式
                      AMEvaScoreData = genPerformanceEvaData(allAchievements, evaCoef) // get成效评价信息
                      PMData = genPerformanceScore(usersList, QYEvaScoreData, QTEvaScoreData, AMEvaScoreData, evaCoef)
                  } else {
                      PMData = genPerformanceScoreOld(usersList, QYEvaScoreData, QTEvaScoreData)
                  }
                  resolve(PMData)
                })
              })
          } else {
              reject(new Error('该月绩效未发布'))
          }
      } else {
          reject(new Error('该月绩效未发布'))
      }
    }).catch(err => {
      reject(new Error(err))
    })
  })
}

// 写入绩效数据
export function savePMData (applyDate, PMData) {
    return new Promise(function (resolve, reject) {
        let url = urlSavePMData
        let params = {
            applyDate: applyDate,
            userID: PMData.id,
            totalWorkTime: PMData.totalWorkTime,
            QYEvaRank: PMData.QYEvaRank,
            QYEvaScoreNor: PMData.QYEvaScoreNor,
            CSQTEvaScoreUnN: PMData.CSQTEvaScoreUnN,
            CSQTEvaScoreNor: PMData.CSQTEvaScoreNor,
            CSQTEvaRank: PMData.CSQTEvaRank,
            MGQTEvaScoreUnN: PMData.MGQTEvaScoreUnN,
            MGQTEvaRank: PMData.MGQTEvaRank,
            MGQTEvaScoreNor: PMData.MGQTEvaScoreNor,
            AMEvaScoreUnN: PMData.AMEvaScoreUnN,
            AMEvaScoreNor: PMData.AMEvaScoreNor,
            AMEvaRank: PMData.AMEvaRank,
            PMScoreUnN: PMData.PMScoreUnN,
            PMScoreNor: PMData.PMScoreNor,
            PMRank: PMData.PMRank,
            remarks: PMData.remarks
        }
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

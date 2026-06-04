import { http } from '../config/http'
import {
    urlGetAllWorkTimeList,
    urlSavePMData,
    urlSavePMDataV2,
    urlSavePMDataV3,
    performanceInfoPublish,
    urlUpdatePMData,
    urlUpdatePMDataV2,
    urlUpdatePMDataV3,
    urlGetPMData,
    urlGetWorkAssign,
    urlDeleteWorkTimeSubmit,
    urlGetProjectType,
    urlWorkTimeSubmit,
    urlWorkTimeTemporary,
    urlGetProjectList,
    urlChangeSubmitStatus,
    urlGetSubmitWorkTimeCount,
    urlMianshenheWorkTimeSubmit,
    urlGetWorkTimeListByType,
    urlGetProjectInfo
} from '../config/interface'
import { calGetScore,
        compare,
        sortBy,
        sortObjectArrayByParams,
        NorCal,
        NorCalV2,
        NorCalTmp } from '@/utils/common'

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

export function getProjectInfo (workTimeID, aplID) { // 获取工时申报详情
  let url = urlGetProjectInfo
  let params = {
    id: workTimeID,
    aplID: aplID
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        let recvData = res
        resolve(recvData)
      } else {
        reject(new Error('getAllWorkTimeList recv error'))
      }
    }).catch((err) => {
      reject(new Error(err + '请求失败'))
    })
  })
}

// 获取项目列表
export function getProjectList (searchID, searchMon, pageNum, pageSize, searchType, reviewType) {
  const url = urlGetProjectList
  return new Promise(function (resolve, reject) {
    let params = {
      searchID: searchID,
      searchMon: searchMon,
      pageNum: pageNum,
      pageSize: pageSize,
      searchType: searchType,
      reviewType: reviewType
    }
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// 获取工时标准
export function getProjectType (groupName) {
  const url = urlGetProjectType
  let params = {
    projectParentID: groupName
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// 插入工时申报
export function workTimeListInsert (projectID, submitType, submitDate, applyType, data) {
  const url = urlWorkTimeSubmit
  let params = {
    projectID: projectID,
    submitType: submitType,
    submitDate: submitDate,
    data: data,
    applyType: applyType
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

// 暂存工时申报
export function temporaryWorkTimeList (projectID, submitType, submitDate, data, applyType) {
  const url = urlWorkTimeTemporary
  return new Promise(function (resolve, reject) {
    let params = {
      projectID: projectID,
      submitType: submitType,
      submitDate: submitDate,
      data: data,
      applyType: applyType
    }
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.code)
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// ***生成定量数据
export function genQYEvaScoreData (users, quantativeData, applyMonth) {
  let QYEvaScoreData = []
  // ***对当月无工时申报的员工填充0工时
  for (let user of users) {
    let findItem = quantativeData.findIndex(quantativeDataItem => {
      return quantativeDataItem.id === user.id
    })
    if (findItem === -1 && user.groupID !== 1) {
        let obj = {
          applyMonth: applyMonth,
          groupID: user.groupID,
          id: user.id,
          name: user.name,
          duty: user.duty,
          reviewWorkTime: 0
        }
        quantativeData.push(obj)
    }
  }
  // ***将所有工时申报信息按组存放
  let groupedWorkTimeList = []
  for (let item of quantativeData) {
    if (item.duty !== 1) {
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
  // ***分别计算小组内每个人的工时数、排名和得分
  for (let groupedWorkTimeListItem of groupedWorkTimeList) {
    let totalWorkTimeCal = []
    for (let item1 of groupedWorkTimeListItem.workTimeList) { // **将各组工时信息按照个人统计
      let index = totalWorkTimeCal.findIndex(totalWorkTimeCalItem => {
        return totalWorkTimeCalItem.id === item1.id
      })
      if (index === -1) {
        let obj = {
          id: item1.id,
          name: item1.name,
          duty: item1.duty,
          totalWorkTime: item1.reviewWorkTime,
          groupID: groupedWorkTimeListItem.groupID
        }
        totalWorkTimeCal.push(obj)
      } else {
        totalWorkTimeCal[index].totalWorkTime += item1.reviewWorkTime
      }
    }
    // ***计算组内工时排名并计算定量指标得分
    totalWorkTimeCal.sort(compare('totalWorkTime')) // ***根据总工时排序
    let preWorkTime = -1
    let preRank = 1
    let count = 1
    for (let totalWorkTimeCalItem of totalWorkTimeCal) { // ***计算排名
      if (totalWorkTimeCalItem.totalWorkTime === preWorkTime) {
        totalWorkTimeCalItem.rank = preRank
      } else {
        totalWorkTimeCalItem.rank = count
        preRank = count
      }
      // ***定量评价标准化得分计算
      if (totalWorkTimeCalItem.groupID === 2 || totalWorkTimeCalItem.groupID === 3) { // **由于多媒体应用组和数字物联组人数较少，标准化在2024年1月先特殊计算
        totalWorkTimeCalItem.QYEvaScoreNor = NorCalTmp(totalWorkTimeCalItem.rank)
      } else {
        totalWorkTimeCalItem.QYEvaScoreNor = NorCalV2(totalWorkTimeCal.length, totalWorkTimeCalItem.rank)
      }

      QYEvaScoreData.push(totalWorkTimeCalItem)
      count++
      preWorkTime = totalWorkTimeCalItem.totalWorkTime
    }
  }
  return QYEvaScoreData
}
// ***生成定量数据V2,实行工时上限计算规则
export function genQYEvaScoreDataV2 (users, quantativeData, applyMonth) {
  let QYEvaScoreData = []
  // ***对当月无工时申报的员工填充0工时
  for (let user of users) {
    let findItem = quantativeData.findIndex(quantativeDataItem => {
      return quantativeDataItem.id === user.id
    })
    if (findItem === -1 && user.groupID !== 1) {
        let obj = {
          applyMonth: applyMonth,
          groupID: user.groupID,
          id: user.id,
          name: user.name,
          duty: user.duty,
          reviewWorkTime: 0,
          totalWorkTime: 0
        }
        quantativeData.push(obj)
    }
  }
  let allWorkTimeList = []
  for (let quantativeDataItem of quantativeData) {
    let findIndex = allWorkTimeList.findIndex(item => { return item.id === quantativeDataItem.id })
    if (findIndex === -1) {
      quantativeDataItem.totalWorkTime = quantativeDataItem.reviewWorkTime
      allWorkTimeList.push(quantativeDataItem)
    } else {
      allWorkTimeList[findIndex].totalWorkTime += quantativeDataItem.reviewWorkTime
    }
  }
  let rank = 1
  allWorkTimeList.sort(compare('totalWorkTime')) // ***根据总工时排序
  for (let allWorkTimeListItem of allWorkTimeList) {
    allWorkTimeListItem.rank = rank++
    if (allWorkTimeListItem.totalWorkTime < 50) {
      allWorkTimeListItem.QYEvaScoreNor = 85
    } else if (allWorkTimeListItem.totalWorkTime > 300) {
      allWorkTimeListItem.QYEvaScoreNor = 95
    } else {
      allWorkTimeListItem.QYEvaScoreNor = Number(((allWorkTimeListItem.totalWorkTime - 50) * 0.04 + 85).toFixed(3))
    }
    QYEvaScoreData.push(allWorkTimeListItem)
  }

  return QYEvaScoreData
}

// ***生成绩效得分与排名数据(新)
export function genPerformanceScore (tableData, QYEvaScoreData, QTEvaScoreData, evaCoefObj) {
  // ***绩效得分(未标准化)计算
  for (let tableDataItem of tableData) {
    let itemQuantativeScore = QYEvaScoreData.find(quantativeDataItem => { // **找出初始表格成员对应的定量评价数据
      return quantativeDataItem.id === tableDataItem.id
    })
    let itemMultualEvaScore = QTEvaScoreData.find(multualEvaDataItem => { // **找出初始表格成员对应的定性评价数据
      return multualEvaDataItem.id === tableDataItem.id
    })
    // ***计算未标准化的绩效得分
    if (itemQuantativeScore && itemMultualEvaScore) {
      // **根据当前评价成员是否是组长，计算绩效得分（因为组长和组员绩效计算方式不同）
      tableDataItem.PMScoreUnN =
        itemQuantativeScore.QYEvaScoreNor * evaCoefObj.quantitativeCoef + // **定量评价标准得分乘上相应系数
        itemMultualEvaScore.CSMutualScoreNor * evaCoefObj.CSMutualCoef + // **定性标准化得分（员工互评）乘上相应系数
        itemMultualEvaScore.MGQualiEvaScoreNor * evaCoefObj.MGEvaCoef + // **定性评价标准化得分（经理评价）乘上相应系数
        tableDataItem.AMEvaScoreNor * evaCoefObj.PMEvaCoef // **成效评价标准化得分乘上相应系数
      tableDataItem.PMScoreUnN = Number(tableDataItem.PMScoreUnN.toFixed(2)) // **保留2位小数
      tableDataItem.QYEvaRank = itemQuantativeScore.rank // **定量评价排名
      tableDataItem.QYEvaScoreNor = itemQuantativeScore.QYEvaScoreNor // **定量评价标准化得分
      tableDataItem.MGQTEvaScoreUnN = itemMultualEvaScore.MGQualiEvaScoreUnN // **定性评价得分（经理评价）
      tableDataItem.MGQTEvaRank = itemMultualEvaScore.MGQualiEvaScoreRank // **定性评价排名（经理评价）
      tableDataItem.MGQTEvaScoreNor = itemMultualEvaScore.MGQualiEvaScoreNor // **定性评价标准化得分（经理评价）
      tableDataItem.CSQTEvaScoreUnN = itemMultualEvaScore.CSMutualScoreAve // **定性评价得分（员工互评）
      tableDataItem.CSQTEvaRank = itemMultualEvaScore.CSMutualScoreAveRank // **定性评价排名（员工互评）
      tableDataItem.CSQTEvaScoreNor = itemMultualEvaScore.CSMutualScoreNor // **定性评价标准化得分（员工互评）
      tableDataItem.PMRankChange = 0
    }
  }
  // ***根据未标准化的绩效得分和总工时进行排序
  tableData = sortObjectArrayByParams(JSON.parse(JSON.stringify(tableData)), 'PMScoreUnN', 'totalWorkTime')
  // ***计算员工的绩效标准化得分
  for (let i = 0; i < tableData.length; i++) {
    tableData[i].PMRank = i + 1 // **绩效排名计算
    tableData[i].initPMRank = i + 1 // **初始绩效排名
    tableData[i].PMScoreNor = NorCal(tableData.length + 1, i + 1) // **标准化绩效得分计算
  }
  return tableData
}
// ***生成绩效得分与排名数据V2，实行取消组长定量评价，改成小组工作评价后的版本
export function genPerformanceScoreV2 (tableData, QYEvaScoreData, QTEvaScoreData, evaCoefObj) {
  // ***绩效得分(未标准化)计算
  for (let tableDataItem of tableData) {
    let itemQuantativeScore = QYEvaScoreData.find(quantativeDataItem => { // **找出初始表格成员对应的定量评价数据
      return quantativeDataItem.id === tableDataItem.id
    })
    let itemMultualEvaScore = QTEvaScoreData.find(multualEvaDataItem => { // **找出初始表格成员对应的定性评价数据
      return multualEvaDataItem.id === tableDataItem.id
    })
    // ***计算未标准化的绩效得分
    if (itemQuantativeScore && itemMultualEvaScore) {
      // **根据当前评价成员是否是组长，计算绩效得分（因为组长和组员绩效计算方式不同）
      if (tableDataItem.duty !== 2) {
        tableDataItem.PMScoreUnN =
          itemQuantativeScore.QYEvaScoreNor * evaCoefObj.quantitativeCoef + // **定量评价标准得分乘上相应系数
          itemMultualEvaScore.CSMutualScoreAve * evaCoefObj.CSMutualCoef + // **定性标准化得分（员工互评）乘上相应系数
          itemMultualEvaScore.MGQualiEvaScoreUnN * evaCoefObj.MGEvaCoef + // **定性评价标准化得分（经理评价）乘上相应系数
          tableDataItem.AMEvaScoreUnN * evaCoefObj.PMEvaCoef // **成效评价标准化得分乘上相应系数
      } else {
        tableDataItem.PMScoreUnN =
          tableDataItem.teamWorkScore * evaCoefObj.quantitativeCoef + // **小组评价得分乘上相应系数
          itemMultualEvaScore.CSMutualScoreAve * evaCoefObj.CSMutualCoef + // **定性标准化得分（员工互评）乘上相应系数
          itemMultualEvaScore.MGQualiEvaScoreUnN * evaCoefObj.MGEvaCoef + // **定性评价标准化得分（经理评价）乘上相应系数
          tableDataItem.AMEvaScoreUnN * evaCoefObj.PMEvaCoef // **成效评价标准化得分乘上相应系数
      }
      tableDataItem.PMScoreUnN = Number(tableDataItem.PMScoreUnN.toFixed(2)) // **保留2位小数
      tableDataItem.QYEvaRank = itemQuantativeScore.rank // **定量评价排名
      tableDataItem.QYEvaScoreNor = itemQuantativeScore.QYEvaScoreNor // **定量评价标准化得分
      tableDataItem.MGQTEvaScoreUnN = itemMultualEvaScore.MGQualiEvaScoreUnN // **定性评价得分（经理评价）
      tableDataItem.MGQTEvaRank = itemMultualEvaScore.MGQualiEvaScoreRank // **定性评价排名（经理评价）
      tableDataItem.MGQTEvaScoreNor = itemMultualEvaScore.MGQualiEvaScoreNor // **定性评价标准化得分（经理评价）
      tableDataItem.CSQTEvaScoreUnN = itemMultualEvaScore.CSMutualScoreAve // **定性评价得分（员工互评）
      tableDataItem.CSQTEvaRank = itemMultualEvaScore.CSMutualScoreAveRank // **定性评价排名（员工互评）
      tableDataItem.CSQTEvaScoreNor = itemMultualEvaScore.CSMutualScoreNor // **定性评价标准化得分（员工互评）
      tableDataItem.PMRankChange = 0
    }
  }
  // ***根据未标准化的绩效得分和总工时进行排序
  tableData = sortObjectArrayByParams(JSON.parse(JSON.stringify(tableData)), 'PMScoreUnN', 'totalWorkTime')
  // ***计算员工的绩效标准化得分
  for (let i = 0; i < tableData.length; i++) {
    tableData[i].PMRank = i + 1 // **绩效排名计算
    tableData[i].initPMRank = i + 1 // **初始绩效排名
    tableData[i].PMScoreNor = NorCalV2(tableData.length, i + 1) // **标准化绩效得分计算
  }
  return tableData
}

// ***生成绩效得分与排名数据V3，实行绩效加分，工时上限的版本
export function genPerformanceScoreV3 (tableData, QYEvaScoreData, QTEvaScoreData, evaCoefObj) {
  // ***绩效得分(未标准化)计算
  for (let tableDataItem of tableData) {
    let itemQuantativeScore = QYEvaScoreData.find(quantativeDataItem => { // **找出初始表格成员对应的定量评价数据
      return quantativeDataItem.id === tableDataItem.id
    })
    let itemMultualEvaScore = QTEvaScoreData.find(multualEvaDataItem => { // **找出初始表格成员对应的定性评价数据
      return multualEvaDataItem.id === tableDataItem.id
    })
    // ***计算未标准化的绩效得分
    if (itemQuantativeScore && itemMultualEvaScore) {
      // **根据当前评价成员是否是组长，计算绩效得分（因为组长和组员绩效计算方式不同）
      if (tableDataItem.duty !== 2) {
        tableDataItem.PMScoreUnN =
          itemQuantativeScore.QYEvaScoreNor * 0.3 + // **定量评价标准得分乘上相应系数
          itemMultualEvaScore.CSMutualScoreAve * evaCoefObj.CSMutualCoef + // **定性标准化得分（员工互评）乘上相应系数
          itemMultualEvaScore.MGQualiEvaScoreUnN * evaCoefObj.MGEvaCoef + // **定性评价标准化得分（经理评价）乘上相应系数
          tableDataItem.AMEvaScoreUnN * 0.4 // **成效评价得分乘上相应系数
      } else {
        tableDataItem.PMScoreUnN =
          tableDataItem.teamWorkScore * evaCoefObj.quantitativeCoef + // **小组评价得分乘上相应系数
          itemMultualEvaScore.CSMutualScoreAve * evaCoefObj.CSMutualCoef + // **定性标准化得分（员工互评）乘上相应系数
          itemMultualEvaScore.MGQualiEvaScoreUnN * evaCoefObj.MGEvaCoef + // **定性评价标准化得分（经理评价）乘上相应系数
          tableDataItem.AMEvaScoreUnN * evaCoefObj.PMEvaCoef // **成效评价标准化得分乘上相应系数
      }
      tableDataItem.PMScoreUnN = Number((tableDataItem.PMScoreUnN + tableDataItem.PBScore).toFixed(2)) // **保留2位小数
      tableDataItem.QYEvaRank = itemQuantativeScore.rank // **定量评价排名
      tableDataItem.QYEvaScoreNor = itemQuantativeScore.QYEvaScoreNor // **定量评价标准化得分
      tableDataItem.MGQTEvaScoreUnN = itemMultualEvaScore.MGQualiEvaScoreUnN // **定性评价得分（经理评价）
      tableDataItem.MGQTEvaRank = itemMultualEvaScore.MGQualiEvaScoreRank // **定性评价排名（经理评价）
      tableDataItem.MGQTEvaScoreNor = itemMultualEvaScore.MGQualiEvaScoreNor // **定性评价标准化得分（经理评价）
      tableDataItem.CSQTEvaScoreUnN = itemMultualEvaScore.CSMutualScoreAve // **定性评价得分（员工互评）
      tableDataItem.CSQTEvaRank = itemMultualEvaScore.CSMutualScoreAveRank // **定性评价排名（员工互评）
      tableDataItem.CSQTEvaScoreNor = itemMultualEvaScore.CSMutualScoreNor // **定性评价标准化得分（员工互评）
      tableDataItem.PMRankChange = 0
    }
  }
  // ***根据未标准化的绩效得分和总工时进行排序
  tableData = sortObjectArrayByParams(JSON.parse(JSON.stringify(tableData)), 'PMScoreUnN', 'totalWorkTime')
  // ***计算员工的绩效标准化得分
  for (let i = 0; i < tableData.length; i++) {
    tableData[i].PMRank = i + 1 // **绩效排名计算
    tableData[i].initPMRank = i + 1 // **初始绩效排名
    tableData[i].PMScoreNor = NorCalV2(tableData.length, i + 1) // **标准化绩效得分计算
  }
  return tableData
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
      item.PMScoreNor = calGetScore(usersList.length, item.PMRank)
    }
    return userPMScoreData
}

// 写入绩效数据
export function savePMData (applyDate, PMData) {
  return new Promise(function (resolve, reject) {
    let url = urlSavePMData
    let PMDataTmp = []
    // 只挑有用的数据上传
    for (let PMDataItem of PMData) {
      let obj = {
        userID: PMDataItem.id,
        totalWorkTime: PMDataItem.totalWorkTime,
        QYEvaRank: PMDataItem.QYEvaRank,
        QYEvaScoreNor: PMDataItem.QYEvaScoreNor,
        CSQTEvaScoreUnN: PMDataItem.CSQTEvaScoreUnN,
        CSQTEvaScoreNor: PMDataItem.CSQTEvaScoreNor,
        CSQTEvaRank: PMDataItem.CSQTEvaRank,
        MGQTEvaScoreUnN: PMDataItem.MGQTEvaScoreUnN,
        MGQTEvaRank: PMDataItem.MGQTEvaRank,
        MGQTEvaScoreNor: PMDataItem.MGQTEvaScoreNor,
        AMEvaScoreUnN: PMDataItem.AMEvaScoreUnN,
        AMEvaScoreNor: PMDataItem.AMEvaScoreNor,
        AMEvaRank: PMDataItem.AMEvaRank,
        PMScoreUnN: PMDataItem.PMScoreUnN,
        PMScoreNor: PMDataItem.PMScoreNor,
        PMRank: PMDataItem.PMRank,
        dimension1CSAveStar: PMDataItem.AMD1CSEvaAveStar,
        dimension1GPEvaStar: PMDataItem.AMD1GPEvaStar,
        dimension2CSAveStar: PMDataItem.AMD2CSEvaAveStar,
        dimension2GPEvaStar: PMDataItem.AMD2GPEvaStar,
        userDuty: PMDataItem.duty,
        userJob: PMDataItem.job
      }
      PMDataTmp.push(JSON.parse(JSON.stringify(obj)))
    }
    let params = {
      applyDate: applyDate,
      PMData: PMDataTmp
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
// ***写入绩效数据V2 实行取消组长定量评价，改成小组工作评价后的版本
export function savePMDataV2 (applyDate, PMData) {
  return new Promise(function (resolve, reject) {
    let url = urlSavePMDataV2
    let PMDataTmp = []
    // 只挑有用的数据上传
    for (let PMDataItem of PMData) {
      let obj = {
        userID: PMDataItem.id,
        totalWorkTime: PMDataItem.totalWorkTime,
        QYEvaRank: PMDataItem.QYEvaRank,
        QYEvaScoreNor: PMDataItem.QYEvaScoreNor,
        CSQTEvaScoreUnN: PMDataItem.CSQTEvaScoreUnN,
        CSQTEvaScoreNor: PMDataItem.CSQTEvaScoreNor,
        CSQTEvaRank: PMDataItem.CSQTEvaRank,
        MGQTEvaScoreUnN: PMDataItem.MGQTEvaScoreUnN,
        MGQTEvaRank: PMDataItem.MGQTEvaRank,
        MGQTEvaScoreNor: PMDataItem.MGQTEvaScoreNor,
        AMEvaScoreUnN: PMDataItem.AMEvaScoreUnN,
        AMEvaScoreNor: PMDataItem.AMEvaScoreNor,
        AMEvaRank: PMDataItem.AMEvaRank,
        PMScoreUnN: PMDataItem.PMScoreUnN,
        PMScoreNor: PMDataItem.PMScoreNor,
        PMRank: PMDataItem.PMRank,
        dimension1CSAveStar: PMDataItem.AMD1CSEvaAveStar,
        dimension1GPEvaStar: PMDataItem.AMD1GPEvaStar,
        dimension2CSAveStar: PMDataItem.AMD2CSEvaAveStar,
        dimension2GPEvaStar: PMDataItem.AMD2GPEvaStar,
        userDuty: PMDataItem.duty,
        userJob: PMDataItem.job,
        teamWorkScore: PMDataItem.teamWorkScore
      }
      PMDataTmp.push(JSON.parse(JSON.stringify(obj)))
    }
    let params = {
      applyDate: applyDate,
      PMData: PMDataTmp
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

// ***发布绩效信息v3，实行绩效加分、工时上限规则的版本
export function savePMDataV3 (applyDate, PMData) {
  return new Promise(function (resolve, reject) {
    let url = urlSavePMDataV3
    let PMDataTmp = []
    // 只挑有用的数据上传
    for (let PMDataItem of PMData) {
      let obj = {
        userID: PMDataItem.id,
        totalWorkTime: PMDataItem.totalWorkTime,
        QYEvaRank: PMDataItem.QYEvaRank,
        QYEvaScoreNor: PMDataItem.QYEvaScoreNor,
        CSQTEvaScoreUnN: PMDataItem.CSQTEvaScoreUnN,
        CSQTEvaScoreNor: PMDataItem.CSQTEvaScoreNor,
        CSQTEvaRank: PMDataItem.CSQTEvaRank,
        MGQTEvaScoreUnN: PMDataItem.MGQTEvaScoreUnN,
        MGQTEvaRank: PMDataItem.MGQTEvaRank,
        MGQTEvaScoreNor: PMDataItem.MGQTEvaScoreNor,
        AMEvaScoreUnN: PMDataItem.AMEvaScoreUnN,
        AMEvaScoreNor: PMDataItem.AMEvaScoreNor,
        AMEvaRank: PMDataItem.AMEvaRank,
        PMScoreUnN: PMDataItem.PMScoreUnN,
        PMScoreNor: PMDataItem.PMScoreNor,
        PMRank: PMDataItem.PMRank,
        dimension1CSAveStar: PMDataItem.AMD1CSEvaAveStar,
        dimension1GPEvaStar: PMDataItem.AMD1GPEvaStar,
        dimension2CSAveStar: PMDataItem.AMD2CSEvaAveStar,
        dimension2GPEvaStar: PMDataItem.AMD2GPEvaStar,
        userDuty: PMDataItem.duty,
        userJob: PMDataItem.job,
        teamWorkScore: PMDataItem.teamWorkScore,
        PBScore: PMDataItem.PBScore
      }
      PMDataTmp.push(JSON.parse(JSON.stringify(obj)))
    }
    let params = {
      applyDate: applyDate,
      PMData: PMDataTmp
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

// 更新绩效数据
export function updatePMData (PMData) {
  return new Promise(function (resolve, reject) {
    let url = urlUpdatePMData
    let PMDataTmp = []
    // 只挑有用的数据上传
    for (let PMDataItem of PMData) {
      let obj = {
        totalWorkTime: PMDataItem.totalWorkTime,
        QYEvaRank: PMDataItem.QYEvaRank,
        QYEvaScoreNor: PMDataItem.QYEvaScoreNor,
        CSQTEvaScoreUnN: PMDataItem.CSQTEvaScoreUnN,
        CSQTEvaScoreNor: PMDataItem.CSQTEvaScoreNor,
        CSQTEvaRank: PMDataItem.CSQTEvaRank,
        MGQTEvaScoreUnN: PMDataItem.MGQTEvaScoreUnN,
        MGQTEvaRank: PMDataItem.MGQTEvaRank,
        MGQTEvaScoreNor: PMDataItem.MGQTEvaScoreNor,
        AMEvaScoreUnN: PMDataItem.AMEvaScoreUnN,
        AMEvaScoreNor: PMDataItem.AMEvaScoreNor,
        AMEvaRank: PMDataItem.AMEvaRank,
        PMScoreUnN: PMDataItem.PMScoreUnN,
        PMScoreNor: PMDataItem.PMScoreNor,
        PMRank: PMDataItem.PMRank,
        dimension1CSAveStar: PMDataItem.AMD1CSEvaAveStar,
        dimension1GPEvaStar: PMDataItem.AMD1GPEvaStar,
        dimension2CSAveStar: PMDataItem.AMD2CSEvaAveStar,
        dimension2GPEvaStar: PMDataItem.AMD2GPEvaStar,
        id: PMDataItem.publishPMDataID
      }
      PMDataTmp.push(JSON.parse(JSON.stringify(obj)))
    }
    let params = {
      PMData: PMDataTmp
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
// 更新绩效数据
export function updatePMDataV2 (PMData) {
  return new Promise(function (resolve, reject) {
    let url = urlUpdatePMDataV2
    let PMDataTmp = []
    // 只挑有用的数据上传
    for (let PMDataItem of PMData) {
      let obj = {
        totalWorkTime: PMDataItem.totalWorkTime,
        QYEvaRank: PMDataItem.QYEvaRank,
        QYEvaScoreNor: PMDataItem.QYEvaScoreNor,
        CSQTEvaScoreUnN: PMDataItem.CSQTEvaScoreUnN,
        CSQTEvaScoreNor: PMDataItem.CSQTEvaScoreNor,
        CSQTEvaRank: PMDataItem.CSQTEvaRank,
        MGQTEvaScoreUnN: PMDataItem.MGQTEvaScoreUnN,
        MGQTEvaRank: PMDataItem.MGQTEvaRank,
        MGQTEvaScoreNor: PMDataItem.MGQTEvaScoreNor,
        AMEvaScoreUnN: PMDataItem.AMEvaScoreUnN,
        AMEvaScoreNor: PMDataItem.AMEvaScoreNor,
        AMEvaRank: PMDataItem.AMEvaRank,
        PMScoreUnN: PMDataItem.PMScoreUnN,
        PMScoreNor: PMDataItem.PMScoreNor,
        PMRank: PMDataItem.PMRank,
        dimension1CSAveStar: PMDataItem.AMD1CSEvaAveStar,
        dimension1GPEvaStar: PMDataItem.AMD1GPEvaStar,
        dimension2CSAveStar: PMDataItem.AMD2CSEvaAveStar,
        dimension2GPEvaStar: PMDataItem.AMD2GPEvaStar,
        teamWorkScore: PMDataItem.teamWorkScore,
        id: PMDataItem.publishPMDataID
      }
      PMDataTmp.push(JSON.parse(JSON.stringify(obj)))
    }
    let params = {
      PMData: PMDataTmp
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
// 更新绩效数据
export function updatePMDataV3 (PMData) {
  return new Promise(function (resolve, reject) {
    let url = urlUpdatePMDataV3
    let PMDataTmp = []
    // 只挑有用的数据上传
    for (let PMDataItem of PMData) {
      let obj = {
        totalWorkTime: PMDataItem.totalWorkTime,
        QYEvaRank: PMDataItem.QYEvaRank,
        QYEvaScoreNor: PMDataItem.QYEvaScoreNor,
        CSQTEvaScoreUnN: PMDataItem.CSQTEvaScoreUnN,
        CSQTEvaScoreNor: PMDataItem.CSQTEvaScoreNor,
        CSQTEvaRank: PMDataItem.CSQTEvaRank,
        MGQTEvaScoreUnN: PMDataItem.MGQTEvaScoreUnN,
        MGQTEvaRank: PMDataItem.MGQTEvaRank,
        MGQTEvaScoreNor: PMDataItem.MGQTEvaScoreNor,
        AMEvaScoreUnN: PMDataItem.AMEvaScoreUnN,
        AMEvaScoreNor: PMDataItem.AMEvaScoreNor,
        AMEvaRank: PMDataItem.AMEvaRank,
        PMScoreUnN: PMDataItem.PMScoreUnN,
        PMScoreNor: PMDataItem.PMScoreNor,
        PMRank: PMDataItem.PMRank,
        dimension1CSAveStar: PMDataItem.AMD1CSEvaAveStar,
        dimension1GPEvaStar: PMDataItem.AMD1GPEvaStar,
        dimension2CSAveStar: PMDataItem.AMD2CSEvaAveStar,
        dimension2GPEvaStar: PMDataItem.AMD2GPEvaStar,
        teamWorkScore: PMDataItem.teamWorkScore,
        PBScore: PMDataItem.PBScore,
        id: PMDataItem.publishPMDataID
      }
      PMDataTmp.push(JSON.parse(JSON.stringify(obj)))
    }
    let params = {
      PMData: PMDataTmp
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
// 获取绩效数据
export function getPMData (applyDate) {
  const url = urlGetPMData
  let params = {
    applyDate: applyDate
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

// 发布绩效数据
export function publishPMData (applyYear, applyMonth, publishID, flagValue) {
  const url = performanceInfoPublish
  let params = {
    flagID: publishID,
    applyYear: applyYear,
    applyMonth: applyMonth,
    flagType: 'performanceInfoPublish',
    flagValue: flagValue
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(response => {
      if (response.code === 1) {
        resolve(response)
      } else {
        reject(response.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// ***获取工时分配结果
export function getWorkAssign (projectID, searchType) {
  const url = urlGetWorkAssign
  let params = {
    projectID: projectID,
    searchType: searchType
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// 删除工时申报
export function deleteWorkTimeSubmit (id) {
  const url = urlDeleteWorkTimeSubmit
  let params = {
    id: id
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// 改变工时申报提交状态
export function changeSubmitStatus (id, submitStatus) {
  const url = urlChangeSubmitStatus
  let params = {
    id: id,
    submitStatus: submitStatus
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve()
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// ***获取提交的工时申报数量
export function getSubmitWorkTimeCount (searchUserID, applyMonth) {
  const url = urlGetSubmitWorkTimeCount
  let params = {
    searchUserID: searchUserID,
    applyMonth: applyMonth
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// ***提交免审核工时***
export function mianshenheWorkTimeSubmit (submitID, projectTypeID, applyMonth) {
  const url = urlMianshenheWorkTimeSubmit
  let params = {
    submitID: submitID,
    projectTypeID: projectTypeID,
    applyMonth: applyMonth
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

// ***根据项目类型获取工时列表***
export function getWorkTimeListByType (userID, applyMonth, projectTypeID) {
  const url = urlGetWorkTimeListByType
  let params = {
    userID: userID,
    applyMonth: applyMonth,
    projectTypeID: projectTypeID
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.err)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

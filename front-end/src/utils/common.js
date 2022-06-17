import { http } from '../config/http'
import {
  urlGetCurApplyAbleMonth,
  urlGetAllUsersInfo,
  workTimeSubmit,
  urlUpdateWorkTimeListReviewStatus,
  submitAssignWorkDetail,
  urlGetWorkTimeAssignInfo,
  urlSetProjectFinish,
  urlGetWorkTimeListInfo,
  urlGetPerformanceIsPublish,
  urlGetTypeGlobalFlag,
  urlGetGlobalFlagByType,
  urlUpdateGlobalFlagVal,
  urlGetEvaCoef,
  urlGetIsSubmitAllow
} from '../config/interface'
import store from '@/store'

// 获取当前可申报的月份
export function getCurApplyAbleMonth () {
  const url = urlGetCurApplyAbleMonth
  let params = {}
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

// 获取全处员工信息
export function getAllUsersInfo () {
  const url = urlGetAllUsersInfo
  let params = {}
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

// 通过姓名移除人员
export function removeUserByName (name, usersList) {
  let index = usersList.findIndex((usersListItem) => {
    return usersListItem.name === name
  })
  usersList.splice(index, 1)
  return usersList
}

// 月总结星级对应工时
export function conclusionManagerEvaStarToWorkTime (managerEvaStar) {
  switch (managerEvaStar) {
    case 1:
      return 0
    case 2:
      return 5
    case 3:
      return store.state.defaultConclusionGetWorkTime
    case 4:
      return store.state.defaultConclusionGetWorkTime + 5
    case 5:
      return store.state.defaultConclusionGetWorkTime + 10
  }
}

// 插入工时申报
export function workTimeListInsert (projectID, submitType, submitDate, applyType, userId, data) {
  const url = workTimeSubmit
  let params = {
    projectID: projectID,
    submitType: submitType,
    submitDate: submitDate,
    data: data,
    applyType: applyType,
    userId: userId
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

// 更新工时条目审核状态
export function updateWorkTimeListReviewStatus (id, reviewKValue, reviewCofficient, reviewStatus, reviewer) {
  const url = urlUpdateWorkTimeListReviewStatus
  let params = {
    id: id,
    reviewKValue: reviewKValue,
    reviewCofficient: reviewCofficient,
    reviewStatus: reviewStatus,
    reviewer: reviewer
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

// 新增项目
export function addNewProject (isFilled, parentID, projectLevel, projectName, userId, tableData) {
  const url = submitAssignWorkDetail
  let params = {
    isFilled: isFilled,
    parentID: parentID,
    projectLevel: projectLevel,
    projectName: projectName,
    userId: userId,
    tableData: tableData
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

// 获取工时分配信息
export function getWorkTimeAssignInfo (workTimeListId) {
  const url = urlGetWorkTimeAssignInfo
  let params = {
    workTimeListId: workTimeListId
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

// 将项目置为已完成状态
export function setProjectFinish (aplId) {
  const url = urlSetProjectFinish
  let params = {
    aplId: aplId
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

// 获取工时申报信息
export function getWorkTimeListInfo (workTimeListId) {
  const url = urlGetWorkTimeListInfo
  let params = {
    workTimeListId: workTimeListId
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

// 获取季度对应的月份
export function getQuarterMon (applyYear, applyQuarter) {
  switch (applyQuarter) {
    case 1:
      return [applyYear + '-' + '01', applyYear + '-' + '02', applyYear + '-' + '03']
    case 2:
      return [applyYear + '-' + '04', applyYear + '-' + '05', applyYear + '-' + '06']
    case 3:
      return [applyYear + '-' + '07', applyYear + '-' + '08', applyYear + '-' + '09']
    case 4:
      return [applyYear + '-' + '10', applyYear + '-' + '11', applyYear + '-' + '12']
    default:
      return []
  }
}

// 标准计算
export function NorCal (usersNum, rank) {
  if (rank === 1) {
    return 95
  }
  let ratio = rank / usersNum
  if (ratio < 0.1 || ratio === 0.1) {
    return 95
  } else if (ratio < 0.2 || ratio === 0.2) {
    return 92.5
  } else if (ratio < 0.49 || ratio === 0.49) {
    return 90
  } else if (ratio < 0.8 || ratio === 0.8) {
    return 87.5
  } else {
    return 85
  }
}

// 绩效得分标准化计算(2021年12月启用)
export function PMScoreNorCal (usersNum, rank) {
  if (rank === 1) {
    return 95
  }
  if (rank < Number((usersNum * 0.1).toFixed(0)) || rank === Number((usersNum * 0.1).toFixed(0))) {
    return 95
  } else if (rank < Number((usersNum * 0.2).toFixed(0)) || rank === Number((usersNum * 0.2).toFixed(0))) {
    return 92.5
  } else if (rank < Number((usersNum * 0.49).toFixed(0)) || rank === Number((usersNum * 0.49).toFixed(0))) {
    return 90
  } else if (rank < Number((usersNum * 0.8).toFixed(0)) || rank === Number((usersNum * 0.8).toFixed(0))) {
    return 87.5
  } else if (rank < Number((usersNum * 1).toFixed(0)) || rank === Number((usersNum * 1).toFixed(0))) {
    return 85
  }
}

// 定性、定量指标得分计算（2021年12月前使用的）
export function calGetScore (length, rank) {
  if (rank === 1) {
    return 92.5
  }
  if (rank < Number((length * 0.1).toFixed(0)) || rank === Number((length * 0.1).toFixed(0))) {
    return 92.5
  } else if (rank < Number((length * 0.3).toFixed(0)) || rank === Number((length * 0.3).toFixed(0))) {
    return 90
  } else if (rank < Number((length * 0.7).toFixed(0)) || rank === Number((length * 0.7).toFixed(0))) {
    return 87.5
  } else if (rank < Number((length * 0.9).toFixed(0)) || rank === Number((length * 0.9).toFixed(0))) {
    return 85
  } else if (rank < Number((length * 1).toFixed(0)) || rank === Number((length * 1).toFixed(0))) {
    return 82.5
  }
}
// 获取当前月份绩效结果是否已公布
export function getPerformanceIsPublish (applyYear, applyMonth) {
  const url = urlGetPerformanceIsPublish
  let params = {
    applyYear: applyYear,
    applyMonth: applyMonth,
    flagType: 'performanceInfoPublish'
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(new Error('getPerformanceIsPublish recv error!'))
      }
    }).catch(err => {
      reject(new Error(err + 'getPerformanceIsPublish send error!'))
    })
  })
}

// 根据时间获取某个类型数据的全局标志位
export function getTypeGlobalFlag (applyYear, applyMonth, flagType) {
  const url = urlGetTypeGlobalFlag
  let params = {
    applyYear: applyYear,
    applyMonth: applyMonth,
    flagType: flagType
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(new Error('getTypeGlobalFlag recv error!'))
      }
    }).catch(err => {
      reject(new Error(err + 'getTypeGlobalFlag send error!'))
    })
  })
}

// 根据数据类型获取全局标志位
export function getGlobalFlagByType (flagType) {
  const url = urlGetGlobalFlagByType
  let params = {
    flagType: flagType
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(new Error('getGlobalFlagByType recv error!'))
      }
    }).catch(err => {
      reject(new Error(err + 'getGlobalFlagByType send error!'))
    })
  })
}

// 评分类型由代码转文字
export function rateTypeSwitch (rateType) {
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
    default:
      return 't1Star'
  }
}

// 星级转评分
export function starToRates (star) {
  switch (star) {
    case 5:
      return 92.5
    case 4:
      return 90
    case 3:
      return 87.5
    case 2:
      return 85
    case 1:
      return 82.5
    default:
      return 87.5
  }
}
// 星级转评分(新)
export function starToRatesNew (star) {
  switch (star) {
    case 5:
      return 95
    case 4:
      return 92.5
    case 3:
      return 90
    case 2:
      return 87.5
    case 1:
      return 85
    default:
      return 0
  }
}

// 星级转评分
export function newStarToRates (star) {
  switch (star) {
    case 5:
      return 95
    case 4:
      return 92.5
    case 3:
      return 90
    case 2:
      return 87.5
    case 1:
      return 85
    default:
      return 90
  }
}

// 评分转星级
export function ratesToStar (rates) {
  switch (rates) {
    case 92.5:
      return 5
    case 90:
      return 4
    case 87.5:
      return 3
    case 85:
      return 2
    case 82.5:
      return 1
    default:
      return 4
  }
}

// 更新某种类型的全局标志位
export function updateGlobalFlagVal (flagType, flagValue) {
  const url = urlUpdateGlobalFlagVal
  let params = {
    flagType: flagType,
    flagValue: flagValue
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

// 小写阿拉伯数字转大写
export function smallNumToL (num) {
  switch (num) {
    case 1:
      return '一'
    case 2:
      return '二'
    case 3:
      return '三'
    case 4:
      return '四'
    default:
      return '错误'
  }
}

// 月份转换成英文
export function MonthToString (month) {
  switch (month) {
    case '1':
      return 'January'
    case '2':
      return 'February'
    case '3':
      return 'March'
    case '4':
      return 'April'
    case '5':
      return 'May'
    case '6':
      return 'June'
    case '7':
      return 'July'
    case '8':
      return 'August'
    case '9':
      return 'September'
    case '10':
      return 'October'
    case '11':
      return 'November'
    case '12':
      return 'December'
    default:
      return 'error'
  }
}
// 月份转换成英文
export function mStringToNumber (mString) {
  switch (mString) {
    case 'January':
      return '01'
    case 'February':
      return '02'
    case 'March':
      return '03'
    case 'April':
      return '04'
    case 'May':
      return '05'
    case 'June':
      return '06'
    case 'July':
      return '07'
    case 'August':
      return '08'
    case 'September':
      return '09'
    case 'October':
      return '10'
    case 'November':
      return '11'
    case 'December':
      return '12'
    default:
      return 'error'
  }
}

// 数据排序方法(从大到小)
export function compare (params) {
  return function (o, p) {
    let a, b
    if (typeof o === 'object' && typeof p === 'object' && o && p) {
      a = o[params]
      b = p[params]
      if (a === b) {
        return 0
      }
      if (typeof a === typeof b) {
        return a > b ? -1 : 1
      }
      return typeof a > typeof b ? -1 : 1
    } else {
      let obj = {}
      throw (obj)
    }
  }
}

// 从数据库获取各种评价系数
export function getEvaCoef () {
  const url = urlGetEvaCoef
  let params = {}
  return new Promise(function (resolve, reject) {
    http(url, params).then(result => {
      let resultData = result.data
      let obj = {
        CSMutualCoef: resultData.find(item => { return item.flagType === 'CSMutualCoef' }).flagValue,
        MGEvaCoef: resultData.find(item => { return item.flagType === 'MGEvaCoef' }).flagValue,
        quantitativeCoef: resultData.find(item => { return item.flagType === 'quantitativeCoef' }).flagValue,
        PMEvaCoef: resultData.find(item => { return item.flagType === 'PMEvaCoef' }).flagValue,
        CSManagerAMEvaCoef: resultData.find(item => { return item.flagType === 'CSManagerAMEvaCoef' }).flagValue,
        CSGroupLeaderAMEvaCoef: resultData.find(item => { return item.flagType === 'CSGroupLeaderAMEvaCoef' }).flagValue,
        CScommonStaffAMEvaCoef: resultData.find(item => { return item.flagType === 'CScommonStaffAMEvaCoef' }).flagValue,
        GPManagerAMEvaCoef: resultData.find(item => { return item.flagType === 'GPManagerAMEvaCoef' }).flagValue,
        GPCommonStaffAMEvaCoef: resultData.find(item => { return item.flagType === 'GPCommonStaffAMEvaCoef' }).flagValue,
        AMBuildBoutiqueProjectCoef: resultData.find(item => { return item.flagType === 'AMBuildBoutiqueProjectCoef' }).flagValue,
        AMBuildProTeamCoef: resultData.find(item => { return item.flagType === 'AMBuildProTeamCoef' }).flagValue
      }
      resolve(obj)
    }).catch(err => {
      reject(err)
    })
  })
}
// 排序比较函数(从大到小)
export function sortBy (props) {
  return function (a, b) {
    return b[props] - a[props]
  }
}

// 排序比较函数(从小到大)
export function sortByAscend (props) {
  return function (a, b) {
    return a[props] - b[props]
  }
}

// 对象数组根据给定的参数从大到小排序
export function sortObjectArrayByParams (array, param1, param2) {
  let preValue = -1
  let arrayTmp = []
  let result = []
  let count = -1
  array.sort(sortBy(param1))
  for (let item of array) {
    if (item[param1] === preValue) {
      arrayTmp[count].push(item)
    } else {
      count++
      if (!arrayTmp[count]) {
        arrayTmp[count] = []
      }
      arrayTmp[count].push(item)
      preValue = item[param1]
    }
  }
  for (let i = 0; i < arrayTmp.length; i++) {
    arrayTmp[i].sort(sortBy(param2))
    for (let item of arrayTmp[i]) {
      result.push(item)
    }
  }
  return result
}

// 获取当前月份能否申报
export function getIsSubmitAllow (applyYear, applyMonth) {
  const url = urlGetIsSubmitAllow
  let params = {
    applyYear: applyYear,
    applyMonth: applyMonth,
    flagType: 'workTimeSubmit'
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(new Error('getIsSubmitAllow recv error!'))
      }
    }).catch(err => {
      reject(err)
    })
  })
}

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
  urlGetGlobalFlagByType
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

// 数字月份转英文月份
export function monthNumToMonthString (monthNum) {
  switch (monthNum) {
    case 1:
      return 'January'
    case 2:
      return 'February'
    case 3:
      return 'March'
    case 4:
      return 'April'
    case 5:
      return 'May'
    case 6:
      return 'June'
    case 7:
      return 'July'
    case 8:
      return 'August'
    case 9:
      return 'September'
    case 10:
      return 'October'
    case 11:
      return 'November'
    case 12:
      return 'December'
    default:
      return null
  }
}

// 绩效得分标准化计算(2021年12月启用)
export function performanceStdScoreCal (usersNum, rank) {
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

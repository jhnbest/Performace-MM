import { http } from '../config/http'
import {
  urlGetCurApplyAbleMonth,
  urlGetAllUsersInfo,
  workTimeSubmit,
  urlUpdateWorkTimeListReviewStatus,
  submitAssignWorkDetail,
  urlGetWorkTimeAssignInfo,
  urlSetProjectFinish,
  urlGetWorkTimeListInfo
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

// 总结星级对应工时
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

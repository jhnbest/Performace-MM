import { http } from '../config/http'
import {
  urlGetTypeProjectList,
  urlgetAssignProjectDetailV2,
  urlProjectDetailIsApplyWorkTime,
  urlProjectDetailIsApplyWorkTimeV2,
  urlSubmitProcess,
  urlSubmitProjectWorkTimeApply,
  urlGetMonthProcess,
  urlUpdateAssignProjectInfo,
  urlUpdateAssignProjectStageInfo,
  urlGetAssignProjectTotalWorkTime
} from '@/config/interface'

// ***获取特定类型的项目列表
export function getTypeProjectList (projectType, isFinish, curApplyYear) {
  const url = urlGetTypeProjectList
  let params = {
    projectType: projectType,
    isFinish: isFinish,
    curApplyYear: curApplyYear
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      if (res.code === 1) {
        resolve(res.data)
      } else {
        reject(res.code)
      }
    }).catch(err => {
      reject(err)
    })
  })
}

 // ***获取指派项目计划&进展明细
 export function getAssignProjectDetailV2 (projectID, yearNum) {
   return new Promise(function (resolve, reject) {
    const url = urlgetAssignProjectDetailV2
    let params = {
      id: projectID,
      year: yearNum
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

// ***查看项目阶段当月是否已填报工时
export function projectDetailIsApplyWorkTime (searchData, type, applyMonth) {
  const url = urlProjectDetailIsApplyWorkTime
  let params = {
    projectDetailID: [],
    applyMonth: applyMonth,
    type: type
  }
  for (let searchDataItem of searchData) {
    params.projectDetailID.push(searchDataItem.apdID)
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      resolve(res.data)
    }).catch(err => {
      reject(new Error('projectDetailIsApplyWorkTime send error!' + err))
    })
  })
}
// ***查看项目阶段当月是否已填报工时
export function projectDetailIsApplyWorkTimeV2 (searchData, type, applyMonth) {
  const url = urlProjectDetailIsApplyWorkTimeV2
  let params = {
    projectDetailID: [],
    applyMonth: applyMonth,
    type: type
  }
  for (let searchDataItem of searchData) {
    params.projectDetailID.push(searchDataItem.apdID)
  }
  return new Promise(function (resolve, reject) {
    http(url, params).then(res => {
      resolve(res.data)
    }).catch(err => {
      reject(new Error('projectDetailIsApplyWorkTime send error!' + err))
    })
  })
}

// ***提交项目阶段进展
export function submitProcess (processData) {
  const url = urlSubmitProcess
  let params = processData
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

export function submitProjectWorkTimeApply (workTimeInfo, projectID) {
  let url = urlSubmitProjectWorkTimeApply
  let params = {
    workTimeInfo: workTimeInfo,
    projectID: projectID
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

// ***根据项目阶段获取项目进展
export function getMonthProcess (projectStage, submitYear) {
  let url = urlGetMonthProcess
  let params = {
    projectStage: projectStage,
    submitYear: submitYear
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

// ***更新项目信息
export function updateAssignProjectInfo (projectInfo) {
  let url = urlUpdateAssignProjectInfo
  let params = {
    id: projectInfo.id,
    userID: projectInfo.userID,
    projectType: projectInfo.projectType,
    projectName: projectInfo.projectName,
    process: projectInfo.process,
    assignerID: projectInfo.assignerID,
    totalWorkTime: projectInfo.totalWorkTime,
    isFilled: projectInfo.isFilled,
    projectLevel: projectInfo.projectLevel,
    reviewStatus: projectInfo.reviewStatus,
    obsoleteStatus: projectInfo.obsoleteStatus
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

// ***更新项目阶段信息
export function updateAssignProjectStageInfo (assignProjectDetail) {
  const url = urlUpdateAssignProjectStageInfo
  let params = {
    assignProjectDetail: assignProjectDetail
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

// ***获取项目总工时
export function getAssignProjectTotalWorkTime (aplID) {
  const url = urlGetAssignProjectTotalWorkTime
  let params = {
    aplID: aplID
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

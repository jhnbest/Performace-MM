const moment = require('moment')
const $http = require('../sql/http')

const $common = {
  RCPDDatabase(sql, arrayParams) {
    return new Promise(function (resolve, reject) {
      $http.connPool(sql, arrayParams, (err, result) => {
        if (err) {
          console.log('err')
          console.log(err)
          reject(err)
        } else {
          result = JSON.parse(JSON.stringify(result))
          resolve(result)
        }
      })
    })
  },
  formatData(rows) {
    return rows.map(row => {
      if(row.create_time) {
        row.create_time = $time.formatTime(row.create_time)
      }
      if(row.update_time) {
        row.update_time = $time.formatTime(row.update_time)
      }
      let type = row.type
      if(type){
        switch(type) {
          case 1:
            row.role = '管理员'
            break
          case 2:
            row.role = '普通用户'
            break
        }
      }
      let role = row.role
      if (role) {
        switch (role) {
          case 1:
            row.role = '管理员'
            break
          case 2:
            row.role = '组长'
            break
          case 3:
            row.role = '普通成员'
            break
        }
      }
      let dept = row.dept
      if (dept) {
        switch (dept) {
          case 1:
            row.dept = '通信工程处'
        }
      }
      row.groupID = row.groupName
      if (row.groupName) {
        switch (row.groupName) {
          case 1:
            row.groupName = '管理组'
            break
          case 2:
            row.groupName = '多媒体应用组'
            break
          case 3:
            row.groupName = '数字物联组'
            break
          case 4:
            row.groupName = '综合业务组'
            break
          case 5:
            row.groupName = '通信组'
            break
        }
      }
      return Object.assign({}, row)
    })
  }
}

module.exports = $common
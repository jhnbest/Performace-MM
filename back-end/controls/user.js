const $sql = require('../sql/sqlMap')
const moment = require('moment')
const $http = require('../sql/http')
const $time = require('../utils/time')
const jwt = require('jwt-simple')
const express = require('express')
const app = express()
const $common = require('../utils/common')
app.set('jwtTokenSecret', 'YOUR_SECRET_STRING')

function formatData(rows) {
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
    let groupName = row.groupName
    if (groupName) {
      switch (groupName) {
        case 1:
          row.groupName = '技术标准组'
          break
        case 2:
          row.groupName = '工程组'
          break
        case 3:
          row.groupName = '通信组'
          break
        case 4:
          row.groupName = '处经理'
          break
      }
    }
    return Object.assign({}, row)
  })
}

const user = {
  /* 用户登录 start */
  login (req, res) {
    let params = req.body
    let name = params.name
    let password = params.password
    let sql = $sql.user.login
    let arrayParams = [name, password]
    $common.RCPDDatabase(sql, arrayParams).then(result => {
      if (!result.length) {
        return $http.writeJson(res, {code: 2, message:'用户或密码不正确'})
      } else {
        let resultData = {}
        resultData.code = 1
        let data = formatData(result)
        //data.create_time = $time.formatTime(data.create_time)
        //if(data.type > 1) data.role = '普通用户'
        //data.role = '管理员'
        delete data[0].password
        /**设置token 1天后过期**/
        let expires = moment().add(1, 'days').valueOf()
        let token = jwt.encode({
          iss: data[0].id,
          exp: expires,
        }, app.get('jwtTokenSecret'))
        data[0].token = token
        resultData.data = data[0]
        resultData.msg = '登录成功'
        return $http.writeJson(res, resultData)
      }
    }).catch(err => {
      return $http.writeJson(res, {code:-2, message:'失败',errMsg: err})
    })
  },
  /* 用户登录 end */

  /* 用户登出 start */
  logout (req, res) {
    let params = req.body
    $http.userVerify(req, res, () => {
      let expires = moment().add(100, 'milliseconds').valueOf()
      let token = jwt.encode({
        iss: params.userId,
        exp: expires,
      }, app.get('jwtTokenSecret'))
      resultData = {
        code: 1,
        message: '退出登录成功'
      }
      return $http.writeJson(res, resultData)
    })
  },
  /* 用户登出 end */

  /*添加用户 start*/
  add (req, res) {
    let params = req.body
    $http.userVerify(req, res, () => {
      let curTime = $time.formatTime()
      let name = params.name
      let password = params.password
      let email = params.email
      let create_time = curTime
      let update_time = curTime
      if(!name || !password) $http.writeJson(res, {code: 2, message:'参数有误'})
      else {
        let sql = $sql.user.add
        let arrayParams = [name, password, email, create_time, update_time]
        $http.connPool(sql, arrayParams, (err, result) => {
          if(err) return $http.writeJson(res, {code:-2, message:'失败',errMsg: err})
          if(result.affectedRows != 1) return $http.writeJson(res, {code: 2, message:'添加失败'})
          return $http.writeJson(res, {code: 1, message: '添加用户成功'})
        })
      }
    })
  },
  /*添加用户 end*/

  /*更新用户信息 start*/
  updateInfo (req, res) {
    let params = req.body
    $http.userVerify(req, res, () => {
      let curTime = $time.formatTime()
      let id = params.id
      let name = params.name
      let password = params.password
      let email = params.email
      let update_time = curTime
      if(!id || !name || !password) {$http.writeJson(res, {code: 2, message:'参数有误'})}
      else {
        let sql = $sql.user.updateInfo
        let arrayParams = [name, password, email, update_time, id]
        $http.connPool(sql, arrayParams, (err, result) => {
          if(err) return $http.writeJson(res, {code:-2, message:'失败',errMsg: err})
          if(result.affectedRows != 1) return $http.writeJson(res, {code: 2, message:'更新失败'})
          return $http.writeJson(res, {code: 1, data: result, message: '更新用户成功'})
        })
      }
    })
  },
  /*更新用户信息 end*/

  /*更新用户状态 start*/
  updateState (req, res) {
    let params = req.body
    $http.userVerify(req, res, () => {
      let curTime = $time.formatTime()
      let id = params.id
      let state = !params.state ? '0' : params.state
      let update_time = curTime
      if(!id) {
        $http.writeJson(res, {code: 2, message:'参数有误'})
      } else {
        let sql = $sql.user.updateState
        let arrayParams = [state, update_time, id]
        $http.connPool(sql, arrayParams, (err, result) => {
          if(err) return $http.writeJson(res, {code:-2, message:'失败',errMsg: err})
          if(result.affectedRows != 1) return $http.writeJson(res, {code: 2, message:'更新用户状态失败'})
          return $http.writeJson(res, {code: 1, message: '更新用户状态成功'})
        })
      }
    })
  },
  /*更新用户状态 end*/

  /*获取用户列表 start*/
  list (req, res) {
    let params = req.body
    $http.userVerify(req, res, () => {
      let sqlSelectTotal = $sql.user.selectTotal
      let sqlSelectList= $sql.user.selectList
      let userId = params.userId
      let userType = params.userType
      let searchId = params.searchId
      let searchName = params.searchName
      let searchEmail = params.searchEmail
      let pageNum = params.pageNum
      let pageSize = !params.pageSize ? 10 : params.pageSize

      if(!pageNum) {
        $http.writeJson(res, {code: 2, message:'参数有误'})
      } else {
        // 分页查询入参 start
        let limitFirst = (pageNum-1)*pageSize;
        let limitLast = pageSize;
        // 分页查询入参 end
        if(userType!=1){
          sqlSelectTotal += " and id = "+userId
          sqlSelectList += " and id = "+userId
        }else{
          if(searchId) {
            sqlSelectTotal += " and id = "+searchId
            sqlSelectList += " and id = "+searchId
          }
        }

        if(searchName){
          sqlSelectTotal += " and name like '%"+searchName+"%'"
          sqlSelectList += " and name like '%"+searchName+"%'"
        }

        if(searchEmail){
          sqlSelectTotal += " and email like '%"+searchEmail+"%'"
          sqlSelectList += " and email like '%"+searchEmail+"%'"
        }
        let sql= sqlSelectTotal + '; ' + sqlSelectList
        sql += " order by id desc limit ?,?"; // id倒序排
        let arrayParams = [limitFirst, limitLast]

        $http.connPool(sql, arrayParams, (err, result) => {
          if(err) {
            return $http.writeJson(res, {code:-2, message:'失败'})
          }else{
            let resultData = {}
            resultData.totalCount = result[0][0]['totalCount']
            resultData.list = formatData(result[1])
            return $http.writeJson(res, {code: 1, data: resultData, message: '获取用户列表成功'})
          }
        })
      }
    })
  },
  /*获取用户列表 end*/
  listTest (req, res) {
    let params = req.body
    $http.userVerify(req, res, () => {
      let sqlSelectTotal = $sql.user.selectTotal1
      let sqlSelectList= $sql.user.selectList1
      let userId = params.userId
      let userType = params.userType
      let searchName = params.searchName
      let searchRole = params.searchRole
      let pageNum = params.pageNum
      let pageSize = !params.pageSize ? 10 : params.pageSize

      if(!pageNum) {
        $http.writeJson(res, {code: 2, message:'参数有误'})
      } else {
        // 分页查询入参 start
        let limitFirst = (pageNum - 1) * pageSize;
        let limitLast = pageSize;
        // 分页查询入参 end

        if (searchName) {
          sqlSelectTotal += " and name like '%"+searchName+"%'"
          sqlSelectList += " and name like '%"+searchName+"%'"
        }
        /*if (searchRole) {
          sqlSelectTotal += " and name like '%"+searchName+"%'"
          sqlSelectList += " and name like '%"+searchName+"%'"
        }*/

        let sql= sqlSelectTotal + '; ' + sqlSelectList
        let arrayParams = [limitFirst, limitLast]

        $http.connPool(sql, arrayParams, (err, result) => {
          if(err) {
            return $http.writeJson(res, {code:-2, message:'失败'})
          }else{
            let resultData = {}
            resultData.totalCount = result[0][0]['totalCount']
            resultData.list = formatData(result[1])
            return $http.writeJson(res, {code: 1, data: resultData, message: '获取用户列表成功'})
          }
        })
      }
    })
  },
  /* 获取用户信息 */
  getUsersList (req, res) {
    let sendData = req.body
    let sql = sendData.checkGroupID === 0 ? $sql.user.selectUsersList1 : $sql.user.selectUsersList2
    let arrayParams = sendData.checkGroupID === 0 ? [] : [sendData.checkGroupID]
    $http.userVerify(req, res, () => {
      $http.connPool(sql, arrayParams, (err, result) => {
        if(err) {
          return $http.writeJson(res, {code:-2, message:'失败'})
        } else {
          let resultData = {}
          resultData.list = formatData(result)
          return $http.writeJson(res, {code: 1, data: resultData, message: '获取用户信息成功'})
        }
      })
    })
  },
  /* 获取组员名称 */
  getGroupUserName (req, res) {
    $http.userVerify(req, res, () => {
      let data = req.body
      let sql = $sql.user.getGroupUserName
      if (data.role === '管理员') {
        sql = $sql.user.getAllUserName
      }
      let arrayParams = [data.groupName]
      $http.connPool(sql, arrayParams, (err, result) => {
        if (err) {
          return $http.writeJson(res, {code: -2, message: '失败'})
        } else {
          result = formatData(result)
          return $http.writeJson(res, {code: 1, data: result, message: '获取组员信息成功'})
        }
      })
    })
  },
  /* 旧密码认证 */
  oldPasswordAuth (req, res) {
    let data = req.body
    let sql = $sql.user.oldPasswordAuth
    let arrayParams = [data.account]
    $http.connPool(sql, arrayParams, (err, result) => {
      if (err) {
        return $http.writeJson(res, {code: -2, message: '失败'})
      } else {
        result = formatData(result)
        if (result[0].password === data.oldPassword) {
          return $http.writeJson(res, {code: 1, message: '旧密码正确'})
        } else {
          return $http.writeJson(res, {code: -1, message: '旧密码错误'})
        }
      }
    })
  },
  /* 更新密码 */
  updateNewPassword (req, res) {
    let data = req.body
    let sql = $sql.user.updateNewPassword
    let arrayParams = [data.newPassword, data.account]
    $http.connPool(sql, arrayParams, (err, result) => {
      if (err) {
        return $http.writeJson(res, {code: -2, message: '修改失败'})
      } else {
        return $http.writeJson(res, {code: 1, message: '修改成功'})
      }
    })
  },
  /* 通过ID获取用户姓名 */
  getUserNameByID(id) {
    return new Promise(function (resolve, reject) {
      let sql = $sql.user.getUserNameByID
      let arrayParams = [id]
      $http.connPool(sql, arrayParams, (err, result) => {
        if (err) {
          return -1
        } else {
          result = JSON.parse(JSON.stringify(result))
          resolve(result[0].name)
        }
      })
    })
  }
}

module.exports = user

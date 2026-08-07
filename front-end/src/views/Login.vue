<template>
  <div class="login-container">
    <div class="login-center-wrapper">
      <el-form class="login-main" :model="formData" :rules="formRules" ref="formData" label-position="left" label-width="0px">
        <h2 class="title">通信工程处绩效管理系统</h2>
        <el-form-item prop="name">
          <el-input type="text" v-model="formData.name" placeholder="工号" clearable></el-input>
        </el-form-item>
        <el-form-item prop="password">
          <el-input type="password"
                    v-model="formData.password"
                    placeholder="密码"
                    clearable></el-input>
        </el-form-item>
        <el-form-item class="btn-box">
          <el-button type="primary" @click="submitLogin('formData')">登录</el-button>
          <el-button @click="resetForm('formData')">重置</el-button>
          <span style="margin-left: 40px;margin-right: 10px" class="link-type" @click="handleChangePassword">修改密码</span>
        </el-form-item>
      </el-form>
    </div>
    <PasswordEdit v-if="showFlag.passwordEdit" ref="passwordEdit" @passwordChangeSuccess="handlePasswordChangeSuccess"/>
  </div>
</template>

<style scoped lang="scss">
.login-container{
  position: relative;
  width: 100vw;
  height: 100vh;
  background-image:url('../assets/images/login_bg.png');
  background-size: cover;
  overflow: hidden;

  .login-center-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
  }

  .login-main{
    -webkit-border-radius: 5px;
    -moz-border-radius: 5px;
    border-radius: 5px;
    background-clip: padding-box;
    width: 350px;
    padding: 35px 35px 15px;
    background: #fff;
    border: 1px solid #eaeaea;
    box-shadow: 0 0 25px #cac6c6;

    h3{text-align: center;}
    h2{text-align: center;}
    .btn-box{text-align: right;}
  }
}
</style>

<script>
import { urlUserLogin } from '@/config/interface'
import { isUndefined } from '@/utils/common'
import PasswordEdit from '@/components/PasswordEdit/PasswordEdit'
import Cookies from 'js-cookie'
export default {
  data () {
    const validate = (rule, value, callback) => {
      const reg = /^[0-9a-zA-Z~!·@#$%^&*()_+-= <>,.:;'"]*$/
      if (!value) {
        callback(new Error('请输入内容'))
      } else if (!reg.test(value)) {
        callback(new Error('内容需为字母或数字'))
      } else {
        callback()
      }
    }
    return {
      formData: {
        name: null,
        password: null
      },
      formRules: {
        name: [
          { validator: validate, trigger: 'blur' }
        ],
        password: [
          { validator: validate, trigger: 'blur' }
        ]
      },
      reqFlag: {
        login: true
      },
      showFlag: {
        passwordEdit: true
      },
      rememberUser: true
    }
  },
  methods: {
    submitLogin (formName) {
      if (!isUndefined(Cookies.get('userName'))) {
        Cookies.remove('userName')
      }
      if (!isUndefined(Cookies.get('userPwd'))) {
        Cookies.remove('userPwd')
      }
      this.$refs[formName].validate((valid) => {
        if (valid) {
          const url = urlUserLogin
          if (this.reqFlag.login) {
            this.reqFlag.login = false
            let params = {
              name: this.formData.name,
              password: this.$md5(this.formData.password)
            }
            this.$http(url, params).then(res => {
              if (res.code === 1) {
                let pwdRegex = new RegExp('(?=.*[0-9])(?=.*[a-z])(?=.*[^a-zA-Z0-9]).{8,30}')
                let pwdRegex2 = new RegExp('(?=.*[0-9])(?=.*[A-Z])(?=.*[^a-zA-Z0-9]).{8,30}')
                let pwdRegex3 = new RegExp('(?=.*[A-Z])(?=.*[a-z])(?=.*[^a-zA-Z0-9]).{8,30}')
                let pwdRegex4 = new RegExp('(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z]).{8,30}')
                if (pwdRegex.test(this.formData.password) || pwdRegex2.test(this.formData.password) ||
                   pwdRegex3.test(this.formData.password) || pwdRegex4.test(this.formData.password)) {
                  let data = res.data
                  localStorage.setItem('userInfo', JSON.stringify(data))
                  this.$store.dispatch('saveUserInfo', data)
                  this.$common.toast('登录成功', 'success', false)
                  this.$router.push({
                    path: '/home/dashboard',
                    query: {}
                  })
                } else {
                  alert('密码需含8位以上字符，至少3种类型组合（小写字母、大写字母、数字、符号组成），请修改密码后登录！')
                  this.showFlag.passwordEdit = true
                  this.$nextTick(() => {
                    this.$refs.passwordEdit.init(this.formData.name)
                  })
                }
              } else if (res.code === 3) {
                alert('您的密码在弱密码库中，请修改密码后登录！')
                this.showFlag.passwordEdit = true
                this.$nextTick(() => {
                  this.$refs.passwordEdit.init(this.formData.name, true, this.formData.password)
                })
              }
              this.reqFlag.login = true
            }).catch(err => {
              console.log(err)
              this.$common.toast('登录失败', 'error', false)
            })
          }
        } else {
          console.log('error submit!!')
        }
      })
    },
    resetForm (formName) {
      this.$refs[formName].resetFields()
    },
    handleChangePassword () {
      this.showFlag.passwordEdit = true
      this.$nextTick(() => {
        this.$refs.passwordEdit.init()
      })
    },
    // 设置cookie
    setCookie (cName, cPwd, exdays) {
      let exdate = new Date() // 获取时间
      exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
      // 字符串拼接cookie
      window.document.cookie = 'userName' + '=' + cName + ';path=/;expires=' + exdate.toGMTString()
      window.document.cookie = 'userPwd' + '=' + cPwd + ';path=/;expires=' + exdate.toGMTString()
    },
    // 读取cookie
    getCookie: function () {
      if (document.cookie.length > 0) {
        let arr = document.cookie.split('; ') // 这里显示的格式需要切割一下自己可输出看下
        for (let i = 0; i < arr.length; i++) {
          let arr2 = arr[i].split('=') // 再次切割
          // 判断查找相对应的值
          if (arr2[0] === 'userName') {
            this.formData.name = arr2[1] // 保存到保存数据的地方
          } else if (arr2[0] == 'userPwd') {
            this.formData.password = arr2[1]
          }
        }
      }
    },
    // 清除cookie
    clearCookie: function () {
      this.setCookie('', '', -1) // 修改2值都为空，天数为负1天就好了
    },
    // 密码修改成功后自动登录
    handlePasswordChangeSuccess (data) {
      const url = urlUserLogin
      let params = {
        name: data.account,
        password: this.$md5(data.password)
      }
      this.$http(url, params).then(res => {
        if (res.code === 1) {
          let data = res.data
          localStorage.setItem('userInfo', JSON.stringify(data))
          this.$store.dispatch('saveUserInfo', data)
          this.$common.toast('登录成功', 'success', false)
          this.$router.push({
            path: '/home/dashboard',
            query: {}
          })
        } else if (res.code === 3) {
          alert('新密码仍在弱密码库中，请使用更复杂的密码！')
          this.showFlag.passwordEdit = true
          this.$nextTick(() => {
            this.$refs.passwordEdit.init(data.account, true)
          })
        } else {
          this.$common.toast('登录失败', 'error', false)
        }
      }).catch(err => {
        console.log(err)
        this.$common.toast('登录失败', 'error', false)
      })
    }
  },
  created () {
    let _self = this
    document.onkeydown = function (e) {
      let key = window.event.keyCode
      if (key === 13 || key === 100) {
        _self.submitLogin('formData')
      }
    }
  },
  mounted () {
    this.getCookie()
  },
  components: {
    PasswordEdit
  }
}
</script>

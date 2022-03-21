<template>
  <div class="login-container">
    <el-form class="login-main sub-center-center" :model="formData" :rules="formRules" ref="formData" label-position="left" label-width="0px">
      <h2 class="title">通信工程处绩效管理系统</h2>
      <el-form-item prop="name">
        <el-input type="text" v-model="formData.name" placeholder="账号" clearable></el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input type="password"
                  v-model="formData.password"
                  placeholder="密码"
                  clearable></el-input>
      </el-form-item>
      <el-form-item class="btn-box">
        <el-checkbox v-model="rememberUser"></el-checkbox>
        <span style="margin-right: 20px;margin-left: 3px">记住密码</span>
        <el-button type="primary" @click="submitLogin('formData')">登录</el-button>
        <el-button @click="resetForm('formData')">重置</el-button>
        <span style="margin-left: 40px;margin-right: 10px" class="link-type" @click="handleChangePassword">修改密码</span>
      </el-form-item>
    </el-form>
    <PasswordEdit v-if="showFlag.passwordEdit" ref="passwordEdit"/>
  </div>
</template>

<script>
import { userLogin } from '@/config/interface'
import PasswordEdit from '@/components/PasswordEdit/PasswordEdit'
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
      this.$refs[formName].validate((valid) => {
        if (valid) {
          const url = userLogin
          if (this.reqFlag.login) {
            this.reqFlag.login = false
            let params = {
              name: this.formData.name,
              password: this.$md5(this.formData.password)
            }
            this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                if (this.rememberUser) {
                  // 传入账号名，密码，和保存天数3个参数
                  this.setCookie(this.formData.name, this.formData.password, 2)
                } else {
                  // 清空Cookie
                  this.clearCookie()
                }
                let data = res.data
                localStorage.setItem('userInfo', JSON.stringify(data))
                this.$store.dispatch('saveUserInfo', data)
                this.$common.toast('登陆成功', 'success', false)
                this.$router.push({
                  path: '/home/dashboard',
                  query: {}
                })
              }
              this.reqFlag.login = true
            })
          }
        } else {
          console.log('error submit!!')
          return false
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

<style scoped lang="scss">
.login-container{position: relative; width: 100vw; height: 100vh;background-image:url('../assets/images/login_bg.png'); background-size: cover; overflow: hidden;
  .login-main{ -webkit-border-radius: 5px; -moz-border-radius: 5px; border-radius: 5px; background-clip: padding-box; width: 350px; padding: 35px 35px 15px; background: #fff; border: 1px solid #eaeaea; box-shadow: 0 0 25px #cac6c6;
    h3{text-align: center;}
    h2{text-align: center;}
    .btn-box{text-align: right;}
  }
}
</style>

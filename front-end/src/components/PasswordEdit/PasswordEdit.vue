<template>
  <el-dialog title="修改密码" :visible.sync="showFlag" custom-class="dialog-small" @close="closeDialog('formData')" width="35%">
    <div>
      <el-form :model="formData" :rules="formRules" ref="formData" label-position="left" label-width="0px">
        <el-form-item prop="account">
          <el-input v-model="formData.account" placeholder="工号" clearable></el-input>
        </el-form-item>
        <el-form-item prop="oldPassword">
          <el-input type="password" v-model="formData.oldPassword" placeholder="旧密码" clearable></el-input>
        </el-form-item>
        <el-form-item prop="newPassword">
          <el-input type="password" v-model="formData.newPassword" placeholder="新密码" clearable></el-input>
        </el-form-item>
        <el-form-item prop="confirmPassword">
          <el-input type="password"
                    v-model="formData.confirmPassword"
                    placeholder="再次输入新密码"
                    clearable></el-input>
        </el-form-item>
        <el-form-item class="btn-box">
          <el-button type="primary" @click="submitLogin('formData')">确定</el-button>
          <el-button @click="resetForm('formData')">重置</el-button>
        </el-form-item>
      </el-form>
    </div>
  </el-dialog>
</template>

<script>
  import { getWorkAssign, updateNewPassword, oldPasswordAuth } from '../../config/interface'
    export default {
      data () {
        // const reg = /^[0-9a-zA-Z~!·@#$%^&*()_+-= <>,.:;'"]*$/
        const reg = /(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])(?=.*[^a-zA-Z0-9]).{8,30}/
        let validateNewPassword = (rule, value, callback) => {
          if (!value) {
            callback(new Error('请输入内容'))
          } else if (value === this.formData.oldPassword) {
            callback(new Error('新密码不能与原密码相同!'))
          } else if (!reg.test(value)) {
            callback(new Error('密码长度至少8位以上，且应由大小写字母及特殊字符组合'))
          } else {
            callback()
          }
        }
        let validateConfirmPassword = (rule, value, callback) => {
          if (!value) {
            callback(new Error('请输入内容'))
          } else if (value !== this.formData.newPassword) {
            callback(new Error('与新密码不一致!'))
          } else if (!reg.test(value)) {
            callback(new Error('内容需为字母或数字或常规特殊字符'))
          } else {
            callback()
          }
        }
        return {
          showFlag: false,
          formData: {
            account: null,
            oldPassword: null,
            newPassword: null,
            confirmPassword: null
          },
          formRules: {
            account: [
              { required: true, message: '请输入账号', trigger: 'blur' }
            ],
            oldPassword: [
              { required: true, message: '请输入旧密码', trigger: 'blur' }
            ],
            newPassword: [
              { validator: validateNewPassword, trigger: 'blur' }
            ],
            confirmPassword: [
              { validator: validateConfirmPassword, trigger: 'blur' }
            ]
          },
          reqFlag: {
            edit: true,
            getWorkTimeAssign: true,
            updateNewPassword: true,
            oldPasswordAuth: true
          }
        }
      },
      components: {
      },
      created () {
      },
      methods: {
        // 初始化
        init (account) {
          this.formData.account = account
          this.$nextTick(() => {
            this.changeShowFlag()
          })
        },
        changeShowFlag () {
          this.showFlag = !this.showFlag
        },
        // 取消
        onCancel (formName) {
          this.changeShowFlag()
          this.$refs[formName].resetFields()
        },
        // 关闭弹出框
        closeDialog (formName) {
          this.$refs[formName].resetFields()
        },
        oldPasswordAuth () {
          let it = this
          return new Promise(function (resolve, reject) {
            const url = oldPasswordAuth
            if (it.reqFlag.oldPasswordAuth) {
              it.reqFlag.oldPasswordAuth = false
              let params = {
                account: it.formData.account,
                oldPassword: it.$md5(it.formData.oldPassword)
              }
              it.$http(url, params)
                .then(res => {
                  if (res.code == 1) {
                    resolve(true)
                  } else if (res.code === -1) {
                    resolve(false)
                  }
                  it.reqFlag.oldPasswordAuth = true
                })
            }
          })
        },
        updateNewPassword () {
          let it = this
          return new Promise(function (resolve, reject) {
            const url = updateNewPassword
            if (it.reqFlag.updateNewPassword) {
              it.reqFlag.updateNewPassword = false
              let params = {
                account: it.formData.account,
                newPassword: it.$md5(it.formData.newPassword)
              }
              it.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    resolve(true)
                  } else if (res.code === -1) {
                    resolve(false)
                  }
                  it.reqFlag.updateNewPassword = true
                })
            }
          })
        },
        submitLogin (formName) {
          this.$refs[formName].validate((valid) => {
            if (valid) {
              this.oldPasswordAuth().then(res => {
                if (res) {
                  this.updateNewPassword().then(res => {
                    if (res) {
                      this.$common.toast('修改成功', 'success', 'false')
                      this.onCancel(formName)
                    }
                  })
                }
              })
            } else {
              console.log('error submit!!')
              return false
            }
          })
        },
        resetForm (formName) {
          this.$refs[formName].resetFields()
        }
      },
      filters: {
        groupNameFilter (groupName) {
          switch (groupName) {
            case '技术标准组':
              return 'success'
            case '工程组':
              return 'warning'
            case '通信组':
              return 'primary'
            default:
              return 'danger'
          }
        },
        reviewStatusFilter (status) {
          switch (status) {
            case 0:
              return 'info'
            case 1:
              return 'success'
            case 2:
              return 'danger'
            default:
              return 'danger'
          }
        },
        reviewStatusTextFilter (status) {
          switch (status.reviewStatus) {
            case 0:
              return '未审核'
            case 1:
              return status.reviewWorkTime
            case 2:
              return status.reviewWorkTime
            default:
              return '错误'
          }
        }
      },
      name: 'PasswordEdit'
    }
</script>

<style scoped>
  .btn-box{text-align: center;}
</style>

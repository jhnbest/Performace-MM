<template>
  <el-dialog title="工时详情" :visible.sync="showFlag" custom-class="dialog-small" @close="closeDialog" width="50%">
    <div>
      <el-form ref="formData" :model="formData" :rules="formRules">
        <el-table
          height="300"
          v-loading="!this.reqFlag.getWorkTimeAssign"
          :data="formData.copInfoTable"
          style="width: 100%;margin: auto">
          <el-table-column label="序号" align="center" type="index"></el-table-column>
          <el-table-column label="姓名" prop="name" align="center"></el-table-column>
          <el-table-column label="小组" prop="groupName" align="center">
            <template slot-scope="scope">
              <el-tag :type="scope.row.groupName | groupNameFilter">
                {{scope.row.groupName}}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="角色" prop="assignRole" align="center"></el-table-column>
          <el-table-column label="申报工时" prop="workTime" align="center"></el-table-column>
          <el-table-column label="审核工时" align="center">
            <template slot-scope="scope">
              <el-form-item :prop="'copInfoTable.' + scope.$index + '.reviewWorkTime'"
                            :rules="formRules.reviewWorkTime"
                            style="margin: auto">
                <el-input :disabled="!(formData.reviewStatus === '0')"
                          size="medium"
                          v-model="scope.row.reviewWorkTime"
                          @change="test(scope.$index)"></el-input>
              </el-form-item>
            </template>
          </el-table-column>
        </el-table>
      </el-form>
    </div>
    <div class="dialog-footer" style="text-align: center;margin-top: 20px">
      <el-button v-if="!(formData.reviewType === 'reviewed')" type="success" size="mini" @click="onSave('formData')">保存</el-button>
      <el-button type="danger" size="mini" @click="onCancel('formData')">关闭</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { getWorkAssign, updateWorkTimeAssignReview } from '../../config/interface'
export default {
  data () {
    return {
      showFlag: false,
      formData: {
        copInfoTable: [],
        name: null,
        password: null,
        email: null,
        selectIndex: null,
        reviewStatus: null,
        reviewType: null,
        projectID: null
      },
      reqFlag: {
        edit: true,
        getWorkTimeAssign: true
      },
      formRules: {
        reviewWorkTime: [
          { required: true, message: '请填写审核工时', trigger: 'blur' }
        ]
      }
    }
  },
  components: {
  },
  created () {
  },
  methods: {
    test (index) {
    },
    // 初始化
    init (row, index, reviewType) {
      this.$nextTick(() => {
        console.log(row)
        this.changeShowFlag()
        this.getWorkTimeAssign(row.id)
        this.formData.selectIndex = index
        this.formData.reviewStatus = row.reviewStatus
        this.formData.reviewType = reviewType
        this.formData.projectID = row.id
      })
    },
    getWorkTimeAssign (id) {
      const url = getWorkAssign
      let params = {
        projectID: id
      }
      if (this.reqFlag.getWorkTimeAssign) {
        this.reqFlag.getWorkTimeAssign = false
        this.$http(url, params)
          .then(res => {
            if (res.code === 1) {
              let data = res.data
              console.log('===CopReview.vue getWorkTimeAssign')
              console.log(data)
              for (let item of data) {
                if (item.reviewWorkTime === null) {
                  item.reviewWorkTime = item.workTime
                }
              }
              this.formData.copInfoTable = data
            }
            this.reqFlag.getWorkTimeAssign = true
          })
      }
    },
    changeShowFlag () {
      this.showFlag = !this.showFlag
    },
    /* 保存 */
    onSave (formData) {
      this.$refs[formData].validate((valid) => {
        if (valid) {
          const url = updateWorkTimeAssignReview
          let params = {
            reviewResult: this.formData.copInfoTable,
            projectID: this.formData.projectID
          }
          this.$http(url, params)
          .then(res => {
            if (res.code === 1) {
              this.$common.toast('保存成功', 'success', false)
              this.onCancel(formData)
              this.$emit('workTimeAssignReview', this.formData.selectIndex)
            } else {
              this.$common.toast('保存失败', 'error', false)
            }
          })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    // 取消
    onCancel (formName) {
      this.changeShowFlag()
      this.$refs[formName].resetFields()
    },
    // 关闭弹出框
    closeDialog () {
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
    }
  }
}
</script>

<style lang="scss">

</style>

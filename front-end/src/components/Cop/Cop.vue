<template>
  <el-dialog title="工时详情" :visible.sync="showFlag" custom-class="dialog-small" @close="closeDialog" width="60%">
    <div>
      <el-table
        height="400"
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
            <span>
              {{ { reviewStatus: scope.row.reviewStatus, reviewWorkTime: scope.row.reviewWorkTime } | reviewStatusTextFilter}}
            </span>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div class="dialog-footer" style="text-align: center;margin-top: 20px">
      <el-button type="danger" size="mini" @click="changeShowFlag">关闭</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { getWorkAssign } from '../../config/interface'
export default {
  data () {
    return {
      showFlag: false,
      formData: {
        copInfoTable: [],
        name: null,
        password: null,
        email: null
      },
      reqFlag: {
        edit: true,
        getWorkTimeAssign: true
      }
    }
  },
  components: {
  },
  created () {
  },
  methods: {
    // 初始化
    init (row) {
      this.$nextTick(() => {
        console.log(row)
        this.changeShowFlag()
        this.getWorkTimeAssign(row.id)
      })
    },
    getWorkTimeAssign (id) {
      const url = getWorkAssign
      let params = {
        projectID: id,
        searchType: 'applyer'
      }
      if (this.reqFlag.getWorkTimeAssign) {
        this.reqFlag.getWorkTimeAssign = false
        this.$http(url, params)
          .then(res => {
            if (res.code === 1) {
              let data = res.data
              this.formData.copInfoTable = data[0]
              for (let item of this.formData.copInfoTable) { // 插入审核状态
                item.reviewStatus = data[1][0].reviewStatus
              }
              console.log(this.formData.copInfoTable)
              this.reqFlag.getWorkTimeAssign = true
            }
          })
      }
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
  }
}
</script>

<style lang="scss">
  .dialogDiv {
    height: 350px;
    overflow: auto;
  }
</style>

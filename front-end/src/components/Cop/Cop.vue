<template>
  <el-dialog title="工时详情"
             :visible.sync="showFlag"
             custom-class="dialog-small"
             @close="closeDialog"
             width="60%"
             append-to-body>
    <div>
      <el-table
        height="400"
        v-loading="!this.reqFlag.reqGetWorkTimeAssign"
        :data="copInfoTable"
        style="width: 100%;margin: auto">
        <el-table-column label="序号" align="center" type="index"></el-table-column>
        <el-table-column label="姓名" prop="name" align="center"></el-table-column>
        <el-table-column label="小组" prop="groupName" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.groupID | groupNameFilter">
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
import { getWorkAssign } from '@/utils/performance'

export default {
  data () {
    return {
      showFlag: false,
      copInfoTable: [],
      reqFlag: {
        edit: true,
        reqGetWorkTimeAssign: true
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
        this.changeShowFlag()
        getWorkAssign(row.id, 'applyer').then(res => {
          this.copInfoTable = res[0]
          let checkFlag = false
          let orgIndex = 0
          for (let i = 0; i < this.copInfoTable.length; i++) { // 插入审核状态
            this.copInfoTable[i].reviewStatus = res[1][0].reviewStatus
            if (this.copInfoTable[i].workTime < 0) {
              checkFlag = true
            }
            if (this.copInfoTable[i].assignRole === '组织者') {
              orgIndex = i
            }
          }
          if (checkFlag) {
            this.copInfoTable[orgIndex].name = 'admin'
            this.copInfoTable[orgIndex].groupName = 'admin'
          }
        }).catch(err => {
          console.log(err)
        })
      })
    },
    changeShowFlag () {
      this.showFlag = !this.showFlag
    },
    // 关闭弹出框
    closeDialog () {
    }
  },
  filters: {
    groupNameFilter (groupID) {
      switch (groupID) {
        case 0:
          return 'success'
        case 2:
          return 'success'
        case 3:
          return 'warning'
        case 4:
          return 'danger'
        case 5:
          return 'primary'
        default:
          return 'info'
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

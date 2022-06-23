<!-- 仅显示状态下的工时分配组件 -->
<template>
  <div>
    <el-table
      :data="tableData"
      :height="400"
      style="width: 100%;margin: auto">
      <el-table-column label="序号" align="center" type="index"></el-table-column>
      <el-table-column label="姓名" prop="name" align="center"></el-table-column>
      <el-table-column label="小组" prop="groupName" align="center" width="110">
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
</template>

<script>
import { getWorkTimeAssign } from '@/utils/performance'
export default {
  data () {
    return {
      tableData: []
    }
  },
  components: {
  },
  created () {
  },
  methods: {
    // 初始化
    init (row) {
      this.tableData = []
      getWorkTimeAssign(row.id, 'applyer').then(response => {
        this.tableData = response[0]
        for (let item of this.tableData) { // 插入审核状态
          item.reviewStatus = response[1][0].reviewStatus
        }
        let organizerIndex = this.tableData.findIndex(item => { return item.assignRole === '组织者' })
        let organizer = this.tableData.splice(organizerIndex, 1)
        this.tableData.unshift(organizer[0])
      })
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
</style>

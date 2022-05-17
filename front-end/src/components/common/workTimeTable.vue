<template>
  <div>
    <el-table
      :data="tableData"
      style="width: 100%;margin: auto">
      <el-table-column label="项目名称" prop="projectName" align="center"></el-table-column>
      <el-table-column label="项目阶段" prop="projectStageName" align="center" show-overflow-tooltip></el-table-column>
      <el-table-column label="申报月份" prop="applyMonth" align="center"></el-table-column>
      <el-table-column label="基本工时" prop="applyBaseWorkTime" align="center"></el-table-column>
      <el-table-column label="K值" prop="applyKValue" align="center"></el-table-column>
      <el-table-column label="完成次数" prop="applyCofficient" align="center"></el-table-column>
      <el-table-column label="申报进展" align="center">
        <template slot-scope="scope">
          <div>
            <span>{{scope.row.applyProcess + '%'}}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="工时分配" align="center">
        <template slot-scope="scope">
          <el-popover
            placement="bottom"
            trigger="hover" @show="handleClickCheckSubmitWorkTime(scope.row)">
            <CopTableVue ref="refCopTableVue"></CopTableVue>
            <span slot="reference" class="link-type">查看</span>
          </el-popover>
        </template>
      </el-table-column>
      <el-table-column label="备注" align="center">
        <template slot-scope="scope">
          <div v-if="scope.row.submitComments !== ''">
            <el-popover
              placement="bottom"
              trigger="hover">
              <span>{{scope.row.submitComments}}</span>
              <span slot="reference" class="link-type">查看</span>
            </el-popover>
          </div>
          <div v-else>无</div>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center">
        <template slot-scope="scope">
          <el-popconfirm
            icon="el-icon-info"
            iconColor="red"
            title="删除确认"
            @confirm="handleDeleteWorkTimeSubmit(scope.row)">
            <el-button size="mini" type="danger" slot="reference">删除</el-button>
          </el-popconfirm>
          <!-- <el-button size="mini" type="danger" @click="handleDeleteWorkTimeSubmit(scope.row)">删除</el-button> -->
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import CopTableVue from '../Cop/CopTable.vue'
import { deleteWorkTimeSubmit } from '@/utils/performance'
export default {
  data () {
    return {
      tableData: [],
      workTimeInfo: { test: '111' }
    }
  },
  components: {
    CopTableVue
  },
  created () {
  },
  methods: {
    // 初始化
    init (workTimeInfo) {
      this.tableData = []
      this.workTimeInfo = workTimeInfo
      this.tableData.push(this.workTimeInfo)
    },
    // 查看工时分配
    handleClickCheckSubmitWorkTime (row) {
      this.$refs.refCopTableVue.init(row)
    },
    // 删除工时申报
    handleDeleteWorkTimeSubmit (row) {
      deleteWorkTimeSubmit(row.id).then(() => {
        this.$common.toast('删除成功', 'success', false)
        this.tableData.splice(0, 1)
        this.$emit('workTimeTableDelete', null)
      }).catch(err => {
        console.log(err)
        this.$common.toast('删除失败', 'error', false)
      })
    }
  }
}
</script>

<style lang="scss">
</style>

<template>
  <div>
    <el-table v-if="tableShowFlag"
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
          <!-- 编辑状态下 -->
          <div v-if="scope.row.editable">
            <el-select v-model="scope.row.applyProcess"
                        placeholder=""
                        size="mini"
                        filterable
                        @visible-change="handleSelectVisibleChange($event, preMonthProcess)">
              <el-option
                v-for="item in progress"
                :key="item.value"
                :label="item.label"
                :value="item.value"
                :disabled="item.disable">
              </el-option>
            </el-select>
          </div>
          <!-- 非编辑状态下 -->
          <div v-else>
            <span>{{scope.row.applyProcess + '%'}}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="工时分配" align="center">
        <template slot-scope="scope">
          <el-popover
            placement="bottom"
            trigger="click"
            @show="handleClickCheckSubmitWorkTime(scope.row)">
              <CopTableVue v-if="!scope.row.editable" ref="refCopTableVue"></CopTableVue>
              <CopTableEdit v-else ref="refCopTableEdit"></CopTableEdit>
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
      <el-table-column label="操作" align="center" width="170">
        <template slot-scope="scope">
          <!-- 工时申报还未通过审核 -->
          <div v-if="scope.row.reviewStatus !== 1">
            <el-popconfirm
              icon="el-icon-info"
              iconColor="red"
              title="删除确认"
              @confirm="handleDeleteWorkTimeSubmit(scope.row)">
              <el-button size="mini" type="danger" slot="reference">删除</el-button>
            </el-popconfirm>
          </div>
          <div v-else>
            <span style="color:red">工时申报已经通过审核，无法修改</span>
          </div>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import CopTableVue from '../Cop/CopTable.vue'
import CopTableEdit from '../Cop/CopTableEdit.vue'
import { deleteWorkTimeSubmit } from '@/utils/performance'
export default {
  data () {
    return {
      tableData: [],
      preMonthProcess: null,
      workTimeInfo: {},
      tableShowFlag: true,
      progress: [{
        value: 10,
        label: '10%',
        disable: false
      }, {
        value: 20,
        label: '20%',
        disable: false
      }, {
        value: 30,
        label: '30%',
        disable: false
      }, {
        value: 40,
        label: '40%',
        disable: false
      }, {
        value: 50,
        label: '50%',
        disable: false
      }, {
        value: 60,
        label: '60%',
        disable: false
      }, {
        value: 70,
        label: '70%',
        disable: false
      }, {
        value: 80,
        label: '80%',
        disable: false
      }, {
        value: 90,
        label: '90%',
        disable: false
      }, {
        value: 100,
        label: '100%',
        disable: false
      }]
    }
  },
  components: {
    CopTableVue,
    CopTableEdit
  },
  created () {
  },
  methods: {
    // 初始化
    init (workTimeInfo, preMonthProcess) {
      this.tableData = []
      this.workTimeInfo = workTimeInfo
      this.preMonthProcess = preMonthProcess
      this.workTimeInfo.editable = false
      this.tableData.push(this.workTimeInfo)
    },
    // 查看工时分配
    handleClickCheckSubmitWorkTime (row) {
      if (!row.editable) {
        this.$refs.refCopTableVue.init(row)
      } else {
        this.$refs.refCopTableEdit.init(row)
      }
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
    },
    // 编辑按钮
    handleEdit (row) {
      row.editable = true
      this.tableShowFlag = false
      this.$nextTick(() => {
        this.tableShowFlag = true
      })
    },
    // 月度进展下拉框下拉时触发
    handleSelectVisibleChange ($event, preMonthProcess) {
      if ($event) {
        for (let item of this.progress) {
          item.disable = false
          if (item.value < preMonthProcess) {
            item.disable = true
          }
        }
      }
    },
    // 保存并提交
    handleComplete (row) {
    }
  }
}
</script>

<style lang="scss">
</style>

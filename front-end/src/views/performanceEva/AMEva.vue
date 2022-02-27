<template>
  <div>
    <div class="head-line">
      <el-button size="mini"
                type="danger"
                style="margin-right: 10px"
                @click="handlePreMonth"
                :disabled="!getDataLoading">上月</el-button>
      <el-date-picker
        v-model="title"
        type="month"
        format="yyyy 第 MM 月"
        value-format="yyyy-MM"
        placeholder="选择月"
        style="width: 150px"
        @change="handleDataChange()">
      </el-date-picker>
      <el-button size="mini"
                  type="primary"
                  style="margin-left: 10px"
                  @click="handleNextMonth"
                  :disabled="!getDataLoading">下月</el-button>
    </div>
    <div class="hr-10"></div>
    <div class="head-line">
      <el-row :gutter="20">
        <el-col :span="12">
          <el-table
            v-loading="!getDataLoading"
            :data="PMdata"
            border
            fit
            highlight-current-row
            style="width: 100%;"
            size="mini"
            ref="PMDataTable">
            <el-table-column label="序号" align="center" type="index" width="80px"></el-table-column>
            <el-table-column label="姓名" prop="name" align="center" width="110px"></el-table-column>
            <el-table-column label="评价状态" prop="evaStatus" align="center"></el-table-column>
            <el-table-column label="月总结" align="center">
              <template slot-scope="scope">
                <el-button type="primary"
                           @click="handlelookOver(scope.row)"
                           size="mini">点击显示</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-col>
        <el-col :span="12">
          <div>
            <el-table :data="tableData1"
                      border
                      stripe
                      size="medium"
                      style="margin: auto"
                      :header-cell-style="{background:'#ced1d4',color:'#000000',fontSize:'16px'}">
              <el-table-column label="打造精品工程">
                <template>
                  <div v-html="buildBoutiqueProject"></div>
                </template>
              </el-table-column>
            </el-table>
            <el-table :data="tableData2"
                      border
                      stripe
                      size="medium"
                      :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="创建专业团队">
                <template>
                  <div v-html="buildProTeam"></div>
                </template>
              </el-table-column>
            </el-table>
            <el-table :data="tableData3"
                      border
                      stripe
                      size="medium"
                      :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="下一个月的工作目标、工作计划/工作安排、工作内容">
                <template>
                  <div v-html="nextPlan"></div>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>
<script>
import {} from '@/utils/performance'
import { Notification } from 'element-ui'
import { getUsersList } from '@/utils/users'
import { getCurMonthConclusionOverviewDataNew } from '@/utils/conclusion'
import store from '@/store'
export default {
  data () {
    return {
      title: this.$moment().format('YYYY-MM'), // 日期
      getDataLoading: true, // 表格加载标志位,
      fillUPing: true, // 表格加载标志位,
      PMdata: [], // 表格数据
      tableHeight: null, // 动态表格高度
      conclusionYear: null, // 总结年份
      conclusionMonth: null, // 总结月份,
      tableData1: [],
      tableData2: [],
      tableData3: [],
      buildBoutiqueProject: null, // 打造精品工程内容
      buildProTeam: null, // 打造精品工程内容
      nextPlan: null // 打造精品工程内容
    }
  },
  methods: {
    // 初始化
    init () {
      this.conclusionYear = this.$moment(this.title).year()
      this.conclusionMonth = this.$moment(this.title).month() + 1
      getUsersList().then(usersList => {
        this.genTableData(usersList)
      })
    },
    // 生成表格数据
    genTableData (usersList) {
      // 初始化默认数据
      let toDoEvaArray = []
      for (let user of usersList) {
        if (store.state.userInfo.groupName === '技术标准组' || store.state.userInfo.groupName === '工程组') {
          if (user.groupName === '技术标准组' || user.groupName === '工程组') {
            let obj = {
              id: user.id,
              name: user.name,
              evaStatus: 0,
              conclusionContent: null,
              isShow: false
            }
            toDoEvaArray.push(obj)
          }
        } else {
          if (user.groupName === '通信组') {
            let obj = {
              id: user.id,
              name: user.name,
              evaStatus: 0,
              conclusionContent: null
            }
            toDoEvaArray.push(obj)
          }
        }
      }
      for (let item of toDoEvaArray) {
      }
      this.PMdata = JSON.parse(JSON.stringify(toDoEvaArray))
      console.log('toDoEvaArray')
      console.log(toDoEvaArray)
    },
    // 点击查看
    handlelookOver (row) {
    },
    // 日期发生变化
    handleDataChange () {
      this.getDataLoading = false
    },
    // 上月
    handlePreMonth () {
      this.title = this.$moment(this.title).subtract(1, 'months').format('YYYY-MM')
      this.handleDataChange()
    },
    // 下月
    handleNextMonth () {
      this.title = this.$moment(this.title).add(1, 'months').format('YYYY-MM')
      this.handleDataChange()
    },
    // 刷新表格尺寸
    refreshTableSize () {
      this.$nextTick(() => {
        this.tableHeight = window.innerHeight - this.$refs.PMDataTable.$el.offsetTop - 5
        if (this.tableHeight < 0) {
          this.tableHeight = window.innerHeight - 100
        }
        let _this = this
        window.onresize = function () {
          _this.tableHeight = window.innerHeight - _this.$refs.PMDataTable.$el.offsetTop - 5
          if (_this.tableHeight < 0) {
            _this.tableHeight = window.innerHeight - 100
          }
        }
      })
    }
  },
  created () {
    this.init()
  },
  mounted () {
    this.refreshTableSize()
  }
}
</script>
<style scoped>
.head-line{
  padding: 20px;
}
</style>

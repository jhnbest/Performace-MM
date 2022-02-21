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
      <el-button size="mini"
                  type="success"
                  style="margin-left: 10px"
                  @click="oneClickFillUp"
                  :disabled="!fillUPing">一键填充</el-button>
    </div>
    <div class="hr-10"></div>
    <div class="head-line">
      <el-table
        v-loading="!getDataLoading"
        :data="PMdata"
        border
        fit
        highlight-current-row
        style="width: 100%;"
        size="mini"
        :height="tableHeight"
        ref="PMDataTable">
        <el-table-column label="序号" align="center" type="index" width="80px"></el-table-column>
        <el-table-column label="姓名" prop="name" align="center" width="110px" fixed="left"></el-table-column>
        <el-table-column label="定量评价得分" prop="QYEvaScoreNor" align="center" width="110px"></el-table-column>
        <el-table-column label="定量评价排名" prop="QYEvaRank" align="center" width="110px"></el-table-column>
        <el-table-column label="当月工时数" prop="totalWorkTime" align="center" width="110px"></el-table-column>
        <el-table-column label="员工定性评价得分（标准化）" prop="CSQTEvaScoreNor" align="center" width="110px"></el-table-column>
        <el-table-column label="员工定性评价排名" prop="CSQTEvaRank" align="center" width="110px"></el-table-column>
        <el-table-column label="经理定性评价得分（标准化）" prop="MGQTEvaScoreNor" align="center" width="110px"></el-table-column>
        <el-table-column label="经理定性评价排名" prop="MGQTEvaRank" align="center" width="110px"></el-table-column>
        <el-table-column label="员工成效评价得分（标准化）" prop="MGQTEvaScoreUnN" align="center" width="110px"></el-table-column>
        <el-table-column label="员工成效评价排名" prop="MGQTEvaScoreUnN" align="center" width="110px"></el-table-column>
        <el-table-column label="组长成效评价得分（标准化）" prop="MGQTEvaScoreUnN" align="center" width="110px"></el-table-column>
        <el-table-column label="组长成效评价排名" prop="MGQTEvaScoreUnN" align="center" width="110px"></el-table-column>
        <el-table-column label="经理成效评价得分（标准化）" prop="MGQTEvaScoreUnN" align="center" width="110px"></el-table-column>
        <el-table-column label="经理成效评价排名" prop="MGQTEvaScoreUnN" align="center" width="110px"></el-table-column>
        <el-table-column label="绩效得分（标准化）" prop="PMScoreNor" align="center" width="110px"></el-table-column>
        <el-table-column label="绩效排名" prop="PMRank" align="center" width="110px"></el-table-column>
        <el-table-column label="绩效得分（未标准化）" prop="PMScoreUnN" align="center" width="110px"></el-table-column>
      </el-table>
    </div>
  </div>
</template>
<script>
import { calPMData,
         savePMData } from '@/utils/performance'
import { Notification } from 'element-ui'
export default {
  data () {
    return {
      title: this.$moment().format('YYYY-MM'), // 日期
      getDataLoading: true, // 表格加载标志位,
      fillUPing: true, // 表格加载标志位,
      PMdata: null, // 表格数据
      tableHeight: null // 动态表格高度
    }
  },
  methods: {
    // 初始化
    init () {
      calPMData(this.title).then(response => {
        this.PMdata = response
        this.getDataLoading = false
        console.log('PMData')
        console.log(response)
      }).catch(err => {
        this.getDataLoading = true
        this.PMdata = []
        console.log(err)
      })
    },
    // 日期发生变化
    handleDataChange () {
      this.getDataLoading = false
      calPMData(this.title).then(response => {
        this.PMdata = response
        this.getDataLoading = true
        console.log('PMData')
        console.log(response)
      }).catch(err => {
        this.PMdata = []
        this.getDataLoading = true
        console.log(err)
      })
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
    // 一键填充绩效数据
    oneClickFillUp () {
      this.fillUPing = false
      let promise = []
      let count = 0
      for (let item of this.PMdata) {
        promise[count++] = savePMData(this.title, item)
      }
      Promise.all(promise).then(allResponse => {
        this.fillUPing = true
        Notification.success({
          title: '成功',
          message: '填充成功'
        })
        console.log(allResponse)
      }).catch(err => {
        this.fillUPing = true
        Notification.error({
          title: '错误',
          message: '填充失败'
        })
        console.log(err)
      })
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

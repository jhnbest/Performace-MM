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
            :height="tableHeight"
            ref="PMDataTable">
            <el-table-column label="序号" align="center" type="index" width="80px"></el-table-column>
            <el-table-column label="姓名" prop="name" align="center" width="110px"></el-table-column>
            <el-table-column label="评价状态" prop="name" align="center" width="110px"></el-table-column>
            <el-table-column label="月总结" prop="name" align="center" width="110px"></el-table-column>
          </el-table>
        </el-col>
        <el-col :span="12">
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
            <el-table-column label="姓名" prop="name" align="center" width="110px"></el-table-column>
            <el-table-column label="评价状态" prop="name" align="center" width="110px"></el-table-column>
            <el-table-column label="月总结" prop="name" align="center" width="110px"></el-table-column>
          </el-table>
        </el-col>
      </el-row>
    </div>
  </div>
</template>
<script>
import {} from '@/utils/performance'
import { Notification } from 'element-ui'
import { getUsersList } from '@/utils/users'
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
      getUsersList().then(response => {
        this.genTableData()
      })
    },
    // 生成表格数据
    genTableData () {

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

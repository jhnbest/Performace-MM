<template>
  <div class="failed-eva-monitor">
    <el-card class="box-card">
      <div slot="header" class="clearfix">
        <span class="card-title">成效评价提交失败监控</span>
        <el-button class="refresh-btn" type="primary" size="small" icon="el-icon-refresh" @click="loadData">刷新数据</el-button>
      </div>

      <div v-if="loading" class="loading-wrapper">
        <i class="el-icon-loading"></i>
        <span>加载中...</span>
      </div>

      <div v-else-if="tableData.length === 0" class="empty-wrapper">
        <i class="el-icon-success success-icon"></i>
        <span class="empty-text">暂无失败数据，所有评价提交正常</span>
      </div>

      <el-table
        v-else
        :data="tableData"
        border
        stripe
        style="width: 100%"
        :header-cell-style="{background: '#f5f7fa', color: '#606266', fontWeight: 'bold'}">
        <el-table-column
          prop="id"
          label="序号"
          width="60"
          align="center">
        </el-table-column>
        <el-table-column
          prop="evaUserName"
          label="评价人"
          width="90"
          align="center">
        </el-table-column>
        <el-table-column
          prop="evaedUserName"
          label="被评价人"
          width="90"
          align="center">
        </el-table-column>
        <el-table-column
          prop="dimensionName"
          label="评价维度"
          min-width="140"
          align="center">
        </el-table-column>
        <el-table-column
          prop="dimensionID"
          label="维度ID"
          width="100"
          align="center">
        </el-table-column>
        <el-table-column
          prop="evaStar"
          label="星级"
          width="70"
          align="center">
          <template slot-scope="scope">
            {{ scope.row.evaStar }}星
          </template>
        </el-table-column>
        <el-table-column
          label="成效评价时间"
          width="130"
          align="center">
          <template slot-scope="scope">
            {{ scope.row.conclusionYear }}年{{ scope.row.conclusionMonth }}月
          </template>
        </el-table-column>
        <el-table-column
          prop="errorCode"
          label="错误码"
          width="80"
          align="center">
          <template slot-scope="scope">
            <el-tag type="danger" size="small">{{ scope.row.errorCode }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column
          prop="errorMessage"
          label="错误信息"
          min-width="180"
          align="center">
        </el-table-column>
        <el-table-column
          label="状态"
          width="100"
          align="center">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.retryStatus === 1" type="success" size="small">
              <i class="el-icon-check"></i> 已成功
            </el-tag>
            <el-tag v-else type="warning" size="small">
              <i class="el-icon-time"></i> 待重试
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column
          prop="retryTime"
          label="重试成功时间"
          width="160"
          align="center">
          <template slot-scope="scope">
            {{ scope.row.retryStatus === 1 ? formatTime(scope.row.retryTime) : '-' }}
          </template>
        </el-table-column>
        <el-table-column
          prop="createTime"
          label="创建时间"
          width="160"
          align="center">
          <template slot-scope="scope">
            {{ formatTime(scope.row.createTime) }}
          </template>
        </el-table-column>
      </el-table>

      <div v-if="tableData.length > 0" class="statistics">
        <el-alert
          :title="'总计：' + tableData.length + ' 条失败记录，其中待重试：' + waitingRetryCount + ' 条，已成功：' + successCount + ' 条'"
          type="info"
          :closable="false"
          show-icon>
        </el-alert>
      </div>
    </el-card>
  </div>
</template>

<script>
import { getAllFailedAMEvaData } from '@/utils/achievementEva'
import moment from 'moment'

export default {
  name: 'FailedAMEvaMonitor',
  data () {
    return {
      tableData: [],
      loading: false
    }
  },
  computed: {
    waitingRetryCount () {
      return this.tableData.filter(item => item.retryStatus === 0).length
    },
    successCount () {
      return this.tableData.filter(item => item.retryStatus === 1).length
    }
  },
  created () {
    this.loadData()
  },
  methods: {
    loadData () {
      this.loading = true
      getAllFailedAMEvaData().then(result => {
        this.tableData = result || []
        this.loading = false
      }).catch(err => {
        console.error('获取失败数据失败:', err)
        this.loading = false
      })
    },
    formatTime (time) {
      if (!time) return ''
      return moment(time).format('YYYY-MM-DD HH:mm:ss')
    }
  }
}
</script>

<style scoped lang="scss">
.failed-eva-monitor {
  padding: 20px;

  .box-card {
    .card-title {
      font-size: 18px;
      font-weight: bold;
      color: #303133;
    }

    .refresh-btn {
      float: right;
    }
  }

  .loading-wrapper,
  .empty-wrapper {
    text-align: center;
    padding: 60px 20px;
    color: #909399;

    .el-icon-loading,
    .el-icon-success {
      font-size: 48px;
      display: block;
      margin-bottom: 16px;
    }

    .success-icon {
      color: #67C23A;
    }

    .empty-text {
      font-size: 16px;
    }
  }

  .statistics {
    margin-top: 20px;
  }
}
</style>

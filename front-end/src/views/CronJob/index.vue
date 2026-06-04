<template>
  <div class="cron-job-container">
    <div class="page-header">
      <div class="header-content">
        <div class="header-icon">
          <i class="el-icon-time"></i>
        </div>
        <div class="header-text">
          <h1>定时任务管理</h1>
          <p class="header-subtitle">管理系统定时任务配置与执行状态</p>
        </div>
      </div>
      <div class="header-actions">
        <el-button type="primary" icon="el-icon-refresh" @click="refreshData" class="refresh-btn">刷新数据</el-button>
      </div>
    </div>

    <el-card class="cron-job-card" shadow="hover">
      <div class="card-header" slot="header">
        <div class="card-title">
          <i class="el-icon-notebook-2"></i>
          <span>定时任务列表</span>
        </div>
        <div class="card-badge">
          <el-tag type="info" size="small">共 {{ cronJobList.length }} 个任务</el-tag>
        </div>
      </div>

      <div class="table-container">
        <el-table :data="cronJobList" border style="width: 100%" :cell-style="tableCellStyle" :header-cell-style="tableHeaderCellStyle" height="400" stripe class="custom-table">
          <el-table-column prop="jobName" label="任务名称" min-width="140" align="center">
            <template slot-scope="scope">
              <el-input 
                v-model="scope.row.jobName" 
                size="mini" 
                class="job-name-input"
                @change="handleJobNameChange(scope.row)"
                placeholder="输入任务名称">
              </el-input>
            </template>
          </el-table-column>
          <el-table-column prop="jobDescription" label="任务描述" min-width="150" show-overflow-tooltip align="left">
            <template slot-scope="scope">
              <span class="description-text">{{ scope.row.jobDescription }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="cronExpression" label="Cron表达式" min-width="140" align="center">
            <template slot-scope="scope">
              <el-tooltip :content="scope.row.cronExpression" placement="top" :open-delay="300">
                <span class="cron-expression">{{ scope.row.cronExpression }}</span>
              </el-tooltip>
            </template>
          </el-table-column>
          <el-table-column label="Cron表达式解析" min-width="200" align="left">
            <template slot-scope="scope">
              <div class="cron-parse-cell">
                <i class="el-icon-view"></i>
                <span>{{ parseCronExpression(scope.row.cronExpression) }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" min-width="90" align="center">
            <template slot-scope="scope">
              <el-tag :type="scope.row.status === 'running' ? 'success' : 'danger'" size="small" effect="light" class="status-tag">
                <i :class="scope.row.status === 'running' ? 'el-icon-circle-check' : 'el-icon-circle-close'"></i>
                {{ scope.row.status === 'running' ? '运行中' : '已停止' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="lastExecution" label="上次执行时间" min-width="160" align="center">
            <template slot-scope="scope">
              <div class="time-cell">
                <i class="el-icon-time"></i>
                <span>{{ scope.row.lastExecution }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="nextExecution" label="下次执行时间" min-width="160" align="center">
            <template slot-scope="scope">
              <div class="time-cell">
                <i class="el-icon-alarm-clock"></i>
                <span>{{ scope.row.nextExecution }}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="快捷设置" min-width="160" align="center">
            <template slot-scope="scope">
              <el-select 
                v-model="scope.row.quickSetDay" 
                size="mini" 
                placeholder="设置日期" 
                class="quick-select"
                @change="(val) => handleQuickSetNextExecution(scope.row, val)"
                clearable>
                <el-option v-for="day in quickSetDays" :key="day" :label="`每月${day}日 02:00`" :value="day"></el-option>
              </el-select>
            </template>
          </el-table-column>
          <el-table-column label="操作" min-width="280" fixed="right" align="center">
            <template slot-scope="scope">
              <div class="action-buttons">
                <el-button type="primary" size="mini" icon="el-icon-edit" @click="editCronJob(scope.row)" class="action-btn">编辑</el-button>
                <el-button type="success" size="mini" icon="el-icon-video-play" @click="executeJobNow(scope.row)" class="action-btn">立即执行</el-button>
                <el-button :type="scope.row.status === 'running' ? 'warning' : 'success'" size="mini" :icon="scope.row.status === 'running' ? 'el-icon-video-pause' : 'el-icon-video-play'" @click="toggleJobStatus(scope.row)" class="action-btn">
                  {{ scope.row.status === 'running' ? '停止' : '启动' }}
                </el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>

    <!-- 全部任务执行日志 -->
    <el-card class="cron-job-card" shadow="hover" style="margin-top: 20px;">
      <div class="card-header" slot="header">
        <div class="card-title">
          <i class="el-icon-document"></i>
          <span>全部任务执行日志</span>
        </div>
        <div class="card-actions">
          <el-select v-model="selectedJobType" placeholder="选择任务类型" size="mini" clearable style="width: 150px; margin-right: 10px;" @change="getAllExecutionLogs">
            <el-option label="全部任务" value=""></el-option>
            <el-option v-for="(config, key) in jobTypeConfigs" :key="key" :label="config.name" :value="key"></el-option>
          </el-select>
          <el-button type="primary" size="mini" icon="el-icon-refresh" @click="refreshAllLogs" class="action-btn">刷新</el-button>
        </div>
      </div>

      <div class="table-container">
        <el-table :data="allExecutionLogs" border style="width: 100%" :cell-style="tableCellStyle" :header-cell-style="tableHeaderCellStyle" height="300" stripe class="custom-table">
          <el-table-column prop="job_type" label="任务类型" min-width="120" align="center">
            <template slot-scope="scope">
              <el-tag :type="getJobTypeTagType(scope.row.job_type)" size="small" effect="dark">
                {{ getJobTypeName(scope.row.job_type) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="execution_time" label="执行时间" min-width="160" align="center">
            <template slot-scope="scope">
              <span>{{ formatDateTime(scope.row.execution_time) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="执行状态" min-width="100" align="center">
            <template slot-scope="scope">
              <el-tag :type="getJobExecutionStatusType(scope.row.execution_status)" size="small">
                {{ getJobExecutionStatusText(scope.row.execution_status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="execution_duration" label="执行时长" min-width="100" align="center">
            <template slot-scope="scope">
              <span>{{ scope.row.execution_duration ? scope.row.execution_duration + 'ms' : '-' }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="execution_result" label="执行摘要" min-width="200" align="left" show-overflow-tooltip>
            <template slot-scope="scope">
              <span>{{ formatExecutionSummary(scope.row) }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" min-width="150" align="center">
            <template slot-scope="scope">
              <el-button type="primary" size="mini" icon="el-icon-view" @click="viewAllLogDetails(scope.row)">查看详情</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>

    <!-- 全部任务执行详情对话框 -->
    <el-dialog title="执行详情" :visible.sync="allLogDetailDialogVisible" width="70%" max-width="800px" class="detail-dialog">
      <div class="detail-info" v-if="allLogDetails">
        <span class="detail-count">任务: {{ allLogDetails.job_name || '-' }}</span>
      </div>
      
      <!-- 基本信息区域 -->
      <div class="basic-info-section" v-if="allLogDetails">
        <el-row :gutter="16">
          <el-col :span="8">
            <div class="basic-info-item">
              <span class="info-label">执行时间:</span>
              <span class="info-value">{{ formatDateTime(allLogDetails.execution_time) }}</span>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="basic-info-item">
              <span class="info-label">执行状态:</span>
              <el-tag :type="getJobExecutionStatusType(allLogDetails.execution_status)" size="small">
                {{ getJobExecutionStatusText(allLogDetails.execution_status) }}
              </el-tag>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="basic-info-item">
              <span class="info-label">执行时长:</span>
              <span class="info-value">{{ allLogDetails.execution_duration ? allLogDetails.execution_duration + 'ms' : '-' }}</span>
            </div>
          </el-col>
        </el-row>
        <el-row :gutter="16" style="margin-top: 12px;">
          <el-col :span="24">
            <div class="basic-info-item full-width">
              <span class="info-label">错误信息:</span>
              <span v-if="allLogDetails.error_message" class="error-text">
                <i class="el-icon-warning"></i>
                {{ allLogDetails.error_message }}
              </span>
              <span v-else class="success-text">
                <i class="el-icon-check"></i>
                无
              </span>
            </div>
          </el-col>
        </el-row>
      </div>

      <!-- 互评填充任务详情展示 -->
      <div v-if="isMutualRateFillJob && mutualRateFillDetails" class="mutual-rate-details" style="margin-top: 20px;">
        <div class="details-header">
          <i class="el-icon-document-checked"></i>
          <span>互评填充详情</span>
        </div>
        <el-row :gutter="16" class="rate-info-row">
          <el-col :span="8">
            <div class="rate-info-card">
              <div class="rate-info-label">评分的月份</div>
              <div class="rate-info-value rate-month">{{ mutualRateFillDetails.rateMonth || '-' }}</div>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="rate-info-card">
              <div class="rate-info-label">需填充用户数</div>
              <div class="rate-info-value rate-users">{{ mutualRateFillDetails.totalUsersToFill || 0 }}</div>
            </div>
          </el-col>
          <el-col :span="8">
            <div class="rate-info-card">
              <div class="rate-info-label">总填充条数</div>
              <div class="rate-info-value rate-records">{{ mutualRateFillDetails.totalRecordsFilled || 0 }}</div>
            </div>
          </el-col>
        </el-row>

        <!-- 需填充用户列表 -->
        <div v-if="mutualRateFillDetails.usersToFill && mutualRateFillDetails.usersToFill.length > 0" class="users-section">
          <div class="section-title">
            <i class="el-icon-user"></i>
            <span>需填充的用户 ({{ mutualRateFillDetails.usersToFill.length }})</span>
          </div>
          <div class="users-tags">
            <el-tag v-for="user in mutualRateFillDetails.usersToFill" :key="user.userID" type="info" size="small" class="user-tag">
              {{ user.userName }}
            </el-tag>
          </div>
        </div>
        
        <!-- 无数据提示 -->
        <div v-if="!mutualRateFillDetails.usersToFill || mutualRateFillDetails.usersToFill.length === 0" class="no-data-section">
          <div class="no-data-content">
            <i class="el-icon-check"></i>
            <span>本次执行无需填充，所有用户已有互评数据</span>
          </div>
        </div>

        <!-- 填充记录详情表格 -->
        <div v-if="mutualRateFillDetails.fillRecords && mutualRateFillDetails.fillRecords.length > 0" class="records-section">
          <div class="section-title">
            <i class="el-icon-notebook-2"></i>
            <span>填充记录详情 ({{ mutualRateFillDetails.fillRecords.length }})</span>
          </div>
          <div class="records-tip" v-if="mutualRateFillDetails.fillRecords.length > 100">
            <i class="el-icon-info"></i>
            <span>为保证加载性能，仅显示前100条记录</span>
          </div>
          <el-table :data="mutualRateFillDetails.fillRecords.slice(0, 100)" border size="small" max-height="300" class="fill-records-table">
            <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
            <el-table-column prop="ratedPersonName" label="被评分人" min-width="100" align="center"></el-table-column>
            <el-table-column prop="ratePersonName" label="评分人" min-width="100" align="center"></el-table-column>
            <el-table-column prop="rate" label="得分" min-width="80" align="center">
              <template slot-scope="scope">
                <el-tag :type="getScoreTagType(scope.row.rate)" size="small">
                  {{ scope.row.rate }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="rateType" label="评分类型" min-width="100" align="center">
              <template slot-scope="scope">
                <el-tag size="small">{{ getRateTypeText(scope.row.rateType) }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="rateMonth" label="评分月份" min-width="100" align="center"></el-table-column>
          </el-table>
        </div>
      </div>

      <!-- 其他任务的执行结果展示 -->
      <div v-else class="execution-result-section" style="margin-top: 20px;">
        <div class="details-header">
          <i class="el-icon-tickets"></i>
          <span>执行结果</span>
        </div>
        <pre v-if="allLogDetails.execution_result" style="white-space: pre-wrap; word-wrap: break-word; margin: 10px 0; font-size: 12px; background: #f5f7fa; padding: 10px; border-radius: 4px;">{{ formatExecutionSummary(allLogDetails) }}</pre>
        <span v-else class="no-result">-</span>
      </div>

      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="allLogDetailDialogVisible = false">确定</el-button>
      </div>
    </el-dialog>

    <!-- 编辑定时任务对话框 -->
    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible" width="85%" max-width="900px" class="cron-dialog" :close-on-click-modal="true" :destroy-on-close="true" :modal-append-to-body="false">
      <div class="dialog-header">
        <div class="dialog-icon">
          <i class="el-icon-setting"></i>
        </div>
        <div class="dialog-info">
          <h3>任务配置</h3>
          <p>配置定时任务的执行计划和描述信息</p>
        </div>
      </div>

      <el-form :model="formData" label-width="100px" class="cron-form" :rules="formRules" ref="cronForm">
        <el-row :gutter="24">
          <el-col :xs="24" :sm="12" :md="12" :lg="10">
            <el-form-item label="任务名称" label-position="top">
              <el-input v-model="formData.jobName" placeholder="任务名称">
                <i slot="prefix" class="el-icon-timer input-icon"></i>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12" :md="12" :lg="14">
            <el-form-item label="当前状态" label-position="top">
              <div class="status-display">
                <el-tag :type="formData.status === 'running' ? 'success' : 'danger'" size="medium" effect="light" class="status-tag-large">
                  <i :class="formData.status === 'running' ? 'el-icon-circle-check' : 'el-icon-circle-close'"></i>
                  {{ formData.status === 'running' ? '运行中' : '已停止' }}
                </el-tag>
              </div>
            </el-form-item>
          </el-col>
        </el-row>

        <div class="config-section">
          <div class="section-title">
            <i class="el-icon-clock"></i>
            <span>Cron表达式配置</span>
          </div>

          <div class="cron-config-panel">
            <vue-cron v-model="formData.cronExpression" @change="handleCronChange" :is-show-week="true" :is-show-year="false" :is-show-second="true" class="vue-cron-wrapper"></vue-cron>
          </div>
        </div>

        <el-row :gutter="24" class="result-row">
          <el-col :xs="24" :sm="12">
            <el-form-item label="Cron表达式" label-position="top">
              <el-input v-model="formData.cronExpression" readonly class="cron-result-input" placeholder="生成的Cron表达式">
                <i slot="prefix" class="el-icon-document input-icon"></i>
                <el-tooltip slot="suffix" content="复制表达式" placement="top" :open-delay="300">
                  <el-button type="text" icon="el-icon-copy-document" size="mini" @click="copyCronExpression" class="copy-btn"></el-button>
                </el-tooltip>
              </el-input>
            </el-form-item>
          </el-col>
          <el-col :xs="24" :sm="12">
            <el-form-item label="表达式解析" label-position="top">
              <el-input v-model="cronExpressionDescription" readonly class="cron-parse-result" placeholder="表达式中文说明">
                <i slot="prefix" class="el-icon-view input-icon"></i>
              </el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-form-item label="任务描述" label-position="top">
          <el-input v-model="formData.jobDescription" type="textarea" rows="3" placeholder="请输入任务描述，用于说明任务的用途和功能" maxlength="500" show-word-limit class="description-input"></el-input>
        </el-form-item>
      </el-form>

      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false" class="cancel-btn">
          <i class="el-icon-close"></i> 取消
        </el-button>
        <el-button ref="saveButton" type="primary" @click="saveCronJob" class="save-btn">
          <i class="el-icon-check"></i> 保存配置
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { http } from '@/config/http.js'
import cronstrue from 'cronstrue/i18n'
import 'cronstrue/locales/zh_CN'

export default {
  name: 'CronJobManager',
  data () {
    return {
      cronJobList: [],
      dialogVisible: false,
      dialogTitle: '',
      // 统一执行日志相关
      selectedJobType: '',
      allExecutionLogs: [],
      allLogDetails: [],
      allLogDetailDialogVisible: false,
      isMutualRateFillJob: false,
      mutualRateFillDetails: null,
      formData: {
        jobName: '',
        cronExpression: '',
        jobDescription: ''
      },
      cronExpressionDescription: '',
      cronPopover: false,
      formRules: {
        jobDescription: [
          { min: 0, max: 500, message: '任务描述最多500个字符', trigger: 'blur' }
        ]
      },
      // 快捷设置日期选项（1-15日）
      quickSetDays: Array.from({ length: 15 }, (_, i) => i + 1),
      // 任务类型配置
      jobTypeConfigs: {
        mutualRateFillCron: {
          name: '互评填充任务',
          description: '每月自动填充互评数据',
          color: '#E6A23C',
          defaultCron: '0 0 2 3 * *'
        },
        autoConclusionCron: {
          name: '月总结自动提交任务',
          description: '每月自动为未提交月总结的员工生成空白总结',
          color: '#409EFF',
          defaultCron: '0 0 3 5 * *'
        },
        amevaDeadlineCron: {
          name: 'AMEva截止任务',
          description: '在globalflag表中插入AMEvaDeadline标志',
          color: '#F56C6C',
          defaultCron: '0 0 0 1 * *'
        },
        mutualEvaSubmitCron: {
          name: '互评提交任务',
          description: '在globalflag表中插入multualEvaSubmit标志',
          color: '#909399',
          defaultCron: '0 0 0 1 * *'
        },
        workTimeSubmitCron: {
          name: '工时提交任务',
          description: '在globalflag表中插入workTimeSubmit标志',
          color: '#67C23A',
          defaultCron: '0 0 0 1 * *'
        },
        resetAssignProjectCron: {
          name: '重置分配项目任务',
          description: '将assignprojectlist表中的isFilled字段重置为0',
          color: '#E91E63',
          defaultCron: '0 0 0 1 * *'
        },
        cleanProgressCron: {
          name: '清理进展任务',
          description: '清理未申报工时的项目阶段进展，重置为上月进展',
          color: '#9C27B0',
          defaultCron: '0 0 1 1 * *'
        }
      },
      // 表格样式
      tableCellStyle: {
        padding: '12px 0',
        fontSize: '13px'
      },
      tableHeaderCellStyle: {
        background: '#409eff',
        color: '#fff',
        fontWeight: '600',
        fontSize: '14px',
        padding: '14px 0'
      }
    }
  },
  computed: {
    ...mapGetters(['userInfo'])
  },
  mounted () {
    this.getCronJobData()
    this.getAllExecutionLogs()
  },
  methods: {
    /**
     * 获取单个任务配置
     * @param {string} jobType - 任务类型
     * @returns {Promise<Object>} - 配置信息
     */
    async getJobConfig (jobType) {
      try {
        const res = await http('/cronJob/getCronJobConfig', { jobType })
        if (res.code === 1 && res.data) {
          const config = this.jobTypeConfigs[jobType] || {}
          return {
            name: res.data.jobName || config.name || jobType,
            description: res.data.jobDescription || config.description || '',
            cronExpr: res.data.cronExpr || config.defaultCron || '0 0 0 1 * *'
          }
        }
      } catch (error) {
        console.error(`获取${jobType}配置失败:`, error)
      }
      return this.jobTypeConfigs[jobType] || { name: jobType, description: '', cronExpr: '0 0 0 1 * *' }
    },

    /**
     * 获取定时任务数据
     */
    async getCronJobData () {
      try {
        const statusRes = await http('/cronJob/getCronJobStatus', {})

        if (statusRes.code === 1) {
          const statusData = statusRes.data
          this.cronJobList = []
          const jobTypes = Object.keys(statusData)

          // 并行获取所有任务配置
          const configPromises = jobTypes.map(async (jobType) => {
            const config = await this.getJobConfig(jobType)
            return { jobType, config }
          })
          const configs = await Promise.all(configPromises)
          const configMap = {}
          configs.forEach(({ jobType, config }) => {
            configMap[jobType] = config
          })

          // 处理每个任务
          for (const jobType of jobTypes) {
            const config = configMap[jobType]
            const jobStatus = statusData[jobType]
            const jobConfig = this.jobTypeConfigs[jobType] || {}
            const defaultCron = jobConfig.defaultCron || '0 0 0 1 * *'
            
            this.cronJobList.push({
              jobName: config.name,
              jobDescription: config.description,
              cronExpression: config.cronExpr || defaultCron,
              jobType: jobType,
              status: jobStatus.running ? 'running' : 'stopped',
              lastExecution: jobStatus.lastExecutionTime ? new Date(jobStatus.lastExecutionTime).toLocaleString('zh-CN') : '从未执行',
              nextExecution: jobStatus.nextDate ? new Date(jobStatus.nextDate).toLocaleString('zh-CN') : '未设置'
            })
          }
        }
      } catch (error) {
        console.error('获取定时任务数据失败:', error)
      }
    },

    /**
     * 刷新数据
     */
    refreshData () {
      this.getCronJobData()
    },

    /**
     * 编辑定时任务
     */
    editCronJob (row) {
      this.dialogTitle = '编辑定时任务'
      this.formData = { ...row }
      this.cronExpressionDescription = this.parseCronExpression(row.cronExpression)

      this.dialogVisible = true
    },

    /**
     * 保存定时任务配置
     */
    async saveCronJob () {
      try {
        // 获取原始表达式
        let cronExpr = this.formData.cronExpression

        // 转换为6字段格式
        const parts = cronExpr.split(' ')
        if (parts.length === 7) {
          cronExpr = parts.slice(0, 6).join(' ')
        } else if (parts.length !== 6) {
          console.error('cron表达式字段数异常:', parts.length, cronExpr)
        }

        // 备选方案：将?替换为*，解决cron v3.x兼容性问题
        const altExpr = cronExpr.replace(/\?/g, '*')
        if (altExpr !== cronExpr) {
          cronExpr = altExpr
        }

        const params = {
          jobType: this.formData.jobType || 'mutualRateFillCron',
          cronExpr: cronExpr,
          jobDescription: this.formData.jobDescription
        }

        const res = await http('/cronJob/updateCronJobConfig', params)
        if (res.code === 1) {
          this.$message.success('保存成功')
          this.dialogVisible = false
          this.getCronJobData()
        } else {
          this.$message.error('保存失败: ' + (res.message || '未知错误'))
        }
      } catch (error) {
        console.error('保存定时任务配置失败:', error)
        this.$message.error('保存失败: ' + error.message)
      }
    },

    /**
     * 处理vue-cron组件变化
     */
    handleCronChange (cronExpression) {
      if (cronExpression) {
        // vue-cron可能生成7字段格式（含年），需要转换为6字段格式
        const parts = cronExpression.split(' ')
        if (parts.length === 7) {
          // 移除年份字段，只保留前6个字段
          this.formData.cronExpression = parts.slice(0, 6).join(' ')
        } else {
          this.formData.cronExpression = cronExpression
        }
        this.cronExpressionDescription = this.parseCronExpression(this.formData.cronExpression)
      }
    },

    /**
     * 立即执行任务
     */
    async executeJobNow (row) {
      try {
        this.$confirm(`确定要立即执行任务 "${row.jobName}" 吗？`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(async () => {
          let res
          if (row.jobType === 'mutualRateFillCron') {
            res = await http('/cronJob/executeMutualRateFill', {})
          } else if (row.jobType === 'autoConclusionCron') {
            res = await http('/cronJob/executeAutoConclusion', {})
          } else if (row.jobType === 'amevaDeadlineCron') {
            res = await http('/cronJob/executeAMEvaDeadline', {})
          } else if (row.jobType === 'mutualEvaSubmitCron') {
            res = await http('/cronJob/executeMutualEvaSubmit', {})
          } else if (row.jobType === 'workTimeSubmitCron') {
            res = await http('/cronJob/executeWorkTimeSubmit', {})
          } else if (row.jobType === 'resetAssignProjectCron') {
            res = await http('/cronJob/executeResetAssignProject', {})
          } else if (row.jobType === 'cleanProgressCron') {
            res = await http('/cronJob/executeCleanProgress', {}, null, 60000)
          }

          if (res && res.code === 1) {
            this.$message.success('任务执行成功')
            this.getCronJobData()
            this.getAllExecutionLogs()
          } else {
            this.$message.error('任务执行失败: ' + (res.message || '未知错误'))
          }
        }).catch(() => {
          this.$message.info('已取消执行')
        })
      } catch (error) {
        console.error('执行任务失败:', error)
        this.$message.error('执行失败: ' + error.message)
      }
    },

    /**
     * 处理任务名称变更
     * @param {Object} row - 任务行数据
     */
    async handleJobNameChange (row) {
      try {
        const res = await http('/cronJob/updateJobName', {
          jobType: row.jobType,
          jobName: row.jobName
        })
        if (res && res.code === 1) {
          this.$message.success('任务名称已更新')
          this.getCronJobData()
        } else {
          this.$message.error('更新失败: ' + (res.message || '未知错误'))
        }
      } catch (error) {
        console.error('更新任务名称失败:', error)
        this.$message.error('更新失败: ' + error.message)
      }
    },

    /**
     * 快捷设置定时任务下次执行时间
     * @param {Object} row - 任务行数据
     * @param {number} day - 选择的日期（1-15）
     */
    async handleQuickSetNextExecution (row, day) {
      if (!day) return
      try {
        const res = await http('/cronJob/setNextExecution', {
          jobType: row.jobType,
          day: day,
          hour: 2,
          minute: 0
        })
        if (res && res.code === 1) {
          this.$message.success(`已设置为每月${day}日 02:00执行`)
          this.getCronJobData()
        } else {
          this.$message.error('设置失败: ' + (res.message || '未知错误'))
        }
      } catch (error) {
        console.error('设置下次执行时间失败:', error)
        this.$message.error('设置失败: ' + error.message)
      }
    },

    /**
     * 获取所有任务的执行日志
     */
    async getAllExecutionLogs () {
      try {
        const params = {
          jobType: this.selectedJobType || null,
          limit: 50
        }
        const res = await http('/cronJob/getAllJobExecutionLogs', params)
        if (res.code === 1) {
          this.allExecutionLogs = res.data || []
        }
      } catch (error) {
        console.error('获取所有任务执行日志失败:', error)
      }
    },

    /**
     * 刷新所有日志
     */
    refreshAllLogs () {
      this.getAllExecutionLogs()
      this.$message.success('日志已刷新')
    },

    /**
     * 获取任务类型名称
     * @param {string} jobType - 任务类型键名
     * @returns {string} - 任务类型显示名称
     */
    getJobTypeName (jobType) {
      const config = this.jobTypeConfigs[jobType]
      return (config && config.name) ? config.name : (jobType || '未知任务')
    },

    /**
     * 获取任务类型标签颜色
     * @param {string} jobType - 任务类型键名
     * @returns {string} - 标签类型
     */
    getJobTypeTagType (jobType) {
      const colorMap = {
        mutualRateFillCron: 'warning',
        autoConclusionCron: 'primary',
        amevaDeadlineCron: 'danger',
        mutualEvaSubmitCron: 'info',
        workTimeSubmitCron: 'success',
        resetAssignProjectCron: 'danger',
        cleanProgressCron: 'warning'
      }
      return colorMap[jobType] || 'info'
    },

    /**
     * 获取任务执行状态类型
     * @param {number} status - 执行状态: 0-执行中, 1-成功, 2-失败
     * @returns {string} - 标签类型
     */
    getJobExecutionStatusType (status) {
      const statusMap = {
        0: 'info',
        1: 'success',
        2: 'danger'
      }
      return statusMap[status] || 'info'
    },

    /**
     * 获取任务执行状态文本
     * @param {number} status - 执行状态: 0-执行中, 1-成功, 2-失败
     * @returns {string} - 状态文本
     */
    getJobExecutionStatusText (status) {
      const statusMap = {
        0: '执行中',
        1: '成功',
        2: '失败'
      }
      return statusMap[status] || '未知'
    },

    /**
     * 格式化执行摘要
     * @param {Object} log - 日志记录
     * @returns {string} - 格式化后的摘要
     */
    formatExecutionSummary (log) {
      if (!log.execution_result) return '-'
      try {
        const summary = typeof log.execution_result === 'string' ? JSON.parse(log.execution_result) : log.execution_result
        if (summary.affectedRows !== undefined) {
          return `影响行数: ${summary.affectedRows}`
        } else if (summary.totalRecords !== undefined) {
          return `总记录数: ${summary.totalRecords}, 已重置: ${summary.resetRecords}`
        } else if (summary.operation) {
          return `操作: ${summary.operation}, 影响行数: ${summary.affectedRows}`
        } else if (summary.cleanedRecords !== undefined) {
          let summaryText = `清理记录: ${summary.cleanedRecords}条, 跳过: ${summary.skippedRecords}条, 目标月份: ${summary.targetMonth}`
          if (summary.cleanedDetails && summary.cleanedDetails.length > 0) {
            summaryText += '\n\n详细清理记录:\n' + summary.cleanedDetails.map((d, index) =>
              `${index + 1}. 项目阶段: ${d.projectStageName}\n` +
              `   APDID: ${d.apdID}, APLID: ${d.aplID}\n` +
              `   ${d.lastMonth}进展: ${d.lastMonthProcess}% → ${d.preMonth}进展: ${d.preMonthProcess}%\n` +
              `   原因: ${d.resetReason}`
            ).join('\n')
          }
          return summaryText
        } else if (summary.success !== undefined) {
          return summary.success ? '执行成功' : '执行失败'
        }
        return JSON.stringify(summary)
      } catch (e) {
        return log.execution_result
      }
    },

    /**
     * 查看任务执行日志详情
     * @param {Object} row - 日志记录
     */
    async viewAllLogDetails(row) {
      try {
        const res = await http('/cronJob/getJobExecutionDetail', { logId: row.id })
        if (res.code === 1) {
          this.allLogDetails = res.data || []
          
          // 检查是否是互评填充任务，并解析执行结果
          if (this.allLogDetails.job_type === 'mutualRateFillCron' && this.allLogDetails.execution_result) {
            this.isMutualRateFillJob = true
            try {
              let result = typeof this.allLogDetails.execution_result === 'string' 
                ? JSON.parse(this.allLogDetails.execution_result) 
                : this.allLogDetails.execution_result
              
              // 检查是否是嵌套的JSON字符串
              if (typeof result === 'string') {
                result = JSON.parse(result)
              }
              
              this.mutualRateFillDetails = result
            } catch (e) {
              console.error('解析互评填充详情失败:', e)
              this.mutualRateFillDetails = null
            }
          } else {
            this.isMutualRateFillJob = false
            this.mutualRateFillDetails = null
          }
          
          this.allLogDetailDialogVisible = true
        }
      } catch (error) {
        console.error('获取日志详情失败:', error)
        this.$message.error('获取详情失败')
      }
    },

    /**
     * 格式化日期时间
     */
    formatDateTime (dateTime) {
      if (!dateTime) return '-'
      return new Date(dateTime).toLocaleString('zh-CN')
    },

    /**
     * 根据得分返回标签类型
     * @param {number} score - 得分
     * @returns {string} - 标签类型
     */
    getScoreTagType(score) {
      if (!score && score !== 0) return 'info'
      if (score >= 90) return 'success'
      if (score >= 80) return ''
      if (score >= 60) return 'warning'
      return 'danger'
    },
    
    /**
     * 根据评分类型ID返回可读文本
     * @param {number} rateType - 评分类型ID
     * @returns {string} - 评分类型文本
     */
    getRateTypeText(rateType) {
      const rateTypeMap = {
        1: 't1Star',
        2: 't2Star',
        3: 't3Star',
        4: 't4Star',
        5: 't5Star',
        6: 't6Star'
      }
      return rateTypeMap[rateType] || `类型${rateType}` || '-'
    },

    /**
     * 获取执行状态类型
     */
    getStatusType (status) {
      const statusMap = {
        0: 'info',
        1: 'success',
        2: 'warning',
        3: 'danger'
      }
      return statusMap[status] || 'info'
    },

    /**
     * 获取执行状态文本
     */
    getStatusText (status) {
      const statusMap = {
        0: '执行中',
        1: '全部成功',
        2: '部分失败',
        3: '全部失败'
      }
      return statusMap[status] || '未知'
    },

    /**
     * 获取职务级别文本
     * @param {number} duty - 职务级别: 1-处经理, 2-组长, 3-组员
     * @returns {string} - 职务级别文本
     */
    getDutyText (duty) {
      const dutyMap = {
        1: '处经理',
        2: '组长',
        3: '组员'
      }
      return dutyMap[duty] || '未知'
    },

    /**
     * 获取职务级别标签类型
     * @param {number} duty - 职务级别
     * @returns {string} - 标签类型
     */
    getDutyTagType (duty) {
      const typeMap = {
        1: 'warning', // 处经理 - 橙色
        2: 'success', // 组长 - 绿色
        3: 'primary' // 组员 - 蓝色
      }
      return typeMap[duty] || 'info'
    },

    /**
     * 获取处理状态标签类型
     * @param {number} status - 处理状态
     * @returns {string} - 标签类型
     */
    getProcessingTagType (status) {
      const typeMap = {
        1: 'success', // 成功
        2: 'danger', // 失败
        3: 'info' // 已跳过
      }
      return typeMap[status] || 'info'
    },

    /**
     * 获取处理状态图标
     * @param {number} status - 处理状态
     * @returns {string} - 图标类名
     */
    getProcessingIcon (status) {
      const iconMap = {
        1: 'el-icon-check',
        2: 'el-icon-close',
        3: 'el-icon-minus'
      }
      return iconMap[status] || 'el-icon-question'
    },

    /**
     * 获取处理状态文本
     * @param {number} status - 处理状态
     * @returns {string} - 状态文本
     */
    getProcessingText (status) {
      const textMap = {
        1: '成功',
        2: '失败',
        3: '已跳过'
      }
      return textMap[status] || '未知'
    },

    /**
     * 详情表格行样式类名
     * @param {Object} row - 行数据
     * @returns {string} - 样式类名
     */
    detailRowClassName ({ row }) {
      if (row.processing_status === 2) {
        return 'detail-row-failed'
      } else if (row.processing_status === 3) {
        return 'detail-row-skipped'
      }
      return 'detail-row-success'
    },

    /**
     * 解析Cron表达式为中文描述
     * @param {string} cronExpression - Cron表达式
     * @returns {string} - 中文描述
     */
    parseCronExpression (cronExpression) {
      try {
        if (!cronExpression) return '-'
        // cronstrue默认解析6位cron表达式（秒 分 时 日 月 周）
        return cronstrue.toString(cronExpression, { locale: 'zh_CN' })
      } catch (error) {
        console.error('解析Cron表达式失败:', error)
        return '无效的Cron表达式'
      }
    },

    /**
     * 复制Cron表达式
     */
    copyCronExpression () {
      if (this.formData.cronExpression) {
        this.$copyText(this.formData.cronExpression).then(() => {
          this.$message.success('Cron表达式已复制到剪贴板')
        }).catch(() => {
          this.$message.error('复制失败，请手动复制')
        })
      }
    },
    /**
     * 切换任务状态
     * @param {Object} row - 任务行数据
     */
    async toggleJobStatus (row) {
      const newStatus = row.status === 'running' ? 'stopped' : 'running'
      const actionText = newStatus === 'running' ? '启动' : '停止'
      
      try {
        await this.$confirm(`确定要${actionText}任务 "${row.jobName}" 吗？`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        })
        
        if (newStatus === 'stopped') {
          const res = await http('/cronJob/stopCronJob', { jobType: row.jobType })
          if (res && res.code === 1) {
            row.status = 'stopped'
            this.$message.success('停止成功')
          } else {
            this.$message.error('停止失败: ' + (res.message || '未知错误'))
          }
        } else {
          const res = await http('/cronJob/startCronJob', { jobType: row.jobType })
          if (res && res.code === 1) {
            row.status = 'running'
            this.$message.success('启动成功')
            this.getCronJobData()
          } else {
            this.$message.error('启动失败: ' + (res.message || '未知错误'))
          }
        }
      } catch (error) {
        if (error !== 'cancel') {
          this.$message.error('操作失败: ' + error.message)
        }
      }
    }
  }
}
</script>

<style scoped>
/* 容器基础样式 */
.cron-job-container {
  padding: 24px;
  max-width: 1920px;
  margin: 0 auto;
  background: linear-gradient(135deg, #f5f7fa 0%, #e4e8eb 100%);
  min-height: calc(100vh - 40px);
  border-radius: 8px;
}

/* 页面头部样式 */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 24px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  margin-bottom: 24px;
  box-shadow: 0 4px 20px rgba(102, 126, 234, 0.3);
}

.header-content {
  display: flex;
  align-items: center;
  gap: 16px;
}

.header-icon {
  width: 56px;
  height: 56px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 28px;
  color: #fff;
  backdrop-filter: blur(10px);
}

.header-text h1 {
  margin: 0 0 4px 0;
  font-size: 24px;
  font-weight: 600;
  color: #fff;
  letter-spacing: 1px;
}

.header-subtitle {
  margin: 0;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.85);
}

.header-actions {
  display: flex;
  gap: 12px;
}

.refresh-btn {
  background: rgba(255, 255, 255, 0.2);
  border: 1px solid rgba(255, 255, 255, 0.3);
  color: #fff;
  font-weight: 500;
  padding: 10px 20px;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.refresh-btn:hover {
  background: rgba(255, 255, 255, 0.3);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
}

/* 卡片样式 */
.cron-job-card {
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.cron-job-card:hover {
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px 20px;
  background: linear-gradient(135deg, #f8f9fc 0%, #f1f3f4 100%);
  border-bottom: 1px solid #ebeef5;
}

.card-title {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

.card-title i {
  color: #667eea;
  font-size: 20px;
}

.card-badge {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

/* 表格容器 */
.table-container {
  padding: 16px;
  background: #fff;
}

/* 表格样式 */
.custom-table {
  border-radius: 8px;
  overflow: hidden;
}

.custom-table::before {
  display: none;
}

.custom-table:hover {
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

/* 任务名称单元格 */
.job-name-cell {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 500;
  color: #303133;
}

.job-name-cell i {
  color: #667eea;
  font-size: 16px;
}

/* 描述文本 */
.description-text {
  color: #606266;
  font-size: 13px;
  line-height: 1.5;
}

/* Cron表达式样式 */
.cron-expression {
  font-family: 'SF Mono', 'Fira Code', monospace;
  background: linear-gradient(135deg, #f0f4ff 0%, #e8edff 100%);
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 12px;
  color: #667eea;
  font-weight: 500;
  letter-spacing: 0.5px;
}

/* Cron解析单元格 */
.cron-parse-cell {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 13px;
  color: #606266;
}

.cron-parse-cell i {
  color: #764ba2;
  font-size: 16px;
}

/* 状态标签 */
.status-tag {
  border-radius: 20px;
  font-weight: 500;
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

/* 时间单元格 */
.time-cell {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  font-size: 13px;
  color: #606266;
}

.time-cell i {
  color: #909399;
}

/* 操作按钮组 */
.action-buttons {
  display: flex;
  gap: 8px;
  justify-content: center;
}

.action-btn {
  border-radius: 6px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.action-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

/* 对话框样式 */
.cron-dialog {
  border-radius: 10px;
  overflow: hidden;
}

.cron-dialog >>> .el-dialog {
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
  max-height: 85vh;
  display: flex;
  flex-direction: column;
  margin: 20px auto;
}

.cron-dialog >>> .el-dialog__header {
  padding: 12px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  flex-shrink: 0;
  position: relative;
  min-height: 4px;
}

.cron-dialog >>> .el-dialog__title {
  color: #fff;
  font-weight: 600;
  font-size: 18px;
  display: block;
  padding-right: 4px;
}

.cron-dialog >>> .el-dialog__headerbtn {
  position: absolute;
  top: 50%;
  right: 16px;
  transform: translateY(-50%);
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cron-dialog >>> .el-dialog__headerbtn .el-dialog__close {
  color: #fff;
  font-size: 18px;
}

.cron-dialog >>> .el-dialog__headerbtn:hover .el-dialog__close {
  color: #f0f0f0;
}

.cron-dialog >>> .el-dialog__body {
  padding: 16px 20px;
  overflow-y: auto;
  flex: 1;
  min-height: 100px;
  max-height: calc(85vh - 120px);
  box-sizing: border-box;
}

.cron-dialog >>> .el-dialog__footer {
  padding: 12px 20px;
  background: linear-gradient(135deg, #f8f9fc 0%, #f1f3f4 100%);
  border-top: 1px solid #ebeef5;
  flex-shrink: 0;
}

/* 对话框头部 */
.dialog-header {
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 18px;
  background: linear-gradient(135deg, #f8f9fc 0%, #f1f3f4 100%);
  border-radius: 10px;
  margin-bottom: 16px;
}

.dialog-icon {
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: #fff;
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
}

.dialog-info h3 {
  margin: 0 0 4px 0;
  font-size: 18px;
  font-weight: 600;
  color: #303133;
}

.dialog-info p {
  margin: 0;
  font-size: 13px;
  color: #909399;
}

/* 表单样式 */
.cron-form {
  padding: 0;
}

.cron-form >>> .el-form-item {
  margin-bottom: 16px;
}

.cron-form >>> .el-form-item__label {
  padding: 0 0 8px 0;
  font-weight: 500;
  color: #303133;
}

.readonly-input {
  background: #f5f7fa;
  border-radius: 8px;
}

.readonly-input >>> .el-input__inner {
  background: #f5f7fa;
  color: #606266;
  font-weight: 500;
}

.input-icon {
  font-size: 16px;
  color: #667eea;
  margin-left: 4px;
}

/* 状态显示 */
.status-display {
  padding: 10px 16px;
  background: linear-gradient(135deg, #f0f4ff 0%, #e8edff 100%);
  border-radius: 8px;
  display: inline-flex;
  align-items: center;
  min-height: 40px;
}

.status-tag-large {
  border-radius: 20px;
  font-weight: 500;
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 14px;
}

/* 配置区块样式 */
.config-section {
  margin-bottom: 14px;
}

.section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 12px;
  padding-bottom: 10px;
  border-bottom: 2px solid #667eea;
}

.section-title i {
  color: #667eea;
  font-size: 16px;
}

/* Cron配置面板 */
.cron-config-panel {
  background: linear-gradient(135deg, #f8f9fc 0%, #f1f3f4 100%);
  border-radius: 10px;
  padding: 14px;
  border: 1px solid #ebeef5;
}

/* vue-cron组件样式 */
.vue-cron-wrapper {
  width: 100%;
}

.vue-cron-wrapper >>> .cron-container {
  background: transparent;
  border: none;
}

.vue-cron-wrapper >>> .el-select {
  border-radius: 8px;
}

.vue-cron-wrapper >>> .el-input-number {
  border-radius: 8px;
}

/* Cron结果输入框 */
.cron-result-input,
.cron-parse-result {
  border-radius: 8px;
  width: 100%;
}

.cron-result-input >>> .el-input__inner,
.cron-parse-result >>> .el-input__inner {
  font-family: 'SF Mono', 'Fira Code', monospace;
  font-size: 13px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.cron-result-full {
  width: 100%;
  margin-bottom: 16px;
}

.cron-result-full >>> .el-input {
  width: 100%;
}

.cron-result-full >>> .el-input__inner {
  min-width: 100%;
  width: 100%;
  font-size: 14px;
  padding-left: 36px;
}

.cron-parse-container {
  width: 100%;
}

.cron-parse-result {
  width: 100%;
}

.cron-parse-result >>> .el-input {
  width: 100%;
}

.cron-parse-result >>> .el-input__inner {
  min-width: 200px;
  max-width: 100%;
  width: 100%;
}

.parse-hint {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
  text-align: left;
}

.copy-btn {
  color: #909399;
  transition: color 0.3s ease;
  padding: 0 8px;
}

.copy-btn:hover {
  color: #667eea;
}

/* 描述输入框 */
.description-input {
  border-radius: 8px;
}

/* 结果行样式 */
.result-row {
  margin-top: 4px;
}

/* 对话框底部 */
.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 12px;
  padding: 12px 20px;
  background: linear-gradient(135deg, #f8f9fc 0%, #f1f3f4 100%);
  border-top: 1px solid #ebeef5;
}

.cancel-btn {
  border-radius: 8px;
  padding: 8px 16px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.cancel-btn:hover {
  background: #f5f7fa;
  border-color: #dcdfe6;
}

.save-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  border-radius: 8px;
  padding: 8px 20px;
  font-weight: 500;
  transition: all 0.3s ease;
}

.save-btn:hover {
  background: linear-gradient(135deg, #5a6fd6 0%, #6a4190 100%);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

/* 响应式布局 - 对话框专用 */
@media screen and (max-width: 1920px) {
  .cron-job-container {
    padding: 16px;
  }

  .page-header {
    padding: 16px 20px;
  }

  .header-text h1 {
    font-size: 20px;
  }

  .cron-dialog >>> .el-dialog {
    width: 85%;
    max-width: 850px;
  }
}

@media screen and (max-width: 1200px) {
  .cron-dialog >>> .el-dialog {
    width: 90%;
    max-width: 700px;
  }
}

@media screen and (max-width: 992px) {
  .cron-dialog >>> .el-dialog {
    width: 95%;
    max-width: 600px;
  }

  .dialog-header {
    padding: 16px;
    flex-direction: column;
    text-align: center;
  }

  .dialog-info h3 {
    font-size: 16px;
  }
}

@media screen and (max-width: 768px) {
  .page-header {
    flex-direction: column;
    gap: 16px;
    text-align: center;
  }

  .header-content {
    flex-direction: column;
  }

  .header-actions {
    width: 100%;
    justify-content: center;
  }

  .action-buttons {
    flex-wrap: wrap;
  }

  .cron-dialog >>> .el-dialog {
    width: 98%;
    max-width: 500px;
    margin: 10px auto;
  }

  .cron-dialog >>> .el-dialog__body {
    padding: 16px;
  }
}

@media screen and (max-width: 480px) {
  .dialog-footer {
    flex-direction: column;
    gap: 8px;
    padding: 12px 16px;
  }

  .cancel-btn,
  .save-btn {
    width: 100%;
    justify-content: center;
  }
}

/* 表格动画效果 */
.custom-table >>> .el-table__row {
  transition: all 0.3s ease;
}

.custom-table >>> .el-table__row:hover {
  background: #f0f4ff !important;
}

/* 标签动画 */
.status-tag {
  animation: slideIn 0.3s ease;
}

@keyframes slideIn {
  from { opacity: 0; transform: scale(0.9); }
  to { opacity: 1; transform: scale(1); }
}

/* 按钮动画 */
.action-btn {
  position: relative;
  overflow: hidden;
}

.action-btn::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: width 0.3s, height 0.3s;
}

.action-btn:active::after {
  width: 200%;
  height: 200%;
}

/* 卡片操作区域 */
.card-actions {
  display: flex;
  gap: 8px;
}

/* 成功和失败文本颜色 */
.success-text {
  color: #67c23a;
  font-weight: 500;
}

.failed-text {
  color: #f56c6c;
  font-weight: 500;
}

/* 执行日志表格样式 */
.execution-logs-table {
  margin-top: 16px;
}

/* 统计对话框样式 */
.stat-item {
  text-align: center;
  padding: 20px;
  background: linear-gradient(135deg, #f8f9fc 0%, #f1f3f4 100%);
  border-radius: 12px;
  transition: all 0.3s ease;
}

.stat-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
}

.stat-item.success {
  background: linear-gradient(135deg, #f0f9eb 0%, #e1f3d8 100%);
}

.stat-item.danger {
  background: linear-gradient(135deg, #fef0f0 0%, #fde2e2 100%);
}

.stat-value {
  font-size: 32px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 8px;
}

.stat-item.success .stat-value {
  color: #67c23a;
}

.stat-item.danger .stat-value {
  color: #f56c6c;
}

.stat-label {
  font-size: 14px;
  color: #909399;
}

/* 详情对话框样式 */
.detail-dialog >>> .el-dialog__body {
  padding: 20px;
}

.statistics-dialog >>> .el-dialog__body {
  padding: 30px;
}

/* 任务名称图标颜色 */
.job-name-cell i {
  margin-right: 6px;
}

/* Cron行样式 */
.cron-row {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 5px;
}

/* Cron标签样式 */
.cron-label {
  font-weight: bold;
  min-width: 30px;
}

/* 卡片样式优化 */
.cron-job-card {
  margin-bottom: 20px;
}

/* 执行详情表格样式 */
.detail-info {
  margin-bottom: 16px;
  padding: 10px 16px;
  background: #f5f7fa;
  border-radius: 8px;
  border-left: 4px solid #409eff;
}

.detail-count {
  font-size: 14px;
  color: #606266;
  font-weight: 500;
}

.detail-table {
  border-radius: 8px;
  overflow: hidden;
}

.detail-table >>> .el-table__header th {
  background: #409eff;
  color: #fff;
  font-weight: 600;
  border-bottom: none !important;
}

.detail-table >>> .el-table__row {
  transition: all 0.3s ease;
}

.detail-table >>> .el-table__row:hover {
  background: #f0f4ff !important;
}

/* 成功行样式 */
.detail-row-success {
  background: #f0f9eb !important;
}

.detail-row-success:hover {
  background: #e1f3d8 !important;
}

/* 失败行样式 */
.detail-row-failed {
  background: #fef0f0 !important;
}

.detail-row-failed:hover {
  background: #fde2e2 !important;
}

/* 跳过行样式 */
.detail-row-skipped {
  background: #f4f4f5 !important;
}

.detail-row-skipped:hover {
  background: #e9e9eb !important;
}

/* 用户单元格样式 */
.user-cell {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}

.user-icon {
  font-size: 18px;
  color: #909399;
}

.user-icon.duty-1 {
  color: #e6a23c;
}

.user-icon.duty-2 {
  color: #67c23a;
}

.user-icon.duty-3 {
  color: #409eff;
}

/* 职务级别标签样式 */
.duty-tag {
  font-weight: 500;
  border-radius: 4px;
}

/* 维度情况单元格样式 */
.dimension-cell {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  font-family: 'SF Mono', 'Fira Code', monospace;
}

.dim-badge {
  display: inline-block;
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 600;
  min-width: 24px;
  text-align: center;
  background: #f56c6c;
  color: #fff;
}

.dim-badge.dim-zero {
  background: #909399;
}

.dim-badge.all-generated {
  background: #67c23a;
}

.dim-separator {
  color: #909399;
  font-size: 14px;
}

/* 处理状态标签样式 */
.status-tag {
  font-weight: 500;
  border-radius: 4px;
}

/* 错误信息样式 */
.error-text {
  color: #f56c6c;
  display: flex;
  align-items: center;
  gap: 4px;
}

.error-text i {
  font-size: 14px;
}

/* 详情表格动画 */
.detail-table >>> .el-table__row {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateX(-10px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

/* 基本信息区域样式 */
.basic-info-section {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 16px;
  margin-bottom: 20px;
}

.basic-info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: #fff;
  border-radius: 6px;
  min-height: 40px;
}

.basic-info-item.full-width {
  width: 100%;
}

.info-label {
  font-weight: 500;
  color: #606266;
  white-space: nowrap;
  font-size: 13px;
}

.info-value {
  color: #303133;
  font-size: 13px;
}

/* 互评填充任务详情样式 */
.mutual-rate-details {
  background: linear-gradient(135deg, #fff9f0 0%, #fff5f5 100%);
  border-radius: 12px;
  padding: 20px;
  border: 1px solid #ffcd56;
}

.mutual-rate-details .details-header {
  display: flex;
  align-items: center;
  gap: 10px;
  font-size: 16px;
  font-weight: 600;
  color: #e6a23c;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 2px solid #e6a23c;
}

.mutual-rate-details .details-header i {
  font-size: 20px;
}

.rate-info-row {
  margin-bottom: 20px;
}

.rate-info-card {
  background: #fff;
  border-radius: 8px;
  padding: 16px;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.rate-info-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.rate-info-label {
  font-size: 12px;
  color: #909399;
  margin-bottom: 8px;
  font-weight: 500;
}

.rate-info-value {
  font-size: 16px;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 4px;
}

.rate-month {
  color: #e6a23c;
  background: #fdf6ec;
}

.rate-users {
  color: #f56c6c;
  background: #fef0f0;
}

.rate-records {
  color: #67c23a;
  background: #f0f9eb;
}

.users-section {
  margin-bottom: 20px;
}

.users-section .section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 1px solid #e6a23c;
}

.users-section .section-title i {
  color: #e6a23c;
  font-size: 16px;
}

.users-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  padding: 12px;
  background: #fff;
  border-radius: 8px;
  border: 1px solid #ebeef5;
}

.users-tags .user-tag {
  border-radius: 16px;
  padding: 4px 12px;
  font-weight: 500;
}

.no-data-section {
  margin: 20px 0;
}

.no-data-content {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  padding: 20px;
  background: linear-gradient(135deg, #f0f9eb 0%, #e1f3d8 100%);
  border-radius: 8px;
  color: #67c23a;
  font-size: 14px;
  font-weight: 500;
}

.no-data-content i {
  font-size: 20px;
}

.records-section {
  margin-top: 20px;
}

.records-section .section-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #303133;
  margin-bottom: 12px;
  padding-bottom: 8px;
  border-bottom: 1px solid #67c23a;
}

.records-section .section-title i {
  color: #67c23a;
  font-size: 16px;
}

.fill-records-table {
  border-radius: 8px;
  overflow: hidden;
}

.fill-records-table >>> .el-table__header th {
  background: #67c23a;
  color: #fff;
  font-weight: 600;
  border-bottom: none !important;
}

.fill-records-table >>> .el-table__row {
  transition: all 0.3s ease;
}

.fill-records-table >>> .el-table__row:hover {
  background: #f0f9eb !important;
}

.fill-records-table >>> .el-table__row:nth-child(even) {
  background: #fafafa;
}

.records-tip {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: #ecf5ff;
  border-radius: 6px;
  color: #409eff;
  font-size: 13px;
  margin-bottom: 12px;
}

.records-tip i {
  font-size: 16px;
}

.execution-result-section {
  background: #f5f7fa;
  border-radius: 8px;
  padding: 16px;
  margin-top: 20px;
}

.execution-result-section .details-header {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  font-weight: 600;
  color: #606266;
  margin-bottom: 12px;
}

.execution-result-section .details-header i {
  color: #909399;
  font-size: 16px;
}

.no-result {
  color: #909399;
  font-style: italic;
}
</style>

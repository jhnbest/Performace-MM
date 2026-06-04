<template>
  <div class="work-hour-statistics">
    <el-card class="filter-card">
      <div class="filter-row">
        <span class="filter-label">月份范围：</span>
        <el-date-picker
          v-model="startMonth"
          type="month"
          placeholder="开始月份"
          value-format="yyyy-MM"
          :picker-options="startMonthOptions"
          style="width: 160px">
        </el-date-picker>
        <span class="filter-separator">至</span>
        <el-date-picker
          v-model="endMonth"
          type="month"
          placeholder="结束月份"
          value-format="yyyy-MM"
          :picker-options="endMonthOptions"
          style="width: 160px">
        </el-date-picker>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch" :loading="loading">查询</el-button>
        <el-button type="success" icon="el-icon-download" @click="handleExportEmployeeRank" :disabled="!employeeByGroup.length">导出员工工时排名</el-button>
        <el-button type="success" icon="el-icon-download" @click="handleExportPersonBreakdown" :disabled="!displayPersonTypeData.length">导出个人工时占比</el-button>
      </div>
    </el-card>

    <!-- 员工工时排名（按组分列，组内按工时降序） -->
    <el-card class="table-card" v-if="employeeByGroup.length">
      <div slot="header" class="card-header">
        <div class="header-row">
          <span>员工工时排名</span>
          <el-button v-if="filteredIdValue.length > 0" type="text" size="small" icon="el-icon-close" @click="filteredIdValue = []">清除筛选({{ filteredIdValue.length }})</el-button>
        </div>
      </div>
      <el-table :data="employeeByGroup" border stripe style="width: 100%" :row-class-name="rankTableRowClass">
        <el-table-column label="排名" width="50" align="center">
          <template slot-scope="scope">
            {{ scope.$index + 1 }}
          </template>
        </el-table-column>
        <el-table-column label="多媒体应用组" min-width="140">
          <template slot-scope="scope">
            <span v-if="scope.row['多媒体应用组']" class="employee-id-link" :class="{ 'is-active': isIdActive(scope.row['多媒体应用组'].userId) }" @click="filterById(scope.row['多媒体应用组'].userId)">
              {{ scope.row['多媒体应用组'].userId }}：<strong>{{ scope.row['多媒体应用组'].totalWorkTime.toFixed(1) }}h</strong>
            </span>
          </template>
        </el-table-column>
        <el-table-column label="通信组" min-width="120">
          <template slot-scope="scope">
            <span v-if="scope.row['通信组']" class="employee-id-link" :class="{ 'is-active': isIdActive(scope.row['通信组'].userId) }" @click="filterById(scope.row['通信组'].userId)">
              {{ scope.row['通信组'].userId }}：<strong>{{ scope.row['通信组'].totalWorkTime.toFixed(1) }}h</strong>
            </span>
          </template>
        </el-table-column>
        <el-table-column label="综合业务组" min-width="140">
          <template slot-scope="scope">
            <span v-if="scope.row['综合业务组']" class="employee-id-link" :class="{ 'is-active': isIdActive(scope.row['综合业务组'].userId) }" @click="filterById(scope.row['综合业务组'].userId)">
              {{ scope.row['综合业务组'].userId }}：<strong>{{ scope.row['综合业务组'].totalWorkTime.toFixed(1) }}h</strong>
            </span>
          </template>
        </el-table-column>
        <el-table-column label="数字物联组" min-width="130">
          <template slot-scope="scope">
            <span v-if="scope.row['数字物联组']" class="employee-id-link" :class="{ 'is-active': isIdActive(scope.row['数字物联组'].userId) }" @click="filterById(scope.row['数字物联组'].userId)">
              {{ scope.row['数字物联组'].userId }}：<strong>{{ scope.row['数字物联组'].totalWorkTime.toFixed(1) }}h</strong>
            </span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <!-- 个人工时种类占比 -->
    <el-card class="table-card" v-if="rawPersonTypeData.length">
      <div slot="header" class="card-header">
        <div class="header-row">
          <span>个人工时种类占比</span>
          <el-radio-group v-model="detailMode" size="small">
            <el-radio-button label="parent">大类</el-radio-button>
            <el-radio-button label="child">小类</el-radio-button>
          </el-radio-group>
        </div>
      </div>
      <el-table
        ref="personTable"
        :data="displayPersonTypeData"
        border stripe
        style="width: 100%"
        row-key="userId"
        @filter-change="handleTableFilterChange">
        <el-table-column label="序号" type="index" width="50" align="center" fixed></el-table-column>
        <!-- 工号：表头多选过滤 -->
        <el-table-column
          prop="userId"
          label="工号"
          width="80"
          fixed
          column-key="userId"
          :filters="idFilterOptions"
          :filter-multiple="true"
          :filtered-value="filteredIdValue"
          filter-placement="bottom">
        </el-table-column>
        <!-- 所属组：表头多选过滤 -->
        <el-table-column
          prop="groupName"
          label="所属组"
          width="130"
          column-key="groupName"
          :filters="groupFilterOptions"
          :filter-multiple="true"
          :filtered-value="filteredGroupValue"
          filter-placement="bottom">
        </el-table-column>
        <el-table-column prop="totalWorkTime" label="总工时" width="100">
          <template slot-scope="scope">
            <strong>{{ scope.row.totalWorkTime.toFixed(1) }}</strong>
          </template>
        </el-table-column>
        <el-table-column label="工时种类明细" min-width="400">
          <template slot-scope="scope">
            <div class="breakdown-bar-wrap">
              <div class="breakdown-bar" v-for="(item, idx) in scope.row.typeBreakdown" :key="item.projectTypeName">
                <div class="bar-label">
                  <span class="bar-index">{{ idx + 1 }}.</span>
                  <span class="bar-name">{{ item.projectTypeName }}</span>
                  <span class="bar-value">{{ item.workTime.toFixed(1) }}h（{{ item.ratio }}）</span>
                </div>
                <el-tooltip v-if="item.projectNames" effect="dark" :content="item.projectNames" placement="top">
                  <div class="bar-track has-project-names">
                    <div class="bar-fill" :style="barFillStyle(item.ratio, idx)"></div>
                  </div>
                </el-tooltip>
                <div v-else class="bar-track">
                  <div class="bar-fill" :style="barFillStyle(item.ratio, idx)"></div>
                </div>
              </div>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </el-card>

    <div class="empty-placeholder" v-if="!loading && !rawPersonTypeData.length">
      <i class="el-icon-document" style="font-size: 60px; color: #c0c4cc"></i>
      <p style="color: #909399; margin-top: 10px">请选择月份范围后查询</p>
    </div>
  </div>
</template>

<script>
import { urlGetWorkHourStatistics } from '@/config/interface'

export default {
  name: 'WorkHourStatistics',
  data () {
    return {
      startMonth: '',
      endMonth: '',
      rawPersonTypeData: [],
      loading: false,
      barColors: ['#409EFF', '#67C23A', '#E6A23C', '#F56C6C', '#909399', '#00D4FF', '#FF6EB4', '#B37FEB'],
      detailMode: 'child',
      filteredGroupValue: [],
      filteredIdValue: [],
      groupFilterOptions: [
        { text: '多媒体应用组', value: '多媒体应用组' },
        { text: '通信组', value: '通信组' },
        { text: '综合业务组', value: '综合业务组' },
        { text: '数字物联组', value: '数字物联组' }
      ]
    }
  },
  computed: {
    startMonthOptions () {
      return {
        disabledDate: (time) => {
          if (this.endMonth) {
            return time.getTime() > new Date(this.endMonth + '-01').getTime()
          }
          return false
        }
      }
    },
    endMonthOptions () {
      return {
        disabledDate: (time) => {
          if (this.startMonth) {
            return time.getTime() < new Date(this.startMonth + '-01').getTime()
          }
          return false
        }
      }
    },
    // 员工按组分列排名矩阵（组内按工时降序）
    employeeByGroup () {
      if (!this.rawPersonTypeData.length) return []
      let groups = { '多媒体应用组': [], '通信组': [], '综合业务组': [], '数字物联组': [] }
      let seen = {}
      this.rawPersonTypeData.forEach(p => {
        if (!seen[p.userId]) {
          seen[p.userId] = true
          if (groups[p.groupName]) {
            groups[p.groupName].push({ userId: p.userId, userName: p.userName, totalWorkTime: p.totalWorkTime, groupName: p.groupName })
          }
        }
      })
      Object.keys(groups).forEach(key => {
        groups[key].sort((a, b) => b.totalWorkTime - a.totalWorkTime)
      })
      let maxLen = Math.max(...Object.values(groups).map(arr => arr.length))
      let rows = []
      for (let i = 0; i < maxLen; i++) {
        let row = {}
        Object.keys(groups).forEach(key => {
          row[key] = groups[key][i] || null
        })
        rows.push(row)
      }
      return rows
    },
    // 从原始数据中提取去重工号，生成过滤器选项
    idFilterOptions () {
      if (!this.rawPersonTypeData.length) return []
      let idSet = {}
      this.rawPersonTypeData.forEach(p => {
        if (!idSet[p.userId]) {
          idSet[p.userId] = true
        }
      })
      return Object.keys(idSet).sort((a, b) => a - b).map(id => ({ text: id, value: id }))
    },
    // 根据筛选条件和展示模式计算最终显示数据
    displayPersonTypeData () {
      let list = this.rawPersonTypeData
      // 应用工号过滤
      if (this.filteredIdValue.length > 0) {
        list = list.filter(p => this.filteredIdValue.includes(p.userId))
      }
      // 应用所属组过滤
      if (this.filteredGroupValue.length > 0) {
        list = list.filter(p => this.filteredGroupValue.includes(p.groupName))
      }
      if (this.detailMode === 'child') {
        return list
      }
      // 大类模式：按 parentTypeName 合并同类目
      return list.map(person => {
        let parentMap = {}
        let totalWorkTime = 0
        person.typeBreakdown.forEach(item => {
          let parentName = item.parentTypeName || item.projectTypeName
          let workTime = item.workTime
          totalWorkTime += workTime
          if (!parentMap[parentName]) {
            parentMap[parentName] = {
              projectTypeName: parentName,
              parentTypeName: parentName,
              workTime: 0,
              projectNamesList: []
            }
          }
          parentMap[parentName].workTime += workTime
          if (item.projectNames) {
            parentMap[parentName].projectNamesList.push(item.projectNames)
          }
        })
        let typeBreakdown = Object.values(parentMap).map(item => {
          return {
            projectTypeName: item.projectTypeName,
            parentTypeName: item.parentTypeName,
            workTime: item.workTime,
            projectNames: item.projectNamesList.length ? item.projectNamesList.join('；') : '',
            ratio: totalWorkTime > 0 ? ((item.workTime / totalWorkTime) * 100).toFixed(1) + '%' : '0.0%'
          }
        })
        typeBreakdown.sort((a, b) => b.workTime - a.workTime)
        return {
          userId: person.userId,
          userName: person.userName,
          groupName: person.groupName,
          totalWorkTime: totalWorkTime,
          typeBreakdown: typeBreakdown
        }
      })
    }
  },
  methods: {
    // 查询工时统计数据
    handleSearch () {
      if (!this.startMonth || !this.endMonth) {
        this.$common.toast('请选择开始月份和结束月份', 'warning', false)
        return
      }
      this.loading = true
      let params = {
        startMonth: this.startMonth,
        endMonth: this.endMonth
      }
      this.$http(urlGetWorkHourStatistics, params).then(res => {
        if (res.code === 1) {
          this.rawPersonTypeData = res.data.personTypeBreakdown || []
          this.filteredGroupValue = []
          this.filteredIdValue = []
          if (!this.rawPersonTypeData.length) {
            this.$common.toast('所选时间范围内无数据', 'info', false)
          }
        } else {
          this.$common.toast('查询失败：' + (res.message || '未知错误'), 'error', false)
        }
        this.loading = false
      }).catch(() => {
        this.$common.toast('请求失败，请稍后重试', 'error', false)
        this.loading = false
      })
    },
    // 同步表头多选过滤值（工号 + 所属组）
    handleTableFilterChange (filters) {
      this.filteredGroupValue = filters.groupName || []
      this.filteredIdValue = filters.userId || []
    },
    // 点击排名表员工工号 → 切换筛选（支持多选）
    filterById (userId) {
      let idx = this.filteredIdValue.indexOf(userId)
      if (idx >= 0) {
        this.filteredIdValue.splice(idx, 1)
      } else {
        this.filteredIdValue.push(userId)
      }
    },
    // 判断指定工号是否处于激活筛选状态
    isIdActive (userId) {
      return this.filteredIdValue.includes(userId)
    },
    // 排名表行样式：有选中员工的加高亮
    rankTableRowClass ({ row }) {
      const groups = ['多媒体应用组', '通信组', '综合业务组', '数字物联组']
      for (let g of groups) {
        if (row[g] && this.isIdActive(row[g].userId)) {
          return 'rank-row-active'
        }
      }
      return ''
    },
    // 导出员工工时排名为CSV（按组分列）
    handleExportEmployeeRank () {
      let data = this.employeeByGroup
      if (!data.length) return
      const headers = ['排名', '多媒体应用组-工号', '多媒体应用组-工时', '通信组-工号', '通信组-工时', '综合业务组-工号', '综合业务组-工时', '数字物联组-工号', '数字物联组-工时']
      let csvContent = '\uFEFF' + headers.join(',') + '\n'
      data.forEach((row, idx) => {
        const groups = ['多媒体应用组', '通信组', '综合业务组', '数字物联组']
        let vals = [idx + 1]
        groups.forEach(g => {
          vals.push(row[g] ? row[g].userId : '')
          vals.push(row[g] ? row[g].totalWorkTime.toFixed(1) : '')
        })
        csvContent += vals.join(',') + '\n'
      })
      this.downloadCSV(csvContent, '员工工时排名.csv')
      this.$common.toast('导出成功', 'success', false)
    },
    // 导出个人工时占比为CSV
    handleExportPersonBreakdown () {
      let data = this.displayPersonTypeData
      if (!data.length) return
      const headers = ['工号', '所属组', '总工时', '项目类型', '工时', '占比']
      let csvContent = '\uFEFF' + headers.join(',') + '\n'
      data.forEach(person => {
        person.typeBreakdown.forEach(item => {
          const values = [
            person.userId,
            person.groupName,
            person.totalWorkTime.toFixed(1),
            item.projectTypeName.replace(/,/g, '，'),
            item.workTime.toFixed(1),
            item.ratio
          ]
          csvContent += values.join(',') + '\n'
        })
      })
      this.downloadCSV(csvContent, '个人工时种类占比.csv')
      this.$common.toast('导出成功', 'success', false)
    },
    // 触发CSV文件下载
    downloadCSV (content, fileName) {
      const blob = new Blob([content], { type: 'text/csv;charset=utf-8;' })
      const link = document.createElement('a')
      const url = URL.createObjectURL(blob)
      link.href = url
      link.download = fileName
      link.style.display = 'none'
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      URL.revokeObjectURL(url)
    },
    // 进度条填充样式（按比例和颜色索引）
    barFillStyle (ratio, idx) {
      return {
        width: ratio,
        'background-color': this.barColors[idx % this.barColors.length]
      }
    }
  }
}
</script>

<style scoped lang="scss">
.work-hour-statistics {
  padding: 20px;
  .filter-card {
    margin-bottom: 20px;
    .filter-row {
      display: flex;
      align-items: center;
      flex-wrap: wrap;
      gap: 10px;
      .filter-label {
        font-weight: bold;
        font-size: 14px;
      }
      .filter-separator {
        margin: 0 5px;
      }
    }
  }
  .table-card {
    margin-bottom: 20px;
    .card-header {
      font-weight: bold;
      font-size: 16px;
    }
    .header-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .breakdown-bar-wrap {
      padding: 4px 0;
      .breakdown-bar {
        margin-bottom: 6px;
        &:last-child { margin-bottom: 0; }
        .bar-label {
          display: flex;
          align-items: center;
          font-size: 12px;
          margin-bottom: 2px;
          .bar-name {
            color: #303133;
            font-weight: 500;
            flex: 1;
          }
          .bar-index {
            color: #909399;
            font-size: 12px;
            min-width: 18px;
          }
          .bar-value {
            color: #909399;
            white-space: nowrap;
          }
        }
        .bar-track {
          height: 10px;
          background: #ebeef5;
          border-radius: 5px;
          overflow: hidden;
          cursor: default;
          &.has-project-names {
            cursor: pointer;
          }
          .bar-fill {
            height: 100%;
            border-radius: 5px;
            min-width: 2px;
            transition: width 0.3s ease;
          }
        }
      }
    }
  }
  .empty-placeholder {
    text-align: center;
    padding: 60px 0;
  }
  .employee-id-link {
    cursor: pointer;
    color: #409EFF;
    &:hover {
      text-decoration: underline;
    }
    &.is-active {
      font-weight: bold;
      strong { color: #E6A23C; }
    }
  }
}
.el-table .rank-row-active {
  background-color: #ecf5ff !important;
}
</style>

<template>
<div>
  <el-form class="main-search" :inline="true">
    <el-row type="flex">
      <el-col :xs="12" :sm="12" :lg="{span: 5, offset: 7 }" :xl="{span: 4, offset: 9 }">
        <div style="margin-top: 5px;text-align: center;font-size: 25px;font-weight: bolder">
          <span>{{title}}</span>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="{span: 7, offset: 5 }" :xl="{span: 6, offset: 7 }">
        <el-button type="primary" @click="handleSubmit" :disabled="isSubmit" size="medium">提交</el-button>
        <el-button type="warning" @click="handleTemporary" size="medium">暂存</el-button>
        <el-button type="success" :disabled="!isSubmit" @click="updateData" size="medium">更新</el-button>
        <el-button type="danger" @click="handleBack" size="medium">返回</el-button>
      </el-col>
    </el-row>
  </el-form>
  <br>
  <!-- 分割线 start -->
  <div class="hr-10"></div>
  <!-- 分割线 end -->
  <br>
  <el-form :inline="true">
    <el-table :data="tableData1"
              border
              stripe
              size="medium"
              style="margin: auto;width: 99%"
              :header-cell-style="{background:'#ced1d4',color:'#000000',fontSize:'18px'}">
      <el-table-column label="在本月所完成工作的回顾及客观评价（含工作内容、进展与成效、不足与改进意见、工作成果评价、未完成的工作内容及原因分析等）"
                       align="center">
        <template>
          <editor-vue :value="conclusionText.curConclusion"
                      @input="(res)=> conclusionText.curConclusion = res"></editor-vue>
        </template>
      </el-table-column>
    </el-table>
    <el-table :data="tableData2"
              border
              stripe
              size="medium"
              :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'18px' }"
              style="margin: auto;width: 99%"
              highlight-current-row>
      <el-table-column label="下一个月的工作目标、工作计划/工作安排、工作内容"
                       align="center">
        <template>
          <editor-vue :value="conclusionText.nextPlan"
                      @input="(res)=> conclusionText.nextPlan = res"></editor-vue>
        </template>
      </el-table-column>
    </el-table>
    <el-table :data="tableData3"
              border
              stripe
              size="medium"
              :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'18px' }"
              style="margin: auto;width: 99%"
              highlight-current-row>
      <el-table-column label="为更好地完成本职工作和团队目标，在下一阶段需要努力和改善的绩效，直接主管的期望、建议、措施等。"
                       align="center">
        <template>
          <editor-vue :value="conclusionText.curAdvice"
                      @input="(res)=> conclusionText.curAdvice = res"></editor-vue>
        </template>
      </el-table-column>
    </el-table>
  </el-form>
</div>
</template>

<script>
  import editorVue from '../../../components/monthConclusion/editor'
  import { submitMonthConclusionData } from '@/utils/conclusion'
  export default {
    data () {
      return {
        title: '',
        tableData1: [{}],
        tableData2: [{}],
        tableData3: [{}],
        submitYear: null,
        submitMonth: null,
        submitter: null,
        reqFlag: {
          getTableData: true
        },
        conclusionText: {
          curConclusion: '',
          nextPlan: '',
          curAdvice: ''
        },
        isSubmit: false
      }
    },
    methods: {
      // 初始化
      init () {
        this.title = this.$route.query.title
        this.submitYear = this.$route.query.submitYear
        this.submitMonth = this.$route.query.submitMonth
        this.submitter = this.$route.query.submitter
      },
      // 提交月总结
      handleSubmit () {
        let submitStatus = 1
        submitMonthConclusionData(this.submitYear, this.submitMonth, this.submitter, this.title, submitStatus,
          this.conclusionText.curConclusion, this.conclusionText.nextPlan, this.conclusionText.curAdvice).then(() => {
            this.$common.toast('提交成功', 'success', false)
        }).catch(() => {
          this.$common.toast('提交失败', 'error', false)
        })
      },
      // 暂存月总结
      handleTemporary () {
      },
      // 更新月总结
      updateData () {
      },
      // 返回
      handleBack () {
        this.$router.push({
          path: '/home/monthConclusion'
        })
      }
    },
    filters: {
      submitStatusFilter (status) {
        if (status === 2) {
          return 'success'
        } else if (status === 1) {
          return 'warning'
        } else if (status === 0) {
          return 'info'
        }
      },
      submitStatusTextFilter (status) {
        if (status === 2) {
          return '已提交'
        } else if (status === 1) {
          return '暂存'
        } else if (status === 0) {
          return '未提交'
        }
      },
      reviewStatusFilter (status) {
        switch (status) {
          case 0:
            return 'info'
          case 1:
            return 'success'
          case 2:
            return 'danger'
          default:
            return 'danger'
        }
      },
      reviewStatusTextFilter (status) {
        switch (status) {
          case 0:
            return '未审核'
          case 1:
            return '已通过'
          case 2:
            return '驳回'
          default:
            return '错误'
        }
      }
    },
    components: {
      editorVue
    },
    created () {
      this.init()
    },
    watch: {
    },
    mounted () {
    },
    name: 'multualEvaluation'
  }
</script>

<style scoped>
</style>

<template>
<div>
  <el-form class="main-search" :inline="true">
    <el-row type="flex">
      <el-col :xs="12" :sm="12" :lg="{span: 6, offset: 9 }" :xl="{span: 6, offset: 10 }">
        <div style="margin-top: 5px;text-align: center;font-size: 25px;font-weight: bolder">
          <span>{{conclusionTitle}}</span>
        </div>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="{span: 6, offset: 5 }" :xl="{span: 6, offset: 7 }">
        <el-button type="primary" @click="handleSubmit" :disabled="isSubmit" size="medium">提交</el-button>
        <el-button type="warning" @click="handleTemporary" size="medium">暂存</el-button>
        <el-button type="danger" @click="handleBack" size="medium">返回</el-button>
      </el-col>
    </el-row>
  </el-form>
  <br>
  <div class="hr-10"></div>
  <br>
  <el-form :inline="true">
    <el-table :data="tableData1"
              border
              stripe
              size="mini"
              style="margin: auto;width: 100%"
              :header-cell-style="{background:'#00c0d1',color:'#000000',fontSize:'18px'}">
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
              :header-cell-style="{ background:'#00c0d1',color:'#000000',fontSize:'18px' }"
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
              :header-cell-style="{ background:'#00c0d1',color:'#000000',fontSize:'18px' }"
              style="margin: auto;width: 99%"
              highlight-current-row>
      <el-table-column label="对处室工作的意见/建议、不满/抱怨、工作/生活/学习中的烦恼和困难以及希望得到的帮助/支持/指导"
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
  import {
    submitMonthConclusionData,
    updateMonthConclusionData } from '@/utils/conclusion'
  export default {
    data () {
      return {
        conclusionTitle: '',
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
        isSubmit: false,
        id: null
      }
    },
    methods: {
      // 初始化
      init () {
        this.id = this.$route.query.id
        this.submitYear = this.$route.query.submitYear
        this.conclusionTitle = this.submitYear + '年' + this.$route.query.conclusionTitle
        this.submitMonth = this.$route.query.submitMonth
        this.submitter = this.$route.query.submitter
        this.conclusionText.curConclusion = this.$route.query.curConclusion
        this.conclusionText.nextPlan = this.$route.query.nextPlan
        this.conclusionText.curAdvice = this.$route.query.curAdvice
      },
      // 提交月总结
      handleSubmit () {
        let submitStatus = 1
        if (this.id !== null) {
          updateMonthConclusionData(this.id, this.submitYear, this.submitMonth, this.submitter, this.conclusionTitle, submitStatus,
            this.conclusionText.curConclusion, this.conclusionText.nextPlan, this.conclusionText.curAdvice).then(() => {
            this.$common.toast('提交成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch((updateMonthConclusionDataErr) => {
            this.$common.toast('提交失败 ' + updateMonthConclusionDataErr, 'error', false)
          })
        } else {
          submitMonthConclusionData(this.submitYear, this.submitMonth, this.submitter, this.conclusionTitle, submitStatus,
            this.conclusionText.curConclusion, this.conclusionText.nextPlan, this.conclusionText.curAdvice).then(() => {
            this.$common.toast('提交成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch((submitMonthConclusionDataErr) => {
            this.$common.toast('提交失败 ' + submitMonthConclusionDataErr, 'error', false)
          })
        }
      },
      // 暂存月总结
      handleTemporary () {
        let submitStatus = 2
        if (this.id !== null) {
          updateMonthConclusionData(this.id, this.submitYear, this.submitMonth, this.submitter, this.conclusionTitle, submitStatus,
            this.conclusionText.curConclusion, this.conclusionText.nextPlan, this.conclusionText.curAdvice).then(() => {
            this.$common.toast('暂存成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch((updateMonthConclusionDataErr) => {
            this.$common.toast('暂存失败 ' + updateMonthConclusionDataErr, 'error', true)
          })
        } else {
          submitMonthConclusionData(this.submitYear, this.submitMonth, this.submitter, this.conclusionTitle, submitStatus,
            this.conclusionText.curConclusion, this.conclusionText.nextPlan, this.conclusionText.curAdvice).then(() => {
            this.$common.toast('暂存成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch((submitMonthConclusionDataErr) => {
            this.$common.toast('暂存失败 ' + submitMonthConclusionDataErr, 'error', true)
          })
        }
      },
      // 返回
      handleBack () {
        this.$router.push({
          path: '/home/monthConclusion'
        })
      }
    },
    filters: {
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

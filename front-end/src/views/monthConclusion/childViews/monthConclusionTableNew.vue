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
              style="margin: auto;width: 100%;user-select:initial"
              :header-cell-style="{background:'#00c0d1',color:'#000000',fontSize:'18px'}">
      <el-table-column label="打造精品工程"
                       align="center"
                       :render-header="renderHeaderBuildBoutiqueProject">
        <template>
          <editor-vue :value="conclusionTextNew.buildBoutiqueProject.content"
                      @input="(res)=> conclusionTextNew.buildBoutiqueProject.content = res"></editor-vue>
        </template>
      </el-table-column>
    </el-table>
    <el-table :data="tableData2"
              border
              stripe
              size="medium"
              :header-cell-style="{ background:'#00c0d1',color:'#000000',fontSize:'18px' }"
              style="margin: auto;width: 99%;user-select:initial"
              highlight-current-row>
      <el-table-column label="创建专业团队"
                       align="center"
                       :render-header="renderHeaderBuildProTeam">
        <template>
          <editor-vue :value="conclusionTextNew.buildProTeam.content"
                      @input="(res)=> conclusionTextNew.buildProTeam.content = res"></editor-vue>
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
      <el-table-column label="下一个月的工作目标、工作计划/工作安排、工作内容"
                       align="center">
        <template>
          <!-- @input="(res)=> conclusionText.nextPlan = res" -->
          <editor-vue :value="conclusionTextNew.nextPlan.content"
                      @input="(res)=> conclusionTextNew.nextPlan.content = res"></editor-vue>
        </template>
      </el-table-column>
    </el-table>
    <el-table :data="tableData4"
              border
              stripe
              size="medium"
              :header-cell-style="{ background:'#00c0d1',color:'#000000',fontSize:'18px' }"
              style="margin: auto;width: 99%"
              highlight-current-row>
      <el-table-column label="对处室工作的意见/建议、不满/抱怨、工作/生活/学习中的烦恼和困难以及希望得到的帮助/支持/指导"
                       align="center">
        <template>
          <editor-vue :value="conclusionTextNew.curAdvice.content"
                      @input="(res)=> conclusionTextNew.curAdvice.content = res"></editor-vue>
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
    updateMonthConclusionData,
    submitMonthConclusionNew,
    updateMonthConclusionNew } from '@/utils/conclusion'
  import store from '@/store'
import jsCookie from 'js-cookie'
  export default {
    data () {
      return {
        conclusionTitle: '',
        tableData1: [{}],
        tableData2: [{}],
        tableData3: [{}],
        tableData4: [{}],
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
        moreDetailData: [],
        conclusionTextNew: JSON.parse(JSON.stringify(this.$store.state.conclusionTextNew))
      }
    },
    methods: {
      // 初始化
      init () {
        this.moreDetailData = JSON.parse(JSON.stringify(this.$route.query.moreDetailData))
        this.submitYear = this.$route.query.submitYear
        this.conclusionTitle = this.submitYear + '年' + this.$route.query.conclusionTitle
        this.submitMonth = this.$route.query.submitMonth
        this.submitter = this.$route.query.submitter
        let index = this.moreDetailData.findIndex(item => {
          return item.dimension === 1
        })
        if (index !== -1) {
          this.conclusionTextNew.buildBoutiqueProject = this.moreDetailData[index]
        }

        index = this.moreDetailData.findIndex(item => {
          return item.dimension === 2
        })
        if (index !== -1) {
          this.conclusionTextNew.buildProTeam = this.moreDetailData[index]
        }

        index = this.moreDetailData.findIndex(item => {
          return item.dimension === 3
        })
        if (index !== -1) {
          this.conclusionTextNew.nextPlan = this.moreDetailData[index]
        }

        index = this.moreDetailData.findIndex(item => {
          return item.dimension === 4
        })
        if (index !== -1) {
          this.conclusionTextNew.curAdvice = this.moreDetailData[index]
        }
      },
      // 提交月总结
      handleSubmit () {
        let submitStatus = 1
        let promises = []
        let count = 0
        if (this.moreDetailData.length === 0) { // 是否第一次提交
          for (let item in this.conclusionTextNew) {
            promises[count++] = submitMonthConclusionNew(this.submitter, this.submitYear, this.submitMonth, store.state.monthConclusionType,
                                                        this.conclusionTextNew[item].dimension, this.conclusionTextNew[item].content,
                                                        submitStatus)
          }
          Promise.all(promises).then(allResponses => {
            console.log('allResponses')
            console.log(allResponses)
            this.$common.toast('提交成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch(err => {
            console.log('err')
            console.log(err)
            this.$common.toast('提交失败', 'error', true)
          })
        } else { // 提交类型为更新
          for (let item of this.moreDetailData) {
            promises[count++] = updateMonthConclusionNew(item.id, item.content, submitStatus)
          }
          Promise.all(promises).then(allResponses => {
            console.log('allResponses')
            console.log(allResponses)
            this.$common.toast('提交成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch(err => {
            console.log('err')
            console.log(err)
            this.$common.toast('提交失败', 'error', true)
          })
        }
      },
      // 暂存月总结
      handleTemporary () {
        let submitStatus = 2
        let promises = []
        let count = 0
        if (this.moreDetailData.length === 0) { // 是否第一次提交
          for (let item in this.conclusionTextNew) {
            promises[count++] = submitMonthConclusionNew(this.submitter, this.submitYear, this.submitMonth, store.state.monthConclusionType,
                                                        this.conclusionTextNew[item].dimension, this.conclusionTextNew[item].content,
                                                        submitStatus)
          }
          Promise.all(promises).then(allResponses => {
            console.log('allResponses')
            console.log(allResponses)
            this.$common.toast('暂存成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch(err => {
            console.log('err')
            console.log(err)
            this.$common.toast('暂存失败', 'error', true)
          })
        } else { // 提交类型为更新
          for (let item of this.moreDetailData) {
            promises[count++] = updateMonthConclusionNew(item.id, item.content, submitStatus)
          }
          Promise.all(promises).then(allResponses => {
            console.log('allResponses')
            console.log(allResponses)
            this.$common.toast('暂存成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch(err => {
            console.log('err')
            console.log(err)
            this.$common.toast('暂存失败', 'error', true)
          })
        }
      },
      // 打造精品工程表头渲染函数
      renderHeaderBuildBoutiqueProject (h, { column, $index }) {
        return (
          <div>
            <span>打造精品工程</span>
            <p>
              <span style="fontSize:15px">(可以从</span>
              <span style="color: red;font-weight:bold;fontSize:15px">承担工作难度、专业技术研究、工作方法创新、工作推进效率、工作完成效果、降本增效举措</span>
              <span style="fontSize:15px">等方面描述)</span>
            </p>
          </div>
        )
      },
      // 打造精品工程表头渲染函数
      renderHeaderBuildProTeam (h, { column, $index }) {
        return (
          <div>
            <span>建设专业团队</span>
            <p>
              <span style="fontSize:15px">(可以从</span>
              <span style="color: red;font-weight:bold;fontSize:15px">处室绩效贡献、团队协作贡献、团建活动和宣传</span>
              <span style="fontSize:15px">等方面描述)</span>
            </p>
          </div>
        )
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
    name: 'momthConclusionTableNew'
  }
</script>

<style scoped>
</style>

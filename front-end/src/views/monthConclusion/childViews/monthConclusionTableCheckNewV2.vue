<template>
  <div>
    <div v-if="isNewRule">
      <el-dialog :title="conclusionTitle"
                :visible.sync="conclusionDialog"
                width="70%"
                :center="true"
                append-to-body
                :before-close="onClose">
        <el-tabs v-model="activeMonth" @tab-click="handleTabClick(activeMonth)">
          <el-tab-pane v-for="(month) in months" :key="month" :label= 'month' :name="month"></el-tab-pane>
        </el-tabs>
        <div class="dialogDiv">
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
          <el-table v-if="checkUserID === $store.state.userInfo.id || this.$store.state.userInfo.id === 26"
                    :data="tableData4"
                    border
                    stripe
                    size="medium"
                    :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                    style="margin: auto"
                    highlight-current-row>
            <el-table-column label="对处室工作的意见/建议、不满/抱怨、工作/生活/学习中的烦恼和困难以及希望得到的帮助/支持/指导">
              <template>
                <div v-html="curAdvice"></div>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-dialog>
    </div>
    <div v-else>
      <el-dialog :title="conclusionTitle"
                 :visible.sync="conclusionDialog"
                 width="70%"
                 :center="true"
                 append-to-body
                 :before-close="onClose">
        <el-tabs v-model="activeMonth" @tab-click="handleTabClick(activeMonth)">
          <el-tab-pane v-for="(month) in months" :key="month" :label= 'month' :name="month"></el-tab-pane>
        </el-tabs>
        <div class="dialogDiv">
          <el-table :data="tableData1"
                    border
                    stripe
                    size="medium"
                    style="margin: auto"
                    :header-cell-style="{background:'#ced1d4',color:'#000000',fontSize:'16px'}">
            <el-table-column label="在本月所完成工作的回顾及客观评价（含工作内容、进展与成效、不足与改进意见、工作成果评价、未完成的工作内容及原因分析等）">
              <template>
                <div v-html="curConclusion"></div>
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
            <el-table-column label="下一个月的工作目标、工作计划/工作安排、工作内容">
              <template>
                <div v-html="nextPlan"></div>
              </template>
            </el-table-column>
          </el-table>
          <el-table v-if="checkUserID.id === $store.state.userInfo.id || this.$store.state.userInfo.id === 26"
                    :data="tableData3"
                    border
                    stripe
                    size="medium"
                    :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                    style="margin: auto"
                    highlight-current-row>
            <el-table-column label="对处室工作的意见/建议、不满/抱怨、工作/生活/学习中的烦恼和困难以及希望得到的帮助/支持/指导">
              <template>
                <div v-html="curAdvice"></div>
              </template>
            </el-table-column>
          </el-table>
          <el-table v-if="checkUserID.id === $store.state.userInfo.id || $store.state.userInfo.id === 26"
                    :data="tableData5"
                    border
                    stripe
                    size="medium"
                    :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                    style="margin: auto"
                    highlight-current-row>
            <el-table-column label="管理者评价"
                            align="center">
              <template>
                <div v-html="managerEva"></div>
              </template>
            </el-table-column>
          </el-table>
        </div>
      </el-dialog>
    </div>
  </div>
</template>

<script>
    import { getCurYearConclusionOverviewData } from '@/utils/conclusion'
    import moment from 'moment'
    import store from '@/store'
    export default {
      data () {
        return {
          isNewRule: true,
          tableData1: [{}],
          tableData2: [{}],
          tableData3: [{}],
          tableData4: [{}],
          tableData5: [{}],
          conclusionDialog: false,
          buildBoutiqueProject: '无数据',
          buildProTeam: '无数据',
          nextPlan: '无数据',
          curAdvice: '无数据',
          activeMonth: null,
          concolusionData: null,
          conclusionTitle: null,
          curConclusion: '无数据',
          managerEva: null,
          firstOpen: true
        }
      },
      props: {
        checkUserID: {
          type: Object,
          default: null
        },
        months: {
          type: Array,
          default: null
        }
      },
      methods: {
        // 初始化
        init (activeMonth) {
          this.$nextTick(() => {
            this.activeMonth = activeMonth
            this.isNewRule = !moment(this.activeMonth).isBefore(store.state.newRulesDate)
            this.conclusionTitle = this.checkUserID.name + this.activeMonth + '月总结'
            let year = this.$moment(this.activeMonth).format('YYYY')
            let month = this.$moment(this.activeMonth).month() + 1
            let userID = this.checkUserID.id
            getCurYearConclusionOverviewData(year, userID).then(allConclusionData => {
              this.concolusionData = allConclusionData
              // 请求的月份在新规则实施月份之前
              if (this.isNewRule) {
                if (allConclusionData[month - 1].conclusionData.length !== 0) {
                  this.buildBoutiqueProject = allConclusionData[month - 1].conclusionData.find(item => {
                    return item.dimension === 1
                  }).content
                  this.buildProTeam = allConclusionData[month - 1].conclusionData.find(item => {
                    return item.dimension === 2
                  }).content
                  this.nextPlan = allConclusionData[month - 1].conclusionData.find(item => {
                    return item.dimension === 3
                  }).content
                  this.curAdvice = allConclusionData[month - 1].conclusionData.find(item => {
                    return item.dimension === 4
                  }).content
                }
              } else { // 请求的月份在新规则实施月份之后
                if (allConclusionData[month - 1].length > 0) {
                  this.curConclusion = allConclusionData[month - 1][0].curConclusion
                  this.nextPlan = allConclusionData[month - 1][0].nextPlan
                  this.curAdvice = allConclusionData[month - 1][0].curAdvice
                  this.managerEva = allConclusionData[month - 1][0].managerEva
                }
              }
              if (this.firstOpen) {
                this.conclusionDialog = !this.conclusionDialog
                this.firstOpen = false
              }
            })
          })
        },
        // 关闭对话框
        onClose () {
          this.conclusionDialog = !this.conclusionDialog
          this.$emit('close')
        },
        // 点击标签事件
        handleTabClick (activeMonth) {
          let month = this.$moment(this.activeMonth).month() + 1
          this.isNewRule = !moment(this.activeMonth).isBefore(store.state.newRulesDate)
          this.conclusionTitle = this.checkUserID.name + this.activeMonth + '月总结'
          this.tableData1 = [{}]
          this.tableData2 = [{}]
          this.tableData3 = [{}]
          this.tableData4 = [{}]
          if (this.isNewRule) {
            if (this.concolusionData[month - 1].conclusionData.length !== 0) {
              this.buildBoutiqueProject = this.concolusionData[month - 1].conclusionData.find(item => {
                return item.dimension === 1
              }).content
              this.buildProTeam = this.concolusionData[month - 1].conclusionData.find(item => {
                return item.dimension === 2
              }).content
              this.nextPlan = this.concolusionData[month - 1].conclusionData.find(item => {
                return item.dimension === 3
              }).content
              this.curAdvice = this.concolusionData[month - 1].conclusionData.find(item => {
                return item.dimension === 4
              }).content
            }
          } else { // 请求的月份在新规则实施月份之后
            this.curConclusion = this.concolusionData[month - 1][0].curConclusion
            this.nextPlan = this.concolusionData[month - 1][0].nextPlan
            this.curAdvice = this.concolusionData[month - 1][0].curAdvice
            this.managerEva = this.concolusionData[month - 1][0].managerEva
          }
        }
      },
      created () {
        this.init(this.months[0])
      },
      computed: {
      },
      components: {
        // editorVue
      },
      watch: {
      },
      name: 'monthConclusionTableCheckNew'
    }
</script>

<style lang="scss" scoped>
  .dialogDiv {
    height: 600px;
    overflow: auto;
  }
</style>

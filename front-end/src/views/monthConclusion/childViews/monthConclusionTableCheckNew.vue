<template>
  <div>
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
        <template v-if="isMergedConclusion">
          <el-table :data="tableMerged"
                    border
                    stripe
                    size="medium"
                    style="margin: auto"
                    :header-cell-style="{background:'#ced1d4',color:'#000000',fontSize:'16px'}">
            <el-table-column label="月度总结">
              <template>
                <div v-html="buildBoutiqueProject"></div>
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
            <el-table-column label="下月计划">
              <template>
                <div v-html="nextPlan"></div>
              </template>
            </el-table-column>
          </el-table>
          <el-table :data="tableData4"
                    border
                    stripe
                    size="medium"
                    :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                    style="margin: auto"
                    highlight-current-row>
            <el-table-column label="意见建议与困难反馈">
              <template>
                <div v-html="curAdvice"></div>
              </template>
            </el-table-column>
          </el-table>
        </template>
        <template v-else>
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
            <el-table-column label="下月计划">
              <template>
                <div v-html="nextPlan"></div>
              </template>
            </el-table-column>
          </el-table>
          <el-table :data="tableData4"
                    border
                    stripe
                    size="medium"
                    :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                    style="margin: auto"
                    highlight-current-row>
            <el-table-column label="意见建议与困难反馈">
              <template>
                <div v-html="curAdvice"></div>
              </template>
            </el-table-column>
          </el-table>
        </template>
        <el-table v-if="(checkUserId === $store.state.userInfo.id || this.$store.state.userInfo.id === 35) && (checkUserDuty === 2)"
                  :data="tableData5"
                  border
                  stripe
                  size="medium"
                  :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                  style="margin: auto"
                  highlight-current-row>
          <el-table-column label="小组工作">
            <template>
              <div v-html="groupWork"></div>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-dialog>
  </div>
</template>

<script>
    export default {
      data () {
        return {
          tableData1: [{}],
          tableData2: [{}],
          tableData3: [{}],
          tableData4: [{}],
          tableData5: [{}],
          tableMerged: [{ }],
          conclusionDialog: false,
          buildBoutiqueProject: null,
          buildProTeam: null,
          nextPlan: null,
          curAdvice: null,
          activeMonth: null,
          groupWork: null
        }
      },
      props: {
        moreDetailData: {
          type: Array,
          default: null
        },
        conclusionTitle: {
          type: String,
          default: null
        },
        checkUserId: {
          type: Number,
          default: null
        },
        checkUserDuty: {
          type: Number,
          default: null
        },
        months: {
          type: Array,
          default: null
        }
      },
      methods: {
        // 初始化
        init () {
          this.$nextTick(() => {
            this.activeMonth = this.months[0]
            this.conclusionDialog = !this.conclusionDialog
            if (this.moreDetailData.length !== 0) {
              this.buildBoutiqueProject = (this.moreDetailData.find(item => item.dimension === 1) || {}).content || ''
              this.buildProTeam = (this.moreDetailData.find(item => item.dimension === 2) || {}).content || ''
              this.nextPlan = (this.moreDetailData.find(item => item.dimension === 3) || {}).content || ''
              this.curAdvice = (this.moreDetailData.find(item => item.dimension === 4) || {}).content || ''
              this.groupWork = (this.moreDetailData.find(item => item.dimension === 5) || {}).content || ''
            } else {
              this.buildBoutiqueProject = ''
              this.buildProTeam = ''
              this.nextPlan = ''
              this.curAdvice = ''
              this.groupWork = ''
            }
          })
        },
        // 关闭对话框
        onClose () {
          this.conclusionDialog = !this.conclusionDialog
          this.$emit('close')
        },
        // 点击标签事件
        handleTabClick (activeMonth) {
          this.$emit('clickActiveMonth', activeMonth)
        }
      },
      created () {
        this.init()
      },
      computed: {
        // 判断当前月份是否使用合并后的月度总结模板（>=2026年5月）
        isMergedConclusion () {
          if (!this.moreDetailData || this.moreDetailData.length === 0) return false
          const firstItem = this.moreDetailData[0]
          if (!firstItem.conclusionYear || !firstItem.conclusionMonth) return false
          const targetYM = Number(firstItem.conclusionYear) * 100 + Number(firstItem.conclusionMonth)
          const mergeYM = 2026 * 100 + 5
          return targetYM >= mergeYM
        }
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

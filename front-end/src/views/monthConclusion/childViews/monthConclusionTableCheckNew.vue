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
        <el-table v-if="checkUserId === $store.state.userInfo.id || this.$store.state.userInfo.id === 26"
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
          tableData6: [{}],
          conclusionDialog: false,
          buildBoutiqueProject: null,
          buildProTeam: null,
          nextPlan: null,
          curAdvice: null,
          activeMonth: null
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
              this.buildBoutiqueProject = this.moreDetailData.find(item => {
                return item.dimension === 1
              }).content
              this.buildProTeam = this.moreDetailData.find(item => {
                return item.dimension === 2
              }).content
              this.nextPlan = this.moreDetailData.find(item => {
                return item.dimension === 3
              }).content
              this.curAdvice = this.moreDetailData.find(item => {
                return item.dimension === 4
              }).content
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

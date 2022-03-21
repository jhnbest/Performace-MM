<template>
  <div>
    <el-dialog :title="conclusionTitle"
               :visible.sync="conclusionDialog"
               width="70%"
               :center="true"
               append-to-body
               :before-close="onClose">
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
        <el-table v-if="isManagerEva"
                  :data="tableData5"
                  border
                  stripe
                  size="medium"
                  :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                  style="margin: auto"
                  highlight-current-row>
          <el-table-column v-if="rateTableShow"
                           label="管理者评分"
                           align="center">
            <template>
              <el-rate v-model="managerRateStarCom"
                       @change="managerRateStarSunChange"
                       show-text
                       :texts="managerRateStarText"></el-rate>
            </template>
          </el-table-column>
        </el-table>
        <el-table v-if="checkUserId === $store.state.userInfo.id || this.$store.state.userInfo.id === 26"
                  :data="tableData6"
                  border
                  stripe
                  size="medium"
                  :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                  style="margin: auto"
                  highlight-current-row>
          <el-table-column label="管理者评价"
                           align="center">
            <template>
              <editor-vue v-if="isManagerEva" :value="managerEva"
                          @input="(res) =>{
                            managerEvaTmp = res
                            changeFlag = true
                          }"></editor-vue>
              <div v-else v-html="managerEva"></div>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div v-if="isManagerEva" slot="footer" class="dialog-footer">
        <el-button @click="handleCancel">取 消</el-button>
        <el-button type="primary"
                   @click="handleSave"
                   :disabled="!changeFlag">提 交</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
    import editorVue from '../../../components/monthConclusion/editor'
    import { conclusionManagerEvaStarToWorkTime } from '@/utils/common'
    export default {
      data () {
        return {
          tableData1: [{}],
          tableData2: [{}],
          tableData3: [{}],
          tableData4: [{}],
          tableData5: [{}],
          tableData6: [{}],
          managerEvaTmp: null,
          conclusionDialog: false,
          changeFlag: false,
          managerRateStarCom: null,
          rateTableShow: true,
          buildBoutiqueProject: null,
          buildProTeam: null,
          nextPlan: null,
          curAdvice: null,
          managerEva: null
        }
      },
      props: {
        moreDetailData: {
          type: Array,
          default: null
        },
        isManagerEva: {
          type: Boolean,
          default: false
        },
        conclusionTitle: {
          type: String,
          default: null
        },
        checkUserId: {
          type: Number,
          default: null
        }
      },
      methods: {
        // 初始化
        init () {
          this.$nextTick(() => {
            this.conclusionDialog = !this.conclusionDialog
            this.managerRateStarCom = this.managerRateStar
            let test = this.moreDetailData.find(item => {
              return item.dimension === 1
            })
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
        // 保存
        handleSave () {
          let emitData = {
            id: this.id,
            managerRateStar: this.managerRateStarCom,
            managerEva: this.managerEvaTmp,
            submitter: this.submitter
          }
          this.$emit('handleSaveEvaData', emitData)
          this.onClose()
        },
        // 取消
        handleCancel () {
          this.onClose()
        },
        // 关闭对话框
        onClose () {
          this.conclusionDialog = !this.conclusionDialog
          this.$emit('close')
        },
        // 管理者星级评价改变
        managerRateStarSunChange () {
          this.changeFlag = true
          this.rateTableShow = false
          this.$nextTick(() => {
            this.rateTableShow = true
          })
        }
      },
      created () {
        this.init()
      },
      computed: {
        managerRateStarText: function () {
          let result = []
          for (let i = 0; i < 5; i++) {
            let getWorkTime = conclusionManagerEvaStarToWorkTime(i + 1) + '工时'
            result.push(getWorkTime)
          }
          return result
        }
      },
      components: {
        editorVue
      },
      watch: {
        managerRateStarCom (e) {
          this.managerRateStarCom = e
        }
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

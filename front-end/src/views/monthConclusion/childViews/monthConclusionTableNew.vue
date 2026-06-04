<template>
<div class="conclusion-form-page">
  <div class="page-header">
    <div class="header-left">
      <i class="el-icon-edit-outline header-icon"></i>
      <span class="header-title">{{conclusionTitle}}</span>
    </div>
    <div class="header-actions">
      <el-button type="primary" @click="handleSubmit" :disabled="isSubmit" size="medium" icon="el-icon-upload">提交</el-button>
      <el-button type="warning" @click="handleTemporary" size="medium" icon="el-icon-folder-opened">暂存</el-button>
      <el-button type="info" @click="handleBack" size="medium" icon="el-icon-back">返回</el-button>
    </div>
  </div>

  <div class="hr-10"></div>

  <div class="main-content">
    <!-- 月度总结（合并模式） -->
    <div v-if="isMergedConclusion" class="section-block">
      <div class="section-header">
        <div class="v-line-icon-blue">
          <span class="section-title">月度总结</span>
          <el-popover placement="bottom" width="520" trigger="click">
            <div class="guide-popover">
              <p><strong>1、目标回顾：</strong>月度总结要跟计划一一对应。计划填写了5条，总结的前面5条要跟计划填写的顺序一致。没完成的，就写没完成，分析原因。在下月计划中再次放进去跟进。计划外的工作从第6条开始写。</p>
              <p><strong>2、量化数据：</strong>能量化的成果尽量量化数据表达。</p>
              <p><strong>3、诚实透明：</strong>除了成果，也要敢于写出需要的支持和可能的风险。没完成的计划，分析原因要务实，不必藏着掖着。</p>
              <p><strong>4、滚动优化：</strong>月度计划允许滚动优化，动态调整。总结不是结束。它是下个月计划的输入，形成"计划 → 执行 → 总结 → 改进计划"的正向循环。</p>
            </div>
            <span slot="reference" style="cursor: pointer;">
              <i class="el-icon-info guide-icon"></i>
              <span style="font-size: 12px; color: #409EFF;">填写要求</span>
            </span>
          </el-popover>
        </div>
      </div>
      <el-table :data="tableMerged" border stripe size="medium" class="content-table"
                :header-cell-style="tableHeaderStyle">
        <el-table-column align="center">
          <template>
            <editor-vue :value="conclusionTextNew.monthSummary.content"
                        @input="(res)=> conclusionTextNew.monthSummary.content = res"></editor-vue>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 打造精品工程 + 建设专业团队（旧模式） -->
    <template v-else>
      <div class="section-block">
        <div class="section-header">
          <div class="v-line-icon-blue">
            <span class="section-title">打造精品工程</span>
          </div>
          <span class="section-hint">（承担工作难度、专业技术研究、工作方法创新、工作推进效率、工作完成效果、降本增效举措）</span>
        </div>
        <el-table :data="tableData1" border stripe size="medium" class="content-table"
                  :header-cell-style="tableHeaderStyle">
          <el-table-column align="center">
            <template>
              <editor-vue :value="conclusionTextNew.buildBoutiqueProject.content"
                          @input="(res)=> conclusionTextNew.buildBoutiqueProject.content = res"></editor-vue>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <div class="section-block">
        <div class="section-header">
          <div class="v-line-icon-blue">
            <span class="section-title">建设专业团队</span>
          </div>
          <span class="section-hint">（处室绩效贡献、团队协作贡献、团建活动和宣传）</span>
        </div>
        <el-table :data="tableData2" border stripe size="medium" class="content-table"
                  :header-cell-style="tableHeaderStyle">
          <el-table-column align="center">
            <template>
              <editor-vue :value="conclusionTextNew.buildProTeam.content"
                          @input="(res)=> conclusionTextNew.buildProTeam.content = res"></editor-vue>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </template>

    <!-- 小组工作（仅组长） -->
    <div v-if="$store.state.userInfo.duty === 2" class="section-block">
      <div class="section-header">
        <div class="v-line-icon-green">
          <span class="section-title">小组工作</span>
        </div>
      </div>
      <el-table :data="tableData5" border stripe size="medium" class="content-table"
                :header-cell-style="tableHeaderStyle">
        <el-table-column align="center">
          <template>
            <editor-vue :value="conclusionTextNew.teamWork.content"
                        @input="(res)=> conclusionTextNew.teamWork.content = res"></editor-vue>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 下月计划 -->
    <div class="section-block">
      <div class="section-header">
        <div class="v-line-icon-yellow">
          <span class="section-title">下月计划</span>
          <el-popover placement="bottom" width="560" trigger="click">
            <div class="guide-popover">
              <p><strong>计划填写要求：满足SMART原则。</strong></p>
              <p><strong>1、S-具体：</strong>目标要清晰明确。比如"推动项目启动"应改成"完成业务需求提交审核"、"完成技术要求编写"、"完成启动文档编写"、"通过启动评审"，每个阶段都可以分解成一个一个本月要完成的具体的动作和目标。</p>
              <p><strong>2、M-可衡量：</strong>要有量化指标。比如"完成17个信息发布点位"、"管线预埋完成87%"。</p>
              <p><strong>3、A-可达成：</strong>目标要基于实际资源（时间、人力、预算）来设定，有一定挑战性但通过努力可以实现。</p>
              <p><strong>4、R-相关联：</strong>每月计划必须对齐各项目计划、预算计划。可以反问自己：这个月最关键的3件事是什么？它们对整体目标有贡献吗？</p>
              <p><strong>5、T-有时限：</strong>为关键任务设定明确的时间节点。比如"15号前完成项目启动，25号前提交预算执行"。</p>
            </div>
            <span slot="reference" style="cursor: pointer;">
              <i class="el-icon-info guide-icon"></i>
              <span style="font-size: 12px; color: #409EFF;">填写要求</span>
            </span>
          </el-popover>
        </div>
      </div>
      <el-table :data="tableData3" border stripe size="medium" class="content-table"
                :header-cell-style="tableHeaderStyle">
        <el-table-column align="center">
          <template>
            <editor-vue :value="conclusionTextNew.nextPlan.content"
                        @input="(res)=> conclusionTextNew.nextPlan.content = res"></editor-vue>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 意见建议 -->
    <div class="section-block">
      <div class="section-header">
        <div class="v-line-icon-purple">
          <span class="section-title">意见建议与困难反馈</span>
        </div>
      </div>
      <el-table :data="tableData4" border stripe size="medium" class="content-table"
                :header-cell-style="tableHeaderStyle">
        <el-table-column align="center">
          <template>
            <editor-vue :value="conclusionTextNew.curAdvice.content"
                        @input="(res)=> conclusionTextNew.curAdvice.content = res"></editor-vue>
          </template>
        </el-table-column>
      </el-table>
    </div>

    <!-- 底部操作区 -->
    <div class="footer-actions">
      <el-button type="primary" @click="handleSubmit" :disabled="isSubmit" size="medium" icon="el-icon-upload">提交</el-button>
      <el-button type="warning" @click="handleTemporary" size="medium" icon="el-icon-folder-opened">暂存</el-button>
      <el-button type="info" @click="handleBack" size="medium" icon="el-icon-back">返回</el-button>
    </div>
  </div>
</div>
</template>

<script>
  import editorVue from '../../../components/monthConclusion/editor'
  import {
    submitMonthConclusionNew,
    updateMonthConclusionNew } from '@/utils/conclusion'
  import store from '@/store'
import { convertYearMonth2Nor, getIsSubmitAllow } from '@/utils/common'
import { getProjectList, getWorkTimeListByType, mianshenheWorkTimeSubmit } from '@/utils/performance'
  export default {
    data () {
      return {
        conclusionTitle: '',
        tableData1: [{}],
        tableData2: [{}],
        tableData3: [{}],
        tableData4: [{}],
        tableData5: [{}],
        tableMerged: [{}],
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
        conclusionTextNew: {},
        tableHeaderStyle: { background: '#48bfe5', color: '#333', fontSize: '16px' },
      }
    },
    methods: {
      // 初始化
      init () {
        this.moreDetailData = this.$route.query.moreDetailData
          ? JSON.parse(JSON.stringify(this.$route.query.moreDetailData))
          : []
        this.submitYear = this.$route.query.submitYear
        this.conclusionTitle = this.submitYear + '年' + this.$route.query.conclusionTitle
        this.submitMonth = this.$route.query.submitMonth
        this.submitter = this.$route.query.submitter

        // 根据合并规则初始化conclusionTextNew结构
        if (this.isMergedConclusion) {
          this.initMergedStructure()
        } else {
          this.initOldStructure()
        }
      },
      // 初始化合并模式的数据结构
      initMergedStructure () {
        this.conclusionTextNew = {
          monthSummary: { dimension: 1, content: '' },
          nextPlan: { dimension: 3, content: '' },
          curAdvice: { dimension: 4, content: '' },
          teamWork: { dimension: 5, content: '' }
        }
        // 回填已有数据
        let index = this.moreDetailData.findIndex(item => item.dimension === 1)
        if (index !== -1) {
          this.conclusionTextNew.monthSummary = this.moreDetailData[index]
        }
        index = this.moreDetailData.findIndex(item => item.dimension === 3)
        if (index !== -1) {
          this.conclusionTextNew.nextPlan = this.moreDetailData[index]
        }
        index = this.moreDetailData.findIndex(item => item.dimension === 4)
        if (index !== -1) {
          this.conclusionTextNew.curAdvice = this.moreDetailData[index]
        }
        index = this.moreDetailData.findIndex(item => item.dimension === 5)
        if (index !== -1) {
          this.conclusionTextNew.teamWork = this.moreDetailData[index]
        }
      },
      // 初始化旧模式的数据结构
      initOldStructure () {
        const defaultText = this.$store.state.userInfo.duty === 2
          ? this.$store.state.conclusionTextNewGP
          : this.$store.state.conclusionTextNew
        this.conclusionTextNew = defaultText ? JSON.parse(JSON.stringify(defaultText)) : {
          buildBoutiqueProject: { dimension: 1, content: '' },
          buildProTeam: { dimension: 2, content: '' },
          nextPlan: { dimension: 3, content: '' },
          curAdvice: { dimension: 4, content: '' },
          teamWork: { dimension: 5, content: '' }
        }
        // 回填已有数据
        let idx = this.moreDetailData.findIndex(item => item.dimension === 1)
        if (idx !== -1) {
          this.conclusionTextNew.buildBoutiqueProject = this.moreDetailData[idx]
        }
        idx = this.moreDetailData.findIndex(item => item.dimension === 2)
        if (idx !== -1) {
          this.conclusionTextNew.buildProTeam = this.moreDetailData[idx]
        }
        idx = this.moreDetailData.findIndex(item => item.dimension === 3)
        if (idx !== -1) {
          this.conclusionTextNew.nextPlan = this.moreDetailData[idx]
        }
        idx = this.moreDetailData.findIndex(item => item.dimension === 4)
        if (idx !== -1) {
          this.conclusionTextNew.curAdvice = this.moreDetailData[idx]
        }
        idx = this.moreDetailData.findIndex(item => item.dimension === 5)
        if (idx !== -1) {
          this.conclusionTextNew.teamWork = this.moreDetailData[idx]
        }
      },
      // 提交月总结
      // 构建需要提交的维度列表（过滤掉普通员工的 dimension=5 小组工作，但保留空内容以便写入数据库）
      _buildSubmitList (sourceData, isFirstSubmit) {
        let isLeader = this.$store.state.userInfo.duty === 2
        let result = []
        if (isFirstSubmit) {
          // 首次提交：遍历 conclusionTextNew 的 value
          for (let key in sourceData) {
            let item = sourceData[key]
            if (item.dimension === 5 && !isLeader) continue
            result.push(item)
          }
        } else {
          // 更新提交：遍历 moreDetailData
          for (let item of sourceData) {
            if (item.dimension === 5 && !isLeader) continue
            result.push(item)
          }
        }
        // 合并模式下：补充 dimension=2（空内容），保持关联模块一致性
        if (this.isMergedConclusion) {
          result.push({
            dimension: 2,
            content: ''
          })
        }
        return result
      },
      handleSubmit () {
        let submitStatus = 1
        let promises = []
        let count = 0
        let submitList = this._buildSubmitList(this.moreDetailData.length === 0 ? this.conclusionTextNew : this.moreDetailData, this.moreDetailData.length === 0)
        if (this.moreDetailData.length === 0) { // ***是否第一次提交
          // ***如果在截止日期前提交申报，则自动提交一条奖励工时
          // getIsSubmitAllow(this.submitYear, this.submitMonth).then(res => {
          //   if (res.length === 0) {
          //     let applyMonth = convertYearMonth2Nor(this.submitYear, this.submitMonth)
          //     mianshenheWorkTimeSubmit(store.state.userInfo.id, 549, applyMonth).then(() => {}).catch(err => { console.log(err) })
          //   } else if (res[0].flagValue !== 1) {
          //     let applyMonth = convertYearMonth2Nor(this.submitYear, this.submitMonth)
          //     mianshenheWorkTimeSubmit(store.state.userInfo.id, 549, applyMonth).then(() => {}).catch(err => { console.log(err) })
          //   }
          // })
          for (let item of submitList) {
            promises[count++] = submitMonthConclusionNew(this.submitter, this.submitYear, this.submitMonth, store.state.monthConclusionType,
                                                        item.dimension, item.content,
                                                        submitStatus)
          }
          Promise.all(promises).then(() => {
            this.$common.toast('提交成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch(err => {
            console.log(err)
            this.$common.toast('提交失败', 'error', true)
          })
        } else { // 提交类型为更新
          let userID = this.$store.state.userInfo.id
          let applyMonth = convertYearMonth2Nor(this.$route.query.submitYear, this.$route.query.submitMonth)
          // getWorkTimeListByType(userID, applyMonth, 549).then(res => {
          //   // ***用户如果在截止日期前是先暂存后提交月总结，则也自动提交一条奖励工时
          //   if (res.length === 0) {
          //     mianshenheWorkTimeSubmit(userID, 549, applyMonth).then(() => {}).catch(err => { console.log(err) })
          //   }
          // })
          for (let item of submitList) {
            promises[count++] = updateMonthConclusionNew(item.id, item.content, submitStatus)
          }
          Promise.all(promises).then(allResponses => {
            this.$common.toast('提交成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch(err => {
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
        let submitList = this._buildSubmitList(this.moreDetailData.length === 0 ? this.conclusionTextNew : this.moreDetailData, this.moreDetailData.length === 0)
        if (this.moreDetailData.length === 0) { // 是否第一次提交
          for (let item of submitList) {
            promises[count++] = submitMonthConclusionNew(this.submitter, this.submitYear, this.submitMonth, store.state.monthConclusionType,
                                                        item.dimension, item.content,
                                                        submitStatus)
          }
          Promise.all(promises).then(allResponses => {
            this.$common.toast('暂存成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch(err => {
            console.log(err)
            this.$common.toast('暂存失败', 'error', true)
          })
        } else { // 提交类型为更新
          for (let item of submitList) {
            promises[count++] = updateMonthConclusionNew(item.id, item.content, submitStatus)
          }
          Promise.all(promises).then(allResponses => {
            this.$common.toast('暂存成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch(err => {
            console.log(err)
            this.$common.toast('暂存失败', 'error', true)
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
    computed: {
      // 判断当前月份是否使用合并后的月度总结模板（>=2026年5月）
      isMergedConclusion () {
        if (!this.submitYear || !this.submitMonth) return false
        const targetYM = Number(this.submitYear) * 100 + Number(this.submitMonth)
        const mergeYM = 2026 * 100 + 5
        return targetYM >= mergeYM
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

<style lang="scss" scoped>
.conclusion-form-page {
  min-height: 100%;
  background: #f5f7fa;
}

.page-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 18px 28px;
  background: #fff;
  border-bottom: 1px solid #e8e8e8;

  .header-left {
    display: flex;
    align-items: center;
  }

  .header-icon {
    font-size: 22px;
    color: #00BFFF;
    margin-right: 10px;
  }

  .header-title {
    font-size: 20px;
    font-weight: 600;
    color: #303133;
  }

  .header-actions .el-button {
    margin-left: 10px;
  }
}

.main-content {
  padding: 24px 28px 40px;
  width: 82vw;
  max-width: 1400px;
  margin: 0 auto;
}

.section-block {
  background: #fff;
  border-radius: 6px;
  padding: 20px 28px;
  margin-bottom: 20px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.06);
  transition: box-shadow 0.3s;

  &:hover {
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  }
}

.section-header {
  display: flex;
  align-items: center;
  margin-bottom: 14px;
  padding-bottom: 10px;
  border-bottom: 1px dashed #e8e8e8;
}

.section-title {
  font-size: 15px;
  font-weight: 600;
  color: #303133;
}

.section-hint {
  font-size: 13px;
  color: #909399;
  margin-left: 12px;
}

.guide-icon {
  color: #409EFF;
  font-size: 16px;
  cursor: pointer;
  margin-left: 8px;
  vertical-align: middle;
}

.guide-popover {
  line-height: 1.8;
  font-size: 13px;
  color: #333;

  p {
    margin: 0 0 6px;
  }
}

.content-table {
  width: 100%;
  border-radius: 4px;
  overflow: hidden;
}

.footer-actions {
  text-align: center;
  padding: 10px 0 0;

  .el-button {
    margin: 0 10px;
    min-width: 100px;
  }
}
</style>

<template>
<div>
  <el-form class="main-search" :inline="true">
    <el-row type="flex">
      <el-col :xs="12" :sm="12" :lg="9" :xl="6">
<!--        年份选择-->
        <el-form-item label="年份选择：" prop="title">
          <el-button size="mini"
                     type="danger"
                     style="margin-right: 10px"
                     @click="handlePreYear"
                     :disabled="!reqFlag.getCurApplyAbleMonth">去年</el-button>
          <el-date-picker
            v-model="title"
            type="year"
            format="yyyy年"
            value-format="yyyy"
            placeholder="选择年份"
            style="width: 120px"
            @change="handelDateChange">
          </el-date-picker>
          <el-button size="mini"
                     type="primary"
                     style="margin-left: 10px"
                     @click="handleNextYear"
                     :disabled="!reqFlag.getCurApplyAbleMonth">明年</el-button>
        </el-form-item>
      </el-col>
<!--      填报说明-->
      <el-col :xs="2" :sm="2" :lg="{span: 6, pull: 1}" :xl="{span: 6, pull: 0}" style="margin-top: 10px">
        <el-popover
          placement="bottom"
          width="470"
          trigger="click">
          <span>1、根据当前的工时申报月份，点击编辑填写对应的月总结；</span><br>
          <span>2、状态为“提交”时，管理者方可看到月总结内容并进行星级评价；</span><br>
          <span>3、有完整填写“本月总结”和“下月计划”并提交默认评价为三颗星（获得10工时），如果取得较好成效，获得5星好评的奖励10工时，4星好评的奖励5工时，
            如果成效较差，获得2颗星扣5工时，1颗星扣10工时；</span><br>
          <span>4、若无特殊情况，提交截止时间为<span style="font-weight: bolder;color: red">每月1日24时。</span></span><br>
          <span slot="reference" class="pointer-type"><i class="el-icon-warning-outline"></i>填报说明</span>
        </el-popover>
      </el-col>
    </el-row>
  </el-form>
  <!-- 分割线 start -->
  <div class="hr-10"></div>
  <!-- 分割线 end -->
  <br>
<!--  月总结表格-->
  <div>
    <el-table :data="rateTableData"
              border
              style="margin: auto; width: 99%"
              stripe
              size="medium"
              :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }"
              v-loading="!reqFlag.getCurApplyAbleMonth"
              ref="rateTable"
              highlight-current-row>
      <el-table-column label="类型" align="center" min-width="50">
        <template slot-scope="scope">
          <el-tag :type="scope.row.conclusionType | conclusionTypeFilter" size="medium">
            <span>{{scope.row.conclusionType | conclusionTypeTextFilter}}</span>
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="月份" align="center" prop="month" min-width="50"></el-table-column>
      <el-table-column label="标题" align="center" prop="conclusionTitle"></el-table-column>
      <el-table-column label="状态" align="center">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.id !== null" :type="scope.row.submitStatus | submitStatusFilter" size="medium">
            <span>{{scope.row.submitStatus | submitStatusTextFilter}}</span>
          </el-tag>
          <el-tag v-else type="info" size="medium">
            <span>{{'未提交'}}</span>
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="管理者评分" align="center">
        <template slot-scope="scope">
          <el-rate v-if="scope.row.managerRateStar" :disabled="true" v-model="scope.row.managerRateStar" slot="reference" style="size: 50px"></el-rate>
          <span v-else>暂未评分</span>
        </template>
      </el-table-column>
      <!-- <el-table-column label="获得工时" align="center" prop="getWorkTime" width="100"></el-table-column> -->
      <el-table-column label="操作" align="center" width="250">
        <template slot-scope="scope">
<!--          点击预览-->
<!--          <el-popover-->
<!--            placement="left"-->
<!--            trigger="click">-->
<!--          </el-popover>-->
          <el-button type="primary"
                     size="mini"
                     @click="handlePreview(scope.row)"
                     :disabled="curApplyYear < title
                      || (curApplyMonth < scope.row.submitMonth && (curApplyYear === Number(title)))">点击预览</el-button>
<!--          编辑-->
<!-- (scope.row.managerRateStar !== null) || (curApplyYear !== Number(title)) ||
                    ((curApplyMonth !== scope.row.submitMonth) && (curApplyYear === Number(title))) -->
          <el-button :disabled="(scope.row.managerRateStar !== null) || (curApplyYear !== Number(title)) ||
                    ((curApplyMonth !== scope.row.submitMonth) && (curApplyYear === Number(title)))"
                     size="mini"
                     type="warning"
                     @click="handleEdit(scope.row)"
                     style="margin-left: 10px">编辑</el-button>
<!--          暂存-->
          <el-button v-if="scope.row.submitStatus === 1"
                     :disabled=" (scope.row.managerRateStar !== null) || (curApplyYear > Number(title)) ||
                    ((curApplyMonth > scope.row.submitMonth) && (curApplyYear === Number(title))) ||
                     !reqFlag.updateMonthConclusionStatus"
                     size="mini"
                     type="info"
                     @click="handleSubmit(scope.row, 2)">暂存</el-button>
<!--          提交-->
          <el-button v-if="!(scope.row.submitStatus === 1)"
                     :disabled="scope.row.moreDetailData.length === 0 || !reqFlag.updateMonthConclusionStatus
                      || (scope.row.managerRateStar !== null)
                      || (curApplyYear > Number(title)) ||
                    ((curApplyMonth > scope.row.submitMonth) && (curApplyYear === Number(title)))"
                     size="mini"
                     type="success"
                     @click="handleSubmit(scope.row, 1)">提交</el-button>
        </template>
      </el-table-column>
    </el-table>
    <br>
  </div>
  <!--    月总结对话框-->
  <month-conclusion-table-check v-if="conclusionDialog"
                                :cur-conclusion="curConclusion"
                                :next-plan="nextPlan"
                                :cur-advice="curAdvice"
                                :conclusion-title="conclusionTitle"
                                :id="selectId"
                                :manager-eva="managerEva"
                                :check-user-id="this.$store.state.userInfo.id"
                                @close="conclusionDialog = false"></month-conclusion-table-check>
  <!-- 月总结对话框（新） -->
  <month-conclusion-table-check-new v-if="conclusionDialogNew"
                                :moreDetailData = moreDetailData
                                :conclusionTitle="conclusionTitle"
                                :checkUserId="$store.state.userInfo.id"
                                @close="conclusionDialogNew = false"></month-conclusion-table-check-new>
</div>
</template>

<script>
  import {
    updateMonthConclusionStatus,
    getCurYearConclusionOverviewData,
    updateMonthConclusionNew } from '@/utils/conclusion'
  import {
    getCurApplyAbleMonth
  } from '@/utils/common'
  import monthConclusionTableCheck from './childViews/monthConclusionTableCheck'
  import monthConclusionTableCheckNew from './childViews/monthConclusionTableCheckNew.vue'
  import store from '@/store'
  export default {
    data () {
      return {
        title: this.$moment().format('YYYY'),
        descriptionContent: '1、首先查看评价标准，了解',
        rateTableData: [],
        curUser: this.$store.state.userInfo.id,
        reqFlag: {
          getCurYearConclusionOverviewData: true,
          updateMonthConclusionStatus: true,
          getCurApplyAbleMonth: true
        },
        curApplyYear: 1970,
        curApplyMonth: 1,
        conclusionDialog: false,
        conclusionDialogNew: false,
        conclusionTitle: null,
        curConclusion: null,
        nextPlan: null,
        curAdvice: null,
        selectId: null,
        managerEva: null,
        moreDetailData: []
      }
    },
    methods: {
      // 初始化
      init () {
        // 获取当前申报月份
        getCurApplyAbleMonth().then(getCurApplyAbleMonthRes => {
          this.curApplyYear = this.$moment(getCurApplyAbleMonthRes[0].setTime).year()
          this.curApplyMonth = this.$moment(getCurApplyAbleMonthRes[0].setTime).month() + 1
        }).catch(() => {
          this.$common.toast('获取当前申报月份错误', 'error', true)
        })
        // 生成表格数据
        this.genConclusionTableData()
      },
      // 生成表格数据
      genConclusionTableData () {
        this.reqFlag.getCurApplyAbleMonth = false
        // 获取年内所有月总结概览数据
        getCurYearConclusionOverviewData(this.title, this.curUser).then((response) => {
          // 初始化默认数据
          this.initDefaultData()
          for (let i = 0; i < response.length; i++) {
            let titleMonth = this.$moment(String(this.title) + '-' + String(i + 1)).format('YYYY-MM')
            if (this.$moment(titleMonth).isBefore(store.state.newRulesDate)) { // 请求的月份再新规则实施月份之前
              if (response[i].data) {
                this.rateTableData[i].conclusionTitle = response[i].data.conclusionTitle
                this.rateTableData[i].submitMonth = response[i].data.submitMonth
                this.rateTableData[i].submitStatus = response[i].data.submitStatus
                this.rateTableData[i].managerRateStar = response[i].data.managerRateStar
                this.rateTableData[i].getWorkTime = response[i].data.getWorkTime
                this.rateTableData[i].conclusionType = response[i].data.conclusionType
                this.rateTableData[i].id = response[i].data.id
                this.rateTableData[i].curConclusion = response[i].data.curConclusion
                this.rateTableData[i].nextPlan = response[i].data.nextPlan
                this.rateTableData[i].curAdvice = response[i].data.curAdvice
                this.rateTableData[i].managerEva = response[i].data.managerEva
              }
            } else {
              if (response[i].data.length !== 0) {
                this.rateTableData[i].conclusionTitle = response[i].data[0].conclusionType === 1 ? this.rateTableData[i].conclusionTitle : null
                this.rateTableData[i].submitMonth = response[i].data[0].conclusionMonth
                this.rateTableData[i].submitStatus = response[i].data[0].submitStatus
                this.rateTableData[i].managerRateStar = response[i].data[0].MGEvaStar
                // this.rateTableData[i].getWorkTime = response[i].data.getWorkTime
                this.rateTableData[i].conclusionType = response[i].data[0].conclusionType
                this.rateTableData[i].moreDetailData = response[i].data
                this.rateTableData[i].id = response[i].data[0].id
              }
            }
          }
          this.reqFlag.getCurApplyAbleMonth = true
        }).catch(err => {
          this.$common.toast('获取月总结概览数据错误', 'error', true)
          console.log(err)
          this.reqFlag.getCurApplyAbleMonth = true
        })
      },
      // 初始化表格默认数据
      initDefaultData () {
        this.rateTableData = []
        for (let i = 0; i < 12; i++) {
          let obj = {
            id: null,
            conclusionType: 1,
            month: i + 1 + '月份',
            submitMonth: i + 1,
            conclusionTitle: i + 1 + '月份总结',
            submitStatus: null,
            managerRateStar: null,
            getWorkTime: null,
            curConclusion: null,
            nextPlan: null,
            curAdvice: null,
            managerEva: null,
            moreDetailData: []
          }
          this.rateTableData.push(obj)
        }
      },
      // 点击预览
      handlePreview (row) {
        let titleMonth = this.$moment(String(this.title) + '-' + String(row.submitMonth)).format('YYYY-MM')
        if (this.$moment(titleMonth).isBefore(store.state.newRulesDate)) { // 请求的月份再新规则实施月份之前
          this.conclusionDialog = true
          this.curConclusion = row.curConclusion
          this.nextPlan = row.nextPlan
          this.curAdvice = row.curAdvice
          this.conclusionTitle = row.conclusionTitle
          this.selectId = row.id
          this.managerEva = row.managerEva
        } else {
          this.moreDetailData = row.moreDetailData
          this.conclusionTitle = row.conclusionTitle
          this.conclusionDialogNew = true
        }
      },
      // 编辑月总结
      handleEdit (row) {
        let titleMonth = this.$moment(String(this.title) + '-' + String(row.submitMonth)).format('YYYY-MM')
        if (this.$moment(titleMonth).isBefore(store.state.newRulesDate)) { // 请求的月份再新规则实施月份之前
          this.$router.push({
            path: '/home/monthConclusionTable',
            query: {
              id: row.id,
              conclusionTitle: row.conclusionTitle,
              submitYear: this.title,
              submitMonth: row.submitMonth,
              submitter: this.$store.state.userInfo.id,
              curConclusion: row.curConclusion,
              nextPlan: row.nextPlan,
              curAdvice: row.curAdvice
            }
          })
        } else {
          this.$router.push({
            path: '/home/monthConclusionTableNew',
            query: {
              conclusionTitle: row.conclusionTitle,
              submitYear: this.title,
              submitMonth: row.submitMonth,
              submitter: this.$store.state.userInfo.id,
              moreDetailData: row.moreDetailData
            }
          })
        }
      },
      // 提交月总结
      handleSubmit (row, submitStatus) {
        let titleMonth = this.$moment(String(this.title) + '-' + String(row.submitMonth)).format('YYYY-MM')
        if (this.$moment(titleMonth).isBefore(store.state.newRulesDate)) { // 请求的月份再新规则实施月份之前
          if (this.reqFlag.updateMonthConclusionStatus) {
            this.reqFlag.updateMonthConclusionStatus = false
            updateMonthConclusionStatus(row.id, submitStatus).then(() => {
              row.submitStatus = submitStatus
              this.reqFlag.updateMonthConclusionStatus = true
              this.$common.toast('操作成功', 'success', false)
            }).catch(() => {
              this.reqFlag.updateMonthConclusionStatus = true
              this.$common.toast('操作失败', 'error', false)
            })
          }
        } else {
          let promises = []
          let count = 0
          for (let item of row.moreDetailData) {
            promises[count++] = updateMonthConclusionNew(item.id, item.content, submitStatus)
          }
          Promise.all(promises).then(() => {
            row.submitStatus = submitStatus
            this.$common.toast('操作成功', 'success', false)
            this.$router.push({
              path: '/home/monthConclusion'
            })
          }).catch(err => {
            console.log(err)
            this.$common.toast('操作失败', 'error', true)
          })
        }
      },
      // 上一年
      handlePreYear () {
        this.title = this.$moment(this.title).subtract(1, 'year').format('YYYY')
        this.setMonthCookie(this.title, 7)
        this.handelDateChange()
      },
      // 下一年
      handleNextYear () {
        this.title = this.$moment(this.title).add(1, 'year').format('YYYY')
        this.setMonthCookie(this.title, 7)
        this.handelDateChange()
      },
      // 申报月份变化
      handelDateChange () {
        this.genConclusionTableData()
      },
      // 设置cookie
      setCookie (showTable, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'sst' + '=' + showTable + ';path=/;expires=' + exdate.toGMTString()
      },
      // 设置月份cookie
      setMonthCookie (month, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'mMon' + '=' + month + ';path=/;expires=' + exdate.toGMTString()
      },
      // 读取cookie
      getCookie: function () {
        if (document.cookie.length > 0) {
          let arr = document.cookie.split('; ') // 这里显示的格式需要切割一下自己可输出看下
          for (let i = 0; i < arr.length; i++) {
            let arr2 = arr[i].split('=') // 再次切割
            // 判断查找相对应的值
            if (arr2[0] === 'sst') {
              this.showFlag.descTableShow = arr2[1] === 'true'
            }
            if (arr2[0] === 'mMon') {
              this.title = arr2[1]
            }
          }
        }
      }
    },
    filters: {
      submitStatusFilter (status) {
        if (status === 1) {
          return 'success'
        } else if (status === 2) {
          return 'warning'
        } else if (status === 0) {
          return 'info'
        }
      },
      submitStatusTextFilter (status) {
        if (status === 1) {
          return '已提交'
        } else if (status === 2) {
          return '暂存'
        } else if (status === 0) {
          return '未提交'
        }
      },
      conclusionTypeFilter (status) {
        switch (status) {
          case 1:
            return 'success'
          case 2:
            return 'danger'
          default:
            return 'danger'
        }
      },
      conclusionTypeTextFilter (status) {
        switch (status) {
          case 1:
            return '月总结'
          case 2:
            return '年度总结'
          case 3:
            return '年中总结'
          default:
            return '错误'
        }
      },
      manageRateStatusTextFilter (status) {
        switch (status) {
          case 1:
            return '月总结'
          case 2:
            return '年度总结'
          case 3:
            return '年中总结'
          default:
            return '错误'
        }
      }
    },
    components: {
      monthConclusionTableCheck,
      monthConclusionTableCheckNew
    },
    created () {
      this.init()
    },
    watch: {
    },
    mounted () {
    },
    name: 'monthConclusion'
  }
</script>

<style scoped>
</style>

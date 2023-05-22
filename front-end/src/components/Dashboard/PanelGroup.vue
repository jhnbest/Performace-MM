<template>
  <div>
    <div>
      <el-button size="mini"
                 type="danger"
                 style="margin-right: 10px"
                 @click="handlePreMonth" :disabled="!reqFlag.getPerformanceScore">上月</el-button>
      <el-date-picker
        v-model="title"
        type="month"
        format="yyyy 第 MM 月"
        value-format="yyyy-MM"
        placeholder="选择月"
        style="width: 150px"
        @change="handelDateChange">
      </el-date-picker>
      <el-button size="mini"
                 type="primary"
                 style="margin-left: 10px"
                 @click="handleNextMonth"
                 :disabled="!reqFlag.getPerformanceScore">下月</el-button>
      <el-popover
        placement="bottom"
        width="500"
        trigger="click">
        <span>1、各评价指标的计算标准参照手册《通信工程处绩效管理办法》</span><br>
        <span slot="reference" class="pointer-type" style="margin-left: 20px"><i class="el-icon-warning-outline"></i>相关说明</span>
      </el-popover>
    </div>
    <div class="hr-10" style="margin-top: 20px; margin-bottom: 20px"></div>
    <!-- 季度、月度之星 -->
    <div>
      <el-row class="panel-group" :gutter="20">
        <!-- 季度之星 -->
        <el-col :xs="12" :sm="12" :lg="12" :xl="12">
          <div class="card-panel-large">
            <!-- 图标 -->
            <div class="card-panel-icon-wrapper">
              <span style="font-weight: bolder;font-size: 30px;">季度</span>
              <br>
              <span style="font-weight: bolder;font-size: 30px">之星</span>
            </div>
            <!-- 具体人员 -->
            <div v-if="quarterStars.length !== 0">
              <div class="card-panel-description" v-for="(quarterStar) in quarterStars" :key="quarterStar.name">
                <el-card slot="reference" shadow="hover" class="card-panel-text" @click.native="handleQuarterStarTabClick(quarterStar)">
                  {{quarterStar.name}}
                </el-card>
              </div>
              <!-- 月总结对话框（新） -->
              <month-conclusion-table-check-new-v-2 v-if="showConclusion"
                                                  :checkUserID ="curQuarterStar"
                                                  :months = "quarterMonth"
                                                  @close="showConclusion = false">
                                                </month-conclusion-table-check-new-v-2>
            </div>
            <!-- 季度数据未统计完毕 -->
            <div v-else style="float: center;font-weight: bold;margin-top: 60px;color: black;font-size:27px;text-align:center">
              暂未统计...
            </div>
          </div>
        </el-col>
        <!-- 月度之星 -->
        <el-col :xs="12" :sm="12" :lg="12" :xl="12">
          <div class="card-panel-large">
            <div class="card-panel-icon-wrapper">
              <span style="font-weight: bolder;font-size: 30px">月度</span>
              <br>
              <span style="font-weight: bolder;font-size: 30px">之星</span>
            </div>
            <div v-if="isCount">
              <div class="card-panel-description" v-for="(monthStar) in monthStars" :key="monthStar.name">
                <el-card slot="reference" shadow="hover" class="card-panel-text" @click.native="handleMonthStarsTabClick(monthStar)">
                  {{monthStar.name}}
                </el-card>
              </div>
              <!-- 月总结对话框（新） -->
              <month-conclusion-table-check-new-v-2 v-if="showConclusion2"
                                                  :checkUserID ="curMonthStar"
                                                  :months = "[title]"
                                                  @close="showConclusion2 = false">
                                                </month-conclusion-table-check-new-v-2>
            </div>
            <!-- 月度数据未统计完毕 -->
            <div v-else style="float: center;font-weight: bold;margin-top: 60px;color: black;font-size:27px;text-align:center">
              暂未统计...
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
    <!-- 绩效 -->
    <div>
      <el-row :gutter="40" class="panel-group">
        <el-col :xs="12" :sm="12" :lg="6" :xl="6">
          <div class="card-panel">
            <div class="card-panel-icon-wrapper icon-people">
              <svg-icon icon-class="rank-new" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                绩效得分
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="PMScoreUnN" :duration="1000" :decimals="2" class="card-panel-num" />
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
        <el-col :xs="12" :sm="12" :lg="6" :xl="6">
          <div class="card-panel">
            <div class="card-panel-icon-wrapper icon-message">
              <svg-icon icon-class="rank-new1" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                绩效排名
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="PMRank" :duration="1000" class="card-panel-num" />
                <span style="font-size: 19px">{{'/ ' + usersNumNotMG}}</span>
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
    <!-- 成效 -->
        <el-col :xs="6" :sm="6" :lg="6" :xl="6">
          <div class="card-panel">
            <div class="card-panel-icon-wrapper icon-money">
              <svg-icon icon-class="rank-new" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                成效得分
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="AMEvaScoreUnN" :duration="1000" :decimals="2" class="card-panel-num" />
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
        <el-col :xs="6" :sm="6" :lg="6" :xl="6">
          <div class="card-panel">
            <div class="card-panel-icon-wrapper icon-shopping">
              <svg-icon icon-class="rank-new1" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                成效排名
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="AMEvaRank" :duration="1000" class="card-panel-num" />
                <span style="font-size: 19px">{{'/ ' + usersNumNotMG}}</span>
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
    <!-- 工时 -->
    <div>
      <el-row :gutter="40" class="panel-group">
        <el-col :xs="8" :sm="8" :lg="8" :xl="8">
          <div class="card-panel">
            <div class="card-panel-icon-wrapper icon-money">
              <svg-icon icon-class="rank-new" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                工时数
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="totalWorkTime" :duration="1000" :decimals="2" class="card-panel-num" />
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
        <el-col :xs="8" :sm="8" :lg="8" :xl="8">
          <div class="card-panel">
            <div class="card-panel-icon-wrapper icon-shopping">
              <svg-icon icon-class="rank-new1" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                工时排名
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="QYEvaRank" :duration="1000" class="card-panel-num" />
                <span style="font-size: 19px">{{'/ ' + QYEvaNum}}</span>
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
    <!-- 定性评价 -->
        <el-col :xs="8" :sm="8" :lg="8" :xl="8">
          <div class="card-panel">
            <div class="card-panel-icon-wrapper icon-shopping">
              <svg-icon icon-class="rank-new" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                定性评价得分
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="QTEvaScore" :duration="1000" :decimals="2" class="card-panel-num" />
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import CountTo from 'vue-count-to'
import { getPerformanceIsPublish, getQuarterMon, sortObjectArrayByParams, isUndefined } from '@/utils/common'
import { getPMData } from '@/utils/performance'
import monthConclusionTableCheckNewV2 from '@/views/monthConclusion/childViews/monthConclusionTableCheckNewV2.vue'
import store from '@/store'
import moment from 'moment'
import Cookies from 'js-cookie'
export default {
  data () {
    return {
      title: this.$moment().format('YYYY-MM'),
      reqFlag: {
        getPerformanceScore: true
      },
      QTEvaScore: 0,
      QYEvaRank: 0,
      PMRank: 0,
      QYEvaNum: 0,
      usersNumNotMG: 0,
      isCount: false,
      totalWorkTime: null,
      PMScoreUnN: null,
      AMEvaScoreUnN: 0,
      AMEvaRank: 0,
      quarterStar1: '暂未统计',
      quarterStar2: '暂未统计',
      monthStar1: '暂未统计',
      monthStar2: '暂未统计',
      firstMonth: '',
      secondMonth: '',
      thirdMonth: '',
      quarterMonth: [],
      quarterStars: [],
      monthStars: [],
      isShowQuarterStar: false,
      activeMonth: [],
      showConclusion: false,
      showConclusion2: false,
      showConclusion3: false,
      conclusionTitle: null,
      curQuarterStar: null,
      curMonthStar: null,
      checkUser: null
    }
  },
  components: {
    CountTo,
    monthConclusionTableCheckNewV2
  },
  methods: {
    // 初始化
    init () {
      if (typeof (Cookies.get('hMon')) === 'undefined') {
        Cookies.set('hMon', this.title)
      }
      this.title = Cookies.get('hMon')
      this.initData()
    },
    // 初始化数据
    initData () {
      this.quarterStars = []
      this.monthStars = []
      this.reqFlag.getPerformanceScore = false
      let applyYear = this.$moment(this.title).year()
      let applyMonth = this.$moment(this.title).month() + 1
      let applyQuater = this.$moment(this.title).quarter()
      getPerformanceIsPublish(applyYear, applyMonth).then(getPerformanceIsPublishRes => {
        if (getPerformanceIsPublishRes.length > 0 && getPerformanceIsPublishRes[0].flagValue === 1) { // 绩效已经发布
          getPMData(this.title).then(PMData => {
            // 计算分组人数
            this.calGroupMemNum(PMData)
            // 根据绩效排名排序
            PMData.sort(function (a, b) {
              return a.PMRank - b.PMRank
            })
            let findResult = PMData.find(PMDataItem => {
              return PMDataItem.userID === store.state.userInfo.id
            })
            if (!isUndefined(findResult)) {
              this.QYEvaRank = findResult.QYEvaRank
              this.totalWorkTime = findResult.totalWorkTime
              this.PMRank = findResult.PMRank
              this.PMScoreUnN = findResult.PMScoreUnN
              // 2022年2月份及以后，每个岗位的定性评价占比都一样
              let isNewRule = moment(this.title).isAfter('2022-01')
              if (isNewRule) {
                this.QTEvaScore = (findResult.CSQTEvaScoreNor * 0.1 + findResult.MGQTEvaScoreNor * 0.2) / (0.1 + 0.2) // 计算定性评价得分
                this.AMEvaScoreUnN = findResult.AMEvaScoreUnN
                this.AMEvaRank = findResult.AMEvaRank
              } else { // 2022年2月份以前，根据岗位计算定性评价得分
                if (findResult.userDuty === 2) { // 组长
                  this.QTEvaScore = (findResult.CSQTEvaScoreNor * 0.3 + findResult.MGQTEvaScoreNor * 0.4) / (0.3 + 0.4)
                } else if (findResult.userJob === 4) { // 主任岗
                  this.QTEvaScore = (findResult.CSQTEvaScoreNor * 0.2 + findResult.MGQTEvaScoreNor * 0.3) / (0.2 + 0.3)
                } else { // 初中高岗
                  this.QTEvaScore = (findResult.CSQTEvaScoreNor * 0.1 + findResult.MGQTEvaScoreNor * 0.2) / (0.1 + 0.2)
                }
              }
            } else {
              this.QYEvaRank = 0
              this.totalWorkTime = 0
              this.PMRank = 0
              this.PMScoreUnN = 0
              this.QTEvaScore = 0
              this.AMEvaScoreUnN = 0
              this.AMEvaRank = 0
            }
            // ============================选取月度之星=============================
            let monthStarNum = this.$store.state.monthStarNum // 月度之星的人数
            for (let i = 0; i < monthStarNum; i++) {
              this.monthStars.push(PMData[i])
            }
            // ============================选取季度之星=============================
            this.getQuarStar(applyYear, applyQuater) // 季度之星数据计算
            this.isCount = true
            this.reqFlag.getPerformanceScore = true
          })
        } else { // 绩效未发布
          this.isCount = false
          this.reqFlag.getPerformanceScore = true
        }
      }).catch(err => {
        this.isCount = false
        this.reqFlag.getPerformanceScore = true
        console.log(err)
      })
    },
    // 季度之星数据获取
    getQuarStar (applyYear, applyQuater) {
      let quarterStarNum = this.$store.state.quarterStarNum
      let promises1 = []
      let promises2 = []
      let count = 0
      this.quarterMonth = getQuarterMon(applyYear, applyQuater) // 获取季度对应的月份
      for (let i = 0; i < this.quarterMonth.length; i++) { // 请求季度所有月份的绩效发布情况
        promises1[i] = getPerformanceIsPublish(applyYear, this.$moment(this.quarterMonth[i]).month() + 1)
      }
      Promise.all(promises1).then(allResponse1 => {
        let PMDataPublishInfo = allResponse1
        let isAllPMDataPublish = true
        // 判断所有月份的绩效是否已经发布
        for (let allResponse1Item of PMDataPublishInfo) {
          if (allResponse1Item.length === 0) { // 该月绩效尚未发布
            isAllPMDataPublish = false
            break
          } else {
            if (allResponse1Item[0].flagValue !== 1) { // 该月绩效尚未发布
              isAllPMDataPublish = false
              break
            }
          }
        }
        if (isAllPMDataPublish) { // 该季度所有月份绩效已经发布
          for (let i = 0; i < PMDataPublishInfo.length; i++) {
            promises2[count++] = getPMData(this.quarterMonth[i])
          }
          Promise.all(promises2).then(allResponse2 => {
            let allPMData = allResponse2
            let quarterPMData = []
            let firstMonPMData = allPMData[0]
            let secondMonPMData = allPMData[1]
            let thirdMonPMData = allPMData[2]
            for (let firstMonPMDataItem of firstMonPMData) {
              let secondFindResult = secondMonPMData.find(secondMonthPMDataItem => {
                return secondMonthPMDataItem.userID === firstMonPMDataItem.userID
              })
              let thirdFindResult = thirdMonPMData.find(thirdMonthPMDataItem => {
                return thirdMonthPMDataItem.userID === firstMonPMDataItem.userID
              })
              if (typeof (secondFindResult) !== 'undefined' && typeof (thirdFindResult) !== 'undefined') { // 如果该用户在第二和第三个月都还在
                let obj = {
                  id: firstMonPMDataItem.userID,
                  name: firstMonPMDataItem.name,
                  totalWorkTime: firstMonPMDataItem.totalWorkTime +
                    secondFindResult.totalWorkTime + thirdFindResult.totalWorkTime,
                  averagePMScoreUnN: (firstMonPMDataItem.PMScoreUnN +
                    secondFindResult.PMScoreUnN + thirdFindResult.PMScoreUnN) / 3
                }
                quarterPMData.push(obj)
              } else if (typeof (secondFindResult) === 'undefined') { // 如果该用户第二个月离职了
                let obj = {
                  id: firstMonPMDataItem.id,
                  name: firstMonPMDataItem.name,
                  totalWorkTime: firstMonPMDataItem.totalWorkTime,
                  averagePMScoreUnN: firstMonPMDataItem.performanceScoreTmp
                }
                quarterPMData.push(obj)
              } else if (typeof (thirdFindResult) === 'undefined') { // 如果该用户第三个月离职了
                let obj = {
                  id: firstMonPMDataItem.id,
                  name: firstMonPMDataItem.name,
                  totalWorkTime: firstMonPMDataItem.totalWorkTime + secondFindResult.totalWorkTime,
                  averagePMScoreUnN: (firstMonPMDataItem.performanceScoreTmp + secondFindResult.performanceScoreTmp) / 2
                }
                quarterPMData.push(obj)
              }
            }
            quarterPMData = sortObjectArrayByParams(quarterPMData, 'averagePMScoreUnN', 'totalWorkTime')
            for (let i = 0; i < quarterStarNum; i++) {
              this.quarterStars.push(quarterPMData[i])
            }
          })
        } else { // 尚有月份未发布绩效
          this.quarterStars = []
        }
      })
    },
    // 分组人数计算
    calGroupMemNum (PMData) {
      let standAndEngineerRates = []
      let standGroupMembers = []
      let engineerGroupMembers = []
      let communicationRates = []
      this.usersNumNotMG = PMData.length
      for (let PMDataItem of PMData) {
        if (PMDataItem.groupID === 1 || PMDataItem.groupID === 2) {
          if (PMDataItem.groupID === 1) {
            standGroupMembers.push(PMDataItem)
          } else {
            engineerGroupMembers.push(PMDataItem)
          }
          standAndEngineerRates.push(PMDataItem)
        } else if (PMDataItem.groupID === 3) {
          communicationRates.push(PMDataItem)
        }
      }
      if (store.state.userInfo.groupID === 1 ||
        store.state.userInfo.groupID === 2) {
        if (store.state.userInfo.groupID === 1) {
          this.QYEvaNum = standGroupMembers.length
        } else {
          this.QYEvaNum = engineerGroupMembers.length
        }
      } else {
        this.QYEvaNum = communicationRates.length
      }
    },
    // 设置月份cookie
    setMonthCookie (month, exdays) {
      let exdate = new Date() // 获取时间
      exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
      // 字符串拼接cookie
      window.document.cookie = 'hMon' + '=' + month + ';path=/;expires=' + exdate.toGMTString()
    },
    // 读取cookie
    getMonthCookie: function () {
      if (document.cookie.length > 0) {
        let arr = document.cookie.split('; ') // 这里显示的格式需要切割一下自己可输出看下
        for (let i = 0; i < arr.length; i++) {
          let arr2 = arr[i].split('=') // 再次切割
          // 判断查找相对应的值
          if (arr2[0] === 'hMon') {
            this.title = arr2[1]
          }
        }
      }
    },
    // 上一月
    handlePreMonth () {
      this.title = this.$moment(this.title).subtract(1, 'months').format('YYYY-MM')
      if (typeof (Cookies.get('hMon')) !== 'undefined') {
        Cookies.remove('hMon')
      }
      Cookies.set('hMon', this.title)
      this.initData()
    },
    // 下一月
    handleNextMonth () {
      // const url = '/performance/test'
      // let params = {}
      // http(url, params).then(res => {
      //   console.log(res)
      // })
      this.title = this.$moment(this.title).add(1, 'months').format('YYYY-MM')
      if (typeof (Cookies.get('hMon')) !== 'undefined') {
        Cookies.remove('hMon')
      }
      Cookies.set('hMon', this.title)
      this.initData()
    },
    // 日期变化调用
    handelDateChange () {
      if (typeof (Cookies.get('hMon')) !== 'undefined') {
        Cookies.remove('hMon')
      }
      Cookies.set('hMon', this.title)
      this.initData()
    },
    // 查看季度之星月总结
    handleQuarterStarTabClick (quarterStar) {
      this.curQuarterStar = quarterStar
      this.showConclusion = true
    },
    // 查看月度之星月总结
    handleMonthStarsTabClick (monthStar) {
      this.curMonthStar = { id: monthStar.userID, name: monthStar.name }
      this.showConclusion2 = true
    }
  },
  created () {
    this.init()
  },
  computed: {
  }
}
</script>

<style lang="scss" scoped>
.panel-group {
  margin: 20px;
  .card-panel {
    height: 108px;
    font-size: 12px;
    position: relative;
    overflow: hidden;
    color: #666;
    background: #fff;
    box-shadow: 4px 4px 40px rgba(0, 0, 0, .05);
    border-color: rgba(0, 0, 0, .05);
    .card-panel-icon-wrapper {
      float: left;
      margin: 14px 0 0 14px;
      padding: 16px;
      transition: all 0.38s ease-out;
      border-radius: 6px;
    }

    .card-panel-icon {
      float: left;
      font-size: 48px;
    }

    .card-panel-description {
      float: right;
      font-weight: bold;
      margin: 26px;
      margin-left: 0px;

      .card-panel-text {
        line-height: 30px;
        color: rgba(0, 0, 0, 1);
        font-size: 17px;
        margin-bottom: 12px;
        text-align: center;
        cursor: pointer;
      }

      .card-panel-num {
        font-size: 19px;
      }
    }
  }
  .card-panel-large {
    height: 150px;
    font-size: 12px;
    position: relative;
    overflow: hidden;
    color: #e50000;
    background: #fff;
    border-radius: 4px;

    .card-panel-icon-wrapper {
      float: left;
      margin: 20px 0 0 24px;
      padding: 16px;
    }
    .card-panel-description {
      width: 35%;
      float: left;
      font-weight: bold;
      margin-top: 50px;
      margin-left: 10px;

      .card-panel-text {
        line-height: 20px;
        color: rgba(0, 0, 0, 1);
        font-size: 27px;
        text-align: center;
        cursor: pointer;
        // &:hover {
        //   color: rgb(1, 182, 253);
        // }
      }

      .card-panel-num {
        font-size: 19px;
      }
    }
  }
}
</style>

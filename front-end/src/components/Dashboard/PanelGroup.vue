<template>
  <div>
    <div class="dashboard-container">
      <!-- 页面顶部区域 -->
      <div class="dashboard-header">
        <div class="header-title">
          <i class="fas fa-chart-line"></i>
          绩效看板
        </div>
        <div class="date-control">
          <button class="control-btn" @click="handlePreMonth" :disabled="!reqFlag.getPerformanceScore">上月
          </button>
          <el-date-picker
            class="date-picker"
            v-model="title"
            type="month"
            format="yyyy 第 MM 月"
            value-format="yyyy-MM"
            placeholder="选择月份"
            @change="handelDateChange">
          </el-date-picker>
          <button class="control-btn" @click="handleNextMonth" :disabled="!reqFlag.getPerformanceScore">下月
          </button>
          <!-- 填充测试数据按钮（根据实际需要保留） -->
          <el-button
            v-if="false"
            size="mini"
            type="text"
            style="margin-left: 15px"
            @click="test"
            :disabled="!reqFlag.getPerformanceScore">
            填充空白数据
          </el-button>
        </div>
      </div>

      <!-- 季度和月度之星区域 -->
      <div class="star-panels">
        <!-- 季度之星 -->
        <div class="star-panel quarter-panel">
          <div class="panel-header">
            <i class="fas fa-crown panel-icon"></i>
            <span class="panel-title">季度之星</span>
          </div>
          <div class="star-content">
            <div v-if="quarterStars.length !== 0" class="star-list">
              <div
                v-for="(quarterStar) in quarterStars"
                :key="quarterStar.name"
                class="star-card quarter-star"
                @click="handleQuarterStarTabClick(quarterStar)">
                <svg-icon v-if="quarterStar.name == '黄雅婷' || quarterStar.name == '顾心瑜'
                 || quarterStar.name == '陈丹雅'" icon-class="白领" class="star-avatar" />
                <svg-icon v-else icon-class="经理" class="star-avatar" />
                <div class="star-name">{{ quarterStar.name }}</div>
              </div>
            </div>
            <div v-else class="no-data">
              <i class="fas fa-chart-bar"></i>
              <span>暂未统计...</span>
            </div>
          </div>
        </div>

        <!-- 月度之星 -->
        <div class="star-panel month-panel">
          <div class="panel-header">
            <i class="fas fa-medal panel-icon"></i>
            <span class="panel-title">月度之星</span>
          </div>
          <div class="star-content">
            <div v-if="isCount" class="star-list">
              <div
                v-for="(monthStar) in monthStars"
                :key="monthStar.name"
                class="star-card month-star"
                @click="handleMonthStarsTabClick(monthStar)">
                <svg-icon v-if="monthStar.name == '黄雅婷' || monthStar.name == '顾心瑜'
                 || monthStar.name == '陈丹雅'" icon-class="白领" class="star-avatar" />
                <svg-icon v-else icon-class="经理" class="star-avatar" />
                <div class="star-name">{{ monthStar.name }}</div>
              </div>
            </div>
            <div v-else class="no-data">
              <i class="fas fa-chart-bar"></i>
              <span>暂未统计...</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 绩效指标区域 -->
      <div class="metric-group">
        <h2 class="group-title">绩效数据</h2>
        <div class="metric-grid">
          <div class="metric-card performance-score">
            <i class="fas fa-chart-line metric-icon"></i>
            <div class="metric-title">绩效得分(标准化)</div>
            <div v-if="isCount">
              <div class="metric-value">{{ PMScoreNor }}</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>

          <div class="metric-card performance-rank">
            <i class="fas fa-trophy metric-icon"></i>
            <div class="metric-title">绩效排名</div>
            <div v-if="isCount">
              <div class="metric-value">{{ PMRank }}</div>
              <div class="metric-rank">共 {{ usersNumNotMG }} 人</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>
        </div>
      </div>

      <!-- 成效/定量/定性评价数据区域 -->
      <div class="metric-group">
        <h2 class="group-title">成效/定量/定性评价数据</h2>
        <div class="metric-grid">
          <div class="metric-card efficiency-score">
            <i class="fas fa-tachometer-alt metric-icon"></i>
            <div class="metric-title">成效得分</div>
            <div v-if="isCount">
              <div class="metric-value">{{ AMEvaScoreUnN }}</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>

          <div class="metric-card efficiency-rank">
            <i class="fas fa-chart-bar metric-icon"></i>
            <div class="metric-title">成效排名</div>
            <div v-if="isCount">
              <div class="metric-value">{{ AMEvaRank }}</div>
              <div class="metric-rank">共 {{ usersNumNotMG }} 人</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>

          <div class="metric-card work-hour">
            <i class="fas fa-clock metric-icon"></i>
            <div class="metric-title">工时数</div>
            <div v-if="isCount">
              <div class="metric-value">{{ totalWorkTime }}</div>
              <div class="metric-rank">小时</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>

          <div class="metric-card work-rank">
            <i class="fas fa-sort-amount-up metric-icon"></i>
            <div class="metric-title">工时排名</div>
            <div v-if="isCount">
              <div class="metric-value">{{ QYEvaRank }}</div>
              <div class="metric-rank">共 {{ usersNumNotMG }} 人</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>

          <div class="metric-card qualitative">
            <i class="fas fa-comments metric-icon"></i>
            <div class="metric-title">定性评价得分</div>
            <div v-if="isCount">
              <div class="metric-value">{{ QTEvaScore }}</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>
        </div>
      </div>

      <!-- 处室绩效加分数据区域 -->
      <div class="metric-group">
        <h2 class="group-title">处室绩效加分数据</h2>
        <div class="bonus-data-container">
          <el-table :data="bonusData" style="width: 100%" :height="tableHeight" :row-class-name="tableRowClassName">
            <el-table-column type="index" label="序号" width="100" align="center"></el-table-column>
            <el-table-column prop="name" label="加分人" width="180" align="center"></el-table-column>
            <el-table-column prop="assignScore" label="加分值" width="140" align="center">
              <template slot-scope="scope">
                <span v-if="scope.row.assignScore > 0" class="points-highlight">{{ scope.row.assignScore }}</span>
                <span v-else class="points-highlight2">{{ scope.row.assignScore }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="PBName" label="加分明细">
              <template slot-scope="scope">
                <div v-html="scope.row.PBName"></div>
              </template>
            </el-table-column>
          </el-table>

          <div v-if="bonusData.length === 0" class="no-bonus-data">
            <i class="fas fa-info-circle"></i>
            <span>暂无绩效加分数据记录</span>
          </div>
        </div>
      </div>

      <!-- 工时和定性评价区域 -->
      <!-- <div class="metric-group">
        <h2 class="group-title">工时、定性评价数据</h2>
        <div class="metric-grid">
          <div class="metric-card work-hour">
            <i class="fas fa-clock metric-icon"></i>
            <div class="metric-title">工时数</div>
            <div v-if="isCount">
              <div class="metric-value">{{ totalWorkTime }}</div>
              <div class="metric-rank">小时</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>

          <div class="metric-card work-rank">
            <i class="fas fa-sort-amount-up metric-icon"></i>
            <div class="metric-title">工时排名</div>
            <div v-if="isCount">
              <div class="metric-value">{{ QYEvaRank }}</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>

          <div class="metric-card qualitative">
            <i class="fas fa-comments metric-icon"></i>
            <div class="metric-title">定性评价得分</div>
            <div v-if="isCount">
              <div class="metric-value">{{ QTEvaScore }}</div>
            </div>
            <div v-else class="not-counted">
              暂未统计
            </div>
          </div>
        </div>
      </div> -->

      <!-- 底部说明区域 -->
      <div class="tips">
        <span class="tip-tag">
          <i class="fas fa-info-circle"></i>
          <span>评价指标计算标准参照《通信工程处绩效管理办法》</span>
        </span>
      </div>
    </div>

    <!-- 月总结对话框组件（保持原逻辑） -->
    <month-conclusion-table-check-new-v-2 v-if="showConclusion" :checkUserID="curQuarterStar" :months="quarterMonth" @close="showConclusion = false"></month-conclusion-table-check-new-v-2>
    <month-conclusion-table-check-new-v-2 v-if="showConclusion2" :checkUserID="curMonthStar" :months="[title]" @close="showConclusion2 = false"></month-conclusion-table-check-new-v-2>
  </div>
</template>

<script>
import { getPerformanceIsPublish, getQuarterMon, sortObjectArrayByParams, isUndefined } from '@/utils/common'
import { getPMData } from '@/utils/performance'
import monthConclusionTableCheckNewV2 from '@/views/monthConclusion/childViews/monthConclusionTableCheckNewV2.vue'
import store from '@/store'
import moment from 'moment'
import Cookies from 'js-cookie'
import { http } from '@/config/http'
import { Notification } from 'element-ui'
import { getPBData } from '@/utils/performanceBonus'

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
      PMScoreNor: null,
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
      checkUser: null,
      bonusData: [],
      tableHeight: 320
    }
  },
  components: {
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
        // ***判断绩效数据发布状态
        if (getPerformanceIsPublishRes.length > 0 && getPerformanceIsPublishRes[0].flagValue === 1) { // **如果绩效已经发布，直接读取绩效
          getPMData(this.title).then(PMData => {
            // ***计算分组人数
            this.calGroupMemNum(PMData)
            // ***根据绩效排名排序
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
              this.PMScoreNor = findResult.PMScoreNor
              // 2022年2月份及以后，每个岗位的定性评价占比都一样
              let isNewRule = moment(this.title).isAfter('2022-01')
              if (isNewRule) {
                if (!moment(this.title).isAfter('2025-12')) {
                  this.QTEvaScore = Number((findResult.CSQTEvaScoreNor * 0.1 + findResult.MGQTEvaScoreNor * 0.2) / (0.1 + 0.2)).toFixed(2) // 计算定性评价得分
                } else {
                  this.QTEvaScore = Number((findResult.CSQTEvaScoreUnN * 0.1 + findResult.MGQTEvaScoreUnN * 0.2) / (0.1 + 0.2)).toFixed(2) // 计算定性评价得分
                }
                this.AMEvaScoreUnN = findResult.AMEvaScoreUnN
                this.AMEvaRank = findResult.AMEvaRank
              } else { // 2022年2月份以前，根据岗位计算定性评价得分
                if (findResult.userDuty === 2) { // 组长
                  this.QTEvaScore = Number((findResult.CSQTEvaScoreNor * 0.3 + findResult.MGQTEvaScoreNor * 0.4) / (0.3 + 0.4)).toFixed(2)
                } else if (findResult.userJob === 4) { // 主任岗
                  this.QTEvaScore = Number((findResult.CSQTEvaScoreNor * 0.2 + findResult.MGQTEvaScoreNor * 0.3) / (0.2 + 0.3)).toFixed(2)
                } else { // 初中高岗
                  this.QTEvaScore = Number((findResult.CSQTEvaScoreNor * 0.1 + findResult.MGQTEvaScoreNor * 0.2) / (0.1 + 0.2)).toFixed(2)
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
            // ***选取月度之星
            let monthStarNum = this.$store.state.monthStarNum // **月度之星的人数
            for (let i = 0; i < monthStarNum; i++) {
              this.monthStars.push(PMData[i])
            }
            // ***选取季度之星
            this.getQuarStar(applyYear, applyQuater) // **季度之星数据计算
            this.isCount = true
            this.reqFlag.getPerformanceScore = true
          })
          getPBData(applyYear, applyMonth).then(getPBDataRes => {
            this.bonusData = []
            let bonusDataTmp = []
            let mergebonusData = []
            if (getPBDataRes.length === 0) { return }
            let getPBDataResReviewPass = getPBDataRes.filter(Res => { return Res.reviewStatus === 1 })
            for (let getPBDataResReviewPassItem1 of getPBDataResReviewPass) {
              for (let getPBDataResReviewPassItem2 of getPBDataResReviewPassItem1.PBScoreAssign) {
                if (getPBDataResReviewPassItem2.assignScore !== 0) {
                  let obj = {
                    name: getPBDataResReviewPassItem2.name,
                    assignScore: getPBDataResReviewPassItem2.assignScore,
                    PBName: getPBDataResReviewPassItem1.PBName,
                    PBRule: getPBDataResReviewPassItem1.PBRule
                  }
                  bonusDataTmp.push(obj)
                }
              }
            }
            let count = 0
            bonusDataTmp.forEach(bonusDataTmpItem => {
              const existingItem = mergebonusData.find(mergebonusDataItem => mergebonusDataItem.name === bonusDataTmpItem.name)
              if (existingItem) {
                // 找到同名项：更新数据
                existingItem.assignScore += bonusDataTmpItem.assignScore
                existingItem.PBName.push({
                  count: (existingItem.PBName[existingItem.PBName.length - 1].count) + 1,
                  PBName: bonusDataTmpItem.PBName,
                  assignScore: bonusDataTmpItem.assignScore
                })
              } else {
                // 未找到同名项：创建新项
                count = 0
                mergebonusData.push({
                  name: bonusDataTmpItem.name,
                  assignScore: bonusDataTmpItem.assignScore,
                  PBName: [{
                    count: ++count,
                    PBName: bonusDataTmpItem.PBName,
                    assignScore: bonusDataTmpItem.assignScore
                  }]
                })
              }
            })

            this.bonusData = mergebonusData.map(mergebonusDataItem => {
              // 格式化原因字符串,每个事项格式为"原因+分值"
              let PBName = null
              if (mergebonusDataItem.assignScore > 0) {
                PBName = mergebonusDataItem.PBName
                .map(r => `${r.count}、${r.PBName} + ${r.assignScore.toFixed(2)}`)
                .join('<br>')
              } else {
                PBName = mergebonusDataItem.PBName
                .map(r => `${r.count}、${r.PBName} ${r.assignScore.toFixed(2)}`)
                .join('<br>')
              }

              // 返回可直接放入表格的对象
              return {
                name: mergebonusDataItem.name,
                assignScore: parseFloat(mergebonusDataItem.assignScore.toFixed(2)), // 保留两位小数
                PBName: PBName
              }
            }).sort((a, b) => {
              // 比较b和a，实现倒序排序
              return b.assignScore - a.assignScore
            })
          })
        } else { // **绩效未发布
          this.bonusData = []
          this.isCount = false
          this.reqFlag.getPerformanceScore = true
        }
      }).catch(err => {
        this.bonusData = []
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
    // ***分组人数计算
    calGroupMemNum (PMData) {
      let multiMediaGroup = PMData.filter(user => { return user.groupID === 2 }) // **过滤多媒体应用组
      let digitalGroup = PMData.filter(user => { return user.groupID === 3 }) // **过滤数字物联应用组
      let zongheGroup = PMData.filter(user => { return user.groupID === 4 }) // **过滤综合业务组
      let communeGroup = PMData.filter(user => { return user.groupID === 5 }) // **过滤通信组
      this.usersNumNotMG = PMData.length
      switch (store.state.userInfo.groupID) {
        case 2:
          this.QYEvaNum = multiMediaGroup.length
          break
        case 3:
          this.QYEvaNum = digitalGroup.length
          break
        case 4:
          this.QYEvaNum = zongheGroup.length
          break
        case 5:
          this.QYEvaNum = communeGroup.length
          break
        default:
          this.QYEvaNum = PMData.length
          break
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
      this.title = this.$moment(this.title).add(1, 'months').format('YYYY-MM')
      if (typeof (Cookies.get('hMon')) !== 'undefined') {
        Cookies.remove('hMon')
      }
      Cookies.set('hMon', this.title)
      this.initData()
    },
    test () {
      const url = '/performance/test'
      let params = {}
      http(url, params).then(res => {
        Notification.success({
          title: '成功',
          message: '插入成功'
        })
      }).catch(err => {
        console.log(err)
      })
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
    },
    // 表格行样式
    tableRowClassName ({ row, rowIndex }) {
      if (rowIndex % 2 === 0) {
        return 'even-row'
      }
      return 'odd-row hover-row'
    }
  },
  created () {
    this.init()
  },
  computed: {
  }
}
</script>

<style>
:root {
      --primary: #00BFFF;
      --primary-light: #64b5f6;
      --secondary: #26a695;
      --success: #66bb6a;
      --info: #26c6da;
      --warning: #ffb300;
      --danger: #f44336;
      --dark: #263238;
      --light: #f5f7fa;
      --border: #e0e0e0;
      --shadow: 0 4px 12px rgba(0,0,0,0.08);
      --transition: all 0.3s ease;
    }

    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Segoe UI', 'Microsoft YaHei', sans-serif;
      background-color: #f5f9fd;
      color: #333;
      line-height: 1.6;
    }

    .dashboard-container {
      max-width: 1800px;
      margin: auto;
      padding: 0 20px;
    }

    .dashboard-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      padding: 15px 0;
      border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    }

    .header-title {
      font-size: 26px;
      font-weight: 600;
      color: var(--dark);
      display: flex;
      align-items: center;
    }

    .header-title i {
      margin-right: 15px;
      color: var(--primary);
    }

    .date-control {
      display: flex;
      align-items: center;
      background: white;
      padding: 5px 15px;
      border-radius: 30px;
      box-shadow: var(--shadow);
      transition: var(--transition);
    }

    .date-control:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 16px rgba(0,0,0,0.12);
    }

    .control-btn {
      border: none;
      background: var(--primary);
      color: white;
      width: 36px;
      height: 36px;
      border-radius: 50%;
      cursor: pointer;
      font-size: 14px;
      display: flex;
      align-items: center;
      justify-content: center;
      transition: var(--transition);
    }

    .control-btn:hover {
      background: #1565c0;
      transform: scale(1.05);
    }

    .control-btn:disabled {
      background: #bbdefb;
      cursor: not-allowed;
      transform: none;
    }

    .date-picker {
      margin: 0 10px;
      width: 180px;
    }

    .star-panels {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
      gap: 25px;
      margin-bottom: 30px;
    }

    .star-panel {
      background: white;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: var(--shadow);
      transition: var(--transition);
    }

    .star-panel:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 25px rgba(0,0,0,0.1);
    }

    .panel-header {
      padding: 18px 25px;
      color: white;
      display: flex;
      align-items: center;
      font-weight: 600;
    }

    .quarter-panel .panel-header {
      background: linear-gradient(135deg, var(--primary), var(--primary-light));
    }

    .month-panel .panel-header {
      background: linear-gradient(135deg, var(--secondary), var(--info));
    }

    .panel-icon {
      font-size: 28px;
      margin-right: 15px;
    }

    .panel-title {
      font-size: 22px;
      letter-spacing: 0.5px;
    }

    .star-content {
      padding: 25px;
      min-height: 200px;
    }

    .star-list {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
      gap: 15px;
    }

    .star-card {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 20px 15px;
      background: var(--light);
      border-radius: 12px;
      transition: var(--transition);
      cursor: pointer;
      text-align: center;
    }

    .star-card:hover {
      transform: translateY(-3px);
      background: var(--light);
      box-shadow: 0 4px 8px rgba(0,0,0,0.08);
    }

    .star-avatar {
      width: 70px;
      height: 70px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      margin-bottom: 15px;
      font-size: 80px;
    }

    .quarter-star .star-avatar {
      /* background: linear-gradient(135deg, var(--primary), var(--primary-light)); */
    }

    .month-star .star-avatar {
      /* background: linear-gradient(135deg, var(--secondary), var(--info)); */
    }

    .star-name {
      font-weight: 600;
      font-size: 28px;
      color: var(--dark);
    }

    .no-data {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 140px;
      font-size: 19px;
      color: #90a4ae;
      font-weight: 500;
    }

    .no-data i {
      font-size: 24px;
      margin-right: 12px;
    }

    .metric-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 25px;
      margin-bottom: 30px;
    }

    .metric-group {
      margin-bottom: 25px;
    }

    .group-title {
      font-size: 20px;
      font-weight: 600;
      color: var(--dark);
      margin: 25px 0 15px 0;
      padding-left: 15px;
      border-left: 4px solid var(--primary);
    }

    .metric-card {
      background: white;
      border-radius: 16px;
      padding: 25px;
      box-shadow: var(--shadow);
      transition: var(--transition);
      position: relative;
      overflow: hidden;
      height: 100%;
    }

    .metric-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 25px rgba(0,0,0,0.12);
    }

    .metric-card::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      height: 5px;
      width: 100%;
    }

    .performance-score .metric-card::before {
      background: linear-gradient(90deg, var(--primary), var(--primary-light));
    }

    .performance-rank .metric-card::before {
      background: linear-gradient(90deg, #5c6bc0, #7986cb);
    }

    .efficiency-score .metric-card::before {
      background: linear-gradient(90deg, var(--success), #81c784);
    }

    .efficiency-rank .metric-card::before {
      background: linear-gradient(90deg, var(--secondary), #26c6da);
    }

    .work-hour .metric-card::before {
      background: linear-gradient(90deg, #ffa726, #ffb74d);
    }

    .work-rank .metric-card::before {
      background: linear-gradient(90deg, #ff7043, #ff8a65);
    }

    .qualitative .metric-card::before {
      background: linear-gradient(90deg, #ab47bc, #ba68c8);
    }

    .metric-icon {
      font-size: 36px;
      margin-bottom: 20px;
      opacity: 0.8;
    }

    .metric-title {
      font-size: 16px;
      color: #78909c;
      margin-bottom: 15px;
      font-weight: 500;
    }

    .metric-value {
      font-size: 36px;
      font-weight: 700;
      margin-bottom: 8px;
      background: linear-gradient(to right, var(--primary), var(--primary-light));
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
    }

    .metric-rank {
      font-size: 18px;
      color: #78909c;
    }

    .not-counted {
      color: #f44336;
      font-size: 16px;
      font-weight: 500;
    }

    .tips {
      display: flex;
      justify-content: flex-end;
      margin-top: 30px;
    }

    .tip-tag {
      display: inline-flex;
      align-items: center;
      background: white;
      padding: 10px 18px;
      border-radius: 50px;
      font-size: 14px;
      color: #78909c;
      box-shadow: 0 2px 6px rgba(0,0,0,0.05);
      transition: var(--transition);
    }

    .tip-tag:hover {
      color: var(--primary);
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .tip-tag i {
      margin-right: 10px;
      color: var(--primary);
    }

    .bonus-data-container {
        background: white;
        border-radius: 16px;
        padding: 25px;
        box-shadow: var(--shadow);
        min-height: 350px;
        max-height: 400px;
        overflow: hidden;
        position: relative;
      }

    .bonus-data-container::before {
      content: "";
      position: absolute;
      top: 0;
      left: 0;
      height: 5px;
      width: 100%;
      background: linear-gradient(90deg, #4facfe, #00f2fe);
    }

    .points-highlight {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      background: linear-gradient(to right, #4facfe, #00f2fe);
      color: white;
      font-weight: bold;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    .points-highlight2 {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      background: linear-gradient(to right, #ff0000, #fe009d);
      color: white;
      font-weight: bold;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }

    .no-bonus-data {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      height: 280px;
      color: #9e9e9e;
      font-size: 18px;
    }

    .no-bonus-data i {
      font-size: 64px;
      margin-bottom: 20px;
      color: #e0e0e0;
    }

    /* 表格行悬停效果 */
    .el-table .hover-row {
      transition: transform 0.3s ease;
    }

    .el-table .hover-row:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
    }

    /* 美化表头 */
    .el-table thead {
      color: #5d6d7e;
      font-weight: 600;
    }

    .el-table th {
      background-color: #f8f9fa !important;
      padding: 12px 0 !important;
    }

    @media (max-width: 768px) {
      .dashboard-header {
        flex-direction: column;
        align-items: flex-start;
      }

      .date-control {
        margin-top: 15px;
        width: 100%;
        justify-content: space-between;
      }

      .star-panels {
        grid-template-columns: 1fr;
      }

      .metric-grid {
        grid-template-columns: 1fr;
      }
    }
</style>

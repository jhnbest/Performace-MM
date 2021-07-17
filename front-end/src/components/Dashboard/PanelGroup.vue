<template>
  <div>
    <div>
      <el-button size="mini"
                 type="danger"
                 style="margin-right: 10px"
                 @click="handlePreMonth" :disabled="!reqFlag.getPerformanceScore">上月</el-button>
      <el-date-picker
        v-model="formData.title"
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
<!--        <span>1、每月的绩效得分、定量和定性互评得分以及相应的排名将于-->
<!--          <span style="font-weight: bolder;color: red">每月工时申报及互评截止后(每月3日0点)</span>进行统计；-->
<!--        </span><br>-->
        <span>1、各评价指标的计算标准参照手册《通信工程处绩效管理办法》</span><br>
        <span slot="reference" @click="dashboardAbout" class="pointer-type" style="margin-left: 20px"><i class="el-icon-warning-outline"></i>相关说明</span>
      </el-popover>
    </div>
    <div class="hr-10" style="margin-top: 20px; margin-bottom: 20px"></div>
    <div>
      <el-row class="panel-group">
        <el-col :xs="24" :sm="24" :lg="12" :xl="8" class="card-panel-col">
          <div class="card-panel-large">
            <div class="card-panel-icon-wrapper icon-people">
              <span style="font-weight: bolder;font-size: 30px;margin-left: -10px">{{selectQuarterNum}}季度</span>
              <br>
              <span style="font-weight: bolder;font-size: 30px">之星</span>
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text icon-quarter" slot="reference">{{quarterStar.name}}</div>
            </div>
          </div>
        </el-col>
        <el-col :xs="24" :sm="24" :lg="6" :xl="6" class="card-panel-col">
          <div class="card-panel-large">
            <div class="card-panel-icon-wrapper icon-month">
              <span style="font-weight: bolder;font-size: 30px">月度</span>
              <br>
              <span style="font-weight: bolder;font-size: 30px">之星</span>
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">{{monthStar.name}}</div>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
    <div>
      <el-row :gutter="40" class="panel-group">
        <el-col :xs="12" :sm="12" :lg="6" :xl="4" class="card-panel-col">
          <div class="card-panel" @click="handleSetLineChartData('newVisitis')">
            <div class="card-panel-icon-wrapper icon-people">
              <svg-icon icon-class="score-red" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                绩效得分
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="performanceScoreTmp" :duration="1000" :decimals="2" class="card-panel-num" />
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
        <el-col :xs="12" :sm="12" :lg="6" :xl="4" class="card-panel-col">
          <div class="card-panel" @click="handleSetLineChartData('messages')">
            <div class="card-panel-icon-wrapper icon-message">
              <svg-icon icon-class="ranks" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                绩效排名
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="performanceRank" :duration="1000" class="card-panel-num" />
                <span style="font-size: 19px">{{'/ ' + usersNum}}</span>
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
        <el-col :xs="12" :sm="12" :lg="6" :xl="4" class="card-panel-col">
          <div class="card-panel" @click="handleSetLineChartData('purchases')">
            <div class="card-panel-icon-wrapper icon-money">
              <svg-icon icon-class="score-blue" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                工时数
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="workTimeNum" :duration="1000" :decimals="2" class="card-panel-num" />
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
        <el-col :xs="12" :sm="12" :lg="6" :xl="4" class="card-panel-col">
          <div class="card-panel" @click="handleSetLineChartData('shoppings')">
            <div class="card-panel-icon-wrapper icon-shopping">
              <svg-icon icon-class="rank-blue" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                工时排名
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="quantitativeRank" :duration="1000" class="card-panel-num" />
                <span style="font-size: 19px">{{'/ ' + quantitativeNum}}</span>
              </div>
              <div v-else>
                <span style="font-size: 15px;color: red">暂未统计</span>
              </div>
            </div>
          </div>
        </el-col>
        <el-col :xs="12" :sm="12" :lg="6" :xl="4" class="card-panel-col">
          <div class="card-panel" @click="handleSetLineChartData('shoppings')">
            <div class="card-panel-icon-wrapper icon-shopping">
              <svg-icon icon-class="score-yellow" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                定性评价得分
              </div>
              <div v-if="isCount">
                <count-to :start-val="0" :end-val="multualScore" :duration="1000" :decimals="2" class="card-panel-num" />
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
import { getUsersName,
  getPerformanceIsCount,
  getCurMutualRate,
  getAllUserRates,
  getGroupWorkTimeList,
  getAllWorkTimeList,
  getIsSubmitAllow,
  getCurGroupWorkTimeReviewFinish,
  getManagerMultualRateFinish,
  getPerformanceIsPublish } from '@/config/interface'

export default {
  data () {
    return {
      formData: {
        title: this.$moment().format('YYYY-MM')
      },
      users: [],
      reqFlag: {
        getUsersList: true,
        getAllUserRates: true,
        getGroupWorkTimeList: true,
        getAllWorkTimeList: true,
        getPerformanceScore: true
      },
      ratesTableTmp: [],
      multualScore: 0,
      multualRank: 0,
      quantitativeScore: 0,
      quantitativeRank: 0,
      performanceScore: 0,
      performanceRank: 0,
      multualNum: 0,
      quantitativeNum: 0,
      usersNum: 0,
      isCount: false,
      commonStaffMutualCof: this.$store.state.commonStaffMutualCof,
      commonStaffManagerCof: this.$store.state.commonStaffManagerCof,
      commonStaffQuantitativeCof: this.$store.state.commonStaffQuantitativeCof,
      groupLeaderMutualCof: this.$store.state.groupLeaderMutualCof,
      groupLeaderManagerCof: this.$store.state.groupLeaderManagerCof,
      groupLeaderQuantitativeCof: this.$store.state.groupLeaderQuantitativeCof,
      directorMutualCof: this.$store.state.directorMutualCof,
      directorManagerCof: this.$store.state.directorManagerCof,
      directorQuantitativeCof: this.$store.state.directorQuantitativeCof,
      workTimeNum: null,
      workTime: null,
      workTimeRank: null,
      performanceScoreTmp: null,
      monthStar: {
        name: '暂未统计'
      },
      quarterStar: {
        name: '暂未统计'
      },
      selectQuarterNum: null
    }
  },
  components: {
    CountTo
  },
  methods: {
    // 初始化
    init () {
      this.getMonthCookie()
      let allUsersRates = []
      let promises = []
      let count = 0
      this.monthStar = {
        name: '加载中...'
      }
      this.quarterStar = {
        name: '加载中...'
      }
      this.selectQuarterNum = this.smallNumToL(this.$moment(this.formData.title).quarter())
      if (this.reqFlag.getPerformanceScore) {
        this.reqFlag.getPerformanceScore = false
        this.getUsersList().then(getUsersListRes => {
          this.users = getUsersListRes
          this.calGroupMemNum(this.users)
          this.getPerformanceIsPublish(this.$moment(this.formData.title).year(),
            this.$moment(this.formData.title).month() + 1).then(getPerformanceIsPublishRes => {
            if (getPerformanceIsPublishRes.length > 0) {
              if (getPerformanceIsPublishRes[0].flagValue === 1) {
                // this.getPerformanceIsCount().then(getPerformanceIsCountRes => {
                //   if (getPerformanceIsCountRes === 1) {
                    promises[count++] = this.getAllWorkTimeList(this.formData.title)
                    promises[count++] = this.getAllUserRates(this.users, allUsersRates, this.formData.title)
                    Promise.all(promises).then((result) => {
                      let performanceScoreResult = this.calPerformanceScore(result)
                      let finalResultFindResult = performanceScoreResult.find(finalResultItem => {
                        return finalResultItem.id === this.$store.state.userInfo.id
                      })
                      console.log('finalResultFindResult')
                      console.log(finalResultFindResult)
                      if (finalResultFindResult) {
                        this.quantitativeRank = finalResultFindResult.quantitativeRank
                        this.quantitativeScore = finalResultFindResult.quantitativeScore
                        this.workTimeNum = finalResultFindResult.totalWorkTime
                        this.performanceRank = finalResultFindResult.performanceRank
                        this.performanceScore = finalResultFindResult.performanceScore
                        this.performanceScoreTmp = finalResultFindResult.performanceScoreTmp
                        let curID = this.$store.state.userInfo.id
                        if (curID === 7 || curID === 11 || curID === 31) { // 主任岗
                          this.multualScore = finalResultFindResult.mutualScore /
                            (this.directorMutualCof + this.directorManagerCof)
                        } else if (curID === 13 || curID === 17 || curID === 33) { // 组长
                          this.multualScore = finalResultFindResult.mutualScore /
                            (this.groupLeaderMutualCof + this.groupLeaderManagerCof)
                        } else { // 普通成员
                          this.multualScore = finalResultFindResult.mutualScore /
                            (this.commonStaffMutualCof + this.commonStaffManagerCof)
                        }
                      } else {
                        this.quantitativeRank = 0
                        this.quantitativeScore = 0
                        this.workTimeNum = 0
                        this.performanceRank = 0
                        this.performanceScore = 0
                        this.performanceScoreTmp = 0
                        this.multualScore = 0
                      }
                      this.getMonStar(performanceScoreResult) // 月度之星数据计算
                      this.getQuarStar(this.$moment(this.formData.title).year(),
                        this.$moment(this.formData.title).quarter()) // 季度之星数据计算
                      this.isCount = true
                      this.reqFlag.getPerformanceScore = true
                    })
                //   } else {
                //     this.isCount = false
                //     this.reqFlag.getPerformanceScore = true
                //   }
                // }).catch(err => {
                //   this.isCount = false
                //   this.$common.toast(err, 'error', false)
                //   this.reqFlag.getPerformanceScore = true
                // })
              } else {
                this.monthStar = {
                  name: '暂未统计'
                }
                this.quarterStar = {
                  name: '暂未统计'
                }
                this.isCount = false
                this.reqFlag.getPerformanceScore = true
              }
            } else {
              this.monthStar = {
                name: '暂未统计'
              }
              this.quarterStar = {
                name: '暂未统计'
              }
              this.isCount = false
              this.reqFlag.getPerformanceScore = true
            }
          }).catch(err => {
            this.monthStar = {
              name: '暂未统计'
            }
            this.quarterStar = {
              name: '暂未统计'
            }
            this.isCount = false
            this.$common.toast(err, 'error', false)
            this.reqFlag.getPerformanceScore = true
          })
        })
      }
    },
    // 小写阿拉伯数字转大写
    smallNumToL (num) {
      switch (num) {
        case 1:
          return '一'
        case 2:
          return '二'
        case 3:
          return '三'
        case 4:
          return '四'
        default:
          return '错误'
      }
    },
    // 获取当前月份绩效结果是否已公布
    getPerformanceIsPublish (applyYear, applyMonth) {
      const url = getPerformanceIsPublish
      let params = {
        applyYear: applyYear,
        applyMonth: applyMonth,
        flagType: 'performanceInfoPublish'
      }
      let _this = this
      return new Promise(function (resolve, reject) {
        _this.$http(url, params).then(res => {
          if (res.code === 1) {
            resolve(res.data)
          } else {
            reject(new Error('getPerformanceIsPublish recv error!'))
          }
        }).catch(err => {
          this.$common.toast(err, 'error', true)
          reject(new Error('getPerformanceIsPublish send error!'))
        })
      })
    },
    // 获取当前月份能否申报互评的标志
    getIsSubmitMultualEvaAllow () {
      const url = getIsSubmitAllow
      let params = {
        applyYear: this.$moment(this.formData.title).year(),
        applyMonth: this.$moment(this.formData.title).month() + 1,
        flagType: 'multualEvaSubmit'
      }
      let _this = this
      return new Promise(function (resolve, reject) {
        _this.$http(url, params).then(res => {
          if (res.code === 1) {
            resolve(res.data)
          } else {
            reject(new Error('getIsSubmitAllow recv error!'))
          }
        }).catch(err => {
          reject(new Error('getIsSubmitAllow send error!' + err))
        })
      })
    },
    // 获取当前月份能否申报工时的标志
    getIsWorkTimeSubmitAllow () {
      const url = getIsSubmitAllow
      let params = {
        applyYear: this.$moment(this.formData.title).year(),
        applyMonth: this.$moment(this.formData.title).month() + 1,
        flagType: 'workTimeSubmit'
      }
      let _this = this
      return new Promise(function (resolve, reject) {
        _this.$http(url, params).then(res => {
          if (res.code === 1) {
            resolve(res.data)
          } else {
            reject(new Error('getIsSubmitAllow recv error!'))
          }
        }).catch(err => {
          this.$common.toast(err, 'error', true)
          reject(new Error('getIsSubmitAllow send error!'))
        })
      })
    },
    // 获取当前小组工时审核是否都已完毕
    getCurGroupWorkTimeReviewFinish (groupID, applyMonth) {
      const url = getCurGroupWorkTimeReviewFinish
      let params = {
        groupID: groupID,
        applyMonth: applyMonth
      }
      let _this = this
      return new Promise(function (resolve, reject) {
        _this.$http(url, params).then(res => {
          if (res.code === 1) {
            resolve(res.data)
          } else {
            reject(new Error(res.code))
          }
        }).catch(err => {
          reject(new Error(err))
        })
      })
    },
    // 当月领导者是否已经评价完毕
    getManagerMultualRateFinish (applyMonth) {
      const url = getManagerMultualRateFinish
      let params = {
        applyMonth: applyMonth
      }
      let _this = this
      return new Promise(function (resolve, reject) {
        _this.$http(url, params).then(res => {
          if (res.code === 1) {
            resolve(res.data)
          } else {
            reject(new Error(res.data))
          }
        }).catch(err => {
          reject(new Error(err))
        })
      })
    },
    // 判断当月绩效评分是否能够统计
    getPerformanceIsCount () {
      let promises = []
      let promises2 = []
      let count = 0
      let count2 = 0
      let _this = this
      return new Promise(function (resolve, reject) {
        promises[count++] = _this.getIsWorkTimeSubmitAllow()
        promises[count++] = _this.getIsSubmitMultualEvaAllow()
        Promise.all(promises).then(result => {
          if (result[0].length > 0 && result[1].length > 0) { // 互评和定量评价均已截止填报
            promises2[count2++] = _this.getCurGroupWorkTimeReviewFinish(_this.$store.state.userInfo.groupID,
              _this.formData.title)
            promises2[count2++] = _this.getManagerMultualRateFinish(_this.formData.title)
            Promise.all(promises2).then(result2 => {
              if (result2[0].length === 0 && result2[1].length > 0) { // 当前小组工时已审核完毕且领导者已评价
                resolve(1)
              } else { // 当前小组工时未审核完毕或领导者未评价
                resolve(-1)
              }
            }).catch(err => {
              reject(new Error(err))
            })
          } else { // 互评和定量评价未都截止填报
            resolve(-1)
          }
        }).catch(err => {
          reject(new Error(err))
        })
      })
    },
    // 计算绩效得分
    calPerformanceScore (result) {
      // ========================定量指标计算=========================
      let allQuantitativeScore = []
      let groupedWorkTimeList = this.groupedWorkTimeList(result[0]) // 对数据进行分组
      for (let item of groupedWorkTimeList) {
        item.caledQuantitative = this.calQuantitativeScore(item.workTimeList)
        for (let itemInside of item.caledQuantitative) {
          allQuantitativeScore.push(itemInside)
        }
      }
      // =======================定性指标计算===========================
      let multualRestuls = this.calMutualRatesRank(result[1]) // 计算定性评价结果
      // =======================绩效指标计算===========================
      let finalResult = JSON.parse(JSON.stringify(multualRestuls)) // 合并定性评价和定量评价
      for (let item of finalResult) {
        let quantitativeInfo = allQuantitativeScore.find(quantitativeInfo => {
          return item.id === quantitativeInfo.id
        })
        if (quantitativeInfo) { // 当月有工时申报
          item.quantitativeScore = quantitativeInfo.quantitativeScore
          item.quantitativeRank = quantitativeInfo.rank
          item.totalWorkTime = quantitativeInfo.totalWorkTime
          if (item.id === this.$store.state.userInfo.id) {
            // this.quantitativeRank = quantitativeInfo.rank
            // this.quantitativeScore = quantitativeInfo.quantitativeScore
            // this.workTimeNum = quantitativeInfo.totalWorkTime
          }
        } else { // 如果当月无任何工时申报
          item.quantitativeScore = 0
          item.quantitativeRank = 0
          if (item.id === this.$store.state.userInfo.id) {
            // this.quantitativeRank = 0
            // this.quantitativeScore = 0
            // this.workTimeNum = 0
          }
        }
        if (item.id === 7 || item.id === 11 || item.id === 31) { // 主任岗
          item.performanceScoreTmp = item.quantitativeScore * this.directorQuantitativeCof + item.mutualScore
        } else if (item.id === 13 || item.id === 17 || item.id === 33) { // 组长
          item.performanceScoreTmp = item.quantitativeScore * this.groupLeaderQuantitativeCof + item.mutualScore
        } else { // 普通成员
          item.performanceScoreTmp = item.quantitativeScore * this.commonStaffQuantitativeCof + item.mutualScore
        }
        finalResult.sort(this.sortBy('performanceScoreTmp'))
      }
      // =========绩效排名计算==========
      let count = 0
      let prePerformanceScoreTmp = -1
      let count1 = -1
      let count2 = 1
      let rankTmp = []
      // for (let item of finalResult) {
      //   if (item.performanceScoreTmp === prePerformanceScoreTmp) {
      //     item.performanceRank = prePerformanceRank
      //   } else {
      //     item.performanceRank = count
      //     prePerformanceScoreTmp = item.performanceScoreTmp
      //     prePerformanceRank = count
      //   }
      //   item.performanceScore = this.calGetScore(finalResult.length, item.performanceRank)
      //   count++
      // }
      // 把绩效得分相同的人员存进对象数组同一个元素里面
      for (let item of finalResult) {
        if (item.performanceScoreTmp === prePerformanceScoreTmp) {
          rankTmp[count1].push(item)
        } else {
          count1++
          if (!rankTmp[count1]) {
            rankTmp[count1] = []
          }
          rankTmp[count1].push(item)
          prePerformanceScoreTmp = item.performanceScoreTmp
        }
      }
      finalResult = []
      for (let i = 0; i < rankTmp.length; i++) {
        rankTmp[i].sort(this.sortBy('totalWorkTime')) // 绩效得分相同的人员根据工时多少进行排序
        for (let j = 0; j < rankTmp[i].length; j++) {
          finalResult[count] = rankTmp[i][j]
          finalResult[count].performanceRank = count2++
          finalResult[count].performanceScore = this.calGetScore(finalResult.length, finalResult[count].performanceRank)
          count++
        }
      }
      return JSON.parse(JSON.stringify(finalResult))
    },
    // 月度之星数据获取
    getMonStar (finalResult) {
      let monthStarNum = this.$store.state.monthStarNum
      let monthStarPerson = ''
      for (let i = 0; i < monthStarNum; i++) {
        monthStarPerson += finalResult[i].name
        if (i !== monthStarNum - 1) {
          monthStarPerson += ','
        }
      }
      this.monthStar.name = monthStarPerson
    },
    // 季度之星数据获取
    getQuarStar (year, quarter) {
      let quarterStarNum = this.$store.state.quarterStarNum
      let promises1 = []
      let promises2 = []
      let quarterMonth = []
      let count = 0
      let allUsersRates = []
      let performanceScoreResult = []
      switch (quarter) {
        case 1:
          quarterMonth = [year + '-' + '01', year + '-' + '02', year + '-' + '03']
          break
        case 2:
          quarterMonth = [year + '-' + '04', year + '-' + '05', year + '-' + '06']
          break
        case 3:
          quarterMonth = [year + '-' + '07', year + '-' + '08', year + '-' + '09']
          break
        case 4:
          quarterMonth = [year + '-' + '10', year + '-' + '11', year + '-' + '12']
          break
        default:
          quarterMonth = []
      }
      for (let i = 0; i < 3; i++) { // 请求季度所有月份的绩效发布情况
        promises1[i] = this.getPerformanceIsPublish(year,
          this.$moment(quarterMonth[i]).month() + 1)
      }
      Promise.all(promises1).then(result => {
        let lengthFlag = 0
        for (let resultItem of result) {
          if (resultItem.length === 0) { // 该月绩效尚未发布
            lengthFlag = 1
            break
          } else {
            if (resultItem[0].flagValue !== 1) { // 该月绩效尚未发布
              lengthFlag = 1
              break
            }
          }
        }
        if (lengthFlag !== 1) { // 该季度所有月份绩效已经发布
          for (let i = 0; i < 3; i++) {
            promises2[count++] = this.getAllWorkTimeList(quarterMonth[i])
            promises2[count++] = this.getAllUserRates(this.users, allUsersRates[i], quarterMonth[i])
          }
          Promise.all(promises2).then((result) => {
            let count = 0
            let comResult = []
            let finalResult = []
            for (let i = 0; i < result.length; i = i + 2) { // 合并查询的每月工时以及定性互评结果，然后计算当月绩效评价
              if (!comResult[count]) {
                comResult[count] = []
              }
              comResult[count].push(result[i])
              comResult[count].push(result[i + 1])
              performanceScoreResult[count] = this.calPerformanceScore(comResult[count])
              count++
            }
            let firstMonthPerformance = performanceScoreResult[0]
            let secondMonthPerformance = performanceScoreResult[1]
            let thirdMonthPerformance = performanceScoreResult[2]
            for (let firstMonthPerformanceItem of firstMonthPerformance) {
              let secondFindResult1 = secondMonthPerformance.find(secondMonthPerformanceItem => {
                return secondMonthPerformanceItem.id === firstMonthPerformanceItem.id
              })
              let thirdFindResult1 = thirdMonthPerformance.find(secondMonthPerformanceItem => {
                return secondMonthPerformanceItem.id === firstMonthPerformanceItem.id
              })
              let obj = {
                id: firstMonthPerformanceItem.id,
                name: firstMonthPerformanceItem.name,
                totalWorkTime: firstMonthPerformanceItem.totalWorkTime +
                  secondFindResult1.totalWorkTime + thirdFindResult1.totalWorkTime,
                averagePerformance: (firstMonthPerformanceItem.performanceScoreTmp +
                  secondFindResult1.performanceScoreTmp + thirdFindResult1.performanceScoreTmp) / 3
              }
              finalResult.push(obj)
            }
            finalResult = this.sortObjectMethod(finalResult, 'averagePerformance', 'totalWorkTime')
            let quarterStarPerson = ''
            this.quarterStar = {
              name: ''
            }
            for (let i = 0; i < quarterStarNum; i++) {
              quarterStarPerson += finalResult[i].name
              if (i !== quarterStarNum - 1) {
                quarterStarPerson += ','
              }
            }
            this.quarterStar.name = quarterStarPerson
          })
        } else { // 尚有月份未发布绩效
          this.quarterStar = {
            name: '暂未统计'
          }
        }
      })
    },
    // 排序方法
    sortObjectMethod (sortArray, firstSortEle, secondSortEle) {
      sortArray.sort(this.sortBy(firstSortEle))
      let count = 0
      let preFirstEle = -1
      let rankTmp = []
      let count1 = -1
      let count2 = 1
      for (let i = 0; i < sortArray.length; i++) { // 第一个排队元素相同的人员存进对象数组同一个元素里面
        if (sortArray[i][firstSortEle] === preFirstEle) {
          rankTmp[count1].push(sortArray[i])
        } else {
          count1++
          if (!rankTmp[count1]) {
            rankTmp[count1] = []
          }
          rankTmp[count1].push(sortArray[i])
          preFirstEle = sortArray[i][firstSortEle]
        }
      }
      let finalResult = []
      for (let i = 0; i < rankTmp.length; i++) {
        rankTmp[i].sort(this.sortBy(secondSortEle)) // 绩效得分相同的人员根据工时多少进行排序
        for (let j = 0; j < rankTmp[i].length; j++) {
          finalResult[count++] = rankTmp[i][j]
        }
      }
      return finalResult
    },
    // 将获得的信息按小组分类
    groupedWorkTimeList (allWorkTimeList) {
      let groupedWorkTimeList = []
      for (let item of allWorkTimeList) {
        if (item.id !== this.$store.state.managerID) {
          let index = groupedWorkTimeList.findIndex(itemInside => {
            return itemInside.groupID === item.groupID
          })
          if (index === -1) {
            let obj = {
              groupID: item.groupID,
              workTimeList: []
            }
            obj.workTimeList.push(item)
            groupedWorkTimeList.push(obj)
          } else {
            groupedWorkTimeList[index].workTimeList.push(item)
          }
        }
      }
      return groupedWorkTimeList
    },
    // 计算定量得分与排名
    calQuantitativeScore (groupWorkTimeList) {
      let totalWorkTimeCal = []
      if (groupWorkTimeList.length > 0) {
        let userID = []
        for (let item of groupWorkTimeList) { // 插入各组员总工时信息
          if (userID.indexOf(item.id) === -1) {
            userID.push(item.id)
            let obj = {
              id: item.id,
              name: item.name,
              totalWorkTime: item.reviewWorkTime
            }
            totalWorkTimeCal.push(obj)
          } else {
            totalWorkTimeCal.find(function (wItem) {
              if (wItem.id === item.id) {
                wItem.totalWorkTime += item.reviewWorkTime
                return wItem.totalWorkTime
              }
            })
          }
        }
        totalWorkTimeCal.sort(this.compare('totalWorkTime')) // 根据总工时排序
        let preWorkTime = -1
        let preRank = 1
        let count = 1
        for (let item of totalWorkTimeCal) { // 计算排名
          if (item.totalWorkTime === preWorkTime) {
            item.rank = preRank
          } else {
            item.rank = count
            preRank = count
          }
          count++
          preWorkTime = item.totalWorkTime
        }
        // ==============================计算定量指标得分=======================================
        let length = totalWorkTimeCal.length
        for (let item of totalWorkTimeCal) { // 计算定量指标得分
          item.quantitativeScore = this.calGetScore(length, item.rank)
        }
      }
      return totalWorkTimeCal
    },
    // 排序比较函数
    sortBy (props) {
      return function (a, b) {
        return b[props] - a[props]
      }
    },
    // 分组人数计算
    calGroupMemNum (users) {
      let standAndEngineerRates = []
      let standGroupMembers = []
      let engineerGroupMembers = []
      let communicationRates = []
      this.usersNum = users.length - 1
      for (let item of users) {
        if (item.groupName === '技术标准组' || item.groupName === '工程组') {
          if (item.groupName === '技术标准组') {
            standGroupMembers.push(item)
          } else {
            engineerGroupMembers.push(item)
          }
          standAndEngineerRates.push(item)
        } else if (item.groupName === '通信组') {
          communicationRates.push(item)
        }
      }
      if (this.$store.state.userInfo.groupName === '技术标准组' ||
        this.$store.state.userInfo.groupName === '工程组') {
        if (this.$store.state.userInfo.groupName === '技术标准组') {
          this.quantitativeNum = standGroupMembers.length
        } else {
          this.quantitativeNum = engineerGroupMembers.length
        }
        this.multualNum = standAndEngineerRates.length
      } else {
        this.multualNum = communicationRates.length
        this.quantitativeNum = communicationRates.length
      }
    },
    // 获取全处工时信息
    getAllWorkTimeList (applyMonth) {
      const url = getAllWorkTimeList
      // if (this.reqFlag.getAllWorkTimeList) {
      //   this.reqFlag.getAllWorkTimeList = false
        let params = {
          applyMonth: applyMonth
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            let recvData = res.data
            // _this.reqFlag.getAllWorkTimeList = true
            resolve(recvData)
          }).catch(() => {
            _this.$common.toast('请求失败', 'error', false)
            reject(new Error('请求失败'))
          })
        })
      // }
    },
    // 获取小组工时信息
    getGroupWorkTimeList (groupID) {
      const url = getGroupWorkTimeList
      if (this.reqFlag.getGroupWorkTimeList) {
        this.reqFlag.getGroupWorkTimeList = false
        let params = {
          groupID: groupID,
          applyMonth: this.formData.title
        }
        let _this = this
        return new Promise((resolve, reject) => {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              let recvData = res.data
              let totalWorkTimeCal = []
              if (recvData.length > 0) {
                let userID = []
                for (let item of recvData) { // 插入各组员总工时信息
                  if (userID.indexOf(item.id) === -1) {
                    userID.push(item.id)
                    let obj = {
                      id: item.id,
                      name: item.name,
                      totalWorkTime: item.reviewWorkTime
                    }
                    totalWorkTimeCal.push(obj)
                  } else {
                    totalWorkTimeCal.find(function (wItem) {
                      if (wItem.id === item.id) {
                        wItem.totalWorkTime += item.reviewWorkTime
                        return wItem.totalWorkTime
                      }
                    })
                  }
                }
                totalWorkTimeCal.sort(_this.compare('totalWorkTime')) // 根据总工时排序
                let preWorkTime = 0
                let preRank = 1
                let count = 1
                for (let item of totalWorkTimeCal) { // 计算排名
                  if (item.totalWorkTime === preWorkTime) {
                    item.rank = preRank
                  } else {
                    item.rank = count
                    preRank = count
                  }
                  count++
                  preWorkTime = item.totalWorkTime
                }
                _this.quantitativeRank = totalWorkTimeCal.find(item => {
                  return item.id === _this.$store.state.userInfo.id
                }).rank
                // ==============================计算定量指标得分=======================================
                let length = totalWorkTimeCal.length
                for (let item of totalWorkTimeCal) { // 计算定量指标得分
                  item.quantitativeScore = _this.calGetScore(length, item.rank)
                }
                _this.quantitativeScore = totalWorkTimeCal.find(item => {
                  return item.id === _this.$store.state.userInfo.id
                }).quantitativeScore
              } else {
                _this.quantitativeRank = 0
                _this.quantitativeScore = 0
              }
              resolve(totalWorkTimeCal)
            } else {
              reject(new Error('小组工时请求失败'))
            }
            _this.reqFlag.getGroupWorkTimeList = true
          })
        })
      }
    },
    // 数据排序方法
    compare (params) {
      return function (o, p) {
        let a, b
        if (typeof o === 'object' && typeof p === 'object' && o && p) {
          a = o[params]
          b = p[params]
          if (a === b) {
            return 0
          }
          if (typeof a === typeof b) {
            return a > b ? -1 : 1
          }
          return typeof a > typeof b ? -1 : 1
        } else {
          let obj = {}
          throw (obj)
        }
      }
    },
    // 获取领导评价相关信息
    getManagerResult (id, allUsersRates) {
      for (let item of allUsersRates) {
        if (item.id === id) {
          return { managerRateRank: item.managerRateRank, managerScore: item.managerScore }
        }
      }
    },
    // 计算定性评价排名与得分
    calMutualRatesRank (allUserRates) {
      let standAndEngineerRates = []
      let communicationRates = []
      for (let item of allUserRates) {
        if (item.groupName === '技术标准组' || item.groupName === '工程组') {
          standAndEngineerRates.push(item)
        } else if (item.groupName === '通信组') {
          communicationRates.push(item)
        }
      }
      // =================================定性评价排序===============================================
      // 技术标准组&工程组员工互评排序
      for (let i = 0; i < standAndEngineerRates.length - 1; i++) {
        for (let j = 0; j < standAndEngineerRates.length - 1 - i; j++) {
          if (standAndEngineerRates[j].staffRate < standAndEngineerRates[j + 1].staffRate) {
            [standAndEngineerRates[j], standAndEngineerRates[j + 1]] =
              [standAndEngineerRates[j + 1], standAndEngineerRates[j]]
          }
        }
      }
      // 通信组员工互评排序
      for (let i = 0; i < communicationRates.length - 1; i++) {
        for (let j = 0; j < communicationRates.length - 1 - i; j++) {
          if (communicationRates[j].staffRate < communicationRates[j + 1].staffRate) {
            [communicationRates[j], communicationRates[j + 1]] =
              [communicationRates[j + 1], communicationRates[j]]
          }
        }
      }
      // 全处员工领导评价排序
      for (let i = 0; i < allUserRates.length - 1; i++) {
        for (let j = 0; j < allUserRates.length - 1 - i; j++) {
          if (allUserRates[j].managerRate < allUserRates[j + 1].managerRate) {
            [allUserRates[j], allUserRates[j + 1]] =
              [allUserRates[j + 1], allUserRates[j]]
          }
        }
      }
      // =================================定性评价得分计算===============================================
      // 技术标准组与工程组互评排名&得分计算
      let tmpStaffRate = -1
      let count = 1
      for (let i = 0; i < standAndEngineerRates.length; i++) {
        if (standAndEngineerRates[i].staffRate === tmpStaffRate) {
          standAndEngineerRates[i].staffRateRank = standAndEngineerRates[i - 1].staffRateRank
        } else {
          standAndEngineerRates[i].staffRateRank = count
          tmpStaffRate = standAndEngineerRates[i].staffRate
        }
        count++
        standAndEngineerRates[i].staffMutualScore =
          this.calGetScore(standAndEngineerRates.length, standAndEngineerRates[i].staffRateRank)
      }
      // 通信组互评排名&得分计算
      tmpStaffRate = -1
      count = 1
      for (let i = 0; i < communicationRates.length; i++) {
        if (communicationRates[i].staffRate === tmpStaffRate) {
          communicationRates[i].staffRateRank = communicationRates[i - 1].staffRateRank
        } else {
          communicationRates[i].staffRateRank = count
          tmpStaffRate = communicationRates[i].staffRate
        }
        count++
        communicationRates[i].staffMutualScore =
          this.calGetScore(communicationRates.length, communicationRates[i].staffRateRank)
      }
      // 全处员工领导评价排名&得分计算
      tmpStaffRate = -1
      count = 1
      for (let i = 0; i < allUserRates.length; i++) {
        if (allUserRates[i].managerRate === tmpStaffRate) {
          allUserRates[i].managerRateRank = allUserRates[i - 1].managerRateRank
        } else {
          allUserRates[i].managerRateRank = count
          tmpStaffRate = allUserRates[i].managerRate
        }
        count++
        allUserRates[i].managerScore =
          this.calGetScore(allUserRates.length, allUserRates[i].managerRateRank)
      }
      let allRates = []
      // =================================定性评价结果合并===============================================
      // 合并三个组结果
      for (let item of standAndEngineerRates) {
        let managerResult = this.getManagerResult(item.id, allUserRates)
        item.managerRateRank = managerResult.managerRateRank
        item.managerScore = managerResult.managerScore
        if (item.id === 7 || item.id === 11 || item.id === 31) { // 主任岗
          item.mutualScore = item.staffMutualScore * this.directorMutualCof +
            item.managerScore * this.directorManagerCof
        } else if (item.id === 13 || item.id === 17 || item.id === 33) { // 组长
          item.mutualScore = item.staffMutualScore * this.groupLeaderMutualCof +
            item.managerScore * this.groupLeaderManagerCof
        } else { // 普通成员
          item.mutualScore = item.staffMutualScore * this.commonStaffMutualCof +
            item.managerScore * this.commonStaffManagerCof
        }
        allRates.push(item)
      }
      for (let item of communicationRates) {
        let managerResult = this.getManagerResult(item.id, allUserRates)
        item.managerRateRank = managerResult.managerRateRank
        item.managerScore = managerResult.managerScore
        if (item.id === 7 || item.id === 11 || item.id === 31) { // 主任岗
          item.mutualScore = item.staffMutualScore * this.directorMutualCof +
            item.managerScore * this.directorManagerCof
        } else if (item.id === 13 || item.id === 17 || item.id === 33) { // 组长
          item.mutualScore = item.staffMutualScore * this.groupLeaderMutualCof +
            item.managerScore * this.groupLeaderManagerCof
        } else { // 普通成员
          item.mutualScore = item.staffMutualScore * this.commonStaffMutualCof +
            item.managerScore * this.commonStaffManagerCof
        }
        allRates.push(item)
      }
      return allRates
    },
    // 定性、定量指标得分计算
    calGetScore (length, rank) {
      if (rank === 1) {
        return 92.5
      }
      if (rank < Number((length * 0.1).toFixed(0)) || rank === Number((length * 0.1).toFixed(0))) {
        return 92.5
      } else if (rank < Number((length * 0.3).toFixed(0)) || rank === Number((length * 0.3).toFixed(0))) {
        return 90
      } else if (rank < Number((length * 0.7).toFixed(0)) || rank === Number((length * 0.7).toFixed(0))) {
        return 87.5
      } else if (rank < Number((length * 0.9).toFixed(0)) || rank === Number((length * 0.9).toFixed(0))) {
        return 85
      } else if (rank < Number((length * 1).toFixed(0)) || rank === Number((length * 1).toFixed(0))) {
        return 82.5
      }
    },
    // 获取用户列表
    getUsersList () {
      const url = getUsersName
      let params = {}
      let _this = this
      if (this.reqFlag.getUsersList) {
        this.reqFlag.getUsersList = false
        return new Promise(function (resolve, reject) {
          _this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                resolve(res.data.list)
              }
              _this.reqFlag.getUsersList = true
            })
        })
      }
    },
    // 计算本人互评分数
    CalMutualRate (param) {
      let flag = 0
      for (let i = 0; i < this.ratedArray.length; i++) {
        if (this.ratedArray[i].ratePersion === param.ratePersion) {
          flag++
          this.ratedArray[i][this.rateTypeSwitch(param.rateType)] = param.rate
          this.ratedArray[i].totalScore = this.calMultualScoreByScore(
            this.ratedArray[i].t1Star,
            this.ratedArray[i].t2Star,
            this.ratedArray[i].t3Star,
            this.ratedArray[i].t4Star,
            this.ratedArray[i].t5Star,
            this.ratedArray[i].t6Star)
          break
        }
      }
      if (!flag) {
        let obj = {
          ratePersion: param.ratePersion,
          t1Star: 0,
          t2Star: 0,
          t3Star: 0,
          t4Star: 0,
          t5Star: 0,
          t6Star: 0,
          totalScore: 0
        }
        obj[this.rateTypeSwitch(param.rateType)] = param.rate
        obj.totalScore = this.calMultualScoreByScore(obj.t1Star, obj.t2Star, obj.t3Star, obj.t4Star,
          obj.t5Star, obj.t6Star)
        this.ratedArray.push(obj)
      }
    },
    // 获取本人互评分数
    getCurMutualRate () {
      const url = getCurMutualRate
      let params = {
        userID: this.$store.state.userInfo.id,
        rateMonth: this.formData.title
      }
      this.ratedArray = []
      this.$http(url, params)
        .then(res => {
          if (res.code === 1) {
            for (let item of res.data) {
              this.CalMutualRate(item)
            }
            let count = 0
            let totalRate = 0
            let manageRate = 0
            for (let item of this.ratedArray) {
              if (item.ratePersion !== 26) {
                count++
                totalRate += item.totalScore
              } else {
                manageRate = item.totalScore
              }
            }
            this.curMutualRate = totalRate / count
          }
        })
    },
    // 获取全处员工互评信息
    getAllUserRates (users, allUsersRates, rateMonth) {
      const url = getAllUserRates
      let params = {
        usersData: users,
        rateMonth: rateMonth
      }
      let _this = this
      // if (this.reqFlag.getAllUserRates) {
      //   this.reqFlag.getAllUserRates = false
        return new Promise(function (resolve, reject) {
          _this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                for (let item of res.data) {
                  let obj = {
                    id: item.id,
                    name: item.name,
                    groupName: item.groupName
                  }
                  let getRated = _this.getMulRated(item.ratedData)
                  obj.staffRate = Number(getRated.staffRate.toFixed(3))
                  obj.managerRate = Number(getRated.manageRate.toFixed(3))
                  obj.isRate = item.rateData.length !== 0
                  if (!allUsersRates) {
                    allUsersRates = []
                  }
                  allUsersRates.push(obj)
                }
                // _this.reqFlag.getAllUserRates = true
                resolve(allUsersRates)
              }
            })
        })
      // }
    },
    // 评分类型转换
    rateTypeSwitch (rateType) {
      switch (rateType) {
        case 1:
          return 't1Star'
        case 2:
          return 't2Star'
        case 3:
          return 't3Star'
        case 4:
          return 't4Star'
        case 5:
          return 't5Star'
        case 6:
          return 't6Star'
        default:
          return 't1Star'
      }
    },
    // 计算互评总分(通过各评分类型分数)
    calMultualScoreByScore (t1Score, t2Score, t3Score, t4Score, t5Score, t6Score) {
      return t1Score * 0.15 + t2Score * 0.2 + t3Score * 0.1 +
        t4Score * 0.1 + t5Score * 0.3 + t6Score * 0.15
    },
    // 获取互评得分
    getMulRated (ratedData) {
      this.ratesTableTmp = []
      let manageRate = 0
      let totalRate = 0
      let count = 0
      if (ratedData.length !== 0) {
        for (let item of ratedData) {
          let index = this.ratesTableTmp.findIndex((itemInside) => {
            return item.ratePersion === itemInside.ratePersion
          })
          if (index === -1) {
            let obj = {
              ratePersion: item.ratePersion
            }
            obj[this.rateTypeSwitch(item.rateType)] = item.rate
            this.ratesTableTmp.push(obj)
          } else {
            this.ratesTableTmp[index][this.rateTypeSwitch(item.rateType)] = item.rate
          }
        }
        for (let item of this.ratesTableTmp) { // 计算各被评价人总分
          item.totalScore = this.calMultualScoreByScore(item.t1Star, item.t2Star, item.t3Star, item.t4Star,
            item.t5Star, item.t6Star)
          if (item.ratePersion === 26) {
            manageRate = item.totalScore
          } else {
            count++
            totalRate += item.totalScore
          }
        }
      }
      if (count === 0) {
        count = 1 // 防止NAN
      }
      return {
        staffRate: totalRate / count,
        manageRate: manageRate
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
            this.formData.title = arr2[1]
          }
        }
      }
    },
    // 上一月
    handlePreMonth () {
      this.formData.title = this.$moment(this.formData.title).subtract(1, 'months').format('YYYY-MM')
      this.setMonthCookie(this.formData.title, 7)
      this.handelDateChange()
    },
    // 下一月
    handleNextMonth () {
      this.formData.title = this.$moment(this.formData.title).add(1, 'months').format('YYYY-MM')
      this.setMonthCookie(this.formData.title, 7)
      this.handelDateChange()
    },
    // 日期变化
    handelDateChange () {
      let allUsersRates = []
      let promises = []
      let count = 0
      this.monthStar = {
        name: '加载中...'
      }
      this.quarterStar = {
        name: '加载中...'
      }
      this.selectQuarterNum = this.smallNumToL(this.$moment(this.formData.title).quarter())
      if (this.reqFlag.getPerformanceScore) {
        this.reqFlag.getPerformanceScore = false
        this.getPerformanceIsPublish(this.$moment(this.formData.title).year(),
          this.$moment(this.formData.title).month() + 1).then(getPerformanceIsPublishRes => {
          if (getPerformanceIsPublishRes.length > 0) {
            if (getPerformanceIsPublishRes[0].flagValue === 1) {
              this.getPerformanceIsCount().then(getPerformanceIsCountRes => {
                if (getPerformanceIsCountRes === 1) {
                  promises[count++] = this.getAllWorkTimeList(this.formData.title)
                  promises[count++] = this.getAllUserRates(this.users, allUsersRates, this.formData.title)
                  Promise.all(promises).then((result) => {
                    let performanceScoreResult = this.calPerformanceScore(result)
                    let finalResultFindResult = performanceScoreResult.find(finalResultItem => {
                      return finalResultItem.id === this.$store.state.userInfo.id
                    })
                    if (finalResultFindResult) {
                      this.quantitativeRank = finalResultFindResult.quantitativeRank
                      this.quantitativeScore = finalResultFindResult.quantitativeScore
                      this.workTimeNum = finalResultFindResult.totalWorkTime
                      this.performanceRank = finalResultFindResult.performanceRank
                      this.performanceScore = finalResultFindResult.performanceScore
                      this.performanceScoreTmp = finalResultFindResult.performanceScoreTmp
                      let curID = this.$store.state.userInfo.id
                      if (curID === 7 || curID === 11 || curID === 31) { // 主任岗
                        this.multualScore = finalResultFindResult.mutualScore /
                          (this.directorMutualCof + this.directorManagerCof)
                      } else if (curID === 13 || curID === 17 || curID === 33) { // 组长
                        this.multualScore = finalResultFindResult.mutualScore /
                          (this.groupLeaderMutualCof + this.groupLeaderManagerCof)
                      } else { // 普通成员
                        this.multualScore = finalResultFindResult.mutualScore /
                          (this.commonStaffMutualCof + this.commonStaffManagerCof)
                      }
                    } else {
                      this.quantitativeRank = 0
                      this.quantitativeScore = 0
                      this.workTimeNum = 0
                      this.performanceRank = 0
                      this.performanceScore = 0
                      this.performanceScoreTmp = 0
                      this.multualScore = 0
                    }
                    this.getMonStar(performanceScoreResult) // 月度之星数据计算
                    this.getQuarStar(this.$moment(this.formData.title).year(),
                      this.$moment(this.formData.title).quarter()) // 季度之星数据计算
                    this.isCount = true
                    this.reqFlag.getPerformanceScore = true
                  })
                } else {
                  this.isCount = false
                  this.reqFlag.getPerformanceScore = true
                }
              }).catch(err => {
                this.isCount = false
                this.$common.toast(err, 'error', false)
                this.reqFlag.getPerformanceScore = true
              })
            } else {
              this.monthStar = {
                name: '暂未统计'
              }
              this.quarterStar = {
                name: '暂未统计'
              }
              this.isCount = false
              this.reqFlag.getPerformanceScore = true
            }
          } else {
            this.monthStar = {
              name: '暂未统计'
            }
            this.quarterStar = {
              name: '暂未统计'
            }
            this.isCount = false
            this.reqFlag.getPerformanceScore = true
          }
        }).catch(err => {
          this.isCount = false
          this.$common.toast(err, 'error', false)
          this.reqFlag.getPerformanceScore = true
        })
      }
    },
    // 首页关于
    dashboardAbout () {
    },
    handleSetLineChartData (type) {
      this.$emit('handleSetLineChartData', type)
    }
  },
  created () {
    this.init()
  }
}
</script>

<style lang="scss" scoped>
.panel-group {
  margin-top: 1px;

  .card-panel-col {
    margin-bottom: 32px;
  }

  .card-panel {
    height: 108px;
    cursor: pointer;
    font-size: 12px;
    position: relative;
    overflow: hidden;
    color: #666;
    background: #fff;
    box-shadow: 4px 4px 40px rgba(0, 0, 0, .05);
    border-color: rgba(0, 0, 0, .05);

    &:hover {
      .card-panel-icon-wrapper {
        color: #fff;
      }

      .icon-people {
        background: #40c9c6;
      }

      .icon-message {
        background: #36a3f7;
      }

      .icon-money {
        background: #f4516c;
      }

      .icon-shopping {
        background: #34bfa3
      }
    }

    .icon-people {
      color: #40c9c6;
    }

    .icon-message {
      color: #36a3f7;
    }

    .icon-money {
      color: #f4516c;
    }

    .icon-shopping {
      color: #34bfa3
    }

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
    width: 500px;
    font-size: 12px;
    position: relative;
    overflow: hidden;
    color: #666;
    background: #fff;
    box-shadow: 4px 4px 40px rgba(0, 0, 0, .05);
    border-color: rgba(0, 0, 0, .05);

    &:hover {
      .card-panel-icon-wrapper {
        color: #fff;
      }

      .icon-people {
        background: #40c9c6;
      }

      .icon-message {
        background: #36a3f7;
      }

      .icon-money {
        background: #f4516c;
      }

      .icon-shopping {
        background: #34bfa3;
      }

      .icon-month {
        background: #34bfa3;
      }
    }

    .icon-people {
      color: #e50000;
    }

    .icon-month {
      color: rgba(229, 179, 0, 0.99);
    }

    .icon-message {
      color: #36a3f7;
    }

    .icon-money {
      color: #f4516c;
    }

    .icon-shopping {
      color: #34bfa3
    }

    .card-panel-icon-wrapper {
      float: left;
      margin: 24px 0 0 24px;
      padding: 16px;
      transition: all 0.38s ease-out;
      border-radius: 6px;
    }

    .card-panel-icon {
      float: left;
      font-size: 48px;
    }

    .card-panel-description {
      float: center;
      font-weight: bold;
      margin: 26px;
      margin-left: 0px;
      margin-top: 60px;

      .card-panel-text {
        line-height: 30px;
        color: rgba(0, 0, 0, 1);
        font-size: 27px;
        text-align: center;
        cursor: pointer;
      }

      .card-panel-num {
        font-size: 19px;
      }
    }
  }
}

@media (max-width:550px) {
  .card-panel-description {
    display: none;
  }

  .card-panel-icon-wrapper {
    float: none !important;
    width: 100%;
    height: 100%;
    margin: 0 !important;

    .svg-icon {
      display: block;
      margin: 14px auto !important;
      float: none !important;
    }
  }
}
</style>

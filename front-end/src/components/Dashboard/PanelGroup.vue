<template>
  <div>
    <div>
      <span style='font-weight: bolder'>时间选择：</span>
      <el-button size="mini" type="danger" style="margin-right: 10px" @click="handlePreMonth">上月</el-button>
      <el-date-picker
        v-model="formData.title"
        type="month"
        format="yyyy 第 MM 月"
        value-format="yyyy-MM"
        placeholder="选择月"
        style="width: 150px"
        @change="handelDateChange">
      </el-date-picker>
      <el-button size="mini" type="primary" style="margin-left: 10px" @click="handleNextMonth">下月</el-button>
      <el-button @click="init">初始化</el-button>
    </div>
    <div class="hr-10" style="margin-top: 20px; margin-bottom: 20px"></div>
    <div>
      <el-row :gutter="40" class="panel-group">
        <el-col :xs="12" :sm="12" :lg="6" :xl="4" class="card-panel-col">
          <div class="card-panel" @click="handleSetLineChartData('newVisitis')">
            <div class="card-panel-icon-wrapper icon-people">
              <svg-icon icon-class="score-red" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                绩效评价得分
              </div>
              <count-to :start-val="0" :end-val="1024" :duration="2600" class="card-panel-num" />
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
                绩效评价排名
              </div>
              <count-to :start-val="0" :end-val="100" :duration="3000" class="card-panel-num" />
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
                定量评价得分
              </div>
              <count-to :start-val="0" :end-val="1" :duration="3200" class="card-panel-num" />
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
                定量评价排名
              </div>
              <count-to :start-val="0" :end-val="136" :duration="3600" class="card-panel-num" />
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
                定性互评得分
              </div>
              <count-to :start-val="0" :end-val="136" :duration="3600" class="card-panel-num" />
            </div>
          </div>
        </el-col>
        <el-col :xs="12" :sm="12" :lg="6" :xl="4" class="card-panel-col">
          <div class="card-panel" @click="handleSetLineChartData('shoppings')">
            <div class="card-panel-icon-wrapper icon-shopping">
              <svg-icon icon-class="rank-yellow" class-name="card-panel-icon" />
            </div>
            <div class="card-panel-description">
              <div class="card-panel-text">
                定性互评排名
              </div>
              <count-to :start-val="0" :end-val="136" :duration="3600" class="card-panel-num" />
            </div>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import CountTo from 'vue-count-to'
import { getUsersName, getUserRates, submitRatesResult, updateUserRate,
  getCurMutualRate, getAllUserRates } from '@/config/interface'

export default {
  data () {
    return {
      formData: {
        title: this.$moment().format('YYYY-MM')
      },
      users: [],
      reqFlag: {
        getUsersList: true,
        getAllUserRates: true
      },
      ratesTableTmp: [],
      multualScore: 0,
      multualRank: 0,
      quantitativeScore: 0,
      quantitativeRank: 0,
      performanceScore: 0,
      performanceRank: 0,
      commonStaffMutualCof: this.$store.state.commonStaffMutualCof,
      commonStaffManagerCof: this.$store.state.commonStaffManagerCof,
      commonStaffQuantitativeCof: this.$store.state.commonStaffQuantitativeCof,
      groupLeaderMutualCof: this.$store.state.groupLeaderMutualCof,
      groupLeaderManagerCof: this.$store.state.groupLeaderManagerCof,
      groupLeaderQuantitativeCof: this.$store.state.groupLeaderQuantitativeCof,
      directorMutualCof: this.$store.state.directorMutualCof,
      directorManagerCof: this.$store.state.directorManagerCof,
      directorQuantitativeCof: this.$store.state.directorQuantitativeCof
    }
  },
  components: {
    CountTo
  },
  methods: {
    // 初始化
    init () {
      let allUsersRates = []
      this.getUsersList().then(res0 => {
        this.users = res0
        this.getAllUserRates(res0, allUsersRates).then(res1 => {
          this.calMutualRatesRank(res1)
        })
      })
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
      console.log('std')
      console.log(standAndEngineerRates)
      console.log('com')
      console.log(communicationRates)
      console.log('all')
      console.log(allUserRates)
      // =================================定性评价得分计算===============================================
      // 技术标准组与工程组互评排名&得分计算
      let tmpStaffRate = -1
      let count = 1
      for (let i = 0; i < standAndEngineerRates.length; i++) {
        if (standAndEngineerRates[i].staffRate === tmpStaffRate) {
          standAndEngineerRates[i].staffRateRank = standAndEngineerRates[i - 1].staffRateRank
        } else {
          standAndEngineerRates[i].staffRateRank = count++
          tmpStaffRate = standAndEngineerRates[i].staffRate
        }
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
          communicationRates[i].staffRateRank = count++
          tmpStaffRate = communicationRates[i].staffRate
        }
        communicationRates[i].staffMutualScore =
          this.calGetScore(communicationRates.length, communicationRates[i].staffRateRank)
      }
      // 全处员工领导评价排名&得分计算
      tmpStaffRate = -1
      count = 1
      for (let i = 0; i < allUserRates.length - 1; i++) {
        if (allUserRates[i].managerRate === tmpStaffRate) {
          allUserRates[i].managerRateRank = allUserRates[i - 1].managerRateRank
        } else {
          allUserRates[i].managerRateRank = count++
          tmpStaffRate = allUserRates[i].managerRate
        }
        allUserRates[i].managerScore =
          this.calGetScore(allUserRates.length, allUserRates[i].managerRateRank)
      }
      // let allRates = []
      // // =================================定性评价结果合并===============================================
      // // 合并三个组结果
      // for (let item of standAndEngineerRates) {
      //   let managerResult = this.getManagerResult(item.id, allUserRates)
      //   item.managerRateRank = managerResult.managerRateRank
      //   item.managerScore = managerResult.managerScore
      //   if (item.id === 7 || item.id === 11) { // 主任岗
      //     item.mutualScore = item.staffMutualScore * this.directorMutualCof +
      //       item.managerScore * this.directorManagerCof
      //   } else if (item.id === 13 || item.id === 17) { // 组长
      //     item.mutualScore = item.staffMutualScore * this.groupLeaderMutualCof +
      //       item.managerScore * this.groupLeaderManagerCof
      //   } else { // 普通成员
      //     item.mutualScore = item.staffMutualScore * this.commonStaffMutualCof +
      //       item.managerScore * this.commonStaffManagerCof
      //   }
      //   allRates.push(item)
      // }
      // for (let item of communicationRates) {
      //   let managerResult = this.getManagerResult(item.id, allUserRates)
      //   item.managerRateRank = managerResult.managerRateRank
      //   item.managerScore = managerResult.managerScore
      //   if (item.id === 7 || item.id === 11) { // 主任岗
      //     item.mutualScore = item.staffMutualScore * this.directorMutualCof +
      //       item.managerScore * this.directorManagerCof
      //   } else if (item.id === 13 || item.id === 17) { // 组长
      //     item.mutualScore = item.staffMutualScore * this.groupLeaderMutualCof +
      //       item.managerScore * this.groupLeaderManagerCof
      //   } else { // 普通成员
      //     item.mutualScore = item.staffMutualScore * this.commonStaffMutualCof +
      //       item.managerScore * this.commonStaffManagerCof
      //   }
      //   allRates.push(item)
      // }
      // console.log(allRates)
    },
    // 定性、定量指标得分计算
    calGetScore (length, rank) {
      let rankPercentage = Number((rank / length).toFixed(1))
      if (rankPercentage < 0.1 || rankPercentage === 0.1 || rank === 1) {
        return 92.5
      } else if (rankPercentage < 0.3 || rankPercentage === 0.3) {
        return 90
      } else if (rankPercentage < 0.7 || rankPercentage === 0.7) {
        return 87.5
      } else if (rankPercentage < 0.9 || rankPercentage === 0.9) {
        return 85
      } else if (rankPercentage < 1 || rankPercentage === 1) {
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
    getAllUserRates (users, allUsersRates) {
      const url = getAllUserRates
      let params = {
        usersData: users,
        rateMonth: this.formData.title
      }
      let _this = this
      if (this.reqFlag.getAllUserRates) {
        this.reqFlag.getAllUserRates = false
        return new Promise(function (resolve, reject) {
          _this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                _this.tableData = []
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
                  allUsersRates.push(obj)
                }
                _this.reqFlag.getAllUserRates = true
                resolve(allUsersRates)
              }
            })
        })
      }
    },
    // 获取被评价人数组索引
    getIndexOfRatedPersion (id) {
      if (this.ratesTableTmp.length === 0) {
        return -1
      }
      for (let i = 0; i < this.ratesTableTmp.length; i++) {
        if (this.ratesTableTmp[i].ratePersion === id) {
          return i
        }
      }
      return -1
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
          let index = this.getIndexOfRatedPersion(item.ratePersion)
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
      let obj = {
        staffRate: totalRate / count,
        manageRate: manageRate
      }
      return obj
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

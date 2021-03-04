<template>
  <div v-if="$store.state.userInfo.id === 26 || $store.state.userInfo.id === 15">
    <el-form class="main-search" :inline="true">
      <el-form-item label="互评月份：" prop="title">
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
    </el-form-item>
    </el-form>
    <!-- 分割线 start -->
    <div class="hr-10"></div>
    <!-- 分割线 end -->
    <br>
    <div>
      <el-table
        :data="tableData"
        style="margin: auto; width: 99%"
        border
        :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333'}"
        :cell-style="{ padding: '5px 0' }"
        v-loading="!reqFlag.getAllUserRates">
        <el-table-column label="序号" align="center" type="index" width="50"></el-table-column>
        <el-table-column label="小组" align="center" prop="groupName"></el-table-column>
        <el-table-column label="姓名" align="center" prop="name"></el-table-column>
        <el-table-column label="当月评价状态" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.isRate? 'success' : 'danger'" size="medium">{{scope.row.isRate? '已评价' : '未评价'}}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="员工互评得分" align="center" prop="staffRate"></el-table-column>
        <el-table-column label="管理者评价得分" align="center" prop="managerRate"></el-table-column>
<!--        <el-table-column label="总分" align="center" prop="totalRate"></el-table-column>-->
      </el-table>
      <br>
      <br>
    </div>
  </div>
  <div v-else>
    <h2>暂无权限</h2>
  </div>
</template>

<script>
  import { getUsersName, getAllUserRates } from '@/config/interface'
  export default {
    data () {
      return {
        formData: {
          title: this.$moment().format('YYYY-MM')
        },
        reqFlag: {
          getUsersList: true,
          getAllUserRates: true
        },
        tableData: [],
        ratesTableTmp: [],
        usersList: [],
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
    methods: {
      // 初始化
      init () {
        this.getCookie()
        this.getUsersList().then(res1 => {
          this.usersList = res1
          this.getAllUserRates(res1).then((res2) => {
            let mutualRatesRankResult = this.calMutualRatesRank(res2)
            console.log(mutualRatesRankResult)
            this.tableData = res2
          })
        })
      },
      // 设置月份cookie
      setMonthCookie (month, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'mCMon' + '=' + month + ';path=/;expires=' + exdate.toGMTString()
      },
      // 读取月份cookie
      getCookie: function () {
        if (document.cookie.length > 0) {
          let arr = document.cookie.split('; ') // 这里显示的格式需要切割一下自己可输出看下
          for (let i = 0; i < arr.length; i++) {
            let arr2 = arr[i].split('=') // 再次切割
            // 判断查找相对应的值
            if (arr2[0] === 'mCMon') {
              this.formData.title = arr2[1]
            }
          }
        }
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
      // 获取领导评价相关信息
      getManagerResult (id, allUsersRates) {
        for (let item of allUsersRates) {
          if (item.id === id) {
            return { managerRateRank: item.managerRateRank, managerScore: item.managerScore }
          }
        }
      },
      // 计算定性评价排名与得分
      calMutualRatesRank (allUserRatesTmp) {
        let allUserRates = JSON.parse(JSON.stringify(allUserRatesTmp))
        let managerIndex = allUserRates.findIndex(allUserRatesItem => {
          return allUserRatesItem.id === 26
        })
        if (managerIndex !== -1) {
          allUserRates.splice(managerIndex, 1)
        }
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
        let curRateResult = allRates.find((item) => {
          return item.id === this.$store.state.userInfo.id
        })
        if (curRateResult) {
          this.multualScore = curRateResult.staffMutualScore
          this.multualRank = curRateResult.staffRateRank
        } else {
          // this.$common.toast('暂未统计', 'error', false)
        }
        return allRates
      },
      // 获取全处员工互评信息
      getAllUserRates (users) {
        const url = getAllUserRates
        let result = []
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
                    obj.staffRate = Number(getRated.staffRate.toFixed(4))
                    obj.managerRate = Number(getRated.manageRate.toFixed(4))
                    obj.isRate = item.rateData.length !== 0
                    obj.totalRate = Number((obj.staffRate * 0.1 + obj.managerRate * 0.2).toFixed(3))
                    result.push(obj)
                  }
                  resolve(result)
                }
                _this.reqFlag.getAllUserRates = true
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
        let totalScore = t1Score * 0.15 + t2Score * 0.2 + t3Score * 0.1 +
          t4Score * 0.1 + t5Score * 0.3 + t6Score * 0.15
        return totalScore
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
      // 月份变化
      handelDateChange () {
        this.setMonthCookie(this.formData.title, 7)
        // this.getAllUserRates(this.usersList).then()
        this.getAllUserRates(this.usersList).then((res2) => {
          let mutualRatesRankResult = this.calMutualRatesRank(res2)
          console.log(mutualRatesRankResult)
          this.tableData = res2
        })
      },
      // 上一月
      handlePreMonth () {
        this.formData.title = this.$moment(this.formData.title).subtract(1, 'months').format('YYYY-MM')
        this.handelDateChange()
      },
      // 下一月
      handleNextMonth () {
        this.formData.title = this.$moment(this.formData.title).add(1, 'months').format('YYYY-MM')
        this.handelDateChange()
      }
    },
    created () {
      this.init()
    },
    name: 'muLEvaCheck'
  }
</script>

<style scoped>

</style>

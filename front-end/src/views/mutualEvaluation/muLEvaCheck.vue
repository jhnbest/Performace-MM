<template>
  <div>
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
        :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333'}" :cell-style="{ padding: '5px 0' }">
        <el-table-column label="序号" align="center" type="index" width="50"></el-table-column>
        <el-table-column label="小组" align="center" prop="groupName"></el-table-column>
        <el-table-column label="姓名" align="center" prop="name"></el-table-column>
        <el-table-column label="员工评价得分" align="center" prop="staffRate"></el-table-column>
        <el-table-column label="管理者评价得分" align="center" prop="managerRate"></el-table-column>
        <el-table-column label="当月评价状态" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.isRate? 'success' : 'danger'" size="medium">{{scope.row.isRate? '已评价' : '未评价'}}</el-tag>
          </template>
        </el-table-column>
      </el-table>
    </div>
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
          getUsersList: true
        },
        tableData: [],
        ratesTableTmp: [],
        usersList: []
      }
    },
    methods: {
      // 初始化
      init () {
        this.getUsersList().then(res1 => {
          this.usersList = res1
          this.getAllUserRates(res1)
        })
      },
      // 获取全处员工互评信息
      getAllUserRates (users) {
        const url = getAllUserRates
        let params = {
          usersData: users,
          rateMonth: this.formData.title
        }
        this.$http(url, params)
          .then(res => {
            if (res.code === 1) {
              this.tableData = []
              for (let item of res.data) {
                let obj = {
                  id: item.id,
                  name: item.name,
                  groupName: item.groupName
                }
                let getRated = this.getMulRated(item.ratedData)
                obj.staffRate = getRated.staffRate
                obj.managerRate = getRated.manageRate
                obj.isRate = item.rateData.length !== 0
                this.tableData.push(obj)
              }
            }
          })
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
        this.getAllUserRates(this.usersList)
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

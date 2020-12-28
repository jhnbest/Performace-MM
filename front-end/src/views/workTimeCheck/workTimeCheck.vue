<template>
  <div>
    <el-form class="main-search" :inline="true">
      <el-form-item label="申报月份" prop="title">
        <el-date-picker
          v-model="formData.title"
          type="month"
          format="yyyy 第 MM 月"
          value-format="yyyy-MM"
          placeholder="选择月"
          style="width: 150px"
          @change="handelDateChange">
        </el-date-picker>
      </el-form-item>
    </el-form>
    <!-- 分割线 start -->
    <div class="hr-10"></div>
    <!-- 分割线 end -->
    <div class="main-content">
      <el-radio-group v-model="formData.selectType" @change="handleSelectTypeChange" :disabled="!reqFlag.getProjectList">
        <el-radio-button label="技术标准组"
                         v-if="$store.state.userInfo.groupName === '技术标准组'
                          || $store.state.userInfo.groupName === '处经理'"></el-radio-button>
        <el-radio-button label="工程组"
                         v-if="$store.state.userInfo.groupName === '工程组'
                          || $store.state.userInfo.groupName === '处经理'"></el-radio-button>
        <el-radio-button label="通信组"
                         v-if="$store.state.userInfo.groupName === '通信组'
                          || $store.state.userInfo.groupName === '处经理'"></el-radio-button>
      </el-radio-group>
    </div>
    <div>
      <el-table :data="tableData" style="width: 97%;margin: auto">
        <el-table-column label="序号" align="center" type="index"></el-table-column>
        <el-table-column label="姓名" align="center" prop="name"></el-table-column>
        <el-table-column label="获得工时" align="center" prop="totalWorkTime"></el-table-column>
        <el-table-column label="小组排名" align="center" prop="rank"></el-table-column>
        <el-table-column label="定量指标得分" align="center" prop="quantitativeScore"></el-table-column>
      </el-table>
      <br>
      <br>
    </div>
  </div>
</template>

<script>
  import { getGroupUserName, getUnReviewProjectCount, getGroupWorkTimeList } from '@/config/interface'
  export default {
    data () {
      return {
        formData: {
          title: this.$moment().format('YYYY-MM'),
          selectType: this.$store.state.userInfo.groupName
        },
        tableData: [],
        reqFlag: {
          getProjectList: true
        }
      }
    },
    methods: {
      init () {
        this.getGroupWorkTimeList(this.$store.state.userInfo.groupID)
      },
      // 比较函数
      compare (totalWorkTime) {
        return function (o, p) {
          let a, b
          if (typeof o === 'object' && typeof p === 'object' && o && p) {
            a = o[totalWorkTime]
            b = p[totalWorkTime]
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
      // 获取已审项目列表
      getGroupWorkTimeList (groupID) {
        const url = getGroupWorkTimeList
        if (this.reqFlag.getProjectList) {
          this.reqFlag.getProjectList = false
          let params = {
            groupID: groupID,
            applyMonth: this.formData.title
          }
          this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                let data = res.data
                let userID = []
                let totalWorkTimeCal = []
                for (let item of data) { // 插入各组员总工时信息
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
                let preWorkTime = 0
                let preRank = 0
                for (let item of totalWorkTimeCal) { // 计算排名
                  if (item.totalWorkTime === preWorkTime) {
                    item.rank = preRank
                  } else {
                    item.rank = ++preRank
                  }
                  preWorkTime = item.totalWorkTime
                }
                let length = totalWorkTimeCal.length
                for (let item of totalWorkTimeCal) { // 计算定量指标得分
                  let rankPercentage = item.rank / length
                  if (rankPercentage < 0.1 || rankPercentage === 0.1) {
                    item.quantitativeScore = 92.5
                  } else if (rankPercentage < 0.3 || rankPercentage === 0.3) {
                    item.quantitativeScore = 90
                  } else if (rankPercentage < 0.7 || rankPercentage === 0.7) {
                    item.quantitativeScore = 87.5
                  } else if (rankPercentage < 0.9 || rankPercentage === 0.9) {
                    item.quantitativeScore = 85
                  } else if (rankPercentage < 1 || rankPercentage === 1) {
                    item.quantitativeScore = 82.5
                  }
                }
                this.tableData = totalWorkTimeCal
              }
              this.reqFlag.getProjectList = true
            })
        }
      },
      // 组名转ID
      groupName2ID (groupName) {
        switch (groupName) {
          case '技术标准组':
            return 1
          case '工程组':
            return 2
          case '通信组':
            return 3
          case '处经理':
            return 4
          default:
            return 1
        }
      },
      // 申报月份变化
      handelDateChange () {
        let groupID = this.groupName2ID(this.formData.selectType)
        this.getGroupWorkTimeList(groupID)
      },
      // 小组切换
      handleSelectTypeChange (selectType) {
        console.log(selectType)
        let groupID = this.groupName2ID(this.formData.selectType)
        this.getGroupWorkTimeList(groupID)
      }
    },
    created () {
      console.log('===workTimeCheck.vue')
      console.log(this.$store.state.userInfo)
      this.init()
    },
    name: 'workTimeCheck'
  }
</script>

<style scoped>

</style>

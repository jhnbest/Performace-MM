<template>
  <div>
    <el-form class="main-search" :inline="true">
      <el-form-item label="申报月份：" prop="title">
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
    <div style="margin-top: -20px">
      <el-table :data="tableData"
                style="width: 97%; margin: auto"
                border
                :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333'}">
        <el-table-column label="序号" align="center" type="index" width="50"></el-table-column>
        <el-table-column label="姓名" align="center" prop="name"></el-table-column>
        <el-table-column label="获得工时" align="center" prop="totalWorkTime"></el-table-column>
        <el-table-column label="小组排名" align="center" prop="rank"></el-table-column>
        <el-table-column label="定量指标得分" align="center" prop="quantitativeScore"></el-table-column>
      </el-table>
    </div>
    <br>
    <br>
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
        this.getCookie()
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
                        wItem.totalWorkTime = Number(wItem.totalWorkTime.toFixed(1))
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
                let length = totalWorkTimeCal.length
                for (let item of totalWorkTimeCal) { // 计算定量指标得分
                  item.quantitativeScore = this.calGetScore(length, item.rank)
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
        this.setCookie(this.formData.title, 7)
      },
      // 小组切换
      handleSelectTypeChange (selectType) {
        let groupID = this.groupName2ID(this.formData.selectType)
        this.getGroupWorkTimeList(groupID)
      },
      // 设置cookie
      setCookie (month, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'wcMon' + '=' + month + ';path=/;expires=' + exdate.toGMTString()
      },
      // 读取cookie
      getCookie: function () {
        if (document.cookie.length > 0) {
          let arr = document.cookie.split('; ') // 这里显示的格式需要切割一下自己可输出看下
          for (let i = 0; i < arr.length; i++) {
            let arr2 = arr[i].split('=') // 再次切割
            // 判断查找相对应的值
            if (arr2[0] === 'wcMon') {
              this.formData.title = arr2[1] // 保存到保存数据的地方
            }
          }
        }
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
    name: 'workTimeCheck'
  }
</script>

<style scoped>

</style>

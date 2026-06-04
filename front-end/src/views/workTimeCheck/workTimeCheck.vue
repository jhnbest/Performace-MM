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
      <el-radio-group v-model="formData.selectType" @change="handleSelectTypeChange" :disabled="!reqFlag.reqGetProjectList">
        <el-radio-button label="多媒体应用组"
                         v-if="$store.state.userInfo.groupID === 2
                          || $store.state.userInfo.groupID === 1"></el-radio-button>
        <el-radio-button label="数字物联组"
                         v-if="$store.state.userInfo.groupID === 3
                          || $store.state.userInfo.groupID === 1"></el-radio-button>
        <el-radio-button label="综合业务组"
                         v-if="$store.state.userInfo.groupID === 4
                          || $store.state.userInfo.groupID === 1"></el-radio-button>
        <el-radio-button label="通信组"
                         v-if="$store.state.userInfo.groupID === 5
                          || $store.state.userInfo.groupID === 1"></el-radio-button>
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
      </el-table>
    </div>
    <br>
    <br>
  </div>
</template>

<script>
  import { getGroupWorkTimeList } from '@/config/interface'
import store from '@/store'
  export default {
    data () {
      return {
        formData: {
          title: this.$moment().format('YYYY-MM'),
          selectType: '多媒体应用组'
        },
        tableData: [],
        reqFlag: {
          reqGetProjectList: true
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
      // 获取已审项目列表
      getGroupWorkTimeList (groupID) {
        const url = getGroupWorkTimeList
        if (this.reqFlag.reqGetProjectList) {
          this.reqFlag.reqGetProjectList = false
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
                this.tableData = totalWorkTimeCal
              }
              this.reqFlag.reqGetProjectList = true
            })
        }
      },
      // 组名转ID
      groupName2ID (groupName) {
        switch (groupName) {
          case '多媒体应用组':
            return 2
          case '数字物联组':
            return 3
          case '综合业务组':
            return 4
          case '通信组':
            return 5
          default:
            return 1
        }
      },
      // 申报月份变化
      handelDateChange () {
        switch (store.state.userInfo.groupID) {
          case 1 :
            this.formData.selectType = '多媒体应用组'
            break
          case 2 :
            this.formData.selectType = '多媒体应用组'
          break
          case 3 :
            this.formData.selectType = '数字物联组'
          break
          case 4 :
            this.formData.selectType = '综合业务组'
          break
          case 5 :
            this.formData.selectType = '通信组'
          break
          default :
            this.formData.selectType = '多媒体应用组'
          break
        }
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

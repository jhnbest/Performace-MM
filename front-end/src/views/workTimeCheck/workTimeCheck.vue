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
      <el-radio-group v-model="formData.selectType" @change="handleSelectTypeChange">
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
        <el-table-column label="获得工时" align="center" prop="getWorkTime"></el-table-column>
        <el-table-column label="小组排名" align="center" prop="rank"></el-table-column>
      </el-table>
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
        this.getGroupWorkTimeList()
      },
      // 获取已审项目列表
      getGroupWorkTimeList (data) {
        const url = getGroupWorkTimeList
        if (this.reqFlag.getProjectList) {
          this.reqFlag.getProjectList = false
          let params = {
            groupID: this.$store.state.userInfo.groupID,
            searchType: 'reviewed',
            searchMon: this.formData.title
          }
          this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                let data = res.data
                console.log(data)
              }
            })
        }
      },
      handelDateChange () {
      },
      handleSelectTypeChange (selectType) {
        console.log(selectType)
      }
    },
    created () {
      console.log('===workTimeCheck.vue')
      console.log(this.$store.state.userInfo)
      // this.init()
    },
    name: 'workTimeCheck'
  }
</script>

<style scoped>

</style>

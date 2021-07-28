<template>
  <div>
    <el-form class="main-search" :inline="true">
      <el-row type="flex">
        <el-col :xs="12" :sm="12" :lg="9" :xl="6">
          <!--        年份选择-->
          <el-form-item label="月份选择：" prop="title">
            <el-button size="mini"
                       type="danger"
                       style="margin-right: 10px"
                       @click="handlePreYear"
                       :disabled="!reqFlag.getCurYearConclusionOverviewData">上月</el-button>
            <el-date-picker
              v-model="formData.title"
              type="month"
              format="yyyy年MM月"
              value-format="yyyy-mm"
              placeholder="选择月份"
              style="width: 150px"
              @change="handelDateChange">
            </el-date-picker>
            <el-button size="mini"
                       type="primary"
                       style="margin-left: 10px"
                       @click="handleNextYear"
                       :disabled="!reqFlag.getCurYearConclusionOverviewData">下月</el-button>
          </el-form-item>
        </el-col>
        <!--      填报说明-->
        <el-col :xs="2" :sm="2" :lg="{span: 6, pull: 1}" :xl="{span: 6, pull: 0}" style="margin-top: 10px">
          <el-popover
            placement="bottom"
            width="470"
            trigger="click">
            <span>1、查看评价标准，了解评价衡量标准以及分值对应的评价星级；</span><br>
            <span>2、点击评价对象相应评价项下的星星，完成该评价项的评分(未点击默认按照3颗星计算分值)</span>；<br>
            <span>3、完成对所有评价对象的所有评价项的评分，点击提交按钮即可；</span><br>
            <span>4、若需要更改当月的评价，则直接修改相应的星星，然后点击更新即可；</span><br>
            <span>5、每月
            <span style="font-weight: bolder;color: red">3日0点前</span>，
            需完成对处室相关成员的评价。若未提交当月评价，
            <span style="font-weight: bolder;color: red">则默认按照上一月份的评价数据计算</span>；
          </span><br>
            <span>6、评价截止时间过后，将<span style="font-weight: bolder;color: red">不能</span>修改当月评价。</span><br>
            <span slot="reference" class="pointer-type"><i class="el-icon-warning-outline"></i>填报说明</span>
          </el-popover>
        </el-col>
      </el-row>
    </el-form>
    <!-- 分割线 start -->
    <div class="hr-10"></div>
    <!-- 分割线 end -->
    <br>
    <!--  月总结表格-->
    <div>
      <el-table :data="conclusionTableData"
                border
                style="margin: auto; width: 99%"
                stripe
                size="medium"
                :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }"
                v-loading="!reqFlag.getCurApplyAbleMonth || !reqFlag.getCurYearConclusionOverviewData"
                :height="tableHeight"
                ref="rateTable"
                highlight-current-row>
        <el-table-column label="类型" align="center" min-width="50">
          <template slot-scope="scope">
            <el-tag :type="scope.row.conclusionType | conclusionTypeFilter" size="medium">
              <span>{{scope.row.conclusionType | conclusionTypeTextFilter}}</span>
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="姓名" align="center" prop="name" min-width="50"></el-table-column>
        <el-table-column label="标题" align="center" prop="conclusionTitle"></el-table-column>
        <el-table-column label="提交状态" align="center" width="100">
          <template slot-scope="scope">
            <el-tag v-if="scope.row.id !== null" :type="scope.row.submitStatus | submitStatusFilter" size="medium">
              <span>{{scope.row.submitStatus | submitStatusTextFilter}}</span>
            </el-tag>
            <el-tag v-else type="info" size="medium">
              <span>{{'未提交'}}</span>
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="管理者评分" align="center">
          <template slot-scope="scope">
            <el-rate v-model="scope.row.getEvaStar" slot="reference" style="size: 50px"></el-rate>
          </template>
        </el-table-column>
        <el-table-column label="获得工时" align="center" prop="getWorkTime" width="100"></el-table-column>
        <el-table-column label="操作" align="center" width="250">
          <template slot-scope="scope">
            <!--          点击预览-->
            <!--          <el-popover-->
            <!--            placement="left"-->
            <!--            trigger="click">-->
            <!--          </el-popover>-->
            <el-button slot="reference"
                       type="primary"
                       size="mini"
                       @click="handlePreview(scope.row, scope.$index)">点击查看</el-button>
            <!--          编辑-->
            <el-button :disabled="(scope.row.managerRateStar) || (curApplyYear > formData.title) ||
                    ((curApplyMonth > scope.row.submitMonth) && (curApplyYear === Number(formData.title)))"
                       size="mini"
                       type="warning"
                       @click="handleEdit(scope.row, scope.$index)"
                       style="margin-left: 10px">编辑</el-button>
            <!--          暂存-->
            <el-button v-if="scope.row.submitStatus === 1"
                       :disabled=" (scope.row.managerRateStar) || (curApplyYear > formData.title) ||
                    ((curApplyMonth > scope.row.submitMonth) && (curApplyYear === Number(formData.title))) || !reqFlag.updateMonthConclusionStatus"
                       size="mini"
                       type="info"
                       @click="handleTemporary(scope.row, scope.$index)">暂存</el-button>
            <!--          提交-->
            <el-button v-if="!(scope.row.submitStatus === 1)"
                       :disabled="!(scope.row.id) || !reqFlag.updateMonthConclusionStatus || (scope.row.managerRateStar) || (curApplyYear > formData.title) ||
                    ((curApplyMonth > scope.row.submitMonth) && (curApplyYear === Number(formData.title)))"
                       size="mini"
                       type="success"
                       @click="handleSubmit(scope.row, scope.$index)">提交</el-button>
          </template>
        </el-table-column>
      </el-table>
      <br>
    </div>
  </div>
</template>

<script>
  import {
    urlGetCurApplyAbleMonth } from '@/config/interface'
  import {
    getCurMonthConclusionOverviewData,
    updateMonthConclusionStatus } from '@/utils/conclusion'
  import {
    getCurApplyAbleMonth,
    getAllUsersInfo
  } from '@/utils/common'
  export default {
    data () {
      return {
        formData: {
          title: this.$moment().format('YYYY')
        },
        showFlag: {
          descTableShow: false
        },
        descriptionContent: '1、首先查看评价标准，了解',
        conclusionTableData: [],
        curUser: this.$store.state.userInfo.id,
        reqFlag: {
          getCurYearConclusionOverviewData: true,
          updateMonthConclusionStatus: true,
          getCurApplyAbleMonth: true
        },
        tableHeight: null,
        curApplyYear: 1970,
        curApplyMonth: 1,
        allUsers: null,
        defaultEvaStar: 1
      }
    },
    methods: {
      // 初始化
      init () {
        // 获取当前申报月份
        if (this.reqFlag.getCurApplyAbleMonth) {
          this.reqFlag.getCurApplyAbleMonth = false
          getCurApplyAbleMonth().then(getCurApplyAbleMonthRes => {
            this.curApplyYear = this.$moment(getCurApplyAbleMonthRes[0].setTime).year()
            this.curApplyMonth = this.$moment(getCurApplyAbleMonthRes[0].setTime).month() + 1
            // 获取全处员工信息
            getAllUsersInfo().then(getAllUsersInfoRes => {
              this.allUsers = getAllUsersInfoRes.list
              // 获取全处员工月总结信息
              this.getAllUsersConclusion(this.allUsers, this.curApplyYear, this.curApplyMonth).then(getAllUsersConclusionRes => {
                // 填充总结表格数据
                this.fillConclusionTableData(getAllUsersConclusionRes)
              })
            }).catch(() => {
              this.$common.toast('获取全处员工信息失败', 'error', false)
            })
            this.reqFlag.getCurApplyAbleMonth = true
          }).catch(() => {
            this.$common.toast('获取当前申报月份错误', 'error', false)
            this.reqFlag.getCurApplyAbleMonth = true
          })
        }
        // // 初始化默认数据
        // this.initDefaultData()
      },
      // 获取全处员工月总结信息
      getAllUsersConclusion (allUsers, submitYear, submitMonth) {
        let promise = []
        let count = 0
        return new Promise(function (resolve, reject) {
          for (let user of allUsers) {
            promise[count++] = getCurMonthConclusionOverviewData(submitMonth, submitYear, user.id)
          }
          Promise.all(promise).then(result => {
            resolve(result)
          })
        })
      },
      // 填充表格数据
      fillConclusionTableData (getAllUsersConclusionRes) {
        console.log('getAllUsersConclusionRes')
        console.log(getAllUsersConclusionRes)
        this.conclusionTableData = []
        let count = 0
        for (let getAllUsersConclusionResItem of getAllUsersConclusionRes) {
          let obj = {
            id: null,
            conclusionType: 1,
            name: this.allUsers[count++].name,
            conclusionTitle: this.$moment(this.formData.title).month() + 1 + '月份总结',
            month: this.$moment(this.formData.title).month() + 1 + '月份',
            submitMonth: this.$moment(this.formData.title).month() + 1,
            submitStatus: null,
            getEvaStar: this.defaultEvaStar,
            getWorkTime: null,
            curConclusion: null,
            nextPlan: null,
            curAdvice: null
          }
          if (getAllUsersConclusionResItem.data.length !== 0) {
          } else {
            this.conclusionTableData.push(obj)
          }
        }
      },
      // 初始化默认数据
      initDefaultData () {
        for (let i = 0; i < 12; i++) {
          let obj = {
            conclusionType: 1,
            month: i + 1 + '月份',
            submitMonth: i + 1,
            conclusionTitle: i + 1 + '月份总结',
            submitStatus: null,
            getEvaStar: null,
            getWorkTime: null,
            id: null,
            curConclusion: null,
            nextPlan: null,
            curAdvice: null
          }
          this.conclusionTableData.push(obj)
        }
      },
      // 点击预览
      handlePreview () {
      },
      // 编辑月总结
      handleEdit (row, index) {
        this.$router.push({
          path: '/home/monthConclusionTable',
          query: {
            id: row.id,
            conclusionTitle: row.conclusionTitle,
            submitYear: this.formData.title,
            submitMonth: row.submitMonth,
            submitter: this.$store.state.userInfo.id,
            curConclusion: row.curConclusion,
            nextPlan: row.nextPlan,
            curAdvice: row.curAdvice
          }
        })
      },
      // 提交月总结
      handleSubmit (row, index) {
        let submitStatus = 1
        if (this.reqFlag.updateMonthConclusionStatus) {
          this.reqFlag.updateMonthConclusionStatus = false
          updateMonthConclusionStatus(row.id, submitStatus).then(() => {
            row.submitStatus = submitStatus
            this.reqFlag.updateMonthConclusionStatus = true
            this.$common.toast('提交成功', 'success', false)
          }).catch(() => {
            this.reqFlag.updateMonthConclusionStatus = true
            this.$common.toast('提交失败', 'error', false)
          })
        }
      },
      // 暂存月总结
      handleTemporary (row, index) {
        let submitStatus = 2
        if (this.reqFlag.updateMonthConclusionStatus) {
          this.reqFlag.updateMonthConclusionStatus = false
          updateMonthConclusionStatus(row.id, submitStatus).then(() => {
            row.submitStatus = submitStatus
            this.reqFlag.updateMonthConclusionStatus = true
            this.$common.toast('暂存成功', 'success', false)
          }).catch(() => {
            this.reqFlag.updateMonthConclusionStatus = true
            this.$common.toast('暂存失败', 'error', false)
          })
        }
      },
      // 获取当前可申报的月份
      getCurApplyAbleMonth () {
        const url = urlGetCurApplyAbleMonth
        let params = {}
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              resolve(res.data)
            } else {
              reject(res.data)
            }
          }).catch(err => {
            reject(err)
          })
        })
      },
      // 上一年
      handlePreYear () {
        this.formData.title = this.$moment(this.formData.title).subtract(1, 'months').format('YYYY-MM')
        this.setMonthCookie(this.formData.title, 7)
        this.handelDateChange()
      },
      // 下一年
      handleNextYear () {
        this.formData.title = this.$moment(this.formData.title).add(1, 'months').format('YYYY-MM')
        this.setMonthCookie(this.formData.title, 7)
        this.handelDateChange()
      },
      // 申报月份变化
      handelDateChange () {
        let submitYear = this.$moment(this.formData.title).year()
        let submitMonth = this.$moment(this.formData.title).month() + 1
        this.getAllUsersConclusion(this.allUsers, submitYear, submitMonth)
      },
      // 设置cookie
      setCookie (showTable, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'sst' + '=' + showTable + ';path=/;expires=' + exdate.toGMTString()
      },
      // 设置月份cookie
      setMonthCookie (month, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'mMon' + '=' + month + ';path=/;expires=' + exdate.toGMTString()
      },
      // 读取cookie
      getCookie: function () {
        if (document.cookie.length > 0) {
          let arr = document.cookie.split('; ') // 这里显示的格式需要切割一下自己可输出看下
          for (let i = 0; i < arr.length; i++) {
            let arr2 = arr[i].split('=') // 再次切割
            // 判断查找相对应的值
            if (arr2[0] === 'sst') {
              this.showFlag.descTableShow = arr2[1] === 'true'
            }
            if (arr2[0] === 'mMon') {
              this.formData.title = arr2[1]
            }
          }
        }
      },
      // 标准表格显示开关
      handleSwitchChange () {
        this.setCookie(this.showFlag.descTableShow, 7)
        this.refreshTableSize()
      }
    },
    filters: {
      submitStatusFilter (status) {
        if (status === 1) {
          return 'success'
        } else if (status === 2) {
          return 'warning'
        } else if (status === 0) {
          return 'info'
        }
      },
      submitStatusTextFilter (status) {
        if (status === 1) {
          return '已提交'
        } else if (status === 2) {
          return '暂存'
        } else if (status === 0) {
          return '未提交'
        }
      },
      conclusionTypeFilter (status) {
        switch (status) {
          case 1:
            return 'success'
          case 2:
            return 'danger'
          default:
            return 'danger'
        }
      },
      conclusionTypeTextFilter (status) {
        switch (status) {
          case 1:
            return '月总结'
          case 2:
            return '年度总结'
          case 3:
            return '年中总结'
          default:
            return '错误'
        }
      },
      manageRateStatusTextFilter (status) {
        switch (status) {
          case 1:
            return '月总结'
          case 2:
            return '年度总结'
          case 3:
            return '年中总结'
          default:
            return '错误'
        }
      }
    },
    components: {
      // CountTo
      // monthConclusionTable
    },
    created () {
      this.init()
    },
    watch: {
    },
    mounted () {
    },
    name: 'conclusionEva'
  }
</script>

<style scoped>
</style>

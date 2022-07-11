<template>
  <div>
    <el-form class="main-search" :inline="true">
      <el-form-item label="申报月份：">
        <el-button size="mini"
                   type="danger"
                   style="margin-right: 10px"
                   @click="handlePreMonth"
                   :disabled="!reqFlag.handelDateChange">上月</el-button>
        <el-date-picker
          v-model="title"
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
                   :disabled="!reqFlag.handelDateChange">下月</el-button>
      </el-form-item>
      <el-form-item style="margin-left: 30px">
        <span v-if="formData.selectType === '工时查询'" style="font-size: 21px;font-weight: bold">本月实际获得工时:
        <count-to
          :start-val="0"
          :end-val="formData.totalWorkTime"
          :duration="1000"
          :decimals="1"
          style="color: #F56C6C;margin-left: 10px;font-size: 25px"/>
        </span>
        <span v-if="formData.selectType === '计划查询'" style="font-size: 21px;font-weight: bold">本月预计获得工时:
        <count-to
          :start-val="0"
          :end-val="planGetWorkTime"
          :duration="2600"
          :decimals="1"
          style="color: #F56C6C;margin-left: 10px;font-size: 25px"/></span>
      </el-form-item>
    </el-form>
    <!-- 分割线 start -->
    <div class="hr-10"></div>
    <!-- 分割线 end -->
    <div>
      <el-table v-if="showFlag.factTableShow"
        :data="workDetailTable"
        style="width: 99%;margin: auto; margin-top: 20px"
        border
        :span-method="objectSpanMethod"
        :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }">
        <el-table-column type="expand">
          <template slot-scope="scope">
            <el-form label-position="left" inline class="demo-table-expand">
              <el-form-item label="提交时间">
                <span>{{ scope.row.submitTime }}</span>
              </el-form-item>
              <el-form-item label="审核人">
                <span>{{ scope.row.reviewerName }}</span>
              </el-form-item>
              <el-form-item label="更新时间">
                <span>{{ scope.row.updateTime }}</span>
              </el-form-item>
              <el-form-item label="审核时间">
                <span>{{ scope.row.reviewTime }}</span>
              </el-form-item>
              <el-form-item label="审核备注">
                <span v-if="scope.row.reviewComments !== ''">{{ scope.row.reviewComments }}</span>
                <span v-else>无</span>
              </el-form-item>
            </el-form>
          </template>
        </el-table-column>
        <el-table-column label="序号" align="center" type="index" width="50%"></el-table-column>
        <el-table-column label="角色" align="center" width="100%">
          <template slot-scope="scope">
            <el-tag :type="roleStatusFilter(scope.row.submitID)" size="medium">
              {{roleStatusTextFilter(scope.row.submitID)}}
            </el-tag>
          </template>
        </el-table-column>
<!--          <el-table-column label="申报月份" align="center" prop="applyMonth"></el-table-column>-->
        <el-table-column label="项目名称" align="center" prop="projectName"></el-table-column>
        <el-table-column label="项目阶段" align="center" prop="projectStageName"></el-table-column>
        <el-table-column label="工时详情" align="center" width="100%">
          <template slot-scope="scope">
            <span class="link-type" @click="handleCoopInfo(scope.row)">点击查看</span>
          </template>
        </el-table-column>
        <el-table-column label="备注" align="center" width="100%">
          <template slot-scope="scope">
            <div v-if="scope.row.submitComments !== ''">
              <el-popover
                placement="top-start"
                trigger="hover"
                :content="scope.row.submitComments">
                <span slot="reference" class="link-type">查看</span>
              </el-popover>
            </div>
            <div v-else>
              <span>无</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="提交状态" align="center" class-name="status-col" width="100%">
          <template slot-scope="scope">
            <el-tag :type="scope.row.submitStatus | submitStatusFilter" size="medium">
              {{ scope.row.submitStatus | submitStatusTextFilter}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="审核状态" align="center" width="100%">
          <template slot-scope="scope">
            <el-tag :type="scope.row.reviewStatus | reviewStatusFilter" size="medium">
              {{ scope.row.reviewStatus | reviewStatusTextFilter}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="获得工时" align="center" prop="assignWorkTime" width="100%"></el-table-column>
        <el-table-column label="操作" align="center" width="250%">
          <template slot-scope="scope">
            <el-button :disabled="scope.row.submitStatus === 1 || ((scope.row.reviewStatus === 1)) || isAssginer(scope.row.submitID)"
                       type="primary"
                       size="mini"
                       @click="handleEdit(scope.row, scope.$index)">编辑</el-button>
            <el-button v-if="!(scope.row.submitStatus === 1)"
                       :disabled="(scope.row.reviewStatus === 1 || isAssginer(scope.row.submitID))"
                       size="mini"
                       type="success"
                       @click="handleSubmitStatus(scope.row)">提交</el-button>
            <el-button v-if="scope.row.submitStatus === 1"
                       :disabled="(scope.row.reviewStatus === 1 || isAssginer(scope.row.submitID))"
                       size="mini"
                       type="info"
                       @click="handleSubmitStatus(scope.row)">暂存</el-button>
            <el-button :disabled="(scope.row.reviewStatus === 1 || isAssginer(scope.row.submitID))"
                       size="mini"
                       type="danger"
                       @click="handleDelete(scope.row, scope.$index)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <Cop v-if="showFlag.cop" ref="cop"/>
  </div>
</template>

<script>
    import Cop from '@/components/Cop/Cop'
    import CountTo from 'vue-count-to'
    import { getAssignWorkTime, getGroupWorkTimeList, urlGetIsSubmitAllow } from '@/config/interface'
    import { getProjectList, deleteWorkTimeSubmit, changeSubmitStatus } from '@/utils/performance'
    import { getIsSubmitAllow } from '@/utils/common'
    import store from '@/store'
    export default {
      data () {
        return {
          props: {
            value: 'projectTypeID',
            label: 'projectName'
          },
          title: this.$moment().format('YYYY-MM'),
          formData: {
            totalWorkTime: 0,
            selectType: '工时查询',
            rank: 0
          },
          showFlag: {
            cop: false,
            factTableShow: true,
            planTableShow: false
          },
          reqFlag: {
            changeSubmitStatus: true,
            deleteProject: true,
            getGroupWorkTimeList: true,
            getAssignWorkTimes: true,
            handelDateChange: true
          },
          pageNum: 1, // 请求第几页
          pageSize: this.$store.state.pageSize, // 每页请求多少条
          currentPage: 1, // 初始时在第几页
          workDetailTable: [],
          workPlanTableData: [],
          planGetWorkTime: 0
        }
      },
      methods: {
        // 初始化
        init () {
          this.getCookie()
          this.fillTableData()
        },
        // 审核表格合并前处理
        handleTable (Table) {
          let preAplID = 0
          let count = 1
          let preIndex = 0
          for (let i = 0; i < Table.length; i++) {
            Table[i].rowSpan = 1
            Table[i].colSpan = 1
            if (Table[i].aplID === preAplID) {
              Table[preIndex].rowSpan = ++count
              Table[i].rowSpan = 0
              Table[i].colSpan = 0
            } else {
              preIndex = i
              count = 1
              preAplID = Table[i].aplID
            }
          }
        },
        // 获取工时申报列表
        fillTableData () {
          this.reqFlag.handelDateChange = false
          this.workPlanTableData = []
          this.workDetailTable = []
          getProjectList(store.state.userInfo.id, this.title, this.pageNum, this.pageSize, null, null).then(res => {
            let factWorkTimeList = []
            let planWorkTimeList = []
            this.planGetWorkTime = 0
            for (let item of res.list) {
              item.assignWorkTime = null
              if (item.applyType === 'fact') { // 实际进展表格数据
                factWorkTimeList.push(item)
              } else if (item.applyType === 'plan') { // 计划进展表格数据
                this.planGetWorkTime += item.avaiableWorkTime
                planWorkTimeList.push(item)
              }
            }
            factWorkTimeList.sort(this.compare('aplID'))
            planWorkTimeList.sort(this.compare('aplID'))
            this.handleTable(factWorkTimeList)
            this.handleTable(planWorkTimeList)
            this.workPlanTableData = JSON.parse(JSON.stringify(planWorkTimeList))
            this.workDetailTable = JSON.parse(JSON.stringify(factWorkTimeList))
            this.totalCount = res.totalCount
            this.currentPage = this.pageNum
            let result = null
            if (this.formData.selectType === '工时查询') {
              result = factWorkTimeList
            } else if (this.formData.selectType === '计划查询') {
              result = planWorkTimeList
            }
            let promises = []
            let count = 0
            promises[count++] = this.getGroupWorkTimeList(this.$store.state.userInfo.groupID)
            promises[count++] = this.getAssignWorkTimes(result)
            Promise.all(promises).then(() => { this.reqFlag.handelDateChange = true }).catch(err => { this.reqFlag.handelDateChange = true; console.log(err) })
          }).catch(err => {
            this.reqFlag.handelDateChange = true
            this.$common.toast('错误', 'error', 'true')
            console.log(err)
          })
        },
        // 表格数据排序
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
        // 设置cookie
        setCookie (month, exdays) {
          let exdate = new Date() // 获取时间
          exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
          // 字符串拼接cookie
          window.document.cookie = 'pMonth' + '=' + month + ';path=/;expires=' + exdate.toGMTString()
        },
        // 读取cookie
        getCookie: function () {
          if (document.cookie.length > 0) {
            let arr = document.cookie.split('; ') // 这里显示的格式需要切割一下自己可输出看下
            for (let i = 0; i < arr.length; i++) {
              let arr2 = arr[i].split('=') // 再次切割
              // 判断查找相对应的值
              if (arr2[0] === 'pMonth') {
                this.title = arr2[1] // 保存到保存数据的地方
              }
            }
          }
        },
        // 申报月份变化
        handelDateChange () {
          this.setCookie(this.title, 7)
          this.fillTableData(store.state.userInfo.id, this.title, this.pageNum, this.pageSize)
        },
        handleAddNew () {
          this.$router.push({ path: '/home/PerformanceAddNew' })
        },
        // 查看工时分配情况
        handleCoopInfo (row) {
          this.showFlag.cop = true
          this.$nextTick(() => {
            this.$refs.cop.init(row)
          })
        },
        // 编辑按钮
        handleEdit (row, index) {
          this.$router.push({
            path: '/home/PerformanceEdit',
            query: {
              id: row.id
            }
          })
        },
        // 提交工时申报
        handleSubmitStatus (row) {
          let applyYear = this.$moment(this.title).year()
          let applyMonth = this.$moment(this.title).month() + 1
          getIsSubmitAllow(applyYear, applyMonth).then(getIsSubmitAllowRes => {
            if (getIsSubmitAllowRes.length === 0 || row.reviewStatus === 2 || this.$store.state.userInfo.id === 26) {
              if (this.reqFlag.changeSubmitStatus) {
                this.reqFlag.changeSubmitStatus = false
                row.submitStatus = row.submitStatus === 1 ? 0 : 1
                changeSubmitStatus(row.id, row.submitStatus).then(() => {
                  this.showFlag.factTableShow = false
                  this.$nextTick(() => {
                    this.showFlag.factTableShow = true
                  })
                  row.reviewStatus = row.submitStatus === 1 ? 0 : row.reviewStatus
                  this.$common.toast('操作成功', 'success', false)
                  this.reqFlag.changeSubmitStatus = true
                }).catch(err => {
                  console.log(err)
                  this.$common.toast('操作失败', 'error', false)
                  this.reqFlag.changeSubmitStatus = true
                })
              }
            } else {
              this.$common.toast(this.title + '月已截止申报工时', 'error', true)
            }
          })
        },
        // 删除工时申报
        handleDelete (row, index) {
          this.$common.msgBox('confirm', '操作提示', '确定删除？', () => {
            if (this.reqFlag.deleteProject) {
              this.reqFlag.deleteProject = false
              this.workDetailTable.splice(index, 1)
              this.workDetailTable.sort(this.compare('aplID'))
              this.handleTable(this.workDetailTable)
              deleteWorkTimeSubmit(row.id).then(res => {
                this.$common.toast('操作成功', 'success', false)
                this.reqFlag.deleteProject = true
              }).catch(err => {
                console.log(err)
                this.reqFlag.deleteProject = true
                this.$common.toast('操作失败', 'danger', false)
              })
            }
          })
        },
        async getAssignWorkTimes (data) {
          const url = getAssignWorkTime
          let i = 0
          this.formData.totalWorkTime = 0
          let params = {
            userID: this.$store.state.userInfo.id,
            projectData: []
          }
          if (data.length !== 0) {
            for (let item of data) {
              if (item.reviewStatus === 1) {
                item.index = i
                params.projectData.push(item)
              }
              i++
            }
            let _this = this
            return new Promise(function (resolve, reject) {
              _this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    let totalWorkTimeTmp = 0
                    for (let item of data) {
                      _this.workDetailTable[item.index].assignWorkTime = item.reviewWorkTime
                      totalWorkTimeTmp += item.reviewWorkTime
                    }
                    _this.formData.totalWorkTime = totalWorkTimeTmp
                    resolve(totalWorkTimeTmp)
                  } else {
                    reject(new Error('请求失败'))
                  }
                })
            })
          }
        },
        // 表格合并方法
        objectSpanMethod ({ row, column, rowIndex, columnIndex }) {
          if (columnIndex === 2 || columnIndex === 3) {
            return {
              rowspan: row.rowSpan,
              colspan: row.colSpan
            }
          }
        },
        // 获取已审项目列表
        getGroupWorkTimeList (groupID) {
          const url = getGroupWorkTimeList
          if (this.reqFlag.getGroupWorkTimeList) {
            this.reqFlag.getGroupWorkTimeList = false
            let params = {
              groupID: groupID,
              applyMonth: this.title
            }
            let _this = this
            return new Promise(function (resolve, reject) {
              _this.$http(url, params).then(res => {
                if (res.code === 1) {
                  let data = res.data
                  if (data.length > 0) {
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
                    _this.formData.rank = totalWorkTimeCal.find(item => {
                      if (item.id === _this.$store.state.userInfo.id) {
                        return item.rank
                      }
                    })
                    if (!_this.formData.rank) {
                      _this.formData.rank = 0
                    } else {
                      _this.formData.rank = _this.formData.rank.rank
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
                      if (item.rank === 1) {
                        item.quantitativeScore = 92.5
                      }
                    }
                    _this.tableData = totalWorkTimeCal
                  } else {
                    _this.formData.rank = 0
                  }
                  resolve(1)
                } else {
                  reject(new Error('请求失败'))
                }
                _this.reqFlag.getGroupWorkTimeList = true
                })
            })
          }
        },
        // 上一月
        handlePreMonth () {
          this.title = this.$moment(this.title).subtract(1, 'months').format('YYYY-MM')
          this.handelDateChange()
        },
        // 下一月
        handleNextMonth () {
          this.title = this.$moment(this.title).add(1, 'months').format('YYYY-MM')
          this.handelDateChange()
        }
      },
      computed: {
        roleStatusFilter () {
          return function (submitID) {
            if (Number(submitID) === this.$store.state.userInfo.id) {
              return 'success'
            } else {
              return 'warning'
            }
          }
        },
        roleStatusTextFilter () {
          return function (submitID) {
            if (Number(submitID) === this.$store.state.userInfo.id) {
              return '组织者'
            } else {
              return '协作者'
            }
          }
        },
        isAssginer () {
          return function (id) {
            if (Number(id) === Number(this.$store.state.userInfo.id)) {
              return false
            } else {
              return true
            }
          }
        }
      },
      components: {
        Cop,
        CountTo
      },
      filters: {
        submitStatusFilter (status) {
          if (status === 1) {
            return 'success'
          } else if (status === 0) {
            return 'info'
          }
        },
        submitStatusTextFilter (status) {
          if (status === 1) {
            return '已提交'
          } else if (status === 0) {
            return '暂存'
          }
        },
        reviewStatusFilter (status) {
          switch (status) {
            case 0:
              return 'info'
            case 1:
              return 'success'
            case 2:
              return 'danger'
            default:
              return 'danger'
          }
        },
        reviewStatusTextFilter (status) {
          switch (status) {
            case 0:
              return '未审核'
            case 1:
              return '已通过'
            case 2:
              return '驳回'
            default:
              return '错误'
          }
        }
      },
      created () {
        this.init()
      },
      mounted () {
        this.getCookie()
      }
    }
</script>

<style scoped>
</style>

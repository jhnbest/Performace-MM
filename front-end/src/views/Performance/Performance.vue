<template>
  <div>
    <el-form class="main-search" :inline="true">
      <el-form-item label="申报月份：" prop="title">
        <el-button size="mini"
                   type="danger"
                   style="margin-right: 10px"
                   @click="handlePreMonth"
                   :disabled="!reqFlag.handelDateChange">上月</el-button>
        <el-date-picker
          v-model="formData.title"
          type="month"
          format="yyyy 第 MM 月"
          value-format="yyyy-MM"
          placeholder="选择月"
          :picker-options="pickerOptions"
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
<!--          <span style="color: #F56C6C;margin-left: 10px;font-size: 25px">{{formData.totalWorkTime}}</span>-->
        <count-to
          :start-val="0"
          :end-val="formData.totalWorkTime"
          :duration="1000"
          :decimals="1"
          style="color: #F56C6C;margin-left: 10px;font-size: 25px"/>
<!--          <span style="font-size: 21px;font-weight: bold;margin-left: 30px">本月小组排名:-->
<!--            <count-to-->
<!--              :start-val="0"-->
<!--              :end-val="formData.rank"-->
<!--              :duration="2600"-->
<!--              style="color: #F56C6C;margin-left: 10px;font-size: 25px"/>-->
<!--          </span>-->
        </span>
        <span v-if="formData.selectType === '计划查询'" style="font-size: 21px;font-weight: bold">本月预计获得工时:
<!--          <span style="color: #F56C6C;margin-left: 10px;font-size: 25px">{{planGetWorkTime}}</span>-->
        <count-to
          :start-val="0"
          :end-val="planGetWorkTime"
          :duration="2600"
          :decimals="1"
          style="color: #F56C6C;margin-left: 10px;font-size: 25px"/></span>
      </el-form-item>
      <el-radio-group v-model="formData.selectType" @change="handleSelectTypeChange" style="margin-left: 50px">
        <el-radio-button label="计划查询"></el-radio-button>
        <el-radio-button label="工时查询"></el-radio-button>
      </el-radio-group>
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
                       @click="handleSubmitStatus(scope.row, scope.$index)">提交</el-button>
            <el-button v-if="scope.row.submitStatus === 1"
                       :disabled="(scope.row.reviewStatus === 1 || isAssginer(scope.row.submitID))"
                       size="mini"
                       type="info"
                       @click="handleSubmitStatus(scope.row,scope.$index)">暂存</el-button>
            <el-button :disabled="(scope.row.reviewStatus === 1 || isAssginer(scope.row.submitID))"
                       size="mini"
                       type="danger"
                       @click="handleDelete(scope.row, scope.$index)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <!---------------------------------------------计划表格--------------------------------------------------->
    <div>
      <el-table :data="workPlanTableData" v-if="showFlag.planTableShow"
                style="width: 99%;margin: auto;margin-top: 20px"
                border
                :span-method="planTableSpanMethod"
                :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }">
        <el-table-column label="序号" align="center" type="index" width="60%"></el-table-column>
<!--        <el-table-column label="申报月份" align="center" prop="applyMonth"></el-table-column>-->
        <el-table-column label="项目名称" align="center" prop="projectName"></el-table-column>
        <el-table-column label="项目阶段" align="center" prop="projectStageName"></el-table-column>
        <el-table-column label="计划进展" align="center" prop="applyProcess" width="100%">
          <template slot-scope="scope">
            <span>{{scope.row.applyProcess + '%'}}</span>
          </template>
        </el-table-column>
        <el-table-column label="预计工时" align="center" prop="avaiableWorkTime" width="100%"></el-table-column>
        <el-table-column label="操作" align="center" width="200">
          <template slot-scope="scope">
            <div v-if="!scope.row.processEditable">
              <el-button type="primary"
                         :disabled="!reqFlag.complete"
                         size="mini"
                         @click="handleComplete(scope.row)">生成工时申报</el-button>
              <el-button type="danger" size="mini" @click="handleDeletePlanItem(scope.row, scope.$index)">删除</el-button>
            </div>
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
    import { getProjectType, getProjectList, changeSubmitStatus, deleteProject,
      getAssignWorkTime, workTimeSubmit, workTimeTemporary, getWorkAssign, getGroupWorkTimeList } from '@/config/interface'
    export default {
      data () {
        return {
          projectTypeOptions: [],
          props: {
            multiple: true,
            value: 'projectTypeID',
            label: 'projectName'
          },
          WorkTimeItem: [],
          declareTime: [],
          formData: {
            title: this.$moment().format('YYYY-MM'),
            projectType: [],
            isShowTable: true,
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
            getProjectType: true,
            getProjectList: true,
            changeSubmitStatus: true,
            deleteProject: true,
            complete: true,
            getWorkTimeAssign: true,
            getGroupWorkTimeList: true,
            getAssignWorkTimes: true,
            handelDateChange: true
          },
          pageNum: 1, // 请求第几页
          pageSize: this.$store.state.pageSize, // 每页请求多少条
          currentPage: 1, // 初始时在第几页
          pickerOptions: {
            // disabledDate (time) {
            //   return time.getTime() > Date.now()
            // }
          },
          workDetailTable: [],
          workPlanTableData: [],
          planGetWorkTime: 0
        }
      },
      methods: {
        // 初始化
        init () {
          this.getCookie()
          let promises = []
          let count = 0
          if (this.reqFlag.handelDateChange) {
            this.reqFlag.handelDateChange = false
            this.getProjectList().then(res => {
              promises[count++] = this.getGroupWorkTimeList(this.$store.state.userInfo.groupID)
              promises[count++] = this.getAssignWorkTimes(res)
              Promise.all(promises).then(() => {
                this.reqFlag.handelDateChange = true
              })
            })
          }
        },
        // 获取项目类型
        getProjectType () {
          const url = getProjectType
          if (this.reqFlag.getProjectType) {
            this.reqFlag.getProjectType = false
            let params = {
              projectParentID: this.$store.state.userInfo.groupName
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  let data = res.data
                  this.projectTypeOptions = data
                }
                this.reqFlag.getProjectType = true
              })
          }
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
        getProjectList () {
          this.workPlanTableData = []
          this.workDetailTable = []
          let it = this
          return new Promise(function (resolve, reject) {
            const url = getProjectList
            if (it.reqFlag.getProjectList) {
              it.reqFlag.getProjectList = false
              let params = {
                searchID: it.$store.state.userInfo.id,
                searchMon: it.formData.title,
                pageNum: it.pageNum,
                pageSize: it.pageSize
              }
              it.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    let factWorkTimeList = []
                    let planWorkTimeList = []
                    it.planGetWorkTime = 0
                    for (let item of data.list) {
                      item.assignWorkTime = null
                      if (item.applyType === 'fact') { // 实际进展表格数据
                        factWorkTimeList.push(item)
                      } else if (item.applyType === 'plan') { // 计划进展表格数据
                        it.planGetWorkTime += item.avaiableWorkTime
                        planWorkTimeList.push(item)
                      }
                    }
                    factWorkTimeList.sort(it.compare('aplID'))
                    planWorkTimeList.sort(it.compare('aplID'))
                    it.handleTable(factWorkTimeList)
                    it.handleTable(planWorkTimeList)
                    it.workPlanTableData = JSON.parse(JSON.stringify(planWorkTimeList))
                    it.workDetailTable = JSON.parse(JSON.stringify(factWorkTimeList))
                    it.totalCount = data.totalCount
                    it.currentPage = it.pageNum
                    if (it.formData.selectType === '工时查询') {
                      resolve(factWorkTimeList)
                    } else if (it.formData.selectType === '计划查询') {
                      resolve(planWorkTimeList)
                    }
                  }
                  it.reqFlag.getProjectList = true
                })
            }
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
                this.formData.title = arr2[1] // 保存到保存数据的地方
              }
            }
          }
        },
        // 申报月份变化
        handelDateChange () {
          this.setCookie(this.formData.title, 7)
          let promises = []
          let count = 0
          if (this.reqFlag.handelDateChange) {
            this.reqFlag.handelDateChange = false
            this.getProjectList().then(res => {
              promises[count++] = this.getGroupWorkTimeList(this.$store.state.userInfo.groupID)
              promises[count++] = this.getAssignWorkTimes(res)
              Promise.all(promises).then(() => {
                this.reqFlag.handelDateChange = true
              })
            })
          }
        },
        handleAdd () {
          this.$router.push({ path: '/home/PerformanceAdd' })
        },
        handleAddNew () {
          this.$router.push({ path: '/home/PerformanceAddNew' })
        },
        handleCoopInfo (row) {
          this.showFlag.cop = true
          this.$nextTick(() => {
            this.$refs.cop.init(row)
          })
        },
        handleEdit (row, index) {
          this.$router.push({
            path: '/home/PerformanceEdit',
            query: {
              id: row.id
            }
          })
        },
        handleSubmitStatus (row, index) {
          if (this.reqFlag.changeSubmitStatus) {
            this.reqFlag.changeSubmitStatus = false
            if (row.submitStatus === 1) {
              row.submitStatus = 0
            } else if (row.submitStatus === 0) {
              row.submitStatus = 1
            }
            const url = changeSubmitStatus
            let params = {
              submitStatus: row.submitStatus,
              id: row.id
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  if (row.submitStatus === 1) {
                    row.reviewStatus = 0
                  }
                  this.$common.toast('操作成功', 'success', false)
                } else {
                  this.$common.toast('操作失败', 'warning', false)
                }
                this.reqFlag.changeSubmitStatus = true
              })
          }
        },
        handleDelete (row, index) {
          this.$common.msgBox('confirm', '操作提示', '确定删除？', () => {
            if (this.reqFlag.deleteProject) {
              this.reqFlag.deleteProject = false
              const url = deleteProject
              this.workDetailTable.splice(index, 1)
              this.workDetailTable.sort(this.compare('aplID'))
              this.handleTable(this.workDetailTable)
              let params = {
                id: row.id
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('操作成功', 'success', false)
                  } else {
                    this.$common.toast('操作失败', 'danger', false)
                  }
                  this.reqFlag.deleteProject = true
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
        // 切换标签事件
        handleSelectTypeChange (selectType) {
          this.getProjectList().then(res => {
            this.getAssignWorkTimes(res)
            if (selectType === '工时查询') {
              this.showFlag.factTableShow = true
              this.showFlag.planTableShow = false
            } else if (selectType === '计划查询') {
              this.showFlag.factTableShow = false
              this.showFlag.planTableShow = true
            }
          })
        },
        // 获取工时分配信息
        getWorkTimeAssign (id) {
          const url = getWorkAssign
          let params = {
            projectID: id,
            searchType: 'applyer'
          }
          let it = this
          return new Promise(function (resolve, reject) {
            if (it.reqFlag.getWorkTimeAssign) {
              it.reqFlag.getWorkTimeAssign = false
              it.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data[0]
                    it.reqFlag.getWorkTimeAssign = true
                    resolve(data)
                  }
                })
            }
          })
        },
        // 已完成按钮
        handleComplete (row) {
          this.getWorkTimeAssign(row.id).then(workTimeAssign => {
            const url = workTimeTemporary
            if (this.reqFlag.complete) {
              this.reqFlag.complete = false
              let title = this.formData.title
              let params = {
                submitType: 'insert',
                submitDate: title,
                data: [],
                applyType: 'fact'
              }
              // let defaultCurrentUserWorkTime = {
              //   id: this.$store.state.userInfo.id,
              //   groupName: this.$store.state.userInfo.groupName,
              //   name: this.$store.state.userInfo.name,
              //   applyRole: '组织者',
              //   assignWorkTime: row.avaiableWorkTime,
              //   deleteAble: false
              // }
              row.workTimeAssign = []
              for (let item of workTimeAssign) {
                item.assignWorkTime = item.workTime
                item.deleteAble = false
                item.id = item.userID
                item.applyRole = item.assignRole
                row.workTimeAssign.push(item)
              }
              row.defaultCofficient = row.applyCofficient
              row.defaultKValue = row.applyKValue
              row.baseWorkTime = row.applyBaseWorkTime
              params.data.push(row)
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('生成成功', 'success', false)
                  } else {
                    this.$common.toast('提交失败', 'error', false)
                  }
                  this.reqFlag.complete = true
                })
            }
          })
        },
        // 保存按钮
        handleSave (row) {
          row.processEditable = false
          row.avaiableWorkTime = row
        },
        // 删除按钮
        handleDeletePlanItem (row, index) {
          this.$common.msgBox('confirm', '操作提示', '确定删除？', () => {
            if (this.reqFlag.deleteProject) {
              this.reqFlag.deleteProject = false
              const url = deleteProject
              this.workPlanTableData.splice(index, 1)
              let params = {
                id: row.id
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('操作成功', 'success', false)
                  } else {
                    this.$common.toast('操作失败', 'danger', false)
                  }
                  this.reqFlag.deleteProject = true
                })
            }
          })
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
        // 计划表格合并方法
        planTableSpanMethod ({ row, column, rowIndex, columnIndex }) {
          if (columnIndex === 1) {
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
              applyMonth: this.formData.title
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
                    let preRank = 0
                    for (let item of totalWorkTimeCal) { // 计算排名
                      if (item.totalWorkTime === preWorkTime) {
                        item.rank = preRank
                      } else {
                        item.rank = ++preRank
                      }
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
          this.formData.title = this.$moment(this.formData.title).subtract(1, 'months').format('YYYY-MM')
          this.handelDateChange()
        },
        // 下一月
        handleNextMonth () {
          this.formData.title = this.$moment(this.formData.title).add(1, 'months').format('YYYY-MM')
          this.handelDateChange()
        }
      },
      computed: {
        userPower: function () {
          let userType = this.$store.state.userInfo.role
          if (userType === '普通成员') {
            return 0
          } else if (userType === '组长') {
            return 1
          } else {
            return 2
          }
        },
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

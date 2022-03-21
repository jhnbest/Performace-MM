<template>
  <div>
    <div v-if="$store.state.userInfo.id === 26">
      <el-form class="main-search" :inline="true">
        <el-row type="flex">
          <el-col :xs="12" :sm="12" :lg="9" :xl="6">
            <!--        月选择-->
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
                value-format="yyyy-MM"
                placeholder="选择月份"
                style="width: 150px"
                @change="handleDateChange">
              </el-date-picker>
              <el-button size="mini"
                         type="primary"
                         style="margin-left: 10px"
                         @click="handleNextYear"
                         :disabled="!reqFlag.getCurYearConclusionOverviewData">下月</el-button>
            </el-form-item>
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
                  v-loading="!reqFlag.getAllUsersConclusion"
                  :height="tableHeight"
                  ref="rateTable"
                  highlight-current-row>
          <el-table-column label="序号" align="center" type="index" width="50"></el-table-column>
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
          <el-table-column label="评价状态" align="center" width="100">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.id !== null" :type="scope.row.evaStatus | evaStatusFilter" size="medium">
                <span>{{scope.row.evaStatus | evaStatusTextFilter}}</span>
              </el-tag>
              <el-tag v-else type="info" size="medium">
                <span>{{'未提交'}}</span>
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="管理者评分" align="center">
            <template slot-scope="scope">
              <el-rate v-if="scope.row.evaStatus !== null"  v-model="scope.row.managerRateStar"
                       slot="reference"
                       style="size: 50px"
                       :disabled="true"></el-rate>
              <div v-else>
                <el-tag v-if="scope.row.id !== null" :type="scope.row.evaStatus | evaStatusFilter" size="medium">
                  <span>{{scope.row.evaStatus | evaStatusTextFilter}}</span>
                </el-tag>
                <el-tag v-else type="info" size="medium">
                  <span>{{'未提交'}}</span>
                </el-tag>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="获得工时" align="center" prop="getWorkTime" width="100"></el-table-column>
          <el-table-column label="操作" align="center" width="250">
            <template slot-scope="scope">
              <!--            查看-->
              <el-button slot="reference"
                         type="primary"
                         size="mini"
                         :disabled="scope.row.submitStatus !== 1"
                         @click="handlePreview(scope.row, scope.$index)">点击查看</el-button>
              <!--&lt;!&ndash;            暂存&ndash;&gt;-->
              <!--            <el-button v-if="scope.row.evaStatus === 1"-->
              <!--                       :disabled=" (scope.row.managerRateStar === null) ||-->
              <!--                       (curApplyYear > formData.title) ||-->
              <!--                    ((curApplyMonth > scope.row.submitMonth) && (curApplyYear === Number(formData.title))) ||-->
              <!--                    !reqFlag.submitEvaData"-->
              <!--                       size="mini"-->
              <!--                       type="info"-->
              <!--                       @click="handleTemporary(scope.row, scope.$index)">暂存</el-button>-->
              <!--            &lt;!&ndash;          提交&ndash;&gt;-->
              <!--            <el-button v-if="scope.row.evaStatus === 2"-->
              <!--                       :disabled="scope.row.id === null ||-->
              <!--                       !reqFlag.submitEvaData ||-->
              <!--                       (scope.row.managerRateStar === null) ||-->
              <!--                       (curApplyYear > formData.title) ||-->
              <!--                    ((curApplyMonth > scope.row.submitMonth) && (curApplyYear === Number(formData.title)))"-->
              <!--                       size="mini"-->
              <!--                       type="success"-->
              <!--                       @click="handleSubmit(scope.row, scope.$index)">提交</el-button>-->
            </template>
          </el-table-column>
        </el-table>
        <br>
      </div>
      <!--    月总结对话框-->
      <month-conclusion-table-check v-if="conclusionDialog"
                                    :cur-conclusion="curConclusion"
                                    :next-plan="nextPlan"
                                    :cur-advice="curAdvice"
                                    :is-manager-eva="true"
                                    :conclusion-title="conclusionTitle"
                                    :id="selectId"
                                    :manager-eva="managerEva"
                                    :manager-rate-star="managerRateStar"
                                    :submitter="submitter"
                                    :check-user-id="this.$store.state.userInfo.id"
                                    @close="conclusionDialog = false"
                                    @handleSaveEvaData="handleSubmitEvaData"></month-conclusion-table-check>
    </div>
    <div v-else>
      <h2>暂无权限</h2>
    </div>
  </div>
</template>

<script>
  import {
    urlGetCurApplyAbleMonth } from '@/config/interface'
  import {
    getCurMonthConclusionOverviewData,
    submitEvaData,
    updateWorkTimeListIdOfConclusion
  } from '@/utils/conclusion'
  import {
    getCurApplyAbleMonth,
    getAllUsersInfo,
    removeUserByName,
    workTimeListInsert,
    updateWorkTimeListReviewStatus,
    conclusionManagerEvaStarToWorkTime, addNewProject, getWorkTimeAssignInfo, setProjectFinish, getWorkTimeListInfo
  } from '@/utils/common'
  import monthConclusionTableCheck from './childViews/monthConclusionTableCheck'
  import store from '@/store'
  import moment from 'moment'
  export default {
    data () {
      return {
        formData: {
          title: this.$moment().format('YYYY-MM')
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
          getCurApplyAbleMonth: true,
          getAllUsersConclusion: true,
          submitEvaData: true
        },
        tableHeight: null,
        curApplyYear: 1970,
        curApplyMonth: 1,
        allUsers: null,
        defaultEvaStar: this.$store.state.defaultConclusionEvaStar,
        defaultGetWorkTime: 10,
        eachStarGetWorkTime: 2,
        conclusionDialog: false,
        curConclusion: null,
        nextPlan: null,
        managerEva: null,
        curAdvice: null,
        managerRateStar: this.$store.state.defaultConclusionEvaStar,
        conclusionTitle: null,
        selectId: null,
        submitter: null,
        workTimeListId: null,
        workTimeAssignInsertID: []
      }
    },
    methods: {
      // 初始化
      init () {
        // 获取当前申报月份
        if (this.reqFlag.getCurApplyAbleMonth) {
          this.reqFlag.getCurApplyAbleMonth = false
          getCurApplyAbleMonth().then(getCurApplyAbleMonthRes => { // 获取当前申报月份
            this.curApplyYear = this.$moment(getCurApplyAbleMonthRes[0].setTime).year()
            this.curApplyMonth = this.$moment(getCurApplyAbleMonthRes[0].setTime).month() + 1
            // 获取全处员工信息
            getAllUsersInfo().then(getAllUsersInfoRes => {
              this.allUsers = removeUserByName('王喻强', JSON.parse(JSON.stringify(getAllUsersInfoRes.list)))
              if (this.reqFlag.getAllUsersConclusion) {
                this.reqFlag.getAllUsersConclusion = false
                // if (this.$moment(this.formData.title).isBefore(store.state.newRulesDate)) { // 在新规则实施之前
                  // 获取全处员工月总结信息
                  this.getAllUsersConclusion(this.allUsers, this.curApplyYear, this.curApplyMonth).then(getAllUsersConclusionRes => {
                    // 填充总结表格数据
                    this.fillConclusionTableData(getAllUsersConclusionRes)
                    this.reqFlag.getAllUsersConclusion = true
                  })
                // } else {
                // }
              }
            }).catch(() => {
              this.$common.toast('获取全处员工信息失败', 'error', false)
            })
            this.reqFlag.getCurApplyAbleMonth = true
          }).catch(() => {
            this.$common.toast('获取当前申报月份错误', 'error', false)
            this.reqFlag.getCurApplyAbleMonth = true
          })
        }
      },
      // 获取全处员工月总结信息
      getAllUsersConclusion (allUsers, submitYear, submitMonth) {
        let promise = []
        let count = 0
        let titleMonth = this.$moment(String(submitYear) + '-' + String(submitMonth))
        return new Promise(function (resolve, reject) {
          for (let user of allUsers) {
            // if (this.$moment(titleMonth).isBefore(store.state.newRulesDate)) {
              promise[count++] = getCurMonthConclusionOverviewData(submitMonth, submitYear, user.id)
            // } else {

            // }
          }
          Promise.all(promise).then(result => {
            resolve(result)
          }).catch(err => {
            reject(err)
          })
        })
      },
      // 填充表格数据
      fillConclusionTableData (getAllUsersConclusionRes) {
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
            managerRateStar: this.defaultEvaStar,
            getWorkTime: null,
            curConclusion: null,
            nextPlan: null,
            curAdvice: null,
            evaStatus: null,
            managerEva: null,
            workTimeListId: null,
            submitter: null,
            workTimeAssignInsertID: []
          }
          if (getAllUsersConclusionResItem.data) {
            obj.id = getAllUsersConclusionResItem.data.id
            obj.conclusionType = getAllUsersConclusionResItem.data.conclusionType
            obj.conclusionTitle = getAllUsersConclusionResItem.data.conclusionTitle
            obj.submitStatus = getAllUsersConclusionResItem.data.submitStatus
            obj.managerRateStar =
              getAllUsersConclusionResItem.data.managerRateStar ? getAllUsersConclusionResItem.data.managerRateStar : this.defaultEvaStar
            obj.getWorkTime = getAllUsersConclusionResItem.data.getWorkTime !== null ? getAllUsersConclusionResItem.data.getWorkTime : null
            obj.curConclusion = getAllUsersConclusionResItem.data.curConclusion
            obj.nextPlan = getAllUsersConclusionResItem.data.nextPlan
            obj.curAdvice = getAllUsersConclusionResItem.data.curAdvice
            obj.evaStatus = getAllUsersConclusionResItem.data.evaStatus
            obj.managerEva = getAllUsersConclusionResItem.data.managerEva
            obj.submitter = getAllUsersConclusionResItem.data.submitter
            obj.workTimeListId = getAllUsersConclusionResItem.data.workTimeListId
          }
          this.conclusionTableData.push(obj)
        }
      },
      // 点击查看
      handlePreview (row, index) {
        this.selectId = row.id
        this.curConclusion = row.curConclusion
        this.nextPlan = row.nextPlan
        this.curAdvice = row.curAdvice
        this.conclusionTitle = row.name + row.conclusionTitle
        this.conclusionDialog = true
        this.managerEva = row.managerEva
        this.managerRateStar = row.managerRateStar
        this.submitter = row.submitter
        this.workTimeListId = row.workTimeListId
        // get工时分配的ID
        if (row.workTimeListId !== null) {
          getWorkTimeAssignInfo(row.workTimeListId).then(getWorkTimeAssignInfoRes => {
            this.workTimeAssignInsertID = []
            this.workTimeAssignInsertID.push(getWorkTimeAssignInfoRes[0].id)
            row.workTimeAssignInsertID.push(getWorkTimeAssignInfoRes[0].id)
          })
        }
      },
      // 提交管理者评价
      handleSubmit (row, index) {
        let evaStatus = 1
        if (this.reqFlag.submitEvaData) {
          this.reqFlag.submitEvaData = false
          // ============================管理者评价数据提交至月总结数据库==========================
          submitEvaData(row.id, row.managerRateStar, row.managerEva, evaStatus).then(() => {
            row.evaStatus = 1
            // 新增项目
            let isFilled = 1
            let parentID = 4
            let projectLevel = 1
            let projectName = row.conclusionTitle
            let userId = row.submitter
            let tableData = [{
              avaiableWorkTime: conclusionManagerEvaStarToWorkTime(row.managerRateStar),
              kValue: 1,
              projectManagerID: row.submitter,
              projectTypeID: 74,
              workTime: conclusionManagerEvaStarToWorkTime(row.managerRateStar),
              workType: '个人月总结'
            }]
            addNewProject(isFilled, parentID, projectLevel, projectName, userId, tableData).then(addNewProjectRes => {
              // ================================插入工时列表==============================================================
              let aplID = addNewProjectRes[0].aplID
              let apdID = addNewProjectRes[0].insertID
              let submitType = null
              let submitDate = this.formData.title
              let applyType = 'fact'
              let data = []
              if (row.workTimeListId === null) { // 管理者首次提交评价
                submitType = 'insert'
                let obj = {
                  projectTypeID: 74,
                  baseWorkTime: row.getWorkTime,
                  defaultKValue: 1,
                  dynamicKValue: 1,
                  defaultCofficient: 1,
                  workTimeAssign: [{
                    id: userId,
                    applyRole: '组织者',
                    assignWorkTime: row.getWorkTime
                  }],
                  submitComments: null,
                  avaiableWorkTime: 1,
                  isConference: 0,
                  defaultAssignWorkTime: row.getWorkTime,
                  applyProcess: 100,
                  planProcess: 100,
                  apdID: apdID,
                  aplID: aplID,
                  lastProcess: 0
                }
                data.push(obj)
              } else {
              }
              workTimeListInsert(submitType, submitDate, applyType, userId, data).then((workTimeListInsertRes) => {
                // ========================================总结表中更新工时列表ID================================================
                updateWorkTimeListIdOfConclusion(row.id, workTimeListInsertRes.insertID).then(() => {
                  // =============================================将月总结工时条目置为已审核状态=====================================
                  let reviewer = this.$store.state.userInfo.id
                  let reviewKValue = 1
                  let reviewCofficient = 1
                  let reviewStatus = 1
                  updateWorkTimeListReviewStatus(workTimeListInsertRes.insertID, reviewKValue,
                    reviewCofficient, reviewStatus, reviewer).then(() => {
                    this.$common.toast('提交成功', 'success', false)
                    this.reqFlag.submitEvaData = true
                  }).catch(updateWorkTimeListReviewStatusErr => {
                    this.reqFlag.submitEvaData = true
                    this.$common.toast('提交失败 ' + updateWorkTimeListReviewStatusErr, 'error', true)
                  })
                }).catch(updateWorkTimeListIdOfConclusionErr => {
                  this.reqFlag.submitEvaData = true
                  this.$common.toast('提交失败 ' + updateWorkTimeListIdOfConclusionErr, 'error', true)
                })
              }).catch(workTimeListInsertErr => {
                this.reqFlag.submitEvaData = true
                this.$common.toast('提交失败 ' + workTimeListInsertErr, 'error', true)
              })
            })
          }).catch(submitEvaDataErr => {
            let submitYear = this.$moment(this.formData.title).year()
            let submitMonth = this.$moment(this.formData.title).month() + 1
            this.getAndFillConclusionData(this.allUsers, submitYear, submitMonth)
            this.$common.toast('提交失败' + submitEvaDataErr, 'error', true)
            this.reqFlag.submitEvaData = true
          })
        }
      },
      // 暂存管理者评价
      handleTemporary (row, index) {
        let evaStatus = 2
        if (this.reqFlag.submitEvaData) {
          this.reqFlag.submitEvaData = false
          submitEvaData(row.id, row.managerRateStar, row.managerEva, evaStatus).then(() => {
            row.evaStatus = 2
            this.$common.toast('暂存成功', 'success', false)
            this.reqFlag.submitEvaData = true
          }).catch(submitEvaDataErr => {
            let submitYear = this.$moment(this.formData.title).year()
            let submitMonth = this.$moment(this.formData.title).month() + 1
            this.getAndFillConclusionData(this.allUsers, submitYear, submitMonth)
            this.$common.toast('暂存失败' + submitEvaDataErr, 'error', false)
            this.reqFlag.submitEvaData = true
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
        this.handleDateChange()
      },
      // 下一年
      handleNextYear () {
        this.formData.title = this.$moment(this.formData.title).add(1, 'months').format('YYYY-MM')
        this.setMonthCookie(this.formData.title, 7)
        this.handleDateChange()
      },
      // 获取并填充表格数据
      getAndFillConclusionData (users, submitYear, submitMonth) {
        if (this.reqFlag.getAllUsersConclusion) {
          this.reqFlag.getAllUsersConclusion = false
          this.getAllUsersConclusion(this.allUsers, submitYear, submitMonth).then(getAllUsersConclusionRes => {
            // 填充总结表格数据
            this.fillConclusionTableData(getAllUsersConclusionRes)
            this.reqFlag.getAllUsersConclusion = true
          }).catch(() => {
            this.reqFlag.getAllUsersConclusion = true
            this.$common.toast('获取全处员工信息失败', 'error', false)
          })
        }
      },
      // 申报月份变化
      handleDateChange () {
        let submitYear = this.$moment(this.formData.title).year()
        let submitMonth = this.$moment(this.formData.title).month() + 1
        this.getAndFillConclusionData(this.allUsers, submitYear, submitMonth)
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
      // 子对话框保存按钮
      handleSubmitEvaData (childData) {
        let evaStatus = 1
        // ============================管理者评价数据提交至月总结数据库==========================
        submitEvaData(childData.id, childData.managerRateStar, childData.managerEva, evaStatus).then(() => {
          // ==================================新增项目==================================================
          if (this.workTimeListId === null) { // 管理者首次提交评价
            let isFilled = 1
            let parentID = 4
            let projectLevel = 1
            let projectName = this.conclusionTitle
            let userId = this.submitter
            let tableData = [{
              avaiableWorkTime: conclusionManagerEvaStarToWorkTime(childData.managerRateStar),
              kValue: 1,
              projectManagerID: this.submitter,
              projectTypeID: 74,
              workTime: conclusionManagerEvaStarToWorkTime(childData.managerRateStar),
              workType: '个人月总结'
            }]
            addNewProject(isFilled, parentID, projectLevel, projectName, userId, tableData).then(addNewProjectRes => {
              // =========================================插入工时列表===========================================================
              let aplID = addNewProjectRes[0].aplID
              let apdID = addNewProjectRes[0].insertID
              let submitType = 'insert'
              let submitDate = this.formData.title
              let applyType = 'fact'
              let data = []
              let projectID = null
              let obj = {
                projectTypeID: 74,
                baseWorkTime: conclusionManagerEvaStarToWorkTime(childData.managerRateStar),
                defaultKValue: 1,
                dynamicKValue: 1,
                defaultCofficient: 1,
                workTimeAssign: [{
                  id: userId,
                  applyRole: '组织者',
                  assignWorkTime: conclusionManagerEvaStarToWorkTime(childData.managerRateStar)
                }],
                submitComments: null,
                avaiableWorkTime: 1,
                isConference: 0,
                defaultAssignWorkTime: conclusionManagerEvaStarToWorkTime(childData.managerRateStar),
                applyProcess: 100,
                planProcess: 100,
                apdID: apdID,
                aplID: aplID,
                lastProcess: 0
              }
              data.push(obj)
              workTimeListInsert(projectID, submitType, submitDate, applyType, userId, data).then((workTimeListInsertRes) => {
                // ========================================总结表中更新工时列表ID================================================
                updateWorkTimeListIdOfConclusion(childData.id, workTimeListInsertRes.insertID).then(() => {
                  // =============================================将月总结工时条目置为已审核状态=====================================
                  let reviewer = this.$store.state.userInfo.id
                  let reviewKValue = 1
                  let reviewCofficient = 1
                  let reviewStatus = 1
                  updateWorkTimeListReviewStatus(workTimeListInsertRes.insertID, reviewKValue,
                    reviewCofficient, reviewStatus, reviewer).then(() => {
                    // ================================将项目重置为已完成状态============================
                    setProjectFinish(aplID).then(() => {
                      let submitYear = this.$moment(this.formData.title).year()
                      let submitMonth = this.$moment(this.formData.title).month() + 1
                      this.getAndFillConclusionData(this.allUsers, submitYear, submitMonth)
                      this.$common.toast('提交成功', 'success', false)
                      this.reqFlag.submitEvaData = true
                    }).catch(setProjectFinishErr => {
                      this.reqFlag.submitEvaData = true
                      this.$common.toast('提交失败 ' + setProjectFinishErr, 'error', true)
                    })
                  }).catch(updateWorkTimeListReviewStatusErr => {
                    this.reqFlag.submitEvaData = true
                    this.$common.toast('提交失败 ' + updateWorkTimeListReviewStatusErr, 'error', true)
                  })
                }).catch(updateWorkTimeListIdOfConclusionErr => {
                  this.reqFlag.submitEvaData = true
                  this.$common.toast('提交失败 ' + updateWorkTimeListIdOfConclusionErr, 'error', true)
                })
              }).catch(workTimeListInsertErr => {
                this.reqFlag.submitEvaData = true
                this.$common.toast('提交失败 ' + workTimeListInsertErr, 'error', true)
              })
            })
          } else {
            // ========================================管理者更新评价=================================
            let submitType = 'update'
            let projectID = this.workTimeListId
            let userId = this.submitter
            let data = []
            let submitDate = this.formData.title
            let applyType = 'fact'
            let obj = {
              projectTypeID: 74,
              baseWorkTime: conclusionManagerEvaStarToWorkTime(childData.managerRateStar),
              defaultKValue: 1,
              dynamicKValue: 1,
              defaultCofficient: 1,
              workTimeAssign: [{
                id: userId,
                applyRole: '组织者',
                assignWorkTime: conclusionManagerEvaStarToWorkTime(childData.managerRateStar)
              }],
              submitComments: null,
              workTimeAssignInsertID: this.workTimeAssignInsertID,
              avaiableWorkTime: 1,
              isConference: 0,
              defaultAssignWorkTime: conclusionManagerEvaStarToWorkTime(childData.managerRateStar),
              applyProcess: 100,
              planProcess: 100,
              lastProcess: 0,
              applyBaseWorkTime: conclusionManagerEvaStarToWorkTime(childData.managerRateStar)
            }
            data.push(obj)
            workTimeListInsert(projectID, submitType, submitDate, applyType, userId, data).then((workTimeListInsertRes) => {
              let reviewer = this.$store.state.userInfo.id
              let reviewKValue = 1
              let reviewCofficient = 1
              let reviewStatus = 1
              updateWorkTimeListReviewStatus(this.workTimeListId, reviewKValue,
                reviewCofficient, reviewStatus, reviewer).then(() => {
                let submitYear = this.$moment(this.formData.title).year()
                let submitMonth = this.$moment(this.formData.title).month() + 1
                this.getAndFillConclusionData(this.allUsers, submitYear, submitMonth)
                this.$common.toast('提交成功', 'success', false)
                this.reqFlag.submitEvaData = true
              }).catch(updateWorkTimeListReviewStatusErr => {
                this.reqFlag.submitEvaData = true
                this.$common.toast('提交失败 ' + updateWorkTimeListReviewStatusErr, 'error', true)
              })
            })
          }
        }).catch(submitEvaDataErr => {
          let submitYear = this.$moment(this.formData.title).year()
          let submitMonth = this.$moment(this.formData.title).month() + 1
          this.getAndFillConclusionData(this.allUsers, submitYear, submitMonth)
          this.$common.toast('保存失败' + submitEvaDataErr, 'error', false)
        })
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
      evaStatusFilter (status) {
        if (status === 1) {
          return 'success'
        } else {
          return 'danger'
        }
      },
      evaStatusTextFilter (status) {
        if (status === 1) {
          return '已评价'
        } else {
          return '未评价'
        }
      }
    },
    components: {
      monthConclusionTableCheck
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

<style lang="scss" scoped>
  .dialogDiv {
    height: 850px;
    overflow: auto;
  }
</style>

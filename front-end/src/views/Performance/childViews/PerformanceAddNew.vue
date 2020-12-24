<template>
    <div>
      <h3 v-if="formData.applyType === 'fact'" class="v-line-icon">新增工时申报</h3>
      <h3 v-if="formData.applyType === 'plan'" class="v-line-icon">新增计划申报</h3>
      <el-form :label-position="labelPosition" label-width="110px" ref="formData" :model="formData" :rules="formRules" :inline="true">
        <el-form-item label="申报月份" prop="title">
          <el-date-picker
            v-model="formData.title"
            type="month"
            format="yyyy 第 MM 月"
            value-format="yyyy-MM"
            placeholder="选择月"
            :picker-options="pickerOptions"
            style="width: 150px">
          </el-date-picker>
        </el-form-item>
        <el-form-item label="小组">
          <el-input
            :disabled="true"
            v-model="this.$store.state.userInfo.groupName"
            style="width: 60%">
          </el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" size="medium" @click="onSubmitWorkTime('formData')">提交</el-button>
          <el-button v-if="formData.applyType === 'fact'" type="info" size="medium" @click="onTemporaryWorkTime('formData')">暂存</el-button>
          <el-button type="danger" size="medium" @click="onCancel('formData')">取 消</el-button>
        </el-form-item>
        <br>
<!--        <el-form-item label="申报类型" prop="applyType">-->
<!--          <el-select v-model="formData.applyType" placeholder="请选择" @change="handleApplyTypeChange">-->
<!--            <el-option v-for="item in applyTypes"-->
<!--                       :key="item.value"-->
<!--                       :label="item.text"-->
<!--                       :value="item.value">-->
<!--            </el-option>-->
<!--          </el-select>-->
<!--        </el-form-item>-->
<!--        <br>-->
        <el-form-item label="项目类型" prop="projectType">
          <el-cascader
            v-if="showFlag.projectType"
            v-model="formData.projectType"
            :options="projectTypeOptions"
            :props="props"
            collapse-tags
            filterable
            @change="handleProjectTypeChange"
            clearable
            style="width: 350%"></el-cascader>
        </el-form-item>
        <br>
        <el-form-item label="项目名称" prop="projectName">
          <el-input v-model="formData.projectName" placeholder="请输入"></el-input>
        </el-form-item>
        <br>
        <el-form-item label="项目级别" prop="projectLevel">
          <el-select v-model="formData.projectLevel" placeholder="请选择">
            <el-option v-for="item in projectLevels"
                       :key="item.value"
                       :label="item.text"
                       :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <!-- 分割线 start -->
        <div class="hr-10"></div>
        <!-- 分割线 end -->
        <br>
        <!--申报工时项目明细-->
        <el-table
          v-if="showFlag.freshTable"
          :data="formData.workTypeTimeDetail"
          stripe
          style="width: 97%;margin: auto">
          <el-table-column type="index" align="center" label="序号"></el-table-column>
<!--          <el-table-column align="center" label="项目名称" width="150%">-->
<!--            <template slot-scope="scope">-->
<!--              <el-form-item-->
<!--                :prop="'workTypeTimeDetail.' + scope.$index + '.projectName'"-->
<!--                :rules="formRules.projectName"-->
<!--                style="margin: auto">-->
<!--                <el-input type="textarea" v-model="scope.row.projectName" autosize></el-input>-->
<!--              </el-form-item>-->
<!--            </template>-->
<!--          </el-table-column>-->
          <el-table-column label="项目阶段" align="center">
            <template slot-scope="scope">
              <div>
                <el-input v-if="projectStageEditable"
                          v-model="scope.row.workType"
                          size="mini"></el-input>
                <span v-else>{{scope.row.workType}}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="基本工时" prop="baseWorkTime" align="center" width="80%">
            <template slot-scope="scope">
              <el-input v-if="projectStageEditable"
                        v-model.number="scope.row.baseWorkTime"
                        size="mini"
                        @change="handleKValueCoffChange(scope.row, scope.$index)"></el-input>
              <span v-else>{{scope.row.baseWorkTime}}</span>
            </template>
          </el-table-column>
          <el-table-column label="K值" prop="defaultKValue" align="center" width="150%">
            <template slot-scope="scope">
              <el-form-item
                :prop="'workTypeTimeDetail.' + scope.$index + '.defaultKValue'"
                :rules="formRules.KValue"
                style="margin: auto">
                <el-input-number size="mini"
                                 v-model="scope.row.defaultKValue"
                                 :step="0.1"
                                 :disabled="!scope.row.dynamicKValue"
                                 :min="1.0"
                                 :precision="1"
                                 @change="handleKValueCoffChange(scope.row, scope.$index)"
                                 style="width: 70%">
                </el-input-number>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="完成次数" align="center" width="150%">
            <template slot-scope="scope">
              <el-form-item :prop="'workTypeTimeDetail.' + scope.$index + '.defaultCofficient'"
                            :rules="formRules.Cofficient"
                            style="margin: auto">
                <el-input-number size="mini"
                                 v-model="scope.row.defaultCofficient"
                                 :min="1.0"
                                 @change="handleKValueCoffChange(scope.row, scope.$index)"
                                 style="width: 70%">
                </el-input-number>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="本月进展" align="center" width="100%" v-if="formData.applyType === 'fact'">
            <template slot-scope="scope">
              <el-form-item
                :prop="'workTypeTimeDetail.' + scope.$index + '.applyProcess'"
                :rules="formRules.applyProcess"
                style="margin: auto">
                <div>
                  <el-input v-model.number="scope.row.applyProcess"
                            type="number"
                            size="mini"
                            style="width: 70%"
                            :max="100"
                            @change="handleKValueCoffChange(scope.row, scope.$index)"></el-input>
                  <span> %</span>
                </div>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="计划进展" align="center" width="100%" v-if="formData.applyType === 'plan'">
            <template slot-scope="scope">
              <el-form-item
                :prop="'workTypeTimeDetail.' + scope.$index + '.applyProcess'"
                :rules="formRules.applyProcess"
                style="margin: auto">
                <div>
                  <el-input v-model.number="scope.row.applyProcess"
                            type="number"
                            size="mini"
                            style="width: 70%"
                            :max="100"
                            @change="handleKValueCoffChange(scope.row, scope.$index)"></el-input>
                  <span> %</span>
                </div>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="预计工时" align="center" width="100%" v-if="formData.applyType === 'plan'"
                           prop="avaiableWorkTime"></el-table-column>
          <el-table-column label="工时分配" align="center" width="100%" v-if="formData.applyType === 'fact'">
            <template slot-scope="scope">
              <span class="link-type" @click="handleWorkTimeAssign(scope.row, scope.$index)">点击分配</span>
            </template>
          </el-table-column>
          <el-table-column label="备注" prop="remarks" align="center" width="200%">
            <template slot-scope="scope">
              <el-input size="mini"
                        type="textarea"
                        autosize
                        v-model="scope.row.submitComments">
              </el-input>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="100%">
            <template slot-scope="scope">
              <div>
                <el-button size="mini" type="danger" @click="handleDelete(scope.row, scope.$index)">删除</el-button>
              </div>
            </template>
          </el-table-column>
        </el-table>
        <br>
        <div style="text-align: center" v-if="projectStageEditable">
          <el-button type="primary" size="mini" plain @click="addNewLine">新增一行</el-button>
        </div>
        <br>
        <br>
        <br>
      </el-form>
      <Assign v-if="showFlag.workTimeAssign" ref="workTimeAssign" @assignDetail="handleAssign"/>
    </div>
</template>

<script>
  import { workTypeList, workTimeSubmit, getWorkTime, submitAssignWorkDetail, submitMonthPlanProcess,
    getUsersName, getProjectType, getWorkTimeNew, workTimeTemporary, submitPersonalProject } from '@/config/interface'
  import Assign from '@/components/Cop/workTimeAssign'
    export default {
      data () {
        return {
          userListOptions: [{
            name: '组织',
            options: [{
              value: 'total',
              name: '全处室',
              id: '0',
              disabled: false
            }, {
              value: 'techGroup',
              name: '技术标准组',
              id: '1',
              disabled: false
            }, {
              value: 'engiGroup',
              name: '工程组',
              id: '2',
              disabled: false
            }, {
              value: 'comGroup',
              name: '通信组',
              id: '3',
              disabled: false
            }]
          }, {
            name: '个人',
            options: []
          }],
          props: {
            multiple: true,
            value: 'projectTypeID',
            label: 'projectName'
          },
          projectTypeOptions: [],
          labelPosition: 'right',
          optionsWorkType: [],
          partTableData: [{
            workTime: undefined
          }],
          formData: {
            title: this.$moment().format('YYYY-MM'),
            workTypeList: [],
            projectType: [[0]],
            participant: [],
            usersList: [],
            partWorkTime: 0,
            partTableData: [],
            workTypeTimeDetail: [],
            projectLevel: 1,
            projectName: null,
            applyType: this.$route.query.type
          },
          formRules: {
            title: [
              { required: true, message: '请选择填报月份', trigger: 'blur' }
            ],
            workTypeValue: [
              { required: true, message: '请选择申报类型', trigger: 'change' }
            ],
            subWorkType1Value: [
              { required: true, message: '请选择申报子类型1', trigger: 'change' }
            ],
            subWorkType2Value: [
              { required: true, message: '请选择申报子类型2', trigger: 'change' }
            ],
            subWorkType3Value: [
              { required: true, message: '请选择申报子类型3', trigger: 'change' }
            ],
            participant: [
              { required: true, message: '请选择参与人员', trigger: 'change' }
            ],
            partWorkTime: [
              { required: true, message: '请输入工时数', trigger: 'blur' }
            ],
            workTime: [
              { required: true, message: '请输入工时数', trigger: 'blur' }
            ],
            KValue: [
              { required: true, message: '请输入K值', trigger: 'blur' }
            ],
            Cofficient: [
              { required: true, message: '请输入系数', trigger: 'blur' }
            ],
            projectName: [
              { required: true, message: '请输入项目名称', trigger: 'blur' }
            ],
            projectType: [
              { required: true, message: '请选择项目类型', trigger: 'change' }
            ],
            applyProcess: [
              { required: true, message: '请填写进展', trigger: 'change' },
              { type: 'number', max: 100 }
            ],
            planProcess: [
              { required: true, message: '请填写进展', trigger: 'change' },
              { type: 'number', max: 100 }
            ],
            projectLevel: [
              { required: true, message: '请选择项目级别', trigger: 'change' }
            ],
            applyType: [
              { required: true, message: '请选择申报类型', trigger: 'change' }
            ]
          },
          reqFlag: {
            add: true,
            workTypeList: true,
            usersName: true,
            getProjectType: true,
            getWorkTimeNew: true
          },
          showFlag: {
            workTimeAssign: false,
            projectType: true,
            freshTable: true
          },
          pickerOptions: {
            // disabledDate (time) {
            //   return time.getTime() > Date.now()
            // }
          },
          workTime: 0,
          projectLevels: [{
            value: 1,
            text: '普通任务'
          }, {
            value: 2,
            text: '处室重点任务'
          }, {
            value: 3,
            text: '部门重点任务'
          }, {
            value: 4,
            text: '公司重点任务'
          }],
          applyTypes: [{
            value: 'plan',
            text: '计划'
          }, {
            value: 'fact',
            text: '实际'
          }]
        }
      },
      methods: {
        // 初始化
        init () {
          this.getProjectType()
        },
        // 提交至工时明细列表
        onSubmitWorkTimeList (formData) {
          const url = workTimeSubmit
          if (this.reqFlag.add) {
            this.reqFlag.add = false
            let title = this.formData.title
            let tableDataCopy = []
            for (let item of this.formData.workTypeTimeDetail) {
              if (item.avaiableWorkTime !== 0) {
                item.lastProcess = 0
                tableDataCopy.push(item)
              }
            }
            if (tableDataCopy.length !== 0) {
              let params = {
                submitType: 'insert',
                submitDate: title,
                data: tableDataCopy,
                applyType: this.formData.applyType
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('添加成功', 'success', false)
                    this.onCancel(formData)
                  } else {
                    this.$common.toast('添加失败', 'error', false)
                    this.onCancel(formData)
                  }
                  this.reqFlag.add = true
                })
            } else {
              this.$common.toast('添加成功', 'success', false)
              this.onCancel(formData)
            }
          }
        },
        // 提交项目进展
        onSubmitProjectProcess (param) {
          const url = submitPersonalProject
          let year = this.$moment(this.formData.title).year()
          let month = this.$moment(this.formData.title).month() + 1
          console.log(year)
          console.log(month)
          let params = {
            id: null,
            type: 'fact',
            year: year,
            month: month,
            monthString: this.$common.MonthToString(String(month)),
            tableData: this.formData.workTypeTimeDetail,
            aplID: param.aplID
          }
          let it = this
          return new Promise(function (resolve, reject) {
            it.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  console.log(res.data)
                  resolve(res.data)
                }
              })
          })
        },
        // 提交至项目明细列表
        onSubmitProjectList () {
          const url = submitAssignWorkDetail
          let params = {
            parentID: this.formData.projectType[0][0],
            projectLevel: this.formData.projectLevel,
            projectName: this.formData.projectName,
            tableData: []
          }
          for (let item of this.formData.workTypeTimeDetail) {
            let obj = {
              avaiableWorkTime: item.avaiableWorkTime,
              defaultAssignWorkTime: item.defaultAssignWorkTime,
              dynamicKValue: item.dynamicKValue,
              isConference: item.isConference,
              kValue: item.defaultKValue,
              projectManagerID: this.$store.state.userInfo.id,
              projectTypeID: item.projectTypeID,
              workTime: item.baseWorkTime,
              workType: item.workType
            }
            params.tableData.push(obj)
          }
          let it = this
          return new Promise(function (resolve, reject) {
            it.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  console.log(res.data)
                  for (let i = 0; i < res.data.length; i++) { // 插入项目明细ID
                    it.formData.workTypeTimeDetail[i].apdID = res.data[i].insertID
                    it.formData.workTypeTimeDetail[i].aplID = res.data[i].aplID
                  }
                  resolve(res.data)
                }
              })
          })
        },
        // 提交计划至计划进展表
        onSubmitMonthPlanProcess () {
          const url = submitMonthPlanProcess
          let applyYear = this.$moment(this.formData.title).year()
          let applyMonth = this.$moment(this.formData.title).month()
          let applyMonthString = this.$common.MonthToString(String(applyMonth + 1))
          let params = {
            paramsData: []
          }
          for (let item of this.formData.workTypeTimeDetail) {
            if (item.applyProcess !== 0) {
              let obj = {
                id: null,
                kValue: item.defaultKValue,
                coefficient: item.defaultCofficient,
                applyProcess: item.applyProcess,
                type: 'plan',
                year: applyYear,
                applyMonthString: applyMonthString,
                aPDID: item.apdID,
                January: null,
                February: null,
                March: null,
                April: null,
                May: null,
                June: null,
                July: null,
                August: null,
                September: null,
                October: null,
                November: null,
                December: null
              }
              obj[applyMonthString] = item.applyProcess
              params.paramsData.push(obj)
            }
          }
          console.log(params)
          let it = this
          return new Promise(function (resolve, reject) {
            if (params.paramsData.length !== 0) {
              it.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    console.log(res.data)
                    resolve(res.data)
                  }
                })
            } else {
              resolve(0)
            }
          })
        },
        // 提交工时申报
        onSubmitWorkTime (formData) {
          this.$refs[formData].validate(valid => {
            if (valid) {
              let projectParentArray = []
              for (let item of this.formData.projectType) {
                if (projectParentArray.indexOf(item[0]) === -1) {
                  projectParentArray.push(item[0])
                }
              }
              if (projectParentArray.length > 1) {
                this.$common.toast('一级活动限选一种', 'error', 'false')
              } else {
                this.onSubmitProjectList().then(() => { // 提交至项目明细表
                  if (this.formData.applyType === 'plan') { // 如果是计划项目，则更新计划进展表
                    this.onSubmitMonthPlanProcess().then(() => {
                      this.onSubmitWorkTimeList(formData) // 提交至工时明细表
                    })
                  } else {
                    this.onSubmitWorkTimeList(formData) // 提交至工时明细表
                  }
                })
              }
            }
          })
        },
        // 暂存至工时明细列表
        onTemporaryWorkTimeList (formData) {
          const url = workTimeTemporary
          if (this.reqFlag.add) {
            this.reqFlag.add = false
            let title = this.formData.title
            let tableDataCopy = []
            for (let item of this.formData.workTypeTimeDetail) {
              if (item.avaiableWorkTime !== 0) {
                tableDataCopy.push(item)
              }
            }
            if (tableDataCopy.length !== 0) {
              let params = {
                submitType: 'insert',
                submitDate: title,
                data: this.formData.workTypeTimeDetail,
                applyType: this.formData.applyType
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('暂存成功', 'success', false)
                    this.onCancel(formData)
                  } else {
                    console.log(res.code)
                    this.$common.toast('添加失败', 'error', false)
                    this.onCancel(formData)
                  }
                  this.reqFlag.add = true
                })
            } else {
              this.$common.toast('暂存成功', 'success', false)
              this.onCancel(formData)
            }
          }
        },
        // 暂存工时申报
        onTemporaryWorkTime (formData) {
          this.$refs[formData].validate(valid => {
            if (valid) {
              let projectParentArray = []
              for (let item of this.formData.projectType) {
                if (projectParentArray.indexOf(item[0]) === -1) {
                  projectParentArray.push(item[0])
                }
              }
              if (projectParentArray.length > 1) {
                this.$common.toast('一级活动限选一种', 'error', 'false')
              } else {
                this.onSubmitProjectList().then(() => { // 提交至项目明细表
                  this.onTemporaryWorkTimeList(formData) // 暂存至工时明细表
                })
              }
            }
          })
        },
        // 取消
        onCancel (formName) {
          this.$router.push({ path: '/home/workStation' })
          this.$refs[formName].resetFields()
        },
        // 获取申报类型
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
        // 获取用户姓名
        getUsersName (isOpen) {
          if (isOpen) {
            console.log('===Performance.vue getUsersName')
            console.log(this.userListOptions)
            const url = getUsersName
            if (this.reqFlag.usersName) {
              this.reqFlag.usersName = false
              let params = {}
              let objList = []
              let options = []
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    let list = data.list
                    list.map((item) => {
                      let disabled = false
                      if (item.account !== this.$store.state.userInfo.account) {
                        let obj = {
                          id: item.account,
                          dept: item.dept,
                          name: item.name,
                          groupName: item.groupName,
                          disabled: disabled
                        }
                        objList.push(obj)
                      }
                    })
                    this.userListOptions[1].options = objList
                  }
                  this.reqFlag.usersName = true
                  this.formData.usersList = this.userListOptions
                })
            }
          }
        },
        // 获取项目明细
        handleProjectTypeChange (selectItem) {
          console.log('PerformanceAddNew.vue handleProjectTypeChange')
          console.log(selectItem)
          console.log(selectItem.length)
          let selectLen = selectItem.length
          let selectItems = []
          let tableItems = []
          let params = {}
          let url = getWorkTimeNew
          for (let i = 0; i < selectLen; i++) {
            selectItems.push(selectItem[i][selectItem[i].length - 1])
          }
          for (let item of this.formData.workTypeTimeDetail) {
            tableItems.push(item.projectTypeID)
          }
          console.log(selectItems)
          console.log(tableItems)
          let difference = selectItems.filter(x => tableItems.indexOf(x) === -1)
            .concat(tableItems.filter(x => selectItems.indexOf(x) === -1))
          console.log(difference)
          let tableLen = tableItems.length
          params.checkID = difference
          if (selectLen !== 0) {
            params.parentID = selectItem[0][0]
          }
          if (selectLen > tableLen) { // 选中的数目大于列表中的数目
            if (this.reqFlag.getWorkTimeNew) {
              this.reqFlag.getWorkTimeNew = false
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    data.pop() // 最后一个父类型删掉
                    console.log(data)
                    for (let item of data) {
                      let obj = {
                        projectTypeID: item.projectTypeID,
                        workType: item.projectName,
                        baseWorkTime: item.workTime,
                        defaultKValue: 1.0,
                        dynamicKValue: item.dynamicKValue,
                        defaultCofficient: 1.0,
                        workTimeAssign: [],
                        submitComments: '',
                        multipleAssign: false,
                        multipleSelect: [],
                        avaiableWorkTime: 0,
                        isConference: item.isConference,
                        defaultAssignWorkTime: item.defaultAssignWorkTime,
                        applyProcess: 100,
                        planProcess: 100,
                        planWorkTime: 0
                      }
                      obj.avaiableWorkTime = obj.baseWorkTime * obj.defaultKValue * obj.defaultCofficient *
                        obj.applyProcess * 0.01
                      obj.avaiableWorkTime = Number(obj.avaiableWorkTime.toFixed(1))
                      obj.planWorkTime = obj.avaiableWorkTime
                      let defaultCurrentUserWorkTime = {
                        id: this.$store.state.userInfo.id,
                        groupName: this.$store.state.userInfo.groupName,
                        name: this.$store.state.userInfo.name,
                        applyRole: '组织者',
                        assignWorkTime: obj.avaiableWorkTime,
                        deleteAble: false
                      }
                      obj.workTimeAssign.push(defaultCurrentUserWorkTime)
                      this.formData.workTypeTimeDetail.push(obj)
                      console.log(this.formData.workTypeTimeDetail)
                    }
                    this.reqFlag.getWorkTimeNew = true
                  }
                })
            }
          } else { // 选中的数目小于列表中的数目
            let deleteIndex = null
            console.log(difference)
            for (let diff of difference) {
              console.log(this.formData.workTypeTimeDetail)
              for (let i = 0; i < this.formData.workTypeTimeDetail.length; i++) {
                if (this.formData.workTypeTimeDetail[i].projectTypeID === diff) {
                  deleteIndex = i
                  break
                }
              }
              this.formData.workTypeTimeDetail.splice(deleteIndex, 1)
            }
          }
        },
        // 删除工时明细记录
        handleDeleteWorkDetail (row, index) {
          console.log('===PerformanceAddNew.vue handleDeleteWorkDetail')
          console.log(row)
          let deleteIndex = null
          this.formData.workTypeTimeDetail.splice(index, 1)
          for (let i = 0; i < this.formData.projectType.length; i++) {
            let arrayLen = this.formData.projectType[i].length
            console.log(this.formData.projectType[i][arrayLen - 1])
            if (this.formData.projectType[i][arrayLen - 1] === row.projectTypeID) {
              deleteIndex = i
              break
            }
          }
          console.log(deleteIndex)
          this.$nextTick(() => {
            this.formData.projectType.splice(deleteIndex, 1)
          })
        },
        // 参与人员变化处理
        handlePartChange () {
          let selectUsers = []
          let tableUsers = []
          let selectUsersLen = 0
          let tmp = []
          /* 取出现有表格中的数据 */
          for (let item of this.formData.partTableData) {
            if (item.account !== this.$store.state.userInfo.account) {
              tableUsers.push(item.account)
            }
          }
          /* 是否选了全处室 */
          if (this.formData.participant.indexOf('0') !== -1) {
            for (let user of this.formData.usersList[1].options) {
              selectUsers.push(user.id)
            }
          } else if (this.formData.participant.indexOf('1') !== -1) { // 是否选了技术标准组
            for (let user of this.formData.usersList[1].options) {
              if (user.groupName === '技术标准组') {
                selectUsers.push(user.id)
              }
            }
            if (this.formData.participant.indexOf('2') !== -1) { // 是否同时选了工程组
              for (let user of this.formData.usersList[1].options) {
                if (user.groupName === '工程组') {
                  selectUsers.push(user.id)
                }
              }
            }
            if (this.formData.participant.indexOf('3') !== -1) { // 是否同时选了通信组
              for (let user of this.formData.usersList[1].options) {
                if (user.groupName === '通信组') {
                  selectUsers.push(user.id)
                }
              }
            }
            if (this.formData.participant.length > 1) {
              for (let item of this.formData.participant) {
                console.log('===Performance.vue handlePartChange')
                console.log(item)
                console.log(tableUsers)
                if (selectUsers.indexOf(item) === -1 && item !== '1' && item !== '2' && item !== '3' && item !== '0') {
                  console.log('push')
                  selectUsers.push(item)
                }
              }
            }
            console.log(selectUsers)
          } else if (this.formData.participant.indexOf('2') !== -1) { // 是否选了工程组
            for (let user of this.formData.usersList[1].options) {
              if (user.groupName === '工程组') {
                selectUsers.push(user.id)
              }
            }
            if (this.formData.participant.indexOf('1') !== -1) { // 是否同时选了技术标准组
              for (let user of this.formData.usersList[1].options) {
                if (user.groupName === '技术标准组') {
                  selectUsers.push(user.id)
                }
              }
            }
            if (this.formData.participant.indexOf('3') !== -1) { // 是否同时选了通信组
              for (let user of this.formData.usersList[1].options) {
                if (user.groupName === '通信组') {
                  selectUsers.push(user.id)
                }
              }
            }
            if (this.formData.participant.length > 1) {
              for (let item of this.formData.participant) {
                console.log('===Performance.vue handlePartChange')
                console.log(item)
                console.log(tableUsers)
                if (selectUsers.indexOf(item) === -1 && item !== '2') {
                  console.log('push')
                  selectUsers.push(item)
                }
              }
            }
            console.log(selectUsers)
          } else if (this.formData.participant.indexOf('3') !== -1) { // 是否选了通信组
            for (let user of this.formData.usersList[1].options) {
              if (user.groupName === '通信组') {
                selectUsers.push(user.id)
              }
            }
            if (this.formData.participant.indexOf('1') !== -1) { // 是否同时选了技术标准组
              for (let user of this.formData.usersList[1].options) {
                if (user.groupName === '技术标准组') {
                  selectUsers.push(user.id)
                }
              }
            }
            if (this.formData.participant.indexOf('2') !== -1) { // 是否同时选了工程组
              for (let user of this.formData.usersList[1].options) {
                if (user.groupName === '工程组') {
                  selectUsers.push(user.id)
                }
              }
            }
            if (this.formData.participant.length > 1) {
              for (let item of this.formData.participant) {
                console.log('===Performance.vue handlePartChange')
                console.log(item)
                console.log(tableUsers)
                if (selectUsers.indexOf(item) === -1 && item !== '3') {
                  console.log('push')
                  selectUsers.push(item)
                }
              }
            }
            console.log(selectUsers)
          } else {
            selectUsers = this.formData.participant
          }
          selectUsersLen = selectUsers.length
          let tableUsersLen = tableUsers.length
          let difference = selectUsers.filter(x => tableUsers.indexOf(x) === -1)
            .concat(tableUsers.filter(x => selectUsers.indexOf(x) === -1))
          console.log(difference)
          console.log(selectUsersLen)
          console.log(tableUsersLen)
          if (selectUsersLen > tableUsersLen) {
            for (let index of difference) {
              tmp = this.formData.usersList[1].options.find((item) => {
                if (item.id === index) {
                  let obj = {
                    account: item.id,
                    dept: item.dept,
                    groupName: item.groupName,
                    name: item.name,
                    workTime: this.formData.partWorkTime,
                    deleteAble: false
                  }
                  this.formData.partTableData.push(obj)
                  return this.formData.partTableData
                }
              })
            }
          } else {
            for (let diff of difference) {
              let index = tableUsers.indexOf(diff)
              let newArr = this.formData.partTableData.splice(index + 1, 1)
              tableUsers.splice(index, 1)
              console.log(newArr)
            }
          }
        },
        // 工时分配点击
        handleWorkTimeAssign (row, index) {
          this.showFlag.workTimeAssign = true
          let rowCop = JSON.parse(JSON.stringify(row))
          let params = {
            rowCop: rowCop,
            index: index
          }
          this.$nextTick(() => {
            this.$refs.workTimeAssign.init(params)
          })
        },
        // 工时分配子组件回调
        handleAssign (params) {
          console.log('===PerformanceAddNew.vue handleAssign')
          console.log(params)
          this.formData.workTypeTimeDetail[params.index].workTimeAssign = params.workTimeAssignDetail
          this.formData.workTypeTimeDetail[params.index].multipleAssign = params.multipleAssign
          this.formData.workTypeTimeDetail[params.index].multipleSelect = params.multipleSelect
        },
        // 删除工时明细数据
        participantDelete (account) {
          console.log(account)
          console.log(this.formData.partTableData[account.$index])
          this.formData.partTableData.splice(account.$index, 1)
          /* let tableLen = this.formData.partTableData.length
          for (let i = 0; i < tableLen; i++) {
            if (this.formData.partTableData[i].account === account) {
              this.formData.partTableData.splice(account.$index, 1)
            }
          } */
        },
        // 处理移除申报子类型3多选标签时的处理事件
        handleSub3RemoveTag (param) {
          let removeTagName = ''
          let deleteIndex = 0
          removeTagName = this.formData.subWorkType3List[param].name
          for (let i = 0; i < this.formData.workTypeTimeDetail.length; i++) {
            if (this.formData.workTypeTimeDetail[i].workType === removeTagName) {
              deleteIndex = i
            }
          }
          this.formData.workTypeTimeDetail.splice(deleteIndex, 1)
        },
        // 工时明细表K值和系数变化处理函数
        handleKValueCoffChange (row, index) {
          row.avaiableWorkTime = row.baseWorkTime * row.defaultKValue * row.defaultCofficient * row.applyProcess * 0.01
          row.avaiableWorkTime = Number(row.avaiableWorkTime.toFixed(1))
          row.workTimeAssign[0].assignWorkTime = row.baseWorkTime * row.defaultKValue * row.defaultCofficient * row.applyProcess * 0.01
        },
        // 手动刷新项目类型
        refreshSelectProjectType () {
          this.showFlag.projectType = false
          let it = this
          setTimeout(() => {
            it.showFlag.projectType = true
          }, it.$store.state.refreshInterval)
        },
        // 新增一行
        addNewLine () {
          let tableLength = this.formData.workTypeTimeDetail.length
          let obj = JSON.parse(JSON.stringify(this.formData.workTypeTimeDetail[tableLength - 1]))
          let selectLength = this.formData.projectType.length
          this.formData.workTypeTimeDetail.push(obj)
          obj = JSON.parse(JSON.stringify(this.formData.projectType[selectLength - 1]))
          this.formData.projectType.push(obj)
          this.refreshSelectProjectType()
          console.log(this.formData.workTypeTimeDetail)
        },
        // 表格删除按钮
        handleDelete (row, index) {
          this.formData.workTypeTimeDetail.splice(index, 1)
          this.formData.projectType.splice(index, 1)
          this.showFlag.projectType = false
          this.refreshSelectProjectType()
        },
        // 申报类型变化
        handleApplyTypeChange (applyType) {
          console.log(applyType)
          this.showFlag.freshTable = false
          setTimeout(() => {
            this.showFlag.freshTable = true
          }, this.$store.state.refreshInterval)
        }
      },
      computed: {
        projectStageEditable () {
          if (this.formData.projectType.length === 0) {
            return false
          } else {
            return this.formData.projectType[0][0] === 5
          }
        }
      },
      components: {
        Assign
      },
      created () {
        console.log('===PerformanceAdd.vue created')
        // this.formData.applyType = this.$route.query.type
        console.log(this.$store.state.userInfo)
        this.init()
      },
      name: 'PerformanceAdd.vue'
    }
</script>

<style scoped>
</style>

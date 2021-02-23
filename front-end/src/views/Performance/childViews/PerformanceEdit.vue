<template>
    <div>
      <h3 class="v-line-icon">编辑工时申报</h3>
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
          <el-button type="info" size="medium" @click="onTemporaryWorkTime('formData')">暂存</el-button>
          <el-button type="danger" size="medium" @click="onCancel('formData')">取 消</el-button>
        </el-form-item>
        <br>
        <el-form-item label="项目类型" prop="projectType">
          <el-cascader
            :disabled="true"
            v-if="formData.isShowProjectType"
            v-model="formData.projectType"
            :options="projectTypeOptions"
            :props="props"
            collapse-tags
            clearable
            style="width: 350%"></el-cascader>
        </el-form-item>
        <br>
<!--        <el-form-item label="项目级别" prop="projectLevel">-->
<!--          <el-select v-model="formData.projectLevel" placeholder="请选择" v-if="formData.isShowProjectLevel" :disabled="true">-->
<!--            <el-option v-for="item in projectLevels"-->
<!--                       :key="item.value"-->
<!--                       :label="item.text"-->
<!--                       :value="item.value">-->
<!--            </el-option>-->
<!--          </el-select>-->
<!--        </el-form-item>-->
        <!-- 分割线 start -->
        <div class="hr-10"></div>
        <!-- 分割线 end -->
        <br>
        <!--申报工时项目明细-->
        <el-table
          :data="formData.workTypeTimeDetail"
          stripe
          style="width: 97%;margin: auto">
          <el-table-column type="index" align="center" label="序号"></el-table-column>
          <el-table-column label="项目阶段" align="center">
            <template slot-scope="scope">
              <div>
                <el-input v-if="projectStageEditable"  v-model="scope.row.workType" size="mini"></el-input>
                <span v-else>{{scope.row.workType}}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="基本工时" prop="applyBaseWorkTime" align="center" width="80%">
            <template slot-scope="scope">
              <el-input v-if="projectStageEditable"
                        v-model.number="scope.row.applyBaseWorkTime"
                        size="mini"
                        @change="handleKValueCoffChange(scope.row, scope.$index)"></el-input>
              <span v-else>{{scope.row.applyBaseWorkTime}}</span>
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
          <el-table-column label="上月进展" align="center" width="100%">
            <template slot-scope="scope">
              <span>{{scope.row.lastProcess + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="本月进展" align="center" width="100%">
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
          <el-table-column label="工时分配" align="center" width="100%">
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
<!--          <el-table-column label="操作" align="center" width="100%">-->
<!--            <template slot-scope="scope">-->
<!--              <div>-->
<!--                <el-button size="mini" type="danger" @click="handleDelete(scope.row, scope.$index)">删除</el-button>-->
<!--              </div>-->
<!--            </template>-->
<!--          </el-table-column>-->
        </el-table>
        <br>
      </el-form>
      <Assign v-if="showFlag.workTimeAssign" ref="workTimeAssign" @assignDetail="handleAssign"/>
    </div>
</template>

<script>
  import { workTimeSubmit, getProjectInfo, getUsersName, getProjectType, getWorkTimeNew, workTimeTemporary,
    updateAssignWork, getAssignWorkDetail, getIsSubmitAllow } from '@/config/interface'
  import Assign from '@/components/Cop/workTimeAssign'
    export default {
      data () {
        return {
          id: null,
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
            projectType: [],
            participant: [],
            usersList: [],
            partWorkTime: 0,
            partTableData: [],
            workTypeTimeDetail: [],
            isShowProjectType: true,
            projectLevel: null,
            isShowProjectLevel: true
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
            projectLevel: [
              { required: true, message: '请选择项目级别', trigger: 'change' }
            ]
          },
          reqFlag: {
            edit: true,
            workTypeList: true,
            usersName: true,
            getProjectType: true,
            getWorkTimeNew: true
          },
          showFlag: {
            workTimeAssign: false
          },
          pickerOptions: {
          },
          workTime: 0,
          apdID: null,
          aplID: null,
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
          isRejectWorkTimeSubmit: false
        }
      },
      methods: {
        // 初始化
        init () {
          this.getUsersName()
          this.getProjectType()
          this.getProjectInfo().then(res => {
            this.getProjectDetail(res)
          })
        },
        // 获取当前月份能否申报的标志
        getIsSubmitAllow () {
          const url = getIsSubmitAllow
          let params = {
            applyYear: this.$moment(this.formData.title).year(),
            applyMonth: this.$moment(this.formData.title).month() + 1,
            flagType: 'workTimeSubmit'
          }
          let _this = this
          return new Promise(function (resolve, reject) {
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                resolve(res.data)
              } else {
                reject(new Error('getIsSubmitAllow recv error!'))
              }
            }).catch(err => {
              this.$common.toast(err, 'error', true)
              reject(new Error('getIsSubmitAllow send error!'))
            })
          })
        },
        // 获取项目申报明细
        getProjectDetail (param) {
          const url = getAssignWorkDetail
          let params = {
            apdID: param.apdID
          }
          this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                console.log(res.data)
                this.apdID = res.data.apdID
                this.aplID = res.data.aplID
                this.formData.projectLevel = res.data.projectLevel
              }
            })
        },
        // 获取工时申报详情
        getProjectInfo () {
          let url = getProjectInfo
          let params = {
            id: this.id
          }
          let it = this
          return new Promise(function (resolve, reject) {
            it.$http(url, params).then(res => {
              if (res.code === 1) {
                let data = res.data
                console.log(data)
                let multipleSelect = []
                let defaultCurrentUserWorkTime = []
                let workTimeAssignInsertID = []
                let tmp = []
                it.formData.title = data.workTimeList[0].applyMonth
                it.isRejectWorkTimeSubmit = data.workTimeList[0].reviewStatus === 2
                it.formData.projectType.push(data.projectTypeCheck) // get项目类型
                it.formData.isShowProjectType = false
                setTimeout(() => {
                  it.formData.isShowProjectType = true
                }, it.$store.state.refreshInterval)
                // 遍历工时分配信息
                for (let item of data.workTimeAssign) {
                  if (item.userID !== it.$store.state.userInfo.id) {
                    multipleSelect.push(item.userID)
                  }
                  workTimeAssignInsertID.push(item.id)
                  // 插入填报人信息
                  if (item.userID === it.$store.state.userInfo.id) {
                    let obj = {
                      id: item.userID,
                      groupName: it.$store.state.userInfo.groupName,
                      name: it.$store.state.userInfo.name,
                      applyRole: item.assignRole,
                      assignWorkTime: item.workTime,
                      deleteAble: false
                    }
                    defaultCurrentUserWorkTime.push(obj)
                  }
                  // 插入协作者信息
                  tmp = it.formData.usersList[1].options.find((iItem) => {
                    if (iItem.id === item.userID) {
                      let obj = {
                        id: iItem.id,
                        groupName: iItem.groupName,
                        name: iItem.name,
                        applyRole: item.assignRole,
                        assignWorkTime: item.workTime,
                        deleteAble: false
                      }
                      defaultCurrentUserWorkTime.push(obj)
                      return 0
                    }
                  })
                }
                let obj = {
                  projectTypeID: data.workTimeList[0].projectTypeID,
                  projectName: data.workTimeList[0].projectName,
                  baseWorkTime: data.workTime,
                  defaultKValue: data.workTimeList[0].applyKValue,
                  dynamicKValue: data.dynamicKValue,
                  defaultCofficient: data.workTimeList[0].applyCofficient,
                  workTimeAssign: [],
                  submitComments: data.workTimeList[0].submitComments,
                  multipleAssign: data.workTimeAssign.length > 1,
                  multipleSelect: multipleSelect,
                  workTimeAssignInsertID: workTimeAssignInsertID,
                  avaiableWorkTime: data.workTimeList[0].avaiableWorkTime,
                  isConference: data.isConference,
                  defaultAssignWorkTime: data.defaultAssignWorkTime,
                  defaultAssignWorkTimeIni: data.defaultAssignWorkTime,
                  applyProcess: data.workTimeList[0].applyProcess,
                  apdID: data.workTimeList[0].apdID,
                  workType: data.workTimeList[0].projectStageName,
                  lastProcess: data.workTimeList[0].lastProcess,
                  applyBaseWorkTime: data.workTimeList[0].applyBaseWorkTime
                }
                // obj.avaiableWorkTime = obj.baseWorkTime * obj.defaultKValue * obj.defaultCofficient
                obj.defaultAssignWorkTime = obj.defaultAssignWorkTimeIni * obj.defaultKValue * obj.defaultCofficient * obj.applyProcess * 0.01
                obj.workTimeAssign = defaultCurrentUserWorkTime
                it.formData.workTypeTimeDetail.push(obj)
                resolve(obj)
              }
            })
          })
        },
        // 提交至工时明细列表
        onSubmitWorkTimeList (formData) {
          const url = workTimeSubmit
          if (this.reqFlag.edit) {
            this.reqFlag.edit = false
            let title = this.formData.title
            let tableDataCopy = []
            for (let item of this.formData.workTypeTimeDetail) {
              item.avaiableWorkTime = Number(item.avaiableWorkTime)
              if (item.avaiableWorkTime !== 0 && item.applyProcess !== 0) {
                tableDataCopy.push(item)
              }
            }
            if (tableDataCopy.length !== 0) {
              let params = {
                projectID: this.id,
                submitType: 'update',
                submitDate: title,
                data: tableDataCopy
              }
              console.log('params')
              console.log(params)
              this.$http(url, params).then(res => {
                if (res.code === 1) {
                  this.$common.toast('提交成功', 'success', false)
                  this.onCancel(formData)
                } else {
                  this.$common.toast('提交失败', 'success', false)
                  this.onCancel(formData)
                }
                this.reqFlag.edit = true
              })
            } else {
              this.reqFlag.edit = true
              this.$common.toast('申报工时为0，请修改,', 'info', false)
            }
          }
        },
        // 提交至项目明细列表
        onSubmitProjectList () {
          const url = updateAssignWork
          let params = {
            apdID: this.apdID,
            aplID: this.aplID,
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
              projectName2: item.projectName,
              projectTypeID: item.projectTypeID,
              workTime: item.avaiableWorkTime,
              applyProcess: item.applyProcess,
              coefficient: item.defaultCofficient,
              workType: item.workType,
              baseWorkTime: item.applyBaseWorkTime,
              applyBaseWorkTime: item.applyBaseWorkTime
            }
            params.tableData.push(obj)
          }
          let it = this
          return new Promise(function (resolve, reject) {
            it.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  resolve(res.data)
                }
              })
          })
        },
        // 提交工时申报（更新）
        onSubmitWorkTime (formData) {
          this.$refs[formData].validate(valid => {
            if (valid) {
              this.getIsSubmitAllow().then(getIsSubmitAllowRes => {
                if (getIsSubmitAllowRes.length === 0 || this.isRejectWorkTimeSubmit || this.$store.state.userInfo.id === 26) {
                  this.onSubmitProjectList().then(() => {
                    this.onSubmitWorkTimeList(formData)
                  })
                } else {
                  this.$common.toast(this.formData.title + '月已截止申报工时', 'error', true)
                }
              }).catch(err => {
                this.$common.toast(err, 'error', true)
              })
            }
          })
        },
        // 暂存至工时申报列表
        onTemporaryWorkTimeList (formData) {
          const url = workTimeTemporary
          if (this.reqFlag.edit) {
            this.reqFlag.edit = false
            let title = this.formData.title
            let tableDataCopy = []
            for (let item of this.formData.workTypeTimeDetail) {
              item.avaiableWorkTime = Number(item.avaiableWorkTime)
              if (item.avaiableWorkTime !== 0 && item.applyProcess !== 0) {
                tableDataCopy.push(item)
              }
            }
            if (tableDataCopy.length !== 0) {
              let params = {
                projectID: this.id,
                submitType: 'update',
                submitDate: title,
                data: this.formData.workTypeTimeDetail
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('暂存成功', 'success', false)
                    this.onCancel(formData)
                  } else {
                    console.log(res.code)
                    this.$common.toast('暂存失败', 'success', false)
                    this.onCancel(formData)
                  }
                  this.reqFlag.edit = true
                })
            } else {
              this.$common.toast('申报工时为0，请修改,', 'warning', false)
              this.reqFlag.edit = true
            }
          }
        },
        // 暂存工时申报
        onTemporaryWorkTime (formData) {
          this.$refs[formData].validate(valid => {
            if (valid) {
              this.getIsSubmitAllow().then(getIsSubmitAllowRes => {
                if (getIsSubmitAllowRes.length === 0 || this.isRejectWorkTimeSubmit || this.$store.state.userInfo.id === 26) {
                  this.onSubmitProjectList().then(() => {
                    this.onTemporaryWorkTimeList(formData)
                  })
                } else {
                  this.$common.toast(this.formData.title + '月已截止申报工时', 'error', true)
                }
              }).catch(err => {
                this.$common.toast(err, 'error', true)
              })
            }
          })
        },
        // 取消
        onCancel (formName) {
          this.$router.push({ path: '/home/Performance' })
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
        getUsersName () {
          console.log('===PerformanceEdit.vue getUsersName')
          console.log(this.userListOptions)
          const url = getUsersName
          if (this.reqFlag.usersName) {
            this.reqFlag.usersName = false
            let params = {}
            let objList = []
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  let data = res.data
                  let list = data.list
                  for (let item of list) {
                    if (item.account !== this.$store.state.userInfo.account) {
                      let obj = {
                        id: item.id,
                        dept: item.dept,
                        name: item.name,
                        groupName: item.groupName,
                        disabled: false
                      }
                      objList.push(obj)
                    }
                  }
                  this.userListOptions[1].options = objList
                }
                this.reqFlag.usersName = true
                this.formData.usersList = this.userListOptions
              })
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
        // 工时明细表K值和系数变化处理函数
        handleKValueCoffChange (row) {
          row.avaiableWorkTime = row.applyBaseWorkTime * row.defaultKValue * row.defaultCofficient * (row.applyProcess - row.lastProcess) * 0.01
          row.avaiableWorkTime = Number(Number(row.avaiableWorkTime).toFixed(1))
          row.workTimeAssign[0].assignWorkTime = row.avaiableWorkTime
          row.defaultAssignWorkTime = row.defaultAssignWorkTimeIni * row.defaultKValue * row.defaultCofficient * row.applyProcess * 0.01
          console.log(row)
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
        console.log('===PerformanceEdit.vue created')
        console.log(this.$store.state.userInfo)
        this.id = this.$route.query.id
        this.init()
      },
      name: 'PerformanceAdd.vue'
    }
</script>

<style scoped>
</style>

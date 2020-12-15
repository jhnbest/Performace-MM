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
            @change="handleProjectTypeChange"
            clearable
            style="width: 350%"></el-cascader>
        </el-form-item>
        <!-- 分割线 start -->
        <div class="hr-10"></div>
        <!-- 分割线 end -->
        <br>
        <!--申报工时项目明细-->
        <el-table
          :data="formData.workTypeTimeDetail"
          stripe
          style="width: 90%;margin: auto">
          <el-table-column type="index" align="center" label="序号"></el-table-column>
          <el-table-column align="center" label="项目名称">
            <template slot-scope="scope">
              <el-form-item
                :prop="'workTypeTimeDetail.' + scope.$index + '.projectName'"
                :rules="formRules.projectName"
                style="margin: auto">
                <el-input type="textarea" size="mini" v-model="scope.row.projectName"></el-input>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column prop="workType" label="项目类型" align="center"></el-table-column>
          <el-table-column prop="baseWorkTime" label="基本工时" align="center" width="80%"></el-table-column>
          <el-table-column prop="defaultKValue" label="K值" align="center" width="170%">
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
                                 @change="handleKValueCoffChange(scope.row)">
                </el-input-number>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column prop="coefficient" label="系数" align="center" width="170%">
            <template slot-scope="scope">
              <el-form-item :prop="'workTypeTimeDetail.' + scope.$index + '.defaultCofficient'"
                            :rules="formRules.Cofficient"
                            style="margin: auto">
                <el-input-number size="mini"
                                 v-model="scope.row.defaultCofficient"
                                 :min="1.0"
                                 @change="handleKValueCoffChange(scope.row)">
                </el-input-number>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="工时分配" align="center">
            <template slot-scope="scope">
              <span class="link-type" @click="handleWorkTimeAssign(scope.row, scope.$index)">点击分配</span>
            </template>
          </el-table-column>
          <el-table-column prop="remarks" label="备注" align="center">
            <template slot-scope="scope">
              <el-input size="mini"
                        type="textarea"
                        autosize
                        v-model="scope.row.submitComments">
              </el-input>
            </template>
          </el-table-column>
<!--          <el-table-column label="操作" align="center" width="200">-->
<!--            <template slot-scope="scope">-->
<!--              <el-button size="mini"-->
<!--                         type="danger"-->
<!--                         plain-->
<!--                         @click="handleDeleteWorkDetail(scope.row, scope.$index)">删除</el-button>-->
<!--            </template>-->
<!--          </el-table-column>-->
        </el-table>
      </el-form>
      <Assign v-if="showFlag.workTimeAssign" ref="workTimeAssign" @assignDetail="handleAssign"/>
    </div>
</template>

<script>
  import { workTimeSubmit, getProjectInfo, getUsersName, getProjectType, getWorkTimeNew, workTimeTemporary } from '@/config/interface'
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
            isShowProjectType: true
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
            disabledDate (time) {
              return time.getTime() > Date.now()
            }
          },
          workTime: 0
        }
      },
      components: {
        Assign
      },
      methods: {
        init () {
          this.getUsersName()
          this.getProjectType()
          this.getProjectInfo()
        },
        /* 获取工时申报详情 */
        getProjectInfo () {
          let url = getProjectInfo
          let params = {
            id: this.id
          }
          this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                let data = res.data
                let multipleSelect = []
                let defaultCurrentUserWorkTime = []
                let workTimeAssignInsertID = []
                let tmp = []
                console.log(data)
                this.formData.title = data.workTimeList[0].applyMonth
                this.formData.projectType.push(data.projectTypeCheck) // get项目类型
                this.formData.isShowProjectType = false
                setTimeout(() => {
                  this.formData.isShowProjectType = true
                }, this.$store.state.refreshInterval)
                /* 遍历工时分配信息 */
                for (let item of data.workTimeAssign) {
                  if (item.userID !== this.$store.state.userInfo.id) {
                    multipleSelect.push(item.userID)
                  }
                  workTimeAssignInsertID.push(item.id)
                  /* 插入填报人信息 */
                  if (item.userID === this.$store.state.userInfo.id) {
                    let obj = {
                      id: item.userID,
                      groupName: this.$store.state.userInfo.groupName,
                      name: this.$store.state.userInfo.name,
                      applyRole: item.assignRole,
                      assignWorkTime: item.workTime,
                      deleteAble: false
                    }
                    defaultCurrentUserWorkTime.push(obj)
                  }
                  /* 插入协作者信息 */
                  tmp = this.formData.usersList[1].options.find((iItem) => {
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
                  workType: data.projectName,
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
                  defaultAssignWorkTime: data.defaultAssignWorkTime
                }
                // obj.avaiableWorkTime = obj.baseWorkTime * obj.defaultKValue * obj.defaultCofficient
                obj.workTimeAssign = defaultCurrentUserWorkTime
                this.formData.workTypeTimeDetail.push(obj)
              }
            })
        },
        /* 提交工时申报 */
        onSubmitWorkTime (formData) {
          this.$refs[formData].validate(valid => {
            if (valid) {
              const url = workTimeSubmit
              if (this.reqFlag.edit) {
                this.reqFlag.edit = false
                let title = this.formData.title
                let params = {
                  projectID: this.id,
                  submitType: 'update',
                  submitDate: title,
                  data: this.formData.workTypeTimeDetail
                }
                this.$http(url, params)
                  .then(res => {
                    if (res.code === 1) {
                      this.$common.toast('提交成功', 'success', false)
                      this.onCancel(formData)
                    } else {
                      console.log(res.code)
                      this.$common.toast('提交失败', 'success', false)
                      this.onCancel(formData)
                    }
                    this.reqFlag.edit = true
                  })
              }
            }
          })
        },
        /* 暂存工时申报 */
        onTemporaryWorkTime (formData) {
          this.$refs[formData].validate(valid => {
            if (valid) {
              const url = workTimeTemporary
              if (this.reqFlag.add) {
                this.reqFlag.add = false
              }
              let title = this.formData.title

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
                  this.reqFlag.add = true
                })
            }
          })
        },
        // 取消
        onCancel (formName) {
          this.$router.push({ path: '/home/Performance' })
          this.$refs[formName].resetFields()
        },
        /* 获取申报类型 */
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
                  console.log(data)
                  this.projectTypeOptions = data
                }
                this.reqFlag.getProjectType = true
              })
          }
        },
        /* 获取用户姓名 */
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
        /* 获取项目类型 */
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
          console.log(params)
          if (selectLen > tableLen) {
            if (this.reqFlag.getWorkTimeNew) {
              this.reqFlag.getWorkTimeNew = false
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    console.log(data)
                    for (let item of data) {
                      let obj = {
                        projectTypeID: item.projectTypeID,
                        projectName: '',
                        workType: item.projectName,
                        baseWorkTime: item.workTime,
                        defaultKValue: 1.0,
                        dynamicKValue: item.dynamicKValue,
                        defaultCofficient: 1.0,
                        workTimeAssign: [],
                        submitComments: '',
                        multipleAssign: false,
                        multipleSelect: [],
                        avaiableWorkTime: 0
                      }
                      obj.avaiableWorkTime = obj.baseWorkTime * obj.defaultKValue * obj.defaultCofficient
                      let defaultCurrentUserWorkTime = {
                        id: this.$store.state.userInfo.id,
                        groupName: this.$store.state.userInfo.groupName,
                        name: this.$store.state.userInfo.name,
                        applyRole: '组织者',
                        assignWorkTime: obj.baseWorkTime * obj.defaultKValue * obj.defaultCofficient,
                        deleteAble: false
                      }
                      obj.workTimeAssign.push(defaultCurrentUserWorkTime)
                      this.formData.workTypeTimeDetail.push(obj)
                      console.log(this.formData.workTypeTimeDetail)
                    }
                  }
                  this.reqFlag.getWorkTimeNew = true
                })
            }
          } else {
            let deleteIndex = null
            for (let diff of difference) {
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
        /* 删除工时明细记录 */
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
        /* 工时分配点击 */
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
        /* 工时分配子组件回调 */
        handleAssign (params) {
          console.log('===PerformanceAddNew.vue handleAssign')
          console.log(params)
          this.formData.workTypeTimeDetail[params.index].workTimeAssign = params.workTimeAssignDetail
          this.formData.workTypeTimeDetail[params.index].multipleAssign = params.multipleAssign
          this.formData.workTypeTimeDetail[params.index].multipleSelect = params.multipleSelect
          console.log(this.formData.workTypeTimeDetail)
        },
        /* 删除工时明细数据 */
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
        /* 工时明细表K值和系数变化处理函数 */
        handleKValueCoffChange (row) {
          row.avaiableWorkTime = row.baseWorkTime * row.defaultKValue * row.defaultCofficient
          row.workTimeAssign[0].assignWorkTime = row.baseWorkTime * row.defaultKValue * row.defaultCofficient
        }
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

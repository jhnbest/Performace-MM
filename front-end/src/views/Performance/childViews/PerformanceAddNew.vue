<template>
    <div>
      <h3 class="v-line-icon">新增工时申报</h3>
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
        <el-form-item label="项目阶段" prop="projectType">
          <el-cascader
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
          :data="formData.workTypeTimeDetail"
          stripe
          style="width: 97%;margin: auto">
          <el-table-column type="index" align="center" label="序号"></el-table-column>
          <el-table-column align="center" label="项目名称" width="150%">
            <template slot-scope="scope">
              <el-form-item
                :prop="'workTypeTimeDetail.' + scope.$index + '.projectName'"
                :rules="formRules.projectName"
                style="margin: auto">
                <el-input type="textarea" v-model="scope.row.projectName" autosize></el-input>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="项目阶段" prop="workType" align="center"></el-table-column>
          <el-table-column label="基本工时" prop="baseWorkTime" align="center" width="80%"></el-table-column>
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
          <el-table-column label="系数" align="center" width="150%">
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
          <el-table-column label="进展" align="center" width="100%">
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
        </el-table>
      </el-form>
      <Assign v-if="showFlag.workTimeAssign" ref="workTimeAssign" @assignDetail="handleAssign"/>
    </div>
</template>

<script>
  import { workTypeList, workTimeSubmit, getWorkTime, submitAssignWorkDetail,
    getUsersName, getProjectType, getWorkTimeNew, workTimeTemporary } from '@/config/interface'
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
            projectType: [],
            participant: [],
            usersList: [],
            partWorkTime: 0,
            partTableData: [],
            workTypeTimeDetail: [],
            projectLevel: 1
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
            projectLevel: [
              { required: true, message: '请选择项目级别', trigger: 'change' }
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
            workTimeAssign: false
          },
          pickerOptions: {
            disabledDate (time) {
              return time.getTime() > Date.now()
            }
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
            let params = {
              submitType: 'insert',
              submitDate: title,
              data: this.formData.workTypeTimeDetail
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  this.$common.toast('添加成功', 'success', false)
                  this.onCancel(formData)
                } else {
                  console.log(res.code)
                  this.$common.toast('添加失败', 'success', false)
                  this.onCancel(formData)
                }
                this.reqFlag.add = true
              })
          }
        },
        // 提交至项目明细列表
        onSubmitProjectList () {
          const url = submitAssignWorkDetail
          let params = {
            parentID: this.formData.projectType[0][0],
            projectLevel: this.formData.projectLevel,
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
              workTime: item.avaiableWorkTime
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
                  }
                  resolve(res.data)
                }
              })
          })
        },
        // 提交工时申报
        onSubmitWorkTime (formData) {
          this.$refs[formData].validate(valid => {
            if (valid) {
              this.onSubmitProjectList().then(res => {
                console.log(res)
                this.onSubmitWorkTimeList(formData)
              })
            }
          })
        },
        // 暂存工时申报
        onTemporaryWorkTime (formData) {
          this.$refs[formData].validate(valid => {
            if (valid) {
              const url = workTimeTemporary
              if (this.reqFlag.add) {
                this.reqFlag.add = false
              }
              let title = this.formData.title
              let params = {
                submitType: 'insert',
                submitDate: title,
                data: this.formData.workTypeTimeDetail
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('添加成功', 'success', false)
                    this.onCancel(formData)
                  } else {
                    console.log(res.code)
                    this.$common.toast('添加失败', 'success', false)
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
          if (selectItem.length !== 0) {
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
                        avaiableWorkTime: 0,
                        isConference: item.isConference,
                        defaultAssignWorkTime: item.defaultAssignWorkTime,
                        applyProcess: 100
                      }
                      obj.avaiableWorkTime = obj.baseWorkTime * obj.defaultKValue * obj.defaultCofficient * obj.applyProcess * 0.01
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
                    this.reqFlag.getWorkTimeNew = true
                  }
                })
            }
          } else { // 选中的数目小于列表中的数目
            let deleteIndex = null
            console.log(difference)
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
          console.log('=====')
          row.avaiableWorkTime = row.baseWorkTime * row.defaultKValue * row.defaultCofficient * row.applyProcess * 0.01
          row.workTimeAssign[0].assignWorkTime = row.baseWorkTime * row.defaultKValue * row.defaultCofficient * row.applyProcess * 0.01
        }
      },
      components: {
        Assign
      },
      created () {
        console.log('===PerformanceAdd.vue created')
        console.log(this.$store.state.userInfo)
        this.init()
      },
      name: 'PerformanceAdd.vue'
    }
</script>

<style scoped>
</style>

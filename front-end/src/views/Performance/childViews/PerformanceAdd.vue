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
          <el-button type="info" size="medium" @click="onSubmitWorkTime('formData')">暂存</el-button>
          <el-button type="danger" size="medium" @click="onCancel('formData')">取 消</el-button>
        </el-form-item>
        <br>
        <!-- 分割线 start -->
        <div class="hr-10"></div>
        <!-- 分割线 end -->
        <br>
        <el-form-item label="项目名称" prop="workName">
          <el-input
            v-model="formData.workName"
            placeholder="请输入项目名称"
            clearable
          ></el-input>
        </el-form-item>
        <el-form-item label="总工时数" style="margin-left:-10px">
          <el-input
            :disabled="true"
            v-model="workTime"
            clearable
            style="width: 80px"
          ></el-input>
        </el-form-item>
        <br>
        <el-form-item label="申报类型" prop="workTypeValue">
          <el-select v-model="formData.workTypeValue"
                     filterable
                     remote
                     reserve-keyword
                     placeholder="请选择"
                     :remote-method="queryWorkType"
                     clearable
                     style="width: 120px"
                     @change="getWorkTypeLabel1">
            <el-option
              v-for="item in formData.workTypeList"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="申报子类型1" prop="subWorkType1Value">
          <el-select v-model="formData.subWorkType1Value"
                     filterable
                     placeholder="请选择"
                     clearable
                     style="width: 160px"
                     @change="getWorkTypeLabel2"
                     @clear="handleSubWorkType1Clear">
            <el-option
              v-for="item in formData.subWorkType1List"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="申报子类型2" prop="subWorkType2Value">
          <el-select v-model="formData.subWorkType2Value"
                     filterable
                     placeholder="请选择"
                     clearable
                     style="width: 160px"
                     @change="getWorkTypeLabel3">
            <el-option
              v-for="item in formData.subWorkType2List"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <br>
        <!--申报子类型3-->
        <el-form-item label="申报子类型3" prop="subWorkType3Value" style="margin-left:21px">
          <el-select v-model="formData.subWorkType3Value"
                     multiple
                     placeholder="请选择"
                     style="width: 200%"
                     @blur="blurTest"
                     @focus="focusTest"
                     collapse-tags
                     @visible-change="getWorkTime"
                     @clear="subWorkType3Clear"
                     @remove-tag="handleSub3RemoveTag"
                     @change="handleSubWorkTypeChange">
            <el-option
              v-for="item in formData.subWorkType3List"
              :key="item.id"
              :label="item.name"
              :value="item.id">
            </el-option>
          </el-select>
        </el-form-item>
        <!--申报工时项目明细-->
        <el-table
          :data="formData.workTypeTimeDetail"
          stripe
          style="width: 90%;margin: auto"
          show-summary
          :summary-method="getWorkTypeTimeDetailTableSummaries"
          :span-method="arraySpanMethod">
          <el-table-column prop="workType" label="申报工时项目" align="center"></el-table-column>
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
                                 @change="handleKValueCoffChange(scope)">
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
                                 @change="handleKValueCoffChange(scope)">
                </el-input-number>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column prop="workTime" label="工时" align="center" width="50%"></el-table-column>
          <el-table-column prop="remarks" label="备注" align="center">
            <template slot-scope="scope">
              <el-input size="mini"
                        type="textarea"
                        autosize
                        v-model="scope.row.remarks">
              </el-input>
            </template>
          </el-table-column>
        </el-table>
        <br>
        <!-- 分割线 start -->
        <div class="hr-10"></div>
        <!-- 分割线 end -->
        <br>
        <el-form-item>
          <el-checkbox v-model="multiParticipant"
                       size="medium"
                       style="margin-left: 35px"
                       border
                       @change="handleMultiChange">多人协作</el-checkbox>
        </el-form-item>
        <el-form-item v-if="multiParticipant" label="工时数" prop="partWorkTime">
          <el-input-number v-model.number="formData.partWorkTime"
                           size="medium"
                           :min="0.5"
                           :max="workTime"
                           style="width: 50%"
                           :precision="1">
          </el-input-number>
        </el-form-item>
        <!--参与人员列表-->
        <el-form-item v-if="multiParticipant" label="参与人员" prop="participant" style="margin-left: -140px">
          <el-select v-model="formData.participant"
                     placeholder="请选择"
                     clearable
                     filterable
                     multiple
                     collapse-tags
                     style="width: 100%"
                     @visible-change="getUsersName"
                     @clear="participantClear"
                     @change="handlePartChange">
            <el-option-group
              v-for="group in formData.usersList"
              :key="group.id"
              :label="group.name"
              :value="group.id">
              <el-option
                v-for="item in group.options"
                :key="item.id"
                :label="item.name"
                :value="item.id"
                :disabled="item.disabled">
              </el-option>
            </el-option-group>
          </el-select>
        </el-form-item>
        <br>
        <!--参与项目的其他人员-->
        <el-table
          v-if="multiParticipant"
          :data="formData.partTableData"
          stripe
          style="width: 90%;margin: auto">
          <el-table-column label="序号" align="center" type="index"></el-table-column>
          <el-table-column prop="account" label="工号" align="center"></el-table-column>
          <el-table-column prop="dept" label="处室" align="center"></el-table-column>
          <el-table-column prop="groupName" label="小组" align="center"></el-table-column>
          <el-table-column prop="name" label="姓名" align="center"></el-table-column>
          <el-table-column prop="workTime" label="工时数" align="center">
            <template slot-scope="scope">
              <el-form-item :prop="'partTableData.' + scope.$index + '.workTime'" :rules="formRules.workTime" style="margin: auto">
                <el-input-number size="mini"
                                 v-model="scope.row.workTime"
                                 :max="workTime"
                                 :precision="1"
                                 :min="0.0">
                </el-input-number>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="200">
            <template slot-scope="scope">
              <el-button size="mini"
                         type="danger"
                         :disabled="scope.row.deleteAble"
                         plain
                         @click="participantDelete(scope)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-form-item class="dialog-footer" align="center">
        </el-form-item>
      </el-form>
    </div>
</template>

<script>
  import { workTypeList, workTimeSubmit, getWorkTime, getUsersName } from '@/config/interface'
  import Sticky from '@/components/Sticky'
    export default {
      data () {
        return {
          multiParticipant: false,
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
          labelPosition: 'right',
          optionsWorkType: [],
          partTableData: [{
            workTime: undefined
          }],
          formData: {
            title: this.$moment().format('YYYY-MM-DD'),
            workTypeList: [],
            subWorkType1List: [],
            subWorkType2List: [],
            subWorkType3List: [],
            workName: '',
            workTypeValue: '',
            subWorkType1Value: '',
            subWorkType2Value: '',
            subWorkType3Value: [],
            participant: [],
            usersList: [],
            partWorkTime: 0,
            partTableData: [],
            workTypeTimeDetail: []
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
            workName: [
              { required: true, message: '请输入项目/任务名称', trigger: 'blur' }
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
            ]
          },
          reqFlag: {
            add: true,
            workTypeList: true,
            usersName: true
          },
          pickerOptions: {
            disabledDate (time) {
              return time.getTime() > Date.now()
            }
          },
          workTime: 0
        }
      },
      methods: {
        init () {
          this.queryWorkType()
        },
        onSubmitWorkTime (formData) {
          this.$refs[formData].validate(valid => {
            if (valid) {
              const url = workTimeSubmit
              if (this.reqFlag.add) {
                this.reqFlag.add = false
              }
              let title = this.formData.title
              let projectLevel1Name = this.formData.workTypeList.find(item => {
                if (item.id === this.formData.workTypeValue) {
                  return item
                }
              })
              let projectLevel2Name = this.formData.subWorkType1List.find(item => {
                if (item.id === this.formData.subWorkType1Value) {
                  return item
                }
              })
              let projectLevel3Name = this.formData.subWorkType2List.find(item => {
                if (item.id === this.formData.subWorkType2Value) {
                  return item
                }
              })
              let selectSubW3Name = []
              let kValue = []
              let cofficient = []
              let remarks = []
              let workTime = []
              for (let item of this.formData.workTypeTimeDetail) {
                selectSubW3Name.push(item.workType)
                kValue.push(item.defaultKValue)
                cofficient.push(item.defaultCofficient)
                workTime.push(item.workTime)
                remarks.push(item.remarks)
              }
              let cooperatePerson = []
              for (let item of this.formData.partTableData) {
                let obj = {
                  account: item.account,
                  workTime: item.workTime
                }
                cooperatePerson.push(obj)
              }
              let params = {
                submitAccount: this.$store.state.userInfo.account,
                submitPerson: this.$store.state.userInfo.name,
                groupName: this.$store.state.userInfo.groupName,
                workName: this.formData.workName,
                projectLevel1: projectLevel1Name.name,
                projectLevel2: projectLevel2Name.name,
                projectLevel3: projectLevel3Name.name,
                projectLevel4: selectSubW3Name,
                workTime: workTime,
                kValue: kValue,
                cofficient: cofficient,
                applyMonth: title,
                remarks: remarks,
                submitStatus: 1,
                cooperatePerson: cooperatePerson
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('添加成功', 'success', false)
                    this.onCancel(formData)
                  } else {
                    this.$common.toast('添加失败', 'success', false)
                    this.onCancel(formData)
                  }
                  this.reqFlag.add = true
                })
            }
          })
          /* this.$refs[formData].validate((valid) => {
            if (valid) {
              const url = performanceAdd
              if (this.reqFlag.add) {
                this.reqFlag.add = false

                let title = this.formData.title
                console.log('formData.title==' + title)

                let yearNum = this.$moment(title).year()
                console.log('yearNum==' + yearNum)

                let monthNum = this.$moment(title).month()
                console.log('monthNum==' + monthNum)

                let params = {
                  title: yearNum + ' 第 ' + monthNum + ' 月',
                  workType: this.formData.workType,
                  workTime: this.workTime
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
            } else {
              console.log('error submit!!')
              return false
            }
          }) */
        },
        // 取消
        onCancel (formName) {
          this.$router.push({ path: '/home/Performance' })
          this.$refs[formName].resetFields()
        },
        /* 获取申报类型 */
        queryWorkType () {
          this.formData.subWorkType1Value = ''
          this.formData.subWorkType2Value = ''
          this.formData.subWorkType3Value = []
          const url = workTypeList
          if (this.reqFlag.workTypeList) {
            this.reqFlag.workTypeList = false
            let params = {
              queryType: 1,
              pageNum: 1,
              pageSize: 20
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  let data = res.data
                  let list = data.list
                  let objList = []
                  list.map((item, index) => {
                    let obj = {
                      id: index,
                      name: item.projectLevel1
                    }
                    objList.push(obj)
                  })
                  this.formData.workTypeList = objList
                }
                this.reqFlag.workTypeList = true
              })
          }
        },
        /* 获取申报子类型1Label */
        getWorkTypeLabel1 (id) {
          this.formData.subWorkType1Value = ''
          this.formData.subWorkType1List = []
          this.formData.subWorkType2Value = ''
          this.formData.subWorkType2List = []
          this.formData.subWorkType3Value = []
          this.formData.subWorkType3List = []
          this.workTime = 0
          if (id || id === 0) {
            let workTypeLabel = ''
            workTypeLabel = this.formData.workTypeList.find((item) => {
              if (item.id === id) {
                return item.name
              }
            })
            const url = workTypeList
            if (this.reqFlag.workTypeList) {
              this.reqFlag.workTypeList = false
              let params = {
                queryType: 2,
                pageNum: 1,
                pageSize: 20,
                workTypeLabel: workTypeLabel.name
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    let list = data.list
                    let objList = []
                    list.map((item, index) => {
                      let obj = {
                        id: index,
                        name: item.projectLevel2
                      }
                      objList.push(obj)
                    })
                    this.formData.subWorkType1List = objList
                  }
                  this.reqFlag.workTypeList = true
                })
            }
          }
        },
        /* 获取申报子类型2 */
        getWorkTypeLabel2 (id) {
          this.formData.subWorkType2Value = ''
          this.formData.subWorkType3Value = []
          this.formData.subWorkType2List = []
          this.formData.subWorkType3List = []
          this.workTime = 0
          if (id || id === 0) {
            let subWorkTypeL1abel = ''
            console.log(id)
            subWorkTypeL1abel = this.formData.subWorkType1List.find((item) => {
              if (item.id === id) {
                return item.name
              }
            })
            console.log(subWorkTypeL1abel)
            const url = workTypeList
            if (this.reqFlag.workTypeList) {
              this.reqFlag.workTypeList = false
              let params = {
                queryType: 3,
                pageNum: 1,
                pageSize: 20,
                subWorkTypeL1abel: subWorkTypeL1abel.name
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    let list = data.list
                    let objList = []
                    list.map((item, index) => {
                      let obj = {
                        id: index,
                        name: item.projectLevel3
                      }
                      objList.push(obj)
                    })
                    this.formData.subWorkType2List = objList
                  }
                  this.reqFlag.workTypeList = true
                })
            }
          }
        },
        /* 获取申报子类型3 */
        getWorkTypeLabel3 (id) {
          this.formData.subWorkType3List = []
          this.formData.subWorkType3Value = []
          this.workTime = 0
          if (id || id === 0) {
            let subWorkTypeL1abel = ''
            let subWorkTypeL2abel = ''
            subWorkTypeL1abel = this.formData.subWorkType1List.find((item) => {
              if (item.id === this.formData.subWorkType1Value) {
                return item.name
              }
            })
            subWorkTypeL2abel = this.formData.subWorkType2List.find((item) => {
              if (item.id === id) {
                return item.name
              }
            })
            const url = workTypeList
            if (this.reqFlag.workTypeList) {
              this.reqFlag.workTypeList = false
              let params = {
                queryType: 4,
                pageNum: 1,
                pageSize: 20,
                subWorkTypeL1abel: subWorkTypeL1abel.name,
                subWorkTypeL2abel: subWorkTypeL2abel.name
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    let list = data.list
                    let objList = []
                    list.map((item, index) => {
                      let obj = {
                        id: index,
                        name: item.projectLevel4
                      }
                      objList.push(obj)
                    })
                    this.formData.subWorkType3List = objList
                  }
                  this.reqFlag.workTypeList = true
                })
            }
          }
        },
        /* 获取工时数 */
        getWorkTime (isOpen) {
          let subWorkTypeL1abel = ''
          let subWorkTypeL3abel = ''
          const url = getWorkTime
          if (!isOpen) {
            this.formData.workTypeTimeDetail = []
            let params = {
              subWorkType1Label: [],
              subWorkType3Label: [],
              selectWorkTypeNum: 0
            }
            let workTypeTimeDetailData = {}
            let selectSubValueNum = this.formData.subWorkType3Value.length
            if (selectSubValueNum) {
              params.selectWorkTypeNum = selectSubValueNum
              for (let i = 0; i < selectSubValueNum; i++) { // 遍历选中的申报子类型3
                // 找到申报子类型1
                subWorkTypeL1abel = this.formData.subWorkType1List.find((item) => {
                  if (item.id === this.formData.subWorkType1Value) {
                    return item.name
                  }
                })
                // 找到申报子类型3
                subWorkTypeL3abel = this.formData.subWorkType3List.find((item) => {
                  if (item.id === this.formData.subWorkType3Value[i]) {
                    return item.name
                  }
                })
                params.subWorkType1Label.push(subWorkTypeL1abel.name)
                params.subWorkType3Label.push(subWorkTypeL3abel.name)
              }
              console.log('===PerformaceAdd.vue getWorkTime')
              console.log(params)
              // 装参，发送请求
              if (this.reqFlag.workTypeList) {
                this.reqFlag.workTypeList = false
                this.$http(url, params)
                  .then(res => {
                    if (res.code === 1) {
                      let data = res.data
                      console.log('===PerformaceAdd.vue getWorkTime')
                      console.log(data)
                      /* 更新工时明细表格数据 */
                      for (let i = 0; i < selectSubValueNum; i++) {
                        workTypeTimeDetailData = {
                          workType: data.subWorkType3Label[i],
                          baseWorkTime: data.workTime[i],
                          dynamicKValue: data.dynamicKValue[i],
                          defaultKValue: data.defaultKValue[i],
                          defaultCofficient: data.defaultCofficient[i],
                          workTime: data.workTime[i] * data.defaultKValue[i] * data.defaultCofficient[i],
                          remarks: ' '
                        }
                        console.log('===PerformaceAdd.vue getWorkTime')
                        console.log(data.workTime[i])
                        console.log(data.defaultKValue[i])
                        console.log(data.defaultCofficient[i])
                        this.formData.workTypeTimeDetail.push(workTypeTimeDetailData)
                      }
                      console.log('===PerformaceAdd.vue 565')
                      console.log(this.formData.workTypeTimeDetail)
                    }
                    this.reqFlag.workTypeList = true
                  })
              }
            } else {
              this.workTime = 0
            }
          }
        },
        /* 获取用户姓名 */
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
        /* 添加其他协作人 */
        /* onAddParticipant () {
          console.log('PerformanceAdd.vue onAddParticipant')
          console.log(this.formData.participant)
          console.log(this.formData.partTableData)
          let tmp = []
          let tableLen = this.formData.partTableData.length
          if (this.formData.participant.length !== 0 && this.formData.partWorkTime !== 0) { // 保证参与人员和工时数有填
            for (let i = 0; i < this.formData.participant.length; i++) {
              for (let j = 0; j < tableLen; j++) {
                if (this.formData.participant[i] !== this.formData.partTableData[j].account) {
                  if (j === tableLen - 1) {
                    tmp = this.formData.usersList.find((item) => {
                      if (item.id === this.formData.participant[i]) {
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
                  this.formData.partTableData[j].workTime = this.formData.partWorkTime
                  break
                }
              }
            }
            /!* for (let i = 0; i < tableLen; i++) {
              if (this.formData.participant === this.formData.partTableData[i].account) {
                this.$notify.error({
                  title: '添加失败',
                  message: '不能重复添加该成员,请先删除该成员再添加'
                })
                return
              }
            }
            tmp = this.formData.usersList.find((item) => {
              if (item.id === this.formData.participant) {
                let obj = {
                  account: item.id,
                  dept: item.dept,
                  groupName: item.groupName,
                  name: item.name,
                  workTime: this.formData.partWorkTime
                }
                this.formData.partTableData.push(obj)
                return this.formData.partTableData
              }
            }) *!/
          }
        }, */
        /* 参与人员变化处理 */
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
        blurTest () {
        },
        focusTest () {
        },
        handleSubWorkType1Clear () {
        },
        subWorkType3Clear () {
          this.workTime = 0
        },
        participantClear () {
          this.formData.participant = ''
          this.formData.partWorkTime = 0
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
        /* 处理移除申报子类型3多选标签时的处理事件 */
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
        /* 工时明细表K值和系数变化处理函数 */
        handleKValueCoffChange (scope) {
          scope.row.workTime = scope.row.baseWorkTime * scope.row.defaultKValue * scope.row.defaultCofficient
        },
        // 显示工时明细表合计行
        getWorkTypeTimeDetailTableSummaries (param) {
          const { columns, data } = param
          const sums = []
          columns.forEach((column, index) => {
            if (index === 0) {
              sums[index] = '总工时'
            } else if (index === columns.length - 2) {
              const values = data.map(item => Number(item[column.property]))
              if (!values.every(value => isNaN(value))) {
                sums[index] = values.reduce((prev, curr) => {
                  const value = Number(curr)
                  if (!isNaN(value)) {
                    return prev + curr
                  } else {
                    return prev
                  }
                }, 0).toFixed(1)
                this.workTime = Number(sums[index])
              } else {
                sums[index] = ' '
              }
            } else {
              sums[index] = ' '
            }
          })
          return sums
        },
        arraySpanMethod ({ row, column, rowIndex, columnIndex }) {
        },
        /* 多人协作选项处理 */
        handleMultiChange (param) {
          if (param) {
            /* 把当前登录用户的工时信息插入工时统计表格 */
            let tableData = []
            let obj = {
              account: this.$store.state.userInfo.account,
              dept: this.$store.state.userInfo.dept,
              groupName: this.$store.state.userInfo.groupName,
              name: this.$store.state.userInfo.name,
              workTime: 0.0,
              deleteAble: true
            }
            for (let item of this.formData.partTableData) {
              tableData.push(item.account)
            }
            if (tableData.indexOf(obj.account) === -1) {
              this.formData.partTableData.push(obj)
            }
          }
        },
        handleSubWorkTypeChange () {
          console.log('===PerformaceAdd.vue handleSubWorkTypeChange')
          console.log(this.formData.subWorkType3Value)
          if (!this.formData.subWorkType3Value.length) {
            this.formData.partTableData = []
          }
        }
      },
      created () {
        this.init()
      },
      name: 'PerformanceAdd.vue'
    }
</script>

<style scoped>
</style>

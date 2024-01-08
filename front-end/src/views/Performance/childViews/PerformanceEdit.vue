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
          <el-button type="primary" size="medium" @click="onSubmitWorkTime('formData', 'submit')">提交</el-button>
          <el-button type="info" size="medium" @click="onSubmitWorkTime('formData', 'temporary')">暂存</el-button>
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
        <el-form-item label="项目名称">
          <el-tooltip :content="projectName" placement="top">
            <el-input v-model="projectName"
                      style="width: 250%"></el-input>
          </el-tooltip>
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
              <el-select v-model="formData.workTypeTimeDetail[scope.$index].applyProcess"
                         placeholder=""
                         size="mini"
                         filterable
                         @visible-change="handleKValueCoffChange(scope.row, scope.$index)">
                <el-option
                  v-for="item in progress"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                  :disabled="item.disable">
                </el-option>
              </el-select>
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
                        v-model="scope.row.submitComments"
                        @input="inputCommentsChange(scope.row)">
              </el-input>
              <span style="font-size: 10px">字数限制：
                <span v-if="!scope.row.isInputCommentsWordExceed">
                  {{scope.row.inputCommentsWord? scope.row.inputCommentsWord : 0}} {{'/' + maxInputCommentsWord}}
                </span>
                <span v-else style="color: red">
                  {{scope.row.inputCommentsWord? scope.row.inputCommentsWord : 0}} {{'/' + maxInputCommentsWord}}
                </span>
              </span>
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
  import { getAssignWorkDetail } from '@/config/interface'
  import { getProjectType, workTimeListInsert, temporaryWorkTimeList, getProjectInfo } from '@/utils/performance'
  import { getUsersList } from '@/utils/users'
  import Assign from '@/components/Cop/workTimeAssign'
  import { getIsSubmitAllow } from '@/utils/common'
  import { getAssignProjectTotalWorkTime, updateAssignProjectInfo, updateAssignProjectStageInfo } from '@/utils/workStation'
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
        isInputCommentsWordExceed: false,
        projectTypeOptions: [],
        labelPosition: 'right',
        optionsWorkType: [],
        partTableData: [{
          workTime: undefined
        }],
        usersList: [],
        assignProjectInfo: null,
        formData: {
          title: this.$moment().format('YYYY-MM'),
          projectType: [],
          participant: [],
          partWorkTime: 0,
          partTableData: [],
          isShowProjectType: true,
          projectLevel: null,
          isShowProjectLevel: true,
          workTypeTimeDetail: []
        },
        formRules: {
          title: [
            { required: true, message: '请选择申报月份', trigger: 'change' }
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
          projectType: [
            { required: true, message: '请选择项目类型', trigger: 'change' }
          ],
          projectLevel: [
            { required: true, message: '请选择项目级别', trigger: 'change' }
          ]
        },
        reqFlag: {
          usersName: true
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
        isRejectWorkTimeSubmit: false,
        projectName: null,
        progress: [{
          value: 100,
          label: '100%',
          disable: false
        }, {
          value: 95,
          label: '95%',
          disable: false
        }, {
          value: 90,
          label: '90%',
          disable: false
        }, {
          value: 85,
          label: '85%',
          disable: false
        }, {
          value: 80,
          label: '80%',
          disable: false
        }, {
          value: 75,
          label: '75%',
          disable: false
        }, {
          value: 70,
          label: '70%',
          disable: false
        }, {
          value: 65,
          label: '65%',
          disable: false
        }, {
          value: 60,
          label: '60%',
          disable: false
        }, {
          value: 55,
          label: '55%',
          disable: false
        }, {
          value: 50,
          label: '50%',
          disable: false
        }, {
          value: 45,
          label: '45%',
          disable: false
        }, {
          value: 40,
          label: '40%',
          disable: false
        }, {
          value: 35,
          label: '35%',
          disable: false
        }, {
          value: 30,
          label: '30%',
          disable: false
        }, {
          value: 25,
          label: '25%',
          disable: false
        }, {
          value: 20,
          label: '20%',
          disable: false
        }, {
          value: 15,
          label: '15%',
          disable: false
        }, {
          value: 10,
          label: '10%',
          disable: false
        }, {
          value: 5,
          label: '5%',
          disable: false
        }, {
          value: 0,
          label: '0%',
          disable: false
        }],
        maxInputCommentsWord: 500
        }
    },
    methods: {
      // 初始化
      init () {
        let checkGroupID = 0
        getUsersList(checkGroupID).then(users => {
          let objList = []
          for (let user of users) {
            if (user.account !== this.$store.state.userInfo.account) {
              let obj = {
                id: user.id,
                dept: user.dept,
                name: user.name,
                groupName: user.groupName,
                disabled: false
              }
              objList.push(obj)
            }
          }
          this.userListOptions[1].options = objList
          this.usersList = this.userListOptions
        })
        getProjectType(this.$store.state.userInfo.groupName).then(getProjectTypeRes => {
          this.projectTypeOptions = getProjectTypeRes
        })
        getProjectInfo(this.id, this.aplID).then(res => {
          let data = res.data
          let multipleSelect = []
          let defaultCurrentUserWorkTime = []
          let workTimeAssignInsertID = []
          let tmp = []
          this.assignProjectInfo = data.assignProject[0]
          this.formData.title = data.workTimeList[0].applyMonth
          this.isRejectWorkTimeSubmit = data.workTimeList[0].reviewStatus === 2
          this.formData.projectType.push(data.projectTypeCheck) // get项目类型
          this.formData.isShowProjectType = false
          this.projectName = data.workTimeList[0].projectName
          setTimeout(() => {
            this.formData.isShowProjectType = true
          }, this.$store.state.refreshInterval)
          // 遍历工时分配信息
          for (let item of data.workTimeAssign) {
            if (item.userID !== this.$store.state.userInfo.id) {
              multipleSelect.push(item.userID)
            }
            workTimeAssignInsertID.push(item.id)
            // 插入填报人信息
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
            // 插入协作者信息
            tmp = this.usersList[1].options.find((iItem) => {
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
          this.formData.workTypeTimeDetail.push(obj)
          this.getProjectDetail(obj)
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
              this.apdID = res.data.apdID
              this.aplID = res.data.aplID
              this.formData.projectLevel = res.data.projectLevel
            }
          })
      },
      // ***提交工时申报（更新）
      onSubmitWorkTime (formData, submitType) {
        this.$refs[formData].validate(valid => {
          if (valid) {
            let applyYear = this.$moment(this.formData.title).year()
            let applyMonth = this.$moment(this.formData.title).month() + 1
            getIsSubmitAllow(applyYear, applyMonth).then(getIsSubmitAllowRes => {
              if (getIsSubmitAllowRes.length === 0 ||
                  this.isRejectWorkTimeSubmit ||
                  this.$store.state.userInfo.id === 26) {
                if (!this.isInputCommentsWordExceed) {
                  let count = 0
                  let promises = []
                  let assignProjectDetail = {
                    apdID: this.formData.workTypeTimeDetail[0].apdID,
                    kValue: this.formData.workTypeTimeDetail[0].defaultKValue,
                    coefficient: this.formData.workTypeTimeDetail[0].defaultCofficient,
                    avaiableWorkTime: this.formData.workTypeTimeDetail[0].avaiableWorkTime,
                    projectStageName: this.formData.workTypeTimeDetail[0].workType,
                    applyBaseWorkTime: this.formData.workTypeTimeDetail[0].applyBaseWorkTime
                  }
                  promises[count++] = updateAssignProjectStageInfo(assignProjectDetail)
                  let tableDataCopy = []
                  let avaiableWorkTime = Number(this.formData.workTypeTimeDetail[0].avaiableWorkTime)
                  let applyProcess = this.formData.workTypeTimeDetail[0].applyProcess
                  if (avaiableWorkTime !== 0 && applyProcess !== 0) {
                    tableDataCopy.push(this.formData.workTypeTimeDetail[0])
                  }
                  if (tableDataCopy.length !== 0) {
                    switch (submitType) {
                      case 'submit':
                        promises[count++] = workTimeListInsert(this.id, 'update', this.formData.title, null, tableDataCopy)
                        break
                      case 'temporary':
                        promises[count++] = temporaryWorkTimeList(this.id, 'update', this.formData.title, this.formData.workTypeTimeDetail, null)
                        break
                      default:
                      this.$common.toast('系统错误', 'info', false)
                        break
                    }
                  } else {
                    this.$common.toast('申报工时为0，请修改,', 'info', false)
                  }
                  Promise.all(promises).then(() => {
                    getAssignProjectTotalWorkTime(this.aplID).then(totalWorkTime => {
                      let projectInfo = {
                        id: this.aplID,
                        userID: this.$store.state.userInfo.id,
                        projectType: this.assignProjectInfo.projectType,
                        projectName: this.projectName,
                        process: this.assignProjectInfo.process,
                        assignerID: this.assignProjectInfo.assignerID,
                        totalWorkTime: totalWorkTime[0].totalWorkTime,
                        isFilled: this.assignProjectInfo.isFilled,
                        projectLevel: this.assignProjectInfo.projectLevel,
                        reviewStatus: this.assignProjectInfo.reviewStatus,
                        obsoleteStatus: this.assignProjectInfo.obsoleteStatus
                      }
                      updateAssignProjectInfo(projectInfo).then(() => {
                        this.$common.toast('提交成功', 'success', false)
                        this.onCancel(formData)
                      })
                    })
                  }).catch(err => {
                    console.log(err)
                    this.$common.toast('提交失败', 'success', false)
                    this.onCancel(formData)
                  })
                } else {
                  this.$common.toast('备注字数过多，请删减', 'error', true)
                }
              } else {
                this.$common.toast(this.formData.title + '月已截止申报工时', 'error', true)
              }
            }).catch(err => {
              this.$common.toast(err, 'error', true)
            })
          }
        })
      },
      // // 暂存工时申报
      // onTemporaryWorkTime (formData) {
      //   this.$refs[formData].validate(valid => {
      //     if (valid) {
      //       getIsSubmitAllow().then(getIsSubmitAllowRes => {
      //         if (getIsSubmitAllowRes.length === 0 ||
      //             this.isRejectWorkTimeSubmit ||
      //             this.$store.state.userInfo.id === 26) {
      //           if (!this.isInputCommentsWordExceed) {
      //             let count = 0
      //             let promises = []
      //             let assignProjectDetail = {
      //               apdID: this.formData.workTypeTimeDetail[0].apdID,
      //               kValue: this.formData.workTypeTimeDetail[0].defaultKValue,
      //               coefficient: this.formData.workTypeTimeDetail[0].defaultCofficient,
      //               avaiableWorkTime: this.formData.workTypeTimeDetail[0].avaiableWorkTime,
      //               projectStageName: this.formData.workTypeTimeDetail[0].workType,
      //               applyBaseWorkTime: this.formData.workTypeTimeDetail[0].applyBaseWorkTime
      //             }
      //             promises[count++] = updateAssignProjectStageInfo(assignProjectDetail)
      //             let tableDataCopy = []
      //             let avaiableWorkTime = Number(this.formData.workTypeTimeDetail[0].avaiableWorkTime)
      //             let applyProcess = this.formData.workTypeTimeDetail[0].applyProcess
      //             if (avaiableWorkTime !== 0 && applyProcess !== 0) {
      //               tableDataCopy.push(this.formData.workTypeTimeDetail[0])
      //             }
      //             if (tableDataCopy.length !== 0) {
      //               promises[count++] = temporaryWorkTimeList(this.id, 'update', this.formData.title, this.formData.workTypeTimeDetail, null)
      //             } else {
      //               this.$common.toast('申报工时为0，请修改,', 'info', false)
      //             }
      //             Promise.all(promises).then(() => {
      //               this.$common.toast('提交成功', 'success', false)
      //               this.onCancel(formData)
      //             }).catch(err => {
      //               console.log(err)
      //               this.$common.toast('提交失败', 'success', false)
      //               this.onCancel(formData)
      //             })
      //           } else {
      //             this.$common.toast('备注字数过多，请删减', 'error', true)
      //           }
      //         } else {
      //           this.$common.toast(this.formData.title + '月已截止申报工时', 'error', true)
      //         }
      //       }).catch(err => {
      //         this.$common.toast(err, 'error', true)
      //       })
      //     }
      //   })
      // },
      // 取消
      onCancel (formName) {
        this.$router.push({ path: '/home/Performance' })
        this.$refs[formName].resetFields()
      },
      // 删除工时明细记录
      handleDeleteWorkDetail (row, index) {
        let deleteIndex = null
        this.formData.workTypeTimeDetail.splice(index, 1)
        for (let i = 0; i < this.formData.projectType.length; i++) {
          let arrayLen = this.formData.projectType[i].length
          if (this.formData.projectType[i][arrayLen - 1] === row.projectTypeID) {
            deleteIndex = i
            break
          }
        }
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
      },
      // 表格删除按钮
      handleDelete (row, index) {
        this.formData.workTypeTimeDetail.splice(index, 1)
        this.formData.projectType.splice(index, 1)
        this.showFlag.projectType = false
        this.refreshSelectProjectType()
      },
      // 备注输入名称监控
      inputCommentsChange (row) {
        row.inputCommentsWord = row.submitComments.length
        row.isInputCommentsWordExceed = row.inputCommentsWord > this.maxInputCommentsWord
        if (row.isInputCommentsWordExceed) {
          this.$common.toast('备注字数过多，请删减', 'error', false)
          this.isInputCommentsWordExceed = true
        } else {
          this.isInputCommentsWordExceed = false
        }
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
      this.id = this.$route.query.id
      this.aplID = this.$route.query.aplID
      this.init()
    },
    name: 'PerformanceEdit.vue'
  }
</script>

<style scoped>
</style>

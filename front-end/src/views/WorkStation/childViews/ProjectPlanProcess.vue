<template>
  <div style="margin: 15px">
    <div style="text-align: center">
      <el-row :gutter="10">
        <el-col :span="8" :offset="7">
          <h3 style="color: red;font-size: 25px">{{formData.yearNum + '年 '}}
            <span style="color: black;font-size: 20px">{{formData.projectName  + '计划&实际进展填报'}}</span></h3>
        </el-col>
        <el-col :span="1" :offset="1">
          <el-button style="margin-top: 17px" size="medium" type="warning" @click="genWorkTimePlanApply">生成项目计划</el-button>
        </el-col>
        <el-col :span="1" :offset="2">
          <el-button style="margin-top: 17px" size="medium" type="success" @click="genWorkTimeApply">生成工时申报</el-button>
        </el-col>
        <el-col :span="1" :offset="2">
          <el-button style="margin-top: 17px" size="medium" type="danger" @click="handleBack">返回</el-button>
        </el-col>
      </el-row>
    </div>
    <!-----------------------------------------------------主表格----------------------------------------------------------->
    <el-form ref="formData" :model="formData" :rules="formRules">
      <el-table v-loading="!reqFlag.getAssignProjectDetail"
                :data="formData.tableData"
                stripe
                border
                size="mini"
                resizable
                :span-method="objectSpanMethod"
                :height="tableMaxHeight">
        <el-table-column label="项目阶段" align="center" prop="projectStageName" fixed></el-table-column>
        <el-table-column label="标准工时" align="center" prop="baseWorkTime" width="50%"></el-table-column>
        <el-table-column label="K值" align="center" prop="kValue" width="50%"></el-table-column>
        <el-table-column label="类型" align="center" prop="type" width="50%">
          <template slot-scope="scope">
            <span>{{scope.row.type | processTypeFilter}}</span>
          </template>
        </el-table-column>
        <el-table-column label="项目进度" align="center">
          <el-table-column align="center" width="40%">
            <template slot="header">
              <span class="link-type" @click="handleDecYear">&lt;&lt;</span>
            </template>
          </el-table-column>
          <el-table-column label="1月" align="center" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.January" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.January}}</span>
              <span v-if="!scope.row.editable && scope.row.January !== null && scope.row.January !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="2月" align="center" prop="February" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.February" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.February}}</span>
              <span v-if="!scope.row.editable && scope.row.February !== null && scope.row.February !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="3月" align="center" prop="March" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.March" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.March}}</span>
              <span v-if="!scope.row.editable && scope.row.March !== null && scope.row.March !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="4月" align="center" prop="April" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.April" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.April}}</span>
              <span v-if="!scope.row.editable && scope.row.April !== null && scope.row.April !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="5月" align="center" prop="May" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.May" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.May}}</span>
              <span v-if="!scope.row.editable && scope.row.May !== null && scope.row.May !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="6月" align="center" prop="June" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.June" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.June}}</span>
              <span v-if="!scope.row.editable && scope.row.June !== null && scope.row.June !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="7月" align="center" prop="July" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.July" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.July}}</span>
              <span v-if="!scope.row.editable && scope.row.July !== null && scope.row.July !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="8月" align="center" prop="August" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.August" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.August}}</span>
              <span v-if="!scope.row.editable && scope.row.August !== null && scope.row.August !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="9月" align="center" prop="September" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.September" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.September}}</span>
              <span v-if="!scope.row.editable && scope.row.September !== null && scope.row.September !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="10月" align="center" prop="October" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.October" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.October}}</span>
              <span v-if="!scope.row.editable && scope.row.October !== null && scope.row.October !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="11月" align="center" prop="November" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.November" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.November}}</span>
              <span v-if="!scope.row.editable && scope.row.November !== null && scope.row.November !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="12月" align="center" prop="December" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model.number="scope.row.December" size="mini" type="number"></el-input>
              <span v-else>{{scope.row.December}}</span>
              <span v-if="!scope.row.editable && scope.row.December !== null && scope.row.December !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column align="center" width="40%">
            <template slot="header">
              <span class="link-type" @click="handleAddYear">&gt;&gt;</span>
            </template>
          </el-table-column>
        </el-table-column>
        <el-table-column label="操作" align="center" width="150" fixed="right">
          <template slot-scope="scope">
            <el-button v-if="!scope.row.editable"
                       size="mini"
                       type="primary"
                       @click="handleEdit(scope.row, scope.$index)">编辑</el-button>
            <div v-else>
              <el-button size="mini" type="warning" @click="handleSave(scope.row, scope.$index)">保存</el-button>
              <el-button size="mini" type="danger" @click="handleCancel(scope.row, scope.$index)">取消</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <br>
      <br>
    </el-form>
    <!-----------------------------------------------生成工时申报对话框---------------------------------------------------->
    <el-dialog :visible.sync="dialogFormVisible" width="65%" :title="formData.projectName + '工时预览'">
      <div>
        <el-form ref="dialogForm" :model="dialogForm" :rules="formRules" style="margin-top: -20px" :inline="true">
          <el-form-item label="申报月份" prop="title">
            <el-date-picker
              v-model="dialogForm.title"
              type="month"
              format="yyyy 第 MM 月"
              value-format="yyyy-MM"
              placeholder="选择月"
              :picker-options="pickerOptions"
              style="width: 150px" @change="handleApplyDateChange">
            </el-date-picker>
          </el-form-item>
          <el-form-item>
            <span style="margin-left: 20px;font-size: 15px">总工时：</span>
            <span style="color: red;font-weight: bolder;font-size: 20px">{{totalGetWorkTime}}</span>
          </el-form-item>
        </el-form>
      </div>
      <div>
        <el-table :data="submitParams.data" height="250">
          <el-table-column label="序号" align="center" type="index"></el-table-column>
          <el-table-column label="项目阶段" align="center" prop="projectStageName"></el-table-column>
          <el-table-column label="上月进展" align="center" prop="lastMonthProcess">
            <template slot-scope="scope">
              <span>{{scope.row.lastMonthProcess + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="本月进展" align="center" prop="applyMonthProcess">
            <template slot-scope="scope">
              <span>{{scope.row.applyMonthProcess + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="预计可获得工时" align="center" prop="avaiableWorkTime"></el-table-column>
          <el-table-column label="备注" align="center">
            <template slot-scope="scope">
              <el-input size="mini" v-model="scope.row.submitComments"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="工时分配" align="center">
            <template slot-scope="scope">
              <span class="link-type" @click="handleWorkTimeAssign(scope.row, scope.$index)">点击分配</span>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary" @click="handleWorkTimeApply('dialogForm')">生成</el-button>
      </div>
      <Assign v-if="showFlag.workTimeAssign" ref="workTimeAssign" @assignDetail="handleAssign"/>
    </el-dialog>
    <!-----------------------------------------------生成项目计划对话框---------------------------------------------------->
    <el-dialog :visible.sync="dialogPlanFormVisible" width="65%" :title="formData.projectName + '项目计划'">
      <div>
        <el-form ref="dialogForm" :model="dialogForm" :rules="formRules" style="margin-top: -20px" :inline="true">
          <el-form-item label="申报月份" prop="title">
            <el-date-picker
              v-model="dialogForm.title"
              type="month"
              format="yyyy 第 MM 月"
              value-format="yyyy-MM"
              placeholder="选择月"
              :picker-options="pickerOptions"
              style="width: 150px" @change="handleApplyPlanDateChange">
            </el-date-picker>
          </el-form-item>
          <el-form-item>
            <span style="margin-left: 20px;font-size: 15px">总预计工时：</span>
            <span style="color: red;font-weight: bolder;font-size: 20px">{{totalGetWorkTime}}</span>
          </el-form-item>
        </el-form>
      </div>
      <div>
        <el-table :data="submitParams.data" height="250">
          <el-table-column label="序号" align="center" type="index"></el-table-column>
          <el-table-column label="项目阶段" align="center" prop="projectStageName"></el-table-column>
          <el-table-column label="计划进展" align="center">
            <template slot-scope="scope">
              <span>{{scope.row.applyMonthProcess + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="预计可获得工时" align="center" prop="avaiableWorkTime"></el-table-column>
          <el-table-column label="备注" align="center">
            <template slot-scope="scope">
              <el-input size="mini" v-model="scope.row.submitComments"></el-input>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary" @click="handleWorkTimePlanApply('dialogForm')">提交计划</el-button>
      </div>
      <Assign v-if="showFlag.workTimeAssign" ref="workTimeAssign" @assignDetail="handleAssign"/>
    </el-dialog>
  </div>
</template>

<script>
  import {
    getAssignProjectDetail,
    getMonthProcessDiff,
    submitPlanProcess,
    updateAssignProjectFilled,
    workTimeTemporary,
    workTimeSubmit
  } from '@/config/interface'
  import Assign from '@/components/Cop/workTimeAssign'

  export default {
      data () {
        return {
          formData: {
            title: this.$moment().format('YYYY-MM'),
            showFlag: false,
            tableData: [],
            tableDataCache: [],
            projectType: '',
            projectName: '',
            destroy: true,
            yearNum: this.$moment().year(),
            pickerOptions: {
              disabledDate (time) {
                return time.getTime() > Date.now()
              }
            },
            isShowTable: true
          },
          formRules: {
            January: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            February: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            March: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            April: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            May: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            June: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            July: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            August: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            September: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            October: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            November: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            December: [
              { required: false },
              { type: 'number', message: '范围0-100', trigger: 'blur', min: 0, max: 100 }
            ],
            title: [
              { required: true, message: '请选择申报月份', trigger: 'change' }
            ]
          },
          dialogForm: {
            title: this.$moment().subtract(1, 'months').format('YYYY-MM')
          },
          reqFlag: {
            getAssignProjectDetail: true,
            savePlanProcess: true
          },
          dialogFormVisible: false,
          dialogPlanFormVisible: false,
          pickerOptions: {
            // disabledDate (time) {
            //   return time.getTime() > Date.now()
            // }
          },
          applyMonthPlanProcess: [],
          applyMonthPlanProcessTableData: [],
          submitParams: {},
          showFlag: {
            workTimeAssign: false
          }
        }
      },
      methods: {
        // 初始化
        init () {
          this.formData.projectType = this.$route.query.projectType
          this.formData.projectName = this.$route.query.projectName
          this.getAssignProjectDetail(this.$route.query.projectID)
        },
        // 获取申报月份进展数据
        getMonthProcess (type) {
          let it = this
          return new Promise(function (resolve, reject) {
            let applyMonth = it.$moment(it.dialogForm.title).toObject()
            let lastMonth = it.$moment(it.dialogForm.title).subtract(1, 'months').toObject()
            let applyYear = it.$moment(it.dialogForm.title).toObject().years
            let lastYear = it.$moment(it.dialogForm.title).subtract(1, 'months').toObject().years
            let applyMonthString = it.$common.MonthToString(String(applyMonth.months + 1))
            let lastMonthString = it.$common.MonthToString(String(lastMonth.months + 1))
            let url = getMonthProcessDiff
            let searchData = []
            for (let item of it.applyMonthPlanProcess) {
              if (type === 'fact') {
                if (item.isFinish !== 1 && item.type === 'fact' && item[applyMonthString] !== null) {
                  searchData.push(item)
                }
              } else if (type === 'plan') {
                if (item.isFinish !== 1 && item.type === 'plan' && item[applyMonthString] !== null) {
                  searchData.push(item)
                }
              }
            }
            it.applyMonthPlanProcessTableData = []
            if (searchData.length === 0) {
              it.$common.toast('该月份项目无计划/实际进展', 'error', 'true')
              resolve([])
            } else {
              let params = {
                applyMonth: applyMonthString,
                applyYear: applyYear,
                lastMonth: lastMonthString,
                lastYear: lastYear,
                data: searchData,
                type: type
              }
              it.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    params = {
                      submitType: 'insert',
                      submitDate: it.dialogForm.title,
                      applyType: '',
                      data: []
                    }
                    if (type === 'fact') {
                      params.applyType = 'fact'
                    } else if (type === 'plan') {
                      params.applyType = 'plan'
                    }
                    for (let item of res.data) {
                      let applyMonthProcess = item.processDiff.applyMonthProcess
                      let lastMonthProcess = item.processDiff.lastMonthProcess
                      let obj = {
                        projectTypeID: item.projectStage,
                        projectName: item.projectName,
                        workType: item.projectStage,
                        baseWorkTime: item.baseWorkTime,
                        defaultKValue: item.kValue,
                        dynamicKValue: item.sendParams.dynamicKValue,
                        defaultCofficient: item.coefficient,
                        workTimeAssign: [],
                        submitComments: '',
                        multipleAssign: false,
                        multipleSelect: [],
                        avaiableWorkTime: 0,
                        isConference: item.sendParams.isConference,
                        defaultAssignWorkTime: item.sendParams.defaultAssignWorkTime,
                        projectStage: item.sendParams.projectStage,
                        applyMonthProcess: applyMonthProcess,
                        lastMonthProcess: lastMonthProcess,
                        processDiff: applyMonthProcess - lastMonthProcess,
                        applyProcess: applyMonthProcess,
                        lastProcess: lastMonthProcess,
                        apdID: item.sendParams.aPDID,
                        aplID: item.aplID,
                        monthID: item.sendParams.id,
                        projectStageName: item.projectStageName
                      }
                      obj.avaiableWorkTime = obj.baseWorkTime * obj.defaultKValue * obj.defaultCofficient *
                        (applyMonthProcess - lastMonthProcess) * 0.01
                      obj.avaiableWorkTime = Number(Number(obj.avaiableWorkTime).toFixed(1))
                      let defaultCurrentUserWorkTime = {
                        id: it.$store.state.userInfo.id,
                        groupName: it.$store.state.userInfo.groupName,
                        name: it.$store.state.userInfo.name,
                        applyRole: '组织者',
                        assignWorkTime: obj.avaiableWorkTime,
                        deleteAble: false
                      }
                      obj.workTimeAssign.push(defaultCurrentUserWorkTime)
                      params.data.push(obj)
                      it.applyMonthPlanProcessTableData.push(obj)
                    }
                    resolve(params)
                  }
                })
            }
          })
        },
        // 提交工时申报
        handleWorkTimeApply (formData) {
          this.$refs[formData].validate((valid) => {
            if (valid) {
              let url = workTimeSubmit
              this.$http(url, this.submitParams)
                .then(res => {
                  if (res.code === 1) {
                    url = updateAssignProjectFilled
                    let params = {
                      assignProjectID: this.$route.query.projectID
                    }
                    this.$http(url, params)
                      .then(() => {
                        this.$common.toast('生成成功', 'success', 'false')
                        this.$router.push({ path: '/home/workStation' })
                        this.dialogFormVisible = false
                      })
                  }
                })
            }
          })
        },
        // 提交项目计划申报
        handleWorkTimePlanApply (formData) {
          this.$refs[formData].validate((valid) => {
            if (valid) {
              let url = workTimeSubmit
              this.$http(url, this.submitParams)
                .then(res => {
                  if (res.code === 1) {
                    url = updateAssignProjectFilled
                    let params = {
                      assignProjectID: this.$route.query.projectID
                    }
                    this.$http(url, params)
                      .then(() => {
                        this.$common.toast('生成成功', 'success', 'false')
                        this.$router.push({ path: '/home/workStation' })
                        this.dialogFormVisible = false
                      })
                  }
                })
            }
          })
        },
        // 生成工时申报
        genWorkTimeApply () {
          let year = this.$moment(this.dialogForm.title).format('YYYY')
          this.httpGetAssignProjectDetail(this.$route.query.projectID, year).then(res => {
            this.dialogFormVisible = true
            this.applyMonthPlanProcess = res
            this.getMonthProcess('fact').then(res1 => {
              this.submitParams = res1
            })
          })
        },
        // 生成项目计划
        genWorkTimePlanApply () {
          let year = this.$moment(this.dialogForm.title).format('YYYY')
          this.httpGetAssignProjectDetail(this.$route.query.projectID, year).then(res => {
            this.dialogPlanFormVisible = true
            this.applyMonthPlanProcess = res
            this.getMonthProcess('plan').then(res1 => {
              this.submitParams = res1
            })
          })
        },
        // 返回上一级
        handleBack () {
          this.$router.push({ path: '/home/workStation' })
        },
        // 上一年度进展
        handleDecYear () {
          if (this.reqFlag.getAssignProjectDetail) {
            this.formData.yearNum -= 1
            this.getAssignProjectDetail(this.$route.query.projectID)
          }
        },
        // 下一年度进展
        handleAddYear () {
          if (this.reqFlag.getAssignProjectDetail) {
            this.formData.yearNum += 1
            this.getAssignProjectDetail(this.$route.query.projectID)
          }
        },
        // 获取指派项目计划&进展明细操作
        httpGetAssignProjectDetail (id, yearNum) {
          let it = this
          return new Promise(function (resolve, reject) {
            if (it.reqFlag.getAssignProjectDetail) {
              it.reqFlag.getAssignProjectDetail = false
              const url = getAssignProjectDetail
              let params = {
                id: id,
                year: yearNum
              }
              it.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    it.reqFlag.getAssignProjectDetail = true
                    resolve(res.data)
                  }
                })
            }
          })
        },
        // 获取指派项目计划&进展明细
        getAssignProjectDetail (id) {
          let it = this
          this.httpGetAssignProjectDetail(id, this.formData.yearNum)
            .then(res => {
              for (let item of res) {
                item.editable = false
              }
              it.formData.tableData = res
              it.formData.tableDataCache = JSON.parse(JSON.stringify(it.formData.tableData))
            })
        },
        // 表格编辑按钮
        handleEdit (row, index) {
          row.editable = true
        },
        // 表格保存按钮
        handleSave (row, index) {
          const url = submitPlanProcess
          for (let item in row) {
            if (row[item] === '') {
              row[item] = null
            }
          }
          let params = row
          if (this.reqFlag.savePlanProcess) {
            this.reqFlag.savePlanProcess = false
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  let data = res.data
                  row.monthID = data.monthID
                  this.getAssignProjectDetail(this.$route.query.projectID)
                  this.reqFlag.savePlanProcess = true
                  this.$common.toast('保存成功', 'success', 'false')
                }
              })
          }
          row.editable = false
          for (let item in row) {
            this.formData.tableDataCache[index][item] = row[item]
          }
        },
        // 取消按钮
        handleCancel (row, index) {
          for (let item in this.formData.tableDataCache[index]) {
            row[item] = this.formData.tableDataCache[index][item]
          }
          row.editable = false
        },
        // 表格列合并方法
        objectSpanMethod ({ row, column, rowIndex, columnIndex }) {
          if (columnIndex === 0 || columnIndex === 1 || columnIndex === 2) {
            if (rowIndex % 2 === 0) {
              return {
                rowspan: 2,
                colspan: 1
              }
            } else {
              return {
                rowspan: 0,
                colspan: 0
              }
            }
          }
        },
        // 申报月份变化处理
        handleApplyDateChange () {
          this.genWorkTimeApply()
        },
        // 生成计划月份变化处理
        handleApplyPlanDateChange () {
          this.genWorkTimePlanApply()
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
          this.submitParams.data[params.index].workTimeAssign = params.workTimeAssignDetail
          this.submitParams.data[params.index].multipleAssign = params.multipleAssign
          this.submitParams.data[params.index].multipleSelect = params.multipleSelect
        }
      },
      computed: {
        tableMaxHeight () {
          return window.innerHeight - 150 + 'px'
        },
        totalGetWorkTime () {
          let total = 0
          for (let item of this.applyMonthPlanProcessTableData) {
            total += item.avaiableWorkTime
          }
          return total
        }
      },
      components: {
        Assign
      },
      filters: {
        processTypeFilter (type) {
          switch (type) {
            case 'plan':
              return '计划'
            case 'fact':
              return '实际'
            default:
              return '错误'
          }
        }
      },
      created () {
        this.init()
      },
      destroyed () {
      },
      name: 'ProjectPlanProcess'
    }
</script>

<style scoped>
</style>

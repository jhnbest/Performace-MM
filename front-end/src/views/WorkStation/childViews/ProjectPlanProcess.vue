<template>
  <div style="margin: 15px">
    <div style="text-align: center">
      <el-row align="middle" type="flex">
        <el-col :xs="1" :sm="1" :lg="1" :xl="{span: 1, push: 0}">
          <el-button icon="el-icon-minus"
                     circle
                     size="mini"
                     type="danger"
                     @click="handleDecYear"
                     :disabled="!this.reqFlag.getAssignProjectDetail"></el-button>
        </el-col>
        <el-col :span="1.5">
          <span style="font-size: 25px;color: red;font-weight: bolder">{{ formData.yearNum + '年' }}</span>
        </el-col>
        <el-col :xs="1" :sm="1" :lg="1" :xl="1">
          <el-button icon="el-icon-plus"
                     circle
                     size="mini"
                     type="primary"
                     @click="handleAddYear"
                     :disabled="!this.reqFlag.getAssignProjectDetail"></el-button>
        </el-col>
        <el-col :xs="9" :sm="9" :lg="{span: 9, offset: 2}" :xl="{span: 10, offset: 2}">
          <span style="font-size: 22px">{{formData.projectName  + '计划&实际进展填报'}}</span>
        </el-col>
        <el-col :xs="3" :sm="3" :lg="{span: 3, offset: 1}" :xl="{span: 2, offset: 3}">
          <el-button size="medium" type="warning" @click="genWorkTimePlanApply">生成项目计划</el-button>
        </el-col>
        <el-col :xs="3" :sm="3" :lg="{span: 3}" :xl="{span: 2}">
          <el-button size="medium" type="primary" @click="genWorkTimeApply">生成工时申报</el-button>
        </el-col>
        <el-col :xs="1" :sm="1" :lg="{span: 1}" :xl="{span: 1}">
          <el-button size="medium" type="danger" @click="handleBack">返回</el-button>
        </el-col>
      </el-row>
    </div>
    <br>
    <!-----------------------------------------------------主表格----------------------------------------------------------->
    <el-form ref="formData" :model="formData" :rules="formRules">
      <el-table v-loading="!reqFlag.getAssignProjectDetail"
                :data="formData.tableData"
                stripe
                border
                size="mini"
                resizable
                :span-method="objectSpanMethod"
                :height="tableHeight"
                ref="rateTable">
        <el-table-column label="项目阶段" align="center" prop="projectStageName" fixed></el-table-column>
        <el-table-column label="标准工时" align="center" prop="baseWorkTime" width="50%"></el-table-column>
        <el-table-column label="K值" align="center" prop="kValue" width="50%"></el-table-column>
        <el-table-column label="类型" align="center" prop="type" width="50%">
          <template slot-scope="scope">
            <span>{{scope.row.type | processTypeFilter}}</span>
          </template>
        </el-table-column>
        <el-table-column label="项目进度" align="center">
          <el-table-column label="1月" align="center" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.January"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'January')"></el-input>
              <span v-else>{{scope.row.January}}</span>
              <span v-if="!scope.row.editable && scope.row.January !== null && scope.row.January !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="2月" align="center" prop="February" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.February"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'February')"></el-input>
              <span v-else>{{scope.row.February}}</span>
              <span v-if="!scope.row.editable && scope.row.February !== null && scope.row.February !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="3月" align="center" prop="March" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.March"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'March')"></el-input>
              <span v-else>{{scope.row.March}}</span>
              <span v-if="!scope.row.editable && scope.row.March !== null && scope.row.March !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="4月" align="center" prop="April" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.April"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'April')"></el-input>
              <span v-else>{{scope.row.April}}</span>
              <span v-if="!scope.row.editable && scope.row.April !== null && scope.row.April !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="5月" align="center" prop="May" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.May"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'May')"></el-input>
              <span v-else>{{scope.row.May}}</span>
              <span v-if="!scope.row.editable && scope.row.May !== null && scope.row.May !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="6月" align="center" prop="June" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.June"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'June')"></el-input>
              <span v-else>{{scope.row.June}}</span>
              <span v-if="!scope.row.editable && scope.row.June !== null && scope.row.June !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="7月" align="center" prop="July" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.July"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'July')"></el-input>
              <span v-else>{{scope.row.July}}</span>
              <span v-if="!scope.row.editable && scope.row.July !== null && scope.row.July !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="8月" align="center" prop="August" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.August"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'August')"></el-input>
              <span v-else>{{scope.row.August}}</span>
              <span v-if="!scope.row.editable && scope.row.August !== null && scope.row.August !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="9月" align="center" prop="September" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.September"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'September')"></el-input>
              <span v-else>{{scope.row.September}}</span>
              <span v-if="!scope.row.editable && scope.row.September !== null && scope.row.September !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="10月" align="center" prop="October" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.October"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'October')"></el-input>
              <span v-else>{{scope.row.October}}</span>
              <span v-if="!scope.row.editable && scope.row.October !== null && scope.row.October !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="11月" align="center" prop="November" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.November"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'November')"></el-input>
              <span v-else>{{scope.row.November}}</span>
              <span v-if="!scope.row.editable && scope.row.November !== null && scope.row.November !== ''">%</span>
            </template>
          </el-table-column>
          <el-table-column label="12月" align="center" prop="December" width="73%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable"
                        v-model.number="scope.row.December"
                        size="mini"
                        type="number"
                        :disabled="monthIsEditable(scope.row, 'December')"></el-input>
              <span v-else>{{scope.row.December}}</span>
              <span v-if="!scope.row.editable && scope.row.December !== null && scope.row.December !== ''">%</span>
            </template>
          </el-table-column>
        </el-table-column>
        <el-table-column label="操作" align="center" width="150" fixed="right">
          <template slot-scope="scope">
            <el-button v-if="!scope.row.editable"
                       size="mini"
                       :type="scope.row.process === 100.0 ? 'info' : (scope.row.type === 'fact' ? 'primary' : 'warning')"
                       @click="handleEdit(scope.row, scope.$index)"
                       :disabled="scope.row.process === 100.0">
              <div v-if="scope.row.process !== 100.0">
                <span v-if="scope.row.type === 'plan'">编辑计划进展</span>
                <span v-if="scope.row.type === 'fact'">编辑实际进展</span></div>
              <span v-else>该阶段已完成</span>
            </el-button>
            <div v-if="scope.row.editable && scope.row.process !== 100">
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
    <el-dialog :visible.sync="dialogFormVisible"
               width="65%"
               :title="formData.projectName + '工时预览'">
      <div>
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
          <el-table :data="submitParams.data">
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
            <el-table-column label="工时申报状态" align="center">
              <template slot-scope="scope">
                <el-popover
                  title="已申报工时信息"
                  placement="right"
                  trigger="click">
                  <el-table :data="scope.row.submitedData">
                    <el-table-column label="项目阶段" align="center" prop="projectStageName"></el-table-column>
                    <el-table-column label="上月进展" align="center">
                      <template slot-scope="scope">
                        <span>{{scope.row.lastProcess + '%'}}</span>
                      </template>
                    </el-table-column>
                    <el-table-column label="本月进展" align="center" prop="applyProcess">
                      <template slot-scope="scope">
                        <span>{{scope.row.applyProcess + '%'}}</span>
                      </template>
                    </el-table-column>
                    <el-table-column label="预计可获得工时" align="center" prop="avaiableWorkTime"></el-table-column>
                    <el-table-column label="工时分配" align="center">
                      <template slot-scope="scope">
                        <span class="link-type" @click="handleSubmitedWorkTimeAssignCheck(scope.row)">点击查看</span>
                      </template>
                    </el-table-column>
                  </el-table>
                  <el-tag v-if="scope.row.isApplyWorkTime > 0"
                          type="danger"
                          slot="reference"
                          style="cursor: pointer" @click="handleSubmitedClick(scope.row)">当月已申报</el-tag>
                </el-popover>
                <br v-if="scope.row.isApplyWorkTime > 0">
                <span v-if="scope.row.isApplyWorkTime > 0">替换：</span>
                <el-switch v-if="scope.row.isApplyWorkTime > 0"></el-switch>
                <el-tag v-if="scope.row.isApplyWorkTime === 0" type="primary">当月未申报</el-tag>
              </template>
            </el-table-column>
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
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary"
                   @click="handleWorkTimeApply('dialogForm')"
                   :disabled="!reqFlag.genWorkTimeApply">生成</el-button>
      </div>
      <Assign v-if="showFlag.workTimeAssign" ref="workTimeAssign" @assignDetail="handleAssign"/>
    </el-dialog>
    <Cop v-if="showFlag.cop" ref="cop"/>
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
        <el-table :data="submitParams.data">
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
    workTimeSubmit,
    getIsSubmitAllow,
    getCurApplyAbleMonth,
    projectDetailIsApplyWorkTime,
    submitProjectWorkTimeApply
  } from '@/config/interface'
  import Assign from '@/components/Cop/workTimeAssign'
  import Cop from '@/components/Cop/Cop'
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
            savePlanProcess: true,
            genWorkTimeApply: true
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
            workTimeAssign: false,
            cop: false
          },
          tableHeight: null,
          curApplyMonth: null
        }
      },
      methods: {
        // 初始化
        init () {
          this.formData.projectType = this.$route.query.projectType
          this.formData.projectName = this.$route.query.projectName
          this.getAssignProjectDetail(this.$route.query.projectID)
          this.getCurApplyAbleMonth().then(getCurApplyAbleMonthRes => {
            this.curApplyMonth = this.$moment(getCurApplyAbleMonthRes[0]).format('YYYY-MM')
          })
        },
        // 临时填充2021-01月份的进展
        fillProcessOfJanuary (year, projectStageDetail) {
          let count = 0
          if (year === 2021) {
            for (let projectStageDetailItem of projectStageDetail) {
              if (projectStageDetailItem.type === 'fact') {
                if (projectStageDetailItem.January === null &&
                  projectStageDetailItem.process !== 0 &&
                  projectStageDetailItem.process !== 100.0) {
                  // this.$common.toast(projectStageDetailItem.projectStageName + '2021-01月份未填报进度，已设置为2020-12月份进度', 'warning', true)
                  projectStageDetailItem.January = projectStageDetailItem.process
                  this.handleSaveTmp(projectStageDetailItem, count)
                }
              }
              count++
            }
          }
        },
        // 获取当前月份能否申报的标志
        getIsSubmitAllow () {
          const url = getIsSubmitAllow
          let params = {
            applyYear: this.$moment(this.dialogForm.title).year(),
            applyMonth: this.$moment(this.dialogForm.title).month() + 1,
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
        // 提交工时申报
        handleWorkTimeApply (formData) {
          this.$refs[formData].validate((valid) => {
            if (valid) {
              this.getIsSubmitAllow().then(getIsSubmitAllowRes => {
                if (getIsSubmitAllowRes.length === 0 || this.$store.state.userInfo.id === 26) {
                  let url = submitProjectWorkTimeApply
                  let params = {
                    workTimeInfo: this.submitParams,
                    projectID: Number(this.$route.query.projectID)
                  }
                  let _this = this
                  // for (let i = 0; i < this.submitParams.data.length; i++) { // 删除当月已经申报工时
                  //   if (this.submitParams.data[i].isApplyWorkTime > 0) {
                  //     console.log('this.submitParams.data')
                  //     console.log(this.submitParams.data)
                  //   }
                  // }
                  return new Promise(function (resolve, reject) {
                    if (_this.reqFlag.genWorkTimeApply) {
                      _this.reqFlag.genWorkTimeApply = false
                      _this.$http(url, params).then(res => {
                        if (res.code === 1) {
                          _this.$common.toast('生成成功', 'success', false)
                          _this.$router.push({ path: '/home/workStation' })
                          _this.dialogFormVisible = false
                          // url = updateAssignProjectFilled
                          // let params = {
                          //   assignProjectID: _this.$route.query.projectID
                          // }
                          // _this.$http(url, params).then((res) => {
                          //   if (res.code === 1) {
                          //     _this.$common.toast('生成成功', 'success', false)
                          //     _this.$router.push({ path: '/home/workStation' })
                          //     _this.dialogFormVisible = false
                          //     resolve(res.code)
                          //   } else {
                          //     this.$common.toast('生成失败', 'error', false)
                          //     reject(res.code)
                          //   }
                          //   _this.reqFlag.genWorkTimeApply = true
                          // })
                        } else {
                          this.$common.toast('生成失败', 'error', false)
                          reject(res.code)
                        }
                      })
                    }
                  })
                } else {
                  this.$common.toast(this.dialogForm.title + '月已截止申报工时', 'error', true)
                }
              }).catch(err => {
                this.$common.toast(err, 'error', true)
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
                        this.$common.toast('生成成功', 'success', false)
                        this.$router.push({ path: '/home/workStation' })
                        this.dialogFormVisible = false
                      })
                  }
                })
            }
          })
        },
        // 查看项目阶段当月是否已填报工时
        projectDetailIsApplyWorkTime (searchData, type) {
          const url = projectDetailIsApplyWorkTime
          let params = {
            projectDetailID: [],
            applyMonth: this.dialogForm.title,
            type: type
          }
          for (let searchDataItem of searchData) {
            params.projectDetailID.push(searchDataItem.apdID)
          }
          let _this = this
          return new Promise(function (resolve, reject) {
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                resolve(res.data)
              } else {
                reject(new Error('projectDetailIsApplyWorkTime recv error!'))
              }
            }).catch(err => {
              reject(new Error('projectDetailIsApplyWorkTime send error!' + err))
            })
          })
        },
        // 生成工时申报
        genWorkTimeApply () {
          let year = this.$moment(this.dialogForm.title).format('YYYY')
          let promises = []
          let count = 0
          this.httpGetAssignProjectDetail(this.$route.query.projectID, year).then(res => { // 获取项目的所有阶段信息
            this.dialogFormVisible = true
            this.applyMonthPlanProcess = res
            let searchData = []
            let applyMonth = this.$moment(this.dialogForm.title).toObject()
            let applyMonthString = this.$common.MonthToString(String(applyMonth.months + 1))
            for (let item of this.applyMonthPlanProcess) {
              if (item.isFinish !== 1 && item.type === 'fact' && item[applyMonthString] !== null) {
                searchData.push(item)
              }
            }
            if (searchData.length === 0) {
              this.reqFlag.genWorkTimeApply = false
              this.submitParams = []
              this.applyMonthPlanProcessTableData = []
              this.$common.toast(this.dialogForm.title + '月份未填报实际进展', 'error', 'true')
            } else {
              promises[count++] = this.projectDetailIsApplyWorkTime(searchData, 'fact')
              promises[count++] = this.getMonthProcess('fact', searchData)
              Promise.all(promises).then(result => {
                let submitParamsTmp = result[1]
                for (let i = 0; i < result[0].length; i++) {
                  if (result[0][i].length > 0) {
                    if (result[0][i][0].applyProcess !== submitParamsTmp.data[i].applyMonthProcess) { // 现申报进展与已申报进展不等
                      submitParamsTmp.data[i].isApplyWorkTime = result[0][i].length
                      submitParamsTmp.data[i].id = []
                      submitParamsTmp.data[i].submitedData = []
                      for (let resultItem of result[0][i]) {
                        submitParamsTmp.data[i].id.push(resultItem.id)
                        resultItem.projectStageName = ''
                        submitParamsTmp.data[i].submitedData.push(resultItem)
                      }
                    } else {
                      submitParamsTmp.data[i] = []
                    }
                  } else {
                    submitParamsTmp.data[i].isApplyWorkTime = result[0][i].length
                    submitParamsTmp.data[i].id = null
                  }
                }
                console.log('submitParamsTmp')
                console.log(submitParamsTmp)
                // this.applyMonthPlanProcessTableData = result[1].data
                this.submitParams = result[1]
              })
            }
          })
        },
        // 生成项目计划
        genWorkTimePlanApply () {
          let year = this.$moment(this.dialogForm.title).format('YYYY')
          let promises = []
          let count = 0
          this.httpGetAssignProjectDetail(this.$route.query.projectID, year).then(res => {
            this.dialogPlanFormVisible = true
            this.applyMonthPlanProcess = res
            let searchData = []
            let applyMonth = this.$moment(this.dialogForm.title).toObject()
            let applyMonthString = this.$common.MonthToString(String(applyMonth.months + 1))
            for (let item of this.applyMonthPlanProcess) {
              if (item.isFinish !== 1 && item.type === 'plan' && item[applyMonthString] !== null) {
                searchData.push(item)
              }
            }
            if (searchData.length === 0) {
              this.reqFlag.genWorkTimeApply = false
              this.submitParams = []
              this.applyMonthPlanProcessTableData = []
              this.$common.toast(this.dialogForm.title + '月份未填报计划进展', 'error', 'true')
            } else {
              promises[count++] = this.projectDetailIsApplyWorkTime(searchData, 'plan')
              promises[count++] = this.getMonthProcess('plan', searchData)
              Promise.all(promises).then(result => {
                this.applyMonthPlanProcessTableData = result[1].data
                this.submitParams = result[1]
                for (let i = 0; i < result[0].length; i++) {
                  if (result[0][i].length > 0) {
                    this.submitParams.data[i].id = []
                    for (let resultItem of result[0][i]) {
                      this.submitParams.data[i].id.push(resultItem.id)
                    }
                  } else {
                    this.submitParams.data[i].id = null
                  }
                }
              })
            }
          })
        },
        // 获取申报月份进展数据
        getMonthProcess (type, searchData) {
          let _this = this
          return new Promise(function (resolve, reject) {
            let applyMonth = _this.$moment(_this.dialogForm.title).toObject()
            let lastMonth = _this.$moment(_this.dialogForm.title).subtract(1, 'months').toObject()
            let applyYear = _this.$moment(_this.dialogForm.title).toObject().years
            let lastYear = _this.$moment(_this.dialogForm.title).subtract(1, 'months').toObject().years
            let applyMonthString = _this.$common.MonthToString(String(applyMonth.months + 1))
            let lastMonthString = _this.$common.MonthToString(String(lastMonth.months + 1))
            let url = getMonthProcessDiff
            _this.reqFlag.genWorkTimeApply = true
            let params = {
              applyMonth: applyMonthString,
              applyYear: applyYear,
              lastMonth: lastMonthString,
              lastYear: lastYear,
              data: searchData,
              type: type
            }
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                params = {
                  submitType: 'insert',
                  submitDate: _this.dialogForm.title,
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
                    projectStageName: item.projectStageName,
                    isApplyWorkTime: null
                  }
                  obj.avaiableWorkTime = Number(Number(obj.baseWorkTime * obj.defaultKValue * obj.defaultCofficient *
                    (applyMonthProcess - lastMonthProcess) * 0.01).toFixed(1))
                  let defaultCurrentUserWorkTime = {
                    id: _this.$store.state.userInfo.id,
                    groupName: _this.$store.state.userInfo.groupName,
                    name: _this.$store.state.userInfo.name,
                    applyRole: '组织者',
                    assignWorkTime: obj.avaiableWorkTime,
                    deleteAble: false
                  }
                  obj.workTimeAssign.push(defaultCurrentUserWorkTime)
                  params.data.push(obj)
                }
                resolve(params)
              }
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
          let _this = this
          return new Promise(function (resolve, reject) {
            if (_this.reqFlag.getAssignProjectDetail) {
              _this.reqFlag.getAssignProjectDetail = false
              const url = getAssignProjectDetail
              let params = {
                id: id,
                year: yearNum
              }
              _this.$http(url, params).then(res => {
                if (res.code === 1) {
                  _this.reqFlag.getAssignProjectDetail = true
                  resolve(res.data)
                }
              })
            }
          })
        },
        // 获取指派项目计划&进展明细
        getAssignProjectDetail (id) {
          this.httpGetAssignProjectDetail(id, this.formData.yearNum).then(res => {
            for (let item of res) {
              item.editable = false
            }
            this.formData.tableData = res
            this.formData.tableDataCache = JSON.parse(JSON.stringify(this.formData.tableData))
            this.fillProcessOfJanuary(this.formData.yearNum, res)
            console.log('this.formData.tableData')
            console.log(this.formData.tableData)
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
            this.$http(url, params).then(res => {
              if (res.code === 1) {
                let data = res.data
                row.monthID = data.monthID
                this.getAssignProjectDetail(this.$route.query.projectID)
                this.reqFlag.savePlanProcess = true
                this.$common.toast('保存成功', 'success', false)
              }
            })
          }
          row.editable = false
          for (let item in row) {
            this.formData.tableDataCache[index][item] = row[item]
          }
        },
        // 表格保存按钮临时
        handleSaveTmp (row, index) {
          const url = submitPlanProcess
          for (let item in row) {
            if (row[item] === '') {
              row[item] = null
            }
          }
          let params = row
          if (this.reqFlag.savePlanProcess) {
            this.reqFlag.savePlanProcess = false
            this.$http(url, params).then(res => {
              if (res.code === 1) {
                let data = res.data
                row.monthID = data.monthID
                this.getAssignProjectDetail(this.$route.query.projectID)
                this.reqFlag.savePlanProcess = true
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
        },
        // 刷新表格尺寸
        refreshTableSize () {
          this.$nextTick(() => {
            this.tableHeight = window.innerHeight - this.$refs.rateTable.$el.offsetTop - 5
            if (this.tableHeight < 0) {
              this.tableHeight = window.innerHeight - 100
            }
            let _this = this
            window.onresize = function () {
              _this.tableHeight = window.innerHeight - _this.$refs.rateTable.$el.offsetTop - 5
              if (_this.tableHeight < 0) {
                _this.tableHeight = window.innerHeight - 100
              }
            }
          })
        },
        // 获取当前可申报的月份
        getCurApplyAbleMonth () {
          const url = getCurApplyAbleMonth
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
        // 月份是否可编辑进度
        monthIsEditable (row, month) {
          if (row.type === 'plan') {
            return false
          } else if (row.type === 'fact') {
            return this.$moment(this.formData.yearNum + '-' + this.$common.mStringToNumber(month)).isBefore(this.curApplyMonth) ||
              this.$moment(this.formData.yearNum + '-' + this.$common.mStringToNumber(month)).isAfter(this.curApplyMonth)
          }
        },
        // 当月已申报点击事件
        handleSubmitedClick (row) {
          for (let item of row.submitedData) {
            item.projectStageName = row.projectStageName
          }
        },
        // 已申报的工时分配情况
        handleSubmitedWorkTimeAssignCheck (row) {
          this.showFlag.cop = true
          this.$nextTick(() => {
            this.$refs.cop.init(row)
          })
        }
      },
      computed: {
        tableMaxHeight () {
          return window.innerHeight - 160 + 'px'
        },
        totalGetWorkTime () {
          let total = 0
          for (let item of this.applyMonthPlanProcessTableData) {
            total += item.avaiableWorkTime
          }
          total = Number(total.toFixed(2))
          return total
        }
      },
      components: {
        Assign,
        Cop
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
      mounted () {
        this.refreshTableSize()
      },
      destroyed () {
      },
      name: 'ProjectPlanProcess'
    }
</script>

<style scoped>
</style>

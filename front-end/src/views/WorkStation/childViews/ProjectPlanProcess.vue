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
          <span style="font-size: 25px;color: red;font-weight: bolder">{{ yearNum + '年' }}</span>
        </el-col>
        <el-col :xs="1" :sm="1" :lg="1" :xl="1">
          <el-button icon="el-icon-plus"
                     circle
                     size="mini"
                     type="primary"
                     @click="handleAddYear"
                     :disabled="!this.reqFlag.getAssignProjectDetail"></el-button>
        </el-col>
        <el-col :xs="9" :sm="9" :lg="{span: 9, offset: 3}" :xl="{span: 10, offset: 3}">
          <span style="font-size: 22px;font-weight:bold">{{projectName  + ' 计划&实际进展填报'}}</span>
        </el-col>
        <el-col :xs="3" :sm="3" :lg="{span: 3, offset: 4}" :xl="{span: 2}">
          <el-button size="medium" type="primary" @click="genWorkTimeApply">生成工时申报</el-button>
        </el-col>
        <el-col :xs="1" :sm="1" :lg="{span: 1}" :xl="{span: 1}">
          <el-button size="medium" type="danger" @click="handleBack">返回</el-button>
        </el-col>
      </el-row>
    </div>
    <br>
    <el-button size="medium" type="danger" @click="handleTest1">测试按钮1</el-button>
    <el-button size="medium" type="danger" @click="handleTest2">测试按钮2</el-button>
    <!-----------------------------------------------------主表格----------------------------------------------------------->
    <el-table v-loading="!reqFlag.getAssignProjectDetail"
              :data="tableData"
              stripe
              border
              size="mini"
              resizable
              :span-method="objectSpanMethod"
              :height="tableHeight"
              :row-class-name="tableRowClassName"
              ref="rateTable"
              v-if="isShowFlag.table">
      <el-table-column label="项目阶段" align="center" prop="projectStageName" fixed></el-table-column>
      <el-table-column label="标准工时" align="center" prop="baseWorkTime" width="50%"></el-table-column>
      <el-table-column label="K值" align="center" prop="kValue" width="50%"></el-table-column>
      <el-table-column label="类型" align="center" prop="type" width="50%">
        <template slot-scope="scope">
          <span>{{scope.row.type | processTypeFilter}}</span>
        </template>
      </el-table-column>
      <el-table-column label="项目进度" align="center">
        <el-table-column v-for="month in months"
                         :key="month.key"
                         :name="String(month.name)"
                         :label="month.name"
                         align="center">
          <template slot-scope="scope">
            <!-- 在编辑状态下，如果该月未申报工时，则显示输入框 -->
            <div v-if="scope.row.editable">
              <el-select v-model="scope.row[month.propName]"
                         placeholder=""
                         size="mini"
                         :disabled="monthIsEditable(scope.row, month.propName)"
                         filterable
                         @visible-change="handleSelectVisibleChange($event, scope.row.preMonthProcess)">
                <el-option
                  v-for="item in progress"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                  :disabled="item.disable">
                </el-option>
              </el-select>
              <el-popover
                v-if="scope.row.isApplyWorkTime > 0 && curApplyMonthNum === month.key"
                placement="bottom"
                trigger="click">
                <work-time-table ref="refWorkTimeInfo" @workTimeTableDelete="handleChildEvent()"></work-time-table>
                <span slot="reference" class="link-type" @click="handleClickCheckSubmitWorkTime(scope.row)">该月已申报工时</span>
              </el-popover>
            </div>
            <!-- 不在编辑状态下,直接显示月份进度值 -->
            <div v-if="!scope.row.editable">
              <span>{{scope.row[month.propName]}}</span>
              <span v-if="scope.row[month.propName] !== null && scope.row[month.propName] !== ''">%</span>
            </div>
          </template>
        </el-table-column>
      </el-table-column>
      <el-table-column label="操作" align="center" width="145" fixed="right">
        <template slot="header" slot-scope="scope">
          <span style="font-size:15px;">操作</span>
          <br>
          <el-checkbox v-model="isHideProjectStage" @change="handleClikHideProjectStage(scope)">隐藏已完成</el-checkbox>
        </template>
        <template slot-scope="scope">
          <el-button v-if="!scope.row.editable"
                      size="mini"
                      :type="scope.row.process === 100.0 ? 'info' : (scope.row.type === 'fact' ? 'primary' : 'warning')"
                      @click="handleEdit(scope.row, scope.$index)"
                      :disabled="scope.row.process === 100.0">
            <div v-if="scope.row.process !== 100.0">
              <span v-if="scope.row.type === 'plan'">编辑计划进展</span>
              <span v-if="scope.row.type === 'fact'">编辑实际进展</span>
              <br>
            </div>
            <span v-else>该阶段已完成</span>
          </el-button>
          <div v-if="scope.row.editable && scope.row.process !== 100">
            <el-button size="mini" type="success" @click="handleSave(scope.row, scope.$index)">保存</el-button>
            <el-button size="mini" type="danger" @click="handleCancel(scope.row, scope.$index)">取消</el-button>
          </div>
        </template>
      </el-table-column>
    </el-table>
    <br>
    <!-----------------------------------------------生成工时申报对话框---------------------------------------------------->
    <el-dialog :visible.sync="dialogFormVisible"
               width="65%"
               :title="projectName + '工时预览'">
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
                  trigger="hover">
                  <el-table :data="scope.row.submitedData">
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
                          style="cursor: pointer"
                          @mouseover="handleSubmitedClick(scope.row)">当月已申报</el-tag>
                </el-popover>
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
                   :disabled="!reqFlag.genWorkTimeApply || this.submitParams.data.length === 0">生成</el-button>
      </div>
      <Assign v-if="showFlag.workTimeAssign" ref="workTimeAssign" @assignDetail="handleAssign"/>
    </el-dialog>
    <!-- 工时分配对话框 -->
    <Cop v-if="showFlag.cop" ref="cop"/>
    <!-----------------------------------------------生成项目计划对话框---------------------------------------------------->
    <el-dialog :visible.sync="dialogPlanFormVisible" width="65%" :title="projectName + '项目计划'">
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
        <el-button @click="dialogPlanFormVisible = false">取消</el-button>
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
    workTimeSubmit,
    getIsSubmitAllow,
    submitProjectWorkTimeApply
  } from '@/config/interface'
  import Assign from '@/components/Cop/workTimeAssign'
  import Cop from '@/components/Cop/Cop'
  import { getAssignProjectDetailV2, projectDetailIsApplyWorkTime, projectDetailIsApplyWorkTimeV2 } from '@/utils/workStation'
  import { getCurApplyAbleMonth, mStringToNumber, MonthToString } from '@/utils/common'
  import { Notification } from 'element-ui'
  import workTimeTable from '@/components/common/workTimeTable.vue'
  import moment from 'moment'
  export default {
    data () {
      return {
        tableData: [],
        tableDataCache: [],
        isHideProjectStage: false,
        yearNum: this.$moment().year(),
        projectName: '',
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
          title: this.$moment().format('YYYY-MM')
        },
        reqFlag: {
          getAssignProjectDetail: true,
          savePlanProcess: true,
          genWorkTimeApply: true
        },
        isShowFlag: {
          table: true,
          workTimeTable: false
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
        submitParams: {
          data: []
        },
        showFlag: {
          workTimeAssign: false,
          cop: false
        },
        tableHeight: null,
        curApplyMonth: null,
        curApplyMonthNum: null,
        workTimeInfo: null, // 传给workTimeTable子组件的参数
        months: [{
          name: '1月',
          key: 1,
          propName: 'January'
        }, {
          name: '2月',
          key: 2,
          propName: 'February'
        }, {
          name: '3月',
          key: 3,
          propName: 'March'
        }, {
          name: '4月',
          key: 4,
          propName: 'April'
        }, {
          name: '5月',
          key: 5,
          propName: 'May'
        }, {
          name: '6月',
          key: 6,
          propName: 'June'
        }, {
          name: '7月',
          key: 7,
          propName: 'July'
        }, {
          name: '8月',
          key: 8,
          propName: 'August'
        }, {
          name: '9月',
          key: 9,
          propName: 'September'
        }, {
          name: '10月',
          key: 10,
          propName: 'October'
        }, {
          name: '11月',
          key: 11,
          propName: 'November'
        }, {
          name: '12月',
          key: 12,
          propName: 'December'
        }],
        progress: [{
          value: 10,
          label: '10%',
          disable: false
        }, {
          value: 20,
          label: '20%',
          disable: false
        }, {
          value: 30,
          label: '30%',
          disable: false
        }, {
          value: 40,
          label: '40%',
          disable: false
        }, {
          value: 50,
          label: '50%',
          disable: false
        }, {
          value: 60,
          label: '60%',
          disable: false
        }, {
          value: 70,
          label: '70%',
          disable: false
        }, {
          value: 80,
          label: '80%',
          disable: false
        }, {
          value: 90,
          label: '90%',
          disable: false
        }, {
          value: 100,
          label: '100%',
          disable: false
        }]
      }
    },
    methods: {
      handleTest1 () {
        for (let item of this.tableData) {
          item.isShow = true
        }
      },
      handleTest2 () {
        for (let item of this.tableData) {
          item.isShow = false
        }
      },
      // 初始化
      init () {
        this.projectName = this.$route.query.projectName
        getCurApplyAbleMonth().then(getCurApplyAbleMonthRes => {
          this.curApplyMonth = this.$moment(getCurApplyAbleMonthRes[0].setTime).format('YYYY-MM')
          this.dialogForm.title = this.curApplyMonth
          this.curApplyMonthNum = this.$moment(getCurApplyAbleMonthRes[0].setTime).month() + 1
          this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth)
        })
      },
      // 初始化默认数据
      initData (projectID, yearNum, curApplyMonthNum, curApplyMonth) {
        getAssignProjectDetailV2(projectID, yearNum).then(response => {
          // 构造表格模板数据
          let tableData = []
          let monthProcessObj = {
            id: null,
            type: null,
            year: yearNum,
            aPDID: null,
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
          // 展开项目阶段在各个月份的计划、实际进展数据
          for (let responseItem of response) {
            responseItem.editable = false
            responseItem.isShow = true
            for (let i = 0; i < responseItem.monthProcess.length; i++) {
              let obj = JSON.parse(JSON.stringify(responseItem))
              obj = Object.assign(obj, responseItem.monthProcess[i])
              tableData.push(JSON.parse(JSON.stringify(obj)))
            }
            // 根据月份计划、进展的数量进行相应调整,使计划在前，实际进展在后
            if (responseItem.monthProcess.length === 0) {
              let obj = JSON.parse(JSON.stringify(responseItem))
              monthProcessObj.type = 'plan'
              monthProcessObj.aPDID = responseItem.apdID
              obj = Object.assign(obj, monthProcessObj)
              tableData.push(JSON.parse(JSON.stringify(obj)))

              obj = JSON.parse(JSON.stringify(responseItem))
              monthProcessObj.type = 'fact'
              obj = Object.assign(obj, monthProcessObj)
              tableData.push(JSON.parse(JSON.stringify(obj)))
            } else if (responseItem.monthProcess.length === 1) {
              if (responseItem.monthProcess[0].type === 'fact') {
                let obj = JSON.parse(JSON.stringify(responseItem))
                monthProcessObj.type = 'plan'
                monthProcessObj.aPDID = responseItem.apdID
                obj = Object.assign(obj, monthProcessObj)
                let tmpObj = tableData.pop() // 调换fact和plan的顺序
                tableData.push(JSON.parse(JSON.stringify(obj)))
                tableData.push(JSON.parse(JSON.stringify(tmpObj)))
              } else {
                let obj = JSON.parse(JSON.stringify(responseItem))
                monthProcessObj.type = 'fact'
                monthProcessObj.aPDID = responseItem.apdID
                obj = Object.assign(obj, monthProcessObj)
                tableData.push(JSON.parse(JSON.stringify(obj)))
              }
            }
          }
          // =====================================查询各个项目阶段在当前申报月份下的工时申报情况
          let checkApdID = []
          console.log('111tableData')
          console.log(tableData)
          for (let tableItem of tableData) {
            // =======================插入需要查询的当月是否申报工时的项目阶段ID和上月进展
            if (tableItem.type === 'fact' && tableItem.aPDID !== null) {
              checkApdID.push(JSON.parse(JSON.stringify(tableItem)))
              let preMonth = moment(curApplyMonth).subtract(1, 'months').month() + 1
              if (preMonth === 12) { // 上个月为去年的十二月份
                if (tableItem.preMonthProcess.length > 0) {
                  tableItem.preMonthProcess = tableItem.preMonthProcess[0].December === null ? 0 : tableItem.preMonthProcess[0].December
                } else {
                  tableItem.preMonthProcess = 0
                }
              } else { // 在本年度
                if (tableItem.monthProcess.length > 0) {
                  tableItem.preMonthProcess = tableItem.monthProcess[0][MonthToString(String(preMonth))] === null
                   ? 0 : tableItem.monthProcess[0][MonthToString(String(preMonth))]
                } else {
                  tableItem.preMonthProcess = 0
                }
              }
            } else {
              tableItem.preMonthProcess = 0
            }
          }
          projectDetailIsApplyWorkTimeV2(checkApdID, 'fact', curApplyMonth).then(response => {
            for (let tableDataItem of tableData) {
              let findIndex = response.findIndex(item => {
                return item.apdID === tableDataItem.apdID
              })
              tableDataItem.isApplyWorkTime = findIndex === -1 ? 0 : 1
              tableDataItem.workTimeInfo = findIndex === -1 ? [] : response[findIndex]
            }
          })
          console.log('tableData')
          console.log(tableData)
          // 如果项目阶段数目>10个，先隐藏已完成的项目阶段
          if (tableData.length > 10) {
            let isShow = false
            for (let item of tableData) {
              if (item.process === 100.0) {
                item.isShow = false
                isShow = true
              }
            }
            if (isShow) {
              this.isHideProjectStage = true
              Notification.warning({
                message: '该项目阶段数量较多，已隐藏已完成的项目阶段。若需要，可手动开启显示。'
              })
            }
          }
          this.tableData = tableData
          this.tableDataCache = JSON.parse(JSON.stringify(this.tableData))
        })
      },
      // 子组件回调函数
      handleChildEvent () {
        this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth)
      },
      // 点击隐藏项目阶段事件
      handleClikHideProjectStage () {
        this.isShowFlag.table = false
        this.$nextTick(() => {
          if (this.isHideProjectStage) { // 当前按钮为隐藏项目阶段
            for (let item of this.tableData) {
              if (item.process === 100.0) {
                item.isShow = false
              }
            }
          } else { // 当前按钮为显示项目阶段
            for (let item of this.tableData) {
              if (item.process === 100.0) {
                item.isShow = true
              }
            }
          }
          this.isShowFlag.table = true
        })
      },
      // 点击该月已申报工时事件
      handleClickCheckSubmitWorkTime (row) {
        this.workTimeInfo = row.workTimeInfo
        this.$refs.refWorkTimeInfo[0].init(row.workTimeInfo)
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
      // 月度进展下拉框下拉时触发
      handleSelectVisibleChange ($event, preMonthProcess) {
        if ($event) {
          for (let item of this.progress) {
            item.disable = false
            if (item.value < preMonthProcess) {
              item.disable = true
            }
          }
        }
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
      // 生成工时申报
      genWorkTimeApply () {
        let year = this.$moment(this.dialogForm.title).format('YYYY')
        let promises = []
        let count = 0
        const url = getAssignProjectDetail
        let params = {
          id: this.$route.query.projectID,
          year: year
        }
        this.$http(url, params).then(res => { // 获取项目的所有阶段信息
          let data = res.data
          this.dialogFormVisible = true
          this.applyMonthPlanProcess = data
          let searchData = []
          let applyMonth = this.$moment(this.dialogForm.title).toObject()
          let applyMonthString = this.$common.MonthToString(String(applyMonth.months + 1))
          for (let item of this.applyMonthPlanProcess) {
            if (item.isFinish !== 1 && item.type === 'fact' && item[applyMonthString] !== null) {
              searchData.push(item)
            }
          }
          this.submitParams = {
            data: []
          }
          if (searchData.length === 0) {
            this.reqFlag.genWorkTimeApply = false
            this.applyMonthPlanProcessTableData = []
            this.$common.toast(this.dialogForm.title + '月份未填报实际进展', 'error', 'true')
          } else {
            promises[count++] = projectDetailIsApplyWorkTime(searchData, 'fact', this.dialogForm.title)
            promises[count++] = this.getMonthProcess('fact', searchData)
            Promise.all(promises).then(result => {
              let submitParamsTmp = result[1]
              for (let i = 0; i < result[0].length; i++) {
                if (result[0][i].length > 0) { // 申报阶段在当月已申报工时
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
              for (let i = 0; i < submitParamsTmp.data.length; i++) {
                if (submitParamsTmp.data[i].lastMonthProcess ===
                  submitParamsTmp.data[i].applyMonthProcess) {
                  submitParamsTmp.data[i] = []
                }
              }
              for (let i = 0; i < submitParamsTmp.data.length; i++) {
                if (submitParamsTmp.data[i].length === 0) {
                  submitParamsTmp.data.splice(i, 1)
                  i--
                }
              }
              this.applyMonthPlanProcessTableData = submitParamsTmp.data
              this.submitParams = submitParamsTmp
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
          this.yearNum -= 1
          this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth)
        }
      },
      // 下一年度进展
      handleAddYear () {
        if (this.reqFlag.getAssignProjectDetail) {
          this.yearNum += 1
          this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth)
        }
      },
      // 表格编辑按钮
      handleEdit (row, index) {
        if (row.type === 'fact') {
          // projectDetailIsApplyWorkTime([row], 'fact', this.curApplyMonth).then(projectDetailIsApplyWorkTimeRes => {
          //   row.isApplyWorkTime = projectDetailIsApplyWorkTimeRes[0].length
            row.editable = true
          //   row.workTimeInfo = projectDetailIsApplyWorkTimeRes[0][0]
          //   console.log('projectDetailIsApplyWorkTimeRes')
          //   console.log(projectDetailIsApplyWorkTimeRes)
          //   row.currentMontProgress = row.isApplyWorkTime > 0 ? projectDetailIsApplyWorkTimeRes[0][0][MonthToString(String(this.curApplyMonthNum))] : 0
          // })
        } else {
          row.editable = true
        }
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
              this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth)
              this.reqFlag.savePlanProcess = true
              this.$common.toast('保存成功', 'success', false)
            }
          })
        }
        row.editable = false
        for (let item in row) {
          this.tableDataCache[index][item] = row[item]
        }
      },
      // 取消按钮
      handleCancel (row, index) {
        for (let item in this.tableDataCache[index]) {
          row[item] = this.tableDataCache[index][item]
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
      // 表格行样式回调方法
      tableRowClassName ({ row, rowIndex }) {
        if (!row.isShow) {
          return 'hidden_box' // 可以动态添加class样式
        }
        return ''
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
      // 是否禁用月份进展编辑框
      monthIsEditable (row, month) {
        if (row.type === 'plan') {
          return false
        } else if (row.type === 'fact') {
          return !this.$moment(this.yearNum + '-' + mStringToNumber(month)).isSame(this.curApplyMonth) || row.isApplyWorkTime > 0
        }
      },
      // 当月已申报点击事件
      handleSubmitedClick (row) {
        this.$common.toast('111', 'error', false)
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
      Cop,
      workTimeTable
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

<style>
.el-table .hidden_box {
  display: none;
}
</style>

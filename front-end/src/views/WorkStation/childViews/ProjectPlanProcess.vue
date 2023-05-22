<template>
  <div style="margin: 15px">
    <!-- 标题 -->
    <div style="text-align: center">
      <el-row align="middle" type="flex">
        <el-col :xs="1" :sm="1" :lg="1" :xl="{span: 1, push: 0}">
          <el-button icon="el-icon-minus"
                     circle
                     size="mini"
                     type="danger"
                     @click="handleDecYear"
                     :disabled="!this.reqFlag.tableDataInit"></el-button>
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
                     :disabled="!this.reqFlag.tableDataInit"></el-button>
        </el-col>
        <el-col :xs="9" :sm="9" :lg="{span: 9, offset: 3}" :xl="{span: 10, offset: 3}">
          <span style="font-size: 22px;font-weight:bold">{{projectName  + ' 计划&实际进展填报'}}</span>
        </el-col>
        <el-col :xs="3" :sm="3" :lg="{span: 3, offset: 4}" :xl="{span: 2}">
          <el-button size="medium" type="primary" :disabled="!reqFlag.tableDataInit" @click="genWorkTimeApply">生成工时申报</el-button>
        </el-col>
        <el-col :xs="1" :sm="1" :lg="{span: 1}" :xl="{span: 1}">
          <el-button size="medium" type="danger" @click="handleBack">返回</el-button>
        </el-col>
      </el-row>
    </div>
    <br>
    <!-----------------------------------------------------主表格----------------------------------------------------------->
    <el-table v-loading="!this.reqFlag.tableDataInit"
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
      <el-table-column label="项目阶段" align="center" prop="projectStageName" fixed show-overflow-tooltip></el-table-column>
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
              <el-select v-if="month.propName === curApplyMonthEn" v-model="scope.row[month.propName]"
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
              <div v-else>
                <span>{{scope.row[month.propName]}}</span>
                <span v-if="scope.row[month.propName] !== null && scope.row[month.propName] !== ''">%</span>
              </div>
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
                      @click="handleEdit(scope.row)"
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
    <el-dialog :visible.sync="dialogFormVisible" width="65%" :title="projectName + '工时预览'">
      <div>
        <span>申报月份：</span>
        <el-date-picker
          v-model="dialogTitle"
          type="month"
          format="yyyy 第 MM 月"
          value-format="yyyy-MM"
          placeholder="选择月"
          :picker-options="pickerOptions"
          style="width: 150px"
          @change="handleApplyDateChange">
        </el-date-picker>
        <span>
          <span style="margin-left: 20px;font-size: 15px">总工时：</span>
          <span style="color: red;font-weight: bolder;font-size: 20px">{{totalGetWorkTime}}</span>
        </span>
      </div>
      <div>
        <el-table :data="submitParams.data">
          <el-table-column label="序号" align="center" type="index"></el-table-column>
          <el-table-column label="项目阶段" align="center" prop="projectStageName"></el-table-column>
          <el-table-column label="上月进展" align="center">
            <template slot-scope="scope">
              <span>{{scope.row.lastProcess + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="本月进展" align="center">
            <template slot-scope="scope">
              <span>{{scope.row.applyProcess + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="K值" align="center" prop="defaultKValue"></el-table-column>
          <el-table-column label="完成次数" align="center" width="150%">
            <template slot-scope="scope">
              <el-input-number size="mini"
                                v-model.number="scope.row.defaultCofficient"
                                :min="1.0"
                                @change="handleCoeffCoffChange(scope.row)"
                                style="width: 70%">
              </el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="预计可获得工时" align="center" prop="avaiableWorkTime">
            <template slot-scope="scope">
              {{scope.row.avaiableWorkTime.toFixed(1)}}
            </template>
          </el-table-column>
          <el-table-column label="工时分配" align="center">
            <template slot-scope="scope">
              <span class="link-type" @click="handleWorkTimeAssign(scope.row, scope.$index)">点击分配</span>
            </template>
          </el-table-column>
          <el-table-column label="备注" align="center">
            <template slot-scope="scope">
              <el-input size="mini" v-model="scope.row.submitComments"></el-input>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogFormVisible = false">取消</el-button>
        <el-button type="primary"
                   @click="handleWorkTimeApply()"
                   :disabled="!reqFlag.genWorkTimeApply || this.submitParams.data.length === 0">生成</el-button>
      </div>
      <Assign v-if="showFlag.workTimeAssign" ref="workTimeAssign" @assignDetail="handleAssign"/>
    </el-dialog>
    <!-- 工时分配对话框 -->
    <Cop v-if="showFlag.cop" ref="cop"/>
  </div>
</template>

<script>
  import Assign from '@/components/Cop/workTimeAssign'
  import Cop from '@/components/Cop/Cop'
  import { getAssignProjectDetailV2, projectDetailIsApplyWorkTimeV2, submitProcess, submitProjectWorkTimeApply } from '@/utils/workStation'
  import { getCurApplyAbleMonth, mStringToNumber, MonthToString, getIsSubmitAllow } from '@/utils/common'
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
        dialogTitle: null,
        dialogTitleMonthEN: null,
        reqFlag: {
          savePlanProcess: true,
          genWorkTimeApply: true,
          tableDataInit: true
        },
        isShowFlag: {
          table: true,
          workTimeTable: false
        },
        dialogFormVisible: false,
        pickerOptions: {
          // disabledDate (time) {
          //   return time.getTime() > Date.now()
          // }
        },
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
        curApplyMonthEn: null, // 当前申报月份的英文拼写
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
        }]
      }
    },
    methods: {
      // 初始化
      init () {
        this.projectName = this.$route.query.projectName
        getCurApplyAbleMonth().then(getCurApplyAbleMonthRes => {
          this.curApplyMonth = this.$moment(getCurApplyAbleMonthRes[0].setTime).format('YYYY-MM')
          this.dialogTitle = this.curApplyMonth
          this.curApplyMonthNum = this.$moment(getCurApplyAbleMonthRes[0].setTime).month() + 1
          this.curApplyMonthEn = MonthToString(String(this.curApplyMonthNum))
          this.dialogTitleMonthEN = MonthToString(String(this.curApplyMonthNum))
          this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth).then(response => {
            this.tableData = response
            this.tableDataCache = JSON.parse(JSON.stringify(this.tableData))
            this.reqFlag.tableDataInit = true
          }).catch(err => {
            console.log(err)
            this.reqFlag.tableDataInit = true
          })
        })
      },
      // 初始化默认数据
      initData (projectID, yearNum, curApplyMonthNum, curApplyMonth) {
        this.reqFlag.tableDataInit = false
        let _this = this
        return new Promise(function (resolve, reject) {
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
              December: null,
              submitComments: ''
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
            // =====================================查询各个项目阶段在当前申报月份下的工时申报情况===================
            let checkApdID = []
            for (let tableItem of tableData) {
              tableItem.submitComments = ''
              // =======================插入需要查询的当月是否申报工时的项目阶段ID和上月进展=========================
              if (tableItem.type === 'fact' && tableItem.aPDID !== null) {
                checkApdID.push(JSON.parse(JSON.stringify(tableItem)))
                let preMonth = moment(curApplyMonth).subtract(1, 'months').month() + 1
                if (preMonth === 12) { // 上个月为去年的十二月份
                  if (tableItem.preMonthProcessArray.length > 0) {
                    tableItem.preMonthProcess = tableItem.preMonthProcessArray[0].December === null ? 0 : tableItem.preMonthProcessArray[0].December
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
                  _this.isHideProjectStage = true
                  Notification.warning({
                    message: '该项目阶段数量较多，已隐藏已完成的项目阶段。若需要，可手动开启显示。'
                  })
                }
              }
              resolve(tableData)
            }).catch(err => {
              reject(err)
            })
          }).catch(err => {
            reject(err)
          })
        })
      },
      // 子组件回调函数
      handleChildEvent () {
        this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth).then(response => {
          this.tableData = response
          this.tableDataCache = JSON.parse(JSON.stringify(this.tableData))
          this.reqFlag.tableDataInit = true
        }).catch(err => {
          console.log(err)
          this.reqFlag.tableDataInit = true
        })
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
        this.$refs.refWorkTimeInfo[0].init(row.workTimeInfo, row.preMonthProcess)
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
      // 系数改变事件
      handleCoeffCoffChange (row) {
        row.avaiableWorkTime = Number(((row.applyProcess - row.lastProcess) * 0.01 * row.applyBaseWorkTime *
              row.defaultCofficient * row.defaultKValue).toFixed(1))
        row.workTimeAssign[0].assignWorkTime = row.avaiableWorkTime
      },
      // 生成工时申报
      genWorkTimeApply () {
        this.reqFlag.genWorkTimeApply = true
        this.dialogFormVisible = true
        let toSaveProcess = []
        for (let i = 0; i < this.tableData.length; i++) {
          if (this.tableData[i].editable && this.tableData[i].type === 'fact') {
            toSaveProcess.push(this.tableData[i])
          }
        }
        // 如果有编辑阶段进展未保存，先保存
        if (toSaveProcess.length !== 0) {
          submitProcess(toSaveProcess).then(response => {
            this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth).then(response => {
              this.tableData = response
              this.tableDataCache = JSON.parse(JSON.stringify(this.tableData))
              this.reqFlag.tableDataInit = true
            }).catch(err => {
              console.log(err)
              this.reqFlag.tableDataInit = true
            })
          }).catch(err => {
            console.log(err)
          })
        }
        let toSubmitWorkTime = []
        // 构造提交工时申报的数据格式
        for (let tableDataItem of this.tableData) {
          let obj = {
            projectTypeID: null,
            defaultKValue: null,
            reviewKValue: null,
            defaultCofficient: null,
            reviewCofficient: null,
            avaiableWorkTime: null,
            applyProcess: null,
            lastProcess: null,
            monthID: null,
            baseWorkTime: null,
            submitComments: '',
            apdID: null,
            aplID: null,
            applyBaseWorkTime: null,
            id: null,
            workTimeAssign: null
          }
          if (tableDataItem.type === 'fact' && tableDataItem.process != 100 && tableDataItem.isApplyWorkTime != 1) {
            let getWorkTime = (tableDataItem[this.dialogTitleMonthEN] - tableDataItem.preMonthProcess) * 0.01 * tableDataItem.baseWorkTime *
              tableDataItem.coefficient * tableDataItem.kValue
            if (getWorkTime > 0) {
              obj.projectTypeID = tableDataItem.projectStageID
              obj.defaultKValue = tableDataItem.kValue
              obj.reviewKValue = null
              obj.defaultCofficient = tableDataItem.coefficient
              obj.reviewCofficient = tableDataItem.null
              obj.avaiableWorkTime = getWorkTime
              obj.applyProcess = tableDataItem[this.dialogTitleMonthEN]
              obj.lastProcess = tableDataItem.preMonthProcess
              obj.monthID = tableDataItem.id
              obj.baseWorkTime = tableDataItem.baseWorkTime
              obj.submitComments = tableDataItem.submitComments
              obj.apdID = tableDataItem.apdID
              obj.aplID = tableDataItem.aplID
              obj.applyBaseWorkTime = tableDataItem.baseWorkTime
              obj.id = null
              obj.workTimeAssign = tableDataItem.workTimeAssign
              obj.projectStageName = tableDataItem.projectStageName
              obj.isConference = tableDataItem.isConference
              obj.defaultAssignWorkTime = tableDataItem.defaultAssignWorkTime
              obj.multipleSelect = []
              obj.multipleAssign = false
              obj.workTimeAssign = []
              let defaultCurrentUserWorkTime = {
                id: this.$store.state.userInfo.id,
                groupName: this.$store.state.userInfo.groupName,
                name: this.$store.state.userInfo.name,
                applyRole: '组织者',
                assignWorkTime: obj.avaiableWorkTime,
                deleteAble: false
              }
              obj.workTimeAssign.push(defaultCurrentUserWorkTime)
              toSubmitWorkTime.push(obj)
            }
          }
        }
        this.submitParams.data = toSubmitWorkTime
        this.submitParams.submitType = 'insert'
        this.submitParams.applyType = 'fact'
        this.submitParams.submitDate = this.dialogTitle
        this.submitParams.userID = this.$store.state.userInfo.id
        this.submitParams.projectID = null
        this.applyMonthPlanProcessTableData = toSubmitWorkTime
        if (toSubmitWorkTime.length === 0) {
          this.reqFlag.genWorkTimeApply = false
          this.applyMonthPlanProcessTableData = []
          this.$common.toast(this.dialogTitle + '月份未填报实际进展', 'error', 'true')
        }
      },
      // 提交工时申报
      handleWorkTimeApply () {
        let applyYear = this.$moment(this.dialogTitle).year()
        let applyMonth = this.$moment(this.dialogTitle).month() + 1
        getIsSubmitAllow(applyYear, applyMonth).then(getIsSubmitAllowRes => {
          if (getIsSubmitAllowRes.length === 0 || this.$store.state.userInfo.duty === 1) {
            submitProjectWorkTimeApply(this.submitParams, this.$route.query.projectID).then(() => {
              this.$common.toast('生成成功', 'success', false)
              this.$router.push({ path: '/home/workStation' })
              this.dialogFormVisible = false
            }).catch(err => {
              console.log(err)
              this.$common.toast('生成失败', 'error', false)
            })
          } else {
            this.$common.toast(this.dialogTitle + '月已截止申报工时', 'error', true)
          }
        }).catch(err => {
          this.$common.toast(err, 'error', true)
        })
      },
      // 返回上一级
      handleBack () {
        this.$router.push({ path: '/home/workStation' })
      },
      // 上一年度进展
      handleDecYear () {
        this.yearNum -= 1
        this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth).then(response => {
          this.tableData = response
          this.tableDataCache = JSON.parse(JSON.stringify(this.tableData))
          this.reqFlag.tableDataInit = true
        }).catch(err => {
          console.log(err)
          this.reqFlag.tableDataInit = true
        })
      },
      // 下一年度进展
      handleAddYear () {
        this.yearNum += 1
        this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth).then(response => {
          this.tableData = response
          this.tableDataCache = JSON.parse(JSON.stringify(this.tableData))
          this.reqFlag.tableDataInit = true
        }).catch(err => {
          console.log(err)
          this.reqFlag.tableDataInit = true
        })
      },
      // 表格编辑按钮
      handleEdit (row) {
        row.editable = true
      },
      // 表格保存按钮
      handleSave (row, index) {
        for (let item in row) {
          if (row[item] === '') {
            row[item] = null
          }
        }
        submitProcess([row]).then(response => {
          row.editable = false
          this.initData(this.$route.query.projectID, this.yearNum, this.curApplyMonthNum, this.curApplyMonth).then(response => {
            this.tableData = response
            this.tableDataCache = JSON.parse(JSON.stringify(this.tableData))
            this.reqFlag.tableDataInit = true
            this.$common.toast('保存成功', 'success', false)
          }).catch(err => {
            console.log(err)
            this.reqFlag.tableDataInit = true
          })
          // row.editable = false
          // for (let item in row) {
          //   this.tableDataCache[index][item] = row[item]
          // }
        }).catch(err => {
          console.log(err)
        })
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
        this.dialogTitleMonthEN = MonthToString(String(this.$moment(this.dialogTitle).month() + 1))
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

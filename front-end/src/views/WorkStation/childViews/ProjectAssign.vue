<template>
  <div v-if="$store.state.userInfo.role !== '普通成员'
  || $store.state.userInfo.id === 32
  || $store.state.userInfo.id === 7
  || $store.state.userInfo.id === 11
  || $store.state.userInfo.id === 12
  || $store.state.userInfo.id === 8">
    <div class="main-search">
      <el-row>
        <el-col :span="4">
          <el-radio-group v-model="selectType" @change="handleSelectTypeChange">
            <el-radio-button label="项目指派"></el-radio-button>
            <el-radio-button label="已指派"></el-radio-button>
          </el-radio-group>
        </el-col>
        <el-col :span="1" v-if="false">
          <el-date-picker
            v-model="formData.title"
            type="month"
            format="yyyy 第 MM 月"
            value-format="yyyy-MM"
            placeholder="选择月"
            :picker-options="pickerOptions"
            style="width: 150px">
          </el-date-picker>
        </el-col>
        <el-col :span="1" :offset="16"  v-if="!showFlag.assigned">
          <el-button type="primary" size="medium" @click="submit">保存</el-button>
        </el-col>
        <el-col :span="1" style="margin-left: 25px"  v-if="!showFlag.assigned">
          <el-button type="warning" size="medium" @click="goBack">返回</el-button>
        </el-col>
      </el-row>
    </div>
    <!-- 分割线 start -->
    <div class="hr-10" style="margin-top: 20px"></div>
    <!-- 分割线 end -->
    <!---------------------------------------------------------项目指派页面-------------------------------------------------->
    <div v-if="showFlag.projectAssign">
      <el-row>
        <el-col :span="3">
          <h3 class="v-line-icon-red">项目指派</h3>
        </el-col>
      </el-row>
      <el-form ref="formData" :model="formData" :rules="formRules" :inline="true">
        <el-form-item label="项目名称" style="margin-left: 30px" prop="projectName">
          <el-input placeholder="请输入" v-model.trim="formData.projectName" clearable></el-input>
        </el-form-item>
        <br>
        <el-form-item label="项目类型" prop="projectType" style="margin-left: 30px">
          <el-cascader
            v-model="formData.projectType"
            :options="projectTypeOptions"
            :props="props"
            collapse-tags
            filterable
            clearable
            style="width: 350%">
            <template slot-scope="{ node, data }">
              <el-tooltip :disabled="data.projectName.length < 11"
                          class="item"
                          effect="dark"
                          :content="data.projectName"
                          placement="top-start">
                <span>{{ data.projectName }}</span>
              </el-tooltip>
            </template>
          </el-cascader>
        </el-form-item>
        <br>
        <el-form-item label="项目级别" style="margin-left: 30px" prop="projectLevel">
          <el-select v-model="formData.projectLevel" placeholder="请选择" style="width: 70%">
            <el-option v-for="item in projectLevels"
                       :key="item.value"
                       :label="item.text"
                       :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="项目经理" prop="projectManager" style="margin-left: -50px">
          <el-select v-model="formData.projectManager"
                     placeholder="请选择"
                     clearable
                     filterable
                     style="width: 50%">
            <el-option-group v-for="group in users"
                             :key="group.label"
                             :label="group.label">
              <el-option v-for="item in group.options"
                         :key="item.id"
                         :label="item.name"
                         :value="item.id">
              </el-option>
            </el-option-group>
          </el-select>
        </el-form-item>
        <el-form-item style="margin-left: -100px">
          <span style="font-size: 15px">总工时：</span>
          <span style="font-size: 20px;color: red;font-weight: bolder">{{totalWorkTime}}</span>
        </el-form-item>
        <el-form-item style="margin-left: 30px">
          <el-button type="success" size="medium" @click="handleAssign('formData')">指派</el-button>
          <el-button type="danger" size="medium" @click="resetForm('formData')">重置</el-button>
        </el-form-item>
        <br>
        <el-table :data="tableData" style="width: 95%;margin: auto">
          <el-table-column label="序号" align="center" type="index"></el-table-column>
          <el-table-column label="项目类型" align="center" prop="projectType"></el-table-column>
          <el-table-column label="项目阶段" align="center" prop="workType" show-overflow-tooltip>
            <template slot-scope="scope">
              <div v-if="scope.row.projectTypeID === 72">
                <el-input v-model="scope.row.workType" size="mini"></el-input>
              </div>
              <div v-else>
                <span>{{scope.row.workType}}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="基本工时" align="center" prop="workTime">
            <template slot-scope="scope">
              <div v-if="scope.row.projectTypeID === 72">
                <el-input-number v-model="scope.row.workTime" size="mini"></el-input-number>
              </div>
              <div v-else>
                <span>{{scope.row.workTime}}</span>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="调整基本工时" align="center" prop="avaiableWorkTime">
            <template slot-scope="scope">
              <el-input-number v-model="scope.row.avaiableWorkTime"
                               size="mini"
                               :min="1.0"
                               :step="0.5"
                               style="width: 100%"></el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="K值" align="center" prop="kValue">
            <template slot-scope="scope">
              <el-input-number v-model="scope.row.kValue"
                               size="mini"
                               :min="1.0"
                               :step="0.5"
                               style="width: 100%"></el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="项目经理" align="center" prop="projectManager"></el-table-column>
          <el-table-column label="操作" align="center">
            <template slot-scope="scope">
              <el-button type="danger"
                         @click="handleDelete(scope.row, scope.$index)"
                         size="mini">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
        <br>
<!--        <div style="text-align: center">-->
<!--          <el-button type="primary" size="mini" plain @click="addNewLine">新增一行</el-button>-->
<!--        </div>-->
        <br>
        <br>
      </el-form>
    </div>
    <!---------------------------------------------------------已指派页面---------------------------------------------------->
    <div v-if="showFlag.assigned">
      <h3 class="v-line-icon-red">已指派</h3>
      <el-table :data="assignedTable" style="width: 95%;margin: auto">
        <el-table-column label="序号" align="center" type="index"></el-table-column>
        <el-table-column label="指派时间" align="center">
          <template slot-scope="scope">
            <span>{{scope.row.assignDate}}</span>
          </template>
        </el-table-column>
        <el-table-column label="项目名称" align="center" prop="projectName">
          <template slot-scope="scope">
            <div v-if="scope.row.editable">
              <el-input v-model="scope.row.projectName"></el-input>
            </div>
            <div v-else>
              <span class="link-type" @click="handleProjectDetailClick(scope.row)">{{ scope.row.projectName }}</span>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="项目类型" align="center" prop="projectType"></el-table-column>
        <el-table-column label="项目级别" align="center" :filters="projectLevels" :filter-method="projectLevelsFilter">
          <template slot-scope="scope">
            <div v-if="scope.row.editable">
              <el-select v-model="scope.row.projectLevel" placeholder="请选择" style="width: 90%">
                <el-option v-for="item in projectLevels"
                           :key="item.value"
                           :label="item.text"
                           :value="item.value">
                </el-option>
              </el-select>
            </div>
            <div v-else>
              <el-tag :type="scope.row.projectLevel | projectLevelColorFilter">
                {{scope.row.projectLevel | projectLevelStringFilter}}
              </el-tag>
            </div>
          </template>
        </el-table-column>
        <el-table-column label="项目经理" align="center" prop="projectManager" :filters="usersFilter" :filter-method="usersFilterMethod">
          <template slot-scope="scope">
            <div v-if="scope.row.editable">
              <el-select v-model="scope.row.projectManagerID"
                         placeholder="请选择"
                         clearable
                         filterable
                         style="width: 60%"
                         size="medium">
                <el-option-group v-for="group in users"
                                 :key="group.label"
                                 :label="group.label">
                  <el-option v-for="item in group.options"
                             :key="item.id"
                             :label="item.name"
                             :value="item.id">
                  </el-option>
                </el-option-group>
              </el-select>
            </div>
            <div v-else>
              {{scope.row.projectManager}}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="进展" align="center">
          <template slot-scope="scope">
            <el-progress :text-inside="true" :stroke-width="26" :percentage="scope.row.process"></el-progress>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template slot-scope="scope">
            <div v-if="!scope.row.editable">
              <el-button type="success" @click="handleTurnTo(scope.row)" size="mini">编辑</el-button>
              <el-button type="danger" @click="handleAssignDelete(scope.row, scope.$index)" size="mini">删除</el-button>
            </div>
            <div v-else>
              <el-button type="primary" @click="handleSave(scope.row)" size="mini">保存</el-button>
              <el-button type="warning" @click="handleCancel(scope.row)" size="mini">取消</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <!---------------------------------------------------------对话框页面---------------------------------------------------->
    <el-dialog :visible.sync="showFlag.projectDetail" :title="formData.yearNum + '年 ' + assignProjectName + ' 计划&进展'" width="90%">
      <el-form>
        <el-table v-loading="!reqFlag.getAssignProjectDetail"
                  :data="formData.tableData"
                  stripe
                  border
                  size="mini"
                  resizable
                  :span-method="objectSpanMethod"
                  :height="tableMaxHeight" style="margin-top: -20px">
          <el-table-column label="项目阶段" align="center" prop="projectStageName" fixed></el-table-column>
          <el-table-column label="标准工时" align="center" prop="baseWorkTime" width="50%"></el-table-column>
          <el-table-column label="K值" align="center" prop="kValue" width="50%"></el-table-column>
          <el-table-column label="完成次数" align="center" prop="coefficient" width="60%"></el-table-column>
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
                <el-form-item :prop="'tableData.' + scope.$index + '.January'" :rules="formRules.January">
                  <el-input v-if="scope.row.editable" v-model.number="scope.row.January" size="mini" type="number"></el-input>
                  <span v-else>{{scope.row.January}}</span>
                  <span v-if="!scope.row.editable && scope.row.January !== null && scope.row.January !== ''">%</span>
                </el-form-item>
              </template>
            </el-table-column>
            <el-table-column label="2月" align="center" prop="February" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.February" size="mini"></el-input>
                <span v-else>{{scope.row.February}}</span>
                <span v-if="!scope.row.editable && scope.row.February !== null && scope.row.February !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="3月" align="center" prop="March" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.March" size="mini"></el-input>
                <span v-else>{{scope.row.March}}</span>
                <span v-if="!scope.row.editable && scope.row.March !== null && scope.row.March !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="4月" align="center" prop="April" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.April" size="mini"></el-input>
                <span v-else>{{scope.row.April}}</span>
                <span v-if="!scope.row.editable && scope.row.April !== null && scope.row.April !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="5月" align="center" prop="May" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.May" size="mini"></el-input>
                <span v-else>{{scope.row.May}}</span>
                <span v-if="!scope.row.editable && scope.row.May !== null && scope.row.May !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="6月" align="center" prop="June" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.June" size="mini"></el-input>
                <span v-else>{{scope.row.June}}</span>
                <span v-if="!scope.row.editable && scope.row.June !== null && scope.row.June !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="7月" align="center" prop="July" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.July" size="mini"></el-input>
                <span v-else>{{scope.row.July}}</span>
                <span v-if="!scope.row.editable && scope.row.July !== null && scope.row.July !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="8月" align="center" prop="August" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.August" size="mini"></el-input>
                <span v-else>{{scope.row.August}}</span>
                <span v-if="!scope.row.editable && scope.row.August !== null && scope.row.August !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="9月" align="center" prop="September" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.September" size="mini"></el-input>
                <span v-else>{{scope.row.September}}</span>
                <span v-if="!scope.row.editable && scope.row.September !== null && scope.row.September !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="10月" align="center" prop="October" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.October" size="mini"></el-input>
                <span v-else>{{scope.row.October}}</span>
                <span v-if="!scope.row.editable && scope.row.October !== null && scope.row.October !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="11月" align="center" prop="November" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.November" size="mini"></el-input>
                <span v-else>{{scope.row.November}}</span>
                <span v-if="!scope.row.editable && scope.row.November !== null && scope.row.November !== ''">%</span>
              </template>
            </el-table-column>
            <el-table-column label="12月" align="center" prop="December" width="73%">
              <template slot-scope="scope">
                <el-input v-if="scope.row.editable" v-model="scope.row.December" size="mini"></el-input>
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
        </el-table>
      </el-form>
    </el-dialog>
  </div>
</template>

<script>
  import { getUsersName, getProjectType, getWorkTimeNew, submitAssignWorkDetail,
    getAssignedProject, updateAssignProjectList, deleteAssignProject, getAssignProjectDetail } from '@/config/interface'
    export default {
      data () {
        return {
          formData: {
            title: this.$moment().format('YYYY-MM'),
            projectType: '',
            projectManager: '',
            projectName: '',
            projectLevel: 1,
            yearNum: this.$moment().format('YYYY')
          },
          users: [{
            label: '技术标准组',
            options: []
          }, {
            label: '工程组',
            options: []
          }, {
            label: '通信组',
            options: []
          }],
          tableData: [],
          projectTypeOptions: [],
          formRules: {
            projectName: [
              { required: true, message: '请输入项目名称', trigger: 'blur' }
            ],
            projectType: [
              { required: true, message: '请选择项目类型', trigger: 'change' }
            ],
            projectManager: [
              { required: true, message: '请选择项目经理', trigger: 'change' }
            ],
            projectLevel: [
              { required: true, message: '请选择项目级别', trigger: 'change' }
            ]
          },
          reqFlag: {
            getUserName: true,
            getProjectType: true,
            handleAssign: true,
            deleteAssignProject: true,
            getAssignProjectDetail: true
          },
          props: {
            multiple: true,
            value: 'projectTypeID',
            label: 'projectName',
            expandTrigger: 'hover'
          },
          showFlag: {
            projectAssign: true,
            assigned: false,
            projectDetail: false
          },
          selectType: '项目指派',
          assignedTable: [],
          pickerOptions: {
            disabledDate (time) {
              return time.getTime() > Date.now()
            }
          },
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
          usersFilter: [],
          checkAssignProjectID: null,
          assignProjectName: ''
        }
      },
      methods: {
        init () {
          this.getUsersName()
          this.getProjectType()
        },
        // 获取人员信息
        getUsersName () {
          if (this.reqFlag.getUserName) {
            this.reqFlag.getUserName = false
            const url = getUsersName
            let params = {}
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  this.reqFlag.getUserName = true
                  let data = res.data
                  for (let item of data.list) {
                    if (item.groupName === '技术标准组') {
                      this.users[0].options.push(item)
                    } else if (item.groupName === '工程组') {
                      this.users[1].options.push(item)
                    } else if (item.groupName === '通信组') {
                      this.users[2].options.push(item)
                    }
                    let obj = {
                      value: item.id,
                      text: item.name
                    }
                    this.usersFilter.push(obj)
                  }
                }
              })
          }
        },
        // 获取项目类型
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
                  this.reqFlag.getProjectType = true
                }
              })
          }
        },
        // 指派按钮
        handleAssign (formData) {
          this.$refs[formData].validate((valid) => {
            if (valid) {
              let selectLen = this.formData.projectType.length
              let selectItems = []
              let params = {}
              let url = getWorkTimeNew
              for (let i = 0; i < selectLen; i++) {
                selectItems.push(this.formData.projectType[i][this.formData.projectType[i].length - 1]) // 数组最后一位即为项目最底级ID
              }
              params.checkID = selectItems
              params.parentID = this.formData.projectType[0][0]
              if (this.reqFlag.handleAssign) {
                this.reqFlag.handleAssign = false
                let it = this
                this.$http(url, params)
                  .then(res => {
                    if (res.code === 1) {
                      this.reqFlag.handleAssign = true
                      let data = res.data
                      let parentType = data.pop()
                      let assignTo = null
                      this.users.find(items => {
                        for (let item of items.options) {
                          if (item.id === this.formData.projectManager) {
                            return (assignTo = item.name)
                          }
                        }
                      })
                      for (let item of data) {
                        item.projectType = parentType
                        item.projectManager = assignTo
                        item.projectManagerID = this.formData.projectManager
                        item.avaiableWorkTime = item.workTime
                        item.kValue = 1.0
                        item.workType = item.projectName
                      }
                      it.tableData = data
                    }
                  })
              }
            }
          })
        },
        // 重置表单
        resetForm (formData) {
          this.$refs[formData].resetFields()
          this.tableData = []
        },
        // 删除按钮
        handleDelete (row, index) {
          this.tableData.splice(index, 1)
        },
        // 保存按钮
        submit () {
          if (this.tableData.length !== 0) {
            const url = submitAssignWorkDetail
            for (let item of this.tableData) { // 可用工时替换基本工时（针对目前已经进行到一半的项目）
              item.workTime = item.avaiableWorkTime
            }
            let params = {
              tableData: this.tableData,
              parentID: this.formData.projectType[0][0],
              projectLevel: this.formData.projectLevel,
              projectName: this.formData.projectName
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  this.$common.toast('保存成功', 'success', 'false')
                  this.selectType = '已指派'
                  this.showFlag.projectAssign = false
                  this.showFlag.assigned = false
                  this.getAssignedProject()
                  this.$nextTick(() => {
                    this.showFlag.assigned = true
                  })
                }
              })
          } else {
            this.$common.toast('请指派任务', 'error', 'false')
          }
        },
        // 返回按钮
        goBack () {
          this.$router.push({ path: '/home/workStation' })
        },
        // 获取已指派项目列表
        getAssignedProject () {
          const url = getAssignedProject
          let params = {
            assignerID: this.$store.state.userInfo.id,
            title: this.formData.title
          }
          this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                for (let item of res.data) {
                  item.editable = false
                }
                this.assignedTable = res.data
              }
            })
        },
        // 手动重置表单数据
        resetFormData () {
          this.formData.title = this.$moment().format('YYYY-MM')
          this.formData.projectType = ''
          this.formData.projectManager = ''
          this.formData.projectName = ''
          this.formData.projectLevel = 1
          this.formData.yearNum = this.$moment().format('YYYY')
        },
        // 标签切换
        handleSelectTypeChange (selectType) {
          if (selectType === '项目指派') {
            this.showFlag.projectAssign = false
            this.showFlag.assigned = false
            this.$nextTick(() => {
              this.showFlag.projectAssign = true
            })
          } else if (selectType === '已指派') {
            this.resetFormData()
            this.showFlag.projectAssign = false
            this.showFlag.assigned = false
            this.getAssignedProject()
            this.$nextTick(() => {
              this.showFlag.assigned = true
            })
          }
        },
        // 转办
        handleTurnTo (row) {
          row.editable = !row.editable
        },
        // 保存
        handleSave (row) {
          row.editable = !row.editable
          const url = updateAssignProjectList
          let params = {
            data: row
          }
          this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                this.getAssignedProject()
                this.$common.toast('保存成功', 'success', 'false')
              }
            })
        },
        // 取消
        handleCancel (row) {
          row.editable = !row.editable
        },
        // 项目级别过滤方法
        projectLevelsFilter (value, row) {
          return row.projectLevel === value
        },
        // 项目经理过滤方法
        usersFilterMethod (value, row) {
          return row.projectManagerID === value
        },
        // 删除操作
        handleAssignDelete (row, index) {
          this.$common.msgBox('confirm', '操作提示', '确定删除？', () => {
            if (this.reqFlag.deleteAssignProject) {
              this.reqFlag.deleteAssignProject = false
              const url = deleteAssignProject
              this.assignedTable.splice(index, 1)
              let params = {
                id: row.id
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('操作成功', 'success', false)
                  } else {
                    this.$common.toast('操作失败', 'warning', false)
                  }
                  this.reqFlag.deleteAssignProject = true
                })
            }
          })
        },
        // 获取指派项目计划&进展明细
        getAssignProjectDetail (id) {
          let it = this
          return new Promise(function (resolve, reject) {
            if (it.reqFlag.getAssignProjectDetail) {
              it.reqFlag.getAssignProjectDetail = false
              const url = getAssignProjectDetail
              let params = {
                id: id,
                year: it.formData.yearNum
              }
              it.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    for (let item of res.data) {
                      item.editable = false
                    }
                    it.formData.tableData = res.data
                    it.reqFlag.getAssignProjectDetail = true
                  }
                })
            }
          })
        },
        // 查看项目详情
        handleProjectDetailClick (row) {
          this.showFlag.projectDetail = true
          this.getAssignProjectDetail(row.id)
          this.checkAssignProjectID = row.id
          this.assignProjectName = row.projectName
        },
        // 表格列合并方法
        objectSpanMethod ({ row, column, rowIndex, columnIndex }) {
          if (columnIndex === 0 || columnIndex === 1 || columnIndex === 2 || columnIndex === 3) {
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
        // 上一年度进展
        handleDecYear () {
          if (this.reqFlag.getAssignProjectDetail) {
            this.formData.yearNum -= 1
            this.getAssignProjectDetail(this.checkAssignProjectID)
          }
        },
        // 下一年度进展
        handleAddYear () {
          if (this.reqFlag.getAssignProjectDetail) {
            this.formData.yearNum += 1
            this.getAssignProjectDetail(this.checkAssignProjectID)
          }
        },
        // 新增项目阶段
        addNewLine () {
          if (this.tableData.length > 0) {
            let obj = {
              avaiableWorkTime: 0,
              defaultAssginWorkTime: 0,
              dynamicKValue: 1,
              isConference: 0,
              kValue: 1,
              projectManager: this.tableData[0].projectManager,
              projectManagerID: this.tableData[0].projectManagerID,
              projectName: '',
              projectType: this.tableData[0].projectType,
              projectTypeID: 72,
              workTime: 0,
              workType: ''
            }
            this.tableData.push(obj)
          } else {
            this.$common.toast('请选择指派任务类型', 'warning', 'false')
          }
        }
      },
      computed: {
        tableMaxHeight () {
          return window.innerHeight - 170 + 'px'
        },
        totalWorkTime () {
          let total = 0
          for (let item of this.tableData) {
            total += item.avaiableWorkTime * item.kValue
          }
          return total
        }
      },
      filters: {
        projectLevelColorFilter (projectLevel) {
          switch (projectLevel) {
            case 1:
              return 'info'
            case 2:
              return 'success'
            case 3:
              return 'warning'
            case 4:
              return 'danger'
            default:
              return 'primary'
          }
        },
        projectLevelStringFilter (projectLevel) {
          switch (projectLevel) {
            case 1:
              return '普通任务'
            case 2:
              return '处室重点任务'
            case 3:
              return '部门重点任务'
            case 4:
              return '公司重点任务'
            default:
              return '错误'
          }
        },
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
        console.log('ProjectAssign created!')
        this.init()
      },
      name: 'ProjectAssign'
    }
</script>

<style scoped>

</style>

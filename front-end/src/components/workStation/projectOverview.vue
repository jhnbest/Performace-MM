<template>
  <div v-if="showFlag.isFresh">
    <el-table
      row-key="id"
      :data="formData.tableData"
      :row-class-name="tableRowClassName"
      :header-cell-style="{ backgroundColor: fatherParams.color, color: '#333'}"
      size="medium"
      style="margin: auto;width: 99%"
      v-loading="!reqFlag.getAssignProjectList">
      <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
      <el-table-column label="指派时间" align="center" prop="assignDate"  width="100"></el-table-column>
      <el-table-column label="项目名称" align="center" show-overflow-tooltip>
        <template slot-scope="scope">
          <span class="link-type" @click="handleEditProject(scope.row)">{{scope.row.projectName}}</span>
        </template>
      </el-table-column>
      <el-table-column v-if="$store.state.userInfo.role === '管理员'"
                       label="项目经理"
                       align="center"
                       prop="projectManager" width="100"></el-table-column>
      <el-table-column label="项目级别" align="center" prop="projectName" width="120">
        <template slot-scope="scope">
          <div>
            <el-tag :type="scope.row.projectLevel | projectLevelColorFilter">
              {{scope.row.projectLevel | projectLevelStringFilter}}
            </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="总完成度" align="center" width="80">
        <template slot-scope="scope">
          <el-progress :text-inside="true" :stroke-width="26" :percentage="scope.row.process"></el-progress>
        </template>
      </el-table-column>
      <el-table-column label="当前阶段" align="center" width="80"></el-table-column>
      <el-table-column label="计划阶段" align="center" width="80"></el-table-column>
      <el-table-column label="指派人" align="center" prop="assigner" width="100"></el-table-column>
      <el-table-column label="操作" align="center" width="180">
        <template slot-scope="scope">
          <el-button v-if="fatherParams.searchType === 'unFilled'"
                     size="mini"
                     type="primary"
                     @click="handleFillIn(scope.row)">填报进度</el-button>
          <el-button v-if="fatherParams.searchType === 'Filled'"
                     type="primary"
                     size="mini"
                     @click="handleFillIn(scope.row)">重新填报</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="editProject" width="80%" center>
      <span slot="title" style="font-weight: bolder;font-size: 20px">{{dialogProjectName + '项目'}}</span>
      <el-table :data="dialogProjectData"
                border
                style="margin: auto;width: 99%"
                size="mini"
                :height="300"
                :header-cell-style="{ backgroundColor: '#67d4f6', color: '#333'}">
        <el-table-column label="序号" align="center" type="index"></el-table-column>
        <el-table-column label="项目阶段" align="center">
          <template slot-scope="scope">
            <div v-if="scope.row.editable">
              <div v-if="scope.row.apdID === -1">
                <el-cascader
                  v-model="scope.row.selectProjectID"
                  :options="projectTypeOptions"
                  filterable
                  :props="props"
                  @change="handleProjectTypeChange(scope.row)"
                  clearable
                  :show-all-levels="false"
                  size="mini"
                  ref="projectStageType">
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
                <div v-if="scope.row.projectStageID === 72" style="margin-top: 10px">
                  <span>项目阶段名称：</span>
                  <el-tooltip :disabled="!scope.row.isShowProjectStageNameToolTip"
                              :content="scope.row.projectStageName"
                              placement="top">
                    <el-input v-model="scope.row.projectStageName"
                              style="width: 50%"
                              size="mini"
                              @input="handleProjectStageNameInput(scope.row)"></el-input>
                  </el-tooltip>
                  <span>字数限制：
                  <span v-if="!scope.row.isProjectNameWordExceed">
                    {{scope.row.inputProjectStageNameWord + '/' + maxProjectStageName}}</span>
                  <span v-else style="color: red">
                    {{scope.row.inputProjectStageNameWord + '/' + maxProjectStageName}}</span>
                </span>
                </div>
              </div>
              <div v-else-if="scope.row.projectStageID === 72">
                <el-input size="mini" v-model="scope.row.projectStageName"></el-input>
              </div>
              <div v-else>
                {{scope.row.projectStageName}}
              </div>
            </div>
            <div v-else>{{scope.row.projectStageName}}</div>
          </template>
        </el-table-column>
        <el-table-column label="基本工时" align="center" width="180">
          <template slot-scope="scope">
            <div v-if="scope.row.projectStageID === 72 && scope.row.editable === true">
              <el-input-number v-model="scope.row.baseWorkTime"
                               size="mini"
                               :min="0"
                               style="width: 60%"></el-input-number>
            </div>
            <div v-else>
              {{scope.row.baseWorkTime}}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="K值" align="center" width="180">
          <template slot-scope="scope">
            <div v-if="scope.row.editable">
              <el-input-number v-model="scope.row.kValue"
                               size="mini"
                               :min="0"
                               style="width: 60%"
                               :disabled="scope.row.dynamicKValue !== 1"></el-input-number>
            </div>
            <div v-else>
              {{scope.row.kValue}}
            </div>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="200">
          <template slot-scope="scope">
            <div v-if="scope.row.process !== 100">
              <el-button v-if="scope.row.apdID !== -1 && !scope.row.editable"
                         size="mini"
                         type="primary"
                         @click="handleProjectStageEdit(scope.row)">编辑</el-button>
              <el-button v-if="scope.row.apdID !== -1 && scope.row.editable"
                         size="mini"
                         type="warning"
                         @click="handleSaveProjectStageEdit(scope.row)">保存</el-button>
              <el-popconfirm
                confirm-button-text='确定'
                cancel-button-text='取消'
                icon="el-icon-info"
                icon-color="red"
                title="确定删除？"
                @confirm="handleProjectStageDelete(scope.row, scope.$index)">
                <el-button slot="reference"
                           size="mini"
                           type="danger" style="margin-left: 10px">删除</el-button>
              </el-popconfirm>
            </div>
            <div v-else>
              <el-button type="info" :disabled="true" size="mini">该阶段已完成</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
      <div style="text-align: center;margin-top: 10px">
        <el-button type="primary" size="mini" @click="addNewProjectStage" :disabled="projectIsFinish">新增项目阶段</el-button>
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" size="medium" @click="handleSaveProjectStage">保存</el-button>
        <el-button @click="editProject = false" size="medium">取消</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
    import {
      getAssignProjectList,
      deleteAssignProject,
      ulrGetWorkTimeNew,
      getAssignProjectStageList,
      getWorkTimeListOfProjectStage,
      updateEditProjectStage } from '@/config/interface'
    import { getProjectType } from '@/utils/performance'
    export default {
      data () {
        return {
          formData: {
            tableData: []
          },
          showFlag: {
            projectPlanProcess: false,
            isFresh: true
          },
          reqFlag: {
            getAssignProjectList: true,
            deleteProject: true
          },
          editProject: false,
          dialogProjectName: '',
          dialogProjectData: null,
          projectTypeOptions: null,
          projectType: null,
          assignerID: null,
          props: {
            value: 'projectTypeID',
            label: 'projectName',
            expandTrigger: 'hover'
          },
          maxProjectStageName: 50,
          iniProjectStage: [],
          aplID: null,
          projectIsFinish: true
        }
      },
      methods: {
        // 初始化
        init () {
          this.getAssignProjectList().then(getAssignProjectListRes => { // 获取项目列表
            this.formData.tableData = getAssignProjectListRes
          }).catch(getAssignProjectListErr => {
            this.$common.toast('初始化失败' + getAssignProjectListErr, 'error', true)
          })
          getProjectType(this.$store.state.userInfo.groupName).then(getProjectTypeRes => { // 获取项目类型，编辑项目阶段用
            this.projectTypeOptions = getProjectTypeRes
          }).catch(getProjectTypeErr => {
            this.$common.toast('初始化失败' + getProjectTypeErr, 'error', true)
          })
        },
        // 获取指派的项目列表
        getAssignProjectList () {
          if (this.reqFlag.getAssignProjectList) {
            this.reqFlag.getAssignProjectList = false
            let params = {
              id: this.$store.state.userInfo.id,
              projectType: this.fatherParams.projectTypeID,
              searchType: this.fatherParams.searchType
            }
            const url = getAssignProjectList
            let _this = this
            return new Promise(function (resolve, reject) {
              _this.$http(url, params).then(res => {
                if (res.code === 1) {
                  _this.$emit('countFeedback', res.data[1][0].totalCount)
                  resolve(res.data[0])
                } else {
                  reject(res.err)
                }
                _this.reqFlag.getAssignProjectList = true
              }).catch(err => {
                _this.reqFlag.getAssignProjectList = true
                reject(err)
              })
            })
          }
        },
        // 获取项目阶段列表
        getAssignProjectStageList (projectID) {
          const url = getAssignProjectStageList
          let params = {
            projectID: projectID
          }
          let _this = this
          return new Promise(function (resolve, reject) {
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                let recvData = res.data
                resolve(recvData)
              } else {
                reject(new Error('获取项目列表失败'))
              }
            })
          })
        },
        // 编辑项目阶段
        handleProjectStageEdit (row) {
          row.editable = true
        },
        // 保存项目阶段
        handleSaveProjectStageEdit (row) {
          row.editable = false
        },
        // 获取项目类型相关信息
        getProjectTypeInfo (projectStageID, parentID) {
          const url = ulrGetWorkTimeNew
          let params = {
            checkID: [projectStageID],
            parentID: parentID
          }
          let _this = this
          return new Promise(function (resolve, reject) {
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                resolve(res.data)
              } else {
                reject(new Error('getProjectTypeInfo Error!'))
              }
            })
          })
        },
        // 选中的项目类型变化
        handleProjectTypeChange (row) {
          if (row.selectProjectID.length > 0) {
            this.resetProjectStageStatus(row)
            row.editable = true
            row.projectStageID = row.selectProjectID[row.selectProjectID.length - 1]
            if (row.projectStageID !== 72) { // 非自定义项目阶段
              this.getProjectTypeInfo(row.projectStageID, row.selectProjectID[0]).then(res0 => {
                row.dynamicKValue = res0[0].dynamicKValue
                row.baseWorkTime = res0[0].workTime
                row.kValue = 1
                row.projectStageName = res0[0].projectName
              }).catch(err => {
                this.$common.toast(err, 'error', false)
              })
            } else {
              row.dynamicKValue = 1
            }
          }
        },
        // 表格颜色控制
        tableRowClassName ({ row, rowIndex }) {
          if (rowIndex % 2 === 1) {
            return 'warning-row'
          } else {
            return 'success-row'
          }
        },
        // 点击填报按钮事件
        handleFillIn (row) {
          this.$router.push({
            path: '/home/projectPlanProcess',
            query: {
              projectName: row.projectName,
              projectID: row.id,
              process: row.process
            }
          })
        },
        // 删除按钮
        handleDelete (row) {
          this.$common.msgBox('confirm', '操作提示', '此操作将删除所有与该项目相关的工时申报（包括已获得工时），确定删除？', () => {
            if (this.reqFlag.deleteProject) {
              this.reqFlag.deleteProject = false
              const url = deleteAssignProject
              let params = {
                id: row.id
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('操作成功', 'success', false)
                  } else {
                    this.$common.toast('操作失败', 'danger', false)
                  }
                  this.showFlag.isFresh = false
                  this.init()
                  setTimeout(() => {
                    this.showFlag.isFresh = true
                  }, this.$store.state.refreshInterval)
                  this.reqFlag.deleteProject = true
                })
            }
          })
        },
        // 编辑项目
        handleEditProject (row) {
          this.projectIsFinish = row.process === 100.0
          this.dialogProjectData = []
          this.editProject = true
          this.dialogProjectName = row.projectName
          this.assignerID = row.assignerID
          this.aplID = row.id
          this.getAssignProjectStageList(row.id).then(res0 => {
            for (let item of res0) {
              item.editable = false
            }
            this.dialogProjectData = res0
            this.iniProjectStage = JSON.parse(JSON.stringify(res0))
          }).catch(err => {
            this.$common.toast(err, 'error', true)
          })
        },
        // 重置项目阶段为初始状态
        resetProjectStageStatus (projectStage) {
          projectStage.inputProjectStageNameWord = 0
          projectStage.isProjectNameWordExceed = false
          projectStage.isShowProjectNameToolTip = false
          projectStage.editable = false
          projectStage.baseWorkTime = null
          projectStage.kValue = null
          projectStage.dynamicKValue = null
        },
        // 新增项目阶段
        addNewProjectStage () {
          this.dialogProjectData.push({
            aplID: this.aplID,
            apdID: -1,
            inputProjectStageNameWord: 0,
            isProjectNameWordExceed: false,
            isShowProjectNameToolTip: false,
            editable: true,
            baseWorkTime: null,
            kValue: null,
            dynamicKValue: 1
          })
        },
        // 项目阶段名称监控
        handleProjectStageNameInput (row) {
          row.inputProjectStageNameWord = row.projectStageName.length
          row.isProjectNameWordExceed = row.projectStageName.length > this.maxProjectStageName
          if (row.isProjectNameWordExceed) {
            this.$common.toast('项目阶段名称字数过多，请删减', 'error', false)
          }
          row.isShowProjectNameToolTip = row.projectStageName.length > 6
        },
        // 删除项目阶段
        handleProjectStageDelete (row, index) {
          if (row.apdID !== -1) {
            const url = getWorkTimeListOfProjectStage
            let params = {
              apdID: row.apdID
            }
            this.$http(url, params).then(res => {
              if (res.code === 1) {
                let recvData = res.data
                if (recvData.length > 0) {
                  this.$common.toast('该阶段已申报过工时，暂无法删除', 'error', true)
                } else {
                  this.dialogProjectData.splice(index, 1)
                }
              } else {
                this.$common.toast('recv handleProjectStageDelete error!', 'error', false)
              }
            }).catch(err => {
              this.$common.toast('send handleProjectStageDelete error!' + err, 'error', false)
            })
          }
        },
        // 保存按钮
        handleSaveProjectStage () {
          const url = updateEditProjectStage
          let iniApdID = []
          let curApdID = []
          let newProjectStage = []
          let updateProjectStage = []
          for (let item of this.iniProjectStage) {
            iniApdID.push(item.apdID)
          }
          for (let item of this.dialogProjectData) {
            if (item.apdID !== -1) {
              curApdID.push(item.apdID)
              updateProjectStage.push(item)
            } else {
              newProjectStage.push(item)
            }
          }
          let deleteApdID = iniApdID.filter(x => curApdID.indexOf(x) === -1)
            .concat(curApdID.filter(x => iniApdID.indexOf(x) === -1))
          let params = {
            updateProjectStage: updateProjectStage,
            newProjectStage: newProjectStage,
            deleteApdID: deleteApdID
          }
          this.$http(url, params).then(res => {
            if (res.code === 1) {
              this.$common.toast('保存成功', 'success', false)
              this.editProject = false
            } else {
              this.$common.toast('保存失败', 'error', false)
            }
          }).catch(err => {
            this.$common.toast('提交失败' + err, 'error', false)
          })
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
        reviewStatusTypeFilter (reviewStatus) {
          switch (reviewStatus) {
            case 0:
              return 'info'
            case 1:
              return 'success'
            case 2:
              return 'danger'
            default:
              return 'danger'
          }
        },
        reviewStatusStringFilter (reviewStatus) {
            switch (reviewStatus) {
              case 0:
                return '未审核'
              case 1:
                return '通过'
              case 2:
                return '驳回'
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
      components: {
      },
      props: {
        fatherParams: {
          type: Object,
          default: null
        }
      },
      name: 'projectOverview.vue'
    }
</script>

<style scoped>

</style>

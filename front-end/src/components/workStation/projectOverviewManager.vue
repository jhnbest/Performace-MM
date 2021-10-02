<template>
    <div class="main-content">
      <el-table row-key="id"
                :data="tableData"
                size="medium"
                style="margin: auto"
                v-loading="!reqFlag.getProjectList" >
        <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
        <el-table-column label="项目名称" align="center" prop="projectName" show-overflow-tooltip width="200"></el-table-column>
        <el-table-column label="项目级别" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.projectLevel | projectLevelColorFilter">
              <span>{{scope.row.projectLevel | projectLevelStringFilter}}</span>
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="项目经理" align="center" prop="projectManager" width="100"></el-table-column>
<!--        <el-table-column label="状态" align="center" prop="projectStatus">-->
<!--        </el-table-column>-->
        <el-table-column label="当前阶段" align="center" prop="curProjectStage"></el-table-column>
        <el-table-column label="计划阶段" align="center" prop="planProjectStage"></el-table-column>
        <el-table-column label="当前阶段进度" align="center">
          <template slot-scope="scope">
            <el-progress type="dashboard"
                         :percentage="scope.row.curProjectStageProcess === null? 0 : scope.row.curProjectStageProcess"
                         :color="progressColors" :width="80"></el-progress>
          </template>
        </el-table-column>
        <el-table-column label="总进度" align="center">
          <template slot-scope="scope">
            <el-progress type="dashboard"
                         :percentage="scope.row.totalProjectStageProcess"
                         :color="progressColors" :width="80"></el-progress>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template slot-scope="scope">
            <el-button type="primary" @click="handleCheckDetails(scope.row)" size="medium">查看详情</el-button>
          </template>
        </el-table-column>
      </el-table>
      <project-process-detail v-if="projectProcessDetail"
                              :projectStage="this.tableDataCache.projectStage"
                              :monthProcess="this.tableDataCache.monthProcess"
                              :projectListIndex="projectListIndex"
                              :project-name="projectName"
                              :cur-year-num="this.curApplyYear"
                              :project-type-i-d="this.fatherParams.projectTypeID"
                              :is-finish="0"
                              @close="projectProcessDetail = false"></project-process-detail>
    </div>
</template>

<script>
  import { getCurApplyAbleMonth, monthNumToMonthString } from '../../utils/common'
  import { getTypeProjectList } from '../../utils/workStation'
  import projectProcessDetail from './projectProcessDetail'
  export default {
      data () {
        return {
          tableData: [],
          curApplyYear: null,
          curApplyMonth: null,
          reqFlag: {
            getProjectList: true
          },
          tableDataCache: [],
          projectProcessDetail: false,
          selectProjectStage: null,
          progressColors: this.$store.state.progressColors,
          projectListIndex: null,
          projectName: null
        }
      },
      props: {
        fatherParams: {
          type: Object,
          default: null
        }
      },
      methods: {
        // 初始化
        init () {
          if (this.reqFlag.getProjectList) {
            this.reqFlag.getProjectList = false
            getCurApplyAbleMonth().then(getCurApplyAbleMonthRes => {
              this.curApplyYear = this.$moment(getCurApplyAbleMonthRes[0].setTime).year()
              this.curApplyMonth = this.$moment(getCurApplyAbleMonthRes[0].setTime).month()
              getTypeProjectList(this.fatherParams.projectTypeID, 0, this.curApplyYear)
                .then(getTypeProjectListRes => {
                  console.log('getTypeProjectListRes')
                  console.log(getTypeProjectListRes)
                  this.genTableData(getTypeProjectListRes, this.curApplyMonth)
                  this.reqFlag.getProjectList = true
                })
            })
          }
        },
        // 生成表格数据
        genTableData (getTypeProjectListRes, curApplyMonth) {
          let projectList = getTypeProjectListRes.projectList
          let projectStage = getTypeProjectListRes.projectStage
          let monthProcess = getTypeProjectListRes.monthProcess
          this.tableDataCache = getTypeProjectListRes
          this.tableData = []
          for (let i = 0; i < projectList.length; i++) {
            let obj = {
              projectName: projectList[i].projectName,
              projectManager: projectList[i].projectManager,
              totalProjectStageProcess: projectList[i].process,
              projectLevel: projectList[i].projectLevel,
              curProjectStage: null,
              curProjectStageProcess: null,
              projectListIndex: i
            }
            for (let projectStageItem of projectStage[i]) {
              if (projectStageItem.process !== 0) {
                obj.curProjectStage = projectStageItem.projectStageName
                obj.curProjectStageProcess = projectStageItem.process
              }
            }
            for (let monthProcessItem of monthProcess[i]) {
              if (monthProcessItem.length !== 0) {
                for (let monthProcessItemItem of monthProcessItem) {
                  if (monthProcessItemItem.type === 'plan') {
                    if (monthProcessItemItem[monthNumToMonthString(curApplyMonth + 1)] !== null) {
                      obj.planProjectStage = monthProcessItemItem.projectStageName
                    }
                  }
                }
              }
            }
            this.tableData.push(obj)
          }
        },
        // 查看详情
        handleCheckDetails (row) {
          console.log('row')
          console.log(row)
          this.projectListIndex = row.projectListIndex
          this.projectName = row.projectName
          this.projectProcessDetail = true
        },
        // 点击项目名称
        handleClickProject () {
          this.$common.toast('点我', 'info', false)
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
      components: {
        projectProcessDetail
      },
      created () {
        this.init()
      },
      name: 'projectOverviewManager'
    }
</script>

<style scoped>

</style>

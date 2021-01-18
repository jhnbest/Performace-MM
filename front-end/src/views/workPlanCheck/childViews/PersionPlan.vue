<template>
  <div>
    <el-tabs v-model="selectProjectType" @tab-click="handleProjectTypeChange" v-if="showFlag.showTabs">
      <el-tab-pane v-for="projectType in projectTypes"
                   :key="projectType.projectTypeID"
                   :name="String(projectType.projectTypeID)" :lazy="true">
        <span slot="label"> {{ projectType.projectTypeName }}
          <el-badge :value="projectType.count" class="item"></el-badge></span>
        <div>
          <el-select v-model="selectProject"
                     placeholder="请选择项目"
                     size="medium"
                     clearable
                     style="width: 100%"
                     @change="handleSelectProjectChange"
                     filterable>
            <el-option
              v-for="item in projects"
              :key="item.id"
              :label="item.projectName"
              :value="item.id">
            </el-option>
          </el-select>
        </div>
        <br>
        <div>
          <el-table
            :data="tableData"
            style="margin: auto"
            border size="mini"
            @cell-click="cellClick"
            highlight-current-row>
            <el-table-column label="项目阶段" align="center" prop="projectStageName" show-overflow-tooltip></el-table-column>
            <el-table-column label="计划进展" align="center">
              <el-table-column
                v-for="item in Months"
                :key="item.id"
                :label="item.name"
                align="center"
                :prop="item.eName" width="70%">
                <template slot-scope="scope">
                  <span v-if="scope.row[item.eName] !== null">{{scope.row[item.eName] + '%'}}</span>
                </template>
              </el-table-column>
            </el-table-column>
          </el-table>
        </div>
        <br>
        <div class="chart-container">
          <planChart v-if="selectProjectType === String(projectType.projectTypeID)"
                     height="100%"
                     width="100%"
                     ref="planChart"
                     :title=" projects[0]? projects[0].name : ' '"></planChart>
        </div>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import echarts from 'echarts'
  import planChart from './planChart'
  import { getPlanInfo, getAssignedProjectPlan } from '@/config/interface'
  export default {
    data () {
      return {
        planChart: null,
        selectProjectType: null,
        projectTypes: [],
        tableData: [],
        Months: [{
          id: 1,
          name: '1月',
          eName: 'January'
        }, {
          id: 2,
          name: '2月',
          eName: 'February'
        }, {
          id: 3,
          name: '3月',
          eName: 'March'
        }, {
          id: 4,
          name: '4月',
          eName: 'April'
        }, {
          id: 5,
          name: '5月',
          eName: 'May'
        }, {
          id: 6,
          name: '6月',
          eName: 'June'
        }, {
          id: 7,
          name: '7月',
          eName: 'July'
        }, {
          id: 8,
          name: '8月',
          eName: 'August'
        }, {
          id: 9,
          name: '9月',
          eName: 'September'
        }, {
          id: 10,
          name: '10月',
          eName: 'October'
        }, {
          id: 11,
          name: '11月',
          eName: 'November'
        }, {
          id: 12,
          name: '12月',
          eName: 'December'
        }],
        projects: [],
        showFlag: {
          showTabs: true,
          planChartShow: true
        },
        selectProject: null
      }
    },
    methods: {
      // 初始化
      init () {
        console.log('init')
        this.getAssignedProject(this.userInfo.year).then(() => {
        })
      },
      // 获取项目类型数组索引
      getIndexOfProjectType (projectTypeID) {
        if (this.projectTypes.length === 0) {
          return -1
        }
        for (let i = 0; i < this.projectTypes.length; i++) {
          if (this.projectTypes[i].projectTypeID === projectTypeID) {
            return i
          }
        }
        return -1
      },
      // 获取项目信息数组索引
      getIndexOfProjects (projectID) {
        for (let i = 0; i < this.projects.length; i++) {
          if (this.projects[i].id === projectID) {
            return i
          }
        }
      },
      // 获取选择项目的数组索引
      getSelectProjectIndex (projectTypeIndex, selectProject) {
        if (this.projectTypes[projectTypeIndex].projects.length === 0) {
          console.log('err')
          return -1
        }
        for (let i = 0; i < this.projectTypes[projectTypeIndex].projects.length; i++) {
          if (selectProject === this.projectTypes[projectTypeIndex].projects[i].id) {
            return i
          }
        }
        return -1
      },
      // 获取项目承担的项目列表
      getAssignedProject (year) {
        const url = getAssignedProjectPlan
        let params = {
          userID: this.userInfo.userID,
          year: year
        }
        this.projects = []
        this.tableData = []
        this.projectTypes = []
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                if (res.data.length > 0) {
                  // _this.selectProjectType = String(res.data[0].projectType)
                  for (let item of res.data) {
                    let index = _this.getIndexOfProjectType(item.projectType)
                    if (index === -1) {
                      let obj = {
                        projectTypeID: item.projectType,
                        projectTypeName: item.projectTypeName,
                        count: 1,
                        projects: []
                      }
                      _this.projectTypes.push(obj)
                      let length = _this.projectTypes.length
                      _this.projectTypes[length - 1].projects.push(item)
                    } else {
                      _this.projectTypes[index].count++
                      _this.projectTypes[index].projects.push(item)
                    }
                  }
                  // _this.projects = _this.projectTypes[0].projects
                  // _this.selectProject = _this.projectTypes[0].projects[0].id
                  // for (let projectDetail of _this.projectTypes[0].projects[0].projectDetail) {
                  //   _this.tableData.push(projectDetail[0])
                  // }
                }
                resolve(res.data)
              }
            })
        })
      },
      // 获取项目计划信息
      getPlanInfo () {
      },
      // 更新图表
      refreshPlanChart () {
        this.showFlag.planChartShow = false
        setTimeout(() => {
          this.showFlag.planChartShow = true
        }, this.$store.state.refreshInterval)
      },
      // 获取项目每月预计获得工时
      getPlanGetWorkTime (data) {
        let planGetWorkTime = []
        let totalProcess = []
        let projectDetailNum = data.projectDetail.length
        // let unusedProjectDetailNum = 0
        // for (let projectDetailItem of data.projectDetail) {
        //   let count = 0
        //   for (let i = 0; i < this.Months.length; i++) {
        //     let MonthProcess = projectDetailItem[0][this.Months[i].eName]
        //     if (!MonthProcess) {
        //       count++
        //     }
        //   }
        //   if (count === this.Months.length) {
        //     unusedProjectDetailNum++
        //   }
        // }
        // projectDetailNum -= unusedProjectDetailNum
        for (let projectDetailItem of data.projectDetail) {
          for (let i = 0; i < this.Months.length; i++) {
            // console.log(projectDetailItem[0][this.Months[i].eName])
            let getWorkTime = 0
            let MonthProcess = projectDetailItem[0][this.Months[i].eName]
            let baseWorkTime = projectDetailItem[0].baseWorkTime
            let kValue = projectDetailItem[0].kValue
            let curMonthProcess = 0
            if (MonthProcess) {
              if (i !== 0) {
                let preMonthProcess = projectDetailItem[0][this.Months[i - 1].eName]
                getWorkTime = (MonthProcess - preMonthProcess) * baseWorkTime * kValue * 0.01
                curMonthProcess = (MonthProcess - preMonthProcess) * (1 / projectDetailNum)
              } else {
                getWorkTime = MonthProcess * baseWorkTime * kValue * 0.01
                curMonthProcess = MonthProcess * (1 / projectDetailNum)
              }
            }
            if (planGetWorkTime[i] || planGetWorkTime[i] === 0) {
              planGetWorkTime[i] += getWorkTime
              planGetWorkTime[i] = Number(planGetWorkTime[i].toFixed(2))
            } else {
              planGetWorkTime.push(getWorkTime)
            }
            if (totalProcess[i] || totalProcess[i] === 0) {
              totalProcess[i] += curMonthProcess
            } else {
              totalProcess.push(curMonthProcess)
            }
          }
        }
        totalProcess[0] = Number(totalProcess[0].toFixed(1))
        for (let i = 1; i < totalProcess.length; i++) {
          totalProcess[i] += totalProcess[i - 1]
          totalProcess[i] = Number(totalProcess[i].toFixed(1))
          if (totalProcess[i] > 100) {
            totalProcess[i] = 100
          }
        }
        let obj = {
          planGetWorkTime: planGetWorkTime,
          totalProcess: totalProcess
        }
        console.log(obj)
        return obj
      },
      // 项目类型变化
      handleProjectTypeChange () {
        let index = this.getIndexOfProjectType(Number(this.selectProjectType))
        this.projects = this.projectTypes[index].projects
        this.selectProject = this.projectTypes[index].projects[0].id
        let result = this.getPlanGetWorkTime(this.projectTypes[index].projects[0])
        this.$nextTick(() => {
          this.$refs.planChart[0].updatePlanGetWorkTime(result.planGetWorkTime)
          this.$refs.planChart[0].updateTotalProcess(result.totalProcess)
          this.$refs.planChart[0].updateTitle(this.projects[0].projectName)
        })
        this.tableData = []
        for (let projectDetail of this.projectTypes[index].projects[0].projectDetail) {
          this.tableData.push(projectDetail[0])
        }
      },
      // 年份变化调用
      handleYearChange () {
        let index = this.getIndexOfProjectType(Number(this.selectProjectType))
        if (index !== -1) {
          this.projects = this.projectTypes[index].projects
          let selectProjectIndex = this.getSelectProjectIndex(index, this.selectProject)
          this.tableData = []
          for (let projectDetail of this.projectTypes[index].projects[selectProjectIndex].projectDetail) {
            this.tableData.push(projectDetail[0])
          }
          let result = this.getPlanGetWorkTime(this.projects[selectProjectIndex])
          this.$nextTick(() => {
            this.$refs.planChart[0].updatePlanGetWorkTime(result.planGetWorkTime)
            this.$refs.planChart[0].updateTotalProcess(result.totalProcess)
          })
        }
      },
      // 表格单元格点击
      cellClick () {
      },
      // 选择项目
      handleSelectProjectChange () {
        if (this.selectProject) {
          this.tableData = []
          let index = this.getIndexOfProjects(this.selectProject)
          for (let projectStage of this.projects[index].projectDetail) {
            this.tableData.push(projectStage[0])
          }
          let result = this.getPlanGetWorkTime(this.projects[index])
          this.$nextTick(() => {
            this.$refs.planChart[0].updatePlanGetWorkTime(result.planGetWorkTime)
            this.$refs.planChart[0].updateTotalProcess(result.totalProcess)
            this.$refs.planChart[0].updateTitle(this.projects[index].projectName)
          })
        }
      },
      // 销毁图表
      destroyPlanChart () {
        console.log('destroy')
        if (!this.planChart) {
          console.log('planChart not exist!')
          return
        }
        this.planChart.dispose()
        this.planChart = null
      }
    },
    components: {
      planChart
    },
    mounted () {
    },
    created () {
      this.init()
    },
    destroyed () {
    },
    beforeDestroy () {
      if (!this.planChart) {
        return
      }
      this.planChart.dispose()
      this.planChart = null
    },
    props: {
      userInfo: {
        type: Object,
        default: null
      }
    },
    name: 'PersionPlan.vue'
  }
</script>

<style scoped>
  .chart-container{
    position: relative;
    width: 100%;
    height: calc(100vh - 84px);
  }
</style>

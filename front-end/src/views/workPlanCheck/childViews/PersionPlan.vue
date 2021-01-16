<template>
  <div>
    <el-tabs v-model="selectProjectType" @tab-click="handleProjectTypeChange" v-if="showFlag.showTabs">
      <el-tab-pane v-for="projectType in projectTypes"
                   :key="projectType.projectTypeID"
                   :name="String(projectType.projectTypeID)">
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
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
  import echarts from 'echarts'
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
          showTabs: true
        },
        selectProject: null
      }
    },
    methods: {
      // 初始化
      init () {
        this.getAssignedProject(this.userInfo.year).then()
        // this.ChartInit()
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
      ChartInit () {
        this.planChart = echarts.init(document.getElementById(this.id))
        const xData = (function () {
          const data = []
          for (let i = 0; i < 12; i++) {
            data.push(i + 1 + '月')
          }
          return data
        }())
        this.planChart.setOption({
          backgroundColor: '#344b58',
          title: {
            text: 'statistics',
            x: '20',
            top: '20',
            textStyle: {
              color: '#fff',
              fontSize: '22'
            },
            subtextStyle: {
              color: '#90979c',
              fontSize: '16'
            }
          },
          tooltip: {
            trigger: 'axis',
            axisPointer: {
              textStyle: {
                color: '#fff'
              },
              type: 'shadow'
            }
          },
          grid: {
            left: '5%',
            right: '5%',
            borderWidth: 0,
            top: 150,
            bottom: 95,
            textStyle: {
              color: '#fff'
            }
          },
          legend: {
            x: '5%',
            top: '10%',
            textStyle: {
              color: '#90979c'
            },
            data: ['female', 'male', 'average', 'ffmale']
          },
          calculable: true,
          xAxis: [{
            type: 'category',
            axisLine: {
              lineStyle: {
                color: '#90979c'
              }
            },
            splitLine: {
              show: false
            },
            axisTick: {
              show: false
            },
            splitArea: {
              show: false
            },
            axisLabel: {
              interval: 0

            },
            data: xData
          }],
          yAxis: [{
            type: 'value',
            splitLine: {
              show: false
            },
            axisLine: {
              lineStyle: {
                color: '#90979c'
              }
            },
            axisTick: {
              show: false
            },
            axisLabel: {
              interval: 0
            },
            splitArea: {
              show: false
            }
          }],
          dataZoom: [{
            show: true,
            height: 30,
            xAxisIndex: [
              0
            ],
            bottom: 30,
            start: 10,
            end: 80,
            handleIcon: 'path://M306.1,413c0,2.2-1.8,4-4,4h-59.8c-2.2,0-4-1.8-4-4V200.8c0-2.2,1.8-4,4-4h59.8c2.2,0,4,1.8,4,4V413z',
            handleSize: '110%',
            handleStyle: {
              color: '#d3dee5'

            },
            textStyle: {
              color: '#fff' },
            borderColor: '#90979c'
          }, {
            type: 'inside',
            show: true,
            height: 15,
            start: 1,
            end: 35
          }],
          series: [{
            name: 'female',
            type: 'bar',
            stack: 'total',
            barMaxWidth: 35,
            barGap: '10%',
            itemStyle: {
              normal: {
                color: 'rgba(255,144,128,1)',
                label: {
                  show: true,
                  textStyle: {
                    color: '#fff'
                  },
                  position: 'insideTop',
                  formatter (p) {
                    return p.value > 0 ? p.value : ''
                  }
                }
              }
            },
            data: [
              709,
              1917,
              2455,
              2610,
              1719,
              1433,
              1544,
              3285,
              5208,
              3372,
              2484,
              4078
            ]
          }, {
            name: 'male',
            type: 'bar',
            stack: 'total',
            itemStyle: {
              normal: {
                color: 'rgba(0,191,183,1)',
                barBorderRadius: 0,
                label: {
                  show: true,
                  position: 'insideTop',
                  formatter (p) {
                    return p.value > 0 ? p.value : ''
                  }
                }
              }
            },
            data: [
              0,
              1776,
              507,
              1200,
              800,
              482,
              204,
              1390,
              1001,
              951,
              381,
              220
            ]
          }, {
            name: 'average',
            type: 'line',
            stack: 'total',
            symbolSize: 10,
            symbol: 'circle',
            itemStyle: {
              normal: {
                color: 'rgba(252,230,48,1)',
                barBorderRadius: 0,
                label: {
                  show: true,
                  position: 'top',
                  formatter (p) {
                    return p.value > 0 ? p.value : ''
                  }
                }
              }
            },
            data: [
              1036,
              3693,
              2962,
              3810,
              2519,
              1915,
              1748,
              4675,
              6209,
              4323,
              2865,
              4298
            ]
          }, {
            name: 'ffmale',
            type: 'bar',
            stack: 'total',
            itemStyle: {
              normal: {
                color: 'rgb(126,45,177)',
                barBorderRadius: 0,
                label: {
                  show: true,
                  position: 'insideTop',
                  formatter (p) {
                    return p.value > 0 ? p.value : ''
                  }
                }
              }
            },
            data: [
              0,
              1776,
              507,
              1200,
              800,
              482,
              204,
              1390,
              1001,
              951,
              381,
              220
            ]
          }]
        })
      },
      // 项目类型变化
      handleProjectTypeChange () {
        let index = this.getIndexOfProjectType(Number(this.selectProjectType))
        this.projects = this.projectTypes[index].projects
        this.selectProject = this.projectTypes[index].projects[0].id
        this.tableData = []
        for (let projectDetail of this.projectTypes[index].projects[0].projectDetail) {
          this.tableData.push(projectDetail[0])
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
        }
      }
    },
    components: {
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
      className: {
        type: String,
        default: 'chart'
      },
      id: {
        type: String,
        default: 'chart'
      },
      width: {
        type: String,
        default: '200px'
      },
      height: {
        type: String,
        default: '200px'
      },
      userInfo: {
        type: Object,
        default: null
      }
    },
    name: 'PersionPlan.vue'
  }
</script>

<style scoped>
</style>

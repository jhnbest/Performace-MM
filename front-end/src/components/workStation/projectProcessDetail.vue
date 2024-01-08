<template>
  <div>
    <el-dialog :visible.sync="projectProcessDetail"
               :title="projectName"
               :before-close="onClose"
               width="90%">
      <div>
        <el-button icon="el-icon-minus"
                   circle
                   size="mini"
                   type="danger"
                   @click="handleDescYearNum()"
                   :disabled="!reqFlag.getTypeProjectList"></el-button>
        <span style="font-size: 25px;color: red;font-weight: bolder;margin: 10px">{{ yearNum + '年' }}</span>
        <el-button icon="el-icon-plus"
                   circle
                   size="mini"
                   type="primary"
                   @click="handleAddYearNum()"
                   :disabled="!reqFlag.getTypeProjectList"></el-button>
      </div>
      <br>
      <div>
        <el-table :data="tableData"
                  stripe
                  border
                  size="mini"
                  resizable
                  :span-method="objectSpanMethod"
                  :height="500"
                  ref="rateTable"
                  v-loading="!this.reqFlag.getTypeProjectList">
          <el-table-column label="项目阶段" align="center" prop="projectStageName">
            <template slot-scope="scope">
              <span>{{ scope.row.projectStageName }}</span>
              <span v-if="scope.row.process === 100" style="color: red">（已完成）</span>
            </template>
          </el-table-column>
          <el-table-column label="标准工时" align="center" prop="baseWorkTime" width="50%"></el-table-column>
          <el-table-column label="K值" align="center" prop="kValue" width="50%"></el-table-column>
          <!-- <el-table-column label="类型" align="center" prop="type" width="50%">
            <template slot-scope="scope">
              <span>{{scope.row.type | processTypeFilter}}</span>
            </template>
          </el-table-column> -->
          <el-table-column label="项目进度" align="center">
            <el-table-column label="1月" align="center" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.January !== null && scope.row.January">{{scope.row.January + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="2月" align="center" prop="February" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.February !== null && scope.row.February">{{scope.row.February + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="3月" align="center" prop="March" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.March !== null && scope.row.March">{{scope.row.March + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="4月" align="center" prop="April" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.April !== null && scope.row.April">{{scope.row.April + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="5月" align="center" prop="May" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.May !== null && scope.row.May">{{scope.row.May + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="6月" align="center" prop="June" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.June !== null && scope.row.June">{{scope.row.June + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="7月" align="center" prop="July" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.July !== null && scope.row.July">{{scope.row.July + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="8月" align="center" prop="August" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.August !== null && scope.row.August">{{scope.row.August + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="9月" align="center" prop="September" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.September !== null && scope.row.September">{{scope.row.September + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="10月" align="center" prop="October" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.October !== null && scope.row.October">{{scope.row.October + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="11月" align="center" prop="November" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.November !== null && scope.row.November">{{scope.row.November + '%'}}</span>
              </template>
            </el-table-column>
            <el-table-column label="12月" align="center" prop="December" width="73%">
              <template slot-scope="scope">
                <span v-if="scope.row.December !== null && scope.row.December">{{scope.row.December + '%'}}</span>
              </template>
            </el-table-column>
          </el-table-column>
        </el-table>
      </div>
    </el-dialog>
  </div>
</template>

<script>
  import { getMonthProcess } from '../../utils/workStation'
    export default {
      data () {
        return {
          tableData: [],
          tableHeight: null,
          projectProcessDetail: false,
          reqFlag: {
            getTypeProjectList: true
          },
          yearNum: null
        }
      },
      props: {
        projectStage: {
          type: Array,
          default: null
        },
        projectName: {
          type: String,
          default: null
        },
        curYearNum: {
          type: Number,
          default: null
        }
      },
      methods: {
        // 初始化
        init () {
          this.$nextTick(() => {
            this.projectProcessDetail = !this.projectProcessDetail
          })
          this.yearNum = this.curYearNum
          getMonthProcess(this.projectStage, this.yearNum).then(monthProcessRes => {
            this.genTableData(this.projectStage, monthProcessRes)
          })
        },
        // 生成表格数据
        genTableData (projectStage, monthProcess) {
          let obj = {}
          this.tableData = []
          for (let i = 0; i < projectStage.length; i++) {
            obj = {}
            obj.projectStageName = projectStage[i].projectStageName
            obj.baseWorkTime = projectStage[i].baseWorkTime
            obj.kValue = projectStage[i].kValue
            obj.process = projectStage[i].process
            if (monthProcess[i].length === 0) { // ***计划、进展都未填报
              this.tableData.push(JSON.parse(JSON.stringify(obj)))
            } else if (monthProcess[i].length === 1) { // ***只报了计划或者实际进展
              for (let j = 0; j < monthProcess[i].length; j++) {
                if (monthProcess[i][j].type === 'fact') {
                  obj.type = monthProcess[i][j].type
                  obj.January = monthProcess[i][j].January
                  obj.February = monthProcess[i][j].February
                  obj.March = monthProcess[i][j].March
                  obj.April = monthProcess[i][j].April
                  obj.May = monthProcess[i][j].May
                  obj.June = monthProcess[i][j].June
                  obj.July = monthProcess[i][j].July
                  obj.August = monthProcess[i][j].August
                  obj.September = monthProcess[i][j].September
                  obj.October = monthProcess[i][j].October
                  obj.November = monthProcess[i][j].November
                  obj.December = monthProcess[i][j].December
                }
                this.tableData.push(JSON.parse(JSON.stringify(obj)))
              }
            } else if (monthProcess[i].length === 2) { // ***计划和实际进展都有报
              for (let j = 0; j < monthProcess[i].length; j++) {
                if (monthProcess[i][j].type === 'fact') {
                  obj.type = monthProcess[i][j].type
                  obj.January = monthProcess[i][j].January
                  obj.February = monthProcess[i][j].February
                  obj.March = monthProcess[i][j].March
                  obj.April = monthProcess[i][j].April
                  obj.May = monthProcess[i][j].May
                  obj.June = monthProcess[i][j].June
                  obj.July = monthProcess[i][j].July
                  obj.August = monthProcess[i][j].August
                  obj.September = monthProcess[i][j].September
                  obj.October = monthProcess[i][j].October
                  obj.November = monthProcess[i][j].November
                  obj.December = monthProcess[i][j].December
                  this.tableData.push(JSON.parse(JSON.stringify(obj)))
                  break
                }
              }
            }
          }
        },
        // 表格列合并方法
        objectSpanMethod ({ row, column, rowIndex, columnIndex }) {
          // if (columnIndex === 0 || columnIndex === 1 || columnIndex === 2) {
          //   if (rowIndex % 2 === 0) {
          //     return {
          //       rowspan: 2,
          //       colspan: 1
          //     }
          //   } else {
          //     return {
          //       rowspan: 0,
          //       colspan: 0
          //     }
          //   }
          // }
        },
        // 关闭对话框
        onClose () {
          this.projectProcessDetail = !this.projectProcessDetail
          this.$emit('close')
        },
        // 年份减
        handleDescYearNum () {
          this.yearNum--
          if (this.reqFlag.getTypeProjectList) {
            this.reqFlag.getTypeProjectList = false
            getMonthProcess(this.projectStage, this.yearNum).then(monthProcessRes => {
              console.log('monthProcessRes')
              console.log(monthProcessRes)
              this.genTableData(this.projectStage, monthProcessRes)
              this.reqFlag.getTypeProjectList = true
            })
          }
        },
        // 年份加
        handleAddYearNum () {
          this.yearNum++
          if (this.reqFlag.getTypeProjectList) {
            this.reqFlag.getTypeProjectList = false
            getMonthProcess(this.projectStage, this.yearNum).then(monthProcessRes => {
              this.genTableData(this.projectStage, monthProcessRes)
              this.reqFlag.getTypeProjectList = true
            })
          }
        }
      },
      mounted () {
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
      name: 'projectProcessDetail'
    }
</script>

<style scoped>
</style>

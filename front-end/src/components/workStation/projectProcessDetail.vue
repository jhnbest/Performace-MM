<template>
  <div>
    <el-dialog :visible.sync="projectProcessDetail"
               :title="projectName"
               :before-close="onClose">
      <el-table :data="tableData"
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
              <span>{{scope.row.January + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="2月" align="center" prop="February" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.February + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="3月" align="center" prop="March" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.March + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="4月" align="center" prop="April" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.April + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="5月" align="center" prop="May" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.May + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="6月" align="center" prop="June" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.June + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="7月" align="center" prop="July" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.July + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="8月" align="center" prop="August" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.August + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="9月" align="center" prop="September" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.September + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="10月" align="center" prop="October" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.October + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="11月" align="center" prop="November" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.November + '%'}}</span>
            </template>
          </el-table-column>
          <el-table-column label="12月" align="center" prop="December" width="73%">
            <template slot-scope="scope">
              <span>{{scope.row.December + '%'}}</span>
            </template>
          </el-table-column>
        </el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
    export default {
      data () {
        return {
          tableData: [],
          tableHeight: null,
          projectProcessDetail: false
        }
      },
      methods: {
        // 初始化
        init () {
          this.$nextTick(() => {
            this.projectProcessDetail = !this.projectProcessDetail
          })
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
        // 关闭对话框
        onClose () {
          this.projectProcessDetail = !this.projectProcessDetail
          this.$emit('close')
        }
      },
      props: {
        projectStage: {
          type: Array,
          default: null
        },
        monthProcess: {
          type: Array,
          default: null
        },
        projectName: {
          type: String,
          default: null
        }
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
      name: 'projectProcessDetail'
    }
</script>

<style scoped>

</style>

<template>
  <div>
    <el-table :data="tableData" width="90%">
      <el-table-column label="序号" align="center" type="index"></el-table-column>
      <el-table-column label="项目名称" align="center" prop="projectName"></el-table-column>
      <el-table-column label="项目级别" align="center" prop="projectLevel">
        <template slot-scope="scope">
          <div>
            <el-tag :type="scope.row.projectLevel | projectLevelColorFilter">
              {{scope.row.projectLevel | projectLevelStringFilter}}
            </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="完成度" align="center" width="100">
        <template slot-scope="scope">
          <el-progress :text-inside="true" :stroke-width="26" :percentage="scope.row.process"></el-progress>
        </template>
      </el-table-column>
      <el-table-column label="总工时" align="center" prop="totalWorkTime"></el-table-column>
      <el-table-column label="操作" align="center">
        <template slot-scope="scope">
          <div>
            <el-button size="mini" type="primary" @change="handleEdit(scope.row, scope.$index)">编辑</el-button>
            <el-button size="mini" type="danger" @change="handleDelete(scope.row, scope.$index)">删除</el-button>
          </div>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
    export default {
      data () {
        return {
          tableData: []
        }
      },
      methods: {
        // 初始化
        init () {
        },
        // 表格编辑按钮
        handleEdit (row, index) {
        },
        // 表格删除按钮
        handleDelete (row, index) {
        }
      },
      created () {
        this.init()
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
        }
      },
      props: {
        fatherParams: {
          type: Object,
          default: null
        }
      },
      name: 'otherProject.vue'
    }
</script>

<style scoped>

</style>

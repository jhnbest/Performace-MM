<template>
  <div>
    <el-dialog title="基建类项目本月计划&进度" :visible.sync="formData.showFlag" custom-class="dialog-medium">
      <el-table :data="formData.tableData">
        <el-table-column label="序号" align="center" type="index" ></el-table-column>
        <el-table-column label="月份" align="center" prop="month"></el-table-column>
        <el-table-column label="阶段名称" align="center" prop="stage"></el-table-column>
        <el-table-column label="基本工时" align="center" prop="baseWorkTime" ></el-table-column>
        <el-table-column label="已完成进度" align="center" prop="curScheduled" ></el-table-column>
        <el-table-column label="计划进度" align="center" prop="planSchedule" ></el-table-column>
        <el-table-column label="本月进度" align="center" prop="realSchedule" ></el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
    export default {
      data () {
        return {
          formData: {
            showFlag: false,
            tableData: []
          }
        }
      },
      methods: {
        init () {
          this.$nextTick(() => {
            this.changeShowFlag()
          })
        },
        changeShowFlag () {
          this.formData.showFlag = !this.formData.showFlag
        }
      },
      name: 'XXProjectPlanProcess'
    }
</script>

<style scoped>

</style>

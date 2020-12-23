<template>
  <div>
    <el-form class="main-search" :inline="true">
      <el-form-item label="申报月份" prop="title">
        <el-date-picker
          v-model="formData.title"
          type="month"
          format="yyyy 第 MM 月"
          value-format="yyyy-MM"
          placeholder="选择月"
          style="width: 150px"
          @change="handelDateChange">
        </el-date-picker>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
    export default {
      data () {
        return {
          formData: {
            title: this.$moment().format('YYYY-MM')
          }
        }
      },
      methods: {
        handelDateChange () {
        }
      },
      name: 'workPlanCheck'
    }
</script>

<style scoped>

</style>

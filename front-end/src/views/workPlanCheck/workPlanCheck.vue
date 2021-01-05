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
          :picker-options="pickerOptions"
          style="width: 150px"
          @change="handelDateChange">
        </el-date-picker>
      </el-form-item>
    </el-form>
    <!-- 分割线 start -->
    <div class="hr-10"></div>
    <!-- 分割线 end -->
    <div class="main-content">
      <el-radio-group v-model="formData.selectType" @change="handleSelectTypeChange">
        <el-badge :value="unReviewProjectCount" class="item">
          <el-radio-button label="已审"></el-radio-button>
          <el-radio-button label="待审"></el-radio-button>
        </el-badge>
      </el-radio-group>
      <br>
      <br>
      <el-tabs v-if="formData.refreshTabs" type="card" v-model="formData.reviewPerson">
        <el-tab-pane
          v-for="groupUser in groupUsers"
          :key="groupUser.id"
          :name="String(groupUser.id)">
          <span slot="label">
            {{groupUser.name}}
            <el-badge v-if="isShowCount(groupUser)"
                      :value="formData.reviewType === 'unReview'? groupUser.unReviewProjectCount : groupUser.reviewedProjectCount"
                      class="item"></el-badge>
          </span>
          <ReviewedPerson v-if="formData.reviewPerson === String(groupUser.id)"
                          :info="{id: groupUser.id, title: formData.title, reviewType: formData.reviewType}"
                          @reviewPass="handleReviewPass"></ReviewedPerson>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script>
    export default {
      data () {
        return {
          formData: {
            title: this.$moment().format('YYYY-MM')
          },
          tableData: []
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

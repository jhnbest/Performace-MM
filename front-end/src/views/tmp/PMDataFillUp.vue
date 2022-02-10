<template>
  <div>
    <div class="head-line">
      <el-button size="mini"
                type="danger"
                style="margin-right: 10px"
                @click="handlePreMonth">上月</el-button>
      <el-date-picker
        v-model="title"
        type="month"
        format="yyyy 第 MM 月"
        value-format="yyyy-MM"
        placeholder="选择月"
        style="width: 150px"
        @change="handleDataChange()">
      </el-date-picker>
      <el-button size="mini"
                  type="primary"
                  style="margin-left: 10px"
                  @click="handleNextMonth">下月</el-button>
    </div>
    <div class="hr-10"></div>
  </div>
</template>
<script>
import { getPMData } from '@/utils/performance'
export default {
  data () {
    return {
      title: this.$moment().format('YYYY-MM')
    }
  },
  methods: {
    // 初始化
    init () {

    },
    // 日期发生变化
    handleDataChange () {
      getPMData(this.title)
    },
    // 上月
    handlePreMonth () {
      this.title = this.$moment(this.title).subtract(1, 'months').format('YYYY-MM')
      this.handleDataChange()
    },
    // 下月
    handleNextMonth () {
      this.title = this.$moment(this.title).add(1, 'months').format('YYYY-MM')
      this.handleDataChange()
    }
  },
  created () {
    this.init()
  }
}
</script>
<style scoped>
.head-line{
  padding: 20px;
}
</style>

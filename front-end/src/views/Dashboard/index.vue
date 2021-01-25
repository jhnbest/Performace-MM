<template>
    <div v-if="true" class="dashboard-editor-container">
      <panel-group/>
      <el-row style="background:#fff;padding:16px 16px 0;margin-bottom:32px;">
<!--        <line-chart :chart-data="lineChartData" />-->
      </el-row>
    </div>
    <div v-else>
      <h2>开发完善中...</h2>
    </div>
</template>

<script>
  import PanelGroup from '@/components/Dashboard/PanelGroup'
  import LineChart from '@/components/Dashboard/LineChart'
    export default {
      components: {
        PanelGroup
        // LineChart
      },
        name: 'index.vue'
    }

</script>

<style scoped>
  .emptyGif {
    display: block;
    width: 45%;
    margin: 0 auto;
  }

  .dashboard-editor-container {
    background-color: #f1f0f0;
    min-height: 150vh;
    padding: 20px 15px 0px;
    .pan-info-roles {
      font-size: 12px;
      font-weight: 700;
      color: #333;
      display: block;
    }
    .info-container {
      position: relative;
      margin-left: 190px;
      height: 150px;
      line-height: 200px;
      .display_name {
        font-size: 48px;
        line-height: 48px;
        color: #212121;
        position: absolute;
        top: 25px;
      }
    }
  }
</style>

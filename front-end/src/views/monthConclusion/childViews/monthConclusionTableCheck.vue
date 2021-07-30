<template>
  <div>
    <el-table :data="tableData1"
              border
              stripe
              size="medium"
              style="margin: auto"
              :header-cell-style="{background:'#ced1d4',color:'#000000',fontSize:'18px'}">
      <el-table-column label="在本月所完成工作的回顾及客观评价（含工作内容、进展与成效、不足与改进意见、工作成果评价、未完成的工作内容及原因分析等）"
                       align="center">
        <template>
          <div v-html="curConclusion"></div>
        </template>
      </el-table-column>
    </el-table>
    <el-table :data="tableData2"
              border
              stripe
              size="medium"
              :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'18px' }"
              style="margin: auto"
              highlight-current-row>
      <el-table-column label="下一个月的工作目标、工作计划/工作安排、工作内容"
                       align="center">
        <template>
          <div v-html="nextPlan"></div>
        </template>
      </el-table-column>
    </el-table>
    <el-table :data="tableData3"
              border
              stripe
              size="medium"
              :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'18px' }"
              style="margin: auto"
              highlight-current-row>
      <el-table-column label="为更好地完成本职工作和团队目标，在下一阶段需要努力和改善的绩效，直接主管的期望、建议、措施等。"
                       align="center">
        <template>
          <div v-html="curAdvice"></div>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
    export default {
      data () {
        return {
          tableData1: [{}],
          tableData2: [{}],
          tableData3: [{}]
        }
      },
      props: {
        curConclusion: {
          type: String,
          default: '无数据'
        },
        nextPlan: {
          type: String,
          default: '无数据'
        },
        curAdvice: {
          type: String,
          default: '无数据'
        }
      },
      name: 'monthConclusionTableCheck'
    }
</script>

<style scoped>
</style>

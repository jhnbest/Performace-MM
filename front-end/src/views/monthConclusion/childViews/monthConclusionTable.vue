<template>
<div>
  <el-form class="main-search" :inline="true">
    <h3 style="text-align: center">{{headerName}}</h3>
    <editor-vue :value="conclusionText.nextMonthPlan"
                @input="(res)=> conclusionText.nextMonthPlan = res"></editor-vue>
    <el-table :data="tableData"
              border
              stripe
              size="medium"
              :header-cell-style="{ backgroundColor:'#e5be48', color: '#333' }"
              v-loading="!reqFlag.getTableData">
      <el-table-column label="在本月所完成工作的回顾及客观评价（含工作内容、进展与成效、不足与改进意见、工作成果评价、未完成的工作内容及原因分析等）"
                       align="center" width="1000"></el-table-column>
    </el-table>
    <el-table :data="tableData"
              border
              stripe
              size="medium"
              :header-cell-style="{ backgroundColor:'#e5be48', color: '#333' }"
              v-loading="!reqFlag.getTableData"
              highlight-current-row>
      <el-table-column label="下一个月的工作目标、工作计划/工作安排、工作内容或上级期望"
                       align="center" prop="month" width="1000">
        <template>
        </template>
      </el-table-column>
    </el-table>
  </el-form>
</div>
</template>

<script>
  import editorVue from '../../../components/monthConclusion/editor'
  export default {
    data () {
      return {
        headerName: '',
        tableData: [{}],
        reqFlag: {
          getTableData: true
        },
        conclusionText: {
          nextMonthPlan: ''
        }
      }
    },
    methods: {
      // 初始化
      init (fatherCompParams) {
      },
      // 点击预览
      handlePreview () {
      },
      // 编辑月总结
      handleEdit () {
      },
      // 提交月总结
      handleSubmit () {
      },
      // 暂存月总结
      handleTemporary () {
      }
    },
    filters: {
      submitStatusFilter (status) {
        if (status === 2) {
          return 'success'
        } else if (status === 1) {
          return 'warning'
        } else if (status === 0) {
          return 'info'
        }
      },
      submitStatusTextFilter (status) {
        if (status === 2) {
          return '已提交'
        } else if (status === 1) {
          return '暂存'
        } else if (status === 0) {
          return '未提交'
        }
      },
      reviewStatusFilter (status) {
        switch (status) {
          case 0:
            return 'info'
          case 1:
            return 'success'
          case 2:
            return 'danger'
          default:
            return 'danger'
        }
      },
      reviewStatusTextFilter (status) {
        switch (status) {
          case 0:
            return '未审核'
          case 1:
            return '已通过'
          case 2:
            return '驳回'
          default:
            return '错误'
        }
      }
    },
    components: {
      // CountTo
      editorVue
    },
    created () {
      this.init()
    },
    watch: {
    },
    mounted () {
    },
    name: 'multualEvaluation'
  }
</script>

<style scoped>
</style>

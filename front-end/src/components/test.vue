<template>
  <div class="main-content" v-if="showFlag.isFresh">
    <el-table
      row-key="id"
      :tree-props="{children: 'children'}"
      :data="formData.tableData"
      :row-class-name="tableRowClassName">
      <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
      <el-table-column label="指派时间" align="center" prop="assignDate"  width="100"></el-table-column>
      <el-table-column label="项目名称" align="center" prop="projectName"></el-table-column>
      <el-table-column label="项目级别" align="center" prop="projectName" width="100">
        <template slot-scope="scope">
          <div>
            <el-tag :type="scope.row.projectLevel | projectLevelColorFilter">
              {{scope.row.projectLevel | projectLevelStringFilter}}
            </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="完成度" align="center" width="70">
        <template slot-scope="scope">
          <el-progress :text-inside="true" :stroke-width="26" :percentage="scope.row.process"></el-progress>
        </template>
      </el-table-column>
      <el-table-column v-if="this.fatherParams.projectTypeID !== 5" label="指派人" align="center" prop="assigner"></el-table-column>
<!--      <el-table-column v-else label="审核状态" align="center">-->
<!--        <template slot-scope="scope">-->
<!--          <el-tag :type="scope.row.reviewStatus | reviewStatusTypeFilter">-->
<!--            {{scope.row.reviewStatus | reviewStatusStringFilter}}-->
<!--          </el-tag>-->
<!--        </template>-->
<!--      </el-table-column>-->
<!--      <el-table-column label="总工时" align="center" prop="totalWorkTime"></el-table-column>-->
      <el-table-column label="计划/实际进展" prop="planCompletion" align="center" v-if="this.fatherParams.searchType === 'unFilled'">
        <template slot-scope="scope">
          <span class="link-type" @click="handleFillIn(scope.row)">点击填报</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" prop="planCompletion" align="center" v-if="this.fatherParams.searchType === 'Filled'">
        <template slot-scope="scope">
          <span class="link-type" @click="handleFillIn(scope.row)">重新填报</span>
        </template>
      </el-table-column>
      <el-table-column v-if="this.fatherParams.projectTypeID === 4 || this.fatherParams.projectTypeID === 5"
                       label="操作"
                       align="center">
        <template slot-scope="scope">
          <el-button type="danger" size="mini" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
    import { getAssignProjectList, deleteAssignProject } from '@/config/interface'
    export default {
      data () {
        return {
          formData: {
            tableData: []
          },
          showFlag: {
            projectPlanProcess: false,
            isFresh: true
          },
          reqFlag: {
            getAssignProjectList: true,
            deleteProject: true
          }
        }
      },
      methods: {
        // 初始化
        init () {
          if (this.reqFlag.getAssignProjectList) {
            this.reqFlag.getAssignProjectList = false
            let params = {
              id: this.$store.state.userInfo.id,
              projectType: this.fatherParams.projectTypeID,
              searchType: this.fatherParams.searchType
            }
            const url = getAssignProjectList
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  this.formData.tableData = res.data[0]
                  this.$emit('countFeedback', res.data[1][0].totalCount)
                }
                this.reqFlag.getAssignProjectList = true
              })
          }
        },
        tableRowClassName ({ row, rowIndex }) {
          if (rowIndex % 2 === 1) {
            return 'warning-row'
          } else {
            return 'success-row'
          }
        },
        // 点击填报按钮事件
        handleFillIn (row) {
          this.$router.push({
            path: '/home/projectPlanProcess',
            query: {
              projectType: this.fatherParams.projectTypeID,
              projectName: row.projectName,
              projectID: row.id,
              process: row.process
            }
          })
        },
        // 删除按钮
        handleDelete (row) {
          this.$common.msgBox('confirm', '操作提示', '此操作将删除所有与该项目相关的工时申报（包括已获得工时），确定删除？', () => {
            if (this.reqFlag.deleteProject) {
              this.reqFlag.deleteProject = false
              const url = deleteAssignProject
              let params = {
                id: row.id
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('操作成功', 'success', false)
                  } else {
                    this.$common.toast('操作失败', 'danger', false)
                  }
                  this.showFlag.isFresh = false
                  this.init()
                  setTimeout(() => {
                    this.showFlag.isFresh = true
                  }, this.$store.state.refreshInterval)
                  this.reqFlag.deleteProject = true
                })
            }
          })
        }
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
        },
        reviewStatusTypeFilter (reviewStatus) {
          switch (reviewStatus) {
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
        reviewStatusStringFilter (reviewStatus) {
            switch (reviewStatus) {
              case 0:
                return '未审核'
              case 1:
                return '通过'
              case 2:
                return '驳回'
              default:
                return '错误'
            }
        }
      },
      created () {
        this.init()
      },
      destroyed () {
      },
      components: {
      },
      props: {
        fatherParams: {
          type: Object,
          default: null
        }
      },
      name: 'test.vue'
    }
</script>

<style scoped>

</style>

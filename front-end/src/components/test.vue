<template>
  <div v-if="showFlag.isFresh">
    <el-table
      row-key="id"
      :data="formData.tableData"
      :row-class-name="tableRowClassName"
      border
      :header-cell-style="{ backgroundColor: fatherParams.color, color: '#333'}"
      size="medium"
      style="margin: auto;width: 99%">
      <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
      <el-table-column label="指派时间" align="center" prop="assignDate"  width="100"></el-table-column>
      <el-table-column label="项目名称" align="center">
        <template slot-scope="scope">
          <span class="link-type" @click="handleEditProject(scope.row)">{{scope.row.projectName}}</span>
        </template>
      </el-table-column>
      <el-table-column label="项目级别" align="center" prop="projectName" width="120">
        <template slot-scope="scope">
          <div>
            <el-tag :type="scope.row.projectLevel | projectLevelColorFilter">
              {{scope.row.projectLevel | projectLevelStringFilter}}
            </el-tag>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="完成度" align="center" width="80">
        <template slot-scope="scope">
          <el-progress :text-inside="true" :stroke-width="26" :percentage="scope.row.process"></el-progress>
        </template>
      </el-table-column>
      <el-table-column label="指派人" align="center" prop="assigner" width="100"></el-table-column>
      <el-table-column label="操作" align="center" width="180">
        <template slot-scope="scope">
          <el-button v-if="fatherParams.searchType === 'unFilled'"
                     size="mini"
                     type="primary"
                     @click="handleFillIn(scope.row)">填报进度</el-button>
          <el-button v-if="fatherParams.searchType === 'Filled'"
                     type="primary"
                     size="mini"
                     @click="handleFillIn(scope.row)">重新填报</el-button>
          <el-button type="danger"
                     size="mini"
                     @click="handleDelete(scope.row)"
                     :disabled="scope.row.assignerID !== $store.state.userInfo.id || scope.row.process === 100">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <el-dialog :visible.sync="editProject" width="90%" center>
      <span slot="title" style="font-weight: bolder;font-size: 20px">{{dialogProjectName + '项目'}}</span>
      <el-table :data="dialogProjectData"
                border
                style="margin: auto;width: 99%"
                size="mini">
        <el-table-column label="序号" align="center" type="index"></el-table-column>
        <el-table-column label="项目阶段" align="center" prop="projectStage"></el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
        <el-button @click="editProject = false">取 消</el-button>
        <el-button type="primary" @click="editProject = false">确 定</el-button>
      </span>
    </el-dialog>
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
          },
          editProject: false,
          dialogProjectName: '',
          dialogProjectData: null
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
                  console.log(this.formData.tableData)
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
        },
        // 编辑项目
        handleEditProject (row) {
          this.editProject = true
          this.dialogProjectName = row.projectName
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

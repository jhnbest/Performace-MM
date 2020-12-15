<template>
  <div class="main-content">
    <el-table
      row-key="id"
      :tree-props="{children: 'children'}"
      :data="formData.tableData"
      :row-class-name="tableRowClassName">
      <el-table-column type="index" label="序号" width="60" align="center"></el-table-column>
      <el-table-column label="指派时间" align="center" prop="assignDate"  width="100"></el-table-column>
      <el-table-column label="项目名称" align="center" prop="projectName"></el-table-column>
      <el-table-column label="项目级别" align="center" prop="projectName" width="150">
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
      <el-table-column label="指派人" align="center" prop="assigner"></el-table-column>
      <el-table-column label="总工时" align="center" prop="totalWorkTime"></el-table-column>
      <el-table-column label="已获工时" align="center" prop="gettedWorkTime"></el-table-column>
      <el-table-column label="计划&进度" prop="planCompletion" align="center" v-if="this.fatherParams.searchType === 'unFilled'">
        <template slot-scope="scope">
          <span class="link-type" @click="handleFillIn(scope.row)">点击填报</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" prop="planCompletion" align="center" v-if="this.fatherParams.searchType === 'Filled'">
        <template slot-scope="scope">
          <span class="link-type" @click="handleFillIn(scope.row)">重新填报</span>
        </template>
      </el-table-column>
    </el-table>
    <JJProjectPlanProcess v-if="showFlag.projectPlanProcess" ref="JJProjectPlanProcess"/>
  </div>
</template>

<script>
    import JJProjectPlanProcess from './PlanProcessTable/JJProjectPlanProcess'
    import { getAssignProjectList } from '@/config/interface'
    export default {
      data () {
        return {
          formData: {
            tableData: []
          },
          showFlag: {
            projectPlanProcess: false
          },
          reqFlag: {
            getAssignProjectList: true
          }
        }
      },
      methods: {
        /* 初始化 */
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
                  console.log(res.data)
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
        /* 点击填报按钮事件 */
        handleFillIn (row) {
          console.log(this.fatherParams)
          this.$router.push({
            path: '/home/projectPlanProcess',
            query: {
              projectType: this.fatherParams.projectTypeID,
              projectName: row.projectName,
              projectID: row.id,
              process: row.process
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
        }
      },
      created () {
        console.log('test.vue create')
        this.init()
      },
      destroyed () {
        console.log('test.vue destroyed')
      },
      components: {
        JJProjectPlanProcess
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

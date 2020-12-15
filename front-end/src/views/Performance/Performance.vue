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
      <!--<el-form-item label="项目类型" prop="projectType" style="margin-left: 20px">
        <el-cascader
          v-model="formData.projectType"
          :options="projectTypeOptions"
          :props="props"
          collapse-tags
          clearable></el-cascader>
      </el-form-item>-->
<!--      <el-form-item style="margin-left: 30px">-->
<!--        <el-button type="primary" size="medium" @click="handleSearchClick">查询</el-button>-->
<!--      </el-form-item>-->
      <el-form-item style="margin-left: 30px">
        <span style="font-size: 17px;font-weight: bold">本月总工时:
          <span style="color: #F56C6C;margin-left: 10px">{{formData.totalWorkTime}}</span></span>
      </el-form-item>
    </el-form>
    <!-- 分割线 start -->
    <div class="hr-10"></div>
    <!-- 分割线 end -->
    <div class="main-content">
      <div class="content-header">
        <el-button type="primary" size="medium" @click="handleAddNew">新增工时申报</el-button>
      </div>
      <div>
        <el-table
          v-if="formData.isShowTable"
          :data="workDetailTable"
          style="width: 99%;margin: auto"
          v-loading="!this.reqFlag.getProjectList">
          <el-table-column type="expand">
            <template slot-scope="scope">
              <el-form label-position="left" inline class="demo-table-expand">
                <el-form-item label="提交时间">
                  <span>{{ scope.row.submitTime }}</span>
                </el-form-item>
                <el-form-item label="审核人">
                  <span>{{ scope.row.reviewer }}</span>
                </el-form-item>
                <el-form-item label="更新时间">
                  <span>{{ scope.row.updateTime }}</span>
                </el-form-item>
                <el-form-item label="审核时间">
                  <span>{{ scope.row.reviewTime }}</span>
                </el-form-item>

              </el-form>
            </template>
          </el-table-column>
          <el-table-column label="序号" align="center" type="index"></el-table-column>
          <el-table-column label="角色" align="center">
            <template slot-scope="scope">
              <el-tag :type="roleStatusFilter(scope.row.submitID)" size="medium">
                {{roleStatusTextFilter(scope.row.submitID)}}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="申报月份" align="center" prop="applyMonth"></el-table-column>
          <el-table-column label="申报项目" align="center" prop="projectName"></el-table-column>
          <el-table-column label="项目阶段" align="center" prop="projectStage"></el-table-column>
          <el-table-column label="工时详情" align="center">
            <template slot-scope="scope">
              <span class="link-type" @click="handleCoopInfo(scope.row)">点击查看</span>
            </template>
          </el-table-column>
          <el-table-column label="提交状态" align="center" class-name="status-col">
            <template slot-scope="scope">
              <el-tag :type="scope.row.submitStatus | submitStatusFilter" size="medium">
                {{ scope.row.submitStatus | submitStatusTextFilter}}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="审核状态" align="center">
            <template slot-scope="scope">
              <el-tag :type="scope.row.reviewStatus | reviewStatusFilter" size="medium">
                {{ scope.row.reviewStatus | reviewStatusTextFilter}}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="获得工时" align="center" prop="assignWorkTime"></el-table-column>
          <el-table-column label="操作" align="center" width="250">
            <template slot-scope="scope">
              <el-button :disabled="scope.row.submitStatus || ((scope.row.reviewStatus === '1')) || isAssginer(scope.row.submitID)"
                         type="primary"
                         size="mini"
                         @click="handleEdit(scope.row, scope.$index)">编辑</el-button>
              <el-button v-if="!scope.row.submitStatus"
                         :disabled="(scope.row.reviewStatus === '1' || isAssginer(scope.row.submitID))"
                         size="mini"
                         type="success"
                         @click="handleSubmitStatus(scope.row, scope.$index)">提交</el-button>
              <el-button v-if="scope.row.submitStatus"
                         :disabled="(scope.row.reviewStatus === '1' || isAssginer(scope.row.submitID))"
                         size="mini"
                         type="info"
                         @click="handleSubmitStatus(scope.row,scope.$index)">暂存</el-button>
              <el-button :disabled="(scope.row.reviewStatus === '1' || isAssginer(scope.row.submitID))"
                         size="mini"
                         type="danger"
                         @click="handleDelete(scope.row, scope.$index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </div>
    <Cop v-if="showFlag.cop" ref="cop"/>
  </div>
</template>

<script>
import Cop from '@/components/Cop/Cop'
import { getProjectType, getProjectList, changeSubmitStatus, deleteProject, getAssignWorkTime } from '@/config/interface'
    export default {
      data () {
        return {
          projectTypeOptions: [],
          props: {
            multiple: true,
            value: 'projectTypeID',
            label: 'projectName'
          },
          WorkTimeItem: [],
          declareTime: [],
          formData: {
            title: this.$moment().format('YYYY-MM'),
            projectType: [],
            isShowTable: true,
            totalWorkTime: 0
          },
          showFlag: {
            cop: false
          },
          reqFlag: {
            getProjectType: true,
            getProjectList: true,
            changeSubmitStatus: true,
            deleteProject: true
          },
          pageNum: 1, // 请求第几页
          pageSize: this.$store.state.pageSize, // 每页请求多少条
          currentPage: 1, // 初始时在第几页
          pickerOptions: {
            disabledDate (time) {
              return time.getTime() > Date.now()
            }
          },
          workDetailTable: []
        }
      },
      methods: {
        init () {
          // this.getProjectType()
          this.getProjectList().then(res => {
            this.getAssignWorkTimes(res)
          })
        },
        getProjectType () {
          const url = getProjectType
          if (this.reqFlag.getProjectType) {
            this.reqFlag.getProjectType = false
            let params = {
              projectParentID: this.$store.state.userInfo.groupName
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  let data = res.data
                  this.projectTypeOptions = data
                }
                this.reqFlag.getProjectType = true
              })
          }
        },
        getProjectList () {
          let it = this
          return new Promise(function (resolve, reject) {
            const url = getProjectList
            if (it.reqFlag.getProjectList) {
              it.reqFlag.getProjectList = false
              let params = {
                searchID: it.$store.state.userInfo.id,
                searchMon: it.formData.title,
                pageNum: it.pageNum,
                pageSize: it.pageSize
              }
              it.$http(url, params)
                .then(res => {
                  if (res.code == 1) {
                    let data = res.data
                    for (let item of data.list) {
                      item.assignWorkTime = null
                    }
                    it.workDetailTable = data.list
                    console.log(it.workDetailTable)
                    it.totalCount = data.totalCount
                    it.currentPage = it.pageNum
                    resolve(data.list)
                  }
                  it.reqFlag.getProjectList = true
                })
            }
          })
        },
        handelDateChange () {
          this.getProjectList().then(res => {
            this.getAssignWorkTimes(res)
          })
        },
        handleAdd () {
          this.$router.push({ path: '/home/PerformanceAdd' })
        },
        handleAddNew () {
          this.$router.push({ path: '/home/PerformanceAddNew' })
        },
        handleCoopInfo (row) {
          this.showFlag.cop = true
          this.$nextTick(() => {
            this.$refs.cop.init(row)
          })
        },
        handleEdit (row, index) {
          this.$router.push({
            path: '/home/PerformanceEdit',
            query: {
              id: row.id
            }
          })
        },
        handleSubmitStatus (row, index) {
          if (this.reqFlag.changeSubmitStatus) {
            this.reqFlag.changeSubmitStatus = false
            row.submitStatus = !row.submitStatus
            const url = changeSubmitStatus
            let params = {
              submitStatus: row.submitStatus,
              id: row.id
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  if (row.submitStatus) {
                    row.reviewStatus = '0'
                  }
                  this.$common.toast('操作成功', 'success', false)
                } else {
                  this.$common.toast('操作失败', 'warning', false)
                }
                this.reqFlag.changeSubmitStatus = true
              })
          }
        },
        handleDelete (row, index) {
          this.$common.msgBox('confirm', '操作提示', '确定删除？', () => {
            if (this.reqFlag.deleteProject) {
              this.reqFlag.deleteProject = false
              const url = deleteProject
              this.workDetailTable.splice(index, 1)
              let params = {
                id: row.id
              }
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    this.$common.toast('操作成功', 'success', false)
                  } else {
                    this.$common.toast('操作失败', 'warning', false)
                  }
                  this.reqFlag.deleteProject = true
                })
            }
          })
        },
        getAssignWorkTimesOP () {
        },
        getAssignWorkTimes (data) {
          const url = getAssignWorkTime
          let i = 0
          this.formData.totalWorkTime = 0
          for (let item of data) {
            if (item.reviewStatus === '1') {
              let params = {
                index: i,
                projectID: item.id,
                userID: this.$store.state.userInfo.id
              }
              console.log(params)
              this.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    console.log(data)
                    this.workDetailTable[data.index].assignWorkTime = data.reviewWorkTime
                    console.log(this.workDetailTable)
                    this.formData.totalWorkTime += data.reviewWorkTime
                  }
                })
            }
            i++
          }
        }
      },
      computed: {
        userPower: function () {
          let userType = this.$store.state.userInfo.role
          if (userType === '普通成员') {
            return 0
          } else if (userType === '组长') {
            return 1
          } else {
            return 2
          }
        },
        roleStatusFilter () {
          return function (submitID) {
            if (Number(submitID) === this.$store.state.userInfo.id) {
              return 'success'
            } else {
              return 'warning'
            }
          }
        },
        roleStatusTextFilter () {
          return function (submitID) {
            if (Number(submitID) === this.$store.state.userInfo.id) {
              return '组织者'
            } else {
              return '协作者'
            }
          }
        },
        isAssginer () {
          return function (id) {
            console.log('===isAssginer')
            console.log(id)
            if (Number(id) === Number(this.$store.state.userInfo.id)) {
              return false
            } else {
              return true
            }
          }
        }
      },
      components: {
        Cop
      },
      filters: {
        submitStatusFilter (status) {
          if (status) {
            return 'success'
          } else {
            return 'info'
          }
        },
        submitStatusTextFilter (status) {
          if (status) {
            return '已提交'
          } else {
            return '暂存'
          }
        },
        reviewStatusFilter (status) {
          switch (status) {
            case '0':
              return 'info'
            case '1':
              return 'success'
            case '2':
              return 'danger'
            default:
              return 'danger'
          }
        },
        reviewStatusTextFilter (status) {
          switch (status) {
            case '0':
              return '未审核'
            case '1':
              return '已通过'
            case '2':
              return '驳回'
            default:
              return '错误'
          }
        }
      },
      created () {
        console.log('===Performance.vue create')
        this.init()
      },
      mounted () {
        console.log('Performance.vue mounted')
      }
    }
</script>

<style scoped>
</style>

<template>
  <div>
    <el-form ref="formData" :model="formData" :rules="formRules">
      <el-table
        v-loading="!reqFlag.getProjectList"
        :data="formData.workDetailTable"
        stripe
        style="width: 100%;margin: auto">
        <el-table-column label="序号" type="index" align="center"></el-table-column>
        <el-table-column label="项目名称" align="center" prop="projectName"></el-table-column>
        <el-table-column label="类型/阶段" align="center" prop="projectStageName"></el-table-column>
        <el-table-column label="申报K值" align="center" prop="applyKValue" width="80%"></el-table-column>
        <el-table-column label="审核K值" align="center">
          <template slot-scope="scope">
            <el-form-item
              :prop="'workDetailTable.' + scope.$index + '.reviewKValue'"
              :rules="formRules.reviewKValue"
              style="margin: auto">
              <el-input :disabled="!(scope.row.reviewStatus === '0')" size="medium" v-model="scope.row.reviewKValue"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="申报次数" align="center" prop="applyCofficient"></el-table-column>
        <el-table-column label="审核次数" align="center">
          <template slot-scope="scope">
            <el-form-item
              :prop="'workDetailTable.' + scope.$index + '.reviewCofficient'"
              :rules="formRules.reviewCofficient"
              style="margin: auto">
              <el-input :disabled="!(scope.row.reviewStatus === '0')" size="medium" v-model="scope.row.reviewCofficient"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="工时分配" align="center">
          <template slot-scope="scope">
            <span v-if="info.reviewType === 'reviewed'"
                  class="link-type"
                  @click="handleCoopInfo(scope.row, scope.$index)">点击查看</span>
            <span v-else-if="!scope.row.workTimeAssignReviewStatus"
                  class="link-type"
                  @click="handleCoopInfo(scope.row, scope.$index)">点击审核</span>
            <span v-else-if="scope.row.workTimeAssignReviewStatus"
                  class="link-type"
                  @click="handleCoopInfo(scope.row, scope.$index)">已审核</span>
          </template>
        </el-table-column>
        <el-table-column label="申报备注" align="center">
          <template slot-scope="scope">
            <el-popover v-if="!(scope.row.submitComments === '')" placement="bottom" trigger="hover" width="200">
              <span>{{scope.row.submitComments}}</span>
              <span slot="reference" class="link-type">查看</span>
            </el-popover>
            <span v-else>无</span>
          </template>
        </el-table-column>
        <el-table-column label="提交时间" align="center" prop="updateTime" width="100%"></el-table-column>
        <el-table-column v-if="info.reviewType === 'reviewed'"
                         label="审核时间"
                         align="center"
                         prop="reviewTime"
                         width="100%"></el-table-column>
        <el-table-column label="审核状态" align="center">
          <template slot-scope="scope">
            <el-tag :type="scope.row.reviewStatus | reviewStatusFilter">
              {{ scope.row.reviewStatus | reviewStatusTextFilter}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center" width="200%">
          <template slot-scope="scope">
            <el-popconfirm
              confirm-button-text="确定"
              cancel-button-text="取消"
              icon="el-icon-info"
              icon-color="green" title="确认通过？"
              @confirm="handleReviewPass(scope.row, scope.$index)">
              <el-button
                slot="reference"
                v-if="(scope.row.reviewStatus === '0') & !(info.reviewType === 'reviewed')"
                size="small"
                type="primary" icon="el-icon-check">通过</el-button>
            </el-popconfirm>
            <el-popconfirm
              confirm-button-text="确定"
              cancel-button-text="取消"
              icon="el-icon-error"
              icon-color="red" title="确认驳回？" @confirm="handleReviewReject(scope.row)">
              <el-button
                style="margin-left: 10px"
                slot="reference"
                v-if="!(info.reviewType === 'reviewed')"
                :disabled="!(scope.row.reviewStatus === '0')"
                size="small"
                type="danger" icon="el-icon-close">驳回</el-button>
            </el-popconfirm>
            <el-popconfirm
              confirm-button-text="确定"
              cancel-button-text="取消"
              icon="el-icon-info"
              icon-color="gray" title="确认撤回？" @confirm="handleWithdrawReject(scope.row)">
              <el-button
                style="margin-left: 10px"
                slot="reference"
                v-if="info.reviewType === 'reviewed'"
                size="small"
                type="info" icon="el-icon-info">撤回</el-button>
            </el-popconfirm>
          </template>
        </el-table-column>
      </el-table>
    </el-form>
    <CopReview v-if="showFlag.CopReview" ref="copReview" @workTimeAssignReview="handleWorkTimeAssignReview"></CopReview>
  </div>
</template>

<script>
  import CopReview from '@/components/Cop/CopReview'
  import { getProjectList, submitReviewPass } from '@/config/interface'
    export default {
      data () {
        return {
          formData: {
            workDetailTable: []
          },
          formRules: {
            reviewKValue: [
              { required: true, message: '请填写审核K值', trigger: 'blur' }
            ],
            reviewCofficient: [
              { required: true, message: '请填写审核系数', trigger: 'blur' }
            ]
          },
          showFlag: {
            CopReview: true
          },
          reqFlag: {
            getProjectList: true
          },
          pageNum: 1, // 请求第几页
          pageSize: this.$store.state.pageSize, // 每页请求多少条
          totalCount: null,
          currentPage: 1 // 初始时在第几页
        }
      },
      methods: {
        handleCoopInfo (row, index) {
          this.showFlag.CopReview = true
          this.$nextTick(() => {
            this.$refs.copReview.init(row, index, this.info.reviewType)
          })
        },
        getProjectList (data) {
          const url = getProjectList
          if (this.reqFlag.getProjectList) {
            this.reqFlag.getProjectList = false
            let params = {
              searchID: data.id,
              searchMon: data.title,
              pageNum: this.pageNum,
              pageSize: this.pageSize,
              searchType: 'review',
              reviewType: data.reviewType
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  let data = res.data
                  for (let item of data.list) {
                    if (item.reviewKValue === null) {
                      item.reviewKValue = item.applyKValue
                    }
                    if (item.reviewCofficient === null) {
                      item.reviewCofficient = item.applyCofficient
                    }
                  }
                  console.log(data)
                  this.formData.workDetailTable = data.list
                  this.totalCount = data.totalCount
                  this.currentPage = this.pageNum
                  this.reqFlag.getProjectList = true
                }
              })
          }
        },
        // 审核通过
        handleReviewPass (row, index) {
          if (row.workTimeAssignReviewStatus) {
            const url = submitReviewPass
            console.log(this.formData.workDetailTable)
            let applyYear = this.$moment(row.applyMonth).year()
            let applyMonth = this.$moment(row.applyMonth).month()
            let applyMonthString = this.$common.MonthToString(String(applyMonth + 1))
            let params = {
              id: row.id,
              apdID: row.apdID,
              aplID: row.aplID,
              monthID: row.monthID,
              applyMonthString: applyMonthString,
              applyProcess: row.applyProcess,
              applyYear: applyYear,
              applyMonth: applyMonth,
              reviewCofficient: row.reviewCofficient,
              reviewComments: row.reviewComments,
              reviewKValue: row.reviewKValue,
              reviewStatus: '1',
              reviewer: this.$store.state.userInfo.name
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  this.getProjectList(this.info)
                  this.$emit('reviewPass')
                  this.$common.toast('通过成功', 'success', false)
                } else {
                  this.$common.toast('失败', 'error', false)
                }
              })
          } else {
            this.$common.toast('请先审核工时分配', 'error', true)
          }
        },
        // 驳回
        handleReviewReject (row) {
          const url = submitReviewPass
          let params = {
            id: row.id,
            reviewCofficient: row.reviewCofficient,
            reviewComments: row.reviewComments,
            reviewKValue: row.reviewKValue,
            reviewStatus: '2',
            reviewer: this.$store.state.userInfo.name
          }
          this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                this.getProjectList(this.info)
                this.$emit('reviewPass')
                this.$common.toast('驳回成功', 'success', false)
              } else {
                this.$common.toast('失败', 'error', false)
              }
            })
        },
        // 撤回
        handleWithdrawReject (row) {
          const url = submitReviewPass
          let params = {
            id: row.id,
            reviewCofficient: null,
            reviewComments: row.reviewComments,
            reviewKValue: null,
            reviewStatus: '0'
          }
          this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                this.getProjectList(this.info)
                this.$emit('reviewPass')
                this.$common.toast('撤回成功', 'success', false)
              }
            })
        },
        handleWorkTimeAssignReview (index) {
          this.formData.workDetailTable[index].workTimeAssignReviewStatus = 1
        }
      },
      props: {
        info: {
          type: Object
        }
      },
      created () {
        console.log('===ReviewedPerson.vue created')
        console.log(this.info)
        this.getProjectList(this.info)
      },
      mounted () {
        console.log('===ReviewedPerson.vue mounted')
        console.log(this.info)
      },
      destroyed () {
        console.log('===ReviewedPerson.vue destroyed')
        console.log(this.info)
      },
      components: {
        CopReview
      },
      filters: {
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
      name: 'ReviewPerson'
    }
</script>

<style scoped>

</style>

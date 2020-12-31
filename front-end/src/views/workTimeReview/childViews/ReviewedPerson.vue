<template>
  <div>
    <el-form ref="formData" :model="formData" :rules="formRules">
      <el-table
        v-loading="!reqFlag.getProjectList"
        :data="formData.workDetailTable"
        stripe
        :span-method="objectSpanMethod"
        style="width: 100%;margin: auto" border>
        <el-table-column v-if="info.reviewType === 'reviewed'" type="expand" >
          <template slot-scope="scope">
            <el-form label-position="left" inline class="demo-table-expand">
              <el-form-item label="提交时间">
                <span>{{ scope.row.submitTime }}</span>
              </el-form-item>
              <el-form-item label="审核时间">
                <span>{{ scope.row.reviewTime }}</span>
              </el-form-item>
              <el-form-item label="审核备注">
                <span v-if="scope.row.reviewComments !== ''">{{ scope.row.reviewComments }}</span>
                <span v-else>无</span>
              </el-form-item>
            </el-form>
          </template>
        </el-table-column>
        <el-table-column label="序号" type="index" align="center" width="50%"></el-table-column>
        <el-table-column label="项目类型" align="center" width="130%">
          <template slot-scope="scope">
            <el-tag :type="scope.row.parentTypeID | parentTypeIDColorFilter">
              {{scope.row.parentTypeID | parentTypeIDStringFilter}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="项目名称" align="center" prop="projectName"></el-table-column>
        <el-table-column label="项目阶段" align="center" prop="projectStageName"></el-table-column>
        <el-table-column label="基本工时" align="center" prop="applyBaseWorkTime" width="80%"></el-table-column>
        <el-table-column label="申报K值" align="center" prop="applyKValue" width="80%"></el-table-column>
        <el-table-column label="审核K值" align="center" width="100%">
          <template slot-scope="scope">
            <el-form-item
              :prop="'workDetailTable.' + scope.$index + '.reviewKValue'"
              :rules="formRules.reviewKValue"
              style="margin: auto">
              <el-input :disabled="!(scope.row.reviewStatus === 0)"
                        size="medium"
                        v-model="scope.row.reviewKValue" @change="handleReviewKValueChange(scope.row)"></el-input>
            </el-form-item>
          </template>
        </el-table-column>
        <el-table-column label="完成次数" align="center" prop="applyCofficient" width="80%"></el-table-column>
<!--        <el-table-column label="审核完成次数" align="center" width="110%">-->
<!--          <template slot-scope="scope">-->
<!--            <el-form-item-->
<!--              :prop="'workDetailTable.' + scope.$index + '.reviewCofficient'"-->
<!--              :rules="formRules.reviewCofficient"-->
<!--              style="margin: auto">-->
<!--              <el-input :disabled="!(scope.row.reviewStatus === 0)" size="medium" v-model="scope.row.reviewCofficient"></el-input>-->
<!--            </el-form-item>-->
<!--          </template>-->
<!--        </el-table-column>-->
        <el-table-column label="申报进展" align="center" width="80%">
          <template slot-scope="scope">
            <span>{{scope.row.applyProcess + '%'}}</span>
          </template>
        </el-table-column>
        <el-table-column label="工时分配" align="center" width="100%">
          <template slot-scope="scope">
            <span v-if="info.reviewType === 'reviewed'"
                  class="link-type"
                  @click="handleCoopInfo(scope.row, scope.$index)">点击查看</span>
            <span v-else-if="!scope.row.workTimeAssignReviewStatus"
                  class="link-type"
                  @click="handleCoopInfo(scope.row, scope.$index)">点击查看</span>
            <span v-else-if="scope.row.workTimeAssignReviewStatus"
                  class="link-type"
                  @click="handleCoopInfo(scope.row, scope.$index)">已审核</span>
          </template>
        </el-table-column>
        <el-table-column label="申报备注" align="center" width="100%">
          <template slot-scope="scope">
            <el-popover v-if="!(scope.row.submitComments === '')" placement="bottom" trigger="hover" width="200">
              <span>{{scope.row.submitComments}}</span>
              <span slot="reference" class="link-type">查看</span>
            </el-popover>
            <span v-else>无</span>
          </template>
        </el-table-column>
        <el-table-column label="提交时间" align="center" prop="updateTime" width="100%"></el-table-column>
        <el-table-column  v-if="info.reviewType !== 'reviewed'" label="审核备注" align="center">
          <template slot-scope="scope">
            <el-input size="mini" autosize type="textarea" v-model="scope.row.reviewComments"></el-input>
          </template>
        </el-table-column>
        <el-table-column v-if="info.reviewType === 'reviewed'"
                         label="审核时间"
                         align="center"
                         prop="reviewTime"
                         width="100%"></el-table-column>
        <el-table-column v-if="info.reviewType === 'reviewed'"
                         label="审核人"
                         align="center"
                         prop="reviewerName"
                         width="100%"></el-table-column>
        <el-table-column v-if="info.reviewType === 'reviewed'" label="审核状态" align="center">
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
                v-if="(scope.row.reviewStatus === 0) & !(info.reviewType === 'reviewed')"
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
                :disabled="!(scope.row.reviewStatus === 0)"
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
  import { getProjectList, submitReviewPass, getWorkAssign } from '@/config/interface'
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
          scale: 1,
          currentPage: 1 // 初始时在第几页
        }
      },
      methods: {
        // 工时审核点击
        handleCoopInfo (row, index) {
          this.showFlag.CopReview = true
          this.$nextTick(() => {
            this.$refs.copReview.init(row, index, this.info.reviewType)
          })
        },
        // 获取工时申报列表
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
                  let reviewTable = []
                  for (let item of data.list) {
                    if (item.reviewKValue === null) {
                      item.reviewKValue = item.applyKValue
                    }
                    if (item.reviewCofficient === null) {
                      item.reviewCofficient = item.applyCofficient
                    }
                    if (item.applyType === 'fact') {
                      data.totalCount -= 1
                      reviewTable.push(item)
                    }
                    item.scale = 0
                    item.avaiableWorkTimeTmp = item.avaiableWorkTime
                  }
                  reviewTable.sort(this.compare('aplID')) // 按照项目名称排序
                  this.handleReviewTable(reviewTable) // 表格按照项目名称合并前处理
                  this.formData.workDetailTable = reviewTable
                  this.totalCount = data.totalCount
                  this.currentPage = this.pageNum
                  this.reqFlag.getProjectList = true
                }
              })
          }
        },
        // 审核表格合并前处理
        handleReviewTable (Table) {
          let preAplID = 0
          let count = 1
          let preIndex = 0
          for (let i = 0; i < Table.length; i++) {
            Table[i].rowSpan = 1
            Table[i].colSpan = 1
            if (Table[i].aplID === preAplID) {
              Table[preIndex].rowSpan = ++count
              Table[i].rowSpan = 0
              Table[i].colSpan = 0
            } else {
              preIndex = i
              count = 1
              preAplID = Table[i].aplID
            }
          }
        },
        // 获取工时分配详情
        getWorkTimeAssign (row) {
          const url = getWorkAssign
          let params = {
            projectID: row.id
          }
          if (this.reqFlag.getWorkTimeAssign) {
            this.reqFlag.getWorkTimeAssign = false
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  let data = res.data
                  this.formData.totalReviewWorkTime = 0
                  for (let item of data) {
                    if (row.reviewStatus !== 1 && item.reviewWorkTime === null) {
                      item.reviewWorkTime = item.workTime
                    }
                    if (row.workTimeAssignReviewStatus === 0) {
                      item.reviewWorkTime = item.workTime * (1 + row.scale)
                      item.reviewWorkTime = Number(Number(item.reviewWorkTime).toFixed(1))
                    }
                  }
                }
                this.reqFlag.getWorkTimeAssign = true
              })
          }
        },
        // 审核通过
        handleReviewPass (row, index) {
          if (row.workTimeAssignReviewStatus) {
            const url = submitReviewPass
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
              reviewStatus: 1,
              reviewer: this.$store.state.userInfo.id
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
            reviewStatus: 2,
            reviewer: this.$store.state.userInfo.id
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
            reviewStatus: 0
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
        // 工时分配审核回调
        handleWorkTimeAssignReview (index) {
          this.formData.workDetailTable[index].workTimeAssignReviewStatus = 1
        },
        // 审核K值修改
        handleReviewKValueChange (row) {
          console.log(row)
          row.scale = (row.reviewKValue - row.applyKValue) / row.applyKValue
          row.scale = Number(Number(row.scale).toFixed(5))
          row.avaiableWorkTime = row.avaiableWorkTimeTmp * (1 + row.scale)
          row.avaiableWorkTime = Number(Number(row.avaiableWorkTime).toFixed(1))
          row.workTimeAssignReviewStatus = 0
        },
        // 表格合并方法
        objectSpanMethod ({ row, column, rowIndex, columnIndex }) {
          if (this.info.reviewType !== 'reviewed') {
            if (columnIndex === 1 || columnIndex === 2) {
              return {
                rowspan: row.rowSpan,
                colspan: row.colSpan
              }
            }
          } else {
            if (columnIndex === 2 || columnIndex === 3) {
              return {
                rowspan: row.rowSpan,
                colspan: row.colSpan
              }
            }
          }
        },
        // 表格数据排序
        compare (aplID) {
          return function (o, p) {
            let a, b
            if (typeof o === 'object' && typeof p === 'object' && o && p) {
              a = o[aplID]
              b = p[aplID]
              if (a === b) {
                return 0
              }
              if (typeof a === typeof b) {
                return a > b ? -1 : 1
              }
              return typeof a > typeof b ? -1 : 1
            } else {
              let obj = {}
              throw (obj)
            }
          }
        }
      },
      props: {
        info: {
          type: Object
        }
      },
      created () {
        console.log('===ReviewedPerson.vue created')
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
        },
        parentTypeIDColorFilter (projectLevel) {
          switch (projectLevel) {
            case 4: // 标准
              return 'warning'
            case 5: // 非标准
              return 'danger'
            case 172: // 选型
              return 'primary'
            case 173: // 基建
              return 'success'
            case 213: // 基础平台（工程）
              return 'info'
            case 275: // 基础平台（通信）
              return 'info'
            case 249: // 修缮
              return 'warning'
            default:
              return 'danger'
          }
        },
        parentTypeIDStringFilter (projectLevel) {
          switch (projectLevel) {
            case 4: // 标准
              return '其他标准工时'
            case 5: // 非标准
              return '其他非标工时'
            case 172: // 选型
              return '选型类'
            case 173: // 基建
              return '基建类'
            case 213: // 基础平台（工程）
              return '基础平台类（工程）'
            case 275: // 基础平台（通信）
              return '基础平台类（通信）'
            case 249: // 修缮
              return '修缮类'
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

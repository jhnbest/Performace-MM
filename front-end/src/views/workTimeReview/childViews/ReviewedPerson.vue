<template>
  <div>
    <el-form ref="formData" :model="formData" :rules="formRules">
      <el-table
        v-loading="!reqFlag.reqGetProjectList"
        :data="formData.workDetailTable"
        stripe
        :span-method="objectSpanMethod"
        style="width: 100%;margin: auto"
        border
        :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }">
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
        <el-table-column label="项目名称" align="center">
          <template slot-scope="scope">
            <el-popover
              placement="bottom"
              trigger="click">
              <div>
                <el-button icon="el-icon-minus"
                           circle
                           size="mini"
                           type="danger"
                           @click="handleDescYearNum(scope.row)"
                           :disabled="!reqFlag.getAssignProjectDetail"></el-button>
                <span style="font-size: 25px;color: red;font-weight: bolder">{{ formData.yearNum + '年' }}</span>
                <el-button icon="el-icon-plus"
                           circle
                           size="mini"
                           type="primary"
                           @click="handleAddYearNum(scope.row)"
                           :disabled="!reqFlag.getAssignProjectDetail"></el-button>
              </div>
              <br>
              <el-table :data="scope.row.tableData"
                        stripe
                        border
                        size="mini"
                        resizable>
                <el-table-column label="项目阶段" align="center" fixed show-overflow-tooltip>
                  <template slot-scope="scope">
                    <span v-if="scope.row.process === 100">
                      {{scope.row.projectStageName}}
                      <span style="color: red">(已完成)</span></span>
                    <span v-else>{{scope.row.projectStageName}}</span>
                  </template>
                </el-table-column>
                <el-table-column label="基本工时" align="center" prop="baseWorkTime" width="50%"></el-table-column>
                <el-table-column label="K值" align="center" prop="kValue" width="50%"></el-table-column>
                <el-table-column label="项目进度" align="center">
                  <el-table-column label="1月" align="center" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.January != null">{{scope.row.January + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="2月" align="center" prop="February" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.February != null">{{scope.row.February + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="3月" align="center" prop="March" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.March != null">{{scope.row.March + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="4月" align="center" prop="April" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.April != null">{{scope.row.April + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="5月" align="center" prop="May" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.May != null">{{scope.row.May + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="6月" align="center" prop="June" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.June != null">{{scope.row.June + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="7月" align="center" prop="July" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.July != null">{{scope.row.July + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="8月" align="center" prop="August" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.August != null">{{scope.row.August + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="9月" align="center" prop="September" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.September != null">{{scope.row.September + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="10月" align="center" prop="October" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.October != null">{{scope.row.October + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="11月" align="center" prop="November" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.November != null">{{scope.row.November + '%'}}</span>
                    </template>
                  </el-table-column>
                  <el-table-column label="12月" align="center" prop="December" width="73%">
                    <template slot-scope="scope">
                      <span v-if="scope.row.December != null">{{scope.row.December + '%'}}</span>
                    </template>
                  </el-table-column>
                </el-table-column>
              </el-table>
              <span class="link-type" slot="reference" @click="getAssignProjectInfo(scope.row, formData.yearNum)">{{scope.row.projectName}}</span>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column label="指派人" align="center" width="70%" prop="assigner"></el-table-column>
        <el-table-column label="项目阶段" align="center" prop="projectStageName" show-overflow-tooltip></el-table-column>
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
        <el-table-column label="操作" align="center" width="200%" fixed="right">
          <template slot-scope="scope">
            <el-button
              @click="handleReviewPass(scope.row)"
              v-if="(scope.row.reviewStatus === 0) & !(info.reviewType === 'reviewed')"
              size="small"
              type="primary" icon="el-icon-check">通过</el-button>
            <el-popconfirm
              confirm-button-text="确定"
              cancel-button-text="取消"
              icon="el-icon-error"
              icon-color="red" title="确认驳回？"
              @confirm="handleReviewReject(scope.row)">
              <el-button
                style="margin-left: 10px"
                slot="reference"
                v-if="!(info.reviewType === 'reviewed')"
                :disabled="!(scope.row.reviewStatus === 0)"
                size="small"
                type="danger"
                icon="el-icon-close">驳回</el-button>
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
  import { submitReviewPass, getAssignProjectDetail } from '@/config/interface'
  import { getProjectList } from '@/utils/performance'
  export default {
    data () {
      return {
        formData: {
          workDetailTable: [],
          yearNum: this.$moment().year()
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
          reqGetProjectList: true,
          getAssignProjectDetail: true
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
      init (params) {
        if (this.reqFlag.reqGetProjectList) {
          this.reqFlag.reqGetProjectList = false
          getProjectList(params.id, params.title, this.pageNum, this.pageSize, 'review', params.reviewType).then(res => {
            let reviewTable = []
            for (let item of res.list) {
              item.tableData = []
              if (item.reviewKValue === null) {
                item.reviewKValue = item.applyKValue
              }
              if (item.reviewCofficient === null) {
                item.reviewCofficient = item.applyCofficient
              }
              if (item.applyType === 'fact') {
                res.totalCount -= 1
                reviewTable.push(item)
              }
              item.scale = 0
              item.avaiableWorkTimeTmp = item.avaiableWorkTime
            }
            reviewTable.sort(this.compare('aplID')) // 按照项目名称排序
            this.handleReviewTable(reviewTable) // 表格按照项目名称合并前处理
            this.formData.workDetailTable = reviewTable
            this.totalCount = res.totalCount
            this.currentPage = this.pageNum
            this.reqFlag.reqGetProjectList = true
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
      // 审核通过
      handleReviewPass (row) {
        if (row.workTimeAssignReviewStatus) {
          const url = submitReviewPass
          let applyYear = this.$moment(row.applyMonth).year()
          let applyMonth = this.$moment(row.applyMonth).month()
          let applyMonthString = this.$common.MonthToString(String(applyMonth + 1))
          if (row.id !== null) {
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
            this.$http(url, params).then(res => {
              if (res.code === 1) {
                this.init(this.info)
                this.$emit('reviewPass')
                this.$common.toast('通过成功', 'success', false)
              } else {
                this.$common.toast('失败', 'error', false)
              }
            })
          } else {
            this.$common.toast('工時id错误', 'error', true)
          }
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
              this.init(this.info)
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
              this.init(this.info)
              this.$emit('reviewPass')
              this.$common.toast('撤回成功', 'success', false)
            }
          })
      },
      // 工时分配审核回调
      handleWorkTimeAssignReview (obj) {
        this.formData.workDetailTable[obj.selectIndex].workTimeAssignReviewStatus = 1
        this.handleReviewPass(obj.row)
      },
      // 审核K值修改
      handleReviewKValueChange (row) {
        row.scale = (row.reviewKValue - row.applyKValue) / row.applyKValue
        row.scale = Number(Number(row.scale).toFixed(5))
        row.avaiableWorkTime = row.avaiableWorkTimeTmp * (1 + row.scale)
        row.avaiableWorkTime = Number(Number(row.avaiableWorkTime).toFixed(1))
        row.workTimeAssignReviewStatus = 0
      },
      // 表格合并方法
      objectSpanMethod ({ row, column, rowIndex, columnIndex }) {
        if (this.info.reviewType !== 'reviewed') {
          if (columnIndex === 1 || columnIndex === 2 || columnIndex === 3) {
            return {
              rowspan: row.rowSpan,
              colspan: row.colSpan
            }
          }
        } else {
          if (columnIndex === 2 || columnIndex === 3 || columnIndex === 4) {
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
      },
      // 获取项目进展数据
      getAssignProjectInfo (row, yearNum) {
        let _this = this
        return new Promise(function (resolve, reject) {
          if (_this.reqFlag.getAssignProjectDetail) {
            _this.reqFlag.getAssignProjectDetail = false
            const url = getAssignProjectDetail
            let params = {
              id: row.aplID,
              year: yearNum
            }
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                let projectDetail = []
                for (let item of res.data) {
                  if (item.type === 'fact') {
                    projectDetail.push(item)
                  }
                }
                row.tableData = projectDetail
                _this.reqFlag.getAssignProjectDetail = true
                resolve(projectDetail)
              }
            })
          }
        })
      },
      // 年份减
      handleDescYearNum (row) {
        this.formData.yearNum--
        this.getAssignProjectInfo(row, this.formData.yearNum)
      },
      // 年份加
      handleAddYearNum (row) {
        this.formData.yearNum++
        this.getAssignProjectInfo(row, this.formData.yearNum)
      }
    },
    props: {
      info: {
        type: Object
      }
    },
    created () {
      this.init(this.info)
    },
    mounted () {
    },
    destroyed () {
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

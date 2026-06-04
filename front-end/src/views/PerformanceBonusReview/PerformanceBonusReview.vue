<template>
  <div v-if="$store.state.userInfo.id === 35">
    <el-form class="main-search" :inline="true">
      <el-form-item prop="title">
        <el-button size="mini" type="danger" style="margin-right: 10px" @click="handlePreMonth">上月</el-button>
        <el-date-picker
          v-model="title"
          type="month"
          format="yyyy 第 MM 月"
          value-format="yyyy-MM"
          placeholder="选择月"
          style="width: 150px"
          @change="handelDateChange">
        </el-date-picker>
        <el-button size="mini" type="primary" style="margin-left: 10px" @click="handleNextMonth">下月</el-button>
      </el-form-item>
    </el-form>
    <!-- 分割线 start -->
    <div class="hr-10"></div>
    <!-- 分割线 end -->
    <div class="main-content">
      <el-radio-group v-model="selectType" @change="handleSelectTypeChange">
        <div v-if="unReviewProjectCount !== 0" >
          <el-badge :value="unReviewProjectCount" class="item">
            <el-radio-button label="已审"></el-radio-button>
            <el-radio-button label="待审"></el-radio-button>
          </el-badge>
        </div>
        <div v-else>
          <el-radio-button label="已审"></el-radio-button>
          <el-radio-button label="待审"></el-radio-button>
        </div>
      </el-radio-group>
      <br>
      <br>
      <el-table :data="PBDataTable"
                border
                style="margin: auto;"
                stripe
                size="medium"
                :header-cell-style="{ backgroundColor:'#00BFFF', color: '#333' }"
                ref="rateTable"
                highlight-current-row>
        <el-table-column label="序号" align="center" type="index" width="50px"></el-table-column>
        <el-table-column label="加分事项描述" align="center" prop="PBName"></el-table-column>
        <el-table-column label="绩效加分项" align="center" prop="PBType"></el-table-column>
        <el-table-column label="加分规则" align="center" prop="PBRule"></el-table-column>
        <el-table-column label="绩效加分" align="center" width="80px">
          <template slot-scope="scope">
            {{ (scope.row.PBScore * scope.row.kValue).toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column label="分配" align="center" prop="PBScore" width="70px">
          <template slot-scope="scope">
            <el-popover
              placement="bottom"
              trigger="hover"
              width="400"
              popper-class="el-popover-v1">
              <el-table :data="scope.row.PBScoreAssign">
                <el-table-column type="index" align="center" label="序号"></el-table-column>
                <el-table-column prop="name" label="角色" align="center">
                  <template slot-scope="scope2">
                    {{scope2.row.role | roleFilter}}
                  </template>
                </el-table-column>
                <el-table-column prop="name" label="姓名" align="center"></el-table-column>
                <el-table-column prop="assignScore" label="分数" align="center"></el-table-column>
              </el-table>
              <span slot="reference" class="link-type">查看</span>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column label="备注" align="center" prop="PBScore" width="70px">
          <template slot-scope="scope">
            <el-popover
              placement="bottom"
              trigger="hover"
              width="400"
              :content="scope.row.PBComments">
              <span slot="reference" class="link-type">查看</span>
            </el-popover>
          </template>
        </el-table-column>
        <el-table-column label="提交时间" align="center" prop="submitTime" width="100px"></el-table-column>
        <el-table-column label="审核状态" align="center" width="85px">
          <template slot-scope="scope">
            <el-tag :type="scope.row.reviewStatus | reviewStatusFilter">
              <span>{{scope.row.reviewStatus | reviewStatusTextFilter}}</span>
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" align="center">
          <template slot-scope="scope">
  <!--          通过-->
            <el-button v-if="selectType === '待审'"
                       size="mini"
                       type="primary"
                       @click="handleReview(scope.row, 1)"
                       style="margin-left: 10px">通过</el-button>
  <!--          驳回-->
            <el-button size="mini"
                       type="danger"
                       @click="handleReview(scope.row, 2)">驳回</el-button>
  <!--          提交-->
            <el-button v-if="selectType !== '待审'"
                       :disabled="scope.row.reviewStatus === 0"
                       size="mini"
                       type="warning"
                       @click="handleReview(scope.row, 0)">撤回</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
  <div v-else>
    <h2>暂无权限</h2>
  </div>
</template>

<script>
  import { getPBData, updatePBData } from '@/utils/performanceBonus'
  import { Notification } from 'element-ui'
  import moment from 'moment'
  import store from '@/store'
  export default {
    data () {
      return {
        title: this.$moment().format('YYYY-MM'),
        selectType: '待审',
        PBDataTable: [],
        applyYear: null,
        applyMonth: null,
        unReviewPBData: [],
        refreshTabs: true,
        unReviewProjectCount: 0
      }
    },
    methods: {
      // ***初始化
      init () {
        this.applyYear = moment(this.title).year()
        this.applyMonth = moment(this.title).month() + 1

        getPBData(this.applyYear, this.applyMonth).then(result => {
          this.unReviewPBData = result.filter(item => { return item.reviewStatus === 0 && item.submitStatus === 1 })
          this.unReviewProjectCount = this.unReviewPBData.length
          this.PBDataTable = this.selectType === '待审' ? result.filter(item => { return item.reviewStatus === 0 && item.submitStatus === 1 })
                                                        : result.filter(item => { return item.reviewStatus !== 0 })
        })
      },
      handelDateChange () {
        this.PBDataTable = []
        this.init()
        // this.refreshTabs = false
        // setTimeout(() => {
        //   this.refreshTabs = true
        // }, store.state.refreshInterval)
      },
      // ***审核绩效加分
      handleReview (row, reviewStatus) {
        updatePBData(row.id,
                     row.PBName,
                     row.userID,
                     this.applyYear,
                     this.applyMonth,
                     row.submitStatus,
                     reviewStatus,
                     row.PBRuleID,
                     row.kValue,
                     row.PBComments,
                     row.PBScoreAssign).then(() => {
                      Notification.success({
                        title: '成功',
                        message: '操作成功'
                        })
                        this.init()
                      }).catch(() => {
                      Notification.error({
                        title: '失败',
                        message: '操作失败'
                        })
                     })
      },
      // ***审核类别标签切换
      handleSelectTypeChange () {
        this.PBDataTable = []
        this.init()
      },
      // **上一月
      handlePreMonth () {
        this.title = moment(this.title).subtract(1, 'months').format('YYYY-MM')
        this.handelDateChange()
      },
      // **下一月
      handleNextMonth () {
        this.title = moment(this.title).add(1, 'months').format('YYYY-MM')
        this.handelDateChange()
      }
    },
    computed: {
    },
    components: {
    },
    created () {
      this.init()
    },
    filters: {
      reviewStatusFilter (status) {
        if (status === 1) {
          return 'primary'
        } else if (status === 2) {
          return 'danger'
        } else if (status === 0) {
          return 'info'
        }
      },
      reviewStatusTextFilter (status) {
        if (status === 1) {
          return '通过'
        } else if (status === 2) {
          return '驳回'
        } else if (status === 0) {
          return '未审核'
        }
      },
      roleFilter (role) {
        switch (role) {
          case 1:
            return '组织者'
          case 2:
            return '协作者'
          default:
            return '错误'
        }
      }
    },
    name: 'PerformanceBonusReview'
  }
</script>

<style scoped>
  .clickStyle {
    width: 90px;
    font-size: 14px;
    background: #429e73;
    color: #fff;
  }
  .clickStyle:hover {
    background: #099a56;
    color: #fff;
  }
  .clickStyle:focus {
    background: #b41f1f;
    color: #fff;
  }
  .clickStyle:active {
    background: #b41f1f;
    color: #fff;
  }
</style>

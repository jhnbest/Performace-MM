<template>
<div>
  <div class="main-search-v2" :inline="true">
    <el-row>
      <!-- <el-col :xs="12" :sm="12" :lg="9" :xl="6">
        <el-button size="mini"
          type="danger"
          style="margin-right: 10px"
          @click="handlePreMonth()"
          :disabled="!reqFlag.handelDateChange">上月</el-button>
        <span label="申报月份" prop="title">
          <el-date-picker
            v-model="title"
            type="month"
            format="yyyy 第 MM 月"
            value-format="yyyy-MM"
            placeholder="选择月"
            style="width: 150px"
            @change="handelDateChange">
          </el-date-picker>
        </span>
        <el-button size="mini"
                   type="primary"
                   style="margin-left: 10px"
                   @click="handleNextMonth()"
                   :disabled="!reqFlag.handelDateChange">下月</el-button>
      </el-col > -->
      <el-col :xs="12" :sm="12" :lg="{span: 3, push: 0}" :xl="{span: 2, push: 0}">
        <el-button type="primary" @click="handleAddNewPB()">新增绩效加分申报</el-button>
      </el-col>
    </el-row>
  </div>
  <!-- 分割线 start -->
  <div class="hr-10"></div>
  <!-- 分割线 end -->
  <br>
<!-- 绩效加分表格 -->
  <div>
    <el-table :data="PMBTable"
              border
              style="margin: auto; width: 99%"
              stripe
              size="medium"
              :header-cell-style="{ backgroundColor:'#00BFFF', color: '#333' }"
              ref="rateTable"
              highlight-current-row>
      <el-table-column label="序号" align="center" type="index" width="50px"></el-table-column>
      <el-table-column label="申报月份" align="center" prop="applyDate" width="80px"></el-table-column>
      <el-table-column label="加分事项描述" align="center" prop="PBName"></el-table-column>
      <el-table-column label="绩效加分项" align="center" prop="PBType"></el-table-column>
      <el-table-column label="加分规则" align="center" prop="PBRule"></el-table-column>
      <el-table-column label="绩效加分" align="center" prop="PBScoretiaozheng" width="80px"></el-table-column>
      <el-table-column label="分配" align="center" width="70px">
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
      <el-table-column label="申报状态" align="center" width="85px">
        <template slot-scope="scope">
          <el-tag :type="scope.row.submitStatus | submitStatusFilter">
            <span>{{scope.row.submitStatus | submitStatusTextFilter}}</span>
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="审核状态" align="center" width="85px">
        <template slot-scope="scope">
          <el-tag :type="scope.row.reviewStatus | reviewStatusFilter">
            <span>{{scope.row.reviewStatus | reviewStatusTextFilter}}</span>
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center">
        <template slot-scope="scope">
<!--          编辑-->
          <el-button :disabled="(scope.row.reviewStatus === 1)"
                     size="mini"
                     type="warning"
                     @click="handleEdit(scope.row)"
                     style="margin-left: 10px">编辑</el-button>
<!--          暂存-->
          <el-button v-if="scope.row.submitStatus === 1"
                     :disabled=" (scope.row.reviewStatus === 1)"
                     size="mini"
                     type="info"
                     @click="handleSubmit(scope.row, 0)">暂存</el-button>
<!--          提交-->
          <el-button v-if="!(scope.row.submitStatus === 1)"
                     size="mini"
                     type="primary"
                     @click="handleSubmit(scope.row, 1)">提交</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
  <!-- 绩效加分新增界面对话框 -->
  <PerformanceBonusView v-if="isPerformanceBonusViewShow"
                        @close="isPerformanceBonusViewShow = false"
                        @submitDataSuccess="submitDataSuccess"></PerformanceBonusView>
  <!-- 绩效加分编辑界面对话框 -->
  <PerformanceBonusViewEditVue v-if="isPerformanceBonusViewEditShow"
                        :fatherPBData="fatherPBData"
                        @closeEdit="isPerformanceBonusViewEditShow = false"
                        @submitDataSuccess="submitDataSuccess"></PerformanceBonusViewEditVue>
</div>
</template>

<script>
  import { getPMBDataByUserID, updatePBData } from '@/utils/performanceBonus'
  import PerformanceBonusView from './childViews/PerformanceBonusView.vue'
  import PerformanceBonusViewEditVue from './childViews/PerformanceBonusViewEdit.vue'
  import moment from 'moment'
import store from '@/store'
  export default {
    data () {
      return {
        title: null,
        PMBTable: [],
        applyYear: 1970,
        applyMonth: 1,
        userID: null,
        isPerformanceBonusViewShow: false,
        isPerformanceBonusViewEditShow: false,
        fatherPBData: null
      }
    },
    methods: {
      // 初始化
      init () {
        this.userID = this.$store.state.userInfo.id
        // **获取绩效加分数据
        getPMBDataByUserID(this.userID).then(getPMBDataByUserIDRes => {
          for (let item of getPMBDataByUserIDRes) {
            item.applyDate = moment(item.applyYear + '-' + item.applyMonth).format('YYYY-MM')
          }
          this.PMBTable = JSON.parse(JSON.stringify(getPMBDataByUserIDRes))
          /** 根据K值显示最终绩效加分项 */
          for (let item of this.PMBTable) {
            item.PBScoretiaozheng = item.PBScore * item.kValue
          }
        })
      },
      // **新增绩效加分申报
      handleAddNewPB () {
        this.isPerformanceBonusViewShow = true
      },
      // ***编辑已提交绩效加分项
      handleEdit (row) {
        this.fatherPBData = row
        this.isPerformanceBonusViewEditShow = true
      },
      // 设置月份cookie
      setMonthCookie (month, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'mMon' + '=' + month + ';path=/;expires=' + exdate.toGMTString()
      },
      // **新增绩效加分子组件回调事件
      submitDataSuccess () {
        this.isPerformanceBonusViewShow = false
        this.isPerformanceBonusViewEditShow = false
        this.init()
      },
      // **提交&暂存按钮
      handleSubmit (row, submitStatus) {
        let reviewStatus = row.reviewStatus
        if (row.reviewStatus === 2 && submitStatus === 1) { // ***若为驳回的申报且当前为提交，则将审核标志位重置为未审核状态
          reviewStatus = 0
        }
        updatePBData(row.id,
                     row.PBName,
                     store.state.userInfo.id,
                     row.applyYear,
                     row.applyMonth,
                     submitStatus,
                     reviewStatus,
                     row.PBRuleID,
                     row.kValue,
                     row.PBComments,
                     row.PBScoreAssign).then(() => {
                      this.$common.toast('操作成功', 'success', false)
                      row.submitStatus = submitStatus
                    }).catch(err => {
                    console.log(err)
                    })
      }
    },
    filters: {
      submitStatusFilter (status) {
        if (status === 1) {
          return 'primary'
        } else if (status === 0) {
          return 'info'
        }
      },
      submitStatusTextFilter (status) {
        if (status === 1) {
          return '已提交'
        } else if (status === 0) {
          return '未提交'
        }
      },
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
    components: {
      PerformanceBonusView,
      PerformanceBonusViewEditVue
    },
    created () {
      this.init()
    },
    watch: {
    },
    mounted () {
    },
    name: 'monthConclusion'
  }
</script>

<style lang="scss">
  .el-popover-v1 {
    height: 300px;
    overflow: auto;
  }
</style>

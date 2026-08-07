<template>
  <div>
    <div v-if="false">系统维护中，预计2月1日晚开放</div>
    <div v-else>
      <div class="head-line">
        <el-row>
          <el-col :md="14" :lg="9" :xl="9">
            <el-button
              size="mini"
              type="danger"
              style="margin-right: 10px"
              @click="handlePreMonth"
              :disabled="!getDataLoading">上月
            </el-button>
            <el-date-picker
              :disabled="!getDataLoading"
              v-model="title"
              type="month"
              format="yyyy 第 MM 月"
              value-format="yyyy-MM"
              placeholder="选择月"
              style="width: 150px"
              @change="handleDataChange()">
            </el-date-picker>
            <el-button
              size="mini"
              type="primary"
              style="margin-left: 10px"
              @click="handleNextMonth"
              :disabled="!getDataLoading">下月
            </el-button>
            <el-button
              v-if="$store.state.userInfo.duty === 1"
              size="mini"
              type="success"
              style="margin-left: 10px"
              @click="handleExportAMEva"
              :disabled="!getDataLoading">导出
            </el-button>
          </el-col>
          <el-col :md="13" :lg="{span: 6}" :xl="{span: 6}" v-if="$store.state.userInfo.duty === 1">
            <div>
              <span style="font-weight:bold;">全处工时审核状态：</span>
              <span>
                <span v-if="getDataLoading">
                  <span v-if="workTimeRWed" style="color: green;font-size: 23px;font-weight:bold">已完成</span>
                  <span v-else style="color: red;font-size: 23px;font-weight:bold">未完成</span>
                </span>
                <span v-else>
                  <span style="color: red;font-size: 23px;font-weight:bold">查询中...</span>
                </span>
              </span>
            </div>
          </el-col>
          <el-col :md="13" :lg="{span: 7, offset: 1}" :xl="{span: 7, offset: 1}" v-if="$store.state.userInfo.duty === 1">
            <div>
              <span style="font-weight:bold;">绩效发布状态：</span>
              <span>
                <span v-if="getDataLoading">
                  <span v-if="PMPublishStatus" style="color: green;font-size: 23px;font-weight:bold">已发布</span>
                  <span v-else style="color: red;font-size: 23px;font-weight:bold">未发布</span>
                </span>
                <span v-else>
                  <span style="color: red;font-size: 23px;font-weight:bold">查询中...</span>
                </span>
              </span>
              <span v-if="!isAllUserEvaedByManager" style="margin-left: 10px;">
                <span style="color: red; fontSize: '14px'; fontWeight: 'bold'">
                  ({{ managerEvaStatusText }})
                </span>
              </span>
              <span>
                <span v-if="isOldRule">
                  <el-switch
                    :disabled="!getDataLoading || !publistPMDataFlag || !workTimeRWed || !isAllUserEvaedByManager"
                    v-model="PMPublishStatus"
                    @change="handlePerformancePublish"
                    style="margin-left: 10px">
                  </el-switch>
                </span>
                <span v-else>
                  <span v-if="!isTeamWorkBegin">
                    <el-switch
                      :disabled="!getDataLoading || !publistPMDataFlag || !workTimeRWed || !isAllUserEvaedByManager"
                      v-model="PMPublishStatus"
                      @change="handlePerformancePublishV2"
                      style="margin-left: 10px">
                    </el-switch>
                  </span>
                  <span v-else>
                    <span v-if="isPBScoreBegin">
                      <el-switch
                        :disabled="!getDataLoading || !publistPMDataFlag || !workTimeRWed || isRateChange || !isAllUserEvaedByManager"
                        v-model="PMPublishStatus"
                        @change="handlePerformancePublishV4"
                        style="margin-left: 10px">
                      </el-switch>
                      <el-popover
                        v-if="isRateChange"
                        placement="bottom"
                        trigger="click">
                        <span>评分有改动，需先点击提交/更新按钮</span><br>
                        <span slot="reference" class="pointer-type"><i class="el-icon-warning" style="color:red"></i></span>
                      </el-popover>
                    </span>
                    <span v-else>
                      <el-switch
                        :disabled="!getDataLoading || !publistPMDataFlag || !workTimeRWed || !isAllUserEvaedByManager"
                        v-model="PMPublishStatus"
                        @change="handlePerformancePublishV3"
                        style="margin-left: 10px">
                      </el-switch>
                    </span>
                  </span>
                </span>
              </span>
              <el-popover
                v-if="!workTimeRWed"
                placement="bottom"
                trigger="click">
                <span>需全处工时完成审核后才能发布</span><br>
                <span slot="reference" class="pointer-type"><i class="el-icon-warning" style="color:red"></i></span>
              </el-popover>
              <el-popover
                v-if="$store.state.userInfo.duty === 1 && !isAllUserEvaedByManager"
                placement="bottom"
                trigger="click">
                <span>需完成对所有用户评价后才能发布</span><br>
                <span slot="reference" class="pointer-type"><i class="el-icon-warning" style="color:red"></i></span>
              </el-popover>
            </div>
          </el-col>
        </el-row>
      </div>
      <div class="hr-10"></div>
      <div class="head-line">
        <el-row :gutter="5">
          <el-col :xs="14" :sm="14" :md="14" :lg="10" :xl="10" class="employee-list-col">
            <div class="employee-list-container">
              <el-table
                v-loading="!getDataLoading"
                :data="PMData"
                fit
                highlight-current-row
                style="width: 100%;"
                size="mini"
                ref = "PMDataTable"
                :cell-style="cellStyle"
                height="100%">
              <el-table-column type="index" label="序号" align="center"></el-table-column>
              <el-table-column label="姓名" prop="name" align="center" width="60px"></el-table-column>
              <el-table-column label="总结状态" prop="submitStatus" align="center" width="50px">
                <template slot-scope="scope">
                  <div v-if="scope.row.submitStatus === 1">
                    <svg-icon icon-class="greenPoint" style="fontSize:30px"/>
                  </div>
                  <div v-if="scope.row.submitStatus === 2">
                    <svg-icon icon-class="yellowPoint" style="fontSize:30px"/>
                  </div>
                  <div v-if="scope.row.submitStatus === 0">
                    <svg-icon icon-class="redPoint" style="fontSize:30px"/>
                  </div>
                </template>
              </el-table-column>
              <el-table-column label="评价状态" prop="submitStatus" align="center" width="50px">
                <template slot-scope="scope">
                  <div v-if="scope.row.evaStatus === 1">
                    <svg-icon icon-class="greenPoint" style="fontSize:30px"/>
                  </div>
                  <div v-else>
                    <svg-icon icon-class="redPoint" style="fontSize:30px"/>
                  </div>
                </template>
              </el-table-column>
              <el-table-column v-if="$store.state.userInfo.duty === 1" label="互评状态" align="center" width="50px">
                <template slot-scope="scope">
                  <div v-if="scope.row.isEvaAllFinish">
                    <svg-icon icon-class="greenPoint" style="fontSize:30px"/>
                  </div>
                  <div v-else>
                    <svg-icon icon-class="redPoint" style="fontSize:30px"/>
                  </div>
                </template>
              </el-table-column>
              <el-table-column v-if="$store.state.userInfo.duty === 1"
                                label="定量得分"
                                align="center" width="60px">
                <template slot-scope="scope">
                  <span v-if="scope.row.duty ===2"> / </span>
                  <span v-else> {{ scope.row.QYEvaScoreNor }} </span>
                </template>
              </el-table-column>
              <!-- <el-table-column v-if="$store.state.userInfo.duty === 1"
                                label="成效得分"
                                prop="AMEvaScoreUnN"
                                align="center" width="55px"></el-table-column> -->
              <el-table-column v-if="$store.state.userInfo.duty === 1"
                                label="成效排名"
                                prop="AMEvaRank"
                                align="center" width="50px"></el-table-column>
              <el-table-column v-if="$store.state.userInfo.duty === 1"
                                label="绩效加分"
                                prop="PBScore"
                                align="center" width="50px"></el-table-column>
              <el-table-column v-if="$store.state.userInfo.duty === 1"
                                label="绩效得分(裸分)"
                                prop="PMScoreUnN"
                                align="center" width="70px"></el-table-column>
              <el-table-column v-if="$store.state.userInfo.duty === 1"
                                label="绩效得分(标准化)"
                                prop="PMScoreNor"
                                align="center" width="70px"></el-table-column>
              <el-table-column v-if="$store.state.userInfo.duty === 1"
                                label="绩效排名"
                                align="center" width="50px">
                <template slot-scope="scope">
                  <span style="font-weight: bolder;color: red">{{scope.row.PMRank}}</span>
                  <i v-if="scope.row.PMRankChange < 0" class="el-icon-caret-top" style="color: red"></i>
                  <i v-if="scope.row.PMRankChange > 0" class="el-icon-caret-bottom" style="color: green"></i>
                  <span v-if="scope.row.PMRankChange !== 0" style="font-size: 10px">
                    {{scope.row.PMRankChange > 0 ? scope.row.PMRankChange : -scope.row.PMRankChange}}
                  </span>
                </template>
              </el-table-column>
              <el-table-column v-if="isOldRule" label="月总结" align="center">
                <template slot-scope="scope">
                  <el-button v-if="!scope.row.isShow"
                            :disabled="scope.row.submitStatus !== 1"
                            @click="table1HandleShow(scope.row, scope.$index)"
                            size="mini">
                            <span v-if="scope.row.submitStatus === 1">显示</span>
                            <span v-else>未提交</span>
                  </el-button>
                  <span v-else>已显示</span>
                </template>
              </el-table-column>
              <el-table-column v-if="!isOldRule" label="月总结" align="center">
                <template slot-scope="scope">
                  <el-button v-if="!scope.row.isShow"
                            :disabled="scope.row.submitStatus !== 1"
                            @click="table1HandleShowV2(scope.row, scope.$index)"
                            size="mini">
                            <span v-if="scope.row.submitStatus === 1">显示</span>
                            <span v-else>未提交</span>
                  </el-button>
                  <span v-else>已显示</span>
                </template>
              </el-table-column>
            </el-table>
            </div>
          </el-col>
          <!-- ************************************************************************************************* -->
          <el-col v-if="isOldRule" :xs="13" :sm="13" :md="13" :lg="13" :xl="13">
            <div v-if="forceRefresh" class="evaluation-container">
              <div class="eval-content-scroll">
                <div class="eval-card">
                  <div class="eval-card-header">
                    <span class="eval-card-title">打造精品工程</span>
                  </div>
                  <div class="eval-card-content" v-html="buildBoutiqueProject.content"></div>
                </div>
                <div class="eval-card">
                  <div class="eval-card-header">
                    <span class="eval-card-title">创建专业团队</span>
                  </div>
                  <div class="eval-card-content" v-html="buildProTeam.content"></div>
                </div>
                <div class="eval-card" v-if="$store.state.userInfo.duty === 1">
                  <div class="eval-card-header">
                    <span class="eval-card-title">下一个月的工作目标、工作计划/工作安排、工作内容</span>
                  </div>
                  <div class="eval-card-content" v-html="nextPlan.content"></div>
                </div>
                <div class="eval-card" v-if="$store.state.userInfo.duty === 1">
                  <div class="eval-card-header">
                    <span class="eval-card-title">意见建议与困难反馈</span>
                  </div>
                  <div class="eval-card-content" v-html="curAdvice.content"></div>
                </div>
              </div>
              <div class="eval-rating-panel">
                <div class="rating-card">
                  <div class="rating-card-header">评分</div>
                  <div class="rating-card-body">
                    <div class="rating-item">
                      <div class="rating-label">打造精品工程</div>
                      <el-rate
                        :disabled="PMPublishStatus"
                        v-model="buildBoutiqueProjectStar.evaStar"
                        @change="handlebuildBoutiqueProjectStarChange()">
                      </el-rate>
                      <div class="rating-info" v-if="$store.state.userInfo.duty === 1">
                        <span>组员平均：{{dimension1CSAveStar}}星</span>
                        <span>组长评价：{{dimension1GPEvaStar}}星</span>
                      </div>
                    </div>
                    <div class="rating-item">
                      <div class="rating-label">创建专业团队</div>
                      <el-rate
                        :disabled="PMPublishStatus"
                        v-model="buildProTeamStar.evaStar"
                        @change="handlebuildProTeamStarChange()">
                      </el-rate>
                      <div class="rating-info" v-if="$store.state.userInfo.duty === 1">
                        <span>组员平均：{{dimension2CSAveStar}}星</span>
                        <span>组长评价：{{dimension2GPEvaStar}}星</span>
                      </div>
                    </div>
                    <div class="rating-action">
                      <el-button v-if="failedEvaData.length > 0"
                                type="warning"
                                size="small"
                                @click="handleRetryFailedEva()">
                                重试失败({{ failedEvaData.length }})
                      </el-button>
                      <el-button v-else-if="!currentShowUserisEva && buildBoutiqueProject.content !== '无数据'"
                                :disabled="!submitEvaDataFlag"
                                type="success"
                                size="small"
                                @click="handleSubmitAndJumpToNext()">
                                提交评价
                      </el-button>
                      <el-button v-else-if="currentShowUserisEva && buildBoutiqueProject.content !== '无数据'"
                                :disabled="!updateEvaDataFlag"
                                type="primary"
                                size="small"
                                @click="handleUpdateEva()">
                                更新评价
                      </el-button>
                    </div>
                    <div v-if="failedEvaData.length > 0" class="failed-eva-info">
                      <div class="failed-eva-title">提交失败的评价数据：</div>
                      <div v-for="(item, index) in failedEvaData" :key="index" class="failed-eva-item">
                        <span>被评价人：{{ item.evaedUserName }}</span>
                        <span>维度：{{ item.dimensionName }}</span>
                        <span>dimensionID：{{ item.dimensionID }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </el-col>
          <!-- ************************************************************************************************* -->
          <el-col v-if="!isOldRule" :xs="13" :sm="13" :md="13" :lg="14" :xl="14">
            <div v-if="forceRefresh" class="evaluation-container">
              <div class="eval-content-scroll">
                <div v-if="isMergedConclusion" class="eval-card">
                  <div class="eval-card-header">
                    <span class="eval-card-title">月度总结</span>
                    <el-button type="primary" plain size="small" icon="el-icon-view" @click="showThisMonthPlan = !showThisMonthPlan" style="margin-left: 8px; padding: 5px 10px; font-size: 12px;">
                      {{ showThisMonthPlan ? '隐藏上月填写的本月计划' : '点击显示上月填写的本月计划' }}
                    </el-button>
                  </div>
                  <div class="eval-card-content" v-html="tableData1[0] && tableData1[0].dimension1V2Content || ''"></div>
                  <div v-if="showThisMonthPlan" style="margin-top: 15px; padding-top: 10px; border-top: 1px dashed #e4e7ed;">
                    <div style="font-size: 12px; color: #909399; margin-bottom: 5px;">—— 上月填写的本月计划 ——</div>
                    <div class="eval-card-content" v-html="tableData2[0] && tableData2[0].dimension2V2Content || '无数据'"></div>
                  </div>
                </div>
                <div v-else class="eval-card">
                  <div class="eval-card-header">
                    <span class="eval-card-title">打造精品工程&创建专业团队</span>
                    <el-button type="primary" plain size="small" icon="el-icon-view" @click="showThisMonthPlan = !showThisMonthPlan" style="margin-left: 8px; padding: 5px 10px; font-size: 12px;">
                      {{ showThisMonthPlan ? '隐藏上月填写的本月计划' : '点击显示上月填写的本月计划' }}
                    </el-button>
                  </div>
                  <div v-if="tableData1[0] && tableData1[0].dimension1V2Content">
                    <div v-if="tableData1[1] && tableData1[1].dimension1V2Content" style="font-size: 12px; color: #909399; margin-bottom: 5px;">—— 打造精品工程 ——</div>
                    <div class="eval-card-content" v-html="tableData1[0].dimension1V2Content || ''"></div>
                  </div>
                  <div v-if="tableData1[1] && tableData1[1].dimension1V2Content" style="margin-top: 15px; padding-top: 10px; border-top: 1px solid #e4e7ed;">
                    <div style="font-size: 12px; color: #909399; margin-bottom: 5px;">—— 创建专业团队 ——</div>
                    <div class="eval-card-content" v-html="tableData1[1].dimension1V2Content || ''"></div>
                  </div>
                  <div v-if="showThisMonthPlan" style="margin-top: 15px; padding-top: 10px; border-top: 1px dashed #e4e7ed;">
                    <div style="font-size: 12px; color: #909399; margin-bottom: 5px;">—— 上月填写的本月计划 ——</div>
                    <div class="eval-card-content" v-html="tableData2[0] && tableData2[0].dimension2V2Content || '无数据'"></div>
                  </div>
                </div>
                <div class="eval-card">
                  <div class="eval-card-header">
                    <span class="eval-card-title">下月计划</span>
                  </div>
                  <div class="eval-card-content" v-html="curMonthNextPlan.content"></div>
                </div>
                <div class="eval-card" v-if="$store.state.userInfo.duty === 1 && isShowTeamWorkTable">
                  <div class="eval-card-header">
                    <span class="eval-card-title">小组每月工作总结</span>
                  </div>
                  <div class="eval-card-content" v-html="teamWorkData[0] && teamWorkData[0].dimension4V2Content || ''"></div>
                </div>
                <div class="eval-card" v-if="$store.state.userInfo.duty === 1">
                  <div class="eval-card-header">
                    <span class="eval-card-title">意见建议与困难反馈</span>
                  </div>
                  <div class="eval-card-content" v-html="tableData3[0] && tableData3[0].dimension3V2Content || ''"></div>
                </div>
              </div>
              <div class="eval-rating-panel">
                <div class="rating-card">
                  <div class="rating-card-header">评分</div>
                  <div class="rating-card-body">
                    <div class="rating-item">
                      <div class="rating-label">{{ isMergedConclusion ? '月度总结' : '打造精品工程&创建专业团队' }}</div>
                      <el-rate
                        :disabled="PMPublishStatus"
                        v-model="dimension1V2Star"
                        @change="handleD1StarChangeV2()">
                      </el-rate>
                      <div class="rating-info" v-if="$store.state.userInfo.duty === 1">
                        <span>组员平均：{{dimension1CSAveStar}}星</span>
                        <span>组长评价：{{dimension1GPEvaStar}}星</span>
                      </div>
                    </div>
                    <div class="rating-item">
                      <div class="rating-label">下月计划</div>
                      <el-rate
                        :disabled="PMPublishStatus"
                        v-model="dimension2V2Star"
                        @change="handleD2StarChangeV2()">
                      </el-rate>
                      <div class="rating-info" v-if="$store.state.userInfo.duty === 1">
                        <span>组员平均：{{dimension2CSAveStar}}星</span>
                        <span>组长评价：{{dimension2GPEvaStar}}星</span>
                      </div>
                    </div>
                    <div class="rating-item" v-if="$store.state.userInfo.duty === 1 && isShowTeamWorkTable">
                      <div class="rating-label">小组每月工作总结</div>
                      <el-rate
                        :disabled="PMPublishStatus"
                        v-model="dimension4V2Star"
                        @change="handleD4StarChangeV2()">
                      </el-rate>
                    </div>
                    <div class="rating-action">
                      <el-button v-if="failedEvaData.length > 0"
                                type="warning"
                                size="small"
                                @click="handleRetryFailedEva()">
                                重试失败({{ failedEvaData.length }})
                      </el-button>
                      <el-button v-else-if="!currentShowUserisEva && tableData1.length !== 0"
                                :disabled="!submitEvaDataFlag || PMPublishStatus"
                                type="success"
                                size="small"
                                @click="handleSubmitAndJumpToNextV2()">
                                提交评价
                      </el-button>
                      <el-button v-else-if="currentShowUserisEva && tableData1.length !== 0"
                                :disabled="!updateEvaDataFlag || PMPublishStatus"
                                type="primary"
                                size="small"
                                @click="handleUpdateEvaV2()">
                                更新评价
                      </el-button>
                    </div>
                    <div v-if="failedEvaData.length > 0" class="failed-eva-info">
                      <div class="failed-eva-title">提交失败的评价数据：</div>
                      <div v-for="(item, index) in failedEvaData" :key="index" class="failed-eva-item">
                        <span>被评价人：{{ item.evaedUserName }}</span>
                        <span>维度：{{ item.dimensionName }}</span>
                        <span>dimensionID：{{ item.dimensionID }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </el-col>
          <!-- ************************************************************************************************* -->
        </el-row>
      </div>
    </div>
  </div>
</template>
<script>
import { getAllWorkTimeList,
         genQYEvaScoreData,
         genPerformanceScore,
         savePMData,
         publishPMData,
         getPMData,
         updatePMData,
         getSubmitWorkTimeCount,
         mianshenheWorkTimeSubmit,
         savePMDataV2,
         updatePMDataV2,
         genPerformanceScoreV2,
         genPerformanceScoreV3,
         genQYEvaScoreDataV2,
         updatePMDataV3,
         savePMDataV3 } from '@/utils/performance'
import { genQualiEvaData, getAllQTEvaedData } from '@/utils/multual'
import { Notification } from 'element-ui'
import { getUsersList } from '@/utils/users'
import { getCurMonthConclusionOverviewDataNew, getCurMonthConclusionOverviewDataNewV2, getCurMonthConclusionOverviewDataNewV3 } from '@/utils/conclusion'
import { submitAMEvaData,
         updateAMEvaData,
         genAMEvaScoreData,
         genAMEvaScoreDataV2,
         addFailedAMEvaData,
         getFailedAMEvaData,
         updateFailedAMEvaRetrySuccess,
         deleteFailedAMEvaData,
         clearFailedAMEvaData } from '@/utils/achievementEva'
import { getEvaCoef, sortObjectArrayByParams, getPerformanceIsPublish, sortByAscend, isUndefined,
         getGlobalFlagByTime, starToRatesNew, getTypeGlobalFlag } from '@/utils/common'
import store from '@/store'
import Cookies from 'js-cookie'
import moment from 'moment'
import { getPBData } from '@/utils/performanceBonus'
export default {
  data () {
    return {
      title: this.$moment().format('YYYY-MM'), // 日期
      isOldRule: true,
      usersList: null, // 用户列表
      getDataLoading: false, // 表格加载标志位,
      submitEvaDataFlag: true, // 提交评价标志位
      updateEvaDataFlag: true, // 更新评价标志位
      publistPMDataFlag: true, // 发布绩效数据标志位
      PMData: [], // 表格数据
      doneEvaTableData: [], // 已经完成评价的数据
      tableHeight: null, // 动态表格高度
      tableData1: [{}],
      tableData2: [{}],
      tableData3: [{}],
      tableData4: [{}],
      tableData5: [{}],
      teamWorkData: [{}],
      showThisMonthPlan: true,
      buildBoutiqueProject: {
        content: '无数据'
      }, // 打造精品工程内容
      buildProTeam: {
        content: '无数据'
      }, // 建设专业团队内容
      nextPlan: {
        content: '无数据'
      }, // 下月计划内容（来自上月月总结的dimension=3）
      curMonthNextPlan: {
        content: '无数据'
      }, // 当月月总结中的下月计划（dimension=3）
      curAdvice: {
        content: '无数据'
      }, // 建议意见
      table1CurShowIndex: -1, // 表格1当前显示的用户序号
      table1PreShowIndex: -1, // 表格1之前显示的用户序号
      buildBoutiqueProjectStar: {
        evaStar: store.state.defaultStar
      }, // 打造精品工程默认评价星级
      buildProTeamStar: {
        evaStar: store.state.defaultStar
      }, // 建设专业团队默认评价星级
      forceRefresh: true, // 强制刷新
      curEvaUserName: null, // 当前显示的用户姓名
      intelligentGroup: [], // **智能化组成员
      commuincationGroup: [], // 通信组成员,
      globalAllAmEvaData: [], // 存储全局成效评价
      QYEvaScoreData: [], // 存储全局定量评价数据
      QTEvaScoreData: [], // 存储全局定性评价数据
      evaCoefObj: [], // 存储全局各种系数数据
      initPMData: [], // 首次生成的绩效数据
      currentShowUserisEva: false, // 当前显示用户是否已评价
      newPMData: [], // 动态计算的绩效数据
      dimension1CSAveStar: 0, // 评价维度1普通成员平均评价星级
      dimension2CSAveStar: 0, // 评价维度2普通成员平均评价星级
      dimension1GPEvaStar: 0, // 评价维度1组长评价星级
      dimension2GPEvaStar: 0, // 评价维度2组长评价星级
      PMPublishStatus: false, // 绩效信息发布状态
      workTimeRWed: false, // 工时审核状态
      PMPublishStatusData: [], // 绩效发布状态数据
      publishedPMData: [], // 已发布的绩效数据
      dimension1V2Star: store.state.defaultStar, // **新版评价维度1评价星级
      dimension2V2Star: store.state.defaultStar, // **新版评价维度2评价星级
      dimension4V2Star: store.state.defaultStar, // **新版评价维度4评价星级
      dimension1IDV2: null, // **新版评价维度1 ID （打造精品工程和创建专业团队）
      dimension2IDV2: null, // **新版评价维度2 ID （上月计划执行情况）
      dimension4IDV2: null, // **新版评价维度4 ID (小组工作评价)
      dimenision1EvaIDV2: null,
      dimenision2EvaIDV2: null,
      dimenision4EvaIDV2: null,
      isShowTeamWorkTable: false, // **是否显示小组工作评价的表格
      isTeamWorkBegin: false, // **是否已经开始实行小组工作评价
      isPBScoreBegin: false, // **是否已经开始实行绩效加分、工时上限规则
      AMEvaDeadline: false, // **成效评价提交是否已截止
      isRateChange: false, // **评分是否有发生变化
      failedEvaData: [] // **提交失败的成效评价数据，用于重试
    }
  },
  computed: {
    isAllUserEvaedByManager () {
      if (store.state.userInfo.duty !== 1) {
        return true
      }
      if (this.PMData.length === 0) {
        return false
      }
      for (let item of this.PMData) {
        if (item.evaStatus !== 1) {
          return false
        }
      }
      return true
    },
    managerEvaStatusText () {
      if (store.state.userInfo.duty !== 1) {
        return ''
      }
      if (this.PMData.length === 0) {
        return '待评价用户加载中...'
      }
      let unEvaCount = this.PMData.filter(item => item.evaStatus !== 1).length
      if (unEvaCount === 0) {
        return '已全部评价'
      } else {
        return `还有 ${unEvaCount} 位用户未评价`
      }
    },
    isMergedConclusion () {
      return this.$moment(this.title).isSameOrAfter(this.$moment(store.state.newRulesConclusionMerge))
    }
  },
  methods: {
    // 初始化
    init () {
      // **读取月份选择cookie，如果没有cookie，则设置cookie
      if (typeof (Cookies.get('cookieAMEvaPageDate')) === 'undefined') {
        Cookies.set('cookieAMEvaPageDate', this.title)
      }
      this.title = Cookies.get('cookieAMEvaPageDate')
      this.getDataLoading = false
      // **加载后端存储的失败评价数据
      this.loadFailedEvaDataFromBackend()
      // **获取是否可申报成效评价标志位
      let applyYear = moment(this.title).year()
      let applyMonth = moment(this.title).month() + 1
      getTypeGlobalFlag(applyYear, applyMonth, 'AMEvaDeadline').then(result => {
        if (!(result.length !== 0 && result[0].flagValue === 1) || (store.state.userInfo.duty !== 3)) {
          this.AMEvaDeadline = false
        } else {
          this.AMEvaDeadline = true
        }
      }).catch(err => {
        console.log(err)
      })
      let checkGroupID = 0
      getUsersList(checkGroupID).then(usersList => {
        this.intelligentGroup = []
        this.commuincationGroup = []
        for (let user of usersList) {
          if (user.groupID === 2 || user.groupID === 3 || user.groupID === 4) { // **将智能化组相关成员放进同个数组
            this.intelligentGroup.push(user)
          } else if (user.groupID === 5) { // **将通信组成员放进同个数组
            this.commuincationGroup.push(user)
          }
        }
        this.usersList = usersList
        let conclusionYear = this.$moment(this.title).year()
        let conclusionMonth = this.$moment(this.title).month() + 1
        this.isOldRule = moment(this.title).isBefore(store.state.newRulesUpdateDate)
        this.isTeamWorkBegin = moment(this.title).isAfter(store.state.newRulesTeamWork)
        this.isPBScoreBegin = moment(this.title).isAfter(store.state.newRulesPBScore)
        getPerformanceIsPublish(conclusionYear, conclusionMonth).then(response => {
          this.PMPublishStatusData = response
          this.PMPublishStatus = false // ***绩效发布状态
          // **判断绩效发布状态
          if (this.PMPublishStatusData.length > 0) {
            if (this.PMPublishStatusData[0].flagValue !== 0) {
              this.PMPublishStatus = true
            }
          }
        })
        // this.isShowTeamWorkTable = moment(this.title).isAfter(store.state.newRulesTeamWork)
        // ***根据当前日期判断采用新/旧绩效计算规则
        if (this.isOldRule) {
          this.initData(conclusionYear, conclusionMonth, this.intelligentGroup, this.commuincationGroup, usersList)
        } else {
          this.genTableDataV2(conclusionYear, conclusionMonth, this.intelligentGroup, this.commuincationGroup).then(tableData => {
            if (store.state.userInfo.duty !== 1) {
              this.initDataCSV2(tableData)
            } else {
              this.initDataMGV2(tableData, conclusionYear, conclusionMonth, usersList)
            }
          })
        }
      })
    },

    // ***获取月总结及相关评价数据，生成初始表格数据
    genTableData (conclusionYear, conclusionMonth, intelligentGroup, CMGroup) {
      // 初始化默认数据
      let allconclusionAndEvaData = []
      let allUsers = intelligentGroup.concat(CMGroup) // 拼接成所有用户
      // =====================================根据当前用户类型生成待评价用户列表=================================
      // 首先构造表格数据单元组成
      let tableDataItem = {
        id: null,
        name: null,
        groupName: null,
        groupID: null,
        duty: null,
        job: null,
        submitStatus: 0, // 月总结提交状态
        evaStatus: 0, // 评价状态
        conclusionContent: [], // 月总结内容
        isShow: false, // 当前是否显示
        isEvaAllFinish: true, // 是否已经评价完别人了
        conclusionEva: [], // 当前用户对该用户评价的数据
        AMCSEvaTotalScore: 0, // 普通成员对该用户的成效评价总分
        AMGPEvaScore: 0, // 本组组长对该用户的成效评价总分
        AMMGEvaScore: 0, // 处经理对该用户的成效评价总分
        AMD1GPEvaStar: 0, // 组长对评价维度1的评价星级
        AMD2GPEvaStar: 0, // 组长对评价维度2的评价星级
        AMD1CSEvaTotalStar: 0, // 普通成员对评价维度1的总评价星级
        AMD2CSEvaTotalStar: 0, // 普通成员对评价维度2的总评价星级
        AMD1CSEvaAveStar: 0, // 普通成员对评价维度1的平均评价星级
        AMD2CSEvaAveStar: 0, // 普通成员对评价维度2的平均评价星级
        AMEvaScoreUnN: 0, // 用户的成效评价得分（未标准化）
        AMEvaScoreNor: 0, // 用户的成效评价得分（标准化）
        totalWorkTime: 0, // 用户的总工时
        PMRank: 0, // 绩效得分排名
        PMScoreUnN: 0, // 绩效得分(未标准化)
        PMScoreNor: 0, // 绩效得分排名（标准化）
        AMD1MGEvaStarV: 0, // 经理对评价维度1的虚拟评价星级
        AMD2MGEvaStarV: 0, // 经理对评价维度2的虚拟评价星级
        allAMEvaedData: [], // 被评价的数据
        isHighlight: false // 是否高亮显示
      }
      // ***如果当前用户属于智能化组，则构造智能化组的评价对象数组，即多媒体、数字物联和综合业务三组
      if (store.state.userInfo.groupID === 2 || store.state.userInfo.groupID === 3 || store.state.userInfo.groupID === 4) {
        for (let intelligentGroupItem of intelligentGroup) {
          tableDataItem.id = intelligentGroupItem.id
          tableDataItem.name = intelligentGroupItem.name
          tableDataItem.groupName = intelligentGroupItem.groupName
          tableDataItem.groupID = intelligentGroupItem.groupID
          tableDataItem.duty = intelligentGroupItem.duty
          tableDataItem.job = intelligentGroupItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem)))
        }
      } else if (store.state.userInfo.groupID === 5) { // ***如果当前用户属于通信组，则构造通信组的评价对象数组
        for (let CMGroupItem of CMGroup) {
          tableDataItem.id = CMGroupItem.id
          tableDataItem.name = CMGroupItem.name
          tableDataItem.groupName = CMGroupItem.groupName
          tableDataItem.groupID = CMGroupItem.groupID
          tableDataItem.duty = CMGroupItem.duty
          tableDataItem.job = CMGroupItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem)))
        }
      } else { // ***如果当前用户属于处经理组，则构造处经理的评价对象数组，即处室所有成员
        for (let allUsersItem of allUsers) {
          tableDataItem.id = allUsersItem.id
          tableDataItem.name = allUsersItem.name
          tableDataItem.groupName = allUsersItem.groupName
          tableDataItem.groupID = allUsersItem.groupID
          tableDataItem.duty = allUsersItem.duty
          tableDataItem.job = allUsersItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem)))
        }
      }
      // ***把自己去掉
      let findIndex = allconclusionAndEvaData.findIndex(item => { return item.id === store.state.userInfo.id })
      if (findIndex !== -1) {
        allconclusionAndEvaData.splice(findIndex, 1)
      }
      return new Promise(function (resolve, reject) {
        // ***根据构造的表格数据单元获取每个用户的月总结及对应的成效评价
        let evaUserID = store.state.userInfo.id
        let evaUserDuty = store.state.userInfo.duty
        let checkUserID = []
        for (let allconclusionAndEvaDataItem of allconclusionAndEvaData) {
          checkUserID.push(allconclusionAndEvaDataItem.id)
        }
        getCurMonthConclusionOverviewDataNew(conclusionYear, conclusionMonth, checkUserID, evaUserID, evaUserDuty).then(response => {
          let responseData = response.data
          // ======================判断月总结提交状态并对已提交总结的用户获取月总结内容对应的该用户的评价结果======================
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            let findResult = responseData.conclusionData.find(item => {
              return item.userID === allconclusionAndEvaData[i].id
            })
            allconclusionAndEvaData[i].submitStatus = typeof (findResult) !== 'undefined' ? findResult.submitStatus : 0
            allconclusionAndEvaData[i].conclusionContent = responseData.conclusionData.filter(item => {
              return item.userID === allconclusionAndEvaData[i].id
            })
            if (store.state.userInfo.duty !== 1) { // 普通成员
              allconclusionAndEvaData[i].conclusionEva = responseData.AMEvaedData.filter(item => {
                return (item.evaUserID === store.state.userInfo.id && item.evaedUserID === allconclusionAndEvaData[i].id)
              })
              allconclusionAndEvaData[i].evaStatus = allconclusionAndEvaData[i].conclusionEva.length > 0 ? 1 : 0
            } else { // 处经理
              allconclusionAndEvaData[i].conclusionEva = responseData.AMEvaedData.filter(item => {
                return (item.evaUserID === store.state.userInfo.id && item.evaedUserID === allconclusionAndEvaData[i].id)
              })
              allconclusionAndEvaData[i].evaStatus = allconclusionAndEvaData[i].conclusionEva.length > 0 ? 1 : 0
              allconclusionAndEvaData[i].allAMEvaedData = responseData.AMEvaedData.filter(item => {
                return item.evaedUserID === allconclusionAndEvaData[i].id
              })
            }
          }
          // =============================判断各位用户是否已经评价完其他人=========================
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            if (allconclusionAndEvaData[i].groupID === 2 ||
                allconclusionAndEvaData[i].groupID === 3 ||
                allconclusionAndEvaData[i].groupID === 2) {
              for (let j = 0; j < allconclusionAndEvaData.length; j++) {
                let findIndex = allconclusionAndEvaData[j].allAMEvaedData.findIndex(item => {
                  return item.evaUserID === allconclusionAndEvaData[i].id
                })
                if (findIndex === -1 && // 没找到
                    j !== i && // 不是本人
                    (allconclusionAndEvaData[j].groupID === 2 ||
                     allconclusionAndEvaData[j].groupID === 3 ||
                     allconclusionAndEvaData[j].groupID === 4)) {
                  allconclusionAndEvaData[i].isEvaAllFinish = false
                  break
                }
              }
            } else if (allconclusionAndEvaData[i].groupID === 5) {
              for (let j = 0; j < allconclusionAndEvaData.length; j++) {
                let findIndex = allconclusionAndEvaData[j].allAMEvaedData.findIndex(item => {
                  return item.evaUserID === allconclusionAndEvaData[i].id
                })
                if (findIndex === -1 && // 没找到
                    j !== i && // 不是本人
                    (allconclusionAndEvaData[j].groupID === 5)) {
                  allconclusionAndEvaData[i].isEvaAllFinish = false
                  break
                }
              }
            }
          }
          resolve(allconclusionAndEvaData)
        })
      })
    },

    // ***获取月总结及相关评价数据，生成初始表格数据v2
    genTableDataV2 (conclusionYear, conclusionMonth, intelligentGroup, commuincationGroup) {
      // ***初始化默认数据
      let allconclusionAndEvaData = []
      let allUsers = intelligentGroup.concat(commuincationGroup) // ***拼接所有成员
      // =====================================根据当前用户类型生成待评价用户列表=================================
      // ***首先构造表格数据单元组成
      let tableDataItem = {
        id: null,
        name: null,
        groupName: null,
        groupID: null,
        duty: null,
        job: null,
        submitStatus: 0, // ***月总结提交状态
        evaStatus: 0, // ***评价状态
        conclusionContent: [], // ***月总结内容
        isShow: false, // ***当前是否显示
        isEvaAllFinish: true, // ***是否已经评价完别人了
        conclusionEva: [], // ***当前用户对该用户评价的数据
        AMCSEvaTotalScore: 0, // ***普通成员对该用户的成效评价总分
        AMGPEvaScore: 0, // ***本组组长对该用户的成效评价总分
        AMMGEvaScore: 0, // ***处经理对该用户的成效评价总分
        AMD1GPEvaStar: 0, // ***组长对评价维度1的评价星级
        AMD2GPEvaStar: 0, // ***组长对评价维度2的评价星级
        AMD1CSEvaTotalStar: 0, // ***普通成员对评价维度1的总评价星级
        AMD2CSEvaTotalStar: 0, // ***普通成员对评价维度2的总评价星级
        AMD1CSEvaAveStar: 0, // ***普通成员对评价维度1的平均评价星级
        AMD2CSEvaAveStar: 0, // ***普通成员对评价维度2的平均评价星级
        AMEvaScoreUnN: 0, // ***用户的成效评价得分（未标准化）
        AMEvaScoreNor: 0, // ***用户的成效评价得分（标准化）
        totalWorkTime: 0, // ***用户的总工时
        PMRank: 0, // ***绩效得分排名
        PMScoreUnN: 0, // ***绩效得分(未标准化)
        PMScoreNor: 0, // ***绩效得分排名（标准化）
        AMD1MGEvaStarV: 0, // ***经理对评价维度1的虚拟评价星级
        AMD2MGEvaStarV: 0, // ***经理对评价维度2的虚拟评价星级
        allAMEvaedData: [], // ***被成效评价的数据
        teamWorkEvaedData: [], // ***被小组工作评价的数据
        isHighlight: false, // ***是否高亮显示
        teamWorkScore: 0 // **小组评价分数
      }
      // ***基于表格数据单元，构造评价对象数组
      // ***如果当前用户属于智能化组，则构造智能化组的评价对象数组，即多媒体、数字物联和综合业务三组
      if (store.state.userInfo.groupID === 2 || store.state.userInfo.groupID === 3 || store.state.userInfo.groupID === 4) {
        for (let intelligentGroupItem of intelligentGroup) {
          tableDataItem.id = intelligentGroupItem.id
          tableDataItem.name = intelligentGroupItem.name
          tableDataItem.groupName = intelligentGroupItem.groupName
          tableDataItem.groupID = intelligentGroupItem.groupID
          tableDataItem.duty = intelligentGroupItem.duty
          tableDataItem.job = intelligentGroupItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem))) // ***如果当前用户属于通信组，则构造通信组的评价对象数组
        }
      } else if (store.state.userInfo.groupID === 5) { // ***如果当前用户属于通信组，则构造通信组的评价对象数组
        for (let commuincationGroupItem of commuincationGroup) {
          tableDataItem.id = commuincationGroupItem.id
          tableDataItem.name = commuincationGroupItem.name
          tableDataItem.groupName = commuincationGroupItem.groupName
          tableDataItem.groupID = commuincationGroupItem.groupID
          tableDataItem.duty = commuincationGroupItem.duty
          tableDataItem.job = commuincationGroupItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem)))
        }
      } else { // ***如果当前用户属于处经理组，则构造处经理的评价对象数组，即处室所有成员
        for (let allUsersItem of allUsers) {
          tableDataItem.id = allUsersItem.id
          tableDataItem.name = allUsersItem.name
          tableDataItem.groupName = allUsersItem.groupName
          tableDataItem.groupID = allUsersItem.groupID
          tableDataItem.duty = allUsersItem.duty
          tableDataItem.job = allUsersItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem)))
        }
      }
      // ***把自己去掉
      let findIndex = allconclusionAndEvaData.findIndex(item => { return item.id === store.state.userInfo.id })
      if (findIndex !== -1) {
        allconclusionAndEvaData.splice(findIndex, 1)
      }
      return new Promise(function (resolve, reject) {
        // ***根据构造的表格数据单元获取每个用户的月总结及对应的评价
        let evaUserID = store.state.userInfo.id
        let evaUserDuty = store.state.userInfo.duty
        let checkUserID = []
        for (let allconclusionAndEvaDataItem of allconclusionAndEvaData) {
          checkUserID.push(allconclusionAndEvaDataItem.id)
        }
        getCurMonthConclusionOverviewDataNewV2(conclusionYear, conclusionMonth, checkUserID, evaUserID, evaUserDuty).then(response => {
          let responseData = response.data
          // ***判断月总结提交状态并对已提交总结的用户获取月总结内容对应的该用户的评价结果
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            allconclusionAndEvaData[i].conclusionContent = responseData.conclusionData.filter(item => { // ***提取月总结内容
              return item.userID === allconclusionAndEvaData[i].id
            })
            // ***赋值评价对象的月总结提交状态
            let findResult = allconclusionAndEvaData[i].conclusionContent.find(item => { return item.dimension === 1 }) // **避免本月还未提交月总结，却有上月计划的情况
            if (!isUndefined(findResult)) {
              allconclusionAndEvaData[i].submitStatus = findResult.submitStatus
            }
            // ***填充评价人对评价对象的评价数据
            // 构建当月维度ID集合，用于过滤掉上月dim=3评价记录的干扰
            let currentMonthConclusionIDs = new Set()
            for (let cItem of allconclusionAndEvaData[i].conclusionContent) {
              if (cItem.conclusionYear === conclusionYear && cItem.conclusionMonth === conclusionMonth) {
                currentMonthConclusionIDs.add(cItem.id)
              }
            }
            allconclusionAndEvaData[i].conclusionEva = responseData.AMEvaedData.filter(item => {
              return (item.evaUserID === store.state.userInfo.id && item.evaedUserID === allconclusionAndEvaData[i].id && currentMonthConclusionIDs.has(item.dimensionID))
            })
            // ***判断评价人对评价对象的评价状态
            allconclusionAndEvaData[i].evaStatus = allconclusionAndEvaData[i].conclusionEva.length > 0 ? 1 : 0
            // ***如果是处经理，则额外填充其他成员对评价的对象的成效评价数据
            if (store.state.userInfo.duty === 1) {
              allconclusionAndEvaData[i].allAMEvaedData = responseData.AMEvaedData.filter(item => {
                return item.evaedUserID === allconclusionAndEvaData[i].id && item.dimension !== 5 && currentMonthConclusionIDs.has(item.dimensionID)
              })
              allconclusionAndEvaData[i].teamWorkEvaedData = responseData.AMEvaedData.filter(item => {
                return item.evaedUserID === allconclusionAndEvaData[i].id && item.dimension === 5 && currentMonthConclusionIDs.has(item.dimensionID)
              })
            }
          }
          // ***判断各位用户是否已经评价完其他人
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            if (allconclusionAndEvaData[i].groupID === 2 ||
                allconclusionAndEvaData[i].groupID === 3 ||
                allconclusionAndEvaData[i].groupID === 4) { // ***如果评价人是智能化组的人员，则只查询对智能化组人员的评价情况
              for (let j = 0; j < allconclusionAndEvaData.length; j++) {
                let findIndex = allconclusionAndEvaData[j].allAMEvaedData.findIndex(item => {
                  return item.evaUserID === allconclusionAndEvaData[i].id
                })
                if (findIndex === -1 && // ***没找到
                    j !== i && // ***不是本人
                    (allconclusionAndEvaData[j].groupID === 2 || // ***查询的被评价对象与评价人为同个评价组
                     allconclusionAndEvaData[j].groupID === 3 ||
                     allconclusionAndEvaData[j].groupID === 4)) { // ***智能化组
                  allconclusionAndEvaData[i].isEvaAllFinish = false
                  break
                }
              }
            } else if (allconclusionAndEvaData[i].groupID === 5) { // ***如果评价人是通信组的人员，则只查询对通信组人员的评价情况
              for (let j = 0; j < allconclusionAndEvaData.length; j++) {
                let findIndex = allconclusionAndEvaData[j].allAMEvaedData.findIndex(item => {
                  return item.evaUserID === allconclusionAndEvaData[i].id
                })
                if (findIndex === -1 && // ***没找到
                    j !== i && // ***不是本人
                    (allconclusionAndEvaData[j].groupID === 5)) { // ***查询的被评价对象与评价人为同个评价组
                  allconclusionAndEvaData[i].isEvaAllFinish = false
                  break
                }
              }
            }
          }
          resolve(allconclusionAndEvaData)
        }).catch(err => {
          console.log('err')
          reject(err)
        })
      })
    },

    // ***初始化显示数据***
    initData (conclusionYear, conclusionMonth, intelligentGroup, CMGroup, usersList) {
      // ***生成表格初始数据（获取其他人的月总结以及对其他人的月总结评价）
      this.genTableData(conclusionYear, conclusionMonth, intelligentGroup, CMGroup).then(tableData => {
        // ***普通员工
        if (store.state.userInfo.duty !== 1) {
          // ***初始化默认显示的数据
          for (let i = 0; i < tableData.length; i++) {
            if (tableData[i].submitStatus !== 0) {
              tableData[i].isShow = true
              tableData[i].isHighlight = true
              this.curEvaUserName = tableData[i].name
              this.table1CurShowIndex = i
              this.table1PreShowIndex = i
              this.currentShowUserisEva = tableData[i].evaStatus === 1
              this.buildBoutiqueProject = tableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
              })
              this.buildProTeam = tableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
              })
              this.nextPlan = tableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
              })
              this.curAdvice = tableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
              })
              if (tableData[i].evaStatus === 1) {
                this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                    return evaItem.dimensionID === this.buildBoutiqueProject.id
                })))
                this.buildProTeamStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                  return evaItem.dimensionID === this.buildProTeam.id
                })))
              }
              break
            }
          }
          this.PMData = tableData
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
          this.getDataLoading = true
        } else { // 管理者页面
          // 首先判断绩效信息发布状态并获取每条月总结对应的所有评价，如果绩效已发布，则显示已经发布的绩效数据；
          getPerformanceIsPublish(conclusionYear, conclusionMonth).then(response => {
            this.PMPublishStatusData = response // 绩效发布状态
            this.PMPublishStatus = false
            if (this.PMPublishStatusData.length > 0) {
              if (this.PMPublishStatusData[0].flagValue !== 0) {
                this.PMPublishStatus = true // 绩效发布状态设置为已发布
              }
            }
            // 获取全处工时审核状态
            getSubmitWorkTimeCount(usersList, this.title).then(getSubmitWorkTimeCountRes => {
              this.workTimeRWed = true
              for (let item of getSubmitWorkTimeCountRes) {
                if (item.unReviewProjectCount > 0 && !this.PMPublishStatus) {
                  this.workTimeRWed = false
                  break
                }
              }
            })
            // 根据绩效发布状态选择直接获取绩效库数据或是重新计算绩效数据
            // 1、直接获取绩效数据：a.绩效库有数据且绩效发布状态为已发布
            // 2、重新计算绩效数据：a.绩效库无数据；b.绩效库有数据但未发布
            if (this.PMPublishStatus) { // 直接获取绩效数据->绩效库有数据且绩效发布状态为已发布
              getPMData(this.title).then(getPMDataRes => {
                for (let tableDataItem of tableData) {
                  let findResult = getPMDataRes.find(getPMDataResItem => {
                    return getPMDataResItem.userID === tableDataItem.id
                  })
                  tableDataItem.PMRankChange = 0
                  tableDataItem.AMD1CSEvaAveStar = findResult.dimension1CSAveStar
                  tableDataItem.AMD1GPEvaStar = findResult.dimension1GPEvaStar
                  tableDataItem.AMD2CSEvaAveStar = findResult.dimension2CSAveStar
                  tableDataItem.AMD2GPEvaStar = findResult.dimension2GPEvaStar
                  tableDataItem.totalWorkTime = findResult.totalWorkTime
                  tableDataItem.QYEvaRank = findResult.QYEvaRank
                  tableDataItem.AMEvaRank = findResult.AMEvaRank
                  tableDataItem.PMRank = findResult.PMRank
                  tableDataItem.PMScoreNor = findResult.PMScoreNor
                }
                // 排序
                tableData.sort(sortByAscend('PMRank'))
                this.initPMData = JSON.parse(JSON.stringify(tableData))
                // 显示第一个已提交的用户信息
                for (let i = 0; i < tableData.length; i++) {
                  if (tableData[i].submitStatus !== 0) {
                    tableData[i].isShow = true
                    tableData[i].isHighlight = true
                    this.curEvaUserName = tableData[i].name
                    this.table1CurShowIndex = i
                    this.table1PreShowIndex = i
                    this.currentShowUserisEva = tableData[i].evaStatus === 1
                    this.buildBoutiqueProject = tableData[i].conclusionContent.find(contenItem => {
                      return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
                    })
                    this.buildProTeam = tableData[i].conclusionContent.find(contenItem => {
                      return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
                    })
                    this.nextPlan = tableData[i].conclusionContent.find(contenItem => {
                      return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
                    })
                    this.curAdvice = tableData[i].conclusionContent.find(contenItem => {
                      return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
                    })
                    if (tableData[i].evaStatus === 1) {
                      this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                          return evaItem.dimensionID === this.buildBoutiqueProject.id
                      })))
                      this.buildProTeamStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                        return evaItem.dimensionID === this.buildProTeam.id
                      })))
                    } else { // 当前显示用户的评价星级设置为虚拟构建的评价星级
                      this.buildBoutiqueProjectStar.evaStar = tableData[i].AMD1MGEvaStarV === store.state.userInfo.defaultStar
                                                              ? this.buildBoutiqueProjectStar.evaStar : tableData[i].AMD1MGEvaStarV
                      this.buildProTeamStar.evaStar = tableData[i].AMD1MGEvaStarV === store.state.userInfo.defaultStar
                                                      ? this.buildProTeamStar.evaStar : tableData[i].AMD2MGEvaStarV
                    }
                    // 显示组员平均评价星级和组长评价星级
                    this.dimension1CSAveStar = tableData[i].AMD1CSEvaAveStar != null ? Number(tableData[i].AMD1CSEvaAveStar.toFixed(2)) : 0
                    this.dimension1GPEvaStar = tableData[i].AMD1GPEvaStar != null ? Number(tableData[i].AMD1GPEvaStar.toFixed(2)) : 0
                    this.dimension2CSAveStar = tableData[i].AMD2CSEvaAveStar != null ? Number(tableData[i].AMD2CSEvaAveStar.toFixed(2)) : 0
                    this.dimension2GPEvaStar = tableData[i].AMD2GPEvaStar != null ? Number(tableData[i].AMD2GPEvaStar.toFixed(2)) : 0
                    break
                  }
                }
                this.PMData = tableData
                this.forceRefresh = false
                this.$nextTick(() => {
                  this.forceRefresh = true
                })
                this.getDataLoading = true
              })
            } else { // 重新计算绩效数据->绩效库无数据或绩效库有数据但未发布
              let promises = []
              let count = 0
              promises[count++] = getAllWorkTimeList(this.title) // 获取工时申报情况
              promises[count++] = getAllQTEvaedData(usersList, this.title) // 获取定性评价情况
              promises[count++] = getEvaCoef() // 获取各种系数
              if (this.PMPublishStatusData.length > 0) { // 如果绩效数据库里面有绩效，则获取绩效数据
                promises[count++] = getPMData(this.title)
              }
              Promise.all(promises).then(allResponse => {
                let allWorkTimeList = allResponse[0]
                let QTEvaedData = allResponse[1]
                this.evaCoefObj = allResponse[2]
                if (this.PMPublishStatusData.length > 0) { // 如果绩效数据库里面有绩效，则获取
                  this.publishedPMData = allResponse[3]
                }
                this.QYEvaScoreData = genQYEvaScoreData(usersList, allWorkTimeList, this.title) // 生成定量评价数据
                this.QTEvaScoreData = genQualiEvaData(QTEvaedData, this.QYEvaScoreData) // 生成定性评价数据
                tableData = genAMEvaScoreData(tableData,
                                      this.evaCoefObj.AMBuildBoutiqueProjectCoef, this.evaCoefObj.AMBuildProTeamCoef,
                                      this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                      this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                      this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData) // 生成成效评价数据
                // 计算绩效信息
                tableData = genPerformanceScore(tableData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
                // 排序
                tableData = sortObjectArrayByParams(tableData, 'PMScoreUnN', 'totalWorkTime')
                this.initPMData = JSON.parse(JSON.stringify(tableData))
                // 显示第一个已提交的用户信息
                for (let i = 0; i < tableData.length; i++) {
                  if (tableData[i].submitStatus !== 0) {
                    tableData[i].isShow = true
                    tableData[i].isHighlight = true
                    this.curEvaUserName = tableData[i].name
                    this.table1CurShowIndex = i
                    this.table1PreShowIndex = i
                    this.currentShowUserisEva = tableData[i].evaStatus === 1
                    this.buildBoutiqueProject = tableData[i].conclusionContent.find(contenItem => {
                      return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
                    })
                    this.buildProTeam = tableData[i].conclusionContent.find(contenItem => {
                      return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
                    })
                    this.nextPlan = tableData[i].conclusionContent.find(contenItem => {
                      return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
                    })
                    this.curAdvice = tableData[i].conclusionContent.find(contenItem => {
                      return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
                    })
                    if (tableData[i].evaStatus === 1) {
                      this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                          return evaItem.dimensionID === this.buildBoutiqueProject.id
                      })))
                      this.buildProTeamStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                        return evaItem.dimensionID === this.buildProTeam.id
                      })))
                    } else { // 当前显示用户的评价星级设置为虚拟构建的评价星级
                      this.buildBoutiqueProjectStar.evaStar = tableData[i].AMD1MGEvaStarV === 0
                                                              ? this.buildBoutiqueProjectStar.evaStar : tableData[i].AMD1MGEvaStarV
                      this.buildProTeamStar.evaStar = tableData[i].AMD1MGEvaStarV === 0
                                                      ? this.buildProTeamStar.evaStar : tableData[i].AMD2MGEvaStarV
                    }
                    // 显示组员平均评价星级和组长评价星级
                    this.dimension1CSAveStar = tableData[i].AMD1CSEvaAveStar != null ? Number(tableData[i].AMD1CSEvaAveStar.toFixed(2)) : 0
                    this.dimension1GPEvaStar = tableData[i].AMD1GPEvaStar != null ? Number(tableData[i].AMD1GPEvaStar.toFixed(2)) : 0
                    this.dimension2CSAveStar = tableData[i].AMD2CSEvaAveStar != null ? Number(tableData[i].AMD2CSEvaAveStar.toFixed(2)) : 0
                    this.dimension2GPEvaStar = tableData[i].AMD2GPEvaStar != null ? Number(tableData[i].AMD2GPEvaStar.toFixed(2)) : 0
                    break
                  }
                }
                this.PMData = tableData
                this.forceRefresh = false
                this.$nextTick(() => {
                  this.forceRefresh = true
                })
                this.getDataLoading = true
              })
            }
          }) // 获取绩效信息发布状态
        }
      })
    },

    // ***初始化显示数据V2(普通员工)***
    initDataCSV2 (tableData) {
      // 生成表格初始数据（获取其他人的月总结以及对其他人的月总结评价）
      // ************显示第一个已提交的用户信息**********
      let findIndex = tableData.findIndex(item => { return item.submitStatus === 1 })
      if (findIndex !== -1) {
        this.showConclusionDataCS(tableData[findIndex], findIndex)
      }
      this.PMData = tableData
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
      this.getDataLoading = true
    },

    // ***显示月总结信息（普通员工）***
    showConclusionDataCS (row, index) {
      this.tableData1 = []
      this.tableData2 = []
      this.showThisMonthPlan = true
      row.isShow = true
      row.isHighlight = true
      this.curEvaUserName = row.name
      this.table1CurShowIndex = index
      this.table1PreShowIndex = index
      this.currentShowUserisEva = row.evaStatus === 1
      if (this.isMergedConclusion) {
        // 合并模式下：仅使用dimension 1作为月度总结
        let findResult = row.conclusionContent.find(contenItem => {
          return contenItem.dimension === 1
        })
        this.dimension1IDV2 = findResult.id
        let obj = {
          evaClass: '月度总结',
          dimension1V2Content: findResult.content
        }
        this.tableData1.push(JSON.parse(JSON.stringify(obj)))
      } else {
        // 旧模式：打造精品工程 + 创建专业团队
        let findResult = row.conclusionContent.find(contenItem => {
          return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
        })
        this.dimension1IDV2 = findResult.id
        let obj = {
          evaClass: '打造精品工程',
          dimension1V2Content: findResult.content
        }
        this.tableData1.push(JSON.parse(JSON.stringify(obj)))
        // ********************寻找创建专业团队维度的内容********************
        findResult = row.conclusionContent.find(contenItem => {
          return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
        })
        obj.evaClass = '创建专业团队'
        obj.dimension1V2Content = findResult.content
        this.tableData1.push(JSON.parse(JSON.stringify(obj)))
      }
      // ********************寻找下月计划维度的内容********************
      let findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      })
      this.dimension2IDV2 = findResult.id
      let obj2 = {
        dimension2V2Content: findResult.content
      }
      this.tableData2.push(JSON.parse(JSON.stringify(obj2)))
      // ***********************获取当月月总结中的下月计划***********************
      let conclusionYearCS = moment(this.title).year()
      let conclusionMonthCS = moment(this.title).month() + 1
      getCurMonthConclusionOverviewDataNewV3(conclusionYearCS, conclusionMonthCS, row.id).then(curMonthNextPlanData => {
        if (curMonthNextPlanData && curMonthNextPlanData.length > 0) {
          this.curMonthNextPlan = curMonthNextPlanData[0]
          if (this.isMergedConclusion) {
            this.dimension2IDV2 = curMonthNextPlanData[0].id
          }
        } else {
          this.curMonthNextPlan = { content: '无数据' }
        }
        // 在V3回调内完成下月计划星级显示，确保dimension2IDV2已正确赋值
        if (row.evaStatus === 1) {
          let evaFind = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension2IDV2
          })
          if (evaFind) {
            this.dimension2V2Star = evaFind.evaStar
            this.dimenision2EvaIDV2 = evaFind.id
          }
        } else {
          this.dimension2V2Star = store.state.defaultConclusionEvaStar
        }
      }).catch(() => {
        this.curMonthNextPlan = { content: '无数据' }
        this.dimension2V2Star = store.state.defaultConclusionEvaStar
      })
      // ***********************显示评价星级***********************
      if (row.evaStatus === 1) {
        findResult = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension1IDV2
        })
        this.dimension1V2Star = findResult.evaStar
        this.dimenision1EvaIDV2 = findResult.id
      } else {
        this.dimension1V2Star = store.state.defaultConclusionEvaStar
      }
    },

    // ***初始化显示数据V2(管理者)***
    initDataMGV2 (tableData, conclusionYear, conclusionMonth, usersList) {
      // *********首先判断绩效信息发布状态并获取每条月总结对应的所有评价，如果绩效已发布，则显示已经发布的绩效数据；
      getPerformanceIsPublish(conclusionYear, conclusionMonth).then(response => {
        this.PMPublishStatusData = response
        this.PMPublishStatus = false // ***绩效发布状态
        this.workTimeRWed = true // ***工时审核状态
        // **判断绩效发布状态
        if (this.PMPublishStatusData.length > 0) {
          if (this.PMPublishStatusData[0].flagValue !== 0) {
            this.PMPublishStatus = true
          }
        }
        // ***获取全处工时审核状态
        getSubmitWorkTimeCount(usersList, this.title).then(getSubmitWorkTimeCountRes => {
          for (let item of getSubmitWorkTimeCountRes) {
            if (item.unReviewProjectCount > 0 && !this.PMPublishStatus) {
              this.workTimeRWed = false
              break
            }
          }
        })
        // ***根据绩效发布状态选择直接获取绩效库数据或是重新计算绩效数据
        // ***1、直接获取绩效数据：绩效库有数据且绩效发布状态为已发布
        // ***2、重新计算绩效数据：a.绩效库无数据；b.绩效库有数据但未发布
        if (this.PMPublishStatus) { // ***************1、直接获取绩效数据->绩效库有数据且绩效发布状态为已发布
          getPMData(this.title).then(getPMDataRes => {
            let undefinedIndex = -1
            for (let i = 0; i < tableData.length; i++) {
              let findResult = getPMDataRes.find(getPMDataResItem => {
                return getPMDataResItem.userID === tableData[i].id
              })
              if (!isUndefined(findResult)) {
                tableData[i].PMRankChange = 0
                tableData[i].AMD1CSEvaAveStar = findResult.dimension1CSAveStar
                tableData[i].AMD1GPEvaStar = findResult.dimension1GPEvaStar
                tableData[i].AMD2CSEvaAveStar = findResult.dimension2CSAveStar
                tableData[i].AMD2GPEvaStar = findResult.dimension2GPEvaStar
                tableData[i].totalWorkTime = findResult.totalWorkTime
                tableData[i].QYEvaRank = findResult.QYEvaRank
                tableData[i].AMEvaRank = findResult.AMEvaRank
                tableData[i].PMRank = findResult.PMRank
                tableData[i].PMScoreNor = findResult.PMScoreNor
                tableData[i].PMScoreUnN = findResult.PMScoreUnN
                tableData[i].PBScore = findResult.PBScore
                tableData[i].QYEvaScoreNor = findResult.QYEvaScoreNor != null ? Number(findResult.QYEvaScoreNor.toFixed(3)) : 0
              } else {
                undefinedIndex = i
              }
            }
            if (undefinedIndex !== -1) {
              tableData.splice(undefinedIndex, 1)
            }
            // ***根据绩效排名进行排序
            tableData.sort(sortByAscend('PMRank'))
            this.initPMData = JSON.parse(JSON.stringify(tableData))
            // ***默认不高亮且不显示
            for (let item of this.initPMData) {
              item.isShow = false
              item.isHighlight = false
            }
            // ***显示月总结信息***
            let findIndex = tableData.findIndex(item => { return item.submitStatus === 1 })
            if (findIndex !== -1) {
              this.showConclusionDataMG(tableData[findIndex], findIndex)
            }
            this.PMData = tableData
            this.forceRefresh = false
            this.$nextTick(() => {
              this.forceRefresh = true
            })
            this.getDataLoading = true
          })
        } else { // ***重新计算绩效数据->绩效库无数据或绩效库有数据但未发布***
          let promises = []
          let count = 0
          let PMPublishIndex = -1
          let PBScoreIndex = -1
          promises[count++] = getAllWorkTimeList(this.title) // ***获取工时申报数据
          promises[count++] = getAllQTEvaedData(usersList, this.title) // ***获取定性评价数据
          promises[count++] = getEvaCoef() // ***获取各种系数***
          if (this.PMPublishStatusData.length > 0) { // ***如果绩效数据库里面有绩效，则获取绩效数据
            PMPublishIndex = count
            promises[count++] = getPMData(this.title)
          }
          // ***如果当前月份已经开始进行绩效加分，则获取绩效加分数据
          if (moment(this.title).isAfter(store.state.newRulesPBScore)) {
            let applyYear = moment(this.title).year()
            let applyMonth = moment(this.title).month() + 1
            PBScoreIndex = count
            promises[count++] = getPBData(applyYear, applyMonth)
          }
          Promise.all(promises).then(allResponse => {
            let allWorkTimeList = allResponse[0]
            let QTEvaedData = allResponse[1]
            this.evaCoefObj = allResponse[2]
            if (this.PMPublishStatusData.length > 0) { // *******如果绩效数据库里面有绩效，则获取相应绩效数据
              this.publishedPMData = allResponse[PMPublishIndex]
            }
            // *******生成定量评价数据
            // ***如果当前月份已经开始进行绩效加分，则执行工时上限的方案
            if (moment(this.title).isAfter(store.state.newRulesPBScore)) {
              this.QYEvaScoreData = genQYEvaScoreDataV2(usersList, allWorkTimeList, this.title)
            } else {
              this.QYEvaScoreData = genQYEvaScoreData(usersList, allWorkTimeList, this.title)
            }
            // *******生成定性评价数据
            this.QTEvaScoreData = genQualiEvaData(QTEvaedData, this.QYEvaScoreData)
            // *******生成成效评价数据
            tableData = genAMEvaScoreDataV2(tableData,
                                  this.evaCoefObj.AMDimension1CoefV2, this.evaCoefObj.AMDimension2CoefV2,
                                  this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                  this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                  this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData)
            // ***如果当前月份已经开始进行小组工作评价，则计算小组评价得分
            if (moment(this.title).isAfter(store.state.newRulesTeamWork)) {
              this.genTeamWorkEvaData(tableData)
            }
            // ***如果当前月份已经开始进行绩效加分，则获取绩效加分数据
            if (moment(this.title).isAfter(store.state.newRulesPBScore)) {
              this.genPBScoreData(tableData, allResponse[PBScoreIndex])
            }
            // ***根据当前时间，选择计算绩效数据的版本
            // ***moment(this.title).isAfter(store.state.newRulesTeamWork)
            if (moment(this.title).isAfter(store.state.newRulesTeamWork)) {
              if (moment(this.title).isAfter(store.state.newRulesPBScore)) {
                tableData = genPerformanceScoreV3(tableData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
              } else {
                tableData = genPerformanceScoreV2(tableData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
              }
            } else {
              tableData = genPerformanceScore(tableData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
            }
            // ***根据未标准化的绩效得分和总工时进行排序
            tableData = sortObjectArrayByParams(tableData, 'PMScoreUnN', 'totalWorkTime')
            // ***记录初始绩效数据
            this.initPMData = JSON.parse(JSON.stringify(tableData))
            for (let item of this.initPMData) {
              item.isShow = false
              item.isHighlight = false
            }
            // ***显示月总结信息***
            let findIndex = tableData.findIndex(item => { return item.submitStatus === 1 })
            if (findIndex !== -1) {
              this.showConclusionDataMG(tableData[findIndex], findIndex)
            }
            this.PMData = tableData
            this.forceRefresh = false
            this.$nextTick(() => {
              this.forceRefresh = true
            })
            for (let item of tableData) {
              if (item.AMMGEvaScore > 95.0) {
                Notification.error({
                  title: '错误',
                  message: '数据错误，请联系江黄能'
                })
              }
            }
            this.getDataLoading = true
          })
        }
      }) // 获取绩效信息发布状态
    },
    // ***绩效加分数据
    genPBScoreData (tableData, PBData) {
      let reviewPassPBData = PBData.filter(item => { return item.reviewStatus === 1 })
      let PBScoreAssign = []
      for (let reviewPassPBDataItem of reviewPassPBData) {
        for (let PBScoreAssignItem of reviewPassPBDataItem.PBScoreAssign) {
          PBScoreAssign.push(PBScoreAssignItem)
        }
      }
      for (let tableDataItem of tableData) {
        let PBScore = 0
        for (let PBScoreAssignItem of PBScoreAssign) {
          if (tableDataItem.id === PBScoreAssignItem.userID) {
            PBScore += PBScoreAssignItem.assignScore
          }
        }
        tableDataItem.PBScore = Number(PBScore.toFixed(2))
      }
    },
    // ***生成小组评价数据
    genTeamWorkEvaData (tableData) {
      for (let tableItem of tableData) {
        if (tableItem.duty === 2) { // **只有小组长有小组工作评价
          if (tableItem.teamWorkEvaedData.length !== 0) {
            tableItem.teamWorkScore = starToRatesNew(tableItem.teamWorkEvaedData[0].evaStar)
          } else {
            tableItem.teamWorkScore = starToRatesNew(this.dimension4V2Star)
          }
        }
      }
    },

    // ***显示月总结信息(管理者)***
    showConclusionDataMG (row, index) {
      this.tableData1 = []
      this.tableData2 = []
      this.tableData3 = []
      this.teamWorkData = []
      this.showThisMonthPlan = true
      row.isShow = true
      row.isHighlight = true
      this.curEvaUserName = row.name
      this.table1CurShowIndex = index
      this.table1PreShowIndex = index
      this.currentShowUserisEva = row.evaStatus === 1
      this.isShowTeamWorkTable = moment(this.title).isAfter(store.state.newRulesTeamWork) && row.duty === 2
      // ***********************寻找打造精品工程/月度总结维度的内容***********************
      let obj = {
        evaClass: '',
        dimension1V2Content: null,
        dimension2V2Content: null,
        dimension3V2Content: null,
        dimension4V2Content: null
      }
      if (this.isMergedConclusion) {
        let findResult = row.conclusionContent.find(contenItem => {
          return contenItem.dimension === 1
        })
        if (!isUndefined(findResult)) {
          this.dimension1IDV2 = findResult.id
          obj.evaClass = '月度总结'
          obj.dimension1V2Content = findResult.content
        }
        this.tableData1.push(JSON.parse(JSON.stringify(obj)))
      } else {
        let findResult = row.conclusionContent.find(contenItem => {
          return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
        })
        if (!isUndefined(findResult)) {
          this.dimension1IDV2 = findResult.id
          obj.dimension1V2Content = findResult.content
        }
        obj.evaClass = '打造精品工程'
        this.tableData1.push(JSON.parse(JSON.stringify(obj)))
        // ***********************寻找创建专业团队维度的内容***********************
        findResult = row.conclusionContent.find(contenItem => {
          return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
        })
        if (!isUndefined(findResult)) {
          obj.dimension1V2Content = findResult.content
        }
        obj.evaClass = '创建专业团队'
        this.tableData1.push(JSON.parse(JSON.stringify(obj)))
      }
      // ***********************寻找下月计划维度的内容***********************
      let findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      })
      if (!isUndefined(findResult)) {
        this.dimension2IDV2 = findResult.id
        obj.dimension2V2Content = findResult.content
        this.nextPlan = findResult
      }
      this.tableData2.push(JSON.parse(JSON.stringify(obj)))
      // ***********************寻找小组工作总结的内容***********************
      findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNewGP.teamWork.dimension
      })
      if (!isUndefined(findResult)) {
        this.dimension4IDV2 = findResult.id
        obj.dimension4V2Content = findResult.content
        this.teamWorkData.push(JSON.parse(JSON.stringify(obj)))
      }
      // ***********************寻找处室意见维度的内容***********************
      findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
      })
      if (!isUndefined(findResult)) {
        this.curAdvice = findResult
        obj.dimension3V2Content = findResult.content === '' ? '无数据' : findResult.content
      }
      this.tableData3.push(JSON.parse(JSON.stringify(obj)))
      // ***********************获取当月月总结中的下月计划***********************
      let conclusionYearMG = moment(this.title).year()
      let conclusionMonthMG = moment(this.title).month() + 1
      getCurMonthConclusionOverviewDataNewV3(conclusionYearMG, conclusionMonthMG, row.id).then(curMonthNextPlanData => {
        if (curMonthNextPlanData && curMonthNextPlanData.length > 0) {
          this.curMonthNextPlan = curMonthNextPlanData[0]
          if (this.isMergedConclusion) {
            this.dimension2IDV2 = curMonthNextPlanData[0].id
          }
        } else {
          this.curMonthNextPlan = { content: '无数据' }
        }
        // 在V3回调内完成下月计划星级显示，确保dimension2IDV2已正确赋值
        if (row.evaStatus === 1) {
          let evaFind = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension2IDV2
          })
          if (!isUndefined(evaFind)) {
            this.dimension2V2Star = evaFind.evaStar
            this.dimenision2EvaIDV2 = evaFind.id
          }
        }
      }).catch(() => {
        this.curMonthNextPlan = { content: '无数据' }
      })
      // ***********************显示评价星级***********************
      if (row.evaStatus === 1) {
        // ***查找打造精品工程、创建专业团队的评价内容
        findResult = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension1IDV2
        })
        if (!isUndefined(findResult)) {
          this.dimension1V2Star = findResult.evaStar
          this.dimenision1EvaIDV2 = findResult.id
        }
        // ***查找小组工作的评价内容
        findResult = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension4IDV2
        })
        if (!isUndefined(findResult)) {
          this.dimension4V2Star = findResult.evaStar
          this.dimenision4EvaIDV2 = findResult.id
        }
      } else { // ************如果当前用户还未评价，则显示为虚拟构建的评价星级
        this.dimension1V2Star = row.AMD1MGEvaStarV
        this.dimension2V2Star = row.AMD2MGEvaStarV
        this.dimension4V2Star = store.state.defaultStar
      }
      // ***********************显示组员平均评价星级和组长评价星级
      this.dimension1CSAveStar = row.AMD1CSEvaAveStar != null ? Number(row.AMD1CSEvaAveStar.toFixed(2)) : 0
      this.dimension1GPEvaStar = row.AMD1GPEvaStar != null ? Number(row.AMD1GPEvaStar.toFixed(2)) : 0
      this.dimension2CSAveStar = row.AMD2CSEvaAveStar != null ? Number(row.AMD2CSEvaAveStar.toFixed(2)) : 0
      this.dimension2GPEvaStar = row.AMD2GPEvaStar != null ? Number(row.AMD2GPEvaStar.toFixed(2)) : 0
    },

    // ***点击显示
    table1HandleShow (row, index) {
      // 如果是经理，将显示的绩效数据设置为初始状态
      if (store.state.userInfo.duty === 1) {
        this.PMData = JSON.parse(JSON.stringify(this.initPMData))
      }
      this.curEvaUserName = row.name
      this.table1CurShowIndex = index
      this.PMData[this.table1CurShowIndex].isShow = true
      this.PMData[this.table1CurShowIndex].isHighlight = true
      this.PMData[this.table1PreShowIndex].isShow = false
      this.PMData[this.table1PreShowIndex].isHighlight = false
      this.currentShowUserisEva = this.PMData[this.table1CurShowIndex].evaStatus === 1
      this.table1PreShowIndex = index
      this.buildBoutiqueProject = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
      })
      this.buildProTeam = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
      })
      this.nextPlan = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      })
      this.curAdvice = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
      })
      // ***********************获取当月月总结中的下月计划***********************
      let conclusionYear = moment(this.title).year()
      let conclusionMonth = moment(this.title).month() + 1
      getCurMonthConclusionOverviewDataNewV3(conclusionYear, conclusionMonth, row.id).then(curMonthNextPlanData => {
        if (curMonthNextPlanData && curMonthNextPlanData.length > 0) {
          this.curMonthNextPlan = curMonthNextPlanData[0]
        } else {
          this.curMonthNextPlan = { content: '无数据' }
        }
      }).catch(() => {
        this.curMonthNextPlan = { content: '无数据' }
      })
      // ==========================================设置评价星级===============================================
      if (row.evaStatus === 1) {
        this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.buildBoutiqueProject.id
        })))
        this.buildProTeamStar = JSON.parse(JSON.stringify(row.conclusionEva.find(evaItem => {
          return evaItem.dimensionID === this.buildProTeam.id
        })))
      } else {
        if (store.state.userInfo.duty === 1) {
          if (this.PMData[this.table1CurShowIndex].conclusionEva.length !== 0) {
            this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(this.PMData[this.table1CurShowIndex].conclusionEva.find(evaItem => {
              return evaItem.dimension === 1
            })))
            this.buildProTeamStar = JSON.parse(JSON.stringify(this.PMData[this.table1CurShowIndex].conclusionEva.find(evaItem => {
              return evaItem.dimension === 2
            })))
          } else {
            this.buildBoutiqueProjectStar.evaStar = this.PMData[this.table1CurShowIndex].AMD1MGEvaStarV === store.state.userInfo.defaultStar
                                                    ? this.buildBoutiqueProjectStar.evaStar : this.PMData[this.table1CurShowIndex].AMD1MGEvaStarV
            this.buildProTeamStar.evaStar = this.PMData[this.table1CurShowIndex].AMD1MGEvaStarV === store.state.userInfo.defaultStar
                                            ? this.buildProTeamStar.evaStar : this.PMData[this.table1CurShowIndex].AMD2MGEvaStarV
          }
        } else {
          this.buildBoutiqueProjectStar = {
            evaStar: store.state.defaultStar
          }
          this.buildProTeamStar = {
            evaStar: store.state.defaultStar
          }
        }
      }
      // 显示组员平均评价星级和组长评价星级
      this.dimension1CSAveStar = this.PMData[this.table1CurShowIndex].AMD1CSEvaAveStar != null ? Number(this.PMData[this.table1CurShowIndex].AMD1CSEvaAveStar.toFixed(2)) : 0
      this.dimension1GPEvaStar = this.PMData[this.table1CurShowIndex].AMD1GPEvaStar != null ? Number(this.PMData[this.table1CurShowIndex].AMD1GPEvaStar.toFixed(2)) : 0
      this.dimension2CSAveStar = this.PMData[this.table1CurShowIndex].AMD2CSEvaAveStar != null ? Number(this.PMData[this.table1CurShowIndex].AMD2CSEvaAveStar.toFixed(2)) : 0
      this.dimension2GPEvaStar = this.PMData[this.table1CurShowIndex].AMD2GPEvaStar != null ? Number(this.PMData[this.table1CurShowIndex].AMD2GPEvaStar.toFixed(2)) : 0
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
    },

    // **********************点击显示V2**********************
    table1HandleShowV2 (row, index) {
      this.tableData1 = []
      this.tableData2 = []
      this.tableData3 = []
      this.teamWorkData = []
      this.showThisMonthPlan = true
      this.isShowTeamWorkTable = moment(this.title).isAfter(store.state.newRulesTeamWork) && row.duty === 2
      // ***如果是经理，将显示的绩效数据设置为初始状态
      if (store.state.userInfo.duty === 1) {
        this.PMData = JSON.parse(JSON.stringify(this.initPMData))
      }
      this.curEvaUserName = row.name
      this.table1CurShowIndex = index
      this.PMData[this.table1CurShowIndex].isShow = true
      this.PMData[this.table1CurShowIndex].isHighlight = true
      if (this.table1PreShowIndex !== -1) {
        this.PMData[this.table1PreShowIndex].isShow = false
        this.PMData[this.table1PreShowIndex].isHighlight = false
      }
      this.currentShowUserisEva = this.PMData[this.table1CurShowIndex].evaStatus === 1
      this.table1PreShowIndex = index

      // ***寻找打造精品工程/月度总结的内容
      let obj = {
        evaClass: '',
        dimension1V2Content: null
      }
      if (this.isMergedConclusion) {
        let findResult = row.conclusionContent.find(contenItem => {
          return contenItem.dimension === 1
        })
        if (!isUndefined(findResult)) {
          this.dimension1IDV2 = findResult.id
          obj.dimension1V2Content = findResult.content
          obj.evaClass = '月度总结'
        }
        this.tableData1.push(JSON.parse(JSON.stringify(obj)))
      } else {
        let findResult = row.conclusionContent.find(contenItem => {
          return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
        })
        if (!isUndefined(findResult)) {
          this.dimension1IDV2 = findResult.id
          obj.dimension1V2Content = findResult.content
        }
        obj.evaClass = '打造精品工程'
        this.tableData1.push(JSON.parse(JSON.stringify(obj)))
        // ***寻找创建专业团队维度的内容
        findResult = row.conclusionContent.find(contenItem => {
          return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
        })
        if (!isUndefined(findResult)) {
          obj.dimension1V2Content = findResult.content
        }
        obj.evaClass = '创建专业团队'
        this.tableData1.push(JSON.parse(JSON.stringify(obj)))
      }
      // ***寻找下月计划维度的内容
      let findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      })
      if (!isUndefined(findResult)) {
        this.dimension2IDV2 = findResult.id
        obj.dimension2V2Content = findResult.content
      }
      this.tableData2.push(JSON.parse(JSON.stringify(obj)))
      // ***查找小组工作的评价内容
      findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNewGP.teamWork.dimension
      })
      if (!isUndefined(findResult)) {
        this.dimension4IDV2 = findResult.id
        obj.dimension4V2Content = findResult.content
        this.teamWorkData.push(JSON.parse(JSON.stringify(obj)))
      }

      // ***设置评价星级
      if (row.evaStatus === 1) {
        // **查找对评价维度1的评价数据
        findResult = row.conclusionEva.find(evaItem => {
          return evaItem.dimensionID === this.dimension1IDV2
        })
        this.dimension1V2Star = findResult.evaStar
        this.dimenision1EvaIDV2 = findResult.id
        // **查找对评价维度4的评价数据
        findResult = row.conclusionEva.find(evaItem => {
          return evaItem.dimensionID === this.dimension4IDV2
        })
        if (!isUndefined(findResult)) {
          this.dimension4V2Star = findResult.evaStar
          this.dimenision4EvaIDV2 = findResult.id
        }
      } else { // ************如果当前用户还未评价，管理者显示虚拟构建的评价星级，普通员工显示默认评价星级********
        if (store.state.userInfo.duty === 1) {
          this.dimension1V2Star = row.AMD1MGEvaStarV
          this.dimension2V2Star = row.AMD2MGEvaStarV
          this.dimension4V2Star = store.state.defaultStar
        } else {
          this.dimension1V2Star = store.state.defaultStar
          this.dimension2V2Star = store.state.defaultStar
        }
      }
      // ***显示组员平均评价星级和组长评价星级
      if (store.state.userInfo.duty === 1) {
        this.dimension1CSAveStar = this.PMData[index].AMD1CSEvaAveStar != null ? Number(this.PMData[index].AMD1CSEvaAveStar.toFixed(2)) : 0
        this.dimension1GPEvaStar = this.PMData[index].AMD1GPEvaStar != null ? Number(this.PMData[index].AMD1GPEvaStar.toFixed(2)) : 0
        this.dimension2CSAveStar = this.PMData[index].AMD2CSEvaAveStar != null ? Number(this.PMData[index].AMD2CSEvaAveStar.toFixed(2)) : 0
        this.dimension2GPEvaStar = this.PMData[index].AMD2GPEvaStar != null ? Number(this.PMData[index].AMD2GPEvaStar.toFixed(2)) : 0
      }
      // ***********************获取当月月总结中的下月计划***********************
      let conclusionYearV2 = moment(this.title).year()
      let conclusionMonthV2 = moment(this.title).month() + 1
      getCurMonthConclusionOverviewDataNewV3(conclusionYearV2, conclusionMonthV2, row.id).then(curMonthNextPlanData => {
        if (curMonthNextPlanData && curMonthNextPlanData.length > 0) {
          this.curMonthNextPlan = curMonthNextPlanData[0]
          if (this.isMergedConclusion) {
            this.dimension2IDV2 = curMonthNextPlanData[0].id
          }
        } else {
          this.curMonthNextPlan = { content: '无数据' }
        }
        // 在V3回调内完成下月计划星级显示，确保dimension2IDV2已正确赋值
        if (row.evaStatus === 1) {
          let evaFind2 = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension2IDV2
          })
          if (evaFind2) {
            this.dimension2V2Star = evaFind2.evaStar
            this.dimenision2EvaIDV2 = evaFind2.id
          }
        }
      }).catch(() => {
        this.curMonthNextPlan = { content: '无数据' }
      })

      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
    },

    // 打造精品工程星级变化(维度1)
    handlebuildBoutiqueProjectStarChange () {
      if (store.state.userInfo.duty === 1) {
        // =========================================更新处经理评价数据=========================================
        let curEvaUserID = this.PMData[this.table1CurShowIndex].id
        let findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
        })
        // 如果处经理已经评价
        if (typeof (findResult) !== 'undefined') {
          findResult.evaStar = this.buildBoutiqueProjectStar.evaStar
        }
        this.PMData = genAMEvaScoreData(this.PMData,
                                  this.evaCoefObj.AMBuildBoutiqueProjectCoef, this.evaCoefObj.AMBuildProTeamCoef,
                                  this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                  this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                  this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData)
        this.PMData = genPerformanceScore(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
        this.table1CurShowIndex = this.PMData.findIndex(item => { return item.id === curEvaUserID })
        for (let initPMDataItem of this.initPMData) {
          let PMdataFindResult = this.PMData.find(PMDataItem => {
            return PMDataItem.id === initPMDataItem.id
          })
          PMdataFindResult.PMRankChange = PMdataFindResult.PMRank - initPMDataItem.PMRank
        }
      }
    },

    // 创建专业团队评价星级变化（维度2）
    handlebuildProTeamStarChange () {
      if (store.state.userInfo.duty === 1) {
        let curEvaUserID = this.PMData[this.table1CurShowIndex].id
        let findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 2 && item.evaUserID === store.state.userInfo.id
        })
        if (typeof (findResult) !== 'undefined') {
          findResult.evaStar = this.buildProTeamStar.evaStar
        }
        this.PMData = genAMEvaScoreData(this.PMData,
                                  this.evaCoefObj.AMBuildBoutiqueProjectCoef, this.evaCoefObj.AMBuildProTeamCoef,
                                  this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                  this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                  this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData)
        this.PMData = genPerformanceScore(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
        this.table1CurShowIndex = this.PMData.findIndex(item => { return item.id === curEvaUserID })
        for (let initPMDataItem of this.initPMData) {
          let PMdataFindResult = this.PMData.find(PMDataItem => {
            return PMDataItem.id === initPMDataItem.id
          })
          PMdataFindResult.PMRankChange = PMdataFindResult.PMRank - initPMDataItem.PMRank
        }
      }
    },

    // *****************维度1星级变化v2*****************
    handleD1StarChangeV2 () {
      if (store.state.userInfo.duty === 1) {
        this.isRateChange = true
        // ***更新处经理评价数据对评价维度1的评价数据
        let curEvaUserID = this.PMData[this.table1CurShowIndex].id
        let findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
        })
        // ***如果处经理已经评价，则更新相应的评价
        if (!isUndefined(findResult)) {
          findResult.evaStar = this.dimension1V2Star
        }
        this.PMData = genAMEvaScoreDataV2(this.PMData,
                                  this.evaCoefObj.AMDimension1CoefV2, this.evaCoefObj.AMDimension2CoefV2,
                                  this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                  this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                  this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData)
        // ***根据当前时间，选择计算绩效数据的版本
        // ***moment(this.title).isAfter(store.state.newRulesTeamWork)
        if (moment(this.title).isAfter(store.state.newRulesTeamWork)) {
          if (moment(this.title).isAfter(store.state.newRulesPBScore)) {
            this.PMData = genPerformanceScoreV3(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
          } else {
            this.PMData = genPerformanceScoreV2(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
          }
        } else {
          this.PMData = genPerformanceScore(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
        }
        this.table1CurShowIndex = this.PMData.findIndex(item => { return item.id === curEvaUserID })
        this.table1PreShowIndex = this.table1CurShowIndex
        for (let initPMDataItem of this.initPMData) {
          let PMdataFindResult = this.PMData.find(PMDataItem => {
            return PMDataItem.id === initPMDataItem.id
          })
          PMdataFindResult.PMRankChange = PMdataFindResult.PMRank - initPMDataItem.PMRank
        }
      }
    },

    // *****************维度2星级变化*****************
    handleD2StarChangeV2 () {
      if (store.state.userInfo.duty === 1) {
        this.isRateChange = true
        let curEvaUserID = this.PMData[this.table1CurShowIndex].id
        let findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 3 && item.evaUserID === store.state.userInfo.id
        })
        if (typeof (findResult) !== 'undefined') {
          findResult.evaStar = this.dimension2V2Star
        }
        this.PMData = genAMEvaScoreDataV2(this.PMData,
                                  this.evaCoefObj.AMDimension1CoefV2, this.evaCoefObj.AMDimension2CoefV2,
                                  this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                  this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                  this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData)
        // ***根据当前时间，选择计算绩效数据的版本
        // ***moment(this.title).isAfter(store.state.newRulesTeamWork)
        if (moment(this.title).isAfter(store.state.newRulesTeamWork)) {
          if (moment(this.title).isAfter(store.state.newRulesPBScore)) {
            this.PMData = genPerformanceScoreV3(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
          } else {
            this.PMData = genPerformanceScoreV2(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
          }
        } else {
          this.PMData = genPerformanceScore(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
        }
        this.table1CurShowIndex = this.PMData.findIndex(item => { return item.id === curEvaUserID })
        for (let initPMDataItem of this.initPMData) {
          let PMdataFindResult = this.PMData.find(PMDataItem => {
            return PMDataItem.id === initPMDataItem.id
          })
          PMdataFindResult.PMRankChange = PMdataFindResult.PMRank - initPMDataItem.PMRank
        }
      }
    },

    // *****************维度4星级变化v2*****************
    handleD4StarChangeV2 () {
      this.isRateChange = true
      // ***更新处经理评价数据
      let curEvaUserID = this.PMData[this.table1CurShowIndex].id
      let findResult = this.PMData[this.table1CurShowIndex].teamWorkEvaedData.find(item => {
        return item.dimension === 5 && item.evaUserID === store.state.userInfo.id
      })
      // 如果处经理已经评价
      if (typeof (findResult) !== 'undefined') {
        findResult.evaStar = this.dimension4V2Star
      }

      this.genTeamWorkEvaData(this.PMData)
      // ***根据当前时间，选择计算绩效数据的版本
      // ***moment(this.title).isAfter(store.state.newRulesTeamWork)
      if (moment(this.title).isAfter(store.state.newRulesTeamWork)) {
        if (moment(this.title).isAfter(store.state.newRulesPBScore)) {
          this.PMData = genPerformanceScoreV3(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
        } else {
          this.PMData = genPerformanceScoreV2(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
        }
      } else {
        this.PMData = genPerformanceScore(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
      }
      this.table1CurShowIndex = this.PMData.findIndex(item => { return item.id === curEvaUserID })
      this.table1PreShowIndex = this.table1CurShowIndex
      for (let initPMDataItem of this.initPMData) {
        let PMdataFindResult = this.PMData.find(PMDataItem => {
          return PMDataItem.id === initPMDataItem.id
        })
        PMdataFindResult.PMRankChange = PMdataFindResult.PMRank - initPMDataItem.PMRank
      }
    },

    // *****************点击提交对当前用户的评价并跳转到下一个待评价人
    handleSubmitAndJumpToNext () {
      this.submitEvaDataFlag = false
      let promises = []
      let count = 0
      promises[count++] = submitAMEvaData(store.state.userInfo.id, this.buildBoutiqueProject.id, this.buildBoutiqueProjectStar.evaStar)
      promises[count++] = submitAMEvaData(store.state.userInfo.id, this.buildProTeam.id, this.buildProTeamStar.evaStar)
      Promise.all(promises).then((allResponse) => {
        this.PMData[this.table1CurShowIndex].evaStatus = 1
        this.PMData[this.table1CurShowIndex].isShow = false
        this.PMData[this.table1CurShowIndex].isHighlight = false
        // 如果是经理，删除虚拟构建的评价星级
        if (store.state.userInfo.duty === 1) {
          this.PMData[this.table1CurShowIndex].conclusionEva = []
          for (let PMDataItem of this.PMData) {
            PMDataItem.PMRankChange = 0
          }
        }
        // ===================================构建并插入评价详情进conclusionEva================================
        let obj = {
          id: allResponse[0].insertId,
          evaStar: this.buildBoutiqueProjectStar.evaStar,
          dimensionID: this.buildBoutiqueProject.id,
          name: store.state.userInfo.name
        }
        this.PMData[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
        let findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
        })
        if (typeof (findResult) !== 'undefined') {
          findResult.evaStar = this.buildBoutiqueProjectStar.evaStar
        } else {
          // ====================================构建评价维度1的处经理虚拟评价进allAMEvaedData=========================
          let obj = {
            evaUserID: store.state.userInfo.id,
            evaStar: this.buildBoutiqueProjectStar.evaStar,
            evaUserDuty: store.state.userInfo.duty,
            dimension: 1,
            evaUserGroupID: store.state.userInfo.groupID
          }
          // 把构建的处经理虚拟评价插入表格数据中
          this.PMData[this.table1CurShowIndex].allAMEvaedData.push(JSON.parse(JSON.stringify(obj)))
        }
        // ====================================构建并插入评价维度2的评价详情进conclusionEva========================================
        obj.id = allResponse[1].insertId
        obj.evaStar = this.buildProTeamStar.evaStar
        obj.dimensionID = this.buildProTeam.id
        this.PMData[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))

        findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 2 && item.evaUserID === store.state.userInfo.id
        })
        if (typeof (findResult) !== 'undefined') {
          findResult.evaStar = this.buildProTeamStar.evaStar
        } else {
          // ========================================构建评价维度2的处经理虚拟评价进allAMEvaedData===========================
          let obj = {
            evaUserID: store.state.userInfo.id,
            evaStar: this.buildBoutiqueProjectStar.evaStar,
            evaUserDuty: store.state.userInfo.duty,
            dimension: 2,
            evaUserGroupID: store.state.userInfo.groupID
          }
          // 把构建的处经理虚拟评价插入表格数据中
          this.PMData[this.table1CurShowIndex].allAMEvaedData.push(JSON.parse(JSON.stringify(obj)))
        }
        // 重置初始绩效数据为已提交的数据
        this.initPMData = JSON.parse(JSON.stringify(this.PMData))

        Notification.success({
          title: '成功',
          message: '提交成功'
        })
        // 重置默认评价星级
        this.buildBoutiqueProjectStar.evaStar = store.state.defaultStar
        this.buildProTeamStar.evaStar = store.state.defaultStar
        // ================================================跳转到下一个未评价的用户===========================================
        let index = this.PMData.findIndex(PMdataItem => {
          return PMdataItem.evaStatus === 0 && PMdataItem.submitStatus === 1
        })
        if (index !== -1) { // 还有未评价且月总结已经提交的用户
          this.curEvaUserName = this.PMData[index].name
          this.table1CurShowIndex = index
          this.PMData[this.table1CurShowIndex].isShow = true
          this.PMData[this.table1CurShowIndex].isHighlight = true
          this.table1PreShowIndex = index
          this.buildBoutiqueProject = this.PMData[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
          })
          this.buildProTeam = this.PMData[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
          })
          this.nextPlan = this.PMData[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
          })
          this.curAdvice = this.PMData[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
          })
          this.buildBoutiqueProjectStar = {
            evaStar: store.state.defaultStar
          }
          this.buildProTeamStar = {
            evaStar: store.state.defaultStar
          }
          if (store.state.userInfo.duty === 1) {
            this.buildBoutiqueProjectStar.evaStar = this.PMData[this.table1CurShowIndex].AMD1MGEvaStarV === store.state.userInfo.defaultStar
                                                    ? this.buildBoutiqueProjectStar.evaStar : this.PMData[this.table1CurShowIndex].AMD1MGEvaStarV
            this.buildProTeamStar.evaStar = this.PMData[this.table1CurShowIndex].AMD1MGEvaStarV === store.state.userInfo.defaultStar
                                            ? this.buildProTeamStar.evaStar : this.PMData[this.table1CurShowIndex].AMD2MGEvaStarV
            // 显示组员平均评价星级和组长评价星级
            this.dimension1CSAveStar = this.PMData[this.table1CurShowIndex].AMD1CSEvaAveStar != null ? Number(this.PMData[this.table1CurShowIndex].AMD1CSEvaAveStar.toFixed(2)) : 0
            this.dimension1GPEvaStar = this.PMData[this.table1CurShowIndex].AMD1GPEvaStar != null ? Number(this.PMData[this.table1CurShowIndex].AMD1GPEvaStar.toFixed(2)) : 0
            this.dimension2CSAveStar = this.PMData[this.table1CurShowIndex].AMD2CSEvaAveStar != null ? Number(this.PMData[this.table1CurShowIndex].AMD2CSEvaAveStar.toFixed(2)) : 0
            this.dimension2GPEvaStar = this.PMData[this.table1CurShowIndex].AMD2GPEvaStar != null ? Number(this.PMData[this.table1CurShowIndex].AMD2GPEvaStar.toFixed(2)) : 0
          }
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
        } else { // 都已评价
          this.currentShowUserisEva = true
          Notification.info({
            title: '成功',
            message: '已全部评价完成'
          })

          // 显示组员平均评价星级和组长评价星级
          this.dimension1CSAveStar = 0
          this.dimension1GPEvaStar = 0
          this.dimension2CSAveStar = 0
          this.dimension2GPEvaStar = 0
        }

        this.submitEvaDataFlag = true
        this.forceRefresh = false
        this.$nextTick(() => {
          this.forceRefresh = true
        })
      }).catch(err => {
        Notification.error({
          title: '失败',
          message: '提交失败'
        })
        this.submitEvaDataFlag = true
        this.forceRefresh = false
        this.$nextTick(() => {
          this.forceRefresh = true
        })
        console.log(err)
      })
    },

    // ************点击提交对当前用户的评价并跳转到下一个待评价人v2************
    handleSubmitAndJumpToNextV2 () {
      this.isRateChange = false
      this.submitEvaDataFlag = false
      if (!this.AMEvaDeadline) {
        let submitPromises = []
        let count = 0
        let submitDimension1 = submitAMEvaData(store.state.userInfo.id, this.dimension1IDV2, this.dimension1V2Star)
        let submitDimension2 = submitAMEvaData(store.state.userInfo.id, this.dimension2IDV2, this.dimension2V2Star)
        submitPromises.push({ promise: submitDimension1, dimension: 1, dimensionID: this.dimension1IDV2, star: this.dimension1V2Star })
        submitPromises.push({ promise: submitDimension2, dimension: 2, dimensionID: this.dimension2IDV2, star: this.dimension2V2Star })
        if (store.state.userInfo.duty === 1 && this.isShowTeamWorkTable) {
          let submitDimension4 = submitAMEvaData(store.state.userInfo.id, this.dimension4IDV2, this.dimension4V2Star)
          submitPromises.push({ promise: submitDimension4, dimension: 4, dimensionID: this.dimension4IDV2, star: this.dimension4V2Star })
        }
        Promise.allSettled(submitPromises.map(item => item.promise)).then((results) => {
          let successCount = 0
          let failedDimensions = []
          let successResults = []
          results.forEach((result, index) => {
            if (result.status === 'fulfilled') {
              successCount++
              successResults.push({ index: index, data: result.value, dimension: submitPromises[index].dimension })
            } else {
              failedDimensions.push({
                dimension: submitPromises[index].dimension,
                dimensionID: submitPromises[index].dimensionID,
                star: submitPromises[index].star,
                error: result.reason
              })
            }
          })
          if (failedDimensions.length > 0) {
            if (successCount > 0) {
              Notification.warning({
                title: '部分提交失败',
                message: `有 ${failedDimensions.length} 个维度提交失败，已成功 ${successCount} 个维度。失败维度数据已保留，请稍后重试。`
              })
            }
            let currentRow = this.PMData[this.table1CurShowIndex]
            let conclusionYear = moment(this.title).year()
            let conclusionMonth = moment(this.title).month() + 1
            failedDimensions.forEach(item => {
              item.evaUserID = store.state.userInfo.id
              item.evaUserName = store.state.userInfo.name
              item.evaedUserID = currentRow.id
              item.evaedUserName = currentRow.name
              item.dimensionName = this.getDimensionName(item.dimension)
              item.evaStar = item.star
              item.conclusionYear = conclusionYear
              item.conclusionMonth = conclusionMonth
              item.errorCode = item.error && item.error.code ? item.error.code : -1
              item.errorMessage = item.error && item.error.message ? item.error.message : '未知错误'
            })
            this.failedEvaData = failedDimensions
            this.saveFailedEvaDataToBackend(failedDimensions)
            return
          }
          this.PMData[this.table1CurShowIndex].evaStatus = 1
          this.PMData[this.table1CurShowIndex].isShow = false
          this.PMData[this.table1CurShowIndex].isHighlight = false
          // ************如果是经理，删除虚拟构建的评价星级
          if (store.state.userInfo.duty === 1) {
            this.PMData[this.table1CurShowIndex].conclusionEva = []
            for (let PMDataItem of this.PMData) {
              PMDataItem.PMRankChange = 0
            }
          }
          // ************构建并插入评价维度1详情进conclusionEva************
          let obj = {
            id: successResults[0].data.insertId,
            evaStar: this.dimension1V2Star,
            dimensionID: this.dimension1IDV2,
            name: store.state.userInfo.name
          }
          this.PMData[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
          // ************更新维度1评价数据************
          let findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
            return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
          })
          if (typeof (findResult) !== 'undefined') {
            findResult.evaStar = this.dimension1V2Star
          } else {
            // ************构建评价维度1的评价进allAMEvaedData************
            let obj = {
              evaUserID: store.state.userInfo.id,
              evaStar: this.dimension1V2Star,
              evaUserDuty: store.state.userInfo.duty,
              dimension: 1,
              evaUserGroupID: store.state.userInfo.groupID
            }
            this.PMData[this.table1CurShowIndex].allAMEvaedData.push(JSON.parse(JSON.stringify(obj)))
          }
          // ************构建并插入评价维度2的评价详情进conclusionEva************
          obj.id = successResults[1].data.insertId
          obj.evaStar = this.dimension2V2Star
          obj.dimensionID = this.dimension2IDV2
          this.PMData[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
          // ************更新维度2评价数据************
          findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
            return item.dimension === 3 && item.evaUserID === store.state.userInfo.id
          })
          if (typeof (findResult) !== 'undefined') {
            findResult.evaStar = this.dimension2V2Star
          } else {
            // ************构建评价维度2的处经理虚拟评价进allAMEvaedData************
            let obj = {
              evaUserID: store.state.userInfo.id,
              evaStar: this.dimension2V2Star,
              evaUserDuty: store.state.userInfo.duty,
              dimension: 3,
              evaUserGroupID: store.state.userInfo.groupID
            }
            this.PMData[this.table1CurShowIndex].allAMEvaedData.push(JSON.parse(JSON.stringify(obj)))
          }
          // ************构建并插入评价维度4的评价详情进conclusionEva************
          if (store.state.userInfo.duty === 1 && this.isShowTeamWorkTable) {
            obj.id = successResults[2].data.insertId
            obj.evaStar = this.dimension4V2Star
            obj.dimensionID = this.dimension4IDV2
            this.PMData[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
            // ************更新维度4评价数据************
            findResult = this.PMData[this.table1CurShowIndex].teamWorkEvaedData.find(item => {
              return item.dimension === 5 && item.evaUserID === store.state.userInfo.id
            })
            if (typeof (findResult) !== 'undefined') {
              findResult.evaStar = this.dimension4V2Star
            } else {
              // ************构建评价维度4的处经理虚拟评价进allAMEvaedData************
              let obj = {
                evaUserID: store.state.userInfo.id,
                evaStar: this.dimension4V2Star,
                evaUserDuty: store.state.userInfo.duty,
                dimension: 5,
                evaUserGroupID: store.state.userInfo.groupID
              }
              this.PMData[this.table1CurShowIndex].allAMEvaedData.push(JSON.parse(JSON.stringify(obj)))
            }
          }

          // ***重置初始绩效数据为已提交的数据
          this.initPMData = JSON.parse(JSON.stringify(this.PMData))
          for (let item of this.initPMData) {
            item.isShow = false
            item.isHighlight = false
          }

          Notification.success({
            title: '成功',
            message: '提交成功'
          })
          // ***重置默认评价星级
          this.dimension2V1Star = store.state.defaultStar
          this.dimension2V2Star = store.state.defaultStar
          this.dimension4V2Star = store.state.defaultStar

          // ************跳转到下一个未评价的用户************
          let index = this.PMData.findIndex(PMdataItem => {
            return PMdataItem.evaStatus === 0 && PMdataItem.submitStatus === 1
          })
          if (index !== -1) { // **还有未评价且月总结已经提交的用户
            if (store.state.userInfo.duty !== 1) {
              this.showConclusionDataCS(this.PMData[index], index)
            } else {
              this.showConclusionDataMG(this.PMData[index], index)
            }
            this.forceRefresh = false
            this.$nextTick(() => {
              this.forceRefresh = true
            })
          } else { // **都已评价
            this.tableData1 = []
            this.tableData2 = []
            this.tableData3 = []
            this.teamWorkData = []
            this.showThisMonthPlan = true
            this.currentShowUserisEva = true
            this.table1PreShowIndex = -1
            Notification.info({
              title: '成功',
              message: '已全部评价完成'
            })
            // ***显示组员平均评价星级和组长评价星级
            this.dimension1CSAveStar = 0
            this.dimension1GPEvaStar = 0
            this.dimension2CSAveStar = 0
            this.dimension2GPEvaStar = 0

            if (store.state.userInfo.duty !== 1) {
              let isEvaAll = true
              for (let item of this.PMData) {
                if (item.conclusionEva.length === 0) {
                  isEvaAll = false
                }
              }
              if (isEvaAll) {
                let year = moment(this.title).year()
                let month = moment(this.title).month() + 1
                // ***如果在截止日期前完成所有人评价提交，则自动提交一条奖励工时
                getGlobalFlagByTime(year, month, ['AMEvaDeadline']).then(res => {
                  if (res.length === 0) {
                    mianshenheWorkTimeSubmit(store.state.userInfo.id, 550, this.title).then(() => {}).catch(err => { console.log(err) })
                  } else if (res[0].flagValue !== 1) {
                    mianshenheWorkTimeSubmit(store.state.userInfo.id, 550, this.title).then(() => {}).catch(err => { console.log(err) })
                  }
                })
              }
            }
          }

          this.submitEvaDataFlag = true
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
        }).catch(err => {
          Notification.error({
            title: '失败',
            message: '提交失败'
          })
          this.submitEvaDataFlag = true
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
          console.log(err)
        })
      } else {
        this.submitEvaDataFlag = true
        Notification.error({
          title: '失败',
          message: '成效评价提交已截止'
        })
      }
    },

    // ************重试提交失败的成效评价************
    handleRetryFailedEva () {
      if (this.failedEvaData.length === 0) {
        Notification.info({
          title: '提示',
          message: '没有需要重试的评价数据'
        })
        return
      }
      if (this.AMEvaDeadline) {
        Notification.error({
          title: '失败',
          message: '成效评价提交已截止'
        })
        return
      }
      let retryPromises = []
      this.failedEvaData.forEach(item => {
        retryPromises.push({
          promise: submitAMEvaData(store.state.userInfo.id, item.dimensionID, item.star),
          dimension: item.dimension,
          dimensionID: item.dimensionID,
          star: item.star
        })
      })
      Promise.allSettled(retryPromises.map(item => item.promise)).then((results) => {
        let stillFailedDimensions = []
        results.forEach((result, index) => {
          if (result.status === 'rejected') {
            stillFailedDimensions.push({
              dimension: retryPromises[index].dimension,
              dimensionID: retryPromises[index].dimensionID,
              star: retryPromises[index].star,
              evaStar: retryPromises[index].star,
              evaUserID: this.failedEvaData[index].evaUserID,
              evaUserName: this.failedEvaData[index].evaUserName,
              evaedUserID: this.failedEvaData[index].evaedUserID,
              evaedUserName: this.failedEvaData[index].evaedUserName,
              dimensionName: this.failedEvaData[index].dimensionName,
              conclusionYear: this.failedEvaData[index].conclusionYear,
              conclusionMonth: this.failedEvaData[index].conclusionMonth,
              errorCode: result.reason && result.reason.code ? result.reason.code : -1,
              errorMessage: result.reason && result.reason.message ? result.reason.message : '未知错误'
            })
          }
        })
        if (stillFailedDimensions.length > 0) {
          this.failedEvaData = stillFailedDimensions
          this.saveFailedEvaDataToBackend(stillFailedDimensions)
          Notification.error({
            title: '重试失败',
            message: `有 ${stillFailedDimensions.length} 个维度重试仍然失败，请稍后再试`
          })
        } else {
          let successPromises = []
          this.failedEvaData.forEach(item => {
            successPromises.push(updateFailedAMEvaRetrySuccess(item.evaUserID, item.dimensionID))
          })
          Promise.all(successPromises).then(() => {
            this.failedEvaData = []
            Notification.success({
              title: '成功',
              message: '所有失败的评价数据重试成功，页面将自动刷新'
            })
            this.refreshAMEvaPage()
          }).catch(() => {
            this.failedEvaData = []
            Notification.success({
              title: '成功',
              message: '所有失败的评价数据重试成功，页面将自动刷新'
            })
            this.refreshAMEvaPage()
          })
        }
      })
    },

    // ************保存失败的评价数据到后端（使用INSERT ON DUPLICATE KEY UPDATE）************
    saveFailedEvaDataToBackend (failedData) {
      failedData.forEach(item => {
        addFailedAMEvaData(item).then(() => {
        }).catch(err => {
          console.error('保存失败数据到后端失败:', err)
        })
      })
    },

    // ************从后端加载失败的评价数据************
    loadFailedEvaDataFromBackend () {
      let conclusionYear = moment(this.title).year()
      let conclusionMonth = moment(this.title).month() + 1
      getFailedAMEvaData(store.state.userInfo.id, conclusionYear, conclusionMonth).then(result => {
        if (result && result.length > 0) {
          result.forEach(item => {
            item.star = item.evaStar
          })
          this.failedEvaData = result
        } else {
          this.failedEvaData = []
        }
      }).catch(() => {
        this.failedEvaData = []
      })
    },

    // ************清除后端失败的评价数据************
    clearFailedEvaDataFromBackend () {
      let conclusionYear = moment(this.title).year()
      let conclusionMonth = moment(this.title).month() + 1
      clearFailedAMEvaData(store.state.userInfo.id, conclusionYear, conclusionMonth).then(() => {
      }).catch(err => {
        console.error('清除后端失败数据失败:', err)
      })
    },

    // ************根据dimension值获取维度名称************
    getDimensionName (dimension) {
      if (this.isMergedConclusion) {
        switch (dimension) {
          case 1: return '月度总结'
          case 2:
          case 3:
            return '下月计划'
          case 4:
            return '对处室的建议'
          case 5:
            return '小组工作总结'
          default:
            return '未知维度'
        }
      } else {
        switch (dimension) {
          case 1:
            return '打造精品工程&创建专业团队'
          case 2:
            return '打造精品工程&创建专业团队'
          case 3:
            return '工作计划'
          case 4:
            return '对处室的建议'
          case 5:
            return '小组工作总结'
          default:
            return '未知维度'
        }
      }
    },

    // ************刷新成效评价页面数据************
    refreshAMEvaPage () {
      this.tableData1 = []
      this.tableData2 = []
      this.tableData3 = []
      this.teamWorkData = []
      this.showThisMonthPlan = true
      this.PMData = []
      this.initPMData = []
      this.currentShowUserisEva = true
      this.table1PreShowIndex = -1
      this.table1CurShowIndex = -1
      this.dimension1CSAveStar = 0
      this.dimension1GPEvaStar = 0
      this.dimension2CSAveStar = 0
      this.dimension2GPEvaStar = 0
      this.dimension4GPEvaStar = 0
      this.dimension1V2Star = store.state.defaultStar
      this.dimension2V2Star = store.state.defaultStar
      this.dimension4V2Star = store.state.defaultStar
      this.init()
    },

    // 点击更新对用户的评价
    handleUpdateEva () {
      this.updateEvaDataFlag = false
      let promises = []
      let count = 0
      promises[count++] = updateAMEvaData(this.buildBoutiqueProjectStar.id, this.buildBoutiqueProjectStar.evaStar)
      promises[count++] = updateAMEvaData(this.buildProTeamStar.id, this.buildProTeamStar.evaStar)
      Promise.all(promises).then(() => {
        // 把更新结果临时插入当前表格数据内
        let findEvaItem = this.PMData[this.table1CurShowIndex].conclusionEva.find(tableDataItem => {
          return tableDataItem.id === this.buildBoutiqueProjectStar.id
        })
        if (typeof (findEvaItem) !== 'undefined') {
          findEvaItem.evaStar = this.buildBoutiqueProjectStar.evaStar
        }
        findEvaItem = this.PMData[this.table1CurShowIndex].conclusionEva.find(tableDataItem => {
          return tableDataItem.id === this.buildProTeamStar.id
        })
        if (typeof (findEvaItem) !== 'undefined') {
          findEvaItem.evaStar = this.buildProTeamStar.evaStar
        }
        // 如果是经理，删除虚拟构建的评价星级
        if (store.state.userInfo.duty === 1) {
          for (let PMDataItem of this.PMData) {
            PMDataItem.PMRankChange = 0
          }
          this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
            return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
          }).evaStar = this.buildProTeamStar.evaStar
          this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
            return item.dimension === 2 && item.evaUserID === store.state.userInfo.id
          }).evaStar = this.buildProTeamStar.evaStar
          // 重置初始绩效数据为已提交的数据
          this.initPMData = JSON.parse(JSON.stringify(this.PMData))
        }
        Notification.success({
          title: '成功',
          message: '更新成功'
        })
        this.updateEvaDataFlag = true
        this.forceRefresh = false
        this.$nextTick(() => {
          this.forceRefresh = true
        })
      }).catch(err => {
        Notification.error({
          title: '失败',
          message: '更新失败'
        })
        this.updateEvaDataFlag = true
        console.log(err)
      })
    },
    // ******点击更新对用户的评价v2
    handleUpdateEvaV2 () {
      this.isRateChange = false
      this.updateEvaDataFlag = false
      let applyYear = moment(this.title).year()
      let applyMonth = moment(this.title).month() + 1
      getTypeGlobalFlag(applyYear, applyMonth, 'AMEvaDeadline').then(result => {
        if (!(result.length !== 0 && result[0].flagValue === 1) || (store.state.userInfo.duty !== 3)) {
          let promises = []
          let count = 0
          promises[count++] = updateAMEvaData(this.dimenision1EvaIDV2, this.dimension1V2Star)
          promises[count++] = updateAMEvaData(this.dimenision2EvaIDV2, this.dimension2V2Star)
          if (store.state.userInfo.duty === 1 && this.isShowTeamWorkTable) {
            promises[count++] = updateAMEvaData(this.dimenision4EvaIDV2, this.dimension4V2Star)
          }
          Promise.all(promises).then(() => {
            // ***把更新结果临时插入当前表格数据内
            let findEvaItem = this.PMData[this.table1CurShowIndex].conclusionEva.find(tableDataItem => { // **插入评价维度1
              return tableDataItem.dimensionID === this.dimension1IDV2
            })
            if (typeof (findEvaItem) !== 'undefined') {
              findEvaItem.evaStar = this.dimension1V2Star
            }
            findEvaItem = this.PMData[this.table1CurShowIndex].conclusionEva.find(tableDataItem => { // **插入评价维度2
              return tableDataItem.dimensionID === this.dimension2IDV2
            })
            if (typeof (findEvaItem) !== 'undefined') {
              findEvaItem.evaStar = this.dimension2V2Star
            }
            findEvaItem = this.PMData[this.table1CurShowIndex].conclusionEva.find(tableDataItem => { // **插入评价维度4
              return tableDataItem.dimensionID === this.dimension4IDV2
            })
            if (typeof (findEvaItem) !== 'undefined') {
              findEvaItem.evaStar = this.dimension4V2Star
            }
            // ***如果是经理，删除虚拟构建的评价星级
            if (store.state.userInfo.duty === 1) {
              for (let PMDataItem of this.PMData) {
                PMDataItem.PMRankChange = 0
              }
              this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
                return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
              }).evaStar = this.dimension1V2Star
              this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
                return item.dimension === 3 && item.evaUserID === store.state.userInfo.id
              }).evaStar = this.dimension2V2Star
              if (this.PMData[this.table1CurShowIndex].teamWorkEvaedData.length !== 0) {
                this.PMData[this.table1CurShowIndex].teamWorkEvaedData.find(item => {
                  return item.dimension === 5 && item.evaUserID === store.state.userInfo.id
                }).evaStar = this.dimension4V2Star
              }
              // 重置初始绩效数据为已提交的数据
              this.initPMData = JSON.parse(JSON.stringify(this.PMData))
              for (let item of this.initPMData) {
                item.isShow = false
                item.isHighlight = false
              }
            }
            Notification.success({
              title: '成功',
              message: '更新成功'
            })
            this.updateEvaDataFlag = true
            this.forceRefresh = false
            this.$nextTick(() => {
              this.forceRefresh = true
            })
          }).catch(err => {
            Notification.error({
              title: '失败',
              message: '更新失败'
            })
            this.updateEvaDataFlag = true
            console.log(err)
          })
        } else {
          this.submitEvaDataFlag = true
          Notification.error({
            title: '失败',
            message: '成效评价提交已截止'
          })
        }
      }).catch(err => {
        this.submitEvaDataFlag = true
        console.log(err)
      })
    },
    // 发布绩效信息
    handlePerformancePublish () {
      this.publistPMDataFlag = false
      // 判断按钮状态
      if (this.PMPublishStatus) { // 如果是发布绩效
        let promise = []
        let count = 0
        let publishID = this.PMPublishStatusData.length > 0 ? this.PMPublishStatusData[0].id : -1 // 判断该月绩效是否已经发布
        let applyYear = this.$moment(this.title).year()
        let applyMonth = this.$moment(this.title).month() + 1
        let flagValue = this.PMPublishStatus ? 1 : 0

        if (publishID === -1) { // 如果绩效数据内还没有相关数据，则插入绩效数据
          promise[count++] = savePMData(this.title, this.PMData)
        } else { // 数据库中有绩效数据
          for (let PMDataItem of this.PMData) {
            let findResult = this.publishedPMData.find(item => {
              return item.userID === PMDataItem.id
            })
            if (!isUndefined(findResult)) {
              PMDataItem.publishPMDataID = findResult.id
            }
          }
          promise[count++] = updatePMData(this.PMData)
        }
        promise[count++] = publishPMData(applyYear, applyMonth, publishID, flagValue) // 更新绩效发布标志位
        Promise.all(promise).then((allResponse) => {
          if (this.PMPublishStatusData.length === 0) {
            let obj = {
              id: allResponse[1].data.insertId,
              flagValue: flagValue,
              flagType: 'performanceInfoPublish'
            }
            this.PMPublishStatusData.push(obj)
          } else {
            this.PMPublishStatusData[0].flagValue = flagValue
          }
          Notification.success({
            title: '成功',
            message: '操作成功'
          })
          this.publistPMDataFlag = true
        }).catch(err => {
          console.log(err)
          Notification.error({
            title: '失败',
            message: '绩效数据上传失败'
          })
          this.publistPMDataFlag = true
        })
      } else { // 如果是取消发布绩效
        let publishID = this.PMPublishStatusData.length > 0 ? this.PMPublishStatusData[0].id : -1 // 判断该月绩效是否已经发布
        let applyYear = this.$moment(this.title).year()
        let applyMonth = this.$moment(this.title).month() + 1
        let flagValue = 0
        publishPMData(applyYear, applyMonth, publishID, flagValue).then(() => {
          this.publistPMDataFlag = true
          this.clearEvaTable()
          this.getDataLoading = false
          let conclusionYear = this.$moment(this.title).year()
          let conclusionMonth = this.$moment(this.title).month() + 1
          this.initData(conclusionYear, conclusionMonth, this.intelligentGroup, this.commuincationGroup, this.usersList)
          Notification.success({
            title: '成功',
            message: '操作成功'
          })
        }).catch(err => {
          console.log(err)
          Notification.error({
            title: '失败',
            message: '取消发布失败'
          })
          this.publistPMDataFlag = true
        })
      }
    },
    // ***发布绩效信息v2
    handlePerformancePublishV2 () {
      this.publistPMDataFlag = false
      // ***判断按钮状态
      if (this.PMPublishStatus) { // **如果是发布绩效
        let promise = []
        let count = 0
        let publishID = this.PMPublishStatusData.length > 0 ? this.PMPublishStatusData[0].id : -1 // 判断该月绩效是否已经发布
        let applyYear = this.$moment(this.title).year()
        let applyMonth = this.$moment(this.title).month() + 1
        let flagValue = 1

        if (publishID === -1) { // ***如果绩效数据内还没有相关数据，则插入绩效数据
          promise[count++] = savePMData(this.title, this.PMData)
        } else { // ***数据库中有绩效数据，则获取原绩效数据ID，给表格的绩效数据赋值
          for (let PMDataItem of this.PMData) {
            let findResult = this.publishedPMData.find(item => {
              return item.userID === PMDataItem.id
            })
            if (!isUndefined(findResult)) {
              PMDataItem.publishPMDataID = findResult.id
            }
          }
          promise[count++] = updatePMData(this.PMData)
        }
        promise[count++] = publishPMData(applyYear, applyMonth, publishID, flagValue) // 更新绩效发布标志位
        Promise.all(promise).then((allResponse) => {
          if (this.PMPublishStatusData.length === 0) {
            let obj = {
              id: allResponse[1].data.insertId,
              flagValue: flagValue,
              flagType: 'performanceInfoPublish'
            }
            this.PMPublishStatusData.push(obj)
          } else {
            this.PMPublishStatusData[0].flagValue = flagValue
          }
          Notification.success({
            title: '成功',
            message: '操作成功'
          })
          this.publistPMDataFlag = true
        }).catch(err => {
          console.log(err)
          Notification.error({
            title: '失败',
            message: '绩效数据上传失败'
          })
          this.publistPMDataFlag = true
        })
      } else { // ***如果是取消发布绩效
        let publishID = this.PMPublishStatusData.length > 0 ? this.PMPublishStatusData[0].id : -1 // 判断该月绩效是否已经发布
        let applyYear = this.$moment(this.title).year()
        let applyMonth = this.$moment(this.title).month() + 1
        let flagValue = 0
        publishPMData(applyYear, applyMonth, publishID, flagValue).then(() => {
          this.publistPMDataFlag = true
          this.clearEvaTable()
          this.getDataLoading = false
          // ***重新生成表格数据
          let conclusionYear = this.$moment(this.title).year()
          let conclusionMonth = this.$moment(this.title).month() + 1
          this.genTableDataV2(conclusionYear, conclusionMonth, this.intelligentGroup, this.commuincationGroup).then(tableData => {
            if (store.state.userInfo.duty !== 1) {
              this.initDataCSV2(tableData)
            } else {
              this.initDataMGV2(tableData, conclusionYear, conclusionMonth, this.usersList)
            }
          })
          Notification.success({
            title: '成功',
            message: '操作成功'
          })
        }).catch(err => {
          console.log(err)
          Notification.error({
            title: '失败',
            message: '取消发布失败'
          })
          this.publistPMDataFlag = true
        })
      }
    },
    // ***发布绩效信息v3，实行取消组长定量评价，改成小组工作评价后的版本
    handlePerformancePublishV3 () {
      this.publistPMDataFlag = false
      // ***判断按钮状态
      if (this.PMPublishStatus) { // **如果是发布绩效
        let promise = []
        let count = 0
        let publishID = this.PMPublishStatusData.length > 0 ? this.PMPublishStatusData[0].id : -1 // 判断该月绩效是否已经发布
        let applyYear = this.$moment(this.title).year()
        let applyMonth = this.$moment(this.title).month() + 1
        let flagValue = 1

        if (publishID === -1) { // ***如果绩效数据内还没有相关数据，则插入绩效数据
          promise[count++] = savePMDataV2(this.title, this.PMData)
        } else { // ***数据库中有绩效数据，则获取原绩效数据ID，给表格的绩效数据赋值
          for (let PMDataItem of this.PMData) {
            let findResult = this.publishedPMData.find(item => {
              return item.userID === PMDataItem.id
            })
            if (!isUndefined(findResult)) {
              PMDataItem.publishPMDataID = findResult.id
            }
          }
          promise[count++] = updatePMDataV2(this.PMData)
        }
        promise[count++] = publishPMData(applyYear, applyMonth, publishID, flagValue) // 更新绩效发布标志位
        Promise.all(promise).then((allResponse) => {
          if (this.PMPublishStatusData.length === 0) {
            let obj = {
              id: allResponse[1].data.insertId,
              flagValue: flagValue,
              flagType: 'performanceInfoPublish'
            }
            this.PMPublishStatusData.push(obj)
          } else {
            this.PMPublishStatusData[0].flagValue = flagValue
          }
          Notification.success({
            title: '成功',
            message: '操作成功'
          })
          this.publistPMDataFlag = true
        }).catch(err => {
          console.log(err)
          Notification.error({
            title: '失败',
            message: '绩效数据上传失败'
          })
          this.publistPMDataFlag = true
        })
      } else { // ***如果是取消发布绩效
        let publishID = this.PMPublishStatusData.length > 0 ? this.PMPublishStatusData[0].id : -1 // 判断该月绩效是否已经发布
        let applyYear = this.$moment(this.title).year()
        let applyMonth = this.$moment(this.title).month() + 1
        let flagValue = 0
        publishPMData(applyYear, applyMonth, publishID, flagValue).then(() => {
          this.publistPMDataFlag = true
          this.clearEvaTable()
          this.getDataLoading = false
          // ***重新生成表格数据
          let conclusionYear = this.$moment(this.title).year()
          let conclusionMonth = this.$moment(this.title).month() + 1
          this.genTableDataV2(conclusionYear, conclusionMonth, this.intelligentGroup, this.commuincationGroup).then(tableData => {
            if (store.state.userInfo.duty !== 1) {
              this.initDataCSV2(tableData)
            } else {
              this.initDataMGV2(tableData, conclusionYear, conclusionMonth, this.usersList)
            }
          })
          Notification.success({
            title: '成功',
            message: '操作成功'
          })
        }).catch(err => {
          console.log(err)
          Notification.error({
            title: '失败',
            message: '取消发布失败'
          })
          this.publistPMDataFlag = true
        })
      }
    },
    // ***发布绩效信息v4，实行绩效加分、工时上限规则的版本
    handlePerformancePublishV4 () {
      this.publistPMDataFlag = false
      // ***判断按钮状态
      if (this.PMPublishStatus) { // **如果是发布绩效
        let promise = []
        let count = 0
        let publishID = this.PMPublishStatusData.length > 0 ? this.PMPublishStatusData[0].id : -1 // 判断该月绩效是否已经发布
        let applyYear = this.$moment(this.title).year()
        let applyMonth = this.$moment(this.title).month() + 1
        let flagValue = 1

        if (publishID === -1) { // ***如果绩效数据内还没有相关数据，则插入绩效数据
          promise[count++] = savePMDataV3(this.title, this.PMData)
        } else { // ***数据库中有绩效数据，则获取原绩效数据ID，给表格的绩效数据赋值
          for (let PMDataItem of this.PMData) {
            let findResult = this.publishedPMData.find(item => {
              return item.userID === PMDataItem.id
            })
            if (!isUndefined(findResult)) {
              PMDataItem.publishPMDataID = findResult.id
            }
          }
          promise[count++] = updatePMDataV3(this.PMData)
        }
        promise[count++] = publishPMData(applyYear, applyMonth, publishID, flagValue) // 更新绩效发布标志位
        Promise.all(promise).then((allResponse) => {
          if (this.PMPublishStatusData.length === 0) {
            let obj = {
              id: allResponse[1].data.insertId,
              flagValue: flagValue,
              flagType: 'performanceInfoPublish'
            }
            this.PMPublishStatusData.push(obj)
          } else {
            this.PMPublishStatusData[0].flagValue = flagValue
          }
          Notification.success({
            title: '成功',
            message: '操作成功'
          })
          this.publistPMDataFlag = true
        }).catch(err => {
          console.log(err)
          Notification.error({
            title: '失败',
            message: '绩效数据上传失败'
          })
          this.publistPMDataFlag = true
        })
      } else { // ***如果是取消发布绩效
        let publishID = this.PMPublishStatusData.length > 0 ? this.PMPublishStatusData[0].id : -1 // 判断该月绩效是否已经发布
        let applyYear = this.$moment(this.title).year()
        let applyMonth = this.$moment(this.title).month() + 1
        let flagValue = 0
        publishPMData(applyYear, applyMonth, publishID, flagValue).then(() => {
          this.publistPMDataFlag = true
          this.clearEvaTable()
          this.getDataLoading = false
          // ***重新生成表格数据
          this.init()
          // let conclusionYear = this.$moment(this.title).year()
          // let conclusionMonth = this.$moment(this.title).month() + 1
          // this.genTableDataV2(conclusionYear, conclusionMonth, this.intelligentGroup, this.commuincationGroup).then(tableData => {
          //   if (store.state.userInfo.duty !== 1) {
          //     this.initDataCSV2(tableData)
          //   } else {
          //     this.initDataMGV2(tableData, conclusionYear, conclusionMonth, this.usersList)
          //   }
          // })
          Notification.success({
            title: '成功',
            message: '操作成功'
          })
        }).catch(err => {
          console.log(err)
          Notification.error({
            title: '失败',
            message: '取消发布失败'
          })
          this.publistPMDataFlag = true
        })
      }
    },
    // ***日期发生变化
    handleDataChange () {
      if (typeof (Cookies.get('cookieAMEvaPageDate')) !== 'undefined') {
        Cookies.remove('cookieAMEvaPageDate')
      }
      Cookies.set('cookieAMEvaPageDate', this.title)
      this.isOldRule = moment(this.title).isBefore(store.state.newRulesUpdateDate)
      this.clearEvaTable()
      this.getDataLoading = false
      let conclusionYear = this.$moment(this.title).year()
      let conclusionMonth = this.$moment(this.title).month() + 1
      if (this.isOldRule) {
        this.initData(conclusionYear, conclusionMonth, this.intelligentGroup, this.commuincationGroup, this.usersList)
      } else {
        this.genTableDataV2(conclusionYear, conclusionMonth, this.intelligentGroup, this.commuincationGroup).then(tableData => {
        if (store.state.userInfo.duty !== 1) {
          this.initDataCSV2(tableData)
        } else {
          this.initDataMGV2(tableData, conclusionYear, conclusionMonth, this.usersList)
        }
      })
      }
    },
    // 上月
    handlePreMonth () {
      this.title = this.$moment(this.title).subtract(1, 'months').format('YYYY-MM')
      this.handleDataChange()
    },
    // 下月
    handleNextMonth () {
      this.title = this.$moment(this.title).add(1, 'months').format('YYYY-MM')
      this.handleDataChange()
    },
    // 导出成效评价数据
    handleExportAMEva () {
      if (!this.PMData || this.PMData.length === 0) {
        this.$message.warning('没有数据可导出')
        return
      }
      let headers = ['序号', '姓名', '总结状态', '评价状态', '互评状态', '定量得分', '成效排名', '绩效加分', '绩效得分(裸分)', '绩效得分(标准化)', '绩效排名']
      let csvRows = []
      csvRows.push(headers.join(','))

      for (let i = 0; i < this.PMData.length; i++) {
        let row = this.PMData[i]
        let submitStatusText = row.submitStatus === 1 ? '已提交' : (row.submitStatus === 2 ? '提交中' : '未提交')
        let evaStatusText = row.evaStatus === 1 ? '已评价' : '未评价'
        let isEvaAllFinishText = row.isEvaAllFinish ? '已完成' : '未完成'
        let qyEvaScoreNor = row.duty === 2 ? '/' : (row.QYEvaScoreNor || '-')

        csvRows.push([
          i + 1,
          row.name || '',
          submitStatusText,
          evaStatusText,
          isEvaAllFinishText,
          qyEvaScoreNor,
          row.AMEvaRank || '-',
          row.PBScore || '0',
          row.PMScoreUnN || '-',
          row.PMScoreNor || '-',
          row.PMRank || '-'
        ].join(','))
      }

      let csvContent = '\uFEFF' + csvRows.join('\n')
      let blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
      let link = document.createElement('a')
      let url = URL.createObjectURL(blob)
      link.setAttribute('href', url)
      link.setAttribute('download', `成效评价_${this.title}.csv`)
      link.style.visibility = 'hidden'
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
      URL.revokeObjectURL(url)
      this.$message.success('导出成功')
    },
    // 刷新表格尺寸
    refreshTableSize () {
      this.$nextTick(() => {
        this.tableHeight = window.innerHeight - this.$refs.PMDataTable.$el.offsetTop - 5
        if (this.tableHeight < 0) {
          this.tableHeight = window.innerHeight - 100
        }
        let _this = this
        window.onresize = function () {
          _this.tableHeight = window.innerHeight - _this.$refs.PMDataTable.$el.offsetTop - 5
          if (_this.tableHeight < 0) {
            _this.tableHeight = window.innerHeight - 100
          }
        }
      })
    },
    // 清空评价表格
    clearEvaTable () {
      if (this.isOldRule) {
        this.tableData1 = [{}]
        this.tableData2 = [{}]
        this.tableData3 = [{}]
        this.tableData4 = [{}]
        // 重置默认评价星级
        this.buildBoutiqueProjectStar.evaStar = store.state.defaultStar
        this.buildProTeamStar.evaStar = store.state.defaultStar
        if (this.table1CurShowIndex !== -1) {
          if (this.PMData[this.table1CurShowIndex].isShow) {
            this.PMData[this.table1CurShowIndex].isShow = false
            this.PMData[this.table1CurShowIndex].isHighlight = false
            this.table1CurShowIndex = -1
          }
        }
        this.buildBoutiqueProject = {
          content: '无数据'
        }
        this.buildProTeam = {
          content: '无数据'
        }
        this.nextPlan = {
          content: '无数据'
        }
        this.curAdvice = {
          content: '无数据'
        }
      } else {
        // 重置默认评价星级
        this.dimension1V2Star = store.state.defaultStar
        this.dimension2V2Star = store.state.defaultStar
        this.dimension4V2Star = store.state.defaultStar
        if (this.table1CurShowIndex !== -1) {
          if (this.PMData[this.table1CurShowIndex].isShow) {
            this.PMData[this.table1CurShowIndex].isShow = false
            this.PMData[this.table1CurShowIndex].isHighlight = false
            this.table1CurShowIndex = -1
          }
        }
        this.tableData1 = []
        this.tableData2 = []
        this.tableData3 = []
        this.tableData4 = []
        this.teamWorkData = []
      }
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
    },
    // 表格合并方法
    objectSpanMethod ({ row, column, rowIndex, columnIndex }) {
      if (columnIndex === 2) {
        if (rowIndex % 2 === 0) {
          return {
            rowspan: 2,
            colspan: 1
          }
        }
      }
    },
    // 表格高亮方法
    cellStyle ({ row, column, rowIndex, columnIndex }) {
      if (row.isHighlight) {
        return 'background-color: #EEDC82'
      }
    }
  },
  created () {
    this.init()
  },
  mounted () {
    this.refreshTableSize()
  },
  filters: {
  }
}
</script>
<style scoped>
.head-line{
  padding: 20px;
}
.evaluation-container {
  display: flex;
  height: calc(100vh - 180px);
  background: #f5f7fa;
  border-radius: 8px;
  overflow: hidden;
}
.eval-content-scroll {
  flex: 1;
  overflow-y: auto;
  padding: 12px;
  scrollbar-width: thin;
}
.eval-content-scroll::-webkit-scrollbar {
  width: 6px;
}
.eval-content-scroll::-webkit-scrollbar-thumb {
  background: #c0c4cc;
  border-radius: 3px;
}
.eval-content-scroll::-webkit-scrollbar-track {
  background: #f5f7fa;
}
.eval-card {
  background: #fff;
  border-radius: 8px;
  margin-bottom: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}
.eval-card-header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  padding: 12px 16px;
  border-bottom: 1px solid #e8e8e8;
}
.eval-card-title {
  color: #fff;
  font-size: 14px;
  font-weight: 600;
}
.eval-card-content {
  padding: 16px;
  color: #333;
  font-size: 14px;
  line-height: 1.8;
  min-height: 60px;
}
.eval-rating-panel {
  width: 280px;
  background: #fff;
  border-left: 1px solid #e8e8e8;
  display: flex;
  flex-direction: column;
  box-shadow: -2px 0 8px rgba(0, 0, 0, 0.05);
}
.rating-card {
  display: flex;
  flex-direction: column;
  height: 100%;
}
.rating-card-header {
  background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
  color: #fff;
  padding: 14px 20px;
  font-size: 16px;
  font-weight: 600;
  text-align: center;
}
.rating-card-body {
  flex: 1;
  overflow-y: auto;
  padding: 16px;
}
.rating-item {
  background: #f8f9fa;
  border-radius: 8px;
  padding: 14px;
  margin-bottom: 12px;
}
.rating-label {
  font-size: 13px;
  font-weight: 600;
  color: #333;
  margin-bottom: 10px;
}
.rating-info {
  display: flex;
  justify-content: space-between;
  margin-top: 8px;
  font-size: 12px;
  color: #666;
}
.rating-action {
  margin-top: 20px;
  text-align: center;
}
.rating-action .el-button {
  width: 100%;
  padding: 10px 20px;
  font-size: 14px;
}
.failed-eva-info {
  margin-top: 15px;
  padding: 10px;
  background-color: #fef0f0;
  border: 1px solid #fde2e2;
  border-radius: 4px;
}
.failed-eva-title {
  font-size: 14px;
  font-weight: bold;
  color: #F56C6C;
  margin-bottom: 8px;
}
.failed-eva-item {
  font-size: 12px;
  color: #666;
  margin-bottom: 4px;
}
.failed-eva-item span {
  margin-right: 15px;
}
.pointer-type {
  cursor: pointer;
}
.employee-list-col {
  display: flex;
  flex-direction: column;
  height: calc(100vh - 160px);
  min-height: 500px;
}
.employee-list-container {
  flex: 1;
  overflow: hidden;
}
.employee-list-container .el-table {
  height: 100% !important;
}
</style>

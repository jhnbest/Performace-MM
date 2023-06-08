<template>
  <div>
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
            <span>
              <el-switch v-if="isOldRule"
               :disabled="!getDataLoading || !publistPMDataFlag || !workTimeRWed"
               v-model="PMPublishStatus"
               @change="handlePerformancePublish"
               style="margin-left: 10px">
              </el-switch>
              <el-switch v-if="!isOldRule"
               :disabled="!getDataLoading || !publistPMDataFlag || !workTimeRWed"
               v-model="PMPublishStatus"
               @change="handlePerformancePublishV2"
               style="margin-left: 10px">
              </el-switch>
            </span>
            <el-popover
              v-if="!workTimeRWed"
              placement="bottom"
              trigger="click">
              <span>需全处工时完成审核后才能发布</span><br>
              <span slot="reference" class="pointer-type"><i class="el-icon-warning" style="color:red"></i></span>
            </el-popover>
          </div>
        </el-col>
      </el-row>
    </div>
    <div class="hr-10"></div>
    <div class="head-line">
      <el-row :gutter="5">
        <el-col :xs="14" :sm="14" :md="14" :lg="9" :xl="9">
          <el-table
            v-loading="!getDataLoading"
            :data="PMData"
            fit
            highlight-current-row
            style="width: 100%;"
            size="mini"
            ref = "PMDataTable"
            :cell-style="cellStyle">
            <el-table-column label="姓名" prop="name" align="center"></el-table-column>
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
                              label="工时排名(组内)"
                              prop="QYEvaRank"
                              align="center" width="70px"></el-table-column>
            <el-table-column v-if="$store.state.userInfo.duty === 1"
                              label="成效评价排名(全处)"
                              prop="AMEvaRank"
                              align="center" width="80px"></el-table-column>
            <el-table-column v-if="$store.state.userInfo.duty === 1"
                              label="标准化绩效得分"
                              prop="PMScoreNor"
                              align="center" width="70px"></el-table-column>
            <el-table-column v-if="$store.state.userInfo.duty === 1"
                              label="绩效排名"
                              align="center" width="65px">
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
        </el-col>
        <!-- ************************************************************************************************* -->
        <el-col v-if="isOldRule" :xs="13" :sm="13" :md="13" :lg="15" :xl="15">
          <div v-if="forceRefresh">
            <el-table :data="tableData1"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      :height="350"
                      size="medium"
                      style="margin: auto"
                      :header-cell-style="{ background:'#ced1d4', color:'#000000', fontSize:'16px'}">
              <el-table-column label="打造精品工程">
                <template>
                  <div v-html="buildBoutiqueProject.content"></div>
                </template>
              </el-table-column>
              <el-table-column label="评分" width="150px" align="center">
                <template slot-scope="scope">
                  <el-rate :disabled="PMPublishStatus"
                           v-model="buildBoutiqueProjectStar.evaStar"
                           @change="handlebuildBoutiqueProjectStarChange(scope.row)"
                           slot="reference">
                  </el-rate>
                  <p v-if="$store.state.userInfo.duty === 1">组员平均星级：{{dimension1CSAveStar}}</p>
                  <p v-if="$store.state.userInfo.duty === 1">组长评价星级：{{dimension1GPEvaStar}}</p>
                </template>
              </el-table-column>
            </el-table>
            <el-table :data="tableData2"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      :height="150"
                      size="medium"
                      :header-cell-style="{ background:'#ced1d4', color:'#000000', fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="创建专业团队">
                <template>
                  <div v-html="buildProTeam.content"></div>
                </template>
              </el-table-column>
              <el-table-column label="评分" width="150px" align="center">
                <template slot-scope="scope">
                  <el-rate :disabled="PMPublishStatus"
                           v-model="buildProTeamStar.evaStar"
                           @change="handlebuildProTeamStarChange(scope.row)"
                           slot="reference">
                  </el-rate>
                  <p v-if="$store.state.userInfo.duty === 1">组员平均星级：{{dimension2CSAveStar}}</p>
                  <p v-if="$store.state.userInfo.duty === 1">组长评价星级：{{dimension2GPEvaStar}}</p>
                </template>
              </el-table-column>
            </el-table>
            <el-table v-if="$store.state.userInfo.duty === 1"
                      :data="tableData3"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      size="medium"
                      :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="下一个月的工作目标、工作计划/工作安排、工作内容">
                <template>
                  <div v-html="nextPlan.content"></div>
                </template>
              </el-table-column>
            </el-table>
            <el-table v-if="$store.state.userInfo.duty === 1"
                      :data="tableData4"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      size="medium"
                      :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="对处室工作的意见/建议、不满/抱怨、工作/生活/学习中的烦恼和困难以及希望得到的帮助/支持/指导">
                <template>
                  <div v-html="curAdvice.content"></div>
                </template>
              </el-table-column>
            </el-table>
            <el-table :data="tableData5"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      size="medium"
                      :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="操作" align="center">
                <template>
                  <el-button v-if="!currentShowUserisEva && buildBoutiqueProject.content !== '无数据'"
                             :disabled="!submitEvaDataFlag"
                             type="success"
                             @click="handleSubmitAndJumpToNext()">
                             点击提交对
                             <span style="color: red;font-weight: bold">{{curEvaUserName}}</span>
                             的评价并跳转到下一个待评价人
                  </el-button>
                  <el-button v-if="currentShowUserisEva && buildBoutiqueProject.content !== '无数据'"
                             :disabled="!updateEvaDataFlag"
                             type="primary"
                             @click="handleUpdateEva()">
                             点击更新对
                             <span style="color: red;font-weight: bold">{{curEvaUserName}}</span>
                             的评价
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-col>
        <!-- ************************************************************************************************* -->
        <el-col v-if="!isOldRule" :xs="13" :sm="13" :md="13" :lg="15" :xl="15">
          <div v-if="forceRefresh">
            <el-table :data="tableData2"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      :height="220"
                      size="medium"
                      :header-cell-style="{ background:'#00BFFF', color:'#000000', fontSize:'20px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="上月计划 (评价标准参考：1、计划合理性；2、计划完成情况。)">
                <template slot-scope="scope">
                  <div v-html="scope.row.dimension2V2Content"></div>
                </template>
              </el-table-column>
              <el-table-column label="评分" width="150px" align="center">
                <template slot-scope="scope">
                  <el-rate :disabled="PMPublishStatus"
                           v-model="dimension2V2Star"
                           @change="handleD2StarChangeV2(scope.row)"
                           slot="reference">
                  </el-rate>
                  <p v-if="$store.state.userInfo.duty === 1">组员平均星级：{{dimension2CSAveStar}}</p>
                  <p v-if="$store.state.userInfo.duty === 1">组长评价星级：{{dimension2GPEvaStar}}</p>
                </template>
              </el-table-column>
            </el-table>
            <br>
            <el-table :data="tableData1"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      :height="360"
                      size="medium"
                      style="margin: auto"
                      :span-method="objectSpanMethod"
                      :header-cell-style="{ background:'#00BFFF', color:'#000000', fontSize:'20px' }">
              <el-table-column label="评价类别" align="center" prop="evaClass" width="70px"></el-table-column>
              <el-table-column label="打造精品工程&创建专业团队">
                <template slot-scope="scope">
                  <div v-html="scope.row.dimension1V2Content"></div>
                </template>
              </el-table-column>
              <el-table-column label="评分" width="150px" align="center">
                <template slot-scope="scope">
                  <el-rate :disabled="PMPublishStatus"
                           v-model="dimension1V2Star"
                           @change="handleD1StarChangeV2(scope.row)"
                           slot="reference">
                  </el-rate>
                  <p v-if="$store.state.userInfo.duty === 1">组员平均星级：{{dimension1CSAveStar}}</p>
                  <p v-if="$store.state.userInfo.duty === 1">组长评价星级：{{dimension1GPEvaStar}}</p>
                </template>
              </el-table-column>
            </el-table>
            <br>
            <el-table v-if="$store.state.userInfo.duty === 1"
                      :data="tableData3"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      size="medium"
                      :header-cell-style="{ background:'#00BFFF',color:'#000000',fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="对处室工作的意见/建议、不满/抱怨、工作/生活/学习中的烦恼和困难以及希望得到的帮助/支持/指导">
                <template slot-scope="scope">
                  <div v-html="scope.row.dimension3V2Content"></div>
                </template>
              </el-table-column>
            </el-table>
            <div style="margin: 0px auto">
              <el-button v-if="!currentShowUserisEva && tableData1.length !== 0"
                          :disabled="!submitEvaDataFlag"
                          type="success"
                          @click="handleSubmitAndJumpToNextV2()">
                          点击提交对
                          <span style="color: red;font-weight: bold">{{curEvaUserName}}</span>
                          的评价并跳转到下一个待评价人
              </el-button>
              <el-button v-if="currentShowUserisEva && tableData1.length !== 0"
                          :disabled="!updateEvaDataFlag"
                          type="primary"
                          @click="handleUpdateEvaV2()">
                          点击更新对
                          <span style="color: red;font-weight: bold">{{curEvaUserName}}</span>
                          的评价
              </el-button>
            </div>
          </div>
        </el-col>
        <!-- ************************************************************************************************* -->
      </el-row>
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
         mianshenheWorkTimeSubmit } from '@/utils/performance'
import { genQualiEvaData, getAllQTEvaedData } from '@/utils/multual'
import { Notification } from 'element-ui'
import { getUsersList } from '@/utils/users'
import { getCurMonthConclusionOverviewDataNew, getCurMonthConclusionOverviewDataNewV2 } from '@/utils/conclusion'
import { submitAMEvaData,
         updateAMEvaData,
         genAMEvaScoreData,
         genAMEvaScoreDataV2 } from '@/utils/achievementEva'
import { getEvaCoef, sortObjectArrayByParams, getPerformanceIsPublish, sortByAscend, isUndefined, getIsSubmitAllow, convertYearMonth2Nor, getGlobalFlagByType, getGlobalFlagByTime } from '@/utils/common'
import store from '@/store'
import Cookies from 'js-cookie'
import moment from 'moment'
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
      buildBoutiqueProject: {
        content: '无数据'
      }, // 打造精品工程内容
      buildProTeam: {
        content: '无数据'
      }, // 建设专业团队内容
      nextPlan: {
        content: '无数据'
      }, // 下月计划内容
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
      standAndEngineerGroup: [], // 工程组和技术标准组成员
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
      dimension1V2Star: store.state.defaultStar, // 新版评价维度1评价星级
      dimension2V2Star: store.state.defaultStar, // 新版评价维度2评价星级
      dimension1IDV2: null, // 新版评价维度1 ID
      dimension2IDV2: null, // 新版评价维度2 ID
      dimenision1EvaIDV2: null,
      dimenision2EvaIDV2: null
    }
  },
  methods: {
    // 初始化
    init () {
      if (typeof (Cookies.get('cookieAMEvaPageDate')) === 'undefined') {
        Cookies.set('cookieAMEvaPageDate', this.title)
      }
      this.title = Cookies.get('cookieAMEvaPageDate')
      this.getDataLoading = false
      let checkGroupID = 0
      getUsersList(checkGroupID).then(usersList => {
        for (let user of usersList) {
          if (user.groupName === '技术标准组' || user.groupName === '工程组') {
            this.standAndEngineerGroup.push(user)
          } else if (user.groupName === '通信组') {
            this.commuincationGroup.push(user)
          }
        }
        this.usersList = usersList
        let conclusionYear = this.$moment(this.title).year()
        let conclusionMonth = this.$moment(this.title).month() + 1
        this.isOldRule = moment(this.title).isBefore(store.state.newRulesUpdateDate)
        if (this.isOldRule) {
          this.initData(conclusionYear, conclusionMonth, this.standAndEngineerGroup, this.commuincationGroup, usersList)
        } else {
          this.genTableDataV2(conclusionYear, conclusionMonth, this.standAndEngineerGroup, this.commuincationGroup).then(tableData => {
            if (store.state.userInfo.duty !== 1) {
              this.initDataCSV2(tableData)
            } else {
              this.initDataMGV2(tableData, conclusionYear, conclusionMonth, usersList)
            }
          })
        }
      })
    },
    // ***显示月总结信息（普通员工）***
    showConclusionDataCS (row, index) {
      this.tableData1 = []
      this.tableData2 = []
      row.isShow = true
      row.isHighlight = true
      this.curEvaUserName = row.name
      this.table1CurShowIndex = index
      this.table1PreShowIndex = index
      this.currentShowUserisEva = row.evaStatus === 1
      // ********************寻找打造精品工程维度的内容
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
      // ********************寻找下月计划维度的内容********************
      findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      })
      this.dimension2IDV2 = findResult.id
      obj.dimension2V2Content = findResult.content
      this.tableData2.push(JSON.parse(JSON.stringify(obj)))
      // ***********************显示评价星级***********************
      if (row.evaStatus === 1) {
        findResult = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension1IDV2
        })
        this.dimension1V2Star = findResult.evaStar
        this.dimenision1EvaIDV2 = findResult.id
        findResult = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension2IDV2
        })
        this.dimension2V2Star = findResult.evaStar
        this.dimenision2EvaIDV2 = findResult.id
      } else {
        this.dimension1V2Star = store.state.defaultConclusionEvaStar
        this.dimension2V2Star = store.state.defaultConclusionEvaStar
      }
    },
    // ***显示月总结信息(管理者)***
    showConclusionDataMG (row, index) {
      this.tableData1 = []
      this.tableData2 = []
      this.tableData3 = []
      row.isShow = true
      row.isHighlight = true
      this.curEvaUserName = row.name
      this.table1CurShowIndex = index
      this.table1PreShowIndex = index
      this.currentShowUserisEva = row.evaStatus === 1
      // ***********************寻找打造精品工程维度的内容***********************
      let findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
      })
      this.dimension1IDV2 = findResult.id
      let obj = {
        evaClass: '打造精品工程',
        dimension1V2Content: findResult.content
      }
      this.tableData1.push(JSON.parse(JSON.stringify(obj)))
      // ***********************寻找创建专业团队维度的内容***********************
      findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
      })
      obj.evaClass = '创建专业团队'
      obj.dimension1V2Content = findResult.content
      this.tableData1.push(JSON.parse(JSON.stringify(obj)))
      // ***********************寻找下月计划维度的内容***********************
      findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      })
      this.dimension2IDV2 = findResult.id
      obj.dimension2V2Content = findResult.content
      this.tableData2.push(JSON.parse(JSON.stringify(obj)))
      // ***********************寻找处室意见维度的内容***********************
      findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
      })
      obj.dimension3V2Content = findResult.content === '' ? '无数据' : findResult.content
      this.tableData3.push(JSON.parse(JSON.stringify(obj)))
      // ***********************显示评价星级***********************
      if (row.evaStatus === 1) { // ********如果当前用户已评价********
        findResult = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension1IDV2
        })
        this.dimension1V2Star = findResult.evaStar
        this.dimenision1EvaIDV2 = findResult.id
        findResult = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension2IDV2
        })
        this.dimension2V2Star = findResult.evaStar
        this.dimenision2EvaIDV2 = findResult.id
      } else { // ************如果当前用户还未评价，则显示为虚拟构建的评价星级********
        this.dimension1V2Star = row.AMD1MGEvaStarV
        this.dimension2V2Star = row.AMD2MGEvaStarV
      }
      // ***********************显示组员平均评价星级和组长评价星级***********************
      this.dimension1CSAveStar = Number(row.AMD1CSEvaAveStar.toFixed(2))
      this.dimension1GPEvaStar = Number(row.AMD1GPEvaStar.toFixed(2))
      this.dimension2CSAveStar = Number(row.AMD2CSEvaAveStar.toFixed(2))
      this.dimension2GPEvaStar = Number(row.AMD2GPEvaStar.toFixed(2))
    },
    // ***初始化显示数据***
    initData (conclusionYear, conclusionMonth, SEGroup, CMGroup, usersList) {
      // 生成表格初始数据（获取其他人的月总结以及对其他人的月总结评价）
      this.genTableData(conclusionYear, conclusionMonth, SEGroup, CMGroup).then(tableData => {
        // 普通员工
        if (store.state.userInfo.duty !== 1) {
          // 初始化默认显示的数据
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
                    this.dimension1CSAveStar = Number(tableData[i].AMD1CSEvaAveStar.toFixed(2))
                    this.dimension1GPEvaStar = Number(tableData[i].AMD1GPEvaStar.toFixed(2))
                    this.dimension2CSAveStar = Number(tableData[i].AMD2CSEvaAveStar.toFixed(2))
                    this.dimension2GPEvaStar = Number(tableData[i].AMD2GPEvaStar.toFixed(2))
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
                    this.dimension1CSAveStar = Number(tableData[i].AMD1CSEvaAveStar.toFixed(2))
                    this.dimension1GPEvaStar = Number(tableData[i].AMD1GPEvaStar.toFixed(2))
                    this.dimension2CSAveStar = Number(tableData[i].AMD2CSEvaAveStar.toFixed(2))
                    this.dimension2GPEvaStar = Number(tableData[i].AMD2GPEvaStar.toFixed(2))
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

    // ***初始化显示数据V2(管理者)***
    initDataMGV2 (tableData, conclusionYear, conclusionMonth, usersList) {
      // *********首先判断绩效信息发布状态并获取每条月总结对应的所有评价，如果绩效已发布，则显示已经发布的绩效数据；
      getPerformanceIsPublish(conclusionYear, conclusionMonth).then(response => {
        this.PMPublishStatusData = response // 绩效发布状态
        this.PMPublishStatus = false
        if (this.PMPublishStatusData.length > 0) {
          if (this.PMPublishStatusData[0].flagValue !== 0) {
            this.PMPublishStatus = true // 绩效发布状态设置为已发布
          }
        }
        // **********************************获取全处工时审核状态************************************
        getSubmitWorkTimeCount(usersList, this.title).then(getSubmitWorkTimeCountRes => {
          this.workTimeRWed = true
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
        if (this.PMPublishStatus) { // ***************直接获取绩效数据->绩效库有数据且绩效发布状态为已发布
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
            // ***排序***
            tableData.sort(sortByAscend('PMRank'))
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
            this.getDataLoading = true
          })
        } else { // ***重新计算绩效数据->绩效库无数据或绩效库有数据但未发布***
          let promises = []
          let count = 0
          promises[count++] = getAllWorkTimeList(this.title) // ***获取工时申报情况***
          promises[count++] = getAllQTEvaedData(usersList, this.title) // ***获取定性评价情况***
          promises[count++] = getEvaCoef() // ***获取各种系数***
          if (this.PMPublishStatusData.length > 0) { // ***如果绩效数据库里面有绩效，则获取绩效数据***
            promises[count++] = getPMData(this.title)
          }
          Promise.all(promises).then(allResponse => {
            let allWorkTimeList = allResponse[0]
            let QTEvaedData = allResponse[1]
            this.evaCoefObj = allResponse[2]
            if (this.PMPublishStatusData.length > 0) { // *******如果绩效数据库里面有绩效，则获取*******
              this.publishedPMData = allResponse[3]
            }
            this.QYEvaScoreData = genQYEvaScoreData(usersList, allWorkTimeList, this.title) // *******生成定量评价数据*******
            this.QTEvaScoreData = genQualiEvaData(QTEvaedData, this.QYEvaScoreData) // *******生成定性评价数据*******
            tableData = genAMEvaScoreDataV2(tableData,
                                  this.evaCoefObj.AMDimension1CoefV2, this.evaCoefObj.AMDimension2CoefV2,
                                  this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                  this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                  this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData) // *******生成成效评价数据*******
            // 计算绩效信息
            tableData = genPerformanceScore(tableData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
            // 排序
            tableData = sortObjectArrayByParams(tableData, 'PMScoreUnN', 'totalWorkTime')
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
            this.getDataLoading = true
          })
        }
      }) // 获取绩效信息发布状态
    },

    // 获取月总结及相关评价数据，生成初始表格数据
    genTableData (conclusionYear, conclusionMonth, SEGroup, CMGroup) {
      // 初始化默认数据
      let allconclusionAndEvaData = []
      let allUsers = SEGroup.concat(CMGroup) // 拼接成所有用户
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
      // 如果当前用户属于技术标准组或工程组，则构造相应组别的成员
      if (store.state.userInfo.groupID === 1 || store.state.userInfo.groupID === 2) {
        for (let SEGroupItem of SEGroup) {
          tableDataItem.id = SEGroupItem.id
          tableDataItem.name = SEGroupItem.name
          tableDataItem.groupName = SEGroupItem.groupName
          tableDataItem.groupID = SEGroupItem.groupID
          tableDataItem.duty = SEGroupItem.duty
          tableDataItem.job = SEGroupItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem)))
        }
      } else if (store.state.userInfo.groupID === 3) { // 如果属于通信组
        for (let CMGroupItem of CMGroup) {
          tableDataItem.id = CMGroupItem.id
          tableDataItem.name = CMGroupItem.name
          tableDataItem.groupName = CMGroupItem.groupName
          tableDataItem.groupID = CMGroupItem.groupID
          tableDataItem.duty = CMGroupItem.duty
          tableDataItem.job = CMGroupItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem)))
        }
      } else { // 如果是处经理
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
      // 把自己去掉
      let findIndex = allconclusionAndEvaData.findIndex(item => { return item.id === store.state.userInfo.id })
      if (findIndex !== -1) {
        allconclusionAndEvaData.splice(findIndex, 1)
      }
      return new Promise(function (resolve, reject) {
        // 根据构造的表格数据单元获取每个用户的月总结及对应的评价
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
            if (allconclusionAndEvaData[i].groupID === 1 || allconclusionAndEvaData[i].groupID === 2) {
              for (let j = 0; j < allconclusionAndEvaData.length; j++) {
                let findIndex = allconclusionAndEvaData[j].allAMEvaedData.findIndex(item => {
                  return item.evaUserID === allconclusionAndEvaData[i].id
                })
                if (findIndex === -1 && // 没找到
                    j !== i && // 不是本人
                    (allconclusionAndEvaData[j].groupID === 1 || allconclusionAndEvaData[j].groupID === 2)) {
                  allconclusionAndEvaData[i].isEvaAllFinish = false
                  break
                }
              }
            } else if (allconclusionAndEvaData[i].groupID === 3) {
              for (let j = 0; j < allconclusionAndEvaData.length; j++) {
                let findIndex = allconclusionAndEvaData[j].allAMEvaedData.findIndex(item => {
                  return item.evaUserID === allconclusionAndEvaData[i].id
                })
                if (findIndex === -1 && // 没找到
                    j !== i && // 不是本人
                    (allconclusionAndEvaData[j].groupID === 3)) {
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

    // 获取月总结及相关评价数据，生成初始表格数据v2
    genTableDataV2 (conclusionYear, conclusionMonth, SEGroup, CMGroup) {
      // 初始化默认数据
      let allconclusionAndEvaData = []
      let allUsers = SEGroup.concat(CMGroup) // 拼接成所有用户
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
      // 如果当前用户属于技术标准组或工程组，则构造相应组别的成员
      if (store.state.userInfo.groupID === 1 || store.state.userInfo.groupID === 2) {
        for (let SEGroupItem of SEGroup) {
          tableDataItem.id = SEGroupItem.id
          tableDataItem.name = SEGroupItem.name
          tableDataItem.groupName = SEGroupItem.groupName
          tableDataItem.groupID = SEGroupItem.groupID
          tableDataItem.duty = SEGroupItem.duty
          tableDataItem.job = SEGroupItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem)))
        }
      } else if (store.state.userInfo.groupID === 3) { // 如果属于通信组
        for (let CMGroupItem of CMGroup) {
          tableDataItem.id = CMGroupItem.id
          tableDataItem.name = CMGroupItem.name
          tableDataItem.groupName = CMGroupItem.groupName
          tableDataItem.groupID = CMGroupItem.groupID
          tableDataItem.duty = CMGroupItem.duty
          tableDataItem.job = CMGroupItem.job
          allconclusionAndEvaData.push(JSON.parse(JSON.stringify(tableDataItem)))
        }
      } else { // 如果是处经理
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
      // 把自己去掉
      let findIndex = allconclusionAndEvaData.findIndex(item => { return item.id === store.state.userInfo.id })
      if (findIndex !== -1) {
        allconclusionAndEvaData.splice(findIndex, 1)
      }
      return new Promise(function (resolve, reject) {
        // 根据构造的表格数据单元获取每个用户的月总结及对应的评价
        let evaUserID = store.state.userInfo.id
        let evaUserDuty = store.state.userInfo.duty
        let checkUserID = []
        for (let allconclusionAndEvaDataItem of allconclusionAndEvaData) {
          checkUserID.push(allconclusionAndEvaDataItem.id)
        }
        getCurMonthConclusionOverviewDataNewV2(conclusionYear, conclusionMonth, checkUserID, evaUserID, evaUserDuty).then(response => {
          let responseData = response.data
          // ======================判断月总结提交状态并对已提交总结的用户获取月总结内容对应的该用户的评价结果======================
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            allconclusionAndEvaData[i].conclusionContent = responseData.conclusionData.filter(item => {
              return item.userID === allconclusionAndEvaData[i].id
            })
            allconclusionAndEvaData[i].submitStatus = allconclusionAndEvaData[i].conclusionContent.length === 4
              ? allconclusionAndEvaData[i].conclusionContent.find(item => { return item.dimension === 1 }).submitStatus : 0
            allconclusionAndEvaData[i].conclusionEva = responseData.AMEvaedData.filter(item => {
              return (item.evaUserID === store.state.userInfo.id && item.evaedUserID === allconclusionAndEvaData[i].id)
            })
            allconclusionAndEvaData[i].evaStatus = allconclusionAndEvaData[i].conclusionEva.length > 0 ? 1 : 0
            if (store.state.userInfo.duty === 1) { // ***处经理
              allconclusionAndEvaData[i].allAMEvaedData = responseData.AMEvaedData.filter(item => {
                return item.evaedUserID === allconclusionAndEvaData[i].id
              })
            }
          }
          // =============================判断各位用户是否已经评价完其他人=========================
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            if (allconclusionAndEvaData[i].groupID === 1 || allconclusionAndEvaData[i].groupID === 2) {
              for (let j = 0; j < allconclusionAndEvaData.length; j++) {
                let findIndex = allconclusionAndEvaData[j].allAMEvaedData.findIndex(item => {
                  return item.evaUserID === allconclusionAndEvaData[i].id
                })
                if (findIndex === -1 && // 没找到
                    j !== i && // 不是本人
                    (allconclusionAndEvaData[j].groupID === 1 || allconclusionAndEvaData[j].groupID === 2)) {
                  allconclusionAndEvaData[i].isEvaAllFinish = false
                  break
                }
              }
            } else if (allconclusionAndEvaData[i].groupID === 3) {
              for (let j = 0; j < allconclusionAndEvaData.length; j++) {
                let findIndex = allconclusionAndEvaData[j].allAMEvaedData.findIndex(item => {
                  return item.evaUserID === allconclusionAndEvaData[i].id
                })
                if (findIndex === -1 && // 没找到
                    j !== i && // 不是本人
                    (allconclusionAndEvaData[j].groupID === 3)) {
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

    // 点击显示
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
      this.dimension1CSAveStar = Number(this.PMData[this.table1CurShowIndex].AMD1CSEvaAveStar.toFixed(2))
      this.dimension1GPEvaStar = Number(this.PMData[this.table1CurShowIndex].AMD1GPEvaStar.toFixed(2))
      this.dimension2CSAveStar = Number(this.PMData[this.table1CurShowIndex].AMD2CSEvaAveStar.toFixed(2))
      this.dimension2GPEvaStar = Number(this.PMData[this.table1CurShowIndex].AMD2GPEvaStar.toFixed(2))
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
      // 如果是经理，将显示的绩效数据设置为初始状态
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

      // ********************寻找打造精品工程的内容********************
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
      // ********************寻找下月计划维度的内容********************
      findResult = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      })
      this.dimension2IDV2 = findResult.id
      obj.dimension2V2Content = findResult.content
      this.tableData2.push(JSON.parse(JSON.stringify(obj)))
      // ********************设置评价星级*****************************
      if (row.evaStatus === 1) { // ********如果当前用户已评价********
        findResult = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension1IDV2
        })
        this.dimension1V2Star = findResult.evaStar
        this.dimenision1EvaIDV2 = findResult.id
        findResult = row.conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.dimension2IDV2
        })
        this.dimension2V2Star = findResult.evaStar
        this.dimenision2EvaIDV2 = findResult.id
      } else { // ************如果当前用户还未评价，管理者显示虚拟构建的评价星级，普通员工显示默认评价星级********
        if (store.state.userInfo.duty === 1) {
          this.dimension1V2Star = row.AMD1MGEvaStarV
          this.dimension2V2Star = row.AMD2MGEvaStarV
        } else {
          this.dimension1V2Star = store.state.defaultStar
          this.dimension2V2Star = store.state.defaultStar
        }
      }
      // 显示组员平均评价星级和组长评价星级
      if (store.state.userInfo.duty === 1) {
        this.dimension1CSAveStar = Number(this.PMData[index].AMD1CSEvaAveStar.toFixed(2))
        this.dimension1GPEvaStar = Number(this.PMData[index].AMD1GPEvaStar.toFixed(2))
        this.dimension2CSAveStar = Number(this.PMData[index].AMD2CSEvaAveStar.toFixed(2))
        this.dimension2GPEvaStar = Number(this.PMData[index].AMD2GPEvaStar.toFixed(2))
      }

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

    // *****************维度1星级变化v2*****************
    handleD1StarChangeV2 () {
      if (store.state.userInfo.duty === 1) {
        // =========================================更新处经理评价数据=========================================
        let curEvaUserID = this.PMData[this.table1CurShowIndex].id
        let findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
        })
        // 如果处经理已经评价
        if (typeof (findResult) !== 'undefined') {
          findResult.evaStar = this.dimension1V2Star
        }
        this.PMData = genAMEvaScoreDataV2(this.PMData,
                                  this.evaCoefObj.AMDimension1CoefV2, this.evaCoefObj.AMDimension2CoefV2,
                                  this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                  this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                  this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData)
        this.PMData = genPerformanceScore(this.PMData, this.QYEvaScoreData, this.QTEvaScoreData, this.evaCoefObj)
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

    // *****************维度2星级变化*****************
    handleD2StarChangeV2 () {
      if (store.state.userInfo.duty === 1) {
        let curEvaUserID = this.PMData[this.table1CurShowIndex].id
        let findResult = this.PMData[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 3 && item.evaUserID === store.state.userInfo.id
        })
        if (typeof (findResult) !== 'undefined') {
          findResult.evaStar = this.buildProTeamStar.evaStar
        }
        this.PMData = genAMEvaScoreDataV2(this.PMData,
                                  this.evaCoefObj.AMDimension1CoefV2, this.evaCoefObj.AMDimension2CoefV2,
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
            this.dimension1CSAveStar = Number(this.PMData[this.table1CurShowIndex].AMD1CSEvaAveStar.toFixed(2))
            this.dimension1GPEvaStar = Number(this.PMData[this.table1CurShowIndex].AMD1GPEvaStar.toFixed(2))
            this.dimension2CSAveStar = Number(this.PMData[this.table1CurShowIndex].AMD2CSEvaAveStar.toFixed(2))
            this.dimension2GPEvaStar = Number(this.PMData[this.table1CurShowIndex].AMD2GPEvaStar.toFixed(2))
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
      this.submitEvaDataFlag = false
      let promises = []
      let count = 0
      promises[count++] = submitAMEvaData(store.state.userInfo.id, this.dimension1IDV2, this.dimension1V2Star)
      promises[count++] = submitAMEvaData(store.state.userInfo.id, this.dimension2IDV2, this.dimension2V2Star)
      Promise.all(promises).then((allResponse) => {
        this.PMData[this.table1CurShowIndex].evaStatus = 1
        this.PMData[this.table1CurShowIndex].isShow = false
        this.PMData[this.table1CurShowIndex].isHighlight = false
        // ************如果是经理，删除虚拟构建的评价星级************
        if (store.state.userInfo.duty === 1) {
          this.PMData[this.table1CurShowIndex].conclusionEva = []
          for (let PMDataItem of this.PMData) {
            PMDataItem.PMRankChange = 0
          }
        }
        // ************构建并插入评价详情进conclusionEva************
        let obj = {
          id: allResponse[0].insertId,
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
        obj.id = allResponse[1].insertId
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

        // ************跳转到下一个未评价的用户************
        let index = this.PMData.findIndex(PMdataItem => {
          return PMdataItem.evaStatus === 0 && PMdataItem.submitStatus === 1
        })
        if (index !== -1) { // 还有未评价且月总结已经提交的用户
          if (store.state.userInfo.duty !== 1) {
            this.showConclusionDataCS(this.PMData[index], index)
          } else {
            this.showConclusionDataMG(this.PMData[index], index)
          }
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
        } else { // 都已评价
          this.tableData1 = []
          this.tableData2 = []
          this.tableData3 = []
          this.currentShowUserisEva = true
          this.table1PreShowIndex = -1
          Notification.info({
            title: '成功',
            message: '已全部评价完成'
          })
          // 显示组员平均评价星级和组长评价星级
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
      this.updateEvaDataFlag = false
      let promises = []
      let count = 0
      promises[count++] = updateAMEvaData(this.dimenision1EvaIDV2, this.dimension1V2Star)
      promises[count++] = updateAMEvaData(this.dimenision2EvaIDV2, this.dimension2V2Star)
      Promise.all(promises).then(() => {
        // 把更新结果临时插入当前表格数据内
        let findEvaItem = this.PMData[this.table1CurShowIndex].conclusionEva.find(tableDataItem => {
          return tableDataItem.id === this.dimension1IDV2
        })
        if (typeof (findEvaItem) !== 'undefined') {
          findEvaItem.evaStar = this.dimension1V2Star
        }
        findEvaItem = this.PMData[this.table1CurShowIndex].conclusionEva.find(tableDataItem => {
          return tableDataItem.id === this.dimension2IDV2
        })
        if (typeof (findEvaItem) !== 'undefined') {
          findEvaItem.evaStar = this.dimension2V2Star
        }
        // 如果是经理，删除虚拟构建的评价星级
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
          this.initData(conclusionYear, conclusionMonth, this.standAndEngineerGroup, this.commuincationGroup, this.usersList)
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
      if (this.PMPublishStatus) { // 如果是发布绩效
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
      } else { // 如果是取消发布绩效
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
          this.genTableDataV2(conclusionYear, conclusionMonth, this.standAndEngineerGroup, this.commuincationGroup).then(tableData => {
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
    // 日期发生变化
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
        this.initData(conclusionYear, conclusionMonth, this.standAndEngineerGroup, this.commuincationGroup, this.usersList)
      } else {
        this.genTableDataV2(conclusionYear, conclusionMonth, this.standAndEngineerGroup, this.commuincationGroup).then(tableData => {
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
</style>

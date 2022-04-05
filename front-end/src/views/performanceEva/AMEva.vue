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
        <el-col :md="13" :lg="{span: 7, offset: 5}" :xl="{span: 7, offset: 7}" v-if="$store.state.userInfo.duty === 1">
          <div>
            <span style="font-weight:bold;">绩效信息发布状态：</span>
            <span>
              <span v-if="getDataLoading">
                <span v-if="PMPublishStatus" style="color: green;font-size: 23px;font-weight:bold">已发布</span>
                <span v-else style="color: red;font-size: 23px;font-weight:bold">未发布</span>
              </span>
              <span v-else>
                <span style="color: red;font-size: 23px;font-weight:bold">查询中...</span>
              </span>
            </span>
            <el-switch
               :disabled="!getDataLoading || !publistPMDataFlag"
               v-model="PMPublishStatus"
               @change="handlePerformancePublish"
               style="margin-left: 20px">
            </el-switch>
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
            :height="600"
            ref = "PMDataTable">
            <el-table-column label="姓名" prop="name" align="center"></el-table-column>
            <el-table-column label="月总结提交状态" prop="submitStatus" align="center" width="70px">
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
            <el-table-column v-if="$store.state.userInfo.duty === 1" label="是否已全部评价他人" align="center" width="80px">
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
                              label="工时排名"
                              prop="newPMData.QYEvaRank"
                              align="center" width="50px"></el-table-column>
            <el-table-column v-if="$store.state.userInfo.duty === 1"
                              label="成效评价排名"
                              prop="newPMData.AMEvaRank"
                              align="center" width="60px"></el-table-column>
            <el-table-column v-if="$store.state.userInfo.duty === 1"
                              label="标准化绩效得分"
                              prop="newPMData.PMScoreNor"
                              align="center" width="70px"></el-table-column>
            <el-table-column v-if="$store.state.userInfo.duty === 1"
                              label="绩效排名"
                              align="center" width="50px">
              <template slot-scope="scope">
                <span style="font-weight: bolder;color: red">{{scope.row.newPMData.PMRank}}</span>
                <i v-if="scope.row.newPMData.PMRankChange < 0" class="el-icon-caret-top" style="color: red"></i>
                <i v-if="scope.row.newPMData.PMRankChange > 0" class="el-icon-caret-bottom" style="color: green"></i>
                <span v-if="scope.row.newPMData.PMRankChange !== 0" style="font-size: 10px">
                  {{scope.row.newPMData.PMRankChange > 0 ? scope.row.newPMData.PMRankChange : -scope.row.newPMData.PMRankChange}}
                </span>
              </template>
            </el-table-column>
            <el-table-column label="月总结" align="center">
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
          </el-table>
        </el-col>
        <el-col :xs="13" :sm="13" :md="13" :lg="15" :xl="15">
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
                  <el-rate v-model="buildBoutiqueProjectStar.evaStar"
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
                  <el-rate v-model="buildProTeamStar.evaStar"
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
         updatePMData } from '@/utils/performance'
import { getAllUserRates, genQualiEvaData } from '@/utils/multual'
import { Notification } from 'element-ui'
import { getUsersList } from '@/utils/users'
import { getCurMonthConclusionOverviewDataNew } from '@/utils/conclusion'
import { getUserofAchievementToAnotherUser,
         submitAMEvaData,
         updateAMEvaData,
         genAMEvaScoreData,
         getUserConclusionEvaedData } from '@/utils/achievementEva'
import { getEvaCoef, sortObjectArrayByParams, getPerformanceIsPublish } from '@/utils/common'
import store from '@/store'
import Cookies from 'js-cookie'
export default {
  data () {
    return {
      title: this.$moment().format('YYYY-MM'), // 日期
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
      toDoEvaNum: 0, // 待评价的人数
      doneEvaNum: 0, // 已评价的人数,
      forceRefresh: true, // 强制刷新
      curEvaUserName: null, // 当前显示的用户姓名
      standAndEngineerGroup: [], // 工程组和技术标准组成员
      commuincationGroup: [], // 通信组成员,
      globalAllAmEvaData: [], // 存储全局成效评价
      QYEvaScoreData: [], // 存储全局定量评价数据
      QTEvaScoreData: [], // 存储全局定性评价数据
      evaCoefObj: [], // 存储全局各种系数数据
      initPMData: [], // 首次生成的绩效数据
      currentShowUserisEva: false, // 存储当前显示用户是否已评价
      newPMData: [], // 动态计算的绩效数据
      dimension1CSAveStar: 0, // 评价维度1普通成员平均评价星级
      dimension2CSAveStar: 0, // 评价维度2普通成员平均评价星级
      dimension1GPEvaStar: 0, // 评价维度1组长评价星级
      dimension2GPEvaStar: 0, // 评价维度2组长评价星级
      PMPublishStatus: false, // 绩效信息发布状态
      PMPublishStatusData: [] // 绩效发布状态数据
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
      getUsersList().then(usersList => {
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
        this.initData(conclusionYear, conclusionMonth, usersList)
      })
    },
    // 初始化显示数据
    initData (conclusionYear, conclusionMonth, usersList) {
      // 先生成表格初始数据（获取其他人的月总结以及对其他的月总结评价
      this.genTableData(conclusionYear, conclusionMonth, usersList).then(tableData => {
        // 普通员工
        if (store.state.userInfo.duty !== 1) {
          // 初始化默认显示的数据
          for (let i = 0; i < tableData.length; i++) {
            if (tableData[i].submitStatus !== 0) {
              tableData[i].isShow = true
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
          let promise1 = []
          let count1 = 0
          promise1[count1++] = getPerformanceIsPublish(conclusionYear, conclusionMonth) // 获取绩效信息发布状态
          for (let tableDataItem of tableData) {
            promise1[count1++] = getUserConclusionEvaedData(conclusionYear, conclusionMonth, tableDataItem.id) // 获取每条月总结对应的所有评价
          }

          Promise.all(promise1).then(allResponse1 => {
            this.PMPublishStatusData = allResponse1[0] // 绩效发布状态
            // 整理月总结评价数据
            for (let i = 1; i < allResponse1.length; i++) {
              tableData[i - 1].allAMEvaedData = allResponse1[i]
            }
            // =============================判断各位用户是否已经评价完其他人=========================
            for (let i = 0; i < tableData.length; i++) {
              if (tableData[i].groupID === 1 || tableData[i].groupID === 2) {
                for (let j = 0; j < tableData.length; j++) {
                  let findIndex = tableData[j].allAMEvaedData.findIndex(item => {
                    return item.evaUserID === tableData[i].id
                  })
                  if (findIndex === -1 && // 没找到
                      j !== i && // 不是本人
                      (tableData[j].groupID === 1 || tableData[j].groupID === 2)) {
                    tableData[i].isEvaAllFinish = false
                    break
                  }
                }
              } else if (tableData[i].groupID === 3) {
                for (let j = 0; j < tableData.length; j++) {
                  let findIndex = tableData[j].allAMEvaedData.findIndex(item => {
                    return item.evaUserID === tableData[i].id
                  })
                  if (findIndex === -1 && // 没找到
                      j !== i && // 不是本人
                      (tableData[j].groupID === 3)) {
                    tableData[i].isEvaAllFinish = false
                    break
                  }
                }
              }
            }
            // =============================计算绩效评价相关信息====================================
            if (this.PMPublishStatusData.length > 0) { // 绩效数据库中已有相关数据
              this.PMPublishStatus = this.PMPublishStatusData[0].flagValue !== 0
              getPMData(this.title).then(getPMDataRes => {
                for (let tableDataItem of tableData) {
                  let findResult = getPMDataRes.find(getPMDataResItem => {
                    return getPMDataResItem.userID === tableDataItem.id
                  })
                  tableDataItem.PMData = findResult
                  tableDataItem.PMData.PMRankChange = 0
                  tableDataItem.PMData.dimension1CSAveStar = findResult.dimension1CSAveStar
                  tableDataItem.PMData.dimension1GPEvaStar = findResult.dimension1GPEvaStar
                  tableDataItem.PMData.dimension2CSAveStar = findResult.dimension2CSAveStar
                  tableDataItem.PMData.dimension2GPEvaStar = findResult.dimension2GPEvaStar
                  tableDataItem.newPMData = JSON.parse(JSON.stringify(tableDataItem.PMData))
                  // 为了排序用
                  tableDataItem.PMScoreUnN = tableDataItem.newPMData.PMScoreUnN
                  tableDataItem.totalWorkTime = tableDataItem.newPMData.totalWorkTime
                }
                // 排序
                tableData = sortObjectArrayByParams(tableData, 'PMScoreUnN', 'totalWorkTime')
                // 显示第一个已提交的用户信息
                for (let i = 0; i < tableData.length; i++) {
                  if (tableData[i].submitStatus !== 0) {
                    tableData[i].isShow = true
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
                      this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                        return evaItem.dimension === 1
                      })))
                      this.buildProTeamStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                        return evaItem.dimension === 2
                      })))
                    }
                    // 显示组员平均评价星级和组长评价星级
                    this.dimension1CSAveStar = Number(tableData[i].newPMData.dimension1CSAveStar.toFixed(2))
                    this.dimension1GPEvaStar = Number(tableData[i].newPMData.dimension1GPEvaStar.toFixed(2))
                    this.dimension2CSAveStar = Number(tableData[i].newPMData.dimension2CSAveStar.toFixed(2))
                    this.dimension2GPEvaStar = Number(tableData[i].newPMData.dimension2GPEvaStar.toFixed(2))
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
            } else { // 绩效数据库中还未有相关数据
              this.PMPublishStatus = false
              let promises = []
              let count = 0
              promises[count++] = getAllWorkTimeList(this.title) // 获取工时申报情况
              promises[count++] = getAllUserRates(usersList, this.title) // 获取定性评价情况
              promises[count++] = getEvaCoef() // 获取各种系数
              Promise.all(promises).then(allResponse => {
                let allWorkTimeList = allResponse[0]
                let allUserRates = allResponse[1]
                this.evaCoefObj = allResponse[2]
                this.QYEvaScoreData = genQYEvaScoreData(usersList, allWorkTimeList, this.title) // 生成定量评价数据
                this.QTEvaScoreData = genQualiEvaData(allUserRates) // 生成定性评价数据
                let AMEvaScoreData = genAMEvaScoreData(tableData,
                                      this.evaCoefObj.AMBuildBoutiqueProjectCoef, this.evaCoefObj.AMBuildProTeamCoef,
                                      this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                      this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                      this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData) // 生成成效评价数据
                if (AMEvaScoreData.length > 0) {
                  // 把生成的成效评价数据插入表格数据里
                  for (let tableDataItem of tableData) {
                    let findResult = AMEvaScoreData.find(AMEvaScoreDataItem => {
                      return AMEvaScoreDataItem.evaedUserID === tableDataItem.id
                    })
                    tableDataItem.AMEvaScoreData = findResult
                  }
                  // ===========================在初始get到的成效评价数据上插入经理评价（如果经理还未评价）=========================
                  for (let tableDataItem of tableData) {
                    if (tableDataItem.conclusionEva.length === 0 && // 管理者尚未评价
                        tableDataItem.submitStatus === 1 && // 月总结已提交
                        tableDataItem.allAMEvaedData.length !== 0) { // 已有其他人评价
                      // 构造打造精品工程的评价
                      let obj = {
                        dimension: 1,
                        dimensionID: tableDataItem.allAMEvaedData.find(item => { return item.dimension === 1 }).dimensionID,
                        evaStar: tableDataItem.AMEvaScoreData.dimension1AveStar,
                        evaUserDuty: store.state.userInfo.duty,
                        evaUserID: store.state.userInfo.id,
                        evaUserName: store.state.userInfo.name,
                        evaedUserDuty: tableDataItem.duty,
                        evaedUserGroupID: tableDataItem.groupID,
                        evaedUserID: tableDataItem.id,
                        evaedUserName: tableDataItem.name
                      }
                      // 把构建的打造精品工程插入评价星级中
                      tableDataItem.conclusionEva.push(JSON.parse(JSON.stringify(obj)))
                      tableDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj))) // 插入对打造精品工程的经理评价
                      // 构造创建专业团队的评价
                      obj.dimension = 2
                      obj.dimensionID = tableDataItem.allAMEvaedData.find(item => { return item.dimension === 2 }).dimensionID
                      obj.evaStar = tableDataItem.AMEvaScoreData.dimension2AveStar
                      tableDataItem.conclusionEva.push(JSON.parse(JSON.stringify(obj))) // 把构建的专业团队评价插入评价星级中
                      tableDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj))) // 插入对创建专业团队的经理评价
                    }
                  }
                  // 计算绩效信息
                  let userListTmp = JSON.parse(JSON.stringify(this.usersList))
                  userListTmp.splice(this.usersList.findIndex(user => { return user.id === store.state.userInfo.id }), 1)
                  this.initPMData = genPerformanceScore(userListTmp, this.QYEvaScoreData, this.QTEvaScoreData, AMEvaScoreData,
                                    this.evaCoefObj)
                  // 把算出来的绩效信息插入表格数据
                  for (let tableDataItem of tableData) {
                    let findResult = this.initPMData.find(initPMDataItem => {
                      return initPMDataItem.id === tableDataItem.id
                    })
                    tableDataItem.PMData = findResult
                    tableDataItem.PMData.dimension1CSAveStar = tableDataItem.AMEvaScoreData.dimension1CSAveStar
                    tableDataItem.PMData.dimension1GPEvaStar = tableDataItem.AMEvaScoreData.dimension1GPEvaStar
                    tableDataItem.PMData.dimension2CSAveStar = tableDataItem.AMEvaScoreData.dimension2CSAveStar
                    tableDataItem.PMData.dimension2GPEvaStar = tableDataItem.AMEvaScoreData.dimension2GPEvaStar
                    tableDataItem.newPMData = JSON.parse(JSON.stringify(tableDataItem.PMData))
                    tableDataItem.newPMData.userJob = tableDataItem.job
                    tableDataItem.newPMData.userDuty = tableDataItem.duty
                    tableDataItem.PMScoreUnN = tableDataItem.newPMData.PMScoreUnN
                    tableDataItem.totalWorkTime = tableDataItem.newPMData.totalWorkTime
                  }
                  // 排序
                  tableData = sortObjectArrayByParams(tableData, 'PMScoreUnN', 'totalWorkTime')
                } else {
                  this.dimension1CSAveStar = 0
                  this.dimension1GPEvaStar = 0
                  this.dimension2CSAveStar = 0
                  this.dimension2GPEvaStar = 0
                }
                // 显示第一个已提交的用户信息
                for (let i = 0; i < tableData.length; i++) {
                  if (tableData[i].submitStatus !== 0) {
                    tableData[i].isShow = true
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
                      if (tableData[i].conclusionEva.length > 0) {
                        this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                          return evaItem.dimension === 1
                        })))
                        this.buildProTeamStar = JSON.parse(JSON.stringify(tableData[i].conclusionEva.find(evaItem => {
                          return evaItem.dimension === 2
                        })))
                      }
                    }
                    if (AMEvaScoreData.length > 0) {
                      // 显示组员平均评价星级和组长评价星级
                      this.dimension1CSAveStar = Number(tableData[i].newPMData.dimension1CSAveStar.toFixed(2))
                      this.dimension1GPEvaStar = Number(tableData[i].newPMData.dimension1GPEvaStar.toFixed(2))
                      this.dimension2CSAveStar = Number(tableData[i].newPMData.dimension2CSAveStar.toFixed(2))
                      this.dimension2GPEvaStar = Number(tableData[i].newPMData.dimension2GPEvaStar.toFixed(2))
                    }
                    break
                  }
                }
                this.PMData = tableData
                console.log('this.PMData')
                console.log(JSON.parse(JSON.stringify(this.PMData)))
                this.forceRefresh = false
                this.$nextTick(() => {
                  this.forceRefresh = true
                })
                this.getDataLoading = true
              })
            }
          })
        }
      })
    },
    // 获取并生成表格数据
    genTableData (conclusionYear, conclusionMonth, usersList) {
      // 初始化默认数据
      let allconclusionAndEvaData = []
      // 根据当前用户类型生成待评价用户列表
      for (let user of usersList) {
        if (store.state.userInfo.groupName === '技术标准组' || store.state.userInfo.groupName === '工程组') {
          if (user.groupName === '技术标准组' || user.groupName === '工程组') {
            let obj = {
              id: user.id,
              name: user.name,
              groupName: user.groupName,
              groupID: user.groupID,
              duty: user.duty,
              job: user.job,
              submitStatus: 0,
              evaStatus: 0,
              conclusionContent: [], // 月总结内容
              isShow: false,
              isEvaAllFinish: true, // 是否已经评价完别人了
              conclusionEva: [], // 当前用户对该用户评价的数据
              newPMData: {
                QYEvaRank: null,
                AMEvaRank: null,
                PMRank: null
              }
            }
            allconclusionAndEvaData.push(obj)
          }
        } else if (store.state.userInfo.groupName === '通信组') {
          if (user.groupName === '通信组') {
            let obj = {
              id: user.id,
              name: user.name,
              groupName: user.groupName,
              groupID: user.groupID,
              duty: user.duty,
              job: user.job,
              submitStatus: 0,
              evaStatus: 0,
              conclusionContent: [],
              isShow: false,
              isEvaAllFinish: true, // 是否已经评价完别人了
              conclusionEva: [],
              newPMData: {
                QYEvaRank: null,
                AMEvaRank: null,
                PMRank: null
              }
            }
            allconclusionAndEvaData.push(obj)
          }
        } else {
          let obj = {
            id: user.id,
            name: user.name,
            groupName: user.groupName,
            groupID: user.groupID,
            duty: user.duty,
            job: user.job,
            submitStatus: 0,
            evaStatus: 0,
            conclusionContent: [],
            isShow: false,
            isEvaAllFinish: true, // 是否已经评价完别人了
            conclusionEva: [],
            newPMData: {
              QYEvaRank: null,
              AMEvaRank: null,
              PMRank: null
            }
          }
          allconclusionAndEvaData.push(obj)
        }
      }
      // 把自己去掉
      allconclusionAndEvaData.splice(allconclusionAndEvaData.findIndex(item => { return item.id === store.state.userInfo.id }), 1)
      // 根据生成的用户列表获取每个用户的月总结数据
      let promise = []
      let count = 0
      for (let item of allconclusionAndEvaData) {
        promise[count++] = getCurMonthConclusionOverviewDataNew(conclusionYear, conclusionMonth, item.id)
      }
      // ======================判断月总结提交状态并对已提交总结的用户获取总结内容对应的自己对该用户的评价结果======================
      return new Promise(function (resolve, reject) {
        Promise.all(promise).then(allResponse => {
          let promise2 = []
          let count2 = 0
          let checkConclusionData = [] // 有发送查询评价结果的月总结数据
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            // 判断月总结提交状态
            if (allResponse[i].data.length !== 0) { // 已提交月总结
              allconclusionAndEvaData[i].submitStatus = allResponse[i].data[0].submitStatus // 月总结提交状态
              // 对已经提交总结的用户获取总结内容对应的自己对该用户的评价结果
              if (allconclusionAndEvaData[i].submitStatus === 1) {
                // 月总结内容赋值
                allconclusionAndEvaData[i].conclusionContent = allResponse[i].data
                for (let item of allResponse[i].data) {
                  if (item.dimension === 1 || item.dimension === 2) { // 打造精品工程和建设团队维度才获取评价结果
                    promise2[count2++] = getUserofAchievementToAnotherUser(item.id, store.state.userInfo.id) // 获取当前用户对该用户总结的评价结果
                    checkConclusionData.push(allconclusionAndEvaData[i])
                  }
                }
              }
            } else { // 还未提交月总结
              allconclusionAndEvaData[i].submitStatus = 0
            }
          }
          // ================================把对某个用户的总结评价嵌入表格数据中==============================
          Promise.all(promise2).then(allResponse2 => {
            for (let i = 0; i < allResponse2.length; i++) {
              if (allResponse2[i].length > 0) {
                checkConclusionData[i].conclusionEva.push(allResponse2[i][0])
                checkConclusionData[i].evaStatus = 1
              }
            }
            resolve(allconclusionAndEvaData)
          }).catch(err => {
            reject(err)
          })
        }).catch(err => {
          reject(err)
        })
      })
    },
    // 点击显示(表格1)
    table1HandleShow (row, index) {
      this.curEvaUserName = row.name
      this.table1CurShowIndex = index
      this.PMData[this.table1CurShowIndex].isShow = true
      this.PMData[this.table1PreShowIndex].isShow = false
      console.log('this.PMData[this.table1CurShowIndex]')
      console.log(JSON.parse(JSON.stringify(this.PMData[this.table1CurShowIndex])))
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
      // 如果是经理，将显示的绩效数据设置为初始状态
      if (store.state.userInfo.duty === 1) {
        for (let PMDataItem of this.PMData) {
          PMDataItem.newPMData = PMDataItem.PMData
        }
      }
      // =================设置评价星级=====================
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
            this.buildBoutiqueProjectStar = {
              evaStar: store.state.defaultStar
            }
            this.buildProTeamStar = {
              evaStar: store.state.defaultStar
            }
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
      this.dimension1CSAveStar = Number(this.PMData[this.table1CurShowIndex].newPMData.dimension1CSAveStar.toFixed(2))
      this.dimension1GPEvaStar = Number(this.PMData[this.table1CurShowIndex].newPMData.dimension1GPEvaStar.toFixed(2))
      this.dimension2CSAveStar = Number(this.PMData[this.table1CurShowIndex].newPMData.dimension2CSAveStar.toFixed(2))
      this.dimension2GPEvaStar = Number(this.PMData[this.table1CurShowIndex].newPMData.dimension2GPEvaStar.toFixed(2))
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
    },
    // 打造精品工程星级变化
    handlebuildBoutiqueProjectStarChange () {
      if (store.state.userInfo.duty === 1) {
        let PMDataTmp = JSON.parse(JSON.stringify(this.PMData))
        console.log('PMDataTmp')
        console.log(JSON.parse(JSON.stringify(PMDataTmp)))
        let findResult = PMDataTmp[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
        })
        if (typeof (findResult) !== 'undefined') {
          findResult.evaStar = this.buildBoutiqueProjectStar.evaStar
        }
        let AMEvaScoreData = genAMEvaScoreData(PMDataTmp,
                                  this.evaCoefObj.AMBuildBoutiqueProjectCoef, this.evaCoefObj.AMBuildProTeamCoef,
                                  this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                  this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                  this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData,
                                  this.standAndEngineerGroup.length, this.commuincationGroup.length)
        let userListTmp = JSON.parse(JSON.stringify(this.usersList))
        userListTmp.splice(this.usersList.findIndex(user => { return user.id === store.state.userInfo.id }), 1)
        let newPMData = genPerformanceScore(userListTmp, this.QYEvaScoreData, this.QTEvaScoreData, AMEvaScoreData,
                                this.evaCoefObj)
        //
        for (let initPMDataItem of this.initPMData) {
          let newPMdataFindResult = newPMData.find(newPMDataItem => {
            return newPMDataItem.id === initPMDataItem.id
          })
          newPMdataFindResult.PMRankChange = newPMdataFindResult.PMRank - initPMDataItem.PMRank
        }
        for (let PMdataItem of this.PMData) {
          PMdataItem.newPMData = newPMData.find(newPMDataItem => {
            return newPMDataItem.id === PMdataItem.id
          })
        }
      }
    },
    // 创建专业团队评价星级变化
    handlebuildProTeamStarChange () {
      if (store.state.userInfo.duty === 1) {
        let PMDataTmp = JSON.parse(JSON.stringify(this.PMData))
        let findResult = PMDataTmp[this.table1CurShowIndex].allAMEvaedData.find(item => {
          return item.dimension === 2 && item.evaUserID === store.state.userInfo.id
        })
        if (typeof (findResult) !== 'undefined') {
          findResult.evaStar = this.buildProTeamStar.evaStar
        }
        let AMEvaScoreData = genAMEvaScoreData(PMDataTmp,
                                  this.evaCoefObj.AMBuildBoutiqueProjectCoef, this.evaCoefObj.AMBuildProTeamCoef,
                                  this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                  this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                  this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData,
                                  this.standAndEngineerGroup.length, this.commuincationGroup.length)
        let userListTmp = JSON.parse(JSON.stringify(this.usersList))
        userListTmp.splice(this.usersList.findIndex(user => { return user.id === store.state.userInfo.id }), 1)
        let newPMData = genPerformanceScore(userListTmp, this.QYEvaScoreData, this.QTEvaScoreData, AMEvaScoreData,
                                this.evaCoefObj)
        for (let initPMDataItem of this.initPMData) {
          let newPMdataFindResult = newPMData.find(newPMDataItem => {
            return newPMDataItem.id === initPMDataItem.id
          })
          newPMdataFindResult.PMRankChange = newPMdataFindResult.PMRank - initPMDataItem.PMRank
        }
        for (let PMdataItem of this.PMData) {
          PMdataItem.newPMData = newPMData.find(newPMDataItem => {
            return newPMDataItem.id === PMdataItem.id
          })
        }
      }
    },
    // 点击提交对当前用户的评价并跳转到下一个待评价人
    handleSubmitAndJumpToNext () {
      this.submitEvaDataFlag = false
      let promises = []
      let count = 0
      promises[count++] = submitAMEvaData(store.state.userInfo.id, this.buildBoutiqueProject.id, this.buildBoutiqueProjectStar.evaStar)
      promises[count++] = submitAMEvaData(store.state.userInfo.id, this.buildProTeam.id, this.buildProTeamStar.evaStar)
      Promise.all(promises).then((allResponse) => {
        this.PMData[this.table1CurShowIndex].evaStatus = 1
        this.PMData[this.table1CurShowIndex].isShow = false
        // 如果是经理，删除虚拟构建的评价星级
        if (store.state.userInfo.duty === 1) {
          this.PMData[this.table1CurShowIndex].conclusionEva = []
          for (let PMDataItem of this.PMData) {
            PMDataItem.newPMData.PMRankChange = 0
            PMDataItem.PMData = PMDataItem.newPMData
          }
        }
        // 插入提交的评价数据进当前数组
        let obj = {
          id: allResponse[0].insertId,
          evaStar: this.buildBoutiqueProjectStar.evaStar,
          dimensionID: this.buildBoutiqueProject.id,
          name: store.state.userInfo.name
        }
        this.PMData[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
        this.PMData[this.table1CurShowIndex].allAMEvaedData.findIndex(item => {
          return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
        }).evaStar = this.buildBoutiqueProjectStar.evaStar
        obj.id = allResponse[1].insertId
        obj.evaStar = this.buildProTeamStar.evaStar
        obj.dimensionID = this.buildProTeam.id
        this.PMData[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
        this.PMData[this.table1CurShowIndex].allAMEvaedData.findIndex(item => {
          return item.dimension === 2 && item.evaUserID === store.state.userInfo.id
        }).evaStar = this.buildProTeamStar.evaStar
        this.toDoEvaNum -= 1
        this.doneEvaNum += 1
        Notification.success({
          title: '成功',
          message: '提交成功'
        })
        // 重置默认评价星级
        this.buildBoutiqueProjectStar.evaStar = store.state.defaultStar
        this.buildProTeamStar.evaStar = store.state.defaultStar
        // 跳转到下一个未评价的用户
        let index = this.PMData.findIndex(PMdataItem => {
          return PMdataItem.evaStatus === 0 && PMdataItem.submitStatus === 1
        })
        if (index !== -1) { // 还有未评价的用户
          this.curEvaUserName = this.PMData[index].name
          this.table1CurShowIndex = index
          this.PMData[this.table1CurShowIndex].isShow = true
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
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
          // 显示组员平均评价星级和组长评价星级
          this.dimension1CSAveStar = Number(this.PMData[this.table1CurShowIndex].newPMData.dimension1CSAveStar.toFixed(2))
          this.dimension1GPEvaStar = Number(this.PMData[this.table1CurShowIndex].newPMData.dimension1GPEvaStar.toFixed(2))
          this.dimension2CSAveStar = Number(this.PMData[this.table1CurShowIndex].newPMData.dimension2CSAveStar.toFixed(2))
          this.dimension2GPEvaStar = Number(this.PMData[this.table1CurShowIndex].newPMData.dimension2GPEvaStar.toFixed(2))
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
        findEvaItem.evaStar = this.buildBoutiqueProjectStar.evaStar
        findEvaItem = this.PMData[this.table1CurShowIndex].conclusionEva.find(tableDataItem => {
          return tableDataItem.id === this.buildProTeamStar.id
        })
        findEvaItem.evaStar = this.buildProTeamStar.evaStar
        // 如果是经理，删除虚拟构建的评价星级
        if (store.state.userInfo.duty === 1) {
          for (let PMDataItem of this.PMData) {
            PMDataItem.newPMData.PMRankChange = 0
            PMDataItem.PMData = PMDataItem.newPMData
          }
          this.PMData[this.table1CurShowIndex].allAMEvaedData.findIndex(item => {
            return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
          }).evaStar = this.buildProTeamStar.evaStar
          this.PMData[this.table1CurShowIndex].allAMEvaedData.findIndex(item => {
            return item.dimension === 2 && item.evaUserID === store.state.userInfo.id
          }).evaStar = this.buildProTeamStar.evaStar
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
      // ========================先把绩效信息写入数据库===================
      let promise = []
      let count = 0
      let publishID = this.PMPublishStatusData.length > 0 ? this.PMPublishStatusData[0].id : -1 // 判断该月绩效是否已经发布
      if (publishID === -1) { // 该月绩效还未发布，插入绩效数据
        for (let PMDataItem of this.PMData) {
          promise[count++] = savePMData(this.title, PMDataItem.newPMData)
        }
      } else { // 该月绩效已发布
        if (this.PMPublishStatus) {
          for (let PMDataItem of this.PMData) {
            promise[count++] = updatePMData(PMDataItem.newPMData)
          }
        }
      }
      Promise.all(promise).then(() => {
        // 发布绩效信息
        let applyYear = this.$moment(this.title).year()
        let applyMonth = this.$moment(this.title).month() + 1
        let flagValue = this.PMPublishStatus ? 1 : 0
        publishPMData(applyYear, applyMonth, publishID, flagValue).then((response) => {
          if (this.PMPublishStatusData.length === 0) {
            let obj = {
              id: response.data.insertId,
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
            message: '操作失败'
          })
          this.publistPMDataFlag = true
        })
      }).catch(err => {
        console.log(err)
        Notification.error({
          title: '失败',
          message: '绩效数据上传失败'
        })
        this.publistPMDataFlag = true
      })
    },
    // 日期发生变化
    handleDataChange () {
      if (typeof (Cookies.get('cookieAMEvaPageDate')) !== 'undefined') {
        Cookies.remove('cookieAMEvaPageDate')
      }
      Cookies.set('cookieAMEvaPageDate', this.title)
      this.clearEvaTable()
      this.getDataLoading = false
      let conclusionYear = this.$moment(this.title).year()
      let conclusionMonth = this.$moment(this.title).month() + 1
      this.initData(conclusionYear, conclusionMonth, this.usersList)
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
      // 重置默认评价星级
      this.buildBoutiqueProjectStar.evaStar = store.state.defaultStar
      this.buildProTeamStar.evaStar = store.state.defaultStar
      if (this.table1CurShowIndex !== -1) {
        if (this.PMData[this.table1CurShowIndex].isShow) {
          this.PMData[this.table1CurShowIndex].isShow = false
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
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
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

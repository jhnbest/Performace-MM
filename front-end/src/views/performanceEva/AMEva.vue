<template>
  <div>
    <div class="head-line">
      <el-button size="mini"
                type="danger"
                style="margin-right: 10px"
                @click="handlePreMonth"
                :disabled="!getDataLoading">上月</el-button>
      <el-date-picker
        v-model="title"
        type="month"
        format="yyyy 第 MM 月"
        value-format="yyyy-MM"
        placeholder="选择月"
        style="width: 150px"
        @change="handleDataChange()">
      </el-date-picker>
      <el-button size="mini"
                  type="primary"
                  style="margin-left: 10px"
                  @click="handleNextMonth"
                  :disabled="!getDataLoading">下月</el-button>
    </div>
    <div class="hr-10"></div>
    <div class="head-line">
      <el-row :gutter="5">
        <el-col :xs="14" :sm="14" :md="14" :lg="9" :xl="9">
          <el-table
            v-loading="!getDataLoading"
            :data="PMdata"
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
                <!-- <el-tag :type="scope.row.isEvaAllFinish | isEvaAllFinishFilter" size="medium">{{scope.row.isEvaAllFinish | isEvaAllFinishTextFilter}}</el-tag> -->
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
            <el-table-column label="月总结" align="center" width="80px">
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
                      :height="300"
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
                  <p>组员平均星级：{{dimension1CSAveStar}}</p>
                  <p>组长评价星级：{{dimension1GPEvaStar}}</p>
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
                  <p>组员平均星级：{{dimension2CSAveStar}}</p>
                  <p>组长评价星级：{{dimension2GPEvaStar}}</p>
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
import { getAllWorkTimeList, genQYEvaScoreData, genPerformanceScore } from '@/utils/performance'
import { getAllUserRates, genQualiEvaData } from '@/utils/multual'
import { Notification } from 'element-ui'
import { getUsersList } from '@/utils/users'
import { getCurMonthConclusionOverviewDataNew } from '@/utils/conclusion'
import { getUserofAchievementToAnotherUser,
         submitAMEvaData,
         updateAMEvaData,
         genAMEvaScoreData,
         getUserConclusionEvaedData } from '@/utils/achievementEva'
import { getEvaCoef, sortObjectArrayByParams } from '@/utils/common'
import store from '@/store'
export default {
  data () {
    return {
      title: this.$moment().subtract(1, 'months').format('YYYY-MM'), // 日期
      usersList: null, // 用户列表
      getDataLoading: false, // 表格加载标志位,
      submitEvaDataFlag: true, // 提交评价标志位
      updateEvaDataFlag: true, // 更新评价标志位
      PMdata: [], // 表格数据
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
      dimension2GPEvaStar: 0 // 评价维度2组长评价星级
    }
  },
  methods: {
    // 初始化
    init () {
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
            this.PMdata = tableData
            this.forceRefresh = false
            this.$nextTick(() => {
              this.forceRefresh = true
            })
            this.getDataLoading = true
          } else { // 管理者
            let promises = []
            let count = 0
            promises[count++] = getAllWorkTimeList(this.title) // 获取工时申报情况
            promises[count++] = getAllUserRates(usersList, this.title) // 获取定性评价情况
            promises[count++] = getEvaCoef() // 获取各种系数
            // 获取每条月总结对应的所有评价
            for (let tableDataItem of tableData) {
              promises[count++] = getUserConclusionEvaedData(conclusionYear, conclusionMonth, tableDataItem.id)
            }
            Promise.all(promises).then(allResponse => {
              let allWorkTimeList = allResponse[0]
              let allUserRates = allResponse[1]
              this.evaCoefObj = allResponse[2]
              let allAMEvaedData = []
              for (let i = 3; i < allResponse.length; i++) {
                let obj = {
                  evaedUserID: tableData[i - 3].id,
                  evaedUserDuty: tableData[i - 3].duty,
                  evaedUserGroupID: tableData[i - 3].groupID,
                  evaedUserName: tableData[i - 3].name,
                  allAMEvaedData: allResponse[i]
                }
                allAMEvaedData.push(obj)
              }
              let SEGroupEvaedData = []
              let CMGroupEvaedData = []
              // =============================判断各位用户是否已经评价完其他人=========================
              // 被评价的信息按照技术标准组和工程组、通信组分类
              for (let allAMEvaedDataItem of allAMEvaedData) {
                if (allAMEvaedDataItem.evaedUserGroupID === 1 || allAMEvaedDataItem.evaedUserGroupID === 2) {
                  SEGroupEvaedData.push(allAMEvaedDataItem)
                } else if (allAMEvaedDataItem.evaedUserGroupID === 3) {
                  CMGroupEvaedData.push(allAMEvaedDataItem)
                }
              }
              // 根据用户的分组判断是否还有人未评价
              for (let i = 0; i < tableData.length; i++) {
                if (tableData[i].groupName === '技术标准组' || tableData[i].groupName === '工程组') {
                  for (let SEGroupEvaedDataItem of SEGroupEvaedData) {
                    let findIndex = SEGroupEvaedDataItem.allAMEvaedData.findIndex(item => {
                      return item.evaUserID === tableData[i].id
                    })
                    if (findIndex === -1 && SEGroupEvaedDataItem.evaedUserID !== tableData[i].id) {
                      tableData[i].isEvaAllFinish = false
                      break
                    }
                  }
                } else if (tableData[i].groupName === '通信组') {
                  for (let CMGroupEvaedDataItem of CMGroupEvaedData) {
                    let findIndex = CMGroupEvaedDataItem.allAMEvaedData.findIndex(item => {
                      return item.evaUserID === tableData[i].id
                    })
                    if (findIndex === -1 && CMGroupEvaedDataItem.evaedUserID !== tableData[i].id) {
                      tableData[i].isEvaAllFinish = false
                      break
                    }
                  }
                }
              }
              this.QYEvaScoreData = genQYEvaScoreData(usersList, allWorkTimeList, this.title) // 生成定量评价数据
              this.QTEvaScoreData = genQualiEvaData(allUserRates) // 生成定性评价数据
              let AMEvaScoreData = genAMEvaScoreData(allAMEvaedData,
                                    allResponse[2].AMBuildBoutiqueProjectCoef, allResponse[2].AMBuildProTeamCoef,
                                    allResponse[2].CSManagerAMEvaCoef, allResponse[2].CSGroupLeaderAMEvaCoef,
                                    allResponse[2].CScommonStaffAMEvaCoef, allResponse[2].GPManagerAMEvaCoef,
                                    allResponse[2].GPCommonStaffAMEvaCoef, this.QYEvaScoreData) // 生成成效评价数据
              // 把普通员工和组长的平均评价星级插入表格数据
              for (let tableDataItem of tableData) {
                let findResult = AMEvaScoreData.find(AMEvaScoreDataItem => {
                  return AMEvaScoreDataItem.evaedUserID === tableDataItem.id
                })
                tableDataItem.dimension1CSAveStar = findResult.dimension1CSAveStar
                tableDataItem.dimension2CSAveStar = findResult.dimension2CSAveStar
                tableDataItem.dimension1GPEvaStar = findResult.dimension1GPEvaStar
                tableDataItem.dimension2GPEvaStar = findResult.dimension2GPEvaStar
              }
              // ===========================在初始get到的成效评价数据上插入经理评价（如果经理还未评价）=========================
              for (let allAMEvaedDataItem of allAMEvaedData) {
                if (allAMEvaedDataItem.allAMEvaedData.length !== 0) { // 已有人评价这个人
                  let findIndex = allAMEvaedDataItem.allAMEvaedData.findIndex(item => { // 寻找管理者有没有评价了
                    return item.evaUserID === store.state.userInfo.id
                  })
                  if (findIndex === -1) { // 管理者还未评价
                    let AMEvaScoreArrayFindIndex = AMEvaScoreData.findIndex(AMEvaScoreDataItem => {
                      return AMEvaScoreDataItem.evaedUserID === allAMEvaedDataItem.evaedUserID
                    })
                    // 构造打造精品工程的评价
                    let obj = {
                      dimension: 1,
                      dimensionID: allAMEvaedDataItem.allAMEvaedData.find(item => { return item.dimension === 1 }).dimensionID,
                      evaStar: AMEvaScoreData[AMEvaScoreArrayFindIndex].dimension1AveStar,
                      evaUserDuty: store.state.userInfo.duty,
                      evaUserID: store.state.userInfo.id,
                      evaUserName: store.state.userInfo.name,
                      evaedUserDuty: allAMEvaedDataItem.evaedUserDuty,
                      evaedUserGroupID: allAMEvaedDataItem.evaedUserGroupID,
                      evaedUserID: allAMEvaedDataItem.evaedUserID,
                      evaedUserName: allAMEvaedDataItem.evaedUserName
                    }
                    // 把构建的打造精品工程插入评价星级中
                    tableData.find(tableDataItem => {
                      return tableDataItem.id === allAMEvaedDataItem.evaedUserID
                    }).conclusionEva.push(JSON.parse(JSON.stringify(obj)))
                    allAMEvaedDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj))) // 插入对打造精品工程的经理评价
                    // 构造创建专业团队的评价
                    obj.dimension = 2
                    obj.dimensionID = allAMEvaedDataItem.allAMEvaedData.find(item => { return item.dimension === 2 }).dimensionID
                    obj.evaStar = AMEvaScoreData[AMEvaScoreArrayFindIndex].dimension2AveStar
                    allAMEvaedDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj))) // 插入对创建专业团队的经理评价
                    // 把构建的专业团队评价插入评价星级中
                    tableData.find(tableDataItem => {
                      return tableDataItem.id === allAMEvaedDataItem.evaedUserID
                    }).conclusionEva.push(JSON.parse(JSON.stringify(obj)))
                  }
                }
              }
              this.globalAllAmEvaData = JSON.parse(JSON.stringify(allAMEvaedData))
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
                tableDataItem.newPMData = JSON.parse(JSON.stringify(tableDataItem.PMData))
                tableDataItem.PMScoreUnNTmp = tableDataItem.newPMData.PMScoreUnN
                tableDataItem.totalWorkTimeTmp = tableDataItem.newPMData.totalWorkTime
              }
              // 排序
              tableData = sortObjectArrayByParams(tableData, 'PMScoreUnNTmp', 'totalWorkTimeTmp')
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
                  this.dimension1CSAveStar = Number(tableData[i].dimension1CSAveStar.toFixed(2))
                  this.dimension1GPEvaStar = Number(tableData[i].dimension1GPEvaStar.toFixed(2))
                  this.dimension2CSAveStar = Number(tableData[i].dimension2CSAveStar.toFixed(2))
                  this.dimension2GPEvaStar = Number(tableData[i].dimension2GPEvaStar.toFixed(2))
                  break
                }
              }
              this.PMdata = tableData
              this.forceRefresh = false
              this.$nextTick(() => {
                this.forceRefresh = true
              })
              this.getDataLoading = true
            })
          }
        })
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
      // ======================判断月总结提交状态并对已提交总结的用户获取总结内容对应的自己对该用户的评价结果===================================
      return new Promise(function (resolve, reject) {
        Promise.all(promise).then(allResponse => {
          let promise2 = []
          let count2 = 0
          let checkConclusionData = [] // 有发送查询评价结果的月总结数据
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            // 判断月总结提交状态
            if (allResponse[i].data.length !== 0) { // 已提交月总结
              allconclusionAndEvaData[i].submitStatus = allResponse[i].data[0].submitStatus
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
      this.PMdata[this.table1CurShowIndex].isShow = true
      this.PMdata[this.table1PreShowIndex].isShow = false
      this.currentShowUserisEva = this.PMdata[this.table1CurShowIndex].evaStatus === 1
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
        for (let PMDataItem of this.PMdata) {
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
          if (this.PMdata[this.table1CurShowIndex].conclusionEva.length !== 0) {
            this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(this.PMdata[this.table1CurShowIndex].conclusionEva.find(evaItem => {
              return evaItem.dimension === 1
            })))
            this.buildProTeamStar = JSON.parse(JSON.stringify(this.PMdata[this.table1CurShowIndex].conclusionEva.find(evaItem => {
              return evaItem.dimension === 2
            })))
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
      this.dimension1CSAveStar = Number(this.PMdata[this.table1PreShowIndex].dimension1CSAveStar.toFixed(2))
      this.dimension1GPEvaStar = Number(this.PMdata[this.table1PreShowIndex].dimension1GPEvaStar.toFixed(2))
      this.dimension2CSAveStar = Number(this.PMdata[this.table1PreShowIndex].dimension2CSAveStar.toFixed(2))
      this.dimension2GPEvaStar = Number(this.PMdata[this.table1PreShowIndex].dimension2GPEvaStar.toFixed(2))
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
    },
    // 打造精品工程星级变化
    handlebuildBoutiqueProjectStarChange () {
      if (store.state.userInfo.duty === 1) {
        let findIndex1 = this.globalAllAmEvaData.findIndex(item => {
          return item.evaedUserID === this.PMdata[this.table1CurShowIndex].id
        })
        let findIndex2 = this.globalAllAmEvaData[findIndex1].allAMEvaedData.findIndex(item => {
          return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
        })
        this.globalAllAmEvaData[findIndex1].allAMEvaedData[findIndex2].evaStar = this.buildBoutiqueProjectStar.evaStar
        let AMEvaScoreData = genAMEvaScoreData(this.globalAllAmEvaData,
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
        for (let PMdataItem of this.PMdata) {
          PMdataItem.newPMData = newPMData.find(newPMDataItem => {
            return newPMDataItem.id === PMdataItem.id
          })
        }
      }
    },
    // 创建专业团队评价星级变化
    handlebuildProTeamStarChange () {
      if (store.state.userInfo.duty === 1) {
        let findIndex1 = this.globalAllAmEvaData.findIndex(item => {
          return item.evaedUserID === this.PMdata[this.table1CurShowIndex].id
        })
        let findIndex2 = this.globalAllAmEvaData[findIndex1].allAMEvaedData.findIndex(item => {
          return item.dimension === 2 && item.evaUserID === store.state.userInfo.id
        })
        this.globalAllAmEvaData[findIndex1].allAMEvaedData[findIndex2].evaStar = this.buildProTeamStar.evaStar
        let AMEvaScoreData = genAMEvaScoreData(this.globalAllAmEvaData,
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
        for (let PMdataItem of this.PMdata) {
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
        this.PMdata[this.table1CurShowIndex].evaStatus = 1
        this.PMdata[this.table1CurShowIndex].isShow = false
        // 如果是经理，删除虚拟构建的评价星级
        if (store.state.userInfo.duty === 1) {
          this.PMdata[this.table1CurShowIndex].conclusionEva = []
          for (let PMDataItem of this.PMdata) {
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
        this.PMdata[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
        obj.id = allResponse[1].insertId
        obj.evaStar = this.buildProTeamStar.evaStar
        obj.dimensionID = this.buildProTeam.id
        this.PMdata[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
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
        let index = this.PMdata.findIndex(PMdataItem => {
          return PMdataItem.evaStatus === 0 && PMdataItem.submitStatus === 1
        })
        if (index !== -1) { // 还有未评价的用户
          this.curEvaUserName = this.PMdata[index].name
          this.table1CurShowIndex = index
          this.PMdata[this.table1CurShowIndex].isShow = true
          this.table1PreShowIndex = index
          this.buildBoutiqueProject = this.PMdata[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
          })
          this.buildProTeam = this.PMdata[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
          })
          this.nextPlan = this.PMdata[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
          })
          this.curAdvice = this.PMdata[this.table1CurShowIndex].conclusionContent.find(contenItem => {
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
          this.dimension1CSAveStar = Number(this.PMdata[this.table1PreShowIndex].dimension1CSAveStar.toFixed(2))
          this.dimension1GPEvaStar = Number(this.PMdata[this.table1PreShowIndex].dimension1GPEvaStar.toFixed(2))
          this.dimension2CSAveStar = Number(this.PMdata[this.table1PreShowIndex].dimension2CSAveStar.toFixed(2))
          this.dimension2GPEvaStar = Number(this.PMdata[this.table1PreShowIndex].dimension2GPEvaStar.toFixed(2))
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
        let findEvaItem = this.PMdata[this.table1CurShowIndex].conclusionEva.find(tableDataItem => {
          return tableDataItem.id === this.buildBoutiqueProjectStar.id
        })
        findEvaItem.evaStar = this.buildBoutiqueProjectStar.evaStar
        findEvaItem = this.PMdata[this.table1CurShowIndex].conclusionEva.find(tableDataItem => {
          return tableDataItem.id === this.buildProTeamStar.id
        })
        findEvaItem.evaStar = this.buildProTeamStar.evaStar
        // 如果是经理，删除虚拟构建的评价星级
        if (store.state.userInfo.duty === 1) {
          for (let PMDataItem of this.PMdata) {
            PMDataItem.newPMData.PMRankChange = 0
            PMDataItem.PMData = PMDataItem.newPMData
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
    // 日期发生变化
    handleDataChange () {
      this.clearEvaTable()
      this.getDataLoading = false
      let conclusionYear = this.$moment(this.title).year()
      let conclusionMonth = this.$moment(this.title).month() + 1
      this.genTableData(conclusionYear, conclusionMonth, this.usersList).then(tableData => {
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
          this.PMdata = tableData
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
          this.getDataLoading = true
        } else { // 管理者
          let promises = []
          let count = 0
          promises[count++] = getAllWorkTimeList(this.title) // 获取工时申报情况
          promises[count++] = getAllUserRates(this.usersList, this.title) // 获取定性评价情况
          promises[count++] = getEvaCoef() // 获取各种系数
          // 获取每条月总结对应的所有评价
          for (let tableDataItem of tableData) {
            promises[count++] = getUserConclusionEvaedData(conclusionYear, conclusionMonth, tableDataItem.id)
          }
          Promise.all(promises).then(allResponse => {
            let allWorkTimeList = allResponse[0]
            let allUserRates = allResponse[1]
            this.evaCoefObj = allResponse[2]
            let allAMEvaedData = []
            for (let i = 3; i < allResponse.length; i++) {
              let obj = {
                evaedUserID: tableData[i - 3].id,
                evaedUserDuty: tableData[i - 3].duty,
                evaedUserGroupID: tableData[i - 3].groupID,
                evaedUserName: tableData[i - 3].name,
                allAMEvaedData: allResponse[i]
              }
              allAMEvaedData.push(obj)
            }
            let SEGroupEvaedData = []
            let CMGroupEvaedData = []
            // =============================判断各位用户是否已经评价完其他人=========================
            // 被评价的信息按照技术标准组和工程组、通信组分类
            for (let allAMEvaedDataItem of allAMEvaedData) {
              if (allAMEvaedDataItem.evaedUserGroupID === 1 || allAMEvaedDataItem.evaedUserGroupID === 2) {
                SEGroupEvaedData.push(allAMEvaedDataItem)
              } else if (allAMEvaedDataItem.evaedUserGroupID === 3) {
                CMGroupEvaedData.push(allAMEvaedDataItem)
              }
            }
            // 根据用户的分组判断是否还有人未评价
            for (let i = 0; i < tableData.length; i++) {
              if (tableData[i].groupName === '技术标准组' || tableData[i].groupName === '工程组') {
                for (let SEGroupEvaedDataItem of SEGroupEvaedData) {
                  let findIndex = SEGroupEvaedDataItem.allAMEvaedData.findIndex(item => {
                    return item.evaUserID === tableData[i].id
                  })
                  if (findIndex === -1 && SEGroupEvaedDataItem.evaedUserID !== tableData[i].id) {
                    tableData[i].isEvaAllFinish = false
                    break
                  }
                }
              } else if (tableData[i].groupName === '通信组') {
                for (let CMGroupEvaedDataItem of CMGroupEvaedData) {
                  let findIndex = CMGroupEvaedDataItem.allAMEvaedData.findIndex(item => {
                    return item.evaUserID === tableData[i].id
                  })
                  if (findIndex === -1 && CMGroupEvaedDataItem.evaedUserID !== tableData[i].id) {
                    tableData[i].isEvaAllFinish = false
                    break
                  }
                }
              }
            }
            this.QYEvaScoreData = genQYEvaScoreData(this.usersList, allWorkTimeList, this.title) // 生成定量评价数据
            this.QTEvaScoreData = genQualiEvaData(allUserRates) // 生成定性评价数据
            let AMEvaScoreData = genAMEvaScoreData(allAMEvaedData,
                                  allResponse[2].AMBuildBoutiqueProjectCoef, allResponse[2].AMBuildProTeamCoef,
                                  allResponse[2].CSManagerAMEvaCoef, allResponse[2].CSGroupLeaderAMEvaCoef,
                                  allResponse[2].CScommonStaffAMEvaCoef, allResponse[2].GPManagerAMEvaCoef,
                                  allResponse[2].GPCommonStaffAMEvaCoef, this.QYEvaScoreData) // 生成成效评价数据
            // 把普通员工和组长的平均评价星级插入表格数据
            for (let tableDataItem of tableData) {
              let findResult = AMEvaScoreData.find(AMEvaScoreDataItem => {
                return AMEvaScoreDataItem.evaedUserID === tableDataItem.id
              })
              tableDataItem.dimension1CSAveStar = findResult.dimension1CSAveStar
              tableDataItem.dimension2CSAveStar = findResult.dimension2CSAveStar
              tableDataItem.dimension1GPEvaStar = findResult.dimension1GPEvaStar
              tableDataItem.dimension2GPEvaStar = findResult.dimension2GPEvaStar
            }
            // ===========================在初始get到的成效评价数据上插入经理评价（如果经理还未评价）=========================
            for (let allAMEvaedDataItem of allAMEvaedData) {
              if (allAMEvaedDataItem.allAMEvaedData.length !== 0) { // 已有人评价这个人
                let findIndex = allAMEvaedDataItem.allAMEvaedData.findIndex(item => { // 寻找管理者有没有评价了
                  return item.evaUserID === store.state.userInfo.id
                })
                if (findIndex === -1) { // 管理者还未评价
                  let AMEvaScoreArrayFindIndex = AMEvaScoreData.findIndex(AMEvaScoreDataItem => {
                    return AMEvaScoreDataItem.evaedUserID === allAMEvaedDataItem.evaedUserID
                  })
                  // 构造打造精品工程的评价
                  let obj = {
                    dimension: 1,
                    dimensionID: allAMEvaedDataItem.allAMEvaedData.find(item => { return item.dimension === 1 }).dimensionID,
                    evaStar: AMEvaScoreData[AMEvaScoreArrayFindIndex].dimension1AveStar,
                    evaUserDuty: store.state.userInfo.duty,
                    evaUserID: store.state.userInfo.id,
                    evaUserName: store.state.userInfo.name,
                    evaedUserDuty: allAMEvaedDataItem.evaedUserDuty,
                    evaedUserGroupID: allAMEvaedDataItem.evaedUserGroupID,
                    evaedUserID: allAMEvaedDataItem.evaedUserID,
                    evaedUserName: allAMEvaedDataItem.evaedUserName
                  }
                  // 把构建的打造精品工程插入评价星级中
                  tableData.find(tableDataItem => {
                    return tableDataItem.id === allAMEvaedDataItem.evaedUserID
                  }).conclusionEva.push(JSON.parse(JSON.stringify(obj)))
                  allAMEvaedDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj))) // 插入对打造精品工程的经理评价
                  // 构造创建专业团队的评价
                  obj.dimension = 2
                  obj.dimensionID = allAMEvaedDataItem.allAMEvaedData.find(item => { return item.dimension === 2 }).dimensionID
                  obj.evaStar = AMEvaScoreData[AMEvaScoreArrayFindIndex].dimension2AveStar
                  allAMEvaedDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj))) // 插入对创建专业团队的经理评价
                  // 把构建的专业团队评价插入评价星级中
                  tableData.find(tableDataItem => {
                    return tableDataItem.id === allAMEvaedDataItem.evaedUserID
                  }).conclusionEva.push(JSON.parse(JSON.stringify(obj)))
                }
              }
            }
            this.globalAllAmEvaData = JSON.parse(JSON.stringify(allAMEvaedData))
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
              tableDataItem.newPMData = JSON.parse(JSON.stringify(tableDataItem.PMData))
              tableDataItem.PMScoreUnNTmp = tableDataItem.newPMData.PMScoreUnN
              tableDataItem.totalWorkTimeTmp = tableDataItem.newPMData.totalWorkTime
            }
            // 排序
            tableData = sortObjectArrayByParams(tableData, 'PMScoreUnNTmp', 'totalWorkTimeTmp')
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
                this.dimension1CSAveStar = Number(tableData[i].dimension1CSAveStar.toFixed(2))
                this.dimension1GPEvaStar = Number(tableData[i].dimension1GPEvaStar.toFixed(2))
                this.dimension2CSAveStar = Number(tableData[i].dimension2CSAveStar.toFixed(2))
                this.dimension2GPEvaStar = Number(tableData[i].dimension2GPEvaStar.toFixed(2))
                break
              }
            }
            this.PMdata = tableData
            this.forceRefresh = false
            this.$nextTick(() => {
              this.forceRefresh = true
            })
            this.getDataLoading = true
          })
        }
      })
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
        if (this.PMdata[this.table1CurShowIndex].isShow) {
          this.PMdata[this.table1CurShowIndex].isShow = false
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
    submitStatusFilter (status) {
      if (status === 1) {
        return 'success'
      } else if (status === 2) {
        return 'warning'
      } else if (status === 0) {
        return 'danger'
      } else {
        return 'danger'
      }
    },
    submitStatusTextFilter (status) {
      if (status === 1) {
        return '已提交'
      } else if (status === 2) {
        return '暂存'
      } else if (status === 0) {
        return '未提交'
      } else {
        return '错误'
      }
    },
    evaStatusFilter (status) {
      if (status === 1) {
        return 'success'
      } else if (status === 0) {
        return 'danger'
      } else {
        return 'danger'
      }
    },
    evaStatusTextFilter (status) {
      if (status === 1) {
        return '已评价'
      } else if (status === 0) {
        return '未评价'
      } else {
        return '错误'
      }
    },
    isEvaAllFinishFilter (status) {
      if (status) {
        return 'success'
      } else {
        return 'danger'
      }
    },
    isEvaAllFinishTextFilter (status) {
      if (status) {
        return '是'
      } else {
        return '否'
      }
    }
  }
}
</script>
<style scoped>
.head-line{
  padding: 20px;
}
</style>

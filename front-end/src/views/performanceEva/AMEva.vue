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
        <el-col :span="11">
          <el-collapse accordion v-model="activeName" @change="handleCollapseChange()">
            <el-collapse-item name="1">
              <template slot="title">
                <el-badge :value="toDoEvaNum" class="item"><span>待评价</span></el-badge>
              </template>
              <el-table
                v-loading="!getDataLoading"
                :data="PMdata"
                fit
                highlight-current-row
                style="width: 100%;"
                size="mini"
                :height="400"
                ref = "PMDataTable">
                <el-table-column label="姓名" prop="name" align="center" width="60px"></el-table-column>
                <el-table-column label="月总结提交状态" prop="submitStatus" align="center">
                  <template slot-scope="scope">
                    <el-tag :type="scope.row.submitStatus | submitStatusFilter" size="medium">{{scope.row.submitStatus | submitStatusTextFilter}}</el-tag>
                  </template>
                </el-table-column>
                <el-table-column label="是否已全部评价他人" prop="submitStatus" align="center">
                  <template slot-scope="scope">
                    <el-tag :type="scope.row.submitStatus | submitStatusFilter" size="medium">{{scope.row.submitStatus | submitStatusTextFilter}}</el-tag>
                  </template>
                </el-table-column>
                <el-table-column v-if="$store.state.userInfo.duty === 1"
                                 label="工时排名"
                                 prop="QYRank"
                                 align="center" width="50px"></el-table-column>
                <el-table-column v-if="$store.state.userInfo.duty === 1"
                                 label="成效评价排名"
                                 prop="QYRank"
                                 align="center" width="60px"></el-table-column>
                <el-table-column v-if="$store.state.userInfo.duty === 1"
                                 label="绩效排名"
                                 prop="QYRank"
                                 align="center" width="50px"></el-table-column>
                <el-table-column label="月总结" align="center" min-width="90px">
                  <template slot-scope="scope">
                    <el-button v-if="!scope.row.isShow"
                              :disabled="scope.row.submitStatus !== 1"
                              @click="table1HandleShow(scope.row, scope.$index)"
                              size="mini">
                              <span v-if="scope.row.submitStatus === 1">点击显示</span>
                              <span v-else>未提交</span>
                    </el-button>
                    <span v-else>已显示</span>
                  </template>
                </el-table-column>
              </el-table>
            </el-collapse-item>
            <el-collapse-item name="2">
              <template slot="title">
                <el-badge :value="doneEvaNum" class="item"><span>已评价</span></el-badge>
              </template>
              <el-table :data="doneEvaTableData"
                         v-loading="!getDataLoading"
                         fit
                         highlight-current-row
                         style="width: 100%;"
                         size="mini">
                <el-table-column label="姓名" prop="name" align="center" width="60px"></el-table-column>
                <el-table-column v-if="$store.state.userInfo.duty === 1"
                                 label="工时排名"
                                 prop="QYRank"
                                 align="center" width="50px"></el-table-column>
                <el-table-column v-if="$store.state.userInfo.duty === 1"
                                 label="成效评价排名"
                                 prop="QYRank"
                                 align="center" width="60px"></el-table-column>
                <el-table-column v-if="$store.state.userInfo.duty === 1"
                                 label="绩效排名"
                                 prop="QYRank"
                                 align="center" width="50px"></el-table-column>
                <el-table-column label="月总结" align="center">
                  <template slot-scope="scope">
                    <el-button v-if="!scope.row.isShow"
                              :disabled="scope.row.submitStatus === 0"
                              @click="table2HandleShow(scope.row, scope.$index)"
                              size="mini">
                              <span v-if="scope.row.submitStatus === 1">点击显示</span>
                              <span v-else>未提交</span>
                    </el-button>
                    <span v-else>已显示</span>
                  </template>
                </el-table-column>
              </el-table>
            </el-collapse-item>
          </el-collapse>
        </el-col>
        <el-col :span="13">
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
                         @change="handlebuildBoutiqueProjectStarChange(scope.row)" slot="reference"></el-rate>
                </template>
              </el-table-column>
            </el-table>
            <el-table :data="tableData2"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      :height="250"
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
                         @change="handlebuildProTeamStarChange(scope.row)" slot="reference"></el-rate>
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
                  <el-button v-if="activeName === '1' && buildBoutiqueProject.content !== '无数据'"
                             :disabled="!submitEvaDataFlag"
                             type="success"
                             @click="handleSubmitAndJumpToNext()">
                             点击提交对
                             <span style="color: red;font-weight: bold">{{curEvaUserName}}</span>
                             的评价并跳转到下一个待评价人
                  </el-button>
                  <el-button v-if="activeName === '2' && buildBoutiqueProject.content !== '无数据'"
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
         getAchievementEvaOfConclusionDimension,
         genAMEvaScoreData,
         getUserConclusionEvaedData } from '@/utils/achievementEva'
import { getEvaCoef } from '@/utils/common'
import store from '@/store'
export default {
  data () {
    return {
      title: this.$moment().subtract(1, 'months').format('YYYY-MM'), // 日期
      usersList: null, // 用户列表
      getDataLoading: false, // 表格加载标志位,
      submitEvaDataFlag: true, // 提交评价标志位
      updateEvaDataFlag: true, // 更新评价标志位
      fillUPing: true, // 表格加载标志位,
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
      table2CurShowIndex: -1, // 表格2当前显示的用户序号
      table2PreShowIndex: -1, // 表格2之前显示的用户序号
      buildBoutiqueProjectStar: {
        evaStar: store.state.defaultStar
      }, // 打造精品工程默认评价星级
      buildProTeamStar: {
        evaStar: store.state.defaultStar
      }, // 建设专业团队默认评价星级
      toDoEvaNum: 0, // 待评价的人数
      doneEvaNum: 0, // 已评价的人数,
      forceRefresh: true, // 强制刷新
      activeName: '1', // 默认展开的name,
      curEvaUserName: null, // 当前显示的用户姓名
      curShowTable: -1, // 当前显示的表格序号
      standAndEngineerGroup: [], // 工程组和技术标准组成员
      commuincationGroup: [], // 通信组成员,
      globalAllAmEvaData: [], // 存储全局成效评价
      QYEvaScoreData: [], // 存储全局定量评价数据
      QTEvaScoreData: [], // 存储全局定性评价数据
      evaCoefObj: [], // 存储全局各种系数数据
      initPMData: [] // 首次生成的绩效数据
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
        let newCombinaTableData = null
        this.genTableData(conclusionYear, conclusionMonth, usersList).then(tableData => {
          console.log('tableData')
          console.log(tableData)
          newCombinaTableData = tableData.toDoEvaTableData.concat(tableData.doneEvaTableData)
          let toDoEvaTableData = tableData.toDoEvaTableData
          let doneEvaTableData = tableData.doneEvaTableData
          this.toDoEvaNum = toDoEvaTableData.length
          this.doneEvaNum = doneEvaTableData.length
          // 初始化默认显示的数据
          if (toDoEvaTableData.length !== 0) { // 还有未评价的用户
            for (let i = 0; i < toDoEvaTableData.length; i++) {
              if (toDoEvaTableData[i].submitStatus !== 0) {
                toDoEvaTableData[i].isShow = true
                this.curEvaUserName = toDoEvaTableData[i].name
                this.table1CurShowIndex = i
                this.table1PreShowIndex = i
                this.buildBoutiqueProject = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                  return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
                })
                this.buildProTeam = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                  return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
                })
                this.nextPlan = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                  return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
                })
                this.curAdvice = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                  return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
                })
                this.forceRefresh = false
                this.$nextTick(() => {
                  this.forceRefresh = true
                })
                break
              }
            }
          } else { // 用户都已评价
            this.activeName = '2'
            doneEvaTableData[0].isShow = true
            this.curEvaUserName = doneEvaTableData[0].name
            this.table2CurShowIndex = 0
            this.table2PreShowIndex = 0
            this.buildBoutiqueProject = doneEvaTableData[0].conclusionContent.find(contenItem => {
              return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
            })
            this.buildProTeam = doneEvaTableData[0].conclusionContent.find(contenItem => {
              return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
            })
            this.nextPlan = doneEvaTableData[0].conclusionContent.find(contenItem => {
              return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
            })
            this.curAdvice = doneEvaTableData[0].conclusionContent.find(contenItem => {
              return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
            })
            this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(doneEvaTableData[0].conclusionEva.find(evaItem => {
              return evaItem.dimensionID === this.buildBoutiqueProject.id
            })))
            this.buildProTeamStar = JSON.parse(JSON.stringify(doneEvaTableData[0].conclusionEva.find(evaItem => {
              return evaItem.dimensionID === this.buildProTeam.id
            })))
            this.forceRefresh = false
            this.$nextTick(() => {
              this.forceRefresh = true
            })
          }
          // ===============================管理者在此页面需计算所有绩效信息============================
          if (store.state.userInfo.duty === 1) {
            let promises = []
            let count = 0
            promises[count++] = getAllWorkTimeList(this.title)
            promises[count++] = getAllUserRates(usersList, this.title)
            promises[count++] = getEvaCoef()
            // 获取每条月总结对应的所有评价
            for (let newCombinaTableDataItem of newCombinaTableData) {
              promises[count++] = getUserConclusionEvaedData(conclusionYear, conclusionMonth, newCombinaTableDataItem.id)
            }
            Promise.all(promises).then(allResponse => {
              let allWorkTimeList = allResponse[0]
              let allUserRates = allResponse[1]
              this.evaCoefObj = allResponse[2]
              let allAMEvaedData = []
              for (let i = 3; i < allResponse.length; i++) {
                let obj = {
                  evaedUserID: newCombinaTableData[i - 3].id,
                  evaedUserDuty: newCombinaTableData[i - 3].duty,
                  evaedUserGroupID: newCombinaTableData[i - 3].groupID,
                  evaedUserName: newCombinaTableData[i - 3].name,
                  allAMEvaedData: allResponse[i]
                }
                allAMEvaedData.push(obj)
              }
              console.log('allAMEvaedData')
              console.log(allAMEvaedData)
              // 判断各位用户是否已经评价完其他人
              for (let i = 0; i < allAMEvaedData.length; i++) {
                newCombinaTableData[i].evaAllConclusion = allAMEvaedData[i]
                if (newCombinaTableData[i].groupName === '技术标准组' || newCombinaTableData[i].groupName === '工程组') {
                  newCombinaTableData[i].isEvaAllFinish = allAMEvaedData[i].length === this.standAndEngineerGroup.length * 2
                } else if (newCombinaTableData[i].groupName === '通信组') {
                  newCombinaTableData[i].isEvaAllFinish = allAMEvaedData[i].length === this.commuincationGroup.length * 2
                }
              }
              // console.log('newCombinaTableData')
              // console.log(newCombinaTableData)
              this.QYEvaScoreData = genQYEvaScoreData(usersList, allWorkTimeList, this.title)
              this.QTEvaScoreData = genQualiEvaData(allUserRates)
              let AMEvaScoreData = genAMEvaScoreData(allAMEvaedData,
                                    allResponse[2].AMBuildBoutiqueProjectCoef, allResponse[2].AMBuildProTeamCoef,
                                    allResponse[2].CSManagerAMEvaCoef, allResponse[2].CSGroupLeaderAMEvaCoef,
                                    allResponse[2].CScommonStaffAMEvaCoef, allResponse[2].GPManagerAMEvaCoef,
                                    allResponse[2].GPCommonStaffAMEvaCoef, this.QYEvaScoreData,
                                    this.standAndEngineerGroup.length, this.commuincationGroup.length)
              console.log('out AMEvaScoreData')
              console.log(AMEvaScoreData)
              // ===========================在初始get到的成效评价数据上插入经理评价（如果经理还未评价）=========================
              for (let allAMEvaedDataItem of allAMEvaedData) {
                if (allAMEvaedDataItem.allAMEvaedData.length !== 0) { // 已有人评价这个人
                  let findIndex = allAMEvaedDataItem.allAMEvaedData.findIndex(item => {
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
                      evaStar: Number(AMEvaScoreData[AMEvaScoreArrayFindIndex].dimension1AveStar.toFixed(0)),
                      evaUserDuty: store.state.userInfo.duty,
                      evaUserID: store.state.userInfo.id,
                      evaUserName: store.state.userInfo.name,
                      evaedUserDuty: allAMEvaedDataItem.evaedUserDuty,
                      evaedUserGroupID: allAMEvaedDataItem.evaedUserGroupID,
                      evaedUserID: allAMEvaedDataItem.evaedUserID,
                      evaedUserName: allAMEvaedDataItem.evaedUserName
                    }
                    allAMEvaedDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj))) // 插入对打造精品工程的经理评价
                    // 构造创建专业团队的评价
                    obj.dimension = 2
                    obj.dimensionID = allAMEvaedDataItem.allAMEvaedData.find(item => { return item.dimension === 2 }).dimensionID
                    obj.evaStar = Number(AMEvaScoreData[AMEvaScoreArrayFindIndex].dimension2AveStar.toFixed(0))
                    allAMEvaedDataItem.allAMEvaedData.push(JSON.parse(JSON.stringify(obj))) // 插入对创建专业团队的经理评价
                  }
                }
              }
              this.globalAllAmEvaData = JSON.parse(JSON.stringify(allAMEvaedData))
              console.log('this.globalAllAmEvaData')
              console.log(this.globalAllAmEvaData)
              this.initPMData = genPerformanceScore(this.usersList, this.QYEvaScoreData, this.QTEvaScoreData, AMEvaScoreData,
                                 this.evaCoefObj)
              console.log('initPMData')
              console.log(this.initPMData)
            })
          }
          this.PMdata = toDoEvaTableData
          this.doneEvaTableData = doneEvaTableData
          this.getDataLoading = true
        })
      })
    },
    // 获取并生成表格数据
    genTableData (conclusionYear, conclusionMonth, usersList) {
      // 初始化默认数据
      let allconclusionAndEvaData = []
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
              isEvaAllFinish: false, // 是否已经评价完别人了
              conclusionEva: [], // 当前用户对该用户评价的数据
              conclusionAllEva: [], // 月总结被评价的数据
              evaAllConclusion: [] // 评价的所有月总结
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
              isEvaAllFinish: false, // 是否已经评价完别人了
              conclusionEva: [],
              conclusionAllEva: [], // 月总结被评价的数据
              evaAllConclusion: [] // 评价的所有月总结
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
            isEvaAllFinish: false, // 是否已经评价完别人了
            conclusionEva: [],
            conclusionAllEva: [], // 月总结被评价的数据
              evaAllConclusion: [] // 评价的所有月总结
          }
          allconclusionAndEvaData.push(obj)
        }
      }
      allconclusionAndEvaData.splice(allconclusionAndEvaData.findIndex(item => { return item.id === store.state.userInfo.id }), 1) // 把自己去掉
      let promise = []
      let count = 0
      for (let item of allconclusionAndEvaData) {
        promise[count++] = getCurMonthConclusionOverviewDataNew(conclusionYear, conclusionMonth, item.id)
      }
      return new Promise(function (resolve, reject) {
        Promise.all(promise).then(allResponse => {
          console.log('allResponse')
          console.log(allResponse)
          let promise2 = []
          let count2 = 0
          // ======================获取月总结评价结果
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            if (allResponse[i].data.length !== 0) {
              allconclusionAndEvaData[i].submitStatus = allResponse[i].data[0].submitStatus
            } else {
              allconclusionAndEvaData[i].submitStatus = 0
            }
            allconclusionAndEvaData[i].conclusionContent = allResponse[i].data
            if (allResponse[i].data.length > 0) { // 已经填写总结
              for (let item of allResponse[i].data) {
                if (item.dimension === 1 || item.dimension === 2) { // 打造精品工程和建设团队维度才获取评价结果
                  promise2[count2++] = getUserofAchievementToAnotherUser(item.id, store.state.userInfo.id) // 获取当前用户对其他人总结的评价结果
                }
              }
            }
          }
          // 把对某个用户的总结评价嵌入表格数据中
          Promise.all(promise2).then(allResponse2 => {
            let toDoEvaArrayIndex = -1
            for (let item2 of allResponse2) {
              if (item2.length > 0) {
                for (let i = 0; i < allconclusionAndEvaData.length; i++) {
                  for (let j = 0; j < allconclusionAndEvaData[i].conclusionContent.length; j++) {
                    if (allconclusionAndEvaData[i].conclusionContent[j].id === item2[0].dimensionID) {
                      toDoEvaArrayIndex = i
                    }
                  }
                }
                if (toDoEvaArrayIndex !== -1) {
                  allconclusionAndEvaData[toDoEvaArrayIndex].conclusionEva.push(item2[0])
                }
              }
            }
            let toDoEvaTableData = []
            let doneEvaTableData = []
            // 已评价和未评价分类
            for (let allconclusionAndEvaDataItem of allconclusionAndEvaData) {
              if (allconclusionAndEvaDataItem.conclusionEva.length !== 0) { // 已评价
                allconclusionAndEvaDataItem.evaStatus = 1
                doneEvaTableData.push(allconclusionAndEvaDataItem)
              } else { // 未评价
                toDoEvaTableData.push(allconclusionAndEvaDataItem)
              }
            }
            resolve({
              toDoEvaTableData: toDoEvaTableData,
              doneEvaTableData: doneEvaTableData
            })
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
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
    },
    // 点击显示（表格2）
    table2HandleShow (row, index) {
      this.curEvaUserName = row.name
      this.table2CurShowIndex = index
      this.doneEvaTableData[this.table2CurShowIndex].isShow = true
      this.doneEvaTableData[this.table2PreShowIndex].isShow = false
      this.table2PreShowIndex = index
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
      this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(row.conclusionEva.find(evaItem => {
        return evaItem.dimensionID === this.buildBoutiqueProject.id
      })))
      this.buildProTeamStar = JSON.parse(JSON.stringify(row.conclusionEva.find(evaItem => {
        return evaItem.dimensionID === this.buildProTeam.id
      })))
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
    },
    // 打造精品工程
    handlebuildBoutiqueProjectStarChange () {
      if (store.state.userInfo.duty === 1) {
        console.log('this.globalAllAmEvaData')
        console.log(this.globalAllAmEvaData)
        if (this.activeName === '1') {
          console.log('this.PMdata[this.table1CurShowIndex]')
          console.log(this.PMdata[this.table1CurShowIndex])
          let findIndex1 = this.globalAllAmEvaData.findIndex(item => {
            return item.evaedUserID === this.PMdata[this.table1CurShowIndex].id
          })
          console.log('findIndex1')
          console.log(findIndex1)
          let findIndex2 = this.globalAllAmEvaData[findIndex1].allAMEvaedData.findIndex(item => {
            return item.dimension === 1 && item.evaUserID === store.state.userInfo.id
          })
          if (findIndex2 === -1) { // 管理者还未评价
            let obj = {
              dimension: 1,
              evaStar: this.buildBoutiqueProjectStar.evaStar,
              evaUserDuty: store.state.userInfo.duty,
              evaUserID: store.state.userInfo.id,
              evaUserName: store.state.userInfo.name,
              evaedUserDuty: this.PMdata[this.table1CurShowIndex].duty,
              evaedUserGroupID: this.PMdata[this.table1CurShowIndex].groupID,
              evaedUserName: this.PMdata[this.table1CurShowIndex].name
            }
            this.globalAllAmEvaData[findIndex1].allAMEvaedData.push(obj)
            console.log('this.globalAllAmEvaData')
            console.log(this.globalAllAmEvaData)
          } else { // 管理者已评价
            this.globalAllAmEvaData[findIndex1].allAMEvaedData[findIndex2].evaStar = this.buildBoutiqueProjectStar.evaStar
          }
          let AMEvaScoreData = genAMEvaScoreData(this.globalAllAmEvaData,
                                    this.evaCoefObj.AMBuildBoutiqueProjectCoef, this.evaCoefObj.AMBuildProTeamCoef,
                                    this.evaCoefObj.CSManagerAMEvaCoef, this.evaCoefObj.CSGroupLeaderAMEvaCoef,
                                    this.evaCoefObj.CScommonStaffAMEvaCoef, this.evaCoefObj.GPManagerAMEvaCoef,
                                    this.evaCoefObj.GPCommonStaffAMEvaCoef, this.QYEvaScoreData,
                                    this.standAndEngineerGroup.length, this.commuincationGroup.length)
          let PMData = genPerformanceScore(this.usersList, this.QYEvaScoreData, this.QTEvaScoreData, AMEvaScoreData,
                                 this.evaCoefObj)
          console.log('PMData')
          console.log(PMData)
          for (let initPMDataItem of this.initPMData) {
            let findIndex = PMData.findIndex(PMDataItem => {
            })
          }
        } else if (this.activeName === '2') {
          console.log(this.doneEvaTableData[this.table2CurShowIndex])
        }
      }
    },
    // 创建专业团队评价星级变化
    handlebuildProTeamStarChange () {
      if (store.state.userInfo.duty === 1) {
        console.log('this.globalAllAmEvaData')
        console.log(this.globalAllAmEvaData)
        if (this.activeName === '1') {
          console.log(this.PMdata[this.table1CurShowIndex])
        } else if (this.activeName === '2') {
          console.log(this.doneEvaTableData[this.table2CurShowIndex])
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
        // 插入提交的评价数据进当前数组
        let obj = {
          id: allResponse[0].id,
          evaStar: this.buildBoutiqueProjectStar.evaStar,
          dimensionID: this.buildBoutiqueProject.id,
          name: store.state.userInfo.name
        }
        this.PMdata[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
        obj.id = allResponse[1].id
        obj.evaStar = this.buildProTeamStar.evaStar
        obj.dimensionID = this.buildProTeam.id
        this.PMdata[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
        this.doneEvaTableData.push(this.PMdata[this.table1CurShowIndex])
        this.PMdata.splice(this.table1CurShowIndex, 1)
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
        console.log('index')
        console.log(index)
        console.log('this.PMdata')
        console.log(this.PMdata)
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
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
        } else { // 都已评价
        this.table1CurShowIndex = -1
        this.table1PreShowIndex = -1
          this.clearEvaTable()
          Notification.info({
            title: '成功',
            message: '已全部评价完成'
          })
        }
        this.submitEvaDataFlag = true
      }).catch(err => {
        Notification.error({
          title: '失败',
          message: '提交失败'
        })
        this.submitEvaDataFlag = true
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
        let findEvaItem = this.doneEvaTableData[this.table2CurShowIndex].conclusionEva.find(doneEvaItem => {
          return doneEvaItem.id === this.buildBoutiqueProjectStar.id
        })
        findEvaItem.evaStar = this.buildBoutiqueProjectStar.evaStar
        findEvaItem = this.doneEvaTableData[this.table2CurShowIndex].conclusionEva.find(doneEvaItem => {
          return doneEvaItem.id === this.buildProTeamStar.id
        })
        findEvaItem.evaStar = this.buildProTeamStar.evaStar
        Notification.success({
          title: '成功',
          message: '更新成功'
        })
        this.updateEvaDataFlag = true
      }).catch(err => {
        Notification.error({
          title: '失败',
          message: '更新失败'
        })
        this.updateEvaDataFlag = true
        console.log(err)
      })
    },
    // 折叠面板切换
    handleCollapseChange () {
      if (Number(this.activeName) === 1) { // 展开待评价页面
        if (this.PMdata.length !== 0) { // 还有未评价的用户
          // 重置默认评价星级
          this.buildBoutiqueProjectStar.evaStar = store.state.defaultStar
          this.buildProTeamStar.evaStar = store.state.defaultStar
          for (let i = 0; i < this.PMdata.length; i++) {
            if (this.PMdata[i].submitStatus !== 0) {
              this.PMdata[i].isShow = true
              this.curEvaUserName = this.PMdata[i].name
              this.table1CurShowIndex = i
              this.table1PreShowIndex = i
              this.buildBoutiqueProject = this.PMdata[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
              })
              this.buildProTeam = this.PMdata[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
              })
              this.nextPlan = this.PMdata[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
              })
              this.curAdvice = this.PMdata[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
              })
              this.forceRefresh = false
              this.$nextTick(() => {
                this.forceRefresh = true
              })
              break
            }
          }
        } else {
          this.clearEvaTable()
        }
      } else if (Number(this.activeName) === 2) { // 展开已评价页面
        this.clearEvaTable()
        if (this.doneEvaTableData.length !== 0) {
          this.doneEvaTableData[0].isShow = true
          this.curEvaUserName = this.doneEvaTableData[0].name
          this.table2CurShowIndex = 0
          this.table2PreShowIndex = 0
          this.buildBoutiqueProject = this.doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
          })
          this.buildProTeam = this.doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
          })
          this.nextPlan = this.doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
          })
          this.curAdvice = this.doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
          })
          this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(this.doneEvaTableData[0].conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.buildBoutiqueProject.id
          })))
          this.buildProTeamStar = JSON.parse(JSON.stringify(this.doneEvaTableData[0].conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.buildProTeam.id
          })))
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
        } else {
          this.clearEvaTable()
        }
      } else if (this.activeName === '') { // 全部折叠
        this.clearEvaTable()
      }
    },
    // 日期发生变化
    handleDataChange () {
      this.clearEvaTable()
      this.getDataLoading = false
      let conclusionYear = this.$moment(this.title).year()
      let conclusionMonth = this.$moment(this.title).month() + 1
      this.genTableData(conclusionYear, conclusionMonth, this.usersList).then(tableData => {
        let toDoEvaTableData = tableData.toDoEvaTableData
        let doneEvaTableData = tableData.doneEvaTableData
        this.toDoEvaNum = toDoEvaTableData.length
        this.doneEvaNum = doneEvaTableData.length
        // 初始化默认显示的数据
        if (toDoEvaTableData.length !== 0) { // 还有未评价的用户
          for (let i = 0; i < toDoEvaTableData.length; i++) {
            if (toDoEvaTableData[i].submitStatus !== 0) {
              toDoEvaTableData[i].isShow = true
              this.curEvaUserName = toDoEvaTableData[i].name
              this.table1CurShowIndex = i
              this.table1PreShowIndex = i
              this.buildBoutiqueProject = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
              })
              this.buildProTeam = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
              })
              this.nextPlan = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
              })
              this.curAdvice = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
              })
              this.forceRefresh = false
              this.$nextTick(() => {
                this.forceRefresh = true
              })
              break
            }
          }
        } else { // 用户都已评价
          doneEvaTableData[0].isShow = true
          this.curEvaUserName = doneEvaTableData[0].name
          this.table2CurShowIndex = 0
          this.table2PreShowIndex = 0
          this.buildBoutiqueProject = doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
          })
          this.buildProTeam = doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
          })
          this.nextPlan = doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
          })
          this.curAdvice = doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.curAdvice.dimension
          })
          this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(doneEvaTableData[0].conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.buildBoutiqueProject.id
          })))
          this.buildProTeamStar = JSON.parse(JSON.stringify(doneEvaTableData[0].conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.buildProTeam.id
          })))
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
        }
        this.PMdata = toDoEvaTableData
        this.doneEvaTableData = doneEvaTableData
        this.getDataLoading = true
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
      if (this.table2CurShowIndex !== -1) {
        if (this.doneEvaTableData[this.table2CurShowIndex].isShow) {
          this.doneEvaTableData[this.table2CurShowIndex].isShow = false
          this.table2CurShowIndex = -1
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
    }
  }
}
</script>
<style scoped>
.head-line{
  padding: 20px;
}
</style>

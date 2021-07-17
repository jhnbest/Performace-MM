<template>
<div>
  <el-form class="main-search" :inline="true">
    <el-row type="flex">
      <el-col :xs="12" :sm="12" :lg="9" :xl="6">
<!--        年份选择-->
        <el-form-item label="年份选择：" prop="title">
          <el-button size="mini"
                     type="danger"
                     style="margin-right: 10px"
                     @click="handlePreYear"
                     :disabled="!reqFlag.getUserRates">去年</el-button>
          <el-date-picker
            v-model="formData.title"
            type="year"
            format="yyyy年"
            value-format="yyyy"
            placeholder="选择年份"
            style="width: 120px"
            @change="handelDateChange">
          </el-date-picker>
          <el-button size="mini"
                     type="primary"
                     style="margin-left: 10px"
                     @click="handleNextYear"
                     :disabled="!reqFlag.getUserRates">明年</el-button>
        </el-form-item>
      </el-col>
<!--      填报说明-->
      <el-col :xs="2" :sm="2" :lg="{span: 3, pull: 1}" :xl="{span: 3, pull: 0}" style="margin-top: 10px">
        <el-popover
          placement="bottom"
          width="470"
          trigger="click">
          <span>1、查看评价标准，了解评价衡量标准以及分值对应的评价星级；</span><br>
          <span>2、点击评价对象相应评价项下的星星，完成该评价项的评分(未点击默认按照3颗星计算分值)</span>；<br>
          <span>3、完成对所有评价对象的所有评价项的评分，点击提交按钮即可；</span><br>
          <span>4、若需要更改当月的评价，则直接修改相应的星星，然后点击更新即可；</span><br>
          <span>5、每月
            <span style="font-weight: bolder;color: red">3日0点前</span>，
            需完成对处室相关成员的评价。若未提交当月评价，
            <span style="font-weight: bolder;color: red">则默认按照上一月份的评价数据计算</span>；
          </span><br>
          <span>6、评价截止时间过后，将<span style="font-weight: bolder;color: red">不能</span>修改当月评价。</span><br>
          <span slot="reference" class="pointer-type"><i class="el-icon-warning-outline"></i>填报说明</span>
        </el-popover>
      </el-col>
<!--      提交和更新按钮-->
<!--      <el-col :xs="12" :sm="12" :lg="{span: 4, offset: 8 }" :xl="{span: 3, offset: 12 }">-->
<!--        <el-button type="primary" @click="submitRatesResult" :disabled="isRated">-->
<!--          <span v-if="!isRated">提交</span>-->
<!--          <span v-else>已提交</span>-->
<!--        </el-button>-->
<!--        <el-button type="success"-->
<!--                   :disabled="!isRated || !isChanged || !reqFlag.updateRateToUpdate"-->
<!--                   @click="updateRateTableData">更新</el-button>-->
<!--      </el-col>-->
    </el-row>
  </el-form>
  <!-- 分割线 start -->
  <div class="hr-10"></div>
  <!-- 分割线 end -->
  <br>
<!--  月总结表格-->
  <div>
    <el-table :data="rateTableData"
              border
              style="margin: auto; width: 99%"
              :span-method="rateTableMethod"
              stripe
              size="medium"
              :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }"
              v-loading="!reqFlag.getUsersList"
              :height="tableHeight"
              ref="rateTable"
              highlight-current-row>
      <el-table-column label="月份" align="center" prop="month" min-width="50"></el-table-column>
      <el-table-column label="总结名称" align="center" prop="conclusionName"></el-table-column>
      <el-table-column label="状态" align="center">
        <template slot-scope="scope">
          <el-tag :type="scope.row.submitStatus | submitStatusFilter" size="medium">
            <span>{{scope.row.submitStatus | submitStatusTextFilter}}</span>
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="管理者评分" align="center">
        <template slot-scope="scope">
          <el-rate :disabled="true" v-model="scope.row.getEvaStar" slot="reference" style="size: 50px"></el-rate>
        </template>
      </el-table-column>
      <el-table-column label="获得工时" align="center" prop="getWorkTime" width="100"></el-table-column>
      <el-table-column label="操作" align="center" width="250">
        <template slot-scope="scope">
<!--          点击预览-->
          <el-popover
            placement="left"
            trigger="click">
            <month-conclusion-table ref="monthConclusionTable"></month-conclusion-table>
            <el-button slot="reference"
                       type="primary"
                       size="mini"
                       @click="handlePreview(scope.row, scope.$index)">点击预览</el-button>
          </el-popover>
<!--          编辑-->
          <el-button v-if="!(scope.row.submitStatus === 1)"
                     :disabled="(scope.row.reviewStatus === 1)"
                     size="mini"
                     type="warning"
                     @click="handleEdit(scope.row, scope.$index)"
                     style="margin-left: 10px">编辑</el-button>
<!--          暂存-->
          <el-button v-if="scope.row.submitStatus === 1"
                     :disabled="(scope.row.reviewStatus === 1)"
                     size="mini"
                     type="info"
                     @click="handleTemporary(scope.row, scope.$index)">暂存</el-button>
<!--          提交-->
          <el-button v-if="!(scope.row.submitStatus === 1)"
                     :disabled="(scope.row.reviewStatus === 1)"
                     size="mini"
                     type="success"
                     @click="handleSubmit(scope.row, scope.$index)">提交</el-button>
        </template>
      </el-table-column>
    </el-table>
    <br>
  </div>
</div>
</template>

<script>
  import { getUsersName,
    getUserRates,
    submitRatesResult,
    updateUserRate,
    getCurMutualRate,
    getIsSubmitAllow,
    getIsWorkTimeReviewFinish,
    getAllWorkTimeList,
    getAllUserRates,
    performanceInfoPublish,
    getPerformanceIsPublish,
    getPreMonthEva,
    getCurApplyAbleMonth,
    handleFillMul } from '@/config/interface'
  import CountTo from 'vue-count-to'
  import monthConclusionTable from './childViews/monthConclusionTable'
  export default {
    data () {
      return {
        formData: {
          title: this.$moment().format('YYYY-MM')
        },
        showFlag: {
          descTableShow: false
        },
        descriptionContent: '1、首先查看评价标准，了解',
        rateTableData: [{
          month: '一月份',
          conclusionName: '一月份总结',
          submitStatus: 2,
          getEvaStar: 3,
          getWorkTime: 100
        }],
        users: [],
        defaultStar: 3,
        scoreText: ['82.5', '85', '87.5', '90', '92.5'],
        isRated: false,
        isChanged: false,
        ratesTableTmp: [],
        reqFlag: {
          getUserRates: true,
          getUsersList: true,
          updateRateToUpdate: true,
          getAllWorkTimeList: true,
          getAllUserRates: true,
          getPreMonthEva: true
        },
        ratesTmp: [],
        ratesToUpdate: [],
        ratedArray: [],
        curMutualRate: 0,
        tableHeight: null,
        realTimeShowTableData: [],
        showInstructiongs: false,
        commonStaffMutualCof: this.$store.state.commonStaffMutualCof,
        commonStaffManagerCof: this.$store.state.commonStaffManagerCof,
        commonStaffQuantitativeCof: this.$store.state.commonStaffQuantitativeCof,
        groupLeaderMutualCof: this.$store.state.groupLeaderMutualCof,
        groupLeaderManagerCof: this.$store.state.groupLeaderManagerCof,
        groupLeaderQuantitativeCof: this.$store.state.groupLeaderQuantitativeCof,
        directorMutualCof: this.$store.state.directorMutualCof,
        directorManagerCof: this.$store.state.directorManagerCof,
        directorQuantitativeCof: this.$store.state.directorQuantitativeCof,
        isMultualEvaFinish: false,
        isQuantativeFinish: false,
        multualEvaData: [],
        quantativeData: [],
        isPerformancePublish: false,
        performanceIsPublishInfo: null
      }
    },
    methods: {
      // 初始化
      init () {
        let _this = this
      },
      // 点击预览
      handlePreview () {
      },
      // 编辑月总结
      handleEdit () {
      },
      // 提交月总结
      handleSubmit () {
      },
      // 暂存月总结
      handleTemporary () {
      },
      // 获取当前可申报的月份
      getCurApplyAbleMonth () {
        const url = getCurApplyAbleMonth
        let params = {}
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              resolve(res.data)
            } else {
              reject(res.data)
            }
          }).catch(err => {
            reject(err)
          })
        })
      },
      // 获取当前月份绩效结果是否已公布
      getPerformanceIsPublish () {
        const url = getPerformanceIsPublish
        let params = {
          applyYear: this.$moment(this.formData.title).year(),
          applyMonth: this.$moment(this.formData.title).month() + 1,
          flagType: 'performanceInfoPublish'
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              resolve(res.data)
            } else {
              reject(new Error('getPerformanceIsPublish recv error!'))
            }
          }).catch(err => {
            this.$common.toast(err, 'error', true)
            reject(new Error('getPerformanceIsPublish send error!'))
          })
        })
      },
      // 生成绩效得分与排名数据
      genPerformanceScore (quantativeData, multualEvaData, genType) {
        // =========绩效得分计算============
        for (let item of this.rateTableData) {
          let itemQuantativeScore = quantativeData.find(quantativeDataItem => { // 找出定量数据
            return quantativeDataItem.id === item.ratedPersion
          })
          let itemMultualEvaScore = multualEvaData.find(multualEvaDataItem => { // 找出定性数据
            return multualEvaDataItem.id === item.ratedPersion
          })
          if (itemQuantativeScore && itemMultualEvaScore) {
            if (item.ratedPersion === 7 || item.ratedPersion === 11 || item.ratedPersion === 31) { // 主任岗
              item.performanceScoreTmp = itemQuantativeScore.quantitativeScore * this.directorQuantitativeCof +
                itemMultualEvaScore.mutualScore
              item.staffMutualScoreTmp = itemMultualEvaScore.staffRate
              item.managerScoreTmp = itemMultualEvaScore.managerScore
              item.mangerRateRank = itemMultualEvaScore.managerRateRank
              item.totalWorkTime = Number(itemQuantativeScore.totalWorkTime.toFixed(2))
            } else if (item.ratedPersion === 13 || item.ratedPersion === 17 || item.ratedPersion === 33) { // 组长
              item.performanceScoreTmp = itemQuantativeScore.quantitativeScore * this.groupLeaderQuantitativeCof +
                itemMultualEvaScore.mutualScore
              item.staffMutualScoreTmp = itemMultualEvaScore.staffRate
              item.managerScoreTmp = itemMultualEvaScore.managerScore
              item.mangerRateRank = itemMultualEvaScore.managerRateRank
              item.totalWorkTime = Number(itemQuantativeScore.totalWorkTime.toFixed(2))
            } else { // 普通成员
              item.performanceScoreTmp = itemQuantativeScore.quantitativeScore * this.commonStaffQuantitativeCof +
                itemMultualEvaScore.mutualScore
              item.staffMutualScoreTmp = itemMultualEvaScore.staffRate
              item.managerScoreTmp = itemMultualEvaScore.managerScore
              item.mangerRateRank = itemMultualEvaScore.managerRateRank
              item.totalWorkTime = Number(itemQuantativeScore.totalWorkTime.toFixed(2))
            }
          }
        }
        let rateTableDataTmp = JSON.parse(JSON.stringify(this.rateTableData))
        rateTableDataTmp.sort(this.sortBy('performanceScoreTmp'))
        // =========绩效排名与标准化绩效得分计算============
        let count = 0
        let prePerformanceScoreTmp = -1
        let rankTmp = []
        let count1 = -1
        let count2 = 1
        for (let i = 0; i < rateTableDataTmp.length; i++) { // 把绩效得分相同的人员存进对象数组同一个元素里面
          if (rateTableDataTmp[i].performanceScoreTmp === prePerformanceScoreTmp) {
            rankTmp[count1].push(rateTableDataTmp[i])
          } else {
            count1++
            if (!rankTmp[count1]) {
              rankTmp[count1] = []
            }
            rankTmp[count1].push(rateTableDataTmp[i])
            prePerformanceScoreTmp = rateTableDataTmp[i].performanceScoreTmp
          }
        }
        rateTableDataTmp = []
        for (let i = 0; i < rankTmp.length; i++) {
          rankTmp[i].sort(this.sortBy('totalWorkTime')) // 绩效得分相同的人员根据工时多少进行排序
          for (let j = 0; j < rankTmp[i].length; j++) {
            rateTableDataTmp[count++] = rankTmp[i][j]
          }
        }
        for (let item of rateTableDataTmp) {
          item.performanceRank = count2++ // 绩效排名计算
          if (genType === 'init') {
            item.initPerformanceRank = item.performanceRank
          } else if (genType === 'update') {
            let performanceRankChanges = item.initPerformanceRank - item.performanceRank
            item.performanceRankRise = performanceRankChanges > 0
            item.performanceRankDesc = performanceRankChanges < 0
            item.performanceRankChanges = Math.abs(performanceRankChanges)
          }
          item.performanceScore = this.calGetScore(rateTableDataTmp.length, item.performanceRank)
        }
        for (let item of this.rateTableData) {
          let rateTableDataTmpFindResult = rateTableDataTmp.find(rateTableDataTmpItem => {
            return rateTableDataTmpItem.ratedPersion === item.ratedPersion
          })
          if (rateTableDataTmpFindResult) {
            item.performanceRank = rateTableDataTmpFindResult.performanceRank
            item.initPerformanceRank = rateTableDataTmpFindResult.initPerformanceRank
            item.performanceRankRise = rateTableDataTmpFindResult.performanceRankRise
            item.performanceRankDesc = rateTableDataTmpFindResult.performanceRankDesc
            item.performanceRankChanges = rateTableDataTmpFindResult.performanceRankChanges
            item.performanceScore = rateTableDataTmpFindResult.performanceScore
          }
        }
        if (genType === 'init') {
          this.rateTableData.sort(this.sortAddBy('performanceRank'))
        }
      },
      // 数据排序方法
      compare (params) {
        return function (o, p) {
          let a, b
          if (typeof o === 'object' && typeof p === 'object' && o && p) {
            a = o[params]
            b = p[params]
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
      // 计算定量得分与排名
      calQuantitativeScore (groupWorkTimeList) {
        let totalWorkTimeCal = []
        if (groupWorkTimeList.length > 0) {
          let userID = []
          for (let item of groupWorkTimeList) { // 插入各组员总工时信息
            if (userID.indexOf(item.id) === -1) {
              userID.push(item.id)
              let obj = {
                id: item.id,
                name: item.name,
                totalWorkTime: item.reviewWorkTime
              }
              totalWorkTimeCal.push(obj)
            } else {
              totalWorkTimeCal.find(function (wItem) {
                if (wItem.id === item.id) {
                  wItem.totalWorkTime += item.reviewWorkTime
                  return wItem.totalWorkTime
                }
              })
            }
          }
          totalWorkTimeCal.sort(this.compare('totalWorkTime')) // 根据总工时排序
          let preWorkTime = -1
          let preRank = 1
          let count = 1
          for (let item of totalWorkTimeCal) { // 计算排名
            if (item.totalWorkTime === preWorkTime) {
              item.rank = preRank
            } else {
              item.rank = count
              preRank = count
            }
            count++
            preWorkTime = item.totalWorkTime
          }
          // ==============================计算定量指标得分=======================================
          let length = totalWorkTimeCal.length
          for (let item of totalWorkTimeCal) { // 根据排名计算定量指标得分
            item.quantitativeScore = this.calGetScore(length, item.rank)
          }
        }
        return totalWorkTimeCal
      },
      // 生成定量数据
      genQuantativeData (quantativeData) {
        let allQuantitativeScore = []
        let groupedWorkTimeList = this.groupedWorkTimeList(quantativeData) // 对数据按照小组进行分组
        // ---------计算小组内每个人的工时数、排名和得分---------------
        for (let item of groupedWorkTimeList) {
          item.caledQuantitative = this.calQuantitativeScore(item.workTimeList)
          for (let itemInside of item.caledQuantitative) {
            allQuantitativeScore.push(itemInside)
          }
        }
        for (let item of this.rateTableData) {
          let allQuantitativeScoreFindResult = allQuantitativeScore.find(allQuantitativeScoreItem => {
            return allQuantitativeScoreItem.id === item.ratedPersion
          })
          if (allQuantitativeScoreFindResult) {
            item.quantitativeScore = allQuantitativeScoreFindResult.quantitativeScore
            item.quantitativeRank = allQuantitativeScoreFindResult.rank
          }
        }
        return allQuantitativeScore
      },
      // 生成互评数据
      genMultualEvaData (multualData) {
        let multualRestuls = this.calMutualRatesRank(multualData) // 计算定性评价结果
        for (let item of this.rateTableData) {
          let multualRestulsFindResult = multualRestuls.find(multualRestulsItem => {
            return multualRestulsItem.id === item.ratedPersion
          })
          if (multualRestulsFindResult) {
            item.staffMutualScore = multualRestulsFindResult.staffMutualScore
            item.staffRateRank = multualRestulsFindResult.staffRateRank
            item.multualScoreRaw = multualRestulsFindResult.mutualScore
          }
        }
        return multualRestuls
      },
      // 获取领导评价相关信息
      getManagerResult (id, allUsersRates) {
        for (let item of allUsersRates) {
          if (item.id === id) {
            return { managerRateRank: item.managerRateRank, managerScore: item.managerScore }
          }
        }
      },
      // 定性、定量指标得分计算
      calGetScore (length, rank) {
        if (rank === 1) {
          return 92.5
        }
        if (rank < Number((length * 0.1).toFixed(0)) || rank === Number((length * 0.1).toFixed(0))) {
          return 92.5
        } else if (rank < Number((length * 0.3).toFixed(0)) || rank === Number((length * 0.3).toFixed(0))) {
          return 90
        } else if (rank < Number((length * 0.7).toFixed(0)) || rank === Number((length * 0.7).toFixed(0))) {
          return 87.5
        } else if (rank < Number((length * 0.9).toFixed(0)) || rank === Number((length * 0.9).toFixed(0))) {
          return 85
        } else if (rank < Number((length * 1).toFixed(0)) || rank === Number((length * 1).toFixed(0))) {
          return 82.5
        }
      },
      // 计算定性评价排名与得分
      calMutualRatesRank (allUserRatesTmp) {
        let allUserRates = JSON.parse(JSON.stringify(allUserRatesTmp))
        let managerIndex = allUserRates.findIndex(allUserRatesItem => {
          return allUserRatesItem.id === 26
        })
        if (managerIndex !== -1) {
          allUserRates.splice(managerIndex, 1)
        }
        let standAndEngineerRates = []
        let communicationRates = []
        for (let item of allUserRates) {
          if (item.groupName === '技术标准组' || item.groupName === '工程组') {
            standAndEngineerRates.push(item)
          } else if (item.groupName === '通信组') {
            communicationRates.push(item)
          }
        }
        // =================================定性评价排序===============================================
        // 技术标准组&工程组员工互评排序
        for (let i = 0; i < standAndEngineerRates.length - 1; i++) {
          for (let j = 0; j < standAndEngineerRates.length - 1 - i; j++) {
            if (standAndEngineerRates[j].staffRate < standAndEngineerRates[j + 1].staffRate) {
              [standAndEngineerRates[j], standAndEngineerRates[j + 1]] =
                [standAndEngineerRates[j + 1], standAndEngineerRates[j]]
            }
          }
        }
        // 通信组员工互评排序
        for (let i = 0; i < communicationRates.length - 1; i++) {
          for (let j = 0; j < communicationRates.length - 1 - i; j++) {
            if (communicationRates[j].staffRate < communicationRates[j + 1].staffRate) {
              [communicationRates[j], communicationRates[j + 1]] =
                [communicationRates[j + 1], communicationRates[j]]
            }
          }
        }
        // 全处员工领导评价排序
        for (let i = 0; i < allUserRates.length - 1; i++) {
          for (let j = 0; j < allUserRates.length - 1 - i; j++) {
            if (allUserRates[j].managerRate < allUserRates[j + 1].managerRate) {
              [allUserRates[j], allUserRates[j + 1]] =
                [allUserRates[j + 1], allUserRates[j]]
            }
          }
        }
        // =================================定性评价得分计算===============================================
        // 技术标准组与工程组互评排名&得分计算
        let tmpStaffRate = -1
        let count = 1
        for (let i = 0; i < standAndEngineerRates.length; i++) {
          if (standAndEngineerRates[i].staffRate === tmpStaffRate) {
            standAndEngineerRates[i].staffRateRank = standAndEngineerRates[i - 1].staffRateRank
          } else {
            standAndEngineerRates[i].staffRateRank = count
            tmpStaffRate = standAndEngineerRates[i].staffRate
          }
          count++
          standAndEngineerRates[i].staffMutualScore =
            this.calGetScore(standAndEngineerRates.length, standAndEngineerRates[i].staffRateRank)
        }
        // 通信组互评排名&得分计算
        tmpStaffRate = -1
        count = 1
        for (let i = 0; i < communicationRates.length; i++) {
          if (communicationRates[i].staffRate === tmpStaffRate) {
            communicationRates[i].staffRateRank = communicationRates[i - 1].staffRateRank
          } else {
            communicationRates[i].staffRateRank = count
            tmpStaffRate = communicationRates[i].staffRate
          }
          count++
          communicationRates[i].staffMutualScore =
            this.calGetScore(communicationRates.length, communicationRates[i].staffRateRank)
        }
        // 全处员工领导评价排名&得分计算
        tmpStaffRate = -1
        count = 1
        for (let i = 0; i < allUserRates.length; i++) {
          if (allUserRates[i].managerRate === tmpStaffRate) {
            allUserRates[i].managerRateRank = allUserRates[i - 1].managerRateRank
          } else {
            allUserRates[i].managerRateRank = count
            tmpStaffRate = allUserRates[i].managerRate
          }
          count++
          allUserRates[i].managerScore =
            this.calGetScore(allUserRates.length, allUserRates[i].managerRateRank)
        }
        let allRates = []
        // =================================定性评价结果合并===============================================
        // 合并三个组结果
        for (let item of standAndEngineerRates) {
          let managerResult = this.getManagerResult(item.id, allUserRates)
          item.managerRateRank = managerResult.managerRateRank
          item.managerScore = managerResult.managerScore
          if (item.id === 7 || item.id === 11 || item.id === 31) { // 主任岗
            item.mutualScore = item.staffMutualScore * this.directorMutualCof +
              item.managerScore * this.directorManagerCof
          } else if (item.id === 13 || item.id === 17 || item.id === 33) { // 组长
            item.mutualScore = item.staffMutualScore * this.groupLeaderMutualCof +
              item.managerScore * this.groupLeaderManagerCof
          } else { // 普通成员
            item.mutualScore = item.staffMutualScore * this.commonStaffMutualCof +
              item.managerScore * this.commonStaffManagerCof
          }
          allRates.push(item)
        }
        for (let item of communicationRates) {
          let managerResult = this.getManagerResult(item.id, allUserRates)
          item.managerRateRank = managerResult.managerRateRank
          item.managerScore = managerResult.managerScore
          if (item.id === 7 || item.id === 11 || item.id === 31) { // 主任岗
            item.mutualScore = item.staffMutualScore * this.directorMutualCof +
              item.managerScore * this.directorManagerCof
          } else if (item.id === 13 || item.id === 17 || item.id === 33) { // 组长
            item.mutualScore = item.staffMutualScore * this.groupLeaderMutualCof +
              item.managerScore * this.groupLeaderManagerCof
          } else { // 普通成员
            item.mutualScore = item.staffMutualScore * this.commonStaffMutualCof +
              item.managerScore * this.commonStaffManagerCof
          }
          allRates.push(item)
        }
        return allRates
      },
      // 将获得的信息按小组分类
      groupedWorkTimeList (allWorkTimeList) {
        let groupedWorkTimeList = []
        for (let item of allWorkTimeList) {
          if (item.id !== this.$store.state.managerID) {
            let index = groupedWorkTimeList.findIndex(itemInside => {
              return itemInside.groupID === item.groupID
            })
            if (index === -1) {
              let obj = {
                groupID: item.groupID,
                workTimeList: []
              }
              obj.workTimeList.push(item)
              groupedWorkTimeList.push(obj)
            } else {
              groupedWorkTimeList[index].workTimeList.push(item)
            }
          }
        }
        return groupedWorkTimeList
      },
      // 计算绩效得分
      calPerformanceScore (result) {
        // ========================定量指标计算=========================
        let allQuantitativeScore = []
        let groupedWorkTimeList = this.groupedWorkTimeList(result[0]) // 对数据进行分组
        for (let item of groupedWorkTimeList) {
          item.caledQuantitative = this.calQuantitativeScore(item.workTimeList)
          for (let itemInside of item.caledQuantitative) {
            allQuantitativeScore.push(itemInside)
          }
        }
        // =======================定性指标计算===========================
        let multualRestuls = this.calMutualRatesRank(result[1]) // 计算定性评价结果
        // =======================绩效指标得分计算===========================
        let finalResult = JSON.parse(JSON.stringify(multualRestuls)) // 合并定性评价和定量评价
        for (let item of finalResult) {
          let quantitativeInfo = allQuantitativeScore.find(quantitativeInfo => {
            return item.id === quantitativeInfo.id
          })
          if (quantitativeInfo) { // 当月有工时申报
            item.quantitativeScore = quantitativeInfo.quantitativeScore
            item.quantitativeRank = quantitativeInfo.rank
            if (item.id === this.$store.state.userInfo.id) {
            }
          } else { // 如果当月无任何工时申报
            item.quantitativeScore = 0
            item.quantitativeRank = 0
            if (item.id === this.$store.state.userInfo.id) {
            }
          }
          if (item.id === 7 || item.id === 11 || item.id === 31) { // 主任岗
            item.performanceScore = item.quantitativeScore * this.directorQuantitativeCof + item.mutualScore
          } else if (item.id === 13 || item.id === 17 || item.id === 33) { // 组长
            item.performanceScore = item.quantitativeScore * this.groupLeaderQuantitativeCof + item.mutualScore
          } else { // 普通成员
            item.performanceScore = item.quantitativeScore * this.commonStaffQuantitativeCof + item.mutualScore
          }
          finalResult.sort(this.sortBy('performanceScore'))
        }
        // =========绩效排名计算==========
        let count = 0
        let prePerformanceScore = -1
        let prePerformanceRank = -1
        for (let item of finalResult) {
          if (item.performanceScore === prePerformanceScore) {
            item.performanceRank = prePerformanceRank
          } else {
            item.performanceRank = count
            prePerformanceScore = item.performanceScore
            prePerformanceRank = count
          }
          count++
        }
        return finalResult
      },
      // 排序比较函数
      sortBy (props) {
        return function (a, b) {
          return b[props] - a[props]
        }
      },
      // 排序比较函数(升序)
      sortAddBy (props) {
        return function (a, b) {
          return a[props] - b[props]
        }
      },
      // 获取全处工时信息
      getAllWorkTimeList () {
        const url = getAllWorkTimeList
        if (this.reqFlag.getAllWorkTimeList) {
          this.reqFlag.getAllWorkTimeList = false
          let params = {
            applyMonth: this.formData.title
          }
          let _this = this
          return new Promise(function (resolve, reject) {
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                let recvData = res.data
                _this.reqFlag.getAllWorkTimeList = true
                resolve(recvData)
              } else {
                _this.reqFlag.getAllWorkTimeList = true
                reject(new Error('getAllWorkTimeList recv error'))
              }
            }).catch(() => {
              _this.$common.toast('请求失败', 'error', false)
              reject(new Error('getAllWorkTimeList send error'))
            })
          })
        }
      },
      // 计算个人互评得分
      getMulRated (ratedData) {
        let ratesTableTmp = []
        let manageRate = 0
        let totalRate = 0
        let count = 0
        if (ratedData.length !== 0) {
          for (let item of ratedData) { // 根据评价人将评价项归类
            let index = ratesTableTmp.findIndex((itemInside) => {
              return item.ratePersion === itemInside.ratePersion
            })
            if (index === -1) {
              let obj = {
                ratePersion: item.ratePersion
              }
              obj[this.rateTypeSwitch(item.rateType)] = item.rate
              ratesTableTmp.push(obj)
            } else {
              ratesTableTmp[index][this.rateTypeSwitch(item.rateType)] = item.rate
            }
          }
          for (let item of ratesTableTmp) { // 计算各被评价人总分
            item.totalScore = this.calMultualScoreByScore(item.t1Star, item.t2Star, item.t3Star, item.t4Star,
              item.t5Star, item.t6Star)
            if (item.ratePersion === 26) {
              manageRate = item.totalScore
            } else {
              count++
              totalRate += item.totalScore
            }
          }
        }
        if (manageRate === 0) { // 领导者尚未评价,重置为默认评分
          manageRate = this.calMultualScore(this.defaultStar, this.defaultStar, this.defaultStar,
            this.defaultStar, this.defaultStar, this.defaultStar)
        }
        if (count === 0) {
          count = 1 // 防止NAN
        }
        return {
          staffRate: totalRate / count,
          manageRate: manageRate
        }
      },
      // 获取全处员工互评信息
      getAllUserRates (users) {
        let allUsersRates = []
        const url = getAllUserRates
        let params = {
          usersData: users,
          rateMonth: this.formData.title
        }
        let _this = this
        if (this.reqFlag.getAllUserRates) {
          this.reqFlag.getAllUserRates = false
          return new Promise(function (resolve, reject) {
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                for (let item of res.data) {
                  let obj = {
                    id: item.id,
                    name: item.name,
                    groupName: item.groupName
                  }
                  let getRated = _this.getMulRated(item.ratedData)
                  obj.staffRate = Number(getRated.staffRate.toFixed(3))
                  obj.managerRate = Number(getRated.manageRate.toFixed(3))
                  obj.isRate = item.rateData.length !== 0
                  allUsersRates.push(obj)
                }
                _this.reqFlag.getAllUserRates = true
                resolve(allUsersRates)
              } else {
                reject(new Error('getAllUserRates recv error!'))
              }
            }).catch(err => {
              reject(new Error(err))
            })
          })
        }
      },
      // 获取定量评价结果
      getQuantitativeInfo () {
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.getIsWorkTimeSubmitAllow().then(getIsWorkTimeSubmitAllowRes => { // 判断工时申报是否已经截止
            if (getIsWorkTimeSubmitAllowRes.length > 0) { // 已经截止
              _this.getIsWorkTimeReviewFinish().then(getIsWorkTimeReviewFinishRes => { // 判断工时是否都已审核完毕
                if (getIsWorkTimeReviewFinishRes.length > 0) { // 未审核完毕
                  for (let item of _this.rateTableData) {
                    item.quantitativeScore = '工时未审核完毕'
                    item.quantitativeRank = '工时未审核完毕'
                  }
                  resolve({
                    err: true
                  })
                } else { // 已审核完毕
                  _this.getAllWorkTimeList().then(getAllWorkTimeListRes => {
                    resolve({
                      error: false,
                      content: getAllWorkTimeListRes
                    })
                  }).catch(err => {
                    reject(new Error(err))
                  })
                }
              })
            } else { // 尚未截止
              for (let item of _this.rateTableData) {
                item.quantitativeScore = '工时申报尚未截止'
                item.quantitativeRank = '工时申报尚未截止'
              }
              resolve({
                err: true
              })
            }
          })
        })
      },
      // 判断工时是否都已审核完毕
      getIsWorkTimeReviewFinish () {
        const url = getIsWorkTimeReviewFinish
        let params = {
          applyMonth: this.formData.title
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              resolve(res.data)
            } else {
              this.$common.toast('getIsWorkTimeReviewFinish recv error!', 'error', true)
              reject(new Error('getIsWorkTimeReviewFinish recv error!'))
            }
          }).catch(err => {
            this.$common.toast(err, 'error', true)
            reject(new Error(err))
          })
        })
      },
      // 获取全处互评结果
      getAllMultualEvaResult () {
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.getIsSubmitMultualEvaAllow().then(getIsSubmitMultualEvaAllowRes => { // 判断互评是否已截止
            if (getIsSubmitMultualEvaAllowRes.length > 0) { // 已截止
              _this.getAllUserRates(_this.users).then(getAllUserRatesRes => {
                resolve({
                  error: false,
                  content: getAllUserRatesRes })
              }).catch(getAllUserRatesResErr => {
                reject(new Error('getAllUserRates error' + getAllUserRatesResErr))
              })
            } else { // 未截止
              for (let item of _this.rateTableData) {
                item.staffMutualScore = '互评尚未截止'
                item.staffRateRank = '互评尚未截止'
              }
              resolve({
                err: true
              })
            }
          }).catch(getIsSubmitMultualEvaAllowErr => {
            reject(new Error('getIsSubmitMultualEvaAllow error ' + getIsSubmitMultualEvaAllowErr))
          })
        })
      },
      // 获取当前月份能否申报工时的标志
      getIsWorkTimeSubmitAllow () {
        const url = getIsSubmitAllow
        let params = {
          applyYear: this.$moment(this.formData.title).year(),
          applyMonth: this.$moment(this.formData.title).month() + 1,
          flagType: 'workTimeSubmit'
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              resolve(res.data)
            } else {
              reject(new Error('getIsSubmitAllow recv error!'))
            }
          }).catch(err => {
            this.$common.toast(err, 'error', true)
            reject(new Error('getIsSubmitAllow send error!'))
          })
        })
      },
      // 获取当前月份能否申报互评的标志
      getIsSubmitMultualEvaAllow () {
        const url = getIsSubmitAllow
        let params = {
          applyYear: this.$moment(this.formData.title).year(),
          applyMonth: this.$moment(this.formData.title).month() + 1,
          flagType: 'multualEvaSubmit'
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              resolve(res.data)
            } else {
              reject(new Error('getIsSubmitAllow recv error!'))
            }
          }).catch(err => {
            reject(new Error('getIsSubmitAllow send error!' + err))
          })
        })
      },
      // 计算本人互评分数
      CalMutualRate (param) {
        let flag = 0
        for (let i = 0; i < this.ratedArray.length; i++) {
          if (this.ratedArray[i].ratePersion === param.ratePersion) {
            flag++
            this.ratedArray[i][this.rateTypeSwitch(param.rateType)] = param.rate
            this.ratedArray[i].totalScore = this.calMultualScoreByScore(
              this.ratedArray[i].t1Star,
              this.ratedArray[i].t2Star,
              this.ratedArray[i].t3Star,
              this.ratedArray[i].t4Star,
              this.ratedArray[i].t5Star,
              this.ratedArray[i].t6Star)
            break
          }
        }
        if (!flag) {
          let obj = {
            ratePersion: param.ratePersion,
            t1Star: 0,
            t2Star: 0,
            t3Star: 0,
            t4Star: 0,
            t5Star: 0,
            t6Star: 0,
            totalScore: 0
          }
          obj[this.rateTypeSwitch(param.rateType)] = param.rate
          obj.totalScore = this.calMultualScoreByScore(obj.t1Star, obj.t2Star, obj.t3Star, obj.t4Star,
            obj.t5Star, obj.t6Star)
          this.ratedArray.push(obj)
        }
      },
      // 获取本人互评分数
      getCurMutualRate () {
        const url = getCurMutualRate
        let params = {
          userID: this.$store.state.userInfo.id,
          rateMonth: this.formData.title
        }
        this.ratedArray = []
        this.$http(url, params).then(res => {
          if (res.code === 1) {
            for (let item of res.data) {
              this.CalMutualRate(item)
            }
            let count = 0
            let totalRate = 0
            let manageRate = 0
            for (let item of this.ratedArray) {
              if (item.ratePersion !== 26) {
                count++
                totalRate += item.totalScore
              } else {
                manageRate = item.totalScore
              }
            }
            this.curMutualRate = totalRate / count
          }
        })
      },
      // 星级转评分
      starToRates (star) {
        switch (star) {
          case 5:
            return 92.5
          case 4:
            return 90
          case 3:
            return 87.5
          case 2:
            return 85
          case 1:
            return 82.5
          default:
            return 87.5
        }
      },
      // 评分转星级
      ratesToStar (rates) {
        switch (rates) {
          case 92.5:
            return 5
          case 90:
            return 4
          case 87.5:
            return 3
          case 85:
            return 2
          case 82.5:
            return 1
          default:
            return 4
        }
      },
      // 评分类型转换(文字)
      rateTypeSwitchText (rateType) {
        switch (rateType) {
          case 1:
            return '责任意识'
          case 2:
            return '团队协作'
          case 3:
            return '组织纪律'
          case 4:
            return '计划能力'
          case 5:
            return '执行能力'
          case 6:
            return '综合能力'
          default:
            return '错误'
        }
      },
      // 评分类型转换
      rateTypeSwitch (rateType) {
        switch (rateType) {
          case 1:
            return 't1Star'
          case 2:
            return 't2Star'
          case 3:
            return 't3Star'
          case 4:
            return 't4Star'
          case 5:
            return 't5Star'
          case 6:
            return 't6Star'
          default:
            return 't1Star'
        }
      },
      // 获取评分细则
      getRateDetail (rateType, star) {
        for (let item of this.tableData) {
          if (item.l2 === rateType) {
            if (item.star === star) {
              return item.standard
            }
          }
        }
      },
      // 获取用户列表
      getUsersList () {
        const url = getUsersName
        let params = {}
        let _this = this
        if (this.reqFlag.getUsersList) {
          this.reqFlag.getUsersList = false
          return new Promise(function (resolve, reject) {
            _this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  resolve(res.data.list)
                }
                _this.reqFlag.getUsersList = true
              })
          })
        }
      },
      // 获取互评信息
      getUserRates () {
        const url = getUserRates
        let params = {
          userID: this.$store.state.userInfo.id,
          rateMonth: this.formData.title
        }
        let _this = this
        if (this.reqFlag.getUserRates) {
          this.reqFlag.getUserRates = false
          return new Promise(function (resolve, reject) {
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                resolve(res.data)
              }
              _this.reqFlag.getUserRates = true
            })
          })
        }
      },
      // 计算互评总分(通过各评分类型分数)
      calMultualScoreByScore (t1Score, t2Score, t3Score, t4Score, t5Score, t6Score) {
        let totalScore = t1Score * 0.15 + t2Score * 0.2 + t3Score * 0.1 +
          t4Score * 0.1 + t5Score * 0.3 + t6Score * 0.15
        return totalScore
      },
      // 计算互评总分
      calMultualScore (t1Star, t2Star, t3Star, t4Star, t5Star, t6Star) {
        let t1Score = this.starToRates(t1Star)
        let t2Score = this.starToRates(t2Star)
        let t3Score = this.starToRates(t3Star)
        let t4Score = this.starToRates(t4Star)
        let t5Score = this.starToRates(t5Star)
        let t6Score = this.starToRates(t6Star)
        let totalScore = t1Score * 0.15 + t2Score * 0.2 + t3Score * 0.1 +
          t4Score * 0.1 + t5Score * 0.3 + t6Score * 0.15
        return totalScore
      },
      // 生成用户互评数据
      genRateTableData (users, rates) {
        this.isChanged = false
        this.rateTableData = []
        let curGroupName = this.$store.state.userInfo.groupName
        let curID = this.$store.state.userInfo.id
        if (rates.length === 0) { // 该月还未进行互评
          for (let user of users) {
            if (curGroupName === '技术标准组' || curGroupName === '工程组') {
              if (user.groupName === '技术标准组' || user.groupName === '工程组') {
                if (curID !== user.id) {
                  let obj = {
                    ratedPersion: user.id,
                    ratedName: user.name,
                    t1Star: this.defaultStar,
                    t2Star: this.defaultStar,
                    t3Star: this.defaultStar,
                    t4Star: this.defaultStar,
                    t5Star: this.defaultStar,
                    t6Star: this.defaultStar,
                    quantitativeScore: null,
                    quantitativeRank: null,
                    staffMutualScore: null,
                    staffRateRank: null,
                    performanceScore: null,
                    performanceRank: null,
                    performanceRankRise: false,
                    performanceRankDesc: false,
                    performanceRankChanges: 0,
                    initPerformanceRank: null
                  }
                  obj.totalScore = this.calMultualScore(obj.t1Star, obj.t2Star, obj.t3Star,
                    obj.t4Star, obj.t5Star, obj.t6Star)
                  this.rateTableData.push(obj)
                }
              }
            } else if (curGroupName === '通信组') {
              if (user.groupName === '通信组') {
                if (curID !== user.id) {
                  let obj = {
                    ratedPersion: user.id,
                    ratedName: user.name,
                    t1Star: this.defaultStar,
                    t2Star: this.defaultStar,
                    t3Star: this.defaultStar,
                    t4Star: this.defaultStar,
                    t5Star: this.defaultStar,
                    t6Star: this.defaultStar
                  }
                  obj.totalScore = this.calMultualScore(obj.t1Star, obj.t2Star, obj.t3Star,
                    obj.t4Star, obj.t5Star, obj.t6Star)
                  this.rateTableData.push(obj)
                }
              }
            } else if (curGroupName === '处经理') {
              if (curID !== user.id) {
                let obj = {
                  ratedPersion: user.id,
                  ratedName: user.name,
                  t1Star: this.defaultStar,
                  t2Star: this.defaultStar,
                  t3Star: this.defaultStar,
                  t4Star: this.defaultStar,
                  t5Star: this.defaultStar,
                  t6Star: this.defaultStar,
                  quantitativeScore: null,
                  quantitativeRank: null,
                  staffMutualScore: null,
                  staffRateRank: null,
                  performanceScore: null,
                  performanceRank: null,
                  performanceRankRise: false,
                  performanceRankDesc: false,
                  performanceRankChanges: null,
                  initPerformanceRank: null
                }
                obj.totalScore = this.calMultualScore(obj.t1Star, obj.t2Star, obj.t3Star,
                  obj.t4Star, obj.t5Star, obj.t6Star)
                this.rateTableData.push(obj)
              }
            }
          }
        } else {
          let ratesTableTmp = []
          this.ratesTmp = JSON.parse(JSON.stringify(rates))
          for (let item1 of rates) {
            let index = ratesTableTmp.findIndex(ratesTableTmpItem => {
              return ratesTableTmpItem.ratedPersion === item1.ratedPersion
            })
            if (index === -1) {
              let obj = {
                ratedPersion: item1.ratedPersion,
                ratedName: item1.ratedPersionName,
                quantitativeScore: null,
                quantitativeRank: null,
                staffMutualScore: null,
                staffRateRank: null,
                performanceScore: null,
                performanceRank: null,
                performanceRankRise: false,
                performanceRankDesc: false,
                performanceRankChanges: null,
                initPerformanceRank: null
              }
              obj[this.rateTypeSwitch(item1.rateType)] = this.ratesToStar(item1.rate)
              ratesTableTmp.push(obj)
            } else {
              ratesTableTmp[index][this.rateTypeSwitch(item1.rateType)] = this.ratesToStar(item1.rate)
            }
          }
          for (let item of ratesTableTmp) { // 计算各被评价人总分
            item.totalScore = this.calMultualScore(item.t1Star, item.t2Star, item.t3Star, item.t4Star,
              item.t5Star, item.t6Star)
          }
          this.rateTableData = JSON.parse(JSON.stringify(ratesTableTmp))
          return ratesTableTmp
        }
      },
      // 上一年
      handlePreYear () {
        this.formData.title = this.$moment(this.formData.title).subtract(1, 'year').format('YYYY')
        this.setMonthCookie(this.formData.title, 7)
        this.handelDateChange()
      },
      // 下一年
      handleNextYear () {
        this.formData.title = this.$moment(this.formData.title).add(1, 'year').format('YYYY')
        this.setMonthCookie(this.formData.title, 7)
        this.handelDateChange()
      },
      // 申报月份变化
      handelDateChange () {
        let _this = this
        let promises = []
        let count = 0
        this.isQuantativeFinish = false
        this.isMultualEvaFinish = false
        this.getUserRates().then(res1 => {
          _this.isRated = res1.length !== 0
          _this.genRateTableData(_this.users, res1)
          if (this.$store.state.userInfo.id === 26) {
            this.getPerformanceIsPublish().then(getPerformanceIsPublishRes => {
              this.performanceIsPublishInfo = getPerformanceIsPublishRes
              if (getPerformanceIsPublishRes.length > 0) {
                this.isPerformancePublish = getPerformanceIsPublishRes[0].flagValue === 1
              } else {
                this.isPerformancePublish = false
              }
            }).catch(getPerformanceIsPublishErr => {
              this.isPerformancePublish = false
              this.$common.toast(getPerformanceIsPublishErr, 'error', false)
            })
            promises[count++] = this.getQuantitativeInfo() // 获取定量评价结果
            promises[count++] = this.getAllMultualEvaResult() // 获取全处互评结果
            let genQuantativeDataResult = null
            let genMultualEvaDataResult = null
            Promise.all(promises).then(result => {
              if (!result[0].err) { // 工时已截止且审核完毕
                genQuantativeDataResult = this.genQuantativeData(result[0].content)
                this.quantativeData = JSON.parse(JSON.stringify(genQuantativeDataResult))
              } else {
                this.isQuantativeFinish = false
              }
              if (!result[1].err) { // 互评已截止
                genMultualEvaDataResult = this.genMultualEvaData(result[1].content)
                this.multualEvaData = JSON.parse(JSON.stringify(genMultualEvaDataResult))
              } else {
                this.multualEvaData = []
                this.isMultualEvaFinish = false
              }
              if (!result[0].err && !result[1].err) { // 工时已审核完毕且互评已截止
                this.isQuantativeFinish = true
                this.isMultualEvaFinish = true
                this.genPerformanceScore(genQuantativeDataResult, genMultualEvaDataResult, 'init')
              }
            }).catch(err => {
              this.$common.toast(err, 'error', true)
            })
          }
        })
      },
      // 表格合并方法
      objectSpanMethod ({ row, column, rowIndex, columnIndex }) {
        if (columnIndex === 0) {
          if (rowIndex === 0) {
            return {
              rowspan: 15,
              colspan: 1
            }
          } else if (rowIndex < 15) {
            return {
              rowspan: 0,
              colspan: 0
            }
          } else if (rowIndex === 15) {
            return {
              rowspan: 15,
              colspan: 1
            }
          } else {
            return {
              rowspan: 0,
              colspan: 0
            }
          }
        }
        if (columnIndex === 1) {
          if (rowIndex === 0) {
            return {
              rowspan: 5,
              colspan: 1
            }
          } else if (rowIndex < 5) {
            return {
              rowspan: 0,
              colspan: 0
            }
          } else if (rowIndex === 5) {
            return {
              rowspan: 5,
              colspan: 1
            }
          } else if (rowIndex < 10) {
            return {
              rowspan: 0,
              colspan: 0
            }
          } else if (rowIndex === 10) {
            return {
              rowspan: 5,
              colspan: 1
            }
          } else if (rowIndex < 15) {
            return {
              rowspan: 0,
              colspan: 0
            }
          } else if (rowIndex === 15) {
            return {
              rowspan: 5,
              colspan: 1
            }
          } else if (rowIndex < 20) {
            return {
              rowspan: 0,
              colspan: 0
            }
          } else if (rowIndex === 20) {
            return {
              rowspan: 5,
              colspan: 1
            }
          } else if (rowIndex < 25) {
            return {
              rowspan: 0,
              colspan: 0
            }
          } else if (rowIndex === 25) {
            return {
              rowspan: 5,
              colspan: 1
            }
          } else if (rowIndex < 30) {
            return {
              rowspan: 0,
              colspan: 0
            }
          }
        }
      },
      // 设置cookie
      setCookie (showTable, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'sst' + '=' + showTable + ';path=/;expires=' + exdate.toGMTString()
      },
      // 设置月份cookie
      setMonthCookie (month, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'mMon' + '=' + month + ';path=/;expires=' + exdate.toGMTString()
      },
      // 读取cookie
      getCookie: function () {
        if (document.cookie.length > 0) {
          let arr = document.cookie.split('; ') // 这里显示的格式需要切割一下自己可输出看下
          for (let i = 0; i < arr.length; i++) {
            let arr2 = arr[i].split('=') // 再次切割
            // 判断查找相对应的值
            if (arr2[0] === 'sst') {
              this.showFlag.descTableShow = arr2[1] === 'true'
            }
            if (arr2[0] === 'mMon') {
              this.formData.title = arr2[1]
            }
          }
        }
      },
      // 标准表格显示开关
      handleSwitchChange () {
        this.setCookie(this.showFlag.descTableShow, 7)
        this.refreshTableSize()
      },
      // 评分表格合并方法
      rateTableMethod () {
      },
      // 更新待更新评分数据
      updateRateToUpdate (ratesUpdate) {
        let flag = 0
        for (let i = 0; i < this.ratesToUpdate.length; i++) {
          if (this.ratesToUpdate[i].id === ratesUpdate.id) {
            this.ratesToUpdate[i] = ratesUpdate
            flag++
            break
          }
        }
        if (!flag) { // 没有匹配的数据
          this.ratesToUpdate.push(ratesUpdate)
        }
      },
      // 更新带id的评分数据
      updateRateRawRateData (rateType, ratedPersion, rate) {
        this.isChanged = true
        for (let i = 0; i < this.ratesTmp.length; i++) {
          if (this.ratesTmp[i].rateType === rateType &&
            this.ratesTmp[i].ratedPersion === ratedPersion) {
            this.ratesTmp[i].rate = rate
            this.updateRateToUpdate(this.ratesTmp[i])
            break
          }
        }
      },
      // 更新实时预览表格数据
      updateRealTimeShowTableData (type, star) {
        let rateType = this.rateTypeSwitchText(type)
        let rateDetail = this.getRateDetail(rateType, star)
        let score = this.starToRates(star)
        let obj = {
          rateType: rateType,
          rateDetail: rateDetail,
          star: star,
          score: score
        }
        this.realTimeShowTableData = []
        this.realTimeShowTableData.push(obj)
      },
      // 更新领导评价且更新互评得分
      updateManagerRate (managerRate, ratedPersion) {
        if (this.isMultualEvaFinish && this.isQuantativeFinish) {
          let multualEvaDataFindResult = this.multualEvaData.find(multualEvaDataRes => {
            return multualEvaDataRes.id === ratedPersion
          })
          if (multualEvaDataFindResult) {
            multualEvaDataFindResult.managerRate = managerRate
            this.multualEvaData.sort(this.sortBy('managerRate')) // 根据领导评价排序
            let count = 1
            let preManagerRate = -1
            let preManagerRateRank = -1
            for (let item of this.multualEvaData) {
              if (item.managerRate === preManagerRate) {
                item.managerRateRank = preManagerRateRank
              } else {
                item.managerRateRank = count
                preManagerRateRank = count
                preManagerRate = item.managerRate
              }
              count++
              item.managerScore = this.calGetScore(this.multualEvaData.length, item.managerRateRank)
              if (item.id === 7 || item.id === 11 || item.id === 31) { // 主任岗
                item.mutualScore = item.staffMutualScore * this.directorMutualCof +
                  item.managerScore * this.directorManagerCof
              } else if (item.id === 13 || item.id === 17 || item.id === 33) { // 组长
                item.mutualScore = item.staffMutualScore * this.groupLeaderMutualCof +
                  item.managerScore * this.groupLeaderManagerCof
              } else { // 普通成员
                item.mutualScore = item.staffMutualScore * this.commonStaffMutualCof +
                  item.managerScore * this.commonStaffManagerCof
              }
            }
          }
        }
      },
      // 评分项1星级变化
      handleT1StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(1, row.ratedPersion, this.starToRates(row.t1Star))
        this.updateRealTimeShowTableData(1, row.t1Star)
        if (this.$store.state.userInfo.id === 26) {
          if (this.isQuantativeFinish && this.isMultualEvaFinish) {
            this.updateManagerRate(row.totalScore, row.ratedPersion)
            this.genPerformanceScore(this.quantativeData, this.multualEvaData, 'update')
          }
        }
      },
      // 评分项2星级变化
      handleT2StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(2, row.ratedPersion, this.starToRates(row.t2Star))
        this.updateRealTimeShowTableData(2, row.t2Star)
        if (this.$store.state.userInfo.id === 26) {
          if (this.isQuantativeFinish && this.isMultualEvaFinish) {
            this.updateManagerRate(row.totalScore, row.ratedPersion)
            this.genPerformanceScore(this.quantativeData, this.multualEvaData, 'update')
          }
        }
      },
      // 评分项3星级变化
      handleT3StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(3, row.ratedPersion, this.starToRates(row.t3Star))
        this.updateRealTimeShowTableData(3, row.t3Star)
        if (this.$store.state.userInfo.id === 26) {
          if (this.isQuantativeFinish && this.isMultualEvaFinish) {
            this.updateManagerRate(row.totalScore, row.ratedPersion)
            this.genPerformanceScore(this.quantativeData, this.multualEvaData, 'update')
          }
        }
      },
      // 评分项4星级变化
      handleT4StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(4, row.ratedPersion, this.starToRates(row.t4Star))
        this.updateRealTimeShowTableData(4, row.t4Star)
        if (this.$store.state.userInfo.id === 26) {
          if (this.isQuantativeFinish && this.isMultualEvaFinish) {
            this.updateManagerRate(row.totalScore, row.ratedPersion)
            this.genPerformanceScore(this.quantativeData, this.multualEvaData, 'update')
          }
        }
      },
      // 评分项5星级变化
      handleT5StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(5, row.ratedPersion, this.starToRates(row.t5Star))
        this.updateRealTimeShowTableData(5, row.t5Star)
        if (this.$store.state.userInfo.id === 26) {
          if (this.isQuantativeFinish && this.isMultualEvaFinish) {
            this.updateManagerRate(row.totalScore, row.ratedPersion)
            this.genPerformanceScore(this.quantativeData, this.multualEvaData, 'update')
          }
        }
      },
      // 评分项6星级变化
      handleT6StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(6, row.ratedPersion, this.starToRates(row.t6Star))
        this.updateRealTimeShowTableData(6, row.t6Star)
        if (this.$store.state.userInfo.id === 26) {
          if (this.isQuantativeFinish && this.isMultualEvaFinish) {
            this.updateManagerRate(row.totalScore, row.ratedPersion)
            this.genPerformanceScore(this.quantativeData, this.multualEvaData, 'update')
          }
        }
      },
      // 提交
      submitRatesResult () {
        this.getIsSubmitMultualEvaAllow().then(getIsSubmitMultualEvaAllowRes => {
          if (getIsSubmitMultualEvaAllowRes.length === 0 || this.$store.state.userInfo.id === 26) {
            const url = submitRatesResult
            let params = {
              data: this.rateTableData,
              title: this.formData.title,
              userID: this.$store.state.userInfo.id
            }
            let _this = this
            this.$http(url, params).then(res => {
              if (res.code === 1) {
                _this.isRated = true
                _this.isChanged = false
                this.$common.toast('提交成功', 'success', false)
              }
            })
          } else {
            this.$common.toast(this.formData.title + '月已截止互评', 'error', true)
          }
        }).catch(err => {
          this.$common.toast(err, 'error', true)
        })
      },
      // 更新按钮
      updateRateTableData () {
        this.getIsSubmitMultualEvaAllow().then(getIsSubmitMultualEvaAllowRes => {
          if (getIsSubmitMultualEvaAllowRes.length === 0 || this.$store.state.userInfo.id === 26) {
            const url = updateUserRate
            let params = {
              ratesToUpdate: this.ratesToUpdate
            }
            if (this.reqFlag.updateRateToUpdate) {
              this.reqFlag.updateRateToUpdate = false
              this.$http(url, params).then(res => {
                if (res.code === 1) {
                  this.isChanged = false
                  this.ratesToUpdate = []
                  this.$common.toast('更新成功', 'success', false)
                }
                this.reqFlag.updateRateToUpdate = true
              })
            }
          } else {
            this.$common.toast(this.formData.title + '月已截止互评', 'error', true)
          }
        }).catch(err => {
          this.$common.toast(err, 'error', true)
        })
      },
      // 刷新表格尺寸
      refreshTableSize () {
        this.$nextTick(() => {
          this.tableHeight = window.innerHeight - this.$refs.rateTable.$el.offsetTop - 5
          if (this.tableHeight < 0) {
            this.tableHeight = window.innerHeight - 100
          }
          let _this = this
          window.onresize = function () {
            _this.tableHeight = window.innerHeight - _this.$refs.rateTable.$el.offsetTop - 5
            if (_this.tableHeight < 0) {
              _this.tableHeight = window.innerHeight - 100
            }
          }
        })
      },
      // 是否发布首页绩效信息
      handlePerformancePublish () {
        let flagValue = null
        let flagID = -1
        if (this.isPerformancePublish) { // 发布绩效
          if (this.performanceIsPublishInfo.length > 0) { // 已存在发布绩效信息
            flagID = this.performanceIsPublishInfo[0].id
          }
          flagValue = 1
        } else { // 不发布绩效
          if (this.performanceIsPublishInfo.length > 0) { // 已存在发布绩效信息
            flagID = this.performanceIsPublishInfo[0].id
          }
          flagValue = 0
        }
        const url = performanceInfoPublish
        let params = {
          flagID: flagID,
          applyYear: this.$moment(this.formData.title).year(),
          applyMonth: this.$moment(this.formData.title).month() + 1,
          flagType: 'performanceInfoPublish',
          flagValue: flagValue
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              _this.getPerformanceIsPublish().then(getPerformanceIsPublishRes => {
                _this.performanceIsPublishInfo = getPerformanceIsPublishRes
                if (getPerformanceIsPublishRes.length > 0) {
                  _this.isPerformancePublish = getPerformanceIsPublishRes[0].flagValue === 1
                } else {
                  _this.isPerformancePublish = false
                }
                _this.$common.toast('操作成功', 'success', false)
                resolve(res.data)
              }).catch(getPerformanceIsPublishErr => {
                _this.isPerformancePublish = false
                _this.$common.toast(getPerformanceIsPublishErr, 'error', false)
              })
            } else {
              _this.$common.toast('操作失败' + res.data, 'error', false)
              reject(new Error('getIsSubmitAllow recv error!'))
            }
          }).catch(err => {
            _this.$common.toast('发布失败' + err, 'error', true)
            reject(new Error('getIsSubmitAllow send error!'))
          })
        })
      },
      // 提取上月互评结果
      getPreMonthEva () {
        let promises = []
        let count = 0
        const url = getPreMonthEva
        let params = {
          userID: this.$store.state.userInfo.id,
          rateMonth: this.$moment(this.formData.title).subtract(1, 'months').format('YYYY-MM')
        }
        if (this.reqFlag.getPreMonthEva) {
          this.reqFlag.getPreMonthEva = false
          this.$http(url, params).then(res => {
            if (res.code === 1) {
              if (res.data.length === 0) {
                this.$common.toast('上月未评价', 'error', false)
                this.reqFlag.getPreMonthEva = true
              } else {
                let rateResult = this.genRateTableData(this.users, res.data)
                this.reqFlag.getPreMonthEva = true
                if (this.$store.state.userInfo.id === 26) {
                  this.getPerformanceIsPublish().then(getPerformanceIsPublishRes => {
                    this.performanceIsPublishInfo = getPerformanceIsPublishRes
                    if (getPerformanceIsPublishRes.length > 0) {
                      this.isPerformancePublish = getPerformanceIsPublishRes[0].flagValue === 1
                    } else {
                      this.isPerformancePublish = false
                    }
                  }).catch(getPerformanceIsPublishErr => {
                    this.isPerformancePublish = false
                    this.$common.toast(getPerformanceIsPublishErr, 'error', false)
                  })
                  promises[count++] = this.getQuantitativeInfo() // 获取定量评价结果
                  promises[count++] = this.getAllMultualEvaResult() // 获取全处互评结果
                  let genQuantativeDataResult = null
                  let genMultualEvaDataResult = null
                  Promise.all(promises).then(result => {
                    if (!result[0].err) { // 工时已截止且审核完毕
                      genQuantativeDataResult = this.genQuantativeData(result[0].content)
                      this.quantativeData = JSON.parse(JSON.stringify(genQuantativeDataResult))
                    } else {
                      this.isQuantativeFinish = false
                    }
                    if (!result[1].err) { // 互评已截止
                      for (let rateResultItem of rateResult) {
                        let contentFindResult = result[1].content.find(contentItem => {
                          return rateResultItem.ratedPersion === contentItem.id
                        })
                        if (contentFindResult) {
                          contentFindResult.managerRate = rateResultItem.totalScore
                        }
                      }
                      genMultualEvaDataResult = this.genMultualEvaData(result[1].content)
                      this.multualEvaData = JSON.parse(JSON.stringify(genMultualEvaDataResult))
                    } else {
                      this.multualEvaData = []
                      this.isMultualEvaFinish = false
                    }
                    if (!result[0].err && !result[1].err) { // 工时已审核完毕且互评已截止
                      this.isQuantativeFinish = true
                      this.isMultualEvaFinish = true
                      this.genPerformanceScore(genQuantativeDataResult, genMultualEvaDataResult, 'init')
                    }
                    this.reqFlag.getPreMonthEva = true
                  }).catch(err => {
                    this.$common.toast(err, 'error', true)
                    this.reqFlag.getPreMonthEva = true
                  })
                }
              }
            }
          })
        }
      },
      // 一键填充定性评价
      handleFillMul () {
        const url = handleFillMul
        let params = {
          rateMonth: '2021-06',
          users: this.users
        }
        this.$http(url, params).then(res => {
          if (res.code === 1) {
            this.$common.toast('填充成功', 'success', false)
          }
        })
      }
    },
    filters: {
      submitStatusFilter (status) {
        if (status === 2) {
          return 'success'
        } else if (status === 1) {
          return 'warning'
        } else if (status === 0) {
          return 'info'
        }
      },
      submitStatusTextFilter (status) {
        if (status === 2) {
          return '已提交'
        } else if (status === 1) {
          return '暂存'
        } else if (status === 0) {
          return '未提交'
        }
      },
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
      }
    },
    components: {
      // CountTo
      monthConclusionTable
    },
    created () {
      this.init()
    },
    watch: {
    },
    mounted () {
      this.refreshTableSize()
    },
    name: 'multualEvaluation'
  }
</script>

<style scoped>
</style>

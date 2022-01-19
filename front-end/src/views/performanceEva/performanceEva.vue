<template>
<div>
  <el-form class="main-search" :inline="true">
    <el-row type="flex">
      <el-col :xs="12" :sm="12" :lg="9" :xl="6">
        <el-form-item label="评价月份：" prop="title">
          <el-button size="mini"
                     type="danger"
                     style="margin-right: 10px"
                     @click="handlePreMonth"
                     :disabled="!reqFlag.getUserRates">上月</el-button>
          <el-date-picker
            v-model="formData.title"
            type="month"
            format="yyyy 第 MM 月"
            value-format="yyyy-MM"
            placeholder="选择月"
            style="width: 150px"
            @change="initData">
          </el-date-picker>
          <el-button size="mini"
                     type="primary"
                     style="margin-left: 10px"
                     @click="handleNextMonth"
                     :disabled="!reqFlag.getUserRates">下月</el-button>
        </el-form-item>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="{span: 4, offset: 8 }" :xl="{span: 3, offset: 12 }">
        <el-button type="primary" @click="submitRatesResult" :disabled="isRated">
          <span v-if="!isRated">提交</span>
          <span v-else>已提交</span>
        </el-button>
        <el-button type="success"
                   :disabled="!isRated || !isChanged || !reqFlag.updateRateToUpdate"
                   @click="updateRateTableData">更新</el-button>
      </el-col>
    </el-row>
  </el-form>
  <!-- 分割线 start -->
  <div class="hr-10"></div>
  <!-- 分割线 end -->
  <div>
    <el-form :model="ratioFormData" :rules="ratioFormRules" ref="ratioFormData" :inline="true" class="main-search">
      <el-form-item label="员工互评的定性评价比例">
        <el-input v-model="ratioFormData.CSMutualCoef"
                  :disabled="!reqFlag.getEvaCoef"
                  @change="handleQuantativeRateChange"></el-input>
      </el-form-item>
      <el-form-item label="经理评价的定性评价比例">
        <el-input v-model="ratioFormData.MGEvaCoef"
                  :disabled="!reqFlag.getEvaCoef"
                  @change="handleQuantativeRateChange"></el-input>
      </el-form-item>
      <el-form-item label="定量评价比例">
        <el-input v-model="ratioFormData.quantitativeCoef"
                  :disabled="!reqFlag.getEvaCoef"
                  @change="handleQuantativeRateChange"></el-input>
      </el-form-item>
      <el-form-item label="成效评价比例">
        <el-input v-model="ratioFormData.PMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef"
                  @change="handlePerformanceRateChange"></el-input>
      </el-form-item>
      <br>
      <el-form-item label="经理对普通职员的成效评价比例">
        <el-input v-model="ratioFormData.CSManagerPMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef"
                  @change="handleCommonStaffPerChange"></el-input>
      </el-form-item>
      <el-form-item label="组长对普通职员的成效评价比例">
        <el-input v-model="ratioFormData.CSGroupLeaderPMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef"
                  @change="handleCommonStaffPerChange"></el-input>
      </el-form-item>
      <el-form-item label="普通职员对普通职员的成效评价比例">
        <el-input v-model="ratioFormData.CScommonStaffPMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef"
                  @change="handleCommonStaffPerChange"></el-input>
      </el-form-item>
      <br>
      <el-form-item label="经理对组长的成效评价比例">
        <el-input v-model="ratioFormData.GPManagerPMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef"
                  @change="handleGLManPerCge"></el-input>
      </el-form-item>
      <el-form-item label="普通职员对组长的成效评价比例">
        <el-input v-model="ratioFormData.GPCommonStaffPMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef"
                  @change="handleGLComPerCge"></el-input>
      </el-form-item>
    </el-form>
  </div>
  <div>
    <el-table :data="rateTableData"
              border
              style="margin: auto; width: 99%"
              stripe
              size="large"
              :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }"
              v-loading="!reqFlag.getUsersList"
              :height="tableHeight"
              ref="rateTable"
              highlight-current-row>
      <el-table-column label="姓名" prop="ratedName" align="center" min-width="40"></el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 26" label="定量排名" align="center" prop="quantitativeRank" width="57"></el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 26" label="互评排名" align="center" prop="staffRateRank" width="57"></el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 26" label="领导评价排名" align="center" prop="mangerRateRank" width="57"></el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 26"
                        label="绩效排名"
                        align="center"
                        prop="performanceRank"
                        width="57">
        <template slot-scope="scope">
          <span style="font-weight: bolder;color: red">{{scope.row.performanceRank}}</span>
          <i v-if="scope.row.performanceRankRise" class="el-icon-caret-top" style="color: red"></i>
          <i v-if="scope.row.performanceRankDesc" class="el-icon-caret-bottom" style="color: green"></i>
          <span v-if="scope.row.performanceRankRise || scope.row.performanceRankDesc" style="font-size: 10px">
            {{scope.row.performanceRankChanges}}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="成效评价" align="center">
          <el-table-column label="维度1" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t1Star"
                        @change="handleT1StarChange(scope.row)" slot="reference" style="size: 50px"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度2" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t2Star"
                       @change="handleT2StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度3" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t3Star"
                       @change="handleT3StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度4" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t4Star"
                       @change="handleT4StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度5" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t5Star"
                       @change="handleT5StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度6" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t6Star"
                       @change="handleT6StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
        </el-table-column>
      <el-table-column v-if="$store.state.userInfo.id !== 26" label="总分" align="center" prop="totalScore" min-width="50"></el-table-column>
    </el-table>
    <br>
  </div>
</div>
</template>

<script>
  import {
    getUsersName,
    getUserRates,
    submitRatesResult,
    updateUserRate,
    getCurMutualRate,
    getIsSubmitAllow,
    getIsWorkTimeReviewFinish,
    getAllUserRates,
    urlGetPerformanceRates } from '@/config/interface'
  import { getAllPerformanceRate } from '@/utils/performancerate'
  import { getPerformanceIsPublish, getTypeGlobalFlag, calGetScore, getGlobalFlagByType } from '@/utils/common'
  import { getAllWorkTimeList } from '@/utils/performance'
  import { calPerformanceEvaScore } from '@/utils/performanceEva'
  import { groupName2String } from '@/utils/users'
  import store from '@/store'
  export default {
    data () {
    return {
        formData: {
          title: this.$moment().format('YYYY-MM')
        },
        ratioFormData: {
          CSMutualCoef: null,
          MGEvaCoef: null,
          quantitativeCoef: null,
          PMEvaCoef: null,
          CSManagerPMEvaCoef: null,
          CSGroupLeaderPMEvaCoef: null,
          CScommonStaffPMEvaCoef: null,
          GPManagerPMEvaCoef: null,
          GPCommonStaffPMEvaCoef: null
        },
        ratioFormRules: {
          quantativeRate: [
            { required: true, message: '请输入定量比例', trigger: 'blur' },
            { min: 3, max: 5, message: '长度在 3 到 5 个字符', trigger: 'blur' }]
        },
        showFlag: {
          descTableShow: false
        },
        descriptionContent: '1、首先查看评价标准，了解',
        rateTableData: [],
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
          getAllUserRates: true,
          getPerformanceRates: true,
          getEvaCoef: true
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
        isPerformanceEvaFinish: false,
        multualEvaData: [],
        quantativeData: [],
        performanceEvaData: [],
        isPerformancePublish: false,
        performanceIsPublishInfo: null,
        conclusionDialog: false,
        conclusionTitle: null,
        curConclusion: null,
        nextPlan: null,
        curAdvice: null,
        managerEva: null,
        selectPersionID: null
      }
    },
    methods: {
      // 初始化
      init () {
        this.getCookie()
        // this.getCurMutualRate()
        // this.getCurApplyAbleMonth().then(getCurApplyAbleMonthRes => {
        //   this.formData.title = this.$moment(getCurApplyAbleMonthRes[0].setTime).format('YYYY-MM')
        // })
        this.getEvaCoef()
        // 获取用户列表
        this.getUsersList().then(userList => {
          this.users = userList
          this.initData(userList)
        })
      },
      // 从数据库获取各种评价系数
      getEvaCoef () {
        let promises = []
        let count = 0
        let _this = this
        this.reqFlag.getEvaCoef = false
        promises[count++] = getGlobalFlagByType('CSMutualCoef')
        promises[count++] = getGlobalFlagByType('MGEvaCoef')
        promises[count++] = getGlobalFlagByType('quantitativeCoef')
        promises[count++] = getGlobalFlagByType('PMEvaCoef')
        promises[count++] = getGlobalFlagByType('CSManagerPMEvaCoef')
        promises[count++] = getGlobalFlagByType('CSGroupLeaderPMEvaCoef')
        promises[count++] = getGlobalFlagByType('CScommonStaffPMEvaCoef')
        promises[count++] = getGlobalFlagByType('GPManagerPMEvaCoef')
        promises[count++] = getGlobalFlagByType('GPCommonStaffPMEvaCoef')
        return new Promise(function (resolve, reject) {
          Promise.all(promises).then(result => {
            _this.reqFlag.getEvaCoef = true
            let allEvaCoefExist = true
            for (let item of result) {
              if (item.length === 0) {
                allEvaCoefExist = false
                break
              }
            }
            if (allEvaCoefExist) {
              _this.ratioFormData.CSMutualCoef = result[0][0].flagValue
              _this.ratioFormData.MGEvaCoef = result[1][0].flagValue
              _this.ratioFormData.quantitativeCoef = result[2][0].flagValue
              _this.ratioFormData.PMEvaCoef = result[3][0].flagValue
              _this.ratioFormData.CSManagerPMEvaCoef = result[4][0].flagValue
              _this.ratioFormData.CSGroupLeaderPMEvaCoef = result[5][0].flagValue
              _this.ratioFormData.CScommonStaffPMEvaCoef = result[6][0].flagValue
              _this.ratioFormData.GPManagerPMEvaCoef = result[7][0].flagValue
              _this.ratioFormData.GPCommonStaffPMEvaCoef = result[8][0].flagValue
              resolve(result)
            }
          }).catch(err => {
            _this.$common.toast('getEvaCoef ERR: ' + err, 'error', false)
            reject(err)
          })
        })
      },
      initData (userList) {
        let promises = []
        let count = 0
        let applyYear = this.$moment(this.formData.title).year()
        let applyMonth = this.$moment(this.formData.title).month() + 1
        this.getPerformanceRates().then(performanceRates => { // 获取个人成效评价数据库数据
          this.isRated = performanceRates.length !== 0
          this.rateTableData = JSON.parse(JSON.stringify(this.genRateTableData(userList, performanceRates))) // 成效评价表格数据初始化
          // 管理者角色进行定量、定性和绩效数据的计算
          if (store.state.userInfo.id === 26) {
            getPerformanceIsPublish(applyYear, applyMonth).then(getPerformanceIsPublishRes => {
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
            promises[count++] = this.getAllPerformanceRateResult(this.formData.title, 'performanceRateSubmit', userList) // 获取全处成效评价结果（总）
            promises[count++] = this.getEvaCoef() // 获取各种评价系数
            let genQuantativeDataResult = null
            let genMultualEvaDataResult = null
            let genPerformanceEvaDataResult = null
            Promise.all(promises).then(result => {
              if (!result[0].err) { // 工时已截止且审核完毕
                genQuantativeDataResult = this.genQuantativeData(result[0].content) // 生成定量数据
                this.quantativeData = JSON.parse(JSON.stringify(genQuantativeDataResult))
              } else {
                this.isQuantativeFinish = false
              }
              if (!result[1].err) { // 互评已截止
                genMultualEvaDataResult = this.genMultualEvaData(result[1].content) // 生成互评数据
                this.multualEvaData = JSON.parse(JSON.stringify(genMultualEvaDataResult))
              } else {
                this.multualEvaData = []
                this.isMultualEvaFinish = false
              }
              if (!result[2].err) { // 成效评价已截止
                genPerformanceEvaDataResult = this.genPerformanceEvaData(result[2].content) // 生成互评数据
                this.performanceEvaData = JSON.parse(JSON.stringify(genPerformanceEvaDataResult))
              } else {
                this.performanceEvaData = []
                this.isPerformanceEvaFinish = false
              }
              if (!result[0].err && !result[1].err && !result[2].err) { // 工时已审核完毕、互评已截止、成效评价已截止
                this.isQuantativeFinish = true
                this.isMultualEvaFinish = true
                this.isPerformanceEvaFinish = true
                this.genPerformanceScore(genQuantativeDataResult, genMultualEvaDataResult, genPerformanceEvaDataResult, 'init')
              }
            }).catch(err => {
              this.$common.toast(err, 'error', true)
            })
          }
        })
      },
      // 获取个人成效评价信息
      getPerformanceRates () {
        const url = urlGetPerformanceRates
        let params = {
          ratePersion: this.$store.state.userInfo.id,
          rateMonth: this.formData.title
        }
        let _this = this
        if (this.reqFlag.getPerformanceRates) {
          this.reqFlag.getPerformanceRates = false
          return new Promise(function (resolve, reject) {
            _this.$http(url, params).then(res => {
              if (res.code === 1) {
                resolve(res.data)
              }
              _this.reqFlag.getPerformanceRates = true
            })
          })
        }
      },
      // 获取全处成效评价结果（总）
      getAllPerformanceRateResult (rateTitle, flagType, userList) {
        let _this = this
        return new Promise(function (resolve, reject) {
          getTypeGlobalFlag(_this.$moment(rateTitle).year(), _this.$moment(rateTitle).month() + 1, flagType).then(getTypeGlobalFlagRes => {
            if (getTypeGlobalFlagRes.length === 0) {
              resolve({
                err: true
              }).catch(getTypeGlobalFlagResErr => {
                reject(new Error('getAllPerformanceRateResult' + getTypeGlobalFlagResErr))
              })
            } else {
              getAllPerformanceRate(userList, rateTitle).then(getAllPerformanceRateRes => {
                resolve({
                  err: false,
                  content: getAllPerformanceRateRes
                })
              }).catch(getAllPerformanceRateErr => {
                reject(new Error('getAllPerformanceRate error' + getAllPerformanceRateErr))
              })
            }
          }).catch(getTypeGlobalFlagErr => {
            reject(new Error('getTypeGlobalFlag error' + getTypeGlobalFlagErr))
          })
        })
      },
      // 生成定量数据
      genQuantativeData (quantativeData) {
        let allQuantitativeScore = []
        for (let item of this.users) {
          let findItem = quantativeData.findIndex(quantativeDataItem => {
            return quantativeDataItem.id === item.id
          })
          if (findItem === -1 && item.groupName !== '处经理') {
            let obj = {
              applyMonth: quantativeData[0].applyMonth,
              groupID: item.groupID,
              id: item.id,
              name: item.name,
              reviewWorkTime: 0
            }
            quantativeData.push(obj)
          }
        }
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
          } else {
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
      // 生成成效评价数据
      genPerformanceEvaData (performanceEvaData) {
        console.log('performanceEvaData')
        console.log(JSON.parse(JSON.stringify(performanceEvaData)))
        let PMEvaScoreArr = []
        // ========================根据从成效评价数据库获取的数据计算每个人的成效得分========================
        for (let performanceEvaDataItem of performanceEvaData) {
          let obj = {
            id: performanceEvaDataItem.id,
            name: performanceEvaDataItem.name,
            groupName: performanceEvaDataItem.groupName,
            duty: performanceEvaDataItem.duty,
            isRate: performanceEvaDataItem.rateData.length !== 0
          }
          let ratesTableTmp = []
          let manageRate = 0
          let groupRate = 0
          let totalRate = 0
          let count = 0
          for (let ratedData of performanceEvaDataItem.ratedData) {
            if (ratedData.length !== null) {
              // =======================整理从数据库获取的数据，按照被评价人结合评价项分组=====================
              let index = ratesTableTmp.findIndex((itemInside) => {
                return ratedData.ratePersion === itemInside.ratePersion
              })
              if (index === -1) {
                let obj = {
                  ratePersion: ratedData.ratePersion,
                  duty: ratedData.duty,
                  groupName: groupName2String(ratedData.groupName)
                }
                obj[this.rateTypeSwitch(ratedData.rateType)] = ratedData.rate
                ratesTableTmp.push(obj)
              } else {
                ratesTableTmp[index][this.rateTypeSwitch(ratedData.rateType)] = ratedData.rate
              }
            }
          }
          // ========================计算各被评价人成效评价得分总分===============================
          for (let item of ratesTableTmp) {
            item.totalScore = calPerformanceEvaScore(item.t1Star, item.t2Star, item.t3Star, item.t4Star,
              item.t5Star, item.t6Star)
            if (item.duty === 1) { // 经理评价
              manageRate = item.totalScore
            } else if (item.duty === 2 && (item.groupName === performanceEvaDataItem.groupName)) { // 本组组长评价
              groupRate = item.totalScore
            } else {
              count++
              totalRate += item.totalScore
            }
          }
          // ==============================计算各评价人领导评价和普通员工评价平均分（未标准化的）===============================
          if (manageRate === 0) { // 领导者尚未评价,重置为默认评分
            let defaultRate = this.starToRates(this.defaultStar)
            manageRate = calPerformanceEvaScore(defaultRate, defaultRate, defaultRate,
              defaultRate, defaultRate, defaultRate)
          }
          if (count === 0) {
            count = 1 // 防止NAN
          }
          obj.CSPMEvaScoreAve = Number((totalRate / count).toFixed(3))
          obj.GPPMEvaScoreUnN = Number(groupRate.toFixed(3))
          obj.MGEvaScoreUnN = Number(manageRate.toFixed(3))
          PMEvaScoreArr.push(obj)
        }
        console.log('PMEvaScoreArr')
        console.log(PMEvaScoreArr)
        // =================================按照成员所属组别计算成效标准化得分======================================
        let allPerformanceEvaRates = JSON.parse(JSON.stringify(PMEvaScoreArr))
        let managerIndex = allPerformanceEvaRates.findIndex(allUserRatesItem => {
          return allUserRatesItem.id === 26
        })
        if (managerIndex !== -1) {
          allPerformanceEvaRates.splice(managerIndex, 1)
        }
        // =================成效数据按组别存放=====================
        let standAndEngineerRates = []
        let communicationRates = []
        for (let item of allPerformanceEvaRates) {
          if (item.groupName === '技术标准组' || item.groupName === '工程组') {
            standAndEngineerRates.push(item)
          } else if (item.groupName === '通信组') {
            communicationRates.push(item)
          }
        }
        // ===================成效评价排序=======================
        // 技术标准组&工程组员工互评排序
        for (let i = 0; i < standAndEngineerRates.length - 1; i++) {
          for (let j = 0; j < standAndEngineerRates.length - 1 - i; j++) {
            if (standAndEngineerRates[j].CSPMEvaScoreAve < standAndEngineerRates[j + 1].CSPMEvaScoreAve) {
              [standAndEngineerRates[j], standAndEngineerRates[j + 1]] =
                [standAndEngineerRates[j + 1], standAndEngineerRates[j]]
            }
          }
        }
        // 通信组员工互评排序
        for (let i = 0; i < communicationRates.length - 1; i++) {
          for (let j = 0; j < communicationRates.length - 1 - i; j++) {
            if (communicationRates[j].CSPMEvaScoreAve < communicationRates[j + 1].CSPMEvaScoreAve) {
              [communicationRates[j], communicationRates[j + 1]] =
                [communicationRates[j + 1], communicationRates[j]]
            }
          }
        }
        // 全处员工领导评价排序
        for (let i = 0; i < allPerformanceEvaRates.length - 1; i++) {
          for (let j = 0; j < allPerformanceEvaRates.length - 1 - i; j++) {
            if (allPerformanceEvaRates[j].MGPMEvaScoreUnN < allPerformanceEvaRates[j + 1].MGPMEvaScoreUnN) {
              [allPerformanceEvaRates[j], allPerformanceEvaRates[j + 1]] =
                [allPerformanceEvaRates[j + 1], allPerformanceEvaRates[j]]
            }
          }
        }
        // ====================成效评价得分计算=======================
        // 技术标准组与工程组互评排名计算并根据排名计算标准化成效得分
        let tmpStaffRate = -1
        let count1 = 1
        for (let i = 0; i < standAndEngineerRates.length; i++) {
          if (standAndEngineerRates[i].CSPMEvaScoreAve === tmpStaffRate) {
            standAndEngineerRates[i].CSPMEvaScoreAveRank = standAndEngineerRates[i - 1].CSPMEvaScoreAveRank
          } else {
            standAndEngineerRates[i].CSPMEvaScoreAveRank = count1
            tmpStaffRate = standAndEngineerRates[i].CSPMEvaScoreAve
          }
          count1++
          standAndEngineerRates[i].PMEvaScoreNor =
            calGetScore(standAndEngineerRates.length, standAndEngineerRates[i].CSPMEvaScoreAveRank)
        }
        // 通信组互评排名计算并根据排名计算标准化成效得分
        tmpStaffRate = -1
        count1 = 1
        for (let i = 0; i < communicationRates.length; i++) {
          if (communicationRates[i].CSPMEvaScoreAve === tmpStaffRate) {
            communicationRates[i].CSPMEvaScoreAveRank = communicationRates[i - 1].CSPMEvaScoreAveRank
          } else {
            communicationRates[i].CSPMEvaScoreAveRank = count1
            tmpStaffRate = communicationRates[i].CSPMEvaScoreAve
          }
          count1++
          communicationRates[i].PMEvaScoreNor =
            calGetScore(communicationRates.length, communicationRates[i].CSPMEvaScoreAveRank)
        }
        // 全处员工领导评价排名计算并根据排名计算标准化成效得分
        let tmpMGPMEvaScoreUnN = -1
        count1 = 1
        for (let i = 0; i < allPerformanceEvaRates.length; i++) {
          if (allPerformanceEvaRates[i].MGPMEvaScoreUnN === tmpMGPMEvaScoreUnN) {
            allPerformanceEvaRates[i].MGPMEvaScoreUnNRank = allPerformanceEvaRates[i - 1].MGPMEvaScoreUnNRank
          } else {
            allPerformanceEvaRates[i].MGPMEvaScoreUnNRank = count1
            tmpMGPMEvaScoreUnN = allPerformanceEvaRates[i].MGPMEvaScoreUnN
          }
          count1++
          allPerformanceEvaRates[i].ManagerPMEvaScoreNor =
            calGetScore(allPerformanceEvaRates.length, allPerformanceEvaRates[i].MGPMEvaScoreUnNRank)
        }
        // =================================定性评价结果合并===============================================
        let allRates = standAndEngineerRates.concat(communicationRates)
        return allRates
      },
      // 生成绩效得分与排名数据
      genPerformanceScore (quantativeData, multualEvaData, performanceEvaData, genType) {
        console.log('this.rateTableData')
        console.log(JSON.parse(JSON.stringify(this.rateTableData)))
        console.log('performanceEvaData')
        console.log(performanceEvaData)
        // =========绩效得分计算============
        for (let item of this.rateTableData) {
          let itemQuantativeScore = quantativeData.find(quantativeDataItem => { // 找出定量数据
            return quantativeDataItem.id === item.ratedPersion
          })
          let itemMultualEvaScore = multualEvaData.find(multualEvaDataItem => { // 找出定性数据
            return multualEvaDataItem.id === item.ratedPersion
          })
          let itemPMEvaObj = performanceEvaData.find(performanceEvaDataItem => { // 找出成效评价数据对象
            return performanceEvaDataItem.id === item.ratedPersion
          })
          if (itemQuantativeScore && itemMultualEvaScore && itemPMEvaObj) {
            if (item.duty === 2) {
              item.PMScoreUnN = itemQuantativeScore.quantitativeScore * this.ratioFormData.quantitativeCoef + itemMultualEvaScore.mutualScore
            } else if (item.duty === 3) {
            }
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
          let totalWorkTimeTmp = JSON.parse(JSON.stringify(totalWorkTimeCal))
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
        console.log('standAndEngineerRates')
        console.log(JSON.parse(JSON.stringify(standAndEngineerRates)))
        // =================================定性评价结果合并===============================================
        // 合并三个组结果
        for (let item of standAndEngineerRates) { // 技术标准组和工程组互拼得分计算
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
        for (let item of communicationRates) { // 通信组互评得分计算
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
                for (let item of res.data) { // res.data格式：[{groupName: ; id: ;name: ; rateData: [{}]; ratedData: }, {...}]
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
                  getAllWorkTimeList(_this.formData.title).then(getAllWorkTimeListRes => {
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
      // 生成成效表格初始数据
      genRateTableData (users, rates) {
        this.isChanged = false
        let ratesTableTmp = []
        let curGroupName = this.$store.state.userInfo.groupName
        let curID = this.$store.state.userInfo.id
        if (rates.length === 0) { // 该月还未进行成效评价
          for (let user of users) {
            // if (curGroupName === '技术标准组' || curGroupName === '工程组') {
            if (curGroupName === '技术标准组') {
              if (user.groupName === '技术标准组') {
                if (curID !== user.id) {
                  let obj = {
                    ratedPersion: user.id,
                    ratedName: user.name,
                    duty: user.duty,
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
                  ratesTableTmp.push(obj)
                }
              }
            } else if (curGroupName === '工程组') {
              if (user.groupName === '工程组') {
                if (curID !== user.id) {
                  let obj = {
                    ratedPersion: user.id,
                    ratedName: user.name,
                    duty: user.duty,
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
                  ratesTableTmp.push(obj)
                }
              }
            } else if (curGroupName === '通信组') {
              if (user.groupName === '通信组') {
                if (curID !== user.id) {
                  let obj = {
                    ratedPersion: user.id,
                    ratedName: user.name,
                    duty: user.duty,
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
                  ratesTableTmp.push(obj)
                }
              }
            } else if (curGroupName === '处经理') {
              if (curID !== user.id) {
                let obj = {
                  ratedPersion: user.id,
                  ratedName: user.name,
                  duty: user.duty,
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
                ratesTableTmp.push(obj)
              }
            }
          }
        } else { // 该月已进行成效评价
          this.ratesTmp = JSON.parse(JSON.stringify(rates))
          for (let item1 of rates) {
            let index = ratesTableTmp.findIndex(ratesTableTmpItem => {
              return ratesTableTmpItem.ratedPersion === item1.ratedPersion
            })
            if (index === -1) {
              let obj = {
                ratedPersion: item1.ratedPersion,
                ratedName: item1.ratedPersionName,
                duty: item1.duty,
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
        }
        return ratesTableTmp
      },
      // 上一月
      handlePreMonth () {
        this.formData.title = this.$moment(this.formData.title).subtract(1, 'months').format('YYYY-MM')
        this.setMonthCookie(this.formData.title, 7)
        this.initData(this.users)
      },
      // 下一月
      handleNextMonth () {
        this.formData.title = this.$moment(this.formData.title).add(1, 'months').format('YYYY-MM')
        this.setMonthCookie(this.formData.title, 7)
        this.initData(this.users)
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
        this.isChanged = true // 全局标志位置位
        // 更新从mutualrate数据库获取的互评数据
        for (let i = 0; i < this.ratesTmp.length; i++) {
          if (this.ratesTmp[i].rateType === rateType &&
            this.ratesTmp[i].ratedPersion === ratedPersion) {
            this.ratesTmp[i].rate = rate
            this.updateRateToUpdate(this.ratesTmp[i])
            break
          }
        }
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
        this.updateRateRawRateData(1, row.ratedPersion, this.starToRates(row.t1Star)) // 更新的评分项推送至待更新数据缓存
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
      // 成效比例改变
      handlePerformanceRateChange () {
        this.ratioFormData.quantativeRate = (0.7 - this.ratioFormData.performanceRate).toFixed(2)
      },
      // 定量比例改变
      handleQuantativeRateChange () {
        this.ratioFormData.performanceRate = (0.7 - this.ratioFormData.quantativeRate).toFixed(2)
      },
      // 普通员工成效评价比例改变
      handleCommonStaffPerChange () {

      },
      // 经理对组长评价的比例改变
      handleGLManPerCge () {

      },
      // 普通成员对组长评价的比例改变
      handleGLComPerCge () {

      }
    },
    components: {
    },
    created () {
      this.init()
    },
    watch: {
    },
    mounted () {
      this.refreshTableSize()
    },
    name: 'performanceEva'
  }
</script>

<style scoped>
</style>

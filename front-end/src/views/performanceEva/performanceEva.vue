<template>
<div v-if="$store.state.userInfo.duty === 1 || $store.state.userInfo.id === 15">
  <el-form class="main-search" :inline="true">
    <el-row type="flex">
      <el-col :xs="12" :sm="12" :lg="9" :xl="6">
        <el-form-item label="评价月份：" prop="title">
          <el-button size="mini"
                     type="danger"
                     style="margin-right: 10px"
                     @click="handlePreMonth"
                     :disabled="!reqFlag.getUserRates || !reqFlag.tableDataInitFinish">上月</el-button>
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
                     :disabled="!reqFlag.getUserRates || !reqFlag.tableDataInitFinish">下月</el-button>
        </el-form-item>
      </el-col>
      <!-- <el-col :xs="12" :sm="12" :lg="{span: 4, offset: 8 }" :xl="{span: 3, offset: 12 }">
        <el-button type="primary" @click="submitRatesResult" :disabled="isRated">
          <span v-if="!isRated">提交</span>
          <span v-else>已提交</span>
        </el-button>
        <el-button type="success"
                   :disabled="!isRated || !isChanged || !reqFlag.updateRateToUpdate"
                   @click="updateRateTableData">更新</el-button>
      </el-col> -->
    </el-row>
  </el-form>
  <!-- 分割线 start -->
  <div class="hr-10"></div>
  <!-- 分割线 end -->
  <div>
    <el-form :model="ratioFormData" :rules="ratioFormRules" ref="ratioFormData" :inline="true" class="main-search">
      <el-form-item label="员工互评的定性评价系数">
        <el-input v-model="ratioFormData.CSMutualCoef"
                  :disabled="!reqFlag.getEvaCoef || !reqFlag.tableDataInitFinish" style="width:50%"></el-input>
      </el-form-item>
      <el-form-item label="经理评价的定性评价系数" style="margin-left:-100px">
        <el-input v-model="ratioFormData.MGEvaCoef"
                  :disabled="!reqFlag.getEvaCoef || !reqFlag.tableDataInitFinish" style="width:50%"></el-input>
      </el-form-item>
      <el-form-item label="定量评价系数" style="margin-left:-100px">
        <el-input v-model="ratioFormData.quantitativeCoef"
                  :disabled="!reqFlag.getEvaCoef || !reqFlag.tableDataInitFinish" style="width:50%"></el-input>
      </el-form-item>
      <el-form-item label="成效评价系数" style="margin-left:-100px">
        <el-input v-model="ratioFormData.PMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef || !reqFlag.tableDataInitFinish" style="width:50%"></el-input>
      </el-form-item>
      <br>
      <el-form-item label="经理对普通职员的成效评价系数">
        <el-input v-model="ratioFormData.CSManagerAMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef || !reqFlag.tableDataInitFinish" style="width:50%"></el-input>
      </el-form-item>
      <el-form-item label="组长对普通职员的成效评价系数" style="margin-left:-100px">
        <el-input v-model="ratioFormData.CSGroupLeaderAMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef || !reqFlag.tableDataInitFinish" style="width:50%"></el-input>
      </el-form-item>
      <el-form-item label="普通职员对普通职员的成效评价系数" style="margin-left:-100px">
        <el-input v-model="ratioFormData.CScommonStaffAMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef || !reqFlag.tableDataInitFinish" style="width:50%"></el-input>
      </el-form-item>
      <br>
      <el-form-item label="经理对组长的成效评价系数">
        <el-input v-model="ratioFormData.GPManagerAMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef || !reqFlag.tableDataInitFinish" style="width:50%"></el-input>
      </el-form-item>
      <el-form-item label="普通职员对组长的成效评价系数" style="margin-left:-100px">
        <el-input v-model="ratioFormData.GPCommonStaffAMEvaCoef"
                  :disabled="!reqFlag.getEvaCoef || !reqFlag.tableDataInitFinish" style="width:50%"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="handleCalPMScore" :disabled="isCalPMScore">计算</el-button>
        <el-button type="success" @click="handleSaveEvaCoef">保存系数</el-button>
      </el-form-item>
    </el-form>
  </div>
  <div>
    <el-table :data="rateTableData"
              border
              style="margin: auto; width: 99%;"
              stripe
              size="large"
              :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }"
              v-loading="!reqFlag.tableDataInitFinish"
              :height="tableHeight"
              ref="rateTable"
              highlight-current-row>
      <el-table-column label="姓名" prop="ratedName" align="center" min-width="20"></el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 26" label="定量评价" align="center">
        <el-table-column v-if="$store.state.userInfo.id === 26" label="工时排名" align="center" prop="quantitativeRank" width="57"></el-table-column>
      </el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 26" label="定性评价" align="center">
        <el-table-column v-if="$store.state.userInfo.id === 26" label="员工互评排名" align="center" prop="CSMutualScoeAveRank" width="57"></el-table-column>
        <el-table-column v-if="$store.state.userInfo.id === 26" label="经理评价排名" align="center" prop="MGQualiEvaScoreRank" width="57"></el-table-column>
      </el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 26" label="成效评价" align="center">
        <el-table-column v-if="$store.state.userInfo.id === 26" label="成效评价排名" align="center" prop="PMEvaScoreUnNRank" width="57"></el-table-column>
      </el-table-column>
      <!-- <el-table-column v-if="$store.state.userInfo.id === 26" label="绩效排名（旧）" align="center" prop="PMScoreRankOld" width="65"></el-table-column> -->
      <el-table-column v-if="$store.state.userInfo.id === 26"
                        label="绩效排名"
                        align="center"
                        prop="PMScoreRank"
                        width="65">
        <template slot-scope="scope">
          <span style="font-weight: bolder;color: red">{{scope.row.PMScoreRank}}</span>
          <i v-if="scope.row.PMScoreRankRise" class="el-icon-caret-top" style="color: red"></i>
          <i v-if="scope.row.PMScoreRankDesc" class="el-icon-caret-bottom" style="color: green"></i>
          <span v-if="scope.row.PMScoreRankRise || scope.row.PMScoreRankDesc" style="font-size: 10px">
            {{scope.row.PMScoreRankChange}}
          </span>
        </template>
      </el-table-column>
      <el-table-column label="成效评价" align="center">
          <el-table-column label="维度1" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t1Star"
                        @change="handleStarChange(scope.row, 1)" slot="reference" style="size: 50px"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度2" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t2Star"
                       @change="handleStarChange(scope.row, 2)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度3" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t3Star"
                       @change="handleStarChange(scope.row, 3)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度4" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t4Star"
                       @change="handleStarChange(scope.row, 4)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度5" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t5Star"
                       @change="handleStarChange(scope.row, 5)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="维度6" align="center" min-width="70">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t6Star"
                       @change="handleStarChange(scope.row, 6)"></el-rate>
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
    submitRatesResult,
    updateUserRate,
    getCurMutualRate,
    getIsSubmitAllow,
    getIsWorkTimeReviewFinish,
    urlGetPerformanceRates } from '@/config/interface'
  import { getAllAchievements } from '@/utils/performancerate'
  import { getPerformanceIsPublish,
          getTypeGlobalFlag,
          calGetScore,
          getGlobalFlagByType,
          PMScoreNorCal,
          rateTypeSwitch,
          starToRates,
          updateGlobalFlagVal,
          ratesToStar,
          compare,
          sortBy } from '@/utils/common'
  import { getAllWorkTimeList } from '@/utils/performance'
  import { calPerformanceEvaScore } from '@/utils/performanceEva'
  import { groupName2String, getUsersList } from '@/utils/users'
  import { getAllUserRates } from '@/utils/multual'
  import store from '@/store'
  import Cookies from 'js-cookie'
  export default {
    data () {
    return {
        formData: {
          title: this.$moment().format('YYYY-MM')
        },
        ratioFormData: {
          CSMutualCoef: 0,
          MGEvaCoef: 0,
          quantitativeCoef: 0,
          PMEvaCoef: 0,
          CSManagerAMEvaCoef: 0,
          CSGroupLeaderAMEvaCoef: 0,
          CScommonStaffAMEvaCoef: 0,
          GPManagerAMEvaCoef: 0,
          GPCommonStaffAMEvaCoef: 0
        },
        ratioFormRules: {
          quantativeRate: [
            { required: true, message: '请输入定量比例', trigger: 'blur' },
            { min: 3, max: 5, message: '长度在 3 到 5 个字符', trigger: 'blur' }]
        },
        rateTableData: [],
        users: [],
        usersNum: null, // 处室成员总数
        defaultStar: 3,
        scoreText: ['82.5', '85', '87.5', '90', '92.5'],
        isRated: false,
        isChanged: false,
        ratesTableTmp: [],
        reqFlag: {
          getUserRates: true,
          getUsersList: true,
          updateRateToUpdate: true,
          getPerformanceRates: true,
          getEvaCoef: true,
          tableDataInitFinish: false
        },
        ratesTmp: [],
        ratesToUpdate: [],
        ratedArray: [],
        curMutualRate: 0,
        tableHeight: null,
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
        performanceEvaDataGlobal: [],
        isPerformancePublish: false,
        performanceIsPublishInfo: null,
        PMEvaDataResult: null,
        getPMEvaData: null,
        isCalPMScore: false
      }
    },
    methods: {
      // 初始化
      init () {
        if (typeof (Cookies.get('PMEvaPageDate')) === 'undefined') {
          Cookies.set('PMEvaPageDate', this.formData.title)
        }
        this.formData.title = Cookies.get('PMEvaPageDate')
        // this.getCookie('PMEvaPageData')
        // this.getCurMutualRate()
        // this.getCurApplyAbleMonth().then(getCurApplyAbleMonthRes => {
        //   this.formData.title = this.$moment(getCurApplyAbleMonthRes[0].setTime).format('YYYY-MM')
        // })
        this.getEvaCoef() // 获取各种评价系数
        // 获取用户列表
        getUsersList().then(userList => {
          this.users = userList
          this.usersNum = this.users.length
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
        promises[count++] = getGlobalFlagByType('CSManagerAMEvaCoef')
        promises[count++] = getGlobalFlagByType('CSGroupLeaderAMEvaCoef')
        promises[count++] = getGlobalFlagByType('CScommonStaffAMEvaCoef')
        promises[count++] = getGlobalFlagByType('GPManagerAMEvaCoef')
        promises[count++] = getGlobalFlagByType('GPCommonStaffAMEvaCoef')
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
              _this.ratioFormData.CSManagerAMEvaCoef = result[4][0].flagValue
              _this.ratioFormData.CSGroupLeaderAMEvaCoef = result[5][0].flagValue
              _this.ratioFormData.CScommonStaffAMEvaCoef = result[6][0].flagValue
              _this.ratioFormData.GPManagerAMEvaCoef = result[7][0].flagValue
              _this.ratioFormData.GPCommonStaffAMEvaCoef = result[8][0].flagValue
              resolve(result)
            }
          }).catch(err => {
            _this.$common.toast('getEvaCoef ERR: ' + err, 'error', false)
            reject(err)
          })
        })
      },
      // 表格数据初始化
      initData (userList) {
        this.reqFlag.tableDataInitFinish = false
        let promises = []
        let count = 0
        let applyYear = this.$moment(this.formData.title).year()
        let applyMonth = this.$moment(this.formData.title).month() + 1
        this.getPerformanceRates().then(performanceRates => { // 获取个人成效评价数据库数据
          this.isRated = performanceRates.length !== 0
          this.rateTableData = JSON.parse(JSON.stringify(this.genRateTableData(userList, performanceRates))) // 成效评价表格数据初始化
          // 管理者角色进行定量、定性和绩效数据的计算
          if (this.$store.state.userInfo.id === 26) {
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
                this.reqFlag.tableDataInitFinish = true
              }
              if (!result[1].err) { // 互评已截止
                genMultualEvaDataResult = this.genQualiEvaData(result[1].content) // 生成定性评价数据
                this.multualEvaData = JSON.parse(JSON.stringify(genMultualEvaDataResult))
              } else {
                this.multualEvaData = []
                this.isMultualEvaFinish = false
                this.reqFlag.tableDataInitFinish = true
              }
              if (!result[2].err) { // 成效评价已截止
                this.getPMEvaData = JSON.parse(JSON.stringify(result[2].content))
                genPerformanceEvaDataResult = this.genPerformanceEvaData(result[2].content) // 生成成效评价数据
                this.performanceEvaDataGlobal = JSON.parse(JSON.stringify(genPerformanceEvaDataResult))
              } else {
                this.performanceEvaDataGlobal = []
                this.isPerformanceEvaFinish = false
                this.reqFlag.tableDataInitFinish = true
              }
              if (!result[0].err && !result[1].err && !result[2].err) { // 工时已审核完毕、互评已截止、成效评价已截止
                this.isQuantativeFinish = true
                this.isMultualEvaFinish = true
                this.isPerformanceEvaFinish = true
                this.genPerformanceScore(genQuantativeDataResult, genMultualEvaDataResult, genPerformanceEvaDataResult, 'init')
                this.genPerformanceScoreOld(genQuantativeDataResult, genMultualEvaDataResult, 'init')
                this.reqFlag.tableDataInitFinish = true
              } else {
                this.reqFlag.tableDataInitFinish = true
              }
            }).catch(err => {
              this.reqFlag.tableDataInitFinish = true
              console.log(err)
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
              getAllAchievements(userList, rateTitle).then(getAllPerformanceRateRes => {
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
        // =============================对当月无工时申报的员工填充0工时==================================
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
      // 生成定性评价数据
      genQualiEvaData (multualData) {
        let multualEvaScoreArr = []
        for (let multualDataItem of multualData) { // res.data格式：[{groupName: ; id: ;name: ; rateData: [{}]; ratedData: [{}]}, {...}]
          let obj = {
            id: multualDataItem.id,
            name: multualDataItem.name,
            groupName: multualDataItem.groupName,
            duty: multualDataItem.duty,
            isRate: multualDataItem.rateData.length !== 0
          }
          let ratesTableTmp = []
          let manageRate = 0
          let totalRate = 0
          let count = 0
          for (let ratedData of multualDataItem.ratedData) {
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
                obj[rateTypeSwitch(ratedData.rateType)] = ratedData.rate
                ratesTableTmp.push(obj)
              } else {
                ratesTableTmp[index][rateTypeSwitch(ratedData.rateType)] = ratedData.rate
              }
            }
          }
          // ========================计算各被评价人成效评价得分总分===============================
          for (let item of ratesTableTmp) {
            item.totalScore = calPerformanceEvaScore(item.t1Star, item.t2Star, item.t3Star, item.t4Star,
              item.t5Star, item.t6Star)
            if (item.duty === 1) { // 经理评价
              manageRate = item.totalScore
            } else {
              count++
              totalRate += item.totalScore
            }
          }
          // ==============================计算各评价人领导评价和普通员工评价平均分（未标准化的）===============================
          if (manageRate === 0) { // 领导者尚未评价,重置为默认评分
            let defaultRate = starToRates(this.defaultStar)
            manageRate = calPerformanceEvaScore(defaultRate, defaultRate, defaultRate,
              defaultRate, defaultRate, defaultRate)
          }
          if (obj.duty === 1) {
            manageRate = 0
          }
          if (count === 0) {
            count = 1 // 防止NAN
          }
          obj.CSMutualScoeAve = Number((totalRate / count).toFixed(5))
          obj.MGQualiEvaScoreUnN = Number(manageRate.toFixed(5))
          multualEvaScoreArr.push(obj)
        }
        let allUserRates = JSON.parse(JSON.stringify(multualEvaScoreArr))
        let managerIndex = allUserRates.findIndex(allUserRatesItem => {
          return allUserRatesItem.duty === 1
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
            if (standAndEngineerRates[j].CSMutualScoeAve < standAndEngineerRates[j + 1].CSMutualScoeAve) {
              [standAndEngineerRates[j], standAndEngineerRates[j + 1]] =
                [standAndEngineerRates[j + 1], standAndEngineerRates[j]]
            }
          }
        }
        // 通信组员工互评排序
        for (let i = 0; i < communicationRates.length - 1; i++) {
          for (let j = 0; j < communicationRates.length - 1 - i; j++) {
            if (communicationRates[j].CSMutualScoeAve < communicationRates[j + 1].CSMutualScoeAve) {
              [communicationRates[j], communicationRates[j + 1]] =
                [communicationRates[j + 1], communicationRates[j]]
            }
          }
        }
        // 全处员工领导评价排序
        for (let i = 0; i < allUserRates.length - 1; i++) {
          for (let j = 0; j < allUserRates.length - 1 - i; j++) {
            if (allUserRates[j].MGQualiEvaScoreUnN < allUserRates[j + 1].MGQualiEvaScoreUnN) {
              [allUserRates[j], allUserRates[j + 1]] =
                [allUserRates[j + 1], allUserRates[j]]
            }
          }
        }
        // =================================定性评价得分计算===============================================
        // 技术标准组与工程组互评排名&得分计算
        let tmpCSMutualScoeAve = -1
        let count = 1
        for (let i = 0; i < standAndEngineerRates.length; i++) {
          if (standAndEngineerRates[i].CSMutualScoeAve === tmpCSMutualScoeAve) {
            standAndEngineerRates[i].CSMutualScoeAveRank = standAndEngineerRates[i - 1].CSMutualScoeAveRank
          } else {
            standAndEngineerRates[i].CSMutualScoeAveRank = count
            tmpCSMutualScoeAve = standAndEngineerRates[i].CSMutualScoeAve
          }
          count++
          standAndEngineerRates[i].CSMutualScoreNor =
            calGetScore(standAndEngineerRates.length, standAndEngineerRates[i].CSMutualScoeAveRank)
        }
        // 通信组互评排名&得分计算
        tmpCSMutualScoeAve = -1
        count = 1
        for (let i = 0; i < communicationRates.length; i++) {
          if (communicationRates[i].CSMutualScoeAve === tmpCSMutualScoeAve) {
            communicationRates[i].CSMutualScoeAveRank = communicationRates[i - 1].CSMutualScoeAveRank
          } else {
            communicationRates[i].CSMutualScoeAveRank = count
            tmpCSMutualScoeAve = communicationRates[i].CSMutualScoeAve
          }
          count++
          communicationRates[i].CSMutualScoreNor =
            calGetScore(communicationRates.length, communicationRates[i].CSMutualScoeAveRank)
        }
        // 全处员工领导评价排名&得分计算
        let tmpMGQualiEvaScoreUnN = -1
        count = 1
        for (let i = 0; i < allUserRates.length; i++) {
          if (allUserRates[i].MGQualiEvaScoreUnN === tmpMGQualiEvaScoreUnN) {
            allUserRates[i].MGQualiEvaScoreRank = allUserRates[i - 1].MGQualiEvaScoreRank
          } else {
            allUserRates[i].MGQualiEvaScoreRank = count
            tmpMGQualiEvaScoreUnN = allUserRates[i].MGQualiEvaScoreUnN
          }
          count++
          allUserRates[i].MGQualiEvaScoreNor =
            calGetScore(allUserRates.length, allUserRates[i].MGQualiEvaScoreRank)
        }
        let allQualiEvaScore = []
        allQualiEvaScore = standAndEngineerRates.concat(communicationRates)
        return allQualiEvaScore
      },
      // 生成成效评价数据
      genPerformanceEvaData (performanceEvaData) {
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
                obj[rateTypeSwitch(ratedData.rateType)] = ratedData.rate
                ratesTableTmp.push(obj)
              } else {
                ratesTableTmp[index][rateTypeSwitch(ratedData.rateType)] = ratedData.rate
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
            let defaultRate = starToRates(this.defaultStar)
            manageRate = calPerformanceEvaScore(defaultRate, defaultRate, defaultRate,
              defaultRate, defaultRate, defaultRate)
          }
          if (count === 0) {
            count = 1 // 防止NAN
          }
          obj.CSPMEvaScoreAve = Number((totalRate / count).toFixed(5))
          obj.GPPMEvaScoreUnN = Number(groupRate.toFixed(5))
          obj.MGEvaScoreUnN = Number(manageRate.toFixed(5))
          if (obj.duty === 2) {
            obj.PMEvaScoreUnN = obj.CSPMEvaScoreAve * this.ratioFormData.GPCommonStaffAMEvaCoef +
             obj.MGEvaScoreUnN * this.ratioFormData.GPManagerAMEvaCoef
          } else if (obj.duty === 3) {
            obj.PMEvaScoreUnN = obj.CSPMEvaScoreAve * this.ratioFormData.CScommonStaffAMEvaCoef +
             obj.MGEvaScoreUnN * this.ratioFormData.CSManagerAMEvaCoef +
             obj.GPPMEvaScoreUnN * this.ratioFormData.CSGroupLeaderAMEvaCoef
          } else {
            obj.PMEvaScoreUnN = 0
          }
          obj.PMEvaScoreUnN = Number(obj.PMEvaScoreUnN.toFixed(5))
          PMEvaScoreArr.push(obj)
        }
        // =================================按照成员所属组别计算成效标准化得分======================================
        let allPerformanceEvaRates = JSON.parse(JSON.stringify(PMEvaScoreArr))
        let managerIndex = allPerformanceEvaRates.findIndex(allUserRatesItem => {
          return allUserRatesItem.id === 26
        })
        // 去除处经理
        if (managerIndex !== -1) {
          allPerformanceEvaRates.splice(managerIndex, 1)
        }
        // =================按组别存放=====================
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
        // 技术标准组&工程组员工成效评价排序
        for (let i = 0; i < standAndEngineerRates.length - 1; i++) {
          for (let j = 0; j < standAndEngineerRates.length - 1 - i; j++) {
            if (standAndEngineerRates[j].PMEvaScoreUnN < standAndEngineerRates[j + 1].PMEvaScoreUnN) {
              [standAndEngineerRates[j], standAndEngineerRates[j + 1]] =
                [standAndEngineerRates[j + 1], standAndEngineerRates[j]]
            }
          }
        }
        // 通信组员工成效评价排序
        for (let i = 0; i < communicationRates.length - 1; i++) {
          for (let j = 0; j < communicationRates.length - 1 - i; j++) {
            if (communicationRates[j].PMEvaScoreUnN < communicationRates[j + 1].PMEvaScoreUnN) {
              [communicationRates[j], communicationRates[j + 1]] =
                [communicationRates[j + 1], communicationRates[j]]
            }
          }
        }
        // ====================成效评价得分计算=======================
        // 技术标准组与工程组成效评价排名计算并根据排名计算标准化成效得分
        let tmpPMEvaScore = -1
        let count1 = 1
        for (let i = 0; i < standAndEngineerRates.length; i++) {
          if (standAndEngineerRates[i].PMEvaScoreUnN === tmpPMEvaScore) {
            standAndEngineerRates[i].PMEvaScoreUnNRank = standAndEngineerRates[i - 1].PMEvaScoreUnNRank
          } else {
            standAndEngineerRates[i].PMEvaScoreUnNRank = count1
            tmpPMEvaScore = standAndEngineerRates[i].PMEvaScoreUnN
          }
          count1++
          standAndEngineerRates[i].PMEvaScoreNor =
            calGetScore(standAndEngineerRates.length, standAndEngineerRates[i].PMEvaScoreUnNRank)
        }
        // 通信组成效评价排名计算并根据排名计算标准化成效得分
        tmpPMEvaScore = -1
        count1 = 1
        for (let i = 0; i < communicationRates.length; i++) {
          if (communicationRates[i].PMEvaScoreUnN === tmpPMEvaScore) {
            communicationRates[i].PMEvaScoreUnNRank = communicationRates[i - 1].PMEvaScoreUnNRank
          } else {
            communicationRates[i].PMEvaScoreUnNRank = count1
            tmpPMEvaScore = communicationRates[i].PMEvaScoreUnN
          }
          count1++
          communicationRates[i].PMEvaScoreNor =
            calGetScore(communicationRates.length, communicationRates[i].PMEvaScoreUnNRank)
        }
        // =================================成效评价结果合并===============================================
        let allPMEvaScore = standAndEngineerRates.concat(communicationRates)
        return allPMEvaScore
      },
      // 生成绩效得分与排名数据
      genPerformanceScore (quantativeData, multualEvaData, performanceEvaData, genType) {
        // ==============================绩效得分(未标准化)计算================================
        for (let item of this.rateTableData) {
          let itemQuantativeScore = quantativeData.find(quantativeDataItem => { // 找出初始表格成员对应的定量数据
            return quantativeDataItem.id === item.ratedPersion
          })
          let itemMultualEvaScore = multualEvaData.find(multualEvaDataItem => { // 找出初始表格成员对应的定性数据
            return multualEvaDataItem.id === item.ratedPersion
          })
          let itemPMEvaObj = performanceEvaData.find(performanceEvaDataItem => { // 找出初始表格成员对应的成效评价数据
            return performanceEvaDataItem.id === item.ratedPersion
          })
          // 计算未标准化的绩效得分
          if (itemQuantativeScore && itemMultualEvaScore && itemPMEvaObj) {
              item.PMScoreUnN =
                itemQuantativeScore.quantitativeScore * this.ratioFormData.quantitativeCoef + // 定量评价乘上相应系数
                itemMultualEvaScore.CSMutualScoreNor * this.ratioFormData.CSMutualCoef + // 定性评价（员工互评）乘上相应系数
                itemMultualEvaScore.MGQualiEvaScoreNor * this.ratioFormData.MGEvaCoef + // 定性评价（经理评价）乘上相应系数
                itemPMEvaObj.PMEvaScoreNor * this.ratioFormData.PMEvaCoef // 成效评价乘上相应系数
              item.PMEvaScoreUnNRank = itemPMEvaObj.PMEvaScoreUnNRank
              item.PMEvaScoreUnN = itemPMEvaObj.PMEvaScoreUnN
              item.PMEvaScoreNor = itemPMEvaObj.PMEvaScoreNor
              item.MGQualiEvaScoreUnN = itemMultualEvaScore.MGQualiEvaScoreUnN
              item.MGQualiEvaScoreRank = itemMultualEvaScore.MGQualiEvaScoreRank
              item.MGQualiEvaScoreNor = itemMultualEvaScore.MGQualiEvaScoreNor
              item.CSMutualScoeAve = itemMultualEvaScore.CSMutualScoeAve
              item.CSMutualScoeAveRank = itemMultualEvaScore.CSMutualScoeAveRank
              item.CSMutualScoreNor = itemMultualEvaScore.CSMutualScoreNor
              item.totalWorkTime = Number(itemQuantativeScore.totalWorkTime.toFixed(2))
          }
        }
        this.rateTableData.sort(sortBy('PMScoreUnN'))
        // ====================================绩效排名与标准化绩效得分计算======================================
        let count = 0
        let prePMScoreUnN = -1
        let rankTmp = []
        let count1 = -1
        let count2 = 1
        // 把绩效得分相同的人员存进对象数组同一个元素里面
        for (let i = 0; i < this.rateTableData.length; i++) {
          if (this.rateTableData[i].PMScoreUnN === prePMScoreUnN) {
            rankTmp[count1].push(this.rateTableData[i])
          } else {
            count1++
            if (!rankTmp[count1]) {
              rankTmp[count1] = []
            }
            rankTmp[count1].push(this.rateTableData[i])
            prePMScoreUnN = this.rateTableData[i].PMScoreUnN
          }
        }
        // 绩效得分相同的人员根据工时多少进行排序
        for (let i = 0; i < rankTmp.length; i++) {
          rankTmp[i].sort(sortBy('totalWorkTime'))
          for (let j = 0; j < rankTmp[i].length; j++) {
            this.rateTableData[count++] = rankTmp[i][j]
          }
        }
        for (let item of this.rateTableData) {
          item.PMScoreRank = count2++ // 绩效排名计算
          if (genType === 'init') {
            item.initPMScoreRank = item.PMScoreRank
          } else if (genType === 'update') {
            let PMScoreRankChange = item.initPMScoreRank - item.PMScoreRank
            item.PMScoreRankRise = PMScoreRankChange > 0
            item.PMScoreRankDesc = PMScoreRankChange < 0
            item.PMScoreRankChange = Math.abs(PMScoreRankChange)
          }
          item.PMScoreNor = PMScoreNorCal(this.usersNum, item.PMScoreRank)
        }
        if (genType === 'init') {
          this.rateTableData.sort(this.sortAddBy('PMScoreRank'))
        }
      },
      // 生成绩效评价得分（旧）
      genPerformanceScoreOld (quantativeData, multualEvaData, genType) {
        // ==============================绩效得分(未标准化)计算================================
        for (let item of this.rateTableData) {
          let itemQuantativeScore = quantativeData.find(quantativeDataItem => { // 找出初始表格成员对应的定量数据
            return quantativeDataItem.id === item.ratedPersion
          })
          let itemMultualEvaScore = multualEvaData.find(multualEvaDataItem => { // 找出初始表格成员对应的定性数据
            return multualEvaDataItem.id === item.ratedPersion
          })
          // 计算未标准化的绩效得分
          if (itemQuantativeScore && itemMultualEvaScore) {
            if (item.ratedPersion === 7 || item.ratedPersion === 11 || item.ratedPersion === 31) { // 主任岗
              item.PMScoreUnNOld =
                itemQuantativeScore.quantitativeScore * this.directorQuantitativeCof + // 定量评价乘上相应系数
                itemMultualEvaScore.CSMutualScoreNor * this.directorMutualCof + // 定性评价（员工互评）乘上相应系数
                itemMultualEvaScore.MGQualiEvaScoreNor * this.directorManagerCof // 定性评价（经理评价）乘上相应系数
            } else if (item.ratedPersion === 13 || item.ratedPersion === 17 || item.ratedPersion === 33) { // 组长
              item.PMScoreUnNOld =
                itemQuantativeScore.quantitativeScore * this.groupLeaderQuantitativeCof + // 定量评价乘上相应系数
                itemMultualEvaScore.CSMutualScoreNor * this.groupLeaderMutualCof + // 定性评价（员工互评）乘上相应系数
                itemMultualEvaScore.MGQualiEvaScoreNor * this.groupLeaderManagerCof // 定性评价（经理评价）乘上相应系数
            } else { // 普通员工
              item.PMScoreUnNOld =
                itemQuantativeScore.quantitativeScore * this.commonStaffQuantitativeCof + // 定量评价乘上相应系数
                itemMultualEvaScore.CSMutualScoreNor * this.commonStaffMutualCof + // 定性评价（员工互评）乘上相应系数
                itemMultualEvaScore.MGQualiEvaScoreNor * this.commonStaffManagerCof // 定性评价（经理评价）乘上相应系数
            }
            // item.MGQualiEvaScoreUnN = itemMultualEvaScore.MGQualiEvaScoreUnN
            // item.MGQualiEvaScoreRank = itemMultualEvaScore.MGQualiEvaScoreRank
            // item.MGQualiEvaScoreNor = itemMultualEvaScore.MGQualiEvaScoreNor
            // item.CSMutualScoeAve = itemMultualEvaScore.CSMutualScoeAve
            // item.CSMutualScoeAveRank = itemMultualEvaScore.CSMutualScoeAveRank
            // item.CSMutualScoreNor = itemMultualEvaScore.CSMutualScoreNor
            // item.totalWorkTime = Number(itemQuantativeScore.totalWorkTime.toFixed(2))
          }
        }
        // this.rateTableData.sort(this.sortBy('PMScoreUnN'))
        let rateTableDataTmp = JSON.parse(JSON.stringify(this.rateTableData))
        rateTableDataTmp.sort(sortBy('PMScoreUnNOld'))
        // ====================================绩效排名与标准化绩效得分计算======================================
        let count = 0
        let prePMScoreUnN = -1
        let rankTmp = []
        let count1 = -1
        let count2 = 1
        // 把绩效得分相同的人员存进对象数组同一个元素里面
        for (let i = 0; i < rateTableDataTmp.length; i++) {
          if (rateTableDataTmp[i].PMScoreUnNOld === prePMScoreUnN) {
            rankTmp[count1].push(rateTableDataTmp[i])
          } else {
            count1++
            if (!rankTmp[count1]) {
              rankTmp[count1] = []
            }
            rankTmp[count1].push(rateTableDataTmp[i])
            prePMScoreUnN = rateTableDataTmp[i].PMScoreUnNOld
          }
        }
        // 绩效得分相同的人员根据工时多少进行排序
        for (let i = 0; i < rankTmp.length; i++) {
          rankTmp[i].sort(sortBy('totalWorkTime'))
          for (let j = 0; j < rankTmp[i].length; j++) {
            rateTableDataTmp[count++] = rankTmp[i][j]
          }
        }
        for (let item of rateTableDataTmp) {
          item.PMScoreRankOld = count2++ // 绩效排名计算
          // if (genType === 'init') {
          //   item.initPMScoreRank = item.PMScoreRankOld
          // } else if (genType === 'update') {
          //   let PMScoreRankChange = item.initPMScoreRank - item.PMScoreRankOld
          //   item.PMScoreRankRise = PMScoreRankChange > 0
          //   item.PMScoreRankDesc = PMScoreRankChange < 0
          //   item.PMScoreRankChange = Math.abs(PMScoreRankChange)
          // }
          item.PMScoreNorOld = PMScoreNorCal(this.usersNum, item.PMScoreRankOld)
        }
        for (let item of this.rateTableData) {
          let rateTableFindResult = rateTableDataTmp.find(rateTableDataTmpItem => {
            return rateTableDataTmpItem.ratedPersion === item.ratedPersion
          })
          item.PMScoreRankOld = rateTableFindResult.PMScoreRankOld
          item.PMScoreNorOld = rateTableFindResult.PMScoreNorOld
        }
        // if (genType === 'init') {
        //   this.rateTableData.sort(this.sortAddBy('PMScoreRank'))
        // }
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
          totalWorkTimeCal.sort(compare('totalWorkTime')) // 根据总工时排序
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
            item.quantitativeScore = calGetScore(length, item.rank)
          }
        }
        return totalWorkTimeCal
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
      // 排序比较函数(升序)
      sortAddBy (props) {
        return function (a, b) {
          return a[props] - b[props]
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
              getAllUserRates(_this.users, _this.formData.title).then(getAllUserRatesRes => {
                resolve({
                  error: false,
                  content: getAllUserRatesRes })
              }).catch(getAllUserRatesResErr => {
                reject(getAllUserRatesResErr)
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
            reject(getIsSubmitMultualEvaAllowErr)
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
            this.ratedArray[i][rateTypeSwitch(param.rateType)] = param.rate
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
          obj[rateTypeSwitch(param.rateType)] = param.rate
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
      // 计算互评总分(通过各评分类型分数)
      calMultualScoreByScore (t1Score, t2Score, t3Score, t4Score, t5Score, t6Score) {
        let totalScore = t1Score * 0.15 + t2Score * 0.2 + t3Score * 0.1 +
          t4Score * 0.1 + t5Score * 0.3 + t6Score * 0.15
        return totalScore
      },
      // 计算互评总分
      calMultualScore (t1Star, t2Star, t3Star, t4Star, t5Star, t6Star) {
        let t1Score = starToRates(t1Star)
        let t2Score = starToRates(t2Star)
        let t3Score = starToRates(t3Star)
        let t4Score = starToRates(t4Star)
        let t5Score = starToRates(t5Star)
        let t6Score = starToRates(t6Star)
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
            if (curGroupName === '技术标准组' || curGroupName === '工程组') {
              if (user.groupName === '技术标准组' || user.groupName === '工程组') {
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
                    PMScoreRank: null,
                    PMScoreRankRise: false,
                    PMScoreRankDesc: false,
                    PMScoreRankChange: 0,
                    initPMScoreRank: null
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
                    PMScoreRank: null,
                    PMScoreRankRise: false,
                    PMScoreRankDesc: false,
                    PMScoreRankChange: 0,
                    initPMScoreRank: null
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
                  PMScoreRank: null,
                  PMScoreRankRise: false,
                  PMScoreRankDesc: false,
                  PMScoreRankChange: null,
                  initPMScoreRank: null
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
                PMScoreRank: null,
                PMScoreRankRise: false,
                PMScoreRankDesc: false,
                PMScoreRankChange: null,
                initPMScoreRank: null
              }
              obj[rateTypeSwitch(item1.rateType)] = ratesToStar(item1.rate)
              ratesTableTmp.push(obj)
            } else {
              ratesTableTmp[index][rateTypeSwitch(item1.rateType)] = ratesToStar(item1.rate)
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
        if (typeof (Cookies.get('PMEvaPageDate')) !== 'undefined') {
          Cookies.remove('PMEvaPageData')
        }
        Cookies.set('PMEvaPageDate', this.formData.title)
        this.initData(this.users)
      },
      // 下一月
      handleNextMonth () {
        this.formData.title = this.$moment(this.formData.title).add(1, 'months').format('YYYY-MM')
        if (typeof (Cookies.get('PMEvaPageDate')) !== 'undefined') {
          Cookies.remove('PMEvaPageData')
        }
        Cookies.set('PMEvaPageDate', this.formData.title)
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
      // 更新带id的评分数据
      updateRateRawRateData (rateType, ratedPersion, rate) {
        let flag = 0
        let rateToUpadateObj = null
        this.isChanged = true // 全局标志位置位
        // 更新从mutualrate数据库获取的互评数据
        for (let i = 0; i < this.ratesTmp.length; i++) {
          if (this.ratesTmp[i].rateType === rateType &&
            this.ratesTmp[i].ratedPersion === ratedPersion) {
            this.ratesTmp[i].rate = rate
            rateToUpadateObj = this.ratesTmp[i]
            break
          }
        }
        // 把更新项存入待更新数组
        for (let i = 0; i < this.ratesToUpdate.length; i++) {
          if (this.ratesToUpdate[i].id === rateToUpadateObj.id) {
            this.ratesToUpdate[i] = rateToUpadateObj
            flag++
            break
          }
        }
        if (!flag) { // 没有待更新的评价
          this.ratesToUpdate.push(rateToUpadateObj)
        }
      },
      // 更新领导成效评价且更新互评得分
      updateManagerRate (managerRate, ratedPersion) {
        if (this.isMultualEvaFinish && this.isQuantativeFinish && this.isPerformanceEvaFinish) {
          let multualEvaDataFindResult = this.multualEvaData.find(multualEvaDataRes => {
            return multualEvaDataRes.id === ratedPersion
          })
          if (multualEvaDataFindResult) {
            multualEvaDataFindResult.managerRate = managerRate
            this.multualEvaData.sort(sortBy('managerRate')) // 根据领导评价排序
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
              item.managerScore = calGetScore(this.multualEvaData.length, item.managerRateRank)
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
      // 评分项星级变化
      handleStarChange (row, rateType) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(rateType, row.ratedPersion, starToRates(row[rateTypeSwitch(rateType)]))
        if (this.$store.state.userInfo.id === 26) {
          if (this.isQuantativeFinish && this.isMultualEvaFinish && this.isPerformanceEvaFinish) {
            let getPMEvaDataFindRes = this.getPMEvaData.find(getPMEvaDataItem => {
              return getPMEvaDataItem.id === row.ratedPersion
            })
            let getPMEvaDataFindResFindRes = getPMEvaDataFindRes.ratedData.find(ratedDataItem => {
              if (ratedDataItem.ratePersion === this.$store.state.userInfo.id && ratedDataItem.rateType === rateType) {
                return ratedDataItem
              }
            })
            getPMEvaDataFindResFindRes.rate = starToRates(row[rateTypeSwitch(rateType)])
            let genPerformanceEvaDataResult = this.genPerformanceEvaData(this.getPMEvaData) // 生成成效评价数据
            this.genPerformanceScore(this.quantativeData, this.multualEvaData, genPerformanceEvaDataResult, 'update') // 生成绩效评价数据
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
      // 计算修改系数后的绩效得分
      handleCalPMScore () {
        this.isCalPMScore = true
        if (parseFloat((Number(this.ratioFormData.CSMutualCoef) +
        Number(this.ratioFormData.MGEvaCoef) +
        Number(this.ratioFormData.quantitativeCoef) +
        Number(this.ratioFormData.PMEvaCoef)).toFixed(5)) !== 1) {
          this.$common.toast('定性评价系数、定量评价系数、成效评价系数之和不为1', 'error', true)
          return null
        }
        if (parseFloat((Number(this.ratioFormData.CSManagerAMEvaCoef) +
        Number(this.ratioFormData.CSGroupLeaderAMEvaCoef) +
        Number(this.ratioFormData.CScommonStaffAMEvaCoef)).toFixed(5)) !== 1) {
          this.$common.toast('经理对普通职员的成效评价系数、组长对普通职员的成效评价系数、普通职员对普通职员的成效评价系数之和不为1', 'error', true)
          return null
        }
        if (parseFloat((Number(this.ratioFormData.GPManagerAMEvaCoef) +
        Number(this.ratioFormData.GPCommonStaffAMEvaCoef)).toFixed(5)) !== 1) {
          this.$common.toast('经理对组长的成效评价系数、普通职员对组长的成效评价系数之和不为1', 'error', true)
          return null
        }
        let genPerformanceEvaDataResult = this.genPerformanceEvaData(this.getPMEvaData) // 重新生成成效评价数据
        this.genPerformanceScore(this.quantativeData, this.multualEvaData, genPerformanceEvaDataResult, 'update')
        this.isCalPMScore = false
      },
      // 保存系数
      handleSaveEvaCoef () {
        let promises = []
        let count = 0
        promises[count++] = updateGlobalFlagVal('CSMutualCoef', this.ratioFormData.CSMutualCoef)
        promises[count++] = updateGlobalFlagVal('MGEvaCoef', this.ratioFormData.MGEvaCoef)
        promises[count++] = updateGlobalFlagVal('quantitativeCoef', this.ratioFormData.quantitativeCoef)
        promises[count++] = updateGlobalFlagVal('PMEvaCoef', this.ratioFormData.PMEvaCoef)
        promises[count++] = updateGlobalFlagVal('CSManagerAMEvaCoef', this.ratioFormData.CSManagerAMEvaCoef)
        promises[count++] = updateGlobalFlagVal('CSGroupLeaderAMEvaCoef', this.ratioFormData.CSGroupLeaderAMEvaCoef)
        promises[count++] = updateGlobalFlagVal('CScommonStaffAMEvaCoef', this.ratioFormData.CScommonStaffAMEvaCoef)
        promises[count++] = updateGlobalFlagVal('GPManagerAMEvaCoef', this.ratioFormData.GPManagerAMEvaCoef)
        promises[count++] = updateGlobalFlagVal('GPCommonStaffAMEvaCoef', this.ratioFormData.GPCommonStaffAMEvaCoef)
        Promise.all(promises).then(() => {
          this.$common.toast('保存成功', 'success', false)
        }).catch(err => {
          console.log(err)
          this.$common.toast('保存失败', 'error', true)
        })
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
.el-table tbody tr:hover>td { background-color: #ff0000;color: #000; }
</style>

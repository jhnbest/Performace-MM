<template>
<div>
  <el-form class="main-search" :inline="true">
    <el-row type="flex">
      <el-col :xs="12" :sm="12" :lg="9" :xl="6">
        <el-form-item label="互评月份：" prop="title">
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
            @change="handelDateChange">
          </el-date-picker>
          <el-button size="mini"
                     type="primary"
                     style="margin-left: 10px"
                     @click="handleNextMonth"
                     :disabled="!reqFlag.getUserRates">下月</el-button>
        </el-form-item>
      </el-col>
      <el-col :xs="2" :sm="2" :lg="2" :xl="2" style="margin-top: 10px">
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
          <span slot="reference" @click="descriprionClick" class="pointer-type"><i class="el-icon-warning-outline"></i>填报说明</span>
        </el-popover>
      </el-col>
      <el-col :xs="12" :sm="12" :lg="{span: 4, offset: 9 }" :xl="{span: 3, offset: 14 }">
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
  <br>
  <div style="margin-left: 20px; margin-top: -15px">
    <span style="font-size: 15px">评价标准：</span>
    <el-switch v-model="showFlag.descTableShow" @change="handleSwitchChange"></el-switch>
    <span style="margin-left: 60px;font-weight: bolder">本月互评状态：
      <span v-if="isRated" style="font-weight: bolder;color: green;font-size: 23px">已评价</span>
      <span v-else style="font-weight: bolder;color: red;font-size: 23px">未评价</span>
    </span>
  </div>
  <br v-if="showFlag.descTableShow">
  <div v-if="showFlag.descTableShow">
    <el-table :data="tableData"
              border
              style="margin: auto; width: 99%"
              :span-method="objectSpanMethod"
              stripe
              :header-cell-style="{ backgroundColor:'#ff2525', color: '#333' }">
      <el-table-column label="一级指标" align="center" width="100%" prop="l1"></el-table-column>
      <el-table-column label="二级指标" align="center" width="100%" prop="l2"></el-table-column>
      <el-table-column label="评分衡量标准" align="center" prop="standard"></el-table-column>
      <el-table-column label="分值" align="center" prop="score" width="100%"></el-table-column>
      <el-table-column label="对应星级" align="center" width="145%">
        <template slot-scope="scope">
          <el-rate v-model="scope.row.star" disabled></el-rate>
        </template>
      </el-table-column>
    </el-table>
  </div>
  <br v-if="showFlag.descTableShow">
<!--  <br>-->
<!--  <div>-->
<!--    <el-table :data="realTimeShowTableData"-->
<!--              style="width: 99%; margin: auto"-->
<!--              border-->
<!--              size="large"-->
<!--              :header-cell-style="{ backgroundColor:'#58c480', color: '#333'}">-->
<!--      <el-table-column label="类别" align="center" prop="rateType" width="100"></el-table-column>-->
<!--      <el-table-column label="评价细则" align="center" prop="rateDetail"></el-table-column>-->
<!--      <el-table-column label="选中星级" align="center" prop="star" width="150">-->
<!--        <template slot-scope="scope">-->
<!--          <el-rate v-model="scope.row.star" :disabled="true"></el-rate>-->
<!--        </template>-->
<!--      </el-table-column>-->
<!--      <el-table-column label="得分" align="center" prop="score" width="110"></el-table-column>-->
<!--    </el-table>-->
<!--  </div>-->
  <br>
  <div>
    <el-table :data="rateTableData"
              border
              style="margin: auto; width: 99%"
              :span-method="rateTableMethod"
              stripe
              size="large"
              :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }"
              v-loading="!reqFlag.getUsersList"
              :height="tableHeight"
              ref="rateTable">
      <el-table-column label="姓名" align="center" prop="ratedName" min-width="50"></el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 15" label="定量评价" align="center">
        <el-table-column v-if="$store.state.userInfo.id === 15" label="定量得分" align="center" prop="quantitativeScore" width="77"></el-table-column>
        <el-table-column v-if="$store.state.userInfo.id === 15" label="定量排名" align="center" prop="quantitativeRank" width="77"></el-table-column>
      </el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 15" label="定性互评" align="center">
        <el-table-column v-if="$store.state.userInfo.id === 15" label="互评得分" align="center" prop="multualScore" width="77"></el-table-column>
        <el-table-column v-if="$store.state.userInfo.id === 15" label="互评排名" align="center" prop="multualRank" width="77"></el-table-column>
      </el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 15" label="绩效评价" align="center">
        <el-table-column v-if="$store.state.userInfo.id === 15" label="绩效得分" align="center" prop="performanceScore" width="77"></el-table-column>
        <el-table-column v-if="$store.state.userInfo.id === 15" label="绩效排名" align="center" prop="performanceRank" width="77"></el-table-column>
      </el-table-column>
      <el-table-column v-if="$store.state.userInfo.id === 15" label="领导评价得分" align="center" prop="totalScore" width="77"></el-table-column>
      <el-table-column label="工作态度" align="center">
          <el-table-column label="责任意识(15%)" align="center" min-width="110">
            <template slot-scope="scope">
<!--              <el-popover placement="top-start" title="测试" trigger="manual" content="jsdklfjdd" v-model="visible">-->
                <el-rate v-model="scope.row.t1Star"
                         @change="handleT1StarChange(scope.row)" slot="reference" style="size: 50px"></el-rate>
<!--              </el-popover>-->
            </template>
          </el-table-column>
          <el-table-column label="团队协作(15%)" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t2Star"
                       @change="handleT2StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="组织纪律(15%)" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t3Star"
                       @change="handleT3StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
        </el-table-column>
      <el-table-column label="工作能力" align="center">
          <el-table-column label="计划能力(10%)" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t4Star"
                       @change="handleT4StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="执行能力(30%)" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t5Star"
                       @change="handleT5StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="综合能力(15%)" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t6Star"
                       @change="handleT6StarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
        </el-table-column>
      <el-table-column v-if="$store.state.userInfo.id !== 15" label="总分" align="center" prop="totalScore" min-width="50"></el-table-column>
    </el-table>
    <br>
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
    getAllWorkTimeList,
    getAllUserRates } from '@/config/interface'
  import CountTo from 'vue-count-to'
  export default {
    data () {
      return {
        formData: {
          title: this.$moment().format('YYYY-MM')
        },
        showFlag: {
          descTableShow: false
        },
        tableData: [{
          l1: '工作态度',
          l2: '责任意识',
          standard: '明确岗位职责，工作积极主动，自觉对行为后果负责。长期主动加班',
          score: '92.5',
          star: 5
        }, {
          l1: '工作态度',
          l2: '责任意识',
          standard: '明确岗位职责，能够较好完成交办工作，对行为后果负责。经常主动加班',
          score: '90',
          star: 4
        }, {
          l1: '工作态度',
          l2: '责任意识',
          standard: '在有上级监督的情况下，能完成交办工作，对行为及后果负责。偶尔加班',
          score: '87.5',
          star: 3
        }, {
          l1: '工作态度',
          l2: '责任意识',
          standard: '对本职工作不够上心，对交办工作需多次督促方能完成，出现问题有时会逃避责任。几乎不加班。',
          score: '85',
          star: 2
        }, {
          l1: '工作态度',
          l2: '责任意识',
          standard: '对本职工作不上心，未能有效履职，对工作中的失误经常逃避责任，爱埋怨和做各种解释。从不加班。',
          score: '82.5',
          star: 1
        }, {
          l1: '工作态度',
          l2: '团队协作',
          standard: '具有较强的团队协作精神，主动积极协助同事配合完成工作',
          score: '92.5',
          star: 5
        }, {
          l1: '工作态度',
          l2: '团队协作',
          standard: '具有团队协作精神，能与内、外部相关业务往来部门保持正常的工作联系',
          score: '90',
          star: 4
        }, {
          l1: '工作态度',
          l2: '团队协作',
          standard: '具有一定的团队协作精神，基本能与内、外部相关业务往来部门保持正常的工作联系',
          score: '87.5',
          star: 3
        }, {
          l1: '工作态度',
          l2: '团队协作',
          standard: '欠缺团队协作精神，缺乏与内、外部相关业务往来部门的工作联系',
          score: '85',
          star: 2
        }, {
          l1: '工作态度',
          l2: '团队协作',
          standard: '不具备团队协作精神，不能与内、外部相关业务往来部门建立工作联系',
          score: '82.5',
          star: 1
        }, {
          l1: '工作态度',
          l2: '组织纪律',
          standard: '具有极强的组织纪律性。严格遵守公司相关规定。工作认真，' +
            '上班期间不做与工作无关事务；遵守考勤纪律，且请假前能够做好工作安排，' +
            '休假期间及时处理事务；日常着装完全符合要求；桌面摆放整洁，符合5S要求。积极组织或参与团队活动',
          score: '92.5',
          star: 5
        }, {
          l1: '工作态度',
          l2: '组织纪律',
          standard: '具有较强的组织纪律性。较好地遵守公司考勤、着装、5S相关规定。能够每天清理门户待办及邮件。主动组织或参与团队活动',
          score: '90',
          star: 4
        }, {
          l1: '工作态度',
          l2: '组织纪律',
          standard: '组织纪律性一般。能够遵守公司考勤、着装、5S相关规定。能够参与团队活动',
          score: '87.5',
          star: 3
        }, {
          l1: '工作态度',
          l2: '组织纪律',
          standard: '组织纪律性较差。上班期间做与工作无关的事务或以公务外出名义脱岗；着装偶尔不符合要求；桌面凌乱，需别人督促整理。偶尔参加团队活动',
          score: '85',
          star: 2
        }, {
          l1: '工作态度',
          l2: '组织纪律',
          standard: '组织纪律性差。上班期间常做与工作无关的事务；着装经常不符合要求；未请假脱岗；桌面凌乱，督促整理仍不改进。从不参加团队活动',
          score: '82.5',
          star: 1
        }, {
          l1: '工作能力',
          l2: '计划能力',
          standard: '具有极强的计划能力。能够根据部门、处工作要求制定完善的工作计划并进行有效分解，个人工作分配合理，目标清晰、创新性强',
          score: '92.5',
          star: 5
        }, {
          l1: '工作能力',
          l2: '计划能力',
          standard: '具有较强的计划能力。能够根据部门、处管理要求制定详细的工作计划，个人(团队)工作目标清晰',
          score: '90',
          star: 4
        }, {
          l1: '工作能力',
          l2: '计划能力',
          standard: '(组员)计划能力一般。个人工作目标不够清晰，创新性不强;' +
            '(组长)计划能力一般。能带领导团队制订团队计划并有效分解，但团队目标不够清晰，创新性不强',
          score: '87.5',
          star: 3
        }, {
          l1: '工作能力',
          l2: '计划能力',
          standard: '(组员)计划能力较差。个人工作计划不够明确或不合理;' +
            '(组长)计划能力较差。能够制定团队计划但未能有效分解或分配不合理',
          score: '85',
          star: 2
        }, {
          l1: '工作能力',
          l2: '计划能力',
          standard: '计划能力差。个人(团队)工作计划无计划、随意',
          score: '82.5',
          star: 1
        }, {
          l1: '工作能力',
          l2: '执行能力',
          standard: '具有极强的执行力。(团队)能够按工作计划严格执行，并确保在每个细节上减少差错。' +
            '时间和资源的利用达到最佳，工作效率高，完成任务速度快，质量高，效益好。',
          score: '92.5',
          star: 5
        }, {
          l1: '工作能力',
          l2: '执行能力',
          standard: '具有较强的执行力。(团队)能够按工作计划严格执行，比较注意细节，' +
            '偶有差错发生并能迅速改正。(班组)工作效率尚可，能分清主次，基本保证质量',
          score: '90',
          star: 4
        }, {
          l1: '工作能力',
          l2: '执行能力',
          standard: '执行力一般。(团队)基本能够按照工作计划执行，但进度及质量管理能力一般',
          score: '87.5',
          star: 3
        }, {
          l1: '工作能力',
          l2: '执行能力',
          standard: '执行力较差，未能够按计划推进工作，工作效率较低或需反复催办才能完成工作，工作质量低',
          score: '85',
          star: 2
        }, {
          l1: '工作能力',
          l2: '执行能力',
          standard: '执行力差。工作随意，常出差错或无法按要求完成任务',
          score: '82.5',
          star: 1
        }, {
          l1: '工作能力',
          l2: '综合能力',
          standard: '(组员)个人学习能力、文字表达能力及组织协调能力极强。' +
            '能够将理论与实践相结合，把学习知识用于工作改进与创新；' +
            '具有良好的人际沟通能力，积极主动与上级领导、同事沟通工作事件，促进工作高效完成;' +
            '(组长)个人学习能力、文字表达能力及组织协调能力极强；能够制订团队培训计划并按计划推进，团队培训效果好；' +
            '能够指导团队成员将理论与实践相结合，把学习知识用于工作改进与创新。具有良好的人际沟通能力，' +
            '积极主动与上级领导、同事沟通工作事件，促进团队工作高效完成。;',
          score: '92.5',
          star: 5
        }, {
          l1: '工作能力',
          l2: '综合能力',
          standard: '(组员)个人学习能力、文字表达能力及组织协调能力较强。具有一定的沟通能力，遇到问题时能与上级领导同事沟通' +
            '(组长)个人学习能力、文字表达能力及组织协调能力较强；能够制订团队培训计划并按计划推进；能够有效指导团队成员开展工作。' +
            '具有一定的沟通能力，遇到问题时能与上级领导同事沟通。',
          score: '90',
          star: 4
        }, {
          l1: '工作能力',
          l2: '综合能力',
          standard: '个人学习能力、文字表达能力及组织协调能力一般。(偶尔组织团队培训；指导团队成员开展工作的能力一般)沟通能力一般，可以保证正常沟通，偶有障碍',
          score: '87.5',
          star: 3
        }, {
          l1: '工作能力',
          l2: '综合能力',
          standard: '个人学习能力、文字表达能力及组织协调能力较弱。(较少组织团队培训；指导团队成员开展工作的能力较弱)，欠缺沟通能力不知用什么方法沟通工作',
          score: '85',
          star: 2
        }, {
          l1: '工作能力',
          l2: '综合能力',
          standard: '个人学习能力、文字表达能力及组织协调能力弱。(无主动学习意识；未组织团队培训；未能指导团队成员开展工作)，不具备沟通能力，人际关系较差',
          score: '82.5',
          star: 1
        }],
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
          getAllWorkTimeList: true,
          getAllUserRates: true
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
        directorQuantitativeCof: this.$store.state.directorQuantitativeCof
      }
    },
    methods: {
      // 初始化
      init () {
        let _this = this
        let promises = []
        let count = 0
        this.getCookie()
        // this.getCurMutualRate()
        this.getUsersList().then(res1 => {
          _this.users = res1
          _this.getUserRates().then(res2 => {
            _this.isRated = res2.length !== 0
            _this.genRateTableData(res1, res2)
            if (this.$store.state.userInfo.id === 15) {
              promises[count++] = this.getQuantitativeInfo() // 获取定量评价结果
              promises[count++] = this.getAllMultualEvaResult() // 获取全处互评结果
            }
            Promise.all(promises).then(result => {
              if (!result[0].err) { // 工时已截止且审核完毕
                this.genQuantativeData(result[0].content)
              }
              if (!result[1].err) { // 互评已截止
                this.genMultualEvaData(result[1].content)
              }
              if (!result[0].err && !result[1].err) {
              }
            }).catch(err => {
              this.$common.toast(err, 'error', true)
            })
          })
        })
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
          for (let item of totalWorkTimeCal) { // 计算定量指标得分
            item.quantitativeScore = this.calGetScore(length, item.rank)
          }
        }
        return totalWorkTimeCal
      },
      // 生成定量数据
      genQuantativeData (quantativeData) {
        let allQuantitativeScore = []
        let groupedWorkTimeList = this.groupedWorkTimeList(quantativeData) // 对数据进行分组
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
          item.quantitativeScore = allQuantitativeScoreFindResult.quantitativeScore
          item.quantitativeRank = allQuantitativeScoreFindResult.rank
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
          item.multualScore = multualRestulsFindResult.staffMutualScore
          item.multualRank = multualRestulsFindResult.staffRateRank
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
        let rankPercentage = Number((rank / length).toFixed(1))
        if (rankPercentage < 0.1 || rankPercentage === 0.1 || rank === 1) {
          return 92.5
        } else if (rankPercentage < 0.3 || rankPercentage === 0.3) {
          return 90
        } else if (rankPercentage < 0.7 || rankPercentage === 0.7) {
          return 87.5
        } else if (rankPercentage < 0.9 || rankPercentage === 0.9) {
          return 85
        } else if (rankPercentage < 1 || rankPercentage === 1) {
          return 82.5
        }
      },
      // 计算定性评价排名与得分
      calMutualRatesRank (allUserRates) {
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
          if (item.id === 7 || item.id === 11) { // 主任岗
            item.mutualScore = item.staffMutualScore * this.directorMutualCof +
              item.managerScore * this.directorManagerCof
          } else if (item.id === 13 || item.id === 17) { // 组长
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
          if (item.id === 7 || item.id === 11) { // 主任岗
            item.mutualScore = item.staffMutualScore * this.directorMutualCof +
              item.managerScore * this.directorManagerCof
          } else if (item.id === 13 || item.id === 17) { // 组长
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
          if (item.id === 7 || item.id === 11) { // 主任岗
            item.performanceScore = item.quantitativeScore * this.directorQuantitativeCof + item.mutualScore
          } else if (item.id === 13 || item.id === 17) { // 组长
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
      // 计算互评得分
      getMulRated (ratedData) {
        let ratesTableTmp = []
        let manageRate = 0
        let totalRate = 0
        let count = 0
        if (ratedData.length !== 0) {
          for (let item of ratedData) {
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
                console.log(res.data)
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
                item.multualScore = '互评尚未截止'
                item.multualRank = '互评尚未截止'
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
        this.$http(url, params)
          .then(res => {
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
            _this.$http(url, params)
              .then(res => {
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
                    ratedID: user.id,
                    ratedName: user.name,
                    t1Star: this.defaultStar,
                    t2Star: this.defaultStar,
                    t3Star: this.defaultStar,
                    t4Star: this.defaultStar,
                    t5Star: this.defaultStar,
                    t6Star: this.defaultStar,
                    quantitativeScore: null,
                    quantitativeRank: null,
                    multualScore: null,
                    multualRank: null,
                    performanceScore: null,
                    performanceRank: null
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
                    ratedID: user.id,
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
                  ratedID: user.id,
                  ratedName: user.name,
                  t1Star: this.defaultStar,
                  t2Star: this.defaultStar,
                  t3Star: this.defaultStar,
                  t4Star: this.defaultStar,
                  t5Star: this.defaultStar,
                  t6Star: this.defaultStar,
                  quantitativeScore: null,
                  quantitativeRank: null,
                  multualScore: null,
                  multualRank: null,
                  performanceScore: null,
                  performanceRank: null
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
                multualScore: null,
                multualRank: null,
                performanceScore: null,
                performanceRank: null
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
        }
      },
      // 上一月
      handlePreMonth () {
        this.formData.title = this.$moment(this.formData.title).subtract(1, 'months').format('YYYY-MM')
        this.setMonthCookie(this.formData.title, 7)
        this.handelDateChange()
      },
      // 下一月
      handleNextMonth () {
        this.formData.title = this.$moment(this.formData.title).add(1, 'months').format('YYYY-MM')
        this.setMonthCookie(this.formData.title, 7)
        this.handelDateChange()
      },
      // 申报月份变化
      handelDateChange () {
        let _this = this
        this.getUserRates().then(res1 => {
          _this.isRated = res1.length !== 0
          _this.genRateTableData(_this.users, res1)
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
      // 评分项1星级变化
      handleT1StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(1, row.ratedPersion, this.starToRates(row.t1Star))
        this.updateRealTimeShowTableData(1, row.t1Star)
      },
      // 评分项2星级变化
      handleT2StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(2, row.ratedPersion, this.starToRates(row.t2Star))
        this.updateRealTimeShowTableData(2, row.t2Star)
      },
      // 评分项3星级变化
      handleT3StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(3, row.ratedPersion, this.starToRates(row.t3Star))
        this.updateRealTimeShowTableData(3, row.t3Star)
      },
      // 评分项4星级变化
      handleT4StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(4, row.ratedPersion, this.starToRates(row.t4Star))
        this.updateRealTimeShowTableData(4, row.t4Star)
      },
      // 评分项5星级变化
      handleT5StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(5, row.ratedPersion, this.starToRates(row.t5Star))
        this.updateRealTimeShowTableData(5, row.t5Star)
      },
      // 评分项6星级变化
      handleT6StarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
        this.updateRateRawRateData(6, row.ratedPersion, this.starToRates(row.t6Star))
        this.updateRealTimeShowTableData(6, row.t6Star)
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
            this.$http(url, params)
              .then(res => {
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
      // 填报说明显示
      descriprionClick () {
      }
    },
    components: {
      // CountTo
    },
    created () {
      this.init()
    },
    watch: {
    },
    mounted () {
      console.log('mounted')
      this.refreshTableSize()
    },
    name: 'multualEvaluation'
  }
</script>

<style scoped>
</style>

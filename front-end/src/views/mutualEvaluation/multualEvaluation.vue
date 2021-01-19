<template>
<div>
  <el-form class="main-search" :inline="true">
    <el-row>
      <el-col :span="10">
        <el-form-item label="互评月份：" prop="title">
          <el-button size="mini" type="danger" style="margin-right: 10px" @click="handlePreMonth">上月</el-button>
          <el-date-picker
            v-model="formData.title"
            type="month"
            format="yyyy 第 MM 月"
            value-format="yyyy-MM"
            placeholder="选择月"
            style="width: 150px"
            @change="handelDateChange">
          </el-date-picker>
          <el-button size="mini" type="success" style="margin-left: 10px" @click="handleNextMonth">下月</el-button>
        </el-form-item>
      </el-col>
      <el-col :span="4" :offset="10">
        <el-button type="primary" @click="submitRatesResult">提交</el-button>
        <el-button type="warning" @click="resetTable">重置</el-button>
      </el-col>
    </el-row>
  </el-form>
  <!-- 分割线 start -->
  <div class="hr-10"></div>
  <!-- 分割线 end -->
  <br>
  <div style="margin-left: 20px">
    <span style="font-size: 15px">评价标准显示：</span>
    <el-switch v-model="showFlag.descTableShow" @change="handleSwitchChange"></el-switch>
  </div>
  <br v-if="showFlag.descTableShow">
  <div v-if="showFlag.descTableShow">
    <el-table :data="tableData"
              border
              style="margin: auto; width: 99%"
              :span-method="objectSpanMethod"
              stripe
              :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }">
      <el-table-column label="序号" align="center" width="50%" type="index"></el-table-column>
      <el-table-column label="一级指标" align="center" width="100%" prop="l1"></el-table-column>
      <el-table-column label="二级指标" align="center" width="100%" prop="l2"></el-table-column>
      <el-table-column label="评分衡量标准" align="center" prop="standard" show-overflow-tooltip></el-table-column>
      <el-table-column label="分值" align="center" prop="score" width="100%"></el-table-column>
      <el-table-column label="对应星级" align="center" width="145%">
        <template slot-scope="scope">
          <el-rate v-model="scope.row.star" disabled></el-rate>
        </template>
      </el-table-column>
    </el-table>
  </div>
  <br v-if="showFlag.descTableShow">
  <br>
  <div>
    <el-table :data="rateTableData"
              border
              style="margin: auto; width: 99%"
              :span-method="rateTableMethod"
              stripe
              size="mini"
              :header-cell-style="{ backgroundColor:'#48bfe5', color: '#333' }">
      <el-table-column label="姓名" align="center" prop="ratedName" min-width="30"></el-table-column>
      <el-table-column label="评价项" align="center">
        <el-table-column label="工作态度" align="center">
          <el-table-column label="责任意识" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t1Star" show-text :texts="scoreText" @change="handleStarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="团队协作" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t2Star" show-text :texts="scoreText" @change="handleStarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="组织纪律" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t3Star" show-text :texts="scoreText" @change="handleStarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
        </el-table-column>
        <el-table-column label="工作能力" align="center">
          <el-table-column label="计划能力" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t4Star" show-text :texts="scoreText" @change="handleStarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="执行能力" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t5Star" show-text :texts="scoreText" @change="handleStarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
          <el-table-column label="综合能力" align="center" min-width="110">
            <template slot-scope="scope">
              <el-rate v-model="scope.row.t6Star" show-text :texts="scoreText" @change="handleStarChange(scope.row)"></el-rate>
            </template>
          </el-table-column>
        </el-table-column>
      </el-table-column>
      <el-table-column label="总分" align="center" prop="totalScore" width="70"></el-table-column>
    </el-table>
    <br>
    <br>
  </div>
</div>
</template>

<script>
  import { getUsersName, getUserRates, submitRatesResult } from '@/config/interface'
  export default {
    data () {
      return {
        formData: {
          title: this.$moment().format('YYYY-MM')
        },
        showFlag: {
          descTableShow: true
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
          standard: '计划能力一般。个人工作目标不够清晰，创新性不强(组员);' +
            '计划能力一般。能带领导团队制订团队计划并有效分解，但团队目标不够清晰，创新性不强(组长)',
          score: '87.5',
          star: 3
        }, {
          l1: '工作能力',
          l2: '计划能力',
          standard: '计划能力较差。个人工作计划不够明确或不合理(组员);' +
            '计划能力较差。能够制定团队计划但未能有效分解或分配不合理(组长)',
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
          standard: '个人学习能力、文字表达能力及组织协调能力极强。' +
            '能够将理论与实践相结合，把学习知识用于工作改进与创新；' +
            '具有良好的人际沟通能力，积极主动与上级领导、同事沟通工作事件，促进工作高效完成(组员);' +
            '个人学习能力、文字表达能力及组织协调能力极强；能够制订团队培训计划并按计划推进，团队培训效果好；' +
            '能够指导团队成员将理论与实践相结合，把学习知识用于工作改进与创新。具有良好的人际沟通能力，' +
            '积极主动与上级领导、同事沟通工作事件，促进团队工作高效完成。(组长);',
          score: '92.5',
          star: 5
        }, {
          l1: '工作能力',
          l2: '综合能力',
          standard: '个人学习能力、文字表达能力及组织协调能力较强。具有一定的沟通能力，遇到问题时能与上级领导同事沟通(组员)' +
            '个人学习能力、文字表达能力及组织协调能力较强；能够制订团队培训计划并按计划推进；能够有效指导团队成员开展工作。' +
            '具有一定的沟通能力，遇到问题时能与上级领导同事沟通。(组长)',
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
        rateTableData: [],
        users: [],
        defaultStar: 3,
        scoreText: ['82.5', '85', '87.5', '90', '92.5']
      }
    },
    methods: {
      // 初始化
      init () {
        let _this = this
        this.getCookie()
        this.getUsersList().then(res1 => {
          _this.users = res1
          _this.getUserRates().then(res2 => {
            _this.genRateTableData(res1, res2)
          })
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
      // 获取用户列表
      getUsersList () {
        const url = getUsersName
        let params = {}
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                console.log(res.data)
                resolve(res.data.list)
              }
            })
        })
      },
      // 获取互评信息
      getUserRates () {
        const url = getUserRates
        let params = {
          userID: this.$store.state.userInfo.id,
          rateMonth: this.formData.title
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params)
            .then(res => {
              if (res.code === 1) {
                console.log(res.data)
                resolve(res.data)
              }
            })
        })
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
        this.rateTableData = []
        let curGroupName = this.$store.state.userInfo.groupName
        let curID = this.$store.state.userInfo.id
        if (rates.length === 0) { // 该月还未进行互评
          for (let user of users) {
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
                  t6Star: this.defaultStar
                }
                obj.totalScore = this.calMultualScore(obj.t1Star, obj.t2Star, obj.t3Star,
                  obj.t4Star, obj.t5Star, obj.t6Star)
                this.rateTableData.push(obj)
              }
            }
          }
        } else {
          for (let user of users) {
            if (curGroupName === '技术标准组' || curGroupName === '工程组') { // 当前用户属于技术标准组和工程组
              if (user.groupName === '技术标准组' && user.id !== curID) {
                let obj = {
                  ratedID: user.id,
                  ratedName: user.name
                }
              }
            } else if (curGroupName === '通信组') { // 当前用户属于通信组
            } else { // 处经理
            }
          }
        }
      },
      // 上一月
      handlePreMonth () {
        this.formData.title = this.$moment(this.formData.title).subtract(1, 'months').format('YYYY-MM')
        this.handelDateChange()
      },
      // 下一月
      handleNextMonth () {
        this.formData.title = this.$moment(this.formData.title).add(1, 'months').format('YYYY-MM')
        this.handelDateChange()
      },
      // 申报月份变化
      handelDateChange () {
        let _this = this
        this.getUserRates().then(res1 => {
          _this.genRateTableData(_this.users, res1)
        })
      },
      // 表格合并方法
      objectSpanMethod ({ row, column, rowIndex, columnIndex }) {
        if (columnIndex === 1) {
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
        if (columnIndex === 2) {
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
          }
        }
      },
      // 标准表格显示开关
      handleSwitchChange () {
        console.log(this.showFlag.descTableShow)
        this.setCookie(this.showFlag.descTableShow, 7)
      },
      // 评分表格合并方法
      rateTableMethod () {
      },
      // 星级变化
      handleStarChange (row) {
        row.totalScore = this.calMultualScore(row.t1Star, row.t2Star, row.t3Star, row.t4Star, row.t5Star, row.t6Star)
      },
      // 提交
      submitRatesResult () {
        const url = submitRatesResult
        let params = {
        }
      },
      // 重置
      resetTable () {
      }
    },
    created () {
      this.init()
    },
    name: 'multualEvaluation'
  }
</script>

<style scoped>
  .el-tooltip__popper{
    max-width: 50%;
  }
</style>

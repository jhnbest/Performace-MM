import Vue from 'vue'
import Vuex from 'vuex'
import * as types from './mutation-types.js'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    userInfo: !localStorage.getItem('userInfo') ? {} : JSON.parse(localStorage.getItem('userInfo')),
    menuList: [
      { name: '首页', url: '/home/dashboard', icon: 'el-icon-house' },
      { name: '个人工作台', url: '/home/workStation', icon: 'el-icon-bank-card' },
      // { name: '工作计划', url: '/home/weekly', icon: 'el-icon-s-grid' },
      { name: '工时查询', url: '/home/performance', icon: 'el-icon-document', dutyHide: 1 },
      { name: '月总结', url: '/home/monthConclusion', icon: 'el-icon-edit-outline', noShowID: 35, dutyHide: 1 },
      { name: '定性评价', url: '/home/mutualEvaluation', icon: 'el-icon-chat-dot-square' },
      { name: '成效评价', url: '/home/AMEvaluation', icon: 'el-icon-data-line' },
      { name: '绩效加分', url: '/home/PerformanceBonusIndex', icon: 'el-icon-s-claim' }
    ],
    workTimeManagerList: [
      { name: '工时审核', url: '/home/workTimeReview', icon: 'el-icon-setting' },
      { name: '工时查询', url: '/home/workTimeCheck', icon: 'el-icon-setting' },
      { name: '绩效加分审核', url: '/home/PerformanceBonusReview', icon: 'el-icon-setting' },
      { name: '成效评价失败监控', url: '/home/FailedAMEvaMonitor', icon: 'el-icon-warning' },
      { name: '定时任务管理', url: '/home/cronJob', icon: 'el-icon-timer' },
      { name: '工时统计', url: '/home/workHourStatistics', icon: 'el-icon-s-data' }
      // { name: '计划查询', url: '/home/workPlanCheck', icon: 'el-icon-s-opportunity' },
      // { name: '月总结评价', url: '/home/conclusionEva', icon: 'el-icon-check' },
      // { name: '定性评价管理', url: '/home/mulEvaCheck', icon: 'el-icon-s-opportunity' }
      // { name: '用户管理', url: '/home/users', icon: 'el-icon-user-solid' },
    ],
    pageSize: 100, // 每页请求多少条
    refreshInterval: 300, // 组件手动刷新间隔 ms
    commonStaffMutualCof: 0.1, // 普通员工对普通员工的定性评价权重
    commonStaffManagerCof: 0.2, // 管理者对普通员工的定性评价权重
    commonStaffQuantitativeCof: 0.7, // 普通员工定量评价权重
    groupLeaderMutualCof: 0.3, // 普通员工对组长的定性评价权重
    groupLeaderManagerCof: 0.4, // 管理者对组长的定性评价权重
    groupLeaderQuantitativeCof: 0.3, // 组长定量评价权重
    directorMutualCof: 0.2, // 普通员工对主任岗的定性评价权重
    directorManagerCof: 0.3, // 管理者对主任岗的定性评价权重
    directorQuantitativeCof: 0.5, // 主任岗定量评价权重
    managerID: 35,
    monthStarNum: 2,
    quarterStarNum: 2,
    defaultConclusionGetWorkTime: 10, // 月总结默认获得工时
    defaultConclusionEvaStar: 3, // 月总结默认评价星级
    usersNum: 23, // 处室员工总数
    CSManagerPMEvaCof: 0.3, // 处经理对普通员工的成效评价系数
    CSGroupLeaderAMEvaCoef: 0.2, // 组长对普通员工的成效评价系数
    CScommonStaffAMEvaCoef: 0.5, // 普通员工对普通员工的成效评价系数
    GPManagerAMEvaCoef: 0.5, // 处经理对组长的成效评价系数
    GPCommonStaffAMEvaCoef: 0.5, // 普通员工对组长的成效评价系数
    defaultStar: 3, // 默认评价星级
    newRulesDate: '2022-02', // 成效评价实施时间,
    newRulesUpdateDate: '2023-05', // 成效评价更新1,
    newRulesTeamWork: '2023-12', // **开始实行小组工作评价的月份-1个月
    newRulesPBScore: '2024-03', // **开始实行绩效加分规则的月份-1个月
    newRulesConclusionMerge: '2026-05', // **月总结表单合并且份（打造精品工程+创建专业团队→月度总结）
    monthConclusionType: 1,
    conclusionTextNew: {
      buildBoutiqueProject: {
        dimension: 1,
        content: ''
                //  '【承担工作难度】：\n' + '<br>' + '<br>' +
                //  '【专业技术研究】：\n' + '<br>' + '<br>' +
                //  '【工作方法创新】：\n' + '<br>' + '<br>' +
                //  '【工作推进效率】：\n' + '<br>' + '<br>' +
                //  '【工作完成效果】：\n' + '<br>' + '<br>' +
                //  '【降本增效举措】：\n'
      },
      buildProTeam: {
        dimension: 2,
        content: ''
                // '【处室绩效贡献】：\n' + '<br>' + '<br>' +
                // '【团队协作贡献】：\n' + '<br>' + '<br>' +
                // '【团建活动和宣传】：\n' + '<br>' + '<br>'
      },
      nextPlan: {
        dimension: 3,
        content: ''
      },
      curAdvice: {
        dimension: 4,
        content: ''
      }
    },
    conclusionTextNewGP: {
      buildBoutiqueProject: {
        dimension: 1,
        content: ''
                //  '【承担工作难度】：\n' + '<br>' + '<br>' +
                //  '【专业技术研究】：\n' + '<br>' + '<br>' +
                //  '【工作方法创新】：\n' + '<br>' + '<br>' +
                //  '【工作推进效率】：\n' + '<br>' + '<br>' +
                //  '【工作完成效果】：\n' + '<br>' + '<br>' +
                //  '【降本增效举措】：\n'
      },
      buildProTeam: {
        dimension: 2,
        content: ''
                // '【处室绩效贡献】：\n' + '<br>' + '<br>' +
                // '【团队协作贡献】：\n' + '<br>' + '<br>' +
                // '【团建活动和宣传】：\n' + '<br>' + '<br>'
      },
      nextPlan: {
        dimension: 3,
        content: ''
      },
      curAdvice: {
        dimension: 4,
        content: ''
      },
      teamWork: {
        dimension: 5,
        content: ''
      }
    },
    // 合并模式下的月总结维度定义（2026年5月起，打造精品工程+创建专业团队→月度总结）
    conclusionTextNewMerged: {
      monthSummary: {
        dimension: 1,
        content: ''
      },
      nextPlan: {
        dimension: 3,
        content: ''
      },
      curAdvice: {
        dimension: 4,
        content: ''
      }
    },
    conclusionTextNewGPMerged: {
      monthSummary: {
        dimension: 1,
        content: ''
      },
      nextPlan: {
        dimension: 3,
        content: ''
      },
      curAdvice: {
        dimension: 4,
        content: ''
      },
      teamWork: {
        dimension: 5,
        content: ''
      }
    },
    progressColors: [
      { color: '#f56c6c', percentage: 20 },
      { color: '#e6a23c', percentage: 40 },
      { color: '#ffdd00', percentage: 60 },
      { color: '#1989fa', percentage: 90 },
      { color: '#00ffa6', percentage: 100 }
    ],
    organization: [{
      name: '组织',
      options: [{
        value: 'total',
        name: '全处室',
        id: '0',
        disabled: false
      }, {
        value: 'MediaGroup',
        name: '多媒体应用组',
        id: '2',
        disabled: false
      }, {
        value: 'DigitalGroup',
        name: '数字物联组',
        id: '3',
        disabled: false
      }, {
        value: 'ZongheGroup',
        name: '综合业务组',
        id: '4',
        disabled: false
      }, {
        value: 'CommueGroup',
        name: '通信组',
        id: '5',
        disabled: false
      }]
    }, {
      name: '个人',
      options: []
    }],
    groupNameFilter (groupID) {
      switch (groupID) {
        case 0:
          return 'success'
        case 2:
          return 'success'
        case 3:
          return 'warning'
        case 4:
          return 'danger'
        case 5:
          return 'primary'
        default:
          return 'info'
      }
    }
  },
  mutations: {
    [types.SAVE_USERINFO] (state, data) {
      state.userInfo = data
    }
  },
  actions: {
    saveUserInfo ({ commit }, data) {
      commit(types.SAVE_USERINFO, data)
    }
  }
})

import Vue from 'vue'
import Vuex from 'vuex'
import * as types from './mutation-types.js'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    userInfo: !localStorage.getItem('userInfo') ? {} : JSON.parse(localStorage.getItem('userInfo')),
    menuList: [
      { name: '首页', url: '/home/dashboard', icon: 'el-icon-s-home' },
      { name: '个人工作台', url: '/home/workStation', icon: 'el-icon-s-data' },
      // { name: '工作计划', url: '/home/weekly', icon: 'el-icon-s-grid' },
      { name: '计划/工时查询', url: '/home/performance', icon: 'el-icon-s-order' },
      { name: '月总结', url: '/home/monthConclusion', icon: 'el-icon-s-finance' },
      { name: '定性评价', url: '/home/mutualEvaluation', icon: 'el-icon-s-finance' }
    ],
    workTimeManagerList: [
      { name: '工时审核', url: '/home/workTimeReview', icon: 'el-icon-s-claim' },
      { name: '工时查询', url: '/home/workTimeCheck', icon: 'el-icon-s-claim' },
      { name: '计划查询', url: '/home/workPlanCheck', icon: 'el-icon-s-opportunity' },
      { name: '月总结评价', url: '/home/conclusionEva', icon: 'el-icon-check' },
      { name: '定性评价管理', url: '/home/mulEvaCheck', icon: 'el-icon-s-opportunity' },
      { name: '用户管理', url: '/home/users', icon: 'el-icon-user-solid' }
    ],
    pageSize: 100, // 每页请求多少条
    refreshInterval: 300, // 组件手动刷新间隔 ms
    commonStaffMutualCof: 0.1,
    commonStaffManagerCof: 0.2,
    commonStaffQuantitativeCof: 0.7,
    groupLeaderMutualCof: 0.3,
    groupLeaderManagerCof: 0.4,
    groupLeaderQuantitativeCof: 0.3,
    directorMutualCof: 0.2,
    directorManagerCof: 0.3,
    directorQuantitativeCof: 0.5,
    managerID: 26,
    monthStarNum: 2,
    quarterStarNum: 2
  },
  mutations: {
    [types.SAVE_USERINFO] (state, data) {
      state.userInfo = data
      console.log(state.userInfo)
    }
  },
  actions: {
    saveUserInfo ({ commit }, data) {
      commit(types.SAVE_USERINFO, data)
    }
  }
})

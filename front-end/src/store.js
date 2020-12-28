import Vue from 'vue'
import Vuex from 'vuex'
import * as types from './mutation-types.js'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    userInfo: !localStorage.getItem('userInfo') ? {} : JSON.parse(localStorage.getItem('userInfo')),
    menuList: [
      { name: '首页', url: '/home/dashboard', icon: 'el-icon-s-data' },
      // { name: '用户管理', url: '/home/user', icon: 'el-icon-user' },
      { name: '个人工作台', url: '/home/workStation', icon: 'el-icon-s-unfold' },
      // { name: '工作计划', url: '/home/weekly', icon: 'el-icon-s-grid' },
      { name: '计划/工时查询', url: '/home/performance', icon: 'el-icon-s-order' },
      // { name: '定性互评', url: '/home/mutualEvaluation', icon: 'el-icon-s-order' }
    ],
    workTimeManagerList: [
      { name: '工时审核', url: '/home/workTimeReview', icon: 'el-icon-s-claim' },
      { name: '工时查询', url: '/home/workTimeCheck', icon: 'el-icon-s-claim' },
      { name: '计划查询', url: '/home/workPlanCheck', icon: 'el-icon-s-opportunity' },
      { name: '用户管理', url: '/home/users', icon: 'el-icon-user-solid' }
    ],
    pageSize: 100, // 每页请求多少条
    refreshInterval: 300 // 组件手动刷新间隔 ms
  },
  mutations: {
    [types.SAVE_USERINFO] (state, data) {
      state.userInfo = data
      console.log('===store.js 21')
      console.log(state.userInfo)
    }
  },
  actions: {
    saveUserInfo ({ commit }, data) {
      commit(types.SAVE_USERINFO, data)
    }
  }
})

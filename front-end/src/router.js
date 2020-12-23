/* eslint-disable */
import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

const originalPush = Router.prototype.push
Router.prototype.push = function push (location) {
  return originalPush.call(this, location).catch(err => err)
}

export default new Router({
  mode: 'hash',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'login',
      component: () => import('./views/Login.vue'),
      meta: { pagePath: '/' }
    },
    {
      path: '/home',
      name: 'home',
      component: () => import(/* webpackChunkName: "home" */ './views/Home.vue'),
      meta: { pagePath: '/home', requireAuth: true },
      children: [
        {
          path: 'dashboard',
          name: 'dashboard',
          component: () => import(/* webpackChunkName: "user" */ './views/Dashboard/index.vue'),
          meta: { pagePath: '/home/dashboard' }
        },
        {
          path: 'user',
          name: 'user',
          component: () => import(/* webpackChunkName: "user" */ './views/User/User.vue'),
          meta: { pagePath: '/home/user' }
        },
        {
          path: 'users',
          name: 'users',
          component: () => import(/* webpackChunkName: "users" */ './views/User/Users.vue'),
          meta: { pagePath: '/home/users' }
        },
        {
          path: 'workStation',
          name: 'workStation',
          component: () => import(/* webpackChunkName: "users" */ './views/WorkStation/WorkStation.vue'),
          meta: { pagePath: '/home/workStation' }
        },
        {
          path: 'projectPlanProcess',
          name: 'projectPlanProcess',
          component: () => import(/* webpackChunkName: "users" */ './views/WorkStation/childViews/ProjectPlanProcess.vue'),
          meta: { pagePath: '/home/workStation' }
        },
        {
          path: 'projectAssign',
          name: 'projectAssign',
          component: () => import(/* webpackChunkName: "users" */ './views/WorkStation/childViews/ProjectAssign.vue'),
          meta: { pagePath: '/home/workStation' }
        },
        {
          path: 'weekly',
          name: 'weekly',
          component: () => import(/* webpackChunkName: "weekly" */ './views/Weekly/Weekly.vue'),
          meta: { pagePath: '/home/weekly' }
        },
        {
          path: 'performance',
          name: 'performance',
          component: () => import(/* webpackChunkName: "weekly" */ './views/Performance/Performance.vue'),
          meta: { pagePath: '/home/performance' }
        },
        {
          path: 'workPlanCheck',
          name: 'workPlanCheck',
          component: () => import(/* webpackChunkName: "weekly" */ './views/workPlanCheck/workPlanCheck.vue'),
          meta: { pagePath: '/home/workPlanCheck' }
        },
        {
          path: 'weeklyadd',
          name: 'weeklyadd',
          component: () => import(/* webpackChunkName: "weekly" */ './views/Weekly/childViews/WeeklyAdd.vue'),
          meta: { pagePath: '/home/weekly' }
        },
        {
          path: 'weeklyedit',
          name: 'weeklyedit',
          component: () => import(/* webpackChunkName: "weekly" */ './views/Weekly/childViews/WeeklyEdit.vue'),
          meta: { pagePath: '/home/weekly' }
        },
        {
          path: 'weeklydetail',
          name: 'weeklydetail',
          component: () => import(/* webpackChunkName: "weekly" */ './views/Weekly/childViews/WeeklyDetail.vue'),
          meta: { pagePath: '/home/weekly' }
        },
        {
          path: 'performanceAdd',
          name: 'performanceAdd',
          component: () => import('./views/Performance/childViews/PerformanceAdd.vue'),
          meta: { pagePath: '/home/workStation' }
        },
        {
          path: 'performanceAddNew',
          name: 'performanceAddNew',
          component: () => import('./views/Performance/childViews/PerformanceAddNew.vue'),
          meta: { pagePath: '/home/workStation' }
        },
        {
          path: 'performanceEdit',
          name: 'performanceEdit',
          component: () => import('./views/Performance/childViews/PerformanceEdit.vue'),
          meta: { pagePath: '/home/performance' }
        },
        {
          path: 'workTimeReview',
          name: 'workTimeReview',
          component: () => import('./views/workTimeReview/WorkTimeReview.vue'),
          meta: { pagePath: '/home/workTimeReview' }
        },
        {
          path: 'test',
          name: 'test',
          component: () => import(/* webpackChunkName: "user" */ './components/test.vue'),
          meta: { pagePath: '/home/test' }
        }
      ]
    },
    {
      path: '/refresh',
      component: () => import(/* webpackChunkName: "home" */ './views/Refresh.vue'),
      name: 'Refresh',
      meta: { requireAuth: true }
    }
  ]
})

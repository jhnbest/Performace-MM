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
  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return {
        x: 0,
        y: 0
      }
    }
  },
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
          path: 'performance',
          name: 'performance',
          component: () => import(/* webpackChunkName: "weekly" */ './views/Performance/Performance.vue'),
          meta: { pagePath: '/home/performance', keepAlive: true }
        },
        {
          path: 'workPlanCheck',
          name: 'workPlanCheck',
          component: () => import(/* webpackChunkName: "weekly" */ './views/workPlanCheck/workPlanCheck.vue'),
          meta: { pagePath: '/home/workPlanCheck' }
        },
        {
          path: 'workTimeCheck',
          name: 'workTimeCheck',
          component: () => import(/* webpackChunkName: "weekly" */ './views/workTimeCheck/workTimeCheck.vue'),
          meta: { pagePath: '/home/workTimeCheck' }
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
          path: 'mutualEvaluation',
          name: 'mutualEvaluation',
          component: () => import('./views/mutualEvaluation/multualEvaluation'),
          meta: { pagePath: '/home/mutualEvaluation' }
        },
        {
          path: 'mulEvaCheck',
          name: 'mulEvaCheck',
          component: () => import('./views/mutualEvaluation/muLEvaCheck'),
          meta: { pagePath: '/home/mulEvaCheck' }
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
          component: () => import(/* webpackChunkName: "user" */ './components/workStation/projectOverview.vue'),
          meta: { pagePath: '/home/test' }
        },{
          path: 'monthConclusion',
          name: 'monthConclusion',
          component: () => import(/* webpackChunkName: "weekly" */ './views/monthConclusion/monthConclusion.vue'),
          meta: { pagePath: '/home/monthConclusion' }
        },{
          path: 'monthConclusionTable',
          name: 'monthConclusionTable',
          component: () => import(/* webpackChunkName: "weekly" */ './views/monthConclusion/childViews/monthConclusionTable.vue'),
          meta: { pagePath: '/home/monthConclusion' }
        },{
          path: 'conclusionEva',
          name: 'conclusionEva',
          component: () => import(/* webpackChunkName: "weekly" */ './views/monthConclusion/conclusionEva.vue'),
          meta: { pagePath: '/home/monthConclusion' }
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

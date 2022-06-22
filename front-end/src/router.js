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
      component: () => import('./views/Home.vue'),
      meta: { pagePath: '/home', requireAuth: true },
      children: [
        {
          path: 'dashboard',
          name: 'dashboard',
          component: () => import('./views/Dashboard/index.vue'),
          meta: { pagePath: '/home/dashboard' }
        },
        {
          path: 'workStation',
          name: 'workStation',
          component: () => import('./views/WorkStation/WorkStation.vue'),
          meta: { pagePath: '/home/workStation' }
        },
        {
          path: 'projectPlanProcess',
          name: 'projectPlanProcess',
          component: () => import('./views/WorkStation/childViews/ProjectPlanProcess.vue'),
          meta: { pagePath: '/home/workStation' }
        },
        {
          path: 'projectAssign',
          name: 'projectAssign',
          component: () => import('./views/WorkStation/childViews/ProjectAssign.vue'),
          meta: { pagePath: '/home/workStation' }
        },
        {
          path: 'performance',
          name: 'performance',
          component: () => import('./views/Performance/Performance.vue'),
          meta: { pagePath: '/home/performance', keepAlive: true }
        },
        {
          path: 'workPlanCheck',
          name: 'workPlanCheck',
          component: () => import('./views/workPlanCheck/workPlanCheck.vue'),
          meta: { pagePath: '/home/workPlanCheck' }
        },
        {
          path: 'workTimeCheck',
          name: 'workTimeCheck',
          component: () => import('./views/workTimeCheck/workTimeCheck.vue'),
          meta: { pagePath: '/home/workTimeCheck' }
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
          component: () => import('./components/workStation/projectOverview.vue'),
          meta: { pagePath: '/home/test' }
        },{
          path: 'monthConclusion',
          name: 'monthConclusion',
          component: () => import('./views/monthConclusion/monthConclusion.vue'),
          meta: { pagePath: '/home/monthConclusion' }
        },{
          path: 'monthConclusionTable',
          name: 'monthConclusionTable',
          component: () => import('./views/monthConclusion/childViews/monthConclusionTable.vue'),
          meta: { pagePath: '/home/monthConclusion' }
        },{
          path: 'PerformanceEvaNew',
          name: 'PerformanceEvaNew',
          component: () => import('./views/performanceEva/performanceEva.vue'),
          meta: { pagePath: '/home/PerformanceEvaNew' }
        },{
          path: 'PMDataFillUp',
          name: 'PMDataFillUp',
          component: () => import('./views/tmp/PMDataFillUp.vue'),
          meta: { pagePath: '/home/PMDataFillUp' }
        },{
          path: 'monthConclusionTableNew',
          name: 'monthConclusionTableNew',
          component: () => import('./views/monthConclusion/childViews/monthConclusionTableNew.vue'),
          meta: { pagePath: '/home/monthConclusion' }
        },{
          path: 'AMEvaluation',
          name: 'AMEvaluation',
          component: () => import('./views/performanceEva/AMEva.vue'),
          meta: { pagePath: '/home/AMEvaluation' }
        }
      ]
    },
    {
      path: '/refresh',
      component: () => import('./views/Refresh.vue'),
      name: 'Refresh',
      meta: { requireAuth: true }
    }
  ]
})

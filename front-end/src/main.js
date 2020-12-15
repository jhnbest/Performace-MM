import 'babel-polyfill'
import Vue from 'vue'
import './assets/styles/reset.css'
import ElementUI from 'element-ui'
import './themes/element/element-variables.scss'
import App from './App.vue'
import router from './router'
import store from './store'
import common from './assets/js/common.js'
import { http, baseURL } from './config/http.js'
import vueQuillEditor from 'vue-quill-editor' // 引入富文本工具
// require styles 引入样式
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'
import moment from 'moment'
import md5 from 'js-md5'

Vue.config.productionTip = false

Vue.use(ElementUI)
Vue.use(vueQuillEditor)

const bus = new Vue()
window.bus = bus
Vue.prototype.$common = common
Vue.prototype.$http = http
Vue.prototype.$baseURL = baseURL
Vue.prototype.$moment = moment
Vue.prototype.$md5 = md5

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requireAuth)) { // 判断该路由是否需要登录权限
    if (localStorage.userInfo) { // 判断当前的token是否存在 ； 登录存入的token
      next()
    } else {
      next({
        path: '/',
        query: { redirect: to.fullPath } // 将跳转的路由path作为参数，登录成功后跳转到该路由
      })
    }
  } else {
    next()
  }
})

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')

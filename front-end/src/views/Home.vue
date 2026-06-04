<template>
  <el-container class="home-wrap">
    <!-- header start -->
    <el-header class="flex">
      <div class="logo flex-item">
        <svg-icon icon-class="communication" style="font-size: 33px" />
<!--        <i style="font-size: 25px" class="el-icon-date"></i>-->
        <span style="font-weight: bolder;font-size: 25px"> 通信工程处绩效管理系统</span></div>
      <div class="user-info">
        <el-dropdown @command="handleCommand">
          <el-button type="primary">
            <i class="el-icon-user-solid el-icon--left" style="font-size: 20px"></i><span style="font-weight: bolder;font-size: 20px">{{userInfo.name}}</span>
          </el-button>
          <el-dropdown-menu slot="dropdown">
            <el-dropdown-item command="loginOut">退出</el-dropdown-item>
          </el-dropdown-menu>
        </el-dropdown>
      </div>
    </el-header>
    <!-- header end -->
    <div class="container-wrap">
      <!-- aside-nav start -->
      <div class="aside-wrap">
        <el-menu
          :default-active="activePath"
          background-color="#283643"
          text-color="#fff"
          active-text-color="#19d1e3"
          router
          :collapse="iscollapse">
          <el-menu-item v-for="item in filteredMenuList" :key="item.url" :index="item.url"
            @click="handleSelect(item.url)">
            <template slot="title">
              <i :class="item.icon" style="font-size: 20px"></i>
              <span>{{item.name}}</span>
            </template>
          </el-menu-item>
          <el-submenu index="1" v-if="$store.state.userInfo.role !== '普通成员'">
            <template slot="title">
              <i class="el-icon-pie-chart" style="font-size: 20px"></i>
              <span style="font-size: 16px">绩效管理</span>
            </template>
            <el-menu-item v-for="item in filteredWorkTimeManagerList" :key="item.url" :index="item.url"
                          @click="handleSelect(item.url)">
              <span slot="title">{{item.name}}</span>
            </el-menu-item>
          </el-submenu>
        </el-menu>
      </div>
      <!-- aside-nav end -->
      <!-- main start -->
      <div class="main-wrap">
        <router-view/>
      </div>
      <!-- main end -->
    </div>
  </el-container>
</template>

<script>
import { urlUserLogout } from '@/config/interface'
import { isUndefined } from '@/utils/common'
import Cookies from 'js-cookie'
export default {
  data () {
    return {
      iscollapse: false,
      menuList: this.$store.state.menuList,
      workTimeManagerList: this.$store.state.workTimeManagerList,
      activePath: null,
      reqFlag: {
        logout: true
      },
      skipSwitchName: ''
    }
  },
  components: {

  },
  computed: {
    userInfo: function () {
      let userInfo = this.$store.state.userInfo
      return userInfo
    },
    filteredMenuList: function () {
      const list = this.$store.state.menuList
      const userDuty = this.userInfo.duty
      const userId = this.userInfo.id
      // duty为1的管理者，隐藏工时查询和月总结菜单
      if (userDuty === 1) {
        return list.filter(item => !item.dutyHide && (!item.onlyShowID || item.onlyShowID === userId))
      }
      // 非管理者，隐藏onlyShowID指定的菜单
      return list.filter(item => !item.onlyShowID || item.onlyShowID === userId)
    },
    filteredWorkTimeManagerList: function () {
       const list = this.$store.state.workTimeManagerList
       // 工号为15的用户才能看到定时任务管理、成效评价失败监控和工时统计菜单
       if (this.userInfo.id !== '15' && this.userInfo.id !== 15) {
         return list.filter(item => item.url !== '/home/cronJob' && item.url !== '/home/FailedAMEvaMonitor' && item.url !== '/home/workHourStatistics')
       }
       return list
     }
  },
  watch: {
    '$route': function (to, from) {
      this.activePath = to.meta.pagePath
    }
  },
  created () {
    this.activePath = this.$route.meta.pagePath
    if (!isUndefined(Cookies.get('userName'))) {
      Cookies.remove('userName')
    }
    if (!isUndefined(Cookies.get('userPwd'))) {
      Cookies.remove('userPwd')
    }
  },
  methods: {
    handleCommand (command) {
      if (command == 'loginOut') {
        this.loginOut()
      }
    },
    // 登出
    loginOut () {
      const url = urlUserLogout
      if (this.reqFlag.logout) {
        this.reqFlag.logout = false
        let params = {}
        this.$http(url, params)
        .then(res => {
          if (res.code == 1) {
            localStorage.clear()
            this.$store.dispatch('saveUserInfo', {})
            this.$common.toast('登出成功', 'success', false)
            this.$router.replace({ path: '/' })
          }
          this.reqFlag.logout = true
        })
      }
    },
    // 解决element导航中，当前导航路由标识和当前路由一致时，点击当前导航，页面不刷新问题
    handleSelect (indexPath) {
      if (indexPath === this.$route.path) {
        this.$common.shallowRefresh(this.$route.name)
      }
    }
  }
}
</script>

<style scoped lang="scss">
.home-wrap{width: 100%; height: 100%;
  .el-header{line-height: 60px; color: $color-white; background: $color-main;
    .logo{font-size: 20px;}
    .user-info .el-button{font-size: 16px;}
  }
  .el-aside{background: #283643;}
  .el-menu{border: none;
    .el-menu-item{font-size: 16px;}
  }
}
.el-dropdown-menu__item{padding: 0 40px;
  span{display: block; width:100%; height: 100%;}
}
</style>

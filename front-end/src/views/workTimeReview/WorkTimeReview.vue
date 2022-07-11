<template>
  <div v-if="$store.state.userInfo.role !== '普通成员'">
    <el-form class="main-search" :inline="true">
      <el-form-item label="申报月份：" prop="title">
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
        <el-button size="mini" type="primary" style="margin-left: 10px" @click="handleNextMonth">下月</el-button>
      </el-form-item>
<!--      <el-form-item style="margin-left: 30px">-->
<!--        <el-button type="primary" size="medium" @click="handleSearchClick">查询</el-button>-->
<!--      </el-form-item>-->
    </el-form>
    <!-- 分割线 start -->
    <div class="hr-10"></div>
    <!-- 分割线 end -->
    <div class="main-content">
<!--      <el-badge :value="unReviewProjectCount" class="item">-->
<!--        <el-button class="clickStyle" @click="handleUnReview" size="medium">待审</el-button>-->
<!--      </el-badge>-->
<!--      <el-button style="margin-left: 20px" class="clickStyle" @click="handleReviewed" size="medium">已审</el-button>-->
      <el-radio-group v-model="formData.selectType" @change="handleSelectTypeChange">
        <el-badge :value="unReviewProjectCount" class="item">
          <el-radio-button label="已审"></el-radio-button>
          <el-radio-button label="待审"></el-radio-button>
        </el-badge>
      </el-radio-group>
      <br>
      <br>
      <el-tabs v-if="formData.refreshTabs" type="card" v-model="formData.reviewPerson">
        <el-tab-pane
          v-for="groupUser in groupUsers"
          :key="groupUser.id"
          :name="String(groupUser.id)">
          <span slot="label">
            {{groupUser.name}}
            <el-badge v-if="isShowCount(groupUser)"
                      :value="formData.reviewType === 'unReview'? groupUser.unReviewProjectCount : groupUser.reviewedProjectCount"
                      class="item"></el-badge>
          </span>
          <ReviewedPerson v-if="formData.reviewPerson === String(groupUser.id)"
                        :info="{id: groupUser.id, title: formData.title, reviewType: formData.reviewType}"
                        @reviewPass="handleReviewPass"></ReviewedPerson>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
  <div v-else>
    <h2>暂无权限</h2>
  </div>
</template>

<script>
  import ReviewedPerson from './childViews/ReviewedPerson'
  import { getSubmitWorkTimeCount } from '@/utils/performance'
  import { getUsersList } from '@/utils/users'
  export default {
    data () {
      return {
        formData: {
          title: this.$moment().format('YYYY-MM'),
          reviewPerson: '',
          reviewType: 'unReview',
          refreshTabs: true,
          selectType: '待审'
        },
        reqFlag: {
          getGroupUsers: true,
          getUnReviewProjectCount: true,
          getReviewedProjectCount: true
        },
        groupUsers: [],
        groupUserList: []
      }
    },
    methods: {
      // 初始化
      init () {
        this.getCookie()
        let checkGroupID = this.$store.state.userInfo.groupID
        checkGroupID = this.$store.state.userInfo.role === '管理员' ? 0 : checkGroupID
        let start = new Date()
        getUsersList(checkGroupID).then(res => {
          this.groupUserList = res
          getSubmitWorkTimeCount(this.groupUserList, this.formData.title).then(result => {
            console.log('耗时： ' + String(new Date() - start) + 'ms')
            this.groupUsers = result
            for (let item of this.groupUsers) {
              if (item.unReviewProjectCount !== 0) {
                this.formData.reviewPerson = String(item.id)
                break
              }
            }
          })
        })
      },
      handelDateChange () {
        if (this.$store.state.userInfo.role === '组长' || this.$store.state.userInfo.role === '管理员') {
          this.setCookie(this.formData.title, 7)
          if (this.formData.reviewType === 'reviewed') {
            this.getGroupUsers().then(res => {
              this.getReviewedProjectCount(res).then(res => {
                this.groupUsers = res
                for (let item of this.groupUsers) {
                  if (item.reviewedProjectCount !== 0) {
                    this.formData.reviewPerson = String(item.id)
                    break
                  }
                }
                this.formData.refreshTabs = false
                setTimeout(() => {
                  this.formData.refreshTabs = true
                }, this.$store.state.refreshInterval)
              })
            })
          } else if (this.formData.reviewType === 'unReview') {
            this.init()
            this.formData.refreshTabs = false
            setTimeout(() => {
              this.formData.refreshTabs = true
            }, this.$store.state.refreshInterval)
          }
        }
      },
      handleUnReview () {
        this.formData.reviewType = 'unReview'
        this.init()
        this.formData.refreshTabs = false
        setTimeout(() => {
          this.formData.refreshTabs = true
        }, this.$store.state.refreshInterval)
      },
      handleReviewed () {
        this.formData.reviewType = 'reviewed'
        if (this.$store.state.userInfo.role === '组长' || this.$store.state.userInfo.role === '管理员') {
          this.getGroupUsers().then(res => {
            this.getReviewedProjectCount(res).then(res => {
              this.groupUsers = res
            })
          })
        }
        this.formData.refreshTabs = false
        setTimeout(() => {
          this.formData.refreshTabs = true
        }, this.$store.state.refreshInterval)
      },
      // 子组件回调
      handleReviewPass () {
        this.getUnReviewProjectCount(this.groupUsers).then(res => {
          this.groupUsers = res
        })
      },
      // 审核类别标签切换事件
      handleSelectTypeChange (params) {
        if (params === '已审') {
          this.formData.reviewType = 'reviewed'
          if (this.$store.state.userInfo.role === '组长' || this.$store.state.userInfo.role === '管理员') {
            this.getGroupUsers().then(res => {
              this.getReviewedProjectCount(res).then(res => {
                this.groupUsers = res
                for (let item of this.groupUsers) {
                  if (item.reviewedProjectCount !== 0) {
                    this.formData.reviewPerson = String(item.id)
                    break
                  }
                }
              })
            })
          }
          this.formData.refreshTabs = false
          setTimeout(() => {
            this.formData.refreshTabs = true
          }, this.$store.state.refreshInterval)
        } else if (params === '待审') {
          this.formData.reviewType = 'unReview'
          this.init()
          this.formData.refreshTabs = false
          setTimeout(() => {
            this.formData.refreshTabs = true
          }, this.$store.state.refreshInterval)
        }
      },
      // 设置cookie
      setCookie (month, exdays) {
        let exdate = new Date() // 获取时间
        exdate.setTime(exdate.getTime() + 24 * 60 * 60 * 1000 * exdays) // 保存的天数
        // 字符串拼接cookie
        window.document.cookie = 'RMon' + '=' + month + ';path=/;expires=' + exdate.toGMTString()
      },
      // 读取cookie
      getCookie: function () {
        if (document.cookie.length > 0) {
          let arr = document.cookie.split('; ') // 这里显示的格式需要切割一下自己可输出看下
          for (let i = 0; i < arr.length; i++) {
            let arr2 = arr[i].split('=') // 再次切割
            // 判断查找相对应的值
            if (arr2[0] === 'RMon') {
              this.formData.title = arr2[1] // 保存到保存数据的地方
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
      }
    },
    computed: {
      unReviewProjectCount () {
        let totalNum = 0
        for (let item of this.groupUsers) {
          totalNum += item.unReviewProjectCount
        }
        return totalNum
      },
      reviewedProjectCount () {
        let totalNum = 0
        for (let item of this.groupUsers) {
          totalNum += item.reviewedProjectCount
        }
        return totalNum
      },
      isShowCount () {
        return function (groupUser) {
          if (this.formData.reviewType === 'unReview') {
            return groupUser.unReviewProjectCount !== 0
          } else if (this.formData.reviewType === 'reviewed') {
            return groupUser.reviewedProjectCount !== 0
          }
        }
      }
    },
    components: {
      ReviewedPerson
    },
    created () {
      this.init()
    },
    filters: {
      groupNameFilters (groupName) {
        switch (groupName) {
          case '技术标准组':
            return 1
          case '工程组':
            return 2
          case '通信组':
            return 3
          case '处经理':
            return 4
          default:
            return -1
        }
      }
    },
    name: 'workTimeReview'
  }
</script>

<style scoped>
  .clickStyle {
    width: 90px;
    font-size: 14px;
    background: #429e73;
    color: #fff;
  }
  .clickStyle:hover {
    background: #099a56;
    color: #fff;
  }
  .clickStyle:focus {
    background: #b41f1f;
    color: #fff;
  }
  .clickStyle:active {
    background: #b41f1f;
    color: #fff;
  }
</style>

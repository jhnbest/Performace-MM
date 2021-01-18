<template>
  <div>
    <el-form class="main-search" :inline="true">
      <el-form-item label="年份选择：" prop="title">
        <el-button size="mini" type="danger" style="margin-right: 10px" @click="handlePreYear">去年</el-button>
        <el-date-picker
          v-model="formData.title"
          type="year"
          format="yyyy年"
          value-format="yyyy"
          placeholder="选择年份"
          style="width: 110px"
          @change="handelDateChange">
        </el-date-picker>
        <el-button size="mini" type="primary" style="margin-left: 10px" @click="handleNextYear">明年</el-button>
      </el-form-item>
      <el-form-item label="计划类型：" style="margin-left: 10px">
        <el-radio-group v-model="selectPlanType" @change="handleSelectTypeChange">
          <el-radio-button label="月度计划"></el-radio-button>
          <el-radio-button label="年度计划"></el-radio-button>
        </el-radio-group>
      </el-form-item>
    </el-form>
    <!-- 分割线 start -->
    <div class="hr-10"></div>
    <!-- 分割线 end -->
    <div class="main-content">
      <el-tabs v-if="formData.refreshTabs" type="border-card" v-model="selectGroup">
        <el-tab-pane
          v-for="groupUser in groupUsers"
          :key="groupUser.groupID"
          :name="String(groupUser.groupID)">
          <span slot="label">{{groupUser.groupName}}</span>
          <el-tabs v-if="formData.refreshTabs" v-model="selectPersion" style="margin-top: -10px;margin-left: 10px">
            <el-tab-pane
              v-for="item in groupUser.childUsers"
              :key="item.id"
              :name="String(item.id)">
                <span slot="label">{{item.name}}</span>
              <keep-alive>
                <PersionPlan v-if="selectPersion === String(item.id)"
                             ref="childPersionPlan"
                             :userInfo="{userID: item.id, year: formData.title}"></PersionPlan>
              </keep-alive>
            </el-tab-pane>
          </el-tabs>
        </el-tab-pane>
      </el-tabs>
    </div>
  </div>
</template>

<script>
  import PersionPlan from './childViews/PersionPlan'
  import { getGroupUserName } from '@/config/interface'
    export default {
      data () {
        return {
          formData: {
            title: this.$moment().format('YYYY'),
            refreshTabs: true
          },
          tableData: [],
          reqFlag: {
            getGroupUsers: true
          },
          groupUsers: [],
          selectPersion: '',
          selectGroup: '',
          selectPlanType: '月度计划'
        }
      },
      methods: {
        // 初始化
        init () {
          this.getGroupUsers()
        },
        handelDateChange () {
          if (this.$refs.childPersionPlan) {
            this.$refs.childPersionPlan[0].getAssignedProject(this.formData.title).then(() => {
              this.$refs.childPersionPlan[0].handleYearChange()
            })
          }
        },
        // 计划选择
        handleSelectTypeChange () {
        },
        // 获取对象数组中小组类别索引
        getGroupIndex (groupID) {
          if (this.groupUsers.length === 0) {
            return -1
          }
          let count = 0
          for (let item of this.groupUsers) {
            if (groupID === item.groupID) {
              return count
            }
            count++
          }
          return -1
        },
        // 获取小组成员信息
        getGroupUsers () {
          let it = this
          return new Promise(function (resolve, reject) {
            if (it.reqFlag.getGroupUsers) {
              it.reqFlag.getGroupUsers = false
              const url = getGroupUserName
              let params = {
                role: it.$store.state.userInfo.role,
                groupName: it.$options.filters['groupNameFilters'](it.$store.state.userInfo.groupName)
              }
              it.$http(url, params)
                .then(res => {
                  if (res.code === 1) {
                    let data = res.data
                    for (let item of data) { // 按照组别分类
                      if (item.groupID === 4) {
                        continue
                      }
                      let index = it.getGroupIndex(item.groupID)
                      if (index === -1) {
                        let obj = {
                          groupID: item.groupID,
                          groupName: item.groupName,
                          childUsers: []
                        }
                        it.groupUsers.push(obj)
                        obj = {
                          id: item.id,
                          name: item.name
                        }
                        it.groupUsers[it.groupUsers.length - 1].childUsers.push(obj)
                      } else {
                        let obj = {
                          id: item.id,
                          name: item.name
                        }
                        it.groupUsers[index].childUsers.push(obj)
                      }
                    }
                    resolve(it.groupUsers)
                  }
                  it.reqFlag.getGroupUsers = true
                })
            }
          })
        },
        // 去年
        handlePreYear () {
          this.formData.title = this.$moment(this.formData.title).subtract(1, 'year').format('YYYY')
          this.handelDateChange()
        },
        // 明年
        handleNextYear () {
          this.formData.title = this.$moment(this.formData.title).add(1, 'year').format('YYYY')
          this.handelDateChange()
        }
      },
      created () {
        this.init()
      },
      components: {
        PersionPlan
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
      name: 'workPlanCheck'
    }
</script>

<style scoped>
  .chart-container{
    position: relative;
    width: 100%;
    height: calc(100vh - 84px);
  }
</style>

<template>
  <div class="workStation-container">
    <div class="main-search">
      <el-row>
        <el-col v-if="this.$store.state.userInfo.id !== 26" :span="6">
          <el-radio-group v-model="formData.selectType" @change="handleSelectTypeChange">
            <el-badge :value="this.unFilledTotalCount" class="item">
              <el-radio-button label="已完成"></el-radio-button>
              <el-radio-button label="已填报"></el-radio-button>
              <el-radio-button label="未填报"></el-radio-button>
            </el-badge>
          </el-radio-group>
        </el-col>
        <el-col :xs="{span: 1, offset: 0}"
                :sm="{span: 1, offset: 0}"
                :lg="{span: 1, offset: 0}"
                :xl="{span: 1, offset: 0, pull: 2}"
                v-if="$store.state.userInfo.role !== '普通成员'
                || $store.state.userInfo.id === 32 // 赵帅
                || $store.state.userInfo.id === 7 // 白工
                || $store.state.userInfo.id === 11 // 郭工
                || $store.state.userInfo.id === 12 // 顾总
                || $store.state.userInfo.id === 8 // 陈迪
                || $store.state.userInfo.id === 19">
          <el-button type="danger"
                     @click="handleProjectAssign"
                     size="medium">项目指派</el-button>
        </el-col>
        <el-col :xs="{span: 5, offset: 3}" :sm="{span: 4, offset: 6}" :lg="{span: 3, offset: 8}" :xl="{span: 2, offset: 11}">
          <el-button type="primary"
                     size="medium" @click="handleAddNew">工时申报(新增项目)</el-button>
        </el-col>
<!--        <el-col :xs="{span: 5, offset: 3}" :sm="{span: 4, offset: 6}" :lg="{span: 1, offset: 1}" :xl="{span: 1, offset: 1}">-->
<!--          <el-button type="warning"-->
<!--                     size="medium" @click="handlePlanAdd">计划申报(新增项目)</el-button>-->
<!--        </el-col>-->
      </el-row>
    </div>
    <!-- 分割线 start -->
    <div class="hr-10" style="margin-top: 20px"></div>
    <!-- 分割线 end -->
    <div v-if="showFlag" style="margin-top: 20px;">
      <div v-if="this.$store.state.userInfo.id !== 26">
        <el-tabs type="border-card" v-model="selectProjectType" stretch style="width: 99%;margin:auto">
          <el-tab-pane
            v-for="projectType in projectTypes"
            :key="projectType.projectTypeID"
            :name="String(projectType.projectTypeID)">
            <span slot="label">
              <span style="font-weight: bolder;color: black;font-size: 15px;vertical-align: center;">{{ projectType.name }}</span>
              <el-badge v-if="projectType.count !== 0" :value="projectType.count" class="item"></el-badge>
            </span>
            <POverview v-if="selectProjectType === String(projectType.projectTypeID)"
                       :fatherParams="{ projectTypeID: projectType.projectTypeID, searchType: projectType.searchType }"
                       @countFeedback="handleCountFeedback"/>
          </el-tab-pane>
        </el-tabs>
      </div>
      <div v-else>
        <el-tabs type="border-card" v-model="selectProjectType" stretch style="width: 99%;margin:auto">
          <el-tab-pane
            v-for="projectTypeManager in projectTypesManager"
            :key="projectTypeManager.projectTypeID"
            :name="String(projectTypeManager.projectTypeID)">
            <span slot="label">
              <span style="font-weight: bolder;color: black;font-size: 18px;vertical-align: center;">{{ projectTypeManager.name }}</span>
              <el-badge v-if="projectTypeManager.count !== 0" :value="projectTypeManager.count" class="item"></el-badge>
            </span>
            <POverviewMan v-if="selectProjectType === String(projectTypeManager.projectTypeID)"
                       :fatherParams="{ projectTypeID: projectTypeManager.projectTypeID,
                                        searchType: projectTypeManager.searchType }"
                       @countFeedback="handleCountFeedback"/>
          </el-tab-pane>
        </el-tabs>
      </div>
    </div>
  </div>
</template>

<script>
  import POverview from '@/components/workStation/projectOverview.vue'
  import POverviewMan from '@/components/workStation/projectOverviewManager.vue'
  import { getUnFilledProjectList } from '@/config/interface'
  export default {
    data () {
      return {
        formData: {
          selectType: '未填报',
          title: this.$moment().format('YYYY-MM')
        },
        pickerOptions: {
          disabledDate (time) {
            return time.getTime() > Date.now()
          }
        },
        JJData: {
          projectTypeID: 173,
          searchType: 'unFilled',
          color: '#67d4f6'
        },
        XXData: {
          projectTypeID: 172,
          searchType: 'unFilled',
          color: '#67d4f6'
        },
        JCPTData: {
          projectTypeID: 213,
          searchType: 'unFilled',
          color: '#67d4f6'
        },
        JCPTTXData: {
          projectTypeID: 275,
          searchType: 'unFilled',
          color: '#67d4f6'
        },
        XSData: {
          projectTypeID: 249,
          searchType: 'unFilled',
          color: '#67d4f6'
        },
        OtherStandData: {
          projectTypeID: 4,
          searchType: 'unFilled',
          color: '#67d4f6'
        },
        OtherUnStandData: {
          projectTypeID: 5,
          searchType: 'unFilled',
          color: '#67d4f6'
        },
        showFlag: true,
        unFilledTotalCount: 0,
        selectProjectType: '-1',
        projectTypes: [{
          projectTypeID: 173,
          name: '基建类',
          count: 0,
          searchType: 'unFilled'
        }, {
          projectTypeID: 213,
          name: '基础平台（工程组）',
          count: 0,
          searchType: 'unFilled'
        }, {
          projectTypeID: 275,
          name: '基础平台（通信组）',
          count: 0,
          searchType: 'unFilled'
        }, {
          projectTypeID: 249,
          name: '修缮类',
          count: 0,
          searchType: 'unFilled'
        }, {
          projectTypeID: 172,
          name: '选型类',
          count: 0,
          searchType: 'unFilled'
        }, {
          projectTypeID: 4,
          name: '其他标准类',
          count: 0,
          searchType: 'unFilled'
        }, {
          projectTypeID: 5,
          name: '其他非标类',
          count: 0,
          searchType: 'unFilled'
        }],
        projectTypesManager: [{
          projectTypeID: 173,
          name: '基建类',
          count: 0,
          searchType: 'unFilled'
        }, {
          projectTypeID: 213,
          name: '基础平台类',
          count: 0,
          searchType: 'unFilled'
        }, {
          projectTypeID: 249,
          name: '修缮类',
          count: 0,
          searchType: 'unFilled'
        }]
      }
    },
    methods: {
      // 初始化
      init () {
        if (this.$store.state.userInfo.id !== 26) {
          this.unFilledTotalCount = 0
          this.getUnFilledProjectList().then().catch(getUnFilledProjectListErr => {
            this.$common.toast(getUnFilledProjectListErr, 'error', true)
          })
        } else {
          this.selectProjectType = String(this.projectTypesManager[0].projectTypeID)
        }
      },
      // 获取当月未填报的项目列表
      getUnFilledProjectList () {
        const url = getUnFilledProjectList
        let params = {
          userID: this.$store.state.userInfo.id,
          searchType: 'unFilled'
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              for (let projectTypesItem of _this.projectTypes) {
                projectTypesItem.count = 0
              }
              for (let getUnFilledProjectListResItem of res.data) {
                let projectTypesFindResults = _this.projectTypes.find(projectTypesItem => {
                  return projectTypesItem.projectTypeID === getUnFilledProjectListResItem.projectType
                })
                if (projectTypesFindResults) {
                  projectTypesFindResults.count += 1
                }
                if (_this.selectProjectType === '-1') {
                  _this.selectProjectType = String(projectTypesFindResults.projectTypeID)
                }
                _this.unFilledTotalCount += 1
              }
              resolve(res.data)
            } else {
              reject(new Error('getUnFilledProjectList recv error'))
            }
          }).catch(err => {
            reject(new Error('getUnFilledProjectList send error ' + err))
          })
        })
      },
      // 获取当月已填报的项目列表
      getFilledProjectList () {
        const url = getUnFilledProjectList
        let params = {
          userID: this.$store.state.userInfo.id,
          searchType: 'Filled'
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              for (let projectTypesItem of _this.projectTypes) {
                projectTypesItem.count = 0
              }
              for (let getUnFilledProjectListResItem of res.data) {
                let projectTypesFindResults = _this.projectTypes.find(projectTypesItem => {
                  return projectTypesItem.projectTypeID === getUnFilledProjectListResItem.projectType
                })
                if (projectTypesFindResults) {
                  projectTypesFindResults.count += 1
                }
                if (_this.selectProjectType === '-1') {
                  _this.selectProjectType = String(projectTypesFindResults.projectTypeID)
                }
              }
              resolve(res.data)
            } else {
              reject(new Error('getFilledProjectList recv error'))
            }
          }).catch(err => {
            reject(new Error('getFilledProjectList send error ' + err))
          })
        })
      },
      // 获取已完成的项目列表
      getCompleteProjectList () {
        const url = getUnFilledProjectList
        let params = {
          userID: this.$store.state.userInfo.id,
          searchType: 'completed'
        }
        let _this = this
        return new Promise(function (resolve, reject) {
          _this.$http(url, params).then(res => {
            if (res.code === 1) {
              for (let projectTypesItem of _this.projectTypes) {
                projectTypesItem.count = 0
              }
              for (let getUnFilledProjectListResItem of res.data) {
                let projectTypesFindResults = _this.projectTypes.find(projectTypesItem => {
                  return projectTypesItem.projectTypeID === getUnFilledProjectListResItem.projectType
                })
                if (projectTypesFindResults) {
                  projectTypesFindResults.count += 1
                }
                if (_this.selectProjectType === '-1') {
                  _this.selectProjectType = String(projectTypesFindResults.projectTypeID)
                }
              }
              resolve(res.data)
            } else {
              reject(new Error('getCompleteProjectList recv error'))
            }
          }).catch(err => {
            reject(new Error('getCompleteProjectList send error ' + err))
          })
        })
      },
      // 项目完成类型选择
      handleSelectTypeChange () {
        this.showFlag = false
        if (this.formData.selectType === '未填报') {
          this.unFilledTotalCount = 0
          this.getUnFilledProjectList()
          for (let projectTypesItem of this.projectTypes) {
            projectTypesItem.searchType = 'unFilled'
          }
        } else if (this.formData.selectType === '已填报') {
          this.getFilledProjectList()
          for (let projectTypesItem of this.projectTypes) {
            projectTypesItem.searchType = 'Filled'
          }
        } else if (this.formData.selectType === '已完成') {
          this.getCompleteProjectList()
          for (let projectTypesItem of this.projectTypes) {
            projectTypesItem.searchType = 'completed'
          }
        }
        this.$nextTick(() => {
          this.showFlag = true
        })
      },
      // 项目指派
      handleProjectAssign () {
        this.$router.push({ path: '/home/projectAssign' })
      },
      // 项目子组件回调
      handleCountFeedback (params) {
        if (this.formData.selectType === '未填报' && this.unFilledTotalCount === null) {
          this.unFilledTotalCount += params
        }
      },
      // 项目申报
      handleAddNew () {
        this.$router.push({
          path: '/home/PerformanceAddNew',
          query: {
            type: 'fact'
          }
        })
      },
      // 计划申报
      handlePlanAdd () {
        this.$router.push({
          path: '/home/PerformanceAddNew',
          query: {
            type: 'plan'
          }
        })
      },
      // 项目类型选择事件
      handleSelectProjectType () {
      }
    },
    created () {
      this.init()
    },
    components: {
      POverview,
      POverviewMan
    },
      name: 'WorkStation.vue'
  }
</script>

<style scoped>
  .workStation-container {
    background-color: #f1f0f0;
    min-height: 150vh;
  }
</style>

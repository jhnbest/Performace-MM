<template>
  <div class="workStation-container">
    <div class="main-search">
      <el-row>
        <el-col :span="6">
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
                || $store.state.userInfo.id === 32
                || $store.state.userInfo.id === 7
                || $store.state.userInfo.id === 11
                || $store.state.userInfo.id === 12
                || $store.state.userInfo.id === 8">
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
<!--    <el-button v-if="$store.state.userInfo.id === 15" @click="repairErrorData">修正按钮</el-button>-->
<!--    <el-button v-if="$store.state.userInfo.id === 15" @click="repairErrorData2">修正按钮2</el-button>-->
<!--    <el-button v-if="$store.state.userInfo.id === 15" @click="repairErrorData3">修正按钮3</el-button>-->
    <!-- 分割线 start -->
    <div class="hr-10" style="margin-top: 20px"></div>
    <!-- 分割线 end -->
    <div v-if="showFlag" style="margin-top: 20px;">
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
    <!-- 分割线 end -->
<!--    <div v-if="showFlag">-->
<!--      <el-row>-->
<!--        <el-col :xs="24" :sm="24" :lg="24" :xl="12">-->
<!--          <h3 class="v-line-icon-red">基建类项目</h3>-->
<!--          <TEST :fatherParams="JJData" @countFeedback="handleCountFeedback"/>-->
<!--        </el-col>-->
<!--        <el-col v-if="$store.state.userInfo.groupName === '通信组'" :xs="24" :sm="24" :lg="24" :xl="12">-->
<!--          <h3 class="v-line-icon-green">基础平台类项目</h3>-->
<!--          <TEST :fatherParams="JCPTTXData" @countFeedback="handleCountFeedback"/>-->
<!--        </el-col>-->
<!--        <el-col v-else :xs="24" :sm="24" :lg="24" :xl="12">-->
<!--          <h3 class="v-line-icon-green">基础平台类项目</h3>-->
<!--          <TEST :fatherParams="JCPTData" @countFeedback="handleCountFeedback"/>-->
<!--        </el-col>-->
<!--      </el-row>-->
<!--    </div>-->
<!--    <div v-if="showFlag">-->
<!--      <el-row>-->
<!--        <el-col :xs="24" :sm="24" :lg="24" :xl="12">-->
<!--          <h3 class="v-line-icon-green">修缮类项目</h3>-->
<!--          <TEST :fatherParams="XSData" @countFeedback="handleCountFeedback"/>-->
<!--        </el-col>-->
<!--        <el-col :xs="24" :sm="24" :lg="24" :xl="12">-->
<!--          <h3 class="v-line-icon-blue">选型项目</h3>-->
<!--          <TEST :fatherParams="XXData" @countFeedback="handleCountFeedback"/>-->
<!--        </el-col>-->
<!--      </el-row>-->
<!--    </div>-->
<!--    <div v-if="showFlag">-->
<!--      <el-row>-->
<!--        <el-col :xs="24" :sm="24" :lg="24" :xl="12">-->
<!--          <h3 class="v-line-icon-yellow">其他标准项目</h3>-->
<!--          <TEST :fatherParams="OtherStandData" @countFeedback="handleCountFeedbackOtherStand"/>-->
<!--        </el-col>-->
<!--        <el-col :xs="24" :sm="24" :lg="24" :xl="12">-->
<!--          <h3 class="v-line-icon-purple">其他非标项目</h3>-->
<!--          <TEST :fatherParams="OtherUnStandData" @countFeedback="handleCountFeedbackOtherUnStand"/>-->
<!--        </el-col>-->
<!--      </el-row>-->
<!--    </div>-->
  </div>
</template>

<script>
  import POverview from '@/components/workStation/projectOverview.vue'
  import { getUnFilledProjectList, repairErrorData, repairErrorData2, repairErrorData3 } from '@/config/interface'
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
        }]
      }
    },
    methods: {
      // 修复错误数据
      repairErrorData () {
        const url = repairErrorData
        let params = {}
        this.$http(url, params).then(res => {
          if (res.code === 1) {
            this.$common.toast('修复成功', 'success', false)
          }
        })
      },
      // 修复错误数据2
      repairErrorData2 () {
        const url = repairErrorData2
        let params = {}
        this.$http(url, params).then(res => {
          if (res.code === 1) {
            this.$common.toast('修复成功', 'success', false)
          }
        })
      },
      // 修复错误数据3
      repairErrorData3 () {
        const url = repairErrorData3
        let params = {}
        this.$http(url, params).then(res => {
          if (res.code === 1) {
            console.log(res.data)
            this.$common.toast('修复成功', 'success', false)
          }
        })
      },
      // 初始化
      init () {
        this.unFilledTotalCount = 0
        this.getUnFilledProjectList().then().catch(getUnFilledProjectListErr => {
          this.$common.toast(getUnFilledProjectListErr, 'error', true)
        })
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
        console.log(this.selectProjectType)
      }
    },
    created () {
      this.init()
    },
    components: {
      POverview
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

<template>
  <div style="padding: 10px">
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
        <el-col :span="1" style="margin-top: 3px">
          <el-button style="margin-left: 50px"
                     v-if="this.$store.state.userInfo.role !== '普通成员'"
                     type="danger"
                     @click="handleProjectAssign"
                     size="medium">项目指派</el-button>
        </el-col>
      </el-row>
    </div>
    <!-- 分割线 start -->
    <div class="hr-10" style="margin-top: 20px"></div>
    <!-- 分割线 end -->
    <div v-if="showFlag">
      <el-row>
        <el-col :xs="24" :sm="24" :lg="24" :xl="12">
          <h3 class="v-line-icon-red">基建类项目</h3>
          <TEST :fatherParams="JJData" @countFeedback="handleCountFeedbackJJ"/>
        </el-col>
        <el-col :xs="24" :sm="24" :lg="24" :xl="12">
          <h3 class="v-line-icon-green">基础平台类项目</h3>
          <TEST :fatherParams="JCPTData" @countFeedback="handleCountFeedbackJCPT"/>
        </el-col>
      </el-row>
    </div>
    <div v-if="showFlag">
      <el-row>
        <el-col :xs="24" :sm="24" :lg="24" :xl="12">
          <h3 class="v-line-icon-green">修缮类项目</h3>
          <TEST :fatherParams="XSData" @countFeedback="handleCountFeedbackXS"/>
        </el-col>
        <el-col :xs="24" :sm="24" :lg="24" :xl="12">
          <h3 class="v-line-icon-blue">选型项目</h3>
          <TEST :fatherParams="XXData" @countFeedback="handleCountFeedbackXX"/>
        </el-col>
      </el-row>
    </div>
    <div v-if="showFlag">
      <el-row>
        <el-col :xs="24" :sm="24" :lg="24" :xl="12">
          <h3 class="v-line-icon-yellow">其他标准项目</h3>
          <TEST :fatherParams="OtherStandData" @countFeedback="handleCountFeedbackOtherStand"/>
        </el-col>
        <el-col :xs="24" :sm="24" :lg="24" :xl="12">
          <h3 class="v-line-icon-purple">其他非标项目</h3>
          <TEST :fatherParams="OtherUnStandData" @countFeedback="handleCountFeedbackOtherUnStand"/>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
  import TEST from '@/components/test.vue'
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
            searchType: 'unFilled'
          },
          XXData: {
            projectTypeID: 172,
            searchType: 'unFilled'
          },
          JCPTData: {
            projectTypeID: 213,
            searchType: 'unFilled'
          },
          XSData: {
            projectTypeID: 249,
            searchType: 'unFilled'
          },
          OtherStandData: {
            projectTypeID: 4,
            searchType: 'unFilled'
          },
          OtherUnStandData: {
            projectTypeID: 5,
            searchType: 'unFilled'
          },
          showFlag: true,
          unFilledTotalCount: 0
        }
      },
      methods: {
        handleSelectTypeChange () {
          this.showFlag = false
          if (this.formData.selectType === '未填报') {
            this.unFilledTotalCount = 0
            this.JJData.searchType = 'unFilled'
            this.XXData.searchType = 'unFilled'
            this.JCPTData.searchType = 'unFilled'
            this.XSData.searchType = 'unFilled'
            this.OtherStandData.searchType = 'unFilled'
            this.OtherUnStandData.searchType = 'unFilled'
          } else if (this.formData.selectType === '已填报') {
            this.JJData.searchType = 'Filled'
            this.XXData.searchType = 'Filled'
            this.JCPTData.searchType = 'Filled'
            this.XSData.searchType = 'Filled'
            this.OtherStandData.searchType = 'Filled'
            this.OtherUnStandData.searchType = 'Filled'
          } else if (this.formData.selectType === '已完成') {
            this.JJData.searchType = 'completed'
            this.XXData.searchType = 'completed'
            this.JCPTData.searchType = 'completed'
            this.XSData.searchType = 'completed'
            this.OtherStandData.searchType = 'completed'
            this.OtherUnStandData.searchType = 'completed'
          }
          this.$nextTick(() => {
            this.showFlag = true
          })
        },
        handleProjectAssign () {
          this.$router.push({ path: '/home/projectAssign' })
        },
        handleCountFeedbackXX (params) {
          if (this.formData.selectType === '未填报') {
            this.unFilledTotalCount += params
          }
        },
        handleCountFeedbackXS (params) {
          if (this.formData.selectType === '未填报') {
            this.unFilledTotalCount += params
          }
        },
        handleCountFeedbackJJ (params) {
          if (this.formData.selectType === '未填报') {
            this.unFilledTotalCount += params
          }
        },
        handleCountFeedbackJCPT (params) {
          if (this.formData.selectType === '未填报') {
            this.unFilledTotalCount += params
          }
        },
        handleCountFeedbackOtherStand (params) {
          if (this.formData.selectType === '未填报') {
            this.unFilledTotalCount += params
          }
        },
        handleCountFeedbackOtherUnStand (params) {
          if (this.formData.selectType === '未填报') {
            this.unFilledTotalCount += params
          }
        }
      },
      components: {
        TEST
      },
        name: 'WorkStation.vue'
    }
</script>

<style scoped>
  .dashboard-editor-container {
    padding: 10px;
    background-color: rgb(240, 242, 245);
    position: relative;

    .github-corner {
      position: absolute;
      top: 0px;
      border: 0;
      right: 0;
    }

    .chart-wrapper {
      background: #fff;
      padding: 16px 16px 0;
      margin-left: 320px;
    }
  }

  @media (max-width:1024px) {
    .chart-wrapper {
      padding: 8px;
    }
  }
</style>

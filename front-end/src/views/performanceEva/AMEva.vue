<template>
  <div>
    <div class="head-line">
      <el-button size="mini"
                type="danger"
                style="margin-right: 10px"
                @click="handlePreMonth"
                :disabled="!getDataLoading">上月</el-button>
      <el-date-picker
        v-model="title"
        type="month"
        format="yyyy 第 MM 月"
        value-format="yyyy-MM"
        placeholder="选择月"
        style="width: 150px"
        @change="handleDataChange()">
      </el-date-picker>
      <el-button size="mini"
                  type="primary"
                  style="margin-left: 10px"
                  @click="handleNextMonth"
                  :disabled="!getDataLoading">下月</el-button>
    </div>
    <div class="hr-10"></div>
    <div class="head-line">
      <el-row :gutter="10">
        <el-col :span="5">
          <el-collapse accordion v-model="activeName">
            <el-collapse-item name="1">
              <template slot="title">
                <el-badge :value="toDoEvaNum" class="item"><span>待评价</span></el-badge>
              </template>
              <el-table
                v-loading="!getDataLoading"
                :data="PMdata"
                fit
                highlight-current-row
                style="width: 100%;"
                size="mini">
                <el-table-column label="姓名" prop="name" align="center" width="60px"></el-table-column>
                <el-table-column label="提交状态" prop="submitStatus" align="center" width="70px">
                  <template slot-scope="scope">
                    <el-tag :type="scope.row.submitStatus | submitStatusFilter" size="mini">{{scope.row.submitStatus | submitStatusTextFilter}}</el-tag>
                  </template>
                </el-table-column>
                <el-table-column label="月总结" align="center">
                  <template slot-scope="scope">
                    <el-button v-if="!scope.row.isShow"
                              :disabled="scope.row.submitStatus === 0"
                              @click="handlelookOver(scope.row, scope.$index)"
                              size="mini">
                              <span v-if="scope.row.submitStatus === 1">点击显示</span>
                              <span v-else>未提交</span>
                    </el-button>
                    <span v-else>已显示</span>
                  </template>
                </el-table-column>
              </el-table>
            </el-collapse-item>
            <el-collapse-item>
              <template slot="title">
                <el-badge :value="doneEvaNum" class="item"><span>已评价</span></el-badge>
              </template>
            </el-collapse-item>
          </el-collapse>
        </el-col>
        <el-col :span="19">
          <div v-if="forceRefresh">
            <el-table :data="tableData1"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      size="medium"
                      style="margin: auto"
                      :header-cell-style="{ background:'#ced1d4', color:'#000000', fontSize:'16px'}">
              <el-table-column label="打造精品工程">
                <template>
                  <div v-html="buildBoutiqueProject"></div>
                </template>
              </el-table-column>
              <el-table-column label="评分" width="150px" align="center">
                <template slot-scope="scope">
                  <el-rate v-model="buildBoutiqueProjectStar"
                         @change="handlebuildBoutiqueProjectStarChange(scope.row)" slot="reference"></el-rate>
                </template>
              </el-table-column>
            </el-table>
            <el-table :data="tableData2"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      size="medium"
                      :header-cell-style="{ background:'#ced1d4', color:'#000000', fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="创建专业团队">
                <template>
                  <div v-html="buildProTeam"></div>
                </template>
              </el-table-column>
              <el-table-column label="评分" width="150px" align="center">
                <template slot-scope="scope">
                  <el-rate v-model="buildProTeamStar"
                         @change="handlebuildProTeamStarChange(scope.row)" slot="reference"></el-rate>
                </template>
              </el-table-column>
            </el-table>
            <el-table v-if="$store.state.userInfo.duty === 1"
                      :data="tableData3"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      size="medium"
                      :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="下一个月的工作目标、工作计划/工作安排、工作内容">
                <template>
                  <div v-html="nextPlan"></div>
                </template>
              </el-table-column>
            </el-table>
            <el-table :data="tableData4"
                      border
                      v-loading="!getDataLoading"
                      stripe
                      size="medium"
                      :header-cell-style="{ background:'#ced1d4',color:'#000000',fontSize:'16px' }"
                      style="margin: auto"
                      highlight-current-row>
              <el-table-column label="操作" align="center">
                <template>
                  <el-button type="success"
                             @click="handleSubmitAndJumpToNext()">
                             点击提交对
                             <span style="color: red;font-weight: bold">{{curEvaUserName}}</span>
                             的评价并跳转到下一个待评价人
                  </el-button>
                </template>
              </el-table-column>
            </el-table>
          </div>
        </el-col>
      </el-row>
    </div>
  </div>
</template>
<script>
import {} from '@/utils/performance'
import { Notification } from 'element-ui'
import { getUsersList } from '@/utils/users'
import { getCurMonthConclusionOverviewDataNew } from '@/utils/conclusion'
import { getAchievementOfUser } from '@/utils/achievementEva'
import store from '@/store'
export default {
  data () {
    return {
      title: this.$moment().format('YYYY-MM'), // 日期
      getDataLoading: false, // 表格加载标志位,
      fillUPing: true, // 表格加载标志位,
      PMdata: [], // 表格数据
      tableHeight: null, // 动态表格高度
      conclusionYear: null, // 总结年份
      conclusionMonth: null, // 总结月份,
      tableData1: [{}],
      tableData2: [{}],
      tableData3: [{}],
      tableData4: [{}],
      buildBoutiqueProject: null, // 打造精品工程内容
      buildProTeam: null, // 打造精品工程内容
      nextPlan: null, // 打造精品工程内容
      curShowIndex: 0, // 当前显示的用户序号
      preShowIndex: 0, // 之前显示的用户序号
      buildBoutiqueProjectStar: 3, // 默认评价星级
      buildProTeamStar: 3, // 默认评价星级
      toDoEvaNum: 0, // 待评价的人数
      doneEvaNum: 0, // 已评价的人数,
      forceRefresh: true, // 强制刷新
      activeName: '1', // 默认展开的name,
      curEvaUser: {
        name: null,
        index: null
      } // 当前评价的用户姓名
    }
  },
  methods: {
    // 初始化
    init () {
      this.getDataLoading = false
      this.conclusionYear = this.$moment(this.title).year()
      this.conclusionMonth = this.$moment(this.title).month() + 1
      getUsersList().then(usersList => {
        this.genTableData(this.conclusionYear, this.conclusionMonth, usersList).then(tableData => {
          // 初始化显示第一个已经提交总结的人
          for (let i = 0; i < tableData.length; i++) {
            if (tableData[i].submitStatus !== 0) {
              tableData[i].isShow = true
              this.curEvaUserName = tableData[i].name
              this.curShowIndex = i
              this.preShowIndex = i
              this.buildBoutiqueProject = tableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
              }).content
              this.buildProTeam = tableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
              }).content
              this.nextPlan = tableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
              }).content
              this.forceRefresh = false
              this.$nextTick(() => {
                this.forceRefresh = true
              })
              break
            }
          }
          this.PMdata = tableData
          this.getDataLoading = true
          console.log('tableData')
          console.log(tableData)
        })
      })
    },
    // 生成表格数据
    genTableData (conclusionYear, conclusionMonth, usersList) {
      // 初始化默认数据
      let toDoEvaArray = []
      for (let user of usersList) {
        if (store.state.userInfo.groupName === '技术标准组' || store.state.userInfo.groupName === '工程组') {
          if (user.groupName === '技术标准组' || user.groupName === '工程组') {
            let obj = {
              id: user.id,
              name: user.name,
              submitStatus: 0,
              evaStatus: 0,
              conclusionContent: null,
              isShow: false,
              conclusionEva: []
            }
            toDoEvaArray.push(obj)
          }
        } else if (store.state.userInfo.groupName === '通信组') {
          if (user.groupName === '通信组') {
            let obj = {
              id: user.id,
              name: user.name,
              submitStatus: 0,
              evaStatus: 0,
              conclusionContent: null,
              isShow: false,
              conclusionEva: []
            }
            toDoEvaArray.push(obj)
          }
        } else {
          let obj = {
            id: user.id,
            name: user.name,
            submitStatus: 0,
            evaStatus: 0,
            conclusionContent: null,
            isShow: false,
            conclusionEva: []
          }
          toDoEvaArray.push(obj)
        }
      }
      console.log('toDoEvaArray')
      console.log(toDoEvaArray)
      console.log('toDoEvaArray')
      console.log(JSON.parse(JSON.stringify(toDoEvaArray)))
      toDoEvaArray.splice(toDoEvaArray.findIndex(item => { return item.id === store.state.userInfo.id }), 1) // 把自己去掉
      let promise = []
      let count = 0
      for (let item of toDoEvaArray) {
        promise[count++] = getCurMonthConclusionOverviewDataNew(conclusionYear, conclusionMonth, item.id)
      }
      return new Promise(function (resolve, reject) {
        Promise.all(promise).then(allResponse => {
          console.log('allResponse')
          console.log(allResponse)
          let promise2 = []
          let count2 = 0
          for (let i = 0; i < toDoEvaArray.length; i++) {
            toDoEvaArray[i].submitStatus = allResponse[i].data.length === 0 ? 0 : 1
            toDoEvaArray[i].conclusionContent = allResponse[i].data
            if (allResponse[i].data.length > 0) { // 已经填写总结
              for (let item of allResponse[i].data) {
                if (item.dimension === 1 || item.dimension === 2) { // 打造精品工程和建设团队维度才获取评价结果
                  promise2[count2++] = getAchievementOfUser(item.id)
                }
              }
              Promise.all(promise2).then(allResponse2 => {
                console.log('allResponse2')
                console.log(allResponse2)
                for (let item2 of allResponse2) {
                  let findResult = allResponse.data.find(allResponseItem => {
                    return allResponseItem.id === item2.data.dimensionID
                  })
                  findResult.conclusionEva.push(item2)
                }
                resolve(toDoEvaArray)
              }).catch(err => {
                reject(err)
              })
            } else {
              if (i === toDoEvaArray.length - 1) {
                resolve(toDoEvaArray)
              }
            }
          }
        }).catch(err => {
          reject(err)
        })
      })
    },
    // 点击查看
    handlelookOver (row, index) {
      console.log('row')
      console.log(row)
      this.curEvaUserName = row.name
      this.curShowIndex = index
      this.PMdata[this.curShowIndex].isShow = true
      this.PMdata[this.preShowIndex].isShow = false
      this.preShowIndex = index
      this.buildBoutiqueProject = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
      }).content
      this.buildProTeam = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
      }).content
      this.nextPlan = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      }).content
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
    },
    // 打造精品工程
    handlebuildBoutiqueProjectStarChange () {
    },
    // 创建专业团队评价星级
    handlebuildProTeamStarChange () {
    },
    // 点击提交对当前用户的评价并跳转到下一个评价人
    handleSubmitAndJumpToNext () {
      let promises = []
      let count = 0
    },
    // 日期发生变化
    handleDataChange () {
      this.getDataLoading = false
    },
    // 上月
    handlePreMonth () {
      this.title = this.$moment(this.title).subtract(1, 'months').format('YYYY-MM')
      this.handleDataChange()
    },
    // 下月
    handleNextMonth () {
      this.title = this.$moment(this.title).add(1, 'months').format('YYYY-MM')
      this.handleDataChange()
    },
    // 刷新表格尺寸
    refreshTableSize () {
      this.$nextTick(() => {
        this.tableHeight = window.innerHeight - this.$refs.PMDataTable.$el.offsetTop - 5
        if (this.tableHeight < 0) {
          this.tableHeight = window.innerHeight - 100
        }
        let _this = this
        window.onresize = function () {
          _this.tableHeight = window.innerHeight - _this.$refs.PMDataTable.$el.offsetTop - 5
          if (_this.tableHeight < 0) {
            _this.tableHeight = window.innerHeight - 100
          }
        }
      })
    }
  },
  created () {
    this.init()
  },
  mounted () {
    this.refreshTableSize()
  },
  filters: {
    submitStatusFilter (status) {
      if (status === 1) {
        return 'success'
      } else if (status === 0) {
        return 'danger'
      }
    },
    submitStatusTextFilter (status) {
      if (status === 1) {
        return '已提交'
      } else if (status === 0) {
        return '未提交'
      }
    }
  }
}
</script>
<style scoped>
.head-line{
  padding: 20px;
}
</style>

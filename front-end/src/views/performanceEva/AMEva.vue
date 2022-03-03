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
          <el-collapse accordion v-model="activeName" @change="handleCollapseChange()">
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
                size="mini"
                ref = "PMDataTable">
                <el-table-column label="姓名" prop="name" align="center" width="60px"></el-table-column>
                <el-table-column label="月总结提交状态" prop="submitStatus" align="center">
                  <template slot-scope="scope">
                    <el-tag :type="scope.row.submitStatus | submitStatusFilter" size="medium">{{scope.row.submitStatus | submitStatusTextFilter}}</el-tag>
                  </template>
                </el-table-column>
                <el-table-column label="月总结" align="center">
                  <template slot-scope="scope">
                    <el-button v-if="!scope.row.isShow"
                              :disabled="scope.row.submitStatus === 0"
                              @click="table1HandleShow(scope.row, scope.$index)"
                              size="mini">
                              <span v-if="scope.row.submitStatus === 1">点击显示</span>
                              <span v-else>未提交</span>
                    </el-button>
                    <span v-else>已显示</span>
                  </template>
                </el-table-column>
              </el-table>
            </el-collapse-item>
            <el-collapse-item name="2">
              <template slot="title">
                <el-badge :value="doneEvaNum" class="item"><span>已评价</span></el-badge>
              </template>
              <el-table :data="doneEvaTableData"
                         v-loading="!getDataLoading"
                         fit
                         highlight-current-row
                         style="width: 100%;"
                         size="mini">
                <el-table-column label="姓名" prop="name" align="center" width="60px"></el-table-column>
                <el-table-column label="月总结提交状态" prop="submitStatus" align="center">
                  <template slot-scope="scope">
                    <el-tag :type="scope.row.submitStatus | submitStatusFilter" size="medium">{{scope.row.submitStatus | submitStatusTextFilter}}</el-tag>
                  </template>
                </el-table-column>
                <el-table-column label="月总结" align="center">
                  <template slot-scope="scope">
                    <el-button v-if="!scope.row.isShow"
                              :disabled="scope.row.submitStatus === 0"
                              @click="table2HandleShow(scope.row, scope.$index)"
                              size="mini">
                              <span v-if="scope.row.submitStatus === 1">点击显示</span>
                              <span v-else>未提交</span>
                    </el-button>
                    <span v-else>已显示</span>
                  </template>
                </el-table-column>
              </el-table>
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
                  <div v-html="buildBoutiqueProject.content"></div>
                </template>
              </el-table-column>
              <el-table-column label="评分" width="150px" align="center">
                <template slot-scope="scope">
                  <el-rate v-model="buildBoutiqueProjectStar.evaStar"
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
                  <div v-html="buildProTeam.content"></div>
                </template>
              </el-table-column>
              <el-table-column label="评分" width="150px" align="center">
                <template slot-scope="scope">
                  <el-rate v-model="buildProTeamStar.evaStar"
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
                  <div v-html="nextPlan.content"></div>
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
                  <el-button v-if="activeName === '1' && buildBoutiqueProject.content !== '无数据'"
                             :disabled="!submitEvaDataFlag"
                             type="success"
                             @click="handleSubmitAndJumpToNext()">
                             点击提交对
                             <span style="color: red;font-weight: bold">{{curEvaUserName}}</span>
                             的评价并跳转到下一个待评价人
                  </el-button>
                  <el-button v-if="activeName === '2' && buildBoutiqueProject.content !== '无数据'"
                             :disabled="!updateEvaDataFlag"
                             type="primary"
                             @click="handleUpdateEva()">
                             点击更新对
                             <span style="color: red;font-weight: bold">{{curEvaUserName}}</span>
                             的评价
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
import { getAllWorkTimeList } from '@/utils/performance'
import { getAllUserRates } from '@/utils/multual'
import { Notification } from 'element-ui'
import { getUsersList } from '@/utils/users'
import { getCurMonthConclusionOverviewDataNew } from '@/utils/conclusion'
import { getUserofAchievementToAnotherUser,
         submitAMEvaData,
         updateAMEvaData } from '@/utils/achievementEva'
import store from '@/store'
export default {
  data () {
    return {
      title: this.$moment().subtract(1, 'months').format('YYYY-MM'), // 日期
      usersList: null, // 用户列表
      getDataLoading: false, // 表格加载标志位,
      submitEvaDataFlag: true, // 提交评价标志位
      updateEvaDataFlag: true, // 更新评价标志位
      fillUPing: true, // 表格加载标志位,
      PMdata: [], // 表格数据
      doneEvaTableData: [], // 已经完成评价的数据
      tableHeight: null, // 动态表格高度
      tableData1: [{}],
      tableData2: [{}],
      tableData3: [{}],
      tableData4: [{}],
      buildBoutiqueProject: {
        content: '无数据'
      }, // 打造精品工程内容
      buildProTeam: {
        content: '无数据'
      }, // 建设专业团队内容
      nextPlan: {
        content: '无数据'
      }, // 下月计划内容
      table1CurShowIndex: -1, // 表格1当前显示的用户序号
      table1PreShowIndex: -1, // 表格1之前显示的用户序号
      table2CurShowIndex: -1, // 表格2当前显示的用户序号
      table2PreShowIndex: -1, // 表格2之前显示的用户序号
      buildBoutiqueProjectStar: {
        evaStar: store.state.defaultStar
      }, // 打造精品工程默认评价星级
      buildProTeamStar: {
        evaStar: store.state.defaultStar
      }, // 建设专业团队默认评价星级
      toDoEvaNum: 0, // 待评价的人数
      doneEvaNum: 0, // 已评价的人数,
      forceRefresh: true, // 强制刷新
      activeName: '1', // 默认展开的name,
      curEvaUserName: null, // 当前显示的用户姓名
      curShowTable: -1 // 当前显示的表格序号
    }
  },
  methods: {
    // 初始化
    init () {
      this.getDataLoading = false
      getUsersList().then(usersList => {
        this.usersList = usersList
        let conclusionYear = this.$moment(this.title).year()
        let conclusionMonth = this.$moment(this.title).month() + 1
        this.genTableData(conclusionYear, conclusionMonth, usersList).then(tableData => {
          let toDoEvaTableData = tableData.toDoEvaTableData
          let doneEvaTableData = tableData.doneEvaTableData
          this.toDoEvaNum = toDoEvaTableData.length
          this.doneEvaNum = doneEvaTableData.length
          // 初始化默认显示的数据
          if (toDoEvaTableData.length !== 0) { // 还有未评价的用户
            for (let i = 0; i < toDoEvaTableData.length; i++) {
              if (toDoEvaTableData[i].submitStatus !== 0) {
                toDoEvaTableData[i].isShow = true
                this.curEvaUserName = toDoEvaTableData[i].name
                this.table1CurShowIndex = i
                this.table1PreShowIndex = i
                this.buildBoutiqueProject = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                  return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
                })
                this.buildProTeam = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                  return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
                })
                this.nextPlan = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                  return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
                })
                this.forceRefresh = false
                this.$nextTick(() => {
                  this.forceRefresh = true
                })
                break
              }
            }
          } else { // 用户都已评价
            doneEvaTableData[0].isShow = true
            this.curEvaUserName = doneEvaTableData[0].name
            this.table2CurShowIndex = 0
            this.table2PreShowIndex = 0
            this.buildBoutiqueProject = doneEvaTableData[0].conclusionContent.find(contenItem => {
              return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
            })
            this.buildProTeam = doneEvaTableData[0].conclusionContent.find(contenItem => {
              return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
            })
            this.nextPlan = doneEvaTableData[0].conclusionContent.find(contenItem => {
              return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
            })
            this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(doneEvaTableData[0].conclusionEva.find(evaItem => {
              return evaItem.dimensionID === this.buildBoutiqueProject.id
            })))
            this.buildProTeamStar = JSON.parse(JSON.stringify(doneEvaTableData[0].conclusionEva.find(evaItem => {
              return evaItem.dimensionID === this.buildProTeam.id
            })))
            this.forceRefresh = false
            this.$nextTick(() => {
              this.forceRefresh = true
            })
          }
          this.PMdata = toDoEvaTableData
          this.doneEvaTableData = doneEvaTableData
          this.getDataLoading = true
        })
        // 管理者在此页面需计算所有绩效信息
        if (store.state.userInfo.duty === 1) {
          let promises = []
          let count = 0
          promises[count++] = this.getAllWorkTimeList(this.title)
          promises[count++] = this.getAllUserRates(usersList, this.title)
          Promise.all(promises).then(allResponse => {
          })
        }
      })
    },
    // 生成表格数据
    genTableData (conclusionYear, conclusionMonth, usersList) {
      // 初始化默认数据
      let allconclusionAndEvaData = []
      for (let user of usersList) {
        if (store.state.userInfo.groupName === '技术标准组' || store.state.userInfo.groupName === '工程组') {
          if (user.groupName === '技术标准组' || user.groupName === '工程组') {
            let obj = {
              id: user.id,
              name: user.name,
              submitStatus: 0,
              evaStatus: 0,
              conclusionContent: [],
              isShow: false,
              conclusionEva: []
            }
            allconclusionAndEvaData.push(obj)
          }
        } else if (store.state.userInfo.groupName === '通信组') {
          if (user.groupName === '通信组') {
            let obj = {
              id: user.id,
              name: user.name,
              submitStatus: 0,
              evaStatus: 0,
              conclusionContent: [],
              isShow: false,
              conclusionEva: []
            }
            allconclusionAndEvaData.push(obj)
          }
        } else {
          let obj = {
            id: user.id,
            name: user.name,
            submitStatus: 0,
            evaStatus: 0,
            conclusionContent: [],
            isShow: false,
            conclusionEva: []
          }
          allconclusionAndEvaData.push(obj)
        }
      }
      allconclusionAndEvaData.splice(allconclusionAndEvaData.findIndex(item => { return item.id === store.state.userInfo.id }), 1) // 把自己去掉
      let promise = []
      let count = 0
      for (let item of allconclusionAndEvaData) {
        promise[count++] = getCurMonthConclusionOverviewDataNew(conclusionYear, conclusionMonth, item.id)
      }
      return new Promise(function (resolve, reject) {
        Promise.all(promise).then(allResponse => {
          let promise2 = []
          let count2 = 0
          // ===================获取总结评价结果
          for (let i = 0; i < allconclusionAndEvaData.length; i++) {
            allconclusionAndEvaData[i].submitStatus = allResponse[i].data.length === 0 ? 0 : 1
            allconclusionAndEvaData[i].conclusionContent = allResponse[i].data
            if (allResponse[i].data.length > 0) { // 已经填写总结
              for (let item of allResponse[i].data) {
                if (item.dimension === 1 || item.dimension === 2) { // 打造精品工程和建设团队维度才获取评价结果
                  promise2[count2++] = getUserofAchievementToAnotherUser(item.id, store.state.userInfo.id)
                }
              }
            }
          }
          // 把对某个用户的总结评价嵌入表格数据中
          Promise.all(promise2).then(allResponse2 => {
            let toDoEvaArrayIndex = -1
            for (let item2 of allResponse2) {
              if (item2.length > 0) {
                for (let i = 0; i < allconclusionAndEvaData.length; i++) {
                  for (let j = 0; j < allconclusionAndEvaData[i].conclusionContent.length; j++) {
                    if (allconclusionAndEvaData[i].conclusionContent[j].id === item2[0].dimensionID) {
                      toDoEvaArrayIndex = i
                    }
                  }
                }
                if (toDoEvaArrayIndex !== -1) {
                  allconclusionAndEvaData[toDoEvaArrayIndex].conclusionEva.push(item2[0])
                }
              }
            }
            let toDoEvaTableData = []
            let doneEvaTableData = []
            // 已评价和未评价分类
            for (let allconclusionAndEvaDataItem of allconclusionAndEvaData) {
              if (allconclusionAndEvaDataItem.conclusionEva.length !== 0) { // 已评价
                allconclusionAndEvaDataItem.evaStatus = 1
                doneEvaTableData.push(allconclusionAndEvaDataItem)
              } else { // 未评价
                toDoEvaTableData.push(allconclusionAndEvaDataItem)
              }
            }
            resolve({
              toDoEvaTableData: toDoEvaTableData,
              doneEvaTableData: doneEvaTableData
            })
          }).catch(err => {
            reject(err)
          })
        }).catch(err => {
          reject(err)
        })
      })
    },
    // 点击显示(表格1)
    table1HandleShow (row, index) {
      this.curEvaUserName = row.name
      this.table1CurShowIndex = index
      this.PMdata[this.table1CurShowIndex].isShow = true
      this.PMdata[this.table1PreShowIndex].isShow = false
      this.table1PreShowIndex = index
      this.buildBoutiqueProject = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
      })
      this.buildProTeam = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
      })
      this.nextPlan = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      })
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
      })
    },
    // 点击显示（表格2）
    table2HandleShow (row, index) {
      this.curEvaUserName = row.name
      this.table2CurShowIndex = index
      this.doneEvaTableData[this.table2CurShowIndex].isShow = true
      this.doneEvaTableData[this.table2PreShowIndex].isShow = false
      this.table2PreShowIndex = index
      this.buildBoutiqueProject = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
      })
      this.buildProTeam = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
      })
      this.nextPlan = row.conclusionContent.find(contenItem => {
        return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
      })
      this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(row.conclusionEva.find(evaItem => {
        return evaItem.dimensionID === this.buildBoutiqueProject.id
      })))
      this.buildProTeamStar = JSON.parse(JSON.stringify(row.conclusionEva.find(evaItem => {
        return evaItem.dimensionID === this.buildProTeam.id
      })))
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
    // 点击提交对当前用户的评价并跳转到下一个待评价人
    handleSubmitAndJumpToNext () {
      this.submitEvaDataFlag = false
      let promises = []
      let count = 0
      promises[count++] = submitAMEvaData(store.state.userInfo.id, this.buildBoutiqueProject.id, this.buildBoutiqueProjectStar.evaStar)
      promises[count++] = submitAMEvaData(store.state.userInfo.id, this.buildProTeam.id, this.buildProTeamStar.evaStar)
      Promise.all(promises).then((allResponse) => {
        this.PMdata[this.table1CurShowIndex].evaStatus = 1
        this.PMdata[this.table1CurShowIndex].isShow = false
        // 插入提交的评价数据进当前数组
        let obj = {
          id: allResponse[0].id,
          evaStar: this.buildBoutiqueProjectStar.evaStar,
          dimensionID: this.buildBoutiqueProject.id,
          name: store.state.userInfo.name
        }
        this.PMdata[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
        obj.id = allResponse[1].id
        obj.evaStar = this.buildProTeamStar.evaStar
        obj.dimensionID = this.buildProTeam.id
        this.PMdata[this.table1CurShowIndex].conclusionEva.push(JSON.parse(JSON.stringify(obj)))
        this.doneEvaTableData.push(this.PMdata[this.table1CurShowIndex])
        this.PMdata.splice(this.table1CurShowIndex, 1)
        this.toDoEvaNum -= 1
        this.doneEvaNum += 1
        Notification.success({
          title: '成功',
          message: '提交成功'
        })
        // 重置默认评价星级
        this.buildBoutiqueProjectStar.evaStar = store.state.defaultStar
        this.buildProTeamStar.evaStar = store.state.defaultStar
        // 跳转到下一个未评价的用户
        let index = this.PMdata.findIndex(PMdataItem => {
          return PMdataItem.evaStatus === 0 && PMdataItem.submitStatus === 1
        })
        if (index !== -1) { // 还有未评价的用户
          this.curEvaUserName = this.PMdata[index].name
          this.table1CurShowIndex = index
          this.PMdata[this.table1CurShowIndex].isShow = true
          this.PMdata[this.table1PreShowIndex].isShow = false
          this.table1PreShowIndex = index
          this.buildBoutiqueProject = this.PMdata[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
          })
          this.buildProTeam = this.PMdata[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
          })
          this.nextPlan = this.PMdata[this.table1CurShowIndex].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
          })
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
        } else { // 都已评价
          this.clearEvaTable()
          Notification.info({
            title: '成功',
            message: '已全部评价完成'
          })
        }
        this.submitEvaDataFlag = true
      }).catch(err => {
        Notification.error({
          title: '失败',
          message: '提交失败'
        })
        this.submitEvaDataFlag = true
        console.log(err)
      })
    },
    // 点击更新对用户的评价
    handleUpdateEva () {
      this.updateEvaDataFlag = false
      let promises = []
      let count = 0
      promises[count++] = updateAMEvaData(this.buildBoutiqueProjectStar.id, this.buildBoutiqueProjectStar.evaStar)
      promises[count++] = updateAMEvaData(this.buildProTeamStar.id, this.buildProTeamStar.evaStar)
      Promise.all(promises).then(() => {
        let findEvaItem = this.doneEvaTableData[this.table2CurShowIndex].conclusionEva.find(doneEvaItem => {
          return doneEvaItem.id === this.buildBoutiqueProjectStar.id
        })
        findEvaItem.evaStar = this.buildBoutiqueProjectStar.evaStar
        findEvaItem = this.doneEvaTableData[this.table2CurShowIndex].conclusionEva.find(doneEvaItem => {
          return doneEvaItem.id === this.buildProTeamStar.id
        })
        findEvaItem.evaStar = this.buildProTeamStar.evaStar
        Notification.success({
          title: '成功',
          message: '更新成功'
        })
        this.updateEvaDataFlag = true
      }).catch(err => {
        Notification.error({
          title: '失败',
          message: '更新失败'
        })
        this.updateEvaDataFlag = true
        console.log(err)
      })
    },
    // 折叠面板切换
    handleCollapseChange () {
      if (Number(this.activeName) === 1) { // 展开待评价页面
        if (this.PMdata.length !== 0) { // 还有未评价的用户
          // 重置默认评价星级
          this.buildBoutiqueProjectStar.evaStar = store.state.defaultStar
          this.buildProTeamStar.evaStar = store.state.defaultStar
          for (let i = 0; i < this.PMdata.length; i++) {
            if (this.PMdata[i].submitStatus !== 0) {
              this.PMdata[i].isShow = true
              this.curEvaUserName = this.PMdata[i].name
              this.table1CurShowIndex = i
              this.table1PreShowIndex = i
              this.buildBoutiqueProject = this.PMdata[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
              })
              this.buildProTeam = this.PMdata[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
              })
              this.nextPlan = this.PMdata[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
              })
              this.forceRefresh = false
              this.$nextTick(() => {
                this.forceRefresh = true
              })
              break
            }
          }
        } else {
          this.clearEvaTable()
        }
      } else if (Number(this.activeName) === 2) { // 展开已评价页面
        this.clearEvaTable()
        if (this.doneEvaTableData.length !== 0) {
          this.doneEvaTableData[0].isShow = true
          this.curEvaUserName = this.doneEvaTableData[0].name
          this.table2CurShowIndex = 0
          this.table2PreShowIndex = 0
          this.buildBoutiqueProject = this.doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
          })
          this.buildProTeam = this.doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
          })
          this.nextPlan = this.doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
          })
          this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(this.doneEvaTableData[0].conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.buildBoutiqueProject.id
          })))
          this.buildProTeamStar = JSON.parse(JSON.stringify(this.doneEvaTableData[0].conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.buildProTeam.id
          })))
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
        } else {
          this.clearEvaTable()
        }
      } else if (this.activeName === '') { // 全部折叠
        this.clearEvaTable()
      }
    },
    // 日期发生变化
    handleDataChange () {
      this.clearEvaTable()
      this.getDataLoading = false
      let conclusionYear = this.$moment(this.title).year()
      let conclusionMonth = this.$moment(this.title).month() + 1
      this.genTableData(conclusionYear, conclusionMonth, this.usersList).then(tableData => {
        let toDoEvaTableData = tableData.toDoEvaTableData
        let doneEvaTableData = tableData.doneEvaTableData
        this.toDoEvaNum = toDoEvaTableData.length
        this.doneEvaNum = doneEvaTableData.length
        // 初始化默认显示的数据
        if (toDoEvaTableData.length !== 0) { // 还有未评价的用户
          for (let i = 0; i < toDoEvaTableData.length; i++) {
            if (toDoEvaTableData[i].submitStatus !== 0) {
              toDoEvaTableData[i].isShow = true
              this.curEvaUserName = toDoEvaTableData[i].name
              this.table1CurShowIndex = i
              this.table1PreShowIndex = i
              this.buildBoutiqueProject = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
              })
              this.buildProTeam = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
              })
              this.nextPlan = toDoEvaTableData[i].conclusionContent.find(contenItem => {
                return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
              })
              this.forceRefresh = false
              this.$nextTick(() => {
                this.forceRefresh = true
              })
              break
            }
          }
        } else { // 用户都已评价
          doneEvaTableData[0].isShow = true
          this.curEvaUserName = doneEvaTableData[0].name
          this.table2CurShowIndex = 0
          this.table2PreShowIndex = 0
          this.buildBoutiqueProject = doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildBoutiqueProject.dimension
          })
          this.buildProTeam = doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.buildProTeam.dimension
          })
          this.nextPlan = doneEvaTableData[0].conclusionContent.find(contenItem => {
            return contenItem.dimension === store.state.conclusionTextNew.nextPlan.dimension
          })
          this.buildBoutiqueProjectStar = JSON.parse(JSON.stringify(doneEvaTableData[0].conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.buildBoutiqueProject.id
          })))
          this.buildProTeamStar = JSON.parse(JSON.stringify(doneEvaTableData[0].conclusionEva.find(evaItem => {
            return evaItem.dimensionID === this.buildProTeam.id
          })))
          this.forceRefresh = false
          this.$nextTick(() => {
            this.forceRefresh = true
          })
        }
        this.PMdata = toDoEvaTableData
        this.doneEvaTableData = doneEvaTableData
        this.getDataLoading = true
      })
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
    },
    // 清空评价表格
    clearEvaTable () {
      // 重置默认评价星级
      this.buildBoutiqueProjectStar.evaStar = store.state.defaultStar
      this.buildProTeamStar.evaStar = store.state.defaultStar
      if (this.table1CurShowIndex !== -1) {
        if (this.PMdata[this.table1CurShowIndex].isShow) {
          this.PMdata[this.table1CurShowIndex].isShow = false
          this.table1CurShowIndex = -1
        }
      }
      if (this.table2CurShowIndex !== -1) {
        if (this.doneEvaTableData[this.table2CurShowIndex].isShow) {
          this.doneEvaTableData[this.table2CurShowIndex].isShow = false
          this.table2CurShowIndex = -1
        }
      }
      this.buildBoutiqueProject = {
        content: '无数据'
      }
      this.buildProTeam = {
        content: '无数据'
      }
      this.nextPlan = ''
      this.forceRefresh = false
      this.$nextTick(() => {
        this.forceRefresh = true
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

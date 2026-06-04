<template>
  <div>
    <el-dialog
      title="绩效加分申报"
      :visible.sync="dialogVisible"
      :before-close="onClose" width="70%">
      <el-form label-position="left" label-width="110px" ref="formData" :model="formData" :rules="formRules" :inline="true">
        <el-form-item label="申报月份" prop="title">
          <el-date-picker
            v-model="formData.title"
            type="month"
            format="yyyy 年 MM 月"
            value-format="yyyy-MM"
            style="width: 150px" @change="handleDateChange">
          </el-date-picker>
        </el-form-item>
        <br>
        <el-form-item label="绩效加分类型" prop="PBType">
          <el-cascader
            :disabled="true"
            v-if="showFlag.PBType"
            v-model="formData.PBType"
            :options="PBTypeOptions"
            :props="props"
            collapse-tags
            filterable
            clearable
            style="width: 200%">
          </el-cascader>
        </el-form-item>
        <br>
        <el-form-item label="加分事项描述" prop="PBName">
          <el-tooltip :disabled="!isShowPBNameToolTip" :content="formData.PBName" placement="top">
            <el-input v-model="formData.PBName"
                      placeholder="请输入"
                      style="width: 250%"
                      @input="handlePBNameInput"></el-input>
          </el-tooltip>
        </el-form-item>
        <el-form-item style="margin-left: 310px">
          <span>字数限制：
            <span v-if="!isPBNameLengthExceed">{{inputPBNameWord + '/' + maxPBNameLength}}</span>
            <span v-else style="color: red">{{inputPBNameWord + '/' + maxPBNameLength}}</span>
          </span>
        </el-form-item>
        <br>
        <!-- 分割线 start -->
        <div class="hr-10"></div>
        <!-- 分割线 end -->
        <br>
        <!--申报绩效加分明细-->
        <el-table
          v-if="showFlag.freshTable"
          :data="PBData"
          stripe
          style="width: 97%;margin: auto">
          <el-table-column type="index" align="center" label="序号"></el-table-column>
          <el-table-column label="绩效加分类型" prop="PBType" align="center"></el-table-column>
          <el-table-column label="绩效加分规则" prop="PBRule" align="center"></el-table-column>
          <el-table-column label="绩效加分" prop="PBScore" align="center"></el-table-column>
          <el-table-column label="K值" align="center">
            <template slot-scope="scope">
              <el-input-number :disabled="scope.row.PBRuleID !== 38"
                              size="mini"
                              :min="0"
                              v-model="scope.row.kValue"
                              :step="0.1"
                              :precision="2"
                              @change="handlekValueChange(scope.row)">
              </el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="分数分配" align="center" width="100%">
            <template slot-scope="scope">
              <el-popover
                placement="bottom"
                width="600"
                trigger="click"
                popper-class="el-popover-v1">
                <el-row>
                  <el-col :xs="12" :sm="12" :lg="5" :xl="5">
                    <span style="font-weight: bold;">总分数：</span>
                    <span style="font-weight: bold;color: #ff0000;">{{ scope.row.PBScoretiaozheng.toFixed(2) }}</span>
                  </el-col>
                  <el-col :xs="12" :sm="12" :lg="5" :xl="5">
                    <span style="font-weight: bold;">已分配：</span>
                    <span style="font-weight: bold;color: #ff0000;">{{ scope.row.assignedPBScore.toFixed(2)}}</span>
                  </el-col>
                  <el-col :xs="12" :sm="12" :lg="12" :xl="12">
                    <span>人员分配：</span>
                    <el-select  v-model="scope.row.participant"
                                size="mini"
                                placeholder="请选择"
                                clearable
                                filterable
                                multiple
                                collapse-tags
                                @change="handlePartChange(scope.row.PBScoreAssign, scope.row.participant)">
                      <el-option-group
                        v-for="group in userListOptions"
                        :key="group.id"
                        :label="group.name"
                        :value="group.id">
                        <el-option
                          v-for="item in group.options"
                          :key="item.id"
                          :label="item.name"
                          :value="item.id"
                          :disabled="item.disabled">
                        </el-option>
                      </el-option-group>
                    </el-select>
                  </el-col>
                </el-row>
                <el-table :data="scope.row.PBScoreAssign">
                  <el-table-column type="index" align="center" label="序号"></el-table-column>
                  <el-table-column prop="name" label="姓名" align="center"></el-table-column>
                  <el-table-column label="分数" align="center">
                    <template slot-scope="scope2">
                      <el-input-number size="mini"
                                      v-model="scope2.row.assignScore"
                                      :step="0.1"
                                      :precision="2"
                                      @change="handlePBScoreChange(scope.row)">
                      </el-input-number>
                    </template>
                  </el-table-column>
                  <el-table-column label="操作" align="center">
                    <template slot-scope="scope2">
                      <el-button type="danger"
                                size="mini"
                                @click="handleDelAssist(scope.row, scope.row.PBScoreAssign, scope.row.participant, scope2.$index)"
                                :disabled="scope.row.role === 1">删除</el-button>
                    </template>
                  </el-table-column>
                </el-table>
                <span slot="reference" class="link-type">点击分配</span>
              </el-popover>
            </template>
          </el-table-column>
          <el-table-column label="备注" prop="PBComments" align="center" width="200%">
            <template slot-scope="scope">
              <el-input size="mini"
                        type="textarea"
                        autosize
                        v-model="scope.row.PBComments"
                        @input="PBCommentsChange(scope.row)">
              </el-input>
              <span style="font-size: 10px">字数限制：
                <span v-if="!scope.row.isPBCommentsLengthExceed">
                  {{scope.row.PBCommentsLength? scope.row.PBCommentsLength : 0}} {{'/' + maxPBCommentsWord}}
                </span>
                <span v-else style="color: red">
                  {{scope.row.PBCommentsLength? scope.row.PBCommentsLength : 0}} {{'/' + maxPBCommentsWord}}
                </span>
              </span>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center" width="100%">
            <template slot-scope="scope">
              <el-button size="mini" type="danger" @click="handleDelete(scope.$index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button type="danger"  @click="onClose">取消</el-button>
        <el-button type="warning" @click="onSubmit('formData', 0)">暂存</el-button>
        <el-button type="primary" @click="onSubmit('formData', 1)">提交</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
  import {} from '@/config/interface'
  import { sortObjectArrayByParamsSmall2Big } from '@/utils/common'
  import Cookies from 'js-cookie'
  import { getPMBRules, updatePBData } from '@/utils/performanceBonus'
  import store from '@/store'
  import { getUsersList } from '@/utils/users'
  import moment from 'moment'
  export default {
    data () {
      return {
        dialogVisible: false,
        PBDataID: null,
        PBData: [],
        PBRulesDetail: [],
        participant: [],
        isPBNameLengthExceed: false,
        isPBCommentsLengthExceed: false,
        inputPBNameWord: 0,
        maxPBNameLength: 60,
        PBCommentsLength: 0,
        isShowPBNameToolTip: false,
        maxPBCommentsWord: 500,
        applyYear: null,
        applyMonth: null,
        userListOptions: store.state.organization,
        props: {
          multiple: true,
          value: 'id',
          label: 'PBType',
          expandTrigger: 'hover'
        },
        isDisablePBType: false,
        PBTypeOptions: [],
        optionsWorkType: [],
        partTableData: [{
          workTime: undefined
        }],
        applyType: this.$route.query.type,
        formData: {
          title: null,
          PBType: [[0]],
          usersList: [],
          partWorkTime: 0,
          partTableData: [],
          projectLevel: 1,
          PBName: null
        },
        formRules: {
          title: [
            { required: true, message: '请选择申报月份', trigger: 'blur' }
          ],
          PBName: [
            { required: true, message: '请输入加分事项描述', trigger: 'blur' }
          ],
          PBType: [
            { required: true, message: '请选择绩效加分类型', trigger: 'change' }
          ]
        },
        reqFlag: {
          add: true,
          usersName: true,
          submitOrTemporaryWorkTime: true,
          getAssignProjectList: true
        },
        showFlag: {
          PBType: true,
          workTimeAssign: false,
          projectType: true,
          freshTable: true
        },
        workTime: 0,
        selectProjectStageID: null,
        selectPersion: null,
        usersList: null
      }
    },
    props: {
      fatherPBData: {
        type: Object,
        default: null
      }
    },
    methods: {
      // 初始化
      init () {
        this.formData.title = this.fatherPBData.applyDate
        this.formData.PBName = this.fatherPBData.PBName
        this.applyYear = moment(this.formData.title).year()
        this.applyMonth = moment(this.formData.title).month() + 1
        // ***查找已分配分数和协助者***
        let assignedPBScore = 0
        let participant = []
        sortObjectArrayByParamsSmall2Big(this.fatherPBData.PBScoreAssign, 'role', 'assignScore')
        for (let item of this.fatherPBData.PBScoreAssign) {
          assignedPBScore += item.assignScore
          if (item.role !== 1) {
            participant.push(item.userID)
          }
        }
        this.fatherPBData.assignedPBScore = assignedPBScore
        this.fatherPBData.participant = participant
        this.fatherPBData.PBScoretiaozheng = this.fatherPBData.PBScore * this.fatherPBData.kValue
        this.PBDataID = this.fatherPBData.id
        // ***
        this.PBData = [JSON.parse(JSON.stringify(this.fatherPBData))]
        getPMBRules().then(getPMBRulesRes => {
          this.PBTypeOptions = getPMBRulesRes
          for (let i = 0; i < getPMBRulesRes.length; i++) {
            for (let j = 0; j < getPMBRulesRes[i].children.length; j++) {
              if (getPMBRulesRes[i].children[j].id === this.fatherPBData.PBRuleID) {
                let tmp = String(getPMBRulesRes[i].id) + ',' + String(getPMBRulesRes[i].children[j].id)
                this.formData.PBType = [tmp]
                break
              }
            }
          }
        })
        let groupID = 0
        getUsersList(groupID).then(users => {
          let findIndex = users.findIndex(user => {
            return user.account === '03515' // ***去除处经理
          })
          if (findIndex !== -1) {
            users.splice(findIndex, 1)
          }
          findIndex = users.findIndex(user => {
            return user.account === this.$store.state.userInfo.account // ***去除自己
          })
          if (findIndex !== -1) {
            users.splice(findIndex, 1)
          }
          this.userListOptions[1].options = users
          this.usersList = JSON.parse(JSON.stringify(users))
        })
        this.dialogVisible = !this.dialogVisible
      },

      // **协作者分数分配变化监控函数
      handlePBScoreChange (row) {
        row.assignedPBScore = 0
        for (let item of row.PBScoreAssign) {
          row.assignedPBScore += item.assignScore
        }
        row.assignedPBScore = Number(row.assignedPBScore.toFixed(2))
      },

      // **K值调整监控函数
      handlekValueChange (row) {
        row.assignedPBScore = 0

        // 计算绩效加分值 * K值作为调整后的总分数
        row.PBScoretiaozheng = row.PBScore * row.kValue
        // 如果当前用户是主要申报人，自动调整其分配分数
        const mainUser = row.PBScoreAssign.find(item => item.role === 1)
        if (mainUser) {
          mainUser.assignScore = row.PBScoretiaozheng
        }
        for (let item of row.PBScoreAssign) {
          row.assignedPBScore += item.assignScore
        }
      },

      // **参与人员变化处理
      handlePartChange (PBScoreAssign, participant) {
        let selectUsers = []
        let tableUsers = []
        let selectUsersLen = 0

        /* 取出现有表格中的数据 */
        for (let item of PBScoreAssign) {
          if (item.userID !== this.$store.state.userInfo.id) {
            tableUsers.push(item.userID)
          }
        }

        selectUsers = JSON.parse(JSON.stringify(participant))
        let usersList = JSON.parse(JSON.stringify(this.usersList))
        let allUsers = []
        let allUsersIndex = selectUsers.indexOf('0')
        if (allUsersIndex !== -1) { // **选择了全处室，全人员数组赋值
          allUsers = JSON.parse(JSON.stringify(usersList))
          selectUsers.splice(allUsersIndex, 1)
        }
        let MediaUsers = []
        let MediaUsersIndex = selectUsers.indexOf('2')
        if (MediaUsersIndex !== -1) { // **选择了多媒体应用组，多媒体应用组人员数组赋值
          MediaUsers = JSON.parse(JSON.stringify(usersList.filter(item => { return item.groupID === 2 })))
          selectUsers.splice(MediaUsersIndex, 1)
        }
        let DigitalUsers = []
        let DigitalUsersIndex = selectUsers.indexOf('3')
        if (DigitalUsersIndex !== -1) { // **选择了数字物联组，数字物联组人员数组赋值
          DigitalUsers = JSON.parse(JSON.stringify(usersList.filter(item => { return item.groupID === 3 })))
          selectUsers.splice(DigitalUsersIndex, 1)
        }
        let ZongheUsers = []
        let ZongheUsersIndex = selectUsers.indexOf('4')
        if (ZongheUsersIndex !== -1) { // **选择了综合业务组，综合业务组人员数组赋值
          ZongheUsers = JSON.parse(JSON.stringify(usersList.filter(item => { return item.groupID === 4 })))
          selectUsers.splice(ZongheUsersIndex, 1)
        }
        let CommueUsers = []
        let CommueUsersIndex = selectUsers.indexOf('5')
        if (CommueUsersIndex !== -1) { // **选择了通信组，通信组人员数组赋值
          CommueUsers = JSON.parse(JSON.stringify(usersList.filter(item => { return item.groupID === 5 })))
          selectUsers.splice(CommueUsersIndex, 1)
        }
        allUsers = allUsers.concat(MediaUsers, DigitalUsers, ZongheUsers, CommueUsers).filter((value, index, self) => {
          return self.findIndex(t => JSON.stringify(t) === JSON.stringify(value)) === index // **合并以上人员数组并去掉重复项
        })
        for (let item of allUsers) { // **只保留选择人员的ID
          selectUsers.push(item.id)
        }
        selectUsers = selectUsers.filter((value, index, self) => { // **选择人员ID去重
          return self.indexOf(value) === index
        })
        selectUsersLen = selectUsers.length
        let tableUsersLen = tableUsers.length
        let difference = selectUsers.filter(x => tableUsers.indexOf(x) === -1)
          .concat(tableUsers.filter(x => selectUsers.indexOf(x) === -1))
        if (selectUsersLen > tableUsersLen) {
          for (let index of difference) {
            let tmp = this.usersList.find((item) => {
              if (item.id === index) {
                let obj = {
                  id: null,
                  userID: item.id,
                  groupName: item.groupName,
                  groupID: item.groupID,
                  name: item.name,
                  role: 2,
                  assignScore: 0,
                  PBDataID: this.PBDataID,
                  deleteAble: false
                }
                PBScoreAssign.push(obj)
                return PBScoreAssign
              }
            })
          }
        } else {
          for (let diff of difference) {
            let index = tableUsers.indexOf(diff)
            PBScoreAssign.splice(index + 1, 1)
            tableUsers.splice(index, 1)
          }
        }
      },

      // **日期变化
      handleDateChange () {
        this.applyYear = moment(this.formData.title).year()
        this.applyMonth = moment(this.formData.title).month() + 1
      },

      // ** 绩效加分事项名称输入框监控
      handlePBNameInput () {
        this.inputPBNameWord = this.formData.PBName.length
        this.isPBNameLengthExceed = this.formData.PBName.length > this.maxPBNameLength
        this.isShowPBNameToolTip = this.formData.PBName.length > 50
      },
      // ***备注输入名称监控
      PBCommentsChange (row) {
        row.PBCommentsLength = row.PBComments.length
        row.isPBCommentsLengthExceed = row.PBCommentsLength > this.maxPBCommentsWord
        if (row.isPBCommentsLengthExceed) {
          this.$common.toast('备注字数过多，请删减', 'error', false)
          this.isPBCommentsLengthExceed = true
        } else {
          this.isPBCommentsLengthExceed = false
        }
      },
      // ***删除协助者按钮
      handleDelAssist (row, PBScoreAssign, participant, index) {
        let deleteIndex = participant.findIndex(participantItem => {
          return participantItem === PBScoreAssign.userID
        })
        row.assignedPBScore -= PBScoreAssign[index].assignScore
        PBScoreAssign.splice(index, 1)
        participant.splice(deleteIndex, 1)
      },
      // ***关闭对话框
      onClose () {
        this.dialogVisible = !this.dialogVisible
        this.$emit('closeEdit')
      },
      // **提交&暂存
      onSubmit (formData, submitStatus) {
        this.$refs[formData].validate((valid) => {
          if (valid) {
            let isOverPMScore = false
            let tmp = null
            for (let item of this.PBData) {
              if (item.assignedPBScore > item.PBScoretiaozheng) {
                isOverPMScore = true
                tmp = JSON.parse(JSON.stringify(item))
                break
              }
            }
            if (isOverPMScore) {
              this.$common.toast(tmp.PBType + '"已分配分数"大于"总分数"，请调整', 'error', true)
            } else {
              let id = this.PBData[0].id
              let PBRuleID = this.PBData[0].PBRuleID
              let kValue = this.PBData[0].kValue
              let PBScoreAssign = this.PBData[0].PBScoreAssign
              let PBComments = this.PBData[0].PBComments
              let reviewStatus = this.PBData[0].reviewStatus
              if (this.PBData[0].reviewStatus === 2 && submitStatus === 1) { // ***若为驳回的申报且当前为提交，则将审核标志位重置为未审核状态
                reviewStatus = 0
              }
              updatePBData(id,
                           this.formData.PBName,
                           store.state.userInfo.id,
                           this.applyYear,
                           this.applyMonth,
                           submitStatus,
                           reviewStatus,
                           PBRuleID,
                           kValue,
                           PBComments,
                           PBScoreAssign).then(() => {
                              this.$common.toast('提交成功', 'success', false)
                              this.dialogVisible = false
                              this.$emit('submitDataSuccess')
                           }).catch(err => {
                            console.log(err)
                           })
            }
          } else {
            return false
          }
        })
      },
      // ** 删除行
      handleDelete (index) {
        this.PBData.splice(index, 1)
        this.formData.PBType.splice(index, 1)
        this.showFlag.PBType = false
        this.refreshPBType()
      },
      // ***手动刷新项目类型
      refreshPBType () {
        this.showFlag.PBType = false
        let it = this
        setTimeout(() => {
          it.showFlag.PBType = true
        }, it.$store.state.refreshInterval)
      }
    },
    computed: {
      projectStageEditable () {
        if (this.formData.PBType.length === 0) {
          return false
        } else {
          return this.formData.PBType[0][0] === 5
        }
      }
    },
    components: {
    },
    created () {
      // this.applyType = this.$route.query.type
      this.init()
    },
    name: 'PerformanceBonusViewEdit.vue'
  }
</script>

<style lang="scss">
  .el-popover-v1 {
    height: 450px;
    overflow: auto;
  }
</style>

<template>
  <el-dialog title="工时分配"
             :visible.sync="formData.showFlag"
             custom-class="dialog-small"
             @close="closeDialog"
             width="60%"
             append-to-body>
    <div style ="margin-top: -20px">
      <el-form ref="formData" :model="formData" :rules="formRules" :inline="true">
        <el-form-item prop="multiParticipant">
          <el-checkbox v-model="formData.multiParticipant"
                       size="medium"
                       border>多人协作</el-checkbox>
        </el-form-item>
        <el-form-item label="工时数" v-if="formData.multiParticipant" prop="workTime" style="margin-left: 20px">
          <el-input-number v-model.number="formData.workTime"
                           :disabled="formData.isConference === 1"
                           size="mini"
                           :min="0.0"
                           :step="0.5"
                           :precision="2">
          </el-input-number>
        </el-form-item>
        <el-form-item v-if="formData.multiParticipant"
                      label="参与人员"
                      prop="participant"
                      style="margin-left: 20px">
          <el-select v-model="formData.participant"
                     size="mini"
                     placeholder="请选择"
                     clearable
                     filterable
                     multiple
                     collapse-tags
                     @change="handlePartChange" style="width: 90%">
            <el-option-group
              v-for="group in formData.userListOptions"
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
        </el-form-item>
        <div v-if="!formData.isConference">
          <span style="font-weight: bold;font-size: 120%">
            总可用工时：<span style="color: #ff0000;font-size: 130%">{{formData.avaiableWorkTime}}</span>
          </span>
          <span style="margin-left: 50px;font-weight: bold;font-size: 120%">
            已分配工时：<span style="color: red;font-size: 130%">{{assignedWorkTime}}</span>
          </span>
        </div>
        <el-table
          height="350"
          :data="formData.copInfoTable"
          style="width: 100%;margin: auto">
          <el-table-column type="index" label="序号" align="center"></el-table-column>
          <el-table-column label="小组" prop="groupName" align="center">
            <template slot-scope="scope">
              <el-tag :type="scope.row.groupID | groupIDFilter">
                {{scope.row.groupName}}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="姓名" prop="name" align="center"></el-table-column>
          <el-table-column label="角色" prop="applyRole" align="center"></el-table-column>
          <el-table-column label="工时" align="center" width="200">
            <template slot-scope="scope">
              <el-form-item
                :prop="'copInfoTable.' + scope.$index + '.assignWorkTime'"
                :rules="formRules.assignWorkTime"
                style="margin: auto">
                <el-input-number size="mini"
                                 v-model="scope.row.assignWorkTime"
                                 :step="0.5"
                                 :precision="2"
                                 @change="handleAssignWorkTimeChange(scope.row)">
                </el-input-number>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center">
            <template slot-scope="scope">
              <el-button type="danger"
                         size="mini"
                         @click="handleDelAssist(scope.row, scope.$index)"
                         :disabled="scope.row.applyRole === '组织者'">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-form>
    </div>
    <div class="dialog-footer" style="text-align: center;margin-top: 20px">
      <el-button type="primary" size="mini" @click="onSave('formData')">保存</el-button>
      <el-button type="danger" size="mini" @click="onCancel('formData')">关闭</el-button>
    </div>
  </el-dialog>
</template>

<script>
import { getUsersList } from '@/utils/users'
import store from '@/store'
import jsCookie from 'js-cookie'
export default {
  data () {
    return {
      usersList: [],
      formData: {
        copInfoTable: [],
        workTime: 0.0,
        showFlag: false,
        reqFlag: {
          edit: true,
          usersName: true
        },
        multiParticipant: false,
        userListOptions: store.state.organization,
        participant: [],
        selectIndex: null,
        isConference: false,
        defaultAssignWorkTime: 0
      },
      formRules: {
        assignWorkTime: [
          { required: true, message: '请输入工时', trigger: 'blur' }
        ],
        multiParticipant: [
          { required: false, message: '', trigger: 'blur' }
        ],
        workTime: [
          { required: false, message: '', trigger: 'blur' }
        ],
        participant: [
          { required: false, message: '', trigger: 'blur' }
        ]
      }
    }
  },
  components: {
  },
  created () {
  },
  mounted () {
  },
  destroyed () {
  },
  methods: {
    // 初始化
    init (params) {
      this.$nextTick(() => {
        let groupID = 0
        getUsersList(groupID).then(users => {
          let findIndex = users.findIndex(user => {
            return user.account === '03515' // ***去除处经理
          })
          if (findIndex !== -1) {
            users.splice(findIndex, 1)
          }
          findIndex = users.findIndex(user => {
            return user.account === this.$store.state.userInfo.account // 去除自己
          })
          if (findIndex !== -1) {
            users.splice(findIndex, 1)
          }
          this.formData.userListOptions[1].options = users
          this.usersList = JSON.parse(JSON.stringify(users))
        })
        this.formData.isConference = params.rowCop.isConference
        this.formData.defaultAssignWorkTime = params.rowCop.defaultAssignWorkTime
        this.formData.workTime = this.formData.defaultAssignWorkTime
        this.formData.avaiableWorkTime = Number(params.rowCop.avaiableWorkTime.toFixed(2))
        this.formData.copInfoTable = params.rowCop.workTimeAssign
        this.formData.selectIndex = params.index
        this.formData.multiParticipant = params.rowCop.multipleAssign
        this.formData.participant = params.rowCop.multipleSelect
        this.changeShowFlag()
      })
    },
    // 对话框显示/隐藏
    changeShowFlag () {
      this.formData.showFlag = !this.formData.showFlag
    },
    // 分配工时变化
    handleAssignWorkTimeChange (row) {
    },
    // 保存
    onSave (formData) {
      this.$refs[formData].validate((valid) => {
        if (valid) {
          if (this.assignedWorkTime > this.formData.avaiableWorkTime && (Number(this.formData.isConference) === 0)) {
            this.$common.toast('"已分配工时"大于"总可用工时"，请调整', 'error', true)
          } else {
            let params = {
              workTimeAssignDetail: this.formData.copInfoTable,
              index: this.formData.selectIndex,
              multipleAssign: this.formData.multiParticipant,
              multipleSelect: this.formData.participant
            }
            params = JSON.parse(JSON.stringify(params)) // 深拷贝
            this.$emit('assignDetail', params)
            this.onCancel(formData)
            this.$common.toast('保存成功', 'success', false)
          }
        } else {
          return false
        }
      })
    },
    // 取消
    onCancel (formName) {
      this.changeShowFlag()
      this.$nextTick(() => {
        this.$refs[formName].resetFields()
      })
    },
    // 参与人员变化处理
    handlePartChange () {
      let selectUsers = []
      let tableUsers = []
      let selectUsersLen = 0
      let tmp = []
      /* 取出现有表格中的数据 */
      for (let item of this.formData.copInfoTable) {
        if (item.id !== this.$store.state.userInfo.id) {
          tableUsers.push(item.id)
        }
      }

      selectUsers = JSON.parse(JSON.stringify(this.formData.participant))
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
          tmp = this.usersList.find((item) => {
            if (item.id === index) {
              let obj = {
                id: item.id,
                groupName: item.groupName,
                groupID: item.groupID,
                name: item.name,
                applyRole: '协作者',
                assignWorkTime: this.formData.workTime,
                deleteAble: false
              }
              this.formData.copInfoTable.push(obj)
              return this.formData.copInfoTable
            }
          })
        }
      } else {
        for (let diff of difference) {
          let index = tableUsers.indexOf(diff)
          this.formData.copInfoTable.splice(index + 1, 1)
          tableUsers.splice(index, 1)
        }
      }
    },
    // 关闭弹出框
    closeDialog () {
      this.$nextTick(() => {
        // this.$refs['formData'].resetFields()
      })
    },
    // 删除协助者按钮
    handleDelAssist (row, index) {
      this.formData.copInfoTable.splice(index, 1)
      let deleteIndex = this.formData.participant.findIndex(participantItem => {
        return participantItem === row.id
      })
      this.formData.participant.splice(deleteIndex, 1)
    }
  },
  computed: {
    assignedWorkTime () {
      let assignedWorkTime = 0
      for (let item of this.formData.copInfoTable) {
        assignedWorkTime += item.assignWorkTime
      }
      return assignedWorkTime
    }
  },
  filters: {
    groupIDFilter (groupID) {
      switch (groupID) {
        case 0:
          return 'success'
        case 2:
          return 'success'
        case 3:
          return 'warning'
        case 4:
          return 'danger'
        case 5:
          return 'primary'
        default:
          return 'info'
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .dialogDiv {
    height: 350px;
    overflow: auto;
  }
</style>

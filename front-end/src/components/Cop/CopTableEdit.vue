<!-- 编辑状态下的工时分配组件 -->
<template>
  <div>
    <!-- 上方选择协助人区域 -->
    <div>
      <el-checkbox v-model="multiParticipant"
                   size="medium">多人协作</el-checkbox>
      <span style="margin-left: 20px">参与人员：</span>
      <el-select v-model="participant"
                 size="mini"
                 placeholder="请选择"
                 clearable
                 filterable
                 multiple
                 collapse-tags
                 @change="handlePartChange()"
                 @visible-change="handleSelectVisibleChange()">
        <el-option-group
          v-for="group in userListOptions"
          :key="group.value"
          :label="group.name"
          :value="group.value">
          <el-option
            v-for="item in group.options"
            :key="item.id"
            :label="item.name"
            :value="item.id"
            :disabled="item.disabled">
          </el-option>
        </el-option-group>
      </el-select>
      <span v-if="isConference" style="font-weight: bold;font-size: 120%">
        总可用工时：<span style="color: red;font-size: 130%">{{ avaiableWorkTime }}</span>
      </span>
      <span v-if="isConference" style="margin-left: 50px;font-weight: bold;font-size: 120%">
        已分配工时：<span style="color: red;font-size: 130%">{{ assignedWorkTime }}</span>
      </span>
    </div>
    <!-- 主显示表格 -->
    <div>
      <el-table
        :data="tableData"
        :height="400"
        style="width: 100%;margin: auto">
        <el-table-column label="序号" align="center" type="index"></el-table-column>
        <el-table-column label="姓名" prop="name" align="center"></el-table-column>
        <el-table-column label="小组" prop="groupName" align="center" width="110">
          <template slot-scope="scope">
            <el-tag :type="scope.row.groupName | groupNameFilter">
              {{scope.row.groupName}}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="角色" prop="assignRole" align="center"></el-table-column>
        <el-table-column label="申报工时" prop="workTime" align="center"></el-table-column>
        <el-table-column label="审核工时" align="center">
          <template slot-scope="scope">
            <span>
              {{ { reviewStatus: scope.row.reviewStatus, reviewWorkTime: scope.row.reviewWorkTime } | reviewStatusTextFilter}}
            </span>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>

<script>
import { getWorkTimeAssign } from '@/utils/performance'
import { getUsersList } from '@/utils/users'
export default {
  data () {
    return {
      tableData: [],
      usersList: [],
      multiParticipant: false,
      avaiableWorkTime: null,
      assignedWorkTime: null,
      isConference: false,
      participant: [],
      preParticiant: [],
      preSelectOrganize: [],
      userListOptions: [{
        name: '组织',
        options: [{
          value: 'total',
          name: '全处室',
          id: 'total',
          disabled: false
        }, {
          value: 'techGroup',
          name: '技术标准组',
          id: 'techGroup',
          disabled: false
        }, {
          value: 'engiGroup',
          name: '工程组',
          id: 'engiGroup',
          disabled: false
        }, {
          value: 'comGroup',
          name: '通信组',
          id: 'comGroup',
          disabled: false
        }, {
          value: 'thirdPartyGP',
          name: '第三党小组',
          id: 'thirdPartyGP',
          disabled: false
        }, {
          value: 'fourthPartyGP',
          name: '第四党小组',
          id: 'fourthPartyGP',
          disabled: false
        }]
      }, {
        name: '个人',
        options: []
      }]
    }
  },
  components: {
  },
  created () {
  },
  methods: {
    // 初始化
    init (row) {
      this.tableData = []
      getWorkTimeAssign(row.id, 'applyer').then(response => {
        this.tableData = response[0]
        this.multiParticipant = response[0].length > 1
        for (let item of this.tableData) { // 插入审核状态
          item.reviewStatus = response[1][0].reviewStatus
        }
        let organizerIndex = this.tableData.findIndex(item => { return item.assignRole === '组织者' })
        let organizer = this.tableData.splice(organizerIndex, 1)
        this.tableData.unshift(organizer[0])
      })
      getUsersList().then(users => {
        this.usersList = users
        this.usersList.splice(this.usersList.findIndex(item => { return item.duty === 1 }), 1)
        this.userListOptions[1].options = JSON.parse(JSON.stringify(this.usersList))
      })
    },
    // 协助人员选择变化事件
    handlePartChange () {
      let findIndexTotal = this.participant.findIndex(item => { return item === 'total' })
      let findIndexTechGroup = this.participant.findIndex(item => { return item === 'techGroup' })
      let findIndexEngiGroup = this.participant.findIndex(item => { return item === 'engiGroup' })
      let findIndexComGroup = this.participant.findIndex(item => { return item === 'comGroup' })
      let findIndexThirdParty = this.participant.findIndex(item => { return item === 'thirdPartyGP' })
      let findIndexFourthParty = this.participant.findIndex(item => { return item === 'fourthPartyGP' })

      let insertID = []
      let insertOrganize = []
      let techGroupInsertID = this.usersList.filter(item => { return item.groupName === '技术标准组' })
      let engiGroupInsertID = this.usersList.filter(item => { return item.groupName === '工程组' })
      let comGroupInsertID = this.usersList.filter(item => { return item.groupName === '通信组' })
      let thirdPartyInsertID = this.usersList.filter(item => { return item.partyGroup === 3 })
      let fourthPartyInsertID = this.usersList.filter(item => { return item.partyGroup === 4 })

      if (findIndexTotal !== -1) { // 有选中全处室
        for (let i = 0; i < this.usersList.length; i++) {
          let findIndex = insertID.findIndex(item => { return item === this.usersList[i].id })
          if (findIndex === -1) {
            insertID.push(JSON.parse(JSON.stringify(this.usersList[i].id)))
          }
        }
        insertOrganize.push('total')
      }
      if (findIndexTechGroup !== -1) { // 有选中技术标准组
        for (let i = 0; i < techGroupInsertID.length; i++) {
          let findIndex = insertID.findIndex(item => { return item === techGroupInsertID[i].id })
          if (findIndex === -1) {
            insertID.push(techGroupInsertID[i].id)
          }
        }
        insertOrganize.push('techGroup')
      }
      if (findIndexEngiGroup !== -1) { // 有选中工程组
        for (let i = 0; i < engiGroupInsertID.length; i++) {
          let findIndex = insertID.findIndex(item => { return item === engiGroupInsertID[i].id })
          if (findIndex === -1) {
            insertID.push(engiGroupInsertID[i].id)
          }
        }
        insertOrganize.push('engiGroup')
      }
      if (findIndexComGroup !== -1) { // 有选中通信组
        for (let i = 0; i < comGroupInsertID.length; i++) {
          let findIndex = insertID.findIndex(item => { return item === comGroupInsertID[i].id })
          if (findIndex === -1) {
            insertID.push(comGroupInsertID[i].id)
          }
        }
        insertOrganize.push('comGroup')
      }
      if (findIndexThirdParty !== -1) { // 有选中第三党小组
        for (let i = 0; i < thirdPartyInsertID.length; i++) {
          let findIndex = insertID.findIndex(item => { return item === thirdPartyInsertID[i].id })
          if (findIndex === -1) {
            insertID.push(thirdPartyInsertID[i].id)
          }
        }
        insertOrganize.push('thirdPartyGP')
      }
      if (findIndexFourthParty !== -1) { // 有选中第四党小组
        for (let i = 0; i < fourthPartyInsertID.length; i++) {
          let findIndex = insertID.findIndex(item => { return item === fourthPartyInsertID[i].id })
          if (findIndex === -1) {
            insertID.push(fourthPartyInsertID[i].id)
          }
        }
        insertOrganize.push('fourthPartyGP')
      }

      if (insertOrganize.length < this.preSelectOrganize.length) {
        let difference = insertOrganize.filter(x => this.preSelectOrganize.indexOf(x) === -1)
        .concat(this.preSelectOrganize.filter(x => insertOrganize.indexOf(x) === -1))

        switch (difference[0]) {
          case 'total':
            for (let item of this.usersList) {
              let findDelIndex = this.participant.findIndex(item1 => { return item1 === item.id })
              this.participant.splice(findDelIndex, 1)
            }
            break
          case 'techGroup':
            for (let item of techGroupInsertID) {
              let findDelIndex = this.participant.findIndex(item1 => { return item1 === item.id })
              this.participant.splice(findDelIndex, 1)
            }
            break
          case 'engiGroup':
            for (let item of engiGroupInsertID) {
              let findDelIndex = this.participant.findIndex(item1 => { return item1 === item.id })
              this.participant.splice(findDelIndex, 1)
            }
            break
          case 'comGroup':
            for (let item of comGroupInsertID) {
              let findDelIndex = this.participant.findIndex(item1 => { return item1 === item.id })
              this.participant.splice(findDelIndex, 1)
            }
            break
          case 'thirdPartyGP':
            for (let item of thirdPartyInsertID) {
              let findDelIndex = this.participant.findIndex(item1 => { return item1 === item.id })
              this.participant.splice(findDelIndex, 1)
            }
            break
          case 'fourthPartyGP':
            for (let item of fourthPartyInsertID) {
              let findDelIndex = this.participant.findIndex(item1 => { return item1 === item.id })
              this.participant.splice(findDelIndex, 1)
            }
            break
        }
      }
      for (let i = 0; i < insertID.length; i++) {
        let findIndex = this.participant.findIndex(item => { return item === insertID[i] })
        if (findIndex === -1) {
          this.participant.push(insertID[i])
        }
      }
      this.preParticiant = JSON.parse(JSON.stringify(this.participant))
      this.preSelectOrganize = insertOrganize
    },
    // 选择框下拉事件
    handleSelectVisibleChange () {
    }
  },
  filters: {
    groupNameFilter (groupName) {
      switch (groupName) {
        case '技术标准组':
          return 'success'
        case '工程组':
          return 'warning'
        case '通信组':
          return 'primary'
        default:
          return 'danger'
      }
    },
    reviewStatusTextFilter (status) {
      switch (status.reviewStatus) {
        case 0:
          return '未审核'
        case 1:
          return status.reviewWorkTime
        case 2:
          return status.reviewWorkTime
        default:
          return '错误'
      }
    }
  }
}
</script>

<style lang="scss">
</style>

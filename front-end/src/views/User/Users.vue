<template>
  <div class="main-content" v-if="$store.state.userInfo.role !== '普通成员'">
    <div v-if="false" class="content-header">
      <el-button type="primary" size="medium">新增用户</el-button>
    </div>
    <el-table
      :data="tableData"
      stripe
      border
      style="width: 100%"
      header-row-class-name="table-header">
      <el-table-column prop="account" label="工号" align="center"></el-table-column>
      <el-table-column prop="dept" label="处室" align="center"></el-table-column>
      <el-table-column prop="groupName" label="小组" align="center"></el-table-column>
      <el-table-column prop="name" label="姓名" align="center"></el-table-column>
      <el-table-column prop="role" label="权限" align="center"></el-table-column>
      <el-table-column prop="status" label="状态" align="center"></el-table-column>
    </el-table>
  </div>
  <div v-else>
    <h2>暂无权限</h2>
  </div>
</template>

<script>
  import { usersList } from '@/config/interface'
  export default {
    name: 'Users.vue',
    data () {
      return {
        keywords: {
          name: null,
          role: null
        },
        reqFlag: { // 防止频繁点击，造成连续多次发请求
          search: true,
          state: true,
          delete: true
        },
        keywordsParams: {},
        tableData: [],
        pageNum: 1, // 请求第几页
        pageSize: this.$store.state.pageSize, // 每页请求多少条
        currentPage: 1 // 初始时在第几页
      }
    },
    computed: {
      userType: function () {
        let userType = this.$store.state.userInfo.role
        return userType
      },
      userPower: function () {
        let userType = this.$store.state.userInfo.role
        return !(userType == '普通成员')
      }
    },
    created () {
      this.keywordsParams = JSON.parse(JSON.stringify(this.keywords))
      this.queryUsersList()
    },
    methods: {
      queryUsersList () {
        const url = usersList
        if (this.reqFlag.search) {
          this.reqFlag.search = false
          let params = {
            searchName: this.keywordsParams.name,
            searchRole: this.keywordsParams.role,
            userType: this.userType,
            pageNum: this.pageNum,
            pageSize: this.pageSize
          }
          this.$http(url, params)
            .then(res => {
              if (res.code == 1) {
                let data = res.data
                this.tableData = data.list
                this.totalCount = data.totalCount
                this.currentPage = this.pageNum
              }
              this.reqFlag.search = true
            })
        }
      }
    }
  }
</script>

<style scoped>

</style>

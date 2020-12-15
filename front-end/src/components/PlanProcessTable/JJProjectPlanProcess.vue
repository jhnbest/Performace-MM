<template>
  <div>
    <el-dialog
      v-if="formData.showFlag"
      :title="formData.projectType + '项目本月计划&进度'"
      :visible.sync="formData.showFlag"
      width="1300px"
      @close="closeDialog">
      <div style="text-align: center;background-color: #39e7f3;margin-top: -25px">
        <h3>项目进度表</h3>
      </div>
      <el-table :data="formData.tableData" stripe border :header-cell-style="{background: 'E9EEF5', fontSize: '15px'}">
        <el-table-column label="项目阶段" align="center" prop="projectStage"></el-table-column>
        <el-table-column label="标准工时" align="center" prop="baseWorkTime" width="60%"></el-table-column>
        <el-table-column label="K值" align="center" prop="kValue" width="50%"></el-table-column>
        <el-table-column label="系数" align="center" prop="coefficient" width="60%"></el-table-column>
        <el-table-column label="可分配工时" align="center" prop="realSchedule" width="80%"></el-table-column>
        <el-table-column label="类型" align="center" prop="type" width="80%"></el-table-column>
        <el-table-column :label="'项目进度(' + formData.yearNum + ')'" align="center">
          <el-table-column align="center" width="40%">
            <template slot="header">
              <span class="link-type">&lt;&lt;</span>
            </template>
          </el-table-column>
          <el-table-column label="1月" align="center" width="75%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.Januray" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.Januray}}</span>
              <span v-if="!scope.row.editable && scope.row.Januray !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="2月" align="center" prop="February" width="50%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.February" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.February}}</span>
              <span v-if="!scope.row.editable && scope.row.February !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="3月" align="center" prop="March" width="50%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.March" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.March}}</span>
              <span v-if="!scope.row.editable && scope.row.March !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="4月" align="center" prop="April" width="50%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.April" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.April}}</span>
              <span v-if="!scope.row.editable && scope.row.April !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="5月" align="center" prop="May" width="50%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.May" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.May}}</span>
              <span v-if="!scope.row.editable && scope.row.May !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="6月" align="center" prop="June" width="50%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.June" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.June}}</span>
              <span v-if="!scope.row.editable && scope.row.June !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="7月" align="center" prop="July" width="50%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.July" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.July}}</span>
              <span v-if="!scope.row.editable && scope.row.July !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="8月" align="center" prop="August" width="50%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.August" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.August}}</span>
              <span v-if="!scope.row.editable && scope.row.August !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="9月" align="center" prop="September" width="50%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.September" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.September}}</span>
              <span v-if="!scope.row.editable && scope.row.September !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="10月" align="center" prop="October" width="60%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.October" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.October}}</span>
              <span v-if="!scope.row.editable && scope.row.October !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="11月" align="center" prop="November" width="60%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.November" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.November}}</span>
              <span v-if="!scope.row.editable && scope.row.November !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column label="12月" align="center" prop="December" width="60%">
            <template slot-scope="scope">
              <el-input v-if="scope.row.editable" v-model="scope.row.December" @change="handleJanuaryChange(scope.row)" size="mini"></el-input>
              <span v-else>{{scope.row.December}}</span>
              <span v-if="!scope.row.editable && scope.row.December !== null">%</span>
            </template>
          </el-table-column>
          <el-table-column align="center" width="40%">
            <template slot="header">
              <span class="link-type">&gt;&gt;</span>
            </template>
          </el-table-column>
        </el-table-column>
        <el-table-column label="操作" align="center" width="150">
          <template slot-scope="scope">
            <el-button v-if="!scope.row.editable" size="mini" type="primary" @click="handleEdit(scope.row)">编辑</el-button>
            <div v-else>
              <el-button size="mini" type="warning" @click="handleSave(scope.row)">保存</el-button>
              <el-button size="mini" type="danger" @click="handleCancel(scope.row)">取消</el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </el-dialog>
  </div>
</template>

<script>
  import { getAssignProjectDetail } from '@/config/interface'
    export default {
      data () {
        return {
          formData: {
            title: this.$moment().format('YYYY-MM'),
            showFlag: false,
            tableData: [],
            projectType: '',
            destroy: true,
            yearNum: this.$moment().year(),
            pickerOptions: {
              disabledDate (time) {
                return time.getTime() > Date.now()
              }
            }
          },
          reqFlag: {
            getAssignProjectDetail: true
          }
        }
      },
      methods: {
        init (params) {
          console.log('===JJProjectPlanProcess.vue')
          console.log('init')
          this.formData.projectType = params.projectType
          this.getAssignProjectDetail(params.projectID)
          this.$nextTick(() => {
            this.changeShowFlag()
          })
        },
        getAssignProjectDetail (id) {
          if (this.reqFlag.getAssignProjectDetail) {
            this.reqFlag.getAssignProjectDetail = false
            const url = getAssignProjectDetail
            let params = {
              id: id,
              year: this.formData.yearNum
            }
            this.$http(url, params)
              .then(res => {
                if (res.code === 1) {
                  console.log(res.data)
                  for (let item of res.data) {
                    item.editable = false
                  }
                  this.formData.tableData = res.data
                }
                this.reqFlag.getAssignProjectDetail = true
              })
          }
        },
        changeShowFlag () {
          this.formData.showFlag = !this.formData.showFlag
        },
        handleEdit (row) {
          row.editable = true
        },
        handleSave (row) {
          row.editable = false
        },
        handleCancel (row) {
          row.editable = false
        },
        closeDialog () {
        }
      },
      created () {
        console.log('created')
      },
      destroyed () {
        console.log('destroy')
      },
      name: 'JJProjectPlanProcess'
    }
</script>

<style scoped>

</style>

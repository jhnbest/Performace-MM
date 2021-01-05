<template>
  <el-form ref="formData" :model="formData" :rules="formRules">
    <el-table
      v-loading="!reqFlag.getProjectList"
      :data="formData.workDetailTable"
      stripe
      :span-method="objectSpanMethod"
      style="width: 100%;margin: auto" border>
      <el-table-column v-if="info.reviewType === 'reviewed'" type="expand" >
        <template slot-scope="scope">
          <el-form label-position="left" inline class="demo-table-expand">
            <el-form-item label="提交时间">
              <span>{{ scope.row.submitTime }}</span>
            </el-form-item>
            <el-form-item label="审核时间">
              <span>{{ scope.row.reviewTime }}</span>
            </el-form-item>
            <el-form-item label="审核备注">
              <span v-if="scope.row.reviewComments !== ''">{{ scope.row.reviewComments }}</span>
              <span v-else>无</span>
            </el-form-item>
          </el-form>
        </template>
      </el-table-column>
      <el-table-column label="序号" type="index" align="center" width="50%"></el-table-column>
      <el-table-column label="项目类型" align="center" width="130%">
        <template slot-scope="scope">
          <el-tag :type="scope.row.parentTypeID | parentTypeIDColorFilter">
            {{scope.row.parentTypeID | parentTypeIDStringFilter}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="项目名称" align="center" prop="projectName"></el-table-column>
      <el-table-column label="项目阶段" align="center" prop="projectStageName"></el-table-column>
      <el-table-column label="基本工时" align="center" prop="applyBaseWorkTime" width="80%"></el-table-column>
      <el-table-column label="申报K值" align="center" prop="applyKValue" width="80%"></el-table-column>
      <el-table-column label="审核K值" align="center" width="100%">
        <template slot-scope="scope">
          <el-form-item
            :prop="'workDetailTable.' + scope.$index + '.reviewKValue'"
            :rules="formRules.reviewKValue"
            style="margin: auto">
            <el-input :disabled="!(scope.row.reviewStatus === 0)"
                      size="medium"
                      v-model="scope.row.reviewKValue" @change="handleReviewKValueChange(scope.row)"></el-input>
          </el-form-item>
        </template>
      </el-table-column>
      <el-table-column label="完成次数" align="center" prop="applyCofficient" width="80%"></el-table-column>
      <el-table-column label="申报进展" align="center" width="80%">
        <template slot-scope="scope">
          <span>{{scope.row.applyProcess + '%'}}</span>
        </template>
      </el-table-column>
      <el-table-column label="工时分配" align="center" width="100%">
        <template slot-scope="scope">
            <span v-if="info.reviewType === 'reviewed'"
                  class="link-type"
                  @click="handleCoopInfo(scope.row, scope.$index)">点击查看</span>
          <span v-else-if="!scope.row.workTimeAssignReviewStatus"
                class="link-type"
                @click="handleCoopInfo(scope.row, scope.$index)">点击查看</span>
          <span v-else-if="scope.row.workTimeAssignReviewStatus"
                class="link-type"
                @click="handleCoopInfo(scope.row, scope.$index)">已审核</span>
        </template>
      </el-table-column>
      <el-table-column label="申报备注" align="center" width="100%">
        <template slot-scope="scope">
          <el-popover v-if="!(scope.row.submitComments === '')" placement="bottom" trigger="hover" width="200">
            <span>{{scope.row.submitComments}}</span>
            <span slot="reference" class="link-type">查看</span>
          </el-popover>
          <span v-else>无</span>
        </template>
      </el-table-column>
      <el-table-column label="提交时间" align="center" prop="updateTime" width="100%"></el-table-column>
      <el-table-column  v-if="info.reviewType !== 'reviewed'" label="审核备注" align="center">
        <template slot-scope="scope">
          <el-input size="mini" autosize type="textarea" v-model="scope.row.reviewComments"></el-input>
        </template>
      </el-table-column>
      <el-table-column v-if="info.reviewType === 'reviewed'"
                       label="审核时间"
                       align="center"
                       prop="reviewTime"
                       width="100%"></el-table-column>
      <el-table-column v-if="info.reviewType === 'reviewed'"
                       label="审核人"
                       align="center"
                       prop="reviewerName"
                       width="100%"></el-table-column>
      <el-table-column v-if="info.reviewType === 'reviewed'" label="审核状态" align="center">
        <template slot-scope="scope">
          <el-tag :type="scope.row.reviewStatus | reviewStatusFilter">
            {{ scope.row.reviewStatus | reviewStatusTextFilter}}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="200%">
        <template slot-scope="scope">
          <el-popconfirm
            confirm-button-text="确定"
            cancel-button-text="取消"
            icon="el-icon-info"
            icon-color="green" title="确认通过？"
            @confirm="handleReviewPass(scope.row, scope.$index)">
            <el-button
              slot="reference"
              v-if="(scope.row.reviewStatus === 0) & !(info.reviewType === 'reviewed')"
              size="small"
              type="primary" icon="el-icon-check">通过</el-button>
          </el-popconfirm>
          <el-popconfirm
            confirm-button-text="确定"
            cancel-button-text="取消"
            icon="el-icon-error"
            icon-color="red" title="确认驳回？" @confirm="handleReviewReject(scope.row)">
            <el-button
              style="margin-left: 10px"
              slot="reference"
              v-if="!(info.reviewType === 'reviewed')"
              :disabled="!(scope.row.reviewStatus === 0)"
              size="small"
              type="danger" icon="el-icon-close">驳回</el-button>
          </el-popconfirm>
          <el-popconfirm
            confirm-button-text="确定"
            cancel-button-text="取消"
            icon="el-icon-info"
            icon-color="gray" title="确认撤回？" @confirm="handleWithdrawReject(scope.row)">
            <el-button
              style="margin-left: 10px"
              slot="reference"
              v-if="info.reviewType === 'reviewed'"
              size="small"
              type="info" icon="el-icon-info">撤回</el-button>
          </el-popconfirm>
        </template>
      </el-table-column>
    </el-table>
  </el-form>
  <CopReview v-if="showFlag.CopReview" ref="copReview" @workTimeAssignReview="handleWorkTimeAssignReview"></CopReview>
</template>

<script>
    export default {
        name: 'PersionPlan.vue'
    }
</script>

<style scoped>

</style>

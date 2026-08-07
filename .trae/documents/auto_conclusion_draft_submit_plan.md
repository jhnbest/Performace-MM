# 月总结自动提交任务 - 暂存状态自动提交功能开发计划

## Summary
当前 `autoConclusionJob.js` 定时任务只处理"完全未提交"的情况（缺失的维度），但**没有处理"已暂存但未提交"的情况**（`submitStatus=2`）。本计划为该任务新增"暂存状态自动提交"逻辑：在 `executeAutoConclusionJob` 主循环中，新增一个前置步骤，扫描目标月份所有 `submitStatus=2` 的 `newconclusion` 记录，将状态更新为 `1`（已提交）；若 `content` 为空或空白字符，则填充默认内容 `'超时未提交，系统自动生成空白月总结'`，否则保留原内容。

## Current State Analysis

### 相关文件
- 后端控制器：[autoConclusionJob.js](file:///d:/vscode_project/Performace-MM/back-end/controls/autoConclusionJob.js)
- SQL配置：[sqlMap.js](file:///d:/vscode_project/Performace-MM/back-end/sql/sqlMap.js)
- 数据库结构：[数据库结构.sql](file:///d:/vscode_project/Performace-MM/back-end/数据库结构.sql)（`newconclusion` 表：L321-L336）
- 前端状态映射（仅供理解状态值）：[monthConclusion.vue](file:///d:/vscode_project/Performace-MM/front-end/src/views/monthConclusion/monthConclusion.vue#L397-L415)

### `submitStatus` 状态值约定
- `0` = 未提交
- `1` = 已提交
- `2` = 暂存

### 当前 `executeAutoConclusionJob` 逻辑
1. 取上个月作为目标月份
2. 遍历所有在职员工，处经理（`duty=1`）跳过
3. 查询已提交维度：`SELECT dimension FROM newconclusion WHERE userID=? AND conclusionYear=? AND conclusionMonth=? AND submitStatus=1`（[autoConclusionJob.js:65-70](file:///d:/vscode_project/Performace-MM/back-end/controls/autoConclusionJob.js#L65-L70)）
4. 计算缺失维度，调用 `generateBlankConclusions` 插入新记录（`submitStatus=1`，`content=默认文本`）（[autoConclusionJob.js:108-139](file:///d:/vscode_project/Performace-MM/back-end/controls/autoConclusionJob.js#L108-L139)）

### 缺陷
- 不处理 `submitStatus=2`（暂存）记录 → 暂存记录会一直保持"暂存"状态，与"已提交"在业务上不等价

## Proposed Changes

### 变更 1：SQL 配置新增（[sqlMap.js](file:///d:/vscode_project/Performace-MM/back-end/sql/sqlMap.js)）
在 `conclusion` 段（约 L354-L377）末尾新增两条 SQL：

```javascript
// 将某员工目标月份的所有暂存记录批量提交，content 为空时填充默认文本
submitDraftConclusions: `UPDATE newconclusion
    SET content = CASE WHEN content IS NULL OR TRIM(content) = '' THEN ? ELSE content END,
        submitStatus = 1,
        updateTime = ?
    WHERE userID = ? AND conclusionYear = ? AND conclusionMonth = ? AND submitStatus = 2`,
// 查询某员工目标月份的暂存记录 ID 与 content（用于日志统计）
getDraftConclusionIds: `SELECT id, content FROM newconclusion
    WHERE userID = ? AND conclusionYear = ? AND conclusionMonth = ? AND submitStatus = 2`
```

### 变更 2：`autoConclusionJob.js` 新增函数
在 `generateBlankConclusions` 函数（L108-L139）之后新增：

```javascript
/**
 * 将某员工目标月份的暂存月总结批量转为已提交
 * - content 为空 / 仅空白字符时，填充为默认提示文本
 * - content 有值时，保留原内容
 * - submitStatus 由 2 改为 1
 * @param {Object} user 用户对象
 * @param {number} year 目标年份
 * @param {number} month 目标月份
 * @returns {Promise<Array<number>>} 被更新的记录 ID 列表
 */
async function submitDraftConclusions(user, year, month) {
    const DEFAULT_CONTENT = '超时未提交，系统自动生成空白月总结'
    const updatedIds = []

    // 先查询暂存记录（仅用于日志统计与错误排查）
    const drafts = await RCPDDatabase($sql.conclusion.getDraftConclusionIds, [user.id, year, month])
    if (!drafts || drafts.length === 0) {
        return updatedIds
    }

    const now = $time.formatTime()
    await RCPDDatabase(
        $sql.conclusion.submitDraftConclusions,
        [DEFAULT_CONTENT, now, user.id, year, month]
    )

    drafts.forEach(row => updatedIds.push(row.id))
    console.log(`用户${user.name}(ID:${user.id})已将 ${updatedIds.length} 条暂存月总结转为已提交`)
    return updatedIds
}
```

### 变更 3：主流程 `executeAutoConclusionJob` 修改
在 `for (let user of users)` 循环中，处经理跳过逻辑之后、`getUserSubmittedDimensions` 之前（L286 之前），插入暂存处理步骤：

```javascript
// 1) 先把"暂存"状态的记录全部转为"已提交"
let draftSubmittedIds = await submitDraftConclusions(user, targetYear, targetMonth)
if (draftSubmittedIds.length > 0) {
    draftSubmittedCount += draftSubmittedIds.length
}

// 2) 再获取已提交维度（此时已包含刚转正的暂存记录）
let submittedDimensions = await getUserSubmittedDimensions(user.id, targetYear, targetMonth)
```

并在函数顶部（L257 附近）新增计数器：
```javascript
let successCount = 0
let failedCount = 0
let draftSubmittedCount = 0   // 新增：累计自动提交的暂存记录条数
```

任务结束汇总日志（L411-L414）与返回值（L417-L426）补充 `draftSubmittedCount` 字段：

```javascript
console.log(`已自动提交暂存记录: ${draftSubmittedCount} 条`)
// ...
return {
    success: true,
    logId: logId,
    summary: {
        total_users: users.length,
        success_count: successCount,
        failed_count: failedCount,
        skipped_count: users.length - successCount - failedCount,
        draft_submitted_count: draftSubmittedCount   // 新增
    }
}
```

## Assumptions & Decisions
1. **执行顺序**：暂存处理在查询已提交维度之前。这样后续"已提交维度"查询会自动包含刚转正的暂存记录，**避免重复生成空白记录**。
2. **默认值与现有逻辑保持一致**：使用 `'超时未提交，系统自动生成空白月总结'`，与 `generateBlankConclusions` L122 完全相同。
3. **content 判空策略**：用 SQL `CASE WHEN content IS NULL OR TRIM(content) = ''` 同时覆盖 NULL 与空白字符。
4. **不修改数据库表结构**：不在 `auto_conclusion_detail` 表新增字段；暂存提交数量仅通过 console 日志与返回值 `summary.draft_submitted_count` 暴露，最小化侵入。
5. **保留现有逻辑**：原有的"缺失维度生成空白记录"功能保留不变；新功能是**前置步骤**。
6. **目标月份口径不变**：仅处理上个月（与现有逻辑一致）。
7. **跳过规则不变**：处经理（`duty=1`）仍跳过暂存处理。
8. **不修改 cron 表达式 / 任务调度**：仅修改任务执行函数本身。

## Verification Steps
1. 准备测试数据（直接在 `newconclusion` 表中构造）：
   - 用户 A：2026-07 月份，dimension=1，`submitStatus=2`，`content=''`
   - 用户 A：2026-07 月份，dimension=2，`submitStatus=2`，`content='<p>用户已编辑的内容</p>'`
   - 用户 B：2026-07 月份，dimension=1，`submitStatus=2`，`content=NULL`
   - 用户 C：2026-07 月份，dimension=1，`submitStatus=0`（无任何记录）
2. 通过 API 手动触发任务（`POST /cronJob/executeAutoConclusion` 或类似接口，调用 `executeAutoConclusionJobManual`）
3. 检查数据库结果：
   - 用户 A 的两条暂存记录 `submitStatus` 均为 `1`
   - 第一条 `content` 变为 `'超时未提交，系统自动生成空白月总结'`
   - 第二条 `content` 保持为 `'<p>用户已编辑的内容</p>'`
   - 用户 B 的 `content` 由 `NULL` 变为默认文本
   - 用户 C 不受影响（无暂存记录）
4. 检查 console 输出与返回值 `summary`：
   - 出现 `已自动提交暂存记录: 3 条`
   - `summary.draft_submitted_count === 3`
5. 回归验证：
   - 缺失维度补全功能仍正常（用户 C 维度未提交时仍会生成空白记录）
   - 处经理（`duty=1`）仍被跳过
6. 异常场景：若 `submitDraftConclusions` SQL 报错，应被外层 `try/catch` 捕获，记录到 `auto_conclusion_detail` 的失败详情中，不影响其他用户。

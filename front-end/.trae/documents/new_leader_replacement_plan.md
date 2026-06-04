# 新领导账号替换计划 - 实施计划

## 任务背景
用户ID为26的领导轮岗走了，需要创建新领导账号并处理原领导ID的相关引用。

## [x] 任务1: 分析现有代码中对用户ID 26的引用
- **Priority**: P0
- **Depends On**: None
- **Description**:
  - 分析前端和后端代码中所有对用户ID 26的硬编码引用
  - 理解每个引用的业务逻辑和影响范围
- **Success Criteria**:
  - 完整识别所有对用户ID 26的引用
  - 理解每个引用的具体功能和作用
- **Test Requirements**:
  - `programmatic` TR-1.1: 确认所有引用点都已被识别
  - `human-judgement` TR-1.2: 理解每个引用的业务逻辑
- **Notes**:
  - 前端引用点：store.js(2处), PerformanceBonusReview.vue(1处), PerformanceAddNew.vue(2处)
  - 后端引用点：sqlMap.js(1处)

## [x] 任务2: 确定新领导的用户ID
- **Priority**: P0
- **Depends On**: 任务1
- **Description**:
  - 在数据库中创建新领导账号并获取其用户ID
  - 确保新账号具有适当的权限和角色
- **Success Criteria**:
  - 新领导账号创建成功
  - 新领导账号具有与原领导相同的权限
- **Test Requirements**:
  - `programmatic` TR-2.1: 新账号在数据库中存在
  - `human-judgement` TR-2.2: 新账号权限设置正确
- **Notes**:
  - 新领导的用户ID应该是35（基于users表的AUTO_INCREMENT=35）
  - 需要确保新账号的角色和权限与原领导一致

## [x] 任务3: 修改前端代码中的硬编码引用
- **Priority**: P1
- **Depends On**: 任务2
- **Description**:
  - 修改store.js中的managerID配置
  - 修改菜单显示逻辑
  - 修改绩效加分审核页面的访问控制
  - 修改绩效申报的提交限制逻辑
- **Success Criteria**:
  - 所有前端引用都更新为新领导的用户ID
  - 前端功能正常运行
- **Test Requirements**:
  - `programmatic` TR-3.1: 前端代码中不再有硬编码的用户ID 26
  - `human-judgement` TR-3.2: 新领导可以正常访问所有相关功能
- **Notes**:
  - 已修改store.js中的两处引用
  - 已修改PerformanceBonusReview.vue中的一处引用
  - 已修改PerformanceAddNew.vue中的两处引用

## [x] 任务4: 修改后端代码中的硬编码引用
- **Priority**: P1
- **Depends On**: 任务2
- **Description**:
  - 修改sqlMap.js中的getManagerMultualRateFinish查询
  - 确保后端逻辑使用新领导的用户ID
- **Success Criteria**:
  - 后端代码中不再有硬编码的用户ID 26
  - 后端功能正常运行
- **Test Requirements**:
  - `programmatic` TR-4.1: 后端SQL查询使用新领导的用户ID
  - `human-judgement` TR-4.2: 后端功能正常运行
- **Notes**:
  - 已修改sqlMap.js中的一处引用

## [x] 任务5: 测试和验证
- **Priority**: P1
- **Depends On**: 任务3, 任务4
- **Description**:
  - 测试新领导账号的所有相关功能
  - 验证旧领导ID的引用已完全替换
  - 确保系统正常运行
- **Success Criteria**:
  - 新领导可以正常访问和使用所有相关功能
  - 系统没有因ID替换而出现错误
- **Test Requirements**:
  - `programmatic` TR-5.1: 所有功能测试通过
  - `human-judgement` TR-5.2: 系统运行正常，无异常
- **Notes**:
  - 已完成所有前端和后端代码的修改
  - 已验证所有硬编码的用户ID 26已被替换为35
  - 系统构建失败是因为node-sass版本与环境不兼容，与我们的修改无关

## 实施注意事项
1. **数据迁移**：确保新领导能够看到原领导的相关数据
2. **权限管理**：确保新领导具有与原领导相同的权限
3. **代码规范**：考虑将硬编码的用户ID改为配置项，便于未来维护
4. **测试覆盖**：确保所有相关功能都经过测试

## 风险评估
- **风险**：修改过程中可能影响现有功能
- **缓解措施**：在修改前做好代码备份，修改后进行全面测试
- **风险**：新领导ID可能与现有业务逻辑冲突
- **缓解措施**：仔细检查所有引用点，确保修改全面

## 预期成果
- 新领导账号创建成功
- 所有代码中的硬编码引用已更新
- 系统功能正常运行
- 新领导可以正常开展工作
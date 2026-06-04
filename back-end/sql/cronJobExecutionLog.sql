-- =====================================================
-- 定时任务执行日志表
-- 用于记录所有定时任务的执行情况
-- =====================================================

-- 1. 定时任务执行日志主表
DROP TABLE IF EXISTS `cron_job_execution_log`;
CREATE TABLE `cron_job_execution_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `job_type` varchar(50) NOT NULL COMMENT '任务类型: mutualRateFillCron, autoConclusionCron, amevaDeadlineCron, mutualEvaSubmitCron, workTimeSubmitCron, resetAssignProjectCron',
  `job_name` varchar(100) NOT NULL COMMENT '任务名称',
  `execution_time` datetime NOT NULL COMMENT '执行时间',
  `execution_status` tinyint NOT NULL DEFAULT '0' COMMENT '执行状态: 0-执行中, 1-成功, 2-失败',
  `execution_duration` int unsigned DEFAULT NULL COMMENT '执行耗时(毫秒)',
  `execution_result` LONGTEXT COMMENT '执行结果(JSON格式)',
  `error_message` text COMMENT '错误信息',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_job_type` (`job_type`),
  KEY `idx_execution_time` (`execution_time`),
  KEY `idx_execution_status` (`execution_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务执行日志表';

-- 2. 任务类型配置表
DROP TABLE IF EXISTS `cron_job_config`;
CREATE TABLE `cron_job_config` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `job_type` varchar(50) NOT NULL COMMENT '任务类型',
  `job_name` varchar(100) NOT NULL COMMENT '任务名称',
  `cron_expr` varchar(50) NOT NULL COMMENT 'Cron表达式',
  `job_description` varchar(500) DEFAULT '' COMMENT '任务描述',
  `is_enabled` tinyint NOT NULL DEFAULT '1' COMMENT '是否启用: 0-禁用, 1-启用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_job_type` (`job_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务配置表';

-- 3. 初始化任务类型配置数据
INSERT INTO `cron_job_config` (`job_type`, `job_name`, `cron_expr`, `job_description`, `is_enabled`, `created_at`, `updated_at`) VALUES
('mutualRateFillCron', '互评填充任务', '0 0 2 3 * *', '每月自动填充互评数据', 1, NOW(), NOW()),
('autoConclusionCron', '月总结自动提交任务', '0 0 3 5 * *', '每月自动为未提交月总结的员工生成空白总结', 1, NOW(), NOW()),
('amevaDeadlineCron', 'AMEva截止任务', '0 0 0 1 * *', '每月自动设置AMEva截止标志', 1, NOW(), NOW()),
('mutualEvaSubmitCron', '互评提交任务', '0 0 0 1 * *', '每月自动设置互评提交标志', 1, NOW(), NOW()),
('workTimeSubmitCron', '工时提交任务', '0 0 0 1 * *', '每月自动设置工时提交标志', 1, NOW(), NOW()),
('resetAssignProjectCron', '重置分配项目任务', '0 0 0 1 * *', '每月自动重置分配项目的是否填充状态', 1, NOW(), NOW());

-- 4. 互评填充任务执行详情表（可选，用于记录每个用户的填充情况）
DROP TABLE IF EXISTS `mutual_rate_fill_detail`;
CREATE TABLE `mutual_rate_fill_detail` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `log_id` int unsigned NOT NULL COMMENT '外键-执行日志ID',
  `user_id` smallint unsigned NOT NULL COMMENT '用户ID',
  `user_name` varchar(100) NOT NULL COMMENT '用户姓名',
  `rate_month` varchar(7) NOT NULL COMMENT '评优月份(YYYY-MM)',
  `fill_count` int unsigned NOT NULL DEFAULT '0' COMMENT '填充记录数',
  `processing_status` tinyint NOT NULL DEFAULT '0' COMMENT '处理状态: 0-待处理, 1-成功, 2-失败',
  `error_message` text COMMENT '错误信息',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_log_id` (`log_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_rate_month` (`rate_month`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='互评填充任务执行详情表';

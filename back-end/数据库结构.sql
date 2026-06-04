-- MySQL dump 10.13  Distrib 8.0.20, for Win64 (x86_64)
--
-- Host: localhost    Database: worktimemm
-- ------------------------------------------------------
-- Server version	8.0.20

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assignprojectdetail`
--

DROP TABLE IF EXISTS `assignprojectdetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignprojectdetail` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aPLID` int unsigned NOT NULL COMMENT '项目列表外键',
  `projectStage` int unsigned NOT NULL DEFAULT '0' COMMENT '项目阶段',
  `projectStageName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '非标项目阶段名称',
  `baseWorkTime` float(5,1) NOT NULL COMMENT '标准工时',
  `kValue` float(5,1) NOT NULL DEFAULT '1.0' COMMENT 'K值',
  `coefficient` smallint NOT NULL DEFAULT '1' COMMENT '系数',
  `avaiableWorkTime` float(5,1) NOT NULL DEFAULT '0.0' COMMENT '可用工时',
  `process` float(4,1) unsigned NOT NULL DEFAULT '0.0' COMMENT '进展',
  `obsoleteStatus` tinyint NOT NULL DEFAULT '0' COMMENT '废弃状态',
  `isFinish` tinyint NOT NULL DEFAULT '0' COMMENT '是否已完成',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31694 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assignprojectlist`
--

DROP TABLE IF EXISTS `assignprojectlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assignprojectlist` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `userID` int unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `assignDate` datetime NOT NULL COMMENT '分配时间',
  `projectType` int DEFAULT NULL COMMENT '项目类型',
  `projectName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '项目名称',
  `process` float(4,1) unsigned NOT NULL DEFAULT '0.0' COMMENT '完成度',
  `assignerID` int unsigned NOT NULL DEFAULT '0' COMMENT '分配人',
  `totalWorkTime` float(10,1) NOT NULL DEFAULT '0.0' COMMENT '总工时数',
  `gettedWorkTime` float(10,1) NOT NULL DEFAULT '0.0' COMMENT '已获得工时数',
  `isFilled` tinyint NOT NULL DEFAULT '0' COMMENT '当月是否已填报',
  `projectLevel` tinyint NOT NULL DEFAULT '1' COMMENT '项目级别',
  `reviewStatus` tinyint NOT NULL DEFAULT '1' COMMENT '审核状态',
  `obsoleteStatus` tinyint NOT NULL DEFAULT '0' COMMENT '是否废弃',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=22213 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auto_conclusion_detail`
--

DROP TABLE IF EXISTS `auto_conclusion_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auto_conclusion_detail` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `log_id` int unsigned NOT NULL COMMENT '外键-执行日志ID',
  `user_id` smallint unsigned NOT NULL COMMENT '用户ID',
  `user_name` varchar(100) NOT NULL COMMENT '用户姓名',
  `user_duty` tinyint NOT NULL COMMENT '用户职务级别',
  `conclusion_month` tinyint NOT NULL COMMENT '总结月份',
  `conclusion_year` year NOT NULL COMMENT '总结年份',
  `dimensions_required` tinyint NOT NULL COMMENT '所需维度数量(4或5)',
  `dimensions_generated` tinyint NOT NULL DEFAULT '0' COMMENT '生成维度数量',
  `processing_status` tinyint NOT NULL DEFAULT '0' COMMENT '处理状态: 0-待处理, 1-成功, 2-失败',
  `error_message` text COMMENT '错误信息',
  `conclusion_ids` text COMMENT '生成的总结ID列表(JSON数组)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_log_id` (`log_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_processing_status` (`processing_status`)
) ENGINE=InnoDB AUTO_INCREMENT=185 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='月总结自动提交处理详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auto_conclusion_log`
--

DROP TABLE IF EXISTS `auto_conclusion_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auto_conclusion_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `execution_time` datetime NOT NULL COMMENT '执行时间',
  `target_month` tinyint NOT NULL COMMENT '目标月份',
  `target_year` year NOT NULL COMMENT '目标年份',
  `total_users` int unsigned NOT NULL DEFAULT '0' COMMENT '应处理用户总数',
  `processed_users` int unsigned NOT NULL DEFAULT '0' COMMENT '已处理用户数',
  `success_count` int unsigned NOT NULL DEFAULT '0' COMMENT '成功处理数',
  `failed_count` int unsigned NOT NULL DEFAULT '0' COMMENT '失败处理数',
  `execution_status` tinyint NOT NULL DEFAULT '0' COMMENT '执行状态: 0-执行中, 1-成功, 2-部分失败, 3-全部失败',
  `error_message` text COMMENT '错误信息',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_execution_time` (`execution_time`),
  KEY `idx_target_month` (`target_year`,`target_month`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='月总结自动提交执行日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `conclusion`
--

DROP TABLE IF EXISTS `conclusion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `conclusion` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `conclusionType` tinyint unsigned NOT NULL COMMENT '总结类型',
  `submitter` int unsigned NOT NULL COMMENT '提交者',
  `conclusionTitle` varchar(50) NOT NULL COMMENT '标题',
  `submitTime` datetime NOT NULL COMMENT '提交时间',
  `updateTime` datetime DEFAULT NULL COMMENT '更新时间',
  `submitYear` year NOT NULL COMMENT '提交年份',
  `submitMonth` tinyint unsigned NOT NULL COMMENT '提交月份',
  `submitStatus` tinyint unsigned NOT NULL COMMENT '提交状态',
  `managerRateStar` tinyint unsigned DEFAULT NULL COMMENT '管理者评价星级',
  `getWorkTime` tinyint unsigned DEFAULT NULL COMMENT '获得工时',
  `curConclusion` text COMMENT '本月工作回顾',
  `nextPlan` text COMMENT '下月工作计划',
  `curAdvice` text COMMENT '建议',
  `managerEva` text COMMENT '管理者评价',
  `evaTime` datetime DEFAULT NULL COMMENT '管理者评价时间',
  `evaStatus` tinyint unsigned DEFAULT NULL COMMENT '评价状态',
  `workTimeListId` int unsigned DEFAULT NULL COMMENT '外键ID',
  `obsoleteStatus` tinyint unsigned NOT NULL DEFAULT '0' COMMENT '废弃状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cron_job_config`
--

DROP TABLE IF EXISTS `cron_job_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cron_job_execution_log`
--

DROP TABLE IF EXISTS `cron_job_execution_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cron_job_execution_log` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `job_type` varchar(50) NOT NULL COMMENT '任务类型: mutualRateFillCron, autoConclusionCron, amevaDeadlineCron, mutualEvaSubmitCron, workTimeSubmitCron, resetAssignProjectCron',
  `job_name` varchar(100) NOT NULL COMMENT '任务名称',
  `execution_time` datetime NOT NULL COMMENT '执行时间',
  `execution_status` tinyint NOT NULL DEFAULT '0' COMMENT '执行状态: 0-执行中, 1-成功, 2-失败',
  `execution_duration` int unsigned DEFAULT NULL COMMENT '执行耗时(毫秒)',
  `execution_result` longtext COMMENT '执行结果(JSON格式)',
  `error_message` text COMMENT '错误信息',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_job_type` (`job_type`),
  KEY `idx_execution_time` (`execution_time`),
  KEY `idx_execution_status` (`execution_status`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='定时任务执行日志表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `failedamevadata`
--

DROP TABLE IF EXISTS `failedamevadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `failedamevadata` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `evaUserID` smallint NOT NULL COMMENT '评价人ID',
  `evaUserName` varchar(50) NOT NULL COMMENT '评价人姓名',
  `evaedUserID` smallint NOT NULL COMMENT '被评价人ID',
  `evaedUserName` varchar(50) NOT NULL COMMENT '被评价人姓名',
  `dimensionID` int unsigned NOT NULL COMMENT '评价维度ID',
  `dimension` tinyint NOT NULL COMMENT '维度类型',
  `dimensionName` varchar(100) NOT NULL COMMENT '维度名称',
  `evaStar` tinyint unsigned NOT NULL COMMENT '评价星级',
  `conclusionYear` smallint NOT NULL COMMENT '成效评价年份',
  `conclusionMonth` tinyint NOT NULL COMMENT '成效评价月份',
  `errorCode` int NOT NULL COMMENT '错误码',
  `errorMessage` varchar(255) NOT NULL COMMENT '错误信息',
  `retryStatus` tinyint NOT NULL DEFAULT '0' COMMENT '重试状态（0=待重试，1=重试成功）',
  `retryTime` datetime DEFAULT NULL COMMENT '重试成功时间',
  `obsoleteStatus` tinyint NOT NULL DEFAULT '0' COMMENT '软删除状态（0=正常，1=已删除）',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_evaUserID_dimensionID` (`evaUserID`,`dimensionID`),
  KEY `idx_evaUserID` (`evaUserID`),
  KEY `idx_conclusionYearMonth` (`conclusionYear`,`conclusionMonth`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `globalflag`
--

DROP TABLE IF EXISTS `globalflag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `globalflag` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `setTime` datetime NOT NULL COMMENT '设置时间',
  `flagType` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标志类型',
  `flagValue` float NOT NULL COMMENT '标志值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=277 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `monthprocess`
--

DROP TABLE IF EXISTS `monthprocess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `monthprocess` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aPDID` int unsigned NOT NULL COMMENT '指派项目明细外键',
  `year` year NOT NULL COMMENT '年份',
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '进展类型',
  `January` float(6,1) unsigned DEFAULT NULL COMMENT '1月',
  `February` float(6,1) unsigned DEFAULT NULL COMMENT '2月',
  `March` float(6,1) unsigned DEFAULT NULL COMMENT '3月',
  `April` float(6,1) unsigned DEFAULT NULL COMMENT '4月',
  `May` float(6,1) unsigned DEFAULT NULL COMMENT '5月',
  `June` float(6,1) unsigned DEFAULT NULL COMMENT '6月',
  `July` float(6,1) unsigned DEFAULT NULL COMMENT '7月',
  `August` float(6,1) unsigned DEFAULT NULL COMMENT '8月',
  `September` float(6,1) unsigned DEFAULT NULL COMMENT '9月',
  `October` float(6,1) unsigned DEFAULT NULL COMMENT '10月',
  `November` float(6,1) unsigned DEFAULT NULL COMMENT '11月',
  `December` float(6,1) unsigned DEFAULT NULL COMMENT '12月',
  `PreMonth` float(6,1) unsigned NOT NULL DEFAULT '0.0' COMMENT '上一月份进展',
  `obsoleteStatus` tinyint NOT NULL DEFAULT '0' COMMENT '废弃状态 ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=30471 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mutual_rate_fill_detail`
--

DROP TABLE IF EXISTS `mutual_rate_fill_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mutualrate`
--

DROP TABLE IF EXISTS `mutualrate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mutualrate` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `ratePersion` int NOT NULL COMMENT '评分人',
  `ratedPersion` int NOT NULL COMMENT '被评分人',
  `rateMonth` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评分月份',
  `rate` float(4,1) NOT NULL COMMENT '得分',
  `rateType` tinyint NOT NULL COMMENT '评分类型',
  `rateTime` datetime NOT NULL COMMENT '初次评分时间',
  `updateTime` datetime NOT NULL COMMENT '评分更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=113953 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `newconclusion`
--

DROP TABLE IF EXISTS `newconclusion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `newconclusion` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `userID` smallint unsigned NOT NULL COMMENT '用户ID',
  `conclusionType` tinyint unsigned NOT NULL COMMENT '总结类型',
  `conclusionYear` year NOT NULL COMMENT '总结的年份',
  `conclusionMonth` tinyint NOT NULL COMMENT '总结的月份',
  `dimension` tinyint NOT NULL COMMENT '总结的维度',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '总结内容',
  `submitTime` datetime NOT NULL COMMENT '提交时间',
  `updateTime` datetime NOT NULL COMMENT '更新时间',
  `submitStatus` tinyint NOT NULL COMMENT '提交状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4657 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `newconclusionevadata`
--

DROP TABLE IF EXISTS `newconclusionevadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `newconclusionevadata` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `evaUserID` smallint NOT NULL COMMENT '评价人ID',
  `dimensionID` int unsigned NOT NULL COMMENT '评价的维度ID',
  `evaStar` tinyint unsigned NOT NULL COMMENT '评价星级',
  `submitTime` datetime NOT NULL COMMENT '提交时间',
  `updateTime` datetime NOT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=21976 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `performancedata`
--

DROP TABLE IF EXISTS `performancedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performancedata` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `userID` int unsigned DEFAULT NULL COMMENT '用户ID',
  `userJob` tinyint DEFAULT NULL COMMENT '用户职称岗位',
  `userDuty` tinyint DEFAULT NULL COMMENT '用户管理岗位',
  `applyDate` varchar(7) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申报月份',
  `totalWorkTime` float DEFAULT NULL COMMENT '总工时',
  `QYEvaScoreNor` float unsigned DEFAULT NULL COMMENT '定量评价得分（标准化）',
  `QYEvaRank` tinyint unsigned DEFAULT NULL COMMENT '定量评价排名',
  `CSQTEvaScoreUnN` float unsigned DEFAULT NULL COMMENT '员工定性评价得分（未标准化）',
  `CSQTEvaScoreNor` float unsigned DEFAULT NULL COMMENT '员工定性评价得分（标准化）',
  `CSQTEvaRank` tinyint unsigned DEFAULT NULL COMMENT '员工定性评价排名',
  `MGQTEvaScoreUnN` float unsigned DEFAULT NULL COMMENT '经理定性评价得分（未标准化）',
  `MGQTEvaScoreNor` float unsigned DEFAULT NULL COMMENT '经理定性评价得分（标准化）',
  `MGQTEvaRank` tinyint unsigned DEFAULT NULL COMMENT '经理定性评价排名',
  `AMEvaScoreUnN` float unsigned DEFAULT NULL COMMENT '成效评价得分（未标准化）',
  `AMEvaScoreNor` float unsigned DEFAULT NULL COMMENT '成效评价得分（标准化）',
  `AMEvaRank` tinyint unsigned DEFAULT NULL COMMENT '成效评价排名',
  `PMScoreUnN` float unsigned DEFAULT NULL COMMENT '绩效得分（未标准化）',
  `PMScoreNor` float unsigned DEFAULT NULL COMMENT '绩效得分（标准化）',
  `PMRank` tinyint unsigned DEFAULT NULL COMMENT '绩效排名',
  `dimension1CSAveStar` float DEFAULT NULL COMMENT '成效评价维度1员工平均评价星级',
  `dimension1GPEvaStar` float DEFAULT NULL COMMENT '成效评价维度1组长评价星级',
  `dimension2CSAveStar` float DEFAULT NULL COMMENT '成效评价维度2员工平均评价星级',
  `dimension2GPEvaStar` float DEFAULT NULL COMMENT '成效评价维度2组长评价星级',
  `teamWorkScore` tinyint unsigned DEFAULT NULL COMMENT '组长的小组工作评价得分',
  `PBScore` float DEFAULT '0' COMMENT '绩效加分',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1740 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `performancedata_copy1`
--

DROP TABLE IF EXISTS `performancedata_copy1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performancedata_copy1` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `applyDate` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '申报月份',
  `totalWorkTime` smallint DEFAULT NULL COMMENT '总工时',
  `QYEvaRank` tinyint unsigned DEFAULT NULL COMMENT '定量排名',
  `QYEvaScoreNor` tinyint unsigned DEFAULT NULL COMMENT '定量得分（标准化）',
  `CSQTEvaScoreUnN` tinyint unsigned DEFAULT NULL COMMENT '员工定性评价得分（未标准化）',
  `CSQTEvaScoreNor` tinyint unsigned DEFAULT NULL COMMENT '员工定性评价得分（标准化）',
  `CSQTEvaRank` tinyint unsigned DEFAULT NULL COMMENT '员工定性评价排名',
  `MGQTEvaScoreUnN` tinyint unsigned DEFAULT NULL COMMENT '经理定性评价得分（未标准化）',
  `MGQTEvaRank` tinyint unsigned DEFAULT NULL COMMENT '经理定性评价排名',
  `MGQTEvaScoreNor` tinyint unsigned DEFAULT NULL COMMENT '经理定性评价得分（标准化）',
  `AMEvaScoreUnN` tinyint unsigned DEFAULT NULL COMMENT '成效评价得分（未标准化）',
  `AMEvaScoreNor` tinyint unsigned DEFAULT NULL COMMENT '成效评价得分（标准化）',
  `AMEvaRank` tinyint unsigned DEFAULT NULL COMMENT '成效评价排名',
  `PMScoreUnN` tinyint unsigned DEFAULT NULL COMMENT '绩效得分（未标准化）',
  `PMScoreNor` tinyint unsigned DEFAULT NULL COMMENT '绩效得分（标准化）',
  `PMRank` tinyint unsigned DEFAULT NULL COMMENT '绩效排名',
  `remarks` varchar(255) DEFAULT NULL COMMENT '备注',
  `userID` int unsigned DEFAULT NULL COMMENT '用户ID',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `performancerate`
--

DROP TABLE IF EXISTS `performancerate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performancerate` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `ratePersion` int NOT NULL COMMENT '评分人',
  `ratedPersion` int NOT NULL COMMENT '被评分人',
  `rateMonth` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '评分月份',
  `rate` float(4,1) NOT NULL COMMENT '得分',
  `rateType` tinyint NOT NULL COMMENT '评分类型',
  `rateTime` datetime NOT NULL COMMENT '初次评分时间',
  `updateTime` datetime NOT NULL COMMENT '评分更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24493 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pmbassign`
--

DROP TABLE IF EXISTS `pmbassign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pmbassign` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `PBDataID` int unsigned NOT NULL,
  `userID` int unsigned NOT NULL,
  `role` tinyint NOT NULL,
  `assignScore` float NOT NULL,
  `obsoleteStatus` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=310 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pmbdata`
--

DROP TABLE IF EXISTS `pmbdata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pmbdata` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `PBName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `userID` int unsigned NOT NULL,
  `submitTime` datetime NOT NULL,
  `updateTime` datetime NOT NULL,
  `applyYear` year NOT NULL,
  `applyMonth` varchar(3) NOT NULL,
  `PBRuleID` int unsigned NOT NULL,
  `kValue` float NOT NULL DEFAULT '1' COMMENT 'K值，除了重点任务评级，其他默认为1，且不可调整',
  `submitStatus` tinyint NOT NULL,
  `reviewStatus` tinyint DEFAULT NULL,
  `PBComments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `obsoleteStatus` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pmbrules`
--

DROP TABLE IF EXISTS `pmbrules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pmbrules` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `parentID` int unsigned NOT NULL DEFAULT '0',
  `PBType` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `PBRule` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `PBScore` float DEFAULT NULL,
  `isContinusBonus` tinyint(1) DEFAULT '0',
  `continusMonths` tinyint unsigned DEFAULT '1',
  `PBComments` text,
  `obsoleteStatus` tinyint DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `projecttypenew`
--

DROP TABLE IF EXISTS `projecttypenew`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projecttypenew` (
  `projectTypeID` int NOT NULL AUTO_INCREMENT,
  `projectName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目名称',
  `projectParentID` int NOT NULL COMMENT '项目父ID',
  `projectLevel` int NOT NULL COMMENT '项目所属级别',
  `workTime` float(6,1) NOT NULL DEFAULT '0.0' COMMENT '工时数',
  `dynamicKValue` tinyint NOT NULL DEFAULT '0' COMMENT 'K值是否可变',
  `isConference` tinyint NOT NULL DEFAULT '0' COMMENT '是否为会议类型',
  `defaultAssignWorkTime` float(6,1) NOT NULL DEFAULT '0.0' COMMENT '默认协助工时',
  `obsoleteStatus` tinyint NOT NULL DEFAULT '0' COMMENT '是否废弃',
  PRIMARY KEY (`projectTypeID`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=594 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `test_table`
--

DROP TABLE IF EXISTS `test_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `test_table` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `account` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `job` tinyint NOT NULL,
  `dept` tinyint NOT NULL,
  `groupName` tinyint NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` tinyint NOT NULL,
  `password` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `partyMember` tinyint NOT NULL,
  `duty` tinyint NOT NULL,
  `updateTime` datetime DEFAULT NULL,
  `partyGroup` tinyint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `weekly`
--

DROP TABLE IF EXISTS `weekly`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weekly` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '周报id',
  `userId` int NOT NULL COMMENT '创建者id',
  `startTime` date NOT NULL COMMENT '这周开始时间',
  `endTime` date NOT NULL COMMENT '这周结束时间',
  `title` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '今年的第几周',
  `thisWeekWork` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '这周完成工作',
  `nextWeekWork` text CHARACTER SET utf8 COLLATE utf8_unicode_ci COMMENT '下周工作计划',
  `collaboration` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '需协调与帮助',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  `update_time` datetime NOT NULL COMMENT '更新时间',
  `state` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='周报表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worktimeassign`
--

DROP TABLE IF EXISTS `worktimeassign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `worktimeassign` (
  `id` int NOT NULL AUTO_INCREMENT,
  `userID` int unsigned NOT NULL COMMENT '参与人员外键',
  `projectID` int unsigned NOT NULL COMMENT '参与项目外键',
  `workTime` float(6,1) NOT NULL COMMENT '分配的工时数',
  `reviewWorkTime` float(6,1) DEFAULT NULL COMMENT '审核的工时数',
  `assignRole` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参与人员角色',
  `obsoleteStatus` tinyint NOT NULL DEFAULT '0' COMMENT '废弃状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=42933 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `worktimelist`
--

DROP TABLE IF EXISTS `worktimelist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `worktimelist` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `apdID` int NOT NULL DEFAULT '0' COMMENT '对应的项目明细ID',
  `aplID` int NOT NULL DEFAULT '0' COMMENT '对应的项目列表ID',
  `monthID` int DEFAULT NULL COMMENT '对应的月份进展ID',
  `submitID` int unsigned NOT NULL COMMENT '申报人ID',
  `projectTypeID` int unsigned NOT NULL COMMENT '项目类型ID',
  `applyKValue` double(5,1) NOT NULL COMMENT '申报K值',
  `reviewKValue` double(5,1) DEFAULT NULL COMMENT '审核K值',
  `applyCofficient` double(5,1) NOT NULL COMMENT '申报系数',
  `reviewCofficient` double(5,1) DEFAULT NULL COMMENT '审核系数',
  `submitTime` datetime NOT NULL COMMENT '提交时间',
  `updateTime` datetime NOT NULL COMMENT '更新时间',
  `applyMonth` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申报月份',
  `submitStatus` tinyint NOT NULL DEFAULT '0' COMMENT '提交状态',
  `submitComments` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '提交备注',
  `reviewStatus` tinyint NOT NULL DEFAULT '0' COMMENT '审核状态',
  `reviewTime` datetime DEFAULT NULL COMMENT '审核时间',
  `reviewComments` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '' COMMENT '审核备注',
  `workTimeAssignReviewStatus` tinyint NOT NULL DEFAULT '0' COMMENT '工时分配审核状态',
  `reviewer` int unsigned DEFAULT NULL COMMENT '审核人',
  `avaiableWorkTime` float(5,1) NOT NULL DEFAULT '0.0' COMMENT '可用工时',
  `applyProcess` float(4,1) unsigned NOT NULL DEFAULT '0.0' COMMENT '申报进展',
  `lastProcess` float(4,1) unsigned NOT NULL DEFAULT '0.0' COMMENT '上月进展',
  `applyType` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '申报类型',
  `applyBaseWorkTime` float(6,1) NOT NULL COMMENT '申报的基本工时（非标项目使用）',
  `obsoleteStatus` tinyint NOT NULL DEFAULT '0' COMMENT '废弃状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=32427 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'worktimemm'
--
/*!50003 DROP PROCEDURE IF EXISTS `test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `test`()
begin
	SELECT m.* FROM monthprocess m left join assignprojectdetail apd on m.aPDID = apd.id WHERE ISNULL(m.May) and apd.process != 100 and apd.process != 0 AND 
		m.`year` in (2023) and m.`type`= 'fact' and apd.obsoleteStatus != 1 ORDER BY m.aPDID;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-12 17:36:23

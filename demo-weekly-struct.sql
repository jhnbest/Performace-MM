/*
 Navicat Premium Data Transfer

 Source Server         : jhn_MySQL
 Source Server Type    : MySQL
 Source Server Version : 80020
 Source Host           : localhost:3306
 Source Schema         : demo-weekly

 Target Server Type    : MySQL
 Target Server Version : 80020
 File Encoding         : 65001

 Date: 25/12/2020 09:26:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for assignprojectdetail
-- ----------------------------
DROP TABLE IF EXISTS `assignprojectdetail`;
CREATE TABLE `assignprojectdetail`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aPLID` int UNSIGNED NOT NULL COMMENT '项目列表外键',
  `projectStage` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '项目阶段',
  `projectStageName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '非标项目阶段名称',
  `baseWorkTime` float(5, 1) NOT NULL COMMENT '标准工时',
  `kValue` float(5, 1) NOT NULL DEFAULT 1.0 COMMENT 'K值',
  `coefficient` smallint NOT NULL DEFAULT 1 COMMENT '系数',
  `avaiableWorkTime` float(5, 1) NOT NULL DEFAULT 0.0 COMMENT '可用工时',
  `process` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '进展',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态',
  `isFinish` tinyint NOT NULL DEFAULT 0 COMMENT '是否已完成',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for assignprojectlist
-- ----------------------------
DROP TABLE IF EXISTS `assignprojectlist`;
CREATE TABLE `assignprojectlist`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `userID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `assignDate` datetime(0) NOT NULL COMMENT '分配时间',
  `projectType` int UNSIGNED NOT NULL COMMENT '项目类型',
  `projectName` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '项目名称',
  `process` double(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '完成度',
  `assignerID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '分配人',
  `totalWorkTime` double(10, 1) NOT NULL DEFAULT 0.0 COMMENT '总工时数',
  `gettedWorkTime` double(10, 1) NOT NULL DEFAULT 0.0 COMMENT '已获得工时数',
  `isFilled` tinyint NOT NULL DEFAULT 0 COMMENT '当月是否已填报',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '是否废弃',
  `projectLevel` tinyint NOT NULL DEFAULT 1 COMMENT '项目级别',
  `reviewStatus` tinyint NOT NULL DEFAULT 1 COMMENT '审核状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for monthprocess
-- ----------------------------
DROP TABLE IF EXISTS `monthprocess`;
CREATE TABLE `monthprocess`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aPDID` int UNSIGNED NOT NULL COMMENT '指派项目明细外键',
  `year` year NOT NULL COMMENT '年份',
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '进展类型',
  `January` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '1月',
  `February` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '2月',
  `March` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '3月',
  `April` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '4月',
  `May` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '5月',
  `June` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '6月',
  `July` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '7月',
  `August` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '8月',
  `September` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '9月',
  `October` tinyint UNSIGNED NULL DEFAULT NULL COMMENT '10月',
  `November` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '11月',
  `December` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '12月',
  `PreMonth` tinyint UNSIGNED NOT NULL DEFAULT 0 COMMENT '上一月份进展',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态 ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for monthprocess_new
-- ----------------------------
DROP TABLE IF EXISTS `monthprocess_new`;
CREATE TABLE `monthprocess_new`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aPDID` int UNSIGNED NOT NULL COMMENT '指派项目明细外键',
  `year` year NOT NULL COMMENT '年份',
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '进展类型',
  `months` tinyint UNSIGNED NULL DEFAULT 0 COMMENT '月份',
  `process` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '进展',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for projectlist
-- ----------------------------
DROP TABLE IF EXISTS `projectlist`;
CREATE TABLE `projectlist`  (
  `id` int NOT NULL COMMENT '项目/任务id',
  `userId` int NOT NULL COMMENT '创建者id',
  `title` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申报月份',
  `workType` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '工时类型',
  `workTime` int NOT NULL COMMENT '工时数',
  `participants` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参与人员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for projecttype
-- ----------------------------
DROP TABLE IF EXISTS `projecttype`;
CREATE TABLE `projecttype`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '项目:任务id',
  `groupName` tinyint NOT NULL COMMENT '组别:1-技术标准/2-工程/3-通信\r\n',
  `projectLevel1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '一级活动',
  `projectLevel2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '二级活动',
  `projectLevel3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '三级活动',
  `projectLevel4` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '四级活动',
  `workTime` double(255, 1) NOT NULL COMMENT '工时数',
  `dynamicKValue` tinyint NOT NULL COMMENT 'K值是否可变',
  `defaultKValue` double(255, 1) NOT NULL COMMENT '默认K值',
  `defaultCofficient` double(255, 1) NOT NULL COMMENT '默认系数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for projecttypenew
-- ----------------------------
DROP TABLE IF EXISTS `projecttypenew`;
CREATE TABLE `projecttypenew`  (
  `projectTypeID` int NOT NULL AUTO_INCREMENT,
  `projectName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目名称',
  `projectParentID` int NOT NULL COMMENT '项目父ID',
  `projectLevel` int NOT NULL COMMENT '项目所属级别',
  `workTime` double(255, 1) NOT NULL DEFAULT 0.0 COMMENT '工时数',
  `dynamicKValue` tinyint NOT NULL DEFAULT 0 COMMENT 'K值是否可变',
  `isConference` tinyint NOT NULL DEFAULT 0 COMMENT '是否为会议类型',
  `defaultAssignWorkTime` double(255, 1) NOT NULL DEFAULT 0.0 COMMENT '默认协助工时',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '是否废弃',
  PRIMARY KEY (`projectTypeID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 380 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for projecttypenew_copy1
-- ----------------------------
DROP TABLE IF EXISTS `projecttypenew_copy1`;
CREATE TABLE `projecttypenew_copy1`  (
  `projectTypeID` int NOT NULL AUTO_INCREMENT,
  `projectName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目名称',
  `projectParentID` int NOT NULL COMMENT '项目父ID',
  `projectLevel` int NOT NULL COMMENT '项目所属级别',
  `workTime` double(255, 1) NOT NULL COMMENT '工时数',
  `dynamicKValue` tinyint NOT NULL COMMENT 'K值是否可变',
  `isConference` tinyint NOT NULL DEFAULT 0 COMMENT '是否为会议类型',
  `defaultAssignWorkTime` double(255, 1) NOT NULL DEFAULT 0.0 COMMENT '默认协助工时',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '是否废弃',
  PRIMARY KEY (`projectTypeID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for projecttypenew_copy2
-- ----------------------------
DROP TABLE IF EXISTS `projecttypenew_copy2`;
CREATE TABLE `projecttypenew_copy2`  (
  `projectTypeID` int NOT NULL AUTO_INCREMENT,
  `projectName` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目名称',
  `projectParentID` int NOT NULL COMMENT '项目父ID',
  `projectLevel` int NOT NULL COMMENT '项目所属级别',
  `workTime` double(255, 1) NOT NULL COMMENT '工时数',
  `dynamicKValue` tinyint NOT NULL COMMENT 'K值是否可变',
  `isConference` tinyint NOT NULL DEFAULT 0 COMMENT '是否为会议类型',
  `defaultAssignWorkTime` double(255, 1) NOT NULL DEFAULT 0.0 COMMENT '默认协助工时',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '是否废弃',
  PRIMARY KEY (`projectTypeID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '用户id',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '用户名称',
  `password` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '用户密码',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '用户邮箱',
  `type` int NOT NULL DEFAULT 2 COMMENT '用户类型',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `status` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `account` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `dept` tinyint NOT NULL,
  `groupName` tinyint NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` tinyint NOT NULL,
  `password` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `status` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `partyMember` tinyint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for users_copy1
-- ----------------------------
DROP TABLE IF EXISTS `users_copy1`;
CREATE TABLE `users_copy1`  (
  `id` tinyint NOT NULL AUTO_INCREMENT,
  `account` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `dept` tinyint NOT NULL,
  `groupName` tinyint NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `role` tinyint NOT NULL,
  `password` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `state` char(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `partyMember` tinyint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for weekly
-- ----------------------------
DROP TABLE IF EXISTS `weekly`;
CREATE TABLE `weekly`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '周报id',
  `userId` int NOT NULL COMMENT '创建者id',
  `startTime` date NOT NULL COMMENT '这周开始时间',
  `endTime` date NOT NULL COMMENT '这周结束时间',
  `title` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '今年的第几周',
  `thisWeekWork` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '这周完成工作',
  `nextWeekWork` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL COMMENT '下周工作计划',
  `collaboration` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL COMMENT '需协调与帮助',
  `create_time` datetime(0) NOT NULL COMMENT '创建时间',
  `update_time` datetime(0) NOT NULL COMMENT '更新时间',
  `state` char(1) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '1' COMMENT '状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '周报表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for worktimeassign
-- ----------------------------
DROP TABLE IF EXISTS `worktimeassign`;
CREATE TABLE `worktimeassign`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL COMMENT '参与人员外键',
  `projectID` int NOT NULL COMMENT '参与项目外键',
  `workTime` float(6, 1) NOT NULL COMMENT '分配的工时数',
  `reviewWorkTime` float(6, 1) NULL DEFAULT NULL COMMENT '审核的工时数',
  `assignRole` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参与人员角色',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for worktimelist
-- ----------------------------
DROP TABLE IF EXISTS `worktimelist`;
CREATE TABLE `worktimelist`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `apdID` int NOT NULL DEFAULT 0 COMMENT '对应的项目明细ID',
  `aplID` int NOT NULL DEFAULT 0 COMMENT '对应的项目列表ID',
  `monthID` int NULL DEFAULT NULL COMMENT '对应的月份进展ID',
  `submitID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申报人ID',
  `projectTypeID` int NOT NULL COMMENT '项目类型ID',
  `applyKValue` double(4, 1) NOT NULL COMMENT '申报K值',
  `reviewKValue` double(4, 1) NULL DEFAULT NULL COMMENT '审核K值',
  `applyCofficient` double(4, 1) NOT NULL COMMENT '申报系数',
  `reviewCofficient` double(4, 1) NULL DEFAULT NULL COMMENT '审核系数',
  `submitTime` datetime(0) NOT NULL COMMENT '提交时间',
  `updateTime` datetime(0) NOT NULL COMMENT '更新时间',
  `applyMonth` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申报月份',
  `submitStatus` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提交状态',
  `submitComments` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交备注',
  `reviewStatus` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '审核状态',
  `reviewTime` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `reviewComments` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '审核备注',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态',
  `workTimeAssignReviewStatus` tinyint NOT NULL DEFAULT 0 COMMENT '工时分配审核状态',
  `reviewer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '审核人',
  `avaiableWorkTime` double(255, 1) NOT NULL DEFAULT 0.0 COMMENT '可用工时',
  `applyProcess` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '申报进展',
  `lastProcess` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '上月进展',
  `applyType` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '申报类型',
  `applyBaseWorkTime` float(6, 1) NOT NULL COMMENT '申报的基本工时（非标项目使用）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Event structure for update_schedule
-- ----------------------------
DROP EVENT IF EXISTS `update_schedule`;
delimiter ;;
CREATE EVENT `update_schedule`
ON SCHEDULE
EVERY '1' MONTH STARTS '2020-12-01 00:01:00'
DO update assignprojectlist set isFilled = 0 where obsoleteStatus != 1
;
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

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

 Date: 16/12/2020 16:26:54
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
  `projectStage` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '项目阶段',
  `baseWorkTime` float(5, 1) UNSIGNED NOT NULL COMMENT '标准工时',
  `kValue` float(5, 1) UNSIGNED NOT NULL DEFAULT 1.0 COMMENT 'K值',
  `coefficient` smallint UNSIGNED NOT NULL DEFAULT 1 COMMENT '系数',
  `avaiableWorkTime` float(5, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '可用工时',
  `process` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '进展',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态',
  `isFinish` tinyint NOT NULL DEFAULT 0 COMMENT '是否已完成',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 84 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of assignprojectdetail
-- ----------------------------
INSERT INTO `assignprojectdetail` VALUES (1, 1, '26', 5.0, 1.0, 1, 5.0, 0.0, 0, 0);

-- ----------------------------
-- Table structure for assignprojectlist
-- ----------------------------
DROP TABLE IF EXISTS `assignprojectlist`;
CREATE TABLE `assignprojectlist`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `userID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `assignDate` datetime(0) NOT NULL COMMENT '分配时间',
  `projectType` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目类型',
  `projectName` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '项目名称',
  `process` double(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '完成度',
  `assignerID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '分配人',
  `totalWorkTime` double(10, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '总工时数',
  `gettedWorkTime` double(10, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '已获得工时数',
  `isFilled` tinyint NOT NULL DEFAULT 0 COMMENT '当月是否已填报',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '是否废弃',
  `projectLevel` tinyint NOT NULL DEFAULT 1 COMMENT '项目级别',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of assignprojectlist
-- ----------------------------
INSERT INTO `assignprojectlist` VALUES (1, 15, '2020-12-16 15:31:20', '4', '112211', 0.0, 15, 5.0, 0.0, 0, 0, 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of monthprocess
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of monthprocess_new
-- ----------------------------

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of projectlist
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of projecttype
-- ----------------------------
INSERT INTO `projecttype` VALUES (1, 1, '规划类工时', '产品选型', '前期调研', '选型需求调研（对用户使用、产品运维的需求确认）', 5.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (2, 1, '规划类工时', '产品选型', '前期调研', '选型产品在公司现有应用及行业市场考察', 10.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (3, 1, '规划类工时', '产品选型', '前期调研', '选型产品的系统结构及技术参数调研', 10.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (4, 1, '规划类工时', '产品选型', '考察对比', '供应商实力及应用案例等考察', 4.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (5, 1, '规划类工时', '产品选型', '考察对比', '技术参数对比', 4.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (6, 1, '规划类工时', '产品选型', '考察对比', '产品测试', 4.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (7, 1, '规划类工时', '产品选型', '考察对比', '编写产品测试报告', 10.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (8, 1, '规划类工时', '产品选型', '选型评审', '编写选型报告', 10.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (9, 1, '规划类工时', '产品选型', '选型评审', '选型产品的系统结构及技术参数调研', 12.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (10, 1, '规划类工时', '产品选型', '选型评审', '选型缺陷跟踪修正', 5.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (11, 1, '规划类工时', '系统建设标准制定', '前期调研', '沟通用户和运维单位，汇总问题和意见/系统', 5.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (12, 1, '规划类工时', '系统建设标准制定', '资产配置标准', '制定资产配置标准/系统', 10.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (13, 1, '规划类工时', '系统建设标准制定', '资产配置标准', '修订资产配置标准/系统', 10.0, 1, 1.0, 1.0);
INSERT INTO `projecttype` VALUES (14, 1, '规划类工时', '系统建设标准制定', '资产配置标准', '牵头修订资产配置标准(包括过程组织、文档整合、外部沟通、流程审批)', 10.0, 0, 1.0, 1.0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of projecttypenew
-- ----------------------------
INSERT INTO `projecttypenew` VALUES (1, '技术标准组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (2, '工程组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (3, '通信组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (4, '规划类工时', 1, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (5, '事务类工时', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (6, '产品选型', 4, 3, 0.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew` VALUES (7, '前期调研', 172, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (8, '考察对比', 172, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (9, '选型评审', 172, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (10, '选型需求调研', 7, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (11, '选型产品在公司现有应用及行业市场考察', 7, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (12, '选型产品的系统结构及技术参数调研', 7, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (13, '供应商实力及应用案例等考察（网站电话邮件形式沟通，考察供应商数目*4h）', 8, 5, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (14, '技术参数对比（考察产品种数*4h）', 8, 5, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (15, '产品测试（测试产品个数*4h）', 8, 5, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (16, '编写产品测试报告', 8, 5, 8.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (17, '编写选型报告', 9, 5, 12.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (18, '选型缺陷跟踪修正 ', 9, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (19, '系统建设标准制定', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (20, '前期调研', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (21, '资产配置标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (22, '系统设计标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (23, '系统施工规范', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (24, '审图检查单', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (25, '工作流程标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (26, '沟通用户和运维单位，汇总问题和意见/系统', 20, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (27, '制定资产配置标准/系统', 21, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (28, '修订资产配置标准/系统', 21, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (29, '牵头修订资产配置标准（包括过程组织、文档整合、外部沟通、流程审批）', 21, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (30, '制定系统设计标准/系统', 22, 5, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (31, '修订系统设计标准/系统', 22, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (32, '牵头修订系统配置标准(包括过程组织、文档整合、外部沟通、流程审批)', 22, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (33, '制定系统施工规范/系统', 23, 5, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (34, '修订系统施工规范/系统', 23, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (35, '牵头修订系统施工规范(包括过程组织、文档整合、外部沟通、流程审批)', 23, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (36, '制定审图检查单/系统', 24, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (37, '修订审图检查单/系统', 24, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (38, '制定工作流程标准/流程', 25, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (39, '修订工作流程标准/流程', 25, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (40, '党团工作', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (41, '培训学习', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (42, '文档总结', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (43, '科室信息搜集', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (44, '工作会议', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (45, '工作规范管理', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (46, '出差行程单', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (47, '系统运维管理', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (48, '创新课题评奖', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (49, '组织活动/参赛', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (50, '宣传', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (51, '培训/知识分享', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (52, '工作饱和度', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (53, '评先评优', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (54, '其他', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (55, '党员学习/月', 40, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (56, '团员学习/月', 40, 4, 0.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (57, '制作党课教材', 40, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (58, '组织党小组会', 40, 4, 1.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew` VALUES (59, '组织党支部大会、线下主题当日活动', 40, 4, 4.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew` VALUES (60, '组织线上会议', 40, 4, 0.5, 0, 1, 0.5, 0);
INSERT INTO `projecttypenew` VALUES (61, '参加党团线下会议、党团活动', 40, 4, 1.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew` VALUES (62, '参加党团线上会议', 40, 4, 0.5, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew` VALUES (63, '党小组工时录入/组', 40, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (64, '制作培训教材', 41, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (65, '修订培训教材', 41, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (66, '准备培训设备等环境', 41, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (67, '制定考核内容', 41, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (68, '组织培训', 41, 4, 3.0, 0, 1, 2.0, 0);
INSERT INTO `projecttypenew` VALUES (69, '组织考核（含试卷批改）', 41, 4, 5.0, 0, 1, 2.0, 0);
INSERT INTO `projecttypenew` VALUES (70, '参加培训', 41, 4, 2.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew` VALUES (71, '参加考核', 41, 4, 2.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew` VALUES (72, '其他', 0, 2, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (73, '优秀培训讲师评价奖励', 41, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (74, '个人月总结', 42, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (75, '行政材料撰写（如处室周总结、月总结、工作报告）', 42, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (76, '科室月报编写及发布', 42, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (77, '搜集相关信息，整理材料', 43, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (78, '参加各类型会议', 44, 4, 1.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew` VALUES (79, '参加技术交流', 44, 4, 1.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew` VALUES (80, '组织各类型会议', 44, 4, 2.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew` VALUES (81, '组织技术交流', 44, 4, 2.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew` VALUES (82, '制定工作手册', 45, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (83, '修订工作手册', 45, 4, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (84, '文档模板制定及发布', 45, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (85, '完成工时标准修订', 45, 4, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (86, '工时审核反馈', 45, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (87, '市内', 46, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (88, '省内', 46, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (89, '国内', 46, 4, 6.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (90, '国际', 46, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (91, '配合进行系统检查、完成信息填报', 47, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (92, '月度巡检', 47, 4, 1.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (93, '季度巡检', 47, 4, 2.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (94, '工单', 47, 4, 1.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (95, '流程审核', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (96, '故障处置', 47, 4, 3.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (97, '配置变更测试', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (98, '配置变更流程', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (99, '配置变更通告', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (100, '日常维护', 47, 4, 3.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (101, '航后维护', 47, 4, 6.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (102, '合同续签', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (103, '防台风准备工作', 47, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (104, '重保保障', 47, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (105, '应急响应（AOC集结）', 47, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (106, '基建项目尾款支付', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (107, '一等奖', 48, 4, 90.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (108, '二等奖', 48, 4, 60.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (109, '三等奖', 48, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (110, '组织处室活动', 49, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (111, '代表本处参加部门活动获奖', 49, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (112, '参加公司活动获奖', 49, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (113, '参加民航局、省级活动获奖', 49, 4, 80.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (114, '参加国家级活动获奖', 49, 4, 100.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (115, '国内/国际权威媒体发表', 50, 4, 80.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (116, '航空报发表', 50, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (117, 'IT365发表', 50, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (118, '部门板报、信息门户发表', 50, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (119, '组织培训，根据时长、培训效果评价', 51, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (120, '手册、工卡编制/修订', 51, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (121, '在处室/部门/公司分享个人经验与教训、研究成果、好书推荐、读书心得、工具介绍、新思路、新方案等', 51, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (122, '加班超过30小时/月', 52, 4, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (123, '加班在10-30小时/月', 52, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (124, '当选季度之星', 53, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (125, '因个人原因导致本处绩效减分', 54, 4, -50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (126, '不服从管理人员工作安排，与管理人员、其他同事发生冲突造成不良影响的', 54, 4, -50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (127, '因个人原因导致审计问题', 54, 4, -200.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (128, '考勤异常，在部门通报后补办手续的', 54, 4, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (129, '个人原因使得处室绩效加分', 54, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (130, '在工作中及时发现存在的问题，风险点，并被处室/部门/公司采纳', 54, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (131, '个人受用户/部门/公司领导表扬', 54, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (132, '个人受用户投诉或者部门/公司领导批评', 54, 4, -10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (133, '未在每月第二个工作日前制定月度工作计划', 54, 4, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (134, '未按照要求进行项目/任务完成情况反馈', 54, 4, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (135, '系统建设规划', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (136, '编写智能化系统建设规划，并完成汇报，明确具体规划方案', 135, 4, 40.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (137, '完成特殊任务方案汇报', 135, 4, 40.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (138, '系统建设管理', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (139, '需求对接', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (140, '方案审核', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (141, '安装调试答疑', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (142, '验收审核', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (143, '零星智能化项目复杂需求对接', 139, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (144, '基建项目方案审核', 140, 5, 16.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (145, '基建项目设计变更或零星智能化项目方案审核', 140, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (146, '基建项目系统安装调试答疑', 141, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (147, '零星智能化项目系统安装调试答疑', 141, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (148, '基建项目验收审核', 142, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (149, '零星智能化项目验收审核', 142, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (150, '预算编制', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (151, '采购类项目预算编制', 150, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (152, '基建类项目预算编制', 150, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (153, '创新探索', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (154, '前期调研', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (155, '预研&立项', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (156, '课题研究', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (157, '报告&评审', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (158, '调研行业前沿应用和市场发展情况，组织会议进行进度确认', 154, 5, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (159, '调研各部门创新应用场景，完成初步测试，组织会议进行进度确认', 154, 5, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (160, '编写课题需求，完成评审会议和流程', 155, 5, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (161, '编写预研计划，完成审批局流程', 155, 5, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (162, '组织课题预研，考察相关供应商及产品', 155, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (163, '调研创新产品的系统结构及技术参数', 155, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (164, '编写预研结果报告，完成评审会议和流程', 155, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (165, '申报创新课题，编写开题报告，完成课题启动评审', 155, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (166, '阶段一，完成25%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (167, '阶段二，完成50%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (168, '阶段三，完成75%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (169, '阶段四，完成100%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (170, '编写创新课题阶段评审报告，完成课题阶段评审/次', 157, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (171, '编写创新课题结题评审报告，完成课题结题评审', 157, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (172, '选型类', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (173, '基建类', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (174, '前期策划', 173, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (175, '项目立项', 174, 4, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (176, '初步需求调研', 174, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (177, '初步设计任务书编审', 174, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (178, '项目启动评审', 174, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (179, '设计', 173, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (180, '深化设计任务书编审', 179, 4, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (181, '设计招标代理单位选择及审批', 179, 4, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (182, '深化设计单位选择及设计合同签订', 179, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (183, '组织编审智能化初步设计方案', 179, 4, 100.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (184, '组织编审智能化深化设计方案', 179, 4, 200.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (185, '项目三重一大汇报', 179, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (186, '项目深化设计技术评审及公司审批', 179, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (187, '发包', 173, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (188, '造价咨询及招标代理单位选择及审批', 187, 4, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (189, '造价咨询及清单审核', 187, 4, 100.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (190, '预算审批', 187, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (191, '招标文件编制及审批', 187, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (192, '工程发包程序', 187, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (193, '施工合同签订', 187, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (194, '结构施工', 173, 3, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (195, '配合施工开工会审及各专业接口交底', 194, 4, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (196, '主体施工阶段现场管理', 194, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (197, '配合主体施工验收', 194, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (198, '智能化工程实施方案二次评审', 194, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (199, '智能化施工', 173, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (200, '组织智能化专业进场交底', 199, 4, 60.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (201, '手机信号室分覆盖建设', 199, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (202, '运营商接入', 199, 4, 60.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (203, '机房装修、综合布线阶段现场管理', 199, 4, 150.0, 1, 0, 0.0, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of projecttypenew_copy1
-- ----------------------------
INSERT INTO `projecttypenew_copy1` VALUES (1, '技术标准组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (2, '工程组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (3, '通信组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (4, '规划类工时', 1, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (5, '事务类工时', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (6, '产品选型', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (7, '前期调研', 6, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (8, '考察对比', 6, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (9, '选型评审', 6, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (10, '选型需求调研（对用户使用、产品运维的需求确认）', 7, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (11, '选型产品在公司现有应用及行业市场考察', 7, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (12, '选型产品的系统结构及技术参数调研', 7, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (13, '供应商实力及应用案例等考察（网站电话邮件形式沟通，考察供应商数目*4h）', 8, 5, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (14, '技术参数对比（考察产品种数*4h）', 8, 5, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (15, '产品测试（测试产品个数*4h）', 8, 5, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (16, '编写产品测试报告', 8, 5, 8.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (17, '编写选型报告', 9, 5, 12.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (18, '选型缺陷跟踪修正 ', 9, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (19, '系统建设标准制定', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (20, '前期调研', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (21, '资产配置标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (22, '系统设计标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (23, '系统施工规范', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (24, '审图检查单', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (25, '工作流程标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (26, '沟通用户和运维单位，汇总问题和意见/系统', 20, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (27, '制定资产配置标准/系统', 21, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (28, '修订资产配置标准/系统', 21, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (29, '牵头修订资产配置标准（包括过程组织、文档整合、外部沟通、流程审批）', 21, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (30, '制定系统设计标准/系统', 22, 5, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (31, '修订系统设计标准/系统', 22, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (32, '牵头修订系统配置标准(包括过程组织、文档整合、外部沟通、流程审批)', 22, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (33, '制定系统施工规范/系统', 23, 5, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (34, '修订系统施工规范/系统', 23, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (35, '牵头修订系统施工规范(包括过程组织、文档整合、外部沟通、流程审批)', 23, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (36, '制定审图检查单/系统', 24, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (37, '修订审图检查单/系统', 24, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (38, '制定工作流程标准/流程', 25, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (39, '修订工作流程标准/流程', 25, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (40, '党团工作', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (41, '培训学习', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (42, '文档总结', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (43, '科室信息搜集', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (44, '工作会议', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (45, '工作规范管理', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (46, '出差行程单', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (47, '系统运维管理', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (48, '创新课题评奖', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (49, '组织活动/参赛', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (50, '宣传', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (51, '培训/知识分享', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (52, '工作饱和度', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (53, '评先评优', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (54, '其他', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (55, '党员学习/月', 40, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (56, '团员学习/月', 40, 4, 0.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (57, '制作党课教材', 40, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (58, '组织党小组会', 40, 4, 1.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (59, '组织党支部大会、线下主题当日活动', 40, 4, 4.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (60, '组织线上会议', 40, 4, 0.5, 0, 1, 0.5, 0);
INSERT INTO `projecttypenew_copy1` VALUES (61, '参加党团线下会议、党团活动', 40, 4, 1.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy1` VALUES (62, '参加党团线上会议', 40, 4, 0.5, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy1` VALUES (63, '党小组工时录入/组', 40, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (64, '制作培训教材', 41, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (65, '修订培训教材', 41, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (66, '准备培训设备等环境', 41, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (67, '制定考核内容', 41, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (68, '组织培训', 41, 4, 3.0, 0, 1, 2.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (69, '组织考核（含试卷批改）', 41, 4, 5.0, 0, 1, 2.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (70, '参加培训', 41, 4, 2.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy1` VALUES (71, '参加考核', 41, 4, 2.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy1` VALUES (72, '其他', 0, 2, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (73, '优秀培训讲师评价奖励', 41, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (74, '个人月总结', 42, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (75, '行政材料撰写（如处室周总结、月总结、工作报告）', 42, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (76, '科室月报编写及发布', 42, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (77, '搜集相关信息，整理材料', 43, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (78, '参加各类型会议', 44, 4, 1.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy1` VALUES (79, '参加技术交流', 44, 4, 1.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy1` VALUES (80, '组织各类型会议', 44, 4, 2.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (81, '组织技术交流', 44, 4, 2.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (82, '制定工作手册', 45, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (83, '修订工作手册', 45, 4, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (84, '文档模板制定及发布', 45, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (85, '完成工时标准修订', 45, 4, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (86, '工时审核反馈', 45, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (87, '市内', 46, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (88, '省内', 46, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (89, '国内', 46, 4, 6.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (90, '国际', 46, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (91, '配合进行系统检查、完成信息填报', 47, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (92, '月度巡检', 47, 4, 1.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (93, '季度巡检', 47, 4, 2.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (94, '工单', 47, 4, 1.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (95, '流程审核', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (96, '故障处置', 47, 4, 3.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (97, '配置变更测试', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (98, '配置变更流程', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (99, '配置变更通告', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (100, '日常维护', 47, 4, 3.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (101, '航后维护', 47, 4, 6.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (102, '合同续签', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (103, '防台风准备工作', 47, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (104, '重保保障', 47, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (105, '应急响应（AOC集结）', 47, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (106, '基建项目尾款支付', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (107, '一等奖', 48, 4, 90.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (108, '二等奖', 48, 4, 60.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (109, '三等奖', 48, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (110, '组织处室活动', 49, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (111, '代表本处参加部门活动获奖', 49, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (112, '参加公司活动获奖', 49, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (113, '参加民航局、省级活动获奖', 49, 4, 80.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (114, '参加国家级活动获奖', 49, 4, 100.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (115, '国内/国际权威媒体发表', 50, 4, 80.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (116, '航空报发表', 50, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (117, 'IT365发表', 50, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (118, '部门板报、信息门户发表', 50, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (119, '组织培训，根据时长、培训效果评价', 51, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (120, '手册、工卡编制/修订', 51, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (121, '在处室/部门/公司分享个人经验与教训、研究成果、好书推荐、读书心得、工具介绍、新思路、新方案等', 51, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (122, '加班超过30小时/月', 52, 4, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (123, '加班在10-30小时/月', 52, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (124, '当选季度之星', 53, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (125, '因个人原因导致本处绩效减分', 54, 4, -50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (126, '不服从管理人员工作安排，与管理人员、其他同事发生冲突造成不良影响的', 54, 4, -50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (127, '因个人原因导致审计问题', 54, 4, -200.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (128, '考勤异常，在部门通报后补办手续的', 54, 4, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (129, '个人原因使得处室绩效加分', 54, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (130, '在工作中及时发现存在的问题，风险点，并被处室/部门/公司采纳', 54, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (131, '个人受用户/部门/公司领导表扬', 54, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (132, '个人受用户投诉或者部门/公司领导批评', 54, 4, -10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (133, '未在每月第二个工作日前制定月度工作计划', 54, 4, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (134, '未按照要求进行项目/任务完成情况反馈', 54, 4, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (135, '系统建设规划', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (136, '编写智能化系统建设规划，并完成汇报，明确具体规划方案', 135, 4, 40.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (137, '完成特殊任务方案汇报', 135, 4, 40.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (138, '系统建设管理', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (139, '需求对接', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (140, '方案审核', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (141, '安装调试答疑', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (142, '验收审核', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (143, '零星智能化项目复杂需求对接', 139, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (144, '基建项目方案审核', 140, 5, 16.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (145, '基建项目设计变更或零星智能化项目方案审核', 140, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (146, '基建项目系统安装调试答疑', 141, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (147, '零星智能化项目系统安装调试答疑', 141, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (148, '基建项目验收审核', 142, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (149, '零星智能化项目验收审核', 142, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (150, '预算编制', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (151, '采购类项目预算编制', 150, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (152, '基建类项目预算编制', 150, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (153, '创新探索', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (154, '前期调研', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (155, '预研&立项', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (156, '课题研究', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (157, '报告&评审', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (158, '调研行业前沿应用和市场发展情况，组织会议进行进度确认', 154, 5, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (159, '调研各部门创新应用场景，完成初步测试，组织会议进行进度确认', 154, 5, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (160, '编写课题需求，完成评审会议和流程', 155, 5, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (161, '编写预研计划，完成审批局流程', 155, 5, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (162, '组织课题预研，考察相关供应商及产品', 155, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (163, '调研创新产品的系统结构及技术参数', 155, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (164, '编写预研结果报告，完成评审会议和流程', 155, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (165, '申报创新课题，编写开题报告，完成课题启动评审', 155, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (166, '阶段一，完成25%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (167, '阶段二，完成50%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (168, '阶段三，完成75%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (169, '阶段四，完成100%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (170, '编写创新课题阶段评审报告，完成课题阶段评审/次', 157, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (171, '编写创新课题结题评审报告，完成课题结题评审', 157, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy1` VALUES (172, '选型类工时', 0, 2, 0.0, 0, 0, 0.0, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of projecttypenew_copy2
-- ----------------------------
INSERT INTO `projecttypenew_copy2` VALUES (1, '技术标准组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (2, '工程组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (3, '通信组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (4, '规划类工时', 1, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (5, '事务类工时', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (6, '产品选型', 4, 3, 0.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy2` VALUES (7, '前期调研', 172, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (8, '考察对比', 172, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (9, '选型评审', 172, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (10, '选型需求调研', 7, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (11, '选型产品在公司现有应用及行业市场考察', 7, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (12, '选型产品的系统结构及技术参数调研', 7, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (13, '供应商实力及应用案例等考察（网站电话邮件形式沟通，考察供应商数目*4h）', 8, 5, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (14, '技术参数对比（考察产品种数*4h）', 8, 5, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (15, '产品测试（测试产品个数*4h）', 8, 5, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (16, '编写产品测试报告', 8, 5, 8.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (17, '编写选型报告', 9, 5, 12.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (18, '选型缺陷跟踪修正 ', 9, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (19, '系统建设标准制定', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (20, '前期调研', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (21, '资产配置标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (22, '系统设计标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (23, '系统施工规范', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (24, '审图检查单', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (25, '工作流程标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (26, '沟通用户和运维单位，汇总问题和意见/系统', 20, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (27, '制定资产配置标准/系统', 21, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (28, '修订资产配置标准/系统', 21, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (29, '牵头修订资产配置标准（包括过程组织、文档整合、外部沟通、流程审批）', 21, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (30, '制定系统设计标准/系统', 22, 5, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (31, '修订系统设计标准/系统', 22, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (32, '牵头修订系统配置标准(包括过程组织、文档整合、外部沟通、流程审批)', 22, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (33, '制定系统施工规范/系统', 23, 5, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (34, '修订系统施工规范/系统', 23, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (35, '牵头修订系统施工规范(包括过程组织、文档整合、外部沟通、流程审批)', 23, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (36, '制定审图检查单/系统', 24, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (37, '修订审图检查单/系统', 24, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (38, '制定工作流程标准/流程', 25, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (39, '修订工作流程标准/流程', 25, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (40, '党团工作', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (41, '培训学习', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (42, '文档总结', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (43, '科室信息搜集', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (44, '工作会议', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (45, '工作规范管理', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (46, '出差行程单', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (47, '系统运维管理', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (48, '创新课题评奖', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (49, '组织活动/参赛', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (50, '宣传', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (51, '培训/知识分享', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (52, '工作饱和度', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (53, '评先评优', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (54, '其他', 5, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (55, '党员学习/月', 40, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (56, '团员学习/月', 40, 4, 0.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (57, '制作党课教材', 40, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (58, '组织党小组会', 40, 4, 1.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (59, '组织党支部大会、线下主题当日活动', 40, 4, 4.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (60, '组织线上会议', 40, 4, 0.5, 0, 1, 0.5, 0);
INSERT INTO `projecttypenew_copy2` VALUES (61, '参加党团线下会议、党团活动', 40, 4, 1.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy2` VALUES (62, '参加党团线上会议', 40, 4, 0.5, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy2` VALUES (63, '党小组工时录入/组', 40, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (64, '制作培训教材', 41, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (65, '修订培训教材', 41, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (66, '准备培训设备等环境', 41, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (67, '制定考核内容', 41, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (68, '组织培训', 41, 4, 3.0, 0, 1, 2.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (69, '组织考核（含试卷批改）', 41, 4, 5.0, 0, 1, 2.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (70, '参加培训', 41, 4, 2.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy2` VALUES (71, '参加考核', 41, 4, 2.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy2` VALUES (72, '其他', 0, 2, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (73, '优秀培训讲师评价奖励', 41, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (74, '个人月总结', 42, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (75, '行政材料撰写（如处室周总结、月总结、工作报告）', 42, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (76, '科室月报编写及发布', 42, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (77, '搜集相关信息，整理材料', 43, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (78, '参加各类型会议', 44, 4, 1.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy2` VALUES (79, '参加技术交流', 44, 4, 1.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew_copy2` VALUES (80, '组织各类型会议', 44, 4, 2.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (81, '组织技术交流', 44, 4, 2.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (82, '制定工作手册', 45, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (83, '修订工作手册', 45, 4, 4.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (84, '文档模板制定及发布', 45, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (85, '完成工时标准修订', 45, 4, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (86, '工时审核反馈', 45, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (87, '市内', 46, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (88, '省内', 46, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (89, '国内', 46, 4, 6.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (90, '国际', 46, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (91, '配合进行系统检查、完成信息填报', 47, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (92, '月度巡检', 47, 4, 1.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (93, '季度巡检', 47, 4, 2.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (94, '工单', 47, 4, 1.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (95, '流程审核', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (96, '故障处置', 47, 4, 3.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (97, '配置变更测试', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (98, '配置变更流程', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (99, '配置变更通告', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (100, '日常维护', 47, 4, 3.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (101, '航后维护', 47, 4, 6.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (102, '合同续签', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (103, '防台风准备工作', 47, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (104, '重保保障', 47, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (105, '应急响应（AOC集结）', 47, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (106, '基建项目尾款支付', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (107, '一等奖', 48, 4, 90.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (108, '二等奖', 48, 4, 60.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (109, '三等奖', 48, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (110, '组织处室活动', 49, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (111, '代表本处参加部门活动获奖', 49, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (112, '参加公司活动获奖', 49, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (113, '参加民航局、省级活动获奖', 49, 4, 80.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (114, '参加国家级活动获奖', 49, 4, 100.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (115, '国内/国际权威媒体发表', 50, 4, 80.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (116, '航空报发表', 50, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (117, 'IT365发表', 50, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (118, '部门板报、信息门户发表', 50, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (119, '组织培训，根据时长、培训效果评价', 51, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (120, '手册、工卡编制/修订', 51, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (121, '在处室/部门/公司分享个人经验与教训、研究成果、好书推荐、读书心得、工具介绍、新思路、新方案等', 51, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (122, '加班超过30小时/月', 52, 4, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (123, '加班在10-30小时/月', 52, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (124, '当选季度之星', 53, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (125, '因个人原因导致本处绩效减分', 54, 4, -50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (126, '不服从管理人员工作安排，与管理人员、其他同事发生冲突造成不良影响的', 54, 4, -50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (127, '因个人原因导致审计问题', 54, 4, -200.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (128, '考勤异常，在部门通报后补办手续的', 54, 4, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (129, '个人原因使得处室绩效加分', 54, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (130, '在工作中及时发现存在的问题，风险点，并被处室/部门/公司采纳', 54, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (131, '个人受用户/部门/公司领导表扬', 54, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (132, '个人受用户投诉或者部门/公司领导批评', 54, 4, -10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (133, '未在每月第二个工作日前制定月度工作计划', 54, 4, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (134, '未按照要求进行项目/任务完成情况反馈', 54, 4, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (135, '系统建设规划', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (136, '编写智能化系统建设规划，并完成汇报，明确具体规划方案', 135, 4, 40.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (137, '完成特殊任务方案汇报', 135, 4, 40.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (138, '系统建设管理', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (139, '需求对接', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (140, '方案审核', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (141, '安装调试答疑', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (142, '验收审核', 138, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (143, '零星智能化项目复杂需求对接', 139, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (144, '基建项目方案审核', 140, 5, 16.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (145, '基建项目设计变更或零星智能化项目方案审核', 140, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (146, '基建项目系统安装调试答疑', 141, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (147, '零星智能化项目系统安装调试答疑', 141, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (148, '基建项目验收审核', 142, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (149, '零星智能化项目验收审核', 142, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (150, '预算编制', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (151, '采购类项目预算编制', 150, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (152, '基建类项目预算编制', 150, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (153, '创新探索', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (154, '前期调研', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (155, '预研&立项', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (156, '课题研究', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (157, '报告&评审', 153, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (158, '调研行业前沿应用和市场发展情况，组织会议进行进度确认', 154, 5, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (159, '调研各部门创新应用场景，完成初步测试，组织会议进行进度确认', 154, 5, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (160, '编写课题需求，完成评审会议和流程', 155, 5, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (161, '编写预研计划，完成审批局流程', 155, 5, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (162, '组织课题预研，考察相关供应商及产品', 155, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (163, '调研创新产品的系统结构及技术参数', 155, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (164, '编写预研结果报告，完成评审会议和流程', 155, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (165, '申报创新课题，编写开题报告，完成课题启动评审', 155, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (166, '阶段一，完成25%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (167, '阶段二，完成50%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (168, '阶段三，完成75%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (169, '阶段四，完成100%，组织会议进行进度确认', 156, 5, 75.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (170, '编写创新课题阶段评审报告，完成课题阶段评审/次', 157, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (171, '编写创新课题结题评审报告，完成课题结题评审', 157, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew_copy2` VALUES (172, '选型类', 0, 2, 0.0, 0, 0, 0.0, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'de06091877ea209cff3c4b4a28194c8e', '1195997183@qq.com', 1, '2018-06-27 09:54:44', '2018-06-27 15:54:44', '1');
INSERT INTO `user` VALUES (2, 'jhn', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-09-24 08:00:00', '2020-07-22 10:50:17', '1');
INSERT INTO `user` VALUES (3, 'test2', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-09-24 09:00:00', '2020-07-22 10:45:22', '1');
INSERT INTO `user` VALUES (4, 'test3', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2018-10-09 09:54:44', '2019-10-10 09:10:20', '1');
INSERT INTO `user` VALUES (5, 'test4', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-10-10 09:12:18', '2019-10-14 16:58:42', '1');
INSERT INTO `user` VALUES (16, 'test5', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-10-12 15:54:30', '2019-10-12 15:54:30', '1');
INSERT INTO `user` VALUES (24, 'test6', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-10-12 16:01:13', '2019-10-12 16:01:13', '1');
INSERT INTO `user` VALUES (25, 'test7', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-10-12 16:01:20', '2019-10-12 16:01:20', '1');
INSERT INTO `user` VALUES (32, 'test8', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-10-12 16:09:30', '2019-10-12 16:09:30', '1');
INSERT INTO `user` VALUES (33, 'test9', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-10-14 10:09:56', '2020-10-15 15:07:31', '1');
INSERT INTO `user` VALUES (35, 'test10', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-10-14 10:11:11', '2019-10-15 14:25:03', '0');
INSERT INTO `user` VALUES (36, 'test12', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-10-15 15:16:36', '2020-09-03 22:01:11', '1');
INSERT INTO `user` VALUES (37, 'test14', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2019-10-15 15:17:39', '2020-07-22 10:45:48', '0');
INSERT INTO `user` VALUES (38, 'jhn111', 'e10adc3949ba59abbe56e057f20f883e', NULL, 2, '2020-09-04 10:06:08', '2020-11-04 09:07:36', '0');

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
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (7, '00984', 1, 1, '白洋', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (8, '30894', 1, 1, '陈迪', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (9, '12148', 1, 3, '陈晓峰', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (10, '00808', 1, 3, '傅霖晖', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (11, '02031', 1, 2, '郭红生', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (12, '12690', 1, 3, '顾心瑜', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (13, '13885', 1, 1, '黄雅婷', 2, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (14, '27815', 1, 1, '胡章荣', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (15, '31345', 1, 1, '江黄能', 1, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (16, '02478', 1, 2, '匡卫民', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (17, '10698', 1, 2, '连祎文', 2, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (18, '22356', 1, 3, '李俊炎', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (19, '23940', 1, 2, '李培育', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (20, '22303', 1, 2, '刘佳彬', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (21, '28494', 1, 1, '刘向前', 3, 'e10adc3949ba59abbe56e057f20f883e', '0', 1);
INSERT INTO `users` VALUES (22, '01712', 1, 2, '罗茂海', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (23, '22410', 1, 1, '彭荣茂', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (24, '20084', 1, 2, '秦言擎', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (25, '12681', 1, 2, '王伟强', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (26, '03515', 1, 4, '王喻强', 1, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (27, '20787', 1, 1, '吴冬晖', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (28, '28616', 1, 2, '吴一鹏', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (29, '25715', 1, 3, '许尖钻', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (30, '22152', 1, 2, '杨宇辰', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (31, '00813', 1, 3, '颜河生', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (32, '28689', 1, 2, '赵帅', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (33, '16600', 1, 3, '邹涛', 2, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users_copy1
-- ----------------------------
INSERT INTO `users_copy1` VALUES (3, '00984', 1, 1, '白洋', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users_copy1` VALUES (4, '30984', 1, 1, '陈迪', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (5, '12148', 1, 3, '陈晓峰', 2, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (6, '00808', 1, 3, '傅霖晖', 3, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (7, '02031', 1, 2, '郭红生', 3, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (8, '12690', 1, 3, '顾心瑜', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (9, '13885', 1, 1, '黄雅婷', 2, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (10, '27815', 1, 1, '胡章荣', 3, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (11, '31345', 1, 1, '江黄能', 1, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (12, '02478', 1, 2, '匡卫民', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (13, '10698', 1, 2, '连祎文', 2, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (14, '22356', 1, 3, '李俊炎', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (15, '23940', 1, 2, '李培育', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (16, '22303', 1, 2, '刘佳彬', 3, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (17, '28494', 1, 1, '刘向前', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (18, '01712', 1, 2, '罗茂海', 3, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (19, '22410', 1, 1, '彭荣茂', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (20, '20084', 1, 2, '秦言擎', 3, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (21, '12681', 1, 2, '王伟强', 3, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (22, '03515', 1, 4, '王喻强', 1, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (23, '20787', 1, 1, '吴冬晖', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (24, '28616', 1, 2, '吴一鹏', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (25, '25715', 1, 3, '许尖钻', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (26, '22152', 1, 2, '杨宇辰', 3, '123456', '1', 1);
INSERT INTO `users_copy1` VALUES (27, '00813', 1, 3, '颜河生', 3, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (28, '28689', 1, 2, '赵帅', 3, '123456', '1', 0);
INSERT INTO `users_copy1` VALUES (29, '16600', 1, 3, '邹涛', 3, '123456', '1', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '周报表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of weekly
-- ----------------------------
INSERT INTO `weekly` VALUES (12, 1, '2018-06-25', '2018-06-29', '2018第26周', '<p>111</p>', '<p>222</p>', '333', '2018-06-29 15:43:17', '2018-06-29 15:43:17', '0');
INSERT INTO `weekly` VALUES (13, 1, '2019-07-14', '2019-07-20', '2019 第 29 周', '<p>111</p>', '<p>333</p>', '333', '2018-06-29 15:44:30', '2019-10-18 16:56:37', '1');
INSERT INTO `weekly` VALUES (14, 1, '2019-07-21', '2019-07-27', '2019 第 30 周', '<ol><li>分销活动逻辑制作未收到回复速度ukfh；</li><li>从App分享到小程序；</li><li>代码优化。</li></ol>', '<ol><li>分销活动剩余接口对接；</li><li>其他待定。</li></ol>', '王金科，王立志', '2018-06-29 15:54:44', '2019-10-18 16:56:17', '1');
INSERT INTO `weekly` VALUES (15, 1, '2019-07-28', '2019-08-03', '2019 第 31 周', '<p>申达股份三个地方</p>', '<p>水电费第三方</p>', '无色无', '2018-06-29 18:34:16', '2019-10-18 16:55:52', '1');
INSERT INTO `weekly` VALUES (16, 1, '2019-08-04', '2019-08-10', '2019 第 32 周', '<p>申达股份三个地方谁看见对方的时刻发挥</p>', '<p>水电费第三方</p>', '无色无', '2018-07-05 18:08:27', '2019-10-18 16:20:23', '1');
INSERT INTO `weekly` VALUES (17, 1, '2019-08-11', '2019-08-17', '2019 第 33 周', '<p>多少苦海吃饭速度和顺丰到付</p>', '<p>大范甘迪速回复打算</p>', '法规回复等级', '2018-07-05 18:16:48', '2019-10-18 16:20:05', '1');
INSERT INTO `weekly` VALUES (18, 2, '2019-08-18', '2019-08-24', '2019 第 34 周', '<p>而发热污染负荷</p>', '<p>儿童和侮辱和他二位</p>', '我看见发给人家', '2018-07-05 19:01:43', '2019-10-18 16:19:51', '1');
INSERT INTO `weekly` VALUES (19, 1, '2019-08-25', '2019-08-31', '2019 第 35 周', '<p>打暑假工福建省的股份</p>', '<p>胜多负少肯定会复合大师</p>', '无', '2018-07-30 19:18:36', '2019-10-18 16:19:21', '1');
INSERT INTO `weekly` VALUES (20, 2, '2019-09-01', '2019-09-07', '2019 第 36 周', '<p>但是结果发生金盾股份</p>', '<p>1</p>', '无', '2018-07-31 18:10:17', '2020-08-19 08:53:13', '1');
INSERT INTO `weekly` VALUES (21, 1, '2019-09-08', '2019-09-14', '2019 第 37 周', '<p>111</p>', '<p>222</p>', '333', '2019-10-14 15:13:32', '2019-10-18 16:18:40', '1');
INSERT INTO `weekly` VALUES (22, 1, '2019-09-15', '2019-09-21', '2019 第 38 周', '<p>111</p>', '<p>222</p>', NULL, '2019-10-16 10:17:33', '2019-10-18 16:17:15', '1');
INSERT INTO `weekly` VALUES (23, 1, '2019-09-22', '2019-09-28', '2019 第 39 周', '<p>11</p>', '<p>33</p>', NULL, '2019-10-16 10:29:02', '2019-10-18 16:16:58', '1');
INSERT INTO `weekly` VALUES (24, 1, '2019-09-29', '2019-10-05', '2019 第 40 周', '<p>eee</p>', '<p>ggg</p>', NULL, '2019-10-16 12:08:10', '2019-10-18 16:16:44', '1');
INSERT INTO `weekly` VALUES (25, 1, '2019-10-06', '2019-10-12', '2019 第 41 周', '<p>rrr</p>', '<p>ggg</p>', NULL, '2019-10-16 12:08:38', '2019-10-18 16:16:37', '1');
INSERT INTO `weekly` VALUES (26, 1, '2019-10-13', '2019-10-19', '2019 第 42 周', '<p>逛</p>', '<p>看看</p>', NULL, '2019-10-16 12:09:16', '2020-11-08 20:53:24', '1');

-- ----------------------------
-- Table structure for worktimeassign
-- ----------------------------
DROP TABLE IF EXISTS `worktimeassign`;
CREATE TABLE `worktimeassign`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL COMMENT '参与人员外键',
  `projectID` int NOT NULL COMMENT '参与项目外键',
  `workTime` double(255, 1) NOT NULL COMMENT '分配的工时数',
  `reviewWorkTime` double(255, 1) NULL DEFAULT NULL COMMENT '审核的工时数',
  `assignRole` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参与人员角色',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 70 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of worktimeassign
-- ----------------------------
INSERT INTO `worktimeassign` VALUES (1, 15, 1, 2.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (2, 8, 1, 1.0, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (3, 32, 1, 1.0, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (4, 15, 2, 2.0, 2.0, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (5, 11, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (6, 16, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (7, 17, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (8, 19, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (9, 20, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (10, 22, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (11, 24, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (12, 25, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (13, 28, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (14, 30, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (15, 32, 2, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (16, 8, 3, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (17, 8, 4, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (18, 8, 5, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (19, 8, 6, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (20, 8, 7, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (21, 8, 8, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (22, 8, 9, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (23, 8, 10, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (24, 8, 11, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (25, 8, 12, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (26, 8, 13, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (27, 8, 14, 20.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (28, 8, 15, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (29, 8, 16, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (30, 8, 17, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (31, 8, 18, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (32, 8, 19, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (33, 8, 20, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (34, 8, 21, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (35, 8, 22, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (36, 8, 24, 0.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (37, 8, 25, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (38, 8, 26, 0.4, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (39, 8, 27, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (40, 15, 26, 0.1, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (41, 8, 28, 0.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (42, 8, 29, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (43, 8, 30, 0.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (44, 8, 31, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (45, 8, 32, 0.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (46, 8, 33, 2.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (47, 8, 34, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (48, 8, 35, 0.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (49, 8, 36, 4.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (50, 8, 37, 0.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (51, 8, 38, 4.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (52, 8, 39, 2.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (53, 8, 40, 2.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (54, 8, 41, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (55, 8, 42, 3.1, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (56, 15, 42, 0.5, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (57, 8, 43, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (58, 8, 44, 3.1, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (59, 15, 44, 0.5, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (60, 8, 45, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (61, 8, 46, 3.6, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (62, 8, 47, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (63, 8, 48, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (64, 15, 49, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (65, 15, 50, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (66, 15, 51, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (67, 8, 52, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (68, 8, 53, 3.6, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (69, 15, 54, 5.0, NULL, '组织者', 0);

-- ----------------------------
-- Table structure for worktimelist
-- ----------------------------
DROP TABLE IF EXISTS `worktimelist`;
CREATE TABLE `worktimelist`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `submitID` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申报人ID',
  `projectName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目名称',
  `projectTypeID` int NOT NULL COMMENT '项目类型ID',
  `applyKValue` double(255, 1) NOT NULL COMMENT '申报K值',
  `reviewKValue` double(255, 1) NULL DEFAULT NULL COMMENT '审核K值',
  `applyCofficient` double(255, 1) NOT NULL COMMENT '申报系数',
  `reviewCofficient` double(255, 1) NULL DEFAULT NULL COMMENT '审核系数',
  `submitTime` datetime(0) NOT NULL COMMENT '提交时间',
  `updateTime` datetime(0) NOT NULL COMMENT '更新时间',
  `applyMonth` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申报月份',
  `submitStatus` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提交状态',
  `submitComments` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交备注',
  `reviewStatus` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '0' COMMENT '审核状态',
  `reviewTime` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `reviewComments` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '审核备注',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态',
  `workTimeAssignReviewStatus` tinyint NOT NULL DEFAULT 0 COMMENT '工时分配审核状态',
  `reviewer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '审核人',
  `avaiableWorkTime` double(255, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '可用工时',
  `applyProcess` float(4, 1) UNSIGNED ZEROFILL NOT NULL DEFAULT 00.0 COMMENT '申报进展',
  `apdID` int NOT NULL DEFAULT 0 COMMENT '对应的项目明细ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 54 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of worktimelist
-- ----------------------------
INSERT INTO `worktimelist` VALUES (1, '15', '科华环境监控交流', 80, 1.0, NULL, 1.0, NULL, '2020-12-01 09:27:10', '2020-12-14 11:30:02', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (2, '15', '答复', 80, 1.0, NULL, 1.0, NULL, '2020-12-01 09:37:40', '2020-12-16 08:07:42', '2020-12', '1', '', '0', NULL, '', 1, 1, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (3, '8', 'BA系统选型', 1, 1.0, NULL, 1.0, NULL, '2020-12-07 08:37:54', '2020-12-07 08:37:54', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (4, '8', 'BA系统选型', 2, 1.0, NULL, 1.0, NULL, '2020-12-07 08:37:54', '2020-12-07 08:37:54', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (5, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 08:39:51', '2020-12-07 08:39:51', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (6, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 08:39:51', '2020-12-07 08:39:51', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (7, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 08:57:17', '2020-12-07 08:59:08', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (8, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 08:57:17', '2020-12-07 08:57:17', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (9, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 08:58:46', '2020-12-07 08:58:46', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (10, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 08:58:46', '2020-12-07 08:58:46', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (11, '8', '1', 26, 1.0, NULL, 1.0, NULL, '2020-12-07 08:59:36', '2020-12-07 08:59:36', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (12, '8', '2', 27, 1.0, NULL, 1.0, NULL, '2020-12-07 08:59:36', '2020-12-07 08:59:36', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (13, '8', '3', 28, 1.0, NULL, 1.0, NULL, '2020-12-07 08:59:36', '2020-12-07 08:59:36', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (14, '8', '4', 29, 1.0, NULL, 1.0, NULL, '2020-12-07 08:59:36', '2020-12-07 08:59:36', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (15, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 09:46:09', '2020-12-07 09:46:09', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (16, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 09:46:09', '2020-12-07 09:46:09', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (17, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 09:49:18', '2020-12-07 09:49:18', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (18, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 09:49:18', '2020-12-07 09:49:18', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (19, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 10:22:23', '2020-12-07 10:22:23', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (20, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 10:22:23', '2020-12-07 10:22:23', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (21, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 10:34:32', '2020-12-07 10:34:32', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (22, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 10:34:32', '2020-12-07 10:34:32', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (23, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 10:47:46', '2020-12-07 10:47:46', '2020-11', '0', '', '0', NULL, '', 0, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (24, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 10:51:50', '2020-12-07 10:51:50', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (25, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 10:51:50', '2020-12-07 10:51:50', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (26, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 11:14:37', '2020-12-07 11:31:12', '2020-11', '1', '', '0', NULL, '', 1, 0, '', 0.5, 00.0, 0);
INSERT INTO `worktimelist` VALUES (27, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 11:14:37', '2020-12-07 11:14:37', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 1.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (28, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 13:58:16', '2020-12-07 13:58:16', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.5, 00.0, 0);
INSERT INTO `worktimelist` VALUES (29, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 13:58:16', '2020-12-07 13:58:16', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 1.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (30, '8', 'BA系统选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 14:23:44', '2020-12-07 14:23:44', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 0.5, 00.0, 0);
INSERT INTO `worktimelist` VALUES (31, '8', 'BA系统选型', 11, 1.0, NULL, 1.0, NULL, '2020-12-07 14:23:44', '2020-12-07 14:23:44', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 1.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (32, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-07 14:45:41', '2020-12-07 14:46:04', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 0.5, 00.0, 0);
INSERT INTO `worktimelist` VALUES (33, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-10 14:41:51', '2020-12-10 14:41:51', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 2.5, 00.0, 0);
INSERT INTO `worktimelist` VALUES (34, '8', '综合布线选型', 12, 1.0, NULL, 1.0, NULL, '2020-12-10 14:41:51', '2020-12-10 14:41:51', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 5.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (35, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-10 14:43:57', '2020-12-10 14:43:57', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 0.5, 00.0, 0);
INSERT INTO `worktimelist` VALUES (36, '8', '综合布线选型', 12, 1.0, NULL, 1.0, NULL, '2020-12-10 14:43:57', '2020-12-10 14:43:57', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 4.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (37, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-10 15:01:28', '2020-12-10 15:24:49', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 0.5, 00.0, 0);
INSERT INTO `worktimelist` VALUES (38, '8', '综合布线选型', 12, 1.0, NULL, 1.0, NULL, '2020-12-10 15:01:28', '2020-12-10 15:24:47', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 4.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (39, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-14 10:32:30', '2020-12-14 10:32:30', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 2.5, 00.0, 0);
INSERT INTO `worktimelist` VALUES (40, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-14 10:33:34', '2020-12-14 10:33:34', '2020-11', '0', '', '0', NULL, '', 1, 0, '', 2.5, 00.0, 0);
INSERT INTO `worktimelist` VALUES (41, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-14 10:48:23', '2020-12-14 10:50:32', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 1.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (42, '8', '综合布线选型', 13, 1.0, NULL, 1.0, NULL, '2020-12-14 10:48:23', '2020-12-14 10:50:30', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 3.6, 00.0, 0);
INSERT INTO `worktimelist` VALUES (43, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-14 14:03:34', '2020-12-14 14:03:34', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 1.0, 00.0, 0);
INSERT INTO `worktimelist` VALUES (44, '8', '综合布线选型', 13, 1.0, NULL, 1.0, NULL, '2020-12-14 14:03:34', '2020-12-14 14:03:44', '2020-12', '1', '测试备注', '0', NULL, '', 1, 0, '', 3.6, 00.0, 0);
INSERT INTO `worktimelist` VALUES (45, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-14 14:16:26', '2020-12-14 14:16:26', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 1.0, 70.0, 0);
INSERT INTO `worktimelist` VALUES (46, '8', '综合布线选型', 13, 1.0, NULL, 1.0, NULL, '2020-12-14 14:16:26', '2020-12-14 14:16:26', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 3.6, 90.0, 0);
INSERT INTO `worktimelist` VALUES (47, '8', '1', 26, 1.0, NULL, 1.0, NULL, '2020-12-14 15:39:35', '2020-12-14 15:39:35', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 5.0, 100.1, 0);
INSERT INTO `worktimelist` VALUES (48, '8', '1', 26, 1.0, NULL, 1.0, NULL, '2020-12-14 15:42:20', '2020-12-14 15:42:20', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 5.0, 100.0, 0);
INSERT INTO `worktimelist` VALUES (49, '15', '测试333', 26, 1.0, NULL, 1.0, NULL, '2020-12-15 17:03:24', '2020-12-15 17:03:24', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 5.0, 100.0, 0);
INSERT INTO `worktimelist` VALUES (50, '15', '1233', 27, 1.0, NULL, 1.0, NULL, '2020-12-15 17:04:35', '2020-12-15 17:04:35', '2020-12', '1', '', '0', NULL, '', 1, 0, '', 10.0, 100.0, 0);
INSERT INTO `worktimelist` VALUES (51, '15', '修订资产配置标准', 28, 1.0, NULL, 1.0, NULL, '2020-12-15 17:10:24', '2020-12-16 15:01:58', '2020-12', '0', '', '0', NULL, '', 1, 0, '', 5.0, 100.0, 0);
INSERT INTO `worktimelist` VALUES (52, '8', '综合布线选型', 10, 1.0, NULL, 1.0, NULL, '2020-12-16 14:24:39', '2020-12-16 15:30:57', '2020-12', '0', '', '0', NULL, '', 0, 0, '', 1.0, 70.0, 10);
INSERT INTO `worktimelist` VALUES (53, '8', '综合布线选型', 13, 1.0, NULL, 1.0, NULL, '2020-12-16 14:24:39', '2020-12-16 14:25:06', '2020-12', '1', '', '0', NULL, '', 0, 0, '', 3.6, 90.0, 13);
INSERT INTO `worktimelist` VALUES (54, '15', '112211', 26, 1.0, NULL, 1.0, NULL, '2020-12-16 15:31:21', '2020-12-16 15:31:21', '2020-12', '0', '', '0', NULL, '', 0, 0, '', 5.0, 100.0, 1);

-- ----------------------------
-- Event structure for update_schedule
-- ----------------------------
DROP EVENT IF EXISTS `update_schedule`;
delimiter ;;
CREATE EVENT `update_schedule`
ON SCHEDULE
EVERY '1' MONTH STARTS '2020-12-01 00:01:00'
DO update assignprojectlist set isFilled = 0 where obsoleteStatus != 1
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

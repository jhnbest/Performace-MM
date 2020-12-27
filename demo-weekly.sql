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

 Date: 27/12/2020 19:49:50
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
) ENGINE = InnoDB AUTO_INCREMENT = 145 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of assignprojectdetail
-- ----------------------------
INSERT INTO `assignprojectdetail` VALUES (1, 1, 11, '选型产品在公司现有应用及行业市场考察', 10.0, 1.5, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (2, 1, 12, '选型产品的系统结构及技术参数调研', 10.0, 1.5, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (3, 1, 13, '供应商实力及应用案例等考察（网站电话邮件形式沟通，考察供应商数目*4h）', 4.0, 1.5, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (4, 1, 14, '技术参数对比（考察产品种数*4h）', 4.0, 1.5, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (5, 1, 15, '产品测试（测试产品个数*4h）', 4.0, 1.5, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (6, 1, 16, '编写产品测试报告', 8.0, 1.5, 1, 8.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (7, 1, 17, '编写选型报告', 12.0, 1.5, 1, 12.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (8, 1, 18, '选型缺陷跟踪修正 ', 5.0, 1.5, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (9, 2, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 1, 1);
INSERT INTO `assignprojectdetail` VALUES (10, 3, 27, '制定资产配置标准/系统', 10.0, 1.0, 1, 8.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (11, 4, 72, '自定义项目阶段', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (12, 5, 72, '自定义项目阶段', 1.0, 1.0, 1, 0.8, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (13, 6, 13, '供应商实力及应用案例等考察（网站电话邮件形式沟通，考察供应商数目*4h）', 4.0, 1.5, 1, 6.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (14, 6, 14, '技术参数对比（考察产品种数*4h）', 4.0, 1.5, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (15, 6, 15, '产品测试（测试产品个数*4h）', 4.0, 1.5, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (16, 6, 16, '编写产品测试报告', 8.0, 1.5, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (17, 6, 17, '编写选型报告', 12.0, 1.5, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (18, 6, 18, '选型缺陷跟踪修正 ', 5.0, 1.5, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (19, 7, 72, '自定义项目阶段', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (20, 8, 72, '协助项目经理完成汇报中功能平台的内容', 100.0, 1.0, 1, 100.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (21, 8, 72, '协助项目经理完成汇报中终端选型的内容', 80.0, 1.0, 1, 80.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (22, 8, 72, '协助项目经理完成汇报中运营商信号的内容', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (23, 9, 175, '项目立项', 20.0, 1.0, 1, 20.0, 10.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (24, 9, 176, '初步需求调研', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (25, 9, 177, '初步设计任务书编审', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (26, 9, 178, '项目启动评审', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (27, 9, 180, '深化设计任务书编审', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (28, 9, 181, '设计招标代理单位选择及审批', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (29, 9, 182, '深化设计单位选择及设计合同签订', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (30, 9, 183, '组织编审智能化初步设计方案', 100.0, 1.0, 1, 100.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (31, 9, 184, '组织编审智能化深化设计方案', 200.0, 1.0, 1, 200.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (32, 9, 185, '项目三重一大汇报', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (33, 9, 186, '项目深化设计技术评审及公司审批', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (34, 9, 188, '造价咨询及招标代理单位选择及审批', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (35, 9, 189, '造价咨询及清单审核', 100.0, 1.0, 1, 100.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (36, 9, 190, '预算审批', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (37, 9, 191, '招标文件编制及审批', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (38, 9, 192, '工程发包程序', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (39, 9, 193, '施工合同签订', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (40, 9, 195, '配合施工开工会审及各专业接口交底', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (41, 9, 196, '主体施工阶段现场管理', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (42, 9, 197, '配合主体施工验收', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (43, 9, 198, '智能化工程实施方案二次评审', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (44, 9, 200, '组织智能化专业进场交底', 60.0, 1.0, 1, 60.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (45, 9, 201, '手机信号室分覆盖建设', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (46, 9, 202, '运营商接入', 60.0, 1.0, 1, 60.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (47, 9, 203, '机房装修、综合布线阶段现场管理', 150.0, 1.0, 1, 150.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (48, 9, 204, '智能化隐蔽工程检查及验收', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (49, 9, 205, '设备安装及系统调试阶段现场管理', 250.0, 1.0, 1, 250.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (50, 9, 207, '智能化初步验收及搬迁配合', 100.0, 1.0, 1, 100.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (51, 9, 208, '项目试运行及整改', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (52, 9, 209, '智能化系统培训', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (53, 9, 210, '项目正式验收', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (54, 9, 211, '项目移交', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (55, 9, 212, '项目总结', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (56, 10, 215, '筹建项目组及项目评估', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (57, 10, 216, '需求调研及编写需求报告\r\n确定目标、范围和入围产品要求', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (58, 10, 217, '编写启动分析报告', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (59, 10, 218, '供应商预推荐及考察', 20.0, 1.0, 1, 18.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (60, 10, 219, '报季度采购沟通会', 2.0, 1.0, 1, 2.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (61, 10, 220, '季度计划外采购申请', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (62, 10, 221, '启动评审', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (63, 10, 223, '产品测试/产品选型/服务考察', 15.0, 1.0, 1, 15.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (64, 10, 224, '增补IT供应商考察及审批流程（可选）', 15.0, 1.0, 1, 15.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (65, 10, 225, '选型方案/测试方案/服务考察方案评审', 15.0, 1.0, 1, 15.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (66, 10, 226, '技术方案编审', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (67, 10, 227, '技术评审', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (68, 10, 229, '发起采购沟通会', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (69, 10, 230, '三重一大议题申报流程(可选）', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (70, 10, 231, '单一来源/品牌采购申请流程(可选)', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (71, 10, 232, '采购需求审批', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (72, 10, 233, '预算执行申请', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (73, 10, 234, '采购评审会', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (74, 10, 235, '合同会签和归档', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (75, 10, 236, '下单采购', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (76, 10, 238, '实施交底及制定实施方案等', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (77, 10, 239, '设备到货验收', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (78, 10, 240, '项目实施及现场管理', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (79, 10, 241, '编写运维手册', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (80, 10, 242, '组织用户使用和运维培训', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (81, 10, 243, '试运行及督促整改', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (82, 10, 245, '组织验收', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (83, 10, 246, '项目验收评审', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (84, 10, 247, '系统移交和归档', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (85, 10, 248, '项目总结', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (86, 11, 250, '需求调研', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (87, 11, 251, '方案设计', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (88, 11, 252, '组织施工', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (89, 11, 253, '验收交接', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (90, 12, 10, '选型需求调研', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (91, 12, 11, '选型产品在公司现有应用及行业市场考察', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (92, 12, 12, '选型产品的系统结构及技术参数调研', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (93, 12, 13, '供应商实力及应用案例等考察（网站电话邮件形式沟通，考察供应商数目*4h）', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (94, 12, 14, '技术参数对比（考察产品种数*4h）', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (95, 12, 15, '产品测试（测试产品个数*4h）', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (96, 12, 16, '编写产品测试报告', 8.0, 1.0, 1, 8.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (97, 12, 17, '编写选型报告', 12.0, 1.0, 1, 12.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (98, 12, 18, '选型缺陷跟踪修正 ', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (99, 13, 72, '自定义项目阶段', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (100, 14, 72, '建设思路汇报阶段', 220.0, 1.0, 1, 220.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (101, 15, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (102, 16, 68, '组织培训', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (103, 17, 72, '桥架设计变更', 100.0, 3.0, 1, 90.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (104, 17, 72, '进度款支付', 5.0, 3.0, 1, 15.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (105, 18, 175, '项目立项', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (106, 18, 176, '初步需求调研', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (107, 18, 177, '初步设计任务书编审', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (108, 18, 178, '项目启动评审', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (109, 18, 180, '深化设计任务书编审', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (110, 18, 181, '设计招标代理单位选择及审批', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (111, 18, 182, '深化设计单位选择及设计合同签订', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (112, 18, 183, '组织编审智能化初步设计方案', 100.0, 1.0, 1, 100.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (113, 18, 184, '组织编审智能化深化设计方案', 200.0, 1.0, 1, 200.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (114, 18, 185, '项目三重一大汇报', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (115, 18, 186, '项目深化设计技术评审及公司审批', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (116, 18, 188, '造价咨询及招标代理单位选择及审批', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (117, 18, 189, '造价咨询及清单审核', 100.0, 1.0, 1, 100.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (118, 18, 190, '预算审批', 20.0, 1.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (119, 18, 191, '招标文件编制及审批', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (120, 18, 192, '工程发包程序', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (121, 18, 193, '施工合同签订', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (122, 18, 195, '配合施工开工会审及各专业接口交底', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (123, 18, 196, '主体施工阶段现场管理', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (124, 18, 197, '配合主体施工验收', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (125, 18, 198, '智能化工程实施方案二次评审', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (126, 18, 200, '组织智能化专业进场交底', 60.0, 1.0, 1, 60.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (127, 18, 201, '手机信号室分覆盖建设', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (128, 18, 202, '运营商接入', 60.0, 1.0, 1, 60.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (129, 18, 203, '机房装修、综合布线阶段现场管理', 150.0, 1.0, 1, 150.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (130, 18, 204, '智能化隐蔽工程检查及验收', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (131, 18, 205, '设备安装及系统调试阶段现场管理', 250.0, 1.0, 1, 250.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (132, 18, 207, '智能化初步验收及搬迁配合', 100.0, 1.0, 1, 100.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (133, 18, 208, '项目试运行及整改', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (134, 18, 209, '智能化系统培训', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (135, 18, 210, '项目正式验收', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (136, 18, 211, '项目移交', 50.0, 1.0, 1, 50.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (137, 18, 212, '项目总结', 30.0, 1.0, 1, 30.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (138, 19, 72, '总部大厦企业展厅供应商考察', 1.0, 1.0, 1, 12.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (139, 20, 89, '国内', 6.0, 1.0, 1, 18.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (140, 21, 72, '与李培育到AOC现场勘查乘务准备室布线线路', 1.0, 1.5, 1, 1.5, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (141, 21, 72, '与赵帅到AOC现场勘查光纤敷设线路', 1.0, 2.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (142, 21, 72, '纵宇修缮项目审核与资料整理', 1.0, 20.0, 1, 20.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (143, 22, 72, '智能化各系统现场检查单编制', 50.0, 1.0, 1, 10.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (144, 23, 27, '制定资产配置标准/系统', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (145, 24, 10, '选型需求调研', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (146, 24, 11, '选型产品在公司现有应用及行业市场考察', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (147, 24, 12, '选型产品的系统结构及技术参数调研', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (148, 24, 13, '供应商实力及应用案例等考察（网站电话邮件形式沟通，考察供应商数目*4h）', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (149, 24, 14, '技术参数对比（考察产品种数*4h）', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (150, 24, 15, '产品测试（测试产品个数*4h）', 4.0, 1.0, 1, 4.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (151, 24, 16, '编写产品测试报告', 8.0, 1.0, 1, 8.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (152, 24, 17, '编写选型报告', 12.0, 1.0, 1, 12.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (153, 24, 18, '选型缺陷跟踪修正 ', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (154, 25, 10, '选型需求调研', 5.0, 1.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (155, 25, 11, '选型产品在公司现有应用及行业市场考察', 10.0, 1.0, 1, 10.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (156, 25, 12, '选型产品的系统结构及技术参数调研', 10.0, 1.0, 1, 10.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (157, 25, 13, '供应商实力及应用案例等考察（网站电话邮件形式沟通，考察供应商数目*4h）', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (158, 25, 14, '技术参数对比（考察产品种数*4h）', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (159, 25, 15, '产品测试（测试产品个数*4h）', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (160, 25, 16, '编写产品测试报告', 8.0, 1.0, 1, 8.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (161, 25, 17, '编写选型报告', 12.0, 1.0, 1, 12.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (162, 25, 18, '选型缺陷跟踪修正 ', 5.0, 1.0, 1, 5.0, 0.0, 0, 0);

-- ----------------------------
-- Table structure for assignprojectlist
-- ----------------------------
DROP TABLE IF EXISTS `assignprojectlist`;
CREATE TABLE `assignprojectlist`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `userID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `assignDate` datetime(0) NOT NULL COMMENT '分配时间',
  `projectType` int NULL DEFAULT NULL COMMENT '项目类型',
  `projectName` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '项目名称',
  `process` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '完成度',
  `assignerID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '分配人',
  `totalWorkTime` float(10, 1) NOT NULL DEFAULT 0.0 COMMENT '总工时数',
  `gettedWorkTime` float(10, 1) NOT NULL DEFAULT 0.0 COMMENT '已获得工时数',
  `isFilled` tinyint NOT NULL DEFAULT 0 COMMENT '当月是否已填报',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '是否废弃',
  `projectLevel` tinyint NOT NULL DEFAULT 1 COMMENT '项目级别',
  `reviewStatus` tinyint NOT NULL DEFAULT 1 COMMENT '审核状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of assignprojectlist
-- ----------------------------
INSERT INTO `assignprojectlist` VALUES (1, 8, '2020-12-24 14:04:42', 172, 'BA系统选型', 0.0, 15, 57.0, 0.0, 0, 1, 2, 1);
INSERT INTO `assignprojectlist` VALUES (2, 15, '2020-12-24 14:06:24', 4, '绩效管理系统交流', 100.0, 15, 2.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (3, 15, '2020-12-24 14:17:04', 4, '制定资产配置标准/系统', 0.0, 15, 10.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (4, 29, '2020-12-24 14:17:20', 5, '测试项目', 0.0, 33, 20.0, 0.0, 0, 1, 1, 0);
INSERT INTO `assignprojectlist` VALUES (5, 15, '2020-12-24 14:19:13', 5, '测试项目', 0.0, 33, 0.8, 0.0, 1, 1, 1, 0);
INSERT INTO `assignprojectlist` VALUES (6, 15, '2020-12-24 15:03:31', 172, '选型测试', 0.0, 15, 37.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (7, 33, '2020-12-25 08:19:04', 5, '融合通信初步建设思路汇报', 0.0, 33, 50.0, 0.0, 0, 1, 3, 0);
INSERT INTO `assignprojectlist` VALUES (8, 33, '2020-12-25 08:49:28', 5, '融合通信建设思路汇报', 0.0, 33, 230.0, 0.0, 0, 1, 3, 0);
INSERT INTO `assignprojectlist` VALUES (9, 8, '2020-12-25 13:40:14', 173, '总部大厦智能化工程', 0.3, 15, 1990.0, 0.0, 1, 1, 4, 1);
INSERT INTO `assignprojectlist` VALUES (10, 8, '2020-12-25 13:40:44', 213, '安防门禁系统建设', 0.0, 15, 430.0, 0.0, 1, 1, 3, 1);
INSERT INTO `assignprojectlist` VALUES (11, 8, '2020-12-25 13:41:31', 249, 'AOC三楼综合布线', 0.0, 15, 20.0, 0.0, 0, 1, 2, 1);
INSERT INTO `assignprojectlist` VALUES (12, 8, '2020-12-25 13:41:51', 172, 'BA系统选型', 0.0, 15, 62.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (13, 31, '2020-12-25 15:24:37', 5, '融合通信建设思路汇报', 0.0, 33, 1.0, 0.0, 0, 1, 3, 0);
INSERT INTO `assignprojectlist` VALUES (14, 33, '2020-12-25 15:33:22', 5, '融合通信建设思路汇报', 0.0, 33, 220.0, 0.0, 1, 0, 3, 0);
INSERT INTO `assignprojectlist` VALUES (15, 8, '2020-12-25 15:45:05', 4, '通信工程处12月份处例会', 100.0, 8, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (16, 8, '2020-12-25 15:51:10', 4, '组织BA系统培训', 0.0, 8, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (17, 11, '2020-12-25 16:43:50', 5, '总部大厦基建智能化项目', 0.0, 11, 105.0, 0.0, 1, 0, 3, 0);
INSERT INTO `assignprojectlist` VALUES (18, 17, '2020-12-25 17:11:11', 173, '总部', 0.0, 17, 1990.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (19, 11, '2020-12-25 17:12:20', 5, '企业展厅供应商考察及案例参观', 0.0, 11, 1.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (20, 11, '2020-12-25 17:14:25', 4, '企业展厅供应商考察及案例参观', 0.0, 11, 6.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (21, 11, '2020-12-25 17:23:33', 5, '2020年12月日常事务', 33.3, 11, 23.5, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (22, 11, '2020-12-25 17:36:10', 5, '智能化各系统现场检查单编制', 0.0, 11, 50.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (23, 15, '2020-12-26 21:02:57', 4, '1234', 0.0, 15, 10.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (24, 15, '2020-12-26 22:43:40', 172, '1111', 0.0, 15, 62.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (25, 15, '2020-12-27 14:56:13', 172, '综合布线选型', 0.0, 13, 62.0, 0.0, 0, 0, 1, 1);

-- ----------------------------
-- Table structure for monthprocess
-- ----------------------------
DROP TABLE IF EXISTS `monthprocess`;
CREATE TABLE `monthprocess`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `aPDID` int UNSIGNED NOT NULL COMMENT '指派项目明细外键',
  `year` year NOT NULL COMMENT '年份',
  `type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '进展类型',
  `January` float(6, 1) UNSIGNED NULL DEFAULT 0.0 COMMENT '1月',
  `February` float(6, 1) UNSIGNED NULL DEFAULT NULL COMMENT '2月',
  `March` float(6, 1) UNSIGNED NULL DEFAULT NULL COMMENT '3月',
  `April` float(6, 1) UNSIGNED NULL DEFAULT NULL COMMENT '4月',
  `May` float(6, 1) UNSIGNED NULL DEFAULT NULL COMMENT '5月',
  `June` float(6, 1) UNSIGNED NULL DEFAULT NULL COMMENT '6月',
  `July` float(6, 1) UNSIGNED NULL DEFAULT NULL COMMENT '7月',
  `August` float(6, 1) UNSIGNED NULL DEFAULT NULL COMMENT '8月',
  `September` float(6, 1) UNSIGNED NULL DEFAULT NULL COMMENT '9月',
  `October` float(6, 1) UNSIGNED NULL DEFAULT NULL COMMENT '10月',
  `November` float(6, 1) UNSIGNED NULL DEFAULT 0.0 COMMENT '11月',
  `December` float(6, 1) UNSIGNED NULL DEFAULT 0.0 COMMENT '12月',
  `PreMonth` float(6, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '上一月份进展',
  `obsoleteStatus` float(6, 1) NOT NULL DEFAULT 0.0 COMMENT '废弃状态 ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of monthprocess
-- ----------------------------
INSERT INTO `monthprocess` VALUES (1, 9, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (2, 9, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (3, 10, 2021, 'plan', 80.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (4, 12, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (5, 12, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (6, 10, 2020, 'fact', 20.0, 30.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (7, 19, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (8, 20, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (9, 21, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (10, 22, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (11, 23, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.0, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (12, 100, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0.0);
INSERT INTO `monthprocess` VALUES (13, 59, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 90.0, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (14, 102, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0.0);
INSERT INTO `monthprocess` VALUES (15, 23, 2021, 'plan', 50.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (16, 101, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0.0);
INSERT INTO `monthprocess` VALUES (17, 105, 2020, 'plan', 10.0, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (18, 106, 2020, 'plan', NULL, NULL, 12.0, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1.0);
INSERT INTO `monthprocess` VALUES (19, 140, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0.0);
INSERT INTO `monthprocess` VALUES (20, 140, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0.0);
INSERT INTO `monthprocess` VALUES (21, 141, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0.0);
INSERT INTO `monthprocess` VALUES (22, 140, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0.0);

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 18 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
  `workTime` float(6, 1) NOT NULL DEFAULT 0.0 COMMENT '工时数',
  `dynamicKValue` tinyint NOT NULL DEFAULT 0 COMMENT 'K值是否可变',
  `isConference` tinyint NOT NULL DEFAULT 0 COMMENT '是否为会议类型',
  `defaultAssignWorkTime` float(6, 1) NOT NULL DEFAULT 0.0 COMMENT '默认协助工时',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '是否废弃',
  PRIMARY KEY (`projectTypeID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 380 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of projecttypenew
-- ----------------------------
INSERT INTO `projecttypenew` VALUES (1, '技术标准组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (2, '工程组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (3, '通信组工时', -1, 1, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (4, '其他标准项目', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (5, '其他非标项目', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (6, '技术标准组相关', 4, 3, 0.0, 0, 0, 0.0, 0);
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
INSERT INTO `projecttypenew` VALUES (19, '系统建设标准制定', 6, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (20, '前期调研', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (21, '资产配置标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (22, '系统设计标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (23, '系统施工规范', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (24, '审图检查单', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (25, '工作流程标准', 19, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (26, '沟通用户和运维单位，汇总问题和意见/系统', 20, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (27, '制定资产配置标准/系统', 21, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (28, '修订资产配置标准/系统', 21, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (29, '牵头修订资产配置标准', 21, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (30, '制定系统设计标准/系统', 22, 5, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (31, '修订系统设计标准/系统', 22, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (32, '牵头修订系统配置标准', 22, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (33, '制定系统施工规范/系统', 23, 5, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (34, '修订系统施工规范/系统', 23, 5, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (35, '牵头修订系统施工规范', 23, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (36, '制定审图检查单/系统', 24, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (37, '修订审图检查单/系统', 24, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (38, '制定工作流程标准/流程', 25, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (39, '修订工作流程标准/流程', 25, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (40, '党团工作', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (41, '培训学习', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (42, '文档总结', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (43, '科室信息搜集', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (44, '工作会议', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (45, '工作规范管理', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (46, '出差行程单', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (47, '系统运维管理', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (48, '创新课题评奖', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (49, '组织活动/参赛', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (50, '宣传', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (51, '培训/知识分享', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (52, '工作饱和度', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (53, '评先评优', 267, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (54, '工时扣罚', 4, 3, 0.0, 0, 0, 0.0, 0);
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
INSERT INTO `projecttypenew` VALUES (72, '自定义项目阶段', 5, 3, 1.0, 1, 0, 0.0, 0);
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
INSERT INTO `projecttypenew` VALUES (87, '市内行程单', 46, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (88, '省内行程单', 46, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (89, '国内行程单', 46, 4, 6.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (90, '国际行程单', 46, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (91, '配合进行系统检查、完成信息填报', 332, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (92, '月度巡检', 332, 4, 1.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (93, '季度巡检', 332, 4, 2.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (94, '工单', 47, 4, 1.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (95, '流程审核', 47, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (96, '故障处置（工作日）', 47, 4, 3.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (97, '配置变更测试', 332, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (98, '配置变更流程', 332, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (99, '配置变更通告', 332, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (100, '系统日常维护', 332, 4, 3.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (101, '系统航后维护(公司现场)', 332, 4, 6.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (102, '合同续签', 47, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (103, '防台风准备工作', 47, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (104, '重保航班保障/次', 332, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (105, '应急响应（AOC集结）', 332, 4, 8.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (106, '项目尾款支付', 47, 4, 2.0, 0, 0, 0.0, 0);
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
INSERT INTO `projecttypenew` VALUES (125, '因个人原因导致本处绩效减分', 54, 4, -50.0, 1, 1, -50.0, 0);
INSERT INTO `projecttypenew` VALUES (126, '不服从管理人员工作安排，与管理人员、其他同事发生冲突造成不良影响的', 54, 4, -50.0, 1, 1, -50.0, 0);
INSERT INTO `projecttypenew` VALUES (127, '因个人原因导致审计问题', 54, 4, -200.0, 0, 1, -200.0, 0);
INSERT INTO `projecttypenew` VALUES (128, '考勤异常，在部门通报后补办手续的', 54, 4, -10.0, 0, 1, -10.0, 0);
INSERT INTO `projecttypenew` VALUES (129, '个人原因使得处室绩效加分', 54, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (130, '在工作中及时发现存在的问题，风险点，并被处室/部门/公司采纳', 54, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (131, '个人受用户/部门/公司领导表扬', 54, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (132, '个人受用户投诉或者部门/公司领导批评', 54, 4, -10.0, 1, 1, -10.0, 0);
INSERT INTO `projecttypenew` VALUES (133, '未在每月第二个工作日前制定月度工作计划', 54, 4, -10.0, 0, 1, -10.0, 0);
INSERT INTO `projecttypenew` VALUES (134, '未按照要求进行项目/任务完成情况反馈', 54, 4, -10.0, 0, 1, -10.0, 0);
INSERT INTO `projecttypenew` VALUES (135, '系统建设规划', 6, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (136, '编写智能化系统建设规划，并完成汇报，明确具体规划方案', 135, 4, 40.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (137, '完成特殊任务方案汇报', 135, 4, 40.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (138, '系统建设管理', 6, 3, 0.0, 0, 0, 0.0, 0);
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
INSERT INTO `projecttypenew` VALUES (150, '预算编制', 6, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (151, '采购类项目预算编制', 150, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (152, '基建类项目预算编制', 150, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (153, '创新探索', 6, 3, 0.0, 0, 0, 0.0, 0);
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
INSERT INTO `projecttypenew` VALUES (204, '智能化隐蔽工程检查及验收', 199, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (205, '设备安装及系统调试阶段现场管理', 199, 4, 250.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (206, '验收交接', 173, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (207, '智能化初步验收及搬迁配合', 206, 4, 100.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (208, '项目试运行及整改', 206, 4, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (209, '智能化系统培训', 206, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (210, '项目正式验收', 206, 4, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (211, '项目移交', 206, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (212, '项目总结', 206, 4, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (213, '基础平台类(工程组)', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (214, '项目策划', 213, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (215, '筹建项目组及项目评估', 214, 4, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (216, '需求调研及编写需求报告\r\n确定目标、范围和入围产品要求', 214, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (217, '编写启动分析报告', 214, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (218, '供应商预推荐及考察', 214, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (219, '报季度采购沟通会', 214, 4, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (220, '季度计划外采购申请', 214, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (221, '启动评审', 214, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (222, '选型测试与考察', 213, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (223, '产品测试/产品选型/服务考察', 222, 4, 15.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (224, '增补IT供应商考察及审批流程（可选）', 222, 4, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (225, '选型方案/测试方案/服务考察方案评审', 222, 4, 15.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (226, '技术方案编审', 222, 4, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (227, '技术评审', 222, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (228, '采购招标', 213, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (229, '发起采购沟通会', 228, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (230, '三重一大议题申报流程(可选）', 228, 4, 30.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (231, '单一来源/品牌采购申请流程(可选)', 228, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (232, '采购需求审批', 228, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (233, '预算执行申请', 228, 4, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (234, '采购评审会', 228, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (235, '合同会签和归档', 228, 4, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (236, '下单采购', 228, 4, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (237, '实施与试运行', 213, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (238, '实施交底及制定实施方案等', 237, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (239, '设备到货验收', 237, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (240, '项目实施及现场管理', 237, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (241, '编写运维手册', 237, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (242, '组织用户使用和运维培训', 237, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (243, '试运行及督促整改', 237, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (244, '验收交接', 213, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (245, '组织验收', 244, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (246, '项目验收评审', 244, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (247, '系统移交和归档', 244, 4, 20.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (248, '项目总结', 244, 4, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (249, '修缮类', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (250, '需求调研', 249, 3, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (251, '方案设计', 249, 3, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (252, '组织施工', 249, 3, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (253, '验收交接', 249, 3, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (254, '付款', 274, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (255, '办理预付款及保函验真', 254, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (256, '工程进度款审核及支付', 254, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (257, '造价咨询、代理、设计费用支付', 254, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (258, '施工阶段', 274, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (259, '工程量清单复核', 258, 5, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (260, '项目配套专线光纤工程', 258, 5, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (261, '工程联系单', 258, 5, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (262, '工程结算', 258, 5, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (263, '设计变更、方案变更', 258, 5, 10.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (264, '工程签证', 258, 5, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (265, '项目运行阶段', 274, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (266, '项目回访', 265, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (267, '事务类工作', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (268, ' 项目计划变更', 274, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (269, '呈批件审批', 274, 4, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (270, '方案汇报（重要事向公司领导汇报等）', 274, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (271, '补充协议', 274, 4, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (272, '进度、重点任务反馈', 274, 4, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (273, '项目风险评估', 274, 4, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (274, '工程组相关', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (275, '基础平台类(通信组)', 0, 2, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (276, '系统集成、纯设备采购', 275, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (277, '项目策划', 276, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (278, '制定年度计划', 277, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (279, '编写《项目评估表》', 277, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (280, '组织项目评估并提交项目评估结论流程', 277, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (281, '编写《简要采购需求》', 277, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (282, '编写《推荐供应商清单》', 277, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (283, '提交供应商预推荐流程', 277, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (284, '季度采购计划申请', 277, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (285, '提交季度计划外采购申请流程（可选）', 277, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (286, '供应商考察', 277, 5, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (287, '提交供应商考察流程', 277, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (288, '编写《需求报告》', 277, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (289, '编写《项目启动分析报告》', 277, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (290, '编写《供应商考察报告》', 277, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (291, '提交项目启动评审流程', 277, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (292, '召开启动评审会', 277, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (293, 'IT管理平台中录入项目计划', 277, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (294, '产品选型/产品测试/服务考察', 276, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (295, '编写《产品选型方案/产品测试方案/服务考察方案》', 294, 5, 50.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (296, '编写《缺陷跟踪审核表》', 294, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (297, '提交选型方案/测试方案/服务考察方案评审流程', 294, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (298, '产品测试/产品选型/服务考察', 294, 5, 100.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (299, '提交增补IT供应商审批流程（可选）', 294, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (300, '初步采购沟通，编写《产品选型报告/产品测试报告/服务考察报告》', 294, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (301, '编写《技术服务要求》', 294, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (302, '编写《评分表》', 294, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (303, '编写《商务条款建议》', 294, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (304, '提交项目技术评审流程', 294, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (305, '召开技术评审会', 294, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (306, '项目采购', 276, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (307, '组织采购沟通会（可选）', 306, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (308, '编写《三重一大会议PPT》（可选）', 306, 5, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (309, '编写《三重一大会议纪要》（可选）', 306, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (310, '召开三重一大会议（可选）', 306, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (311, '提交单一来源/单一品牌采购申请（可选）', 306, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (312, '编写《采购沟通结论表》', 306, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (313, '提交采购需求审批流程', 306, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (314, '编写《设备清单》', 306, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (315, '编写《预算执行申请表》', 306, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (316, '提交预算执行申请流程', 306, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (317, '采购评审及合同会签', 306, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (318, '项目实施', 276, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (319, '项目整体实施', 318, 5, 70.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (320, '后端部署', 318, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (321, '前端部署', 318, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (322, '试运行', 276, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (323, '试运行', 322, 5, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (324, '验收交接', 276, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (325, '编写《到货入库单》', 324, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (326, '编写《验收报告》', 324, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (327, '编写《用户意见》', 324, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (328, '提交项目验收评审流程', 324, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (329, '编写《运维手册》', 324, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (330, '进行用户培训', 324, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (331, '提交项目交接流程', 324, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (332, '通信组相关', 4, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (333, '维保及技术服务类', 275, 3, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (334, '项目策划', 333, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (335, '制定年度计划', 334, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (336, '编写《项目评估表》', 334, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (337, '组织项目评估并提交项目评估结论流程', 334, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (338, '编写《简要采购需求》', 334, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (339, '编写《推荐供应商清单》', 334, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (340, '提交供应商预推荐流程', 334, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (341, '季度采购计划申请', 334, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (342, '提交季度计划外采购申请流程（可选）', 334, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (343, '供应商考察', 334, 5, 50.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (344, '提交供应商考察流程', 334, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (345, '编写《需求报告》', 334, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (346, '编写《项目启动分析报告》', 334, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (347, '编写《供应商考察报告》', 334, 5, 20.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (348, '提交项目启动评审流程', 334, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (349, '召开启动评审会', 334, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (350, 'IT管理平台中录入项目计划', 334, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (351, '项目采购', 333, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (352, '组织采购沟通会（可选）', 351, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (353, '编写《三重一大会议PPT》（可选）', 351, 5, 30.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (354, '编写《三重一大会议纪要》（可选）', 351, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (355, '召开三重一大会议（可选）', 351, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (356, '提交单一来源/单一品牌采购申请（可选）', 351, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (357, '编写《采购沟通结论表》', 351, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (358, '提交采购需求审批流程', 351, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (359, '编写《设备清单》', 351, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (360, '编写《预算执行申请表》', 351, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (361, '提交预算执行申请流程', 351, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (362, '采购评审及合同会签', 351, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (363, '验收交接', 333, 4, 0.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (364, '编写《到货入库单》', 363, 5, 5.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (365, '编写《验收报告》', 363, 5, 10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (366, '编写《用户意见》', 363, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (367, '提交项目验收评审流程', 363, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (368, '编写《运维手册》', 363, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (369, '进行用户培训', 363, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (370, '提交项目交接流程', 363, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (371, '故障处置(周末)', 47, 5, 6.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (372, '故障处置(法定节假日)', 47, 5, 9.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (373, '系统航后维护(家中)', 332, 5, 4.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (374, '重保保障(白班监听)/天', 332, 5, 7.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (375, '重保保障(晚班监听)/天', 332, 5, 15.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (376, '法定节假日厦门本地待命（A角）/天', 332, 5, 7.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (377, '法定节假日待命（B角）/天', 332, 5, 3.8, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (378, '非法定节假日厦门本地待命（A角）/天', 332, 5, 3.8, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (379, '非法定节假日待命（B角）/天', 332, 5, 1.9, 0, 0, 0.0, 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 173 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (7, '00984', 1, 1, '白洋', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (8, '30894', 1, 1, '陈迪', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (9, '12148', 1, 3, '陈晓峰', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (10, '00808', 1, 3, '傅霖晖', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (11, '02031', 1, 2, '郭红生', 3, '3769ef0dfe4c4c761c958a00d8161930', '1', 0);
INSERT INTO `users` VALUES (12, '12690', 1, 3, '顾心瑜', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (13, '13885', 1, 1, '黄雅婷', 2, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (14, '27815', 1, 1, '胡章荣', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (15, '31345', 1, 1, '江黄能', 1, '090f3febf40ccbf7c0f06aa40b54e04f', '1', 1);
INSERT INTO `users` VALUES (16, '02478', 1, 2, '匡卫民', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (17, '10698', 1, 2, '连祎文', 2, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (18, '22356', 1, 3, '李俊炎', 3, '4c4d2e597922e58b6abc692cadd3669c', '1', 1);
INSERT INTO `users` VALUES (19, '23940', 1, 2, '李培育', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (20, '22303', 1, 2, '刘佳彬', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (21, '28494', 1, 1, '刘向前', 3, 'e10adc3949ba59abbe56e057f20f883e', '0', 1);
INSERT INTO `users` VALUES (22, '01712', 1, 2, '罗茂海', 3, '243bbce90a557dbc89fec91d8a263e8d', '1', 0);
INSERT INTO `users` VALUES (23, '22410', 1, 1, '彭荣茂', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (24, '20084', 1, 2, '秦言擎', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (25, '12681', 1, 2, '王伟强', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (26, '03515', 1, 4, '王喻强', 1, '19204dbb26a7897524a495e4292bb0a3', '1', 1);
INSERT INTO `users` VALUES (27, '20787', 1, 1, '吴冬晖', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (28, '28616', 1, 2, '吴一鹏', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (29, '25715', 1, 3, '许尖钻', 3, 'd22a295a1b0343f32bea478e0c2fec4d', '1', 1);
INSERT INTO `users` VALUES (30, '22152', 1, 2, '杨宇辰', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (31, '00813', 1, 3, '颜河生', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (32, '28689', 1, 2, '赵帅', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (33, '16600', 1, 3, '邹涛', 2, '49401fa4e156ca887ced41f03331098c', '1', 1);

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
) ENGINE = InnoDB AUTO_INCREMENT = 27 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci COMMENT = '周报表' ROW_FORMAT = DYNAMIC;

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
  `userID` int UNSIGNED NOT NULL COMMENT '参与人员外键',
  `projectID` int UNSIGNED NOT NULL COMMENT '参与项目外键',
  `workTime` float(6, 1) NOT NULL COMMENT '分配的工时数',
  `reviewWorkTime` float(6, 1) NULL DEFAULT NULL COMMENT '审核的工时数',
  `assignRole` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '参与人员角色',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of worktimeassign
-- ----------------------------
INSERT INTO `worktimeassign` VALUES (1, 15, 1, 2.0, 2.0, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (2, 13, 1, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (3, 33, 1, 1.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (4, 15, 2, 8.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (5, 15, 3, 8.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (6, 15, 4, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (7, 15, 5, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (8, 15, 6, 0.8, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (9, 15, 7, 6.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (10, 33, 8, 50.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (11, 33, 9, 50.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (12, 33, 10, 100.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (13, 33, 11, 80.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (14, 33, 12, 50.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (15, 33, 13, 100.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (16, 33, 14, 80.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (17, 33, 15, 25.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (18, 29, 15, 25.0, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (19, 8, 16, 2.0, 2.0, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (20, 33, 17, 20.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (21, 31, 17, 50.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (22, 18, 17, 25.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (23, 27, 17, 25.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (24, 9, 17, 40.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (25, 12, 17, 40.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (26, 29, 17, 20.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (27, 8, 18, 2.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (28, 7, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (29, 9, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (30, 10, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (31, 11, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (32, 12, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (33, 13, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (34, 14, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (35, 15, 18, 1.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (36, 16, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (37, 17, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (38, 18, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (39, 19, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (40, 20, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (41, 22, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (42, 23, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (43, 24, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (44, 25, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (45, 27, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (46, 28, 18, 0.0, 0.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (47, 29, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (48, 30, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (49, 31, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (50, 32, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (51, 33, 18, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (52, 8, 19, 17.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (53, 9, 19, 1.0, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (54, 8, 20, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (55, 8, 21, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (56, 11, 22, 50.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (57, 13, 22, 40.0, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (58, 11, 23, 15.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (59, 11, 24, 12.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (60, 11, 25, 18.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (61, 11, 26, 1.5, 1.5, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (62, 11, 27, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (63, 11, 28, 20.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (64, 11, 29, 10.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (65, 15, 30, 10.0, NULL, '组织者', 1);

-- ----------------------------
-- Table structure for worktimelist
-- ----------------------------
DROP TABLE IF EXISTS `worktimelist`;
CREATE TABLE `worktimelist`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `apdID` int NOT NULL DEFAULT 0 COMMENT '对应的项目明细ID',
  `aplID` int NOT NULL DEFAULT 0 COMMENT '对应的项目列表ID',
  `monthID` int NULL DEFAULT NULL COMMENT '对应的月份进展ID',
  `submitID` int UNSIGNED NOT NULL COMMENT '申报人ID',
  `projectTypeID` int NOT NULL COMMENT '项目类型ID',
  `applyKValue` double(5, 1) NOT NULL COMMENT '申报K值',
  `reviewKValue` double(5, 1) NULL DEFAULT NULL COMMENT '审核K值',
  `applyCofficient` double(5, 1) NOT NULL COMMENT '申报系数',
  `reviewCofficient` double(5, 1) NULL DEFAULT NULL COMMENT '审核系数',
  `submitTime` datetime(0) NOT NULL COMMENT '提交时间',
  `updateTime` datetime(0) NOT NULL COMMENT '更新时间',
  `applyMonth` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申报月份',
  `submitStatus` tinyint NOT NULL COMMENT '提交状态',
  `submitComments` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交备注',
  `reviewStatus` tinyint NOT NULL DEFAULT 0 COMMENT '审核状态',
  `reviewTime` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `reviewComments` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '审核备注',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态',
  `workTimeAssignReviewStatus` tinyint NOT NULL DEFAULT 0 COMMENT '工时分配审核状态',
  `reviewer` int UNSIGNED NULL DEFAULT 0 COMMENT '审核人',
  `avaiableWorkTime` float(5, 1) NOT NULL DEFAULT 0.0 COMMENT '可用工时',
  `applyProcess` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '申报进展',
  `lastProcess` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '上月进展',
  `applyType` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '申报类型',
  `applyBaseWorkTime` float(6, 1) NOT NULL COMMENT '申报的基本工时（非标项目使用）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of worktimelist
-- ----------------------------
INSERT INTO `worktimelist` VALUES (1, 9, 2, NULL, 15, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-24 14:06:24', '2020-12-24 14:06:24', '2020-12', 1, '', 1, '2020-12-24 14:13:53', '', 1, 1, 15, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (2, 10, 3, NULL, 15, 27, 1.0, NULL, 1.0, NULL, '2020-12-24 14:17:04', '2020-12-24 14:17:04', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 8.0, 80.0, 0.0, 'plan', 10.0);
INSERT INTO `worktimelist` VALUES (3, 10, 3, NULL, 15, 27, 1.0, NULL, 1.0, NULL, '2020-12-24 14:17:58', '2020-12-24 14:18:18', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 8.0, 80.0, 0.0, 'fact', 10.0);
INSERT INTO `worktimelist` VALUES (4, 12, 5, 4, 15, 72, 1.0, NULL, 1.0, NULL, '2020-12-24 14:20:44', '2020-12-24 14:20:44', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'plan', 1.0);
INSERT INTO `worktimelist` VALUES (5, 12, 5, 5, 15, 72, 1.0, NULL, 1.0, NULL, '2020-12-24 14:21:02', '2020-12-24 14:21:02', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (6, 12, 5, 4, 15, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-24 14:31:20', '2020-12-24 14:31:51', '2020-12', 1, '', 2, '2020-12-24 15:04:24', '', 1, 0, 15, 0.8, 80.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (7, 13, 6, NULL, 15, 13, 1.5, NULL, 1.0, NULL, '2020-12-24 15:03:31', '2020-12-24 15:03:31', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 6.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (8, 19, 7, NULL, 33, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 08:19:04', '2020-12-25 08:19:04', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 50.0, 100.0, 0.0, 'plan', 50.0);
INSERT INTO `worktimelist` VALUES (9, 19, 7, NULL, 33, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 08:19:24', '2020-12-25 08:19:24', '2021-01', 0, '', 0, NULL, '', 1, 0, NULL, 50.0, 100.0, 0.0, 'fact', 50.0);
INSERT INTO `worktimelist` VALUES (10, 20, 8, NULL, 33, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 08:49:28', '2020-12-25 08:49:28', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 100.0, 100.0, 0.0, 'plan', 100.0);
INSERT INTO `worktimelist` VALUES (11, 21, 8, NULL, 33, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 08:49:28', '2020-12-25 08:49:28', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 80.0, 100.0, 0.0, 'plan', 80.0);
INSERT INTO `worktimelist` VALUES (12, 22, 8, NULL, 33, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 08:49:28', '2020-12-25 08:49:28', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 50.0, 100.0, 0.0, 'plan', 50.0);
INSERT INTO `worktimelist` VALUES (13, 20, 8, NULL, 33, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 08:50:03', '2020-12-25 08:50:03', '2021-01', 0, '', 0, NULL, '', 1, 0, NULL, 100.0, 100.0, 0.0, 'fact', 100.0);
INSERT INTO `worktimelist` VALUES (14, 21, 8, NULL, 33, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 08:50:05', '2020-12-25 08:50:05', '2021-01', 0, '', 0, NULL, '', 1, 0, NULL, 80.0, 100.0, 0.0, 'fact', 80.0);
INSERT INTO `worktimelist` VALUES (15, 22, 8, NULL, 33, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 08:50:06', '2020-12-25 08:51:21', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 50.0, 100.0, 0.0, 'fact', 50.0);
INSERT INTO `worktimelist` VALUES (16, 23, 9, 11, 8, 175, 1.0, 1.0, 1.0, 1.0, '2020-12-25 13:46:04', '2020-12-25 13:46:10', '2020-11', 1, '', 1, '2020-12-25 13:46:26', '', 1, 1, 15, 2.0, 10.0, 0.0, 'fact', 20.0);
INSERT INTO `worktimelist` VALUES (17, 100, 14, NULL, 33, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 15:33:22', '2020-12-25 15:33:22', '2021-01', 1, '以向部门领导进行汇报为目标。项目经理为颜河生，功能平台建设内容由颜河生、李俊炎、吴冬晖协助；终端选型内容由陈晓峰、顾心瑜协助；信号覆盖内容由邹涛、许尖钻协助。', 0, NULL, '', 0, 0, NULL, 220.0, 100.0, 0.0, 'plan', 220.0);
INSERT INTO `worktimelist` VALUES (18, 101, 15, 16, 8, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-25 15:45:05', '2020-12-25 15:45:05', '2020-12', 1, '', 1, '2020-12-25 16:32:03', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (19, 59, 10, 13, 8, 218, 1.0, NULL, 1.0, NULL, '2020-12-25 15:48:00', '2020-12-25 15:48:46', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 18.0, 90.0, 0.0, 'fact', 20.0);
INSERT INTO `worktimelist` VALUES (20, 102, 16, NULL, 8, 68, 1.0, NULL, 1.0, NULL, '2020-12-25 15:51:10', '2020-12-25 15:51:10', '2021-01', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'plan', 3.0);
INSERT INTO `worktimelist` VALUES (21, 23, 9, 15, 8, 175, 1.0, NULL, 1.0, NULL, '2020-12-25 15:54:06', '2020-12-25 15:54:06', '2021-01', 0, '', 0, NULL, '', 1, 0, NULL, 10.0, 50.0, 0.0, 'plan', 20.0);
INSERT INTO `worktimelist` VALUES (22, 103, 17, NULL, 11, 72, 3.0, NULL, 1.0, NULL, '2020-12-25 16:43:50', '2020-12-25 16:43:50', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 90.0, 30.0, 0.0, 'fact', 100.0);
INSERT INTO `worktimelist` VALUES (23, 104, 17, NULL, 11, 72, 3.0, NULL, 1.0, NULL, '2020-12-25 16:43:50', '2020-12-25 16:43:50', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 15.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (24, 138, 19, NULL, 11, 72, 1.0, NULL, 12.0, NULL, '2020-12-25 17:12:20', '2020-12-25 17:12:20', '2020-12', 1, '1、上海风语筑文化科技股份有限公司参观考察。\n2、风语筑上海市工人文化宫案例进行参观。\n3、上海市飞来飞去展览设计工程有限公司考察交流。\n4、飞来飞去杭州海康威视案例进行参观。\n5、华为深圳机场智慧机场展厅参观考察。\n6、深圳机场党群服务中心展厅。\n7、参观深圳中视动科技总部。\n8、参观深圳中视动科技大潮起珠江展馆。\n9、参观深圳城市规划展厅。\n10、参观北京雪格案例深圳微银行展厅。\n11、参观福州高铭铁塔公司展厅。\n12、参观福州三坊七巷展馆。', 0, NULL, '', 0, 0, NULL, 12.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (25, 139, 20, NULL, 11, 89, 1.0, NULL, 3.0, NULL, '2020-12-25 17:14:25', '2020-12-25 17:14:25', '2020-12', 1, '1、20201202厦门到上海、上海到杭州\n2、20201203杭州到深圳\n3、20201204深圳到福州、福州到厦门（动车）', 0, NULL, '', 0, 0, NULL, 18.0, 100.0, 0.0, 'fact', 6.0);
INSERT INTO `worktimelist` VALUES (26, 140, 21, 22, 11, 72, 1.5, 1.5, 1.0, 1.0, '2020-12-25 17:23:33', '2020-12-25 17:23:33', '2020-12', 1, '20201207到AOC查看乘务准备室线路，讨论布线方案。', 1, '2020-12-25 17:37:16', '', 0, 1, 17, 1.5, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (27, 141, 21, NULL, 11, 72, 2.0, NULL, 1.0, NULL, '2020-12-25 17:23:33', '2020-12-25 17:29:20', '2020-12', 1, '20201224与赵帅到AOC园区说明光纤敷设管井路由', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (28, 142, 21, NULL, 11, 72, 20.0, NULL, 1.0, NULL, '2020-12-25 17:23:33', '2020-12-25 17:27:45', '2020-12', 1, '20201211-15处理整理零星修缮项目结算资料。', 0, NULL, '', 0, 0, NULL, 20.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (29, 143, 22, NULL, 11, 72, 1.0, NULL, 1.0, NULL, '2020-12-25 17:36:10', '2020-12-25 17:36:10', '2020-12', 1, '1、完成桥架图纸检查单与施工检查单。\n2、办公网与设备网点位数量检查单（完成40%）。', 0, NULL, '', 0, 0, NULL, 10.0, 20.0, 0.0, 'fact', 50.0);
INSERT INTO `worktimelist` VALUES (30, 144, 23, NULL, 15, 27, 1.0, NULL, 1.0, NULL, '2020-12-26 21:02:57', '2020-12-26 21:07:38', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 10.0, 100.0, 0.0, 'fact', 10.0);

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

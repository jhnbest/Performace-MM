/*
 Navicat Premium Data Transfer

 Source Server         : 11.22.232.34-jhn
 Source Server Type    : MySQL
 Source Server Version : 80022
 Source Host           : 11.22.232.34:3306
 Source Schema         : workTimeMM

 Target Server Type    : MySQL
 Target Server Version : 80022
 File Encoding         : 65001

 Date: 29/12/2020 17:32:08
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
) ENGINE = InnoDB AUTO_INCREMENT = 374 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `assignprojectdetail` VALUES (102, 16, 68, '组织培训', 3.0, 1.0, 1, 3.0, 0.0, 1, 0);
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
INSERT INTO `assignprojectdetail` VALUES (138, 19, 72, '总部大厦企业展厅供应商考察', 1.0, 1.0, 12, 12.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (139, 20, 89, '国内行程单', 6.0, 1.0, 3, 18.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (140, 21, 72, '与李培育到AOC现场勘查乘务准备室布线线路', 1.0, 1.5, 1, 1.5, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (141, 21, 72, '与赵帅到AOC现场勘查光纤敷设线路', 1.0, 2.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (142, 21, 72, '纵宇修缮项目审核与资料整理', 1.0, 20.0, 1, 20.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (143, 22, 72, '智能化各系统现场检查单编制', 50.0, 1.0, 1, 10.0, 20.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (144, 23, 125, '因个人原因导致本处绩效减分', -50.0, 1.0, 1, -50.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (145, 24, 72, '用户反馈地下室识别率较低，经排查问题，协调增加灯板，优化摄像机配置，提高了识别率。', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (146, 25, 81, '组织技术交流', 2.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (147, 26, 72, '参加华为智慧屏品鉴会', 3.0, 1.0, 1, 3.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (148, 27, 72, '自定义项目阶段', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (149, 28, 81, '组织技术交流', 2.0, 1.0, 5, 10.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (150, 29, 31, '修订系统设计标准/系统', 10.0, 1.0, 1, 5.0, 50.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (151, 30, 31, '修订系统设计标准/系统', 10.0, 1.0, 1, 10.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (152, 31, 250, '需求调研', 5.0, 1.5, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (153, 31, 251, '方案设计', 5.0, 2.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (154, 31, 252, '组织施工', 5.0, 2.5, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (155, 31, 253, '验收交接', 5.0, 2.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (156, 32, 250, '需求调研', 5.0, 1.5, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (157, 32, 251, '方案设计', 5.0, 2.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (158, 32, 252, '组织施工', 5.0, 4.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (159, 32, 253, '验收交接', 5.0, 2.5, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (160, 33, 89, '国内行程单', 6.0, 1.0, 1, 6.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (161, 34, 250, '需求调研', 5.0, 3.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (162, 34, 251, '方案设计', 5.0, 3.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (163, 34, 252, '组织施工', 5.0, 3.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (164, 34, 253, '验收交接', 5.0, 3.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (165, 35, 28, '修订资产配置标准/系统', 5.0, 1.0, 1, 2.5, 50.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (166, 36, 316, '提交预算执行申请流程', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (167, 37, 31, '修订系统设计标准/系统', 10.0, 1.0, 1, 10.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (168, 38, 32, '牵头修订系统配置标准', 20.0, 1.0, 1, 20.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (169, 39, 87, '市内行程单', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (170, 40, 64, '制作培训教材', 10.0, 1.0, 1, 10.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (171, 41, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (172, 42, 65, '修订培训教材', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (173, 43, 65, '修订培训教材', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (174, 44, 65, '修订培训教材', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (175, 45, 67, '制定考核内容', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (176, 46, 68, '组织培训', 3.0, 1.0, 1, 3.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (177, 47, 72, '晋江酒店项目施工进度、质量临时检查', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (178, 48, 72, '洪文空勤项目施工进度、质量临时检查', 3.0, 1.0, 1, 3.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (179, 49, 250, '需求调研', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (180, 49, 251, '方案设计', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (181, 49, 252, '组织施工', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (182, 49, 253, '验收交接', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (183, 50, 250, '需求调研', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (184, 50, 251, '方案设计', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (185, 50, 252, '组织施工', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (186, 50, 253, '验收交接', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (187, 51, 250, '需求调研', 5.0, 2.5, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (188, 51, 251, '方案设计', 5.0, 2.5, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (189, 51, 252, '组织施工', 5.0, 2.5, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (190, 51, 253, '验收交接', 5.0, 2.5, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (191, 52, 257, '造价咨询、代理、设计费用支付', 5.0, 1.0, 1, 5.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (192, 53, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (193, 54, 143, '零星智能化项目复杂需求对接', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (194, 55, 143, '零星智能化项目复杂需求对接', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (195, 56, 72, '出差深圳考察会议系统项目建设案例', 12.0, 1.0, 1, 12.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (196, 57, 144, '基建项目方案审核', 16.0, 1.0, 1, 16.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (197, 58, 68, '组织培训', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (198, 59, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (199, 60, 247, '系统移交和归档', 20.0, 1.0, 1, 20.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (200, 61, 262, '工程结算', 50.0, 1.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (201, 62, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (202, 63, 72, '头脑风暴前讨论', 1.0, 1.0, 2, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (203, 63, 72, '头脑风暴过程', 3.0, 1.0, 1, 3.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (204, 63, 72, '头脑风暴后讨论', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (205, 64, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (206, 65, 60, '组织线上会议', 0.5, 1.0, 1, 0.5, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (207, 66, 80, '组织各类型会议', 2.0, 1.0, 2, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (208, 67, 250, '需求调研', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (209, 67, 251, '方案设计', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (210, 67, 252, '组织施工', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (211, 67, 253, '验收交接', 5.0, 2.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (212, 68, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (213, 69, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (214, 70, 68, '组织培训', 3.0, 1.0, 1, 3.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (215, 71, 145, '基建项目设计变更或零星智能化项目方案审核', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (216, 72, 55, '党员学习/月', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (217, 73, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (218, 74, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (219, 75, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (220, 76, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (221, 77, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (222, 78, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (223, 79, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (224, 80, 88, '省内行程单', 4.0, 1.0, 1, 16.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (225, 81, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (226, 82, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (227, 83, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (228, 84, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (229, 85, 55, '党员学习/月', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (230, 86, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (231, 87, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (232, 88, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (233, 89, 56, '团员学习/月', 0.5, 1.0, 1, 0.5, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (234, 90, 272, '进度、重点任务反馈', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (235, 91, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (236, 92, 215, '筹建项目组及项目评估', 5.0, 1.0, 1, 5.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (237, 92, 216, '需求调研及编写需求报告\r\n确定目标、范围和入围产品要求', 20.0, 1.7, 1, 10.2, 30.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (238, 92, 217, '编写启动分析报告', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (239, 92, 218, '供应商预推荐及考察', 20.0, 1.7, 1, 10.2, 30.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (240, 92, 219, '报季度采购沟通会', 2.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (241, 92, 220, '季度计划外采购申请', 4.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (242, 92, 221, '启动评审', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (243, 92, 223, '产品测试/产品选型/服务考察', 15.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (244, 92, 224, '增补IT供应商考察及审批流程（可选）', 15.0, 1.0, 1, 15.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (245, 92, 225, '选型方案/测试方案/服务考察方案评审', 15.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (246, 92, 226, '技术方案编审', 30.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (247, 92, 227, '技术评审', 20.0, 1.0, 1, -0.6, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (248, 92, 229, '发起采购沟通会', 4.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (249, 92, 230, '三重一大议题申报流程(可选）', 30.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (250, 92, 231, '单一来源/品牌采购申请流程(可选)', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (251, 92, 232, '采购需求审批', 4.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (252, 92, 233, '预算执行申请', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (253, 92, 234, '采购评审会', 4.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (254, 92, 235, '合同会签和归档', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (255, 92, 236, '下单采购', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (256, 92, 238, '实施交底及制定实施方案等', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (257, 92, 239, '设备到货验收', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (258, 92, 240, '项目实施及现场管理', 50.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (259, 92, 241, '编写运维手册', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (260, 92, 242, '组织用户使用和运维培训', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (261, 92, 243, '试运行及督促整改', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (262, 92, 245, '组织验收', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (263, 92, 246, '项目验收评审', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (264, 92, 247, '系统移交和归档', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (265, 92, 248, '项目总结', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (266, 93, 272, '进度、重点任务反馈', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (267, 94, 89, '国内行程单', 6.0, 1.0, 1, 6.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (268, 95, 55, '党员学习/月', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (269, 96, 95, '流程审核', 1.0, 1.0, 1, 14.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (270, 97, 143, '零星智能化项目复杂需求对接', 5.0, 1.0, 1, 5.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (271, 98, 215, '筹建项目组及项目评估', 5.0, 1.0, 1, 5.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (272, 98, 216, '需求调研及编写需求报告\r\n确定目标、范围和入围产品要求', 20.0, 1.0, 1, 4.0, 20.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (273, 98, 217, '编写启动分析报告', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (274, 98, 218, '供应商预推荐及考察', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (275, 98, 219, '报季度采购沟通会', 2.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (276, 98, 220, '季度计划外采购申请', 4.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (277, 98, 221, '启动评审', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (278, 98, 223, '产品测试/产品选型/服务考察', 15.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (279, 98, 224, '增补IT供应商考察及审批流程（可选）', 15.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (280, 98, 225, '选型方案/测试方案/服务考察方案评审', 15.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (281, 98, 226, '技术方案编审', 30.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (282, 98, 227, '技术评审', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (283, 98, 229, '发起采购沟通会', 4.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (284, 98, 230, '三重一大议题申报流程(可选）', 30.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (285, 98, 231, '单一来源/品牌采购申请流程(可选)', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (286, 98, 232, '采购需求审批', 4.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (287, 98, 233, '预算执行申请', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (288, 98, 234, '采购评审会', 4.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (289, 98, 235, '合同会签和归档', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (290, 98, 236, '下单采购', 4.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (291, 98, 238, '实施交底及制定实施方案等', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (292, 98, 239, '设备到货验收', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (293, 98, 240, '项目实施及现场管理', 50.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (294, 98, 241, '编写运维手册', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (295, 98, 242, '组织用户使用和运维培训', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (296, 98, 243, '试运行及督促整改', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (297, 98, 245, '组织验收', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (298, 98, 246, '项目验收评审', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (299, 98, 247, '系统移交和归档', 20.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (300, 98, 248, '项目总结', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (301, 99, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (302, 100, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (303, 101, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (304, 102, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (305, 103, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (306, 104, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (307, 105, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (308, 106, 55, '党员学习/月', 1.0, 1.0, 2, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (309, 107, 143, '零星智能化项目复杂需求对接', 5.0, 1.0, 1, 5.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (310, 108, 72, '总部大厦项目VAV系统控制部分设计方案现场审核', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (311, 109, 250, '需求调研', 5.0, 4.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (312, 109, 251, '方案设计', 5.0, 4.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (313, 109, 252, '组织施工', 5.0, 4.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (314, 109, 253, '验收交接', 5.0, 4.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (315, 110, 26, '沟通用户和运维单位，汇总问题和意见/系统', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (316, 111, 72, '自定义项目阶段', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (317, 112, 250, '需求调研', 5.0, 4.0, 1, 20.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (318, 112, 251, '方案设计', 5.0, 4.0, 1, 20.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (319, 112, 252, '组织施工', 5.0, 4.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (320, 112, 253, '验收交接', 5.0, 4.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (321, 113, 251, '方案设计', 5.0, 4.0, 1, 20.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (322, 113, 252, '组织施工', 5.0, 4.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (323, 113, 253, '验收交接', 5.0, 4.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (324, 114, 251, '方案设计', 5.0, 4.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (325, 114, 252, '组织施工', 5.0, 4.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (326, 114, 253, '验收交接', 5.0, 4.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (327, 115, 251, '方案设计', 5.0, 4.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (328, 115, 252, '组织施工', 5.0, 4.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (329, 115, 253, '验收交接', 5.0, 4.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (330, 116, 250, '需求调研', 5.0, 3.0, 1, 15.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (331, 116, 251, '方案设计', 5.0, 3.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (332, 116, 252, '组织施工', 5.0, 3.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (333, 116, 253, '验收交接', 5.0, 3.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (334, 117, 251, '方案设计', 5.0, 4.0, 1, 20.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (335, 117, 252, '组织施工', 5.0, 4.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (336, 117, 253, '验收交接', 5.0, 4.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (337, 118, 251, '方案设计', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (338, 118, 252, '组织施工', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (339, 118, 253, '验收交接', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (340, 119, 250, '需求调研', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (341, 119, 251, '方案设计', 5.0, 1.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (342, 119, 252, '组织施工', 5.0, 1.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (343, 119, 253, '验收交接', 5.0, 1.0, 1, 0.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (344, 120, 72, '自定义项目阶段', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (345, 121, 72, '自定义项目阶段22', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (346, 122, 72, '梳理责任归属、协调各方讨论解决方案', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (347, 122, 72, '召集各方现场排查故障、整理问题清单', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (348, 122, 72, '协调各方解决问题并完成系统交接', 1.0, 1.0, 1, 0.5, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (349, 123, 72, '自定义项目阶段', 1.0, 1.0, 1, 1.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (350, 124, 26, '沟通用户和运维单位，汇总问题和意见/系统', 5.0, 1.0, 1, 5.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (351, 125, 143, '零星智能化项目复杂需求对接', 5.0, 1.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (352, 126, 95, '流程审核', 1.0, 1.0, 1, 14.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (353, 127, 72, '完成旧系统数据备份，服务器下线，关闭网络规则，补充CMDB信息，完成迁移流程。', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (354, 128, 72, '洪文空勤项目施工进度质量检查', 3.0, 1.0, 2, 6.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (355, 129, 145, '基建项目设计变更或零星智能化项目方案审核', 2.0, 1.0, 2, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (356, 130, 80, '组织各类型会议', 2.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (357, 131, 218, '供应商预推荐及考察', 20.0, 1.0, 2, 40.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (358, 132, 64, '制作培训教材', 10.0, 1.0, 1, 10.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (359, 133, 67, '制定考核内容', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (360, 134, 17, '编写选型报告', 12.0, 1.5, 1, 18.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (361, 134, 18, '选型缺陷跟踪修正 ', 5.0, 1.5, 1, 7.5, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (362, 135, 69, '组织考核（含试卷批改）', 5.0, 1.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (363, 136, 250, '需求调研', 5.0, 1.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (364, 136, 251, '方案设计', 5.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (365, 136, 252, '组织施工', 5.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (366, 136, 253, '验收交接', 5.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (367, 137, 72, '完成旧系统数据备份，服务器下线，关闭网络规则，补充CMDB信息，完成迁移流程。', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (368, 138, 247, '系统移交和归档', 20.0, 1.0, 1, 20.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (369, 139, 29, '牵头修订资产配置标准', 20.0, 1.0, 1, 20.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (370, 140, 29, '牵头修订资产配置标准', 20.0, 1.0, 1, 20.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (371, 141, 72, '梳理责任归属、协调各方讨论解决方案', 10.0, 1.0, 1, 10.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (372, 141, 72, '召集各方现场排查故障、整理问题清单', 15.0, 1.0, 1, 15.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (373, 141, 72, '协调各方解决问题并完成系统交接', 10.0, 1.0, 1, 0.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (374, 142, 75, '行政材料撰写（如处室周总结、月总结、工作报告）', 11.0, 1.0, 1, 11.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (375, 142, 76, '科室月报编写及发布', 11.0, 1.0, 1, 11.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (376, 143, 77, '搜集相关信息，整理材料', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (377, 144, 106, '项目尾款支付', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (378, 145, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (379, 146, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (380, 147, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (381, 148, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (382, 149, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (383, 150, 234, '采购评审会', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (384, 151, 234, '采购评审会', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (385, 152, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (386, 153, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (387, 154, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (388, 155, 382, '账单、报表审核', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (389, 156, 95, '流程审核', 1.0, 1.0, 1, 1.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (390, 157, 382, '账单、报表审核', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (391, 158, 94, '工单', 1.5, 1.0, 13, 19.5, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (392, 159, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (393, 160, 382, '账单、报表审核', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (394, 161, 72, '自定义项目阶段', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (395, 162, 100, '系统日常维护', 3.0, 1.0, 1, 9.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (396, 163, 185, '项目三重一大汇报', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (397, 163, 186, '项目深化设计技术评审及公司审批', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (398, 163, 188, '造价咨询及招标代理单位选择及审批', 30.0, 3.0, 1, 30.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (399, 163, 189, '造价咨询及清单审核', 100.0, 3.0, 1, 100.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (400, 163, 190, '预算审批', 20.0, 3.0, 1, 20.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (401, 163, 191, '招标文件编制及审批', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (402, 163, 192, '工程发包程序', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (403, 163, 193, '施工合同签订', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (404, 163, 195, '配合施工开工会审及各专业接口交底', 30.0, 3.0, 1, 30.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (405, 163, 196, '主体施工阶段现场管理', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (406, 163, 197, '配合主体施工验收', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (407, 163, 198, '智能化工程实施方案二次评审', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (408, 163, 200, '组织智能化专业进场交底', 60.0, 3.0, 1, 60.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (409, 163, 201, '手机信号室分覆盖建设', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (410, 163, 202, '运营商接入', 60.0, 3.0, 1, 60.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (411, 163, 203, '机房装修、综合布线阶段现场管理', 150.0, 3.0, 1, 150.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (412, 163, 204, '智能化隐蔽工程检查及验收', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (413, 163, 205, '设备安装及系统调试阶段现场管理', 250.0, 3.0, 1, 250.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (414, 163, 207, '智能化初步验收及搬迁配合', 100.0, 3.0, 1, 100.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (415, 163, 208, '项目试运行及整改', 30.0, 3.0, 1, 30.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (416, 163, 209, '智能化系统培训', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (417, 163, 210, '项目正式验收', 30.0, 3.0, 1, 30.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (418, 163, 211, '项目移交', 50.0, 3.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (419, 163, 212, '项目总结', 30.0, 3.0, 1, 30.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (420, 164, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (421, 165, 91, '配合进行系统检查、完成信息填报', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (422, 166, 72, '自定义项目阶段', 50.0, 1.0, 1, 50.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (423, 167, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (424, 168, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (425, 169, 97, '配置变更测试', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (426, 170, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (427, 171, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (428, 172, 96, '故障处置（工作日）', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (429, 173, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (430, 174, 96, '故障处置（工作日）', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (431, 175, 75, '行政材料撰写（如处室周总结、月总结、工作报告）', 11.0, 1.0, 1, 11.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (432, 175, 76, '科室月报编写及发布', 11.0, 1.0, 1, 11.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (433, 176, 92, '月度巡检', 1.0, 1.0, 1, 1.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (434, 177, 75, '行政材料撰写（如处室周总结、月总结、工作报告）', 11.0, 1.0, 1, 11.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (435, 178, 76, '科室月报编写及发布', 11.0, 1.0, 1, 11.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (436, 179, 72, '工时标准修订，答疑', 1.0, 1.0, 1, 1.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (437, 180, 75, '行政材料撰写（如处室周总结、月总结、工作报告）', 11.0, 1.0, 1, 11.0, 0.0, 1, 0);
INSERT INTO `assignprojectdetail` VALUES (438, 181, 96, '故障处置（工作日）', 3.0, 1.0, 1, 15.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (439, 182, 75, '行政材料撰写（如处室周总结、月总结、工作报告）', 11.0, 1.0, 1, 11.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (440, 183, 76, '科室月报编写及发布', 11.0, 1.0, 1, 11.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (441, 184, 72, '自定义项目阶段', 50.0, 1.0, 1, 50.0, 80.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (442, 185, 296, '编写《缺陷跟踪审核表》', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (443, 185, 312, '编写《采购沟通结论表》', 5.0, 1.0, 1, 5.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (444, 185, 313, '提交采购需求审批流程', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (445, 185, 314, '编写《设备清单》', 5.0, 1.0, 1, 5.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (446, 186, 118, '部门板报、信息门户发表', 10.0, 1.0, 1, 10.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (447, 187, 117, 'IT365发表', 30.0, 1.0, 1, 30.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (448, 188, 384, '参加非本处室组织会议', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (449, 189, 317, '采购评审及合同会签', 10.0, 1.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (450, 190, 317, '采购评审及合同会签', 10.0, 1.0, 1, 5.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (451, 191, 72, '配合后保部完成智能门锁招标工作', 40.0, 1.0, 1, 40.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (452, 192, 89, '国内行程单', 6.0, 1.0, 1, 6.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (453, 193, 92, '月度巡检', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (454, 194, 384, '参加非本处室组织会议', 1.0, 1.0, 3, 3.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (455, 195, 104, '重保航班保障/次', 4.0, 1.0, 5, 20.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (456, 196, 95, '流程审核', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (457, 197, 87, '市内行程单', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (458, 198, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (459, 199, 72, '实验室接待贵宾参观', 5.0, 1.0, 1, 5.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (460, 200, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (461, 201, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (462, 202, 106, '项目尾款支付', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (463, 203, 80, '组织各类型会议', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (464, 204, 384, '参加非本处室组织会议', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (465, 205, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (466, 206, 100, '系统日常维护', 3.0, 1.0, 1, 3.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (467, 207, 97, '配置变更测试', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (468, 208, 95, '流程审核', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (469, 209, 80, '组织各类型会议', 2.0, 1.0, 2, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (470, 210, 81, '组织技术交流', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (471, 211, 384, '参加非本处室组织会议', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (472, 212, 381, '前端配置', 1.5, 1.0, 1, 1.5, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (473, 213, 91, '配合进行系统检查、完成信息填报', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (474, 214, 86, '工时审核反馈', 2.0, 1.0, 1, 2.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (475, 215, 380, '前端维修（如对讲机维修）', 1.5, 1.0, 1, 1.5, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (476, 216, 386, '处室行政材料（除处工作月报和处月总结外的其他材料，如周总结、降本增效总结、安全月报等）', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (477, 217, 386, '处室行政材料（除处工作月报和处月总结外的其他材料，如周总结、降本增效总结、安全月报等）', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (478, 218, 386, '处室行政材料（除处工作月报和处月总结外的其他材料，如周总结、降本增效总结、安全月报等）', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (479, 219, 384, '参加非本处室组织会议', 1.0, 1.0, 1, 1.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (480, 220, 386, '处室行政材料（除处工作月报和处月总结外的其他材料，如周总结、降本增效总结、安全月报等）', 4.0, 1.0, 1, 4.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (481, 221, 386, '处室行政材料（除处工作月报和处月总结外的其他材料，如周总结、降本增效总结、安全月报等）', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (482, 222, 72, '应急响应事件办公室待命', 1.0, 1.0, 1, 1.0, 100.0, 0, 1);
INSERT INTO `assignprojectdetail` VALUES (483, 223, 386, '处室行政材料（除处工作月报和处月总结外的其他材料，如周总结、降本增效总结、安全月报等）', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (484, 224, 55, '党员学习/月', 1.0, 1.0, 1, 1.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (485, 225, 91, '配合进行系统检查、完成信息填报', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (486, 226, 56, '团员学习/月', 0.5, 1.0, 1, 0.5, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (487, 227, 77, '搜集相关信息，整理材料', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (488, 228, 72, '自定义项目阶段', 1.0, 1.0, 1, 1.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (489, 229, 72, '自定义项目阶段', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (490, 230, 72, '自定义项目阶段', 1.0, 1.0, 1, 1.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (491, 231, 72, '自定义项目阶段', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (492, 232, 91, '配合进行系统检查、完成信息填报', 4.0, 1.0, 1, 4.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (493, 233, 72, '自定义项目阶段', 2.0, 1.0, 1, 2.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (494, 234, 96, '故障处置（工作日）', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);
INSERT INTO `assignprojectdetail` VALUES (495, 235, 68, '组织培训', 3.0, 1.0, 1, 3.0, 0.0, 0, 0);

-- ----------------------------
-- Table structure for assignprojectlist
-- ----------------------------
DROP TABLE IF EXISTS `assignprojectlist`;
CREATE TABLE `assignprojectlist`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `userID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '用户ID',
  `assignDate` datetime(0) NOT NULL COMMENT '分配时间',
  `projectType` int NULL DEFAULT NULL COMMENT '项目类型',
  `projectName` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '项目名称',
  `process` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '完成度',
  `assignerID` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '分配人',
  `totalWorkTime` float(10, 1) NOT NULL DEFAULT 0.0 COMMENT '总工时数',
  `gettedWorkTime` float(10, 1) NOT NULL DEFAULT 0.0 COMMENT '已获得工时数',
  `isFilled` tinyint NOT NULL DEFAULT 0 COMMENT '当月是否已填报',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '是否废弃',
  `projectLevel` tinyint NOT NULL DEFAULT 1 COMMENT '项目级别',
  `reviewStatus` tinyint NOT NULL DEFAULT 1 COMMENT '审核状态',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 142 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `assignprojectlist` VALUES (16, 8, '2020-12-25 15:51:10', 4, '组织BA系统培训', 0.0, 8, 3.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (17, 11, '2020-12-25 16:43:50', 5, '总部大厦基建智能化项目', 0.0, 11, 105.0, 0.0, 1, 0, 3, 0);
INSERT INTO `assignprojectlist` VALUES (18, 17, '2020-12-25 17:11:11', 173, '总部', 0.0, 17, 1990.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (19, 11, '2020-12-25 17:12:20', 5, '企业展厅供应商考察及案例参观', 100.0, 11, 1.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (20, 11, '2020-12-25 17:14:25', 4, '企业展厅供应商考察及案例参观', 100.0, 11, 6.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (21, 11, '2020-12-25 17:23:33', 5, '2020年12月日常事务', 100.0, 11, 23.5, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (22, 11, '2020-12-25 17:36:10', 5, '智能化各系统现场检查单编制', 20.0, 11, 50.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (23, 29, '2020-12-28 09:25:38', 4, '11月份手册超时阅读', 100.0, 29, -50.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (24, 23, '2020-12-28 10:56:32', 5, '人脸识别无感考勤优化', 0.0, 23, 2.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (25, 23, '2020-12-28 11:02:13', 4, '视频会议厂家技术交流', 0.0, 23, 2.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (26, 23, '2020-12-28 11:05:02', 5, '参加华为智慧屏品鉴会', 0.0, 23, 3.0, 0.0, 1, 1, 1, 0);
INSERT INTO `assignprojectlist` VALUES (27, 15, '2020-12-28 11:24:10', 5, '11', 0.0, 15, 1.0, 0.0, 1, 1, 1, 0);
INSERT INTO `assignprojectlist` VALUES (28, 23, '2020-12-28 11:30:25', 4, '视频会议厂家技术交流', 100.0, 23, 10.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (29, 7, '2020-12-28 11:57:10', 4, '有线电视系统部分配置修订', 50.0, 7, 10.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (30, 7, '2020-12-28 12:00:47', 4, '综合布线系统设计标准修订', 100.0, 7, 10.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (31, 22, '2020-12-28 12:42:52', 249, '航材楼弱电改造申请', 0.0, 32, 20.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (32, 22, '2020-12-28 12:47:29', 249, '杭州配餐部食品车安装车载监控、防疲劳驾驶设备的申请', 0.0, 32, 20.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (33, 13, '2020-12-28 14:05:26', 4, '出差深圳', 100.0, 13, 6.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (34, 22, '2020-12-28 14:10:39', 249, '2012-采购类-杭州配餐部食品车安装车载监控、防疲劳驾驶设备的申请', 0.0, 32, 20.0, 0.0, 0, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (35, 7, '2020-12-28 14:10:44', 4, '背景音乐系统配置标准', 50.0, 7, 5.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (36, 13, '2020-12-28 14:11:48', 275, '预算执行流程提交', 100.0, 13, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (37, 7, '2020-12-28 14:12:15', 4, '综合布线系统设计标准修订', 0.0, 7, 10.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (38, 7, '2020-12-28 14:13:56', 4, '组织综合布线系统设计标准修订', 0.0, 7, 20.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (39, 23, '2020-12-28 14:15:35', 4, '参加华为智慧屏品鉴会', 100.0, 23, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (40, 7, '2020-12-28 14:16:16', 4, '已确认修订标准关键内容整理发布', 0.0, 7, 10.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (41, 23, '2020-12-28 14:18:04', 4, '参加华为智慧屏品鉴会', 100.0, 23, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (42, 7, '2020-12-28 14:18:53', 4, 'V2视频会议系统培训教材修订', 100.0, 7, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (43, 7, '2020-12-28 14:19:48', 4, '修订多媒体系统培训教材', 100.0, 7, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (44, 7, '2020-12-28 14:20:20', 4, '修订背景音乐系统教材', 100.0, 7, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (45, 7, '2020-12-28 14:21:07', 4, '撰写背景音乐系统考题', 100.0, 7, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (46, 7, '2020-12-28 14:21:46', 4, '多媒体系统培训', 100.0, 7, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (47, 7, '2020-12-28 14:25:57', 5, '晋江酒店项目施工进度质量检查', 100.0, 7, 4.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (48, 7, '2020-12-28 14:27:05', 5, '洪文空勤项目施工进度、质量临时检查', 100.0, 7, 3.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (49, 16, '2020-12-28 14:37:55', 249, '2012-采购类-杭州维修基地航材库改造工程', 0.0, 32, 20.0, 0.0, 0, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (50, 16, '2020-12-28 14:38:36', 249, '2012-采购类-北京分公司关于新增监控设备的申请', 0.0, 32, 20.0, 0.0, 0, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (51, 16, '2020-12-28 14:39:09', 249, '2012-采购类-福州新配餐大楼梯控功能需求', 0.0, 32, 20.0, 0.0, 0, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (52, 16, '2020-12-28 14:41:56', 4, '厦航广场初步设计费审核支付', 100.0, 16, 5.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (53, 14, '2020-12-28 14:42:42', 4, '总部大厦建筑智能化集成管理平台项目评估评审', 100.0, 14, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (54, 7, '2020-12-28 14:43:48', 4, '新基地机务、餐厅汇聚机房机房环境监控系统建设需求对接', 0.0, 7, 5.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (55, 7, '2020-12-28 14:45:05', 4, '新基地维修楼机房机房环监控系统建设需求、方案对接', 0.0, 7, 5.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (56, 13, '2020-12-28 14:45:26', 5, '出差考察', 100.0, 13, 12.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (57, 7, '2020-12-28 14:47:15', 4, '总部大厦VAV系统控制系统方案审核修订', 0.0, 7, 16.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (58, 28, '2020-12-28 14:48:04', 4, '工程组每月分享交流培训', 0.0, 11, 3.0, 0.0, 0, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (59, 14, '2020-12-28 14:51:00', 4, '维谛机房微模块交流', 100.0, 14, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (60, 7, '2020-12-28 14:51:10', 213, '新基地BA系统交接', 100.0, 7, 20.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (61, 16, '2020-12-28 14:58:55', 4, '福州配餐楼智能化工程结算', 0.0, 16, 50.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (62, 14, '2020-12-28 15:00:56', 4, '环境监控系统统一监控平台建设方案沟通', 100.0, 14, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (63, 13, '2020-12-28 15:06:58', 5, '数字化转型头脑风暴', 100.0, 13, 6.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (64, 15, '2020-12-28 15:19:38', 4, '霍尼韦尔广播技术交流', 100.0, 15, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (65, 13, '2020-12-28 15:20:30', 4, '党小组线上会议', 100.0, 13, 0.5, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (66, 13, '2020-12-28 15:22:26', 4, '党支部会议', 100.0, 13, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (67, 22, '2020-12-28 15:23:46', 249, '2012-零星修缮类-航材楼弱电改造申请', 0.0, 32, 20.0, 0.0, 0, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (68, 13, '2020-12-28 15:23:54', 4, '技术标准组月例会', 100.0, 13, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (69, 13, '2020-12-28 15:27:07', 4, '党支委会议', 100.0, 13, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (70, 32, '2020-12-28 15:35:02', 4, '科华环境监控交流培训', 100.0, 32, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (71, 23, '2020-12-28 15:35:19', 4, '杭州B地块增加车辆道闸方案审核', 100.0, 23, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (72, 13, '2020-12-28 15:37:19', 4, '党员学习', 0.0, 13, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (73, 7, '2020-12-28 15:45:57', 4, '基地维修部定检处申请屏风布线', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (74, 7, '2020-12-28 15:46:21', 4, '福州新运行楼四楼显示屏安装', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (75, 7, '2020-12-28 15:46:56', 4, '数据中心机房电话布线申请', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (76, 7, '2020-12-28 15:47:27', 4, '中巴车电子显示器', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (77, 7, '2020-12-28 15:47:56', 4, '总部办公楼712申请弱电建设', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (78, 7, '2020-12-28 15:48:25', 4, '机房环境监控系统选型报告初稿审核 ', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (79, 7, '2020-12-28 15:48:53', 4, '安防系统室内防入侵报警产品选型申请', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (80, 28, '2020-12-28 15:48:55', 4, '晋江飞行出勤楼项目出差', 0.0, 28, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (81, 7, '2020-12-28 15:49:20', 4, '培训部二期6901教室录播系统网线布置申请', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (82, 7, '2020-12-28 15:49:45', 4, '长沙中心机房配电系统结构图审核', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (83, 7, '2020-12-28 15:50:25', 4, '北京分公司关于新增监控设备的申请', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (84, 7, '2020-12-28 15:50:53', 4, '总部大厦智能化专业调试报告', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (85, 16, '2020-12-28 15:51:10', 4, '参加第一党支部参观厦航学习室主题活动', 100.0, 16, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (86, 7, '2020-12-28 15:51:17', 4, '关于开展杭州空中乘务部飞鹭训练基地-杭州工作室弱电建设申请', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (87, 7, '2020-12-28 15:51:38', 4, '航材楼弱电改造申请', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (88, 7, '2020-12-28 15:52:00', 4, '总部大厦项目联系单', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (89, 8, '2020-12-28 15:52:15', 4, '团员学习', 0.0, 8, 0.5, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (90, 16, '2020-12-28 15:52:17', 4, '福州配餐楼智能化工程项目进度反馈', 100.0, 16, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (91, 7, '2020-12-28 15:52:29', 4, '新基地机务楼、餐厅楼汇聚机房环境监控系统建设申请', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (92, 23, '2020-12-28 15:55:32', 213, '2021年视频会议系统建设', 5.3, 23, 432.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (93, 16, '2020-12-28 15:56:31', 4, 'RFID技术应用项目进度反馈', 100.0, 16, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (94, 8, '2020-12-28 15:58:04', 4, '国内出差行程单', 0.0, 8, 6.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (95, 13, '2020-12-28 15:59:35', 4, '12月党员学习', 100.0, 13, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (96, 7, '2020-12-28 16:01:01', 4, '弱电建设、选型等审核', 0.0, 7, 1.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (97, 7, '2020-12-28 16:04:30', 4, '路桥公司在新基地楼顶安装监控点需求公函处理', 100.0, 7, 5.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (98, 23, '2020-12-28 16:05:46', 213, '2021年停车场管理系统建设', 4.0, 23, 432.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (99, 7, '2020-12-28 16:08:22', 4, 'IBMS技术交流会（北京优诺）', 100.0, 7, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (100, 7, '2020-12-28 16:09:54', 4, '机房环控系统技术沟通会（共济科技）', 100.0, 7, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (101, 7, '2020-12-28 16:12:28', 4, '综合布线系统标准审核会', 100.0, 7, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (102, 7, '2020-12-28 16:13:39', 4, '翔安生产基地智能化方案技术交流会（华为）', 100.0, 7, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (103, 7, '2020-12-28 16:15:12', 4, '洪文空勤基地项目进度情况向部门领导会汇报', 100.0, 7, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (104, 7, '2020-12-28 16:16:48', 4, 'IBMS系统交流会(万安）', 100.0, 7, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (105, 7, '2020-12-28 16:17:23', 4, 'IBMS系统交流会（银江）', 100.0, 7, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (106, 16, '2020-12-28 16:22:43', 4, '参加党员学习会议', 0.0, 16, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (107, 7, '2020-12-28 16:24:32', 4, '公安局小区智慧安防需求文件对接处理', 100.0, 7, 5.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (108, 7, '2020-12-28 16:28:48', 5, '总部大厦项目VAV系统控制部分设计方案现场审核', 0.0, 7, 3.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (109, 8, '2020-12-28 16:53:43', 249, '新基地机务楼、餐厅楼汇聚机房新增环控系统', 0.0, 8, 60.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (110, 15, '2020-12-28 16:53:55', 4, '1111', 0.0, 15, 5.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (111, 15, '2020-12-28 16:54:19', 5, '111', 0.0, 15, 1.0, 0.0, 1, 1, 1, 0);
INSERT INTO `assignprojectlist` VALUES (112, 8, '2020-12-28 17:00:24', 249, '新生产基地机务楼、餐厅楼汇聚机房新增环控系统', 0.0, 8, 40.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (113, 8, '2020-12-28 17:39:24', 249, '杭州空中乘务部飞鹭训练基地改造项目', 0.0, 8, 20.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (114, 15, '2020-12-28 17:47:11', 249, '111222', 0.0, 15, 15.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (115, 15, '2020-12-28 17:50:56', 249, '123123', 0.0, 15, 15.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (116, 8, '2020-12-28 17:52:22', 249, '杭州A地块应急会议室改造项目', 0.0, 8, 15.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (117, 15, '2020-12-28 17:55:09', 249, '123', 0.0, 15, 15.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (118, 15, '2020-12-28 17:56:46', 249, '2222', 0.0, 15, 15.0, 0.0, 0, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (119, 15, '2020-12-28 17:58:50', 249, '111', 0.0, 15, 20.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (120, 8, '2020-12-28 18:20:24', 5, '培训中心二期BA系统建设及运行问题排查与处理', 0.0, 8, 1.0, 0.0, 1, 1, 1, 0);
INSERT INTO `assignprojectlist` VALUES (121, 15, '2020-12-28 18:28:14', 5, '111', 0.0, 15, 1.0, 0.0, 1, 1, 1, 0);
INSERT INTO `assignprojectlist` VALUES (122, 8, '2020-12-28 18:33:40', 5, '模拟机二期BA系统建设及运行问题排查与处理', 0.0, 8, 2.5, 0.0, 1, 1, 1, 0);
INSERT INTO `assignprojectlist` VALUES (123, 15, '2020-12-28 18:34:04', 5, '111', 0.0, 15, 1.0, 0.0, 1, 1, 1, 0);
INSERT INTO `assignprojectlist` VALUES (124, 15, '2020-12-28 18:35:21', 4, '1221', 0.0, 15, 5.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (125, 7, '2020-12-29 08:21:51', 4, '泉州酒店项目机房环境监控系统配置方案审核修订', 0.0, 7, 5.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (126, 7, '2020-12-29 08:27:37', 4, '弱电建设、选型流程、联系单审核汇总', 0.0, 7, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (127, 23, '2020-12-29 08:30:57', 5, '中控门禁系统迁移', 0.0, 23, 3.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (128, 7, '2020-12-29 08:52:58', 5, '洪文空勤项目施工进度质量检查', 0.0, 7, 3.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (129, 7, '2020-12-29 08:55:00', 4, '总部大厦项目BA系统深化方案', 0.0, 7, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (130, 23, '2020-12-29 08:57:35', 4, '梯控平台开发沟通会', 0.0, 23, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (131, 7, '2020-12-29 08:59:38', 213, 'IBMS系统建设', 0.0, 7, 20.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (132, 7, '2020-12-29 09:01:19', 4, '已完成修订智能化建设标准部分', 0.0, 7, 10.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (133, 7, '2020-12-29 09:02:44', 4, '已完成修订智能化建设标准部分', 0.0, 7, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (134, 23, '2020-12-29 09:04:35', 172, '入侵报警系统选型', 0.0, 23, 17.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (135, 7, '2020-12-29 09:04:53', 4, '已完成修订智能化建设标准部分', 0.0, 7, 5.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (136, 8, '2020-12-29 09:07:18', 249, '新基地附件楼机房环控系统接入统一环控平台 ', 0.0, 8, 20.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (137, 23, '2020-12-29 09:07:55', 5, '中控门禁系统迁移', 0.0, 23, 4.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (138, 7, '2020-12-29 09:10:10', 213, '新基地综合布线系统', 0.0, 7, 20.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (139, 7, '2020-12-29 09:15:19', 4, '视频监控系统配置标准', 0.0, 7, 20.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (140, 7, '2020-12-29 09:16:47', 4, '车辆道闸系统配置标准修订', 0.0, 7, 20.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (141, 8, '2020-12-29 09:30:10', 5, '模拟机二期BA系统故障排查与处理', 0.0, 8, 35.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (142, 32, '2020-12-29 09:51:24', 4, '2020年12月月报和月总结', 0.0, 32, 22.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (143, 8, '2020-12-29 09:56:08', 4, '通信工程处员工岗位晋升时间统计与整理', 0.0, 8, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (144, 8, '2020-12-29 10:07:32', 4, '新基地弱电机房排风系统增配项目工程结算', 0.0, 8, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (145, 18, '2020-12-29 10:24:48', 4, '数字委员会2020年度管理干部考核述职报告会', 0.0, 18, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (146, 18, '2020-12-29 10:26:10', 4, '12月1日数字委员会2020年度管理干部考核述职报告会', 0.0, 18, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (147, 18, '2020-12-29 10:35:04', 4, '12月7日河北航护网行动服务器端口梳理', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (148, 18, '2020-12-29 10:36:07', 4, '12月8日内通灾备Avaya服务器改密维护', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (149, 18, '2020-12-29 10:40:08', 4, '12月9日内通系统apache struts版本及漏洞排查', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (150, 29, '2020-12-29 10:40:31', 213, '2020年客服中心扩容友邻录音', 0.0, 29, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (151, 29, '2020-12-29 10:41:36', 213, '2020年客服中心扩容avaya系统', 0.0, 29, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (152, 18, '2020-12-29 10:41:58', 4, '12月10日南昌无线网关线路状态“空闲”异常问题排查', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (153, 18, '2020-12-29 10:42:51', 4, '12月10日洪文乘务内通电话故障处理', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (154, 18, '2020-12-29 10:43:23', 4, '12月10日总签卫星电话录音排查', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (155, 18, '2020-12-29 10:46:28', 4, '12月14日办公室原车董内通电话资产盘点', 0.0, 18, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (156, 18, '2020-12-29 10:46:59', 4, '12月14日河北航内通灾备服务器堡垒权限申请流程审核', 0.0, 18, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (157, 18, '2020-12-29 10:47:34', 4, '12月15日总签派内通电话资产盘点', 0.0, 18, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (158, 8, '2020-12-29 10:48:34', 4, '人脸识别系统工单处理', 0.0, 8, 19.5, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (159, 18, '2020-12-29 10:50:11', 4, '12月15日HCC机签132甚高频录音排查', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (160, 18, '2020-12-29 10:51:08', 4, '12月16日整理2020年11月境外ACARS通信费降本增效明细', 0.0, 18, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (161, 18, '2020-12-29 10:54:30', 5, '12月17日部门消防应急演引导员工作（不参与人员名单统计、熟练脚本、疏散引导、清点核对人数）', 0.0, 18, 2.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (162, 8, '2020-12-29 10:55:08', 4, '系统日常维护', 0.0, 8, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (163, 13, '2020-12-29 10:55:12', 173, '厦航总部大厦', 0.0, 17, 1490.0, 0.0, 0, 0, 4, 1);
INSERT INTO `assignprojectlist` VALUES (164, 29, '2020-12-29 11:01:10', 4, '杭州程控交换机系统故障处理', 0.0, 29, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (165, 29, '2020-12-29 11:03:16', 4, '语音导航EP系统工作日巡检', 0.0, 29, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (166, 19, '2020-12-29 11:09:48', 5, '2011-建立建筑智能化工程各系统验收检查单', 0.0, 17, 50.0, 0.0, 0, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (167, 18, '2020-12-29 11:18:16', 4, '12月21日晋江无线网关线路状态“空闲”异常问题排查', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (168, 18, '2020-12-29 11:18:32', 4, '12月21日总签派协调席录音排查', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (169, 18, '2020-12-29 11:19:11', 4, '12月23日内通无线服务器更新测试', 0.0, 18, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (170, 18, '2020-12-29 11:19:55', 4, '12月23日内通无线服务器更新维护', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (171, 18, '2020-12-29 11:20:36', 4, '12月25日杭州签派新增内通调度台及Avaya话机事宜', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (172, 18, '2020-12-29 11:21:00', 4, '12月25日ESB统一认证故障处置', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (173, 18, '2020-12-29 11:21:36', 4, '12月28日AOC配餐800M室分覆盖光端机维护：人员引领及监工', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (174, 18, '2020-12-29 11:22:10', 4, '12月28日内通灾备AES服务器权限异常问题排查', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (175, 32, '2020-12-29 11:23:20', 4, '2020年12月月报和月总结', 0.0, 32, 22.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (176, 18, '2020-12-29 11:23:30', 4, '12月29日内通系统季度巡检', 0.0, 18, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (177, 32, '2020-12-29 11:24:16', 4, '月总结', 0.0, 32, 11.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (178, 32, '2020-12-29 11:24:41', 4, '12月月报', 0.0, 32, 11.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (179, 23, '2020-12-29 11:24:47', 5, '工时标准管理', 0.0, 23, 1.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (180, 32, '2020-12-29 11:25:23', 4, '12月月总结', 0.0, 32, 11.0, 0.0, 1, 1, 1, 1);
INSERT INTO `assignprojectlist` VALUES (181, 8, '2020-12-29 11:26:22', 4, '12月15日人脸系统故障处置与分析', 0.0, 8, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (182, 32, '2020-12-29 11:28:23', 4, '12月月总结', 100.0, 32, 11.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (183, 32, '2020-12-29 11:28:40', 4, '12月月报', 100.0, 32, 11.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (184, 17, '2020-12-29 11:36:49', 5, '2011-杭州BA系统优化', 80.0, 17, 50.0, 0.0, 1, 0, 2, 0);
INSERT INTO `assignprojectlist` VALUES (185, 33, '2020-12-29 11:39:53', 275, '无线固话项目', 100.0, 33, 13.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (186, 33, '2020-12-29 11:41:08', 4, '机上直播活动门户新闻投稿', 100.0, 33, 10.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (187, 33, '2020-12-29 11:41:50', 4, '机上直播活动it365投稿', 100.0, 33, 30.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (188, 33, '2020-12-29 11:46:04', 4, '作为空客项目小组成员参加与春秋航的交流会', 100.0, 33, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (189, 29, '2020-12-29 11:49:24', 275, '2020年客服中心扩容avaya系统', 0.0, 29, 5.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (190, 29, '2020-12-29 11:51:20', 275, '2020年客服中心扩容友邻录音采购', 0.0, 29, 5.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (191, 30, '2020-12-29 11:56:38', 5, '配合后保部完成智能门锁招标工作', 0.0, 30, 40.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (192, 32, '2020-12-29 12:09:33', 4, '28-31日出差北京大兴', 0.0, 32, 6.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (193, 18, '2020-12-29 12:30:00', 4, '12月29日内通系统季度巡检', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (194, 33, '2020-12-29 13:47:37', 4, '参加acars故障调查分析会', 100.0, 33, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (195, 33, '2020-12-29 13:52:28', 4, '重点航班保证任务', 100.0, 33, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (196, 33, '2020-12-29 13:54:00', 4, '提交程控交换机维保项目预算执行申请流程', 100.0, 33, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (197, 33, '2020-12-29 13:54:40', 4, '参加腾讯数字生态论坛智慧交通专场报告', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (198, 33, '2020-12-29 13:58:04', 4, '处理规划财务部提出的三方电话会议的需求并测试反馈', 100.0, 33, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (199, 33, '2020-12-29 13:59:34', 5, '接待厦门科技局来实验室参观任务', 100.0, 33, 5.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (200, 33, '2020-12-29 14:00:43', 4, '与松下沟通后端打包的问题并在本地linux系统和rack上测试', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (201, 33, '2020-12-29 14:01:44', 4, '组织网络处同事和松下工程师讨论解决rack访问外网的问题', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (202, 33, '2020-12-29 14:02:42', 4, '提交斯德哥尔摩高频站季度付款流程', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (203, 33, '2020-12-29 14:04:49', 4, '调查福州铁路选址影响甚高频的问题并向部门领导报告', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (204, 33, '2020-12-29 14:05:12', 4, '部门非研发方向管理者竞聘民主评委', 100.0, 33, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (205, 33, '2020-12-29 14:05:59', 4, '与松下、电信沟通亚太6c卫星被干扰的问题', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (206, 33, '2020-12-29 14:07:21', 4, 'B787飞机机上频率配置文件更新及逐架测试', 100.0, 33, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (207, 33, '2020-12-29 14:08:27', 4, 'pdi实名认证数据库迁移测试工作', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (208, 33, '2020-12-29 14:09:27', 4, '提交预算执行流程-无线对讲终端采购项目', 100.0, 33, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (209, 33, '2020-12-29 14:13:46', 4, '小组会', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (210, 33, '2020-12-29 14:16:21', 4, '融合通信建设推进会', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (211, 33, '2020-12-29 14:17:23', 4, '与客运营销委召开机上互联网运营及改装讨论会', 100.0, 33, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (212, 33, '2020-12-29 14:25:23', 4, '协助整理疫情期间海关交接的对讲机', 100.0, 33, 1.5, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (213, 33, '2020-12-29 14:28:16', 4, '28日晚与党委工作部进行机上直播测试', 100.0, 33, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (214, 33, '2020-12-29 14:35:41', 4, '审核上月小组工时', 100.0, 33, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (215, 18, '2020-12-29 14:56:46', 4, '12月29日数字集群TETRA直放机邮寄厂家维修', 0.0, 18, 1.5, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (216, 33, '2020-12-29 15:00:12', 4, '填写应急管理工作总结与计划调研表', 100.0, 33, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (217, 33, '2020-12-29 15:00:39', 4, '填写平台重点项目表并向部门领导报告', 100.0, 33, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (218, 33, '2020-12-29 15:01:04', 4, '汇总本处采购评审专员表', 100.0, 33, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (219, 18, '2020-12-29 15:01:30', 4, '12月1日数字委员会2020年度管理干部考核述职报告会', 0.0, 18, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (220, 33, '2020-12-29 15:01:46', 4, '本处系统主数据审阅', 100.0, 33, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (221, 18, '2020-12-29 15:02:23', 4, '12月17日通信工程处消防应急演练记录表', 0.0, 18, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (222, 33, '2020-12-29 15:02:27', 5, '应急响应事件待命', 100.0, 33, 1.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (223, 18, '2020-12-29 15:03:00', 4, '12月23日部门分工会2020年工作总结及2021年工作计划', 0.0, 18, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (224, 18, '2020-12-29 15:09:50', 4, '12月党员学习强国', 0.0, 18, 1.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (225, 29, '2020-12-29 15:10:25', 4, '杭州程控交换机系统故障处理', 0.0, 29, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (226, 18, '2020-12-29 15:10:26', 4, '12月团员福建共青团青年大学习', 0.0, 18, 0.5, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (227, 32, '2020-12-29 15:14:33', 4, '根据王经理要求，汇总数字委关于“数字化转型内容”，并筛查内容。', 0.0, 32, 2.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (228, 32, '2020-12-29 15:18:12', 5, '协助飞行部程源处理404领导办公室线槽和网线问题（下班后帮其处理）', 0.0, 32, 1.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (229, 32, '2020-12-29 15:19:48', 5, '协助荣茂处理信息大厦三楼机房内人脸识别设备跳线和标签（重新跳线和打标签）', 0.0, 32, 2.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (230, 32, '2020-12-29 15:20:51', 5, '12月3日参加第一党支部预备党员转正意见听取会', 0.0, 32, 1.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (231, 32, '2020-12-29 15:23:10', 5, '推动通商达GPS合同签订，并录入合同信息，保障了在12月31日旧合同到期之前成功续签。', 0.0, 32, 3.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (232, 18, '2020-12-29 15:28:44', 4, '12月9日12月9日内通系统apache struts版本及漏洞排查', 0.0, 18, 4.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (233, 18, '2020-12-29 15:29:24', 5, '12月18日数字委劳动技能竞赛总决赛现场布场', 0.0, 18, 2.0, 0.0, 1, 0, 1, 0);
INSERT INTO `assignprojectlist` VALUES (234, 18, '2020-12-29 15:34:41', 4, '12月24日乘务调度Avaya话机“Discover from XX.XX”故障处置', 0.0, 18, 3.0, 0.0, 1, 0, 1, 1);
INSERT INTO `assignprojectlist` VALUES (235, 7, '2020-12-29 15:38:35', 4, '智能化建设标准（以确认部分）培训）', 0.0, 7, 3.0, 0.0, 1, 0, 1, 1);

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
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态 ',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of monthprocess
-- ----------------------------
INSERT INTO `monthprocess` VALUES (1, 9, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (2, 9, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (3, 10, 2021, 'plan', 80.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (4, 12, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (5, 12, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (6, 10, 2020, 'fact', 20.0, 30.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (7, 19, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (8, 20, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (9, 21, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (10, 22, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (11, 23, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.0, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (12, 100, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (13, 59, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 90.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (14, 102, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (15, 23, 2021, 'plan', 50.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (16, 101, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (17, 105, 2020, 'plan', 10.0, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (18, 106, 2020, 'plan', NULL, NULL, 12.0, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (19, 140, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (20, 140, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (21, 141, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (22, 140, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (23, 143, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (24, 141, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (25, 142, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (26, 139, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (27, 138, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (28, 151, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (29, 150, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (30, 160, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (31, 166, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (32, 149, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (33, 169, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (34, 171, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (35, 191, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (36, 192, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (37, 192, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (38, 195, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (39, 187, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (40, 188, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (41, 189, 2021, 'plan', 50.0, 70.0, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (42, 190, 2021, 'plan', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (43, 179, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (44, 179, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (45, 180, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (46, 180, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (47, 181, 2021, 'plan', NULL, 50.0, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (48, 198, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (49, 182, 2021, 'plan', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (50, 183, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (51, 184, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (52, 183, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (53, 184, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (54, 185, 2021, 'plan', NULL, 50.0, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (55, 186, 2021, 'plan', NULL, NULL, NULL, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (56, 192, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (57, 198, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (58, 200, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (59, 201, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (60, 202, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (61, 204, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (62, 203, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (63, 201, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (64, 205, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (65, 215, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (66, 229, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (67, 234, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (68, 266, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (69, 239, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (70, 217, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (71, 200, 2021, 'plan', 50.0, 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (72, 206, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (73, 179, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (74, 207, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (75, 180, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (76, 212, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (77, 213, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (78, 268, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (79, 183, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (80, 184, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (81, 165, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (82, 172, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (83, 301, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (84, 302, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (85, 199, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (86, 270, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (87, 176, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (88, 308, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (89, 307, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (90, 306, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (91, 305, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (92, 304, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (93, 309, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (94, 303, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (95, 214, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (96, 178, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (97, 177, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (98, 175, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (99, 174, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (100, 266, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (101, 173, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (102, 229, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (103, 234, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (104, 271, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (105, 272, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 20.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (106, 236, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (107, 237, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (108, 191, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (109, 311, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (110, 318, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (111, 348, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 1);
INSERT INTO `monthprocess` VALUES (112, 354, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (113, 355, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (114, 357, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (115, 358, 2020, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (116, 359, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (117, 362, 2020, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (118, 368, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (119, 369, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (120, 370, 2021, 'plan', 100.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.0, 0);
INSERT INTO `monthprocess` VALUES (121, 144, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (122, 374, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (123, 374, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (124, 375, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (125, 375, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 1);
INSERT INTO `monthprocess` VALUES (126, 439, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (127, 439, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (128, 440, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (129, 440, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (130, 441, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 50.0, 70.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (131, 441, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 80.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (132, 452, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (133, 473, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (134, 472, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (135, 471, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (136, 470, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (137, 469, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (138, 468, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (139, 466, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (140, 467, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (141, 465, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (142, 464, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (143, 463, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (144, 462, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (145, 461, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (146, 460, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (147, 459, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (148, 458, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (149, 457, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (150, 456, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (151, 455, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (152, 454, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (153, 448, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (154, 447, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (155, 446, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (156, 442, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (157, 443, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (158, 444, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (159, 445, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (160, 474, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (161, 482, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (162, 480, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (163, 478, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (164, 477, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (165, 476, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (166, 487, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (167, 487, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (168, 488, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (169, 488, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (170, 489, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (171, 489, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (172, 490, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (173, 490, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (174, 491, 2020, 'plan', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);
INSERT INTO `monthprocess` VALUES (175, 491, 2020, 'fact', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 100.0, 0.0, 0);

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
INSERT INTO `projecttypenew` VALUES (55, '党员学习/月', 40, 4, 1.0, 0, 1, 1.0, 0);
INSERT INTO `projecttypenew` VALUES (56, '团员学习/月', 40, 4, 0.5, 0, 1, 0.5, 0);
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
INSERT INTO `projecttypenew` VALUES (75, '行政材料撰写（如处室周总结、月总结、工作报告）', 42, 4, 11.0, 0, 0, 0.0, 1);
INSERT INTO `projecttypenew` VALUES (76, '科室月报编写及发布', 42, 4, 11.0, 0, 0, 0.0, 1);
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
INSERT INTO `projecttypenew` VALUES (92, '月度巡检', 332, 4, 3.0, 0, 0, 0.0, 0);
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
INSERT INTO `projecttypenew` VALUES (252, '组织施工', 249, 3, 5.0, 1, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (253, '验收交接', 249, 3, 5.0, 1, 0, 0.0, 0);
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
INSERT INTO `projecttypenew` VALUES (380, '前端维修（如对讲机维修）', 332, 5, 1.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (381, '前端配置', 332, 5, 1.5, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (382, '账单、报表审核', 332, 5, 2.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (383, '培训考核缺席或未通过', 54, 5, -10.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (384, '参加非本处室组织会议', 44, 5, 1.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (385, '处室月报总结（工作月报、月总结）', 42, 5, 11.0, 0, 0, 0.0, 0);
INSERT INTO `projecttypenew` VALUES (386, '处室行政材料（除处工作月报和处月总结外的其他材料，如周总结、降本增效总结、安全月报等）', 42, 5, 4.0, 0, 0, 0.0, 0);

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
INSERT INTO `users` VALUES (7, '00984', 1, 1, '白洋', 3, '87066f8c8ce63a90fe005abc725e096a', '1', 1);
INSERT INTO `users` VALUES (8, '30894', 1, 1, '陈迪', 3, 'c98150304bb8a79a0e956d64c86408e0', '1', 1);
INSERT INTO `users` VALUES (9, '12148', 1, 3, '陈晓峰', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (10, '00808', 1, 3, '傅霖晖', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (11, '02031', 1, 2, '郭红生', 3, '3769ef0dfe4c4c761c958a00d8161930', '1', 0);
INSERT INTO `users` VALUES (12, '12690', 1, 3, '顾心瑜', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (13, '13885', 1, 1, '黄雅婷', 2, '0456bb506954890f0cd409db364afd5d', '1', 1);
INSERT INTO `users` VALUES (14, '27815', 1, 1, '胡章荣', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (15, '31345', 1, 1, '江黄能', 1, '090f3febf40ccbf7c0f06aa40b54e04f', '1', 1);
INSERT INTO `users` VALUES (16, '02478', 1, 2, '匡卫民', 3, '9cf3af350232e4afa7232aba0bbdea23', '1', 1);
INSERT INTO `users` VALUES (17, '10698', 1, 2, '连祎文', 2, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (18, '22356', 1, 3, '李俊炎', 3, '4c4d2e597922e58b6abc692cadd3669c', '1', 1);
INSERT INTO `users` VALUES (19, '23940', 1, 2, '李培育', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (20, '22303', 1, 2, '刘佳彬', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (21, '28494', 1, 1, '刘向前', 3, 'e10adc3949ba59abbe56e057f20f883e', '0', 1);
INSERT INTO `users` VALUES (22, '01712', 1, 2, '罗茂海', 3, '4cec724674f1872b56a17dabd41ef4f8', '1', 0);
INSERT INTO `users` VALUES (23, '22410', 1, 1, '彭荣茂', 3, '96e79218965eb72c92a549dd5a330112', '1', 1);
INSERT INTO `users` VALUES (24, '20084', 1, 2, '秦言擎', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (25, '12681', 1, 2, '王伟强', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (26, '03515', 1, 4, '王喻强', 1, '19204dbb26a7897524a495e4292bb0a3', '1', 1);
INSERT INTO `users` VALUES (27, '20787', 1, 1, '吴冬晖', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (28, '28616', 1, 2, '吴一鹏', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (29, '25715', 1, 3, '许尖钻', 3, 'd22a295a1b0343f32bea478e0c2fec4d', '1', 1);
INSERT INTO `users` VALUES (30, '22152', 1, 2, '杨宇辰', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 1);
INSERT INTO `users` VALUES (31, '00813', 1, 3, '颜河生', 3, 'e10adc3949ba59abbe56e057f20f883e', '1', 0);
INSERT INTO `users` VALUES (32, '28689', 1, 2, '赵帅', 3, 'f2043ec1e2d9dad2cc82e59388107fbb', '1', 0);
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
) ENGINE = InnoDB AUTO_INCREMENT = 323 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `worktimeassign` VALUES (54, 8, 20, 3.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (55, 8, 21, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (56, 11, 22, 50.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (57, 13, 22, 40.0, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (58, 11, 23, 15.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (59, 11, 24, 12.0, 12.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (60, 11, 25, 18.0, 18.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (61, 11, 26, 1.5, 1.5, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (62, 11, 27, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (63, 11, 28, 20.0, 20.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (64, 11, 29, 10.0, 10.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (65, 29, 30, 0.0, 0.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (66, 14, 30, -50.0, -50.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (67, 24, 30, -150.0, -150.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (68, 15, 31, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (69, 23, 32, 9.0, 9.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (70, 13, 32, 6.0, 6.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (71, 15, 32, 3.0, 3.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (72, 27, 32, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (73, 7, 33, 5.0, 5.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (74, 7, 34, 10.0, 10.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (75, 13, 35, 6.0, 6.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (76, 7, 36, 2.5, 2.5, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (77, 13, 37, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (78, 7, 38, 10.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (79, 7, 39, 20.0, 19.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (80, 23, 40, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (81, 7, 41, 10.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (82, 23, 42, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (83, 7, 43, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (84, 7, 44, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (85, 7, 45, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (86, 7, 46, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (87, 7, 47, 3.0, 3.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (88, 7, 48, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (89, 7, 49, 3.0, 3.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (90, 8, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (91, 13, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (92, 14, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (93, 15, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (94, 23, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (95, 27, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (96, 11, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (97, 16, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (98, 17, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (99, 19, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (100, 20, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (101, 22, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (102, 24, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (103, 25, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (104, 28, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (105, 30, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (106, 32, 47, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (107, 16, 50, 5.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (108, 14, 51, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (109, 7, 51, 1.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (110, 13, 51, 1.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (111, 17, 51, 1.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (112, 14, 52, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (113, 7, 52, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (114, 13, 52, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (115, 17, 52, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (116, 16, 53, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (117, 7, 54, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (118, 7, 55, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (119, 13, 56, 12.0, 12.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (120, 7, 57, 16.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (121, 14, 58, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (122, 7, 58, 1.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (123, 17, 58, 1.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (124, 7, 59, 14.0, 14.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (125, 8, 59, 6.0, 6.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (126, 14, 60, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (127, 7, 60, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (128, 17, 60, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (129, 14, 61, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (130, 7, 61, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (131, 13, 61, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (132, 17, 61, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (133, 16, 62, 50.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (134, 16, 63, 50.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (135, 16, 64, 5.0, 5.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (136, 14, 65, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (137, 7, 65, 1.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (138, 14, 66, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (139, 7, 66, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (140, 13, 67, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (141, 13, 68, 3.0, 3.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (142, 13, 69, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (143, 15, 70, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (144, 7, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (145, 8, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (146, 11, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (147, 14, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (148, 16, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (149, 17, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (150, 19, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (151, 22, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (152, 23, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (153, 24, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (154, 25, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (155, 28, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (156, 32, 70, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (157, 13, 71, 0.5, 0.5, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (158, 7, 71, 0.5, 0.5, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (159, 8, 71, 0.5, 0.5, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (160, 15, 71, 0.5, 0.5, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (161, 28, 71, 0.5, 0.5, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (162, 27, 71, 0.5, 0.5, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (163, 23, 71, 0.5, 0.5, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (164, 13, 72, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (165, 7, 72, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (166, 8, 72, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (167, 15, 72, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (168, 23, 72, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (169, 27, 72, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (170, 28, 72, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (171, 13, 73, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (172, 7, 73, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (173, 8, 73, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (174, 14, 73, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (175, 15, 73, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (176, 23, 73, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (177, 27, 73, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (178, 13, 74, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (179, 32, 75, 3.0, 3.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (180, 7, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (181, 8, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (182, 14, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (183, 15, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (184, 16, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (185, 17, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (186, 19, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (187, 23, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (188, 28, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (189, 30, 75, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (190, 23, 76, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (191, 13, 77, 1.0, 1.0, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (192, 7, 77, 0.0, 1.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (193, 8, 77, 0.0, 0.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (194, 15, 77, 0.0, 0.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (195, 23, 77, 0.0, 0.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (196, 28, 77, 0.0, 0.0, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (197, 7, 78, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (198, 7, 79, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (199, 7, 80, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (200, 7, 81, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (201, 7, 82, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (202, 7, 83, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (203, 7, 84, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (204, 28, 85, 16.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (205, 7, 86, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (206, 7, 87, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (207, 7, 88, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (208, 7, 89, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (209, 16, 90, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (210, 7, 91, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (211, 7, 92, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (212, 7, 93, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (213, 8, 94, 0.5, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (214, 16, 95, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (215, 7, 96, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (216, 16, 97, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (217, 16, 98, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (218, 16, 99, 50.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (219, 16, 100, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (220, 23, 101, 3.0, 3.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (221, 13, 101, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (222, 23, 102, 6.2, 6.2, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (223, 13, 102, 4.0, 4.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (224, 16, 103, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (225, 16, 104, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (226, 8, 105, 6.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (227, 7, 106, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (228, 13, 107, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (229, 7, 107, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (230, 8, 107, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (231, 15, 107, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (232, 28, 107, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (233, 23, 107, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (234, 7, 108, 5.0, 5.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (235, 23, 109, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (236, 32, 109, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (237, 23, 110, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (238, 7, 111, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (239, 14, 111, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (240, 23, 112, 6.2, 6.2, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (241, 13, 112, 4.0, 4.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (242, 7, 113, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (243, 7, 114, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (244, 7, 115, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (245, 8, 115, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (246, 14, 115, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (247, 17, 115, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (248, 7, 116, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (249, 30, 116, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (250, 7, 117, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (251, 14, 117, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (252, 7, 118, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (253, 14, 118, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (254, 16, 119, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (255, 16, 120, 2.0, 0.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (256, 16, 121, 50.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (257, 7, 122, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (258, 27, 122, 4.0, 4.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (259, 7, 123, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (260, 8, 124, 6.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (261, 7, 124, 14.0, NULL, '协作者', 1);
INSERT INTO `worktimeassign` VALUES (262, 8, 125, 20.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (263, 8, 126, 20.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (264, 8, 127, 20.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (265, 15, 128, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (266, 15, 129, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (267, 8, 130, 6.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (268, 7, 130, 14.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (269, 8, 131, 14.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (270, 8, 132, 20.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (271, 8, 133, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (272, 8, 134, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (273, 15, 135, 20.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (274, 15, 136, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (275, 15, 137, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (276, 15, 138, 20.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (277, 15, 139, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (278, 15, 140, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (279, 8, 141, 10.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (280, 25, 141, 5.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (281, 8, 142, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (282, 8, 143, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (283, 8, 144, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (284, 15, 145, 20.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (285, 15, 146, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (286, 15, 147, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (287, 15, 148, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (288, 15, 149, 0.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (289, 8, 150, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (290, 15, 151, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (291, 8, 152, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (292, 8, 153, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (293, 15, 154, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (294, 15, 155, 5.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (295, 8, 156, 0.5, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (296, 7, 157, 5.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (297, 23, 158, 3.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (298, 7, 159, 6.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (299, 7, 131, 6.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (300, 7, 160, 4.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (301, 23, 161, 4.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (302, 27, 161, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (303, 7, 162, 20.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (304, 14, 162, 20.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (305, 7, 163, 10.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (306, 7, 164, 4.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (307, 23, 165, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (308, 23, 166, 7.5, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (309, 7, 167, 5.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (310, 8, 168, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (311, 7, 168, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (312, 23, 169, 4.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (313, 7, 170, 15.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (314, 8, 170, 5.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (315, 7, 171, 15.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (316, 23, 171, 5.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (317, 7, 172, 15.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (318, 23, 172, 5.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (319, 8, 173, 5.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (320, 7, 173, 5.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (321, 8, 174, 10.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (322, 24, 174, 5.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (323, 32, 175, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (324, 32, 176, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (325, 32, 177, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (326, 32, 178, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (327, 32, 179, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (328, 32, 180, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (329, 32, 181, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (330, 8, 182, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (331, 8, 183, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (332, 18, 184, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (333, 18, 185, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (334, 18, 186, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (335, 18, 187, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (336, 18, 188, 3.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (337, 29, 189, 4.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (338, 29, 190, 4.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (339, 18, 191, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (340, 18, 192, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (341, 18, 193, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (342, 18, 194, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (343, 18, 195, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (344, 18, 196, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (345, 8, 197, 19.5, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (346, 18, 198, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (347, 18, 199, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (348, 18, 200, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (349, 8, 201, 9.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (350, 29, 202, 3.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (351, 29, 203, 4.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (352, 18, 204, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (353, 18, 205, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (354, 18, 206, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (355, 18, 207, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (356, 18, 208, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (357, 18, 209, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (358, 18, 210, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (359, 18, 211, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (360, 32, 212, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (361, 32, 213, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (362, 18, 214, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (363, 32, 215, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (364, 32, 216, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (365, 23, 217, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (366, 32, 218, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (367, 8, 219, 6.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (368, 27, 219, 6.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (369, 30, 219, 3.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (370, 32, 220, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (371, 32, 221, 11.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (372, 32, 222, 11.0, 11.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (373, 32, 223, 11.0, 11.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (374, 17, 224, 10.0, 10.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (375, 33, 225, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (376, 33, 226, 5.0, 5.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (377, 33, 227, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (378, 33, 228, 5.0, 5.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (379, 33, 229, 10.0, 10.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (380, 33, 230, 30.0, 30.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (381, 33, 231, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (382, 29, 232, 5.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (383, 29, 233, 5.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (384, 30, 234, 15.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (385, 27, 234, 15.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (386, 8, 234, 10.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (387, 32, 235, 6.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (388, 18, 236, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (389, 33, 237, 3.0, 3.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (390, 33, 238, 20.0, 20.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (391, 33, 239, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (392, 33, 240, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (393, 33, 241, 3.0, 3.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (394, 33, 242, 5.0, 5.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (395, 33, 243, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (396, 33, 244, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (397, 33, 245, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (398, 33, 246, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (399, 33, 247, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (400, 33, 248, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (401, 33, 249, 3.0, 3.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (402, 33, 250, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (403, 33, 251, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (404, 33, 252, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (405, 18, 252, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (406, 12, 252, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (407, 31, 252, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (408, 29, 252, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (409, 9, 252, 2.0, 2.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (410, 33, 253, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (411, 31, 253, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (412, 29, 253, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (413, 18, 253, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (414, 12, 253, 1.0, 1.0, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (415, 33, 254, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (416, 33, 255, 1.5, 1.5, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (417, 33, 256, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (418, 33, 257, 2.0, 2.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (419, 18, 258, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (420, 29, 258, 0.5, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (421, 33, 259, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (422, 33, 260, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (423, 33, 261, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (424, 18, 262, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (425, 33, 263, 4.0, 4.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (426, 18, 264, 4.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (427, 33, 265, 1.0, 1.0, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (428, 18, 266, 4.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (429, 18, 267, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (430, 29, 268, 4.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (431, 18, 269, 0.5, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (432, 32, 270, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (433, 32, 271, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (434, 32, 272, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (435, 32, 273, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (436, 32, 274, 2.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (437, 32, 275, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (438, 32, 276, 1.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (439, 32, 277, 1.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (440, 32, 278, 3.0, NULL, '组织者', 1);
INSERT INTO `worktimeassign` VALUES (441, 32, 279, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (442, 18, 280, 4.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (443, 18, 281, 2.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (444, 18, 282, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (445, 7, 283, 3.0, NULL, '组织者', 0);
INSERT INTO `worktimeassign` VALUES (446, 8, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (447, 11, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (448, 14, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (449, 16, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (450, 17, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (451, 19, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (452, 22, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (453, 23, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (454, 24, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (455, 27, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (456, 30, 283, 2.0, NULL, '协作者', 0);
INSERT INTO `worktimeassign` VALUES (457, 32, 283, 2.0, NULL, '协作者', 0);

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
  `projectTypeID` int UNSIGNED NOT NULL COMMENT '项目类型ID',
  `applyKValue` double(5, 1) NOT NULL COMMENT '申报K值',
  `reviewKValue` double(5, 1) NULL DEFAULT NULL COMMENT '审核K值',
  `applyCofficient` double(5, 1) NOT NULL COMMENT '申报系数',
  `reviewCofficient` double(5, 1) NULL DEFAULT NULL COMMENT '审核系数',
  `submitTime` datetime(0) NOT NULL COMMENT '提交时间',
  `updateTime` datetime(0) NOT NULL COMMENT '更新时间',
  `applyMonth` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申报月份',
  `submitStatus` tinyint NOT NULL DEFAULT 0 COMMENT '提交状态',
  `submitComments` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '提交备注',
  `reviewStatus` tinyint NOT NULL DEFAULT 0 COMMENT '审核状态',
  `reviewTime` datetime(0) NULL DEFAULT NULL COMMENT '审核时间',
  `reviewComments` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '审核备注',
  `obsoleteStatus` tinyint NOT NULL DEFAULT 0 COMMENT '废弃状态',
  `workTimeAssignReviewStatus` tinyint NOT NULL DEFAULT 0 COMMENT '工时分配审核状态',
  `reviewer` int UNSIGNED NULL DEFAULT NULL COMMENT '审核人',
  `avaiableWorkTime` float(5, 1) NOT NULL DEFAULT 0.0 COMMENT '可用工时',
  `applyProcess` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '申报进展',
  `lastProcess` float(4, 1) UNSIGNED NOT NULL DEFAULT 0.0 COMMENT '上月进展',
  `applyType` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '' COMMENT '申报类型',
  `applyBaseWorkTime` float(6, 1) NOT NULL COMMENT '申报的基本工时（非标项目使用）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 175 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `worktimelist` VALUES (20, 102, 16, NULL, 8, 68, 1.0, NULL, 1.0, NULL, '2020-12-25 15:51:10', '2020-12-25 15:51:10', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 3.0, 100.0, 0.0, 'plan', 3.0);
INSERT INTO `worktimelist` VALUES (21, 23, 9, 15, 8, 175, 1.0, NULL, 1.0, NULL, '2020-12-25 15:54:06', '2020-12-25 15:54:06', '2021-01', 0, '', 0, NULL, '', 1, 0, NULL, 10.0, 50.0, 0.0, 'plan', 20.0);
INSERT INTO `worktimelist` VALUES (22, 103, 17, NULL, 11, 72, 3.0, NULL, 1.0, NULL, '2020-12-25 16:43:50', '2020-12-25 16:43:50', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 90.0, 30.0, 0.0, 'fact', 100.0);
INSERT INTO `worktimelist` VALUES (23, 104, 17, NULL, 11, 72, 3.0, NULL, 1.0, NULL, '2020-12-25 16:43:50', '2020-12-25 16:43:50', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 15.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (24, 138, 19, 27, 11, 72, 1.0, 1.0, 12.0, 12.0, '2020-12-25 17:12:20', '2020-12-25 17:12:20', '2020-12', 1, '1、上海风语筑文化科技股份有限公司参观考察。\n2、风语筑上海市工人文化宫案例进行参观。\n3、上海市飞来飞去展览设计工程有限公司考察交流。\n4、飞来飞去杭州海康威视案例进行参观。\n5、华为深圳机场智慧机场展厅参观考察。\n6、深圳机场党群服务中心展厅。\n7、参观深圳中视动科技总部。\n8、参观深圳中视动科技大潮起珠江展馆。\n9、参观深圳城市规划展厅。\n10、参观北京雪格案例深圳微银行展厅。\n11、参观福州高铭铁塔公司展厅。\n12、参观福州三坊七巷展馆。', 1, '2020-12-28 08:50:17', '', 0, 1, 17, 12.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (25, 139, 20, 26, 11, 89, 1.0, 1.0, 3.0, 3.0, '2020-12-25 17:14:25', '2020-12-25 17:14:25', '2020-12', 1, '1、20201202厦门到上海、上海到杭州\n2、20201203杭州到深圳\n3、20201204深圳到福州、福州到厦门（动车）', 1, '2020-12-28 08:49:57', '', 0, 1, 17, 18.0, 100.0, 0.0, 'fact', 6.0);
INSERT INTO `worktimelist` VALUES (26, 140, 21, 22, 11, 72, 1.5, 1.5, 1.0, 1.0, '2020-12-25 17:23:33', '2020-12-25 17:23:33', '2020-12', 1, '20201207到AOC查看乘务准备室线路，讨论布线方案。', 1, '2020-12-25 17:37:16', '', 0, 1, 17, 1.5, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (27, 141, 21, 24, 11, 72, 2.0, 2.0, 1.0, 1.0, '2020-12-25 17:23:33', '2020-12-25 17:29:20', '2020-12', 1, '20201224与赵帅到AOC园区说明光纤敷设管井路由', 1, '2020-12-28 08:49:39', '', 0, 1, 17, 2.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (28, 142, 21, 25, 11, 72, 20.0, 20.0, 1.0, 1.0, '2020-12-25 17:23:33', '2020-12-25 17:27:45', '2020-12', 1, '20201211-15处理整理零星修缮项目结算资料。', 1, '2020-12-28 08:49:47', '', 0, 1, 17, 20.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (29, 143, 22, 23, 11, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-25 17:36:10', '2020-12-25 17:36:10', '2020-12', 1, '1、完成桥架图纸检查单与施工检查单。\n2、办公网与设备网点位数量检查单（完成40%）。', 1, '2020-12-28 08:49:30', '', 0, 1, 17, 10.0, 20.0, 0.0, 'fact', 50.0);
INSERT INTO `worktimelist` VALUES (30, 144, 23, 121, 29, 125, 1.0, 1.0, 1.0, 1.0, '2020-12-28 09:25:38', '2020-12-28 09:25:38', '2020-12', 1, '胡章荣一次手册阅读超时，秦言擎三次手册阅读超时。', 1, '2020-12-29 09:27:21', '', 0, 1, 26, -50.0, 100.0, 0.0, 'fact', -50.0);
INSERT INTO `worktimelist` VALUES (31, 148, 27, NULL, 15, 72, 1.0, NULL, 1.0, NULL, '2020-12-28 11:24:10', '2020-12-28 11:24:10', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (32, 149, 28, 32, 23, 81, 1.0, 1.0, 5.0, 5.0, '2020-12-28 11:30:25', '2020-12-28 14:24:36', '2020-12', 1, '思科2次、亿联、全时、华为。', 1, '2020-12-28 14:33:29', '', 0, 1, 13, 10.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (33, 150, 29, 29, 7, 31, 1.0, 1.0, 1.0, 1.0, '2020-12-28 11:57:10', '2020-12-28 11:57:10', '2020-12', 1, '', 1, '2020-12-28 14:02:12', '', 0, 1, 13, 5.0, 50.0, 0.0, 'fact', 10.0);
INSERT INTO `worktimelist` VALUES (34, 151, 30, 28, 7, 31, 1.0, 1.0, 1.0, 1.0, '2020-12-28 12:00:47', '2020-12-28 12:00:47', '2020-12', 1, '', 1, '2020-12-28 14:02:04', '', 0, 1, 13, 10.0, 100.0, 0.0, 'fact', 10.0);
INSERT INTO `worktimelist` VALUES (35, 160, 33, 30, 13, 89, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:05:26', '2020-12-28 14:05:26', '2020-12', 1, '12.10、12.11公务外出至深圳考察平安大厦南塔会议音视频、VIVO大楼会议音视频、华润春笋大楼会议音视频系统、OPPO大楼会议管理系统。', 1, '2020-12-28 14:07:30', '', 0, 1, 13, 6.0, 100.0, 0.0, 'fact', 6.0);
INSERT INTO `worktimelist` VALUES (36, 165, 35, 81, 7, 28, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:10:44', '2020-12-28 14:10:44', '2020-12', 1, '', 1, '2020-12-28 16:09:00', '', 0, 1, 13, 2.5, 50.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (37, 166, 36, 31, 13, 316, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:11:48', '2020-12-28 14:11:48', '2020-12', 1, '总部大厦样板层会议信息发布屏预算执行流程提交', 1, '2020-12-28 14:32:50', '', 0, 1, 13, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (38, 167, 37, NULL, 7, 31, 1.0, NULL, 1.0, NULL, '2020-12-28 14:12:15', '2020-12-28 14:12:15', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 10.0, 100.0, 0.0, 'fact', 10.0);
INSERT INTO `worktimelist` VALUES (39, 168, 38, NULL, 7, 32, 1.0, NULL, 1.0, NULL, '2020-12-28 14:13:56', '2020-12-28 14:13:56', '2020-12', 1, '', 0, NULL, '', 0, 1, NULL, 20.0, 100.0, 0.0, 'fact', 20.0);
INSERT INTO `worktimelist` VALUES (40, 169, 39, 33, 23, 87, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:15:35', '2020-12-28 14:15:35', '2020-12', 1, '', 1, '2020-12-28 14:33:30', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (41, 170, 40, NULL, 7, 64, 1.0, NULL, 1.0, NULL, '2020-12-28 14:16:16', '2020-12-28 14:16:16', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 10.0, 100.0, 0.0, 'fact', 10.0);
INSERT INTO `worktimelist` VALUES (42, 171, 41, 34, 23, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:18:04', '2020-12-28 14:18:04', '2020-12', 1, '', 1, '2020-12-28 14:33:32', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (43, 172, 42, 82, 7, 65, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:18:53', '2020-12-28 14:18:53', '2020-12', 1, '', 1, '2020-12-28 16:09:21', '', 0, 1, 13, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (44, 173, 43, 101, 7, 65, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:19:48', '2020-12-28 14:19:48', '2020-12', 1, '', 1, '2020-12-28 16:27:07', '', 0, 1, 13, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (45, 174, 44, 99, 7, 65, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:20:20', '2020-12-28 14:20:20', '2020-12', 1, '', 1, '2020-12-28 16:26:54', '', 0, 1, 13, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (46, 175, 45, 98, 7, 67, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:21:07', '2020-12-28 14:21:07', '2020-12', 1, '', 1, '2020-12-28 16:26:44', '', 0, 1, 13, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (47, 176, 46, 87, 7, 68, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:21:46', '2020-12-28 14:35:58', '2020-12', 1, '', 1, '2020-12-28 16:11:57', '', 0, 1, 13, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (48, 177, 47, 97, 7, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:25:57', '2020-12-28 14:25:57', '2020-12', 1, '', 1, '2020-12-28 16:26:36', '', 0, 1, 13, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (49, 178, 48, 96, 7, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:27:05', '2020-12-28 14:27:05', '2020-12', 1, '', 1, '2020-12-28 16:26:30', '', 0, 1, 13, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (50, 191, 52, NULL, 16, 257, 1.0, NULL, 1.0, NULL, '2020-12-28 14:41:56', '2020-12-28 14:41:56', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 5.0, 100.0, 0.0, 'plan', 5.0);
INSERT INTO `worktimelist` VALUES (51, 192, 53, NULL, 14, 80, 1.0, NULL, 1.0, NULL, '2020-12-28 14:42:42', '2020-12-28 14:42:42', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'plan', 2.0);
INSERT INTO `worktimelist` VALUES (52, 192, 53, 37, 14, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:42:56', '2020-12-28 14:43:22', '2020-12', 1, '', 1, '2020-12-28 14:46:36', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (53, 191, 52, NULL, 16, 257, 1.0, NULL, 1.0, NULL, '2020-12-28 14:43:24', '2020-12-28 14:59:48', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (54, 193, 54, NULL, 7, 143, 1.0, NULL, 1.0, NULL, '2020-12-28 14:43:48', '2020-12-28 14:43:48', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (55, 194, 55, NULL, 7, 143, 1.0, NULL, 1.0, NULL, '2020-12-28 14:45:05', '2020-12-28 14:45:05', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (56, 195, 56, 38, 13, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:45:26', '2020-12-28 14:45:26', '2020-12', 1, '出差2天，考察4个系统建设项目案例，与一家供应商技术交流。', 1, '2020-12-28 14:46:50', '', 0, 1, 13, 12.0, 100.0, 0.0, 'fact', 12.0);
INSERT INTO `worktimelist` VALUES (57, 196, 57, NULL, 7, 144, 1.0, NULL, 1.0, NULL, '2020-12-28 14:47:15', '2020-12-28 14:47:15', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 16.0, 100.0, 0.0, 'fact', 16.0);
INSERT INTO `worktimelist` VALUES (58, 198, 59, NULL, 14, 81, 1.0, NULL, 1.0, NULL, '2020-12-28 14:51:00', '2020-12-28 14:51:00', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'plan', 2.0);
INSERT INTO `worktimelist` VALUES (59, 199, 60, 85, 7, 247, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:51:10', '2020-12-28 14:51:10', '2020-12', 1, '', 1, '2020-12-28 16:11:29', '', 0, 1, 13, 20.0, 100.0, 0.0, 'fact', 20.0);
INSERT INTO `worktimelist` VALUES (60, 198, 59, 57, 14, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:51:16', '2020-12-28 14:51:37', '2020-12', 1, '', 1, '2020-12-28 14:55:52', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (61, 192, 53, 56, 14, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-28 14:51:18', '2020-12-28 14:51:38', '2020-12', 1, '', 1, '2020-12-28 14:55:50', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (62, 200, 61, NULL, 16, 262, 1.0, NULL, 1.0, NULL, '2020-12-28 14:58:55', '2020-12-28 14:58:55', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 50.0, 100.0, 0.0, 'plan', 50.0);
INSERT INTO `worktimelist` VALUES (63, 200, 61, NULL, 16, 262, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:00:00', '2020-12-28 15:00:17', '2020-12', 1, '', 2, '2020-12-28 16:42:02', '', 0, 0, 17, 50.0, 100.0, 0.0, 'fact', 50.0);
INSERT INTO `worktimelist` VALUES (64, 191, 52, 108, 16, 257, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:00:07', '2020-12-28 15:00:19', '2020-12', 1, '', 1, '2020-12-28 16:42:17', '', 0, 1, 17, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (65, 201, 62, NULL, 14, 80, 1.0, NULL, 1.0, NULL, '2020-12-28 15:00:56', '2020-12-28 15:00:56', '2020-12', 1, '与运保沟通统一监控平台建设方案', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'plan', 2.0);
INSERT INTO `worktimelist` VALUES (66, 201, 62, 63, 14, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:01:03', '2020-12-28 15:01:06', '2020-12', 1, '与运保沟通统一监控平台建设方案', 1, '2020-12-28 15:07:35', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (67, 202, 63, 60, 13, 72, 1.0, 1.0, 2.0, 2.0, '2020-12-28 15:06:58', '2020-12-28 15:06:58', '2020-12', 1, '12.14、12.15会议讨论', 1, '2020-12-28 15:07:24', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (68, 203, 63, 62, 13, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:06:58', '2020-12-28 15:06:58', '2020-12', 1, '12.17下午参加部门头脑风暴', 1, '2020-12-28 15:07:27', '', 0, 1, 13, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (69, 204, 63, 61, 13, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:06:58', '2020-12-28 15:06:58', '2020-12', 1, '12.21参加第三组头脑风暴讨论及材料整理', 1, '2020-12-28 15:07:26', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (70, 205, 64, 64, 15, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:19:38', '2020-12-28 15:19:38', '2020-12', 1, '', 1, '2020-12-28 15:27:51', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (71, 206, 65, 72, 13, 60, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:20:30', '2020-12-28 15:20:30', '2020-12', 1, '12.28召开党小组会议', 1, '2020-12-28 16:00:00', '', 0, 1, 13, 0.5, 100.0, 0.0, 'fact', 0.5);
INSERT INTO `worktimelist` VALUES (72, 207, 66, 74, 13, 80, 1.0, 1.0, 2.0, 2.0, '2020-12-28 15:22:26', '2020-12-28 15:22:26', '2020-12', 1, '12.15、12.22党支部大会', 1, '2020-12-28 16:00:30', '', 0, 1, 13, 4.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (73, 212, 68, 76, 13, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:23:55', '2020-12-28 15:23:55', '2020-12', 1, '12.8技术标准组例会', 1, '2020-12-28 16:00:38', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (74, 213, 69, 77, 13, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:27:07', '2020-12-28 15:27:07', '2020-12', 1, '12.14参加党支部支委会', 1, '2020-12-28 16:00:45', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (75, 214, 70, 95, 32, 68, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:35:02', '2020-12-28 15:35:02', '2020-12', 1, '', 1, '2020-12-28 16:26:06', '', 0, 1, 17, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (76, 215, 71, 65, 23, 145, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:35:19', '2020-12-28 15:35:19', '2020-12', 1, '', 1, '2020-12-28 15:38:04', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (77, 216, 72, NULL, 13, 55, 1.0, NULL, 1.0, NULL, '2020-12-28 15:37:19', '2020-12-28 15:37:19', '2020-12', 0, '12月党建E家及学习强国学习', 0, NULL, '', 1, 1, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (78, 217, 73, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:45:57', '2020-12-28 15:45:57', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (79, 218, 74, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:46:21', '2020-12-28 15:46:21', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (80, 219, 75, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:46:56', '2020-12-28 15:46:56', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (81, 220, 76, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:47:27', '2020-12-28 15:47:27', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (82, 221, 77, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:47:56', '2020-12-28 15:47:56', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (83, 222, 78, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:48:25', '2020-12-28 15:48:25', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (84, 223, 79, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:48:53', '2020-12-28 15:48:53', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (85, 224, 80, NULL, 28, 88, 1.0, NULL, 4.0, NULL, '2020-12-28 15:48:55', '2020-12-28 15:48:55', '2020-12', 0, '', 0, NULL, '', 0, 0, NULL, 16.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (86, 225, 81, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:49:20', '2020-12-28 15:49:20', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (87, 226, 82, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:49:45', '2020-12-28 15:49:45', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (88, 227, 83, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:50:25', '2020-12-28 15:50:25', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (89, 228, 84, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:50:53', '2020-12-28 15:50:53', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (90, 229, 85, NULL, 16, 55, 1.0, NULL, 1.0, NULL, '2020-12-28 15:51:10', '2020-12-28 15:51:10', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 1.0, 100.0, 0.0, 'plan', 1.0);
INSERT INTO `worktimelist` VALUES (91, 230, 86, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:51:17', '2020-12-28 15:51:17', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (92, 231, 87, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:51:38', '2020-12-28 15:51:38', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (93, 232, 88, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:52:00', '2020-12-28 15:52:00', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (94, 233, 89, NULL, 8, 56, 1.0, NULL, 1.0, NULL, '2020-12-28 15:52:15', '2020-12-28 17:19:29', '2020-12', 1, '完成月度福建共青团青年大学习任务', 0, NULL, '', 0, 0, NULL, 0.5, 100.0, 0.0, 'fact', 0.5);
INSERT INTO `worktimelist` VALUES (95, 234, 90, NULL, 16, 272, 1.0, NULL, 1.0, NULL, '2020-12-28 15:52:17', '2020-12-28 15:52:17', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 1.0, 100.0, 0.0, 'plan', 1.0);
INSERT INTO `worktimelist` VALUES (96, 235, 91, NULL, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:52:29', '2020-12-28 15:52:29', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (97, 234, 90, 103, 16, 272, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:53:40', '2020-12-28 15:55:20', '2020-12', 1, '', 1, '2020-12-28 16:27:22', '', 0, 1, 17, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (98, 229, 85, 102, 16, 55, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:53:43', '2020-12-28 15:55:36', '2020-12', 1, '', 1, '2020-12-28 16:27:15', '', 0, 1, 17, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (99, 200, 61, NULL, 16, 262, 1.0, NULL, 1.0, NULL, '2020-12-28 15:53:51', '2020-12-28 15:53:51', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 50.0, 100.0, 0.0, 'fact', 50.0);
INSERT INTO `worktimelist` VALUES (100, 191, 52, NULL, 16, 257, 1.0, NULL, 1.0, NULL, '2020-12-28 15:53:56', '2020-12-28 15:53:56', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (101, 236, 92, 106, 23, 215, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:55:32', '2020-12-28 16:10:23', '2020-12', 1, '', 1, '2020-12-28 16:28:53', '', 0, 1, 13, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (102, 237, 92, 107, 23, 216, 1.7, 1.7, 1.0, 1.0, '2020-12-28 15:55:32', '2020-12-28 16:10:23', '2020-12', 1, '', 1, '2020-12-28 16:28:54', '', 0, 1, 13, 10.2, 30.0, 0.0, 'fact', 20.0);
INSERT INTO `worktimelist` VALUES (103, 266, 93, NULL, 16, 272, 1.0, NULL, 1.0, NULL, '2020-12-28 15:56:31', '2020-12-28 15:56:31', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 1.0, 100.0, 0.0, 'plan', 1.0);
INSERT INTO `worktimelist` VALUES (104, 266, 93, 100, 16, 272, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:56:43', '2020-12-28 15:56:50', '2020-12', 1, '', 1, '2020-12-28 16:27:06', '', 0, 1, 17, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (105, 267, 94, NULL, 8, 89, 1.0, NULL, 1.0, NULL, '2020-12-28 15:58:04', '2020-12-28 17:19:12', '2020-12', 1, '12月18日出差杭州调研A地块应急指挥室改造项目需求', 0, NULL, '', 0, 0, NULL, 6.0, 100.0, 0.0, 'fact', 6.0);
INSERT INTO `worktimelist` VALUES (106, 217, 73, 70, 7, 95, 1.0, NULL, 1.0, NULL, '2020-12-28 15:58:56', '2020-12-28 15:58:56', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (107, 268, 95, 78, 13, 55, 1.0, 1.0, 1.0, 1.0, '2020-12-28 15:59:35', '2020-12-28 15:59:35', '2020-12', 1, '12月党建E家、学习强国学习', 1, '2020-12-28 16:00:53', '', 0, 1, 13, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (108, 270, 97, 86, 7, 143, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:04:30', '2020-12-28 16:04:30', '2020-12', 1, '', 1, '2020-12-28 16:11:36', '', 0, 1, 13, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (109, 271, 98, 104, 23, 215, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:05:46', '2020-12-28 16:05:46', '2020-12', 1, '', 1, '2020-12-28 16:28:50', '', 0, 1, 13, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (110, 272, 98, 105, 23, 216, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:05:46', '2020-12-28 16:05:46', '2020-12', 1, '', 1, '2020-12-28 16:28:51', '', 0, 1, 13, 4.0, 20.0, 0.0, 'fact', 20.0);
INSERT INTO `worktimelist` VALUES (111, 301, 99, 83, 7, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:08:22', '2020-12-28 16:08:22', '2020-12', 1, '', 1, '2020-12-28 16:11:01', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (112, 239, 92, 69, 23, 218, 1.7, 1.7, 1.0, 1.0, '2020-12-28 16:08:41', '2020-12-28 16:10:24', '2020-12', 1, '', 1, '2020-12-28 16:28:49', '', 0, 1, 13, 10.2, 30.0, 0.0, 'fact', 20.0);
INSERT INTO `worktimelist` VALUES (113, 302, 100, 84, 7, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:09:54', '2020-12-28 16:09:54', '2020-12', 1, '', 1, '2020-12-28 16:11:05', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (114, 303, 101, 94, 7, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:12:28', '2020-12-28 16:12:28', '2020-12', 1, '', 1, '2020-12-28 16:26:01', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (115, 304, 102, 92, 7, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:13:39', '2020-12-28 16:13:39', '2020-12', 1, '', 1, '2020-12-28 16:25:37', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (116, 305, 103, 91, 7, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:15:12', '2020-12-28 16:15:12', '2020-12', 1, '', 1, '2020-12-28 16:25:24', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (117, 306, 104, 90, 7, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:16:48', '2020-12-28 16:16:48', '2020-12', 1, '', 1, '2020-12-28 16:25:15', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (118, 307, 105, 89, 7, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:17:23', '2020-12-28 16:17:23', '2020-12', 1, '', 1, '2020-12-28 16:25:08', '', 0, 1, 13, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (119, 308, 106, NULL, 16, 55, 1.0, NULL, 2.0, NULL, '2020-12-28 16:22:43', '2020-12-28 16:22:43', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'plan', 1.0);
INSERT INTO `worktimelist` VALUES (120, 308, 106, NULL, 16, 55, 1.0, 1.0, 2.0, 2.0, '2020-12-28 16:22:49', '2020-12-28 16:22:58', '2020-12', 1, '', 2, '2020-12-28 16:36:39', '', 0, 1, 17, 2.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (121, 200, 61, NULL, 16, 262, 1.0, NULL, 1.0, NULL, '2020-12-28 16:23:49', '2020-12-28 16:23:49', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 50.0, 100.0, 0.0, 'fact', 50.0);
INSERT INTO `worktimelist` VALUES (122, 309, 107, 93, 7, 143, 1.0, 1.0, 1.0, 1.0, '2020-12-28 16:24:32', '2020-12-28 16:24:32', '2020-12', 1, '', 1, '2020-12-28 16:25:54', '', 0, 1, 13, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (123, 310, 108, NULL, 7, 72, 1.0, NULL, 1.0, NULL, '2020-12-28 16:28:48', '2020-12-28 16:28:48', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (124, 311, 109, NULL, 8, 250, 4.0, NULL, 1.0, NULL, '2020-12-28 16:53:43', '2020-12-28 16:53:43', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (125, 312, 109, NULL, 8, 251, 4.0, NULL, 1.0, NULL, '2020-12-28 16:53:43', '2020-12-28 16:53:43', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (126, 313, 109, NULL, 8, 252, 4.0, NULL, 1.0, NULL, '2020-12-28 16:53:43', '2020-12-28 16:53:43', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (127, 314, 109, NULL, 8, 253, 4.0, NULL, 1.0, NULL, '2020-12-28 16:53:43', '2020-12-28 16:53:43', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (128, 315, 110, NULL, 15, 26, 1.0, NULL, 1.0, NULL, '2020-12-28 16:53:55', '2020-12-28 16:53:55', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (129, 316, 111, NULL, 15, 72, 1.0, NULL, 1.0, NULL, '2020-12-28 16:54:19', '2020-12-28 16:54:19', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (130, 317, 112, NULL, 8, 250, 4.0, NULL, 1.0, NULL, '2020-12-28 17:00:24', '2020-12-28 17:00:24', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (131, 318, 112, 110, 8, 251, 4.0, NULL, 1.0, NULL, '2020-12-28 17:13:26', '2020-12-29 08:53:38', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (132, 321, 113, NULL, 8, 251, 4.0, NULL, 1.0, NULL, '2020-12-28 17:39:24', '2020-12-28 17:40:34', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (133, 322, 113, NULL, 8, 252, 4.0, NULL, 1.0, NULL, '2020-12-28 17:39:24', '2020-12-28 17:39:24', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (134, 323, 113, NULL, 8, 253, 4.0, NULL, 1.0, NULL, '2020-12-28 17:39:24', '2020-12-28 17:39:24', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (135, 324, 114, NULL, 15, 251, 4.0, NULL, 1.0, NULL, '2020-12-28 17:47:11', '2020-12-28 17:47:11', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (136, 325, 114, NULL, 15, 252, 4.0, NULL, 1.0, NULL, '2020-12-28 17:47:11', '2020-12-28 17:47:11', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (137, 326, 114, NULL, 15, 253, 4.0, NULL, 1.0, NULL, '2020-12-28 17:47:11', '2020-12-28 17:47:11', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (138, 327, 115, NULL, 15, 251, 4.0, NULL, 1.0, NULL, '2020-12-28 17:50:56', '2020-12-28 17:50:56', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (139, 328, 115, NULL, 15, 252, 4.0, NULL, 1.0, NULL, '2020-12-28 17:50:56', '2020-12-28 17:50:56', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (140, 329, 115, NULL, 15, 253, 4.0, NULL, 1.0, NULL, '2020-12-28 17:50:56', '2020-12-28 17:50:56', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (141, 330, 116, NULL, 8, 250, 3.0, NULL, 1.0, NULL, '2020-12-28 17:52:22', '2020-12-29 09:08:41', '2020-12', 1, '', 0, NULL, '', 0, 1, NULL, 15.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (142, 331, 116, NULL, 8, 251, 3.0, NULL, 1.0, NULL, '2020-12-28 17:52:22', '2020-12-28 17:52:22', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (143, 332, 116, NULL, 8, 252, 3.0, NULL, 1.0, NULL, '2020-12-28 17:52:22', '2020-12-28 17:52:22', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (144, 333, 116, NULL, 8, 253, 3.0, NULL, 1.0, NULL, '2020-12-28 17:52:22', '2020-12-28 17:52:22', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (145, 334, 117, NULL, 15, 251, 4.0, NULL, 1.0, NULL, '2020-12-28 17:55:09', '2020-12-28 17:55:09', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 20.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (146, 340, 119, NULL, 15, 250, 1.0, NULL, 1.0, NULL, '2020-12-28 17:58:50', '2020-12-28 17:58:50', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (147, 341, 119, NULL, 15, 251, 1.0, NULL, 1.0, NULL, '2020-12-28 17:58:50', '2020-12-28 17:58:50', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (148, 342, 119, NULL, 15, 252, 1.0, NULL, 1.0, NULL, '2020-12-28 17:58:50', '2020-12-28 17:58:50', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (149, 343, 119, NULL, 15, 253, 1.0, NULL, 1.0, NULL, '2020-12-28 17:58:50', '2020-12-28 17:58:50', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 0.0, 0.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (150, 344, 120, NULL, 8, 72, 1.0, NULL, 1.0, NULL, '2020-12-28 18:20:24', '2020-12-28 18:20:24', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (151, 345, 121, NULL, 15, 72, 1.0, NULL, 1.0, NULL, '2020-12-28 18:28:14', '2020-12-28 18:28:14', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (152, 346, 122, NULL, 8, 72, 1.0, NULL, 1.0, NULL, '2020-12-28 18:33:40', '2020-12-28 18:35:02', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (153, 347, 122, NULL, 8, 72, 1.0, NULL, 1.0, NULL, '2020-12-28 18:33:40', '2020-12-29 08:57:08', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (154, 349, 123, NULL, 15, 72, 1.0, NULL, 1.0, NULL, '2020-12-28 18:34:04', '2020-12-28 18:34:04', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (155, 350, 124, NULL, 15, 26, 1.0, NULL, 1.0, NULL, '2020-12-28 18:35:22', '2020-12-28 18:35:22', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (156, 348, 122, 111, 8, 72, 1.0, NULL, 1.0, NULL, '2020-12-28 18:37:24', '2020-12-28 18:40:17', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 0.5, 50.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (157, 351, 125, NULL, 7, 143, 1.0, NULL, 1.0, NULL, '2020-12-29 08:21:51', '2020-12-29 08:21:51', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (158, 353, 127, NULL, 23, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 08:30:57', '2020-12-29 09:06:35', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (159, 354, 128, NULL, 7, 72, 1.0, NULL, 2.0, NULL, '2020-12-29 08:52:58', '2020-12-29 08:52:58', '2021-01', 1, '', 0, NULL, '', 0, 0, NULL, 6.0, 100.0, 0.0, 'plan', 3.0);
INSERT INTO `worktimelist` VALUES (160, 355, 129, NULL, 7, 145, 1.0, NULL, 2.0, NULL, '2020-12-29 08:55:00', '2020-12-29 08:55:00', '2021-01', 1, '', 0, NULL, '', 0, 0, NULL, 4.0, 100.0, 0.0, 'plan', 2.0);
INSERT INTO `worktimelist` VALUES (161, 356, 130, NULL, 23, 80, 1.0, NULL, 2.0, NULL, '2020-12-29 08:57:35', '2020-12-29 08:57:35', '2020-12', 0, '针对总部大厦和配餐园区等梯控需求，组织综合开发、凯迪、中控等单位讨论方案。', 0, NULL, '', 0, 0, NULL, 4.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (162, 357, 131, NULL, 7, 218, 1.0, NULL, 2.0, NULL, '2020-12-29 08:59:38', '2020-12-29 08:59:38', '2021-01', 1, '', 0, NULL, '', 0, 0, NULL, 40.0, 100.0, 0.0, 'plan', 20.0);
INSERT INTO `worktimelist` VALUES (163, 358, 132, NULL, 7, 64, 1.0, NULL, 1.0, NULL, '2020-12-29 09:01:19', '2020-12-29 09:01:19', '2020-01', 1, '', 0, NULL, '', 0, 0, NULL, 10.0, 100.0, 0.0, 'plan', 10.0);
INSERT INTO `worktimelist` VALUES (164, 359, 133, NULL, 7, 67, 1.0, NULL, 1.0, NULL, '2020-12-29 09:02:44', '2020-12-29 09:02:44', '2021-01', 1, '', 0, NULL, '', 0, 0, NULL, 4.0, 100.0, 0.0, 'plan', 4.0);
INSERT INTO `worktimelist` VALUES (165, 360, 134, NULL, 23, 17, 1.5, NULL, 1.0, NULL, '2020-12-29 09:04:35', '2020-12-29 09:04:35', '2020-12', 0, '本月完成选型，申报剩余8.5工时。', 0, NULL, '', 0, 0, NULL, 18.0, 100.0, 0.0, 'fact', 12.0);
INSERT INTO `worktimelist` VALUES (166, 361, 134, NULL, 23, 18, 1.5, NULL, 1.0, NULL, '2020-12-29 09:04:35', '2020-12-29 09:04:35', '2020-12', 0, '本月完成选型，申报剩余8.5工时。', 0, NULL, '', 0, 0, NULL, 7.5, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (167, 362, 135, NULL, 7, 69, 1.0, NULL, 1.0, NULL, '2020-12-29 09:04:53', '2020-12-29 09:04:53', '2020-01', 1, '', 0, NULL, '', 0, 0, NULL, 5.0, 100.0, 0.0, 'plan', 5.0);
INSERT INTO `worktimelist` VALUES (168, 363, 136, NULL, 8, 250, 1.0, NULL, 1.0, NULL, '2020-12-29 09:07:19', '2020-12-29 09:07:19', '2020-12', 0, '', 0, NULL, '', 0, 0, NULL, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (169, 367, 137, NULL, 23, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 09:07:55', '2020-12-29 09:07:55', '2020-12', 0, '', 0, NULL, '', 0, 0, NULL, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (170, 368, 138, NULL, 7, 247, 1.0, NULL, 1.0, NULL, '2020-12-29 09:10:10', '2020-12-29 09:10:10', '2021-01', 1, '', 0, NULL, '', 0, 0, NULL, 20.0, 100.0, 0.0, 'plan', 20.0);
INSERT INTO `worktimelist` VALUES (171, 369, 139, NULL, 7, 29, 1.0, NULL, 1.0, NULL, '2020-12-29 09:15:19', '2020-12-29 09:15:19', '2021-01', 1, '', 0, NULL, '', 0, 0, NULL, 20.0, 100.0, 0.0, 'plan', 20.0);
INSERT INTO `worktimelist` VALUES (172, 370, 140, NULL, 7, 29, 1.0, NULL, 1.0, NULL, '2020-12-29 09:16:47', '2020-12-29 09:16:47', '2021-01', 1, '', 0, NULL, '', 0, 0, NULL, 20.0, 100.0, 0.0, 'plan', 20.0);
INSERT INTO `worktimelist` VALUES (173, 371, 141, NULL, 8, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 09:30:10', '2020-12-29 09:30:10', '2020-12', 1, '模拟机二期BA已过保，为解决现存系统故障，多次与物业、后保、运保处进行沟通，讨论解决方案。', 0, NULL, '', 0, 0, NULL, 10.0, 100.0, 0.0, 'fact', 10.0);
INSERT INTO `worktimelist` VALUES (174, 372, 141, NULL, 8, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 09:30:10', '2020-12-29 09:30:10', '2020-12', 1, '1、陈迪12月2日与后保肖国强、培训部物业对BA现场设备进行初次排查\n2、陈迪、秦言擎12月16日与后保肖国强、培训物业、建设方恒锋、三拓相关人员到现场进行详细故障排查，梳理责任归属，并整理汇总问题清单', 0, NULL, '', 0, 0, NULL, 15.0, 100.0, 0.0, 'fact', 15.0);
INSERT INTO `worktimelist` VALUES (175, 374, 142, NULL, 32, 75, 1.0, NULL, 1.0, NULL, '2020-12-29 09:51:24', '2020-12-29 09:51:24', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (176, 375, 142, NULL, 32, 76, 1.0, NULL, 1.0, NULL, '2020-12-29 09:51:24', '2020-12-29 09:51:24', '2021-01', 1, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (177, 374, 142, 123, 32, 75, 1.0, NULL, 1.0, NULL, '2020-12-29 09:53:44', '2020-12-29 09:53:44', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (178, 374, 142, 123, 32, 75, 1.0, NULL, 1.0, NULL, '2020-12-29 09:54:27', '2020-12-29 09:54:27', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (179, 375, 142, 125, 32, 76, 1.0, NULL, 1.0, NULL, '2020-12-29 09:54:27', '2020-12-29 09:54:27', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (180, 374, 142, 123, 32, 75, 1.0, NULL, 1.0, NULL, '2020-12-29 09:54:51', '2020-12-29 09:54:51', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (181, 375, 142, 125, 32, 76, 1.0, NULL, 1.0, NULL, '2020-12-29 09:54:51', '2020-12-29 09:54:51', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (182, 376, 143, NULL, 8, 77, 1.0, NULL, 1.0, NULL, '2020-12-29 09:56:08', '2020-12-29 09:56:08', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (183, 377, 144, NULL, 8, 106, 1.0, NULL, 1.0, NULL, '2020-12-29 10:07:32', '2020-12-29 10:07:32', '2020-12', 1, '新基地弱电机房排风系统增配项目由后保框架供应商施工，使用后保修缮工程预算，需到基建财务系统里进行工程结算。', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (184, 378, 145, NULL, 18, 80, 1.0, NULL, 1.0, NULL, '2020-12-29 10:24:48', '2020-12-29 10:24:48', '2020-12', 0, '参加会议', 0, NULL, '', 1, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (185, 379, 146, NULL, 18, 80, 1.0, NULL, 1.0, NULL, '2020-12-29 10:26:10', '2020-12-29 10:26:10', '2020-12', 1, '参加会议1工时', 0, NULL, '', 1, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (186, 380, 147, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 10:35:04', '2020-12-29 10:35:04', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (187, 381, 148, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 10:36:07', '2020-12-29 10:36:07', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (188, 382, 149, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 10:40:08', '2020-12-29 10:40:08', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (189, 383, 150, NULL, 29, 234, 1.0, NULL, 1.0, NULL, '2020-12-29 10:40:31', '2020-12-29 11:39:29', '2020-12', 0, '友邻录音采购框架和维保服务谈判', 0, NULL, '', 1, 0, NULL, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (190, 384, 151, NULL, 29, 234, 1.0, NULL, 1.0, NULL, '2020-12-29 10:41:36', '2020-12-29 10:41:36', '2020-12', 0, 'avaya系统框架采购谈判', 0, NULL, '', 1, 0, NULL, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (191, 385, 152, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 10:41:58', '2020-12-29 10:41:58', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (192, 386, 153, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 10:42:51', '2020-12-29 10:42:51', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (193, 387, 154, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 10:43:23', '2020-12-29 10:43:23', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (194, 388, 155, NULL, 18, 382, 1.0, NULL, 1.0, NULL, '2020-12-29 10:46:28', '2020-12-29 10:46:28', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (195, 389, 156, NULL, 18, 95, 1.0, NULL, 1.0, NULL, '2020-12-29 10:46:59', '2020-12-29 10:46:59', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (196, 390, 157, NULL, 18, 382, 1.0, NULL, 1.0, NULL, '2020-12-29 10:47:34', '2020-12-29 10:47:34', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (197, 391, 158, NULL, 8, 94, 1.0, NULL, 13.0, NULL, '2020-12-29 10:48:34', '2020-12-29 16:54:42', '2020-12', 0, '1、INC202012230088\n2、INC202012260010\n3、INC202012170101\n4、INC202012150087\n5、INC202012100058\n6、处理黄毅、郑小暄等12人权限缺失处理（职服韩艳波派单）\n7、许盛鸿、林晓迪权限缺失处理（福州人力王怡派单）\n8、徐诣周改名处理（用户自行联系）\n9、林芳1无法接收考勤通知处理（用户自行联系）\n10、张鹭虹信息无法同步处理（职服韩艳波派单）\n11、王娟娟信息无法同步处理（国旅行政杨啟彬派单）\n12、叶政行无法接收考勤通知处理（用户自行联系）\n13、沈益祺无法识别处理（杭州人力陈硕妍派单）', 0, NULL, '', 0, 0, NULL, 19.5, 100.0, 0.0, 'fact', 1.5);
INSERT INTO `worktimelist` VALUES (198, 392, 159, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 10:50:11', '2020-12-29 10:50:11', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (199, 393, 160, NULL, 18, 382, 1.0, NULL, 1.0, NULL, '2020-12-29 10:51:08', '2020-12-29 10:51:08', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (200, 394, 161, NULL, 18, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 10:54:30', '2020-12-29 10:54:30', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (201, 395, 162, NULL, 8, 100, 1.0, NULL, 3.0, NULL, '2020-12-29 10:55:08', '2020-12-29 10:55:08', '2020-12', 1, '1、完成旧作息管理系统中本处每月排班与关账。\n2、完成新人力业务系统中本处每月排班与关账，提醒考勤异常员工及时提交补漏流程，并编写本处考勤管理要求。\n3、完成人脸识别系统日常设备增减与人员权限下发。', 0, NULL, '', 0, 0, NULL, 9.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (202, 420, 164, NULL, 29, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 11:01:10', '2020-12-29 11:01:10', '2020-12', 0, '杭州程控交换机系统CM无法登陆及无录音排故', 0, NULL, '', 1, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (203, 421, 165, NULL, 29, 91, 1.0, NULL, 1.0, NULL, '2020-12-29 11:03:16', '2020-12-29 11:03:16', '2020-12', 0, '语音导航系统工作日巡检', 0, NULL, '', 1, 0, NULL, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (204, 423, 167, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 11:18:16', '2020-12-29 11:18:16', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (205, 424, 168, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 11:18:32', '2020-12-29 11:18:32', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (206, 425, 169, NULL, 18, 97, 1.0, NULL, 1.0, NULL, '2020-12-29 11:19:11', '2020-12-29 11:19:11', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (207, 426, 170, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 11:19:55', '2020-12-29 11:19:55', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (208, 427, 171, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 11:20:36', '2020-12-29 11:20:36', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (209, 428, 172, NULL, 18, 96, 1.0, NULL, 1.0, NULL, '2020-12-29 11:21:00', '2020-12-29 11:21:00', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (210, 429, 173, NULL, 18, 100, 1.0, NULL, 1.0, NULL, '2020-12-29 11:21:36', '2020-12-29 11:21:36', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (211, 430, 174, NULL, 18, 96, 1.0, NULL, 1.0, NULL, '2020-12-29 11:22:10', '2020-12-29 11:22:10', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (212, 431, 175, NULL, 32, 75, 1.0, NULL, 1.0, NULL, '2020-12-29 11:23:20', '2020-12-29 11:23:20', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (213, 432, 175, NULL, 32, 76, 1.0, NULL, 1.0, NULL, '2020-12-29 11:23:20', '2020-12-29 11:23:20', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (214, 433, 176, NULL, 18, 92, 1.0, NULL, 1.0, NULL, '2020-12-29 11:23:30', '2020-12-29 11:23:30', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (215, 434, 177, NULL, 32, 75, 1.0, NULL, 1.0, NULL, '2020-12-29 11:24:16', '2020-12-29 11:24:16', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (216, 435, 178, NULL, 32, 76, 1.0, NULL, 1.0, NULL, '2020-12-29 11:24:41', '2020-12-29 11:24:41', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (217, 436, 179, NULL, 23, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 11:24:47', '2020-12-29 11:24:47', '2020-12', 0, '', 0, NULL, '', 0, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (218, 437, 180, NULL, 32, 75, 1.0, NULL, 1.0, NULL, '2020-12-29 11:25:23', '2020-12-29 11:25:23', '2020-12', 0, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (219, 438, 181, NULL, 8, 96, 1.0, NULL, 5.0, NULL, '2020-12-29 11:26:22', '2020-12-29 11:26:22', '2020-12', 1, '1、12月15日人脸系统权限下发异常，北京、杭州、厦门多地乘务无法签到，当天已解决故障。\n2、事后调取前端设备故障日志分析原因。', 0, NULL, '', 0, 0, NULL, 15.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (220, 439, 182, NULL, 32, 75, 1.0, NULL, 1.0, NULL, '2020-12-29 11:28:23', '2020-12-29 11:32:51', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (221, 440, 183, NULL, 32, 76, 1.0, NULL, 1.0, NULL, '2020-12-29 11:28:40', '2020-12-29 11:32:50', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (222, 439, 182, 127, 32, 75, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:34:09', '2020-12-29 11:34:42', '2020-12', 1, '', 1, '2020-12-29 11:41:02', '', 0, 1, 17, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (223, 440, 183, 129, 32, 76, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:35:14', '2020-12-29 11:35:50', '2020-12', 1, '', 1, '2020-12-29 11:40:48', '', 0, 1, 17, 11.0, 100.0, 0.0, 'fact', 11.0);
INSERT INTO `worktimelist` VALUES (224, 441, 184, 131, 17, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:39:27', '2020-12-29 11:45:20', '2020-12', 1, '完成末端修复，现场验收，交接', 1, '2020-12-29 11:50:05', '', 0, 1, 17, 10.0, 80.0, 60.0, 'fact', 50.0);
INSERT INTO `worktimelist` VALUES (225, 442, 185, 156, 33, 296, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:39:53', '2020-12-29 13:52:41', '2020-12', 1, '', 1, '2020-12-29 14:33:27', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (226, 443, 185, 157, 33, 312, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:39:53', '2020-12-29 13:52:41', '2020-12', 1, '', 1, '2020-12-29 14:33:32', '', 0, 1, 33, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (227, 444, 185, 158, 33, 313, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:39:53', '2020-12-29 13:52:41', '2020-12', 1, '', 1, '2020-12-29 14:33:37', '', 0, 1, 33, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (228, 445, 185, 159, 33, 314, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:39:53', '2020-12-29 13:52:40', '2020-12', 1, '', 1, '2020-12-29 14:33:42', '', 0, 1, 33, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (229, 446, 186, 155, 33, 118, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:41:08', '2020-12-29 13:52:42', '2020-12', 1, '', 1, '2020-12-29 14:33:23', '', 0, 1, 33, 10.0, 100.0, 0.0, 'fact', 10.0);
INSERT INTO `worktimelist` VALUES (230, 447, 187, 154, 33, 117, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:41:50', '2020-12-29 13:52:43', '2020-12', 1, '', 1, '2020-12-29 14:33:18', '', 0, 1, 33, 30.0, 100.0, 0.0, 'fact', 30.0);
INSERT INTO `worktimelist` VALUES (231, 448, 188, 153, 33, 384, 1.0, 1.0, 1.0, 1.0, '2020-12-29 11:46:04', '2020-12-29 13:52:43', '2020-12', 1, '', 1, '2020-12-29 14:33:12', '', 0, 1, 33, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (232, 449, 189, NULL, 29, 317, 1.0, NULL, 1.0, NULL, '2020-12-29 11:49:24', '2020-12-29 15:08:08', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 5.0, 50.0, 0.0, 'fact', 10.0);
INSERT INTO `worktimelist` VALUES (233, 450, 190, NULL, 29, 317, 1.0, NULL, 1.0, NULL, '2020-12-29 11:51:20', '2020-12-29 15:07:57', '2020-12', 1, '2020年客服中心扩容友邻录音框架采购及维保服务采购', 0, NULL, '', 0, 0, NULL, 5.0, 50.0, 0.0, 'fact', 10.0);
INSERT INTO `worktimelist` VALUES (234, 451, 191, NULL, 30, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 11:56:38', '2020-12-29 11:56:38', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 40.0, 100.0, 0.0, 'fact', 40.0);
INSERT INTO `worktimelist` VALUES (235, 452, 192, NULL, 32, 89, 1.0, NULL, 1.0, NULL, '2020-12-29 12:09:33', '2020-12-29 12:09:33', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 6.0, 100.0, 0.0, 'fact', 6.0);
INSERT INTO `worktimelist` VALUES (236, 453, 193, NULL, 18, 92, 1.0, NULL, 1.0, NULL, '2020-12-29 12:30:00', '2020-12-29 12:30:00', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (237, 454, 194, 152, 33, 384, 1.0, 1.0, 3.0, 3.0, '2020-12-29 13:47:37', '2020-12-29 13:52:44', '2020-12', 1, '共参加3次', 1, '2020-12-29 14:33:08', '', 0, 1, 33, 3.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (238, 455, 195, 151, 33, 104, 1.0, 1.0, 5.0, 5.0, '2020-12-29 13:52:28', '2020-12-29 13:52:44', '2020-12', 1, '共5次：12月4日，MF8451；12月5日，MF8432；12月14日，MF8119；12月18日，MF8172；12月26日，MF8172。', 1, '2020-12-29 14:33:03', '', 0, 1, 33, 20.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (239, 456, 196, 150, 33, 95, 1.0, 1.0, 1.0, 1.0, '2020-12-29 13:54:00', '2020-12-29 14:29:13', '2020-12', 1, '', 1, '2020-12-29 14:32:58', '', 0, 1, 33, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (240, 457, 197, 149, 33, 87, 1.0, 1.0, 1.0, 1.0, '2020-12-29 13:54:40', '2020-12-29 14:29:12', '2020-12', 1, '', 1, '2020-12-29 14:32:53', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (241, 458, 198, 148, 33, 100, 1.0, 1.0, 1.0, 1.0, '2020-12-29 13:58:04', '2020-12-29 14:29:12', '2020-12', 1, '', 1, '2020-12-29 14:32:48', '', 0, 1, 33, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (242, 459, 199, 147, 33, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-29 13:59:34', '2020-12-29 14:29:11', '2020-12', 1, '包括卫生、实验环境准备等', 1, '2020-12-29 14:32:43', '', 0, 1, 33, 5.0, 100.0, 0.0, 'fact', 5.0);
INSERT INTO `worktimelist` VALUES (243, 460, 200, 146, 33, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:00:43', '2020-12-29 14:29:09', '2020-12', 1, '', 1, '2020-12-29 14:32:38', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (244, 461, 201, 145, 33, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:01:44', '2020-12-29 14:29:08', '2020-12', 1, '', 1, '2020-12-29 14:32:34', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (245, 462, 202, 144, 33, 106, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:02:42', '2020-12-29 14:29:07', '2020-12', 1, '', 1, '2020-12-29 14:32:29', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (246, 463, 203, 143, 33, 80, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:04:49', '2020-12-29 14:29:07', '2020-12', 1, '', 1, '2020-12-29 14:32:24', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (247, 464, 204, 142, 33, 384, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:05:12', '2020-12-29 14:29:06', '2020-12', 1, '', 1, '2020-12-29 14:32:17', '', 0, 1, 33, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (248, 465, 205, 141, 33, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:05:59', '2020-12-29 14:29:05', '2020-12', 1, '', 1, '2020-12-29 14:32:12', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (249, 466, 206, 139, 33, 100, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:07:21', '2020-12-29 14:29:04', '2020-12', 1, '共11架飞机。', 1, '2020-12-29 14:32:00', '', 0, 1, 33, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (250, 467, 207, 140, 33, 97, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:08:27', '2020-12-29 14:29:03', '2020-12', 1, '', 1, '2020-12-29 14:32:05', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (251, 468, 208, 138, 33, 95, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:09:27', '2020-12-29 14:29:03', '2020-12', 1, '', 1, '2020-12-29 14:31:53', '', 0, 1, 33, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (252, 469, 209, 137, 33, 80, 1.0, 1.0, 2.0, 2.0, '2020-12-29 14:13:46', '2020-12-29 14:29:02', '2020-12', 1, '共2次：12月4日，12月23日', 1, '2020-12-29 14:31:48', '', 0, 1, 33, 4.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (253, 470, 210, 136, 33, 81, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:16:21', '2020-12-29 14:29:02', '2020-12', 1, '', 1, '2020-12-29 14:31:43', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (254, 471, 211, 135, 33, 384, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:17:23', '2020-12-29 14:28:57', '2020-12', 1, '', 1, '2020-12-29 14:31:26', '', 0, 1, 33, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (255, 472, 212, 134, 33, 381, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:25:23', '2020-12-29 14:28:56', '2020-12', 1, '', 1, '2020-12-29 14:31:12', '', 0, 1, 33, 1.5, 100.0, 0.0, 'fact', 1.5);
INSERT INTO `worktimelist` VALUES (256, 473, 213, 133, 33, 91, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:28:16', '2020-12-29 14:28:58', '2020-12', 1, '', 1, '2020-12-29 14:30:54', '', 0, 1, 33, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (257, 474, 214, 160, 33, 86, 1.0, 1.0, 1.0, 1.0, '2020-12-29 14:35:41', '2020-12-29 14:36:01', '2020-12', 1, '', 1, '2020-12-29 14:36:10', '', 0, 1, 33, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (258, 475, 215, NULL, 18, 380, 1.0, NULL, 1.0, NULL, '2020-12-29 14:56:46', '2020-12-29 14:58:16', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 1.5, 100.0, 0.0, 'fact', 1.5);
INSERT INTO `worktimelist` VALUES (259, 476, 216, 165, 33, 386, 1.0, 1.0, 1.0, 1.0, '2020-12-29 15:00:12', '2020-12-29 15:02:48', '2020-12', 1, '', 1, '2020-12-29 15:03:13', '', 0, 1, 33, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (260, 477, 217, 164, 33, 386, 1.0, 1.0, 1.0, 1.0, '2020-12-29 15:00:39', '2020-12-29 15:02:48', '2020-12', 1, '', 1, '2020-12-29 15:03:12', '', 0, 1, 33, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (261, 478, 218, 163, 33, 386, 1.0, 1.0, 1.0, 1.0, '2020-12-29 15:01:04', '2020-12-29 15:02:49', '2020-12', 1, '', 1, '2020-12-29 15:03:10', '', 0, 1, 33, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (262, 479, 219, NULL, 18, 384, 1.0, NULL, 1.0, NULL, '2020-12-29 15:01:30', '2020-12-29 15:01:30', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (263, 480, 220, 162, 33, 386, 1.0, 1.0, 1.0, 1.0, '2020-12-29 15:01:46', '2020-12-29 15:02:49', '2020-12', 1, '', 1, '2020-12-29 15:03:09', '', 0, 1, 33, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (264, 481, 221, NULL, 18, 386, 1.0, NULL, 1.0, NULL, '2020-12-29 15:02:23', '2020-12-29 15:02:23', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (265, 482, 222, 161, 33, 72, 1.0, 1.0, 1.0, 1.0, '2020-12-29 15:02:27', '2020-12-29 15:02:50', '2020-12', 1, '', 1, '2020-12-29 15:03:07', '', 0, 1, 33, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (266, 483, 223, NULL, 18, 386, 1.0, NULL, 1.0, NULL, '2020-12-29 15:03:00', '2020-12-29 15:03:00', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (267, 484, 224, NULL, 18, 55, 1.0, NULL, 1.0, NULL, '2020-12-29 15:09:50', '2020-12-29 15:09:50', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (268, 485, 225, NULL, 29, 91, 1.0, NULL, 1.0, NULL, '2020-12-29 15:10:25', '2020-12-29 15:10:25', '2020-12', 1, '杭州程控交换机系统CM无法登陆及无录音排故', 0, NULL, '', 0, 0, NULL, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (269, 486, 226, NULL, 18, 56, 1.0, NULL, 1.0, NULL, '2020-12-29 15:10:26', '2020-12-29 15:10:26', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 0.5, 100.0, 0.0, 'fact', 0.5);
INSERT INTO `worktimelist` VALUES (270, 487, 227, NULL, 32, 77, 1.0, NULL, 1.0, NULL, '2020-12-29 15:14:33', '2020-12-29 15:14:33', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (271, 487, 227, 167, 32, 77, 1.0, NULL, 1.0, NULL, '2020-12-29 15:15:07', '2020-12-29 15:18:22', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (272, 488, 228, NULL, 32, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 15:18:12', '2020-12-29 15:18:12', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (273, 488, 228, 169, 32, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 15:18:47', '2020-12-29 15:18:51', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (274, 489, 229, NULL, 32, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 15:19:48', '2020-12-29 15:19:48', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (275, 489, 229, 171, 32, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 15:20:08', '2020-12-29 15:20:14', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (276, 490, 230, NULL, 32, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 15:20:51', '2020-12-29 15:20:51', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (277, 490, 230, 173, 32, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 15:21:07', '2020-12-29 15:21:11', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 1.0, 100.0, 0.0, 'fact', 1.0);
INSERT INTO `worktimelist` VALUES (278, 491, 231, NULL, 32, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 15:23:10', '2020-12-29 15:23:10', '2020-12', 1, '', 0, NULL, '', 1, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (279, 491, 231, 175, 32, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 15:23:27', '2020-12-29 15:23:39', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (280, 492, 232, NULL, 18, 91, 1.0, NULL, 1.0, NULL, '2020-12-29 15:28:44', '2020-12-29 15:28:44', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 4.0, 100.0, 0.0, 'fact', 4.0);
INSERT INTO `worktimelist` VALUES (281, 493, 233, NULL, 18, 72, 1.0, NULL, 1.0, NULL, '2020-12-29 15:29:24', '2020-12-29 15:29:24', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 2.0, 100.0, 0.0, 'fact', 2.0);
INSERT INTO `worktimelist` VALUES (282, 494, 234, NULL, 18, 96, 1.0, NULL, 1.0, NULL, '2020-12-29 15:34:41', '2020-12-29 15:34:41', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);
INSERT INTO `worktimelist` VALUES (283, 495, 235, NULL, 7, 68, 1.0, NULL, 1.0, NULL, '2020-12-29 15:38:35', '2020-12-29 15:38:35', '2020-12', 1, '', 0, NULL, '', 0, 0, NULL, 3.0, 100.0, 0.0, 'fact', 3.0);

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

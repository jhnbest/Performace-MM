-- 密码安全升级：存量无盐 MD5 迁移到强哈希（PBKDF2 客户端摘要 + scrypt 服务端存储）所需的数据结构变更
-- 说明：
--   1) 旧版密码为无盐 MD5（users.password 为 char(32)），无法用于校验新的强摘要。
--   2) 新密码哈希格式为 scrypt$N$r$p$saltHex$hashHex（约 114 字符），需扩列。
--   3) 存量 32 位 MD5 账号无需手动重置：用户首次登录时，系统自动做一次旧格式兼容校验
--      并在登录成功后把该账号无缝升级为 scrypt（见 controls/user.js login），全程用户无感。
--   4) 本脚本只需扩列以容纳 scrypt 哈希，扩展列必须执行，否则升级写入会因列宽被截断。
-- 使用前请先在测试库执行验证。

USE `workTimeMM`;

-- 主登录/改密表 users 的密码列扩宽
ALTER TABLE `users`
  MODIFY COLUMN `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户密码（scrypt 哈希，历史为 MD5）';

-- 兼容旧表 user（若存在且使用）
ALTER TABLE `user`
  MODIFY COLUMN `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT '用户密码（scrypt 哈希）';
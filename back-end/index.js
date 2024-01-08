// node 后端服务器
const router = require('./routes/router'); // 接口地址管理
const path = require('path');
const bodyParser = require('body-parser');
const express = require('express');
const app = express();

// let CronJob = require('cron').CronJob
// new CronJob('0 0 1 3 * ?', function() { // 秒 分 小时 月份中的日期 月份 星期中的日期 年份（可选）
//   console.log(new Date())
// }, null, true)

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

// 后端api路由
app.use(router);

// 监听端口
app.listen(3002);
console.log('success listen at port:3002......');
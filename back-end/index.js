// node 后端服务器
const router = require('./routes/router'); // 接口地址管理
const path = require('path');
const bodyParser = require('body-parser');
const express = require('express');
const app = express();
const cronJobManager = require('./controls/cronJobManager');

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

// 后端api路由
app.use(router);

// 监听端口
app.listen(3002, async () => {
  console.log('success listen at port:3002......');
  // 启动所有定时任务
  await cronJobManager.startAllCronJobs();
  console.log('所有定时任务已启动');
});
let mysql = require('mysql');
let db = require('../config/db');
let pool = mysql.createPool(db);
const jwt = require('jwt-simple');
// JWT 签名密钥：从配置读取（环境变量 JWT_SECRET 或本地生成密钥文件），避免硬编码
const secret = require('../config/secret');

const $http = {
    connPool (sql, val, cb) {
        pool.getConnection((err, conn) => {
            if (err) {
                console.log('和mysql数据库建立连接失败');
                console.log(err)
            } else {
                let query = conn.query(sql, val, (err, result) => {
                    if (err) {
                        console.log(err);
                    }
                    cb(err, result);
                    conn.release();
                });
            }
        });
    },
    // json格式
    writeJson(res, result) {
      if(typeof result === 'undefined') {
        res.send('err')
      } else {
        res.json(result);
        // res.send('ok')
      }
    },
    // user验证
    userVerify(req, res, cb) {
      let params = req.body
      let userId = params.userId
      let resultData = {}
      let token = req.headers.token //获取前端请求头发送过来的token
      let decoded = jwt.decode(token, secret.jwtSecret)
      if (!userId || decoded.iss != userId) {
        resultData = {
          code: 2,
          message: 'userId有误'
        }
        $http.writeJson(res, resultData)
      } else {
        if(decoded.exp <= Date.now()){
          resultData = {
            code: 20,
            message: '登录过期'
          }
          $http.writeJson(res, resultData)
        } else {
          cb()
        }
      }
    }
};

module.exports = $http

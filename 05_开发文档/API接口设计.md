# API接口设计 - 贷查查v1.0

**项目名称**：企业贷款体质改造系统  
**产品名称**：贷查查 v1.0  
**API版本**：v1  
**基础URL**：`https://api.loan-diagnosis.com/v1`  
**更新日期**：2025-12-07

---

## 一、接口概述

### 1.1 设计原则
- **RESTful风格**：遵循REST设计规范
- **统一响应格式**：所有接口返回统一JSON格式
- **安全第一**：所有接口需鉴权（除登录/注册）
- **版本控制**：URL中包含版本号
- **幂等性**：GET/PUT/DELETE保证幂等

### 1.2 通用规范

**请求头（Request Headers）**：
```
Content-Type: application/json
Authorization: Bearer {token}
X-Client-Version: 1.0.0
```

**响应格式（Response Format）**：
```json
{
  "code": 0,
  "message": "success",
  "data": {},
  "timestamp": 1701936000
}
```

**状态码（Status Codes）**：
| Code | 说明 |
|------|------|
| 0 | 成功 |
| 1001 | 参数错误 |
| 1002 | 未登录 |
| 1003 | 权限不足 |
| 2001 | 业务错误 |
| 5000 | 服务器错误 |

---

## 二、鉴权模块

### 2.1 用户注册

**接口**：`POST /auth/register`

**请求参数**：
```json
{
  "mobile": "13800138000",
  "password": "password123",
  "sms_code": "123456",
  "enterprise_name": "某某科技有限公司"
}
```

**响应**：
```json
{
  "code": 0,
  "message": "注册成功",
  "data": {
    "user_id": 1,
    "mobile": "13800138000",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 86400
  }
}
```

---

### 2.2 用户登录

**接口**：`POST /auth/login`

**请求参数**：
```json
{
  "mobile": "13800138000",
  "password": "password123"
}
```

**响应**：
```json
{
  "code": 0,
  "message": "登录成功",
  "data": {
    "user_id": 1,
    "mobile": "13800138000",
    "enterprise_name": "某某科技有限公司",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 86400
  }
}
```

---

### 2.3 发送短信验证码

**接口**：`POST /auth/sms/send`

**请求参数**：
```json
{
  "mobile": "13800138000",
  "scene": "register"
}
```

**scene枚举**：`register`（注册）、`login`（登录）、`reset_password`（重置密码）

**响应**：
```json
{
  "code": 0,
  "message": "验证码已发送",
  "data": {
    "expires_in": 300
  }
}
```

---

### 2.4 刷新Token

**接口**：`POST /auth/refresh`

**请求头**：
```
Authorization: Bearer {token}
```

**响应**：
```json
{
  "code": 0,
  "message": "刷新成功",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 86400
  }
}
```

---

## 三、诊断模块

### 3.1 提交诊断问卷

**接口**：`POST /diagnosis/questionnaire`

**请求参数**：
```json
{
  "enterprise_name": "某某科技有限公司",
  "industry": "软件开发",
  "establishment_years": 3,
  "annual_revenue": 2500,
  "annual_invoice": 2400,
  "annual_tax": 20,
  "tax_grade": "B",
  "has_property": false,
  "property_value": 0,
  "has_patent": true,
  "patent_count": 10,
  "is_high_tech": false,
  "credit_status": "良好",
  "target_amount": 800,
  "target_term": 12,
  "urgency": "紧急"
}
```

**响应**：
```json
{
  "code": 0,
  "message": "问卷提交成功",
  "data": {
    "questionnaire_id": 123,
    "report_id": 456
  }
}
```

---

### 3.2 获取诊断报告

**接口**：`GET /diagnosis/report/{report_id}`

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "report_id": 456,
    "report_no": "DIAG20241207001",
    "enterprise_name": "某某科技有限公司",
    "created_at": "2024-12-07 10:00:00",
    
    "current_status": {
      "max_amount": 350,
      "products_count": 3,
      "best_rate": 4.5,
      "matched_products": [
        {
          "product_id": 1,
          "product_name": "云税贷",
          "bank_name": "建设银行",
          "estimated_amount": 200,
          "estimated_rate": 3.15
        },
        {
          "product_id": 2,
          "product_name": "管家贷",
          "bank_name": "兴业银行",
          "estimated_amount": 150,
          "estimated_rate": 5.0
        }
      ]
    },
    
    "target_status": {
      "target_amount": 800,
      "gap_amount": 450
    },
    
    "reform_solutions": [
      {
        "solution_id": 3,
        "solution_name": "资质认定术（高新技术企业）",
        "priority": 1,
        "type": "fastest",
        "cost": 10.7,
        "duration": 6,
        "expected_amount": 800,
        "roi": 3036,
        "matched_products": [
          {
            "product_id": 5,
            "product_name": "科创贷",
            "bank_name": "邮储银行",
            "estimated_amount": 800,
            "estimated_rate": 4.2
          }
        ]
      },
      {
        "solution_id": 2,
        "solution_name": "纳税提升术",
        "priority": 2,
        "type": "cheapest",
        "cost": 11.5,
        "duration": 12,
        "expected_amount": 600,
        "roi": 900
      }
    ]
  }
}
```

---

### 3.3 获取用户的报告列表

**接口**：`GET /diagnosis/reports`

**请求参数（Query）**：
```
?page=1&page_size=10
```

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total": 25,
    "page": 1,
    "page_size": 10,
    "items": [
      {
        "report_id": 456,
        "report_no": "DIAG20241207001",
        "enterprise_name": "某某科技有限公司",
        "target_amount": 800,
        "current_max_amount": 350,
        "gap_amount": 450,
        "has_solution": true,
        "created_at": "2024-12-07 10:00:00"
      }
    ]
  }
}
```

---

### 3.4 下载报告（PDF）

**接口**：`GET /diagnosis/report/{report_id}/download`

**响应**：
- Content-Type: `application/pdf`
- 直接返回PDF文件流

---

## 四、产品库模块

### 4.1 获取银行产品列表

**接口**：`GET /products`

**请求参数（Query）**：
```
?product_type=税贷&bank_name=建设银行&page=1&page_size=20
```

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total": 20,
    "page": 1,
    "page_size": 20,
    "items": [
      {
        "product_id": 1,
        "product_name": "云税贷",
        "bank_name": "建设银行",
        "product_type": "税贷",
        "max_amount": 500,
        "min_amount": 1,
        "min_rate": 3.15,
        "max_rate": 6.0,
        "term": "12个月",
        "repayment_method": "随借随还",
        "approval_duration": "最快当天，一般3-5天"
      }
    ]
  }
}
```

---

### 4.2 获取产品详情

**接口**：`GET /products/{product_id}`

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "product_id": 1,
    "product_name": "云税贷",
    "bank_name": "建设银行",
    "product_type": "税贷",
    "max_amount": 500,
    "min_amount": 1,
    "amount_formula": "年纳税额 × 倍数（A级20倍，B级15倍，M级10倍）",
    "min_rate": 3.15,
    "max_rate": 6.0,
    "requirements": {
      "establishment_years": {"min": 1},
      "annual_tax": {"min": 5},
      "tax_grade": ["A", "B", "M"],
      "credit_status": ["良好"]
    },
    "term": "12个月",
    "repayment_method": "随借随还",
    "approval_duration": "最快当天，一般3-5天"
  }
}
```

---

### 4.3 产品匹配测算

**接口**：`POST /products/match`

**请求参数**：
```json
{
  "annual_revenue": 2500,
  "annual_invoice": 2400,
  "annual_tax": 20,
  "tax_grade": "B",
  "has_property": false,
  "is_high_tech": false,
  "credit_status": "良好"
}
```

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "matched_products": [
      {
        "product_id": 1,
        "product_name": "云税贷",
        "bank_name": "建设银行",
        "match_score": 95,
        "estimated_amount": 200,
        "estimated_rate": 3.15,
        "is_recommended": true
      },
      {
        "product_id": 2,
        "product_name": "管家贷",
        "bank_name": "兴业银行",
        "match_score": 85,
        "estimated_amount": 150,
        "estimated_rate": 5.0,
        "is_recommended": true
      }
    ]
  }
}
```

---

## 五、方案库模块

### 5.1 获取改造方案列表

**接口**：`GET /solutions`

**请求参数（Query）**：
```
?category=开票提升&page=1&page_size=20
```

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total": 10,
    "page": 1,
    "page_size": 20,
    "items": [
      {
        "solution_id": 1,
        "solution_name": "开票提升术",
        "solution_category": "开票提升",
        "min_cost": 8,
        "max_cost": 15,
        "min_duration": 4,
        "max_duration": 7,
        "applicable_condition": "年开票额<年营收80%的企业"
      }
    ]
  }
}
```

---

### 5.2 获取方案详情

**接口**：`GET /solutions/{solution_id}`

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "solution_id": 1,
    "solution_name": "开票提升术",
    "solution_category": "开票提升",
    "applicable_condition": "年开票额<年营收80%的企业",
    "min_cost": 8,
    "max_cost": 15,
    "min_duration": 4,
    "max_duration": 7,
    "solution_detail": "通过H业务帮助企业提升开票额...",
    "steps": [
      {
        "step": 1,
        "name": "开票诊断",
        "duration": "3-5天",
        "cost": 0,
        "description": "盘点企业现有开票情况..."
      },
      {
        "step": 2,
        "name": "开票方案设计",
        "duration": "2-3天",
        "cost": 0,
        "description": "制定开票提升方案..."
      }
    ]
  }
}
```

---

## 六、案例库模块

### 6.1 获取案例列表

**接口**：`GET /cases`

**请求参数（Query）**：
```
?industry=软件开发&page=1&page_size=10
```

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total": 3,
    "page": 1,
    "page_size": 10,
    "items": [
      {
        "case_id": 1,
        "case_title": "科技企业高新认定",
        "industry": "软件开发",
        "before_amount": 350,
        "after_amount": 1300,
        "solution_used": "资质认定术（高新技术企业）",
        "roi": 3036
      }
    ]
  }
}
```

---

### 6.2 获取案例详情

**接口**：`GET /cases/{case_id}`

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "case_id": 1,
    "case_title": "科技企业高新认定",
    "industry": "软件开发",
    "enterprise_type": "小微企业",
    "before_amount": 350,
    "before_rate": 5.5,
    "after_amount": 1300,
    "after_rate": 4.2,
    "solution_used": "资质认定术（高新技术企业）",
    "cost": 10.7,
    "duration": 6,
    "roi": 3036,
    "case_content": "某智能科技有限公司成立3年..."
  }
}
```

---

## 七、用户模块

### 7.1 获取用户信息

**接口**：`GET /user/profile`

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "user_id": 1,
    "mobile": "138****8000",
    "enterprise_name": "某某科技有限公司",
    "legal_person": "张三",
    "uscc": "91110000******",
    "created_at": "2024-12-01 10:00:00"
  }
}
```

---

### 7.2 更新用户信息

**接口**：`PUT /user/profile`

**请求参数**：
```json
{
  "enterprise_name": "某某科技有限公司",
  "legal_person": "张三",
  "uscc": "91110000MA01234567"
}
```

**响应**：
```json
{
  "code": 0,
  "message": "更新成功",
  "data": null
}
```

---

### 7.3 修改密码

**接口**：`PUT /user/password`

**请求参数**：
```json
{
  "old_password": "old_password123",
  "new_password": "new_password456"
}
```

**响应**：
```json
{
  "code": 0,
  "message": "密码修改成功",
  "data": null
}
```

---

## 八、统计模块

### 8.1 用户统计数据

**接口**：`GET /stats/overview`

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total_reports": 25,
    "total_matched_products": 75,
    "avg_current_amount": 250,
    "avg_gap_amount": 300,
    "most_used_solution": "资质认定术（高新技术企业）"
  }
}
```

---

## 九、管理后台接口（Admin）

### 9.1 管理员登录

**接口**：`POST /admin/auth/login`

**请求参数**：
```json
{
  "username": "admin",
  "password": "admin123"
}
```

**响应**：
```json
{
  "code": 0,
  "message": "登录成功",
  "data": {
    "admin_id": 1,
    "username": "admin",
    "role": "super_admin",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 86400
  }
}
```

---

### 9.2 获取用户列表

**接口**：`GET /admin/users`

**请求参数（Query）**：
```
?keyword=138&page=1&page_size=20
```

**响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "total": 100,
    "page": 1,
    "page_size": 20,
    "items": [
      {
        "user_id": 1,
        "mobile": "13800138000",
        "enterprise_name": "某某科技有限公司",
        "reports_count": 5,
        "status": 1,
        "created_at": "2024-12-01 10:00:00"
      }
    ]
  }
}
```

---

### 9.3 添加/更新银行产品

**接口**：`POST /admin/products` 或 `PUT /admin/products/{product_id}`

**请求参数**：
```json
{
  "product_name": "云税贷",
  "bank_name": "建设银行",
  "product_type": "税贷",
  "max_amount": 500,
  "min_amount": 1,
  "amount_formula": "年纳税额 × 倍数",
  "min_rate": 3.15,
  "max_rate": 6.0,
  "requirements": {
    "establishment_years": {"min": 1},
    "annual_tax": {"min": 5}
  },
  "term": "12个月",
  "repayment_method": "随借随还",
  "approval_duration": "3-5天",
  "status": 1
}
```

**响应**：
```json
{
  "code": 0,
  "message": "操作成功",
  "data": {
    "product_id": 1
  }
}
```

---

### 9.4 系统配置管理

**接口**：`GET /admin/configs` 或 `PUT /admin/configs`

**GET响应**：
```json
{
  "code": 0,
  "message": "success",
  "data": {
    "sms_template_login": "您的验证码是{code}，5分钟内有效",
    "report_expire_days": 30,
    "max_free_reports": 3
  }
}
```

**PUT请求**：
```json
{
  "report_expire_days": 60,
  "max_free_reports": 5
}
```

---

## 十、错误码定义

### 10.1 通用错误码

| Code | Message | 说明 |
|------|---------|------|
| 0 | success | 成功 |
| 1001 | 参数错误 | 请求参数不正确 |
| 1002 | 未登录 | Token无效或过期 |
| 1003 | 权限不足 | 无权访问该资源 |
| 1004 | 请求频繁 | 超过频率限制 |

### 10.2 业务错误码

| Code | Message | 说明 |
|------|---------|------|
| 2001 | 手机号已注册 | 该手机号已存在 |
| 2002 | 验证码错误 | 短信验证码不正确 |
| 2003 | 验证码已过期 | 验证码超过5分钟 |
| 2004 | 密码错误 | 登录密码不正确 |
| 2005 | 用户不存在 | 该用户不存在 |
| 2006 | 报告不存在 | 该诊断报告不存在 |
| 2007 | 产品不存在 | 该银行产品不存在 |
| 2008 | 超过免费次数 | 超过免费诊断次数限制 |

### 10.3 服务器错误码

| Code | Message | 说明 |
|------|---------|------|
| 5000 | 服务器错误 | 服务器内部错误 |
| 5001 | 数据库错误 | 数据库操作失败 |
| 5002 | 第三方服务错误 | 短信/支付等服务异常 |

---

## 十一、接口鉴权

### 11.1 JWT Token格式

**生成（服务端）**：
```python
import jwt
import datetime

payload = {
    'user_id': 1,
    'exp': datetime.datetime.utcnow() + datetime.timedelta(days=1)
}
token = jwt.encode(payload, 'secret_key', algorithm='HS256')
```

**验证（服务端）**：
```python
try:
    payload = jwt.decode(token, 'secret_key', algorithms=['HS256'])
    user_id = payload['user_id']
except jwt.ExpiredSignatureError:
    # Token已过期
    return error_response(1002, "Token已过期")
except jwt.InvalidTokenError:
    # Token无效
    return error_response(1002, "Token无效")
```

---

### 11.2 请求签名（可选，高安全场景）

**签名生成（客户端）**：
```
1. 将所有参数按key排序
2. 拼接成字符串：key1=value1&key2=value2&key=secret_key
3. MD5加密
```

**签名验证（服务端）**：
```python
import hashlib

def verify_sign(params, sign):
    # 排序并拼接
    sorted_params = sorted(params.items())
    sign_str = '&'.join([f'{k}={v}' for k, v in sorted_params])
    sign_str += '&key=secret_key'
    
    # MD5加密
    calculated_sign = hashlib.md5(sign_str.encode()).hexdigest()
    
    return calculated_sign == sign
```

---

## 十二、接口限流

### 12.1 限流策略

**用户级限流**：
- 登录：5次/分钟
- 注册：3次/小时
- 诊断问卷：10次/小时
- 其他接口：100次/小时

**IP级限流**：
- 全局：1000次/小时

### 12.2 限流响应

**超限响应**：
```json
{
  "code": 1004,
  "message": "请求过于频繁，请稍后再试",
  "data": {
    "retry_after": 60
  }
}
```

---

## 十三、接口测试

### 13.1 测试环境

- **测试URL**：`https://test-api.loan-diagnosis.com/v1`
- **测试账号**：
  - 手机号：`13800000001`
  - 密码：`test123456`

### 13.2 Postman Collection

**示例：登录接口**
```json
{
  "name": "用户登录",
  "request": {
    "method": "POST",
    "url": "{{base_url}}/auth/login",
    "header": [
      {
        "key": "Content-Type",
        "value": "application/json"
      }
    ],
    "body": {
      "mode": "raw",
      "raw": "{\n  \"mobile\": \"13800138000\",\n  \"password\": \"password123\"\n}"
    }
  }
}
```

---

## 十四、版本升级计划

### v1.1（计划）
- [ ] 增加微信登录
- [ ] 支持批量诊断
- [ ] 增加企业对比功能

### v2.0（规划）
- [ ] AI智能推荐
- [ ] 实时贷款进度查询
- [ ] 银行直连申请

---

**设计者**：Claude AI  
**审核者**：开发团队  
**版本**：v1.0  
**最后更新**：2025-12-07

---

*本API接口设计文档作为开发指导，具体实现时可根据技术栈调整。*

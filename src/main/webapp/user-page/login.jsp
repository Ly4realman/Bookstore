<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <title>用户登录</title>
  <meta charset="UTF-8">
  <!-- 引入 Bootstrap 5 CDN -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f8f9fa;
    }
    .login-container {
      max-width: 400px;
      margin: 80px auto;
      padding: 30px;
      background: white;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .captcha-img {
      cursor: pointer;
      height: 38px;
      border: 1px solid #ced4da;
      border-radius: .375rem;
    }
  </style>
</head>
<body>

<div class="login-container">
  <h3 class="text-center mb-4">用户登录</h3>
  <form action="/user/login" method="post">
    <div class="mb-3">
      <label for="username" class="form-label">用户名</label>
      <input type="text" class="form-control" id="username" name="username" required>
    </div>

    <div class="mb-3">
      <label for="password" class="form-label">密码</label>
      <input type="password" class="form-control" id="password" name="password" required>
    </div>

    <div class="mb-3">
      <label for="captcha" class="form-label">验证码</label>
      <div class="d-flex">
        <input type="text" class="form-control me-2" id="captcha" name="captcha" required>
        <img src="/captcha" alt="验证码" class="captcha-img"
             onclick="this.src='captcha?'+Math.random()" title="看不清？点击刷新">
      </div>
    </div>

    <p>还没有账号？<a href="register.jsp">点击注册</a></p>

    <% String error = (String) request.getAttribute("error"); %>
    <% if (error != null) { %>
    <div class="alert alert-danger mt-3" role="alert">
      <%= error %>
    </div>
    <% } %>

    <div class="d-grid mt-4">
      <button type="submit" class="btn btn-primary">登录</button>
    </div>
  </form>
</div>

</body>
</html>

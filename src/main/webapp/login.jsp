<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>登录</title>
  <meta charset="UTF-8">
</head>
<body>
<h2>用户登录</h2>
<form action="login" method="post">
  用户名: <input type="text" name="username"><br>
  密码: <input type="password" name="password"><br>
  验证码: <input type="text" name="captcha">
  <img src="captcha" onclick="this.src='captcha?'+Math.random()" title="看不清？点击刷新" style="cursor:pointer;"><br>
  <input type="submit" value="登录">
  <div style="color:red;"><%= request.getAttribute("error") == null ? "" : request.getAttribute("error") %></div>
</form>

</body>
</html>

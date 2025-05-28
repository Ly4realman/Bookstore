<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>登录</title>
</head>
<body>
<h2>用户登录</h2>
<form action="login" method="post">
  用户名：<input type="text" name="username" required><br>
  密码：<input type="password" name="password" required><br>
  <input type="submit" value="登录">
</form>

<% String error = (String) request.getAttribute("error");
  if (error != null) { %>
<p style="color:red;"><%= error %></p>
<% } %>
</body>
</html>

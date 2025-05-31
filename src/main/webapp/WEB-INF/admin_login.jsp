<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <title>管理员登录</title>
</head>
<body>
<h2>管理员登录</h2>

<form action="${pageContext.request.contextPath}/admin/login" method="post">
  用户名: <input type="text" name="username" required><br>
  密码: <input type="password" name="password" required><br>
  <input type="submit" value="登录">
</form>

<%-- 显示错误信息（如果有） --%>
<c:if test="${not empty error}">
  <p style="color:red;">${error}</p>
</c:if>

</body>
</html>

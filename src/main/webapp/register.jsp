<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head><title>用户注册</title></head>
<body>
<h2>注册</h2>

<form action="register" method="post">
    用户名: <input type="text" name="username" required><br>
    密码: <input type="password" name="password" required><br>
    确认密码: <input type="password" name="confirmPassword" required><br>
    手机号: <input type="text" name="phone" required><br>
    <input type="submit" value="注册"><br>

    <ul style="color: red">
        <c:forEach var="error" items="${errors}">
            <li>${error}</li>
        </c:forEach>
    </ul>
</form>

</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.bean.Admin" %>
<%@ page session="true" %>
<%
  Admin admin = (Admin) session.getAttribute("admin");
  if (admin == null) {
    request.getRequestDispatcher("/WEB-INF/admin_login.jsp").forward(request, response);
    return;
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>管理员后台</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h2 { color: #333; }
    .nav { margin-bottom: 20px; }
    .nav a { margin-right: 15px; text-decoration: none; color: #007BFF; }
  </style>
</head>
<body>

<h2>欢迎你，管理员 <%= admin.getUsername() %>！</h2>

<div class="nav">
  <a href="manage_books.jsp">管理图书</a>
  <a href="manage_users.jsp">管理用户</a>
  <a href="view_orders.jsp">查看订单</a>
  <a href="logout.jsp">退出登录</a>
</div>

<hr>

<p>这是您的后台首页，您可以通过上方导航进行操作。</p>

</body>
</html>

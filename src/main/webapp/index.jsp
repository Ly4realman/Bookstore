<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>网上书店首页</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* 自定义样式 */
        .navbar-brand img {
            height: 40px;
        }
        .book-card img {
            height: 200px;
            object-fit: cover;
        }
        .carousel-item img {
            height: 400px;
            object-fit: cover;
            width: 100%;
        }
    </style>
</head>
<body>
<!-- 顶部导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light bg-light px-3">
    <a class="navbar-brand" href="index.jsp">
        <img src="images/logo.jpg" alt="书店Logo"> 吴彦书店
    </a>

    <form class="d-flex mx-auto" action="login.jsp" method="get" style="width: 50%;">
        <input class="form-control me-2" type="search" name="query" placeholder="搜索图书" aria-label="搜索" required>
        <button class="btn btn-outline-success" type="submit">搜索</button>
    </form>

    <div>
        <a href="login.jsp" class="btn btn-outline-primary me-2">登录</a>
        <a href="login.jsp" class="btn btn-outline-secondary me-2">购物车</a>
        <a href="login.jsp" class="btn btn-outline-info">我的订单</a>
    </div>
</nav>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

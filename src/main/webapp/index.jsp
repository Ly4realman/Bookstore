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

    <form class="d-flex mx-auto" action="search" method="get" style="width: 50%;">
        <input class="form-control me-2" type="search" name="query" placeholder="搜索图书" aria-label="搜索" required>
        <button class="btn btn-outline-success" type="submit">搜索</button>
    </form>

    <div>
        <a href="login.jsp" class="btn btn-outline-primary me-2">登录</a>
        <a href="login.jsp" class="btn btn-outline-secondary me-2">购物车</a>
        <a href="login.jsp" class="btn btn-outline-info">我的订单</a>
    </div>
</nav>

<!-- 轮播图：热门图书 -->
<div id="hotBooksCarousel" class="carousel slide mt-4 container" data-bs-ride="carousel">
    <div class="carousel-inner">
        <c:forEach var="book" items="${hotBooks}" varStatus="status">
            <div class="carousel-item ${status.first ? 'active' : ''}">
                <a href="bookDetail?id=${book.id}">
                    <img src="${book.coverImage}" class="d-block w-100" alt="${book.title}">
                    <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50 rounded">
                        <h5>${book.title}</h5>
                        <p class="fw-bold text-warning">￥${book.price}</p>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#hotBooksCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">上一张</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#hotBooksCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">下一张</span>
    </button>
</div>

<!-- 图书列表展示卡片 -->
<div class="container mt-5">
    <h4 class="mb-4">图书列表</h4>
    <div class="row row-cols-1 row-cols-md-4 g-4">
        <c:forEach var="book" items="${bookList}">
            <div class="col">
                <div class="card book-card h-100">
                    <a href="bookDetail?id=${book.id}">
                        <img src="${book.coverImage}" class="card-img-top" alt="${book.title}">
                    </a>
                    <div class="card-body">
                        <h5 class="card-title">${book.title}</h5>
                        <p class="card-text text-muted">作者：${book.author}</p>
                        <p class="card-text text-danger fw-bold">￥${book.price}</p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>



<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

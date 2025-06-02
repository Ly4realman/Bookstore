<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>书店首页</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .section-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 25px;
            margin-bottom: 30px;
        }

        .section-title {
            position: relative;
            margin-bottom: 25px;
            padding-bottom: 10px;
            color: #333;
        }

        .section-title::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 50px;
            height: 3px;
            background: #007bff;
        }

        .carousel-section {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .carousel-inner {
            border-radius: 10px;
        }

        .carousel-item img {
            height: 400px;
            object-fit: cover;
        }

        .book-card {
            transition: transform 0.2s, box-shadow 0.2s;
            border: none;
            border-radius: 8px;
            overflow: hidden;
            height: 100%;
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }

        .book-card .card-img-top {
            height: 250px;
            object-fit: cover;
        }

        .book-card .card-body {
            padding: 1.25rem;
        }

        .book-price {
            font-size: 1.25rem;
            color: #dc3545;
            font-weight: bold;
        }

        .navbar {
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .navbar.sticky-top {
            position: sticky;
            top: 0;
            z-index: 1020;
        }

        .navbar .user-welcome {
            color: #007bff;
            font-weight: 500;
        }

        .navbar .dropdown-menu {
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 8px 0;
        }

        .navbar .dropdown-item {
            padding: 8px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #333;
        }

        .navbar .dropdown-item:hover {
            background-color: #f8f9fa;
            color: #007bff;
        }

        .search-input {
            border-radius: 25px;
            padding: 12px 25px;
            font-size: 1.1em;
            border: 1px solid #333;
            background-color: rgba(255,255,255,0.95);
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light sticky-top">
    <div class="container">
        <a class="navbar-brand" href="index">
            <i class="bi bi-book"></i> 糊涂书店
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- 搜索框 -->
            <div class="w-100 d-flex justify-content-center mb-3">
                <form class="d-flex w-100 justify-content-center" action="search" method="get" style="max-width: 600px; min-width: 250px;">
                    <div class="input-group w-100">
                        <input type="text" name="query" class="form-control search-input"
                               placeholder="搜索图书、作者..." required>
                        <button type="submit" class="btn btn-outline-primary">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>
            </div>

            <!-- 用户菜单 -->
            <ul class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link" href="login.jsp">登录</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="register.jsp">注册</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle user-welcome" href="#" id="userDropdown" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle"></i>
                                欢迎，${sessionScope.user.username}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item" href="profile">
                                        <i class="bi bi-person"></i> 个人信息
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="orders">
                                        <i class="bi bi-receipt"></i> 我的订单
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item position-relative" href="cart">
                                        <i class="bi bi-cart3"></i> 购物车
                                        <c:if test="${not empty cartItemCount}">
                                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                                    ${cartItemCount}
                                            </span>
                                        </c:if>
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="logout">
                                        <i class="bi bi-box-arrow-right"></i> 退出登录
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<div class="container">
    <!-- 热门图书轮播 -->
    <div class="section-container">
        <h3 class="section-title">热门推荐</h3>
        <div id="hotBooksCarousel" class="carousel slide carousel-section" data-bs-ride="carousel">
            <div class="carousel-inner">
                <c:forEach var="book" items="${hotBooks}" varStatus="status">
                    <div class="carousel-item ${status.first ? 'active' : ''}">
                        <a href="bookDetail?id=${book.id}">
                            <img src="${book.coverImage}" class="d-block w-100" alt="${book.title}">
                            <div class="carousel-caption d-none d-md-block bg-dark bg-opacity-50 rounded">
                                <h5>${book.title}</h5>
                                <p class="book-price">￥${book.price}</p>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
            <button class="carousel-control-prev" type="button" data-bs-target="#hotBooksCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon"></span>
                <span class="visually-hidden">上一张</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#hotBooksCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon"></span>
                <span class="visually-hidden">下一张</span>
            </button>
        </div>
    </div>

    <!-- 图书列表 -->
    <div class="section-container">
        <h3 class="section-title">全部图书</h3>
        <div class="row row-cols-1 row-cols-md-4 g-4">
            <c:forEach var="book" items="${bookList}">
                <div class="col">
                    <div class="card book-card">
                        <a href="bookDetail?id=${book.id}" class="text-decoration-none">
                            <img src="${book.coverImage}" class="card-img-top" alt="${book.title}">
                            <div class="card-body">
                                <h5 class="card-title text-dark">${book.title}</h5>
                                <p class="card-text text-muted">${book.author}</p>
                                <p class="book-price">￥${book.price}</p>
                            </div>
                        </a>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<!-- 页脚 -->
<footer class="bg-light py-4 mt-5">
    <div class="container text-center text-muted">
        <p>&copy; 2024 我的书店. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

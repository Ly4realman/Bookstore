<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>书店首页</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/header.css">
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
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/header.jsp"/>

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

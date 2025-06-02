<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>${book.title} - 图书详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .book-detail-section {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 40px;
        }
        
        .recommendation-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 30px;
            margin-top: 40px;
            position: relative;
            border: 1px solid #e9ecef;
        }
        
        .recommendation-title {
            position: absolute;
            top: -15px;
            left: 30px;
            background-color: #fff;
            padding: 0 15px;
            color: #333;
            font-weight: bold;
        }
        
        .recommendation-content {
            font-size: 1.1em;
            line-height: 1.8;
            color: #666;
            margin-top: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 4px;
            border-left: 4px solid #007bff;
        }
        
        .book-cover {
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .price {
            color: #dc3545;
            font-size: 1.8em;
            font-weight: bold;
        }
        
        .stock-info {
            color: #28a745;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="index">首页</a></li>
                <li class="breadcrumb-item active" aria-current="page">图书详情</li>
            </ol>
        </nav>

        <!-- 基本信息部分 -->
        <div class="book-detail-section">
            <div class="row">
                <!-- 图书封面 -->
                <div class="col-md-4">
                    <img src="${book.coverImage}" class="img-fluid book-cover" alt="${book.title}">
                </div>
                
                <!-- 图书信息 -->
                <div class="col-md-8">
                    <h2 class="mb-4">${book.title}</h2>
                    <p class="text-muted h5 mb-3">作者：${book.author}</p>
                    <p class="price mb-4">￥${book.price}</p>
                    <p class="stock-info mb-4">
                        <i class="bi bi-check-circle-fill"></i> 
                        库存：${book.stock} 件
                    </p>
                    <div class="description mb-4">
                        <h5 class="mb-3">图书简介</h5>
                        <p class="text-muted">${book.description}</p>
                    </div>
                    
                    <div class="d-grid gap-2 d-md-block">
                        <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                            <input type="hidden" name="bookId" value="${book.id}">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn btn-primary btn-lg me-2">加入购物车</button>
                        </form>
                        <button class="btn btn-danger btn-lg" type="button" 
                                onclick="location.href='${pageContext.request.contextPath}/checkout?bookId=${book.id}'">
                            立即购买
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 推荐内容区域 -->
        <c:if test="${not empty book.recommendation}">
            <div class="recommendation-section">
                <h4 class="recommendation-title">编辑推荐</h4>
                <div class="recommendation-content">
                    ${book.recommendation}
                </div>
            </div>
        </c:if>
    </div>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>购物车</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/header.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        
        .cart-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 25px;
            margin: 30px 0;
        }
        
        .cart-item {
            border-bottom: 1px solid #eee;
            padding: 20px 0;
        }
        
        .cart-item:last-child {
            border-bottom: none;
        }
        
        .book-cover {
            width: 120px;
            height: 160px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .quantity-control {
            width: 120px;
        }
        
        .total-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/header.jsp"/>

<div class="container">
    <h2 class="my-4">我的购物车</h2>
    
    <!-- 错误消息显示 -->
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${sessionScope.errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <% session.removeAttribute("errorMessage"); %>
    </c:if>
    
    <div class="cart-container">
        <c:if test="${empty cartItems}">
            <div class="text-center py-5">
                <i class="bi bi-cart3 fs-1 text-muted"></i>
                <p class="mt-3">购物车是空的</p>
                <a href="index" class="btn btn-primary">去购物</a>
            </div>
        </c:if>
        
        <c:if test="${not empty cartItems}">
            <div class="cart-items">
                <c:forEach var="item" items="${cartItems}">
                    <div class="cart-item">
                        <div class="row align-items-center">
                            <div class="col-md-2">
                                <img src="${item.book.coverImage}" alt="${item.book.title}" class="book-cover">
                            </div>
                            <div class="col-md-4">
                                <h5>${item.book.title}</h5>
                                <p class="text-muted">${item.book.author}</p>
                                <p class="text-danger">￥${item.book.price}</p>
                            </div>
                            <div class="col-md-3">
                                <div class="quantity-control input-group">
                                    <button class="btn btn-outline-secondary" type="button" 
                                            onclick="updateQuantity(${item.id}, ${item.quantity - 1})">-</button>
                                    <input type="number" class="form-control text-center" value="${item.quantity}" 
                                           min="1" max="99" onchange="updateQuantity(${item.id}, this.value)">
                                    <button class="btn btn-outline-secondary" type="button"
                                            onclick="updateQuantity(${item.id}, ${item.quantity + 1})">+</button>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <p class="h5 text-danger">￥${item.book.price * item.quantity}</p>
                            </div>
                            <div class="col-md-1">
                                <button class="btn btn-link text-danger" onclick="removeItem(${item.id})">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="total-section">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <button class="btn btn-outline-danger" onclick="clearCart()">清空购物车</button>
                    </div>
                    <div class="text-end">
                        <p class="mb-2">共 ${cartItems.size()} 件商品</p>
                        <h4 class="text-danger">
                            总计：￥<span id="totalPrice">
                                <c:set var="total" value="0"/>
                                <c:forEach var="item" items="${cartItems}">
                                    <c:set var="total" value="${total + item.book.price * item.quantity}"/>
                                </c:forEach>
                                ${total}
                            </span>
                        </h4>
                        <button class="btn btn-primary btn-lg mt-2" onclick="checkout()">结算</button>
                    </div>
                </div>
            </div>
        </c:if>
    </div>
</div>

<script>
    function updateQuantity(itemId, newQuantity) {
        if (newQuantity < 1) return;
        window.location.href = '${pageContext.request.contextPath}/cart/update?cartItemId=' + itemId + '&quantity=' + newQuantity;
    }
    
    function removeItem(itemId) {
        if (confirm('确定要删除这件商品吗？')) {
            window.location.href = '${pageContext.request.contextPath}/cart/remove?cartItemId=' + itemId;
        }
    }
    
    function clearCart() {
        if (confirm('确定要清空购物车吗？')) {
            window.location.href = '${pageContext.request.contextPath}/cart/clear';
        }
    }
    
    function checkout() {
        window.location.href = '${pageContext.request.contextPath}/checkout';
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
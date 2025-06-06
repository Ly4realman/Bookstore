<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>订单结算</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/header.css">

    <style>
        .checkout-section {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .total-price {
            font-size: 1.5em;
            color: #dc3545;
            font-weight: bold;
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="/WEB-INF/components/header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">订单结算</h2>
    
    <form action="${pageContext.request.contextPath}/order/create" method="post">
        <!-- 收货信息 -->
        <div class="checkout-section">
            <h4 class="mb-3">收货信息</h4>
            <div class="row g-3">
                <div class="col-md-6">
                    <label for="receiverName" class="form-label">收货人姓名</label>
                    <input type="text" class="form-control" id="receiverName" name="receiverName" 
                           value="${user.realname}" required>
                </div>
                <div class="col-md-6">
                    <label for="receiverPhone" class="form-label">联系电话</label>
                    <input type="tel" class="form-control" id="receiverPhone" name="receiverPhone" 
                           value="${user.phone}" required>
                </div>
                <div class="col-12">
                    <label for="shippingAddress" class="form-label">收货地址</label>
                    <input type="text" class="form-control" id="shippingAddress" name="shippingAddress" 
                           value="${user.address}" required>
                </div>
            </div>
        </div>

        <!-- 商品清单 -->
        <div class="checkout-section">
            <h4 class="mb-3">商品清单</h4>
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>商品</th>
                            <th>单价</th>
                            <th>数量</th>
                            <th>小计</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${cartItems}" var="item">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <img src="${item.book.coverImage}" alt="${item.book.title}" 
                                             style="width: 50px; margin-right: 10px;">
                                        ${item.book.title}
                                    </div>
                                </td>
                                <td>￥${item.book.price}</td>
                                <td>${item.quantity}</td>
                                <td>￥${item.book.price * item.quantity}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="text-end mt-3">
                <p class="total-price">总计：￥${totalAmount}</p>
            </div>
        </div>

        <!-- 提交订单按钮 -->
        <div class="d-grid gap-2 col-6 mx-auto mb-5">
            <button class="btn btn-primary btn-lg" type="submit">提交订单</button>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
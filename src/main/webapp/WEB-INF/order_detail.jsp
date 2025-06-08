<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<fmt:setTimeZone value="Asia/Shanghai" />

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>订单详情</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/header.css">

    <style>
        .order-detail-card {
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .book-image {
            width: 80px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/header.jsp"/>

<div class="container mt-5">
    <div class="row">
        <div class="col-md-8 mx-auto">
            <div class="card order-detail-card">
                <div class="card-header bg-light">
                    <div class="d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">订单详情</h5>
                        <span class="badge bg-${statusColor}">
                            ${statusLabel}
                        </span>

                    </div>
                </div>
                
                <div class="card-body">
                    <div class="mb-4">
                        <h6 class="text-muted">订单信息</h6>
                        <p class="mb-1">订单号：${order.id}</p>
                        <p class="mb-1">下单时间：<fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                        <p class="mb-1">收货人：${order.receiverName}</p>
                        <p class="mb-1">联系电话：${order.receiverPhone}</p>
                        <p class="mb-1">收货地址：${order.shippingAddress}</p>
                    </div>

                    <div class="mb-4">
                        <h6 class="text-muted">购买书籍列表</h6>
                        <ul class="list-group">
                            <c:forEach items="${order.orderItems}" var="item">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                        ${item.book.title}
                                    <span class="badge bg-primary rounded-pill">x${item.quantity}</span>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>

                    <div class="mb-4">
                        <h6 class="text-muted">商品信息</h6>
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
                                    <c:forEach items="${order.orderItems}" var="item">
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="${pageContext.request.contextPath}${item.book.coverImage}" 
                                                         alt="${item.book.title}" class="book-image me-3">
                                                    <div>
                                                        <div>${item.book.title}</div>
                                                        <small class="text-muted">${item.book.author}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>￥<fmt:formatNumber value="${item.price}" pattern="#,##0.00"/></td>
                                            <td>${item.quantity}</td>
                                            <td>￥<fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0.00"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="text-end">
                        <h5>总计：￥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></h5>
                    </div>
                </div>

                <div class="card-footer bg-light">
                    <div class="d-flex justify-content-between align-items-center">
                        <a href="${pageContext.request.contextPath}/order/list" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> 返回订单列表
                        </a>

                        <div>
                            <c:if test="${order.status eq 'PENDING' || order.status eq 'PENDING_SHIPMENT'}">
                                <a href="${pageContext.request.contextPath}/order/cancel?id=${order.id}"
                                   class="btn btn-danger"
                                   onclick="return confirm('确定要取消该订单吗？');">
                                    取消订单
                                </a>
                            </c:if>

                        <c:if test="${order.status eq 'PENDING'}">
                            <a href="${pageContext.request.contextPath}/order/confirm?id=${order.id}" 
                               class="btn btn-primary">
                                确认购买
                            </a>
                        </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
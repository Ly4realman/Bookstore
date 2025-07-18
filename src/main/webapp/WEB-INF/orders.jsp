<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="zh_CN" />
<fmt:setTimeZone value="Asia/Shanghai" />

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>我的订单</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="css/header.css">

    <style>

        .order-card {
            margin-bottom: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .order-header {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 8px 8px 0 0;
        }
        .order-body {
            padding: 20px;
        }
        .order-footer {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 0 0 8px 8px;
        }
        .book-image {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/header.jsp"/>

<div class="container mt-5">
    <h2 class="mb-4">我的订单</h2>
    
    <c:if test="${empty orders}">
        <div class="alert alert-info" role="alert">
            您还没有任何订单，去 <a href="${pageContext.request.contextPath}/index" class="alert-link">首页</a> 看看吧！
        </div>
    </c:if>
    
    <c:forEach items="${orders}" var="order">
        <div class="card order-card">
            <div class="order-header">
                <div class="row align-items-center">
                    <div class="col">
                        <span class="text-muted">订单号：${order.id}</span>
                    </div>
                    <div class="col text-end">
                        <span class="badge bg-${order.status eq 'PENDING' ? 'warning' :
                                           order.status eq 'PENDING_SHIPMENT' ? 'info' :
                                           order.status eq 'SHIPPED' ? 'primary' :
                                           order.status eq 'CANCELLED' ? 'danger' : 'secondary'}">
                            ${order.status eq 'PENDING' ? '待确认' :
                              order.status eq 'PENDING_SHIPMENT' ? '待发货' :
                              order.status eq 'SHIPPED' ? '已发货' :
                              order.status eq 'CANCELLED' ? '已取消' : '未知状态'}
                        </span>
                    </div>
                </div>
            </div>

            <div class="order-body">
                <h6 class="text-muted">书籍清单</h6>
                <ul class="list-group list-group-flush">
                    <c:forEach items="${order.orderItems}" var="item">
                        <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                                ${item.book.title}
                            <span class="badge bg-secondary rounded-pill">x${item.quantity}</span>
                        </li>
                    </c:forEach>
                </ul>
            </div>


            <div class="order-footer">
                <div class="row align-items-center">
                    <div class="col">
                        <p class="mb-0">
                            <small class="text-muted">下单时间：
                                <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </small>
                        </p>
                    </div>
                    <div class="col text-end">
                        <span class="h5 mb-0">总计：￥${order.totalAmount}</span>
                        <c:if test="${order.status eq 'PENDING' || order.status eq 'PENDING_SHIPMENT'}">
                            <a href="${pageContext.request.contextPath}/order/cancel?id=${order.id}"
                               class="btn btn-danger btn-sm ms-2"
                               onclick="return confirm('确定要取消该订单吗？');">
                                取消订单
                            </a>
                        </c:if>

                        <a href="${pageContext.request.contextPath}/order/detail?id=${order.id}"
                           class="btn btn-outline-primary btn-sm ms-3">查看详情</a>

                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
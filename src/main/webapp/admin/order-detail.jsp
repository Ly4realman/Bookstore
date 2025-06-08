<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单详情 - 书店管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .book-cover {
            width: 60px;
            height: 80px;
            object-fit: cover;
            border-radius: 4px;
        }
        .status-badge {
            font-size: 1rem;
            padding: 0.5rem 1rem;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav class="col-md-3 col-lg-2 d-md-block bg-dark sidebar collapse" style="min-height: 100vh;">
            <div class="position-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="bi bi-speedometer2"></i> 控制面板
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/books">
                            <i class="bi bi-book"></i> 图书管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/orders">
                            <i class="bi bi-cart"></i> 订单管理
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/users">
                            <i class="bi bi-people"></i> 用户管理
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Main content -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1>订单详情</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left"></i> 返回订单列表
                    </a>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8">
                    <!-- Order Information -->
                    <div class="card mb-4">
                        <div class="card-header">
                            <h5 class="card-title mb-0">订单信息</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>订单号：</strong> ${order.id}</p>
                                    <p><strong>下单时间：</strong> <fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                                    <p><strong>订单状态：</strong>
                                        <span class="badge bg-${order.status eq 'PENDING' ? 'warning' :
                                                           order.status eq 'PENDING_SHIPMENT' ? 'info' :
                                                           order.status eq 'SHIPPED' ? 'primary' :
                                                           order.status eq 'CANCELLED' ? 'danger' : 'secondary'}">
                                            ${order.status eq 'PENDING' ? '待确认' :
                                              order.status eq 'PENDING_SHIPMENT' ? '待发货' :
                                              order.status eq 'SHIPPED' ? '已发货' :
                                              order.status eq 'CANCELLED' ? '已取消' : '未知状态'}
                                        </span>
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>收货人：</strong> ${order.receiverName}</p>
                                    <p><strong>联系电话：</strong> ${order.receiverPhone}</p>
                                    <p><strong>收货地址：</strong> ${order.shippingAddress}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Order Items -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">订单商品</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>图书</th>
                                            <th>书名</th>
                                            <th>单价</th>
                                            <th>数量</th>
                                            <th>小计</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${order.orderItems}" var="item">
                                            <tr>
                                                <td>
                                                    <img src="${pageContext.request.contextPath}${item.book.coverImage}"
                                                         alt="${item.book.title}"
                                                         class="book-cover">
                                                </td>
                                                <td>
                                                    ${item.book.title}<br>
                                                    <small class="text-muted">${item.book.author}</small>
                                                </td>
                                                <td>￥${item.price}</td>
                                                <td>${item.quantity}</td>
                                                <td>￥<fmt:formatNumber value="${item.price * item.quantity}" pattern="#,##0.00"/></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td colspan="4" class="text-end"><strong>总计：</strong></td>
                                            <td><strong>￥${order.totalAmount}</strong></td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <!-- Order Actions -->
                    <div class="card">
                        <div class="card-header">
                            <h5 class="card-title mb-0">订单操作</h5>
                        </div>
                        <div class="card-body">
                            <form action="${pageContext.request.contextPath}/admin/orders/update-status" method="post">
                                <input type="hidden" name="orderId" value="${order.id}">
                                <div class="mb-3">
                                    <label for="status" class="form-label">更新订单状态</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="PENDING" ${order.status eq 'PENDING' ? 'selected' : ''}>待确认</option>
                                        <option value="PENDING_SHIPMENT" ${order.status eq 'PENDING_SHIPMENT' ? 'selected' : ''}>待发货</option>
                                        <option value="SHIPPED" ${order.status eq 'SHIPPED' ? 'selected' : ''}>已发货</option>
                                        <option value="CANCELLED" ${order.status eq 'CANCELLED' ? 'selected' : ''}>已取消</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary w-100">更新状态</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
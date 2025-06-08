<!-- 订单管理 -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单管理 - 书店管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .order-status {
            font-size: 0.875rem;
            padding: 0.25rem 0.5rem;
        }
        .table td {
            vertical-align: middle;
        }
        .address-cell {
            max-width: 200px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .phone-cell {
            white-space: nowrap;
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
                <h1>订单管理</h1>
            </div>

            <!-- Filter Section -->
            <div class="row mb-3">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-body">
                            <form class="row g-3" action="${pageContext.request.contextPath}/admin/orders" method="get">
                                <div class="col-md-3">
                                    <label for="status" class="form-label">订单状态</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="">全部</option>
                                        <option value="PENDING" ${param.status eq 'PENDING' ? 'selected' : ''}>待确认</option>
                                        <option value="PENDING_SHIPMENT" ${param.status eq 'PENDING_SHIPMENT' ? 'selected' : ''}>待发货</option>
                                        <option value="SHIPPED" ${param.status eq 'SHIPPED' ? 'selected' : ''}>已发货</option>
                                        <option value="CANCELLED" ${param.status eq 'CANCELLED' ? 'selected' : ''}>已取消</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="dateFrom" class="form-label">开始日期</label>
                                    <input type="date" class="form-control" id="dateFrom" name="dateFrom" value="${param.dateFrom}">
                                </div>
                                <div class="col-md-3">
                                    <label for="dateTo" class="form-label">结束日期</label>
                                    <input type="date" class="form-control" id="dateTo" name="dateTo" value="${param.dateTo}">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">&nbsp;</label>
                                    <button type="submit" class="btn btn-primary w-100">筛选</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Orders Table -->
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover">
                            <thead>
                                <tr>
                                    <th>订单号</th>
                                    <th>用户</th>
                                    <th>收货人</th>
                                    <th>联系电话</th>
                                    <th>收货地址</th>
                                    <th>总金额</th>
                                    <th>状态</th>
                                    <th>创建时间</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr>
                                        <td>${order.id}</td>
                                        <td>${order.username}</td>
                                        <td>${order.receiverName}</td>
                                        <td class="phone-cell">${order.receiverPhone}</td>
                                        <td class="address-cell" title="${order.shippingAddress}">${order.shippingAddress}</td>
                                        <td>￥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status eq 'PENDING'}">
                                                    <span class="badge bg-warning order-status">待确认</span>
                                                </c:when>
                                                <c:when test="${order.status eq 'PENDING_SHIPMENT'}">
                                                    <span class="badge bg-info order-status">待发货</span>
                                                </c:when>
                                                <c:when test="${order.status eq 'SHIPPED'}">
                                                    <span class="badge bg-primary order-status">已发货</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger order-status">已取消</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                                        <td>
                                            <div class="btn-group">
                                                <a href="${pageContext.request.contextPath}/admin/orders/detail?id=${order.id}"
                                                   class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-eye"></i> 查看
                                                </a>
                                                <button type="button" class="btn btn-sm btn-outline-secondary"
                                                        onclick="updateOrderStatus(${order.id})">
                                                    <i class="bi bi-pencil"></i> 更新状态
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Update Status Modal -->
<div class="modal fade" id="updateStatusModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">更新订单状态</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/orders/update-status" method="post">
                <div class="modal-body">
                    <input type="hidden" id="updateOrderId" name="orderId">
                    <div class="mb-3">
                        <label for="newStatus" class="form-label">新状态</label>
                        <select class="form-select" id="newStatus" name="status" required>
                            <option value="PENDING">待确认</option>
                            <option value="PENDING_SHIPMENT">待发货</option>
                            <option value="SHIPPED">已发货</option>
                            <option value="CANCELLED">已取消</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">更新</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function updateOrderStatus(orderId) {
        document.getElementById('updateOrderId').value = orderId;
        new bootstrap.Modal(document.getElementById('updateStatusModal')).show();
    }
</script>
</body>
</html>
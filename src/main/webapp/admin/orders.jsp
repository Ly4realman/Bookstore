<!-- 订单管理 -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>书店管理系统</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
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
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-outline-secondary" onclick="exportOrders()">
                            <i class="bi bi-download"></i> 导出订单
                        </button>
                    </div>
                </div>
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
                                        <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>待付款</option>
                                        <option value="paid" ${param.status == 'paid' ? 'selected' : ''}>已付款</option>
                                        <option value="shipped" ${param.status == 'shipped' ? 'selected' : ''}>已发货</option>
                                        <option value="delivered" ${param.status == 'delivered' ? 'selected' : ''}>已送达</option>
                                        <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>已取消</option>
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
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                    <tr>
                        <th>订单号</th>
                        <th>用户</th>
                        <th>总金额</th>
                        <th>状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td>${order.orderId}</td>
                            <td>${order.username}</td>
                            <td>￥<fmt:formatNumber value="${order.totalAmount}" pattern="#,##0.00"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status == 'pending'}">
                                        <span class="badge bg-warning">待付款</span>
                                    </c:when>
                                    <c:when test="${order.status == 'paid'}">
                                        <span class="badge bg-info">已付款</span>
                                    </c:when>
                                    <c:when test="${order.status == 'shipped'}">
                                        <span class="badge bg-primary">已发货</span>
                                    </c:when>
                                    <c:when test="${order.status == 'delivered'}">
                                        <span class="badge bg-success">已送达</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">已取消</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatDate value="${order.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                            <td>
                                <button class="btn btn-sm btn-primary" onclick="viewOrderDetails(${order.orderId})">
                                    <i class="bi bi-eye"></i> 查看
                                </button>
                                <button class="btn btn-sm btn-success" onclick="updateOrderStatus(${order.orderId})">
                                    <i class="bi bi-arrow-clockwise"></i> 更新
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage - 1}${not empty param.status ? '&status='.concat(param.status) : ''}">上一页</a>
                        </li>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}${not empty param.status ? '&status='.concat(param.status) : ''}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${currentPage + 1}${not empty param.status ? '&status='.concat(param.status) : ''}">下一页</a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </main>
    </div>
</div>

<!-- Order Details Modal -->
<div class="modal fade" id="orderDetailsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">订单详情</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="orderDetailsContent">
                    <!-- Content will be loaded dynamically -->
                </div>
            </div>
        </div>
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
            <form id="updateStatusForm" action="${pageContext.request.contextPath}/admin/orders/update-status" method="post">
                <div class="modal-body">
                    <input type="hidden" id="updateOrderId" name="orderId">
                    <div class="mb-3">
                        <label for="newStatus" class="form-label">新状态</label>
                        <select class="form-select" id="newStatus" name="status" required>
                            <option value="pending">待付款</option>
                            <option value="paid">已付款</option>
                            <option value="shipped">已发货</option>
                            <option value="delivered">已送达</option>
                            <option value="cancelled">已取消</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
                    <button type="submit" class="btn btn-primary">更新状态</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function viewOrderDetails(orderId) {
        fetch('${pageContext.request.contextPath}/admin/orders/' + orderId)
            .then(response => response.text())
            .then(html => {
                document.getElementById('orderDetailsContent').innerHTML = html;
                new bootstrap.Modal(document.getElementById('orderDetailsModal')).show();
            });
    }

    function updateOrderStatus(orderId) {
        document.getElementById('updateOrderId').value = orderId;
        new bootstrap.Modal(document.getElementById('updateStatusModal')).show();
    }

    function exportOrders() {
        window.location.href = '${pageContext.request.contextPath}/admin/orders/export' +
            window.location.search;
    }
</script>
</body>
</html>
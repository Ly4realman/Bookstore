<!-- 控制面板 -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/dashboard">
              <i class="bi bi-speedometer2"></i> 控制面板
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/books">
              <i class="bi bi-book"></i> 图书管理
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/orders">
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
        <h1>控制面板</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
          <div class="btn-group me-2">
            <a href="${pageContext.request.contextPath}/admin/logout" class="btn btn-sm btn-outline-danger">
              <i class="bi bi-box-arrow-right"></i> 退出登录
            </a>
          </div>
        </div>
      </div>

      <!-- Dashboard content -->
      <div class="row">
        <div class="col-md-4 mb-4">
          <div class="card text-white bg-primary">
            <div class="card-body">
              <h5 class="card-title">图书总数</h5>
              <p class="card-text h2">${totalBooks}</p>
            </div>
          </div>
        </div>
        <div class="col-md-4 mb-4">
          <div class="card text-white bg-success">
            <div class="card-body">
              <h5 class="card-title">订单总数</h5>
              <p class="card-text h2">${totalOrders}</p>
            </div>
          </div>
        </div>
        <div class="col-md-4 mb-4">
          <div class="card text-white bg-info">
            <div class="card-body">
              <h5 class="card-title">用户总数</h5>
              <p class="card-text h2">${totalUsers}</p>
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
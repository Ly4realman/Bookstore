<!-- 编辑用户 -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${empty user ? '添加用户' : '编辑用户'}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
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
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/admin/orders">
              <i class="bi bi-cart"></i> 订单管理
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/users">
              <i class="bi bi-people"></i> 用户管理
            </a>
          </li>
        </ul>
      </div>
    </nav>

    <!-- Main content -->
    <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
      <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <h1>${empty user ? '添加用户' : '编辑用户'}</h1>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
      </c:if>

      <div class="card">
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/admin/users${empty user ? '/add' : '/edit'}" class="needs-validation" novalidate>
            <c:if test="${not empty user}">
              <input type="hidden" name="id" value="${user.id}">
            </c:if>

            <div class="mb-3">
              <label for="username" class="form-label">用户名</label>
              <input type="text" class="form-control" id="username" name="username" value="${user.username}"
                     ${not empty user ? 'readonly' : 'required'}>
              <div class="invalid-feedback">请输入用户名</div>
            </div>

            <div class="mb-3">
              <label for="password" class="form-label">密码${not empty user ? '（留空表示不修改）' : ''}</label>
              <input type="password" class="form-control" id="password" name="password"
                     ${empty user ? 'required' : ''}>
              <div class="invalid-feedback">请输入密码</div>
            </div>

            <div class="mb-3">
              <label for="phone" class="form-label">手机号</label>
              <input type="tel" class="form-control" id="phone" name="phone" value="${user.phone}"
                     pattern="^1[3-9]\d{9}$">
              <div class="invalid-feedback">请输入有效的手机号</div>
            </div>

            <div class="mb-3">
              <label for="email" class="form-label">邮箱</label>
              <input type="email" class="form-control" id="email" name="email" value="${user.email}">
              <div class="invalid-feedback">请输入有效的邮箱地址</div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
              <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary me-md-2">取消</a>
              <button type="submit" class="btn btn-primary">保存</button>
            </div>
          </form>
        </div>
      </div>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // 表单验证
  (function () {
    'use strict'
    var forms = document.querySelectorAll('.needs-validation')
    Array.prototype.slice.call(forms)
      .forEach(function (form) {
        form.addEventListener('submit', function (event) {
          if (!form.checkValidity()) {
            event.preventDefault()
            event.stopPropagation()
          }
          form.classList.add('was-validated')
        }, false)
      })
  })()
</script>
</body>
</html>
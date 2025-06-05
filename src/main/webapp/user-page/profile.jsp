<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>个人信息</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link rel="stylesheet" href="../css/header.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        
        .profile-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            padding: 25px;
            margin-top: 30px;
            margin-bottom: 30px;
        }
        
        .profile-title {
            position: relative;
            margin-bottom: 25px;
            padding-bottom: 10px;
            color: #333;
        }
        
        .profile-title::after {
            content: '';
            position: absolute;
            left: 0;
            bottom: 0;
            width: 50px;
            height: 3px;
            background: #007bff;
        }
        
        .info-item {
            margin-bottom: 15px;
        }
        
        .info-label {
            font-weight: bold;
            color: #555;
        }
        
        .btn-action {
            margin-right: 10px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/components/header.jsp"/>

<div class="container">
    <div class="profile-container">
        <h3 class="profile-title">个人信息</h3>
        
        <!-- 显示操作结果消息 -->
        <c:if test="${not empty infoMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${infoMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty infoError}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${infoError}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty passwordMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${passwordMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty passwordError}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${passwordError}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        
        <!-- 用户信息展示 -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="info-item">
                    <div class="info-label">用户名</div>
                    <div>${user.username}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">收货人姓名</div>
                    <div>${empty user.realname ? '未设置' : user.realname}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">手机号码</div>
                    <div>${empty user.phone ? '未设置' : user.phone}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">邮箱</div>
                    <div>${empty user.email ? '未设置' : user.email}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">收货地址</div>
                    <div>${empty user.address ? '未设置' : user.address}</div>
                </div>
            </div>
        </div>
        
        <!-- 操作按钮 -->
        <div class="d-flex">
            <button type="button" class="btn btn-primary btn-action" data-bs-toggle="modal" data-bs-target="#editInfoModal">
                <i class="bi bi-pencil-square"></i> 编辑信息
            </button>
            <button type="button" class="btn btn-secondary btn-action" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                <i class="bi bi-key"></i> 修改密码
            </button>
        </div>
    </div>
</div>

<!-- 编辑信息模态框 -->
<div class="modal fade" id="editInfoModal" tabindex="-1" aria-labelledby="editInfoModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editInfoModalLabel">编辑个人信息</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="/user/profile" method="post">
                <input type="hidden" name="action" value="updateInfo">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="realname" class="form-label">收货人姓名</label>
                        <input type="text" class="form-control" id="realname" name="realname" value="${user.realname}">
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">手机号码</label>
                        <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}">
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">邮箱</label>
                        <input type="email" class="form-control" id="email" name="email" value="${user.email}">
                    </div>
                    <div class="mb-3">
                        <label for="address" class="form-label">收货地址</label>
                        <textarea class="form-control" id="address" name="address" rows="3">${user.address}</textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 修改密码模态框 -->
<div class="modal fade" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="changePasswordModalLabel">修改密码</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="/user/profile" method="post">
                <input type="hidden" name="action" value="updatePassword">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="oldPassword" class="form-label">旧密码</label>
                        <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">新密码</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">确认新密码</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">保存</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 页脚 -->
<footer class="bg-light py-4 mt-5">
    <div class="container text-center text-muted">
        <p>&copy; 2025 模糊书店. All rights reserved.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

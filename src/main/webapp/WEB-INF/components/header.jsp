<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/index">
            <i class="bi bi-book"></i> 糊涂书店
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- 搜索框 -->
            <div class="w-100 d-flex justify-content-center mb-3">
                <form class="d-flex w-100 justify-content-center" action="search" method="get" style="max-width: 600px; min-width: 250px;">
                    <div class="input-group w-100">
                        <input type="text" name="query" class="form-control search-input"
                               placeholder="搜索图书、作者..." required>
                        <button type="submit" class="btn btn-outline-primary">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>
            </div>

            <!-- 用户菜单 -->
            <ul class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link" href="/user-page/login.jsp">登录</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/user-page/register.jsp">注册</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle user-welcome" href="#" id="userDropdown" role="button"
                               data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle"></i>
                                欢迎，${sessionScope.user.username}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li>
                                    <a class="dropdown-item" href="/user/profile">
                                        <i class="bi bi-person"></i> 个人信息
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/order/list">
                                        <i class="bi bi-receipt"></i> 我的订单
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item position-relative" href="/cart">
                                        <i class="bi bi-cart3"></i> 购物车
                                        <c:if test="${not empty cartItemCount}">
                                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                                    ${cartItemCount}
                                            </span>
                                        </c:if>
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="/user/logout">
                                        <i class="bi bi-box-arrow-right"></i> 退出登录
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav> 
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>搜索结果 - ${searchQuery}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
  <link rel="stylesheet" href="css/header.css">

</head>
<body>

<jsp:include page="/WEB-INF/components/header.jsp"/>

<div class="container mt-5">
  <h3>搜索结果："${searchQuery}"</h3>
  <hr>
  <div class="row">
    <c:forEach var="book" items="${resultList}">
      <div class="col-md-3 mb-4">
        <div class="card h-100 book-card">
          <img src="${book.coverImage}" class="card-img-top" alt="${book.title}">
          <div class="card-body">
            <h5 class="card-title">${book.title}</h5>
            <p class="card-text">作者：${book.author}</p>
            <p class="card-text text-danger fw-bold">￥${book.price}</p>
            <a href="bookDetail?id=${book.id}" class="btn btn-sm btn-primary">查看详情</a>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>

  <c:if test="${empty resultList}">
    <p class="text-muted">未找到相关图书。</p>
  </c:if>
</div>

<!-- 页脚 -->
<footer class="bg-light py-4 mt-5">
  <div class="container text-center text-muted">
    <p>&copy; 2025 糊涂书店. All rights reserved.</p>
  </div>
</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>

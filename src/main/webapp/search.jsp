<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>搜索结果 - ${searchQuery}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
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
</body>
</html>

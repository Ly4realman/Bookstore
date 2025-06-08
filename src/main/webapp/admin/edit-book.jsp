<!-- 图书编辑 -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <title>书店管理系统</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
  <style>
    .image-preview {
      max-width: 200px;
      max-height: 300px;
      margin-top: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      padding: 5px;
    }
    .preview-container {
      position: relative;
      display: inline-block;
    }
    .remove-image {
      position: absolute;
      top: 0;
      right: 0;
      background: rgba(255, 255, 255, 0.8);
      border: none;
      border-radius: 50%;
      padding: 5px 8px;
      cursor: pointer;
      margin: 5px;
    }
    .remove-image:hover {
      background: rgba(255, 0, 0, 0.1);
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
            <a class="nav-link active text-white" href="${pageContext.request.contextPath}/admin/books">
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
        <h1>编辑图书</h1>
        <div class="btn-toolbar mb-2 mb-md-0">
          <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-secondary">
            <i class="bi bi-arrow-left"></i> 返回图书列表
          </a>
        </div>
      </div>

      <div class="row">
        <div class="col-md-8">
          <form action="${pageContext.request.contextPath}/admin/books/edit" method="post" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${book.id}">
            <input type="hidden" name="currentCoverImage" value="${book.coverImage}">

            <div class="mb-3">
              <label for="title" class="form-label">书名</label>
              <input type="text" class="form-control" id="title" name="title" value="${book.title}" required>
            </div>

            <div class="mb-3">
              <label for="author" class="form-label">作者</label>
              <input type="text" class="form-control" id="author" name="author" value="${book.author}" required>
            </div>

            <div class="mb-3">
              <label for="price" class="form-label">价格</label>
              <input type="number" step="0.01" class="form-control" id="price" name="price" value="${book.price}" required>
            </div>

            <div class="mb-3">
              <label for="stock" class="form-label">库存</label>
              <input type="number" class="form-control" id="stock" name="stock" value="${book.stock}" required>
            </div>

            <div class="mb-3">
              <label for="description" class="form-label">描述</label>
              <textarea class="form-control" id="description" name="description" rows="3">${book.description}</textarea>
            </div>

            <div class="mb-3">
              <label for="coverImage" class="form-label">封面图片</label>
              <input type="file" class="form-control" id="coverImage" name="coverImage" accept="image/jpeg,image/png,image/gif,image/webp" onchange="previewImage(this);">
              <div class="form-text">支持的格式：JPEG、PNG、GIF、WebP，最大文件大小：10MB</div>
              <input type="hidden" name="currentCoverImage" value="${book.coverImage}" id="currentCoverImage">
              <div id="imagePreviewContainer" class="preview-container mt-2 ${empty book.coverImage ? 'd-none' : ''}">
                <img src="${pageContext.request.contextPath}${book.coverImage}" 
                     alt="${book.title}" 
                     class="image-preview" 
                     id="imagePreview">
                <button type="button" class="remove-image" onclick="removeImage()">
                  <i class="bi bi-x"></i>
                </button>
              </div>
            </div>

            <div class="mb-3 form-check">
              <input type="checkbox" class="form-check-input" id="isHot" name="isHot" ${book.hot ? 'checked' : ''}>
              <label class="form-check-label" for="isHot">标记为热门</label>
            </div>

            <div class="mb-3">
              <button type="submit" class="btn btn-primary">保存修改</button>
              <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-secondary">取消</a>
            </div>
          </form>
        </div>

        <div class="col-md-4">
          <div class="card">
            <div class="card-body">
              <h5 class="card-title">图书统计</h5>
              <p class="card-text">
                <strong>总销量：</strong> ${book.sales}<br>
                <strong>当前库存：</strong> ${book.stock}<br>
                <strong>状态：</strong>
                <c:choose>
                  <c:when test="${book.hot}">
                    <span class="badge bg-danger">热门</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge bg-secondary">普通</span>
                  </c:otherwise>
                </c:choose>
              </p>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function previewImage(input) {
  const previewContainer = document.getElementById('imagePreviewContainer');
  const preview = document.getElementById('imagePreview');
  const currentImageInput = document.getElementById('currentCoverImage');

  if (input.files && input.files[0]) {
    const reader = new FileReader();
    
    reader.onload = function(e) {
      preview.src = e.target.result;
      previewContainer.classList.remove('d-none');
    }
    
    reader.readAsDataURL(input.files[0]);
  }
}

function removeImage() {
  const previewContainer = document.getElementById('imagePreviewContainer');
  const preview = document.getElementById('imagePreview');
  const fileInput = document.getElementById('coverImage');
  const currentImageInput = document.getElementById('currentCoverImage');
  
  preview.src = '';
  fileInput.value = '';
  currentImageInput.value = '';
  previewContainer.classList.add('d-none');
}
</script>
</body>
</html>
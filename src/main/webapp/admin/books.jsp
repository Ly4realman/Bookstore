<!-- 图书管理 -->
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
        .book-cover-thumb {
            width: 50px;
            height: 70px;
            object-fit: cover;
            border-radius: 4px;
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
                <h1>图书管理</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addBookModal">
                        <i class="bi bi-plus"></i> 添加新书
                    </button>
                </div>
            </div>

            <c:if test="${not empty message}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <!-- Books Table -->
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>封面</th>
                        <th>书名</th>
                        <th>作者</th>
                        <th>价格</th>
                        <th>库存</th>
                        <th>热门</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="book" items="${books}">
                        <tr>
                            <td>${book.id}</td>
                            <td>
                                <c:if test="${not empty book.coverImage}">
                                    <img src="${pageContext.request.contextPath}${book.coverImage}" 
                                         alt="${book.title}" 
                                         class="book-cover-thumb">
                                </c:if>
                            </td>
                            <td>${book.title}</td>
                            <td>${book.author}</td>
                            <td>￥${book.price}</td>
                            <td>${book.stock}</td>
                            <td>
                                <c:if test="${book.hot}">
                                    <span class="badge bg-danger">热门</span>
                                </c:if>
                            </td>
                            <td>
                                <button class="btn btn-sm btn-primary" onclick="editBook(${book.id})">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <button class="btn btn-sm btn-danger" onclick="deleteBook(${book.id})">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<!-- Add Book Modal -->
<div class="modal fade" id="addBookModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">添加新书</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/books/add" method="post" enctype="multipart/form-data">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="title" class="form-label">书名</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="author" class="form-label">作者</label>
                        <input type="text" class="form-control" id="author" name="author" required>
                    </div>
                    <div class="mb-3">
                        <label for="price" class="form-label">价格</label>
                        <input type="number" step="0.01" class="form-control" id="price" name="price" required>
                    </div>
                    <div class="mb-3">
                        <label for="stock" class="form-label">库存</label>
                        <input type="number" class="form-control" id="stock" name="stock" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">描述</label>
                        <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                    </div>
                    <div class="mb-3">
                        <label for="coverImage" class="form-label">封面图片</label>
                        <input type="file" class="form-control" id="coverImage" name="coverImage" accept="image/jpeg,image/png,image/gif,image/webp" onchange="previewImage(this, 'addBookPreview');">
                        <div class="form-text">支持的格式：JPEG、PNG、GIF、WebP，最大文件大小：10MB</div>
                        <div id="addBookPreviewContainer" class="preview-container mt-2 d-none">
                            <img src="" alt="" class="image-preview" id="addBookPreview">
                            <button type="button" class="remove-image" onclick="removeImage('addBook')">
                                <i class="bi bi-x"></i>
                            </button>
                        </div>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="isHot" name="isHot">
                        <label class="form-check-label" for="isHot">标记为热门</label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">添加</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editBook(bookId) {
        window.location.href = '${pageContext.request.contextPath}/admin/books/edit?id=' + bookId;
    }

    function deleteBook(bookId) {
        if (confirm('确定要删除这本书吗？')) {
            window.location.href = '${pageContext.request.contextPath}/admin/books/delete?id=' + bookId;
        }
    }

    function previewImage(input, previewId) {
        const previewContainer = document.getElementById(previewId + 'Container');
        const preview = document.getElementById(previewId);
        
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                preview.src = e.target.result;
                previewContainer.classList.remove('d-none');
            };
            
            reader.readAsDataURL(input.files[0]);
        }
    }

    function removeImage(prefix) {
        const previewContainer = document.getElementById(prefix + 'PreviewContainer');
        const preview = document.getElementById(prefix + 'Preview');
        const fileInput = document.getElementById('coverImage');
        
        preview.src = '';
        fileInput.value = '';
        previewContainer.classList.add('d-none');
    }

    // 清除模态框
    document.getElementById('addBookModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('addBookPreviewContainer').classList.add('d-none');
        document.getElementById('addBookPreview').src = '';
        document.getElementById('coverImage').value = '';
    });
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookstore.bean.Book" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>图书列表</title>
</head>
<body>
<h2>图书展示</h2>

<table border="1" cellpadding="8" cellspacing="0">
    <tr>
        <th>ID</th>
        <th>书名</th>
        <th>作者</th>
        <th>价格</th>
        <th>库存</th>
        <th>简介</th>
    </tr>

    <%
        List<Book> bookList = (List<Book>) request.getAttribute("bookList");
        if (bookList != null) {
            for (Book book : bookList) {
    %>
    <tr>
        <td><%= book.getId() %></td>
        <td><%= book.getTitle() %></td>
        <td><%= book.getAuthor() %></td>
        <td><%= book.getPrice() %></td>
        <td><%= book.getStock() %></td>
        <td><%= book.getDescription() %></td>
    </tr>
    <%
            }
        }
    %>
</table>

<p><a href="index.jsp">返回主页</a></p>
</body>
</html>

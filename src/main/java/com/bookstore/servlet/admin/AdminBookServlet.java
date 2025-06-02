package com.bookstore.servlet.admin;

import com.bookstore.bean.Book;
import com.bookstore.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet({ "/admin/books", "/admin/books/*" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class AdminBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all books
            listBooks(request, response);
        } else if (pathInfo.equals("/edit")) {
            // Show edit form
            getBookForEdit(request, response);
        } else if (pathInfo.equals("/delete")) {
            // Delete book
            deleteBook(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/add")) {
            // Add new book
            addBook(request, response);
        } else if (pathInfo.equals("/edit")) {
            // Update existing book
            updateBook(request, response);
        }
    }

    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM book ORDER BY id DESC";

        try (Connection conn = DBUtil.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPrice(rs.getBigDecimal("price"));
                book.setStock(rs.getInt("stock"));
                book.setDescription(rs.getString("description"));
                book.setCoverImage(rs.getString("cover_image"));
                book.setHot(rs.getBoolean("is_hot"));
                book.setSales(rs.getInt("sales"));
                books.add(book);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取图书列表失败");
        }

        request.setAttribute("books", books);
        request.getRequestDispatcher("/admin/books.jsp").forward(request, response);
    }

    private void addBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String description = request.getParameter("description");
        boolean isHot = request.getParameter("isHot") != null;

        // Handle file upload
        Part filePart = request.getPart("coverImage");
        String coverImage = null;
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
            String uploadPath = getServletContext().getRealPath("/uploads/covers/");
            filePart.write(uploadPath + fileName);
            coverImage = "/uploads/covers/" + fileName;
        }

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 1. 获取当前最大ID
            int nextId = 1;
            String maxIdSql = "SELECT COALESCE(MAX(id), 0) + 1 FROM book";
            try (Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(maxIdSql)) {
                if (rs.next()) {
                    nextId = rs.getInt(1);
                }
            }

            // 2. 插入新书籍
            String sql = "INSERT INTO book (id, title, author, price, stock, description, cover_image, is_hot) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, nextId);
                stmt.setString(2, title);
                stmt.setString(3, author);
                stmt.setBigDecimal(4, price);
                stmt.setInt(5, stock);
                stmt.setString(6, description);
                stmt.setString(7, coverImage);
                stmt.setBoolean(8, isHot);

                stmt.executeUpdate();
            }

            conn.commit(); // 提交事务
            request.setAttribute("message", "图书添加成功");
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback(); // 发生错误时回滚
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            request.setAttribute("error", "添加图书失败");
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // 恢复自动提交
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private void updateBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String description = request.getParameter("description");
        boolean isHot = request.getParameter("isHot") != null;

        // Handle file upload
        Part filePart = request.getPart("coverImage");
        String coverImage = request.getParameter("currentCoverImage");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
            String uploadPath = getServletContext().getRealPath("/uploads/covers/");
            filePart.write(uploadPath + fileName);
            coverImage = "/uploads/covers/" + fileName;
        }

        String sql = "UPDATE book SET title=?, author=?, price=?, stock=?, description=?, cover_image=?, is_hot=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, title);
            stmt.setString(2, author);
            stmt.setBigDecimal(3, price);
            stmt.setInt(4, stock);
            stmt.setString(5, description);
            stmt.setString(6, coverImage);
            stmt.setBoolean(7, isHot);
            stmt.setInt(8, id);

            stmt.executeUpdate();
            request.setAttribute("message", "图书更新成功");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "更新图书失败");
        }

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private void deleteBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Connection conn = null;

        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 1. 删除这本书
            String deleteSql = "DELETE FROM book WHERE id=?";
            try (PreparedStatement stmt = conn.prepareStatement(deleteSql)) {
                stmt.setInt(1, id);
                stmt.executeUpdate();
            }

            // 2. 重置AUTO_INCREMENT
            String resetSql = "ALTER TABLE book AUTO_INCREMENT = 1";
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(resetSql);
            }

            // 3. 重新排序现有ID
            String reorderSql = "SET @count = 0; " +
                    "UPDATE book SET id = @count:= @count + 1 ORDER BY id;";
            try (Statement stmt = conn.createStatement()) {
                stmt.execute(reorderSql);
            }

            conn.commit(); // 提交事务
            request.setAttribute("message", "图书删除成功");
        } catch (SQLException e) {
            try {
                if (conn != null) {
                    conn.rollback(); // 发生错误时回滚
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            request.setAttribute("error", "删除图书失败");
        } finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true); // 恢复自动提交
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private void getBookForEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        String sql = "SELECT * FROM book WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
                PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPrice(rs.getBigDecimal("price"));
                book.setStock(rs.getInt("stock"));
                book.setDescription(rs.getString("description"));
                book.setCoverImage(rs.getString("cover_image"));
                book.setHot(rs.getBoolean("is_hot"));
                book.setSales(rs.getInt("sales"));

                request.setAttribute("book", book);
                request.getRequestDispatcher("/admin/edit-book.jsp").forward(request, response);
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取图书详情失败");
        }

        response.sendRedirect(request.getContextPath() + "/admin/books");
    }

    private String getFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                String fileName = token.substring(token.indexOf("=") + 2, token.length() - 1);
                int dotIndex = fileName.lastIndexOf('.');
                return dotIndex > 0 ? fileName.substring(dotIndex) : "";
            }
        }
        return "";
    }
}
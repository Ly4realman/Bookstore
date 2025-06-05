package com.bookstore.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Statement;
import com.bookstore.util.DBUtil;

@WebServlet("/admin/init-db")
public class DatabaseInitServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // 获取SQL脚本
            String sql = "CREATE TABLE IF NOT EXISTS user (" +
                    "id INT PRIMARY KEY AUTO_INCREMENT," +
                    "username VARCHAR(50) NOT NULL UNIQUE," +
                    "password VARCHAR(255) NOT NULL," +
                    "phone VARCHAR(20)," +
                    "email VARCHAR(100)," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ");";

            // 执行SQL
            try (Connection conn = DBUtil.getConnection();
                    Statement stmt = conn.createStatement()) {
                stmt.execute(sql);
                out.println("<h2>数据库初始化成功！</h2>");
                out.println("<p>user表已创建。</p>");
            }
        } catch (Exception e) {
            out.println("<h2>数据库初始化失败！</h2>");
            out.println("<p>错误信息：" + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }
}
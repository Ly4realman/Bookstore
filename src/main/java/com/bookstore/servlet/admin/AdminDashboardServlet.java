package com.bookstore.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.bookstore.util.DBUtil;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if admin is logged in
        if (request.getSession().getAttribute("adminUsername") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            // Get total books count
            String booksSql = "SELECT COUNT(*) as total FROM book";
            try (PreparedStatement stmt = conn.prepareStatement(booksSql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("totalBooks", rs.getInt("total"));
                }
            }

            // Get total users count
            String usersSql = "SELECT COUNT(*) as total FROM user";
            try (PreparedStatement stmt = conn.prepareStatement(usersSql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("totalUsers", rs.getInt("total"));
                }
            }

            // Get total orders count (assuming you have an orders table)
            String ordersSql = "SELECT COUNT(*) as total FROM orders";
            try (PreparedStatement stmt = conn.prepareStatement(ordersSql)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("totalOrders", rs.getInt("total"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching dashboard data");
        }

        request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
    }
}
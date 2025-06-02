package com.bookstore.servlet.admin;

import com.bookstore.bean.Order;
import com.bookstore.bean.OrderItem;
import com.bookstore.util.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet({ "/admin/orders", "/admin/orders/*" })
public class AdminOrderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // List all orders
            listOrders(request, response);
        } else {
            // View order details
            int orderId = Integer.parseInt(pathInfo.substring(1));
            getOrderDetails(request, response, orderId);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo != null && pathInfo.equals("/update-status")) {
            // Update order status
            updateOrderStatus(request, response);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> orders = new ArrayList<>();

        // Get filter parameters
        String status = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");
        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        int pageSize = 10;

        // Build SQL query with filters
        StringBuilder sql = new StringBuilder(
                "SELECT o.*, u.username FROM orders o JOIN user u ON o.user_id = u.user_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            sql.append(" AND o.status = ?");
            params.add(status);
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND DATE(o.created_at) >= ?");
            params.add(dateFrom);
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND DATE(o.created_at) <= ?");
            params.add(dateTo);
        }

        sql.append(" ORDER BY o.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setUsername(rs.getString("username"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));
                orders.add(order);
            }

            // Get total count for pagination
            String countSql = sql.toString().replaceFirst("SELECT o.*, u.username", "SELECT COUNT(*)");
            countSql = countSql.substring(0, countSql.lastIndexOf("LIMIT"));
            try (PreparedStatement countStmt = conn.prepareStatement(countSql)) {
                for (int i = 0; i < params.size() - 2; i++) {
                    countStmt.setObject(i + 1, params.get(i));
                }
                ResultSet countRs = countStmt.executeQuery();
                if (countRs.next()) {
                    int totalOrders = countRs.getInt(1);
                    int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
                    request.setAttribute("totalPages", totalPages);
                    request.setAttribute("currentPage", page);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching orders");
        }

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    private void getOrderDetails(HttpServletRequest request, HttpServletResponse response, int orderId)
            throws ServletException, IOException {
        try (Connection conn = DBUtil.getConnection()) {
            // Get order details
            String orderSql = "SELECT o.*, u.username FROM orders o JOIN user u ON o.user_id = u.user_id WHERE o.order_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(orderSql)) {
                stmt.setInt(1, orderId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setUsername(rs.getString("username"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    order.setUpdatedAt(rs.getTimestamp("updated_at"));

                    // Get order items
                    String itemsSql = "SELECT oi.*, b.title FROM order_items oi JOIN book b ON oi.book_id = b.id WHERE oi.order_id = ?";
                    try (PreparedStatement itemsStmt = conn.prepareStatement(itemsSql)) {
                        itemsStmt.setInt(1, orderId);
                        ResultSet itemsRs = itemsStmt.executeQuery();

                        List<OrderItem> items = new ArrayList<>();
                        while (itemsRs.next()) {
                            OrderItem item = new OrderItem();
                            item.setItemId(itemsRs.getInt("item_id"));
                            item.setOrderId(itemsRs.getInt("order_id"));
                            item.setBookId(itemsRs.getInt("book_id"));
                            item.setBookTitle(itemsRs.getString("title"));
                            item.setQuantity(itemsRs.getInt("quantity"));
                            item.setPrice(itemsRs.getBigDecimal("price"));
                            items.add(item);
                        }
                        order.setItems(items);
                    }

                    request.setAttribute("order", order);
                    request.getRequestDispatcher("/admin/order-details.jsp").forward(request, response);
                    return;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error fetching order details");
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        String sql = "UPDATE orders SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE order_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            stmt.executeUpdate();

            request.setAttribute("message", "Order status updated successfully");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error updating order status");
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
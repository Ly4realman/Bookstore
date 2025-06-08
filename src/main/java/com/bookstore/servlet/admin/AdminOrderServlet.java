package com.bookstore.servlet.admin;

import com.bookstore.bean.Order;
import com.bookstore.dao.OrderDAO;
import com.bookstore.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/admin/orders/*")
public class AdminOrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // 检查管理员是否登录
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                // 显示订单列表
                listOrders(request, response);
            } else if (pathInfo.equals("/detail")) {
                // 显示订单详情
                showOrderDetail(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "数据库操作失败");
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        // 检查管理员是否登录
        HttpSession session = request.getSession();
        if (session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        try {
            if (pathInfo.equals("/update-status")) {
                // 更新订单状态
                updateOrderStatus(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "数据库操作失败");
            request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
        }
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        // 获取筛选参数
        String status = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        // 构建查询条件
        Timestamp fromDate = null;
        Timestamp toDate = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

        try {
            if (dateFrom != null && !dateFrom.isEmpty()) {
                Date date = sdf.parse(dateFrom);
                fromDate = new Timestamp(date.getTime());
            }
            if (dateTo != null && !dateTo.isEmpty()) {
                Date date = sdf.parse(dateTo);
                // 设置为当天的最后一秒
                toDate = new Timestamp(date.getTime() + 24 * 60 * 60 * 1000 - 1);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }

        // 获取订单列表
        List<Order> orders = orderDAO.getOrdersByFilter(status, fromDate, toDate);

        // 设置属性并转发到JSP
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int orderId = Integer.parseInt(request.getParameter("id"));
        Order order = orderDAO.getOrderById(orderId);

        if (order != null) {
            request.setAttribute("order", order);
            request.getRequestDispatcher("/admin/order-detail.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        orderDAO.updateOrderStatus(orderId, status.toUpperCase());

        // 重定向回订单列表
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
package com.bookstore.servlet;

import com.bookstore.bean.Book;
import com.bookstore.bean.CartItem;
import com.bookstore.bean.Order;
import com.bookstore.bean.OrderItem;
import com.bookstore.bean.User;
import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CartDAO;
import com.bookstore.dao.OrderDAO;
import com.bookstore.util.DBUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/order/*")
public class OrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO cartDAO = new CartDAO();
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
            // 显示用户的所有订单
            showUserOrders(request, response);
        } else if (pathInfo.equals("/detail")) {
            // 显示订单详情
            showOrderDetail(request, response);
        } else if (pathInfo.equals("/confirm")) {
            // 确认购买（更新订单状态）
            confirmOrder(request, response);
        } else if (pathInfo.equals("/cancel")) {
            // 取消订单
            cancelOrder(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND); // 非法路径
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/create")) {
            // 创建新订单
            createOrder(request, response);
        }
    }

    private String getStatusLabel(String status) {
        switch (status) {
            case "PENDING":
                return "待确认";
            case "PENDING_SHIPMENT":
                return "待发货";
            case "SHIPPED":
                return "已发货";
            case "CANCELLED":
                return "已取消";
            default:
                return "未知状态";
        }
    }

    private String getStatusBadgeColor(String status) {
        switch (status) {
            case "PENDING":
                return "warning";
            case "PENDING_SHIPMENT":
                return "info";
            case "SHIPPED":
                return "primary";
            case "CANCELLED":
                return "danger";
            default:
                return "secondary";
        }
    }

    private void showUserOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
            List<Order> orders = orderDAO.getUserOrdersWithItems(user.getId());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/orders.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "获取订单列表失败");
        }
    }

    private void showOrderDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 验证订单所属用户
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null || order.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // 设置状态展示文本和样式颜色
            request.setAttribute("order", order);
            request.setAttribute("statusLabel", getStatusLabel(order.getStatus()));
            request.setAttribute("statusColor", getStatusBadgeColor(order.getStatus()));

            request.getRequestDispatcher("/WEB-INF/order_detail.jsp").forward(request, response);
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void confirmOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            // 验证订单所属用户
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null || order.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            // 更新订单状态为待发货
            orderDAO.updateOrderStatus(orderId, "PENDING_SHIPMENT");

            // 重定向到订单列表页面
            response.sendRedirect(request.getContextPath() + "/order/list");

        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void createOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }

        try {
            // 仅从购物车获取商品
            List<CartItem> cartItems = cartDAO.getCartItems(user.getId());
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // 创建订单对象
            Order order = new Order();
            order.setUserId(user.getId());
            order.setStatus("PENDING");
            order.setReceiverName(request.getParameter("receiverName"));
            order.setReceiverPhone(request.getParameter("receiverPhone"));
            order.setShippingAddress(request.getParameter("shippingAddress"));

            BigDecimal totalAmount = BigDecimal.ZERO;
            List<OrderItem> orderItems = new ArrayList<>();

            for (CartItem cartItem : cartItems) {
                Book book = bookDAO.getBookById(cartItem.getBookId());

                if (book == null || book.getStock() < cartItem.getQuantity()) {
                    request.setAttribute("error", "部分商品库存不足");
                    request.setAttribute("cartItems", cartItems);
                    request.setAttribute("totalAmount", totalAmount);
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/WEB-INF/checkout.jsp").forward(request, response);
                    return;
                }

                OrderItem orderItem = new OrderItem();
                orderItem.setBookId(cartItem.getBookId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(book.getPrice());
                orderItems.add(orderItem);

                totalAmount = totalAmount.add(book.getPrice().multiply(new BigDecimal(cartItem.getQuantity())));

                // 减库存
                book.setStock(book.getStock() - cartItem.getQuantity());
                bookDAO.updateBook(book);
            }

            order.setTotalAmount(totalAmount);

            // 插入订单和订单项
            int orderId = orderDAO.createOrder(order);
            if (orderId == -1) {
                throw new SQLException("创建订单失败");
            }

            orderDAO.createOrderItems(orderId, orderItems);

            // 清空购物车
            cartDAO.clearCart(user.getId());

            // 跳转到订单详情页
            response.sendRedirect(request.getContextPath() + "/order/detail?id=" + orderId);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "创建订单失败，请稍后重试");
            request.getRequestDispatcher("/WEB-INF/checkout.jsp").forward(request, response);
        }
    }

    private void cancelOrder(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderIdStr = request.getParameter("id");
        if (orderIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Connection conn = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // 开启事务

            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (order == null || user == null || order.getUserId() != user.getId()) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            if (!order.getStatus().equals("PENDING") && !order.getStatus().equals("PENDING_SHIPMENT")) {
                request.setAttribute("error", "该订单无法取消");
                request.getRequestDispatcher("/WEB-INF/order_detail.jsp").forward(request, response);
                return;
            }

            // 更新状态为已取消
            orderDAO.updateOrderStatus(orderId, "CANCELLED");

            // 恢复库存
            for (OrderItem item : order.getOrderItems()) {
                Book book = bookDAO.getBookById(item.getBookId());
                if (book != null) {
                    book.setStock(book.getStock() + item.getQuantity());
                    bookDAO.updateBook(book);
                }
            }

            conn.commit(); // 提交事务
            response.sendRedirect(request.getContextPath() + "/order/list");
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback(); // 发生错误时回滚
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
    }

}
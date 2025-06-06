package com.bookstore.servlet;

import com.bookstore.bean.Book;
import com.bookstore.bean.CartItem;
import com.bookstore.bean.Order;
import com.bookstore.bean.OrderItem;
import com.bookstore.bean.User;
import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CartDAO;
import com.bookstore.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
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

    private void showUserOrders(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/user/login");
            return;
        }
        
        try {
            List<Order> orders = orderDAO.getUserOrders(user.getId());
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/WEB-INF/orders.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
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
            
            request.setAttribute("order", order);
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
            // 获取购物车项目
            List<CartItem> cartItems = cartDAO.getCartItems(user.getId());
            if (cartItems.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
            // 创建订单
            Order order = new Order();
            order.setUserId(user.getId());
            order.setStatus("PENDING"); // 初始状态为待确认
            order.setReceiverName(request.getParameter("receiverName"));
            order.setReceiverPhone(request.getParameter("receiverPhone"));
            order.setShippingAddress(request.getParameter("shippingAddress"));
            
            // 计算总金额
            BigDecimal totalAmount = BigDecimal.ZERO;
            List<OrderItem> orderItems = new ArrayList<>();
            
            for (CartItem cartItem : cartItems) {
                Book book = bookDAO.getBookById(cartItem.getBookId());
                if (book == null || book.getStock() < cartItem.getQuantity()) {
                    request.setAttribute("error", "部分商品库存不足");
                    request.getRequestDispatcher("/WEB-INF/checkout.jsp").forward(request, response);
                    return;
                }
                
                OrderItem orderItem = new OrderItem();
                orderItem.setBookId(cartItem.getBookId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setPrice(book.getPrice());
                orderItems.add(orderItem);
                
                totalAmount = totalAmount.add(book.getPrice().multiply(new BigDecimal(cartItem.getQuantity())));
                
                // 更新库存
                book.setStock(book.getStock() - cartItem.getQuantity());
                bookDAO.updateBook(book);
            }
            
            order.setTotalAmount(totalAmount);
            
            // 保存订单
            int orderId = orderDAO.createOrder(order);
            if (orderId == -1) {
                throw new SQLException("Failed to create order");
            }
            
            // 保存订单项
            orderDAO.createOrderItems(orderId, orderItems);
            
            // 清空购物车
            cartDAO.clearCart(user.getId());
            
            // 重定向到订单详情页面
            response.sendRedirect(request.getContextPath() + "/order/detail?id=" + orderId);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "创建订单失败，请稍后重试");
            request.getRequestDispatcher("/WEB-INF/checkout.jsp").forward(request, response);
        }
    }
}
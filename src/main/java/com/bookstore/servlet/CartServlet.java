package com.bookstore.servlet;

import com.bookstore.bean.CartItem;
import com.bookstore.bean.User;
import com.bookstore.dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/cart/*")
public class CartServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getPathInfo();
        if (action == null) {
            // 显示购物车页面
            List<CartItem> cartItems = cartDAO.getCartItems(user.getId());
            request.setAttribute("cartItems", cartItems);
            request.getRequestDispatcher("/WEB-INF/cart.jsp").forward(request, response);
        } else {
            // 处理其他GET请求
            switch (action) {
                case "/update":
                    handleUpdateCart(request, response);
                    break;
                case "/remove":
                    handleRemoveFromCart(request, response);
                    break;
                case "/clear":
                    handleClearCart(request, response, user.getId());
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/cart");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            String referer = request.getHeader("Referer");
            if (referer != null) {
                session.setAttribute("returnUrl", referer);
            }
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getPathInfo();
        if ("/add".equals(action)) {
            handleAddToCart(request, response, user.getId());
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {
        try {
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            boolean success = cartDAO.addItem(userId, bookId, quantity);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/cart");
            } else {
                request.getSession().setAttribute("errorMessage", "添加到购物车失败，请稍后重试");
                String referer = request.getHeader("Referer");
                response.sendRedirect(referer != null ? referer : request.getContextPath() + "/cart");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "参数格式错误");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleUpdateCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            
            if (quantity <= 0) {
                request.getSession().setAttribute("errorMessage", "商品数量必须大于0");
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
            
            boolean success = cartDAO.updateItemQuantity(cartItemId, quantity);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/cart");
            } else {
                request.getSession().setAttribute("errorMessage", "更新购物车失败，请稍后重试");
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "参数格式错误");
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
            boolean success = cartDAO.removeItem(cartItemId);
            if (!success) {
                request.getSession().setAttribute("errorMessage", "删除商品失败，请稍后重试");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "参数格式错误");
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleClearCart(HttpServletRequest request, HttpServletResponse response, int userId)
            throws IOException {
        boolean success = cartDAO.clearCart(userId);
        if (!success) {
            request.getSession().setAttribute("errorMessage", "清空购物车失败，请稍后重试");
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }
} 
package com.bookstore.servlet;

import com.bookstore.bean.Book;
import com.bookstore.bean.CartItem;
import com.bookstore.bean.User;
import com.bookstore.dao.BookDAO;
import com.bookstore.dao.CartDAO;
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

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // 处理立即购买的情况
            String bookIdStr = request.getParameter("bookId");
            if (bookIdStr != null) {
                int bookId = Integer.parseInt(bookIdStr);
                Book book = bookDAO.getBookById(bookId);
                if (book != null) {
                    CartItem item = new CartItem();
                    item.setBook(book);
                    item.setQuantity(1);
                    List<CartItem> items = new ArrayList<>();
                    items.add(item);
                    request.setAttribute("cartItems", items);
                    request.setAttribute("totalAmount", book.getPrice());
                } else {
                    response.sendRedirect(request.getContextPath() + "/index");
                    return;
                }
            } else {
                // 处理购物车结算的情况
                List<CartItem> cartItems = cartDAO.getCartItems(user.getId());
                if (cartItems.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }
                
                // 计算总金额
                BigDecimal totalAmount = BigDecimal.ZERO;
                for (CartItem item : cartItems) {
                    totalAmount = totalAmount.add(item.getBook().getPrice().multiply(new BigDecimal(item.getQuantity())));
                }
                
                request.setAttribute("cartItems", cartItems);
                request.setAttribute("totalAmount", totalAmount);
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/WEB-INF/checkout.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/index");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "系统错误，请稍后重试");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
} 
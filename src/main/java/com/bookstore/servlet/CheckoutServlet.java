package com.bookstore.servlet;

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
            // 仅处理购物车结算
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
            request.setAttribute("user", user);

            // 清除旧的立即购买数据（保险起见）
            session.removeAttribute("immediatePurchaseItems");

            request.getRequestDispatcher("/WEB-INF/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // 建议开发期保留日志
            request.setAttribute("error", "系统错误，请稍后重试");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}

package com.bookstore.servlet.user;

import com.bookstore.bean.User;
import com.bookstore.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/user/login")
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password").trim();
        String inputCaptcha = request.getParameter("captcha");

        HttpSession session = request.getSession();
        String sessionCaptcha = (String) session.getAttribute("captcha");

        // 验证验证码
        if (sessionCaptcha == null || !sessionCaptcha.equals(inputCaptcha)) {
            request.setAttribute("error", "验证码错误");
            request.getRequestDispatcher("/user-page/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.findByUsername(username);
        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            // 保存管理员的登录状态（如果存在）
            String adminUsername = (String) session.getAttribute("adminUsername");
            Object adminObj = session.getAttribute("admin");

            // 清除用户相关的 session 数据
            session.removeAttribute("user");
            session.removeAttribute("captcha");

            // 重新设置管理员的登录状态（如果之前存在）
            if (adminUsername != null) {
                session.setAttribute("adminUsername", adminUsername);
            }
            if (adminObj != null) {
                session.setAttribute("admin", adminObj);
            }

            // 设置用户登录状态
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30分钟过期

            // 设置 cookie 安全属性
            Cookie cookie = new Cookie("JSESSIONID", session.getId());
            cookie.setHttpOnly(true);
            cookie.setSecure(true); // 仅在 HTTPS 启用时设置
            response.addCookie(cookie);

            response.sendRedirect("/index");
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/user-page/login.jsp").forward(request, response);
        }
    }
}

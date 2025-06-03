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
            // 清除旧 session，创建新 session（防 session fixation）
            session.invalidate();
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("user", user);
            newSession.setMaxInactiveInterval(30 * 60); // 30分钟过期

            // 设置 cookie 安全属性
            Cookie cookie = new Cookie("JSESSIONID", newSession.getId());
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

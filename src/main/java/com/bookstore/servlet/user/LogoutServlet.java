package com.bookstore.servlet.user;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/user/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
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
        }
        response.sendRedirect(request.getContextPath() + "/index");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
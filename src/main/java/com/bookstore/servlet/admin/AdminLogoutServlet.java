package com.bookstore.servlet.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/logout")
public class AdminLogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            // 保存用户的登录状态（如果存在）
            Object userObj = session.getAttribute("user");

            // 清除管理员相关的 session 数据
            session.removeAttribute("adminUsername");
            session.removeAttribute("admin");

            // 如果之前有用户登录，恢复用户状态
            if (userObj != null) {
                session.setAttribute("user", userObj);
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/login");
    }
}
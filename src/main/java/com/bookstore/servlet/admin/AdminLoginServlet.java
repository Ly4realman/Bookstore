package com.bookstore.servlet.admin;

import com.bookstore.dao.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("Login attempt - Username: " + username); // 调试日志

        if (adminDAO.validateLogin(username, password)) {
            System.out.println("Login successful for user: " + username); // 调试日志
            HttpSession session = request.getSession();
            session.setAttribute("adminUsername", username);
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            System.out.println("Login failed for user: " + username); // 调试日志
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/admin/login.jsp").forward(request, response);
    }
}
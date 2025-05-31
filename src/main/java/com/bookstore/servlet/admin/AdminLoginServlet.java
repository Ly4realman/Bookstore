package com.bookstore.servlet.admin;

import com.bookstore.bean.Admin;
import com.bookstore.dao.AdminDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");


        Admin admin = adminDAO.findByUsername(username);

        if (admin != null && BCrypt.checkpw(password, admin.getPassword())) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", admin);
            request.getRequestDispatcher("/WEB-INF/dashboard.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "用户名或密码错误");
            request.getRequestDispatcher("/WEB-INF/admin_login.jsp").forward(request, response);
        }
    }
}

package com.bookstore.servlet.user;

import com.bookstore.bean.User;
import com.bookstore.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


import java.io.IOException;

@WebServlet("/user/profile")
public class ProfileServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            // 如果用户未登录，重定向到登录页面
            response.sendRedirect("login");
            return;
        }
        
        // 从数据库获取最新的用户信息
        User latestUser = userDAO.findById(user.getId());
        if (latestUser != null) {
            // 更新会话中的用户信息
            session.setAttribute("user", latestUser);
        }
        
        // 转发到个人信息页面
        request.getRequestDispatcher("/user-page/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            // 如果用户未登录，重定向到登录页面
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("updateInfo".equals(action)) {
            // 处理更新用户信息的请求
            String realname = request.getParameter("realname");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            
            user.setRealname(realname);
            user.setPhone(phone);
            user.setEmail(email);
            user.setAddress(address);
            
            boolean success = userDAO.updateUserInfo(user);
            
            if (success) {
                request.setAttribute("infoMessage", "个人信息更新成功！");
            } else {
                request.setAttribute("infoError", "个人信息更新失败，请稍后再试。");
            }
            
        } else if ("updatePassword".equals(action)) {
            // 处理修改密码的请求
            String oldPassword = request.getParameter("oldPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // 验证旧密码是否正确
            if (!userDAO.checkPassword(user.getId(), oldPassword)) {
                request.setAttribute("passwordError", "旧密码不正确！");
            } 
            // 验证新密码和确认密码是否一致
            else if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("passwordError", "新密码和确认密码不一致！");
            } 
            // 更新密码
            else {
                boolean success = userDAO.updatePassword(user.getId(), newPassword);
                
                if (success) {
                    request.setAttribute("passwordMessage", "密码修改成功！");
                } else {
                    request.setAttribute("passwordError", "密码修改失败，请稍后再试。");
                }
            }
        }
        
        // 重新获取最新的用户信息
        User latestUser = userDAO.findById(user.getId());
        if (latestUser != null) {
            // 更新会话中的用户信息
            session.setAttribute("user", latestUser);
        }
        
        // 转发到个人信息页面
        request.getRequestDispatcher("/user-page/profile.jsp").forward(request, response);
    }
}

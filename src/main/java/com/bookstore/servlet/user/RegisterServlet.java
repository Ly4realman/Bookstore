package com.bookstore.servlet.user;

import com.bookstore.bean.User;
import com.bookstore.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/user/register")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        List<String> errors = new ArrayList<>();


        // 1. 用户名非空且唯一
        if (username == null || username.trim().isEmpty()) {
            errors.add("用户名不能为空");
        } else if (userDAO.findByUsername(username) != null) {
            errors.add("用户名已存在");
        }

        // 2. 密码一致性和复杂度校验
        if (password == null || confirmPassword == null || !password.equals(confirmPassword)) {
            errors.add("两次输入的密码不一致");
        } else if (!isPasswordStrong(password)) {
            errors.add("密码必须至少8位，包含大写、小写字母和数字");
        }

        // 3. 手机号格式校验
        if (phone == null || !phone.matches("^1[3-9]\\d{9}$")) {
            errors.add("手机号格式不正确");
        }

        // 4. 邮箱格式校验
        if (email == null || !email.matches("^[\\w.-]+@[\\w.-]+\\.[a-zA-Z]{2,}$")) {
            errors.add("邮箱格式不正确");
        }


        // 5. 如果有错误，回显并终止
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/user-page/register.jsp").forward(request, response);
            return;
        }

        // 6. 全部验证通过，保存用户（调用 register 方法）
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(hashedPassword);
        newUser.setPhone(phone);
        newUser.setEmail(email);

        boolean success = userDAO.register(newUser);
        
        if (success) {
            response.sendRedirect("/user-page/login.jsp");
        } else {
            errors.add("注册失败，请稍后重试");
            request.setAttribute("errors", errors);
            request.getRequestDispatcher("/user-page/register.jsp").forward(request, response);
        }
    }

    // 密码复杂度校验方法（同之前）
    private boolean isPasswordStrong(String password) {
        return password.length() >= 8 &&
                password.matches(".*[a-z].*") &&
                password.matches(".*[A-Z].*") &&
                password.matches(".*\\d.*");
    }

}

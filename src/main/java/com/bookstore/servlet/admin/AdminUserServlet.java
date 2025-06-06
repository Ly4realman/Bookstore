package com.bookstore.servlet.admin;

import com.bookstore.bean.User;
import com.bookstore.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.List;

@WebServlet({ "/admin/users", "/admin/users/*" })
public class AdminUserServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查管理员是否已登录
        if (request.getSession().getAttribute("adminUsername") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // 显示用户列表
            listUsers(request, response);
        } else if (pathInfo.equals("/add")) {
            // 显示添加用户表单
            request.setAttribute("user", null); // 确保user属性为null，表示是添加操作
            request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
        } else if (pathInfo.equals("/edit")) {
            // 显示编辑用户表单
            showEditForm(request, response);
        } else if (pathInfo.equals("/delete")) {
            // 删除用户
            deleteUser(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 检查管理员是否已登录
        if (request.getSession().getAttribute("adminUsername") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/add")) {
            // 添加新用户
            addUser(request, response);
        } else if (pathInfo.equals("/edit")) {
            // 更新用户信息
            updateUser(request, response);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            User user = new User();
            user.setId(userId);

            // 获取其他参数
            String username = request.getParameter("username");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            user.setUsername(username);
            user.setPhone(phone);
            user.setEmail(email);

            request.setAttribute("user", user);
            request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        // 表单验证
        if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "用户名和密码不能为空");
            request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
            return;
        }

        // 验证用户名是否已存在
        if (userDAO.findByUsername(username) != null) {
            request.setAttribute("error", "用户名已存在");
            request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
            return;
        }

        // 验证密码长度
        if (password.length() < 6) {
            request.setAttribute("error", "密码长度必须至少为6位");
            request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
            return;
        }

        // 验证手机号格式
        if (phone != null && !phone.trim().isEmpty() && !phone.matches("^1[3-9]\\d{9}$")) {
            request.setAttribute("error", "手机号格式不正确");
            request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt())); // 加密密码
        user.setPhone(phone);
        user.setEmail(email);

        if (userDAO.addUser(user)) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        } else {
            request.setAttribute("error", "添加用户失败");
            request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // 验证手机号格式
            if (phone != null && !phone.trim().isEmpty() && !phone.matches("^1[3-9]\\d{9}$")) {
                request.setAttribute("error", "手机号格式不正确");
                request.setAttribute("user", new User());
                request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
                return;
            }

            User user = new User();
            user.setId(userId);
            user.setPhone(phone);
            user.setEmail(email);

            // 如果提供了新密码，则更新密码
            if (password != null && !password.trim().isEmpty()) {
                if (password.length() < 6) {
                    request.setAttribute("error", "密码长度必须至少为6位");
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
                    return;
                }
                user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            }

            if (userDAO.updateUser(user)) {
                response.sendRedirect(request.getContextPath() + "/admin/users");
            } else {
                request.setAttribute("error", "更新用户失败");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/admin/user-form.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            if (userDAO.deleteUser(userId)) {
                response.sendRedirect(request.getContextPath() + "/admin/users");
            } else {
                request.setAttribute("error", "删除用户失败");
                listUsers(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }
}
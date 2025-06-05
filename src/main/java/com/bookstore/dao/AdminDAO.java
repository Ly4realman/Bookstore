package com.bookstore.dao;

import com.bookstore.bean.Admin;
import com.bookstore.util.DBUtil;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;

public class AdminDAO {
    public Admin findByUsername(String username) {
        String sql = "SELECT * FROM admin WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password")); // 哈希值
                return admin;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean validateLogin(String username, String password) {
        Admin admin = findByUsername(username);
        if (admin != null) {
            // 验证密码是否匹配（使用BCrypt）
            boolean matches = BCrypt.checkpw(password, admin.getPassword());
            System.out.println("Password validation result: " + matches); // 调试日志
            return matches;
        }
        return false;
    }

}

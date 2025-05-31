package com.bookstore.dao;

import com.bookstore.bean.Admin;
import com.bookstore.util.DBUtil;
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
}

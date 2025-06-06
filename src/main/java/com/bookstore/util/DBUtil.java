package com.bookstore.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/bookstore?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "root";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("Error loading MySQL JDBC Driver: " + e.getMessage());
            throw new RuntimeException("加载数据库驱动失败", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connection established successfully");
            return conn;
        } catch (SQLException e) {
            System.err.println("Error connecting to database: " + e.getMessage());
            throw e;
        }
    }
}

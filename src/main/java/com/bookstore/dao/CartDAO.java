package com.bookstore.dao;

import com.bookstore.bean.Book;
import com.bookstore.bean.CartItem;
import com.bookstore.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {
    private final BookDAO bookDAO = new BookDAO();

    // 获取用户的购物车ID，如果不存在则创建
    public int getOrCreateCart(int userId) {
        String selectSql = "SELECT id FROM cart WHERE user_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 如果购物车不存在，创建新的购物车
        String insertSql = "INSERT INTO cart (user_id) VALUES (?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // 添加商品到购物车
    public boolean addItem(int userId, int bookId, int quantity) {
        int cartId = getOrCreateCart(userId);
        if (cartId == -1) return false;

        String sql = "INSERT INTO cart_item (cart_id, book_id, quantity) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 更新购物车中商品数量
    public boolean updateItemQuantity(int cartItemId, int quantity) {
        String sql = "UPDATE cart_item SET quantity = ? WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 从购物车中删除商品
    public boolean removeItem(int cartItemId) {
        String sql = "DELETE FROM cart_item WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 获取用户购物车中的所有商品
    public List<CartItem> getCartItems(int userId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.id, ci.cart_id, ci.book_id, ci.quantity " +
                    "FROM cart_item ci " +
                    "JOIN cart c ON ci.cart_id = c.id " +
                    "WHERE c.user_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CartItem item = new CartItem();
                item.setId(rs.getInt("id"));
                item.setCartId(rs.getInt("cart_id"));
                item.setQuantity(rs.getInt("quantity"));
                
                // 获取图书信息
                Book book = bookDAO.getBookById(rs.getInt("book_id"));
                item.setBook(book);
                
                items.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    // 清空购物车
    public boolean clearCart(int userId) {
        int cartId = getOrCreateCart(userId);
        if (cartId == -1) return false;

        String sql = "DELETE FROM cart_item WHERE cart_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            return ps.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
} 
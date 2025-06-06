package com.bookstore.dao;

import com.bookstore.bean.Book;
import com.bookstore.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {
    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM book";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setTitle(rs.getString("title"));
                book.setAuthor(rs.getString("author"));
                book.setPrice(rs.getBigDecimal("price"));
                book.setCoverImage(rs.getString("cover_image"));
                book.setStock(rs.getInt("stock"));
                book.setCoverImage(rs.getString("cover_image"));
                book.setDescription(rs.getString("description"));
                books.add(book);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }

    public List<Book> getHotBooks() {
        List<Book> hotBooks = new ArrayList<>();
        String sql = "SELECT id, title, price, cover_image FROM book WHERE is_hot = 1";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Book book = new Book();
                book.setId(rs.getInt("id"));
                book.setTitle(rs.getString("title"));
                book.setPrice(rs.getBigDecimal("price"));
                book.setCoverImage(rs.getString("cover_image"));
                hotBooks.add(book);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return hotBooks;
    }

    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book book = new Book();
        book.setId(rs.getInt("id"));
        book.setTitle(rs.getString("title"));
        book.setAuthor(rs.getString("author"));
        book.setPrice(rs.getBigDecimal("price"));
        book.setStock(rs.getInt("stock"));
        book.setDescription(rs.getString("description"));
        book.setCoverImage(rs.getString("cover_image"));
        book.setRecommendation(rs.getString("recommendation"));
        return book;
    }

    public List<Book> searchBooks(String keyword) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM book WHERE title LIKE ? OR author LIKE ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String pattern = "%" + keyword + "%";
            stmt.setString(1, pattern);
            stmt.setString(2, pattern);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Book book = mapResultSetToBook(rs);
                list.add(book);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Book getBookById(int id) throws SQLException {
        String sql = "SELECT * FROM book WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Book book = new Book();
                    book.setId(rs.getInt("id"));
                    book.setTitle(rs.getString("title"));
                    book.setAuthor(rs.getString("author"));
                    book.setPrice(rs.getBigDecimal("price"));
                    book.setStock(rs.getInt("stock"));
                    book.setDescription(rs.getString("description"));
                    book.setCoverImage(rs.getString("cover_image"));
                    book.setHot(rs.getBoolean("is_hot"));
                    book.setSales(rs.getInt("sales"));
                    book.setRecommendation(rs.getString("recommendation"));
                    return book;
                }
            }
        }
        return null;
    }

    public void updateBook(Book book) throws SQLException {
        String sql = "UPDATE book SET title = ?, author = ?, price = ?, stock = ?, " +
                    "description = ?, cover_image = ?, is_hot = ?, sales = ?, recommendation = ? " +
                    "WHERE id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, book.getTitle());
            stmt.setString(2, book.getAuthor());
            stmt.setBigDecimal(3, book.getPrice());
            stmt.setInt(4, book.getStock());
            stmt.setString(5, book.getDescription());
            stmt.setString(6, book.getCoverImage());
            stmt.setBoolean(7, book.isHot());
            stmt.setInt(8, book.getSales());
            stmt.setString(9, book.getRecommendation());
            stmt.setInt(10, book.getId());
            
            stmt.executeUpdate();
        }
    }
}

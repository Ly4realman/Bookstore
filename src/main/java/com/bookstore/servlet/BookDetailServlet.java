package com.bookstore.servlet;

import com.bookstore.bean.Book;
import com.bookstore.dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/bookDetail")
public class BookDetailServlet extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idStr = request.getParameter("id");
        
        try {
            int id = Integer.parseInt(idStr);
            Book book = bookDAO.getBookById(id);
            
            if (book != null) {
                request.setAttribute("book", book);
                request.getRequestDispatcher("/WEB-INF/book_detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("index"); // 如果图书不存在，重定向到首页
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("index"); // 如果id格式不正确，重定向到首页
        }
    }
} 
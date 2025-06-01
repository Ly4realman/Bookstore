package com.bookstore.servlet;

import com.bookstore.bean.Book;
import com.bookstore.dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/index")
public class HomeServlet extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 热门图书
        List<Book> hotBooks = bookDAO.getHotBooks();
        request.setAttribute("hotBooks", hotBooks);

        // 全部图书
        List<Book> books = bookDAO.getAllBooks();
        request.setAttribute("bookList", books);

        // 一次性转发给 index.jsp
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}


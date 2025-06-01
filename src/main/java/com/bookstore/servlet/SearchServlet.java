package com.bookstore.servlet;

import com.bookstore.bean.Book;
import com.bookstore.dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("query");
        List<Book> resultList = bookDAO.searchBooks(query);

        request.setAttribute("searchQuery", query);
        request.setAttribute("resultList", resultList);

        request.getRequestDispatcher("search.jsp").forward(request, response);
    }
}

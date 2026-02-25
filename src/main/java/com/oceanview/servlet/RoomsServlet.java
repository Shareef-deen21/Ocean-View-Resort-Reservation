package com.oceanview.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/rooms")
public class RoomsServlet extends BaseServlet {
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        if (!requireLogin(q, r)) return;
        try {
            q.setAttribute("rooms", service.getAllRooms());
        } catch (Exception e) { q.setAttribute("error", e.getMessage()); }
        fwd(q, r, "/pages/rooms.jsp");
    }
}

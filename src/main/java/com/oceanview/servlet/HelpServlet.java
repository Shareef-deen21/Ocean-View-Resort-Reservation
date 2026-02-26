package com.oceanview.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/help")
public class HelpServlet extends BaseServlet {

    @Override
    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        if (!requireLogin(q, r)) return;
        try {
            // Pass live stats to the help page
            q.setAttribute("totalRes",       service.getTotalReservations());
            q.setAttribute("availableRooms", service.getAvailableRoomCount());
            q.setAttribute("allRooms",       service.getAllRooms());
        } catch (Exception e) {
            // Non-critical — help page still loads without stats
        }
        fwd(q, r, "/pages/help.jsp");
    }
}

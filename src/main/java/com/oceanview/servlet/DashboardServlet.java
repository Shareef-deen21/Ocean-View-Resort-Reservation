package com.oceanview.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends BaseServlet {
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws ServletException, IOException {
        if (!requireLogin(q, r)) return;
        try {
            q.setAttribute("totalRes",        service.getTotalReservations());
            q.setAttribute("confirmedCount",  service.getConfirmedCount());
            q.setAttribute("checkedInCount",  service.getCheckedInCount());
            q.setAttribute("availableRooms",  service.getAvailableRoomCount());
            q.setAttribute("totalRevenue",    service.getTotalRevenue());
            q.setAttribute("recentRes",       service.getAll());
            q.setAttribute("auditLog",        service.getAuditLog());
            q.setAttribute("dbOk",            service.isDbConnected());
        } catch (Exception e) { q.setAttribute("dbError", e.getMessage()); }
        fwd(q, r, "/pages/dashboard.jsp");
    }
}

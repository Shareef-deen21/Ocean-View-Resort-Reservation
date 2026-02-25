package com.oceanview.servlet;

import com.oceanview.model.User;
import com.oceanview.service.ReservationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * ABSTRACTION + INHERITANCE — abstract parent for all servlets
 */
public abstract class BaseServlet extends HttpServlet {

    protected final ReservationService service = new ReservationService();

    protected boolean isLoggedIn(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("currentUser") != null;
    }

    protected User currentUser(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s == null ? null : (User) s.getAttribute("currentUser");
    }

    protected boolean requireLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        if (!isLoggedIn(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return false; }
        return true;
    }

    protected void fwd(HttpServletRequest req, HttpServletResponse resp, String jsp)
            throws ServletException, IOException {
        req.getRequestDispatcher(jsp).forward(req, resp);
    }

    protected String p(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        return v == null ? "" : v.trim();
    }

    protected int pi(HttpServletRequest req, String name, int def) {
        try { return Integer.parseInt(p(req, name)); }
        catch (NumberFormatException e) { return def; }
    }
}

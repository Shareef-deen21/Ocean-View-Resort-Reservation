package com.oceanview.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends BaseServlet {
    @Override protected void doGet(HttpServletRequest q, HttpServletResponse r) throws IOException {
        HttpSession s = q.getSession(false);
        if (s != null) s.invalidate();
        r.sendRedirect(q.getContextPath()+"/login");
    }
}

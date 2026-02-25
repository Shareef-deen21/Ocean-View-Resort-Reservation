package com.oceanview.servlet;

import com.oceanview.repository.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends BaseServlet {

    private final UserRepository userRepo = new UserRepository();

    @Override
    protected void doGet(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {
        if (isLoggedIn(q)) {
            r.sendRedirect(q.getContextPath() + "/dashboard");
            return;
        }
        fwd(q, r, "/pages/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest q, HttpServletResponse r)
            throws ServletException, IOException {

        String username = p(q, "username");
        String password = p(q, "password");

        // ── 1. Empty field validation ─────────────────────────────
        if (username.isEmpty() && password.isEmpty()) {
            q.setAttribute("errorType",     "both");
            q.setAttribute("usernameError", "Username is required.");
            q.setAttribute("passwordError", "Password is required.");
            q.setAttribute("enteredUsername", "");
            fwd(q, r, "/pages/login.jsp");
            return;
        }

        if (username.isEmpty()) {
            q.setAttribute("errorType",     "username");
            q.setAttribute("usernameError", "Username is required.");
            q.setAttribute("enteredUsername", "");
            fwd(q, r, "/pages/login.jsp");
            return;
        }

        if (password.isEmpty()) {
            q.setAttribute("errorType",     "password");
            q.setAttribute("passwordError", "Password is required.");
            q.setAttribute("enteredUsername", username);
            fwd(q, r, "/pages/login.jsp");
            return;
        }

        // ── 2. Database authentication with specific errors ───────
        try {
            // First check — does the username exist at all?
            boolean userExists = userRepo.usernameExists(username);

            if (!userExists) {
                // Username not found in database
                q.setAttribute("errorType",     "username");
                q.setAttribute("usernameError", "No account found with username \"" + username + "\".");
                q.setAttribute("enteredUsername", username);
                fwd(q, r, "/pages/login.jsp");
                return;
            }

            // Username exists — now check full credentials
            var user = service.login(username, password);

            if (user != null) {
                // ✅ Login success
                HttpSession s = q.getSession(true);
                s.setAttribute("currentUser", user);
                s.setMaxInactiveInterval(1800); // 30 min
                r.sendRedirect(q.getContextPath() + "/dashboard");
            } else {
                // Username exists but password is wrong
                q.setAttribute("errorType",     "password");
                q.setAttribute("passwordError", "Incorrect password. Please try again.");
                q.setAttribute("enteredUsername", username);
                fwd(q, r, "/pages/login.jsp");
            }

        } catch (Exception e) {
            // ── 3. Database connection error ──────────────────────
            q.setAttribute("errorType",     "db");
            q.setAttribute("dbError",
                "Cannot connect to the database. Please check DBConnection.java — " + e.getMessage());
            q.setAttribute("enteredUsername", username);
            fwd(q, r, "/pages/login.jsp");
        }
    }
}

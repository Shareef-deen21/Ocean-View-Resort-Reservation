package com.oceanview.singleton;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * SINGLETON PATTERN (Holder idiom — thread-safe lazy init)
 * !! CHANGE USERNAME AND PASSWORD TO MATCH YOUR MYSQL SETUP !!
 */
public class DBConnection {

    // ── Configure your MySQL here ─────────────────────────────────
    private static final String HOST     = "localhost";
    private static final String PORT     = "3306";
    private static final String DATABASE = "ocean_view_resort";
    private static final String USERNAME = "root";    // ← your MySQL username
    private static final String PASSWORD = "Oceanviewresort!!##";    // ← your MySQL password
    // ─────────────────────────────────────────────────────────────

    private static final String URL =
        "jdbc:mysql://" + HOST + ":" + PORT + "/" + DATABASE
        + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true&useUnicode=true&characterEncoding=utf8";

    private static final class Holder {
        private static final DBConnection INSTANCE = new DBConnection();
    }

    private DBConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found!", e);
        }
    }

    public static DBConnection getInstance() {
        return Holder.INSTANCE;
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    public boolean isConnected() {
        try (Connection c = getConnection()) {
            return c.isValid(2);
        } catch (SQLException e) {
            return false;
        }
    }
}

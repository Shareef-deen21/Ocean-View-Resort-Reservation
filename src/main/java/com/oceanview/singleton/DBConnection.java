package com.oceanview.singleton;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;


public class DBConnection {

    // ── Configure MySQL
    private static final String HOST     = "localhost";
    private static final String PORT     = "3306";
    private static final String DATABASE = "ocean_view_resort";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "Oceanviewresort!!##";
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

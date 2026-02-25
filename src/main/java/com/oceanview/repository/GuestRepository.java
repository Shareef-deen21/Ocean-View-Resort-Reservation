package com.oceanview.repository;

import com.oceanview.model.Guest;
import com.oceanview.singleton.DBConnection;

import java.sql.*;

public class GuestRepository {

    public int save(Guest g) throws SQLException {
        String sql = "INSERT INTO guests (full_name,email,phone,address,nationality,id_type,id_number) VALUES (?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, g.getFullName());
            ps.setString(2, g.getEmail());
            ps.setString(3, g.getPhone());
            ps.setString(4, g.getAddress());
            ps.setString(5, g.getNationality());
            ps.setString(6, g.getIdType());
            ps.setString(7, g.getIdNumber());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        }
    }

    public Guest findById(int id) throws SQLException {
        String sql = "SELECT * FROM guests WHERE id=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    public Guest mapRow(ResultSet rs) throws SQLException {
        Guest g = new Guest();
        g.setId(rs.getInt("id"));
        g.setFullName(rs.getString("full_name"));
        g.setEmail(rs.getString("email"));
        g.setPhone(rs.getString("phone"));
        g.setAddress(rs.getString("address"));
        g.setNationality(rs.getString("nationality"));
        g.setIdType(rs.getString("id_type"));
        g.setIdNumber(rs.getString("id_number"));
        return g;
    }
}

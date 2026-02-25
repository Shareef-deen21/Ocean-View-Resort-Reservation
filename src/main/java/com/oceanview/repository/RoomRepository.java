package com.oceanview.repository;

import com.oceanview.model.Room;
import com.oceanview.singleton.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoomRepository {

    public List<Room> findAll() throws SQLException {
        return query("SELECT * FROM rooms ORDER BY room_number");
    }

    public List<Room> findAvailable() throws SQLException {
        return query("SELECT * FROM rooms WHERE status='AVAILABLE' ORDER BY room_type, room_number");
    }

    public List<Room> findAvailableForDates(String checkIn, String checkOut) throws SQLException {
        String sql = """
            SELECT r.* FROM rooms r
            WHERE r.status='AVAILABLE'
              AND r.id NOT IN (
                SELECT res.room_id FROM reservations res
                WHERE res.status NOT IN ('CANCELLED','CHECKED_OUT')
                  AND res.check_in_date  < ?
                  AND res.check_out_date > ?
              )
            ORDER BY r.room_type, r.room_number
            """;
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, checkOut);
            ps.setString(2, checkIn);
            return mapList(ps.executeQuery());
        }
    }

    public Room findById(int id) throws SQLException {
        String sql = "SELECT * FROM rooms WHERE id=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        }
    }

    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public void updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE rooms SET status=? WHERE id=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status); ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    private List<Room> query(String sql) throws SQLException {
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            return mapList(ps.executeQuery());
        }
    }

    private List<Room> mapList(ResultSet rs) throws SQLException {
        List<Room> list = new ArrayList<>();
        while (rs.next()) list.add(mapRow(rs));
        return list;
    }

    public Room mapRow(ResultSet rs) throws SQLException {
        Room r = new Room();
        r.setId(rs.getInt("id"));
        r.setRoomNumber(rs.getString("room_number"));
        r.setRoomType(rs.getString("room_type"));
        r.setRatePerNight(rs.getDouble("rate_per_night"));
        r.setCapacity(rs.getInt("capacity"));
        r.setDescription(rs.getString("description"));
        r.setStatus(rs.getString("status"));
        r.setFloorNumber(rs.getInt("floor_number"));
        return r;
    }
}

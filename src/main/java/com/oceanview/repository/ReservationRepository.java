package com.oceanview.repository;

import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.model.Guest;
import com.oceanview.singleton.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class ReservationRepository {

    public int save(Reservation r) throws SQLException {
        String sql = """
            INSERT INTO reservations
              (reservation_number,guest_id,room_id,check_in_date,check_out_date,
               num_guests,total_amount,status,special_requests)
            VALUES (?,?,?,?,?,?,?,?,?)
            """;
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, r.getReservationNumber());
            ps.setInt   (2, r.getGuest().getId());
            ps.setInt   (3, r.getRoom().getId());
            ps.setDate  (4, Date.valueOf(r.getCheckInDate()));
            ps.setDate  (5, Date.valueOf(r.getCheckOutDate()));
            ps.setInt   (6, r.getNumGuests());
            ps.setDouble(7, r.calculateTotal());
            ps.setString(8, r.getStatus());
            ps.setString(9, r.getSpecialRequests());
            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        }
    }

    public Reservation findById(int id) throws SQLException {
        return queryOne(buildSelect("WHERE res.id=?"), id);
    }

    public Reservation findByNumber(String num) throws SQLException {
        String sql = buildSelect("WHERE res.reservation_number=?");
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, num);
            List<Reservation> list = mapList(ps.executeQuery());
            return list.isEmpty() ? null : list.get(0);
        }
    }

    public List<Reservation> findAll() throws SQLException {
        return queryList(buildSelect("ORDER BY res.created_at DESC"));
    }

    public List<Reservation> search(String kw) throws SQLException {
        String sql = buildSelect("WHERE res.reservation_number LIKE ? OR g.full_name LIKE ? OR g.phone LIKE ? ORDER BY res.created_at DESC");
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            String w = "%" + kw + "%";
            ps.setString(1,w); ps.setString(2,w); ps.setString(3,w);
            return mapList(ps.executeQuery());
        }
    }

    public void updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE reservations SET status=? WHERE id=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,status); ps.setInt(2,id);
            ps.executeUpdate();
        }
    }

    public int countAll() throws SQLException        { return countWhere(""); }
    public int countByStatus(String s) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,s); ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    public double getTotalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount),0) FROM reservations WHERE status!='CANCELLED'";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0;
        }
    }
    public boolean existsByNumber(String num) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE reservation_number=?";
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,num); ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        }
    }

    // ── Helpers ───────────────────────────────────────────────────
    private String buildSelect(String clause) {
        return """
            SELECT res.*,
                   g.full_name,g.email,g.phone,g.address,g.nationality,g.id_type,g.id_number,
                   r.room_number,r.room_type,r.rate_per_night,r.capacity,
                   r.description AS rdesc, r.status AS rstatus, r.floor_number
            FROM reservations res
            JOIN guests g ON res.guest_id=g.id
            JOIN rooms  r ON res.room_id =r.id
            """ + clause;
    }

    private Reservation queryOne(String sql, int param) throws SQLException {
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, param);
            List<Reservation> list = mapList(ps.executeQuery());
            return list.isEmpty() ? null : list.get(0);
        }
    }

    private List<Reservation> queryList(String sql) throws SQLException {
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            return mapList(ps.executeQuery());
        }
    }

    private int countWhere(String w) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations" + (w.isEmpty() ? "" : " WHERE " + w);
        try (Connection c = DBConnection.getInstance().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private List<Reservation> mapList(ResultSet rs) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        while (rs.next()) list.add(mapRow(rs));
        return list;
    }

    private Reservation mapRow(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setReservationNumber(rs.getString("reservation_number"));
        r.setCheckInDate(rs.getDate("check_in_date").toLocalDate());
        r.setCheckOutDate(rs.getDate("check_out_date").toLocalDate());
        r.setNumGuests(rs.getInt("num_guests"));
        r.setTotalAmount(rs.getDouble("total_amount"));
        r.setStatus(rs.getString("status"));
        r.setSpecialRequests(rs.getString("special_requests"));

        Guest g = new Guest();
        g.setId(rs.getInt("guest_id"));
        g.setFullName(rs.getString("full_name"));
        g.setEmail(rs.getString("email"));
        g.setPhone(rs.getString("phone"));
        g.setAddress(rs.getString("address"));
        g.setNationality(rs.getString("nationality"));
        g.setIdType(rs.getString("id_type"));
        g.setIdNumber(rs.getString("id_number"));
        r.setGuest(g);

        Room room = new Room();
        room.setId(rs.getInt("room_id"));
        room.setRoomNumber(rs.getString("room_number"));
        room.setRoomType(rs.getString("room_type"));
        room.setRatePerNight(rs.getDouble("rate_per_night"));
        room.setCapacity(rs.getInt("capacity"));
        room.setDescription(rs.getString("rdesc"));
        room.setStatus(rs.getString("rstatus"));
        room.setFloorNumber(rs.getInt("floor_number"));
        r.setRoom(room);
        return r;
    }
}

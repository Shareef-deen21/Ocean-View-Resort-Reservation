package com.oceanview.service;

import com.oceanview.command.ReservationCommand;
import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.model.User;
import com.oceanview.repository.GuestRepository;
import com.oceanview.repository.ReservationRepository;
import com.oceanview.repository.RoomRepository;
import com.oceanview.repository.UserRepository;
import com.oceanview.singleton.DBConnection;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

/**
 * SERVICE — SRP, DIP
 * Coordinates all business operations.
 * Uses COMMAND PATTERN for every DB operation.
 * Maintains a QUEUE-based (LinkedList) audit log — Collection.
 */
public class ReservationService {

    private final ReservationRepository resRepo   = new ReservationRepository();
    private final GuestRepository       guestRepo = new GuestRepository();
    private final RoomRepository        roomRepo  = new RoomRepository();
    private final UserRepository        userRepo  = new UserRepository();

    // COLLECTION — Queue<String> FIFO audit trail (Command pattern audit log)
    private final Queue<String> auditLog = new LinkedList<>();

    // ── Auth ──────────────────────────────────────────────────────
    public User login(String username, String password) throws Exception {
        User u = userRepo.findByCredentials(username, password);
        if (u != null) log("LOGIN", u.getFullName() + " signed in");
        return u;
    }

    // ── Reservation CRUD ──────────────────────────────────────────
    public Reservation createReservation(
            String guestName, String guestEmail, String guestPhone,
            String guestAddress, String nationality, String idType, String idNumber,
            int roomId, String checkIn, String checkOut,
            int numGuests, String specialRequests) throws Exception {

        LocalDate ci = LocalDate.parse(checkIn);
        LocalDate co = LocalDate.parse(checkOut);
        if (!co.isAfter(ci))
            throw new IllegalArgumentException("Check-out date must be after check-in date.");
        if (ci.isBefore(LocalDate.now()))
            throw new IllegalArgumentException("Check-in date cannot be in the past.");

        Room room = roomRepo.findById(roomId);
        if (room == null) throw new IllegalArgumentException("Room not found.");

        // COMMAND PATTERN — encapsulate the create operation
        Reservation[] holder = new Reservation[1];
        ReservationCommand cmd = new ReservationCommand() {
            @Override
            public void execute() throws Exception {
                Guest guest = new Guest();
                guest.setFullName(guestName); guest.setEmail(guestEmail);
                guest.setPhone(guestPhone);   guest.setAddress(guestAddress);
                guest.setNationality(nationality); guest.setIdType(idType);
                guest.setIdNumber(idNumber);
                int gid = guestRepo.save(guest);
                guest.setId(gid);

                Reservation r = new Reservation();
                r.setReservationNumber(generateNumber());
                r.setGuest(guest); r.setRoom(room);
                r.setCheckInDate(ci); r.setCheckOutDate(co);
                r.setNumGuests(numGuests); r.setStatus("CONFIRMED");
                r.setSpecialRequests(specialRequests);
                r.setTotalAmount(r.calculateTotal());
                int id = resRepo.save(r);
                r.setId(id);
                holder[0] = r;
            }
            @Override
            public String getDescription() {
                return "CREATE | Guest: " + guestName + " | Room: " + room.getRoomNumber()
                    + " | " + checkIn + " → " + checkOut
                    + " | $" + String.format("%.2f", room.getRatePerNight() * ci.until(co, java.time.temporal.ChronoUnit.DAYS));
            }
        };
        invoke(cmd);
        return holder[0];
    }

    public List<Reservation> getAll()              throws Exception { return resRepo.findAll(); }
    public List<Reservation> search(String kw)     throws Exception { log("SEARCH","\""+kw+"\""); return resRepo.search(kw); }
    public Reservation       getById(int id)       throws Exception { return resRepo.findById(id); }
    public Reservation       getByNumber(String n) throws Exception { return resRepo.findByNumber(n); }

    public void updateStatus(int id, String status) throws Exception {
        ReservationCommand cmd = new ReservationCommand() {
            @Override public void execute() throws Exception {
                resRepo.updateStatus(id, status);
                Reservation r = resRepo.findById(id);
                if (r != null) {
                    if ("CHECKED_IN".equals(status))
                        roomRepo.updateStatus(r.getRoom().getId(), "OCCUPIED");
                    else if ("CHECKED_OUT".equals(status) || "CANCELLED".equals(status))
                        roomRepo.updateStatus(r.getRoom().getId(), "AVAILABLE");
                }
            }
            @Override public String getDescription() { return "STATUS_UPDATE | id="+id+" → "+status; }
        };
        invoke(cmd);
    }

    // ── Rooms ─────────────────────────────────────────────────────
    public List<Room> getAllRooms() throws Exception { return roomRepo.findAll(); }
    public List<Room> getAvailableRooms(String ci, String co) throws Exception {
        if (ci != null && !ci.isEmpty() && co != null && !co.isEmpty())
            return roomRepo.findAvailableForDates(ci, co);
        return roomRepo.findAvailable();
    }

    // ── Dashboard stats ───────────────────────────────────────────
    public int    getTotalReservations()  throws Exception { return resRepo.countAll(); }
    public int    getConfirmedCount()     throws Exception { return resRepo.countByStatus("CONFIRMED"); }
    public int    getCheckedInCount()     throws Exception { return resRepo.countByStatus("CHECKED_IN"); }
    public int    getAvailableRoomCount() throws Exception { return roomRepo.countByStatus("AVAILABLE"); }
    public double getTotalRevenue()       throws Exception { return resRepo.getTotalRevenue(); }
    public boolean isDbConnected()                        { return DBConnection.getInstance().isConnected(); }

    // COLLECTION — returns Queue as List for JSP display
    public List<String> getAuditLog() { return new ArrayList<>(auditLog); }

    // ── Helpers ───────────────────────────────────────────────────
    private void invoke(ReservationCommand cmd) throws Exception {
        cmd.execute();
        log("CMD", cmd.getDescription());
    }

    private void log(String type, String msg) {
        String entry = "[" + LocalTime.now().format(DateTimeFormatter.ofPattern("HH:mm:ss"))
            + "] " + type + " — " + msg;
        auditLog.offer(entry);                     // QUEUE offer()
        if (auditLog.size() > 100) auditLog.poll(); // QUEUE poll() — evict oldest
    }

    private String generateNumber() {
        return "OVR-" + String.format("%05d", (int)(Math.random() * 99999) + 1);
    }
}

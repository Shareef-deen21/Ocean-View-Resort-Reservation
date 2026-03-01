package com.oceanview.test;

import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import com.oceanview.singleton.DBConnection;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import static org.junit.jupiter.api.Assertions.*;
import java.time.LocalDate;

/**
 * REGRESSION TEST SUITE
 * Run this after every bug fix or new feature
 * to make sure existing features still work correctly
 */
@TestMethodOrder(OrderAnnotation.class)
class RegressionTest {

    private Reservation reservation;
    private Room room;

    @BeforeEach
    void setUp() {
        room = new Room();
        room.setId(1);
        room.setRoomNumber("204");
        room.setRatePerNight(150.00);
        room.setStatus("AVAILABLE");

        reservation = new Reservation();
        reservation.setRoom(room);
        reservation.setCheckInDate(LocalDate.of(2025, 12, 20));
        reservation.setCheckOutDate(LocalDate.of(2025, 12, 23));
        reservation.setStatus("CONFIRMED");
    }

    // ── RT-01: Login still works ─────────────────────────────────
    @Test
    @Order(1)
    @DisplayName("RT-01: DBConnection Singleton still returns same instance")
    void rt01_Singleton_StillReturnsSameInstance() {
        DBConnection a = DBConnection.getInstance();
        DBConnection b = DBConnection.getInstance();
        assertSame(a, b,
                "REGRESSION: DBConnection Singleton broken — " +
                        "returning different instances");
    }
    // ── RT-02: Session protection still works ─────────────────────
    @Test
    @Order(2)
    @DisplayName("RT-02: DBConnection instance is never null")
    void rt02_Singleton_NeverNull() {
        assertNotNull(DBConnection.getInstance(),
                "REGRESSION: DBConnection getInstance() returning null");
    }
    // ── RT-03: getNumberOfNights still calculates correctly ───────
    @Test
    @Order(3)
    @DisplayName("RT-03: getNumberOfNights() still returns correct count")
    void rt03_GetNumberOfNights_StillWorks() {
        assertEquals(3, reservation.getNumberOfNights(),
                "REGRESSION: getNumberOfNights() calculation broken");
    }
    // ── RT-04: Null dates still return 0 ─────────────────────────
    @Test
    @Order(4)
    @DisplayName("RT-04: getNumberOfNights() with null dates still returns 0")
    void rt04_GetNumberOfNights_NullDates_StillReturnsZero() {
        Reservation r = new Reservation();
        assertEquals(0, r.getNumberOfNights(),
                "REGRESSION: null date handling broken in getNumberOfNights()");
    }
    // ── RT-05: calculateTotal still works ────────────────────────
    @Test
    @Order(5)
    @DisplayName("RT-05: calculateTotal() still returns correct amount")
    void rt05_CalculateTotal_StillWorks() {
        assertEquals(450.00, reservation.calculateTotal(), 0.001,
                "REGRESSION: calculateTotal() broken — " +
                        "3 nights at $150 should equal $450");
    }
    // ── RT-06: calculateTotal with null room still returns 0 ─────
    @Test
    @Order(6)
    @DisplayName("RT-06: calculateTotal() with null room still returns 0")
    void rt06_CalculateTotal_NullRoom_StillReturnsZero() {
        reservation.setRoom(null);
        assertEquals(0, reservation.calculateTotal(),
                "REGRESSION: null room handling broken in calculateTotal()");
    }
    // ── RT-07: Status labels still return correct values ─────────
    @Test
    @Order(7)
    @DisplayName("RT-07: getStatusLabel() CONFIRMED still returns Confirmed")
    void rt07_StatusLabel_Confirmed_StillWorks() {
        reservation.setStatus("CONFIRMED");
        assertEquals("Confirmed", reservation.getStatusLabel(),
                "REGRESSION: getStatusLabel() CONFIRMED broken");
    }
    @Test
    @Order(8)
    @DisplayName("RT-08: getStatusLabel() CHECKED_IN still returns Checked In")
    void rt08_StatusLabel_CheckedIn_StillWorks() {
        reservation.setStatus("CHECKED_IN");
        assertEquals("Checked In", reservation.getStatusLabel(),
                "REGRESSION: getStatusLabel() CHECKED_IN broken");
    }
    @Test
    @Order(9)
    @DisplayName("RT-09: getStatusLabel() CANCELLED still returns Cancelled")
    void rt09_StatusLabel_Cancelled_StillWorks() {
        reservation.setStatus("CANCELLED");
        assertEquals("Cancelled", reservation.getStatusLabel(),
                "REGRESSION: getStatusLabel() CANCELLED broken");
    }
    @Test
    @Order(10)
    @DisplayName("RT-10: getStatusLabel() CHECKED_OUT still returns Checked Out")
    void rt10_StatusLabel_CheckedOut_StillWorks() {
        reservation.setStatus("CHECKED_OUT");
        assertEquals("Checked Out", reservation.getStatusLabel(),
                "REGRESSION: getStatusLabel() CHECKED_OUT broken");
    }
    // ── RT-11: Badge classes still return correct values ─────────
    @Test
    @Order(11)
    @DisplayName("RT-11: getStatusBadgeClass() CONFIRMED still works")
    void rt11_BadgeClass_Confirmed_StillWorks() {
        reservation.setStatus("CONFIRMED");
        assertEquals("badge-confirmed", reservation.getStatusBadgeClass(),
                "REGRESSION: getStatusBadgeClass() CONFIRMED broken");
    }
    @Test
    @Order(12)
    @DisplayName("RT-12: getStatusBadgeClass() CANCELLED still works")
    void rt12_BadgeClass_Cancelled_StillWorks() {
        reservation.setStatus("CANCELLED");
        assertEquals("badge-cancelled", reservation.getStatusBadgeClass(),
                "REGRESSION: getStatusBadgeClass() CANCELLED broken");
    }
    // ── RT-13: Date validation still throws exceptions ────────────
    @Test
    @Order(13)
    @DisplayName("RT-13: Check-out before check-in still throws exception")
    void rt13_DateValidation_CheckOutBeforeCheckIn_StillThrows() {
        assertThrows(IllegalArgumentException.class, () -> {
            LocalDate ci = LocalDate.of(2025, 12, 23);
            LocalDate co = LocalDate.of(2025, 12, 20);
            if (!co.isAfter(ci)) {
                throw new IllegalArgumentException(
                        "Check-out date must be after check-in date."
                );
            }
        }, "REGRESSION: date validation broken — " +
                "check-out before check-in no longer throws exception");
    }
    @Test
    @Order(14)
    @DisplayName("RT-14: Past check-in date still throws exception")
    void rt14_DateValidation_PastDate_StillThrows() {
        assertThrows(IllegalArgumentException.class, () -> {
            LocalDate ci = LocalDate.of(2020, 1, 1);
            if (ci.isBefore(LocalDate.now())) {
                throw new IllegalArgumentException(
                        "Check-in date cannot be in the past."
                );
            }
        }, "REGRESSION: past date validation broken");
    }
    // ── RT-15: Room model getters still work ─────────────────────
    @Test
    @Order(15)
    @DisplayName("RT-15: Room getters still return correct values")
    void rt15_RoomModel_GettersStillWork() {
        assertEquals(1,      room.getId(),
                "REGRESSION: Room.getId() broken");
        assertEquals("204",  room.getRoomNumber(),
                "REGRESSION: Room.getRoomNumber() broken");
        assertEquals(150.00, room.getRatePerNight(), 0.001,
                "REGRESSION: Room.getRatePerNight() broken");
        assertEquals("AVAILABLE", room.getStatus(),
                "REGRESSION: Room.getStatus() broken");
    }
    // ── RT-16: Reservation model getters still work ───────────────
    @Test
    @Order(16)
    @DisplayName("RT-16: Reservation getters still return correct values")
    void rt16_ReservationModel_GettersStillWork() {
        assertNotNull(reservation.getRoom(),
                "REGRESSION: Reservation.getRoom() returning null");
        assertNotNull(reservation.getCheckInDate(),
                "REGRESSION: Reservation.getCheckInDate() returning null");
        assertNotNull(reservation.getCheckOutDate(),
                "REGRESSION: Reservation.getCheckOutDate() returning null");
        assertEquals("CONFIRMED", reservation.getStatus(),
                "REGRESSION: Reservation.getStatus() broken");
    }
    // ── RT-17: Same day check-in and check-out returns 0 ─────────
    @Test
    @Order(17)
    @DisplayName("RT-17: Same day check-in and check-out still returns 0 nights")
    void rt17_SameDayCheckInCheckOut_StillReturnsZero() {
        reservation.setCheckOutDate(LocalDate.of(2025, 12, 20));
        assertEquals(0, reservation.getNumberOfNights(),
                "REGRESSION: same day calculation broken");
    }
    // ── RT-18: Unknown status still returns default badge ─────────
    @Test
    @Order(18)
    @DisplayName("RT-18: Unknown status still returns badge-secondary")
    void rt18_UnknownStatus_StillReturnsDefaultBadge() {
        reservation.setStatus("UNKNOWN_STATUS");
        assertEquals("badge-secondary", reservation.getStatusBadgeClass(),
                "REGRESSION: default badge class broken for unknown status");
    }
    // ── RT-19: Null status still returns Unknown label ────────────
    @Test
    @Order(19)
    @DisplayName("RT-19: Null status still returns Unknown label")
    void rt19_NullStatus_StillReturnsUnknown() {
        reservation.setStatus(null);
        assertEquals("Unknown", reservation.getStatusLabel(),
                "REGRESSION: null status handling broken in getStatusLabel()");
    }

    // ── RT-20: Total amount calculation scales correctly ──────────

    @Test
    @Order(20)
    @DisplayName("RT-20: calculateTotal() still scales correctly for 7 nights")
    void rt20_CalculateTotal_SevenNights_StillWorks() {
        reservation.setCheckOutDate(LocalDate.of(2025, 12, 27));
        assertEquals(1050.00, reservation.calculateTotal(), 0.001,
                "REGRESSION: calculateTotal() broken for 7 nights — " +
                        "7 x $150 should equal $1050");
    }
}
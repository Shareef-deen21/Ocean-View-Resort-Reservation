package com.oceanview.test;

import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;
import java.time.LocalDate;

class ReservationTest {

    // These are shared across all test methods
    private Reservation reservation;
    private Room room;

    // Runs BEFORE every single @Test method
    // Sets up fresh objects so tests do not affect each other
    @BeforeEach
    void setUp() {
        room = new Room();
        room.setRatePerNight(150.00);

        reservation = new Reservation();
        reservation.setRoom(room);
        reservation.setCheckInDate(LocalDate.of(2025, 12, 20));
        reservation.setCheckOutDate(LocalDate.of(2025, 12, 23));
    }

    // ── getNumberOfNights() tests ─────────────────────────────────

    @Test
    @DisplayName("TC-08: 3 nights between Dec 20 and Dec 23")
    void testGetNumberOfNights_Returns3() {
        assertEquals(3, reservation.getNumberOfNights());
    }

    @Test
    @DisplayName("TC-09: Null dates should return 0")
    void testGetNumberOfNights_NullDates_ReturnsZero() {
        Reservation r = new Reservation();
        // no dates set — both are null
        assertEquals(0, r.getNumberOfNights());
    }

    @Test
    @DisplayName("TC-10: Same check-in and check-out returns 0")
    void testGetNumberOfNights_SameDay_ReturnsZero() {
        reservation.setCheckOutDate(LocalDate.of(2025, 12, 20));
        assertEquals(0, reservation.getNumberOfNights());
    }

    // ── calculateTotal() tests ────────────────────────────────────

    @Test
    @DisplayName("TC-11: 3 nights at $150 = $450")
    void testCalculateTotal_ThreeNights_Returns450() {
        assertEquals(450.00, reservation.calculateTotal(), 0.001);
    }

    @Test
    @DisplayName("TC-12: Null room returns 0")
    void testCalculateTotal_NullRoom_ReturnsZero() {
        reservation.setRoom(null);
        assertEquals(0, reservation.calculateTotal());
    }

    @Test
    @DisplayName("1 night at $150 = $150")
    void testCalculateTotal_OneNight_Returns150() {
        reservation.setCheckOutDate(LocalDate.of(2025, 12, 21));
        assertEquals(150.00, reservation.calculateTotal(), 0.001);
    }

    // ── getStatusLabel() tests ────────────────────────────────────

    @Test
    @DisplayName("TC-13: CONFIRMED returns Confirmed")
    void testGetStatusLabel_Confirmed() {
        reservation.setStatus("CONFIRMED");
        assertEquals("Confirmed", reservation.getStatusLabel());
    }

    @Test
    @DisplayName("TC-14: CHECKED_IN returns Checked In")
    void testGetStatusLabel_CheckedIn() {
        reservation.setStatus("CHECKED_IN");
        assertEquals("Checked In", reservation.getStatusLabel());
    }

    @Test
    @DisplayName("TC-15: CANCELLED returns Cancelled")
    void testGetStatusLabel_Cancelled() {
        reservation.setStatus("CANCELLED");
        assertEquals("Cancelled", reservation.getStatusLabel());
    }

    @Test
    @DisplayName("CHECKED_OUT returns Checked Out")
    void testGetStatusLabel_CheckedOut() {
        reservation.setStatus("CHECKED_OUT");
        assertEquals("Checked Out", reservation.getStatusLabel());
    }

    // ── getStatusBadgeClass() tests ───────────────────────────────

    @Test
    @DisplayName("TC-16: CONFIRMED returns badge-confirmed")
    void testGetStatusBadgeClass_Confirmed() {
        reservation.setStatus("CONFIRMED");
        assertEquals("badge-confirmed", reservation.getStatusBadgeClass());
    }

    @Test
    @DisplayName("CHECKED_IN returns badge-checkedin")
    void testGetStatusBadgeClass_CheckedIn() {
        reservation.setStatus("CHECKED_IN");
        assertEquals("badge-checkedin", reservation.getStatusBadgeClass());
    }

    @Test
    @DisplayName("CANCELLED returns badge-cancelled")
    void testGetStatusBadgeClass_Cancelled() {
        reservation.setStatus("CANCELLED");
        assertEquals("badge-cancelled", reservation.getStatusBadgeClass());
    }

    @Test
    @DisplayName("Unknown status returns badge-secondary")
    void testGetStatusBadgeClass_Unknown() {
        reservation.setStatus("UNKNOWN");
        assertEquals("badge-secondary", reservation.getStatusBadgeClass());
    }
}
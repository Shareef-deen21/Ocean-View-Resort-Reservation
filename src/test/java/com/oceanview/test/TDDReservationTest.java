package com.oceanview.test;

import com.oceanview.model.Reservation;
import com.oceanview.model.Room;
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;
import java.time.LocalDate;

class TDDReservationTest {

    @Test
    @DisplayName("TDD RED: getNumberOfNights returns 3")
    void tdd_getNumberOfNights_Returns3() {
        Reservation r = new Reservation();
        r.setCheckInDate(LocalDate.of(2025, 12, 20));
        r.setCheckOutDate(LocalDate.of(2025, 12, 23));

        // This test FAILS first because method does not exist yet
        assertEquals(3, r.getNumberOfNights());
    }

    @Test
    @DisplayName("TDD REFACTOR: null dates return 0")
    void tdd_getNumberOfNights_NullDates_ReturnsZero() {
        Reservation r = new Reservation();
        // no dates set
        assertEquals(0, r.getNumberOfNights());
    }

    @Test
    @DisplayName("TDD REFACTOR: same day returns 0")
    void tdd_getNumberOfNights_SameDay_ReturnsZero() {
        Reservation r = new Reservation();
        r.setCheckInDate(LocalDate.of(2025, 12, 20));
        r.setCheckOutDate(LocalDate.of(2025, 12, 20));
        assertEquals(0, r.getNumberOfNights());
    }

    @Test
    @DisplayName("TDD REFACTOR: 7 nights returns 7")
    void tdd_getNumberOfNights_SevenNights_Returns7() {
        Reservation r = new Reservation();
        r.setCheckInDate(LocalDate.of(2025, 12, 20));
        r.setCheckOutDate(LocalDate.of(2025, 12, 27));
        assertEquals(7, r.getNumberOfNights());
    }



    @Test
    @DisplayName("TDD RED: calculateTotal 3 nights at $150 = $450")
    void tdd_calculateTotal_ThreeNights_Returns450() {
        Room room = new Room();
        room.setRatePerNight(150.00);

        Reservation r = new Reservation();
        r.setRoom(room);
        r.setCheckInDate(LocalDate.of(2025, 12, 20));
        r.setCheckOutDate(LocalDate.of(2025, 12, 23));

        // FAILS first — calculateTotal() not implemented yet
        assertEquals(450.00, r.calculateTotal(), 0.001);
    }


    @Test
    @DisplayName("TDD REFACTOR: null room returns 0")
    void tdd_calculateTotal_NullRoom_ReturnsZero() {
        Reservation r = new Reservation();
        r.setRoom(null);
        assertEquals(0, r.calculateTotal());
    }

    @Test
    @DisplayName("TDD REFACTOR: 1 night at $150 = $150")
    void tdd_calculateTotal_OneNight_Returns150() {
        Room room = new Room();
        room.setRatePerNight(150.00);

        Reservation r = new Reservation();
        r.setRoom(room);
        r.setCheckInDate(LocalDate.of(2025, 12, 20));
        r.setCheckOutDate(LocalDate.of(2025, 12, 21));

        assertEquals(150.00, r.calculateTotal(), 0.001);
    }


}
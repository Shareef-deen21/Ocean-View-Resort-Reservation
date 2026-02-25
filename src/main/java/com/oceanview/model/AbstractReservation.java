package com.oceanview.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * ABSTRACTION + ENCAPSULATION — abstract base for all reservation types
 */
public abstract class AbstractReservation {
    private int       id;
    private String    reservationNumber;
    private Guest     guest;
    private Room      room;
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private int       numGuests;
    private double    totalAmount;
    private String    status;
    private String    specialRequests;

    // Abstract methods — subclass must implement (POLYMORPHISM)
    public abstract double calculateTotal();
    public abstract String getStatusLabel();
    public abstract String getStatusBadgeClass();

    // Shared concrete logic
    public long getNumberOfNights() {
        if (checkInDate == null || checkOutDate == null) return 0;
        return ChronoUnit.DAYS.between(checkInDate, checkOutDate);
    }

    // Getters & Setters (ENCAPSULATION)
    public int       getId()                       { return id; }
    public void      setId(int v)                  { id = v; }
    public String    getReservationNumber()        { return reservationNumber; }
    public void      setReservationNumber(String v){ reservationNumber = v; }
    public Guest     getGuest()                    { return guest; }
    public void      setGuest(Guest v)             { guest = v; }
    public Room      getRoom()                     { return room; }
    public void      setRoom(Room v)               { room = v; }
    public LocalDate getCheckInDate()              { return checkInDate; }
    public void      setCheckInDate(LocalDate v)   { checkInDate = v; }
    public LocalDate getCheckOutDate()             { return checkOutDate; }
    public void      setCheckOutDate(LocalDate v)  { checkOutDate = v; }
    public int       getNumGuests()                { return numGuests; }
    public void      setNumGuests(int v)           { numGuests = v; }
    public double    getTotalAmount()              { return totalAmount; }
    public void      setTotalAmount(double v)      { totalAmount = v; }
    public String    getStatus()                   { return status; }
    public void      setStatus(String v)           { status = v; }
    public String    getSpecialRequests()          { return specialRequests; }
    public void      setSpecialRequests(String v)  { specialRequests = v; }
}

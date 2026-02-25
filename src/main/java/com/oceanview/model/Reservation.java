package com.oceanview.model;

/**
 * INHERITANCE — extends AbstractReservation
 * POLYMORPHISM — overrides calculateTotal, getStatusLabel, getStatusBadgeClass
 */
public class Reservation extends AbstractReservation {

    @Override
    public double calculateTotal() {
        if (getRoom() == null) return 0;
        return getRoom().getRatePerNight() * getNumberOfNights();
    }

    @Override
    public String getStatusLabel() {
        if (getStatus() == null) return "Unknown";
        return switch (getStatus()) {
            case "CONFIRMED"   -> "Confirmed";
            case "CHECKED_IN"  -> "Checked In";
            case "CHECKED_OUT" -> "Checked Out";
            case "CANCELLED"   -> "Cancelled";
            default            -> getStatus();
        };
    }

    @Override
    public String getStatusBadgeClass() {
        if (getStatus() == null) return "badge-secondary";
        return switch (getStatus()) {
            case "CONFIRMED"   -> "badge-confirmed";
            case "CHECKED_IN"  -> "badge-checkedin";
            case "CHECKED_OUT" -> "badge-checkedout";
            case "CANCELLED"   -> "badge-cancelled";
            default            -> "badge-secondary";
        };
    }
}

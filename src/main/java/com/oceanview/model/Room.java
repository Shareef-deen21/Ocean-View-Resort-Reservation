package com.oceanview.model;

public class Room {
    private int    id, capacity, floorNumber;
    private String roomNumber, roomType, description, status;
    private double ratePerNight;

    public int    getId()                  { return id; }
    public void   setId(int v)             { id = v; }
    public String getRoomNumber()          { return roomNumber; }
    public void   setRoomNumber(String v)  { roomNumber = v; }
    public String getRoomType()            { return roomType; }
    public void   setRoomType(String v)    { roomType = v; }
    public double getRatePerNight()        { return ratePerNight; }
    public void   setRatePerNight(double v){ ratePerNight = v; }
    public int    getCapacity()            { return capacity; }
    public void   setCapacity(int v)       { capacity = v; }
    public String getDescription()         { return description; }
    public void   setDescription(String v) { description = v; }
    public String getStatus()              { return status; }
    public void   setStatus(String v)      { status = v; }
    public int    getFloorNumber()         { return floorNumber; }
    public void   setFloorNumber(int v)    { floorNumber = v; }
    public boolean isAvailable()           { return "AVAILABLE".equals(status); }

    public String getTypeIcon() {
        if (roomType == null) return "🏨";
        return switch (roomType) {
            case "STANDARD"   -> "🛏️";
            case "DELUXE"     -> "✨";
            case "OCEAN VIEW" -> "🌊";
            case "FAMILY"     -> "👨‍👩‍👧‍👦";
            case "SUITE"      -> "👑";
            default           -> "🏨";
        };
    }
}

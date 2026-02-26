package com.oceanview.model;

public class Guest {
    private int    id;
    private String fullName, email, phone, address, nationality, idType, idNumber;

    public int    getId()              { return id; }
    public void   setId(int v)         { id = v; }
    public String getFullName()        { return fullName; }
    public void   setFullName(String v){ fullName = v; }
    public String getEmail()           { return email; }
    public void   setEmail(String v)   { email = v; }
    public String getPhone()           { return phone; }
    public void   setPhone(String v)   { phone = v; }
    public String getAddress()         { return address; }
    public void   setAddress(String v) { address = v; }
    public String getNationality()     { return nationality; }
    public void   setNationality(String v) { nationality = v; }
    public String getIdType()          { return idType; }
    public void   setIdType(String v)  { idType = v; }
    public String getIdNumber()        { return idNumber; }
    public void   setIdNumber(String v){ idNumber = v; }
}

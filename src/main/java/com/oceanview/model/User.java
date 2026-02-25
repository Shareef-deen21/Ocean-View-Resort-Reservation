package com.oceanview.model;

public class User {
    private int    id;
    private String username, password, fullName, role;

    public int    getId()          { return id; }
    public void   setId(int v)     { id = v; }
    public String getUsername()    { return username; }
    public void   setUsername(String v)  { username = v; }
    public String getPassword()    { return password; }
    public void   setPassword(String v)  { password = v; }
    public String getFullName()    { return fullName; }
    public void   setFullName(String v)  { fullName = v; }
    public String getRole()        { return role; }
    public void   setRole(String v){ role = v; }
    public boolean isAdmin()       { return "ADMIN".equals(role); }

    public String getInitials() {
        if (fullName == null || fullName.isEmpty()) return "?";
        String[] p = fullName.split(" ");
        return p.length > 1
            ? ("" + p[0].charAt(0) + p[p.length-1].charAt(0)).toUpperCase()
            : ("" + p[0].charAt(0)).toUpperCase();
    }
}

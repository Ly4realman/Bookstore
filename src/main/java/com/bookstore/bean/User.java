package com.bookstore.bean;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String password;
    private String phone;
    private String realname;
    private String address;
    private String email;
    private Timestamp createdAt;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRealname() { return realname; }

    public void setRealname(String realname) { this.realname = realname; }

    public String getAddress() { return address; }

    public void setAddress(String address) { this.address = address; }

    public String getEmail() { return email; }

    public void setEmail(String email) { this.email = email; }

    public Timestamp getCreatedAt() { return createdAt; }

    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

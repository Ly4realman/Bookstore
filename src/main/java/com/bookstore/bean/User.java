package com.bookstore.bean;

public class User {
    private int id;
    private String username;
    private String password;
    private String phone;
    private String real_name;
    private String address;

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

    public String getReal_name() { return real_name; }

    public void setReal_name(String real_name) { this.real_name = real_name; }

    public String getAddress() { return address; }

    public void setAddress(String address) { this.address = address; }
}

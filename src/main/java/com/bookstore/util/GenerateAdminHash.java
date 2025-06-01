package com.bookstore.util;

import org.mindrot.jbcrypt.BCrypt;

public class GenerateAdminHash {
    public static void main(String[] args) {
        String plainPassword = "admin123A";
        String hash = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        System.out.println(hash);
    }
}

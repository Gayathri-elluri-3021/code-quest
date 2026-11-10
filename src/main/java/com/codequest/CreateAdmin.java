
package com.codequest;

import java.io.Console;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.security.SecureRandom;
import java.util.Base64;
import java.util.Arrays;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class CreateAdmin {

    public static void main(String[] args) {

        Console console = System.console();

        if (console == null) {
            System.out.println(
                "Run this program from a terminal.");
            return;
        }

        String email = console.readLine("Admin Email: ");
        char[] password =
            console.readPassword("Admin Password: ");

        if (email == null || email.isBlank()
                || password == null
                || password.length < 12) {
            System.out.println(
                "Enter a valid email and password " +
                "of at least 12 characters.");
            return;
        }

        PBEKeySpec spec = null;

        try {
            byte[] salt = new byte[16];
            new SecureRandom().nextBytes(salt);

            int iterations = 600000;

            spec = new PBEKeySpec(
                password, salt, iterations, 256);

            byte[] hash =
                SecretKeyFactory.getInstance(
                    "PBKDF2WithHmacSHA256")
                .generateSecret(spec)
                .getEncoded();

            String storedHash =
                "pbkdf2_sha256$" + iterations + "$" +
                Base64.getEncoder().encodeToString(salt) + "$" +
                Base64.getEncoder().encodeToString(hash);

            try (Connection con = DbConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO admins(email, password_hash) " +
                     "VALUES (?, ?)")) {

                ps.setString(1, email.trim());
                ps.setString(2, storedHash);
                ps.executeUpdate();
            }

            System.out.println(
                "Admin account created successfully!");

        } catch (Exception e) {
            System.out.println(
                "Admin creation failed. Check database " +
                "connection and whether email already exists.");
        } finally {
            Arrays.fill(password, '\0');
            if (spec != null) {
                spec.clearPassword();
            }
        }
    }
}
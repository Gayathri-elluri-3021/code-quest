
package com.codequest;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

//@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    

private static String hashPassword(String password)
        throws Exception {

    byte[] salt = new byte[16];
    new SecureRandom().nextBytes(salt);

    PBEKeySpec spec = new PBEKeySpec(
            password.toCharArray(), salt, 600000, 256);

    byte[] hash;
    try {
        hash = SecretKeyFactory
                .getInstance("PBKDF2WithHmacSHA256")
                .generateSecret(spec)
                .getEncoded();
    } finally {
        spec.clearPassword();
    }

    return "pbkdf2_sha256$600000$"
            + Base64.getEncoder().encodeToString(salt)
            + "$"
            + Base64.getEncoder().encodeToString(hash);
} 

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        try (PrintWriter out = response.getWriter()) {

            if (password == null ||
                    !password.equals(confirm)) {
                out.println("Passwords do not match!");
                return;
            }


try {
    String hashedPassword = hashPassword(password);

    String sql = "INSERT INTO users "
            + "(username, email, password_hash) "
            + "VALUES (?, ?, ?)";

    try (Connection con = DbConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, username);
        ps.setString(2, email);
        ps.setString(3, hashedPassword);

        int rows = ps.executeUpdate();

        if (rows > 0) {
            out.println("Registration Successful!");
        }
    }

} catch (java.sql.SQLIntegrityConstraintViolationException e) {
    out.println("Username or Email already exists!");

} catch (Exception e) {
    out.println("Registration failed. Please try again.");
    getServletContext().log("Registration error", e);
}
        }
    }
}
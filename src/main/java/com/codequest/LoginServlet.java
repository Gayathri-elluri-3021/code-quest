
package com.codequest;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private boolean verifyPassword(String password, String storedHash)
            throws Exception {

        String[] parts = storedHash.split("\\$");

        if (parts.length != 4 || !parts[0].equals("pbkdf2_sha256")) {
            return false;
        }

        int iterations = Integer.parseInt(parts[1]);
        byte[] salt = Base64.getDecoder().decode(parts[2]);
        byte[] expected = Base64.getDecoder().decode(parts[3]);

        PBEKeySpec spec = new PBEKeySpec(
                password.toCharArray(), salt,
                iterations, expected.length * 8);

        try {
            byte[] actual = SecretKeyFactory
                    .getInstance("PBKDF2WithHmacSHA256")
                    .generateSecret(spec)
                    .getEncoded();

            return java.security.MessageDigest.isEqual(
                    actual, expected);
        } finally {
            spec.clearPassword();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (PrintWriter out = response.getWriter()) {

            if (email == null || password == null) {
                out.println("Email and password are required.");
                return;
            }

            String sql = "SELECT id, username, password_hash "
                       + "FROM users WHERE email = ?";

            try (Connection con = DbConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, email);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next() &&
                        verifyPassword(password,
                                rs.getString("password_hash"))) {

                        request.getSession(true).setAttribute(
                                "userId", rs.getInt("id"));

                        response.sendRedirect(
                                request.getContextPath() + "/dashboard.jsp");

                    } else {
                        out.println("Invalid email or password.");
                    }
                }

            } catch (Exception e) {
                getServletContext().log("Login error", e);
                out.println("Login failed. Please try again.");
            }
        }
    }
}
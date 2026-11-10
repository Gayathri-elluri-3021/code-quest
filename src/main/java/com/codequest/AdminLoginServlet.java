
package com.codequest;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;
import java.util.Base64;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.WebInitParam;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(
	    urlPatterns = "/admin-login",
	    initParams = {
	        @WebInitParam(name = "adminRole", value = "ADMIN")
	    }
	)
public class AdminLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    @Override
    public void init() throws ServletException {
        super.init();

        String adminRole = getServletConfig()
                .getInitParameter("adminRole");

        getServletContext().log(
            "Admin Servlet initialized. Role: " + adminRole
        );
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT id, password_hash FROM admins WHERE email = ?")) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next() &&
                    verifyPassword(password,
                        rs.getString("password_hash"))) {

                    HttpSession oldSession =
                        request.getSession(false);

                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    HttpSession session =
                        request.getSession(true);

                    session.setAttribute(
                        "adminId", rs.getInt("id"));

                    response.sendRedirect(
                        request.getContextPath() +
                        "/admin-dashboard.jsp");
                    return;
                }
            }

            response.setContentType(
                "text/html;charset=UTF-8");

            response.getWriter().println(
                "<h3>Invalid admin email or password</h3>" +
                "<a href='admin-login.jsp'>Try Again</a>"
            );

        } catch (Exception e) {
            log("Admin login failed", e);
            response.sendError(500, "Admin login unavailable");
        }
    }

    private boolean verifyPassword(String password,
                                   String storedHash)
            throws Exception {

        if (password == null || storedHash == null) {
            return false;
        }

        String[] parts = storedHash.split("\\$");

        if (parts.length != 4 ||
            !"pbkdf2_sha256".equals(parts[0])) {
            return false;
        }

        int iterations = Integer.parseInt(parts[1]);

        byte[] salt = Base64.getDecoder().decode(parts[2]);
        byte[] expected = Base64.getDecoder().decode(parts[3]);

        PBEKeySpec spec = new PBEKeySpec(
            password.toCharArray(),
            salt,
            iterations,
            expected.length * 8
        );

        try {
            byte[] actual =
                SecretKeyFactory.getInstance(
                    "PBKDF2WithHmacSHA256")
                .generateSecret(spec)
                .getEncoded();

            return MessageDigest.isEqual(actual, expected);
        } finally {
            spec.clearPassword();
        }
    }
}
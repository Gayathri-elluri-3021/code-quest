
package com.codequest;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student-dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("userId") instanceof Number)) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int userId =
            ((Number) session.getAttribute("userId")).intValue();

        String sql =
            "SELECT u.username, u.xp, u.level, " +
            "(SELECT COUNT(*) FROM mission_submissions ms " +
            " WHERE ms.user_id = u.id AND ms.is_correct = TRUE) " +
            "AS completed_missions " +
            "FROM users u WHERE u.id = ?";

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    session.invalidate();
                    response.sendRedirect(
                        request.getContextPath() + "/login.jsp"
                    );
                    return;
                }

                int xp = rs.getInt("xp");
                int level = rs.getInt("level");
                int completed = rs.getInt("completed_missions");

                // Example: 100 XP needed per level
                int progress = xp % 100;
                int xpToNextLevel = 100 - progress;

                request.setAttribute(
                    "username", rs.getString("username"));
                request.setAttribute("xp", xp);
                request.setAttribute("level", level);
                request.setAttribute("completedMissions", completed);
                request.setAttribute("progress", progress);
                request.setAttribute("xpToNextLevel", xpToNextLevel);
            }

        } catch (SQLException e) {
            getServletContext().log(
                "Student dashboard database error", e);

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load dashboard"
            );
            return;
        }

        request.getRequestDispatcher("/dashboard.jsp")
               .forward(request, response);
    }
}
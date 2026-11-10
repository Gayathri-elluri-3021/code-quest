
package com.codequest;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/student-missions")
public class MissionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Student login check
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

        List<Map<String, Object>> missions =
            new ArrayList<>();

        // Admin-created questions from MySQL
        String sql =
            "SELECT m.id, m.title, m.description, " +
            "m.category, m.difficulty, " +
            "m.option_a, m.option_b, " +
            "m.option_c, m.option_d, m.xp_reward, " +
            "ms.is_correct AS attempted_correct " +
            "FROM missions m " +
            "LEFT JOIN mission_submissions ms " +
            "ON ms.mission_id = m.id AND ms.user_id = ? " +
            "ORDER BY m.id DESC";

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps =
                 con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Map<String, Object> mission =
                        new HashMap<>();

                    mission.put("id", rs.getInt("id"));
                    mission.put("title",
                        rs.getString("title"));
                    mission.put("description",
                        rs.getString("description"));
                    mission.put("category",
                        rs.getString("category"));
                    mission.put("difficulty",
                        rs.getString("difficulty"));

                    mission.put("option_a",
                        rs.getString("option_a"));
                    mission.put("option_b",
                        rs.getString("option_b"));
                    mission.put("option_c",
                        rs.getString("option_c"));
                    mission.put("option_d",
                        rs.getString("option_d"));

                    mission.put("xp_reward",
                        rs.getInt("xp_reward"));

                    Object attemptedCorrect =
                        rs.getObject("attempted_correct");

                    mission.put("attempted",
                        attemptedCorrect != null);

                    mission.put("isCorrect",
                        Boolean.TRUE.equals(attemptedCorrect));

                    missions.add(mission);
                }
            }

        } catch (SQLException e) {

            getServletContext().log(
                "Unable to load student missions", e);

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load missions"
            );
            return;
        }

        // Send questions to missions.jsp
        request.setAttribute("missions", missions);

        request.getRequestDispatcher("/missions.jsp")
               .forward(request, response);
    }
}
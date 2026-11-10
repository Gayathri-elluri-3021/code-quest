
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

@WebServlet("/submit-answer")
public class SubmitAnswerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("userId") instanceof Number)) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        int userId =
            ((Number) session.getAttribute("userId")).intValue();

        String answer = request.getParameter("answer");
        String missionIdText =
            request.getParameter("missionId");

        int missionId;

        try {
            missionId = Integer.parseInt(missionIdText);
        } catch (NumberFormatException e) {
            response.sendError(400, "Invalid mission ID");
            return;
        }

        if (missionId <= 0 || answer == null ||
            !answer.matches("[ABCD]")) {

            response.sendError(400, "Invalid answer");
            return;
        }

        Connection con = null;

        try {
            con = DbConnection.getConnection();
            con.setAutoCommit(false);

            // Lock this student's record during submission
            try (PreparedStatement lock =
                     con.prepareStatement(
                         "SELECT id FROM users " +
                         "WHERE id = ? FOR UPDATE")) {

                lock.setInt(1, userId);

                try (ResultSet rs = lock.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        response.sendError(403, "Student not found");
                        return;
                    }
                }
            }

            // Prevent multiple attempts
            try (PreparedStatement check =
                     con.prepareStatement(
                         "SELECT id FROM mission_submissions " +
                         "WHERE user_id = ? AND mission_id = ?")) {

                check.setInt(1, userId);
                check.setInt(2, missionId);

                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        con.rollback();
                        response.sendError(
                            409, "Mission already attempted");
                        return;
                    }
                }
            }

            String correctAnswer;
            int xpReward;

            try (PreparedStatement ps =
                     con.prepareStatement(
                         "SELECT correct_answer, xp_reward " +
                         "FROM missions WHERE id = ?")) {

                ps.setInt(1, missionId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        response.sendError(404, "Mission not found");
                        return;
                    }

                    correctAnswer =
                        rs.getString("correct_answer");
                    xpReward = rs.getInt("xp_reward");
                }
            }

            boolean isCorrect =
                answer.equalsIgnoreCase(correctAnswer);

            int earnedXP = isCorrect ? xpReward : 0;

            // Save the answer
            try (PreparedStatement ps =
                     con.prepareStatement(
                         "INSERT INTO mission_submissions " +
                         "(user_id, mission_id, selected_answer, " +
                         "is_correct, xp_earned) " +
                         "VALUES (?, ?, ?, ?, ?)")) {

                ps.setInt(1, userId);
                ps.setInt(2, missionId);
                ps.setString(3, answer);
                ps.setBoolean(4, isCorrect);
                ps.setInt(5, earnedXP);
                ps.executeUpdate();
            }

            // Award XP and update level
            if (isCorrect) {
                try (PreparedStatement ps =
                         con.prepareStatement(
                             "UPDATE users SET xp = xp + ?, " +
                             "level = FLOOR((xp + ?) / 100) + 1 " +
                             "WHERE id = ?")) {

                    ps.setInt(1, earnedXP);
                    ps.setInt(2, earnedXP);
                    ps.setInt(3, userId);
                    ps.executeUpdate();
                }
            }

            con.commit();

            request.setAttribute("isCorrect", isCorrect);
            request.setAttribute("earnedXP", earnedXP);

            request.getRequestDispatcher("/mission-result.jsp")
                   .forward(request, response);

        } catch (SQLException e) {

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ignored) {
                    getServletContext().log(
                        "Rollback failed", ignored);
                }
            }

            getServletContext().log(
                "Answer submission failed", e);

            response.sendError(
                500, "Unable to submit answer");

        } finally {
            if (con != null) {
                try {
                    con.close();
                } catch (SQLException e) {
                    getServletContext().log(
                        "Connection close failed", e);
                }
            }
        }
    }
}

package com.codequest;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/python-quiz")
public class PythonQuizServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String q1 = request.getParameter("q1");
        String q2 = request.getParameter("q2");
        String q3 = request.getParameter("q3");

        if (q1 == null || q2 == null || q3 == null) {
            response.sendError(400, "Answer all questions");
            return;
        }

        int score = 0;

        if ("b".equals(q1)) score++;
        if ("a".equals(q2)) score++;
        if ("c".equals(q3)) score++;

        int earnedXP = score * 10;

        try (Connection con = DbConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                String insert =
                    "INSERT IGNORE INTO mission_completions " +
                    "(user_id, mission_name) VALUES (?, ?)";

                int inserted;

                try (PreparedStatement ps =
                         con.prepareStatement(insert)) {

                    ps.setInt(1, userId);
                    ps.setString(2, "PYTHON_QUIZ_1");
                    inserted = ps.executeUpdate();
                }

                if (inserted == 1) {
                    String update =
                        "UPDATE users SET xp = xp + ?, " +
                        "level = FLOOR((xp + ?) / 100) + 1 " +
                        "WHERE id = ?";

                    try (PreparedStatement ps =
                             con.prepareStatement(update)) {

                        ps.setInt(1, earnedXP);
                        ps.setInt(2, earnedXP);
                        ps.setInt(3, userId);
                        ps.executeUpdate();
                    }
                }

                con.commit();

                response.setContentType(
                    "text/html;charset=UTF-8");

                response.getWriter().println(
                    "<h2>Your Score: " + score + "/3</h2>" +
                    "<h3>XP Earned: " +
                    (inserted == 1 ? earnedXP : 0) +
                    "</h3>" +
                    "<p>" +
                    (inserted == 1
                        ? "Mission Completed!"
                        : "Mission already completed!") +
                    "</p>" +
                    "<a href='dashboard.jsp'>Dashboard</a>"
                );

            } catch (Exception e) {
                con.rollback();
                throw e;
            }

        } catch (Exception e) {
            log("Python quiz submission failed", e);
            response.sendError(
                500, "Unable to save quiz result");
        }
    }
}
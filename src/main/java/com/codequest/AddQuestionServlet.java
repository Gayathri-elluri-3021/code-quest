
package com.codequest;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-question")
public class AddQuestionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin login
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("adminId") == null) {

            response.sendRedirect(
                request.getContextPath() + "/admin-login.jsp"
            );
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String difficulty = request.getParameter("difficulty");

        String optionA = request.getParameter("option_a");
        String optionB = request.getParameter("option_b");
        String optionC = request.getParameter("option_c");
        String optionD = request.getParameter("option_d");

        String correctAnswer =
                request.getParameter("correct_answer");

        String xpText = request.getParameter("xp_reward");

        // Validate all fields
        if (isBlank(title) || isBlank(description) ||
            isBlank(optionA) || isBlank(optionB) ||
            isBlank(optionC) || isBlank(optionD) ||
            !isAllowed(category, "Java", "SQL", "DSA") ||
            !isAllowed(difficulty, "Easy", "Medium", "Hard") ||
            !isAllowed(correctAnswer, "A", "B", "C", "D")) {

            showMessage(response, "Invalid question details.");
            return;
        }

        int xpReward;

        try {
            xpReward = Integer.parseInt(xpText);

            if (xpReward < 1 || xpReward > 1000 ||
                title.length() > 200 ||
                optionA.length() > 255 ||
                optionB.length() > 255 ||
                optionC.length() > 255 ||
                optionD.length() > 255) {

                showMessage(response, "Invalid input length or XP.");
                return;
            }

        } catch (NumberFormatException e) {
            showMessage(response, "Please enter valid XP.");
            return;
        }

        String sql =
            "INSERT INTO missions " +
            "(title, description, category, difficulty, " +
            "option_a, option_b, option_c, option_d, " +
            "correct_answer, xp_reward) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, title.trim());
            ps.setString(2, description.trim());
            ps.setString(3, category);
            ps.setString(4, difficulty);
            ps.setString(5, optionA.trim());
            ps.setString(6, optionB.trim());
            ps.setString(7, optionC.trim());
            ps.setString(8, optionD.trim());
            ps.setString(9, correctAnswer);
            ps.setInt(10, xpReward);

            ps.executeUpdate();

            showMessage(response, "Question added successfully!");

        } catch (SQLException e) {
            getServletContext().log("Add question failed", e);
            showMessage(response,
                "Unable to save question. Please try again.");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean isAllowed(String value, String... allowed) {
        if (value == null) return false;

        for (String item : allowed) {
            if (item.equals(value)) return true;
        }

        return false;
    }

    private void showMessage(HttpServletResponse response,
                             String message)
            throws IOException {

        response.setContentType("text/html;charset=UTF-8");

        java.io.PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html><html><head>");
        out.println("<title>CodeQuest - Add Question</title>");
        out.println("</head><body style='background:#101827;"
                + "color:white;text-align:center;"
                + "font-family:Arial;padding:50px'>");

        out.println("<h2>" + message + "</h2>");
        out.println("<a style='color:#38bdf8' "
                + "href='add-question.jsp'>Back to Add Question</a>");

        out.println("</body></html>");
    }
}
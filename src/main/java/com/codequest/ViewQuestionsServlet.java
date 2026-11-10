
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

@WebServlet("/view-questions")
public class ViewQuestionsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
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

        List<Map<String, Object>> questions =
                new ArrayList<>();

        String sql =
            "SELECT id, title, category, difficulty, xp_reward " +
            "FROM missions ORDER BY id DESC";

        try (Connection con = DbConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Map<String, Object> question = new HashMap<>();

                question.put("id", rs.getInt("id"));
                question.put("title", rs.getString("title"));
                question.put("category", rs.getString("category"));
                question.put("difficulty",
                             rs.getString("difficulty"));
                question.put("xp_reward",
                             rs.getInt("xp_reward"));

                questions.add(question);
            }

        } catch (SQLException e) {
            getServletContext().log(
                "Unable to load questions", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load questions"
            );
            return;
        }

        // Send database data to JSP
        request.setAttribute("questions", questions);

        request.getRequestDispatcher("/view-questions.jsp")
               .forward(request, response);
    }
}
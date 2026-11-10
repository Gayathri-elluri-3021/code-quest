<%@ page import="java.sql.*" %>
<%@ page import="com.codequest.DbConnection" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%!
    // Display usernames safely
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    // Student login check
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>CodeQuest - Leaderboard</title>

<style>
    body {
        background: #101827;
        color: white;
        font-family: Arial, sans-serif;
        text-align: center;
        padding: 30px 15px;
    }

    h1 {
        color: #38bdf8;
    }

    table {
        width: 95%;
        max-width: 850px;
        margin: 30px auto;
        border-collapse: collapse;
        background: #1e293b;
        border-radius: 12px;
        overflow: hidden;
    }

    th, td {
        padding: 15px;
        border-bottom: 1px solid #334155;
    }

    th {
        background: #0284c7;
    }

    tr:hover {
        background: #334155;
    }

    .gold {
        color: #facc15;
        font-weight: bold;
    }

    .silver {
        color: #cbd5e1;
        font-weight: bold;
    }

    .bronze {
        color: #fb923c;
        font-weight: bold;
    }

    .btn {
        display: inline-block;
        background: #38bdf8;
        color: #101827;
        padding: 12px 25px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: bold;
        margin: 10px;
    }
</style>
</head>

<body>

<h1>CodeQuest Leaderboard</h1>

<p>Top students ranked by XP Points!</p>

<table>

    <tr>
        <th>Rank</th>
        <th>Student Name</th>
        <th>XP Points</th>
        <th>Level</th>
        <th>Completed Missions</th>
    </tr>

<%
    int rank = 1;
    boolean hasStudents = false;

    String sql =
        "SELECT u.username, u.xp, u.level, " +
        "COUNT(ms.id) AS completed_missions " +
        "FROM users u " +
        "LEFT JOIN mission_submissions ms " +
        "ON u.id = ms.user_id " +
        "AND ms.is_correct = TRUE " +
        "GROUP BY u.id, u.username, u.xp, u.level " +
        "ORDER BY u.xp DESC, u.username ASC";

    try (Connection con = DbConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            hasStudents = true;

            String username =
                escapeHtml(rs.getString("username"));

            int xp = rs.getInt("xp");
            int level = rs.getInt("level");

            int completedMissions =
                rs.getInt("completed_missions");

            String rankDisplay;
            String rankClass = "";

            if (rank == 1) {
                rankDisplay = "&#129351; 1";
                rankClass = "gold";

            } else if (rank == 2) {
                rankDisplay = "&#129352; 2";
                rankClass = "silver";

            } else if (rank == 3) {
                rankDisplay = "&#129353; 3";
                rankClass = "bronze";

            } else {
                rankDisplay = String.valueOf(rank);
            }
%>

    <tr>
        <td class="<%= rankClass %>">
            <%= rankDisplay %>
        </td>

        <td><%= username %></td>

        <td><%= xp %></td>

        <td><%= level %></td>

        <td><%= completedMissions %></td>
    </tr>

<%
            rank++;
        }

    } catch (Exception e) {
        application.log("Leaderboard loading failed", e);
%>

    <tr>
        <td colspan="5">
            Unable to load leaderboard.
        </td>
    </tr>

<%
    }

    if (!hasStudents) {
%>

    <tr>
        <td colspan="5">
            No students available yet.
        </td>
    </tr>

<%
    }
%>

</table>

<a href="<%= request.getContextPath() %>/student-dashboard"
   class="btn">
    Back to Dashboard
</a>

<a href="<%= request.getContextPath() %>/student-missions"
   class="btn">
    Play Missions
</a>

</body>
</html>
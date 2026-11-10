<%@ page import="java.sql.*" %>
<%@ page import="com.codequest.DbConnection" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    // Allow only logged-in admins
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin-login.jsp"
        );
        return;
    }

    int totalStudents = 0;
    int totalXP = 0;

    try (Connection con = DbConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
             "SELECT COUNT(*) AS total_students, " +
             "COALESCE(SUM(xp), 0) AS total_xp FROM users");
         ResultSet rs = ps.executeQuery()) {

        if (rs.next()) {
            totalStudents = rs.getInt("total_students");
            totalXP = rs.getInt("total_xp");
        }

    } catch (Exception e) {
        application.log("Admin dashboard error", e);
        response.sendError(500, "Unable to load dashboard");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CodeQuest - Admin Dashboard</title>

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

    .card {
        background: #1e293b;
        display: inline-block;
        padding: 25px;
        margin: 15px;
        border-radius: 15px;
        min-width: 180px;
    }

    .number {
        color: #facc15;
        font-size: 30px;
        font-weight: bold;
    }

    table {
        width: 95%;
        max-width: 850px;
        margin: 30px auto;
        border-collapse: collapse;
        background: #1e293b;
    }

    th, td {
        padding: 14px;
        border-bottom: 1px solid #334155;
    }

    th {
        background: #0284c7;
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

    .btn:hover {
        background: #0ea5e9;
    }

    .logout {
        background: #ef4444;
        color: white;
    }
</style>
</head>

<body>

<h1>CodeQuest Admin Dashboard</h1>

<p>Manage and monitor student progress</p>

<div class="card">
    <h3>Total Students</h3>
    <div class="number"><%= totalStudents %></div>
</div>

<div class="card">
    <h3>Total XP Earned</h3>
    <div class="number"><%= totalXP %></div>
</div>

<h2>Student Details</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Username</th>
        <th>Email</th>
        <th>XP</th>
        <th>Level</th>
    </tr>

<%
    try (Connection con = DbConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(
             "SELECT id, username, email, xp, level " +
             "FROM users ORDER BY id");
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            String username = rs.getString("username");
            String email = rs.getString("email");

            username = username.replace("&", "&amp;")
                               .replace("<", "&lt;")
                               .replace(">", "&gt;")
                               .replace("\"", "&quot;")
                               .replace("'", "&#39;");

            email = email.replace("&", "&amp;")
                         .replace("<", "&lt;")
                         .replace(">", "&gt;")
                         .replace("\"", "&quot;")
                         .replace("'", "&#39;");
%>

    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= username %></td>
        <td><%= email %></td>
        <td><%= rs.getInt("xp") %></td>
        <td><%= rs.getInt("level") %></td>
    </tr>

<%
        }

    } catch (Exception e) {
        application.log("Admin student list error", e);
%>

    <tr>
        <td colspan="5">Unable to load student details.</td>
    </tr>

<%
    }
%>

</table>

<!-- Admin Question Management -->

<h2>Manage Programming Questions</h2>

<a href="<%= request.getContextPath() %>/add-question.jsp"
   class="btn">
    ➕ Add Question
</a>

<a href="<%= request.getContextPath() %>/view-questions"
   class="btn">
    📋 View Questions
</a>

<br><br>

<a href="<%= request.getContextPath() %>/index.html"
   class="btn">
    🏠 Home
</a>

<a href="<%= request.getContextPath() %>/admin-logout"
   class="btn logout">
    Logout
</a>

</body>
</html>
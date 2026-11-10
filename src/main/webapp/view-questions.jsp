
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>

<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin-login.jsp"
        );
        return;
    }

    if (request.getAttribute("questions") == null) {
        response.sendRedirect(
            request.getContextPath() + "/view-questions"
        );
        return;
    }

    List<Map<String, Object>> questions =
        (List<Map<String, Object>>)
        request.getAttribute("questions");
%>

<%!
    public String escapeHtml(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CodeQuest - View Questions</title>

<style>
    body {
        background: #101827;
        color: white;
        font-family: Arial, sans-serif;
        padding: 25px;
    }

    h1 {
        color: #38bdf8;
        text-align: center;
    }

    table {
        width: 95%;
        margin: 30px auto;
        border-collapse: collapse;
        background: #1e293b;
    }

    th, td {
        padding: 14px;
        border: 1px solid #334155;
        text-align: center;
    }

    th {
        background: #0284c7;
    }

    a {
        color: #38bdf8;
    }

    .links {
        text-align: center;
        margin-top: 25px;
    }
</style>
</head>

<body>

<h1>CodeQuest - All Programming Questions</h1>

<table>
    <tr>
        <th>ID</th>
        <th>Question Title</th>
        <th>Category</th>
        <th>Difficulty</th>
        <th>XP Reward</th>
    </tr>

<%
    if (questions.isEmpty()) {
%>
    <tr>
        <td colspan="5">No questions available.</td>
    </tr>
<%
    } else {
        for (Map<String, Object> q : questions) {
%>
    <tr>
        <td><%= q.get("id") %></td>
        <td><%= escapeHtml((String) q.get("title")) %></td>
        <td><%= escapeHtml((String) q.get("category")) %></td>
        <td><%= escapeHtml((String) q.get("difficulty")) %></td>
        <td><%= q.get("xp_reward") %></td>
    </tr>
<%
        }
    }
%>

</table>

<div class="links">
    <a href="add-question.jsp">Add New Question</a>
    |
    <a href="admin-dashboard.jsp">Admin Dashboard</a>
</div>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    // DashboardServlet nunchi data
    if (request.getAttribute("username") == null) {
        response.sendRedirect(
            request.getContextPath() + "/student-dashboard"
        );
        return;
    }

    String username = (String) request.getAttribute("username");

    int xp = (Integer) request.getAttribute("xp");
    int level = (Integer) request.getAttribute("level");

    int completedMissions =
        (Integer) request.getAttribute("completedMissions");

    int progress =
        (Integer) request.getAttribute("progress");

    int xpToNextLevel =
        (Integer) request.getAttribute("xpToNextLevel");

    // Protect username from HTML injection
    username = username.replace("&", "&amp;")
                       .replace("<", "&lt;")
                       .replace(">", "&gt;")
                       .replace("\"", "&quot;")
                       .replace("'", "&#39;");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Student Dashboard</title>

    <style>
        body {
            background: #101827;
            color: white;
            font-family: Arial, sans-serif;
            text-align: center;
            margin: 0;
            padding: 40px 15px;
        }

        h1 {
            color: #38bdf8;
        }

        .card {
            background: #1e293b;
            padding: 25px;
            margin: 20px auto;
            border-radius: 15px;
            max-width: 400px;
        }

        .points {
            color: #facc15;
            font-size: 26px;
            font-weight: bold;
        }

        .btn {
            display: inline-block;
            background: #38bdf8;
            color: #101827;
            padding: 12px 25px;
            border-radius: 8px;
            text-decoration: none;
            margin: 10px;
            font-weight: bold;
        }

        .progress-container {
            background: #334155;
            border-radius: 10px;
            width: 100%;
            height: 22px;
            overflow: hidden;
            margin-top: 15px;
        }

        .progress-bar {
            background: #22c55e;
            height: 100%;
            border-radius: 10px;
        }

        .logout-btn {
            background: #ef4444;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
    </style>
</head>

<body>

    <h1>CodeQuest Dashboard</h1>

    <h2>Welcome, <%= username %>!</h2>

    <div class="card">

        <h2>Student Profile</h2>

        <p>Username: <%= username %></p>

        <p class="points">XP Points: <%= xp %></p>

        <p>Level: <%= level %></p>

        <p>Completed Missions: <%= completedMissions %></p>

    </div>

    <div class="card">

        <h2>Level Progress</h2>

        <p><%= progress %> / 100 XP</p>

        <div class="progress-container">
            <div class="progress-bar"
                 style="width: <%= progress %>%;">
            </div>
        </div>

        <p>
            <%= xpToNextLevel %> XP needed for next level
        </p>

    </div>

    <a href="index.html" class="btn">Home</a>

    <a href="missions.jsp" class="btn">Missions</a>

    <a href="leaderboard.jsp" class="btn">Leaderboard</a>

    <form action="<%= request.getContextPath() %>/student-logout"
          method="post">

        <button type="submit" class="logout-btn">
            Logout
        </button>

    </form>

</body>
</html>
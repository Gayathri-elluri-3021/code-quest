
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    // Results must come from SubmitAnswerServlet
    Boolean isCorrect =
        (Boolean) request.getAttribute("isCorrect");

    Integer earnedXP =
        (Integer) request.getAttribute("earnedXP");

    if (isCorrect == null || earnedXP == null) {
        response.sendRedirect(
            request.getContextPath() + "/student-missions"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>CodeQuest - Mission Result</title>

    <style>
        body {
            background: #101827;
            color: white;
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px 15px;
        }

        h1 {
            color: #38bdf8;
        }

        .card {
            background: #1e293b;
            padding: 35px;
            margin: 30px auto;
            border-radius: 15px;
            max-width: 450px;
        }

        .correct {
            color: #22c55e;
        }

        .wrong {
            color: #ef4444;
        }

        .points {
            color: #facc15;
            font-size: 28px;
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

    <h1>CodeQuest Mission Result</h1>

    <div class="card">

        <% if (isCorrect) { %>

            <h2 class="correct">
                &#10004; Correct Answer!
            </h2>

            <p>Congratulations! Mission completed.</p>

            <p class="points">
                +<%= earnedXP %> XP Earned
            </p>

        <% } else { %>

            <h2 class="wrong">
                &#10008; Wrong Answer!
            </h2>

            <p>Keep learning and improving!</p>

            <p class="points">
                +0 XP
            </p>

        <% } %>

    </div>

    <a href="<%= request.getContextPath() %>/student-missions"
       class="btn">
        Back to Missions
    </a>

    <a href="<%= request.getContextPath() %>/student-dashboard"
       class="btn">
        My Dashboard
    </a>

</body>
</html>
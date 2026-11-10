<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%!
    // Display database text safely in HTML
    private String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }

        return String.valueOf(value)
            .replace("&", "&amp;")
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

    // Questions are loaded by MissionServlet
    List<Map<String, Object>> missions =
        (List<Map<String, Object>>)
        request.getAttribute("missions");

    if (missions == null) {
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
    <title>CodeQuest - Programming Missions</title>

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
            padding: 25px;
            margin: 20px auto;
            border-radius: 15px;
            max-width: 550px;
            text-align: left;
        }

        .btn {
            display: inline-block;
            background: #38bdf8;
            color: #101827;
            padding: 12px 25px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            border: none;
            cursor: pointer;
            margin: 10px 5px;
        }

        .option {
            display: block;
            background: #334155;
            padding: 12px;
            margin: 10px 0;
            border-radius: 8px;
            cursor: pointer;
        }

        .option:hover {
            background: #475569;
        }

        .tag {
            color: #facc15;
            font-weight: bold;
        }

        .completed {
            color: #22c55e;
            font-weight: bold;
        }

        .attempted {
            color: #f87171;
            font-weight: bold;
        }

        .empty {
            text-align: center;
        }
    </style>
</head>

<body>

    <h1>CodeQuest Programming Missions</h1>

    <p>Complete programming challenges and earn XP!</p>

    <%
        if (missions.isEmpty()) {
    %>

        <div class="card empty">
            <h2>No Missions Available</h2>
            <p>
                Admin has not added any programming
                questions yet.
            </p>
        </div>

    <%
        } else {

            for (Map<String, Object> mission : missions) {

                int missionId =
                    ((Number) mission.get("id")).intValue();

                boolean attempted =
                    Boolean.TRUE.equals(
                        mission.get("attempted")
                    );

                boolean correct =
                    Boolean.TRUE.equals(
                        mission.get("isCorrect")
                    );
    %>

        <div class="card">

            <h2>
                <%= escapeHtml(mission.get("title")) %>
            </h2>

            <p>
                <span class="tag">Category:</span>
                <%= escapeHtml(mission.get("category")) %>
            </p>

            <p>
                <span class="tag">Difficulty:</span>
                <%= escapeHtml(mission.get("difficulty")) %>
            </p>

            <p>
                <span class="tag">XP Reward:</span>
                <%= mission.get("xp_reward") %>
            </p>

            <p>
                <%= escapeHtml(mission.get("description")) %>
            </p>

            <%
                if (attempted) {

                    if (correct) {
            %>

                <p class="completed">
                    &#10004; Mission Completed!
                </p>

            <%
                    } else {
            %>

                <p class="attempted">
                    Mission Already Attempted
                </p>

            <%
                    }

                } else {
            %>

                <form action="<%= request.getContextPath() %>/submit-answer"
                      method="post">

                    <input type="hidden"
                           name="missionId"
                           value="<%= missionId %>">

                    <label class="option">
                        <input type="radio"
                               name="answer"
                               value="A"
                               required>
                        A.
                        <%= escapeHtml(mission.get("option_a")) %>
                    </label>

                    <label class="option">
                        <input type="radio"
                               name="answer"
                               value="B">
                        B.
                        <%= escapeHtml(mission.get("option_b")) %>
                    </label>

                    <label class="option">
                        <input type="radio"
                               name="answer"
                               value="C">
                        C.
                        <%= escapeHtml(mission.get("option_c")) %>
                    </label>

                    <label class="option">
                        <input type="radio"
                               name="answer"
                               value="D">
                        D.
                        <%= escapeHtml(mission.get("option_d")) %>
                    </label>

                    <button type="submit" class="btn">
                        Submit Answer
                    </button>

                </form>

            <%
                }
            %>

        </div>

    <%
            }
        }
    %>

    <a href="<%= request.getContextPath() %>/student-dashboard"
       class="btn">
        Back to Dashboard
    </a>

</body>
</html>
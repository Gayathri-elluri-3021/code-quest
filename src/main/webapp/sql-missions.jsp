
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CodeQuest - SQL Missions</title>

<style>
    body {
        background: #101827;
        color: white;
        font-family: Arial, sans-serif;
        text-align: center;
        padding: 25px;
    }

    h1 {
        color: #38bdf8;
    }

    .card {
        background: #1e293b;
        padding: 25px;
        margin: 20px auto;
        border-radius: 15px;
        max-width: 500px;
        text-align: left;
    }

    label {
        display: block;
        padding: 8px;
        cursor: pointer;
    }

    button, .btn {
        display: inline-block;
        background: #38bdf8;
        color: #101827;
        padding: 12px 25px;
        border: none;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        margin: 10px;
    }

    #result {
        color: #facc15;
        font-size: 22px;
        margin: 20px;
    }
</style>
</head>

<body>

<h1>SQL Programming Missions</h1>

<p>Answer the questions and test your SQL knowledge!</p>

<form id="quiz" action="sql-quiz" method="post">

    <div class="card">
        <h3>1. Which SQL command retrieves data from a table?</h3>

        <label>
            <input type="radio" name="q1" value="a">
            SELECT
        </label>

        <label>
            <input type="radio" name="q1" value="b">
            INSERT
        </label>

        <label>
            <input type="radio" name="q1" value="c">
            DELETE
        </label>
    </div>

    <div class="card">
        <h3>2. Which SQL command adds new records?</h3>

        <label>
            <input type="radio" name="q2" value="a">
            UPDATE
        </label>

        <label>
            <input type="radio" name="q2" value="b">
            INSERT
        </label>

        <label>
            <input type="radio" name="q2" value="c">
            DROP
        </label>
    </div>

    <div class="card">
        <h3>3. Which SQL clause filters records?</h3>

        <label>
            <input type="radio" name="q3" value="a">
            ORDER BY
        </label>

        <label>
            <input type="radio" name="q3" value="b">
            GROUP BY
        </label>

        <label>
            <input type="radio" name="q3" value="c">
            WHERE
        </label>
    </div>

   <button type="submit">
    Submit Answers
</button> 

</form>

<div id="result" role="status"></div>

<a href="missions.jsp" class="btn">
    Back to Missions
</a>

<script>
function checkAnswers() {

    const answers = {
        q1: "a",
        q2: "b",
        q3: "c"
    };

    let score = 0;

    for (const question in answers) {

        const selected = document.querySelector(
            'input[name="' + question + '"]:checked'
        );

        if (!selected) {
            document.getElementById("result").textContent =
                "Please answer all questions!";
            return;
        }

        if (selected.value === answers[question]) {
            score++;
        }
    }

    document.getElementById("result").textContent =
        "Your Score: " + score + " / 3";
}
</script>

</body>
</html>
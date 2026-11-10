
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
<title>CodeQuest - Python Missions</title>

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

<h1>Python Programming Missions</h1>

<p>Answer the questions and test your Python knowledge!</p>

<form id="quiz" action="python-quiz" method="post">

    <div class="card">
        <h3>1. Which function displays output in Python?</h3>

        <label>
            <input type="radio" name="q1" value="a">
            echo()
        </label>

        <label>
            <input type="radio" name="q1" value="b">
            print()
        </label>

        <label>
            <input type="radio" name="q1" value="c">
            display()
        </label>
    </div>

    <div class="card">
        <h3>2. Which symbol starts a comment in Python?</h3>

        <label>
            <input type="radio" name="q2" value="a">
            #
        </label>

        <label>
            <input type="radio" name="q2" value="b">
            //
        </label>

        <label>
            <input type="radio" name="q2" value="c">
            /*
        </label>
    </div>

    <div class="card">
        <h3>3. Which keyword defines a function in Python?</h3>

        <label>
            <input type="radio" name="q3" value="a">
            function
        </label>

        <label>
            <input type="radio" name="q3" value="b">
            func
        </label>

        <label>
            <input type="radio" name="q3" value="c">
            def
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
        q1: "b",
        q2: "a",
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
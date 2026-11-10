
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect(request.getContextPath()
                + "/admin-login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CodeQuest - Add Question</title>
<style>
    body {
        background: #101827;
        color: white;
        font-family: Arial, sans-serif;
        padding: 25px;
    }
    .container {
        max-width: 600px;
        margin: auto;
        background: #1e293b;
        padding: 25px;
        border-radius: 15px;
    }
    h2 {
        text-align: center;
        color: #38bdf8;
    }
    label {
        display: block;
        margin-top: 15px;
    }
    input, textarea, select {
        width: 100%;
        padding: 12px;
        margin-top: 6px;
        border-radius: 6px;
        border: none;
        box-sizing: border-box;
    }
    button {
        background: #38bdf8;
        padding: 12px 25px;
        border: none;
        border-radius: 8px;
        margin-top: 20px;
        cursor: pointer;
        font-weight: bold;
    }
    a {
        color: #38bdf8;
    }
</style>
</head>
<body>

<div class="container">
    <h2>Add Programming Question</h2>

    <form action="<%= request.getContextPath() %>/add-question"
          method="post">

        <label>Question Title</label>
        <input type="text" name="title" required maxlength="200">

        <label>Question Description</label>
        <textarea name="description" rows="4" required></textarea>

        <label>Category</label>
        <select name="category" required>
            <option value="Java">Java</option>
            <option value="SQL">SQL</option>
            <option value="DSA">DSA</option>
        </select>

        <label>Difficulty</label>
        <select name="difficulty" required>
            <option value="Easy">Easy</option>
            <option value="Medium">Medium</option>
            <option value="Hard">Hard</option>
        </select>

        <label>Option A</label>
        <input type="text" name="option_a" required>

        <label>Option B</label>
        <input type="text" name="option_b" required>

        <label>Option C</label>
        <input type="text" name="option_c" required>

        <label>Option D</label>
        <input type="text" name="option_d" required>

        <label>Correct Answer</label>
        <select name="correct_answer" required>
            <option value="A">Option A</option>
            <option value="B">Option B</option>
            <option value="C">Option C</option>
            <option value="D">Option D</option>
        </select>

        <label>XP Reward</label>
        <input type="number" name="xp_reward"
               value="10" min="1" max="1000" required>

        <button type="submit">Add Question</button>
    </form>

    <p><a href="admin-dashboard.jsp">Back to Dashboard</a></p>
</div>

</body>
</html>
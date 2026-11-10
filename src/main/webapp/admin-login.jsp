
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CodeQuest - Admin Login</title>

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

    .login-box {
        background: #1e293b;
        padding: 30px;
        margin: 30px auto;
        max-width: 380px;
        border-radius: 15px;
    }

    input {
        width: 90%;
        padding: 12px;
        margin: 12px 0;
        border: none;
        border-radius: 8px;
        font-size: 16px;
    }

    button {
        background: #38bdf8;
        color: #101827;
        padding: 12px 30px;
        border: none;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
    }

    a {
        color: #38bdf8;
        display: inline-block;
        margin-top: 20px;
    }
</style>
</head>

<body>

<h1>CodeQuest Admin Login</h1>
<p>Administrator Access</p>

<div class="login-box">

    <h2>Admin Sign In</h2>

    <form action="admin-login" method="post">

        <input type="email"
               name="email"
               placeholder="Admin Email"
               required>

        <input type="password"
               name="password"
               placeholder="Admin Password"
               required>

        <button type="submit">
            Login as Admin
        </button>

    </form>

</div>

<a href="index.html">Back to Home</a>

</body>
</html>
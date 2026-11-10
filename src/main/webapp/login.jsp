
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>CodeQuest - Student Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body style="background:#0b0b1e; color:white; text-align:center; padding-top:100px;">

    <h1 style="color:#58a6ff;">CodeQuest</h1>
    <h2 style="color:orange;">Student Login</h2>

    <form action="login" method="post">
        <input type="email" name="email"
               placeholder="Enter Email" required>
        <br><br>

        <input type="password" name="password"
               placeholder="Enter Password" required>
        <br><br>

        <button type="submit">Login</button>
    </form>

    <p>Don't have an account?
        <a href="register.jsp">Register Here</a>
    </p>

    <a href="index.html">Back to Home</a>

</body>
</html>
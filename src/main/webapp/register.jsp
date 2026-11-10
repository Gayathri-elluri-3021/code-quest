
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Registration</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

    <h1>CodeQuest</h1>
    <h2>Student Registration</h2>

    <form action="register" method="post">

        <input type="text" name="username"
               placeholder="Enter Username" required>
        <br><br>

        <input type="email" name="email"
               placeholder="Enter Email" required>
        <br><br>

        <input type="password" name="password"
               placeholder="Enter Password" required>
        <br><br>

        <input type="password" name="confirmPassword"
               placeholder="Confirm Password" required>
        <br><br>

        <button type="submit">Register</button>

    </form>

    <p>Already have an account?
        <a href="login.jsp">Login Here</a>
    </p>

    <a href="index.html">Back to Home</a>

</body>
</html>
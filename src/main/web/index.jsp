<%@ page import="java.sql.SQLException" %>
<%@ page import="vedder.models.DietingPerson" %>
<%@ page import="vedder.controllers.DBManipulator" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet/less" type="text/css" href="main.less">
    <link href="https://fonts.googleapis.com/css2?family=Roboto+Slab:wght@400;500;531;600;700;800;900&display=swap"
          rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Ubuntu:ital,wght@0,700;1,700&display=swap" rel="stylesheet">
    <script src="//cdnjs.cloudflare.com/ajax/libs/less.js/3.9.0/less.min.js"></script>
    <title>Dieters</title>
</head>
<body>

<%
    HttpSession initialHttpSession = request.getSession();
    DietingPerson userInCookies = (DietingPerson) initialHttpSession.getAttribute("user");
    DietingPerson userInDB = null;
    if (userInCookies != null) {
        try {
            userInDB = new DBManipulator().getUser(userInCookies.getLogin(), userInCookies.getPassword());
            if (userInCookies.equals(userInDB)) {
                response.sendRedirect("result.jsp");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
%>

<header class="login-header header">
    <h1 class="title">DIETERS - login page</h1>
</header>
<main class="login">
    <form class="login-form" action="index.jsp" method="post">
        Please, enter your credentials
        <div class="login-input-wrapper">
            <label class="login-form__label label">
                login
                <input name="login" class="login-form__input input" type="text">
            </label>
            <label class="login-form__label label">
                password
                <input name="password" class="login-form__input input" type="password">
            </label>
        </div>
        <input name="submit" class="login-form__button button" type="submit">
    </form>
    <%
        try {
            String login = request.getParameter("login");
            String password = request.getParameter("password");
            String submit = request.getParameter("submit");

            if (submit != null) {
                if (!login.equals("") && !password.equals("")) {
                    DietingPerson user = new DBManipulator().getUser(login, password);
                    if (user != null) {
                        HttpSession httpSession = request.getSession();
                        httpSession.setAttribute("user", user);
                        response.sendRedirect("result.jsp");
                    } else {
                        out.println("<div class=\"login-error\">There is no such user</div>");
                    }
                } else {
                    out.println("<div class=\"login-error\">Fill in credentials</div>");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    %>
</main>
</body>
</html>


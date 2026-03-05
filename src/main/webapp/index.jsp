<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Login - Biblioteca Digital UNTEC</title>
  </head>
  <body>
    <h1>Acceso a la Biblioteca Digital UNTEC</h1>

    <c:if test="${not empty error}">
      <p style="color: red"><c:out value="${error}" /></p>
    </c:if>

    <form action="login" method="post">
      <table border="0" cellpadding="5">
        <tr>
          <td>Email:</td>
          <td><input type="email" name="email" required /></td>
        </tr>
        <tr>
          <td>Password:</td>
          <td><input type="password" name="password" required /></td>
        </tr>
        <tr>
          <td></td>
          <td><button type="submit">Entrar</button></td>
        </tr>
      </table>
    </form>
  </body>
</html>

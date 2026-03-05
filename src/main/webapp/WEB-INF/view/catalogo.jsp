<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head><title>Catálogo - Biblioteca Digital UNTEC</title></head>
<body>
    <h1>Catálogo de la Biblioteca Digital UNTEC</h1>
    <p>Usuario: <c:out value="${sessionScope.usuario.nombre}" /></p>
    <a href="formulario-vinilo.jsp">Registrar Nuevo</a> | <a href="mis-prestamos">Mis Préstamos</a>
    <br><br>
    
    <%-- Solo se mantiene el mensaje de error para validaciones de seguridad --%>
    <c:if test="${not empty error}"><p style="color:red"><c:out value="${error}"/></p></c:if>

    <table border="1" cellpadding="10" cellspacing="0">
        <thead>
            <tr><th>ID</th><th>Título</th><th>Autor</th><th>Año</th><th>Género</th><th>Acciones</th></tr>
        </thead>
        <tbody>
            <c:forEach var="l" items="${libros}">
                <tr>
                    <td>${l.idLibro}</td><td>${l.titulo}</td><td>${l.autor}</td>
                    <td>${l.anioLanzamiento}</td><td>${l.genero}</td>
                    <td>
                        <c:choose>
                            <c:when test="${l.disponible}">
                                <a href="solicitarPrestamo?id=${l.idLibro}">Solicitar</a> |
                                <a href="libros?accion=editar&id=${l.idLibro}">Editar</a> |
                                <a href="libros?accion=eliminar&id=${l.idLibro}" onclick="return confirm('¿Eliminar?');">Eliminar</a>
                            </c:when>
                            <c:otherwise>
                                <span style="color: grey; font-style: italic;">En préstamo</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
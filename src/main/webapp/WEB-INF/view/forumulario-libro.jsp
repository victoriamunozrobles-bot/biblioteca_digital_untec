<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Formulario Libro</title>
  </head>
  <body>
    <h1><c:out value="${libro != null ? 'Editar' : 'Registrar'}" /> Libro</h1>

    <form action="libros" method="post">
      <input type="hidden" name="idLibro" value="${libro.idLibro}" />

      <table border="0" cellpadding="5">
        <tr>
          <td><label for="titulo">Título:</label></td>
          <td>
            <input
              type="text"
              id="titulo"
              name="titulo"
              value="${libro.titulo}"
              required
            />
          </td>
        </tr>
        <tr>
          <td><label for="autor">Autor:</label></td>
          <td>
            <input
              type="text"
              id="autor"
              name="autor"
              value="${libro.autor}"
              required
            />
          </td>
        </tr>
        <tr>
          <td><label for="anioLanzamiento">Año:</label></td>
          <td>
            <input
              type="number"
              id="anioLanzamiento"
              name="anioLanzamiento"
              value="${libro.anioLanzamiento}"
              required
            />
          </td>
        </tr>
        <tr>
          <td><label for="genero">Género:</label></td>
          <td>
            <input
              type="text"
              id="genero"
              name="genero"
              value="${libro.genero}"
            />
          </td>
        </tr>
        <input
          type="hidden"
          name="disponible"
          value="${libro.idLibro != null ? libro.disponible : true}"
        />
        <tr>
          <td></td>
          <td>
            <button type="submit">Guardar</button>
            <a href="vinilos">Cancelar</a>
          </td>
        </tr>
      </table>
    </form>
  </body>
</html>

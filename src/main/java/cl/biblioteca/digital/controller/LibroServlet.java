package cl.biblioteca.digital.controller;

import cl.biblioteca.digital.dao.LibroDAO;
import cl.biblioteca.digital.model.Libro;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/Libros")
public class LibroServlet extends HttpServlet {
    private LibroDAO libroDAO = new LibroDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            List<Libro> lista = libroDAO.listarTodos();
            request.setAttribute("libros", lista);
            request.getRequestDispatcher("catalogo.jsp").forward(request, response);
        } else if (accion.equals("eliminar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            libroDAO.eliminar(id);
            response.sendRedirect("libros");
        } else if (accion.equals("editar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Libro v = libroDAO.obtenerPorId(id);
            request.setAttribute("libro", v);
            request.getRequestDispatcher("formulario-libro.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("idLibro");
        String titulo = request.getParameter("titulo");
        String autor = request.getParameter("autor");
        int anio = Integer.parseInt(request.getParameter("anioLanzamiento"));
        String genero = request.getParameter("genero");
        String disponibleString = request.getParameter("disponible");
        boolean disponible = (disponibleString == null) || Boolean.parseBoolean(disponibleString);

        Libro v = new Libro();
        v.setTitulo(titulo);
        v.setAutor(autor);
        v.setAnioLanzamiento(anio);
        v.setGenero(genero);
        v.setDisponible(disponible);

        if (idStr == null || idStr.isEmpty()) {
            libroDAO.agregar(v);
        } else {
            v.setIdLibro(Integer.parseInt(idStr));
            libroDAO.actualizar(v);
        }
        response.sendRedirect("libros");
    }
}
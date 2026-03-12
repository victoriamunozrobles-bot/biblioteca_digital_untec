package cl.biblioteca.digital.controller;

import cl.biblioteca.digital.dao.PrestamoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/asignarPrestamo")
public class AsignarPrestamoServlet extends HttpServlet {
    private PrestamoDAO prestamoDAO = new PrestamoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idLibroStr = request.getParameter("idLibro");
        String nombre = request.getParameter("nombreUsuario");
        String apellido = request.getParameter("apellidoUsuario");
        String fechaEntrega = request.getParameter("fechaEntrega");

        if (idLibroStr != null && !idLibroStr.isEmpty()) {
            int idLibro = Integer.parseInt(idLibroStr);
            prestamoDAO.registrarManual(idLibro, nombre, apellido, fechaEntrega);
        }

        response.sendRedirect("libros");
    }
}
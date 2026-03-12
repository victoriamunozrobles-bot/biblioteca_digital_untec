package cl.biblioteca.digital.controller;

import cl.biblioteca.digital.dao.PrestamoDAO;
import cl.biblioteca.digital.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/devolverLibro")
public class Devolver extends HttpServlet {

    private PrestamoDAO prestamoDAO = new PrestamoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String idLibroStr = request.getParameter("idLibro");

        if (usuario != null && idLibroStr != null) {
            prestamoDAO.devolverConValidacion(Integer.parseInt(idLibroStr), usuario.getIdUsuario());
        }
        response.sendRedirect("mis-prestamos");
    }
}

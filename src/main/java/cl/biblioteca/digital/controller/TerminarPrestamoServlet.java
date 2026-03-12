package cl.biblioteca.digital.controller;

import cl.biblioteca.digital.dao.PrestamoDAO;
import cl.biblioteca.digital.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/terminarPrestamo")
public class TerminarPrestamoServlet extends HttpServlet {

    private PrestamoDAO prestamoDAO = new PrestamoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");
        String idPrestamoStr = request.getParameter("id");

        if (usuario != null && "ADMIN".equals(usuario.getRol()) && idPrestamoStr != null) {
            try {
                int idPrestamo = Integer.parseInt(idPrestamoStr);
                prestamoDAO.terminarPrestamoAdmin(idPrestamo);
            } catch (NumberFormatException e) {
                // Ignorar error de parseo o manejar log
            }
        }

        response.sendRedirect("perfil");
    }
}
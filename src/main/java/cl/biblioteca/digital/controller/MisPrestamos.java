package cl.biblioteca.digital.controller;

import cl.biblioteca.digital.dao.PrestamoDAO;
import cl.biblioteca.digital.model.Prestamo;
import cl.biblioteca.digital.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/mis-prestamos")

public class MisPrestamos extends HttpServlet {

    private PrestamoDAO prestamoDAO = new PrestamoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<Prestamo> lista = prestamoDAO.listarPorUsuario(usuario.getIdUsuario());
        request.setAttribute("prestamos", lista);
        request.getRequestDispatcher("mis-prestamos.jsp").forward(request, response);
    }
}

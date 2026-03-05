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

@WebServlet("/solicitarPrestamo")
public class PrestamoServlet extends HttpServlet {
    private PrestamoDAO prestamoDAO = new PrestamoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario socio = (Usuario) session.getAttribute("usuario");

        if (socio == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String idViniloStr = request.getParameter("id");

        if (idViniloStr != null) {
            int idVinilo = Integer.parseInt(idViniloStr);
            boolean exito = prestamoDAO.registrar(socio.getIdUsuario(), idVinilo);

            if (exito) {
                request.setAttribute("mensaje", "Préstamo registrado");
            } else {
                request.setAttribute("error", "Error al procesar");
            }
        }

        request.getRequestDispatcher("vinilos").forward(request, response);
    }
}

package cl.biblioteca.digital.controller;

import cl.biblioteca.digital.dao.PrestamoDAO;
import cl.biblioteca.digital.dao.UsuarioDAO;
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

@WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {

    private PrestamoDAO prestamoDAO = new PrestamoDAO();
    private UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        if ("ADMIN".equals(usuario.getRol())) {
            List<Prestamo> agenda = prestamoDAO.listarTodosActivos();
            List<Prestamo> historial = prestamoDAO.listarTodosHistorial();

            request.setAttribute("agendaPrestamos", agenda);
            request.setAttribute("totalPrestamosPendientes", agenda.size());

            request.setAttribute("historialAdmin", historial);
            request.setAttribute("totalPrestamosHistoricos", historial.size());
        } else {
            List<Prestamo> activos = prestamoDAO.listarPorUsuario(usuario.getIdUsuario());
            List<Prestamo> historial = prestamoDAO.listarHistorialPorUsuario(usuario.getIdUsuario());

            request.setAttribute("activos", activos);
            request.setAttribute("totalActivos", activos.size());
            request.setAttribute("historial", historial);
        }

        request.getRequestDispatcher("/WEB-INF/view/perfil.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Usuario usuario = (Usuario) session.getAttribute("usuario");

        String nuevoNombre = request.getParameter("nombre");
        String nuevoApellido = request.getParameter("apellido");
        String nuevaPassword = request.getParameter("password");
        String nuevaCarrera = request.getParameter("carrera");
        String nuevoCargo = request.getParameter("cargo");

        boolean exito = usuarioDAO.actualizarPerfil(usuario.getIdUsuario(), nuevoNombre, nuevoApellido, nuevaPassword,
                nuevaCarrera);

        if (exito) {
            usuario.setNombre(nuevoNombre);
            usuario.setApellido(nuevoApellido);
            usuario.setPassword(nuevaPassword);
            if (nuevaCarrera != null)
                usuario.setCarrera(nuevaCarrera);
            if (nuevoCargo != null)
                usuario.setCargo(nuevoCargo);

            session.setAttribute("usuario", usuario);
            request.setAttribute("mensaje", "Perfil actualizado correctamente.");
        } else {
            request.setAttribute("error", "Error al actualizar el perfil.");
        }

        doGet(request, response);
    }
}
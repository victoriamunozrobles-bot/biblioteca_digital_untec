package cl.biblioteca.digital.controller;

import cl.biblioteca.digital.dao.UsuarioDAO;
import cl.biblioteca.digital.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    private static final String SECRET_ADMIN_PASS = "admin123";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String rol = request.getParameter("rol");

        if ("ADMIN".equals(rol)) {
            String adminPass = request.getParameter("adminPassword");
            if (adminPass == null || !adminPass.equals(SECRET_ADMIN_PASS)) {
                response.sendRedirect("index.jsp?registro=error_admin");
                return;
            }
        }

        Usuario u = new Usuario();
        u.setNombre(request.getParameter("nombre"));
        u.setApellido(request.getParameter("apellido"));
        u.setEmail(request.getParameter("email"));
        u.setPassword(request.getParameter("password"));
        u.setCarrera(request.getParameter("carrera"));
        u.setCargo(request.getParameter("cargo"));

        u.setRol(rol != null ? rol : "USUARIO");

        UsuarioDAO dao = new UsuarioDAO();
        if (dao.registrarUsuario(u)) {
            response.sendRedirect("index.jsp?registro=exito");
        } else {
            response.sendRedirect("index.jsp?registro=error");
        }
    }
}

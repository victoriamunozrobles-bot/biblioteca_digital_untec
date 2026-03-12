package cl.biblioteca.digital.controller;

import cl.biblioteca.digital.dao.UsuarioDAO;
import cl.biblioteca.digital.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Capturar los parámetros enviados desde el formulario JSP
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 2. Instanciar el DAO para conectarse a la base de datos
        UsuarioDAO usuarioDAO = new UsuarioDAO();

        // 3. Validar las credenciales reales usando el método del DAO
        Usuario usuario = usuarioDAO.validarUsuario(email, password);

        // 4. Si el usuario no es null, significa que las credenciales son correctas
        if (usuario != null) {
            HttpSession session = request.getSession();

            // 5. Guardar el objeto Usuario COMPLETO en la sesión.
            // Se debe llamar "usuario" porque en tu catalogo.jsp lo buscas con
            // ${sessionScope.usuario.nombre}
            session.setAttribute("usuario", usuario);

            // 6. Redirigir al Servlet de libros (asegúrate de que LibroServlet tenga
            // @WebServlet("/libros"))
            response.sendRedirect("libros");
        } else {
            // 7. Si las credenciales fallan, redirigir al login con el parámetro de error
            // en la URL
            response.sendRedirect("index.jsp?error=1");
        }
    }
}

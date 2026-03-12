package cl.biblioteca.digital.controller;

import cl.biblioteca.digital.dao.LibroDAO;
import cl.biblioteca.digital.model.Libro;
import cl.biblioteca.digital.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/libros")
public class LibroServlet extends HttpServlet {
    private LibroDAO libroDAO = new LibroDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Usuario u = (Usuario) request.getSession().getAttribute("usuario");

        if (u == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        String accion = request.getParameter("accion");

        if (accion == null) {
            String criterio = request.getParameter("criterio");
            String query = request.getParameter("q");

            List<Libro> lista;

            if (query != null && !query.trim().isEmpty() && criterio != null) {
                lista = libroDAO.buscar(criterio, query.trim());
            } else {
                lista = libroDAO.listarTodos();
            }

            request.setAttribute("libros", lista);

            if ("ADMIN".equals(u.getRol())) {
                int totalLibros = lista.size();
                int librosDisponibles = 0;
                int librosPrestados = 0;

                for (Libro l : lista) {
                    librosDisponibles += l.getEjemplaresDisponibles();
                    librosPrestados += (l.getEjemplaresTotales() - l.getEjemplaresDisponibles());
                }

                request.setAttribute("totalLibros", totalLibros);
                request.setAttribute("librosDisponibles", librosDisponibles);
                request.setAttribute("librosPrestados", librosPrestados);
            } else {
                cl.biblioteca.digital.dao.PrestamoDAO pDao = new cl.biblioteca.digital.dao.PrestamoDAO();
                int pendientes = pDao.listarPorUsuario(u.getIdUsuario()).size();
                int leidos = pDao.listarHistorialPorUsuario(u.getIdUsuario()).size();
                int totalCat = lista.size();
                int porcentaje = totalCat > 0 ? (int) Math.round((double) leidos / totalCat * 100) : 0;

                request.setAttribute("librosPendientes", pendientes);
                request.setAttribute("librosLeidos", leidos);
                request.setAttribute("porcentajeLeido", porcentaje);
            }

            request.getRequestDispatcher("/WEB-INF/view/catalogo.jsp").forward(request, response);

        } else if (accion.equals("eliminar")) {
            if ("ADMIN".equals(u.getRol())) {
                int id = Integer.parseInt(request.getParameter("id"));
                libroDAO.eliminar(id);
            }
            response.sendRedirect("libros");

        } else if (accion.equals("nuevo")) {
            request.getRequestDispatcher("/WEB-INF/view/formulario-libro.jsp").forward(request, response);

        } else if (accion.equals("editar")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Libro l = libroDAO.obtenerPorId(id);
            request.setAttribute("libro", l);
            request.getRequestDispatcher("/WEB-INF/view/formulario-libro.jsp").forward(request, response);
        } else if (accion.equals("detalle")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Libro l = libroDAO.obtenerPorId(id);

            List<Libro> relacionados = libroDAO.buscar("genero", l.getGenero());

            relacionados.removeIf(b -> b.getIdLibro() == id);

            request.setAttribute("libroDetalle", l);
            request.setAttribute("relacionados", relacionados);

            request.getRequestDispatcher("/WEB-INF/view/fragmento-detalle.jsp").forward(request, response);
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String idStr = request.getParameter("idLibro");
        String titulo = request.getParameter("titulo");
        String autor = request.getParameter("autor");
        String anioStr = request.getParameter("anioLanzamiento");
        int anio = (anioStr != null && !anioStr.isEmpty()) ? Integer.parseInt(anioStr) : 0;
        String genero = request.getParameter("genero");
        String editorial = request.getParameter("editorial");
        String portada = request.getParameter("portada");
        String sinopsis = request.getParameter("sinopsis");

        String isbn = request.getParameter("isbn");
        if (isbn == null || isbn.trim().isEmpty()) {
            isbn = "978-" + (System.currentTimeMillis() % 10000000000L);
        }

        String ejemplaresTotalesStr = request.getParameter("ejemplaresTotales");
        int ejemplaresTotales = (ejemplaresTotalesStr != null && !ejemplaresTotalesStr.isEmpty())
                ? Integer.parseInt(ejemplaresTotalesStr)
                : 1;

        String disponibleString = request.getParameter("disponible");
        boolean disponible = (disponibleString == null) || Boolean.parseBoolean(disponibleString);

        Libro v = new Libro();
        v.setTitulo(titulo);
        v.setAutor(autor);
        v.setAnioLanzamiento(anio);
        v.setGenero(genero);
        v.setEditorial(editorial);
        v.setIsbn(isbn);
        v.setPortada(portada);
        v.setSinopsis(sinopsis);
        v.setEjemplaresTotales(ejemplaresTotales);
        v.setDisponible(disponible);

        if (idStr == null || idStr.trim().isEmpty() || idStr.equals("0")) {
            v.setEjemplaresDisponibles(ejemplaresTotales); // Todos disponibles al crear
            libroDAO.agregar(v);
        } else {
            v.setIdLibro(Integer.parseInt(idStr));

            Libro libroActual = libroDAO.obtenerPorId(v.getIdLibro());
            if (libroActual != null) {
                int diferencia = ejemplaresTotales - libroActual.getEjemplaresTotales();
                int nuevosDisponibles = libroActual.getEjemplaresDisponibles() + diferencia;
                if (nuevosDisponibles < 0)
                    nuevosDisponibles = 0;
                v.setEjemplaresDisponibles(nuevosDisponibles);
            } else {
                v.setEjemplaresDisponibles(ejemplaresTotales);
            }

            libroDAO.actualizar(v);
        }

        response.sendRedirect("libros");
    }
}
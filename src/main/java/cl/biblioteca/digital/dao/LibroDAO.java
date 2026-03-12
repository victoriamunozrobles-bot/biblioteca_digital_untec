package cl.biblioteca.digital.dao;

import cl.biblioteca.digital.model.Libro;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LibroDAO {

    public List<Libro> listarTodos() {
        List<Libro> lista = new ArrayList<>();
        String sql = "SELECT * FROM libros ORDER BY titulo ASC";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Libro l = new Libro();
                l.setIdLibro(rs.getInt("id_libro"));
                l.setTitulo(rs.getString("titulo"));
                l.setAutor(rs.getString("autor"));
                l.setAnioLanzamiento(rs.getInt("anio_lanzamiento"));
                l.setGenero(rs.getString("genero"));
                l.setDisponible(rs.getBoolean("disponible"));
                l.setIsbn(rs.getString("isbn"));
                l.setEjemplaresTotales(rs.getInt("ejemplares_totales"));
                l.setEjemplaresDisponibles(rs.getInt("ejemplares_disponibles"));
                l.setPortada(rs.getString("portada"));
                l.setSinopsis(rs.getString("sinopsis"));
                l.setEditorial(rs.getString("editorial"));
                lista.add(l);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Libro> buscar(String criterio, String valor) {
        List<Libro> lista = new ArrayList<>();
        String sql = "SELECT * FROM libros WHERE ";

        boolean esGeneral = (criterio == null || criterio.equals("todo"));

        if (esGeneral) {
            sql += "titulo LIKE ? OR autor LIKE ? OR genero LIKE ?";
        } else {
            switch (criterio) {
                case "autor":
                    sql += "autor LIKE ?";
                    break;
                case "genero":
                    sql += "genero LIKE ?";
                    break;
                case "anio":
                    sql += "anio_lanzamiento = ?";
                    break;
                case "titulo":
                default:
                    sql += "titulo LIKE ?";
                    break;
            }
        }
        sql += " ORDER BY titulo ASC";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            if (esGeneral) {
                String parametro = "%" + valor + "%";
                ps.setString(1, parametro);
                ps.setString(2, parametro);
                ps.setString(3, parametro);
            } else if (criterio.equals("anio")) {
                try {
                    ps.setInt(1, Integer.parseInt(valor));
                } catch (NumberFormatException e) {
                    ps.setInt(1, 0);
                }
            } else {
                ps.setString(1, "%" + valor + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Libro l = new Libro();
                    l.setIdLibro(rs.getInt("id_libro"));
                    l.setTitulo(rs.getString("titulo"));
                    l.setAutor(rs.getString("autor"));
                    l.setAnioLanzamiento(rs.getInt("anio_lanzamiento"));
                    l.setGenero(rs.getString("genero"));
                    l.setDisponible(rs.getBoolean("disponible"));
                    l.setIsbn(rs.getString("isbn"));
                    l.setEjemplaresTotales(rs.getInt("ejemplares_totales"));
                    l.setEjemplaresDisponibles(rs.getInt("ejemplares_disponibles"));
                    l.setPortada(rs.getString("portada"));
                    l.setSinopsis(rs.getString("sinopsis"));
                    l.setEditorial(rs.getString("editorial"));
                    lista.add(l);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean agregar(Libro libro) {
        String sql = "INSERT INTO libros (titulo, autor, anio_lanzamiento, genero, disponible, isbn, ejemplares_totales, ejemplares_disponibles, portada, sinopsis, editorial) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, libro.getTitulo());
            ps.setString(2, libro.getAutor());
            ps.setInt(3, libro.getAnioLanzamiento());
            ps.setString(4, libro.getGenero());
            ps.setBoolean(5, true);
            ps.setString(6, libro.getIsbn());
            ps.setInt(7, libro.getEjemplaresTotales());
            ps.setInt(8, libro.getEjemplaresDisponibles());
            ps.setString(9, libro.getPortada());
            ps.setString(10, libro.getSinopsis());
            ps.setString(11, libro.getEditorial());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Libro obtenerPorId(int idLibro) {
        Libro l = null;
        String sql = "SELECT * FROM libros WHERE id_libro = ?";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idLibro);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    l = new Libro();
                    l.setIdLibro(rs.getInt("id_libro"));
                    l.setTitulo(rs.getString("titulo"));
                    l.setAutor(rs.getString("autor"));
                    l.setAnioLanzamiento(rs.getInt("anio_lanzamiento"));
                    l.setGenero(rs.getString("genero"));
                    l.setDisponible(rs.getBoolean("disponible"));
                    l.setIsbn(rs.getString("isbn"));
                    l.setEjemplaresTotales(rs.getInt("ejemplares_totales"));
                    l.setEjemplaresDisponibles(rs.getInt("ejemplares_disponibles"));
                    l.setPortada(rs.getString("portada"));
                    l.setSinopsis(rs.getString("sinopsis"));
                    l.setEditorial(rs.getString("editorial"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return l;
    }

    public boolean actualizar(Libro v) {
        String sql = "UPDATE libros SET titulo=?, autor=?, anio_lanzamiento=?, genero=?, disponible=?, isbn=?, ejemplares_totales=?, ejemplares_disponibles=?, portada=?, sinopsis=?, editorial=? WHERE id_libro=?";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getTitulo());
            ps.setString(2, v.getAutor());
            ps.setInt(3, v.getAnioLanzamiento());
            ps.setString(4, v.getGenero());
            ps.setBoolean(5, v.isDisponible());
            ps.setString(6, v.getIsbn());
            ps.setInt(7, v.getEjemplaresTotales());
            ps.setInt(8, v.getEjemplaresDisponibles());
            ps.setString(9, v.getPortada());
            ps.setString(10, v.getSinopsis());
            ps.setString(11, v.getEditorial());
            ps.setInt(12, v.getIdLibro()); // Este es el WHERE

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean eliminar(int idLibro) {
        String sql = "DELETE FROM libros WHERE id_libro=?";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idLibro);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
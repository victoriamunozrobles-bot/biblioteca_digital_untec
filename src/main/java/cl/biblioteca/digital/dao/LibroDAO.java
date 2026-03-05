package cl.biblioteca.digital.dao;

import cl.biblioteca.digital.model.Libro;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LibroDAO {

    public List<Libro> listarTodos() {
        List<Libro> lista = new ArrayList<>();
        String sql = "SELECT * FROM libros";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(new Libro(
                        rs.getInt("id_libro"),
                        rs.getString("titulo"),
                        rs.getString("autor"),
                        rs.getInt("anio_lanzamiento"),
                        rs.getString("genero"),
                        rs.getBoolean("disponible")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public boolean agregar(Libro Libro) {
        String sql = "INSERT INTO libros (titulo, autor, anio_lanzamiento, genero, disponible) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, Libro.getTitulo());
            ps.setString(2, Libro.getAutor());
            ps.setInt(3, Libro.getAnioLanzamiento());
            ps.setString(4, Libro.getGenero());
            ps.setBoolean(5, true);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Libro obtenerPorId(int idLibro) {
        Libro v = null;
        String sql = "SELECT * FROM libros WHERE id_libro = ?";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idLibro);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    v = new Libro(
                            rs.getInt("id_libro"),
                            rs.getString("titulo"),
                            rs.getString("autor"),
                            rs.getInt("anio_lanzamiento"),
                            rs.getString("genero"),
                            rs.getBoolean("disponible"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return v;
    }

    public boolean actualizar(Libro v) {
        String sql = "UPDATE libros SET titulo=?, autor=?, anio_lanzamiento=?, genero=?, disponible=? WHERE id_libro=?";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getTitulo());
            ps.setString(2, v.getAutor());
            ps.setInt(3, v.getAnioLanzamiento());
            ps.setString(4, v.getGenero());
            ps.setBoolean(5, v.isDisponible());
            ps.setInt(6, v.getIdLibro());
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
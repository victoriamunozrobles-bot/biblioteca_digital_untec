package cl.biblioteca.digital.dao;

import cl.biblioteca.digital.model.Prestamo;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class PrestamoDAO {

    public boolean registrar(int idUsuario, int idLibro) {
        String sqlIns = "INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo) VALUES (?, ?, ?)";
        String sqlUpd = "UPDATE libros SET disponible = false WHERE id_libro = ?";
        Connection conn = null;
        try {
            conn = ConexionBD.obtenerConexion();
            conn.setAutoCommit(false);
            try (PreparedStatement psI = conn.prepareStatement(sqlIns);
                    PreparedStatement psU = conn.prepareStatement(sqlUpd)) {
                psI.setInt(1, idUsuario);
                psI.setInt(2, idLibro);
                psI.setDate(3, Date.valueOf(LocalDate.now()));
                psI.executeUpdate();
                psU.setInt(1, idLibro);
                psU.executeUpdate();
                conn.commit();
                return true;
            } catch (SQLException e) {
                if (conn != null)
                    conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean devolverConValidacion(int idLibro, int idUsuario) {
        String sqlPre = "UPDATE prestamos SET fecha_devolucion = CURRENT_DATE " +
                "WHERE id_libro = ? AND id_usuario = ? AND fecha_devolucion IS NULL";
        String sqlVin = "UPDATE libros SET disponible = true WHERE id_Libro = ?";
        Connection conn = null;
        try {
            conn = ConexionBD.obtenerConexion();
            conn.setAutoCommit(false);
            try (PreparedStatement psP = conn.prepareStatement(sqlPre);
                    PreparedStatement psV = conn.prepareStatement(sqlVin)) {
                psP.setInt(1, idLibro);
                psP.setInt(2, idUsuario);
                if (psP.executeUpdate() > 0) {
                    psV.setInt(1, idLibro);
                    psV.executeUpdate();
                    conn.commit();
                    return true;
                }
                if (conn != null)
                    conn.rollback();
                return false;
            } catch (SQLException e) {
                if (conn != null)
                    conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public List<Prestamo> listarPorUsuario(int idUsuario) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, v.titulo FROM prestamos p " +
                "JOIN libros v ON p.id_libro = v.id_libro " +
                "WHERE p.id_usuario = ? AND p.fecha_devolucion IS NULL";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = new Prestamo();
                p.setIdLibro(rs.getInt("id_libro"));
                p.setTituloLibro(rs.getString("titulo"));
                p.setFechaPrestamo(rs.getDate("fecha_prestamo"));
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
package cl.biblioteca.digital.dao;

import cl.biblioteca.digital.model.Prestamo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PrestamoDAO {

    public boolean registrar(int idUsuario, int idLibro, String fechaEntrega) {
        String sqlIns = "INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, fecha_entrega, estado) VALUES (?, ?, CURRENT_DATE, ?, 'PENDIENTE')";
        String sqlUpd = "UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles - 1 WHERE id_libro = ? AND ejemplares_disponibles > 0";

        Connection conn = null;
        try {
            conn = ConexionBD.obtenerConexion();
            conn.setAutoCommit(false);
            try (PreparedStatement psI = conn.prepareStatement(sqlIns);
                    PreparedStatement psU = conn.prepareStatement(sqlUpd)) {

                psU.setInt(1, idLibro);
                int updated = psU.executeUpdate();

                if (updated > 0) {
                    psI.setInt(1, idUsuario);
                    psI.setInt(2, idLibro);
                    psI.setDate(3, Date.valueOf(fechaEntrega)); // Nueva fecha
                    psI.executeUpdate();

                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            } catch (SQLException e) {
                if (conn != null)
                    conn.rollback();
                return false;
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public boolean registrarManual(int idLibro, String nombre, String apellido, String fechaEntrega) {
        String sqlIns = "INSERT INTO prestamos (id_libro, fecha_prestamo, nombre_manual, apellido_manual, fecha_entrega, estado) VALUES (?, CURRENT_DATE, ?, ?, ?, 'PENDIENTE')";
        String sqlUpd = "UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles - 1 WHERE id_libro = ? AND ejemplares_disponibles > 0";

        Connection conn = null;
        try {
            conn = ConexionBD.obtenerConexion();
            conn.setAutoCommit(false);
            try (PreparedStatement psI = conn.prepareStatement(sqlIns);
                    PreparedStatement psU = conn.prepareStatement(sqlUpd)) {

                psU.setInt(1, idLibro);
                int updated = psU.executeUpdate();

                if (updated > 0) {
                    psI.setInt(1, idLibro);
                    psI.setString(2, nombre);
                    psI.setString(3, apellido);
                    psI.setDate(4, Date.valueOf(fechaEntrega));
                    psI.executeUpdate();

                    conn.commit();
                    return true;
                } else {
                    conn.rollback();
                    return false;
                }
            } catch (SQLException e) {
                if (conn != null)
                    conn.rollback();
            }
        } catch (SQLException e) {
        }
        return false;
    }

    public boolean devolverConValidacion(int idLibro, int idUsuario) {
        String sqlPre = "UPDATE prestamos SET fecha_devolucion = CURRENT_DATE, estado = 'ENTREGADO' " +
                "WHERE id_libro = ? AND id_usuario = ? AND fecha_devolucion IS NULL";
        String sqlVin = "UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles + 1 WHERE id_libro = ?";

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

    public boolean terminarPrestamoAdmin(int idPrestamo) {
        String sqlPre = "UPDATE prestamos SET fecha_devolucion = CURRENT_DATE, estado = 'ENTREGADO' WHERE id_prestamo = ? AND fecha_devolucion IS NULL";
        String sqlVin = "UPDATE libros SET ejemplares_disponibles = ejemplares_disponibles + 1 WHERE id_libro = (SELECT id_libro FROM prestamos WHERE id_prestamo = ?)";
        Connection conn = null;
        try {
            conn = ConexionBD.obtenerConexion();
            conn.setAutoCommit(false);
            try (PreparedStatement psP = conn.prepareStatement(sqlPre);
                    PreparedStatement psV = conn.prepareStatement(sqlVin)) {

                psP.setInt(1, idPrestamo);

                if (psP.executeUpdate() > 0) {
                    psV.setInt(1, idPrestamo);
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
        String sql = "SELECT p.*, l.titulo FROM prestamos p " +
                "JOIN libros l ON p.id_libro = l.id_libro " +
                "WHERE p.id_usuario = ? AND p.fecha_devolucion IS NULL";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = new Prestamo();
                p.setIdPrestamo(rs.getInt("id_prestamo"));
                p.setIdLibro(rs.getInt("id_libro"));
                p.setTituloLibro(rs.getString("titulo"));
                p.setFechaPrestamo(rs.getDate("fecha_prestamo"));
                p.setEstado(rs.getString("estado"));
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Prestamo> listarHistorialPorUsuario(int idUsuario) {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, l.titulo FROM prestamos p " +
                "JOIN libros l ON p.id_libro = l.id_libro " +
                "WHERE p.id_usuario = ? AND p.fecha_devolucion IS NOT NULL " +
                "ORDER BY p.fecha_devolucion DESC";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idUsuario);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prestamo p = new Prestamo();
                p.setIdPrestamo(rs.getInt("id_prestamo"));
                p.setIdLibro(rs.getInt("id_libro"));
                p.setTituloLibro(rs.getString("titulo"));
                p.setFechaPrestamo(rs.getDate("fecha_prestamo"));
                p.setFechaDevolucion(rs.getDate("fecha_devolucion"));
                p.setEstado(rs.getString("estado"));
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Prestamo> listarTodosActivos() {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, l.titulo, l.autor, l.isbn, u.nombre, u.apellido, u.email " +
                "FROM prestamos p " +
                "JOIN libros l ON p.id_libro = l.id_libro " +
                "LEFT JOIN usuarios u ON p.id_usuario = u.id_usuario " +
                "WHERE p.fecha_devolucion IS NULL ORDER BY p.fecha_prestamo DESC";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Prestamo p = new Prestamo();
                p.setIdPrestamo(rs.getInt("id_prestamo"));
                p.setIsbn(rs.getString("isbn"));
                p.setTituloLibro(rs.getString("titulo"));
                p.setAutor(rs.getString("autor"));
                p.setEstado(rs.getString("estado"));

                Object idUsuarioObj = rs.getObject("id_usuario");
                if (idUsuarioObj == null) {
                    p.setNombreUsuario(rs.getString("nombre_manual"));
                    p.setApellidoUsuario(rs.getString("apellido_manual"));
                    p.setIdUsuario(0);
                } else {
                    p.setIdUsuario(rs.getInt("id_usuario"));
                    p.setNombreUsuario(rs.getString("nombre"));
                    p.setApellidoUsuario(rs.getString("apellido"));
                    p.setEmailUsuario(rs.getString("email"));
                }
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<Prestamo> listarTodosHistorial() {
        List<Prestamo> lista = new ArrayList<>();
        String sql = "SELECT p.*, l.titulo, l.autor, l.isbn, u.nombre, u.apellido, u.email " +
                "FROM prestamos p " +
                "JOIN libros l ON p.id_libro = l.id_libro " +
                "LEFT JOIN usuarios u ON p.id_usuario = u.id_usuario " +
                "WHERE p.fecha_devolucion IS NOT NULL ORDER BY p.fecha_devolucion DESC";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Prestamo p = new Prestamo();
                p.setIdPrestamo(rs.getInt("id_prestamo"));
                p.setIsbn(rs.getString("isbn"));
                p.setTituloLibro(rs.getString("titulo"));
                p.setAutor(rs.getString("autor"));
                p.setEstado(rs.getString("estado"));
                p.setFechaPrestamo(rs.getDate("fecha_prestamo"));
                p.setFechaDevolucion(rs.getDate("fecha_devolucion"));

                Object idUsuarioObj = rs.getObject("id_usuario");
                if (idUsuarioObj == null) {
                    p.setNombreUsuario(rs.getString("nombre_manual"));
                    p.setApellidoUsuario(rs.getString("apellido_manual"));
                } else {
                    p.setIdUsuario(rs.getInt("id_usuario"));
                    p.setNombreUsuario(rs.getString("nombre"));
                    p.setApellidoUsuario(rs.getString("apellido"));
                    p.setEmailUsuario(rs.getString("email"));
                }
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}
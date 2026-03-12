package cl.biblioteca.digital.dao;

import cl.biblioteca.digital.model.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UsuarioDAO {

    public Usuario validarUsuario(String email, String password) {
        Usuario usuario = null;
        String sql = "SELECT id_usuario, nombre, apellido, carrera, cargo, email, password, rol FROM usuarios WHERE email = ? AND password = ?";

        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    usuario = new Usuario();
                    usuario.setIdUsuario(rs.getInt("id_usuario"));
                    usuario.setNombre(rs.getString("nombre"));
                    usuario.setApellido(rs.getString("apellido"));
                    usuario.setCarrera(rs.getString("carrera"));
                    usuario.setCargo(rs.getString("cargo"));
                    usuario.setEmail(rs.getString("email"));
                    usuario.setPassword(rs.getString("password"));
                    usuario.setRol(rs.getString("rol"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return usuario;
    }

    public boolean actualizarPerfil(int idUsuario, String nombre, String apellido, String password, String carrera) {
        String sql = "UPDATE usuarios SET nombre = ?, apellido = ?, password = ?, carrera = ? WHERE id_usuario = ?";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, nombre);
            ps.setString(2, apellido);
            ps.setString(3, password);
            ps.setString(4, carrera);
            ps.setInt(5, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean registrarUsuario(Usuario u) {
        String sql = "INSERT INTO usuarios (nombre, apellido, email, password, rol, carrera, cargo) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = ConexionBD.obtenerConexion();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getNombre());
            ps.setString(2, u.getApellido());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getPassword());
            ps.setString(5, u.getRol());
            ps.setString(6, u.getCarrera());
            ps.setString(7, u.getCargo());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
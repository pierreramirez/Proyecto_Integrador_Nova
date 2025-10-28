package DAO;

import Persistencia.Conexion;
import Modelo.DTOLugar;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOLugar {

    // Listar todos (para dropdowns)
    public List<DTOLugar> listAll() throws SQLException {
        List<DTOLugar> lista = new ArrayList<>();
        String sql = "SELECT idLugar, nombre, estado FROM lugares WHERE estado = 1 ORDER BY nombre";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DTOLugar l = new DTOLugar();
                l.setId(rs.getInt("idLugar"));
                l.setNombre(rs.getString("nombre"));
                l.setEstado(rs.getInt("estado"));
                lista.add(l);
            }
        }
        return lista;
    }

    // Obtener por id
    public DTOLugar getById(int id) throws SQLException {
        String sql = "SELECT idLugar, nombre, estado FROM lugares WHERE idLugar = ?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DTOLugar l = new DTOLugar();
                    l.setId(rs.getInt("idLugar"));
                    l.setNombre(rs.getString("nombre"));
                    l.setEstado(rs.getInt("estado"));
                    return l;
                }
            }
        }
        return null;
    }

    // Crear
    public int crearLugar(DTOLugar l) throws SQLException {
        String sql = "INSERT INTO lugares (nombre, estado) VALUES (?, ?)";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, l.getNombre());
            ps.setInt(2, l.getEstado());
            int aff = ps.executeUpdate();
            if (aff == 0) return -1;
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getInt(1);
            }
        }
        return -1;
    }

    // Actualizar
    public boolean updateLugar(DTOLugar l) throws SQLException {
        String sql = "UPDATE lugares SET nombre = ?, estado = ? WHERE idLugar = ?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, l.getNombre());
            ps.setInt(2, l.getEstado());
            ps.setInt(3, l.getId());
            return ps.executeUpdate() == 1;
        }
    }

    // Borrar (o mejor: desactivar)
    public boolean deleteLugar(int id) throws SQLException {
        // opción: soft delete -> SET estado = 0
        String sql = "UPDATE lugares SET estado = 0 WHERE idLugar = ?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() == 1;
        }
    }
}

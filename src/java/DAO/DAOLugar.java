package DAO;

import Modelo.DTOLugar;
import Persistencia.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOLugar {

    private Conexion cn = new Conexion();

    public int crearLugar(DTOLugar l) throws SQLException {
        String sql = "INSERT INTO lugar (nombre, descripcion, tipo, estado) VALUES (?, ?, ?, ?)";
        Connection con = cn.getConnection(); // NO cerrar esta conexión aquí
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, l.getNombre());
            ps.setString(2, l.getDescripcion());
            ps.setString(3, l.getTipo());
            ps.setInt(4, l.getEstado());
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return -1;
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException ignore) {
            }
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
            // NO cerrar 'con' porque lo gestiona Persistencia.Conexion
        }
    }

    public boolean actualizarLugar(DTOLugar l) throws SQLException {
        String sql = "UPDATE lugar SET nombre = ?, descripcion = ?, tipo = ?, estado = ? WHERE idLugar = ?";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setString(1, l.getNombre());
            ps.setString(2, l.getDescripcion());
            ps.setString(3, l.getTipo());
            ps.setInt(4, l.getEstado());
            ps.setInt(5, l.getIdLugar());
            return ps.executeUpdate() > 0;
        } finally {
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
        }
    }

    public boolean eliminarLugar(int idLugar) throws SQLException {
        String sql = "DELETE FROM lugar WHERE idLugar = ?";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, idLugar);
            return ps.executeUpdate() > 0;
        } finally {
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
        }
    }

    public DTOLugar obtenerPorId(int idLugar) throws SQLException {
        String sql = "SELECT * FROM lugar WHERE idLugar = ?";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, idLugar);
            rs = ps.executeQuery();
            if (rs.next()) {
                DTOLugar l = new DTOLugar();
                l.setIdLugar(rs.getInt("idLugar"));
                l.setNombre(rs.getString("nombre"));
                l.setDescripcion(rs.getString("descripcion"));
                l.setTipo(rs.getString("tipo"));
                l.setEstado(rs.getInt("estado"));
                return l;
            }
            return null;
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException ignore) {
            }
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
        }
    }

    public List<DTOLugar> listarTodos() throws SQLException {
        String sql = "SELECT * FROM lugar ORDER BY nombre";
        List<DTOLugar> lista = new ArrayList<>();
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                DTOLugar l = new DTOLugar();
                l.setIdLugar(rs.getInt("idLugar"));
                l.setNombre(rs.getString("nombre"));
                l.setDescripcion(rs.getString("descripcion"));
                l.setTipo(rs.getString("tipo"));
                l.setEstado(rs.getInt("estado"));
                lista.add(l);
            }
            return lista;
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException ignore) {
            }
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
        }
    }

    public List<DTOLugar> listarActivos() throws SQLException {
        String sql = "SELECT * FROM lugar WHERE estado = 1 ORDER BY nombre";
        List<DTOLugar> lista = new ArrayList<>();
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                DTOLugar l = new DTOLugar();
                l.setIdLugar(rs.getInt("idLugar"));
                l.setNombre(rs.getString("nombre"));
                l.setDescripcion(rs.getString("descripcion"));
                l.setTipo(rs.getString("tipo"));
                l.setEstado(rs.getInt("estado"));
                lista.add(l);
            }
            return lista;
        } finally {
            if (rs != null) try {
                rs.close();
            } catch (SQLException ignore) {
            }
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
        }
    }
}

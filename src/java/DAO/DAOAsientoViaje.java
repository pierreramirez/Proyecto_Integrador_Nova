package DAO;

import Modelo.DTOAsientoViaje;
import Persistencia.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOAsientoViaje {

    private Conexion cn = new Conexion();

    public void generarAsientos(int idViaje, int capacidad, double precio) throws SQLException {
        String sql = "INSERT INTO asiento_viaje (idViaje, numeroAsiento, estado, precio) VALUES (?, ?, 0, ?)";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sql);
            for (int i = 1; i <= capacidad; i++) {
                ps.setInt(1, idViaje);
                ps.setInt(2, i);
                ps.setDouble(3, precio);
                ps.addBatch();
            }
            ps.executeBatch();
        } finally {
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
        }
    }

    /**
     * Lista todos los asientos de un viaje (incluye estado y precio).
     */
    public List<DTOAsientoViaje> listarAsientosPorViaje(int idViaje) throws SQLException {
        List<DTOAsientoViaje> lista = new ArrayList<>();
        String sql = "SELECT idAsientoViaje, idViaje, numeroAsiento, estado, precio FROM asiento_viaje WHERE idViaje = ? ORDER BY numeroAsiento";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, idViaje);
            rs = ps.executeQuery();
            while (rs.next()) {
                DTOAsientoViaje a = new DTOAsientoViaje();
                a.setIdAsientoViaje(rs.getInt("idAsientoViaje"));
                a.setIdViaje(rs.getInt("idViaje"));
                a.setNumeroAsiento(rs.getInt("numeroAsiento"));
                a.setEstado(rs.getInt("estado"));
                a.setPrecio(rs.getDouble("precio"));
                lista.add(a);
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

    /**
     * Actualiza el estado de un asiento (0,1,2)
     */
    public boolean actualizarEstadoAsiento(int idAsientoViaje, int nuevoEstado) throws SQLException {
        String sql = "UPDATE asiento_viaje SET estado = ? WHERE idAsientoViaje = ?";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, nuevoEstado);
            ps.setInt(2, idAsientoViaje);
            return ps.executeUpdate() > 0;
        } finally {
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
        }
    }
}

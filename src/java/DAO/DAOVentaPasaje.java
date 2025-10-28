package DAO;

import Persistencia.Conexion;
import Modelo.DTOVentaPasaje;

import java.sql.*;
import java.util.*;

public class DAOVentaPasaje {

    // Crear venta (retorna id generado o -1)
    public int crearVentaPasaje(DTOVentaPasaje v) throws SQLException {
        String sql = "INSERT INTO venta_pasaje (idViaje, idCliente, asiento, fechaCompra, creador, fechaCreacion, estado) VALUES (?, ?, ?, NOW(), ?, NOW(), ?)";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, v.getIdViaje());
            ps.setInt(2, v.getIdCliente());
            ps.setInt(3, v.getAsiento());
            if (v.getCreador() != null) ps.setInt(4, v.getCreador()); else ps.setNull(4, Types.INTEGER);
            ps.setInt(5, v.getEstado() == null ? 1 : v.getEstado());
            int affected = ps.executeUpdate();
            if (affected == 0) return -1;
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) {
                    int id = gk.getInt(1);
                    v.setIdPasaje(id);
                    return id;
                }
            }
        }
        return -1;
    }

    // Obtener venta por id
    public DTOVentaPasaje getVentaById(int idPasaje) throws SQLException {
        String sql = "SELECT * FROM venta_pasaje WHERE idPasaje = ?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idPasaje);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToVenta(rs);
            }
        }
        return null;
    }

    // Listar ventas por viaje
    public List<DTOVentaPasaje> listarVentasPorViaje(int idViaje) throws SQLException {
        List<DTOVentaPasaje> list = new ArrayList<>();
        String sql = "SELECT * FROM venta_pasaje WHERE idViaje = ?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idViaje);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRowToVenta(rs));
            }
        }
        return list;
    }

    // Listar ventas por cliente
    public List<DTOVentaPasaje> listarVentasPorCliente(int idCliente) throws SQLException {
        List<DTOVentaPasaje> list = new ArrayList<>();
        String sql = "SELECT * FROM venta_pasaje WHERE idCliente = ?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRowToVenta(rs));
            }
        }
        return list;
    }

    // Obtener asientos ya vendidos (estado = 1)
    public Set<Integer> getAsientosVendidos(int idViaje) throws SQLException {
        Set<Integer> vendidos = new HashSet<>();
        String sql = "SELECT asiento FROM venta_pasaje WHERE idViaje = ? AND estado = 1";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idViaje);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) vendidos.add(rs.getInt("asiento"));
            }
        }
        return vendidos;
    }

    // Método transaccional seguro para reservar un asiento:
    // Bloquea la fila de ruta_viaje (FOR UPDATE), verifica boletos, intenta insertar, decrementa boletos.
    // Retorna true si la reserva se confirma, false si no (sin lanzar excepción en casos lógicos).
    public boolean reservarAsientoSeguro(int idViaje, int idCliente, int asiento, int creador) throws SQLException {
        String lockSql = "SELECT boletosRestantes FROM ruta_viaje WHERE idViaje = ? FOR UPDATE";
        String insertSql = "INSERT INTO venta_pasaje (idViaje, idCliente, asiento, fechaCompra, creador, fechaCreacion, estado) VALUES (?, ?, ?, NOW(), ?, NOW(), 1)";
        String updateRuta = "UPDATE ruta_viaje SET boletosRestantes = boletosRestantes - 1 WHERE idViaje = ? AND boletosRestantes > 0";

        Connection conn = null;
        try {
            conn = new Conexion().getConnection();
            conn.setAutoCommit(false);

            // 1) Bloquear fila de ruta_viaje
            try (PreparedStatement psLock = conn.prepareStatement(lockSql)) {
                psLock.setInt(1, idViaje);
                try (ResultSet rs = psLock.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false; // ruta no existe
                    }
                    int disponibles = rs.getInt("boletosRestantes");
                    if (disponibles <= 0) {
                        conn.rollback();
                        return false; // no hay boletos
                    }
                }
            }

            // 2) Intentar insertar venta (puede fallar por unique constraint)
            try (PreparedStatement psIns = conn.prepareStatement(insertSql)) {
                psIns.setInt(1, idViaje);
                psIns.setInt(2, idCliente);
                psIns.setInt(3, asiento);
                psIns.setInt(4, creador);
                psIns.executeUpdate();
            }

            // 3) Decrementar boletosRestantes
            try (PreparedStatement psUp = conn.prepareStatement(updateRuta)) {
                psUp.setInt(1, idViaje);
                int updated = psUp.executeUpdate();
                if (updated != 1) {
                    conn.rollback();
                    return false;
                }
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { /* log si quieres */ }
            throw e; // el servlet debe manejar Duplicate Key o errores
        } finally {
            if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { /* log */ }
        }
    }

    // Cancelar venta (cambia estado a 2)
    public boolean cancelarVenta(int idPasaje) throws SQLException {
        String sql = "UPDATE venta_pasaje SET estado = 2 WHERE idPasaje = ?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idPasaje);
            return ps.executeUpdate() == 1;
        }
    }

    // Mapeador privado
    private DTOVentaPasaje mapRowToVenta(ResultSet rs) throws SQLException {
        DTOVentaPasaje v = new DTOVentaPasaje();
        v.setIdPasaje(rs.getInt("idPasaje"));
        v.setIdViaje(rs.getInt("idViaje"));
        v.setIdCliente(rs.getInt("idCliente"));
        v.setAsiento(rs.getInt("asiento"));
        v.setFechaCompra(rs.getTimestamp("fechaCompra"));
        try { v.setCreador((Integer) rs.getObject("creador")); } catch (Exception ex) { v.setCreador(null); }
        v.setFechaCreacion(rs.getTimestamp("fechaCreacion"));
        v.setEstado(rs.getInt("estado"));
        return v;
    }
}

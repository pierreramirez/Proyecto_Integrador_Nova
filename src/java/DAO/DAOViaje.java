package DAO;

import Modelo.DTOViaje;
import Persistencia.Conexion;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOViaje {

    private Conexion cn = new Conexion();

    public int crearViaje(DTOViaje v) throws SQLException {
        String sql = "INSERT INTO viaje (idBus, idChofer, origen_id, destino_id, fechaSalida, horaSalida, duracionMin, precio, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, v.getIdBus());
            ps.setInt(2, v.getIdChofer());
            ps.setInt(3, v.getOrigen_id());
            ps.setInt(4, v.getDestino_id());
            ps.setDate(5, v.getFechaSalida());
            ps.setTime(6, v.getHoraSalida());
            if (v.getDuracionMin() != null) {
                ps.setInt(7, v.getDuracionMin());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setDouble(8, v.getPrecio());
            ps.setInt(9, v.getEstado());
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
        }
    }

    /**
     * Listar todos los viajes e incluir la cantidad de asientos disponibles
     * (estado = 0)
     */
    public List<DTOViaje> listarTodos() throws SQLException {
        String sql = "SELECT v.*, "
                + "(SELECT COUNT(*) FROM asiento_viaje a WHERE a.idViaje = v.idViaje AND a.estado = 0) AS disponibles "
                + "FROM viaje v ORDER BY v.fechaSalida, v.horaSalida";
        List<DTOViaje> lista = new ArrayList<>();
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                DTOViaje v = new DTOViaje();
                v.setIdViaje(rs.getInt("idViaje"));
                v.setIdBus(rs.getInt("idBus"));
                v.setIdChofer(rs.getInt("idChofer"));
                v.setOrigen_id(rs.getInt("origen_id"));
                v.setDestino_id(rs.getInt("destino_id"));
                v.setFechaSalida(rs.getDate("fechaSalida"));
                v.setHoraSalida(rs.getTime("horaSalida"));

                // duracionMin puede ser NULL -> usar wasNull para diferenciar 0 vs null
                int dur = rs.getInt("duracionMin");
                if (rs.wasNull()) {
                    v.setDuracionMin(null);
                } else {
                    v.setDuracionMin(dur);
                }

                v.setPrecio(rs.getDouble("precio"));
                v.setEstado(rs.getInt("estado"));

                // disponibles (subconsulta)
                v.setDisponibles(rs.getInt("disponibles"));

                lista.add(v);
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

    public DTOViaje obtenerPorId(int idViaje) throws SQLException {
        String sql = "SELECT v.*, "
                + "(SELECT COUNT(*) FROM asiento_viaje a WHERE a.idViaje = v.idViaje AND a.estado = 0) AS disponibles "
                + "FROM viaje v WHERE v.idViaje = ?";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, idViaje);
            rs = ps.executeQuery();
            if (rs.next()) {
                DTOViaje v = new DTOViaje();
                v.setIdViaje(rs.getInt("idViaje"));
                v.setIdBus(rs.getInt("idBus"));
                v.setIdChofer(rs.getInt("idChofer"));
                v.setOrigen_id(rs.getInt("origen_id"));
                v.setDestino_id(rs.getInt("destino_id"));
                v.setFechaSalida(rs.getDate("fechaSalida"));
                v.setHoraSalida(rs.getTime("horaSalida"));
                int dur = rs.getInt("duracionMin");
                if (rs.wasNull()) {
                    v.setDuracionMin(null);
                } else {
                    v.setDuracionMin(dur);
                }
                v.setPrecio(rs.getDouble("precio"));
                v.setEstado(rs.getInt("estado"));
                v.setDisponibles(rs.getInt("disponibles"));
                return v;
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

    public boolean actualizarViaje(DTOViaje v) throws SQLException {
        String sql = "UPDATE viaje SET idBus=?, idChofer=?, origen_id=?, destino_id=?, fechaSalida=?, horaSalida=?, duracionMin=?, precio=?, estado=? WHERE idViaje=?";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, v.getIdBus());
            ps.setInt(2, v.getIdChofer());
            ps.setInt(3, v.getOrigen_id());
            ps.setInt(4, v.getDestino_id());
            ps.setDate(5, v.getFechaSalida());
            ps.setTime(6, v.getHoraSalida());
            if (v.getDuracionMin() != null) {
                ps.setInt(7, v.getDuracionMin());
            } else {
                ps.setNull(7, Types.INTEGER);
            }
            ps.setDouble(8, v.getPrecio());
            ps.setInt(9, v.getEstado());
            ps.setInt(10, v.getIdViaje());
            return ps.executeUpdate() > 0;
        } finally {
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
        }
    }

    public boolean eliminarViaje(int idViaje) throws SQLException {
        String sql = "DELETE FROM viaje WHERE idViaje = ?";
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, idViaje);
            return ps.executeUpdate() > 0;
        } finally {
            if (ps != null) try {
                ps.close();
            } catch (SQLException ignore) {
            }
        }
    }

    // consulta para la vista cliente, ver viajes por destino+origen (incluye disponibles)
    public List<DTOViaje> listarPorDestinoOrigen(int destino, int origen) throws SQLException {
        String sql = "SELECT v.*, "
                + "(SELECT COUNT(*) FROM asiento_viaje a WHERE a.idViaje = v.idViaje AND a.estado = 0) AS disponibles "
                + "FROM viaje v WHERE destino_id = ? AND origen_id = ? AND estado = 1 AND fechaSalida >= CURDATE() ORDER BY fechaSalida, horaSalida";
        List<DTOViaje> lista = new ArrayList<>();
        Connection con = cn.getConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = con.prepareStatement(sql);
            ps.setInt(1, destino);
            ps.setInt(2, origen);
            rs = ps.executeQuery();
            while (rs.next()) {
                DTOViaje v = new DTOViaje();
                v.setIdViaje(rs.getInt("idViaje"));
                v.setIdBus(rs.getInt("idBus"));
                v.setIdChofer(rs.getInt("idChofer"));
                v.setOrigen_id(rs.getInt("origen_id"));
                v.setDestino_id(rs.getInt("destino_id"));
                v.setFechaSalida(rs.getDate("fechaSalida"));
                v.setHoraSalida(rs.getTime("horaSalida"));
                int dur = rs.getInt("duracionMin");
                if (rs.wasNull()) {
                    v.setDuracionMin(null);
                } else {
                    v.setDuracionMin(dur);
                }
                v.setPrecio(rs.getDouble("precio"));
                v.setEstado(rs.getInt("estado"));
                v.setDisponibles(rs.getInt("disponibles"));
                lista.add(v);
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
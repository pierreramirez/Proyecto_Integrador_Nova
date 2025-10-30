package DAO;

import Modelo.DTOViaje;
import Persistencia.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOViaje {

    private final Conexion cn = new Conexion();

    // --- Helper para cerrar silenciosamente ---
    private void closeQuiet(AutoCloseable c) {
        if (c != null) {
            try {
                c.close();
            } catch (Exception ignored) {
            }
        }
    }

    // Holder para saber si debemos cerrar la connection (cuando fue creada temporalmente)
    private static class ConnHolder {

        Connection con;
        boolean closeAfter;

        ConnHolder(Connection con, boolean closeAfter) {
            this.con = con;
            this.closeAfter = closeAfter;
        }
    }

    /**
     * Obtiene una Connection válida. Si la conexión compartida está cerrada
     * crea una Conexion temporal y marca closeAfter=true para cerrarla luego.
     */
    private ConnHolder obtainConnection() throws SQLException {
        Connection con = cn.getConnection();
        try {
            if (con != null && !con.isClosed() && con.isValid(2)) {
                return new ConnHolder(con, false);
            } else {
                // conexión compartida inválida, crear temporal
                Conexion tmp = new Conexion();
                Connection t = tmp.getConnection();
                if (t == null) {
                    throw new SQLException("No se pudo obtener conexión temporal.");
                }
                return new ConnHolder(t, true);
            }
        } catch (SQLException ex) {
            // fallback: intentar crear temporal
            Conexion tmp = new Conexion();
            Connection t = tmp.getConnection();
            if (t == null) {
                throw ex;
            }
            return new ConnHolder(t, true);
        }
    }

    // --- Mapeo flexible del ResultSet al DTO (acepta varias convenciones de columna) ---
    private boolean hasColumn(ResultSet rs, String colName) {
        try {
            ResultSetMetaData md = rs.getMetaData();
            int cols = md.getColumnCount();
            for (int i = 1; i <= cols; i++) {
                String label = md.getColumnLabel(i);
                if (label == null || label.isEmpty()) {
                    label = md.getColumnName(i);
                }
                if (colName.equalsIgnoreCase(label)) {
                    return true;
                }
            }
        } catch (SQLException e) {
            // ignorar
        }
        return false;
    }

    private DTOViaje mapResultSetToDTOViaje(ResultSet rs) throws SQLException {
        DTOViaje v = new DTOViaje();

        if (hasColumn(rs, "idViaje")) {
            v.setIdViaje(rs.getInt("idViaje"));
        } else if (hasColumn(rs, "id_viaje")) {
            v.setIdViaje(rs.getInt("id_viaje"));
        }

        if (hasColumn(rs, "idBus")) {
            v.setIdBus(rs.getInt("idBus"));
        } else if (hasColumn(rs, "id_bus")) {
            v.setIdBus(rs.getInt("id_bus"));
        }

        if (hasColumn(rs, "idChofer")) {
            v.setIdChofer(rs.getInt("idChofer"));
        } else if (hasColumn(rs, "id_chofer")) {
            v.setIdChofer(rs.getInt("id_chofer"));
        }

        if (hasColumn(rs, "origen")) {
            v.setOrigen_id(rs.getInt("origen"));
        } else if (hasColumn(rs, "origen_id")) {
            v.setOrigen_id(rs.getInt("origen_id"));
        }

        if (hasColumn(rs, "destino")) {
            v.setDestino_id(rs.getInt("destino"));
        } else if (hasColumn(rs, "destino_id")) {
            v.setDestino_id(rs.getInt("destino_id"));
        }

        if (hasColumn(rs, "fechaSalida")) {
            v.setFechaSalida(rs.getDate("fechaSalida"));
        } else if (hasColumn(rs, "fecha_salida")) {
            v.setFechaSalida(rs.getDate("fecha_salida"));
        }

        if (hasColumn(rs, "horaSalida")) {
            v.setHoraSalida(rs.getTime("horaSalida"));
        } else if (hasColumn(rs, "hora_salida")) {
            v.setHoraSalida(rs.getTime("hora_salida"));
        }

        if (hasColumn(rs, "duracionMin")) {
            int dur = rs.getInt("duracionMin");
            v.setDuracionMin(rs.wasNull() ? null : dur);
        } else if (hasColumn(rs, "duracion_min")) {
            int dur = rs.getInt("duracion_min");
            v.setDuracionMin(rs.wasNull() ? null : dur);
        } else if (hasColumn(rs, "duracion")) {
            int dur = rs.getInt("duracion");
            v.setDuracionMin(rs.wasNull() ? null : dur);
        }

        if (hasColumn(rs, "precio")) {
            v.setPrecio(rs.getDouble("precio"));
        } else if (hasColumn(rs, "price")) {
            v.setPrecio(rs.getDouble("price"));
        }

        if (hasColumn(rs, "estado")) {
            v.setEstado(rs.getInt("estado"));
        } else if (hasColumn(rs, "id_estado")) {
            v.setEstado(rs.getInt("id_estado"));
        }

        if (hasColumn(rs, "disponibles")) {
            v.setDisponibles(rs.getInt("disponibles"));
        } else if (hasColumn(rs, "boletosRestantes")) {
            v.setDisponibles(rs.getInt("boletosRestantes"));
        }

        return v;
    }

    // ----------------- CRUD y consultas -----------------
    public int crearViaje(DTOViaje v) throws SQLException {
        String sql = "INSERT INTO viaje (idBus, idChofer, origen_id, destino_id, fechaSalida, horaSalida, duracionMin, precio, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        ConnHolder h = obtainConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = h.con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
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
            closeQuiet(rs);
            closeQuiet(ps);
            if (h.closeAfter) {
                closeQuiet(h.con);
            }
        }
    }

    public List<DTOViaje> listarTodos() throws SQLException {
        List<DTOViaje> lista = new ArrayList<>();
        String sql = "SELECT v.*, (SELECT COUNT(*) FROM asiento_viaje a WHERE a.idViaje = v.idViaje AND a.estado = 0) AS disponibles FROM viaje v ORDER BY v.fechaSalida, v.horaSalida";

        ConnHolder h = obtainConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = h.con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapResultSetToDTOViaje(rs));
            }
        } finally {
            closeQuiet(rs);
            closeQuiet(ps);
            if (h.closeAfter) {
                closeQuiet(h.con);
            }
        }
        return lista;
    }

    public DTOViaje obtenerPorId(int idViaje) throws SQLException {
        String sql = "SELECT v.*, (SELECT COUNT(*) FROM asiento_viaje a WHERE a.idViaje = v.idViaje AND a.estado = 0) AS disponibles FROM viaje v WHERE v.idViaje = ?";
        ConnHolder h = obtainConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = h.con.prepareStatement(sql);
            ps.setInt(1, idViaje);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDTOViaje(rs);
            }
        } finally {
            closeQuiet(rs);
            closeQuiet(ps);
            if (h.closeAfter) {
                closeQuiet(h.con);
            }
        }
        return null;
    }

    /**
     * Lista viajes por destino (usa 'destino_id' si existe; si falla intenta
     * 'destino')
     */
    public List<DTOViaje> listarPorDestino(int destino) throws SQLException {
        List<DTOViaje> lista = new ArrayList<>();

        // Intento con destino_id
        String sql1 = "SELECT v.*, (SELECT COUNT(*) FROM asiento_viaje a WHERE a.idViaje = v.idViaje AND a.estado = 0) AS disponibles "
                + "FROM viaje v WHERE v.destino_id = ? AND v.estado = 1 AND v.fechaSalida >= CURDATE() ORDER BY v.fechaSalida, v.horaSalida";

        ConnHolder h = obtainConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = h.con.prepareStatement(sql1);
            ps.setInt(1, destino);
            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapResultSetToDTOViaje(rs));
            }
        } catch (SQLException ex) {
            // si la columna destino_id no existe, intentar con destino
            System.out.println("listarPorDestino: fallo con destino_id, intentando columna 'destino' -> " + ex.getMessage());
            closeQuiet(rs);
            closeQuiet(ps);
            if (h.closeAfter) {
                closeQuiet(h.con);
            }

            String sql2 = "SELECT v.*, (SELECT COUNT(*) FROM asiento_viaje a WHERE a.idViaje = v.idViaje AND a.estado = 0) AS disponibles "
                    + "FROM viaje v WHERE v.destino = ? AND v.estado = 1 AND v.fechaSalida >= CURDATE() ORDER BY v.fechaSalida, v.horaSalida";
            ConnHolder h2 = obtainConnection();
            try {
                ps = h2.con.prepareStatement(sql2);
                ps.setInt(1, destino);
                rs = ps.executeQuery();
                while (rs.next()) {
                    lista.add(mapResultSetToDTOViaje(rs));
                }
            } finally {
                closeQuiet(rs);
                closeQuiet(ps);
                if (h2.closeAfter) {
                    closeQuiet(h2.con);
                }
            }
            // devolver lo que se encontró en la segunda consulta (aunque sea vacío)
            return lista;
        } finally {
            // normal close for first attempt (if it succeeded)
            closeQuiet(rs);
            closeQuiet(ps);
            if (h.closeAfter) {
                closeQuiet(h.con);
            }
        }

        // **IMPORTANTE**: devolver lista (incluso si está vacía)
        return lista;
    }

    public boolean actualizarViaje(DTOViaje v) throws SQLException {
        String sql = "UPDATE viaje SET idBus=?, idChofer=?, origen_id=?, destino_id=?, fechaSalida=?, horaSalida=?, duracionMin=?, precio=?, estado=? WHERE idViaje=?";
        ConnHolder h = obtainConnection();
        PreparedStatement ps = null;
        try {
            ps = h.con.prepareStatement(sql);
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
            closeQuiet(ps);
            if (h.closeAfter) {
                closeQuiet(h.con);
            }
        }
    }

    public boolean eliminarViaje(int idViaje) throws SQLException {
        String sql = "DELETE FROM viaje WHERE idViaje = ?";
        ConnHolder h = obtainConnection();
        PreparedStatement ps = null;
        try {
            ps = h.con.prepareStatement(sql);
            ps.setInt(1, idViaje);
            return ps.executeUpdate() > 0;
        } finally {
            closeQuiet(ps);
            if (h.closeAfter) {
                closeQuiet(h.con);
            }
        }
    }

    /**
     * Lista por destino y origen (intenta columnas destino_id/origen_id; si
     * fallan intenta destino/origen)
     */
    public List<DTOViaje> listarPorDestinoOrigen(int destino, int origen) throws SQLException {
        List<DTOViaje> lista = new ArrayList<>();
        String sql1 = "SELECT v.*, (SELECT COUNT(*) FROM asiento_viaje a WHERE a.idViaje = v.idViaje AND a.estado = 0) AS disponibles FROM viaje v WHERE v.destino_id = ? AND v.origen_id = ? AND v.estado = 1 AND v.fechaSalida >= CURDATE() ORDER BY v.fechaSalida, v.horaSalida";

        ConnHolder h = obtainConnection();
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            System.out.println("listarPorDestinoOrigen SQL1 params: destino=" + destino + " origen=" + origen);
            ps = h.con.prepareStatement(sql1);
            ps.setInt(1, destino);
            ps.setInt(2, origen);
            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapResultSetToDTOViaje(rs));
            }
        } catch (SQLException ex) {
            System.out.println("listarPorDestinoOrigen: fallo con destino_id/origen_id, intentando destino/origen -> " + ex.getMessage());
            closeQuiet(rs);
            closeQuiet(ps);
            if (h.closeAfter) {
                closeQuiet(h.con);
            }

            String sql2 = "SELECT v.*, (SELECT COUNT(*) FROM asiento_viaje a WHERE a.idViaje = v.idViaje AND a.estado = 0) AS disponibles FROM viaje v WHERE v.destino = ? AND v.origen = ? AND v.estado = 1 AND v.fechaSalida >= CURDATE() ORDER BY v.fechaSalida, v.horaSalida";
            ConnHolder h2 = obtainConnection();
            try {
                System.out.println("listarPorDestinoOrigen SQL2 params: destino=" + destino + " origen=" + origen);
                ps = h2.con.prepareStatement(sql2);
                ps.setInt(1, destino);
                ps.setInt(2, origen);
                rs = ps.executeQuery();
                while (rs.next()) {
                    lista.add(mapResultSetToDTOViaje(rs));
                }
            } finally {
                closeQuiet(rs);
                closeQuiet(ps);
                if (h2.closeAfter) {
                    closeQuiet(h2.con);
                }
            }
            return lista;
        } finally {
            closeQuiet(rs);
            closeQuiet(ps);
            if (h.closeAfter) {
                closeQuiet(h.con);
            }
        }

        // FIX: devolver lista en vez de null
        System.out.println("listarPorDestinoOrigen -> encontrados: " + lista.size());
        return lista;
    }
}

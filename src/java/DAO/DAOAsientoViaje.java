package DAO;

import Modelo.DTOAsientoViaje;
import Persistencia.Conexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO unificado para gestión de asientos por viaje.
 *
 * Ofrece: - generarAsientos - listarAsientosPorViaje - contarDisponibles -
 * obtenerAsientoPorId - reservarAsiento (transaccional con SELECT ... FOR
 * UPDATE, recomendado) - reservarAsientoAtomic (UPDATE condicional por PK) -
 * reservarAsientosTransactional (reserva múltiple dentro de una transacción) -
 * liberarAsiento
 *
 * IMPORTANTE: Ajusta los SQL INSERT/UPDATE a las columnas reales de tu esquema
 * (venta_pasaje, estados, etc.)
 */
public class DAOAsientoViaje {

    /**
     * Genera asientos faltantes hasta la capacidad indicada. Evita duplicados:
     * si ya existen N asientos, crea N+1..capacidad.
     */
    public void generarAsientos(int idViaje, int capacidad, double precio) throws SQLException {
        String countSql = "SELECT COUNT(*) AS cnt FROM asiento_viaje WHERE idViaje = ?";
        String insertSql = "INSERT INTO asiento_viaje (idViaje, numeroAsiento, estado, precio) VALUES (?, ?, 0, ?)";

        Conexion cx = new Conexion();
        try (Connection con = cx.getConnection(); PreparedStatement psCount = con.prepareStatement(countSql)) {

            psCount.setInt(1, idViaje);
            int existentes = 0;
            try (ResultSet rs = psCount.executeQuery()) {
                if (rs.next()) {
                    existentes = rs.getInt("cnt");
                }
            }

            if (existentes >= capacidad) {
                return;
            }

            try (PreparedStatement psInsert = con.prepareStatement(insertSql)) {
                for (int i = existentes + 1; i <= capacidad; i++) {
                    psInsert.setInt(1, idViaje);
                    psInsert.setInt(2, i);
                    psInsert.setDouble(3, precio);
                    psInsert.addBatch();
                }
                psInsert.executeBatch();
            }
        }
    }

    /**
     * Lista todos los asientos de un viaje ordenados por número de asiento.
     */
    public List<DTOAsientoViaje> listarAsientosPorViaje(int idViaje) throws SQLException {
        List<DTOAsientoViaje> lista = new ArrayList<>();
        String sql = "SELECT idAsientoViaje, idViaje, numeroAsiento, estado, precio FROM asiento_viaje WHERE idViaje = ? ORDER BY numeroAsiento";
        Conexion cx = new Conexion();
        try (Connection con = cx.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idViaje);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DTOAsientoViaje a = new DTOAsientoViaje();
                    a.setIdAsientoViaje(rs.getInt("idAsientoViaje"));
                    a.setIdViaje(rs.getInt("idViaje"));
                    a.setNumeroAsiento(rs.getInt("numeroAsiento"));
                    a.setEstado(rs.getInt("estado"));
                    a.setPrecio(rs.getDouble("precio"));
                    lista.add(a);
                }
            }
        }
        return lista;
    }

    /**
     * Cuenta asientos disponibles (estado = 0).
     */
    public int contarDisponibles(int idViaje) throws SQLException {
        String sql = "SELECT COUNT(*) AS cnt FROM asiento_viaje WHERE idViaje = ? AND estado = 0";
        Conexion cx = new Conexion();
        try (Connection con = cx.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idViaje);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cnt");
                }
            }
        }
        return 0;
    }

    /**
     * Obtener asiento por PK idAsientoViaje.
     */
    public DTOAsientoViaje obtenerAsientoPorId(int idAsientoViaje) throws SQLException {
        String sql = "SELECT idAsientoViaje, idViaje, numeroAsiento, estado, precio FROM asiento_viaje WHERE idAsientoViaje = ?";
        Conexion cx = new Conexion();
        try (Connection con = cx.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAsientoViaje);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    DTOAsientoViaje a = new DTOAsientoViaje();
                    a.setIdAsientoViaje(rs.getInt("idAsientoViaje"));
                    a.setIdViaje(rs.getInt("idViaje"));
                    a.setNumeroAsiento(rs.getInt("numeroAsiento"));
                    a.setEstado(rs.getInt("estado"));
                    a.setPrecio(rs.getDouble("precio"));
                    return a;
                }
            }
        }
        return null;
    }

    /**
     * Reservar asiento de forma transaccional por idViaje+numeroAsiento
     * (recomendado). - Bloquea fila con SELECT ... FOR UPDATE - Actualiza
     * asiento a estado = 1 - Inserta registro en venta_pasaje (ajusta columnas
     * según tu esquema)
     *
     * @param idViaje id del viaje
     * @param asientoNum número de asiento (numeroAsiento)
     * @param clienteId id del cliente (que hace la reserva)
     * @return true si se reservó correctamente, false si ya estaba ocupado o no
     * existe
     * @throws SQLException
     */
    public boolean reservarAsiento(int idViaje, int asientoNum, int clienteId) throws SQLException {
        String selectSql = "SELECT idAsientoViaje, estado FROM asiento_viaje WHERE idViaje = ? AND numeroAsiento = ? FOR UPDATE";
        String updateSql = "UPDATE asiento_viaje SET estado = 1 WHERE idAsientoViaje = ?";
        // Ajusta el INSERT a tu tabla venta_pasaje (columnas / tipos)
        String insertVentaSql = "INSERT INTO venta_pasaje (idViaje, idCliente, asiento_num, fechaCompra, estado) VALUES (?, ?, ?, NOW(), 'VENDIDO')";

        Conexion cx = new Conexion();
        try (Connection con = cx.getConnection()) {
            boolean originalAuto = con.getAutoCommit();
            try {
                con.setAutoCommit(false);

                // SELECT FOR UPDATE
                try (PreparedStatement psSel = con.prepareStatement(selectSql)) {
                    psSel.setInt(1, idViaje);
                    psSel.setInt(2, asientoNum);
                    try (ResultSet rs = psSel.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            return false; // asiento no existe
                        }
                        int idAsiento = rs.getInt("idAsientoViaje");
                        int estado = rs.getInt("estado");
                        if (estado != 0) {
                            con.rollback();
                            return false; // ya ocupado
                        }

                        // actualizar asiento
                        try (PreparedStatement psUpd = con.prepareStatement(updateSql)) {
                            psUpd.setInt(1, idAsiento);
                            int u = psUpd.executeUpdate();
                            if (u <= 0) {
                                con.rollback();
                                return false;
                            }
                        }

                        // insertar venta
                        try (PreparedStatement psIns = con.prepareStatement(insertVentaSql)) {
                            psIns.setInt(1, idViaje);
                            psIns.setInt(2, clienteId);
                            psIns.setInt(3, asientoNum);
                            int ins = psIns.executeUpdate();
                            if (ins <= 0) {
                                con.rollback();
                                return false;
                            }
                        }

                        con.commit();
                        return true;
                    }
                }
            } catch (SQLException ex) {
                try {
                    con.rollback();
                } catch (SQLException ignore) {
                }
                throw ex;
            } finally {
                try {
                    con.setAutoCommit(originalAuto);
                } catch (SQLException ignore) {
                }
            }
        }
    }

    /**
     * Reservar asiento por idAsientoViaje de forma atómica (UPDATE ... WHERE
     * estado = 0). Útil cuando ya conoces la PK del asiento.
     */
    public boolean reservarAsientoAtomic(int idAsientoViaje) throws SQLException {
        String sql = "UPDATE asiento_viaje SET estado = 1 WHERE idAsientoViaje = ? AND estado = 0";
        Conexion cx = new Conexion();
        try (Connection con = cx.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            boolean originalAuto = con.getAutoCommit();
            try {
                con.setAutoCommit(false);
                ps.setInt(1, idAsientoViaje);
                int updated = ps.executeUpdate();
                if (updated > 0) {
                    con.commit();
                    return true;
                } else {
                    con.rollback();
                    return false;
                }
            } catch (SQLException ex) {
                try {
                    con.rollback();
                } catch (SQLException ignore) {
                }
                throw ex;
            } finally {
                try {
                    con.setAutoCommit(originalAuto);
                } catch (SQLException ignore) {
                }
            }
        }
    }

    /**
     * Reservar múltiples asientos dentro de una única transacción (todo o
     * nada). Usa SELECT ... FOR UPDATE por cada asiento para bloquear fila,
     * luego actualiza y crea registros en venta_pasaje. Si cualquiera falla,
     * hace rollback.
     *
     * @param asientoIds lista de idAsientoViaje (PKs) a reservar
     * @param clienteId id del cliente que compra
     * @return true si todos se reservaron correctamente, false si algún asiento
     * ya estaba ocupado o error
     * @throws SQLException
     */
    public boolean reservarAsientosTransactional(List<Integer> asientoIds, int clienteId) throws SQLException {
        if (asientoIds == null || asientoIds.isEmpty()) {
            return false;
        }

        // Queries: obtenemos por PK y hacemos FOR UPDATE
        String selectSql = "SELECT idAsientoViaje, idViaje, numeroAsiento, estado FROM asiento_viaje WHERE idAsientoViaje = ? FOR UPDATE";
        String updateSql = "UPDATE asiento_viaje SET estado = 1 WHERE idAsientoViaje = ?";
        String insertVentaSql = "INSERT INTO venta_pasaje (idViaje, idCliente, asiento_num, fechaCompra, estado) VALUES (?, ?, ?, NOW(), 'VENDIDO')";

        Conexion cx = new Conexion();
        try (Connection con = cx.getConnection()) {
            boolean originalAuto = con.getAutoCommit();
            try {
                con.setAutoCommit(false);

                for (Integer idAsiento : asientoIds) {
                    // SELECT FOR UPDATE por PK
                    int idViaje;
                    int asientoNum;
                    int estado;
                    try (PreparedStatement psSel = con.prepareStatement(selectSql)) {
                        psSel.setInt(1, idAsiento);
                        try (ResultSet rs = psSel.executeQuery()) {
                            if (!rs.next()) {
                                con.rollback();
                                return false; // asiento no existe
                            }
                            idViaje = rs.getInt("idViaje");
                            asientoNum = rs.getInt("numeroAsiento");
                            estado = rs.getInt("estado");
                            if (estado != 0) {
                                con.rollback();
                                return false; // alguno ya estaba ocupado
                            }
                        }
                    }

                    // actualizar asiento
                    try (PreparedStatement psUpd = con.prepareStatement(updateSql)) {
                        psUpd.setInt(1, idAsiento);
                        int u = psUpd.executeUpdate();
                        if (u <= 0) {
                            con.rollback();
                            return false;
                        }
                    }

                    // insertar venta (usa idViaje y numeroAsiento obtenidos)
                    try (PreparedStatement psIns = con.prepareStatement(insertVentaSql)) {
                        psIns.setInt(1, idViaje);
                        psIns.setInt(2, clienteId);
                        psIns.setInt(3, asientoNum);
                        int ins = psIns.executeUpdate();
                        if (ins <= 0) {
                            con.rollback();
                            return false;
                        }
                    }
                }

                // Si llegamos aquí, todo OK
                con.commit();
                return true;
            } catch (SQLException ex) {
                try {
                    con.rollback();
                } catch (SQLException ignore) {
                }
                throw ex;
            } finally {
                try {
                    con.setAutoCommit(originalAuto);
                } catch (SQLException ignore) {
                }
            }
        }
    }

    /**
     * Liberar (poner disponible) un asiento por PK idAsientoViaje.
     */
    public boolean liberarAsiento(int idAsientoViaje) throws SQLException {
        String sql = "UPDATE asiento_viaje SET estado = 0 WHERE idAsientoViaje = ?";
        Conexion cx = new Conexion();
        try (Connection con = cx.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idAsientoViaje);
            return ps.executeUpdate() > 0;
        }
    }
}

package DAO;

import Persistencia.Conexion;

import java.sql.*;

public class DAOReserva {

    private final Conexion cn = new Conexion();

    /**
     * Crea una reserva para el asiento indicado. Retorna idReserva (>0) si se
     * creó, 0 si asiento no estaba disponible.
     *
     * Flujo: - SELECT estado FROM asiento_viaje WHERE idAsientoViaje = ? FOR
     * UPDATE - Si estado == 0 -> INSERT INTO reserva(...) RETURN_GENERATED_KEYS
     * - UPDATE asiento_viaje SET estado = 1 WHERE idAsientoViaje = ? - commit
     */
    public int crearReserva(int idViaje, int idAsientoViaje, int idCliente) throws SQLException {
        Connection con = cn.getConnection();
        PreparedStatement psSelect = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;
        ResultSet rs = null;
        ResultSet rsKeys = null;
        boolean originalAutoCommit = true;
        try {
            originalAutoCommit = con.getAutoCommit();
            con.setAutoCommit(false);

            // 1) verificar el estado actual del asiento con lock
            String sqlCheck = "SELECT estado FROM asiento_viaje WHERE idAsientoViaje = ? FOR UPDATE";
            psSelect = con.prepareStatement(sqlCheck);
            psSelect.setInt(1, idAsientoViaje);
            rs = psSelect.executeQuery();
            if (!rs.next()) {
                con.rollback();
                return 0; // asiento no existe
            }
            int estado = rs.getInt("estado");
            if (estado != 0) {
                con.rollback();
                return 0; // no disponible
            }

            // 2) insertar la reserva
            String sqlInsert = "INSERT INTO reserva (idViaje, idAsientoViaje, idCliente, fechaReserva, estado) VALUES (?, ?, ?, NOW(), ?)";
            psInsert = con.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
            psInsert.setInt(1, idViaje);
            psInsert.setInt(2, idAsientoViaje);
            psInsert.setInt(3, idCliente);
            psInsert.setInt(4, 1); // 1 = reservado (ajusta segun tu lógica)
            psInsert.executeUpdate();
            rsKeys = psInsert.getGeneratedKeys();
            int idReserva = 0;
            if (rsKeys.next()) {
                idReserva = rsKeys.getInt(1);
            }

            // 3) actualizar estado del asiento a '1' reservado
            String sqlUpdate = "UPDATE asiento_viaje SET estado = 1 WHERE idAsientoViaje = ?";
            psUpdate = con.prepareStatement(sqlUpdate);
            psUpdate.setInt(1, idAsientoViaje);
            psUpdate.executeUpdate();

            con.commit();
            return idReserva;
        } catch (SQLException ex) {
            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ignore) {
            }
            throw ex;
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (SQLException ignore) {
            }
            try {
                if (rsKeys != null) {
                    rsKeys.close();
                }
            } catch (SQLException ignore) {
            }
            try {
                if (psSelect != null) {
                    psSelect.close();
                }
            } catch (SQLException ignore) {
            }
            try {
                if (psInsert != null) {
                    psInsert.close();
                }
            } catch (SQLException ignore) {
            }
            try {
                if (psUpdate != null) {
                    psUpdate.close();
                }
            } catch (SQLException ignore) {
            }
            try {
                if (con != null) {
                    con.setAutoCommit(originalAutoCommit);
                }
            } catch (SQLException ignore) {
            }
        }
    }
}

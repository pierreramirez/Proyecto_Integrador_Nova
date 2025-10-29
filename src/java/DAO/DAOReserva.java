package DAO;

import Persistencia.Conexion;
import java.sql.*;

public class DAOReserva {

    private Conexion cn = new Conexion();

    /**
     * Crea una reserva para el asiento indicado. Retorna idReserva (>0) si se
     * creó, 0 si asiento no estaba disponible.
     */
    public int crearReserva(int idViaje, int idAsientoViaje, int idCliente) throws SQLException {
        Connection con = cn.getConnection();
        PreparedStatement psSelect = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;
        ResultSet rs = null;
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
            String sqlInsert = "INSERT INTO reserva (idViaje, idAsientoViaje, idCliente, estado) VALUES (?, ?, ?, 1)";
            psInsert = con.prepareStatement(sqlInsert, Statement.RETURN_GENERATED_KEYS);
            psInsert.setInt(1, idViaje);
            psInsert.setInt(2, idAsientoViaje);
            psInsert.setInt(3, idCliente);
            psInsert.executeUpdate();
            ResultSet rsKeys = psInsert.getGeneratedKeys();
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
                con.rollback();
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
                con.setAutoCommit(originalAutoCommit);
            } catch (SQLException ignore) {
            }
        }
    }
}

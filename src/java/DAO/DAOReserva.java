package DAO;

import Persistencia.Conexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

/**
 * DAOReserva: crea reservas de forma transaccional asegurando que el asiento
 * esté disponible (SELECT ... FOR UPDATE) y devolviendo el id generado.
 */
public class DAOReserva {

    /**
     * Crea una reserva para el asiento indicado. Retorna idReserva (>0) si se
     * creó, 0 si asiento no estaba disponible.
     */
    public int crearReserva(int idViaje, int idAsientoViaje, int idCliente) throws SQLException {
        Connection con = null;
        PreparedStatement psSelect = null;
        PreparedStatement psInsert = null;
        PreparedStatement psUpdate = null;
        ResultSet rs = null;
        ResultSet rsKeys = null;

        try {
            Conexion cx = new Conexion();
            con = cx.getConnection();
            if (con == null) {
                throw new SQLException("Conexion nula en DAOReserva");
            }

            con.setAutoCommit(false);

            // 1) bloquear fila del asiento
            String sqlSelect = "SELECT estado FROM asiento_viaje WHERE idAsientoViaje = ? FOR UPDATE";
            psSelect = con.prepareStatement(sqlSelect);
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
            psInsert.setString(4, "PENDIENTE");
            int affected = psInsert.executeUpdate();

            if (affected == 0) {
                con.rollback();
                return 0;
            }

            rsKeys = psInsert.getGeneratedKeys();
            int idReserva = 0;
            if (rsKeys.next()) {
                idReserva = rsKeys.getInt(1);
            } else {
                con.rollback();
                return 0;
            }

            // 3) actualizar estado del asiento a '1' reservado
            String sqlUpdate = "UPDATE asiento_viaje SET estado = 1 WHERE idAsientoViaje = ?";
            psUpdate = con.prepareStatement(sqlUpdate);
            psUpdate.setInt(1, idAsientoViaje);
            psUpdate.executeUpdate();

            // 4) commit
            con.commit();
            return idReserva;

        } catch (SQLException ex) {
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ignore) {
                }
            }
            throw ex;
        } finally {
            try {
                if (rsKeys != null) {
                    rsKeys.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (psSelect != null) {
                    psSelect.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (psInsert != null) {
                    psInsert.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (psUpdate != null) {
                    psUpdate.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (con != null) {
                    con.setAutoCommit(true);
                    con.close();
                }
            } catch (Exception ignore) {
            }
        }
    }
}

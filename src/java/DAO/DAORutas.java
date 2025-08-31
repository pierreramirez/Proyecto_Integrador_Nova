package DAO;

import Modelo.DTORuta;
import Interfaces.CRUDRutas;
import Persistencia.Conexion;
import java.sql.*;
import java.util.LinkedList;

public class DAORutas extends Conexion implements CRUDRutas {

    public DAORutas() {
        super();
    }

    @Override
    public LinkedList<DTORuta> ListarRutas() {
        LinkedList<DTORuta> lista = new LinkedList<>();
        String consulta = "SELECT * FROM ruta_viaje WHERE estado = 1";
        try {
            ps = con.prepareStatement(consulta);
            rs = ps.executeQuery();
            while (rs.next()) {
                DTORuta ruta = new DTORuta();
                ruta.setIdViaje(rs.getInt("idViaje"));
                ruta.setIdBus(rs.getInt("idBus"));
                ruta.setIdChofer(rs.getInt("idChofer"));
                ruta.setFechaSalida(rs.getDate("fechaSalida"));
                ruta.setHoraSalida(rs.getTime("horaSalida"));
                ruta.setFechaLlegada(rs.getDate("fechaLlegada"));
                ruta.setHoraLlegada(rs.getTime("horaLlegada"));
                ruta.setOrigen(rs.getInt("origen"));
                ruta.setDestino(rs.getInt("destino"));
                ruta.setPrecio(rs.getBigDecimal("precio")); // BigDecimal correcto
                ruta.setBoletosRestantes(rs.getInt("boletosRestantes"));
                ruta.setCreador(rs.getInt("creador"));
                ruta.setFechaCreacion(rs.getTimestamp("fechaCreacion")); // Timestamp
                ruta.setEstado(rs.getInt("estado"));
                lista.add(ruta);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    @Override
    public DTORuta ObtenerRuta(int id) {
        DTORuta ruta = null;
        String consulta = "SELECT * FROM ruta_viaje WHERE idViaje = ?";
        try {
            ps = con.prepareStatement(consulta);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                ruta = new DTORuta();
                ruta.setIdViaje(rs.getInt("idViaje"));
                ruta.setIdBus(rs.getInt("idBus"));
                ruta.setIdChofer(rs.getInt("idChofer"));
                ruta.setFechaSalida(rs.getDate("fechaSalida"));
                ruta.setHoraSalida(rs.getTime("horaSalida"));
                ruta.setFechaLlegada(rs.getDate("fechaLlegada"));
                ruta.setHoraLlegada(rs.getTime("horaLlegada"));
                ruta.setOrigen(rs.getInt("origen"));
                ruta.setDestino(rs.getInt("destino"));
                ruta.setPrecio(rs.getBigDecimal("precio"));
                ruta.setBoletosRestantes(rs.getInt("boletosRestantes"));
                ruta.setCreador(rs.getInt("creador"));
                ruta.setFechaCreacion(rs.getTimestamp("fechaCreacion"));
                ruta.setEstado(rs.getInt("estado"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return ruta;
    }

    @Override
    public boolean AgregarRuta(DTORuta ruta) {
        String consulta = "INSERT INTO ruta_viaje "
                + "(idBus, idChofer, fechaSalida, horaSalida, origen, fechaLlegada, horaLlegada, destino, precio, boletosRestantes, creador, fechaCreacion, estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)";
        try {
            ps = con.prepareStatement(consulta);
            ps.setInt(1, ruta.getIdBus());
            ps.setInt(2, ruta.getIdChofer());
            ps.setDate(3, ruta.getFechaSalida());
            ps.setTime(4, ruta.getHoraSalida());
            ps.setInt(5, ruta.getOrigen());
            ps.setDate(6, ruta.getFechaLlegada());
            ps.setTime(7, ruta.getHoraLlegada());
            ps.setInt(8, ruta.getDestino());
            if (ruta.getPrecio() != null) {
                ps.setBigDecimal(9, ruta.getPrecio());
            } else {
                ps.setNull(9, Types.DECIMAL);
            }
            ps.setInt(10, ruta.getBoletosRestantes());
            ps.setInt(11, ruta.getCreador());
            ps.setInt(12, ruta.getEstado());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean EditarRuta(DTORuta ruta) {
        String consulta = "UPDATE ruta_viaje SET idBus=?, idChofer=?, fechaSalida=?, horaSalida=?, origen=?, fechaLlegada=?, horaLlegada=?, destino=?, precio=?, boletosRestantes=?, estado=? WHERE idViaje=?";
        try {
            ps = con.prepareStatement(consulta);
            ps.setInt(1, ruta.getIdBus());
            ps.setInt(2, ruta.getIdChofer());
            ps.setDate(3, ruta.getFechaSalida());
            ps.setTime(4, ruta.getHoraSalida());
            ps.setInt(5, ruta.getOrigen());
            ps.setDate(6, ruta.getFechaLlegada());
            ps.setTime(7, ruta.getHoraLlegada());
            ps.setInt(8, ruta.getDestino());
            if (ruta.getPrecio() != null) {
                ps.setBigDecimal(9, ruta.getPrecio());
            } else {
                ps.setNull(9, Types.DECIMAL);
            }
            ps.setInt(10, ruta.getBoletosRestantes());
            ps.setInt(11, ruta.getEstado());
            ps.setInt(12, ruta.getIdViaje());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean EliminarRuta(int id) {
        String consulta = "UPDATE ruta_viaje SET estado = 0 WHERE idViaje = ?";
        try {
            ps = con.prepareStatement(consulta);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }
}

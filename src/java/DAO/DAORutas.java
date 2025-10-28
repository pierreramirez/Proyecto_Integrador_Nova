package DAO;

import Persistencia.Conexion;
import Modelo.DTORuta;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAORutas {

    // Listar todas las rutas (usado por tu servlet List)
    public List<DTORuta> ListarRutas() throws SQLException {
        List<DTORuta> lista = new ArrayList<>();
        String sql = "SELECT * FROM ruta_viaje ORDER BY fechaSalida, horaSalida, idViaje";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapRowToRuta(rs));
            }
        }
        return lista;
    }

    // Obtener ruta por id (ObtenerRuta)
    public DTORuta ObtenerRuta(int idViaje) throws SQLException {
        String sql = "SELECT * FROM ruta_viaje WHERE idViaje = ?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idViaje);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToRuta(rs);
            }
        }
        return null;
    }

    // Agregar Ruta (AgregarRuta) - retorna id generado o -1
    public int AgregarRuta(DTORuta r) throws SQLException {
        String sql = "INSERT INTO ruta_viaje (idBus, idChofer, fechaSalida, horaSalida, fechaLlegada, horaLlegada, origen, destino, precio, boletosRestantes, creador, fechaCreacion, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getIdBus());
            ps.setInt(2, r.getIdChofer());
            ps.setDate(3, r.getFechaSalida());
            ps.setTime(4, r.getHoraSalida());
            ps.setDate(5, r.getFechaLlegada());
            ps.setTime(6, r.getHoraLlegada());
            ps.setInt(7, r.getOrigen());
            ps.setInt(8, r.getDestino());
            ps.setBigDecimal(9, r.getPrecio());
            ps.setInt(10, r.getBoletosRestantes());
            ps.setInt(11, r.getCreador());
            ps.setInt(12, r.getEstado());
            int affected = ps.executeUpdate();
            if (affected == 0) return -1;
            try (ResultSet gk = ps.getGeneratedKeys()) {
                if (gk.next()) return gk.getInt(1);
            }
        }
        return -1;
    }

    // Editar Ruta (EditarRuta)
    public boolean EditarRuta(DTORuta r) throws SQLException {
        String sql = "UPDATE ruta_viaje SET idBus=?, idChofer=?, fechaSalida=?, horaSalida=?, fechaLlegada=?, horaLlegada=?, origen=?, destino=?, precio=?, boletosRestantes=?, estado=? WHERE idViaje=?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, r.getIdBus());
            ps.setInt(2, r.getIdChofer());
            ps.setDate(3, r.getFechaSalida());
            ps.setTime(4, r.getHoraSalida());
            ps.setDate(5, r.getFechaLlegada());
            ps.setTime(6, r.getHoraLlegada());
            ps.setInt(7, r.getOrigen());
            ps.setInt(8, r.getDestino());
            ps.setBigDecimal(9, r.getPrecio());
            ps.setInt(10, r.getBoletosRestantes());
            ps.setInt(11, r.getEstado());
            ps.setInt(12, r.getIdViaje());
            int updated = ps.executeUpdate();
            return updated == 1;
        }
    }

    // Eliminar ruta (EliminarRuta) - si prefieres soft-delete cambia a UPDATE estado=0
    public boolean EliminarRuta(int idViaje) throws SQLException {
        String sql = "DELETE FROM ruta_viaje WHERE idViaje = ?";
        try (Connection c = new Conexion().getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idViaje);
            return ps.executeUpdate() == 1;
        }
    }

    // Decrementar boletosRestantes (uso interno en transacciones)
    public boolean decrementarBoletos(int idViaje, Connection conn) throws SQLException {
        String sql = "UPDATE ruta_viaje SET boletosRestantes = boletosRestantes - 1 WHERE idViaje = ? AND boletosRestantes > 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idViaje);
            return ps.executeUpdate() == 1;
        }
    }

    // Mapeador privado
    private DTORuta mapRowToRuta(ResultSet rs) throws SQLException {
        DTORuta r = new DTORuta();
        r.setIdViaje(rs.getInt("idViaje"));
        r.setIdBus(rs.getInt("idBus"));
        r.setIdChofer(rs.getInt("idChofer"));
        r.setFechaSalida(rs.getDate("fechaSalida"));
        r.setHoraSalida(rs.getTime("horaSalida"));
        r.setFechaLlegada(rs.getDate("fechaLlegada"));
        r.setHoraLlegada(rs.getTime("horaLlegada"));
        r.setOrigen(rs.getInt("origen"));
        r.setDestino(rs.getInt("destino"));
        r.setPrecio(rs.getBigDecimal("precio"));
        r.setBoletosRestantes(rs.getInt("boletosRestantes"));
        r.setCreador(rs.getInt("creador"));
        r.setFechaCreacion(rs.getTimestamp("fechaCreacion"));
        r.setEstado(rs.getInt("estado"));
        return r;
    }
}

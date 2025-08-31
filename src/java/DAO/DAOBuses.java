package DAO;

import Modelo.DTOBuses;
import Interfaces.CRUDBuses;
import Persistencia.Conexion;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedList;

public class DAOBuses extends Conexion implements CRUDBuses {

    public DAOBuses() {
        super();
    }

    @Override
    public LinkedList<DTOBuses> listarBuses() {
        LinkedList<DTOBuses> lista = new LinkedList<>();
        String consulta = "SELECT * FROM bus";
        try {
            ps = con.prepareStatement(consulta);
            rs = ps.executeQuery();
            while (rs.next()) {
                DTOBuses bus = new DTOBuses();
                bus.setIdBus(rs.getInt("idBus"));
                bus.setPlaca(rs.getString("placa"));
                bus.setCapacidadAsientos(rs.getInt("capacidadAsientos"));
                bus.setTipo(rs.getString("tipo"));
                bus.setDescripcion(rs.getString("descripcion"));
                bus.setCreador(rs.getInt("creador"));
                bus.setFechaCreacion(rs.getDate("fechaCreacion"));
                bus.setEstado(rs.getInt("estado"));
                lista.add(bus);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    @Override
    public DTOBuses obtenerBus(int id) {
        DTOBuses bus = null;
        String consulta = "SELECT * FROM bus WHERE idBus = ?";
        try {
            ps = con.prepareStatement(consulta);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                bus = new DTOBuses();
                bus.setIdBus(rs.getInt("idBus"));
                bus.setPlaca(rs.getString("placa"));
                bus.setCapacidadAsientos(rs.getInt("capacidadAsientos"));
                bus.setTipo(rs.getString("tipo"));
                bus.setDescripcion(rs.getString("descripcion"));
                bus.setCreador(rs.getInt("creador"));
                bus.setFechaCreacion(rs.getDate("fechaCreacion"));
                bus.setEstado(rs.getInt("estado"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return bus;
    }

    @Override
    public boolean agregarBus(DTOBuses bus) {
        String consulta = "INSERT INTO bus (placa, capacidadAsientos, tipo, descripcion, creador, fechaCreacion, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            ps = con.prepareStatement(consulta);
            ps.setString(1, bus.getPlaca());
            ps.setInt(2, bus.getCapacidadAsientos());
            ps.setString(3, bus.getTipo());
            ps.setString(4, bus.getDescripcion());
            ps.setInt(5, bus.getCreador());
            ps.setDate(6, new java.sql.Date(bus.getFechaCreacion().getTime()));
            ps.setInt(7, bus.getEstado());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean actualizarBus(DTOBuses bus) {
        String consulta = "UPDATE bus SET placa = ?, capacidadAsientos = ?, tipo = ?, descripcion = ?, estado = ? WHERE idBus = ?";
        try {
            ps = con.prepareStatement(consulta);
            ps.setString(1, bus.getPlaca());
            ps.setInt(2, bus.getCapacidadAsientos());
            ps.setString(3, bus.getTipo());
            ps.setString(4, bus.getDescripcion());
            ps.setInt(5, bus.getEstado());
            ps.setInt(6, bus.getIdBus());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean eliminarBus(int id) {
        String consulta = "DELETE FROM bus WHERE idBus = ?";
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

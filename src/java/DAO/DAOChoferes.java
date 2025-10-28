package DAO;

import Modelo.DTOChofer;
import Interfaces.CRUDChoferes;
import Persistencia.Conexion;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedList;

public class DAOChoferes extends Conexion implements CRUDChoferes {

    public DAOChoferes() {
        super();
    }

    @Override
    public LinkedList<DTOChofer> ListarChoferes() {
        LinkedList<DTOChofer> lista = new LinkedList<>();
        String consulta = "SELECT * FROM chofer";
        try {
            ps = con.prepareStatement(consulta);
            rs = ps.executeQuery();
            while (rs.next()) {
                DTOChofer chofer = new DTOChofer();
                chofer.setId(rs.getInt("idChofer"));
                chofer.setAppat(rs.getString("appat"));
                chofer.setApmat(rs.getString("apmat"));
                chofer.setNombre(rs.getString("nombre"));
                chofer.setDni(rs.getInt("dni"));
                chofer.setLicenciaConducir(rs.getString("licenciaConducir"));
                chofer.setFechaContratacion(rs.getDate("fechaContratacion"));
                chofer.setFechaVencimientoLicencia(rs.getDate("fechaVencimientoLicencia"));
                chofer.setTelefono(rs.getInt("telefono"));
                chofer.setDisponibilidad(rs.getInt("disponibilidad"));
                chofer.setEstado(rs.getInt("estado"));
                lista.add(chofer);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    @Override
    public LinkedList<DTOChofer> ListarChoferesDisponibles() {
        LinkedList<DTOChofer> lista = new LinkedList<>();
        String consulta = "SELECT * FROM chofer WHERE disponibilidad = 1 AND estado = 1";
        try {
            rs = smt.executeQuery(consulta);
            while (rs.next()) {
                DTOChofer chofer = new DTOChofer();
                chofer.setId(rs.getInt("idChofer"));
                chofer.setAppat(rs.getString("appat"));
                chofer.setApmat(rs.getString("apmat"));
                chofer.setNombre(rs.getString("nombre"));
                chofer.setDni(rs.getInt("dni"));
                chofer.setLicenciaConducir(rs.getString("licenciaConducir"));
                chofer.setFechaContratacion(rs.getDate("fechaContratacion"));
                chofer.setFechaVencimientoLicencia(rs.getDate("fechaVencimientoLicencia"));
                chofer.setTelefono(rs.getInt("telefono"));
                chofer.setDisponibilidad(rs.getInt("disponibilidad"));
                chofer.setEstado(rs.getInt("estado"));
                lista.add(chofer);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    @Override
    public DTOChofer ObtenerChofer(int id) {
        DTOChofer chofer = null;
        String consulta = "SELECT * FROM chofer WHERE idChofer = ?";
        try {
            ps = con.prepareStatement(consulta);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                chofer = new DTOChofer();
                chofer.setId(rs.getInt("idChofer"));
                chofer.setAppat(rs.getString("appat"));
                chofer.setApmat(rs.getString("apmat"));
                chofer.setNombre(rs.getString("nombre"));
                chofer.setDni(rs.getInt("dni"));
                chofer.setLicenciaConducir(rs.getString("licenciaConducir"));
                chofer.setFechaContratacion(rs.getDate("fechaContratacion"));
                chofer.setFechaVencimientoLicencia(rs.getDate("fechaVencimientoLicencia"));
                chofer.setTelefono(rs.getInt("telefono"));
                chofer.setDisponibilidad(rs.getInt("disponibilidad"));
                chofer.setEstado(rs.getInt("estado"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return chofer;
    }

    @Override
    public boolean AgregarChofer(DTOChofer chofer) {
        String consulta = "INSERT INTO chofer (appat, apmat, nombre, dni, licenciaConducir, fechaContratacion, fechaVencimientoLicencia, telefono, disponibilidad, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            ps = con.prepareStatement(consulta);
            ps.setString(1, chofer.getAppat());
            ps.setString(2, chofer.getApmat());
            ps.setString(3, chofer.getNombre());
            ps.setInt(4, chofer.getDni());
            ps.setString(5, chofer.getLicenciaConducir());
            ps.setDate(6, new java.sql.Date(chofer.getFechaContratacion().getTime()));
            ps.setDate(7, new java.sql.Date(chofer.getFechaVencimientoLicencia().getTime()));
            ps.setInt(8, chofer.getTelefono());
            ps.setInt(9, chofer.getDisponibilidad());
            ps.setInt(10, chofer.getEstado());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean ActualizarChofer(DTOChofer chofer) {
        String consulta = "UPDATE chofer SET appat = ?, apmat = ?, nombre = ?, dni = ?, licenciaConducir = ?, fechaContratacion = ?, fechaVencimientoLicencia = ?, telefono = ?, disponibilidad = ?, estado = ? WHERE idChofer = ?";
        try {
            ps = con.prepareStatement(consulta);
            ps.setString(1, chofer.getAppat());
            ps.setString(2, chofer.getApmat());
            ps.setString(3, chofer.getNombre());
            ps.setInt(4, chofer.getDni());
            ps.setString(5, chofer.getLicenciaConducir());
            ps.setDate(6, new java.sql.Date(chofer.getFechaContratacion().getTime()));
            ps.setDate(7, new java.sql.Date(chofer.getFechaVencimientoLicencia().getTime()));
            ps.setInt(8, chofer.getTelefono());
            ps.setInt(9, chofer.getDisponibilidad());
            ps.setInt(10, chofer.getEstado());
            ps.setInt(11, chofer.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean EliminarChofer(int id) {
        String consulta = "DELETE FROM chofer WHERE idChofer = ?";
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

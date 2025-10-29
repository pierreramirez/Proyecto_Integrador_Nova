package DAO;

import Modelo.DTOChofer;
import Interfaces.CRUDChoferes;
import Persistencia.Conexion;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;

public class DAOChoferes extends Conexion implements CRUDChoferes {

    public DAOChoferes() {
        super();
    }

    @Override
    public LinkedList<DTOChofer> ListarChoferes() {
        LinkedList<DTOChofer> lista = new LinkedList<>();
        String consulta = "SELECT * FROM chofer ORDER BY nombre";
        PreparedStatement localPs = null;
        ResultSet localRs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localRs = localPs.executeQuery();
            while (localRs.next()) {
                DTOChofer chofer = new DTOChofer();
                // tu DAO original usaba setId, etc. DTO ahora tiene alias setIdChofer
                chofer.setId(localRs.getInt("idChofer"));
                chofer.setAppat(localRs.getString("appat"));
                chofer.setApmat(localRs.getString("apmat"));
                chofer.setNombre(localRs.getString("nombre"));
                chofer.setDni(localRs.getInt("dni"));
                chofer.setLicenciaConducir(localRs.getString("licenciaConducir"));
                chofer.setFechaContratacion(localRs.getDate("fechaContratacion"));
                chofer.setFechaVencimientoLicencia(localRs.getDate("fechaVencimientoLicencia"));
                chofer.setTelefono(localRs.getInt("telefono"));
                chofer.setDisponibilidad(localRs.getInt("disponibilidad"));
                chofer.setEstado(localRs.getInt("estado"));
                lista.add(chofer);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localRs != null) {
                    localRs.close();
                }
            } catch (SQLException ignored) {
            }
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (SQLException ignored) {
            }
        }
        return lista;
    }

    @Override
    public LinkedList<DTOChofer> ListarChoferesDisponibles() {
        LinkedList<DTOChofer> lista = new LinkedList<>();
        String consulta = "SELECT * FROM chofer WHERE disponibilidad = 1 AND estado = 1 ORDER BY nombre";
        PreparedStatement localPs = null;
        ResultSet localRs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localRs = localPs.executeQuery();
            while (localRs.next()) {
                DTOChofer chofer = new DTOChofer();
                chofer.setId(localRs.getInt("idChofer"));
                chofer.setAppat(localRs.getString("appat"));
                chofer.setApmat(localRs.getString("apmat"));
                chofer.setNombre(localRs.getString("nombre"));
                chofer.setDni(localRs.getInt("dni"));
                chofer.setLicenciaConducir(localRs.getString("licenciaConducir"));
                chofer.setFechaContratacion(localRs.getDate("fechaContratacion"));
                chofer.setFechaVencimientoLicencia(localRs.getDate("fechaVencimientoLicencia"));
                chofer.setTelefono(localRs.getInt("telefono"));
                chofer.setDisponibilidad(localRs.getInt("disponibilidad"));
                chofer.setEstado(localRs.getInt("estado"));
                lista.add(chofer);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localRs != null) {
                    localRs.close();
                }
            } catch (SQLException ignored) {
            }
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (SQLException ignored) {
            }
        }
        return lista;
    }

    @Override
    public DTOChofer ObtenerChofer(int id) {
        DTOChofer chofer = null;
        String consulta = "SELECT * FROM chofer WHERE idChofer = ?";
        PreparedStatement localPs = null;
        ResultSet localRs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localPs.setInt(1, id);
            localRs = localPs.executeQuery();
            if (localRs.next()) {
                chofer = new DTOChofer();
                chofer.setId(localRs.getInt("idChofer"));
                chofer.setAppat(localRs.getString("appat"));
                chofer.setApmat(localRs.getString("apmat"));
                chofer.setNombre(localRs.getString("nombre"));
                chofer.setDni(localRs.getInt("dni"));
                chofer.setLicenciaConducir(localRs.getString("licenciaConducir"));
                chofer.setFechaContratacion(localRs.getDate("fechaContratacion"));
                chofer.setFechaVencimientoLicencia(localRs.getDate("fechaVencimientoLicencia"));
                chofer.setTelefono(localRs.getInt("telefono"));
                chofer.setDisponibilidad(localRs.getInt("disponibilidad"));
                chofer.setEstado(localRs.getInt("estado"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localRs != null) {
                    localRs.close();
                }
            } catch (SQLException ignored) {
            }
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (SQLException ignored) {
            }
        }
        return chofer;
    }

    @Override
    public boolean AgregarChofer(DTOChofer chofer) {
        String consulta = "INSERT INTO chofer (appat, apmat, nombre, dni, licenciaConducir, fechaContratacion, fechaVencimientoLicencia, telefono, disponibilidad, estado) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement localPs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localPs.setString(1, chofer.getAppat());
            localPs.setString(2, chofer.getApmat());
            localPs.setString(3, chofer.getNombre());
            localPs.setInt(4, chofer.getDni());
            localPs.setString(5, chofer.getLicenciaConducir());
            if (chofer.getFechaContratacion() != null) {
                localPs.setDate(6, new java.sql.Date(chofer.getFechaContratacion().getTime()));
            } else {
                localPs.setNull(6, java.sql.Types.DATE);
            }
            if (chofer.getFechaVencimientoLicencia() != null) {
                localPs.setDate(7, new java.sql.Date(chofer.getFechaVencimientoLicencia().getTime()));
            } else {
                localPs.setNull(7, java.sql.Types.DATE);
            }
            localPs.setInt(8, chofer.getTelefono());
            localPs.setInt(9, chofer.getDisponibilidad());
            localPs.setInt(10, chofer.getEstado());
            return localPs.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (SQLException ignored) {
            }
        }
        return false;
    }

    @Override
    public boolean ActualizarChofer(DTOChofer chofer) {
        String consulta = "UPDATE chofer SET appat = ?, apmat = ?, nombre = ?, dni = ?, licenciaConducir = ?, fechaContratacion = ?, fechaVencimientoLicencia = ?, telefono = ?, disponibilidad = ?, estado = ? WHERE idChofer = ?";
        PreparedStatement localPs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localPs.setString(1, chofer.getAppat());
            localPs.setString(2, chofer.getApmat());
            localPs.setString(3, chofer.getNombre());
            localPs.setInt(4, chofer.getDni());
            localPs.setString(5, chofer.getLicenciaConducir());
            if (chofer.getFechaContratacion() != null) {
                localPs.setDate(6, new java.sql.Date(chofer.getFechaContratacion().getTime()));
            } else {
                localPs.setNull(6, java.sql.Types.DATE);
            }
            if (chofer.getFechaVencimientoLicencia() != null) {
                localPs.setDate(7, new java.sql.Date(chofer.getFechaVencimientoLicencia().getTime()));
            } else {
                localPs.setNull(7, java.sql.Types.DATE);
            }
            localPs.setInt(8, chofer.getTelefono());
            localPs.setInt(9, chofer.getDisponibilidad());
            localPs.setInt(10, chofer.getEstado());
            localPs.setInt(11, chofer.getId());
            return localPs.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (SQLException ignored) {
            }
        }
        return false;
    }

    @Override
    public boolean EliminarChofer(int id) {
        String consulta = "DELETE FROM chofer WHERE idChofer = ?";
        PreparedStatement localPs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localPs.setInt(1, id);
            return localPs.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (SQLException ignored) {
            }
        }
        return false;
    }
}

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
        PreparedStatement localPs = null;
        ResultSet localRs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localRs = localPs.executeQuery();
            while (localRs.next()) {
                DTOBuses bus = new DTOBuses();
                bus.setIdBus(localRs.getInt("idBus"));
                bus.setPlaca(localRs.getString("placa"));
                bus.setCapacidadAsientos(localRs.getInt("capacidadAsientos"));
                bus.setTipo(localRs.getString("tipo"));
                bus.setDescripcion(localRs.getString("descripcion"));
                bus.setCreador(localRs.getInt("creador"));
                bus.setFechaCreacion(localRs.getDate("fechaCreacion"));
                bus.setEstado(localRs.getInt("estado"));
                lista.add(bus);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localRs != null) {
                    localRs.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (Exception ignore) {
            }
        }
        return lista;
    }

    @Override
    public DTOBuses obtenerBus(int id) {
        DTOBuses bus = null;
        String consulta = "SELECT * FROM bus WHERE idBus = ?";
        PreparedStatement localPs = null;
        ResultSet localRs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localPs.setInt(1, id);
            localRs = localPs.executeQuery();
            if (localRs.next()) {
                bus = new DTOBuses();
                bus.setIdBus(localRs.getInt("idBus"));
                bus.setPlaca(localRs.getString("placa"));
                bus.setCapacidadAsientos(localRs.getInt("capacidadAsientos"));
                bus.setTipo(localRs.getString("tipo"));
                bus.setDescripcion(localRs.getString("descripcion"));
                bus.setCreador(localRs.getInt("creador"));
                bus.setFechaCreacion(localRs.getDate("fechaCreacion"));
                bus.setEstado(localRs.getInt("estado"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localRs != null) {
                    localRs.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (Exception ignore) {
            }
        }
        return bus;
    }

    @Override
    public boolean agregarBus(DTOBuses bus) {
        String consulta = "INSERT INTO bus (placa, capacidadAsientos, tipo, descripcion, creador, fechaCreacion, estado) VALUES (?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement localPs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localPs.setString(1, bus.getPlaca());
            localPs.setInt(2, bus.getCapacidadAsientos());
            localPs.setString(3, bus.getTipo());
            localPs.setString(4, bus.getDescripcion());
            localPs.setInt(5, bus.getCreador());
            // cuidado: fechaCreacion puede ser null
            if (bus.getFechaCreacion() != null) {
                localPs.setDate(6, new java.sql.Date(bus.getFechaCreacion().getTime()));
            } else {
                localPs.setDate(6, new java.sql.Date(new java.util.Date().getTime()));
            }
            localPs.setInt(7, bus.getEstado());
            return localPs.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (Exception ignore) {
            }
        }
        return false;
    }

    @Override
    public boolean actualizarBus(DTOBuses bus) {
        String consulta = "UPDATE bus SET placa = ?, capacidadAsientos = ?, tipo = ?, descripcion = ?, estado = ? WHERE idBus = ?";
        PreparedStatement localPs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localPs.setString(1, bus.getPlaca());
            localPs.setInt(2, bus.getCapacidadAsientos());
            localPs.setString(3, bus.getTipo());
            localPs.setString(4, bus.getDescripcion());
            localPs.setInt(5, bus.getEstado());
            localPs.setInt(6, bus.getIdBus());
            return localPs.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (Exception ignore) {
            }
        }
        return false;
    }

    @Override
    public boolean eliminarBus(int id) {
        String consulta = "DELETE FROM bus WHERE idBus = ?";
        PreparedStatement localPs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localPs.setInt(1, id);
            return localPs.executeUpdate() > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (Exception ignore) {
            }
        }
        return false;
    }

    /**
     * Devuelve la capacidad (número de asientos) del bus indicado. Retorna 0 si
     * no existe o hay error.
     */
    public int obtenerCapacidadBus(int idBus) {
        String consulta = "SELECT capacidadAsientos FROM bus WHERE idBus = ?";
        PreparedStatement localPs = null;
        ResultSet localRs = null;
        try {
            localPs = con.prepareStatement(consulta);
            localPs.setInt(1, idBus);
            localRs = localPs.executeQuery();
            if (localRs.next()) {
                return localRs.getInt("capacidadAsientos");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (localRs != null) {
                    localRs.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (localPs != null) {
                    localPs.close();
                }
            } catch (Exception ignore) {
            }
        }
        return 0;
    }
}

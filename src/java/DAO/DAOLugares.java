package DAO;

import Modelo.DTOLugar;
import Interfaces.CRUDLugares;
import Persistencia.*;
import java.util.LinkedList;

public class DAOLugares extends Conexion implements CRUDLugares{
    DTOLugar lugar;

    public DAOLugares() {}
    
    @Override
    public LinkedList<DTOLugar> ListarLugar() {
        LinkedList Lista = new LinkedList();
        String consulta = "SELECT * FROM lugares WHERE estado = 1";
        try {
            rs = smt.executeQuery(consulta);
            while (rs.next()) {
                lugar = new DTOLugar();
                lugar.setId(rs.getInt(1));
                lugar.setNombre(rs.getString(2));
                lugar.setEstado(rs.getInt(3));
                Lista.add(lugar);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return Lista;
    }
    
}

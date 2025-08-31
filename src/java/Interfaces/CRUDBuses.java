package Interfaces;

import Modelo.DTOBuses;
import java.util.List;

public interface CRUDBuses {
    public List<DTOBuses> listarBuses();
    public DTOBuses obtenerBus(int id);
    public boolean agregarBus(DTOBuses b);
    public boolean actualizarBus(DTOBuses b);
    public boolean eliminarBus(int id);
}

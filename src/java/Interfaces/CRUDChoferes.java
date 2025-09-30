package Interfaces;

import Modelo.DTOChofer;
import java.util.LinkedList;

public interface CRUDChoferes {
    public LinkedList<DTOChofer> ListarChoferes();
    public LinkedList<DTOChofer> ListarChoferesDisponibles();
    DTOChofer ObtenerChofer(int id);
    boolean AgregarChofer(DTOChofer chofer);
    boolean ActualizarChofer(DTOChofer chofer);
    boolean EliminarChofer(int id);
    
}   

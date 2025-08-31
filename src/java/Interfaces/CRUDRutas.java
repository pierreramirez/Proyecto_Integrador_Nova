package Interfaces;

import Modelo.DTORuta;
import java.util.LinkedList;

public interface CRUDRutas {
    public LinkedList<DTORuta> ListarRutas();
    public DTORuta ObtenerRuta(int id);
    public boolean AgregarRuta(DTORuta ruta);
    public boolean EditarRuta(DTORuta ruta);
    public boolean EliminarRuta(int id);
}

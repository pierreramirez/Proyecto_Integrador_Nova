package Interfaces;

import Modelo.DTOUsuario;
import java.util.LinkedList;

public interface CRUDUsuarios {
    public LinkedList<DTOUsuario> ListarUsuarios();
    DTOUsuario ValidarSesion(String correo, String contra);
}

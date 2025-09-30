
package Interfaces;

import java.util.LinkedList;
import Modelo.DTOCliente;


public interface CRUDClientes {
    public LinkedList<DTOCliente> ListarClientes();
    DTOCliente ObtenerCliente(int id);  // CREATE
    boolean AgregarCliente(DTOCliente cliente); // READ
    boolean ActualizarCliente(DTOCliente cliente); //UPDATE
    boolean EliminarCliente(int id); // DELETE
}

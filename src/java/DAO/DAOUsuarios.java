package DAO;

import Interfaces.CRUDUsuarios;
import Modelo.DTOUsuario;
import Persistencia.Conexion;
import java.util.LinkedList;

public class DAOUsuarios extends Conexion implements CRUDUsuarios{
 
    @Override
    public LinkedList<DTOUsuario> ListarUsuarios() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public DTOUsuario ValidarSesion(String correo, String contra) {
        DTOUsuario usuario = null;
        String consulta = "SELECT * FROM usuario WHERE email = ? AND contraseña = ? AND estado = 1";
        try {
            ps = super.con.prepareStatement(consulta);
            ps.setString(1, correo);
            ps.setString(2, contra);
            rs = ps.executeQuery();
            if (rs.next()) {
                usuario = new DTOUsuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setAppat(rs.getString("appat"));
                usuario.setApmat(rs.getString("apmat"));
                usuario.setDni(rs.getInt("dni"));
                usuario.setEmail(rs.getString("email"));
                usuario.setContra(rs.getString("contraseña"));
                usuario.setEstado(rs.getInt("estado"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return usuario;
    }

}

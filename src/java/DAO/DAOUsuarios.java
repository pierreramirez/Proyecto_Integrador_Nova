package DAO;

import Interfaces.CRUDUsuarios;
import Modelo.DTOUsuario;
import Persistencia.Conexion;
import java.util.LinkedList;

public class DAOUsuarios extends Conexion implements CRUDUsuarios {

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
    // dentro de la clase DAOUsuarios (usa tu estructura de conexion, ps, rs, con)

    public DTOUsuario getUserByEmail(String correo) {
        DTOUsuario usuario = null;
        String sql = "SELECT * FROM usuario WHERE email = ? AND estado = 1";
        try {
            ps = super.con.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();
            if (rs.next()) {
                usuario = new DTOUsuario();
                usuario.setIdUsuario(rs.getInt("idUsuario"));
                usuario.setNombre(rs.getString("nombre"));
                usuario.setAppat(rs.getString("appat"));
                usuario.setApmat(rs.getString("apmat"));
                usuario.setDni(rs.getInt("dni"));
                usuario.setEmail(rs.getString("email"));
                usuario.setContra(rs.getString("contraseña")); // hash almacenado
                usuario.setEstado(rs.getInt("estado"));
                // si añadiste creador en DTO:
                try {
                    usuario.setCreador(rs.getInt("creador"));
                } catch (Exception e) {
                    /* opcional */ }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return usuario;
    }

    public boolean insertarUsuario(DTOUsuario u, int creadorId) {
        String sql = "INSERT INTO usuario(appat,apmat,nombre,dni,email,contraseña,creador,fechaCreacion,estado) VALUES(?,?,?,?,?,?,?,NOW(),1)";
        try {
            ps = super.con.prepareStatement(sql);
            ps.setString(1, u.getAppat());
            ps.setString(2, u.getApmat());
            ps.setString(3, u.getNombre());
            ps.setInt(4, u.getDni());
            ps.setString(5, u.getEmail());
            ps.setString(6, u.getContra()); // hashed
            ps.setInt(7, creadorId);
            int r = ps.executeUpdate();
            return r > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }
// Actualiza la contraseña (ya recibida hasheada)

    public boolean actualizarContrasena(String email, String hashedPassword) {
        String sql = "UPDATE usuario SET contraseña = ? WHERE email = ?";
        try {
            ps = super.con.prepareStatement(sql);
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            int r = ps.executeUpdate();
            return r > 0;
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

}

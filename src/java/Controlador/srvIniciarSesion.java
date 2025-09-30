package Controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import DAO.DAOUsuarios;
import Modelo.DTOUsuario;
import Util.EmailUtil;
import org.mindrot.jbcrypt.BCrypt;
import javax.mail.MessagingException;
import javax.mail.MessagingException;
import org.mindrot.jbcrypt.BCrypt;

public class srvIniciarSesion extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // <-- forzar UTF-8 (muy importante)
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");
        try {
            if (accion != null) {
                switch (accion) {
                    case "verificar":
                        VerificarLogin(request, response);
                        break;
                    case "confirmarCodigo":
                        ConfirmarCodigo(request, response);
                        break;
                    case "registrar":
                        Registrar(request, response);
                        break;
                    case "cerrar":
                        CerrarSesion(request, response);
                        break;
                    case "solicitarRecuperacion":
                        SolicitarRecuperacion(request, response);
                        break;
                    case "verificarRecuperacion":
                        VerificarRecuperacion(request, response);
                        break;
                    case "cambiarPassword":
                        CambiarPassword(request, response);
                        break;

                    default:
                        response.sendRedirect("Vista/login.jsp");
                }
            } else {
                response.sendRedirect("Vista/login.jsp");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Vista/login.jsp?error=ex");
        }
    }

    private void VerificarLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String correo = request.getParameter("txtCorreo");
            String contra = request.getParameter("txtPassword");

            DAOUsuarios dao = new DAOUsuarios();
            DTOUsuario user = dao.getUserByEmail(correo);

            if (user != null && BCrypt.checkpw(contra, user.getContra())) {
                // generar código 6 dígitos
                String codigo = String.format("%06d", (int) (Math.random() * 900000) + 100000);
                HttpSession ses = request.getSession();
                ses.setAttribute("codigo2FA", codigo);
                ses.setAttribute("userTemp", user);
                long expiracion = System.currentTimeMillis() + (5 * 60 * 1000); // 5 min
                ses.setAttribute("codigoExpira", expiracion);

                try {
                    EmailUtil.enviarCodigoVerificacion(user.getEmail(), codigo);
                } catch (MessagingException me) {
                    me.printStackTrace();
                    response.sendRedirect("Vista/login.jsp?error=mail");
                    return;
                }

                response.sendRedirect("Vista/verificarCodigo.jsp");
            } else {
                response.sendRedirect("Vista/login.jsp?error=cred");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Vista/login.jsp?error=ex");
        }
    }

    private void ConfirmarCodigo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String codigoEnviado = request.getParameter("txtCodigo");
            HttpSession ses = request.getSession(false);
            if (ses == null) {
                response.sendRedirect("Vista/login.jsp");
                return;
            }

            String codigoCorrecto = (String) ses.getAttribute("codigo2FA");
            Long expira = (Long) ses.getAttribute("codigoExpira");

            if (codigoCorrecto != null && expira != null && System.currentTimeMillis() <= expira && codigoCorrecto.equals(codigoEnviado)) {
                DTOUsuario user = (DTOUsuario) ses.getAttribute("userTemp");
                ses.setAttribute("user", user);
                ses.removeAttribute("codigo2FA");
                ses.removeAttribute("codigoExpira");
                ses.removeAttribute("userTemp");
                response.sendRedirect("Vista/index.jsp");
            } else {
                response.sendRedirect("Vista/verificarCodigo.jsp?error=cod");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Vista/login.jsp?error=ex2");
        }
    }

    private void Registrar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String appat = request.getParameter("appat");
            String apmat = request.getParameter("apmat");
            String nombre = request.getParameter("nombre");
            int dni = Integer.parseInt(request.getParameter("dni"));
            String email = request.getParameter("email");
            String pass = request.getParameter("password");

            String hashed = BCrypt.hashpw(pass, BCrypt.gensalt(12));

            DTOUsuario u = new DTOUsuario();
            u.setAppat(appat);
            u.setApmat(apmat);
            u.setNombre(nombre);
            u.setDni(dni);
            u.setEmail(email);
            u.setContra(hashed);

            DAOUsuarios dao = new DAOUsuarios();
            int creadorId = 1; // admin por defecto
            boolean ok = dao.insertarUsuario(u, creadorId);

            if (ok) {
                response.sendRedirect("Vista/login.jsp?registro=ok");
            } else {
                response.sendRedirect("Vista/registro.jsp?error=bd");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Vista/registro.jsp?error=ex");
        }
    }

    private void CerrarSesion(HttpServletRequest request, HttpServletResponse response) {
        try {
            HttpSession sesion = request.getSession(false);
            if (sesion != null) {
                sesion.invalidate();
            }
            response.sendRedirect("Vista/login.jsp");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    // 1) Solicitar recuperación: genera código y envía correo si existe el usuario

    private void SolicitarRecuperacion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String correo = request.getParameter("txtCorreoRecup");
            DAOUsuarios dao = new DAOUsuarios();
            DTOUsuario user = dao.getUserByEmail(correo);
            if (user == null) {
                // no existe
                response.sendRedirect("Vista/recuperar.jsp?error=noexist");
                return;
            }

            // generar código
            String codigo = String.format("%06d", (int) (Math.random() * 900000) + 100000);
            HttpSession ses = request.getSession();
            ses.setAttribute("recupEmail", correo);
            ses.setAttribute("recupCodigo", codigo);
            ses.setAttribute("recupExpira", System.currentTimeMillis() + (10 * 60 * 1000)); // 10 min validez
            ses.setAttribute("recupIntentos", 0);

            // enviar correo
            try {

                Util.EmailUtil.enviarCodigoVerificacion(correo, codigo);
            } catch (MessagingException me) {
                me.printStackTrace();
                response.sendRedirect("Vista/recuperar.jsp?error=mail");
                return;
            }

            response.sendRedirect("Vista/recuperarCodigo.jsp");
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Vista/recuperar.jsp?error=ex");
        }
    }

// 2) Verificar código de recuperación
    private void VerificarRecuperacion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String codigoIngresado = request.getParameter("txtCodigoRecup");
            HttpSession ses = request.getSession(false);
            if (ses == null) {
                response.sendRedirect("Vista/recuperar.jsp");
                return;
            }

            String codigoCorrecto = (String) ses.getAttribute("recupCodigo");
            Long expira = (Long) ses.getAttribute("recupExpira");
            Integer intentos = (Integer) ses.getAttribute("recupIntentos");
            if (intentos == null) {
                intentos = 0;
            }

            // controlar intentos
            if (System.currentTimeMillis() > expira) {
                ses.removeAttribute("recupCodigo");
                ses.removeAttribute("recupExpira");
                response.sendRedirect("Vista/recuperar.jsp?error=exp");
                return;
            }

            if (codigoCorrecto != null && codigoCorrecto.equals(codigoIngresado)) {
                // ok -> permitir cambiar password
                response.sendRedirect("Vista/cambiarPassword.jsp");
            } else {
                intentos++;
                ses.setAttribute("recupIntentos", intentos);
                if (intentos >= 3) {
                    // bloquear intento: limpiar y forzar re-solicitud
                    ses.removeAttribute("recupCodigo");
                    ses.removeAttribute("recupExpira");
                    response.sendRedirect("Vista/recuperar.jsp?error=blocked");
                } else {
                    response.sendRedirect("Vista/recuperarCodigo.jsp?error=cod");
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Vista/recuperar.jsp?error=ex");
        }
    }

// 3) Cambiar contraseña (desde cambiarPassword.jsp)
    private void CambiarPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String pass1 = request.getParameter("password1");
            String pass2 = request.getParameter("password2");
            if (pass1 == null || pass2 == null || !pass1.equals(pass2)) {
                response.sendRedirect("Vista/cambiarPassword.jsp?error=match");
                return;
            }
            // validar mínimos si deseas (longitud)
            if (pass1.length() < 6) {
                response.sendRedirect("Vista/cambiarPassword.jsp?error=short");
                return;
            }

            HttpSession ses = request.getSession(false);
            if (ses == null) {
                response.sendRedirect("Vista/recuperar.jsp");
                return;
            }
            String correo = (String) ses.getAttribute("recupEmail");
            if (correo == null) {
                response.sendRedirect("Vista/recuperar.jsp");
                return;
            }

            // hashear
            String hashed = BCrypt.hashpw(pass1, BCrypt.gensalt(12));

            DAOUsuarios dao = new DAOUsuarios();
            boolean ok = dao.actualizarContrasena(correo, hashed);
            if (ok) {
                // limpiar atributos de sesión relacionados
                ses.removeAttribute("recupCodigo");
                ses.removeAttribute("recupExpira");
                ses.removeAttribute("recupEmail");
                ses.removeAttribute("recupIntentos");
                response.sendRedirect("Vista/login.jsp?recup=ok");
            } else {
                response.sendRedirect("Vista/cambiarPassword.jsp?error=bd");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Vista/cambiarPassword.jsp?error=ex");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}

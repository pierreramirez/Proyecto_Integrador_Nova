package Controlador;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import DAO.DAOUsuarios;
import Modelo.DTOUsuario;
import Util.EmailUtil;
import org.mindrot.jbcrypt.BCrypt;
import javax.mail.MessagingException;

/**
 * srvIniciarSesion - servlet para login, 2FA por email, registro y recuperación
 * de contraseña.
 */
public class srvIniciarSesion extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Forzar UTF-8
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

    /**
     * Verificar credenciales: si OK -> generar código 2FA y enviar por email.
     */
    private void VerificarLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String correo = request.getParameter("txtCorreo");
            String contra = request.getParameter("txtPassword");

            if (correo == null || correo.trim().isEmpty() || contra == null) {
                response.sendRedirect("Vista/login.jsp?error=cred");
                return;
            }

            DAOUsuarios dao = new DAOUsuarios();
            DTOUsuario user = dao.getUserByEmail(correo);

            if (user == null) {
                System.out.println("DEBUG: getUserByEmail devolvió NULL para email=" + correo);
                response.sendRedirect("Vista/login.jsp?error=cred");
                return;
            } else {
                System.out.println("DEBUG: usuario encontrado email=" + user.getEmail() + " rol=" + user.getRol() + " hashExists=" + (user.getContra() != null));
            }

            // comprobar hash con BCrypt
            if (user.getContra() != null && BCrypt.checkpw(contra, user.getContra())) {
                String codigo = String.format("%06d", (int) (Math.random() * 900000) + 100000);
                HttpSession ses = request.getSession();
                ses.setAttribute("codigo2FA", codigo);
                ses.setAttribute("userTemp", user);
                long expiracion = System.currentTimeMillis() + (5 * 60 * 1000); // 5 minutos
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
                System.out.println("DEBUG: BCrypt.checkpw returned FALSE para email=" + correo);
                response.sendRedirect("Vista/login.jsp?error=cred");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Vista/login.jsp?error=ex");
        }
    }

    /**
     * Confirmar código 2FA: si OK -> guardar usuario en sesión y redirigir
     * según rol.
     */
    private void ConfirmarCodigo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String codigoEnviado = request.getParameter("txtCodigo");
            HttpSession ses = request.getSession(false);
            if (ses == null) {
                response.sendRedirect("Vista/login.jsp");
                return;
            }

            Object oCodigo = ses.getAttribute("codigo2FA");
            Object oExpira = ses.getAttribute("codigoExpira");
            String codigoCorrecto = oCodigo != null ? oCodigo.toString() : null;
            long expira = 0L;
            if (oExpira instanceof Long) {
                expira = (Long) oExpira;
            } else if (oExpira instanceof Integer) {
                expira = ((Integer) oExpira).longValue();
            } else if (oExpira instanceof String) {
                try {
                    expira = Long.parseLong((String) oExpira);
                } catch (Exception e) {
                    expira = 0L;
                }
            }

            if (codigoCorrecto != null && expira > 0 && System.currentTimeMillis() <= expira && codigoCorrecto.equals(codigoEnviado)) {
                DTOUsuario user = (DTOUsuario) ses.getAttribute("userTemp");
                if (user == null) {
                    response.sendRedirect("Vista/login.jsp");
                    return;
                }

                System.out.println("DEBUG: Usuario logueado email=" + user.getEmail() + " rol=" + user.getRol());

                ses.setAttribute("user", user);
                ses.setMaxInactiveInterval(30 * 60); // 30 minutos

                // limpiar 2FA
                ses.removeAttribute("codigo2FA");
                ses.removeAttribute("codigoExpira");
                ses.removeAttribute("userTemp");

                // redirigir según rol
                int rol = user.getRol();
                if (rol == 1) {
                    response.sendRedirect("Vista/Administrador/index.jsp");
                } else if (rol == 2) {
                    response.sendRedirect("Vista/Empleado/index.jsp");
                } else if (rol == 3) {
                    response.sendRedirect("Vista/index.jsp");
                } else {
                    System.out.println("DEBUG: rol inesperado (" + rol + "), redirigiendo a login");
                    response.sendRedirect("Vista/login.jsp?error=rol");
                }
            } else {
                response.sendRedirect("Vista/verificarCodigo.jsp?error=cod");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("Vista/login.jsp?error=ex2");
        }
    }

    /**
     * Registrar nuevo usuario (básico).
     */
    private void Registrar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String appat = request.getParameter("appat");
            String apmat = request.getParameter("apmat");
            String nombre = request.getParameter("nombre");
            String dniStr = request.getParameter("dni");
            String email = request.getParameter("email");
            String pass = request.getParameter("password");

            if (appat == null || nombre == null || dniStr == null || email == null || pass == null) {
                response.sendRedirect("Vista/registro.jsp?error=missing");
                return;
            }

            int dni = 0;
            try {
                dni = Integer.parseInt(dniStr);
            } catch (NumberFormatException nfe) {
                /* deja 0 */ }

            String hashed = BCrypt.hashpw(pass, BCrypt.gensalt(12));

            DTOUsuario u = new DTOUsuario();
            u.setAppat(appat);
            u.setApmat(apmat);
            u.setNombre(nombre);
            u.setDni(dni);
            u.setEmail(email);
            u.setContra(hashed);

            // Asignar rol por defecto: 3 = cliente (ajusta si tu sistema usa otros códigos)
            u.setRol(3);

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

    /**
     * Cerrar sesión.
     */
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

    /**
     * Solicitar recuperación: genera y envía código por email si existe el
     * usuario.
     */
    private void SolicitarRecuperacion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String correo = request.getParameter("txtCorreoRecup");
            if (correo == null || correo.trim().isEmpty()) {
                response.sendRedirect("Vista/recuperar.jsp?error=missing");
                return;
            }

            DAOUsuarios dao = new DAOUsuarios();
            DTOUsuario user = dao.getUserByEmail(correo);
            if (user == null) {
                response.sendRedirect("Vista/recuperar.jsp?error=noexist");
                return;
            }

            String codigo = String.format("%06d", (int) (Math.random() * 900000) + 100000);
            HttpSession ses = request.getSession();
            ses.setAttribute("recupEmail", correo);
            ses.setAttribute("recupCodigo", codigo);
            ses.setAttribute("recupExpira", System.currentTimeMillis() + (10 * 60 * 1000)); // 10 minutos
            ses.setAttribute("recupIntentos", 0);

            try {
                EmailUtil.enviarCodigoVerificacion(correo, codigo);
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

    /**
     * Verificar código de recuperación: si OK -> ir a cambiarPassword.jsp.
     */
    private void VerificarRecuperacion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String codigoIngresado = request.getParameter("txtCodigoRecup");
            HttpSession ses = request.getSession(false);
            if (ses == null) {
                response.sendRedirect("Vista/recuperar.jsp");
                return;
            }

            Object oCodigo = ses.getAttribute("recupCodigo");
            Object oExpira = ses.getAttribute("recupExpira");
            Object oIntentos = ses.getAttribute("recupIntentos");

            String codigoCorrecto = oCodigo != null ? oCodigo.toString() : null;
            long expira = 0L;
            if (oExpira instanceof Long) {
                expira = (Long) oExpira;
            } else if (oExpira instanceof Integer) {
                expira = oExpira != null ? ((Integer) oExpira).longValue() : 0L;
            } else if (oExpira instanceof String) {
                try {
                    expira = Long.parseLong((String) oExpira);
                } catch (Exception e) {
                    expira = 0L;
                }
            }

            int intentos = 0;
            if (oIntentos instanceof Integer) {
                intentos = (Integer) oIntentos;
            } else if (oIntentos instanceof Long) {
                intentos = ((Long) oIntentos).intValue();
            }

            // control de expiración
            if (expira > 0 && System.currentTimeMillis() > expira) {
                ses.removeAttribute("recupCodigo");
                ses.removeAttribute("recupExpira");
                ses.removeAttribute("recupIntentos");
                response.sendRedirect("Vista/recuperar.jsp?error=exp");
                return;
            }

            if (codigoCorrecto != null && codigoCorrecto.equals(codigoIngresado)) {
                // permitir cambiar password
                response.sendRedirect("Vista/cambiarPassword.jsp");
            } else {
                intentos++;
                ses.setAttribute("recupIntentos", intentos);
                if (intentos >= 3) {
                    // bloquear y forzar re-solicitud
                    ses.removeAttribute("recupCodigo");
                    ses.removeAttribute("recupExpira");
                    ses.removeAttribute("recupIntentos");
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

    /**
     * Cambiar contraseña (desde cambiarPassword.jsp). Usa el email guardado en
     * sesión por solicitarRecuperacion.
     */
    private void CambiarPassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String pass1 = request.getParameter("password1");
            String pass2 = request.getParameter("password2");

            if (pass1 == null || pass2 == null || !pass1.equals(pass2)) {
                response.sendRedirect("Vista/cambiarPassword.jsp?error=match");
                return;
            }
            if (pass1.length() < 6) {
                response.sendRedirect("Vista/cambiarPassword.jsp?error=short");
                return;
            }

            HttpSession ses = request.getSession(false);
            if (ses == null) {
                response.sendRedirect("Vista/recuperar.jsp");
                return;
            }
            Object oCorreo = ses.getAttribute("recupEmail");
            String correo = oCorreo != null ? oCorreo.toString() : null;
            if (correo == null) {
                response.sendRedirect("Vista/recuperar.jsp");
                return;
            }

            String hashed = BCrypt.hashpw(pass1, BCrypt.gensalt(12));
            DAOUsuarios dao = new DAOUsuarios();
            boolean ok = dao.actualizarContrasena(correo, hashed);
            if (ok) {
                // limpiar atributos relacionados con la recuperación
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

    // doGet / doPost
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}

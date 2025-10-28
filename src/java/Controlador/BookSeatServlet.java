package Controlador;

import DAO.DAOVentaPasaje;
import Modelo.DTOUsuario;
import java.io.*;
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.SQLException;
import javax.servlet.*;
import javax.servlet.http.*;

public class BookSeatServlet extends HttpServlet {

    DAOVentaPasaje dao = new DAOVentaPasaje();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String sIdViaje = req.getParameter("idViaje");
        String sAsiento = req.getParameter("asiento");
        if (sIdViaje == null || sAsiento == null) {
            resp.sendRedirect(req.getContextPath() + "/rutas.jsp?error=parametros_invalidos");
            return;
        }

        int idViaje;
        int asiento;
        try {
            idViaje = Integer.parseInt(sIdViaje);
            asiento = Integer.parseInt(sAsiento);
        } catch (NumberFormatException ex) {
            resp.sendRedirect(req.getContextPath() + "/selectSeat?idViaje=" + sIdViaje + "&error=parametros_invalidos");
            return;
        }

        // Obtener idCliente: intenta idUsuario en sesión o el objeto 'user'
        HttpSession session = req.getSession(false);
        Integer idCliente = null;
        if (session != null) {
            Object idObj = session.getAttribute("idUsuario");
            if (idObj instanceof Integer) idCliente = (Integer) idObj;
            else {
                Object userObj = session.getAttribute("user");
                if (userObj instanceof DTOUsuario) {
                    idCliente = ((DTOUsuario) userObj).getIdUsuario();
                }
            }
        }

        if (idCliente == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            boolean ok = dao.reservarAsientoSeguro(idViaje, idCliente, asiento, idCliente);
            if (ok) {
                resp.sendRedirect(req.getContextPath() + "/confirmacion.jsp?success=1");
            } else {
                resp.sendRedirect(req.getContextPath() + "/selectSeat?idViaje=" + idViaje + "&error=asiento_no_disponible");
            }
        } catch (SQLIntegrityConstraintViolationException ex) {
            // unique constraint: asiento ya vendido
            resp.sendRedirect(req.getContextPath() + "/selectSeat?idViaje=" + idViaje + "&error=asiento_no_disponible");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

package Controlador;

import DAO.DAOAsientoViaje;
import DAO.DAOViaje;
import Modelo.DTOViaje;

import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;

public class ReservaServlet extends HttpServlet {

    private final DAOAsientoViaje daoAsiento = new DAOAsientoViaje();
    private final DAOViaje daoViaje = new DAOViaje();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("init".equalsIgnoreCase(action)) {
            // Mostrar resumen del viaje (sin elegir asiento)
            String sViaje = req.getParameter("viajeId");
            if (sViaje == null) {
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
            try {
                int viajeId = Integer.parseInt(sViaje);
                DTOViaje v = daoViaje.obtenerPorId(viajeId);
                req.setAttribute("viaje", v);
                req.getRequestDispatcher("/Vista/Cliente/reserva_init.jsp").forward(req, resp);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        }

        if ("reserveForm".equalsIgnoreCase(action)) {
            // Llamado cuando el usuario hace click en un asiento disponible -> mostrar form con asiento seleccionado
            String sViaje = req.getParameter("viajeId");
            String sAsientoId = req.getParameter("asientoId"); // NOTA: pedir asientoId (PK)
            if (sViaje == null || sAsientoId == null) {
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
            try {
                int viajeId = Integer.parseInt(sViaje);
                int asientoId = Integer.parseInt(sAsientoId);
                DTOViaje v = daoViaje.obtenerPorId(viajeId);
                req.setAttribute("viaje", v);
                req.setAttribute("asientoId", asientoId);
                req.getRequestDispatcher("/Vista/Cliente/reserva_form.jsp").forward(req, resp);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        }

        // default
        resp.sendRedirect(req.getContextPath() + "/");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Confirmar reserva: action=confirm
        String action = req.getParameter("action");
        if ("confirm".equalsIgnoreCase(action)) {
            try {
                String sAsientoId = req.getParameter("asientoId");
                if (sAsientoId == null) {
                    req.setAttribute("error", "Falta identificar el asiento.");
                    req.getRequestDispatcher("/Vista/Cliente/reserva_form.jsp").forward(req, resp);
                    return;
                }
                int asientoId = Integer.parseInt(sAsientoId);

                // opcional: obtener clienteId de sesión
                Integer clienteId = (Integer) req.getSession().getAttribute("userId");

                // Usamos el método existente reservarAsientoAtomic(idAsientoViaje)
                boolean ok = daoAsiento.reservarAsientoAtomic(asientoId);

                if (ok) {
                    resp.sendRedirect(req.getContextPath() + "/Vista/Cliente/reserva_confirmada.jsp?asientoId=" + asientoId);
                } else {
                    req.setAttribute("error", "No se pudo reservar el asiento (tal vez ya fue ocupado).");
                    req.getRequestDispatcher("/Vista/Cliente/reserva_form.jsp").forward(req, resp);
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/");
    }
}

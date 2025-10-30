package Controlador;

import DAO.DAOViaje;
import DAO.DAOAsientoViaje;
import DAO.DAOLugar;
import Modelo.DTOViaje;
import Modelo.DTOLugar;

import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class DestinoServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final DAOViaje daoViaje = new DAOViaje();
    private final DAOAsientoViaje daoAsiento = new DAOAsientoViaje();
    private final DAOLugar daoLugar = new DAOLugar();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String sDestino = req.getParameter("destinoId");
        System.out.println("DestinoServlet: parametro destinoId = " + sDestino);

        if (sDestino == null || sDestino.trim().isEmpty()) {
            // Parámetro ausente -> redirigir al índice o mostrar mensaje
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        int destinoId;
        try {
            destinoId = Integer.parseInt(sDestino);
        } catch (NumberFormatException nfe) {
            System.err.println("DestinoServlet: destinoId no es número -> " + sDestino);
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        try {
            List<DTOViaje> viajes = daoViaje.listarPorDestino(destinoId);
            System.out.println("DestinoServlet: viajes recuperados -> " + (viajes == null ? "null" : viajes.size()));

            if (viajes != null) {
                for (DTOViaje v : viajes) {
                    try {
                        int disp = daoAsiento.contarDisponibles(v.getIdViaje());
                        System.out.println("Viaje " + v.getIdViaje() + " disponibles = " + disp);
                        v.setDisponibles(disp);
                    } catch (Exception e) {
                        // no abortar todo si falla contarDisponibles para un viaje
                        System.err.println("Error contando asientos para viaje " + v.getIdViaje() + ": " + e.getMessage());
                        v.setDisponibles(0);
                    }
                }
            }

            DTOLugar lugar = null;
            try {
                lugar = daoLugar.obtenerPorId(destinoId);
            } catch (Exception e) {
                System.err.println("Error obteniendo lugar id=" + destinoId + ": " + e.getMessage());
            }

            // Si quieres ver errores en la página durante desarrollo:
            req.setAttribute("viajes", viajes);
            req.setAttribute("lugar", lugar);
            req.getRequestDispatcher("/Vista/Cliente/viajes_destino.jsp").forward(req, resp);

        } catch (Exception e) {
            // loguear y devolver una respuesta de error para debug
            e.printStackTrace();
            resp.setContentType("text/html;charset=UTF-8");
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = resp.getWriter()) {
                out.println("<h2>Error al procesar destino</h2>");
                out.println("<pre>");
                e.printStackTrace(out);
                out.println("</pre>");
            }
        }
    }
}

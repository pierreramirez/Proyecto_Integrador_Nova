package Controlador;

import DAO.DAOAsientoViaje;
import DAO.DAOViaje;
import Modelo.DTOAsientoViaje;
import Modelo.DTOViaje;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class VerAsientosServlet extends HttpServlet {

    private final DAOAsientoViaje daoAsiento = new DAOAsientoViaje();
    private final DAOViaje daoViaje = new DAOViaje();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String sViaje = req.getParameter("viajeId");
        String cantidadParam = req.getParameter("cantidad");
        String format = req.getParameter("format"); // soporte format=json

        if (sViaje == null || sViaje.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        try {
            int viajeId = Integer.parseInt(sViaje);

            // obtener viaje (para mostrar resumen)
            DTOViaje viaje = null;
            try {
                viaje = daoViaje.obtenerPorId(viajeId);
            } catch (Exception exV) {
                // si falla, dejamos viaje null (no fatal)
                exV.printStackTrace();
            }

            // listar asientos (DAO debe devolver List<DTOAsientoViaje>)
            List<DTOAsientoViaje> asientos = daoAsiento.listarAsientosPorViaje(viajeId);

            // Si piden JSON (API), exportamos un JSON simple
            if ("json".equalsIgnoreCase(format) ) {
                resp.setContentType("application/json; charset=UTF-8");
                PrintWriter out = resp.getWriter();

                StringBuilder sb = new StringBuilder();
                sb.append("[");
                boolean first = true;
                for (DTOAsientoViaje a : asientos) {
                    if (!first) sb.append(",");
                    first = false;
                    int id = a.getIdAsientoViaje();
                    int numero = a.getNumeroAsiento();
                    int estado = a.getEstado();
                    boolean disponible = (estado == 0);
                    sb.append("{");
                    sb.append("\"id\":").append(id).append(",");
                    sb.append("\"numero\":").append(numero).append(",");
                    sb.append("\"fila\":").append("null").append(",");
                    sb.append("\"columna\":").append("null").append(",");
                    sb.append("\"disponible\":").append(disponible);
                    sb.append("}");
                }
                sb.append("]");
                out.print(sb.toString());
                out.flush();
                return;
            }

            // forward al JSP normal: seteamos atributos (incluimos 'cantidad' para que el JSP sepa cuántos seleccionar)
            req.setAttribute("viaje", viaje);
            req.setAttribute("asientos", asientos);
            if (cantidadParam != null) req.setAttribute("cantidad", cantidadParam);

            // forward a la vista (asegúrate de que la ruta coincide con tu proyecto)
            req.getRequestDispatcher("/Vista/Cliente/ver_asientos.jsp").forward(req, resp);

        } catch (NumberFormatException nfe) {
            nfe.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/");
        } catch (Exception e) {
            e.printStackTrace();
            // en error devolvemos al inicio (puedes crear una JSP de error y forwardearla)
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    // soportar POST redirigiendo a GET (útil si llamas desde un form)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }
}

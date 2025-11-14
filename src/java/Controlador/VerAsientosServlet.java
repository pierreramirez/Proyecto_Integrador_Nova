package Controlador;

import DAO.DAOAsientoViaje;
import DAO.DAOViaje;
import Modelo.DTOAsientoViaje;
import Modelo.DTOViaje;

import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class VerAsientosServlet extends HttpServlet {

    private final DAOAsientoViaje daoAsiento = new DAOAsientoViaje();
    private final DAOViaje daoViaje = new DAOViaje();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String sViaje = req.getParameter("viajeId");
        if (sViaje == null || sViaje.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        try {
            int viajeId = Integer.parseInt(sViaje);
            DTOViaje viaje = daoViaje.obtenerPorId(viajeId);
            List<DTOAsientoViaje> asientos = daoAsiento.listarAsientosPorViaje(viajeId);

            String format = req.getParameter("format"); // if format=json -> return JSON
            if ("json".equalsIgnoreCase(format) || "list".equalsIgnoreCase(req.getParameter("action"))) {
                resp.setContentType("application/json; charset=UTF-8");
                PrintWriter out = resp.getWriter();

                // Simple JSON builder (safe porque los campos son enteros/boleanos)
                StringBuilder sb = new StringBuilder();
                sb.append("[");
                boolean first = true;
                for (DTOAsientoViaje a : asientos) {
                    if (!first) {
                        sb.append(",");
                    }
                    first = false;

                    int id = a.getIdAsientoViaje();
                    int numero = a.getNumeroAsiento();
                    int estado = a.getEstado();
                    boolean disponible = (estado == 0);

                    sb.append("{");
                    sb.append("\"id\":").append(id).append(",");
                    sb.append("\"numero\":").append(numero).append(",");
                    sb.append("\"fila\":").append("null").append(",");    // si no tienes fila/columna, deja null
                    sb.append("\"columna\":").append("null").append(",");
                    sb.append("\"disponible\":").append(disponible);
                    sb.append("}");
                }
                sb.append("]");
                out.print(sb.toString());
                out.flush();
                return;
            }

            // default: render JSP server-side (tu comportamiento original)
            req.setAttribute("viaje", viaje);
            req.setAttribute("asientos", asientos);
            req.getRequestDispatcher("/Vista/Cliente/ver_asientos.jsp").forward(req, resp);

        } catch (NumberFormatException nfe) {
            nfe.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}

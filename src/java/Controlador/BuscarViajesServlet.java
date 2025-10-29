package Controlador;

import DAO.DAOViaje;
import DAO.DAOLugar;
import Modelo.DTOViaje;
import Modelo.DTOLugar;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;

public class BuscarViajesServlet extends HttpServlet {

    private DAOViaje dao = new DAOViaje();
    private DAOLugar daoLugar = new DAOLugar();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<DTOLugar> lugares = daoLugar.listarActivos();
            request.setAttribute("lugares", lugares);

            String origenParam = request.getParameter("origen_id");
            String destinoParam = request.getParameter("destino_id");

            if (origenParam != null && destinoParam != null && !origenParam.isEmpty() && !destinoParam.isEmpty()) {
                int origen = Integer.parseInt(origenParam);
                int destino = Integer.parseInt(destinoParam);
                List<DTOViaje> viajes = dao.listarPorDestinoOrigen(destino, origen);
                request.setAttribute("viajes", viajes);
            }

            request.getRequestDispatcher("/cliente/resultados.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}

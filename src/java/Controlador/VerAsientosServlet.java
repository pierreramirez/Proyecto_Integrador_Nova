package Controlador;

import DAO.DAOAsientoViaje;
import DAO.DAOViaje;
import Modelo.DTOAsientoViaje;
import Modelo.DTOViaje;

import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
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
            req.setAttribute("viaje", viaje);
            req.setAttribute("asientos", asientos);
            req.getRequestDispatcher("/Vista/Cliente/ver_asientos.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}

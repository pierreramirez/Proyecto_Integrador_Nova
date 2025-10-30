package Controlador;

import DAO.DAOViaje;
import DAO.DAOAsientoViaje;
import Modelo.DTOViaje;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

public class BuscarPasajesServlet extends HttpServlet {

    private DAOViaje daoViaje = new DAOViaje();
    private DAOAsientoViaje daoAsiento = new DAOAsientoViaje();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String sOrigen = req.getParameter("origen");
            String sDestino = req.getParameter("destino");
            String sFecha = req.getParameter("fechaSalida");
            // En tu DB usas IDs; si en el form mandas nombres, debes mapearlos a idLugar (ej. con DAOLugar).
            // Aquí asumo que el form manda IDs en los select (recomiendo cambiar en index).
            int origen = Integer.parseInt(sOrigen);
            int destino = Integer.parseInt(sDestino);
            Date fecha = Date.valueOf(sFecha);

            // Si quieres filtrar por fecha exacta, podrías agregar un método DAOViaje.listarPorDestinoOrigenFecha
            // por simplicidad usamos listarPorDestino y filtramos fecha en Java:
            List<DTOViaje> viajes = daoViaje.listarPorDestino(destino);
            viajes.removeIf(v -> v.getFechaSalida() == null || !v.getFechaSalida().equals(fecha));

            for (DTOViaje v : viajes) {
                v.setDisponibles(daoAsiento.contarDisponibles(v.getIdViaje()));
            }

            req.setAttribute("viajes", viajes);
            req.getRequestDispatcher("/Vista/Cliente/viajes_destino.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}

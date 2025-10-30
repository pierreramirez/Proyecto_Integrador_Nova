package Controlador;

import DAO.DAOAsientoViaje;
import Modelo.DTOAsientoViaje;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/SeatSelectorServlet")
public class SeatSelectorServlet extends HttpServlet {

    private final DAOAsientoViaje daoAsiento = new DAOAsientoViaje();

    @Override
    protected void doGet(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws ServletException, IOException {
        String sIdViaje = request.getParameter("idViaje");
        if (sIdViaje == null || sIdViaje.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cliente/buscar.jsp");
            return;
        }
        int idViaje;
        try {
            idViaje = Integer.parseInt(sIdViaje);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/cliente/buscar.jsp");
            return;
        }
        try {
            List<DTOAsientoViaje> asientos = daoAsiento.listarAsientosPorViaje(idViaje);
            request.setAttribute("asientos", asientos);
            request.setAttribute("idViaje", idViaje);
            request.getRequestDispatcher("/Vista/Cliente/seleccionarAsiento.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}

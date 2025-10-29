package Controlador;

import DAO.DAOReserva;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

public class BookSeatServlet extends HttpServlet {

    private DAOReserva daoReserva = new DAOReserva();

    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws ServletException, IOException {
        int idViaje = Integer.parseInt(request.getParameter("idViaje"));
        int idAsiento = Integer.parseInt(request.getParameter("idAsiento"));
        // tomar idCliente desde sesión si hay login
        HttpSession session = request.getSession(false);
        int idCliente = 0;
        if (session != null && session.getAttribute("clienteId") != null) {
            idCliente = (int) session.getAttribute("clienteId");
        } else {
            // fallback: si lo mandan por parametro (temporal)
            String sCliente = request.getParameter("idCliente");
            if (sCliente != null) {
                try { idCliente = Integer.parseInt(sCliente); } catch (NumberFormatException ignored) {}
            }
        }

        if (idCliente <= 0) {
            request.getSession().setAttribute("msg", "Debes iniciar sesión para reservar.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int idReserva = daoReserva.crearReserva(idViaje, idAsiento, idCliente);
            if (idReserva > 0) {
                request.getSession().setAttribute("msg", "Reserva creada. ID: " + idReserva);
                response.sendRedirect(request.getContextPath() + "/cliente/misReservas.jsp");
            } else {
                request.getSession().setAttribute("msg", "Asiento ya no disponible.");
                response.sendRedirect(request.getContextPath() + "/SeatSelectorServlet?idViaje=" + idViaje);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}

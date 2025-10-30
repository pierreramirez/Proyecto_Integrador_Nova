package Controlador;

import DAO.DAOReserva;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/BookSeatServlet")
public class BookSeatServlet extends HttpServlet {

    private final DAOReserva daoReserva = new DAOReserva();

    @Override
    protected void doPost(javax.servlet.http.HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws ServletException, IOException {
        String sIdViaje = request.getParameter("idViaje");
        String sIdAsiento = request.getParameter("idAsiento");

        if (sIdViaje == null || sIdAsiento == null) {
            request.getSession().setAttribute("msg", "Parámetros inválidos.");
            response.sendRedirect(request.getContextPath() + "/cliente/buscar.jsp");
            return;
        }

        int idViaje, idAsiento, idCliente = 0;
        try {
            idViaje = Integer.parseInt(sIdViaje);
            idAsiento = Integer.parseInt(sIdAsiento);
        } catch (NumberFormatException ex) {
            request.getSession().setAttribute("msg", "Parámetros inválidos.");
            response.sendRedirect(request.getContextPath() + "/cliente/buscar.jsp");
            return;
        }

        // Obtener idCliente desde sesión (recomendado)
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("clienteId") != null) {
            try {
                idCliente = Integer.parseInt(session.getAttribute("clienteId").toString());
            } catch (Exception ignored) {
            }
        } else {
            // fallback: si mandan por parámetro (temporal)
            String sCliente = request.getParameter("idCliente");
            if (sCliente != null) {
                try {
                    idCliente = Integer.parseInt(sCliente);
                } catch (NumberFormatException ignored) {
                }
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
                request.getSession().setAttribute("msg", "Reserva creada exitosamente. ID: " + idReserva);
                response.sendRedirect(request.getContextPath() + "/cliente/misReservas.jsp");
            } else {
                request.getSession().setAttribute("msg", "El asiento ya no está disponible.");
                response.sendRedirect(request.getContextPath() + "/SeatSelectorServlet?idViaje=" + idViaje);
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}

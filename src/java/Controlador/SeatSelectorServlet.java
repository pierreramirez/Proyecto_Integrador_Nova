package Controlador;

import DAO.DAOVentaPasaje;
import Persistencia.Conexion;
import java.io.*;
import java.sql.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class SeatSelectorServlet extends HttpServlet {
    DAOVentaPasaje daoVenta = new DAOVentaPasaje();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String sIdViaje = req.getParameter("idViaje");
        if (sIdViaje == null) {
            resp.sendRedirect(req.getContextPath() + "/rutas.jsp?error=parametros_invalidos");
            return;
        }

        int idViaje;
        try {
            idViaje = Integer.parseInt(sIdViaje);
        } catch (NumberFormatException ex) {
            resp.sendRedirect(req.getContextPath() + "/rutas.jsp?error=parametros_invalidos");
            return;
        }

        try (Connection c = new Conexion().getConnection()) {
            String sql = "SELECT rv.*, b.capacidadAsientos, b.placa, lo.nombre AS origen_nombre, ld.nombre AS destino_nombre " +
                         "FROM ruta_viaje rv " +
                         "JOIN bus b ON rv.idBus = b.idBus " +
                         "LEFT JOIN lugares lo ON rv.origen = lo.idLugar " +
                         "LEFT JOIN lugares ld ON rv.destino = ld.idLugar " +
                         "WHERE rv.idViaje = ?";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, idViaje);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        resp.sendRedirect(req.getContextPath() + "/rutas.jsp?error=ruta_no_encontrada");
                        return;
                    }

                    Map<String,Object> ruta = new HashMap<>();
                    ruta.put("idViaje", rs.getInt("idViaje"));
                    ruta.put("origen", rs.getInt("origen"));
                    ruta.put("origenNombre", rs.getString("origen_nombre"));
                    ruta.put("destino", rs.getInt("destino"));
                    ruta.put("destinoNombre", rs.getString("destino_nombre"));
                    ruta.put("fechaSalida", rs.getDate("fechaSalida"));
                    ruta.put("horaSalida", rs.getTime("horaSalida"));
                    ruta.put("precio", rs.getBigDecimal("precio"));
                    ruta.put("capacidadAsientos", rs.getInt("capacidadAsientos"));
                    ruta.put("boletosRestantes", rs.getInt("boletosRestantes"));
                    ruta.put("placa", rs.getString("placa"));

                    req.setAttribute("ruta", ruta);

                    // obtener asientos vendidos via DAO
                    Set<Integer> vendidos = daoVenta.getAsientosVendidos(idViaje);
                    req.setAttribute("vendidos", vendidos);

                    // generar lista 1..capacidad para el JSP
                    int cap = (int) ruta.get("capacidadAsientos");
                    List<Integer> asientos = new ArrayList<>();
                    for (int i = 1; i <= cap; i++) asientos.add(i);
                    req.setAttribute("asientos", asientos);

                    req.getRequestDispatcher("Vista/seleccionarAsiento.jsp").forward(req, resp);
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}

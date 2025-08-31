package Controlador;

import Modelo.DTORuta;
import DAO.DAORutas;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RutaServlet extends HttpServlet {
    DAORutas dao = new DAORutas();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                request.getRequestDispatcher("Vista/Administrador/Ruta/agregar.jsp").forward(request, response);
                break;

            case "edit":
                int idEdit = Integer.parseInt(request.getParameter("id"));
                DTORuta rutaEdit = dao.ObtenerRuta(idEdit);
                request.setAttribute("ruta", rutaEdit);
                request.getRequestDispatcher("Vista/Administrador/Ruta/editar.jsp").forward(request, response);
                break;

            case "delete":
                int idDelete = Integer.parseInt(request.getParameter("id"));
                dao.EliminarRuta(idDelete);
                response.sendRedirect("RutaServlet?action=list");
                break;

            case "list":
            default:
                List<DTORuta> lista = dao.ListarRutas();
                request.setAttribute("lista", lista);
                request.getRequestDispatcher("Vista/Administrador/Ruta/listar.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            DTORuta r = new DTORuta();
            r.setIdBus(Integer.parseInt(request.getParameter("idBus")));
            r.setIdChofer(Integer.parseInt(request.getParameter("idChofer")));
            r.setFechaSalida(Date.valueOf(request.getParameter("fechaSalida")));
            r.setHoraSalida(Time.valueOf(request.getParameter("horaSalida") + ":00"));
            r.setFechaLlegada(Date.valueOf(request.getParameter("fechaLlegada")));
            r.setHoraLlegada(Time.valueOf(request.getParameter("horaLlegada") + ":00"));
            r.setOrigen(Integer.parseInt(request.getParameter("origen")));
            r.setDestino(Integer.parseInt(request.getParameter("destino")));
            r.setPrecio(new BigDecimal(request.getParameter("precio")));
            r.setBoletosRestantes(Integer.parseInt(request.getParameter("boletosRestantes")));
            r.setCreador(Integer.parseInt(request.getParameter("creador")));
            r.setEstado(Integer.parseInt(request.getParameter("estado")));
            // fechaCreacion ya lo maneja el DAO con NOW()

            dao.AgregarRuta(r);
            response.sendRedirect("RutaServlet?action=list");
        } 
        else if ("update".equals(action)) {
            DTORuta r = new DTORuta();
            r.setIdViaje(Integer.parseInt(request.getParameter("idViaje")));
            r.setIdBus(Integer.parseInt(request.getParameter("idBus")));
            r.setIdChofer(Integer.parseInt(request.getParameter("idChofer")));
            r.setFechaSalida(Date.valueOf(request.getParameter("fechaSalida")));
            r.setHoraSalida(Time.valueOf(request.getParameter("horaSalida") + ":00"));
            r.setFechaLlegada(Date.valueOf(request.getParameter("fechaLlegada")));
            r.setHoraLlegada(Time.valueOf(request.getParameter("horaLlegada") + ":00"));
            r.setOrigen(Integer.parseInt(request.getParameter("origen")));
            r.setDestino(Integer.parseInt(request.getParameter("destino")));
            r.setPrecio(new BigDecimal(request.getParameter("precio")));
            r.setBoletosRestantes(Integer.parseInt(request.getParameter("boletosRestantes")));
            r.setCreador(Integer.parseInt(request.getParameter("creador")));
            r.setEstado(Integer.parseInt(request.getParameter("estado")));

            dao.EditarRuta(r); // ✅ corregido: ahora llama al método del DAO
            response.sendRedirect("RutaServlet?action=list");
        }
    }
}

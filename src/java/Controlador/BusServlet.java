package Controlador;

import Modelo.DTOBuses;
import DAO.DAOBuses;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;

public class BusServlet extends HttpServlet {

    DAOBuses dao = new DAOBuses();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        switch (action) {
            case "listar": {
                List<DTOBuses> lista = dao.listarBuses();
                request.setAttribute("buses", lista);
                request.getRequestDispatcher("Vista/Administrador/Bus/listar.jsp").forward(request, response);
                break;
            }
            case "agregar": {
                request.getRequestDispatcher("Vista/Administrador/Bus/agregar.jsp").forward(request, response);
                break;
            }
            case "editar": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DTOBuses bus = dao.obtenerBus(id);
                    request.setAttribute("bus", bus);
                    request.getRequestDispatcher("Vista/Administrador/editar.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("BusServlet?action=listar");
                }
                break;
            }
            case "eliminar": {
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    dao.eliminarBus(idEliminar);
                } catch (NumberFormatException ignored) {}
                response.sendRedirect("BusServlet?action=listar");
                break;
            }
            default:
                response.sendRedirect("BusServlet?action=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        DTOBuses b = new DTOBuses();

        if ("add".equals(action)) {
            b.setPlaca(request.getParameter("placa"));
            b.setCapacidadAsientos(Integer.parseInt(request.getParameter("capacidadAsientos")));
            b.setTipo(request.getParameter("tipo"));
            b.setDescripcion(request.getParameter("descripcion"));
            b.setCreador(1); // Opcional: puedes reemplazar con el usuario logueado
            b.setFechaCreacion(new java.util.Date());
            b.setEstado(Integer.parseInt(request.getParameter("estado")));

            dao.agregarBus(b);
            response.sendRedirect("BusServlet?action=listar");
            return;
        }

        if ("update".equals(action)) {
            b.setIdBus(Integer.parseInt(request.getParameter("idBus")));
            b.setPlaca(request.getParameter("placa"));
            b.setCapacidadAsientos(Integer.parseInt(request.getParameter("capacidadAsientos")));
            b.setTipo(request.getParameter("tipo"));
            b.setDescripcion(request.getParameter("descripcion"));
            b.setEstado(Integer.parseInt(request.getParameter("estado")));

            dao.actualizarBus(b);
            response.sendRedirect("BusServlet?action=listar");
        }
    }
}

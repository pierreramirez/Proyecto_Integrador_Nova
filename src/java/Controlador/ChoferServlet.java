package Controlador;

import Modelo.DTOChofer;
import DAO.DAOChoferes;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;

public class ChoferServlet extends HttpServlet {

    DAOChoferes dao = new DAOChoferes();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // CASO DE PRUEBA
        String test = request.getParameter("test");
        if ("true".equals(test)) {
            response.setContentType("text/plain");
            response.getWriter().println("ChoferServlet está funcionando correctamente");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        switch (action) {
            case "listar": {
                List<DTOChofer> lista = dao.ListarChoferes();
                request.setAttribute("choferes", lista);
                request.getRequestDispatcher("Vista/Administrador/Chofer/listar.jsp").forward(request, response);
                break;
            }
            case "agregar": {
                request.getRequestDispatcher("Vista/Administrador/Chofer/agregar.jsp").forward(request, response);
                break;
            }
            case "editar": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DTOChofer chofer = dao.ObtenerChofer(id);
                    request.setAttribute("chofer", chofer);
                    request.getRequestDispatcher("Vista/Administrador/Chofer/editar.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("ChoferServlet?action=listar");
                }
                break;
            }
            case "eliminar": {
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    dao.EliminarChofer(idEliminar);
                } catch (NumberFormatException ignored) {
                }
                response.sendRedirect("ChoferServlet?action=listar");
                break;
            }
            default:
                response.sendRedirect("ChoferServlet?action=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        DTOChofer c = new DTOChofer();

        if ("add".equals(action)) {
            c.setAppat(request.getParameter("appat"));
            c.setApmat(request.getParameter("apmat"));
            c.setNombre(request.getParameter("nombre"));
            c.setDni(Integer.parseInt(request.getParameter("dni")));
            c.setLicenciaConducir(request.getParameter("licenciaConducir"));
            c.setFechaContratacion(java.sql.Date.valueOf(request.getParameter("fechaContratacion")));
            c.setFechaVencimientoLicencia(java.sql.Date.valueOf(request.getParameter("fechaVencimientoLicencia")));
            c.setTelefono(Integer.parseInt(request.getParameter("telefono")));
            c.setDisponibilidad(Integer.parseInt(request.getParameter("disponibilidad")));
            c.setEstado(Integer.parseInt(request.getParameter("estado")));

            dao.AgregarChofer(c);
            response.sendRedirect("ChoferServlet?action=listar");
            return;
        }

        if ("update".equals(action)) {
            c.setId(Integer.parseInt(request.getParameter("idChofer")));
            c.setAppat(request.getParameter("appat"));
            c.setApmat(request.getParameter("apmat"));
            c.setNombre(request.getParameter("nombre"));
            c.setDni(Integer.parseInt(request.getParameter("dni")));
            c.setLicenciaConducir(request.getParameter("licenciaConducir"));
            c.setFechaContratacion(java.sql.Date.valueOf(request.getParameter("fechaContratacion")));
            c.setFechaVencimientoLicencia(java.sql.Date.valueOf(request.getParameter("fechaVencimientoLicencia")));
            c.setTelefono(Integer.parseInt(request.getParameter("telefono")));
            c.setDisponibilidad(Integer.parseInt(request.getParameter("disponibilidad")));
            c.setEstado(Integer.parseInt(request.getParameter("estado")));

            dao.ActualizarChofer(c);
            response.sendRedirect("ChoferServlet?action=listar");
        }
    }
}


package Controlador;

import Modelo.DTOCliente;
import DAO.DAOClientes;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;

public class ClienteServlet extends HttpServlet {

    DAOClientes dao = new DAOClientes();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        switch (action) {
            case "listar": {
                List<DTOCliente> lista = dao.ListarClientes();
                request.setAttribute("clientes", lista);
                request.getRequestDispatcher("Vista/Administrador/Cliente/listar.jsp").forward(request, response);
                break;
            }
            case "agregar": {
                request.getRequestDispatcher("Vista/Administrador/Cliente/agregar.jsp").forward(request, response);
                break;
            }
            case "editar": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DTOCliente cliente = dao.ObtenerCliente(id);
                    request.setAttribute("cliente", cliente);
                    request.getRequestDispatcher("Vista/Administrador/Cliente/editar.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("ClienteServlet?action=listar");
                }
                break;
            }
            case "eliminar": {
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    dao.EliminarCliente(idEliminar);
                } catch (NumberFormatException ignored) {
                }
                response.sendRedirect("ClienteServlet?action=listar");
                break;
            }
            default:
                response.sendRedirect("ClienteServlet?action=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        DTOCliente c = new DTOCliente();

        if ("add".equals(action)) {
            c.setAppat(request.getParameter("appat"));
            c.setApmat(request.getParameter("apmat"));
            c.setNombre(request.getParameter("nombre"));
            c.setDni(Integer.parseInt(request.getParameter("dni")));
            c.setFechaNacimiento(request.getParameter("fechaNacimiento"));
            c.setTelefono(Integer.parseInt(request.getParameter("telefono")));
            c.setGenero(request.getParameter("genero"));

            dao.AgregarCliente(c);
            response.sendRedirect("ClienteServlet?action=listar");
            return;
        }

        if ("update".equals(action)) {
            c.setId(Integer.parseInt(request.getParameter("idCliente")));
            c.setAppat(request.getParameter("appat"));
            c.setApmat(request.getParameter("apmat"));
            c.setNombre(request.getParameter("nombre"));
            c.setDni(Integer.parseInt(request.getParameter("dni")));
            c.setFechaNacimiento(request.getParameter("fechaNacimiento"));
            c.setTelefono(Integer.parseInt(request.getParameter("telefono")));
            c.setGenero(request.getParameter("genero"));

            dao.ActualizarCliente(c);
            response.sendRedirect("ClienteServlet?action=listar");
            return;
        }

        response.sendRedirect("ClienteServlet?action=listar");
    }
}

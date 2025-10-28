package Controlador;

import DAO.DAOLugar;
import Modelo.DTOLugar;

import java.io.*;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;

public class LugarServlet extends HttpServlet {

    private final DAOLugar dao = new DAOLugar();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "listar";

        switch (action) {
            case "listar": {
                try {
                    List<DTOLugar> lista = dao.listAll();
                    request.setAttribute("lugares", lista);
                    request.getRequestDispatcher("Vista/Administrador/Lugar/listar.jsp").forward(request, response);
                } catch (Exception e) {
                    throw new ServletException(e);
                }
                break;
            }
            case "agregar": {
                request.getRequestDispatcher("Vista/Administrador/Lugar/agregar.jsp").forward(request, response);
                break;
            }
            case "editar": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DTOLugar l = dao.getById(id);
                    request.setAttribute("lugar", l);
                    request.getRequestDispatcher("Vista/Administrador/Lugar/editar.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("LugarServlet?action=listar");
                } catch (Exception e) {
                    throw new ServletException(e);
                }
                break;
            }
            case "eliminar": {
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    dao.deleteLugar(idEliminar); // soft-delete según tu DAO
                } catch (NumberFormatException ignored) {} catch (SQLException ex) {
                Logger.getLogger(LugarServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
                response.sendRedirect("LugarServlet?action=listar");
                break;
            }
            default:
                response.sendRedirect("LugarServlet?action=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try {
                DTOLugar l = new DTOLugar();
                l.setNombre(request.getParameter("nombre"));
                l.setEstado(Integer.parseInt(request.getParameter("estado")));
                dao.crearLugar(l);
                response.sendRedirect("LugarServlet?action=listar");
                return;
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }

        if ("update".equals(action)) {
            try {
                DTOLugar l = new DTOLugar();
                l.setId(Integer.parseInt(request.getParameter("idLugar")));
                l.setNombre(request.getParameter("nombre"));
                l.setEstado(Integer.parseInt(request.getParameter("estado")));
                dao.updateLugar(l);
                response.sendRedirect("LugarServlet?action=listar");
                return;
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }

        response.sendRedirect("LugarServlet?action=listar");
    }
}

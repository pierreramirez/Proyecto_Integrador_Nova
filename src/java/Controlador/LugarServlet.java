package Controlador;

import DAO.DAOLugar;
import Modelo.DTOLugar;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;

public class LugarServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    DAOLugar dao = new DAOLugar();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        switch (action) {
            case "listar": {
                try {
                    List<DTOLugar> lista = dao.listarTodos();
                    request.setAttribute("lugares", lista);
                } catch (Exception e) {
                    request.setAttribute("error", "Error obteniendo lugares: " + e.getMessage());
                    e.printStackTrace(); // escribe en logs (catalina.out)
                }
                request.getRequestDispatcher("Vista/Administrador/Lugar/listar.jsp").forward(request, response);
                break;
            }
            case "agregar": {
                request.getRequestDispatcher("Vista/Administrador/Lugar/agregar.jsp").forward(request, response);
                break;
            }
            case "editar": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DTOLugar lugar = dao.obtenerPorId(id);
                    request.setAttribute("lugar", lugar);
                    request.getRequestDispatcher("Vista/Administrador/Lugar/editar.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("LugarServlet?action=listar");
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("LugarServlet?action=listar");
                }
                break;
            }
            case "eliminar": {
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    dao.eliminarLugar(idEliminar);
                } catch (NumberFormatException ignored) {
                } catch (Exception e) {
                    e.printStackTrace();
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
        DTOLugar l = new DTOLugar();

        if ("add".equals(action)) {
            l.setNombre(request.getParameter("nombre"));
            l.setDescripcion(request.getParameter("descripcion"));
            l.setTipo(request.getParameter("tipo"));
            try {
                l.setEstado(Integer.parseInt(request.getParameter("estado")));
            } catch (NumberFormatException e) {
                l.setEstado(1);
            }

            try {
                int id = dao.crearLugar(l);
                System.out.println("Lugar creado id=" + id);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error creando lugar: " + e.getMessage());
            }

            closeModalAndReload(response);
            return;
        }

        if ("update".equals(action)) {
            try {
                l.setIdLugar(Integer.parseInt(request.getParameter("idLugar")));
            } catch (NumberFormatException e) {
                response.sendRedirect("LugarServlet?action=listar");
                return;
            }
            l.setNombre(request.getParameter("nombre"));
            l.setDescripcion(request.getParameter("descripcion"));
            l.setTipo(request.getParameter("tipo"));
            try {
                l.setEstado(Integer.parseInt(request.getParameter("estado")));
            } catch (NumberFormatException e) {
                l.setEstado(1);
            }

            try {
                boolean ok = dao.actualizarLugar(l);
                System.out.println("Lugar actualizado ok=" + ok);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Error actualizando lugar: " + e.getMessage());
            }

            closeModalAndReload(response);
            return;
        }

        response.sendRedirect("LugarServlet?action=listar");
    }

    private void closeModalAndReload(HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!doctype html>");
            out.println("<html><head><meta charset='utf-8'><title>OK</title></head><body>");
            out.println("<script>");
            out.println("try {");
            out.println("  var modalEl = parent.document.getElementById('modalLugarForm');");
            out.println("  if (modalEl) {");
            out.println("    var modal = parent.bootstrap && parent.bootstrap.Modal ? parent.bootstrap.Modal.getInstance(modalEl) || new parent.bootstrap.Modal(modalEl) : null;");
            out.println("    if (modal) modal.hide(); else { var btn = modalEl.querySelector('[data-bs-dismiss]'); if (btn) btn.click(); }");
            out.println("  }");
            out.println("} catch(e) { /* ignore */ }");
            out.println("try { parent.postMessage({ type: 'lugar-updated' }, '*'); } catch(e) { }");
            out.println("try { parent.location.reload(); } catch(e) { }");
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}

package Controlador;

import Modelo.DTOBuses;
import DAO.DAOBuses;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;

public class BusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
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
                    request.getRequestDispatcher("Vista/Administrador/Bus/editar.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("BusServlet?action=listar");
                }
                break;
            }
            case "eliminar": {
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    dao.eliminarBus(idEliminar);
                } catch (NumberFormatException ignored) {
                }
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
            try {
                b.setCapacidadAsientos(Integer.parseInt(request.getParameter("capacidadAsientos")));
            } catch (NumberFormatException e) {
                b.setCapacidadAsientos(0);
            }
            b.setTipo(request.getParameter("tipo"));
            b.setDescripcion(request.getParameter("descripcion"));
            b.setCreador(1); // Opcional: usar usuario en sesión
            b.setFechaCreacion(new java.util.Date());
            try {
                b.setEstado(Integer.parseInt(request.getParameter("estado")));
            } catch (NumberFormatException e) {
                b.setEstado(1);
            }

            dao.agregarBus(b);

            // En vez de redirect -> RESPUESTA que cerrará el modal y recargará el padre
            closeModalAndReload(response);
            return;
        }

        if ("update".equals(action)) {
            try {
                b.setIdBus(Integer.parseInt(request.getParameter("idBus")));
            } catch (NumberFormatException e) {
                response.sendRedirect("BusServlet?action=listar");
                return;
            }
            b.setPlaca(request.getParameter("placa"));
            try {
                b.setCapacidadAsientos(Integer.parseInt(request.getParameter("capacidadAsientos")));
            } catch (NumberFormatException e) {
                b.setCapacidadAsientos(0);
            }
            b.setTipo(request.getParameter("tipo"));
            b.setDescripcion(request.getParameter("descripcion"));
            try {
                b.setEstado(Integer.parseInt(request.getParameter("estado")));
            } catch (NumberFormatException e) {
                b.setEstado(1);
            }

            dao.actualizarBus(b);

            // En vez de redirect -> RESPUESTA que cerrará el modal y recargará el padre
            closeModalAndReload(response);
            return;
        }
        // fallback
        response.sendRedirect("BusServlet?action=listar");
    }

    /**
     * Escribe una pequeña página que, al cargarse dentro del iframe, intentará:
     * - cerrar el modal en el parent usando bootstrap - enviar postMessage al
     * parent { type: 'bus-updated' } - recargar parent como fallback
     */
    private void closeModalAndReload(HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!doctype html>");
            out.println("<html><head><meta charset='utf-8'><title>OK</title></head><body>");
            out.println("<script>");
            // intentar cerrar modal vía bootstrap en el parent
            out.println("try {");
            out.println("  if (parent && parent.bootstrap && parent.bootstrap.Modal) {");
            out.println("    var modalEl = parent.document.getElementById('modalBusForm');");
            out.println("    if (modalEl) {");
            out.println("      var modal = parent.bootstrap.Modal.getInstance(modalEl) || new parent.bootstrap.Modal(modalEl);");
            out.println("      modal.hide();");
            out.println("    }");
            out.println("  } else {");
            out.println("    var modalEl2 = parent.document.getElementById('modalBusForm');");
            out.println("    if (modalEl2) { var btn = modalEl2.querySelector('[data-bs-dismiss]'); if (btn) btn.click(); }");
            out.println("  }");
            out.println("} catch(e) { /* ignore */ }");
            // notificar al parent (si quieres recargar solo la tabla con postMessage)
            out.println("try { parent.postMessage({ type: 'bus-updated' }, '*'); } catch(e) { }");
            // fallback: recargar la página padre
            out.println("try { parent.location.reload(); } catch(e) { }");
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}
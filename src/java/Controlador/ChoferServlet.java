package Controlador;

import Modelo.DTOChofer;
import DAO.DAOChoferes;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;

public class ChoferServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    DAOChoferes dao = new DAOChoferes();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            try {
                c.setDni(Integer.parseInt(request.getParameter("dni")));
            } catch (NumberFormatException e) {
                c.setDni(0);
            }
            c.setLicenciaConducir(request.getParameter("licenciaConducir"));
            try {
                c.setFechaContratacion(java.sql.Date.valueOf(request.getParameter("fechaContratacion")));
            } catch (Exception e) {
                c.setFechaContratacion(null);
            }
            try {
                c.setFechaVencimientoLicencia(java.sql.Date.valueOf(request.getParameter("fechaVencimientoLicencia")));
            } catch (Exception e) {
                c.setFechaVencimientoLicencia(null);
            }
            try {
                c.setTelefono(Integer.parseInt(request.getParameter("telefono")));
            } catch (NumberFormatException e) {
                c.setTelefono(0);
            }
            try {
                c.setDisponibilidad(Integer.parseInt(request.getParameter("disponibilidad")));
            } catch (NumberFormatException e) {
                c.setDisponibilidad(1);
            }
            try {
                c.setEstado(Integer.parseInt(request.getParameter("estado")));
            } catch (NumberFormatException e) {
                c.setEstado(1);
            }

            dao.AgregarChofer(c);
            // responder con script que cierra modal y notifica al padre
            closeModalAndReload(response, "chofer-updated");
            return;
        }

        if ("update".equals(action)) {
            try {
                c.setId(Integer.parseInt(request.getParameter("id"))); // <-- usa setId()
            } catch (NumberFormatException e) {
                response.sendRedirect("ChoferServlet?action=listar");
                return;
            }
            c.setAppat(request.getParameter("appat"));
            c.setApmat(request.getParameter("apmat"));
            c.setNombre(request.getParameter("nombre"));
            try {
                c.setDni(Integer.parseInt(request.getParameter("dni")));
            } catch (NumberFormatException e) {
                c.setDni(0);
            }
            c.setLicenciaConducir(request.getParameter("licenciaConducir"));
            try {
                c.setFechaContratacion(java.sql.Date.valueOf(request.getParameter("fechaContratacion")));
            } catch (Exception e) {
                c.setFechaContratacion(null);
            }
            try {
                c.setFechaVencimientoLicencia(java.sql.Date.valueOf(request.getParameter("fechaVencimientoLicencia")));
            } catch (Exception e) {
                c.setFechaVencimientoLicencia(null);
            }
            try {
                c.setTelefono(Integer.parseInt(request.getParameter("telefono")));
            } catch (NumberFormatException e) {
                c.setTelefono(0);
            }
            try {
                c.setDisponibilidad(Integer.parseInt(request.getParameter("disponibilidad")));
            } catch (NumberFormatException e) {
                c.setDisponibilidad(1);
            }
            try {
                c.setEstado(Integer.parseInt(request.getParameter("estado")));
            } catch (NumberFormatException e) {
                c.setEstado(1);
            }

            dao.ActualizarChofer(c);
            closeModalAndReload(response, "chofer-updated");
            return;
        }

        response.sendRedirect("ChoferServlet?action=listar");
    }

    private void closeModalAndReload(HttpServletResponse response, String messageType) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!doctype html><html><head><meta charset='utf-8'><title>OK</title></head><body>");
            out.println("<script>");
            out.println("try {");
            out.println("  if (parent && parent.bootstrap && parent.bootstrap.Modal) {");
            out.println("    var modalEl = parent.document.getElementById('modalForm');");
            out.println("    if (modalEl) {");
            out.println("      var modal = parent.bootstrap.Modal.getInstance(modalEl) || new parent.bootstrap.Modal(modalEl);");
            out.println("      modal.hide();");
            out.println("    }");
            out.println("  } else {");
            out.println("    var modalEl2 = parent.document.getElementById('modalForm');");
            out.println("    if (modalEl2) { var btn = modalEl2.querySelector('[data-bs-dismiss]'); if (btn) btn.click(); }");
            out.println("  }");
            out.println("} catch(e) { }");
            out.println("try { parent.postMessage({ type: '" + messageType + "' }, '*'); } catch(e) { }");
            out.println("try { parent.location.reload(); } catch(e) { }");
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}

package Controlador;

import Modelo.DTOCliente;
import DAO.DAOClientes;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;

public class ClienteServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    DAOClientes dao = new DAOClientes();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "listar";

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
                } catch (NumberFormatException ignored) {}
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
            try { c.setDni(Integer.parseInt(request.getParameter("dni"))); } catch (NumberFormatException e) { c.setDni(0); }
            c.setFechaNacimiento(request.getParameter("fechaNacimiento")); // si tu DTO usa Date, convierte aquí
            try { c.setTelefono(Integer.parseInt(request.getParameter("telefono"))); } catch (NumberFormatException e) { c.setTelefono(0); }
            c.setGenero(request.getParameter("genero"));

            dao.AgregarCliente(c);

            // responder con script que cierra modal y notifica al parent
            closeModalAndReload(response, "cliente-updated");
            return;
        }

        if ("update".equals(action)) {
            try {
                c.setId(Integer.parseInt(request.getParameter("id"))); // usamos 'id'
            } catch (NumberFormatException e) {
                response.sendRedirect("ClienteServlet?action=listar");
                return;
            }
            c.setAppat(request.getParameter("appat"));
            c.setApmat(request.getParameter("apmat"));
            c.setNombre(request.getParameter("nombre"));
            try { c.setDni(Integer.parseInt(request.getParameter("dni"))); } catch (NumberFormatException e) { c.setDni(0); }
            c.setFechaNacimiento(request.getParameter("fechaNacimiento"));
            try { c.setTelefono(Integer.parseInt(request.getParameter("telefono"))); } catch (NumberFormatException e) { c.setTelefono(0); }
            c.setGenero(request.getParameter("genero"));

            dao.ActualizarCliente(c);

            closeModalAndReload(response, "cliente-updated");
            return;
        }

        response.sendRedirect("ClienteServlet?action=listar");
    }

    private void closeModalAndReload(HttpServletResponse response, String messageType) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter() ) {
            out.println("<!doctype html>");
            out.println("<html><head><meta charset='utf-8'><title>OK</title></head><body>");
            out.println("<script>");
            out.println("try {");
            out.println("  if (parent && parent.bootstrap && parent.bootstrap.Modal) {");
            out.println("    var modalEl = parent.document.getElementById('modalClienteForm') || parent.document.getElementById('modalForm');");
            out.println("    if (modalEl) {");
            out.println("      var modal = parent.bootstrap.Modal.getInstance(modalEl) || new parent.bootstrap.Modal(modalEl);");
            out.println("      modal.hide();");
            out.println("    }");
            out.println("  } else {");
            out.println("    var modalEl2 = parent.document.getElementById('modalClienteForm') || parent.document.getElementById('modalForm');");
            out.println("    if (modalEl2) { var btn = modalEl2.querySelector('[data-bs-dismiss]'); if (btn) btn.click(); }");
            out.println("  }");
            out.println("} catch(e) { /* ignore */ }");
            out.println("try { parent.postMessage({ type: '" + messageType + "' }, '*'); } catch(e) { }");
            out.println("try { parent.location.reload(); } catch(e) { }");
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}
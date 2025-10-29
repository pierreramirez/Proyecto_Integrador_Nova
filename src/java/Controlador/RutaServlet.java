package Controlador;

import Modelo.DTORuta;
import DAO.DAORutas;
import DAO.DAOLugar;
import DAO.DAOChoferes;
import DAO.DAOBuses;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;

public class RutaServlet extends HttpServlet {

    private final DAORutas daoRuta = new DAORutas();
    private final DAOLugar daoLugar = new DAOLugar();
    private final DAOChoferes daoChofer = new DAOChoferes();
    private final DAOBuses daoBus = new DAOBuses();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        switch (action) {
            case "listar": {
                try {
                    List<DTORuta> lista = daoRuta.ListarRutas();
                    request.setAttribute("lista", lista);
                    request.getRequestDispatcher("Vista/Administrador/Ruta/listar.jsp").forward(request, response);
                } catch (Exception e) {
                    throw new ServletException(e);
                }
                break;
            }
            case "agregar": {
                safeLoadSelects(request);
                request.getRequestDispatcher("Vista/Administrador/Ruta/agregar.jsp").forward(request, response);
                break;
            }
            case "editar": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DTORuta ruta = daoRuta.ObtenerRuta(id);
                    if (ruta == null) {
                        response.sendRedirect("RutaServlet?action=listar");
                        return;
                    }
                    request.setAttribute("ruta", ruta);
                    safeLoadSelects(request);
                    request.getRequestDispatcher("Vista/Administrador/Ruta/editar.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    response.sendRedirect("RutaServlet?action=listar");
                } catch (Exception e) {
                    throw new ServletException(e);
                }
                break;
            }
            case "eliminar": {
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    daoRuta.EliminarRuta(idEliminar);
                } catch (NumberFormatException ignored) {
                } catch (Exception ex) {
                    Logger.getLogger(RutaServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
                response.sendRedirect("RutaServlet?action=listar");
                break;
            }
            default:
                response.sendRedirect("RutaServlet?action=listar");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try {
                DTORuta r = new DTORuta();

                r.setIdBus(parseIntParam(request, "idBus"));
                r.setIdChofer(parseIntParam(request, "idChofer"));

                String fechaSalidaParam = request.getParameter("fechaSalida");
                String fechaLlegadaParam = request.getParameter("fechaLlegada");
                if (fechaSalidaParam == null || fechaSalidaParam.trim().isEmpty()
                        || fechaLlegadaParam == null || fechaLlegadaParam.trim().isEmpty()) {
                    throw new IllegalArgumentException("Fechas inválidas");
                }
                r.setFechaSalida(Date.valueOf(fechaSalidaParam.trim()));
                r.setFechaLlegada(Date.valueOf(fechaLlegadaParam.trim()));

                Time hs = safeParseTime(request.getParameter("horaSalida"));
                Time hl = safeParseTime(request.getParameter("horaLlegada"));
                if (hs == null || hl == null) {
                    request.setAttribute("error", "Formato de hora inválido. Use HH:MM o HH:MM:SS.");
                    safeLoadSelects(request);
                    request.getRequestDispatcher("Vista/Administrador/Ruta/agregar.jsp").forward(request, response);
                    return;
                }
                r.setHoraSalida(hs);
                r.setHoraLlegada(hl);

                r.setOrigen(parseIntParam(request, "origen"));
                r.setDestino(parseIntParam(request, "destino"));
                r.setPrecio(new BigDecimal(request.getParameter("precio")));
                r.setBoletosRestantes(parseIntParam(request, "boletosRestantes"));
                r.setCreador(parseIntParam(request, "creador"));
                r.setEstado(parseIntParam(request, "estado"));

                daoRuta.AgregarRuta(r);

                // responder con script que cierra modal y notifica al padre
                closeModalAndReload(response, "ruta-updated");
                return;
            } catch (IllegalArgumentException ex) {
                request.setAttribute("error", ex.getMessage());
                safeLoadSelects(request);
                request.getRequestDispatcher("Vista/Administrador/Ruta/agregar.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }

        if ("update".equals(action)) {
            try {
                DTORuta r = new DTORuta();
                r.setIdViaje(parseIntParam(request, "idViaje"));
                r.setIdBus(parseIntParam(request, "idBus"));
                r.setIdChofer(parseIntParam(request, "idChofer"));

                String fechaSalidaParam = request.getParameter("fechaSalida");
                String fechaLlegadaParam = request.getParameter("fechaLlegada");
                if (fechaSalidaParam == null || fechaSalidaParam.trim().isEmpty()
                        || fechaLlegadaParam == null || fechaLlegadaParam.trim().isEmpty()) {
                    throw new IllegalArgumentException("Fechas inválidas");
                }
                r.setFechaSalida(Date.valueOf(fechaSalidaParam.trim()));
                r.setFechaLlegada(Date.valueOf(fechaLlegadaParam.trim()));

                Time hs = safeParseTime(request.getParameter("horaSalida"));
                Time hl = safeParseTime(request.getParameter("horaLlegada"));
                if (hs == null || hl == null) {
                    request.setAttribute("error", "Formato de hora inválido. Use HH:MM o HH:MM:SS.");
                    // reconstruir ruta parcial para mostrar el formulario
                    DTORuta partial = new DTORuta();
                    partial.setIdViaje(parseIntParam(request, "idViaje"));
                    partial.setIdBus(parseIntParam(request, "idBus"));
                    partial.setIdChofer(parseIntParam(request, "idChofer"));
                    request.setAttribute("ruta", partial);
                    safeLoadSelects(request);
                    request.getRequestDispatcher("Vista/Administrador/Ruta/editar.jsp").forward(request, response);
                    return;
                }
                r.setHoraSalida(hs);
                r.setHoraLlegada(hl);

                r.setOrigen(parseIntParam(request, "origen"));
                r.setDestino(parseIntParam(request, "destino"));
                r.setPrecio(new BigDecimal(request.getParameter("precio")));
                r.setBoletosRestantes(parseIntParam(request, "boletosRestantes"));
                r.setCreador(parseIntParam(request, "creador"));
                r.setEstado(parseIntParam(request, "estado"));

                daoRuta.EditarRuta(r);

                closeModalAndReload(response, "ruta-updated");
                return;
            } catch (IllegalArgumentException ex) {
                request.setAttribute("error", ex.getMessage());
                safeLoadSelects(request);
                request.getRequestDispatcher("Vista/Administrador/Ruta/editar.jsp").forward(request, response);
                return;
            } catch (Exception e) {
                throw new ServletException(e);
            }
        }

        response.sendRedirect("RutaServlet?action=listar");
    }

    // ----------------- helpers -----------------
    private Time safeParseTime(String raw) {
        if (raw == null) {
            return null;
        }
        raw = raw.trim();
        if (raw.isEmpty()) {
            return null;
        }
        try {
            long colons = raw.chars().filter(ch -> ch == ':').count();
            String normalized = raw;
            if (colons == 1) {
                normalized = raw + ":00";
            }
            LocalTime lt = LocalTime.parse(normalized);
            return Time.valueOf(lt);
        } catch (DateTimeParseException ex) {
            try {
                LocalTime lt2 = LocalTime.parse(raw);
                return Time.valueOf(lt2);
            } catch (Exception ex2) {
                return null;
            }
        } catch (Exception ex) {
            return null;
        }
    }

    private int parseIntParam(HttpServletRequest req, String name) {
        String v = req.getParameter(name);
        if (v == null || v.trim().isEmpty()) {
            return 0;
        }
        try {
            return Integer.parseInt(v.trim());
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException("Parámetro numérico inválido: " + name);
        }
    }

    private void safeLoadSelects(HttpServletRequest request) {
        try {
            request.setAttribute("lugares", daoLugar.listarActivos());
        } catch (Exception ignored) {
        }
        try {
            request.setAttribute("choferes", daoChofer.ListarChoferes());
        } catch (Exception ignored) {
        }
        try {
            request.setAttribute("buses", daoBus.listarBuses());
        } catch (Exception ignored) {
        }
    }

    private void closeModalAndReload(HttpServletResponse response, String messageType) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!doctype html><html><head><meta charset='utf-8'><title>OK</title></head><body>");
            out.println("<script>");
            out.println("try {");
            out.println("  if (parent && parent.bootstrap && parent.bootstrap.Modal) {");
            out.println("    var modalEl = parent.document.getElementById('modalRutaForm');");
            out.println("    if (modalEl) {");
            out.println("      var modal = parent.bootstrap.Modal.getInstance(modalEl) || new parent.bootstrap.Modal(modalEl);");
            out.println("      modal.hide();");
            out.println("    }");
            out.println("  } else {");
            out.println("    var modalEl2 = parent.document.getElementById('modalRutaForm');");
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
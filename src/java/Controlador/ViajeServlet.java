package Controlador;

import DAO.DAOViaje;
import DAO.DAOAsientoViaje;
import DAO.DAOBuses;
import DAO.DAOChoferes;
import DAO.DAOLugar;
import Modelo.DTOViaje;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.List;
import java.sql.Date;
import java.sql.Time;
import java.util.ArrayList;

public class ViajeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    DAOViaje dao = new DAOViaje();
    DAOAsientoViaje daoAsiento = new DAOAsientoViaje();
    DAOBuses daoBuses = new DAOBuses();
    DAOChoferes daoChoferes = new DAOChoferes();
    DAOLugar daoLugar = new DAOLugar();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "listar";
        }

        switch (action) {
            case "listar": {
                try {
                    List<DTOViaje> lista = dao.listarTodos(); // si quieres JOINs, luego adaptamos
                    request.setAttribute("viajes", lista);
                } catch (Exception e) {
                    request.setAttribute("error", "Error obteniendo viajes: " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("viajes", new ArrayList<DTOViaje>());
                }
                request.getRequestDispatcher("Vista/Administrador/Viaje/listar.jsp").forward(request, response);
                break;
            }
            case "agregar": {
                // garantizar que nunca pasemos nulls a la JSP
                try {
                    request.setAttribute("buses", safeListBuses());
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("buses", new ArrayList<>());
                }
                try {
                    request.setAttribute("choferes", safeListChoferes());
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("choferes", new ArrayList<>());
                }
                try {
                    request.setAttribute("lugares", daoLugar.listarActivos());
                } catch (Exception e) {
                    e.printStackTrace();
                    request.setAttribute("lugares", new ArrayList<>());
                }

                request.getRequestDispatcher("Vista/Administrador/Viaje/agregar.jsp").forward(request, response);
                break;
            }
            case "editar": {
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    DTOViaje v = dao.obtenerPorId(id);
                    request.setAttribute("viaje", v);

                    request.setAttribute("buses", safeListBuses());
                    request.setAttribute("choferes", safeListChoferes());
                    request.setAttribute("lugares", daoLugar.listarActivos());

                    request.getRequestDispatcher("Vista/Administrador/Viaje/editar.jsp").forward(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    response.sendRedirect("ViajeServlet?action=listar");
                }
                break;
            }
            case "eliminar": {
                try {
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    dao.eliminarViaje(idEliminar);
                } catch (Exception ignored) {
                }
                response.sendRedirect("ViajeServlet?action=listar");
                break;
            }
            default:
                response.sendRedirect("ViajeServlet?action=listar");
        }
    }

    // helpers seguros para obtener listas (evitan nulls)
    private List safeListChoferes() {
        try {
            return daoChoferes.ListarChoferes();
        } catch (Exception ex) {
            ex.printStackTrace();
            return new ArrayList<>();
        }
    }

    private List safeListBuses() {
        try {
            return daoBuses.listarBuses();
        } catch (Exception ex) {
            ex.printStackTrace();
            return new ArrayList<>();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        DTOViaje v = new DTOViaje();

        if ("add".equals(action)) {
            try {
                int idBus = Integer.parseInt(request.getParameter("idBus"));
                int idChofer = Integer.parseInt(request.getParameter("idChofer"));
                int origen = Integer.parseInt(request.getParameter("origen_id"));
                int destino = Integer.parseInt(request.getParameter("destino_id"));
                Date fecha = Date.valueOf(request.getParameter("fechaSalida")); // format yyyy-mm-dd
                Time hora = Time.valueOf(request.getParameter("horaSalida") + ":00");
                Integer duracion = null;
                String dur = request.getParameter("duracionMin");
                if (dur != null && !dur.isEmpty()) {
                    duracion = Integer.parseInt(dur);
                }
                double precio = Double.parseDouble(request.getParameter("precio"));

                v.setIdBus(idBus);
                v.setIdChofer(idChofer);
                v.setOrigen_id(origen);
                v.setDestino_id(destino);
                v.setFechaSalida(fecha);
                v.setHoraSalida(hora);
                v.setDuracionMin(duracion);
                v.setPrecio(precio);

                int idViaje = dao.crearViaje(v);
                if (idViaje > 0) {
                    // generar asientos usando capacidad del bus (asegúrate de tener este método)
                    int capacidad = 0;
                    try {
                        capacidad = daoBuses.obtenerCapacidadBus(idBus); // implementa/ajusta en DAOBuses
                    } catch (Exception e) {
                        e.printStackTrace();
                        // fallback: si no existe, podrías usar una constante o dejar 0
                    }
                    if (capacidad > 0) {
                        daoAsiento.generarAsientos(idViaje, capacidad, precio);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            closeModalAndReload(response);
            return;
        }

        if ("update".equals(action)) {
            try {
                v.setIdViaje(Integer.parseInt(request.getParameter("idViaje")));
                v.setIdBus(Integer.parseInt(request.getParameter("idBus")));
                v.setIdChofer(Integer.parseInt(request.getParameter("idChofer")));
                v.setOrigen_id(Integer.parseInt(request.getParameter("origen_id")));
                v.setDestino_id(Integer.parseInt(request.getParameter("destino_id")));
                v.setFechaSalida(java.sql.Date.valueOf(request.getParameter("fechaSalida")));
                v.setHoraSalida(java.sql.Time.valueOf(request.getParameter("horaSalida") + ":00"));
                String dur = request.getParameter("duracionMin");
                if (dur != null && !dur.isEmpty()) {
                    v.setDuracionMin(Integer.parseInt(dur));
                } else {
                    v.setDuracionMin(null);
                }
                v.setPrecio(Double.parseDouble(request.getParameter("precio")));
                v.setEstado(Integer.parseInt(request.getParameter("estado")));

                dao.actualizarViaje(v);
            } catch (Exception e) {
                e.printStackTrace();
            }
            closeModalAndReload(response);
            return;
        }

        response.sendRedirect("ViajeServlet?action=listar");
    }

    private void closeModalAndReload(HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!doctype html>");
            out.println("<html><head><meta charset='utf-8'><title>OK</title></head><body>");
            out.println("<script>");
            out.println("try { var modalEl = parent.document.getElementById('modalViajeForm'); if (modalEl) { var modal = parent.bootstrap && parent.bootstrap.Modal ? parent.bootstrap.Modal.getInstance(modalEl) || new parent.bootstrap.Modal(modalEl) : null; if (modal) modal.hide(); else { var btn = modalEl.querySelector('[data-bs-dismiss]'); if (btn) btn.click(); } } } catch(e) {}");
            out.println("try { parent.postMessage({ type: 'viaje-updated' }, '*'); } catch(e) {}");
            out.println("try { parent.location.reload(); } catch(e) {}");
            out.println("</script>");
            out.println("</body></html>");
        }
    }
}

package Controlador;

import DAO.DAOAsientoViaje;
import DAO.DAOViaje;
import DAO.DAOReserva;
import Modelo.DTOViaje;
import Modelo.DTOAsientoViaje;

import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;

/**
 * ReservaServlet
 *
 * Maneja: - GET action=init -> mostrar resumen del viaje y cargar vista
 * reserva_init.jsp - GET action=reserveForm -> mostrar formulario para
 * confirmar un asiento específico - POST action=confirm -> crear la reserva
 * (transactional) y redirigir a pago.jsp con amount y reservaId - POST
 * action=reserveMultiple -> reservar múltiples asientos (intenta reservar uno a
 * uno con reservarAsientoAtomic)
 *
 * Nota: Para atomicidad total de multi-asientos crear método transaccional en
 * DAOReserva.
 */
public class ReservaServlet extends HttpServlet {

    private final DAOAsientoViaje daoAsiento = new DAOAsientoViaje();
    private final DAOViaje daoViaje = new DAOViaje();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Forzar UTF-8 por si acaso
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        if ("init".equalsIgnoreCase(action)) {
            // Mostrar resumen del viaje (sin elegir asiento)
            String sViaje = req.getParameter("viajeId");
            if (sViaje == null) {
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
            try {
                int viajeId = Integer.parseInt(sViaje);
                DTOViaje v = daoViaje.obtenerPorId(viajeId);
                req.setAttribute("viaje", v);
                req.getRequestDispatcher("/Vista/Cliente/reserva_init.jsp").forward(req, resp);
            } catch (NumberFormatException nfe) {
                nfe.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        }

        if ("reserveForm".equalsIgnoreCase(action)) {
            // Mostrar form para confirmar reserva de un asiento (cuando el usuario hizo click en 1 asiento)
            String sViaje = req.getParameter("viajeId");
            String sAsientoId = req.getParameter("asientoId");
            if (sViaje == null || sAsientoId == null) {
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
            try {
                int viajeId = Integer.parseInt(sViaje);
                int asientoId = Integer.parseInt(sAsientoId);
                DTOViaje v = daoViaje.obtenerPorId(viajeId);
                req.setAttribute("viaje", v);
                req.setAttribute("asientoId", asientoId);
                req.getRequestDispatcher("/Vista/Cliente/reserva_form.jsp").forward(req, resp);
            } catch (NumberFormatException nfe) {
                nfe.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        }

        // default
        resp.sendRedirect(req.getContextPath() + "/");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Forzar encoding
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // --- Reservar un único asiento: ahora crea reserva transaccional y pasa amount al pago ---
        if ("confirm".equalsIgnoreCase(action)) {
            try {
                String sAsientoId = req.getParameter("asientoId");
                String sViajeId = req.getParameter("viajeId");

                if (sAsientoId == null) {
                    req.setAttribute("error", "Falta identificar el asiento.");
                    req.getRequestDispatcher("/Vista/Cliente/reserva_form.jsp").forward(req, resp);
                    return;
                }

                int asientoId = Integer.parseInt(sAsientoId);
                int viajeId = -1;
                if (sViajeId != null && !sViajeId.trim().isEmpty()) {
                    viajeId = Integer.parseInt(sViajeId);
                }

                // obtener clienteId desde sesión (si existe). Si no, fallback a 1 (mejor obligar login en producción)
                Integer clienteIdObj = null;
                HttpSession session = req.getSession(false);
                if (session != null && session.getAttribute("userId") != null) {
                    try {
                        Object u = session.getAttribute("userId");
                        if (u instanceof Integer) {
                            clienteIdObj = (Integer) u;
                        } else {
                            clienteIdObj = Integer.parseInt(u.toString());
                        }
                    } catch (Exception ignored) {
                    }
                }
                int clienteId = (clienteIdObj != null) ? clienteIdObj : 1;

                // obtener precio del asiento (si tu DAOAsientoViaje tiene este método)
                double precio = 0.0;
                try {
                    DTOAsientoViaje asientoDto = daoAsiento.obtenerAsientoPorId(asientoId);
                    if (asientoDto != null) {
                        precio = asientoDto.getPrecio();
                    }
                } catch (Exception ignored) {
                }

                // crear la reserva transaccionalmente (DAOReserva)
                DAOReserva daoReserva = new DAOReserva();
                int idReserva = daoReserva.crearReserva(viajeId, asientoId, clienteId);

                if (idReserva > 0) {
                    // redirigir a pago.jsp con reservaId y amount (dos decimales en notación "US" con punto decimal)
                    String ctx = req.getContextPath();
                    String amountStr = String.format(java.util.Locale.US, "%.2f", precio);
                    String redirect = ctx + "/Vista/Cliente/pago.jsp?reservaId=" + idReserva
                            + "&asientoId=" + asientoId
                            + "&viajeId=" + viajeId
                            + "&amount=" + amountStr;
                    resp.sendRedirect(redirect);
                } else {
                    // fallo al crear la reserva (asiento no disponible)
                    req.setAttribute("error", "No se pudo crear la reserva. Es posible que el asiento ya esté ocupado.");
                    req.getRequestDispatcher("/Vista/Cliente/reserva_form.jsp").forward(req, resp);
                }

            } catch (NumberFormatException nfe) {
                nfe.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
            }
            return;
        }

        // --- Reservar múltiples asientos (sin transacción global; mantiene tu lógica original) ---
        if ("reserveMultiple".equalsIgnoreCase(action)) {
            try {
                // parámetros: asientoIds (repetidos) y cantidad
                String[] asientoIdParams = req.getParameterValues("asientoIds");
                String sCantidad = req.getParameter("cantidad");
                String sViaje = req.getParameter("viajeId");

                if (sViaje == null) {
                    req.setAttribute("error", "Falta identificar el viaje.");
                    req.getRequestDispatcher("/Vista/Cliente/reserva_init.jsp").forward(req, resp);
                    return;
                }

                if (asientoIdParams == null || asientoIdParams.length == 0) {
                    req.setAttribute("error", "No seleccionaste asientos.");
                    req.getRequestDispatcher("/Vista/Cliente/reserva_init.jsp").forward(req, resp);
                    return;
                }

                int cantidadSolicitada = (sCantidad != null && !sCantidad.isEmpty()) ? Integer.parseInt(sCantidad) : asientoIdParams.length;

                // Validación simple: la cantidad de asientos seleccionada debe coincidir con la solicitada
                if (asientoIdParams.length != cantidadSolicitada) {
                    req.setAttribute("error", "La cantidad seleccionada (" + asientoIdParams.length + ") no coincide con la cantidad solicitada (" + cantidadSolicitada + ").");
                    req.getRequestDispatcher("/Vista/Cliente/reserva_init.jsp").forward(req, resp);
                    return;
                }

                Integer clienteId = (Integer) req.getSession().getAttribute("userId");

                // Parsear ids
                java.util.List<Integer> asientoIds = java.util.Arrays.stream(asientoIdParams)
                        .map(String::trim)
                        .filter(s -> !s.isEmpty())
                        .map(Integer::parseInt)
                        .collect(java.util.stream.Collectors.toList());

                // Intentamos reservar uno por uno con el método atómico disponible.
                java.util.List<Integer> reserved = new java.util.ArrayList<>();
                java.util.List<Integer> failed = new java.util.ArrayList<>();

                for (Integer id : asientoIds) {
                    try {
                        boolean ok = daoAsiento.reservarAsientoAtomic(id);
                        if (ok) {
                            reserved.add(id);
                        } else {
                            failed.add(id);
                        }
                    } catch (Exception exInner) {
                        exInner.printStackTrace();
                        failed.add(id);
                    }
                }

                if (failed.isEmpty()) {
                    // Reservas OK -> redirigir a confirmación con la lista de ids
                    String idsParam = reserved.stream().map(String::valueOf).collect(java.util.stream.Collectors.joining(","));
                    resp.sendRedirect(req.getContextPath() + "/Vista/Cliente/reserva_confirmada.jsp?asientoIds=" + idsParam + "&viajeId=" + sViaje);
                    return;
                } else {
                    // Algunas reservas fallaron.
                    req.setAttribute("error", "No se pudieron reservar algunos asientos. IDs fallidos: " + failed);
                    req.setAttribute("reservedIds", reserved);
                    req.setAttribute("failedIds", failed);
                    req.setAttribute("cantidadSolicitada", cantidadSolicitada);

                    DTOViaje v = daoViaje.obtenerPorId(Integer.parseInt(sViaje));
                    req.setAttribute("viaje", v);

                    req.getRequestDispatcher("/Vista/Cliente/reserva_init.jsp").forward(req, resp);
                    return;
                }

            } catch (NumberFormatException nfe) {
                nfe.printStackTrace();
                req.setAttribute("error", "Parámetros inválidos.");
                req.getRequestDispatcher("/Vista/Cliente/reserva_init.jsp").forward(req, resp);
                return;
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
        }

        // default
        resp.sendRedirect(req.getContextPath() + "/");
    }
}

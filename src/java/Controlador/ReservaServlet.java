package Controlador;

import DAO.DAOAsientoViaje;
import DAO.DAOViaje;
import Modelo.DTOViaje;

import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * ReservaServlet
 *
 * Maneja:
 *  - GET action=init        -> mostrar resumen del viaje y cargar vista reserva_init.jsp
 *  - GET action=reserveForm -> mostrar formulario para confirmar un asiento específico
 *  - POST action=confirm    -> reservar un único asiento (usa daoAsiento.reservarAsientoAtomic(id))
 *  - POST action=reserveMultiple -> reservar múltiples asientos (intenta reservar uno a uno con reservarAsientoAtomic)
 *
 * Nota: Para atomicidad real (todo o nada) implementar un método transaccional en DAO.
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

        // --- Reservar un único asiento (igual que tenías antes) ---
        if ("confirm".equalsIgnoreCase(action)) {
            try {
                String sAsientoId = req.getParameter("asientoId");
                if (sAsientoId == null) {
                    req.setAttribute("error", "Falta identificar el asiento.");
                    req.getRequestDispatcher("/Vista/Cliente/reserva_form.jsp").forward(req, resp);
                    return;
                }
                int asientoId = Integer.parseInt(sAsientoId);

                // opcional: obtener clienteId de sesión
                Integer clienteId = (Integer) req.getSession().getAttribute("userId");

                // Usamos el método existente reservarAsientoAtomic(idAsientoViaje)
                boolean ok = daoAsiento.reservarAsientoAtomic(asientoId);

                if (ok) {
                    // Redirigir a página de confirmación (puedes mostrar más info en esa JSP)
                    resp.sendRedirect(req.getContextPath() + "/Vista/Cliente/reserva_confirmada.jsp?asientoId=" + asientoId);
                } else {
                    req.setAttribute("error", "No se pudo reservar el asiento (tal vez ya fue ocupado).");
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

        // --- Reservar múltiples asientos ---
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
                List<Integer> asientoIds = Arrays.stream(asientoIdParams)
                        .map(String::trim)
                        .filter(s -> !s.isEmpty())
                        .map(Integer::parseInt)
                        .collect(Collectors.toList());

                // Intentamos reservar uno por uno con el método atómico disponible.
                // NOTA: si tu sistema requiere atomicidad (todo o nada), implementa un método transaccional en DAO y llámalo aquí.
                List<Integer> reserved = new ArrayList<>();
                List<Integer> failed = new ArrayList<>();

                for (Integer id : asientoIds) {
                    try {
                        boolean ok = daoAsiento.reservarAsientoAtomic(id);
                        if (ok) reserved.add(id);
                        else failed.add(id);
                    } catch (Exception exInner) {
                        exInner.printStackTrace();
                        failed.add(id);
                    }
                }

                if (failed.isEmpty()) {
                    // Reservas OK -> redirigir a confirmación con la lista de ids
                    String idsParam = reserved.stream().map(String::valueOf).collect(Collectors.joining(","));
                    resp.sendRedirect(req.getContextPath() + "/Vista/Cliente/reserva_confirmada.jsp?asientoIds=" + idsParam + "&viajeId=" + sViaje);
                    return;
                } else {
                    // Algunas reservas fallaron. Devolver info al usuario.
                    // NOTA: aquí no hacemos rollback porque solo conocemos reservarAsientoAtomic(id).
                    // Recomendación: implementar en DAO un método transactional que haga commit/rollback.
                    req.setAttribute("error", "No se pudieron reservar algunos asientos. IDs fallidos: " + failed);
                    req.setAttribute("reservedIds", reserved);
                    req.setAttribute("failedIds", failed);
                    req.setAttribute("cantidadSolicitada", cantidadSolicitada);

                    // Volver a cargar la vista inicial (mejor sería recargar el plano y mostrar los cambios)
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
                // En caso de error grave, redirigir a la raíz o mostrar página de error
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            }
        }

        // default
        resp.sendRedirect(req.getContextPath() + "/");
    }
}

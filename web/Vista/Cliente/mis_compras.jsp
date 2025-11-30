<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Modelo.DTOUsuario, Persistencia.Conexion, java.sql.*, java.text.SimpleDateFormat, java.lang.reflect.Method, java.util.ArrayList, java.util.List, java.util.Calendar" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Seguridad: si no hay sesión, redirigir
    DTOUsuario usuarioObj = (DTOUsuario) session.getAttribute("user");
    if (usuarioObj == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/login.jsp");
        return;
    }

    // Obtener contextPath para uso en enlaces (también lo pasamos a JSTL más abajo)
    String ctx = request.getContextPath();

    // intentar obtener id del usuario por varios getters (reflexión)
    int userId = -1;
    try {
        Method m = usuarioObj.getClass().getMethod("getIdUsuario");
        Object r = m.invoke(usuarioObj);
        if (r instanceof Number) {
            userId = ((Number) r).intValue();
        }
    } catch (Exception e) {
        try {
            Method m2 = usuarioObj.getClass().getMethod("getId");
            Object r2 = m2.invoke(usuarioObj);
            if (r2 instanceof Number) {
                userId = ((Number) r2).intValue();
            }
        } catch (Exception e2) {
            try {
                Method m3 = usuarioObj.getClass().getMethod("getDni");
                Object r3 = m3.invoke(usuarioObj);
                if (r3 instanceof Number) {
                    userId = ((Number) r3).intValue();
                }
            } catch (Exception e3) {
                userId = -1;
            }
        }
    }

    // obtener nombre para mostrar (intentar getter por reflexión, fallback a "Usuario")
    String displayName = "Usuario";
    try {
        Method gm = usuarioObj.getClass().getMethod("getNombre");
        Object gn = gm.invoke(usuarioObj);
        if (gn != null) {
            displayName = gn.toString();
        }
    } catch (Exception ignore) {
    }

    // Clase fila ampliada con campos ficticios
    class CompraRow {

        public int id;
        public Timestamp fecha;
        public double total;
        public String estado;
        public int cantidad;          // cantidad de boletos/reservas
        public String asientoIds;     // lista de asientos reservados (ej: "12,14")
        public String metodoPago;     // e.g., "Tarjeta", "Yape", "Efectivo"
    }

    List<CompraRow> compras = new ArrayList<>();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

    if (userId != -1) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            Conexion c = new Conexion();
            con = c.getConnection();

            // intentamos varias variantes de consulta (robusta para nombres comunes)
            String[] queries = new String[]{
                "SELECT c.*, COALESCE(c.total,0) AS total FROM compra c WHERE c.idUsuario = ? ORDER BY COALESCE(c.fechaCompra, c.created_at) DESC",
                "SELECT c.*, COALESCE(c.total,0) AS total FROM compras c WHERE c.id_usuario = ? ORDER BY COALESCE(c.fecha_compra, c.created_at) DESC",
                "SELECT * FROM compra WHERE idUsuario = ? ORDER BY fechaCompra DESC",
                "SELECT * FROM compras WHERE id_usuario = ? ORDER BY fecha_compra DESC"
            };
            for (String sql : queries) {
                try {
                    ps = con.prepareStatement(sql);
                    ps.setInt(1, userId);
                    rs = ps.executeQuery();
                    break; // si no lanza excepción usamos este ResultSet
                } catch (SQLException ex) {
                    try {
                        if (rs != null) {
                            rs.close();
                        }
                    } catch (Exception ignore) {
                    }
                    try {
                        if (ps != null) {
                            ps.close();
                        }
                    } catch (Exception ignore) {
                    }
                    rs = null;
                    ps = null;
                }
            }

            if (rs != null) {
                while (rs.next()) {
                    CompraRow r = new CompraRow();
                    // id
                    try {
                        r.id = rs.getInt("idCompra");
                    } catch (Exception e) {
                        try {
                            r.id = rs.getInt("id_compra");
                        } catch (Exception e2) {
                            try {
                                r.id = rs.getInt(1);
                            } catch (Exception ignore) {
                                r.id = -1;
                            }
                        }
                    }
                    // fecha
                    try {
                        r.fecha = rs.getTimestamp("fechaCompra");
                    } catch (Exception e) {
                        try {
                            r.fecha = rs.getTimestamp("fecha_compra");
                        } catch (Exception e2) {
                            try {
                                r.fecha = rs.getTimestamp("created_at");
                            } catch (Exception ignore) {
                                r.fecha = null;
                            }
                        }
                    }
                    // total
                    try {
                        r.total = rs.getDouble("total");
                    } catch (Exception e) {
                        try {
                            r.total = rs.getDouble("monto");
                        } catch (Exception ignore) {
                            r.total = 0.0;
                        }
                    }
                    // estado
                    try {
                        String st = rs.getString("estado");
                        if (st == null) {
                            st = rs.getString("status");
                        }
                        r.estado = (st == null) ? "-" : st;
                    } catch (Exception e) {
                        r.estado = "-";
                    }
                    // cantidad (si existe)
                    try {
                        r.cantidad = rs.getInt("cantidad");
                        if (rs.wasNull()) {
                            r.cantidad = 1;
                        }
                    } catch (Exception e) {
                        r.cantidad = 1;
                    }
                    // asientoIds (varias variantes)
                    try {
                        String a = rs.getString("asientoIds");
                        if (a == null) {
                            a = rs.getString("asientos");
                        }
                        if (a == null) {
                            a = rs.getString("asiento_ids");
                        }
                        r.asientoIds = (a == null) ? "-" : a;
                    } catch (Exception e) {
                        r.asientoIds = "-";
                    }
                    // metodo de pago
                    try {
                        String mtd = rs.getString("metodo_pago");
                        if (mtd == null) {
                            mtd = rs.getString("payment_method");
                        }
                        r.metodoPago = (mtd == null) ? "—" : mtd;
                    } catch (Exception e) {
                        r.metodoPago = "—";
                    }

                    compras.add(r);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace(new java.io.PrintWriter(out));
        } finally {
            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception ignore) {
            }
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ignore) {
            }
        }
    }

    // Si aún no hay compras reales, generar datos ficticios (5 registros)
    if (compras.isEmpty()) {
        // usamos Calendar para generar fechas atrás
        long now = System.currentTimeMillis();
        int[][] sampleDays = new int[][]{{2}, {5}, {12}, {20}, {35}}; // días atrás
        double[] totals = new double[]{45.00, 90.00, 135.00, 60.00, 180.00};
        String[] estados = new String[]{"Pagado", "Pendiente", "Cancelado", "Pagado", "Pagado"};
        int[] cantidades = new int[]{1, 2, 3, 1, 4};
        String[] asientosArr = new String[]{"12", "4,5", "10,11,12", "7", "21,22,23,24"};
        String[] metodos = new String[]{"Tarjeta (VISA)", "Yape", "Tarjeta (Mastercard)", "Efectivo", "Tarjeta (Amex)"};

        for (int i = 0; i < 5; i++) {
            CompraRow r = new CompraRow();
            r.id = 1000 + i; // ids ficticios
            long ts = now - (long) sampleDays[i][0] * 24L * 3600L * 1000L;
            r.fecha = new Timestamp(ts);
            r.total = totals[i];
            r.estado = estados[i];
            r.cantidad = cantidades[i];
            r.asientoIds = asientosArr[i];
            r.metodoPago = metodos[i];
            compras.add(r);
        }
    }
%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Mis compras - NOVAS</title>

        <!-- Hoja de estilos principal y FontAwesome (usa la tuya si ya la tienes) -->
        <link href="${ctx}/css/novas-landing.css" rel="stylesheet"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/>

        <!-- Ajustes específicos (dropdown, tabla) -->
        <style>
            /* Asegura que el navbar no recorte el dropdown */
            .navbar {
                position: relative;
                overflow: visible;
                z-index: 1000;
            }

            /* User dropdown */
            .user-dropdown {
                position: relative;
                display: inline-block;
            }
            .user-btn {
                display: inline-flex;
                align-items:center;
                gap:8px;
                padding:6px 10px;
                border-radius:10px;
                background: transparent;
                border:1px solid rgba(29,58,160,0.06);
                color:inherit;
                cursor:pointer;
                font-weight:600;
            }
            .user-avatar {
                width:34px;
                height:34px;
                border-radius:50%;
                background:#fff;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                color:#1d3aa0;
                font-weight:700;
                box-shadow:0 2px 6px rgba(0,0,0,0.05);
            }
            .user-menu {
                display:none;
                position:absolute;
                right:0;
                top:calc(100% + 8px);
                min-width:190px;
                background:#fff;
                color:#222;
                box-shadow:0 10px 30px rgba(8,15,40,0.12);
                border-radius:10px;
                padding:6px 0;
                z-index:2000;
                white-space:nowrap;
            }
            .user-menu a {
                display:flex;
                align-items:center;
                gap:8px;
                padding:10px 14px;
                color:#222 !important;
                text-decoration:none;
                font-size:0.95rem;
            }
            .user-menu a:hover {
                background:#f4f6fb;
            }
            .user-menu i {
                width:16px;
                text-align:center;
                color:#1d3aa0;
            }

            /* Table / card */
            .compras-card {
                background:#fff;
                padding:18px;
                border-radius:12px;
                box-shadow:0 8px 20px rgba(0,0,0,0.06);
            }
            .compras-table {
                width:100%;
                border-collapse:collapse;
                margin-top:12px;
            }
            .compras-table th, .compras-table td {
                padding:10px 12px;
                border-bottom:1px solid #eee;
                text-align:left;
                vertical-align:middle;
            }
            .compras-table th {
                background:#f6f8fb;
                font-weight:700;
            }
            .empty-box {
                padding:36px;
                text-align:center;
                color:#666;
            }
            .btn-ghost {
                padding:8px 12px;
                border-radius:8px;
                border:1px solid #dfe6f5;
                background:transparent;
                color:#1d3aa0;
                text-decoration:none;
                display:inline-block;
            }

            /* small badges */
            .badge-ok {
                background:#e6f8ef;
                color:#04683a;
                padding:6px 10px;
                border-radius:8px;
                font-weight:700;
                display:inline-block;
            }
            .badge-pend {
                background:#fff7e6;
                color:#8a5800;
                padding:6px 10px;
                border-radius:8px;
                font-weight:700;
                display:inline-block;
            }
            .badge-cancel {
                background:#ffeceb;
                color:#8a1a1a;
                padding:6px 10px;
                border-radius:8px;
                font-weight:700;
                display:inline-block;
            }

            /* Forzar color de enlaces en el menú (evitar violetas por estilos globales) */
            .user-menu a:link, .user-menu a:visited {
                color:#222 !important;
            }

            /* Responsive small fix */
            @media (max-width:800px){
                .compras-table th:nth-child(2), .compras-table td:nth-child(2) {
                    display:none;
                } /* ocultar fecha en móviles para ahorrar espacio */
            }
        </style>
    </head>
    <body>
        <!-- HEADER (igual que index, con dropdown corregido) -->
        <header>
            <nav class="navbar">
                <div class="container" style="display:flex; align-items:center; justify-content:space-between;">
                    <div class="nav-brand" style="display:flex; align-items:center; gap:10px;">
                        <img src="${ctx}/Imagenes/novas_logo.png" alt="NOVAS Logo" class="logo" style="height:44px;">
                        <span class="company-name">NOVAS</span>
                    </div>

                    <!-- menú principal -->
                    <ul class="nav-menu" style="display:flex; list-style:none; gap:1rem; align-items:center; margin:0;">
                        <li><a href="${ctx}#inicio">Inicio</a></li>
                        <li><a href="${ctx}#destinos">Destinos</a></li>
                        <li><a href="${ctx}#promociones">Promociones</a></li>
                        <li><a href="${ctx}#contacto">Contacto</a></li>
                    </ul>

                    <!-- AREA ACCESO / USUARIO -->
                    <div class="nav-actions">
                        <c:if test="${empty sessionScope.user}">
                            <a href="${ctx}/Vista/login.jsp" class="btn btn-primary btn-access" role="button" aria-label="Acceder">
                                <i class="fas fa-user-circle"></i><span style="margin-left:8px;">Acceder</span>
                            </a>
                        </c:if>

                        <c:if test="${not empty sessionScope.user}">
                            <div class="user-dropdown" id="userDropdown">
                                <button class="user-btn" id="userBtn" type="button" aria-haspopup="true" aria-expanded="false" aria-controls="userMenu">
                                    <div class="user-avatar"><i class="fas fa-user"></i></div>
                                    <div style="text-align:left; margin-left:6px; color:inherit;">
                                        <span style="font-size:12px; display:block;">Hola,</span>
                                        <strong style="display:block;"><c:out value="${sessionScope.user.nombre}" default="Usuario"/></strong>
                                    </div>
                                    <i class="fas fa-caret-down" style="margin-left:8px;"></i>
                                </button>

                                <div class="user-menu" id="userMenu" role="menu" aria-label="Menú usuario">
                                    <a href="${ctx}/PerfilServlet"><i class="fas fa-user-circle"></i> Mi perfil</a>
                                    <a href="${ctx}/Vista/Cliente/mis_compras.jsp"><i class="fas fa-shopping-cart"></i> Mis compras</a>
                                    <a href="${ctx}/srvIniciarSesion?accion=cerrar"><i class="fas fa-sign-out-alt"></i> Cerrar sesión</a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </nav>
        </header>

        <!-- CONTENIDO PRINCIPAL -->
        <main style="padding:28px;">
            <div class="container">
                <div class="compras-card">
                    <h2 style="margin:0 0 8px 0;">Mis compras</h2>
                    <p style="margin:0 0 12px 0; color:#666;">Usuario: <strong><%= displayName%></strong></p>

                    <table class="compras-table" role="table" aria-label="Lista de compras">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Fecha</th>
                                <th>ID Compra</th>
                                <th>Cantidad</th>
                                <th>Asientos</th>
                                <th>Total (S/)</th>
                                <th>Estado</th>
                                <th>Método Pago</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int idx = 1;
                                for (CompraRow r : compras) {
                            %>
                            <tr>
                                <td><%= idx++%></td>
                                <td><%= (r.fecha != null ? sdf.format(r.fecha) : "-")%></td>
                                <td><%= r.id%></td>
                                <td><%= r.cantidad%></td>
                                <td><%= (r.asientoIds != null ? r.asientoIds : "-")%></td>
                                <td><%= String.format("%.2f", r.total)%></td>
                                <td>
                                    <%
                                        String badgeClass = "badge-ok";
                                        if ("Pendiente".equalsIgnoreCase(r.estado)) {
                                            badgeClass = "badge-pend";
                                        }
                                        if ("Cancelado".equalsIgnoreCase(r.estado) || "Anulado".equalsIgnoreCase(r.estado))
                                            badgeClass = "badge-cancel";
                                    %>
                                    <span class="<%= badgeClass%>"><%= r.estado%></span>
                                </td>
                                <td><%= (r.metodoPago != null ? r.metodoPago : "—")%></td>
                                <td><a class="btn-ghost" href="<%= ctx%>/Vista/Cliente/compra_detalle.jsp?compraId=<%= r.id%>">Ver</a></td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>

                </div>
            </div>
        </main>

        <!-- FOOTER (idéntico al index) -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <div class="footer-logo"><img src="${ctx}/Imagenes/novas_logo.png" alt="NOVAS" class="logo"><span class="company-name">NOVAS</span></div>
                        <p class="footer-text">Viajes seguros y cómodos por todo el Perú</p>
                    </div>
                    <div class="footer-section"><h3>Destinos</h3><ul><li><a href="#">Arequipa</a></li><li><a href="#">Cusco</a></li><li><a href="#">Chiclayo</a></li><li><a href="#">Trujillo</a></li></ul></div>
                    <div class="footer-section"><h3>Opciones de Viaje</h3><ul><li><a href="#">Promociones</a></li><li><a href="#">Rutas</a></li><li><a href="#">Horarios</a></li><li><a href="#">Contacto</a></li></ul></div>
                    <div class="footer-section"><h3>Contacto</h3><div class="contact-info"><p><i class="fas fa-phone"></i> (01) 123-4567</p><p><i class="fas fa-envelope"></i> info@novas.com</p><p><i class="fas fa-map-marker-alt"></i> Lima, Perú</p></div></div>
                </div>
                <div class="footer-bottom"><p>&copy; 2025 NOVAS - Todos los derechos reservados</p><p>NOVAS es atención y dedicación</p></div>
            </div>
        </footer>

        <!-- SCRIPTS: dropdown comportamiento y tarjetas clicables -->
        <script>
        var ctx = '${ctx}';

        // Dropdown usuario: toggle + cerrar si clic fuera + Escape
        (function () {
            var userBtn = document.getElementById('userBtn');
            var userMenu = document.getElementById('userMenu');
            if (!userBtn || !userMenu)
                return;

            function closeMenu() {
                userMenu.style.display = 'none';
                userBtn.setAttribute('aria-expanded', 'false');
            }

            function openMenu() {
                userMenu.style.display = 'block';
                userBtn.setAttribute('aria-expanded', 'true');
            }

            document.addEventListener('click', function (e) {
                if (userBtn.contains(e.target)) {
                    if (userMenu.style.display === 'block')
                        closeMenu();
                    else
                        openMenu();
                } else {
                    if (!userMenu.contains(e.target))
                        closeMenu();
                }
            });

            document.addEventListener('keydown', function (ev) {
                if (ev.key === 'Escape')
                    closeMenu();
            });

            userBtn.addEventListener('keydown', function (ev) {
                if (ev.key === 'Enter' || ev.key === ' ') {
                    ev.preventDefault();
                    if (userMenu.style.display === 'block')
                        closeMenu();
                    else
                        openMenu();
                }
            });
        })();
        </script>

        <script src="${ctx}/js/script.js"></script>
    </body>
</html>

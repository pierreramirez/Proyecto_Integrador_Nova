<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Modelo.DTOUsuario, Persistencia.Conexion, java.sql.*, java.text.SimpleDateFormat, java.lang.reflect.Method, java.util.ArrayList, java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Seguridad: si no hay sesión, redirigir
    DTOUsuario usuarioObj = (DTOUsuario) session.getAttribute("user");
    if (usuarioObj == null) {
        response.sendRedirect(request.getContextPath() + "/Vista/login.jsp");
        return;
    }

    // Obtener contextPath para uso en enlaces
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
            userId = -1;
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

    // viajeId se pasa originalmente como parámetro desde ReservaServlet?action=init
    String viajeIdParam = request.getParameter("viajeId");
    if (viajeIdParam == null) {
        viajeIdParam = "";
    }
    Object viajeObj = request.getAttribute("viaje");
%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>Reservar - Selección de asientos</title>

        <!-- Estilos principales del sitio -->
        <link href="${ctx}/css/novas-landing.css" rel="stylesheet"/>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/>
        <!-- Bootstrap (opcional pero útil para componentes) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Estilos específicos (header/footer + asientos) -->
        <style>
            /* HEADER / USER dropdown (from template) */
            .navbar {
                position: relative;
                overflow: visible;
                z-index: 1000;
            }
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

            /* Card principal (adaptado del segundo template) */
            .reserva-card {
                background:#fff;
                padding:18px;
                border-radius:12px;
                box-shadow:0 8px 20px rgba(0,0,0,0.06);
            }

            /* Asientos (copiado y ajustado) */
            .seat {
                width:48px;
                height:48px;
                margin:4px;
                border-radius:6px;
                cursor:pointer;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                font-weight:600;
            }
            .seat.available {
                background:#e9f7ef;
                border:1px solid #2ecc71;
                color:#0b5136;
            }
            .seat.unavailable {
                background:#f5f5f5;
                border:1px solid #ccc;
                color:#aaa;
                cursor:not-allowed;
            }
            .seat.selected {
                background:#ffd966;
                border:2px solid #f39c12;
                color:#3b2b00;
            }
            .seat.occupied {
                background:#ffb3b3;
                border:1px solid #ff4d4d;
                color:#6b0000;
                cursor:not-allowed;
            }
            .seat-row {
                margin-bottom:8px;
            }
            #seatsContainer {
                max-width:720px;
                margin:0 auto;
            }

            /* pequeños ajustes responsivos */
            @media (max-width:600px){
                .seat {
                    width:40px;
                    height:40px;
                    margin:3px;
                    font-size:0.85rem;
                }
                .user-avatar {
                    width:30px;
                    height:30px;
                }
            }
        </style>
    </head>
    <body>
        <!-- HEADER -->
        <header>
            <nav class="navbar">
                <div class="container" style="display:flex; align-items:center; justify-content:space-between;">
                    <div class="nav-brand" style="display:flex; align-items:center; gap:10px;">
                        <img src="${ctx}/Imagenes/novas_logo.png" alt="NOVAS Logo" class="logo" style="height:44px;">
                        <span class="company-name">NOVAS</span>
                    </div>
                    <ul class="nav-menu" style="display:flex; list-style:none; gap:1rem; align-items:center; margin:0;">
                        <li><a href="${ctx}#inicio">Inicio</a></li>
                        <li><a href="${ctx}#destinos">Destinos</a></li>
                        <li><a href="${ctx}#promociones">Promociones</a></li>
                        <li><a href="${ctx}#contacto">Contacto</a></li>
                    </ul>

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

        <!-- CONTENIDO - SELECCIÓN DE ASIENTOS -->
        <main style="padding:28px;">
            <div class="container">
                <div class="reserva-card">
                    <div style="display:flex; justify-content:space-between; align-items:center; gap:12px; margin-bottom:12px;">
                        <div>
                            <h3 style="margin:0;">Reserva - Selección de asientos</h3>
                            <small style="color:#666;">Usuario: <strong><%= displayName%></strong></small>
                        </div>
                        <div style="text-align:right;">
                            <p style="margin:0;"><strong>Viaje ID:</strong> <%= viajeIdParam%></p>
                            <p style="margin:0; color:#666;"><strong>Resumen:</strong> <%= (viajeObj != null) ? viajeObj.toString() : "No disponible"%></p>
                        </div>
                    </div>

                    <!-- Cantidad de boletos -->
                    <div class="mb-3 row g-2 align-items-center">
                        <div class="col-auto">
                            <label for="ticketQty" class="col-form-label">¿Cuántos boletos quieres?</label>
                        </div>
                        <div class="col-auto">
                            <input id="ticketQty" class="form-control" type="number" min="1" value="1" style="width:100px;">
                        </div>
                        <div class="col-auto">
                            <button id="loadSeatsBtn" class="btn btn-primary">Mostrar asientos</button>
                        </div>
                        <div class="col-auto">
                            <small id="availableInfo" class="text-muted"></small>
                        </div>
                    </div>

                    <!-- Mensaje: redirige -->
                    <div id="seatsContainer" class="mb-3">
                        <div id="seatsMessage" class="mb-2 text-muted">Pulsa "Mostrar asientos" para ir al plano del bus.</div>
                    </div>

                    <!-- Botones -->
                    <div style="display:flex; gap:8px;">
                        <a href="${ctx}/" class="btn btn-secondary">Cancelar</a>
                    </div>
                </div>
            </div>
        </main>

        <!-- FOOTER -->
        <footer class="footer" style="margin-top:28px;">
            <div class="container">
                <div class="footer-content" style="display:flex; gap:20px; flex-wrap:wrap; align-items:flex-start;">
                    <div class="footer-section" style="flex:1;">
                        <div class="footer-logo"><img src="${ctx}/Imagenes/novas_logo.png" alt="NOVAS" class="logo" style="height:36px;"><span class="company-name">NOVAS</span></div>
                        <p class="footer-text" style="margin-top:8px;">Viajes seguros y cómodos por todo el Perú</p>
                    </div>
                    <div class="footer-section"><h3>Destinos</h3><ul><li><a href="#">Arequipa</a></li><li><a href="#">Cusco</a></li><li><a href="#">Chiclayo</a></li><li><a href="#">Trujillo</a></li></ul></div>
                    <div class="footer-section"><h3>Opciones de Viaje</h3><ul><li><a href="#">Promociones</a></li><li><a href="#">Rutas</a></li><li><a href="#">Horarios</a></li><li><a href="#">Contacto</a></li></ul></div>
                    <div class="footer-section"><h3>Contacto</h3><div class="contact-info"><p><i class="fas fa-phone"></i> (01) 123-4567</p><p><i class="fas fa-envelope"></i> info@novas.com</p><p><i class="fas fa-map-marker-alt"></i> Lima, Perú</p></div></div>
                </div>
                <div class="footer-bottom" style="margin-top:16px; text-align:center; color:#666;"><p>&copy; 2025 NOVAS - Todos los derechos reservados</p></div>
            </div>
        </footer>

        <!-- SCRIPTS: dropdown behavior -->
        <script>
            var ctx = '<%= ctx%>'; // para uso en JS
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

        <!-- REDIRECCIÓN: Mostrar asientos -> VerAsientosServlet -->
        <script>
            (function () {
                var viajeId = '<%= viajeIdParam%>';
                document.getElementById('loadSeatsBtn').addEventListener('click', function () {
                    var qty = parseInt(document.getElementById('ticketQty').value || '1', 10);
                    if (isNaN(qty) || qty < 1) {
                        alert('Cantidad mínima: 1');
                        return;
                    }
                    var url = ctx + '/VerAsientosServlet?viajeId=' + encodeURIComponent(viajeId) + '&cantidad=' + encodeURIComponent(qty);
                    window.location.href = url;
                });
            })();
        </script>

        <script src="${ctx}/js/script.js"></script>
    </body>
</html>

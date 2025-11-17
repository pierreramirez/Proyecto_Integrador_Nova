<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="container-fluid">
    <div class="row g-0">

        <aside class="col-md-2 d-none d-md-block sidebar p-3 bg-white shadow">
            <div class="text-center mb-3">
                <img src="${pageContext.request.contextPath}/Imagenes/user-default.png"
                     onerror="this.src='https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'"
                     class="rounded-circle avatar-small img-fluid" alt="avatar">
            </div>
            <h5 class="text-center small mb-3 user-name">
                <c:out value="${sessionScope.user.appat}"/> 
                <c:out value="${sessionScope.user.apmat}"/><br/>
                <strong><c:out value="${sessionScope.user.nombre}"/></strong>
            </h5>
            <ul class="nav flex-column">
                <c:if test="${sessionScope.user.rol == 1}">
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/BusServlet?action=listar">
                            <i class='bx bxs-bus me-2'></i> Registrar Bus
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/ChoferServlet?action=listar">
                            <i class='bx bxs-user-account me-2'></i> Registrar Choferes
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/LugarServlet?action=listar">
                            <i class='bx bxs-map me-2'></i> Gestionar Lugares
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/ClienteServlet?action=listar">
                            <i class='bx bx-user me-2'></i> Gestionar Clientes
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/ViajeServlet?action=listar">
                            <i class='bx bxs-coupon me-2'></i> Administrar Viajes
                        </a>
                    </li>
                </c:if>

                <c:if test="${sessionScope.user.rol == 2}">
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/BusServlet?action=listar">
                            <i class='bx bxs-bus me-2'></i> Registrar Bus
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/RutaServlet?action=listar">
                            <i class='bx bxs-map me-2'></i> Programar Ruta
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/ClienteServlet?action=listar">
                            <i class='bx bx-user me-2'></i> Gestionar Clientes
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/Vista/AdministrarPasajes.jsp">
                            <i class='bx bxs-coupon me-2'></i> Pasajes
                        </a>
                    </li>
                </c:if>

                <c:if test="${sessionScope.user.rol == 3}">
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/Vista/Cliente/index.jsp">
                            <i class='bx bxs-dashboard me-2'></i> Mi Panel
                        </a>
                    </li>
                    <li class="nav-item mb-2">
                        <a class="nav-link" href="${pageContext.request.contextPath}/pasaje/listar.jsp">
                            <i class='bx bxs-coupon me-2'></i> Mis Pasajes
                        </a>
                    </li>
                </c:if>
            </ul>

            <hr>

            <div class="text-center">
                <a href="${pageContext.request.contextPath}/srvIniciarSesion?accion=cerrar" class="text-dark text-decoration-none">
                    <i class='bx bx-log-out me-2'></i> Cerrar Sesión
                </a>
            </div>
        </aside>

        <!-- OFFCANVAS (MÓVIL): mismo contenido que arriba pero para pantallas pequeñas -->
        <div class="offcanvas offcanvas-start d-md-none" tabindex="-1" id="offcanvasSidebar" aria-labelledby="offcanvasSidebarLabel">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="offcanvasSidebarLabel">Menú</h5>
                <button type="button" class="btn-close text-reset" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
            </div>
            <div class="offcanvas-body">
                <div class="text-center mb-3">
                    <img src="${pageContext.request.contextPath}/Imagenes/user-default.png"
                         onerror="this.src='https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'"
                         class="rounded-circle avatar-small img-fluid" alt="avatar">
                </div>
                <h6 class="text-center small mb-3">
                    <c:out value="${sessionScope.user.appat}"/> <c:out value="${sessionScope.user.apmat}"/><br/>
                    <strong><c:out value="${sessionScope.user.nombre}"/></strong>
                </h6>

                <ul class="nav flex-column">
                    <c:if test="${sessionScope.user.rol == 1}">
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/BusServlet?action=listar">
                                <i class='bx bxs-bus me-2'></i> Registrar Bus
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/ChoferServlet?action=listar">
                                <i class='bx bxs-user-account me-2'></i> Registrar Choferes
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/RutaServlet?action=listar">
                                <i class='bx bxs-map me-2'></i> Programar Ruta
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/ClienteServlet?action=listar">
                                <i class='bx bx-user me-2'></i> Gestionar Clientes
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/Vista/AdministrarPasajes.jsp">
                                <i class='bx bxs-coupon me-2'></i> Pasajes
                            </a>
                        </li>
                    </c:if>

                    <c:if test="${sessionScope.user.rol == 2}">
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/BusServlet?action=listar">
                                <i class='bx bxs-bus me-2'></i> Registrar Bus
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/RutaServlet?action=listar">
                                <i class='bx bxs-map me-2'></i> Programar Ruta
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/ClienteServlet?action=listar">
                                <i class='bx bx-user me-2'></i> Gestionar Clientes
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/Vista/AdministrarPasajes.jsp">
                                <i class='bx bxs-coupon me-2'></i> Pasajes
                            </a>
                        </li>
                    </c:if>

                    <c:if test="${sessionScope.user.rol == 3}">
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/Vista/Cliente/index.jsp">
                                <i class='bx bxs-dashboard me-2'></i> Mi Panel
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a class="nav-link" href="${pageContext.request.contextPath}/pasaje/listar.jsp">
                                <i class='bx bxs-coupon me-2'></i> Mis Pasajes
                            </a>
                        </li>
                    </c:if>
                </ul>

                <hr>
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/srvIniciarSesion?accion=cerrar" class="text-dark text-decoration-none">
                        <i class='bx bx-log-out me-2'></i> Cerrar Sesión
                    </a>
                </div>
            </div>
        </div>

        <main class="col-12 col-md-10 p-3 main-content">

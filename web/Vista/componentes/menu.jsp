<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<div class="d-flex">
    <%-- Sidebar --%>
    <div class="sidebar p-3 col-2 d-flex flex-column justify-content-between shadow">
        <div>
            <div class="d-flex justify-content-center align-items-center my-4">
                <img src="${pageContext.request.contextPath}/Imagenes/user-default.png"
                     onerror="this.src='https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg'"
                     class="rounded-circle" width="100" height="100" alt="avatar">
            </div>
            <div>
                <h4 class="text-center">
                    <c:out value="${sessionScope.user.appat}"/> <c:out value="${sessionScope.user.apmat}"/>, <c:out value="${sessionScope.user.nombre}"/>
                </h4>
            </div>
        </div>

        <hr>

        <ul class="nav flex-column">
            <%-- SOLO ADMIN (rol 1) --%>
            <c:if test="${sessionScope.user.rol == 1}">
                <li class="nav-item mb-3">
                    <a class="nav-link" href="${pageContext.request.contextPath}/BusServlet?action=listar"><i class='bx bxs-bus me-2'></i> Registrar Bus</a>
                </li>
                <li class="nav-item mb-3">
                    <a class="nav-link" href="${pageContext.request.contextPath}/ChoferServlet?action=listar"><i class='bx bxs-user-account me-2'></i> Registrar Choferes</a>
                </li>
                <li class="nav-item mb-3">
                    <a class="nav-link" href="${pageContext.request.contextPath}/RutaServlet?action=listar"><i class='bx bxs-map me-2'></i> Programar Ruta</a>
                </li>
                <li class="nav-item mb-3">
                    <a class="nav-link" href="${pageContext.request.contextPath}/ClienteServlet?action=listar"><i class='bx bx-user me-2'></i> Gestionar Clientes</a>
                </li>
                <li class="nav-item mb-3">
                    <a class="nav-link" href="${pageContext.request.contextPath}/Vista/AdministrarPasajes.jsp"><i class='bx bxs-coupon me-2'></i> Pasajes</a>
                </li>
            </c:if>

            <%-- ROL 2: Solo Registrar Cliente (por ejemplo) --%>
            <c:if test="${sessionScope.user.rol == 2}">
                <li class="nav-item mb-3">
                    <a class="nav-link" href="${pageContext.request.contextPath}/ClienteServlet?action=agregarForm"><i class='bx bx-user me-2'></i> Registrar Cliente</a>
                </li>
            </c:if>

            <%-- ROL 3: Cliente (ejemplo) --%>
            <c:if test="${sessionScope.user.rol == 3}">
                <li class="nav-item mb-3">
                    <a class="nav-link" href="${pageContext.request.contextPath}/Vista/Cliente/index.jsp"><i class='bx bxs-dashboard me-2'></i> Mi Panel</a>
                </li>
                <li class="nav-item mb-3">
                    <a class="nav-link" href="${pageContext.request.contextPath}/pasaje/listar.jsp"><i class='bx bxs-coupon me-2'></i> Mis Pasajes</a>
                </li>
            </c:if>

            <%-- Opcional: items visibles para admin+empleado --%>
            <c:if test="${sessionScope.user.rol == 1 || sessionScope.user.rol == 2}">
                <%-- Por ejemplo, acceso rápido a "Buscar Cliente" para ambos --%>
                <li class="nav-item mb-3">
                    <a class="nav-link" href="${pageContext.request.contextPath}/ClienteServlet?action=buscar"><i class='bx bx-search me-2'></i> Buscar Cliente</a>
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

    <%-- Espaciador para el contenido principal --%>
    <div class="col-2"></div>

    <%-- Contenedor del contenido principal: abre wrapper que cerrará el footer --%>
    <div class="col-10 main-content">
        <%-- El JSP incluido pondrá su contenido aquí --%>

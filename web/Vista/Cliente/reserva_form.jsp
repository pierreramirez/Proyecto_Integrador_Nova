<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../componentes/public/header.jsp" />

<link href="${pageContext.request.contextPath}/css/novas-landing.css" rel="stylesheet" />

<style>
    .nav-actions {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-left: 1rem;
    }
    @media (max-width: 768px) {
        .nav-actions {
            margin-left: 0;
        }
    }

    /* estilos dropdown usuario (para mantener apariencia similar al botón Acceder) */
    .user-dropdown {
        position: relative;
        display:inline-block;
    }
    .user-btn {
        display:flex;
        align-items:center;
        gap:8px;
        padding:8px 12px;
        border-radius:8px;
        background:transparent;
        border:0;
        color:inherit;
        cursor:pointer;
    }
    .user-avatar {
        width:32px;
        height:32px;
        border-radius:50%;
        background:#fff;
        display:inline-flex;
        align-items:center;
        justify-content:center;
        color:#1d3aa0;
        font-weight:700;
    }
    .user-menu {
        display:none;
        position:absolute;
        right:0;
        top:calc(100% + 6px);
        background:#fff;
        color:#222;
        min-width:160px;
        box-shadow:0 6px 18px rgba(0,0,0,0.12);
        border-radius:8px;
        padding:6px 0;
        z-index:999;
    }
    .user-menu a {
        display:block;
        padding:8px 12px;
        color:#222;
        text-decoration:none;
    }
    .user-menu a:hover {
        background:#f4f6fb;
    }
</style>

<div class="container" style="padding:28px;">
    <h2>Confirmar reserva</h2>

    <c:if test="${not empty error}">
        <div style="color:red; margin-bottom:10px;">${error}</div>
    </c:if>

    <c:if test="${not empty viaje}">
        <p>Viaje: <c:out value="${viaje.idViaje}"/> - Precio: S/ <c:out value="${viaje.precio}"/></p>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/ReservaServlet">
        <input type="hidden" name="action" value="confirm" />
        <input type="hidden" name="viajeId" value="${param.viajeId != null ? param.viajeId : ''}" />
        <input type="hidden" name="asientoId" value="${param.asientoId != null ? param.asientoId : asientoId}" />

        <p>Asiento seleccionado: <strong><c:out value="${param.asientoId != null ? param.asientoId : asientoId}"/></strong></p>

        <!-- Si no hay sesión de usuario, pedir datos básicos (ejemplo) -->
        <c:if test="${sessionScope.userId == null}">
            <label>Nombre:</label><br/>
            <input type="text" name="clienteNombre" required/><br/><br/>
        </c:if>

        <button type="submit" class="btn btn-primary">Confirmar reserva</button>
        <a href="${pageContext.request.contextPath}/VerAsientosServlet?viajeId=${param.viajeId}" class="btn btn-outline">Volver</a>
    </form>
</div>

<jsp:include page="../componentes/public/footer.jsp" />

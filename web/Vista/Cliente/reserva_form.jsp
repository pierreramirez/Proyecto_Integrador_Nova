<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/Vista/componentes/header.jsp" />
<link href="${pageContext.request.contextPath}/css/novas-landing.css" rel="stylesheet" />

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

<jsp:include page="/Vista/componentes/footer.jsp" />

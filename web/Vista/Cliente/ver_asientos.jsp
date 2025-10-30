<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/Vista/componentes/header.jsp" />
<link href="${pageContext.request.contextPath}/css/novas-landing.css" rel="stylesheet" />

<div class="container" style="padding:28px;">
    <h2>Asientos - Viaje: <c:out value="${viaje != null ? viaje.idViaje : 'N/A'}"/></h2>

    <c:if test="${empty asientos}">
        <div class="alert alert-info">No hay asientos generados para este viaje.</div>
    </c:if>

    <c:if test="${not empty asientos}">
        <div style="display:grid; grid-template-columns: repeat(auto-fill, 60px); gap:12px; align-items:start;">
            <c:forEach var="a" items="${asientos}">
                <c:choose>
                    <c:when test="${a.estado == 0}">
                        <a href="${pageContext.request.contextPath}/ReservaServlet?action=reserveForm&viajeId=${a.idViaje}&asientoId=${a.idAsientoViaje}"
                           style="display:block; text-align:center; padding:10px; background:#2ecc71; color:#fff; border-radius:6px; text-decoration:none;">
                            ${a.numeroAsiento}
                        </a>
                    </c:when>
                    <c:otherwise>
                        <div style="padding:10px; background:#cccccc; text-align:center; border-radius:6px; color:#666;">
                            ${a.numeroAsiento}
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>
    </c:if>
</div>

<jsp:include page="/Vista/componentes/footer.jsp" />

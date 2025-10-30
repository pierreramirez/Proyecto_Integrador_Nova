<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="/Vista/componentes/header.jsp" />

<link href="${pageContext.request.contextPath}/css/novas-landing.css" rel="stylesheet" />

<div class="container" style="padding:28px 12px;">
    <div class="section-header" style="text-align:center; margin-bottom:18px;">
        <h1 style="font-size:34px; color:#1d3aa0;">
            Viajes a: <c:out value="${lugar != null ? lugar.nombre : 'Destino'}"/>
        </h1>
        <p style="color:#6b6b6b;">Selecciona el viaje que prefieras</p>
    </div>

    <c:if test="${empty viajes}">
        <div class="alert alert-info" style="padding:16px; border-radius:8px; background:#f4f7fb; border:1px solid #e0e6f0;">
            No se encontraron viajes para este destino.
        </div>
        <div style="margin-top:12px;">
            <a class="btn" href="${pageContext.request.contextPath}/">Volver al inicio</a>
        </div>
    </c:if>

    <c:if test="${not empty viajes}">
        <div class="viajes-grid" style="display:grid; grid-template-columns: repeat(auto-fill,minmax(320px,1fr)); gap:18px;">
            <c:forEach var="v" items="${viajes}">
                <div class="card viaje-card" style="background:#fff; border-radius:10px; box-shadow:0 6px 18px rgba(20,30,60,0.06); padding:14px;">
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                        <div>
                            <h3 style="margin:0; color:#243a8b;">Viaje #<c:out value="${v.idViaje}"/></h3>
                            <small style="color:#6b6b6b;">Bus ID: <c:out value="${v.idBus}"/></small>
                        </div>
                        <div style="text-align:right;">
                            <div style="font-weight:700; color:#e66b00;">S/ <c:out value="${v.precio}"/></div>
                            <div style="font-size:12px; color:#6b6b6b;">Estado: <c:out value="${v.estado}"/></div>
                        </div>
                    </div>

                    <hr style="border:none;border-top:1px solid #eee;margin:10px 0;">

                    <div style="display:flex; gap:12px; align-items:center; justify-content:space-between;">
                        <div>
                            <p style="margin:0;">
                                <strong>Salida:</strong>
                                <fmt:formatDate value="${v.fechaSalida}" pattern="dd/MM/yyyy" /> —
                                <fmt:formatDate value="${v.horaSalida}" pattern="HH:mm"/>
                            </p>
                            <p style="margin:0;">
                                <strong>Asientos disponibles:</strong>
                                <c:out value="${v.disponibles != null ? v.disponibles : 0}"/>
                            </p>
                        </div>

                        <div style="display:flex; flex-direction:column; gap:6px;">
                            <a href="${pageContext.request.contextPath}/ReservaServlet?action=init&viajeId=${v.idViaje}"
                               class="btn btn-primary" style="padding:8px 14px; border-radius:8px;">Reservar</a>

                            <a href="${pageContext.request.contextPath}/VerAsientosServlet?viajeId=${v.idViaje}"
                               class="btn btn-outline" style="padding:8px 14px; border-radius:8px;">Ver asientos</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:if>
</div>

<jsp:include page="/Vista/componentes/footer.jsp" />

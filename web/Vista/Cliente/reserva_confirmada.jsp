<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/Vista/componentes/header.jsp" />

<link href="${pageContext.request.contextPath}/css/novas-landing.css" rel="stylesheet" />

<div class="container" style="padding:28px; max-width:900px; margin:28px auto;">
    <div style="background:#fff; border-radius:10px; box-shadow:0 8px 24px rgba(16,24,64,0.08); padding:24px;">
        <h2 style="color:#243a8b; margin:0 0 8px 0;">Reserva confirmada</h2>
        <p style="color:#6b6b6b; margin:0 0 18px 0;">Tu reserva se registró correctamente. Detalles:</p>

        <div style="display:flex; gap:18px; flex-wrap:wrap;">
            <div style="flex:1; min-width:220px;">
                <strong>Asiento ID:</strong>
                <div style="padding:8px 10px; background:#f7f9ff; border-radius:6px;"> <c:out value="${param.asientoId}" /> </div>
            </div>
            <div style="flex:1; min-width:220px;">
                <strong>Viaje ID:</strong>
                <div style="padding:8px 10px; background:#f7f9ff; border-radius:6px;"> <c:out value="${param.viajeId}" /> </div>
            </div>
            <div style="flex:1; min-width:220px;">
                <strong>Estado:</strong>
                <div style="padding:8px 10px; background:#f7f9ff; border-radius:6px;"> Confirmada </div>
            </div>
        </div>

        <div style="margin-top:20px; display:flex; gap:12px; align-items:center;">
            <a href="pago.jsp?asientoId=${param.asientoId}&viajeId=${param.viajeId}"
               class="btn btn-primary" style="padding:10px 18px; border-radius:8px;">
                💳 Pagar reserva
            </a>

            <a href="${pageContext.request.contextPath}/" class="btn btn-outline" style="padding:10px 18px; border-radius:8px;">
                ← Volver al inicio
            </a>

            <span style="margin-left:auto; color:#999; font-size:13px;">Demo de pago: visual solamente.</span>
        </div>
    </div>
</div>

<jsp:include page="/Vista/componentes/footer.jsp" />

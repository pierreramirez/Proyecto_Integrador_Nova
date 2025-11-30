<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<jsp:include page="../componentes/public/header.jsp" />

<link href="${pageContext.request.contextPath}/css/novas-landing.css" rel="stylesheet" />

<%
    // Recoger parámetros: admite asientoIds (CSV) o asientoId (único)
    String asientoIdsParam = request.getParameter("asientoIds");
    if (asientoIdsParam == null || asientoIdsParam.trim().isEmpty()) {
        asientoIdsParam = request.getParameter("asientoId");
    }
    String viajeIdParam = request.getParameter("viajeId");
    if (viajeIdParam == null) {
        viajeIdParam = "";
    }

    java.util.List<String> asientoIdsList = new java.util.ArrayList<>();
    if (asientoIdsParam != null && !asientoIdsParam.trim().isEmpty()) {
        String[] parts = asientoIdsParam.split(",");
        for (String p : parts) {
            String t = p.trim();
            if (!t.isEmpty()) {
                asientoIdsList.add(t);
            }
        }
    }
    // exponer para JSTL
    request.setAttribute("asientoIdsList", asientoIdsList);

    // string para query (reconstruir CSV)
    String asientoIdsQuery = String.join(",", asientoIdsList);
%>

<style>
    :root {
        --header-height: 84px;
    } /* fallback seguro */

    /* fuerza que el contenido quede siempre por debajo del header */
    .page-content {
        padding-top: calc(var(--header-height) + 20px); /* espacio extra de 20px */
        padding-bottom: 48px;
        min-height: calc(100vh - var(--header-height) - 220px); /* evita que el footer suba */
        transition: padding-top 160ms ease;
    }

    .reserva-card {
        background:#fff;
        padding:22px;
        border-radius:12px;
        box-shadow:0 10px 30px rgba(8,15,40,0.06);
    }
    .badge-id {
        display:inline-block;
        padding:8px 10px;
        background:#f4f6fb;
        border-radius:8px;
        margin:6px 6px 6px 0;
        color:#1d3aa0;
        font-weight:600;
    }
    .muted {
        color:#6b6b6b;
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

    footer {
        position: relative;
        z-index: 10;
        margin-top: 28px;
    } /* footer en flujo normal */

    @media (max-width: 720px) {
        .bus-info {
            flex-direction: column;
            gap: 12px;
        }
        .page-content {
            padding-top: calc(var(--header-height) + 12px);
        }
    }
</style>

<div class="page-content">
    <div class="container" style="max-width:900px; margin:0 auto;">
        <div class="reserva-card" style="margin-top:0;">
            <div style="display:flex; gap:18px; align-items:flex-start; flex-wrap:wrap;">
                <div style="flex:1; min-width:240px;">
                    <h2 style="color:#243a8b; margin:0 0 6px 0;">Reserva confirmada</h2>
                    <p class="muted" style="margin:0 0 12px 0;">Tu(s) asiento(s) fueron reservados correctamente. Revisa los detalles abajo.</p>

                    <div style="margin-top:10px;">
                        <strong>Cantidad:</strong>
                        <div style="margin-top:6px;">
                            <span class="badge-id"><c:out value="${fn:length(asientoIdsList)}" /></span>
                        </div>
                    </div>

                    <div style="margin-top:12px;">
                        <strong>Asientos reservados:</strong>
                        <div style="margin-top:8px;">
                            <c:choose>
                                <c:when test="${not empty asientoIdsList}">
                                    <c:forEach var="aid" items="${asientoIdsList}">
                                        <span class="badge-id">${aid}</span>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div style="padding:8px 10px; background:#fff8e6; border-radius:8px; color:#8a6d00;">No hay IDs de asientos en los parámetros.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <div style="flex:1; min-width:220px;">
                    <div style="background:#f7f9ff; border-radius:10px; padding:12px;">
                        <p style="margin:0 0 8px 0;"><strong>Viaje ID</strong></p>
                        <div style="padding:8px 10px; background:#fff; border-radius:6px; color:#243a8b; font-weight:700;">
                            <c:out value="${param.viajeId}" default="${empty param.viajeId ? '' : param.viajeId}" />
                            <c:if test="${empty param.viajeId}"><c:out value="${viajeIdParam}" /></c:if>
                            </div>

                            <p style="margin:12px 0 8px 0;"><strong>Estado</strong></p>
                            <div style="padding:8px 10px; background:#e9f7ef; border-radius:6px; color:#0b5136; font-weight:600;">Confirmada</div>
                        </div>

                        <div style="margin-top:16px; display:flex; gap:10px; align-items:center;">
                        <c:url var="pagoUrl" value="/Vista/Cliente/pago.jsp">
                            <c:param name="viajeId" value="${param.viajeId != null ? param.viajeId : viajeIdParam}" />
                            <c:param name="asientoIds" value="<%= asientoIdsQuery%>" />
                        </c:url>

                        <a href="${pagoUrl}" class="btn btn-primary" style="padding:10px 16px; border-radius:8px;">
                            💳 Pagar reserva
                        </a>

                        <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary" style="padding:10px 16px; border-radius:8px;">
                            ← Volver al inicio
                        </a>
                    </div>
                </div>
            </div>

            <div style="margin-top:18px; color:#777; font-size:13px;">
                <strong>Nota:</strong> Esto es una confirmación de reserva en el sistema. El pago se realiza en la siguiente pantalla. En producción valida la sesión y aplica transacciones/rollback al confirmar múltiples reservas.
            </div>
        </div>
    </div>
</div>

<jsp:include page="../componentes/public/footer.jsp" />

<script>
    (function () {
        function applyHeaderSpacing() {
            // detecta el header/jar/navbar más probable
            var header = document.querySelector('header') ||
                    document.querySelector('.navbar') ||
                    document.querySelector('.site-header') ||
                    document.querySelector('#header') ||
                    document.querySelector('.topbar');

            var height = 84; // fallback
            if (header) {
                // offsetHeight es más estable que getBoundingClientRect en algunos layouts
                height = Math.max(56, Math.ceil(header.offsetHeight || header.getBoundingClientRect().height || 84));
            }
            document.documentElement.style.setProperty('--header-height', height + 'px');
        }

        // intentos múltiples por si el header se renderiza después
        window.addEventListener('DOMContentLoaded', applyHeaderSpacing);
        window.addEventListener('load', function () {
            applyHeaderSpacing();
            setTimeout(applyHeaderSpacing, 120);
            setTimeout(applyHeaderSpacing, 420);
        });
        window.addEventListener('resize', function () {
            setTimeout(applyHeaderSpacing, 120);
        });
    })();
</script>

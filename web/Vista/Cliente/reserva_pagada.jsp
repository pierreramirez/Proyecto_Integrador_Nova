<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="java.time.*, java.time.format.*" %>

<jsp:include page="/Vista/componentes/header.jsp" />

<link href="${pageContext.request.contextPath}/css/novas-landing.css" rel="stylesheet" />

<style>
    .ticket-wrap {
        max-width:880px;
        margin:28px auto;
    }
    .ticket {
        background:#fff;
        border-radius:12px;
        box-shadow:0 10px 30px rgba(20,30,60,0.06);
        padding:20px;
        display:flex;
        gap:18px;
        flex-wrap:wrap;
    }
    .ticket-left {
        flex:1 1 420px;
    }
    .ticket-right {
        width:320px;
        flex:0 0 320px;
    }
    .badge-status {
        background:#e8f7ec;
        color:#126a2d;
        padding:6px 10px;
        border-radius:8px;
        font-weight:700;
        display:inline-block;
    }
    .field {
        margin:8px 0;
    }
    .label {
        color:#6b7280;
        font-size:13px;
    }
    .value {
        font-weight:700;
        font-size:16px;
        color:#111827;
    }
    .seats-list {
        display:flex;
        gap:6px;
        flex-wrap:wrap;
        margin-top:8px;
    }
    .seat-pill {
        background:#eef2ff;
        color:#1d3aa0;
        padding:6px 10px;
        border-radius:999px;
        font-weight:600;
    }
    .actions {
        margin-top:18px;
        display:flex;
        gap:10px;
        align-items:center;
    }
    .btn {
        padding:10px 14px;
        border-radius:8px;
        border:none;
        cursor:pointer;
        font-weight:700;
    }
    .btn-primary {
        background:#1d3aa0;
        color:#fff;
    }
    .btn-outline {
        background:transparent;
        border:1px solid #d1d5db;
        color:#111827;
        padding:10px 14px;
        border-radius:8px;
    }
    .muted {
        color:#6b7280;
        font-size:13px;
    }
    .total {
        font-size:20px;
        font-weight:900;
        color:#0b3a75;
    }
</style>

<div class="container ticket-wrap">
    <div id="ticketArea" class="ticket" role="region" aria-label="Boleta de reserva (ticket)">
        <div class="ticket-left">
            <div style="display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <div class="badge-status">RESERVA PAGADA</div>
                    <div style="margin-top:8px;"><small class="muted">Número(s) de reserva</small></div>

                    <!-- Mostrar código de reserva si viene -->
                    <div style="font-size:18px; font-weight:800; margin-top:6px;" id="reservationsText">
                        <c:choose>
                            <c:when test="${not empty codigoReserva}">
                                <c:out value="${codigoReserva}" />
                                <div style="font-size:12px; color:#6b7280; margin-top:6px;">(Código de reserva)</div>
                            </c:when>
                            <c:when test="${not empty reservedIds}">
                                <c:forEach var="rid" items="${reservedIds}" varStatus="st">
                                    <c:out value="${rid}" /><c:if test="${!st.last}">, </c:if>
                                </c:forEach>
                            </c:when>
                            <c:when test="${not empty param.asientoIds}">
                                <c:out value="${param.asientoIds}" />
                            </c:when>
                            <c:when test="${not empty param.asientoId}">
                                <c:out value="${param.asientoId}" />
                            </c:when>
                            <c:otherwise>
                                (ID no disponible)
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div style="text-align:right;">
                    <div class="muted">Emitido</div>
                    <div id="emitido" style="font-weight:700;"></div>
                    <div class="muted" style="margin-top:6px;">Estado</div>
                    <div class="muted" id="estadoTicket">PAGADO</div>
                </div>
            </div>

            <hr style="margin:16px 0; border:none; border-top:1px solid #eef2f6;">

            <div>
                <div class="field">
                    <div class="label">Viaje</div>
                    <div class="value" id="viajeTitle">
                        <c:choose>
                            <c:when test="${not empty viaje}">
                                <c:out value="${viaje.origen}" /> → <c:out value="${viaje.destino}" />
                            </c:when>
                            <c:otherwise>
                                Viaje ID: <c:out value="${param.viajeId}" />
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="field">
                    <div class="label">Fecha & Hora</div>
                    <div class="value" id="viajeDatetime">
                        <c:choose>
                            <c:when test="${not empty viaje}">
                                <c:out value="${viaje.fechaHora}" />
                            </c:when>
                            <c:otherwise>
                                <%
                                    LocalDateTime now = LocalDateTime.now();
                                    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                                %>
                                <%= now.format(fmt)%>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="field">
                    <div class="label">Asientos</div>
                    <div id="seatsContainer" class="seats-list">
                        <!-- Mostrar desde atributo reservedIds (preferido) -->
                        <c:if test="${not empty reservedIds}">
                            <c:forEach var="rid" items="${reservedIds}">
                                <div class="seat-pill"><c:out value="${rid}" /></div>
                            </c:forEach>
                        </c:if>

                        <!-- fallback: usar param.asientoId(s) si no hubo forward -->
                        <c:if test="${empty reservedIds && not empty param.asientoIds}">
                            <c:forEach var="x" items="${fn:split(param.asientoIds, ',')}">
                                <div class="seat-pill"><c:out value="${fn:trim(x)}" /></div>
                            </c:forEach>
                        </c:if>

                        <c:if test="${empty reservedIds && empty param.asientoIds && not empty param.asientoId}">
                            <div class="seat-pill"><c:out value="${param.asientoId}" /></div>
                        </c:if>
                    </div>
                </div>

                <div class="field">
                    <div class="label">Cliente</div>
                    <div class="value" id="clienteName">
                        <c:out value="${sessionScope.userName != null ? sessionScope.userName : 'Cliente' }" />
                    </div>
                </div>
            </div>
        </div>

        <div class="ticket-right">
            <div style="background:linear-gradient(180deg,#ffffff,#f6f8ff); padding:14px; border-radius:10px;">
                <div class="label">Detalle</div>
                <div style="display:flex; justify-content:space-between; margin-top:8px;">
                    <div class="muted">Subtotal</div>
                    <div id="subtotal" class="value">
                        <c:out value="${subtotal != null ? 'S/ ' + subtotal : 'S/ 0.00'}" />
                    </div>
                </div>
                <div style="display:flex; justify-content:space-between; margin-top:6px;">
                    <div class="muted">Comisión</div>
                    <div id="comision" class="value">
                        <c:out value="${comision != null ? 'S/ ' + comision : 'S/ 0.00'}" />
                    </div>
                </div>
                <hr style="margin:12px 0; border:none; border-top:1px solid #eef2f6;">
                <div style="display:flex; justify-content:space-between; align-items:center;">
                    <div class="muted">Total</div>
                    <div id="total" class="total">
                        <c:out value="${total != null ? 'S/ ' + total : 'S/ 0.00'}" />
                    </div>
                </div>

                <div class="actions">
                    <button id="btnPrint" class="btn btn-primary">Imprimir / Guardar PDF</button>
                    <button id="btnPDF" class="btn btn-outline">Exportar PDF (alta calidad)</button>
                </div>

                <div style="margin-top:10px;" class="muted">Puedes imprimir o exportar la boleta en PDF para tu respaldo.</div>
            </div>
        </div>
    </div>
</div>

<!-- jsPDF + html2canvas CDN -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>

<script>
    // Valores seguros inyectados desde servidor (atributos o params)
    const CTX = '<c:out value="${pageContext.request.contextPath}" />';

    // reserved: prefer attribute reservedIds (forward) else params
    let reserved = [];
    (function initReserved() {
        // If server forwarded reservedIds attribute, it was rendered into DOM as .seat-pill elements; read them:
        const pills = document.querySelectorAll('#seatsContainer .seat-pill');
        if (pills && pills.length > 0) {
            reserved = Array.from(pills).map(p => p.textContent.trim());
            return;
        }
        // fallback: parse query params asientoIds / asientoId
        const qp = new URLSearchParams(window.location.search);
        const asIds = qp.get('asientoIds') || '<c:out value="${param.asientoIds}" />';
        const asId = qp.get('asientoId') || '<c:out value="${param.asientoId}" />';
        if (asIds && asIds.trim() !== '') {
            reserved = asIds.split(',').map(s => s.trim()).filter(s => s !== '');
        } else if (asId && asId.trim() !== '') {
            reserved = [asId];
        }
    })();

    // codigoReserva si viene del servidor
    const codigoReserva = '<c:out value="${codigoReserva != null ? codigoReserva : ''}" />';

    // mostrar fecha de emisión
    (function setEmitido() {
        const now = new Date();
        const fmt = now.toLocaleString('es-PE', {year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit'});
        document.getElementById('emitido').textContent = fmt;
    })();

    // Si subtotal/comision/total NO vienen del servidor (fallback), intentamos calcular consultando precios
    async function loadPricesIfNeeded() {
        try {
            const subtotalEl = document.getElementById('subtotal');
            if (subtotalEl && subtotalEl.textContent && !subtotalEl.textContent.includes('0.00')) {
                return;
            }
            const qp = new URLSearchParams(window.location.search);
            const viajeId = qp.get('viajeId') || '<c:out value="${param.viajeId}" />';

            let subtotal = 0;
            if (viajeId && reserved.length > 0) {
                const url = CTX + '/VerAsientosServlet?format=json&viajeId=' + encodeURIComponent(viajeId);
                const resp = await fetch(url);
                if (resp.ok) {
                    const data = await resp.json();
                    reserved.forEach(rid => {
                        const found = data.find(s => String(s.id) === String(rid) || String(s.numero) === String(rid));
                        if (found && found.precio) {
                            subtotal += Number(found.precio);
                        }
                    });
                }
            }

            if (subtotal === 0 && reserved.length > 0) {
                subtotal = reserved.length * 45.00;
            }
            const comision = Number((subtotal * 0.05).toFixed(2));
            const total = Number((subtotal + comision).toFixed(2));

            document.getElementById('subtotal').textContent = 'S/ ' + subtotal.toFixed(2);
            document.getElementById('comision').textContent = 'S/ ' + comision.toFixed(2);
            document.getElementById('total').textContent = 'S/ ' + total.toFixed(2);
        } catch (e) {
            console.error(e);
        }
    }

    // Botones
    document.getElementById('btnPrint').addEventListener('click', () => window.print());

    document.getElementById('btnPDF').addEventListener('click', async () => {
        const ticket = document.getElementById('ticketArea');
        const scale = 2;
        try {
            const canvas = await html2canvas(ticket, {scale: scale, useCORS: true, logging: false});
            const imgData = canvas.toDataURL('image/jpeg', 0.95);
            const {jsPDF} = window.jspdf;
            const pdf = new jsPDF({unit: 'mm', format: 'a4', orientation: 'portrait'});
            const pageWidth = pdf.internal.pageSize.getWidth();

            const imgProps = pdf.getImageProperties(imgData);
            const imgWidthMM = pageWidth - 20;
            const imgHeightMM = (imgProps.height * imgWidthMM) / imgProps.width;

            pdf.addImage(imgData, 'JPEG', 10, 10, imgWidthMM, imgHeightMM);

            const dateStr = (new Date()).toISOString().slice(0, 10);
            const reservedPart = (reserved.length > 0) ? reserved.join('-') : 'NA';
            const filename = 'boleta_reserva_' + (codigoReserva ? codigoReserva + '_' : '') + reservedPart + '_' + dateStr + '.pdf';
            pdf.save(filename);
        } catch (err) {
            console.error('Error generando PDF', err);
            alert('No se pudo generar el PDF. Usa la opción Imprimir/Guardar como PDF.');
        }
    });

    // Inicial
    loadPricesIfNeeded();
</script>

<jsp:include page="/Vista/componentes/footer.jsp" />

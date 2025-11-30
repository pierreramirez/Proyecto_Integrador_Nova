<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- HEADER PRINCIPAL -->
<jsp:include page="../componentes/public/header.jsp" />

<%
    // parámetros esperados: viajeId, cantidad (vienen por query string o por forward del servlet)
    String viajeIdParam = request.getParameter("viajeId");
    if (viajeIdParam == null) {
        viajeIdParam = (request.getAttribute("viaje") != null) ? String.valueOf(((Modelo.DTOViaje) request.getAttribute("viaje")).getIdViaje()) : "";
    }
    String cantidadParam = request.getParameter("cantidad");
    if (cantidadParam == null) {
        Object cAttr = request.getAttribute("cantidad");
        if (cAttr != null) {
            cantidadParam = String.valueOf(cAttr);
        }
    }
    int maxSelectable = 1;
    try {
        if (cantidadParam != null && !cantidadParam.isEmpty()) {
            maxSelectable = Integer.parseInt(cantidadParam);
        }
    } catch (Exception e) {
        maxSelectable = 1;
    }
%>

<style>
    body {
        background: #eef3f9;
        margin: 0;
        padding: 0;
    }
    .bus-container {
        width: 500px;
        margin: 80px auto;
        background: white;
        padding: 25px;
        border-radius: 25px;
        box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        text-align: center;
    }
    .title-box {
        background: #0a1a77;
        color: white;
        padding: 16px;
        font-size: 22px;
        font-weight: bold;
        border-radius: 12px;
        margin-bottom: 20px;
    }
    .legend {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-bottom: 15px;
        font-size: 14px;
    }
    .legend-item {
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .legend-box {
        width: 18px;
        height: 18px;
        border-radius: 4px;
    }
    .legend-free {
        background: #1b74c9;
    }
    .legend-taken {
        background: #bcbcbc;
    }
    .driver-row {
        display: grid;
        grid-template-columns: 1fr 1fr 40px 1fr 1fr;
        margin-bottom: 20px;
    }
    .driver-seat {
        width: 80px;
        height: 50px;
        background: #d97706;
        border-radius: 12px;
        display: flex;
        justify-content: center;
        align-items: center;
        color: white;
        font-size: 26px;
        grid-column: 1;
        margin:0 auto;
    }
    .seats-grid {
        display: grid;
        grid-template-columns: 1fr 1fr 40px 1fr 1fr;
        gap: 12px;
        justify-content: center;
        padding: 10px 0;
    }
    .seat {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 45px;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        transition: 0.12s;
        user-select: none;
    }
    .seat-free {
        background: #1b74c9;
        color: white;
    }
    .seat-free:hover {
        transform: scale(1.06);
    }
    .seat-taken {
        background: #bcbcbc;
        color: #555;
        cursor: not-allowed;
    }
    .seat-selected {
        background: #ffd966;
        color: #3b2b00;
        border: 2px solid #f39c12;
        transform: scale(1.03);
    }
    .aisle {
        background: transparent;
    }
    .seat-label {
        margin-top: 15px;
        color: #777;
        font-size: 14px;
    }
    .controls {
        margin-top: 16px;
        display:flex;
        justify-content:space-between;
        align-items:center;
        gap:12px;
        flex-wrap:wrap;
    }
</style>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/novas-landing.css">

<div class="bus-container">
    <div class="title-box">PLANO DEL BUS</div>

    <!-- Leyenda -->
    <div class="legend">
        <div class="legend-item"><div class="legend-box legend-free"></div> Disponible</div>
        <div class="legend-item"><div class="legend-box legend-taken"></div> Ocupado</div>
    </div>

    <!-- Asiento del conductor -->
    <div class="driver-row">
        <div class="driver-seat">🧑‍️</div>
    </div>

    <!-- Asientos -->
    <div class="seats-grid" id="seatsGrid">
        <c:set var="col" value="0"/>
        <c:forEach var="a" items="${asientos}">
            <c:if test="${col == 2}">
                <div class="aisle"></div>
            </c:if>

            <c:choose>
                <c:when test="${a.estado == 0}">
                    <div class="seat seat-free"
                         role="button"
                         tabindex="0"
                         data-id="${a.idAsientoViaje}"
                         data-num="${a.numeroAsiento}">
                        ${a.numeroAsiento}
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="seat seat-taken">${a.numeroAsiento}</div>
                </c:otherwise>
            </c:choose>

            <c:set var="col" value="${col + 1}"/>
            <c:if test="${col == 4}">
                <c:set var="col" value="0"/>
            </c:if>
        </c:forEach>
    </div>

    <div class="seat-label">Seleccione hasta <strong id="requiredCount"><%= maxSelectable%></strong> asiento(s)</div>

    <div class="controls">
        <div class="selected-info">Seleccionados: <span id="selectedCount">0</span></div>
        <div style="margin-left:auto; display:flex; gap:8px;">
            <button id="clearBtn" class="btn btn-light">Limpiar</button>
            <button id="reserveBtn" class="btn btn-success" disabled>Reservar seleccionados</button>
        </div>
    </div>
</div>

<!-- FOOTER PRINCIPAL -->
<jsp:include page="../componentes/public/footer.jsp" />

<script>
    (function () {
        const ctx = '${pageContext.request.contextPath}';
        const viajeId = '<%= viajeIdParam%>';
        const maxSelectable = parseInt('<%= maxSelectable%>', 10) || 1;
        const seatsGrid = document.getElementById('seatsGrid');
        const seatEls = seatsGrid ? seatsGrid.querySelectorAll('.seat-free') : [];
        const selected = new Set();
        const selectedCountEl = document.getElementById('selectedCount');
        const requiredCountEl = document.getElementById('requiredCount');
        const reserveBtn = document.getElementById('reserveBtn');
        const clearBtn = document.getElementById('clearBtn');

        requiredCountEl.innerText = maxSelectable;

        function updateUI() {
            selectedCountEl.innerText = selected.size;
            reserveBtn.disabled = (selected.size === 0);
            seatEls.forEach(el => {
                if (!selected.has(el.dataset.id)) {
                    if (selected.size >= maxSelectable) {
                        el.style.opacity = '0.6';
                    } else {
                        el.style.opacity = '';
                    }
                }
            });
        }

        seatEls.forEach(el => {
            el.addEventListener('click', () => {
                const id = el.dataset.id;
                if (selected.has(id)) {
                    selected.delete(id);
                    el.classList.remove('seat-selected');
                } else {
                    if (selected.size >= maxSelectable) {
                        alert('Ya seleccionaste la cantidad máxima (' + maxSelectable + '). Deselecciona uno para elegir otro.');
                        return;
                    }
                    selected.add(id);
                    el.classList.add('seat-selected');
                }
                updateUI();
            });
            el.addEventListener('keydown', (ev) => {
                if (ev.key === 'Enter' || ev.key === ' ') {
                    ev.preventDefault();
                    el.click();
                }
            });
        });

        clearBtn.addEventListener('click', () => {
            selected.clear();
            seatEls.forEach(e => e.classList.remove('seat-selected'));
            updateUI();
        });

        reserveBtn.addEventListener('click', () => {
            if (selected.size === 0) {
                alert('Selecciona al menos 1 asiento.');
                return;
            }
            if (selected.size > maxSelectable) {
                alert('Has seleccionado más asientos de los permitidos.');
                return;
            }
            // crear y enviar formulario POST a ReservaServlet?action=reserveMultiple
            const form = document.createElement('form');
            form.method = 'post';
            form.action = ctx + '/ReservaServlet?action=reserveMultiple';
            // viajeId
            const vi = document.createElement('input');
            vi.type = 'hidden';
            vi.name = 'viajeId';
            vi.value = viajeId;
            form.appendChild(vi);
            // cantidad
            const cq = document.createElement('input');
            cq.type = 'hidden';
            cq.name = 'cantidad';
            cq.value = selected.size;
            form.appendChild(cq);
            // asientoIds (múltiples)
            Array.from(selected).forEach(id => {
                const ai = document.createElement('input');
                ai.type = 'hidden';
                ai.name = 'asientoIds';
                ai.value = id;
                form.appendChild(ai);
            });
            document.body.appendChild(form);
            form.submit();
        });

        updateUI();
    })();
</script>

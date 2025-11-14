<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Reservar - Selección de asientos</title>
        <!-- Bootstrap CDN (opcional) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            .seat {
                width:48px;
                height:48px;
                margin:4px;
                border-radius:6px;
                cursor:pointer;
                display:inline-flex;
                align-items:center;
                justify-content:center;
            }
            .seat.available {
                background:#e9f7ef;
                border:1px solid #2ecc71;
                color:#0b5136;
            }
            .seat.unavailable {
                background:#f5f5f5;
                border:1px solid #ccc;
                color:#aaa;
                cursor:not-allowed;
            }
            .seat.selected {
                background:#ffd966;
                border:2px solid #f39c12;
                color:#3b2b00;
            }
            .seat.occupied {
                background:#ffb3b3;
                border:1px solid #ff4d4d;
                color:#6b0000;
                cursor:not-allowed;
            }
            .seat-row {
                margin-bottom:8px;
            }
            #seatsContainer {
                max-width:720px;
                margin:0 auto;
            }
        </style>
    </head>
    <body class="p-4">
        <div class="container">
            <h3>Reserva - Selección de asientos</h3>

            <!-- Viaje resumen -->
            <div class="card mb-3">
                <div class="card-body">
                    <%
                        // viajeId se pasa originalmente como parámetro desde ReservaServlet?action=init
                        String viajeIdParam = request.getParameter("viajeId");
                        if (viajeIdParam == null) {
                            viajeIdParam = "";
                        }
                        Object viajeObj = request.getAttribute("viaje");
                    %>
                    <p><strong>Viaje ID:</strong> <%= viajeIdParam%></p>
                    <p>
                        <strong>Resumen:</strong>
                        <%= (viajeObj != null) ? viajeObj.toString() : "Información completa del viaje no disponible en la petición."%>
                    </p>
                </div>
            </div>

            <!-- Cantidad de boletos -->
            <div class="mb-3 row g-2 align-items-center">
                <div class="col-auto">
                    <label for="ticketQty" class="col-form-label">¿Cuántos boletos quieres?</label>
                </div>
                <div class="col-auto">
                    <input id="ticketQty" class="form-control" type="number" min="1" value="1" style="width:100px;">
                </div>
                <div class="col-auto">
                    <button id="loadSeatsBtn" class="btn btn-primary">Mostrar asientos</button>
                </div>
                <div class="col-auto">
                    <small id="availableInfo" class="text-muted"></small>
                </div>
            </div>

            <!-- Zona de asientos -->
            <div id="seatsContainer" class="mb-3">
                <div id="seatsMessage" class="mb-2 text-muted">Pulsa "Mostrar asientos" para cargar el plano.</div>
                <div id="seatsGrid" class="border p-3 bg-white" style="min-height:120px;"></div>
            </div>

            <!-- Resumen selección -->
            <div class="mb-3">
                <p>Asientos seleccionados: <span id="selectedCount">0</span> / <span id="requiredCount">1</span></p>
                <div id="selectedList" class="mb-2"></div>
                <div id="errorMsg" class="text-danger mb-2" style="display:none;"></div>
            </div>

            <!-- Botones -->
            <div>
                <button id="continueBtn" class="btn btn-success">Continuar</button>
                <a href="<%= request.getContextPath()%>/" class="btn btn-secondary">Cancelar</a>
            </div>

            <!-- Hidden form fallback (se envía por JS) -->
            <form id="postForm" method="post" action="<%= request.getContextPath()%>/ReservaServlet?action=reserveMultiple" style="display:none;">
                <input type="hidden" name="viajeId" value="<%= viajeIdParam%>">
                <input type="hidden" name="cantidad" id="postCantidad">
                <!-- asientoIds serán agregados por JS -->
                <div id="postAsientos"></div>
            </form>
        </div>

        <script>
            // Config
            const viajeId = "<%= viajeIdParam%>";
            let seats = []; // se poblará con [{id, numero, fila, columna, disponible}]
            let selected = new Set();
            let maxSelectable = 1;

            // Actualiza UI
            function renderSeats() {
                const grid = document.getElementById('seatsGrid');
                grid.innerHTML = '';
                if (!seats || seats.length === 0) {
                    document.getElementById('seatsMessage').innerText = 'No hay asientos disponibles o no se pudo cargar el plano.';
                    return;
                } else {
                    document.getElementById('seatsMessage').innerText = '';
                }

                // Agrupar por fila si existe la propiedad 'fila'
                const rows = {};
                seats.forEach(s => {
                    const rowKey = (s.fila !== null && typeof s.fila !== 'undefined') ? String(s.fila) : 'R';
                    if (!rows[rowKey])
                        rows[rowKey] = [];
                    rows[rowKey].push(s);
                });

                // Render filas ordenadas (si fila es numérica)
                const rowKeys = Object.keys(rows).sort((a, b) => {
                    const na = isNaN(a) ? a : Number(a);
                    const nb = isNaN(b) ? b : Number(b);
                    return (na > nb) ? 1 : ((na < nb) ? -1 : 0);
                });

                rowKeys.forEach(rk => {
                    const rowDiv = document.createElement('div');
                    rowDiv.className = 'seat-row';
                    rows[rk].forEach(s => {
                        const btn = document.createElement('div');
                        btn.className = 'seat ' + (s.disponible ? 'available' : 'unavailable');
                        if (!s.disponible)
                            btn.className = 'seat unavailable';
                        btn.dataset.id = String(s.id);
                        btn.dataset.numero = String(s.numero || s.id);
                        btn.innerText = s.numero || (s.fila ? (s.fila + '-' + s.columna) : s.id);

                        if (!s.disponible) {
                            btn.classList.add('occupied');
                        } else {
                            btn.addEventListener('click', onSeatClick);
                        }
                        rowDiv.appendChild(btn);
                    });
                    grid.appendChild(rowDiv);
                });

                updateSelectedUI();
                updateContinueState();
            }

            function onSeatClick(ev) {
                const id = ev.currentTarget.dataset.id;
                const isAvailable = !ev.currentTarget.classList.contains('unavailable') && !ev.currentTarget.classList.contains('occupied');
                if (!isAvailable)
                    return;

                if (selected.has(id)) {
                    selected.delete(id);
                    ev.currentTarget.classList.remove('selected');
                } else {
                    if (selected.size >= maxSelectable) {
                        alert('Ya seleccionaste la cantidad solicitada (' + maxSelectable + '). Deselecciona uno para elegir otro.');
                        return;
                    }
                    selected.add(id);
                    ev.currentTarget.classList.add('selected');
                }
                toggleAvailabilityWhenMax();
                updateSelectedUI();
                updateContinueState();
            }

            function toggleAvailabilityWhenMax() {
                const allSeats = document.querySelectorAll('#seatsGrid .seat.available');
                if (selected.size >= maxSelectable) {
                    allSeats.forEach(s => {
                        if (!selected.has(s.dataset.id))
                            s.classList.add('unavailable'); // visual
                    });
                } else {
                    allSeats.forEach(s => s.classList.remove('unavailable'));
                }
            }

            function updateSelectedUI() {
                document.getElementById('selectedCount').innerText = selected.size;
                document.getElementById('requiredCount').innerText = maxSelectable;
                const list = document.getElementById('selectedList');
                list.innerHTML = '';
                selected.forEach(id => {
                    const sp = document.createElement('span');
                    sp.className = 'badge bg-primary me-1';
                    sp.innerText = id;
                    list.appendChild(sp);
                });
            }

            function updateContinueState() {
                const btn = document.getElementById('continueBtn');
                const qty = parseInt(document.getElementById('ticketQty').value || '1', 10);
                const avail = seats.filter(s => s.disponible).length;
                // disable continue if requested > avail or selected size != qty
                if (qty > avail) {
                    btn.disabled = true;
                    document.getElementById('errorMsg').style.display = 'block';
                    document.getElementById('errorMsg').innerText = 'La cantidad solicitada (' + qty + ') excede los asientos disponibles (' + avail + ').';
                } else {
                    document.getElementById('errorMsg').style.display = 'none';
                    btn.disabled = (selected.size !== qty);
                }
            }

            // Cargar asientos via AJAX (espera JSON array: {id, numero, fila, columna, disponible})
            async function loadSeatsAjax() {
                try {
                    // Usamos VerAsientosServlet con format=json (tu servlet soporta format=json o action=list)
                    const url = '<%= request.getContextPath()%>/VerAsientosServlet?format=json&viajeId=' + encodeURIComponent(viajeId);
                    const resp = await fetch(url, {method: 'GET'});
                    if (!resp.ok)
                        throw new Error('Error cargando asientos: ' + resp.status);
                    const data = await resp.json();

                    // normalize: ensure fields and robust available detection
                    seats = (Array.isArray(data) ? data : []).map(s => {
                        const id = (s.id !== undefined) ? s.id : (s.idAsientoViaje !== undefined ? s.idAsientoViaje : s.asientoId);
                        const numero = (s.numero !== undefined) ? s.numero : (s.numeroAsiento !== undefined ? s.numeroAsiento : id);
                        const fila = (s.fila !== undefined) ? s.fila : (s.row !== undefined ? s.row : null);
                        const columna = (s.columna !== undefined) ? s.columna : (s.col !== undefined ? s.col : null);
                        // disponible: prefer boolean field, else interpret estado==0 or '0'
                        let disponible = true;
                        if (typeof s.disponible !== 'undefined') {
                            disponible = Boolean(s.disponible);
                        } else if (typeof s.estado !== 'undefined') {
                            disponible = (s.estado === 0 || s.estado === '0');
                        }
                        return {id: id, numero: numero, fila: fila, columna: columna, disponible: disponible};
                    });

                    const avail = seats.filter(s => s.disponible).length;
                    document.getElementById('availableInfo').innerText = avail + ' asientos disponibles';

                    const requested = parseInt(document.getElementById('ticketQty').value || '1', 10);
                    if (requested > avail) {
                        document.getElementById('errorMsg').style.display = 'block';
                        document.getElementById('errorMsg').innerText = 'La cantidad solicitada (' + requested + ') excede los asientos disponibles (' + avail + ').';
                        document.getElementById('continueBtn').disabled = true;
                    } else {
                        document.getElementById('errorMsg').style.display = 'none';
                    }

                    renderSeats();
                } catch (err) {
                    console.error(err);
                    document.getElementById('seatsMessage').innerText = 'No se pudo cargar el plano de asientos. Comprueba el endpoint VerAsientosServlet (format=json).';
                    document.getElementById('availableInfo').innerText = '';
                    document.getElementById('continueBtn').disabled = true;
                }
            }

            // Eventos
            document.getElementById('loadSeatsBtn').addEventListener('click', () => {
                const qty = parseInt(document.getElementById('ticketQty').value || '1', 10);
                if (qty < 1) {
                    alert('Cantidad mínima: 1');
                    return;
                }
                maxSelectable = qty;
                selected.clear();
                document.getElementById('postCantidad').value = qty;
                document.getElementById('requiredCount').innerText = qty;
                // Cargar asientos
                loadSeatsAjax();
            });

            document.getElementById('continueBtn').addEventListener('click', () => {
                const qty = parseInt(document.getElementById('ticketQty').value || '1', 10);
                if (selected.size !== qty) {
                    alert('Debes seleccionar exactamente ' + qty + ' asientos. Actualmente: ' + selected.size);
                    return;
                }

                // Build hidden form and submit to ReservaServlet?action=reserveMultiple
                const postAsientos = document.getElementById('postAsientos');
                postAsientos.innerHTML = '';
                Array.from(selected).forEach(id => {
                    const inp = document.createElement('input');
                    inp.type = 'hidden';
                    inp.name = 'asientoIds';
                    inp.value = id;
                    postAsientos.appendChild(inp);
                });
                document.getElementById('postForm').submit();
            });

            // Si quieres auto-cargar los asientos al abrir la página descomenta la línea siguiente:
            // window.addEventListener('load', () => document.getElementById('loadSeatsBtn').click());
        </script>
    </body>
</html>

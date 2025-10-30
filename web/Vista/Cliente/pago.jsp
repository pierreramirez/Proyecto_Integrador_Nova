<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/Vista/componentes/header.jsp" />

<link href="${pageContext.request.contextPath}/css/novas-landing.css" rel="stylesheet" />

<style>
    /* Estilos específicos para la pantalla de pago (no tocan tu CSS global) */
    .pay-wrap {
        max-width:980px;
        margin:32px auto;
        display:grid;
        grid-template-columns: 1fr 420px;
        gap:28px;
    }
    .card-box {
        background: linear-gradient(180deg,#ffffff,#f6f9ff);
        padding:20px;
        border-radius:12px;
        box-shadow:0 12px 30px rgba(16,24,64,0.06);
    }
    .card-preview {
        height:220px;
        border-radius:14px;
        padding:18px;
        color:#fff;
        position:relative;
        overflow:hidden;
    }
    .card-chip {
        width:48px;
        height:36px;
        background:rgba(255,255,255,0.35);
        border-radius:6px;
        margin-bottom:18px;
    }
    .card-number {
        font-size:20px;
        letter-spacing:3px;
        margin-top:12px;
    }
    .card-bottom {
        position:absolute;
        left:18px;
        bottom:18px;
        right:18px;
        display:flex;
        justify-content:space-between;
        align-items:center;
        font-size:13px;
        opacity:0.95;
    }
    .input-row {
        display:flex;
        gap:12px;
        margin-bottom:12px;
    }
    .form-control {
        width:100%;
        padding:10px 12px;
        border-radius:8px;
        border:1px solid #e6e9f0;
        font-size:14px;
    }
    .btn-pay {
        background:#1d3aa0;
        color:#fff;
        padding:12px 18px;
        border-radius:10px;
        border:none;
        cursor:pointer;
        font-weight:600;
    }
    .btn-pay:active {
        transform:translateY(1px);
    }
    .small-muted {
        font-size:13px;
        color:#7b7b7b;
        margin-top:8px;
    }
    @media (max-width:900px) {
        .pay-wrap{
            grid-template-columns:1fr;
        }
        .card-preview{
            height:180px;
        }
    }
</style>

<div class="container">
    <div class="pay-wrap">
        <!-- Formulario -->
        <div class="card-box">
            <h2 style="color:#243a8b; margin:0 0 6px;">Pago de reserva</h2>
            <p class="small-muted">Formulario de pago simulado — no procesa transacciones reales.</p>

            <form id="paymentForm" autocomplete="off" onsubmit="return false;">
                <input type="hidden" name="asientoId" value="${param.asientoId}" />
                <input type="hidden" name="viajeId" value="${param.viajeId}" />

                <label style="display:block; margin-top:12px; font-weight:600;">Nombre en la tarjeta</label>
                <input class="form-control" id="cardName" placeholder="Nombre completo" required />

                <label style="display:block; margin-top:12px; font-weight:600;">Número de tarjeta</label>
                <input class="form-control" id="cardNumber" maxlength="19" placeholder="XXXX XXXX XXXX XXXX" inputmode="numeric" required />

                <div class="input-row">
                    <div style="flex:1;">
                        <label style="display:block; font-weight:600;">Fecha (MM/AA)</label>
                        <input class="form-control" id="cardExpiry" maxlength="5" placeholder="MM/AA" required />
                    </div>
                    <div style="width:140px;">
                        <label style="display:block; font-weight:600;">CVV</label>
                        <input class="form-control" id="cardCvv" maxlength="4" placeholder="●●●" inputmode="numeric" required />
                    </div>
                </div>

                <div style="margin-top:10px; display:flex; gap:10px; align-items:center;">
                    <button id="payBtn" class="btn-pay">Pagar ahora</button>
                    <a class="btn btn-outline" href="${pageContext.request.contextPath}/ReservaConfirmada.jsp?asientoId=${param.asientoId}&viajeId=${param.viajeId}">← Volver</a>
                </div>

                <div class="small-muted">
                    <strong>Monto:</strong> S/ <span id="mockAmount">45.00</span> &nbsp; — &nbsp; Demo visual únicamente.
                </div>
            </form>

            <div id="msg" style="margin-top:14px; color:#177a00; display:none; font-weight:700;">Pago simulado: aprobado ✅</div>
        </div>

        <!-- Preview de tarjeta -->
        <div>
            <div class="card-preview" id="cardPreview" style="background:linear-gradient(135deg,#1d3aa0,#3b6be6);">
                <div class="card-chip"></div>
                <div style="font-size:12px; opacity:0.95;">NOVAS</div>
                <div class="card-number" id="previewNumber">XXXX XXXX XXXX XXXX</div>
                <div style="margin-top:10px;"> <small>Nombre</small><div style="font-weight:700;" id="previewName">Nombre A. Cliente</div></div>
                <div class="card-bottom">
                    <div><small>VÁLIDO HASTA</small><div id="previewExpiry">MM/AA</div></div>
                    <div style="text-align:right;"><small>CVV</small><div id="previewCvv">●●●</div></div>
                </div>
            </div>

            <div style="margin-top:12px; background:#fff; border-radius:10px; padding:12px; box-shadow:0 6px 18px rgba(20,30,60,0.04);">
                <h4 style="margin:0 0 6px 0;">Resumen</h4>
                <p style="margin:0; color:#555;">Reserva <strong>#<c:out value="${param.asientoId}" /></strong></p>
                <p style="margin:6px 0 0 0; color:#555;">Viaje ID: <strong><c:out value="${param.viajeId}" /></strong></p>
                <p style="margin:12px 0 0 0; font-weight:700;">Total a pagar: S/ <span id="mockAmount2">45.00</span></p>
            </div>
        </div>
    </div>
</div>

<script>
    // UI JS: formating y preview (demo visual)
    const cardNumber = document.getElementById('cardNumber');
    const cardName = document.getElementById('cardName');
    const cardExpiry = document.getElementById('cardExpiry');
    const cardCvv = document.getElementById('cardCvv');

    const previewNumber = document.getElementById('previewNumber');
    const previewName = document.getElementById('previewName');
    const previewExpiry = document.getElementById('previewExpiry');
    const previewCvv = document.getElementById('previewCvv');
    const payBtn = document.getElementById('payBtn');
    const msg = document.getElementById('msg');

    function formatNumber(value) {
        return value.replace(/\D/g, '').replace(/(.{4})/g, '$1 ').trim();
    }

    cardNumber.addEventListener('input', (e) => {
        e.target.value = formatNumber(e.target.value).substring(0, 19);
        previewNumber.textContent = e.target.value || 'XXXX XXXX XXXX XXXX';
    });

    cardName.addEventListener('input', (e) => {
        previewName.textContent = e.target.value || 'Nombre A. Cliente';
    });

    cardExpiry.addEventListener('input', (e) => {
        let v = e.target.value.replace(/\D/g, '').substring(0, 4);
        if (v.length > 2)
            v = v.substring(0, 2) + '/' + v.substring(2);
        e.target.value = v;
        previewExpiry.textContent = v || 'MM/AA';
    });

    cardCvv.addEventListener('input', (e) => {
        e.target.value = e.target.value.replace(/\D/g, '').substring(0, 4);
        previewCvv.textContent = e.target.value ? '●'.repeat(Math.min(e.target.value.length, 4)) : '●●●';
    });

    payBtn.addEventListener('click', function (ev) {
        ev.preventDefault();
        // Validación básica (solo visual)
        if (!cardName.value.trim() || cardNumber.value.replace(/\s/g, '').length < 13 || cardExpiry.value.length < 4 || cardCvv.value.length < 3) {
            alert('Por favor completa correctamente los datos de la tarjeta (validación demo).');
            return;
        }
        // Simular procesamiento
        payBtn.disabled = true;
        payBtn.textContent = 'Procesando...';
        setTimeout(() => {
            msg.style.display = 'block';
            payBtn.textContent = 'Pago realizado';
            payBtn.style.background = '#17a34a';
            // redirigir después de 2s a una página de confirmación o inicio
            setTimeout(() => {
                window.location.href = '${pageContext.request.contextPath}/'; // vuelve al inicio en demo
            }, 1800);
        }, 1200);
    });
</script>

<jsp:include page="/Vista/componentes/footer.jsp" />

%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- incluye solo header -->
<jsp:include page="../componentes/public/header.jsp" />

<!-- Usamos la clase page-content para respetar la altura del header (la variable se ajusta por JS al final) -->
<div class="page-content container">

    <!-- estilos específicos de la página de pago (mínimos) -->
    <style>
        .pay-wrap {
            max-width:980px;
            margin:40px auto 24px auto;
            display:grid;
            grid-template-columns:1fr 380px;
            gap:28px;
            align-items:start;
        }
        .card-box {
            background:linear-gradient(180deg,#ffffff,#f6f9ff);
            padding:20px;
            border-radius:12px;
            box-shadow:0 12px 30px rgba(16,24,64,0.06);
        }
        .form-control {
            width:100%;
            padding:10px 12px;
            border-radius:8px;
            border:1px solid #e6e9f0;
            font-size:14px;
            margin-top:6px;
        }
        .input-row {
            display:flex;
            gap:12px;
            margin-bottom:12px;
        }
        .btn-pay {
            background:linear-gradient(135deg,#1d3aa0,#3b6be6);
            color:#fff;
            padding:12px 18px;
            border-radius:10px;
            border:none;
            cursor:pointer;
            font-weight:600;
        }
        .btn-outline {
            background:transparent;
            border:1px solid #d1d5db;
            padding:10px 16px;
            border-radius:8px;
            color:#1d3aa0;
        }
        @media (max-width: 900px) {
            .pay-wrap {
                grid-template-columns: 1fr;
                margin: 24px;
            }
        }
    </style>
    <link href="../../css/novas-landing.css" rel="stylesheet" type="text/css"/>
    <!-- main content -->
    <div class="pay-wrap">
        <!-- FORM -->
        <div class="card-box">
            <h2 style="color:#243a8b; margin:0 0 6px;">Pago de reserva</h2>
            <p style="color:#6b7280; margin:0 0 14px;">Formulario de pago simulado ? no procesa transacciones reales.</p>

            <form id="paymentForm" autocomplete="off" onsubmit="return false;">
                <input type="hidden" id="hiddenAsientoId" name="asientoId" value="${param.asientoId}" />
                <input type="hidden" id="hiddenViajeId" name="viajeId" value="${param.viajeId}" />

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
                        <input class="form-control" id="cardCvv" maxlength="4" placeholder="???" inputmode="numeric" required />
                    </div>
                </div>

                <div style="margin-top:10px; display:flex; gap:10px; align-items:center;">
                    <button id="payBtn" class="btn-pay">Pagar ahora</button>
                    <a class="btn-outline" href="<c:out value='${pageContext.request.contextPath}'/>/">? Volver</a>
                </div>

                <div style="margin-top:12px; color:#6b7280;">
                    <strong>Monto:</strong> S/ <span id="mockAmount">45.00</span> &nbsp; ? &nbsp; Demo visual únicamente.
                </div>
            </form>

            <div id="msg" style="margin-top:14px; color:#177a00; display:none; font-weight:700;">Pago simulado: aprobado ?</div>
        </div>

        <!-- PREVIEW -->
        <div>
            <div style="background:linear-gradient(135deg,#1d3aa0,#3b6be6); border-radius:12px; padding:18px; color:#fff; margin-bottom:12px;">
                <div style="font-size:18px; letter-spacing:3px;">XXXX XXXX XXXX XXXX</div>
                <div style="margin-top:12px; font-weight:700;" id="previewName">Nombre A. Cliente</div>
                <div style="margin-top:8px;">MM/AA</div>
            </div>

            <div style="background:#fff; border-radius:10px; padding:12px; box-shadow:0 6px 18px rgba(20,30,60,0.04);">
                <h4 style="margin:0 0 6px 0;">Resumen</h4>
                <p style="margin:0;">Reserva <strong>#<c:out value="${param.asientoId}" /></strong></p>
                <p style="margin:6px 0 0 0;">Viaje ID: <strong><c:out value="${param.viajeId}" /></strong></p>
                <p style="margin:12px 0 0 0; font-weight:700;">Total a pagar: S/ <span id="mockAmount2">45.00</span></p>
            </div>
        </div>
    </div>
</div> <!-- .page-content -->

<!-- small script to format fields + simulate payment + adjust header spacing -->
<script>
    (function () {
        // Ajustador dinámico: toma la altura real del header (.navbar o header) y la guarda en la variable CSS
        function adjustHeaderHeight() {
            var header = document.querySelector('header') || document.querySelector('.navbar');
            var footer = document.querySelector('footer');
            var h = header ? header.offsetHeight : 80;
            var f = footer ? footer.offsetHeight : 0;
            document.documentElement.style.setProperty('--header-height', h + 'px');
            document.documentElement.style.setProperty('--footer-height', f + 'px');
        }
        window.addEventListener('load', adjustHeaderHeight);
        window.addEventListener('resize', adjustHeaderHeight);

        // seguridad: small formatting helpers
        function formatNumber(value) {
            return value.replace(/\D/g, '').replace(/(.{4})/g, '$1 ').trim();
        }

        var cardNumber = document.getElementById('cardNumber');
        var cardName = document.getElementById('cardName');
        var cardExpiry = document.getElementById('cardExpiry');
        var cardCvv = document.getElementById('cardCvv');
        var previewName = document.getElementById('previewName');
        var payBtn = document.getElementById('payBtn');
        var msg = document.getElementById('msg');

        cardNumber.addEventListener('input', (e) => {
            e.target.value = formatNumber(e.target.value).substring(0, 19);
        });
        cardName.addEventListener('input', (e) => {
            previewName.textContent = e.target.value || 'Nombre A. Cliente';
        });
        cardExpiry.addEventListener('input', (e) => {
            let v = e.target.value.replace(/\D/g, '').substring(0, 4);
            if (v.length > 2)
                v = v.substring(0, 2) + '/' + v.substring(2);
            e.target.value = v;
        });
        cardCvv.addEventListener('input', (e) => {
            e.target.value = e.target.value.replace(/\D/g, '').substring(0, 4);
        });

        payBtn.addEventListener('click', function (ev) {
            ev.preventDefault();
            if (!cardName.value.trim() || cardNumber.value.replace(/\s/g, '').length < 13 || cardExpiry.value.length < 4 || cardCvv.value.length < 3) {
                alert('Por favor completa correctamente los datos de la tarjeta (validación demo).');
                return;
            }
            payBtn.disabled = true;
            payBtn.textContent = 'Procesando...';
            setTimeout(function () {
                msg.style.display = 'block';
                payBtn.textContent = 'Pago realizado';
                payBtn.style.background = '#17a34a';
                setTimeout(function () {
                    // redirigir a reserva_pagada.jsp (si existe)
                    var ctx = '<c:out value="${pageContext.request.contextPath}" />' || '';
                    var asId = '<c:out value="${param.asientoId}" />';
                    var vId = '<c:out value="${param.viajeId}" />';
                    window.location.href = ctx + '/Vista/Cliente/reserva_pagada.jsp?asientoIds=' + encodeURIComponent(asId) + '&viajeId=' + encodeURIComponent(vId);
                }, 800);
            }, 900);
        });
    })();
</script>

<!-- incluye solo footer -->
<jsp:include page="../componentes/public/footer.jsp" />

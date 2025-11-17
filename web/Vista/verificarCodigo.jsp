<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title>Verificar código | NOVA'S TRAVELS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link rel="icon" href="../Imagenes/novas_logo.png">

        <style>
            body {
                background: url("../Imagenes/fondobus.jpg") no-repeat center center / cover;
                position: relative;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                overflow-x: hidden;
            }

            /* Capa blur */
            body::before {
                content: "";
                position: fixed;
                inset: 0;
                background: inherit;
                filter: blur(7px) brightness(0.65);
                z-index: -1;
            }

            /* === CONTENEDOR CENTRAL === */
            .verify-wrapper{
                min-height:100vh;
                display:flex;
                align-items:center;
                justify-content:center;
                padding:20px;
            }

            /* === TARJETA === */
            .verify-box{
                background: linear-gradient(176deg, #1a237e, #5b3b00);
                padding:40px 32px;
                border-radius:14px;
                color: white;
                box-shadow:0 6px 18px rgba(0,0,0,0.12);
                width:100%;
                max-width:520px;
                text-align:center;
            }

            /* === LOGO === */
            .verify-logo{
                width:100%;
                max-width:260px;
                margin:0 auto 15px auto;
                display:block;
            }

            /* === BOTÓN PERSONALIZADO === */
            .btn-primary-custom{
                background: linear-gradient(90deg, #1a237e, #1a237e);
                border:none;
                color:#fff;
                font-weight:600;
            }
        </style>
    </head>

    <body>

        <div class="verify-wrapper">
            <div class="verify-box">

                <!-- LOGO -->
                <img src="../Imagenes/novas_logo.png" class="verify-logo" alt="logo">

                <h3 class="mb-3">Verificar código</h3>
                <p class="mb-4">Hemos enviado un código de 6 dígitos a tu correo.<br> Tiene validez 5 minutos.</p>

                <!-- FORMULARIO -->
                <form method="post" action="../srvIniciarSesion?accion=confirmarCodigo" id="codigoForm" novalidate>

                    <div class="mb-3 text-start">
                        <label class="form-label">Código (6 dígitos)</label>
                        <input name="txtCodigo" type="text" maxlength="6" pattern="[0-9]{6}"
                               inputmode="numeric" autocomplete="one-time-code"
                               class="form-control" required autofocus>
                    </div>

                    <button class="btn btn-primary-custom w-100 mb-3" type="submit">Verificar</button>

                    <div class="d-flex justify-content-between small">
                        <a href="login.jsp">Volver al inicio</a>

                        <form method="post" action="../srvIniciarSesion?accion=reenviarCodigo" style="display:inline;">
                            <button type="submit" class="btn btn-link p-0 small">Reenviar código</button>
                        </form>
                    </div>

                </form>
            </div>
        </div>

        <script>
            (function () {
                const params = new URLSearchParams(window.location.search);
                const err = params.get('error');
                if (err === 'cod')
                    Swal.fire({icon: 'error', title: 'Código inválido', text: 'Código incorrecto o expirado.'});
                else if (err === 'mail')
                    Swal.fire({icon: 'error', title: 'Error envío', text: 'No se pudo enviar el correo. Intenta luego.'});

                const form = document.getElementById('codigoForm');
                form.addEventListener('submit', function (e) {
                    const input = form.querySelector('input[name="txtCodigo"]');
                    const valor = input.value.trim();
                    if (!/^\d{6}$/.test(valor)) {
                        e.preventDefault();
                        Swal.fire({
                            icon: 'warning',
                            title: 'Código inválido',
                            text: 'Ingresa un código de 6 dígitos (solo números).'
                        });
                        return false;
                    }
                    input.value = valor;
                    return true;
                });
            })();
        </script>

    </body>
</html>

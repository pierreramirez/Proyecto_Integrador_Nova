<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <link rel="icon" href="../Imagenes/novas_logo.png">
        <title>Verificar código | NOVA'S TRAVELS</title>
        <style>
            body {
                background-color: #E6EEF5;
            }
            .login-box {
                background-color: #FAF3E0;
                padding:36px;
                border-radius:15px;
                box-shadow:0 4px 12px rgba(0,0,0,0.12);
            }
            .login-logo {
                width:500px;
                height:auto;
            }
            .btn-primary-custom {
                background:#f5be0a;
                border:none;
                color:#fff;
                font-weight:600;
            }
            .btn-primary-custom:hover{
                background:#e6a800;
            }
        </style>
    </head>
    <body>
        <div class="d-flex justify-content-between row align-items-center mt-5" style="width:100%;">
            <div class="col d-flex justify-content-center align-items-center">
                <img src="../Imagenes/novas_logo.png" class="login-logo" alt="NOVA'S TRAVELS Logo">
            </div>
            <div class="container login-box col-4 p-5 rounded me-5 shadow">
                <h3 class="text-center mb-3">Verificar código</h3>
                <p>Hemos enviado un código de 6 dígitos a tu correo.</p>
                <form method="post" action="../srvIniciarSesion?accion=verificarRecuperacion" id="formCod" novalidate>
                    <label class="form-label">Código (6 dígitos)</label>
                    <input name="txtCodigoRecup" type="text" maxlength="6" pattern="[0-9]{6}" inputmode="numeric" class="form-control mb-3" required autofocus>
                    <button class="btn btn-primary-custom w-100" type="submit">Verificar</button>
                </form>
                <div class="mt-3 d-flex justify-content-between">
                    <a href="recuperar.jsp">Repetir correo</a>
                    <form method="post" action="../srvIniciarSesion?accion=solicitarRecuperacion" style="display:inline;">
                        <!-- reenviar: re-lanza la solicitud usando el email en session -->
                        <button type="submit" class="btn btn-link p-0">Reenviar código</button>
                    </form>
                </div>
            </div>
        </div>

        <script>
            (function () {
                const params = new URLSearchParams(window.location.search);
                const err = params.get('error');
                if (err === 'cod')
                    Swal.fire({icon: 'error', title: 'Código inválido', text: 'Código incorrecto o expirado.'});
                if (err === 'mail')
                    Swal.fire({icon: 'error', title: 'Error envío', text: 'No se pudo enviar el correo.'});
                if (err === 'blocked')
                    Swal.fire({icon: 'warning', title: 'Bloqueado', text: 'Demasiados intentos.'});

                const form = document.getElementById('formCod');
                form.addEventListener('submit', function (e) {
                    const val = form.querySelector('input[name="txtCodigoRecup"]').value.trim();
                    if (!/^\d{6}$/.test(val)) {
                        e.preventDefault();
                        e.stopPropagation();
                        Swal.fire({icon: 'warning', title: 'Código inválido', text: 'Ingresa 6 números.'});
                    }
                });
            })();
        </script>
    </body>
</html>


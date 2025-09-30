<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <link rel="icon" href="../Imagenes/novas_logo.png">
        <title>Nueva contraseña | NOVA'S TRAVELS</title>
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
                <h3 class="text-center mb-3">Nueva contraseña</h3>
                <p>Ingresa tu nueva contraseña.</p>
                <form method="post" action="../srvIniciarSesion?accion=cambiarPassword" id="formPass" novalidate>
                    <label class="form-label">Contraseña</label>
                    <input name="password1" type="password" minlength="6" class="form-control mb-2" required>
                    <label class="form-label">Confirmar contraseña</label>
                    <input name="password2" type="password" minlength="6" class="form-control mb-3" required>
                    <button class="btn btn-primary-custom w-100" type="submit">Cambiar contraseña</button>
                </form>
                <div class="mt-3">
                    <a href="login.jsp">Volver al inicio</a>
                </div>
            </div>
        </div>

        <script>
            (function () {
                const params = new URLSearchParams(window.location.search);
                const err = params.get('error');
                if (err === 'match')
                    Swal.fire({icon: 'error', title: 'No coinciden', text: 'Las contraseñas no coinciden.'});
                if (err === 'short')
                    Swal.fire({icon: 'warning', title: 'Corta', text: 'La contraseña debe tener al menos 6 caracteres.'});
                if (err === 'bd' || err === 'ex')
                    Swal.fire({icon: 'error', title: 'Error', text: 'Ocurrió un error. Intenta más tarde.'});

                const form = document.getElementById('formPass');
                form.addEventListener('submit', function (e) {
                    const p1 = form.querySelector('input[name="password1"]').value;
                    const p2 = form.querySelector('input[name="password2"]').value;
                    if (p1.length < 6) {
                        e.preventDefault();
                        e.stopPropagation();
                        Swal.fire({icon: 'warning', title: 'Corta', text: 'La contraseña debe tener al menos 6 caracteres.'});
                        return;
                    }
                    if (p1 !== p2) {
                        e.preventDefault();
                        e.stopPropagation();
                        Swal.fire({icon: 'error', title: 'No coinciden', text: 'Las contraseñas deben coincidir.'});
                    }
                });
            })();
        </script>
    </body>
</html>

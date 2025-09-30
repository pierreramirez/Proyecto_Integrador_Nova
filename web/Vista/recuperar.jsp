<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <link rel="icon" href="../Imagenes/novas_logo.png">
        <title>Recuperar contraseña | NOVA'S TRAVELS</title>
        <style>
            
            body {
                background-color: #E6EEF5;
            }
            .login-box {
                background-color: #FAF3E0;
                padding:40px;
                border-radius:15px;
                box-shadow:0 4px 12px rgba(0,0,0,0.2);
            }
            .login-logo {
                width:500px;
                height:auto;
            }
            .btn-login {
                background:#f5be0a;
                border:none;
                color:#fff;
                font-weight:600;
            }
            .btn-login:hover{
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
                <h3 class="text-center mb-4">Recuperar contraseña</h3>
                <p>Introduce el correo asociado a tu cuenta. Te enviaremos un código de 6 dígitos.</p>
                <form method="post" action="../srvIniciarSesion?accion=solicitarRecuperacion">
                    <label class="form-label">Correo</label>
                    <input name="txtCorreoRecup" type="email" class="form-control mb-3" required>
                    <button class="btn btn-login w-100" type="submit">Enviar código</button>
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
                if (err === 'noexist')
                    Swal.fire({icon: 'error', title: 'No existe', text: 'No encontramos una cuenta con ese correo.'});
                if (err === 'mail')
                    Swal.fire({icon: 'error', title: 'Error envío', text: 'No se pudo enviar el correo. Intenta más tarde.'});
                if (err === 'ex')
                    Swal.fire({icon: 'error', title: 'Error', text: 'Error inesperado. Revisa logs.'});
                if (err === 'exp')
                    Swal.fire({icon: 'warning', title: 'Código expirado', text: 'Solicita un nuevo código.'});
                if (err === 'blocked')
                    Swal.fire({icon: 'warning', title: 'Bloqueado', text: 'Demasiados intentos. Solicita un nuevo código.'});
            })();
        </script>
    </body>
</html>


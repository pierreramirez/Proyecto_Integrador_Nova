<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Evitar cache (seguridad)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <link rel="icon" href="../Imagenes/novas_logo.png">
        <title>Login | NOVA'S TRAVELS</title>

        <style>
            body {
                background-color: #E6EEF5;
            }
            .login-box {
                background-color: #FAF3E0;
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            }
            .login-logo {
                width: 500px;
                height: auto;
            }
            .btn-login {
                background-color: #f5be0a;
                border: none;
                color: #fff;
                font-weight: 600;
            }
            .btn-login:hover {
                background-color: #e6a800;
            }
            .form-label {
                font-weight: 500;
            }
            .small-link {
                font-size: 0.9rem;
            }
        </style>
    </head>
    <body>
        <div class="d-flex justify-content-between row align-items-center mt-5" style="width: 100%;">
            <!-- Logo a la izquierda -->
            <div class="col d-flex justify-content-center align-items-center">
                <img src="../Imagenes/novas_logo.png" class="login-logo" alt="NOVA'S TRAVELS Logo">
            </div>

            <!-- Formulario a la derecha -->
            <div class="container login-box col-4 p-5 rounded me-5 shadow">
                <h1 class="text-center mb-4">Login</h1>

                <form method="post" action="../srvIniciarSesion?accion=verificar" id="loginForm">
                    <div class="row mb-3">
                        <div>
                            <label for="username" class="form-label">Correo:</label>
                            <input type="email" id="username" name="txtCorreo" class="form-control" required>
                        </div>
                    </div>
                    <div class="row mb-4">
                        <div>
                            <label for="password" class="form-label">Password:</label>
                            <input type="password" id="password" name="txtPassword" class="form-control" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <button class="btn btn-login btn-lg w-100" type="submit">Inicia Sesión</button>
                    </div>

                    <!-- Si ya existe código2FA en session mostramos enlace para ir a verificar -->
                    <%
                        String codigo = (String) session.getAttribute("codigo2FA");
                        Long expira = (Long) session.getAttribute("codigoExpira");
                        if (codigo != null && expira != null) {
                            long remSeg = (expira - System.currentTimeMillis()) / 1000;
                            if (remSeg < 0)
                                remSeg = 0;
                    %>
                    <div class="row mb-3">
                        <div class="text-center">
                            <a href="verificarCodigo.jsp" class="btn btn-outline-primary w-100">
                                Ingresar código (pendiente) — tiempo restante: <%= remSeg%> s
                            </a>
                        </div>
                    </div>
                    <%
                        }
                    %>

                    <div class="row">
                        <div class="d-flex justify-content-between align-items-center">
                            <a href="registro.jsp" class="small-link">¿No tienes cuenta? Registrarse</a>
                            <a href="recuperar.jsp" class="small-link">Olvidé mi contraseña</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Leer parámetros de la URL y mostrar alertas con SweetAlert2
            (function () {
                const params = new URLSearchParams(window.location.search);
                const err = params.get('error');
                const registro = params.get('registro');
                const recup = params.get('recup');

                if (registro === 'ok') {
                    Swal.fire({icon: 'success', title: 'Registro exitoso', text: 'Cuenta creada correctamente. Ahora ingresa con tu correo y contraseña.', timer: 3500, showConfirmButton: false});
                    return;
                }
                if (recup === 'ok') {
                    Swal.fire({icon: 'success', title: 'Contraseña cambiada', text: 'Tu contraseña fue actualizada. Ingresa de nuevo.', timer: 3000, showConfirmButton: false});
                    return;
                }

                if (!err)
                    return;
                switch (err) {
                    case 'cred':
                        Swal.fire({icon: 'error', title: 'Credenciales inválidas', text: 'Correo o contraseña incorrectos, o la cuenta está inactiva.'});
                        break;
                    case 'mail':
                        Swal.fire({icon: 'error', title: 'Error enviando código', text: 'No se pudo enviar el correo con el código. Intenta más tarde.'});
                        break;
                    case 'ex':
                    case 'ex2':
                        Swal.fire({icon: 'error', title: 'Error', text: 'Ocurrió un error inesperado. Revisa el log del servidor.'});
                        break;
                    default:
                        Swal.fire({icon: 'info', title: 'Información', text: 'Revisa los datos e intenta nuevamente.'});
                }
            })();
        </script>
    </body>
</html>


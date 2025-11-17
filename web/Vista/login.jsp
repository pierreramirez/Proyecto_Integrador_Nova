<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Login | NOVA'S TRAVELS</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link rel="icon" href="../Imagenes/novas_logo.png">

        <style>
            /* === Fondo difuminado === */
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

            /* === Centrado del wrapper principal === */
            .container {
                display: flex !important;
                justify-content: center !important;
                align-items: center !important;
            }

            .login-wrapper {
                width: 90%;
                max-width: 980px;
                margin: 0 auto;
            }

            /* === Tarjeta completa login estilo 50/50 === */
            .login-card {
                background-color: #ffffff; /* blanco */
                backdrop-filter: blur(16px);
                border-radius: 18px;
                overflow: hidden;
                box-shadow: 0 8px 28px rgba(0,0,0,0.25);
                display: flex;
                flex-wrap: wrap;
            }

            /* ======= Sección IZQUIERDA ======= */
            .left-section {
                flex: 1;
                min-width: 320px;
                padding: 45px 40px 45px 55px;
            }

            /* Logo centrado */
            .login-logo {
                max-width: 180px;
                display: block;
                margin: 0 auto 10px auto;
            }

            /* Títulos */
            .left-section h3 {
                text-align: center;
                margin-bottom: 22px;
                font-weight: 600;
            }

            /* Inputs */
            .form-control {
                border-radius: 8px;
                padding: 10px 12px;
            }

            /* Botón login */
            .btn-login {
                background: linear-gradient(90deg, #1a237e, #1a237e);
                border: none;
                color: #fff;
                font-weight: 600;
                border-radius: 10px;
                transition: 0.25s ease;
            }

            /* ======= Sección DERECHA ======= */
            .right-section {
                flex: 1;
                min-width: 340px;
                background: linear-gradient(145deg, #1a237e, #452800);
                color: white;
                font-family: "Inter", sans-serif;
                padding: 80px 60px;
                /* 👇 ESTO AGREGA EL CENTRADO SIN ROMPER EL TAMAÑO */
                display: flex;
                flex-direction: column;
                justify-content: center;   /* centra vertical */
                align-items: center;        /* centra horizontal */
                text-align: center;         /* centra texto */
            }


            .right-section h2 {
                font-size: 52px;
                font-weight: 700;
                margin-bottom: 15px;
            }

            .right-section p {
                font-size: 17px;
                font-style: italic;
                opacity: 0.92;
            }


            /* ======= RESPONSIVE ======= */
            @media (max-width: 900px) {
                .login-card {
                    flex-direction: column;
                }

                .right-section {
                    padding: 60px 35px;
                    text-align: center;
                }

                .left-section {
                    padding: 40px 30px;
                }
            }

        </style>
    </head>
    <body>
        <div class="container">
            <div class="login-wrapper">
                <div class="login-card">

                    <!-- SECCIÓN IZQUIERDA -->
                    <div class="left-section">

                        <img src="../Imagenes/novas_logo.png" 
                             alt="NOVA'S TRAVELS" 
                             class="login-logo">

                        <h3>Iniciar sesión</h3>

                        <form method="post" action="../srvIniciarSesion?accion=verificar" id="loginForm" novalidate>

                            <div class="mb-3">
                                <label for="username" class="form-label">Correo</label>
                                <input type="email" id="username" name="txtCorreo" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Contraseña</label>
                                <input type="password" id="password" name="txtPassword" class="form-control" required>
                            </div>

                            <div class="d-grid mb-3">
                                <button class="btn btn-login btn-lg" type="submit">Inicia Sesión</button>
                            </div>

                            <div class="d-flex justify-content-between small">
                                <a href="registro.jsp">¿No tienes cuenta? Registrarse</a>
                                <a href="recuperar.jsp">Olvidé mi contraseña</a>
                            </div>
                        </form>
                    </div>

                    <!-- SECCIÓN DERECHA -->
                    <div class="right-section">
                        <h2>¡BIENVENIDO!</h2>
                        <p>
                            Gracias por utilizar nuestro sistema de transporte.<br>
                            Inicia sesión para continuar gestionando tus viajes.
                        </p>
                    </div>
                </div>
            </div>
        </div>
        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Reutilizo tu código de SweetAlert para mensajes -->
        <script>
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

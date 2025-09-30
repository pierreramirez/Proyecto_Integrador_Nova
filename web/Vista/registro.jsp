<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <link rel="icon" href="../Imagenes/novas_logo.png">
        <title>Registro | NOVA'S TRAVELS</title>

        <style>
            body {
                background-color: #E6EEF5;
            }
            .box {
                background-color: #FAF3E0;
                padding: 36px;
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.12);
            }
            .brand-logo {
                width: 500px;
                height: auto;
            }
            .btn-primary-custom {
                background-color: #f5be0a;
                border: none;
                color: #fff;
                font-weight: 600;
            }
            .btn-primary-custom:hover {
                background-color: #e6a800;
            }
            .form-label {
                font-weight: 500;
            }
            a.small-link {
                font-size: 0.9rem;
            }
        </style>
    </head>
    <body>
        <div class="d-flex justify-content-between row align-items-center mt-5" style="width:100%;">
            <div class="col d-flex justify-content-center align-items-center">
                <img src="../Imagenes/novas_logo.png" class="brand-logo" alt="NOVA'S TRAVELS Logo">
            </div>

            <div class="container box col-4 p-5 rounded me-5 shadow">
                <h2 class="text-center mb-4">Registro de usuario</h2>

                <!-- accept-charset añadido para forzar envío en UTF-8 -->
                <form method="post" action="../srvIniciarSesion?accion=registrar" id="registroForm" accept-charset="UTF-8" novalidate>
                    <div class="row mb-2">
                        <div class="col">
                            <label class="form-label">Apellido paterno</label>
                            <input name="appat" type="text" class="form-control" required>
                        </div>
                        <div class="col">
                            <label class="form-label">Apellido materno</label>
                            <input name="apmat" type="text" class="form-control">
                        </div>
                    </div>

                    <div class="row mb-2">
                        <div class="col">
                            <label class="form-label">Nombres</label>
                            <input name="nombre" type="text" class="form-control" required>
                        </div>
                        <div class="col">
                            <label class="form-label">DNI</label>
                            <input name="dni" type="number" class="form-control" required>
                        </div>
                    </div>

                    <div class="row mb-2">
                        <div class="col">
                            <label class="form-label">Correo</label>
                            <input name="email" type="email" class="form-control" required>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col">
                            <label class="form-label">Contraseña</label>
                            <input name="password" type="password" class="form-control" minlength="6" required>
                            <div class="form-text">Mínimo 6 caracteres.</div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <button class="btn btn-primary-custom btn-lg w-100" type="submit">Crear cuenta</button>
                    </div>

                    <div class="row">
                        <div class="d-flex justify-content-between">
                            <a href="login.jsp" class="small-link">¿Ya tienes cuenta? Iniciar sesión</a>
                            <a href="#" class="small-link">Política de privacidad</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Validación HTML5 simple + SweetAlert feedback por parámetros en URL
            (function () {
                const params = new URLSearchParams(window.location.search);
                const registro = params.get('registro');
                const err = params.get('error');

                if (registro === 'ok') {
                    Swal.fire({icon: 'success', title: 'Registro exitoso', text: 'Cuenta creada. Revisa tu correo si hace falta verificar.', timer: 3000, showConfirmButton: false});
                }
                if (err) {
                    let text = 'Ocurrió un error.';
                    if (err === 'bd')
                        text = 'Error en la base de datos. Intenta nuevamente.';
                    if (err === 'ex')
                        text = 'Error inesperado. Revisa logs del servidor.';
                    Swal.fire({icon: 'error', title: 'Error', text: text});
                }

                // Client side: evitar submit si invalid
                const form = document.getElementById('registroForm');
                form.addEventListener('submit', function (e) {
                    if (!form.checkValidity()) {
                        e.preventDefault();
                        e.stopPropagation();
                        Swal.fire({icon: 'warning', title: 'Completa el formulario', text: 'Revisa los campos obligatorios.'});
                    }
                }, false);
            })();
        </script>
    </body>
</html>

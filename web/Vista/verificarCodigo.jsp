<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <link rel="icon" href="../Imagenes/novas_logo.png">
        <title>Verificar código | NOVA'S TRAVELS</title>

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
        </style>
    </head>
    <body>
        <div class="d-flex justify-content-between row align-items-center mt-5" style="width:100%;">
            <div class="col d-flex justify-content-center align-items-center">
                <img src="../Imagenes/novas_logo.png" class="brand-logo" alt="NOVA'S TRAVELS Logo">
            </div>

            <div class="container box col-4 p-5 rounded me-5 shadow">
                <h3 class="text-center mb-3">Verificar código</h3>
                <p>Hemos enviado un código de 6 dígitos a tu correo. Tiene validez 5 minutos.</p>

                <form method="post" action="../srvIniciarSesion?accion=confirmarCodigo" id="codigoForm" novalidate>
                    <div class="mb-3">
                        <label class="form-label">Código (6 dígitos)</label>
                        <!-- input corregido: pattern seguro, inputmode para teclado numérico y autocomplete para OTP -->
                        <input name="txtCodigo"
                               type="text"
                               maxlength="6"
                               class="form-control"
                               pattern="[0-9]{6}"
                               inputmode="numeric"
                               autocomplete="one-time-code"
                               required
                               autofocus>
                    </div>
                    <div class="mb-3">
                        <button class="btn btn-primary-custom w-100" type="submit">Verificar</button>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="login.jsp" class="small-link">Volver al inicio</a>

                        <form method="post" action="../srvIniciarSesion?accion=reenviarCodigo" style="display:inline;">
                            <!-- Cambié la acción a reenviarCodigo; implementa ese case en el servlet para reenviar -->
                            <button type="submit" class="btn btn-link small-link p-0">Reenviar código</button>
                        </form>
                    </div>
                </form>
            </div>
        </div>

        <script>
            (function () {
                const params = new URLSearchParams(window.location.search);
                const err = params.get('error');

                if (err === 'cod') {
                    Swal.fire({icon: 'error', title: 'Código inválido', text: 'Código incorrecto o expirado.'});
                } else if (err === 'mail') {
                    Swal.fire({icon: 'error', title: 'Error envío', text: 'No se pudo enviar el correo. Intenta luego.'});
                }

                const form = document.getElementById('codigoForm');
                form.addEventListener('submit', function (e) {
                    const input = form.querySelector('input[name="txtCodigo"]');
                    const regex = /^\d{6}$/;
                    // trim por si el usuario pega espacios
                    const valor = input.value.trim();

                    if (!regex.test(valor)) {
                        e.preventDefault();
                        e.stopPropagation();
                        Swal.fire({icon: 'warning', title: 'Código inválido', text: 'Ingresa un código de 6 dígitos (solo números).'});
                        return false;
                    }
                    // si pasó validación, asignamos el valor (sin espacios) y dejamos enviar
                    input.value = valor;
                    return true;
                });
            })();
        </script>
    </body>
</html>

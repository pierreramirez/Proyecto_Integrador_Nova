<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Registro | NOVA'S TRAVELS</title>

        <!-- Bootstrap + Boxicons + jQuery + SweetAlert -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <link rel="icon" href="../Imagenes/novas_logo.png">

        <style>
            /* ===== Fondo general con blur ===== */
            /* ===== Fondo general ===== */
            body {
                margin: 0;
                padding: 0;
                background: url("../Imagenes/fondobus.jpg") no-repeat center center/cover;
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: "Inter", sans-serif;
            }

            /* Capa oscura */
            body::before {
                content: "";
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.35);
                backdrop-filter: blur(5px);
                z-index: -1;
            }

            /* ===== Contenedor general ===== */
            .login-container {
                width: 85%;
                max-width: 1150px;
                height: 97vh;
                display: flex;
                border-radius: 22px;
                overflow: hidden;
                box-shadow: 0 8px 25px rgba(0,0,0,0.35);
            }

            /* ===== PANELES (problema corregido) ===== */
            .left-panel,
            .right-panel {
                flex: 1 1 50%;     /* <-- 50% / 50% real */
                height: 100%;
            }

            /* ===== PANEL IZQUIERDO ===== */
            .left-panel {
                background: #ffffff;
                padding: 40px 55px;
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                position: relative;
            }

            /* LOGO */
            .brand-logo {
                width: 150px;
                display: block;
                margin: 0px auto 5px; /* ← baja el logo y lo centra */
                padding: 10px;

            }
            .brand-logo:hover {
                transform: scale(1.03);
            }

            /* Cuadro del form */
            .box {
                width: 100%;
                max-width: 450px;
            }

            /* Inputs */
            .form-control {
                border-radius: 10px;
                border: 1.8px solid #d1d1d1;
                padding: 10px 14px;
                font-size: 15px;
                transition: 0.2s;
            }
            .form-control:focus {
                border-color: #ff7a00;
                box-shadow: 0 0 8px rgba(255,122,0,0.4);
            }

            /* Títulos */
            h2 {
                font-weight: 700;
                color: #333;
            }

            /* Botón principal */
            .btn-primary-custom {
                background: linear-gradient(90deg, #1a237e, #1a237e);
                color: white;
                font-size: 17px;
                padding: 12px 0;
                border-radius: 12px;
                border: none;
                transition: 0.2s;
            }
            .btn-primary-custom:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 20px rgba(255,136,0,0.35);
            }

            button#submitBtn {
                cursor: pointer;
                opacity: 1;
            }
            button#submitBtn:disabled {
                opacity: 0.6;
                cursor: not-allowed;
            }

            /* Links */
            .small-link {
                color: #0066cc;
            }

            /* Checklist */
            .pw-check {
                font-size: 14px;
            }

            /* ===== PANEL DERECHO ===== */
            .right-panel {
                background: linear-gradient(145deg, #1a237e, #452800);
                color: white;
                padding: 60px;
                display: flex;
                flex-direction: column;
                justify-content: center;  /* Centra verticalmente */
                align-items: center;      /* Centra horizontalmente */
                text-align: center;       /* Centra el texto */
                position: relative;
            }
            /* Título */
            .right-panel h1 {
                font-size: 42px;
                font-weight: 800;
            }

            /* Texto */
            .right-panel p {
                font-size: 17px;
                font-style: italic;
                line-height: 1.5rem;
                max-width: 80%;
            }

            /* Imagen decorativa */
            .right-panel::after {
                content: "";
                position: absolute;
                width: 320px;
                height: 320px;
                bottom: 15px;
                right: 15px;
                background: url('../Imagenes/bus_vector.png') no-repeat center/contain;
                opacity: 0.22;
                pointer-events: none;
            }

            /* ===== Responsive ===== */
            @media (max-width: 992px) {
                .login-container {
                    flex-direction: column;
                    height: auto;
                    margin: 40px 0;
                }

                .right-panel {
                    align-items: center;
                    text-align: center;
                    padding: 35px;
                }

                .right-panel p {
                    max-width: 100%;
                }

                .right-panel::after {
                    display: none;
                }
            }



        </style>
    </head>
    <body>

        <!-- Contenedor GRANDE dividido -->
        <div class="login-container">
            <!-- PANEL IZQUIERDO -->
            <div class="left-panel">
                <!-- Logo -->
                <img src="../Imagenes/novas_logo.png" class="brand-logo" alt="NOVA'S TRAVELS Logo">
                <div class="box">
                    <h2 class="text-center mb-4">Registro de Usuario</h2>

                    <form method="post" action="../srvIniciarSesion?accion=registrar" id="registroForm" novalidate>

                        <!-- Apellidos -->
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

                        <!-- Nombre + DNI -->
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

                        <!-- Email -->
                        <div class="row mb-2">
                            <div class="col">
                                <label class="form-label">Correo</label>
                                <input name="email" type="email" class="form-control" autocomplete="email" required>
                            </div>
                        </div>

                        <!-- Contraseña -->
                        <div class="row mb-3">
                            <div class="col-12 mb-2">
                                <label class="form-label">Contraseña</label>
                                <div class="input-group">
                                    <input id="password" name="password" type="password" class="form-control" minlength="8" required>
                                    <button id="togglePwd" class="btn btn-outline-secondary" type="button">
                                        <i class='bx bx-hide'></i>
                                    </button>
                                </div>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Confirmar contraseña</label>
                                <div class="input-group">
                                    <input id="password2" name="password2" type="password" class="form-control" minlength="8" required>
                                    <button id="togglePwd2" class="btn btn-outline-secondary" type="button">
                                        <i class='bx bx-hide'></i>
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Checklist -->
                        <ul class="list-unstyled mb-3">
                            <li class="pw-check" id="chk-len"><i>✖</i> Mínimo 8 caracteres</li>
                            <li class="pw-check" id="chk-upper"><i>✖</i> Una letra mayúscula</li>
                            <li class="pw-check" id="chk-lower"><i>✖</i> Una letra minúscula</li>
                            <li class="pw-check" id="chk-num"><i>✖</i> Un número o símbolo</li>
                            <li class="pw-check" id="chk-match"><i>✖</i> Las contraseñas coinciden</li>
                        </ul>

                        <!-- Botón -->
                        <button id="submitBtn" class="btn btn-primary-custom w-100 mb-3" type="submit" disabled>
                            Crear cuenta
                        </button>

                        <!-- Links -->
                        <div class="d-flex justify-content-between">
                            <a href="login.jsp" class="small-link">¿Ya tienes cuenta?</a>
                            <a href="#" class="small-link">Política de privacidad</a>
                        </div>

                    </form>
                </div>

            </div>

            <!-- PANEL DERECHO -->
            <div class="right-panel">
                <h1>¡BIENVENIDO!</h1>
                <p>
                    Regístrate para comenzar a disfrutar de nuestra plataforma.
                </p>
            </div>

        </div>

    </body>

    <script>
        (function () {
            // elementos
            const pwd = document.getElementById('password');
            const pwd2 = document.getElementById('password2');
            const submitBtn = document.getElementById('submitBtn');

            const chkLen = document.getElementById('chk-len');
            const chkUpper = document.getElementById('chk-upper');
            const chkLower = document.getElementById('chk-lower');
            const chkNum = document.getElementById('chk-num');
            const chkMatch = document.getElementById('chk-match');

            const togglePwd = document.getElementById('togglePwd');
            const togglePwd2 = document.getElementById('togglePwd2');

            // toggle mostrar/ocultar (cambia tipo y el icono)
            function toggleInputVisibility(inputEl, btn) {
                const icon = btn.querySelector('i');
                if (inputEl.type === 'password') {
                    inputEl.type = 'text';
                    icon.className = 'bx bx-show'; // icono "mostrar"
                    btn.setAttribute('aria-label', 'Ocultar contraseña');
                } else {
                    inputEl.type = 'password';
                    icon.className = 'bx bx-hide'; // icono "ocultar"
                    btn.setAttribute('aria-label', 'Mostrar contraseña');
                }
            }
            togglePwd.addEventListener('click', () => toggleInputVisibility(pwd, togglePwd));
            togglePwd2.addEventListener('click', () => toggleInputVisibility(pwd2, togglePwd2));

            // validación en vivo
            function updateChecks() {
                const v = pwd.value;
                const v2 = pwd2.value;

                const reLen = /.{8,}/;
                const reUpper = /[A-ZÁÉÍÓÚÑ]/;
                const reLower = /[a-záéíóúñ]/;
                const reNumSym = /[0-9]|[^A-Za-z0-9]/;

                const okLen = reLen.test(v);
                const okUpper = reUpper.test(v);
                const okLower = reLower.test(v);
                const okNum = reNumSym.test(v);
                const okMatch = (v.length > 0) && (v === v2);

                setCheck(chkLen, okLen);
                setCheck(chkUpper, okUpper);
                setCheck(chkLower, okLower);
                setCheck(chkNum, okNum);
                setCheck(chkMatch, okMatch);

                // habilita submit sólo si todo OK
                submitBtn.disabled = !(okLen && okUpper && okLower && okNum && okMatch);
            }

            function setCheck(element, ok) {
                const icon = element.querySelector('i');
                if (ok) {
                    icon.textContent = '✓';
                    icon.classList.remove('text-danger');
                    icon.classList.add('text-success');
                } else {
                    icon.textContent = '✖';
                    icon.classList.remove('text-success');
                    icon.classList.add('text-danger');
                }
            }

            // listeners
            pwd.addEventListener('input', updateChecks);
            pwd2.addEventListener('input', updateChecks);

            // validación final antes de submit (por seguridad UX)
            const form = document.getElementById('registroForm');
            form.addEventListener('submit', function (e) {
                // si el botón está deshabilitado no debería llegar, pero por si acaso:
                if (submitBtn.disabled) {
                    e.preventDefault();
                    e.stopPropagation();
                    Swal.fire({icon: 'warning', title: 'Completa la contraseña', text: 'Asegúrate que la contraseña cumpla todos los requisitos.'});
                    return;
                }
                // opcional: puedes mostrar un spinner, deshabilitar el botón, etc.
                submitBtn.disabled = true;
            });

            // Mensajes según parámetros (opcional)
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
                if (err === 'email')
                    text = 'El correo ya está registrado.';
                Swal.fire({icon: 'error', title: 'Error', text: text});
            }

            // Inicializa checks (por si hay autofill)
            updateChecks();
        })();
    </script>
</body>
</html>

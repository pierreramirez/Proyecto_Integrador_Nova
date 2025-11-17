<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Recuperar contraseña | NOVA'S TRAVELS</title>

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

        /* Capa blur oscura */
        body::before {
            content: "";
            position: fixed;
            inset: 0;
            background: inherit;
            filter: blur(7px) brightness(0.65);
            z-index: -1;
        }

        /* CONTENEDOR CENTRAL */
        .recover-wrapper{
            min-height:100vh;
            display:flex;
            align-items:center;
            justify-content:center;
            padding:20px;
        }

        /* TARJETA */
        .recover-box{
            background: linear-gradient(176deg, #1a237e, #5b3b00);
            padding:40px 32px;
            border-radius:14px;
            box-shadow:0 6px 18px rgba(0,0,0,0.25);
            width:100%;
            max-width:520px;
            text-align:center;
            color:white;
        }

        /* LOGO */
        .recover-logo{
            width:100%;
            max-width:260px;
            margin:0 auto 15px auto;
            display:block;
        }

        /* BOTÓN */
        .btn-primary-custom{
            background: linear-gradient(90deg, #1a237e, #1a237e);
            border:none;
            color:#fff;
            font-weight:600;
        }

        .btn-primary-custom:hover{
            opacity: 0.9;
        }
    </style>
</head>

<body>

    <div class="recover-wrapper">
        <div class="recover-box">

            <!-- LOGO -->
            <img src="../Imagenes/novas_logo.png" class="recover-logo" alt="logo">

            <h3 class="mb-3">Recuperar Contraseña</h3>
            <p class="mb-4">Introduce el correo asociado a tu cuenta. Te enviaremos un código de 6 dígitos.</p>

            <!-- FORMULARIO -->
            <form method="post" action="../srvIniciarSesion?accion=solicitarRecuperacion" id="formRecup" novalidate>

                <div class="mb-3 text-start">
                    <label class="form-label">Correo</label>
                    <input name="txtCorreoRecup" type="email" class="form-control" autocomplete="email" required>
                </div>

                <button class="btn btn-primary-custom w-100 mb-3" type="submit">Enviar código</button>

                <a href="login.jsp" class="small text-white">Volver al inicio</a>

            </form>

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
                Swal.fire({icon: 'error', title: 'Error', text: 'Error inesperado.'});
            if (err === 'exp')
                Swal.fire({icon: 'warning', title: 'Código expirado', text: 'Solicita un nuevo código.'});
            if (err === 'blocked')
                Swal.fire({icon: 'warning', title: 'Bloqueado', text: 'Demasiados intentos.'});
        })();
    </script>

</body>
</html>

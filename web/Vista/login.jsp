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
    <title>Login | NOVA'S TRAVELS</title>

    <style>
        body {
            background-color: #E6EEF5; /* Fondo azul claro */
        }

        .login-box {
            background-color: #FAF3E0; /* Fondo crema suave */
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .login-logo {
            width: 500px; /* Tamaño del logo */
            height: auto;
        }

        .btn-login {
            background-color: #f5be0a; /* Naranja del logo */
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
            <form method="post" action="../srvIniciarSesion?accion=verificar">
                <div class="row mb-3">
                    <div>
                        <label for="username" class="form-label">Correo:</label>
                        <input type="text" id="username" name="txtCorreo" class="form-control" required>
                    </div>
                </div>
                <div class="row mb-5">
                    <div>
                        <label for="password" class="form-label">Password:</label>
                        <input type="password" id="password" name="txtPassword" class="form-control" required>
                    </div>
                </div>
                <div class="row mb-3">
                    <button class="btn btn-login btn-lg w-100" type="submit">Inicia Sesión</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>


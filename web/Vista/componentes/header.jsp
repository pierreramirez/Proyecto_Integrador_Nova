<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%@ page import="Modelo.DTOUsuario" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title>NOVA'S TRAVELS</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <!-- DataTables CSS -->
        <link href="https://cdn.datatables.net/2.0.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/buttons/3.0.2/css/buttons.bootstrap5.min.css" rel="stylesheet">

        <!-- Boxicons -->
        <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">

        <!-- Favicon -->
        <link rel="icon" href="${pageContext.request.contextPath}/Imagenes/novas_logo.png">

        <!-- jQuery (necesario para algunas librerías como DataTables) -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <style>
            /* Fondo general */
            body {
                background-color: #E6EEF5;
                font-family: 'Poppins', sans-serif;
            }

            .container-fluid {
                padding-left: 0 !important;
                padding-right: 0 !important;
            }

            .user-name {
                color: black; /* o el color que quieras */
            }

            .user-name strong {
                color: #F5A623; /* el naranja acento, opcional */
            }
            /* Sidebar (estilo común) */
            /* --- SIDEBAR FLOTANTE --- */
            .sidebar {
                position: fixed;              /* Que quede flotante */
                top: 90px;                    /* Separación del header */
                left: 25px;                   /* Separación del borde izquierdo */
                width: 260px;
                background-color: #ffffff;
                border-radius: 16px;
                padding: 25px 18px;
                min-height: calc(90vh - 120px);
                box-shadow: 0 4px 14px rgba(0,0,0,0.12);
                z-index: 2000;
            }

            /* Avatar centrado */
            .sidebar .text-center img {
                margin-top: 10px;
            }

            /* Links del sidebar */
            .sidebar .nav-link {
                color: #0D1B4C;
                font-weight: 600;
                border-radius: 10px;
                padding: 10px 14px;
                margin-bottom: 8px;
                transition: background 0.2s ease, transform 0.15s ease;
            }

            .sidebar .nav-link:hover {
                background: #F5A623;
                color: white;
                transform: translateX(5px);
            }

            /* Botón cerrar sesión */
            .logout-area {
                margin-top: 25px;
                padding-top: 15px;
                border-top: 1px solid #ddd;
            }

            /* Banner superior */
            .banner-top {
                background-color: #1a237e;
                position: relative;
                color: #ffffff;
                padding: 10px 0;
                border-bottom: 1px solid rgba(0,0,0,0.05);
            }
            .banner-top h1 {
                position: absolute;
                left: 50%;
                top: 50%;
                transform: translate(-50%, -50%);
                margin: 0;
                white-space: nowrap;
                font-weight: bold;
                margin:0;
                font-size:1.25rem;
            }
            .banner-top .container-fluid {
                max-width: 1800px;   /* evita que todo se vaya a las esquinas */
                margin: 0 auto;      /* centra el contenido del header */
                padding-left: 20px;
                padding-right: 20px;
            }
            /* Footer sin línea arriba */
            .site-footer {
                background-color: #1a237e;
                color: #fff;
                padding: 15px 0;
                margin-top: 0;
                border-top: none !important;
            }

            /* Elimina márgenes del párrafo */
            .site-footer p {
                margin: 0;
            }

            /* Elimina márgenes del contenedor anterior si genera espacio */
            .container-fluid,
            .row,
            main {
                margin-bottom: 0 !important;
                padding-bottom: 0 !important;
            }



            .card,
            .sidebar,
            button,
            input,
            table {
                border-radius: 12px !important;
            }
            .card, .sidebar, .banner-top {
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            }

            /* Ajustes avatar */
            .avatar-small {
                max-width: 100px;
                width:100px;
                height:auto;
            }
            .btn-primary {
                background-color: #0D1B4C;
                border-radius: 10px;
                border: none;
                padding: 8px 16px;
            }

            .btn-primary:hover {
                background-color: #112566;
                transform: translateY(-2px);
            }

            /* Main content spacing handled by grid (no margin-left fijo) */
            .main-content {
                margin-left: 315px; /* ancho del sidebar + separación */
                padding: 25px;
            }


            /* Navbar small: botón visible solo en pantallas pequeñas */
            .btn-offcanvas {
                font-size: 1.2rem;
            }

            /* Media queries para pequeños ajustes */
            @media (max-width: 768px) {
                .banner-top h1 {
                    font-size: 1rem;
                }
            }
        </style>
    </head>
    <body>
        <c:set var="usuario" value="${sessionScope.user}" />
        <c:if test="${usuario == null}">
            <c:redirect url="${pageContext.request.contextPath}/Vista/login.jsp" />
        </c:if>

        <!-- Banner superior: logo + toggle para móvil -->
        <nav class="banner-top d-flex align-items-center">
            <div class="container-fluid d-flex align-items-center">
                <!-- Botón para abrir el sidebar en móvil -->
                <button class="btn btn-outline-secondary d-md-none btn-offcanvas me-2"
                        type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasSidebar"
                        aria-controls="offcanvasSidebar" aria-label="Abrir menú">
                    <i class='bx bx-menu'></i>
                </button>

                <img src="${pageContext.request.contextPath}/Imagenes/novas_logo.png"
                     class="img-fluid me-3" style="height:56px;" alt="logo">

                <h1 class="mb-0"><i class='bx bxs-plane-alt me-2'></i> NOVA'S TRAVELS</h1>

                <!-- saludo pequeño a la derecha en pantallas md+ -->
                <div class="d-none d-md-flex align-items-center ms-auto small">
                    Hola, <strong class="ms-2"><c:out value="${sessionScope.user.nombre}"/></strong>
                </div>
            </div>
        </nav>

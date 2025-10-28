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
            }

            /* Sidebar (estilo común) */
            .sidebar {
                background-color: #FAF3E0;
                min-height: 100vh;
                padding-top: 1rem;
            }
            .sidebar .nav-link {
                color: #333333;
                font-weight: 500;
            }
            .sidebar .nav-link:hover {
                background-color: #f5be0a;
                color: #fff;
            }

            /* Banner superior */
            .banner-top {
                background-color: #fce8b1;
                color: #333333;
                padding: 10px 0;
                border-bottom: 1px solid rgba(0,0,0,0.05);
            }
            .banner-top h1 {
                font-weight: bold;
                margin:0;
                font-size:1.25rem;
            }

            /* Ajustes avatar */
            .avatar-small {
                max-width: 100px;
                width:100px;
                height:auto;
            }

            /* Main content spacing handled by grid (no margin-left fijo) */
            .main-content {
                padding: 20px;
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

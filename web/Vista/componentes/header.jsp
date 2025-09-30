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

    <%-- Bootstrap CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <%-- DataTables CSS --%>
    <link href="https://cdn.datatables.net/2.0.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/buttons/3.0.2/css/buttons.bootstrap5.min.css" rel="stylesheet">

    <%-- Boxicons -- corregido --%>
    <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet">

    <%-- SweetAlert (script lo dejamos para footer si prefieres) --%>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <%-- JQuery (necesario para DataTables) --%>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <%-- Favicon --%>
    <link rel="icon" href="${pageContext.request.contextPath}/Imagenes/novas_logo.png">

    <style>
        /* Fondo general */
        body {
            background-color: #E6EEF5;
        }

        /* Sidebar */
        .sidebar {
            background-color: #FAF3E0;
            min-height: 100vh;
            position: fixed;
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
        .banner-top h1 { font-weight: bold; margin:0; }

        /* Texto del usuario en sidebar */
        .sidebar h4 { color: #333333; font-size: 1rem; }

        /* Contenido principal (ajustado con el sidebar fijo) */
        .main-content {
            margin-left: 16.6667%; /* espacio para la sidebar (col-2) */
            width: 83.3333%;       /* resto del ancho */
            padding: 20px;
        }

        /* Pequeños ajustes responsive */
        @media (max-width: 768px) {
            .sidebar { position: relative; min-height: auto; }
            .main-content { margin-left: 0; width: 100%; }
        }
    </style>
</head>
<body>
<%-- Comprobación de sesión: si no hay usuario, redirige al login --%>
<c:set var="usuario" value="${sessionScope.user}" />
<c:if test="${usuario == null}">
    <c:redirect url="${pageContext.request.contextPath}/Vista/login.jsp" />
</c:if>

<%-- Banner superior (logo + título) --%>
<div class="banner-top d-flex align-items-center justify-content-center">
    <img src="${pageContext.request.contextPath}/Imagenes/novas_logo.png" class="img-fluid me-3" style="height:64px;">
    <h1><i class='bx bxs-plane-alt me-2'></i> NOVA'S TRAVELS</h1>
</div>

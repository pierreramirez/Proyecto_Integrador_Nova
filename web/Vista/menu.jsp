<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.*"%>
<%@page import="DAO.*"%>
<%@page import="java.util.LinkedList"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>NOVA'S TRAVELS</title>

        <%--Bootstrap--%>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <%--DataTables CSS--%>
        <link href="https://cdn.datatables.net/2.0.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">
        <link href="https://cdn.datatables.net/buttons/3.0.2/css/buttons.bootstrap5.min.css" rel="stylesheet">

        <%--Boxicons--%>
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>

        <%--SweetAlert--%>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

        <%--JQuery--%>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <%--DataTables JS--%>
        <script src="https://cdn.datatables.net/2.0.7/js/dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/2.0.7/js/dataTables.bootstrap5.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/3.0.2/js/dataTables.buttons.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.bootstrap5.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.html5.min.js"></script>
        <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.print.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

        <%--Favicon--%>
        <link rel="icon" href="../Imagenes/novas_logo.png">

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
            }
            .banner-top h1 {
                font-weight: bold;
            }

            /* Texto del usuario */
            .sidebar h4 {
                color: #333333;
            }
            /* Contenido principal */
            .main-content {
                margin-left: 16.6667%; /* espacio para la sidebar */
                width: 83.3333%;       /* resto del ancho */
                padding: 20px;
            }
        </style>
    </head>
    <body>
        <%-- Sesión --%>
        <c:set var="usuario" value="${sessionScope.user}"/>
        <c:if test="${usuario == null}">
            <c:redirect url="../Vista/login.jsp"/>
        </c:if>

        <input type="hidden" name="idUsuario" id="idUsuario" value="${usuario.getIdUsuario()}">

        <div class="d-flex">
            <%-- Sidebar --%>
            <div class="sidebar p-3 col-2 d-flex flex-column justify-content-between shadow">
                <div>
                    <div class="d-flex justify-content-center align-items-center my-4">
                        <img src="https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg" class="rounded-circle" width="100" height="100">
                    </div>
                    <div>
                        <h4 class="text-center"><c:out value="${usuario.getAppat()} ${usuario.getApmat()}, ${usuario.getNombre()}"/></h4>
                    </div>
                </div>

                <hr>

                <ul class="nav flex-column">
                    <li class="nav-item mb-3">
                        <a class="nav-link" href="../BusServlet?action=listar"><i class='bx bxs-bus me-2'></i> Registrar Bus</a>
                    </li>
                    <li class="nav-item mb-3">
                        <a class="nav-link" href="../ChoferServlet?action=listar"><i class='bx bxs-user-account me-2'></i> Registrar Choferes</a>
                    </li>
                    <li class="nav-item mb-3">
                        <a class="nav-link" href="../RutaServlet?action=listar"><i class='bx bxs-map me-2'></i> Programar Ruta</a>
                    </li>
                    <li class="nav-item mb-3">
                        <a class="nav-link" href="../ClienteServlet?action=listar"><i class='bx bx-user me-2'></i> Registrar Cliente</a>
                    </li>
                    <li class="nav-item mb-3">
                        <a class="nav-link" href="AdministrarPasajes.jsp"><i class='bx bxs-coupon me-2'></i> Pasajes</a>
                    </li>
                </ul>

                <hr>

                <div class="text-center">
                    <a href="../srvIniciarSesion?accion=cerrar" class="text-dark text-decoration-none"><i class='bx bx-log-out me-2'></i> Cerrar Sesión</a>
                </div>
            </div>

            <%-- Espaciador para el contenido principal --%>
            <div class="col-2"></div>

            <%-- Contenido principal --%>
            <div class="col-10">
                <%-- Banner superior --%>
                <div class="banner-top d-flex align-items-center justify-content-center">
                    <img src="../Imagenes/novas_logo.png" class="img-fluid me-3" width="100px">
                    <h1><i class='bx bxs-plane-alt me-2'></i> NOVA'S TRAVELS</h1>
                </div>

                <%-- Aquí puedes agregar el contenido principal de tu página --%>
                <div class="p-3">
                    <!-- Contenido dinámico -->
                </div>
            </div>
        </div>

        <%-- Scripts al final --%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

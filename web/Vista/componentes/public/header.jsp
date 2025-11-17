<%@page contentType="text/html" pageEncoding="UTF-8"%>

<header>
    <nav class="navbar">
        <div class="container" style="display:flex; align-items:center; justify-content:space-between;">

            <!-- Logo + nombre -->
            <div class="nav-brand" style="display:flex; align-items:center; gap:10px;">
                <img src="${pageContext.request.contextPath}/Imagenes/novas_logo.png" 
                     alt="NOVAS Logo" class="logo">
                <span class="company-name">NOVAS</span>
            </div>

            <!-- Menú -->
            <ul class="nav-menu" style="display:flex; list-style:none; gap:1rem; align-items:center;">
                <li><a href="${pageContext.request.contextPath}/index.jsp#inicio">Inicio</a></li>
                <li><a href="${pageContext.request.contextPath}/index.jsp#destinos">Destinos</a></li>
                <li><a href="${pageContext.request.contextPath}/index.jsp#promociones">Promociones</a></li>
                <li><a href="${pageContext.request.contextPath}/index.jsp#contacto">Contacto</a></li>
            </ul>

            <!-- Botón Acceder -->
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/Vista/login.jsp"
                   class="btn btn-primary btn-access">
                    <i class="fas fa-user-circle"></i>
                    <span style="margin-left:8px;">Acceder</span>
                </a>
            </div>

        </div>
    </nav>
</header>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Modelo.DTOUsuario" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>NOVAS - Viajes Seguros y Cómodos</title>

        <!-- Hoja principal -->
        <link href="${ctx}/css/novas-landing.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <style>
            /* ---------- Header / dropdown ---------- */
            .nav-actions {
                display:flex;
                align-items:center;
                gap:0.5rem;
                margin-left:1rem;
            }
            @media (max-width:768px){
                .nav-actions {
                    margin-left:0;
                }
            }

            .user-dropdown {
                position: relative;
                display:inline-block;
            }
            .user-btn {
                display:flex;
                align-items:center;
                gap:8px;
                padding:8px 12px;
                border-radius:8px;
                background:transparent;
                border:0;
                color:inherit;
                cursor:pointer;
                font:inherit;
            }
            .user-avatar {
                width:32px;
                height:32px;
                border-radius:50%;
                background:#fff;
                display:inline-flex;
                align-items:center;
                justify-content:center;
                color:#1d3aa0;
                font-weight:700;
                box-shadow: 0 2px 6px rgba(0,0,0,0.08);
            }
            .user-menu {
                display:none;
                position:absolute;
                right:0;
                top:calc(100% + 6px);
                background:#fff;
                color:#222;
                min-width:180px;
                box-shadow:0 6px 18px rgba(0,0,0,0.12);
                border-radius:8px;
                padding:6px 0;
                z-index:999;
            }
            .user-menu a {
                display:block;
                padding:10px 14px;
                color:#222;
                text-decoration:none;
                font-size:0.95rem;
            }
            .user-menu a:hover {
                background:#f4f6fb;
            }

            /* ====== Carrusel - estilos (mejorados) ====== */
            .carousel {
                position: relative;
                width: 100%;
                max-width: 1100px;
                margin: 0 auto;
                overflow: hidden;
                border-radius: 12px;
                background: #fff;
                padding: 18px;
                box-shadow: 0 6px 20px rgba(16,24,64,0.04);
            }

            .carousel-track {
                display: flex;
                transition: transform 600ms ease;
                will-change: transform;
                align-items: stretch;
            }

            /* Cada slide ocupa 100% del carrusel */
            .destination-card {
                min-width: 100%;
                box-sizing: border-box;
                padding: 12px;
                display: grid;
                grid-template-columns: 360px 1fr;
                gap: 20px;
                align-items: center;
                justify-items: start;
            }

            /* imagen: control de ratio/alto fijo para consistencia */
            .destination-image {
                width: 100%;
                max-width: 360px;
                aspect-ratio: 3 / 4;
                max-height: 520px;
                height: 100%;
                position: relative;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 8px 20px rgba(16,24,64,0.06);
                background: #f2f4f8;
                display:flex;
            }
            @supports not (aspect-ratio: 1 / 1) {
                .destination-image {
                    height: 420px;
                }
            }

            .destination-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                display: block;
            }

            .destination-overlay {
                position: absolute;
                right: 12px;
                bottom: 12px;
            }
            .destination-price {
                background: rgba(0,0,0,0.65);
                color: #fff;
                padding: 8px 12px;
                border-radius: 6px;
                font-weight: 600;
                text-decoration: none;
                font-size: 0.95rem;
            }

            .destination-content {
                display:flex;
                flex-direction:column;
                justify-content:center;
                gap: 8px;
                padding-right:8px;
            }
            .destination-name {
                margin:0;
                font-size:1.6rem;
                line-height:1.05;
                font-weight:700;
                color:#222;
            }
            .destination-desc {
                margin:0;
                color:#666;
                font-size:1rem;
            }
            .destination-features {
                display:flex;
                gap:18px;
                color:#444;
                font-size:0.95rem;
                align-items:center;
            }

            /* Controls (flechas) */
            .carousel-control {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                background: rgba(0,0,0,0.45);
                border: none;
                color: #fff;
                width:44px;
                height:44px;
                border-radius:50%;
                display:flex;
                align-items:center;
                justify-content:center;
                cursor:pointer;
                z-index: 40;
                box-shadow: 0 4px 10px rgba(0,0,0,0.12);
            }
            .carousel-control.left {
                left: 12px;
            }
            .carousel-control.right {
                right: 12px;
            }

            /* Indicators */
            .carousel-indicators {
                position: absolute;
                left: 50%;
                transform: translateX(-50%);
                bottom: 10px;
                display:flex;
                gap:8px;
                z-index: 40;
            }
            .indicator {
                width:10px;
                height:10px;
                border-radius:50%;
                background: rgba(0,0,0,0.18);
                cursor:pointer;
            }
            .indicator.active {
                background: rgba(0,0,0,0.6);
            }

            /* responsive adjustments */
            @media (max-width: 900px) {
                .destination-card {
                    grid-template-columns: 260px 1fr;
                    gap: 14px;
                }
                .destination-image {
                    max-width: 260px;
                }
            }
            @media (max-width: 600px) {
                .destination-card {
                    padding: 12px;
                    grid-template-columns: 1fr;
                    gap:12px;
                }
                .destination-image {
                    width:100%;
                    max-width:none;
                    aspect-ratio: 16/9;
                    height:220px;
                }
                .carousel {
                    padding: 10px;
                }
                .carousel-control {
                    width:38px;
                    height:38px;
                }
            }

            /* container helper */
            .container {
                max-width:1100px;
                margin:0 auto;
                padding:0 16px;
            }
            .section-header {
                margin-bottom:10px;
            }
            .section-title {
                margin:6px 0 0 0;
                font-size:1.25rem;
            }
            .section-subtitle {
                margin:4px 0 12px 0;
                color:#666;
                font-size:0.95rem;
            }
        </style>
    </head>

    <body>
        <!-- HEADER-->
        <header>
            <nav class="navbar">
                <div class="container" style="display:flex; align-items:center; justify-content:space-between;">
                    <div class="nav-brand" style="display:flex; align-items:center; gap:10px;">
                        <img src="${ctx}/Imagenes/novas_logo.png" alt="NOVAS Logo" class="logo" style="height:36px;">
                        <span class="company-name">NOVAS</span>
                    </div>

                    <!-- menú principal -->
                    <ul class="nav-menu" style="display:flex; list-style:none; gap:1rem; align-items:center;">
                        <li><a href="#inicio">Inicio</a></li>
                        <li><a href="#destinos">Destinos</a></li>
                        <li><a href="#promociones">Promociones</a></li>
                        <li><a href="#contacto">Contacto</a></li>
                    </ul>

                    <!-- AREA ACCESO / USUARIO -->
                    <div class="nav-actions" aria-live="polite">
                        <c:if test="${empty sessionScope.user}">
                            <a href="${ctx}/Vista/login.jsp" class="btn btn-primary btn-access" role="button" aria-label="Acceder a iniciar sesión">
                                <i class="fas fa-user-circle" aria-hidden="true"></i>
                                <span style="margin-left:8px;">Acceder</span>
                            </a>
                        </c:if>

                        <c:if test="${not empty sessionScope.user}">
                            <div class="user-dropdown" id="userDropdown">
                                <button class="user-btn" id="userBtn" type="button" aria-haspopup="true" aria-expanded="false">
                                    <div class="user-avatar" aria-hidden="true"><i class="fas fa-user"></i></div>
                                    <div style="text-align:left; margin-left:6px; color:#1d3aa0;">
                                        <span style="font-size:12px; display:block; color:inherit;">Hola,</span>
                                        <strong style="display:block; font-size:14px; color:inherit;">
                                            <c:out value="${sessionScope.user.nombre}" default="Usuario"/>
                                        </strong>
                                    </div>
                                    <i class="fas fa-caret-down" style="margin-left:8px;" aria-hidden="true"></i>
                                </button>

                                <div class="user-menu" id="userMenu" role="menu" aria-label="Menú usuario">
                                    <a href="${ctx}/PerfilServlet" role="menuitem"><i class="fas fa-user-circle" style="width:14px;"></i> Mi perfil</a>
                                    <a href="${ctx}/Vista/Cliente/mis_compras.jsp" role="menuitem"><i class="fas fa-shopping-cart" style="width:14px;"></i> Mis compras</a>
                                    <a href="${ctx}/srvIniciarSesion?accion=cerrar" role="menuitem"><i class="fas fa-sign-out-alt" style="width:14px;"></i> Cerrar sesión</a>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </nav>
        </header>

        <!-- ANUNCIO -->
        <section class="hero" id="inicio">
            <div class="hero-overlay">
                <div class="container">
                    <div class="hero-content">
                        <h1 class="hero-title">Viaja con <span class="highlight">NOVAS</span></h1>
                        <p class="hero-subtitle">Descubre Perú con comodidad y seguridad</p>
                        <div class="hero-tagline"><i class="fas fa-check"></i><span>NOVAS es atención y dedicación</span></div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Buscador (igual que antes) -->
        <section class="search-section">
            <div class="container">
                <div class="search-card">
                    <h2 class="search-title"><i class="fas fa-search"></i> Encuentra tu próximo viaje</h2>
                    <form id="search-form" action="${ctx}/BuscarPasajes" method="post" class="modern-form">
                        <div class="form-grid" style="display:grid; grid-template-columns: repeat(auto-fit,minmax(220px,1fr)); gap:12px;">
                            <div class="form-group">
                                <label for="origen" class="form-label"><i class="fas fa-map-marker-alt"></i> Origen</label>
                                <select id="origen" name="origen" class="form-select" required>
                                    <option value="">Seleccione ciudad de origen</option>
                                    <option value="lima">Lima</option>
                                    <option value="arequipa">Arequipa</option>
                                    <option value="cusco">Cusco</option>
                                    <option value="trujillo">Trujillo</option>
                                    <option value="chiclayo">Chiclayo</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="destino" class="form-label"><i class="fas fa-flag-checkered"></i> Destino</label>
                                <select id="destino" name="destino" class="form-select" required>
                                    <option value="">Seleccione ciudad de destino</option>
                                    <option value="abancay">Abancay</option>
                                    <option value="arequipa">Arequipa</option>
                                    <option value="camana">Camaná</option>
                                    <option value="chiclayo">Chiclayo</option>
                                    <option value="chimbote">Chimbote</option>
                                    <option value="cusco">Cusco</option>
                                    <option value="lima">Lima</option>
                                    <option value="trujillo">Trujillo</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="fecha-salida" class="form-label"><i class="fas fa-calendar-alt"></i> Fecha de salida</label>
                                <input type="date" id="fecha-salida" name="fechaSalida" class="form-input" required>
                            </div>
                            <div class="form-group">
                                <label for="fecha-retorno" class="form-label"><i class="fas fa-calendar-check"></i> Fecha de retorno</label>
                                <input type="date" id="fecha-retorno" name="fechaRetorno" class="form-input">
                                <div class="checkbox-group" style="margin-top:6px;">
                                    <input type="checkbox" id="solo-ida" name="soloIda">
                                    <label for="solo-ida" class="checkbox-label">Solo ida</label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="pasajeros" class="form-label"><i class="fas fa-users"></i> Pasajeros</label>
                                <select id="pasajeros" name="pasajeros" class="form-select">
                                    <option value="1">1 pasajero</option>
                                    <option value="2">2 pasajeros</option>
                                    <option value="3">3 pasajeros</option>
                                    <option value="4">4 pasajeros</option>
                                    <option value="5">5 pasajeros</option>
                                </select>
                            </div>
                        </div>
                        <div style="margin-top:12px;">
                            <button type="submit" class="btn btn-primary btn-large"><i class="fas fa-search"></i> Buscar Pasajes</button>
                        </div>
                    </form>
                </div>
            </div>
        </section>

        <!-- DESTINOS -> Carrusel -->
        <section class="destinations-section" id="destinos">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Destinos Populares</h2>
                    <p class="section-subtitle">Descubre los lugares más visitados de Perú</p>
                </div>

                <div class="carousel" id="destinos-carousel" aria-roledescription="carousel">
                    <div class="carousel-track" id="carousel-track">
                        <!-- Slide 1 -->
                        <article class="destination-card" data-destino="arequipa" data-id="3" role="group" aria-label="Arequipa">
                            <div class="destination-image" aria-hidden="true">
                                <img src="${ctx}/Imagenes/arequipa.jpg" alt="Arequipa">
                                <div class="destination-overlay"><a class="destination-price" href="${ctx}/DestinoServlet?destinoId=3">Desde S/ 45</a></div>
                            </div>
                            <div class="destination-content">
                                <h3 class="destination-name">Arequipa</h3>
                                <p class="destination-desc">La Ciudad Blanca</p>
                                <div class="destination-features"><span><i class="fas fa-clock"></i> 12h</span><span><i class="fas fa-bus"></i> Directo</span></div>
                            </div>
                        </article>

                        <!-- Slide 2 -->
                        <article class="destination-card" data-destino="cusco" data-id="4" role="group" aria-label="Cusco">
                            <div class="destination-image" aria-hidden="true">
                                <img src="${ctx}/Imagenes/cusco.jpg" alt="Cusco">
                                <div class="destination-overlay"><span class="destination-price">Desde S/ 55</span></div>
                            </div>
                            <div class="destination-content">
                                <h3 class="destination-name">Cusco</h3>
                                <p class="destination-desc">Capital Imperial</p>
                                <div class="destination-features"><span><i class="fas fa-clock"></i> 20h</span><span><i class="fas fa-bus"></i> Semi-cama</span></div>
                            </div>
                        </article>

                        <!-- Slide 3 -->
                        <article class="destination-card" data-destino="chiclayo" data-id="5" role="group" aria-label="Chiclayo">
                            <div class="destination-image" aria-hidden="true">
                                <img src="${ctx}/Imagenes/chiclayo.jpg" alt="Chiclayo">
                                <div class="destination-overlay"><span class="destination-price">Desde S/ 35</span></div>
                            </div>
                            <div class="destination-content">
                                <h3 class="destination-name">Chiclayo</h3>
                                <p class="destination-desc">Capital de la Amistad</p>
                                <div class="destination-features"><span><i class="fas fa-clock"></i> 10h</span><span><i class="fas fa-bus"></i> Directo</span></div>
                            </div>
                        </article>

                        <!-- Slide 4 -->
                        <article class="destination-card" data-destino="trujillo" data-id="6" role="group" aria-label="Trujillo">
                            <div class="destination-image" aria-hidden="true">
                                <img src="${ctx}/Imagenes/trujillo.jpg" alt="Trujillo">
                                <div class="destination-overlay"><span class="destination-price">Desde S/ 40</span></div>
                            </div>
                            <div class="destination-content">
                                <h3 class="destination-name">Trujillo</h3>
                                <p class="destination-desc">Ciudad de la Eterna Primavera</p>
                                <div class="destination-features"><span><i class="fas fa-clock"></i> 8h</span><span><i class="fas fa-bus"></i> Ejecutivo</span></div>
                            </div>
                        </article>
                    </div>

                    <!-- Controls -->
                    <button class="carousel-control left" id="carousel-prev" aria-label="Anterior">
                        <i class="fas fa-chevron-left" aria-hidden="true"></i>
                    </button>
                    <button class="carousel-control right" id="carousel-next" aria-label="Siguiente">
                        <i class="fas fa-chevron-right" aria-hidden="true"></i>
                    </button>

                    <!-- Indicators -->
                    <div class="carousel-indicators" id="carousel-indicators" role="tablist" aria-label="Indicadores de destinos">
                        <!-- generados por JS -->
                    </div>
                </div>
            </div>
        </section>

        <!-- CHERRY XD -->
        <section class="visa-section">
            <div class="container">
                <div class="visa-card">
                    <div class="visa-icon"><i class="fas fa-bus"></i></div>
                    <div class="visa-content">
                        <h2>Porque viajar con NOVAS</h2>
                        <p>Te brindamos un servicio de transporte integral que combina seguridad, calidad, cumplimiento de plazos y trazabilidad de tus trayectos.</p>
                        <button class="btn btn-outline">Más Información</button>
                    </div>
                </div>
            </div>
        </section>

        <!-- FOOTER -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <div class="footer-logo">
                            <img src="${ctx}/Imagenes/novas_logo.png" alt="NOVAS" class="logo">
                            <span class="company-name">NOVAS</span>
                        </div>
                        <p class="footer-text">Viajes seguros y cómodos por todo el Perú</p>
                        <div class="social-links"><a href="#"><i class="fab fa-facebook"></i></a><a href="#"><i class="fab fa-twitter"></i></a><a href="#"><i class="fab fa-instagram"></i></a><a href="#"><i class="fab fa-whatsapp"></i></a></div>
                    </div>

                    <div class="footer-section"><h3>Destinos</h3><ul><li><a href="#">Arequipa</a></li><li><a href="#">Cusco</a></li><li><a href="#">Chiclayo</a></li><li><a href="#">Trujillo</a></li></ul></div>

                    <div class="footer-section"><h3>Opciones de Viaje</h3><ul><li><a href="#">Promociones</a></li><li><a href="#">Rutas</a></li><li><a href="#">Horarios</a></li><li><a href="#">Contacto</a></li></ul></div>

                    <div class="footer-section"><h3>Contacto</h3><div class="contact-info"><p><i class="fas fa-phone"></i> (01) 123-4567</p><p><i class="fas fa-envelope"></i> info@novas.com</p><p><i class="fas fa-map-marker-alt"></i> Lima, Perú</p></div></div>
                </div>

                <div class="footer-bottom">
                    <p>&copy; 2025 NOVAS - Todos los derechos reservados</p>
                    <p>NOVAS es atención y dedicación</p>
                </div>
            </div>
        </footer>

        <!-- SCRIPTS -->
        <script>
            var ctx = '${ctx}';

            // Dropdown usuario (abre / cierra y cierra al click fuera)
            (function () {
                var userBtn = document.getElementById('userBtn');
                var userMenu = document.getElementById('userMenu');
                if (!userBtn || !userMenu)
                    return;

                userBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    var visible = userMenu.style.display === 'block';
                    userMenu.style.display = visible ? 'none' : 'block';
                    userBtn.setAttribute('aria-expanded', String(!visible));
                });

                document.addEventListener('click', function (e) {
                    if (!userMenu.contains(e.target) && !userBtn.contains(e.target)) {
                        userMenu.style.display = 'none';
                        userBtn.setAttribute('aria-expanded', 'false');
                    }
                });

                document.addEventListener('keydown', function (e) {
                    if (e.key === 'Escape') {
                        userMenu.style.display = 'none';
                        if (userBtn)
                            userBtn.setAttribute('aria-expanded', 'false');
                    }
                });
            })();

            // tarjetas clicables (también en slides)
            (function () {
                function goToCard(card) {
                    var id = card.dataset.id;
                    if (id) {
                        window.location.href = ctx + '/DestinoServlet?destinoId=' + encodeURIComponent(id);
                    } else {
                        var slug = card.dataset.destino;
                        window.location.href = ctx + '/DestinoServlet?destino=' + encodeURIComponent(slug);
                    }
                }

                document.addEventListener('click', function (e) {
                    var card = e.target.closest('.destination-card');
                    if (card)
                        goToCard(card);
                });

                document.addEventListener('keydown', function (e) {
                    if ((e.key === 'Enter' || e.key === ' ') && document.activeElement && document.activeElement.classList.contains('destination-card')) {
                        e.preventDefault();
                        goToCard(document.activeElement);
                    }
                });
            })();

            // CARRUSEL: indicadores, controles, autoplay, accesibilidad, normalizar alturas
            (function () {
                const track = document.getElementById('carousel-track');
                const slides = Array.from(track.children);
                const prevBtn = document.getElementById('carousel-prev');
                const nextBtn = document.getElementById('carousel-next');
                const indicatorsContainer = document.getElementById('carousel-indicators');
                const carousel = document.getElementById('destinos-carousel');

                let currentIndex = 0;
                const total = slides.length;
                const autoplayDelay = 4000; // ms
                let autoplayTimer = null;

                // crear indicadores
                slides.forEach((s, i) => {
                    const dot = document.createElement('button');
                    dot.className = 'indicator' + (i === 0 ? ' active' : '');
                    dot.setAttribute('aria-label', 'Ir al slide ' + (i + 1));
                    dot.setAttribute('data-index', i);
                    dot.addEventListener('click', () => goToIndex(i));
                    indicatorsContainer.appendChild(dot);
                });
                const indicators = Array.from(indicatorsContainer.children);

                function updateAria() {
                    slides.forEach((s, i) => {
                        s.setAttribute('aria-hidden', i === currentIndex ? 'false' : 'true');
                        // make slides focusable only when active
                        if (i === currentIndex) {
                            s.setAttribute('tabindex', '0');
                        } else {
                            s.removeAttribute('tabindex');
                        }
                    });
                    indicators.forEach((d, i) => d.classList.toggle('active', i === currentIndex));
                }

                function goToIndex(index) {
                    if (index < 0)
                        index = total - 1;
                    if (index >= total)
                        index = 0;
                    currentIndex = index;
                    const translateX = -(currentIndex * 100);
                    track.style.transform = 'translateX(' + translateX + '%)';
                    updateAria();
                    resetAutoplay();
                }

                prevBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    goToIndex(currentIndex - 1);
                });
                nextBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    goToIndex(currentIndex + 1);
                });

                // autoplay
                function startAutoplay() {
                    if (autoplayTimer)
                        return;
                    autoplayTimer = setInterval(() => goToIndex(currentIndex + 1), autoplayDelay);
                }
                function stopAutoplay() {
                    if (autoplayTimer) {
                        clearInterval(autoplayTimer);
                        autoplayTimer = null;
                    }
                }
                function resetAutoplay() {
                    stopAutoplay();
                    startAutoplay();
                }

                // pausa al hover/focus
                carousel.addEventListener('mouseenter', stopAutoplay);
                carousel.addEventListener('mouseleave', startAutoplay);
                carousel.addEventListener('focusin', stopAutoplay);
                carousel.addEventListener('focusout', startAutoplay);

                // teclado
                document.addEventListener('keydown', (e) => {
                    if (e.key === 'ArrowLeft')
                        goToIndex(currentIndex - 1);
                    if (e.key === 'ArrowRight')
                        goToIndex(currentIndex + 1);
                });

                // Ajustar ancho de track y normalizar alturas
                function layoutSlides() {
                    track.style.width = (total * 100) + '%';
                    slides.forEach(s => {
                        s.style.width = (100 / total) + '%';
                        s.style.boxSizing = 'border-box';
                        s.style.minHeight = '0';
                    });

                    // normalizar altura al mayor de los slides para que no haya blancos
                    let maxH = 0;
                    slides.forEach(s => {
                        s.style.height = 'auto';
                        const rect = s.getBoundingClientRect();
                        const h = rect.height || s.offsetHeight;
                        if (h > maxH)
                            maxH = h;
                    });
                    if (maxH > 0)
                        slides.forEach(s => s.style.height = maxH + 'px');
                }

                // Iniciar
                window.addEventListener('load', () => {
                    layoutSlides();
                    updateAria();
                    startAutoplay();
                    window.addEventListener('resize', layoutSlides);
                });

                // Exponer (opcional)
                window.goToDestino = goToIndex;
            })();
        </script>

        <script src="${ctx}/js/script.js"></script>
    </body>
</html>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>NOVAS - Viajes Seguros y Cómodos</title>

        <!-- hoja principal (mantenerla) -->
        <link href="${pageContext.request.contextPath}/css/novas-landing.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <style>
            /* ====== small helper styles for header/nav kept minimal ====== */
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

            /* grid para centrar verticalmente y controlar dos columnas */
            .destination-card {
                min-width: 100%;
                box-sizing: border-box;
                padding: 12px;
                display: grid;
                grid-template-columns: 360px 1fr;
                gap: 20px;
                align-items: center; /* centra verticalmente el contenido respecto a la imagen */
                justify-items: start;
            }

            /* imagen: control de ratio/alto fijo para consistencia */
            .destination-image {
                width: 100%;
                max-width: 360px;
                aspect-ratio: 3 / 4;              /* si el navegador lo soporta */
                max-height: 520px;                /* tope para evitar imágenes excesivas */
                height: 100%;
                position: relative;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 8px 20px rgba(16,24,64,0.06);
                background: #f2f4f8;
                display:flex;
            }
            /* fallback para navegadores sin aspect-ratio: forzamos altura */
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
                flex: 1 1 auto;
                display:flex;
                flex-direction:column;
                justify-content:center; /* centra verticalmente el bloque textual */
                gap: 8px;
                padding-right: 8px;
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
                border: 2px solid rgba(255,255,255,0.0);
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
                    grid-auto-rows: auto;
                }
                .destination-image {
                    width:100%;
                    max-width: none;
                    aspect-ratio: 16/9;
                    height: 220px;
                }
                .carousel {
                    padding: 10px;
                }
                .carousel-control {
                    width:38px;
                    height:38px;
                }
            }

            /* pequeños retoques: botón acceso, logo, etc. (opcional) */
            .logo {
                height: 36px;
                display:inline-block;
                vertical-align:middle;
            }
            .company-name {
                font-weight:700;
                font-size:1.05rem;
                color:#333;
            }
        </style>
    </head>

    <body>
        <header>
            <nav class="navbar">
                <div class="container" style="display:flex; align-items:center; justify-content:space-between;">
                    <div class="nav-brand" style="display:flex; align-items:center; gap:10px;">
                        <img src="${pageContext.request.contextPath}/Imagenes/novas_logo.png" alt="NOVAS Logo" class="logo">
                        <span class="company-name">NOVAS</span>
                    </div>

                    <ul class="nav-menu" style="display:flex; list-style:none; gap:1rem; align-items:center;">
                        <li><a href="#inicio">Inicio</a></li>
                        <li><a href="#destinos">Destinos</a></li>
                        <li><a href="#promociones">Promociones</a></li>
                        <li><a href="#contacto">Contacto</a></li>
                    </ul>

                    <div class="nav-actions">
                        <a href="${pageContext.request.contextPath}/Vista/login.jsp" class="btn btn-primary btn-access" style="display:flex; align-items:center; gap:8px;">
                            <i class="fas fa-user-circle"></i>
                            <span>Acceder</span>
                        </a>
                    </div>
                </div>
            </nav>
        </header>

        <section class="hero" id="inicio">
            <div class="hero-overlay">
                <div class="container">
                    <div class="hero-content">
                        <h1 class="hero-title">Viaja con <span class="highlight">NOVAS</span></h1>
                        <p class="hero-subtitle">Descubre Perú con comodidad y seguridad</p>
                        <div class="hero-tagline">
                            <i class="fas fa-check"></i>
                            <span>NOVAS es atención y dedicación</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Buscador -->
        <section class="search-section">
            <div class="container">
                <div class="search-card">
                    <h2 class="search-title"><i class="fas fa-search"></i> Encuentra tu próximo viaje</h2>
                    <form id="search-form" action="BuscarPasajes" method="post" class="modern-form">
                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-map-marker-alt"></i> Origen</label>
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
                                <label class="form-label"><i class="fas fa-calendar-alt"></i> Fecha de salida</label>
                                <input type="date" name="fechaSalida" class="form-input" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-calendar-check"></i> Fecha de retorno</label>
                                <input type="date" name="fechaRetorno" class="form-input">
                                <div class="checkbox-group">
                                    <input type="checkbox" id="solo-ida" name="soloIda">
                                    <label for="solo-ida" class="checkbox-label">Solo ida</label>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label"><i class="fas fa-users"></i> Pasajeros</label>
                                <select id="pasajeros" name="pasajeros" class="form-select">
                                    <option value="1">1 pasajero</option>
                                    <option value="2">2 pasajeros</option>
                                    <option value="3">3 pasajeros</option>
                                    <option value="4">4 pasajeros</option>
                                    <option value="5">5 pasajeros</option>
                                </select>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-large">
                            <i class="fas fa-search"></i> Buscar Pasajes
                        </button>
                    </form>
                </div>
            </div>
        </section>

        <!-- DESTINOS -> Carrusel dinámico -->
        <section class="destinations-section" id="destinos">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Destinos Populares</h2>
                    <p class="section-subtitle">Descubre los lugares más visitados de Perú</p>
                </div>

                <div class="carousel" id="destinos-carousel" aria-roledescription="carousel">
                    <div class="carousel-track" id="carousel-track">
                        <!-- Slide 1 -->
                        <article class="destination-card" data-destino="3" aria-hidden="false">
                            <div class="destination-image">
                                <img src="${pageContext.request.contextPath}/Imagenes/arequipa.jpg" alt="Arequipa">
                                <div class="destination-overlay">
                                    <a href="${pageContext.request.contextPath}/DestinoServlet?destinoId=3" class="destination-price btn-link">Desde S/ 45</a>
                                </div>
                            </div>
                            <div class="destination-content">
                                <div>
                                    <h3 class="destination-name">Arequipa</h3>
                                    <p class="destination-desc">La Ciudad Blanca</p>
                                </div>
                                <div class="destination-features">
                                    <span><i class="fas fa-clock"></i> 12h</span>
                                    <span><i class="fas fa-bus"></i> Directo</span>
                                </div>
                            </div>
                        </article>

                        <!-- Slide 2 -->
                        <article class="destination-card" data-destino="cusco" aria-hidden="true">
                            <div class="destination-image">
                                <img src="${pageContext.request.contextPath}/Imagenes/cusco.jpg" alt="Cusco">
                                <div class="destination-overlay">
                                    <span class="destination-price">Desde S/ 55</span>
                                </div>
                            </div>
                            <div class="destination-content">
                                <div>
                                    <h3 class="destination-name">Cusco</h3>
                                    <p class="destination-desc">Capital Imperial</p>
                                </div>
                                <div class="destination-features">
                                    <span><i class="fas fa-clock"></i> 20h</span>
                                    <span><i class="fas fa-bus"></i> Semi-cama</span>
                                </div>
                            </div>
                        </article>

                        <!-- Slide 3 -->
                        <article class="destination-card" data-destino="chiclayo" aria-hidden="true">
                            <div class="destination-image">
                                <img src="${pageContext.request.contextPath}/Imagenes/chiclayo.jpg" alt="Chiclayo">
                                <div class="destination-overlay">
                                    <span class="destination-price">Desde S/ 35</span>
                                </div>
                            </div>
                            <div class="destination-content">
                                <div>
                                    <h3 class="destination-name">Chiclayo</h3>
                                    <p class="destination-desc">Capital de la Amistad</p>
                                </div>
                                <div class="destination-features">
                                    <span><i class="fas fa-clock"></i> 10h</span>
                                    <span><i class="fas fa-bus"></i> Directo</span>
                                </div>
                            </div>
                        </article>

                        <!-- Slide 4 -->
                        <article class="destination-card" data-destino="trujillo" aria-hidden="true">
                            <div class="destination-image">
                                <img src="${pageContext.request.contextPath}/Imagenes/trujillo.jpg" alt="Trujillo">
                                <div class="destination-overlay">
                                    <span class="destination-price">Desde S/ 40</span>
                                </div>
                            </div>
                            <div class="destination-content">
                                <div>
                                    <h3 class="destination-name">Trujillo</h3>
                                    <p class="destination-desc">Ciudad de la Eterna Primavera</p>
                                </div>
                                <div class="destination-features">
                                    <span><i class="fas fa-clock"></i> 8h</span>
                                    <span><i class="fas fa-bus"></i> Ejecutivo</span>
                                </div>
                            </div>
                        </article>
                    </div>

                    <!-- Controls -->
                    <button class="carousel-control left" id="carousel-prev" aria-label="Anterior">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                    <button class="carousel-control right" id="carousel-next" aria-label="Siguiente">
                        <i class="fas fa-chevron-right"></i>
                    </button>

                    <!-- Indicators -->
                    <div class="carousel-indicators" id="carousel-indicators" role="tablist" aria-label="Indicadores de destinos">
                        <!-- indicadores se generan por JS -->
                    </div>
                </div>

            </div>
        </section>

        <section class="visa-section">
            <div class="container">
                <div class="visa-card">
                    <div class="visa-icon"><i class="fas fa-bus"></i></div>
                    <div class="visa-content">
                        <h2>Porque viajar con NOVAS</h2>
                        <p>Te brindamos un servicio de transporte integral que combina seguridad, calidad,
                            cumplimiento de plazos y trazabilidad de tus trayectos.</p>
                        <button class="btn btn-outline">Más Información</button>
                    </div>
                </div>
            </div>
        </section>

        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <div class="footer-logo">
                            <img src="${pageContext.request.contextPath}/Imagenes/logo-novas-white.png" alt="NOVAS" class="logo">
                            <span class="company-name">NOVAS</span>
                        </div>
                        <p class="footer-text">Viajes seguros y cómodos por todo el Perú</p>
                        <div class="social-links">
                            <a href="#"><i class="fab fa-facebook"></i></a>
                            <a href="#"><i class="fab fa-twitter"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-whatsapp"></i></a>
                        </div>
                    </div>

                    <div class="footer-section">
                        <h3>Destinos</h3>
                        <ul>
                            <li><a href="#">Arequipa</a></li>
                            <li><a href="#">Cusco</a></li>
                            <li><a href="#">Chiclayo</a></li>
                            <li><a href="#">Trujillo</a></li>
                        </ul>
                    </div>

                    <div class="footer-section">
                        <h3>Opciones de Viaje</h3>
                        <ul>
                            <li><a href="#">Promociones</a></li>
                            <li><a href="#">Rutas</a></li>
                            <li><a href="#">Horarios</a></li>
                            <li><a href="#">Contacto</a></li>
                        </ul>
                    </div>

                    <div class="footer-section">
                        <h3>Contacto</h3>
                        <div class="contact-info">
                            <p><i class="fas fa-phone"></i> (01) 123-4567</p>
                            <p><i class="fas fa-envelope"></i> info@novas.com</p>
                            <p><i class="fas fa-map-marker-alt"></i> Lima, Perú</p>
                        </div>
                    </div>
                </div>

                <div class="footer-bottom">
                    <p>&copy; 2025 NOVAS - Todos los derechos reservados</p>
                    <p>NOVAS es atención y dedicación</p>
                </div>
            </div>
        </footer>

        <!-- script: controla el carrusel (mejorado) -->
        <script>
            (function () {
                const track = document.getElementById('carousel-track');
                const slides = Array.from(track.children);
                const prevBtn = document.getElementById('carousel-prev');
                const nextBtn = document.getElementById('carousel-next');
                const indicatorsContainer = document.getElementById('carousel-indicators');

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
                    slides.forEach((s, i) => s.setAttribute('aria-hidden', i === currentIndex ? 'false' : 'true'));
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

                prevBtn.addEventListener('click', () => goToIndex(currentIndex - 1));
                nextBtn.addEventListener('click', () => goToIndex(currentIndex + 1));

                // autoplay
                function startAutoplay() {
                    if (autoplayTimer)
                        return;
                    autoplayTimer = setInterval(() => {
                        goToIndex(currentIndex + 1);
                    }, autoplayDelay);
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

                // pausado al hover / focus (accesibilidad)
                const carousel = document.getElementById('destinos-carousel');
                carousel.addEventListener('mouseenter', stopAutoplay);
                carousel.addEventListener('mouseleave', startAutoplay);
                carousel.addEventListener('focusin', stopAutoplay);
                carousel.addEventListener('focusout', startAutoplay);

                // navegación por teclado (izq/der)
                document.addEventListener('keydown', (e) => {
                    if (e.key === 'ArrowLeft')
                        goToIndex(currentIndex - 1);
                    if (e.key === 'ArrowRight')
                        goToIndex(currentIndex + 1);
                });

                // Ajustar tamaño/anchos de slides y normalizar alturas
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
                    // aplicar altura uniforme sólo si calculamos un max válido
                    if (maxH > 0)
                        slides.forEach(s => s.style.height = maxH + 'px');
                }

                // iniciar
                window.addEventListener('load', () => {
                    layoutSlides();
                    updateAria();
                    startAutoplay();
                    // recalcular en resize
                    window.addEventListener('resize', () => {
                        layoutSlides();
                    });
                });

                // Exponer función para cambiar desde servidor (JS)
                window.goToDestino = goToIndex;
            })();
        </script>

        <!-- script general del sitio (corrige path si tu proyecto lo ubica en otra carpeta) -->
        <script src="${pageContext.request.contextPath}/js/script.js"></script>
    </body>
</html>

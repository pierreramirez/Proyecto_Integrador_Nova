document.addEventListener('DOMContentLoaded', function () {
    // --- Helpers seguros para obtener elementos por id o por name (fallback) ---
    function getByIdOrName(id, nameSelector) {
        return document.getElementById(id) || document.querySelector(nameSelector);
    }

    // Inputs de fecha (intenta id 'fecha-salida' / 'fecha-retorno', si no usa name)
    const fechaSalidaEl = getByIdOrName('fecha-salida', 'input[name="fechaSalida"]');
    const fechaRetornoEl = getByIdOrName('fecha-retorno', 'input[name="fechaRetorno"]');

    // Selects y botones
    const origenEl = getByIdOrName('origen', 'select[name="origen"]');
    const destinoEl = getByIdOrName('destino', 'select[name="destino"]');
    const searchForm = document.getElementById('search-form') || document.querySelector('form.modern-form');

    // Checkbox solo ida
    const soloIdaEl = document.getElementById('solo-ida') || document.querySelector('input[name="soloIda"]');

    // Fecha mínima = hoy (si los elementos existen)
    try {
        const today = new Date().toISOString().split('T')[0];
        if (fechaSalidaEl)
            fechaSalidaEl.min = today;
        if (fechaRetornoEl)
            fechaRetornoEl.min = today;
    } catch (err) {
        // no bloquear si algo falla
        console.warn('Error al establecer min fecha:', err);
    }

    // Manejar checkbox solo ida (solo si existe)
    if (soloIdaEl && fechaRetornoEl) {
        soloIdaEl.addEventListener('change', function () {
            fechaRetornoEl.disabled = this.checked;
            if (this.checked)
                fechaRetornoEl.value = '';
        });
    }

    // Actualizar min de retorno cuando cambia salida
    if (fechaSalidaEl && fechaRetornoEl) {
        fechaSalidaEl.addEventListener('change', function () {
            // si la fecha de salida cambia, actualizamos min de retorno
            if (this.value)
                fechaRetornoEl.min = this.value;
            // si retorno es anterior, lo limpiamos
            if (fechaRetornoEl.value && fechaRetornoEl.value < this.value)
                fechaRetornoEl.value = '';
        });
    }

    // CLICK en tarjetas: intenta seleccionar el option correspondiente del select destino
    document.querySelectorAll('.destination-card').forEach(card => {
        card.addEventListener('click', function (e) {
            // evitar doble trigger si hay botones dentro
            if (e.target && (e.target.tagName === 'A' || e.target.closest('a')))
                return;

            const dataDestino = this.getAttribute('data-destino');             // p.e. "3" o "arequipa"
            const cardNameEl = this.querySelector('.destination-name');
            const cardName = cardNameEl ? cardNameEl.textContent.trim().toLowerCase() : null;

            if (destinoEl) {
                // 1) intenta setear por value exacto (más rápido y seguro)
                const optByValue = Array.from(destinoEl.options).find(o => o.value === dataDestino);
                if (optByValue) {
                    destinoEl.value = dataDestino;
                } else {
                    // 2) intenta buscar option cuyo texto coincida con el nombre de la tarjeta
                    const optByText = Array.from(destinoEl.options).find(o => {
                        return o.textContent.trim().toLowerCase() === cardName;
                    });
                    if (optByText) {
                        destinoEl.value = optByText.value;
                    } else {
                        // 3) intenta buscar por substring (p.e. "Arequipa" dentro de "Arequipa - ...")
                        const optByContains = Array.from(destinoEl.options).find(o => {
                            return o.textContent.trim().toLowerCase().includes(cardName);
                        });
                        if (optByContains)
                            destinoEl.value = optByContains.value;
                        else {
                            // 4) si no hay match, simplemente setea el value (puede crear mismatch)
                            try {
                                destinoEl.value = dataDestino;
                            } catch (err) { /* ignore */
                            }
                        }
                    }
                }
            }

            // scroll suave al formulario si existe
            if (searchForm) {
                searchForm.scrollIntoView({behavior: 'smooth', block: 'center'});
            }

            // pequeño feedback visual
            this.style.transform = 'scale(0.97)';
            setTimeout(() => this.style.transform = '', 160);
        });
    });

    // Smooth scroll navegación (protección por existencia)
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            if (!href || href === '#')
                return;
            const target = document.querySelector(href);
            if (!target)
                return;
            e.preventDefault();
            target.scrollIntoView({behavior: 'smooth', block: 'start'});
        });
    });

    // Parallax hero — limita el efecto (y evita romper layout)
    const hero = document.querySelector('.hero');
    let lastKnownScroll = 0;
    if (hero) {
        window.addEventListener('scroll', function () {
            lastKnownScroll = window.pageYOffset || document.documentElement.scrollTop;
            // limitamos desplazamiento a 120px para no empujar todo
            const offset = Math.min(120, lastKnownScroll * 0.25);
            hero.style.transform = `translateY(${offset}px)`;
        }, {passive: true});
    }

    // Validación del formulario antes de enviar (si existe)
    if (searchForm) {
        searchForm.addEventListener('submit', function (e) {
            const origen = origenEl ? origenEl.value : '';
            const destino = destinoEl ? destinoEl.value : '';
            const fechaSalida = fechaSalidaEl ? fechaSalidaEl.value : '';

            // Mensajería simple
            function notify(msg, type = 'error') {
                // Reusa función de notificación si existe, si no usa alert
                if (typeof showNotification === 'function') {
                    showNotification(msg, type);
                } else {
                    alert(msg);
            }
            }

            if (!origen || !destino || !fechaSalida) {
                e.preventDefault();
                notify('Por favor, complete todos los campos obligatorios.', 'error');
                return;
            }
            if (origen === destino) {
                e.preventDefault();
                notify('El origen y destino no pueden ser iguales.', 'error');
                return;
            }

            const soloIda = soloIdaEl ? soloIdaEl.checked : false;
            const fechaRetornoVal = fechaRetornoEl ? fechaRetornoEl.value : '';

            if (!soloIda && !fechaRetornoVal) {
                e.preventDefault();
                notify('Por favor, seleccione fecha de retorno o marque "Solo ida".', 'error');
                return;
            }
            if (!soloIda && fechaRetornoVal && fechaRetornoVal < fechaSalida) {
                e.preventDefault();
                notify('La fecha de retorno no puede ser anterior a la fecha de salida.', 'error');
                return;
            }

            // todo ok -> mostrar loading (si existe función)
            if (typeof showNotification === 'function')
                showNotification('Buscando pasajes disponibles...', 'loading');
        });
    }

    // Observador de intersección: animaciones (si IntersectionObserver está disponible)
    if ('IntersectionObserver' in window) {
        const observerOptions = {threshold: 0.08, rootMargin: '0px 0px -40px 0px'};
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.destination-card, .search-card, .visa-card').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(20px)';
            el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            observer.observe(el);
        });
    }

    // ÚLTIMO RECURSO: si alguna hoja externa fuerza height/width en <img>, lo corregimos en runtime
    // (esto debe aplicar luego de que la página cargue imágenes)
    window.addEventListener('load', function () {
        document.querySelectorAll('.destination-image img').forEach(img => {
            // solo aplicar si no está ya correcto
            const computed = window.getComputedStyle(img);
            if (computed.objectFit !== 'cover' || computed.height === 'auto' || computed.width === '0px') {
                img.style.width = '100%';
                img.style.height = '260px';
                img.style.maxHeight = '360px';
                img.style.objectFit = 'cover';
                img.style.display = 'block';
            }
        });
    });
});

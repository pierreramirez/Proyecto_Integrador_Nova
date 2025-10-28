document.addEventListener('DOMContentLoaded', function() {
    // Establecer fecha mínima como hoy
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('fecha-salida').min = today;
    document.getElementById('fecha-retorno').min = today;
    
    // Manejar el checkbox de solo ida
    document.getElementById('solo-ida').addEventListener('change', function() {
        const fechaRetorno = document.getElementById('fecha-retorno');
        fechaRetorno.disabled = this.checked;
        if (this.checked) {
            fechaRetorno.value = '';
        }
    });
    
    // Actualizar fecha mínima de retorno cuando cambia la fecha de salida
    document.getElementById('fecha-salida').addEventListener('change', function() {
        const fechaRetorno = document.getElementById('fecha-retorno');
        fechaRetorno.min = this.value;
    });
    
    // Manejar clics en las tarjetas de destino
    document.querySelectorAll('.destination-card').forEach(card => {
        card.addEventListener('click', function() {
            const destino = this.getAttribute('data-destino');
            document.getElementById('destino').value = destino;
            
            // Scroll suave al formulario
            document.getElementById('search-form').scrollIntoView({ 
                behavior: 'smooth',
                block: 'center'
            });
            
            // Efecto visual de confirmación
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = '';
            }, 200);
        });
    });
    
    // Smooth scroll para navegación
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Efecto de parallax en el hero
    window.addEventListener('scroll', function() {
        const scrolled = window.pageYOffset;
        const hero = document.querySelector('.hero');
        if (hero) {
            hero.style.transform = `translateY(${scrolled * 0.5}px)`;
        }
    });
    
    // Validación del formulario antes de enviar
    document.getElementById('search-form').addEventListener('submit', function(e) {
        const origen = document.getElementById('origen').value;
        const destino = document.getElementById('destino').value;
        const fechaSalida = document.getElementById('fecha-salida').value;
        
        if (!origen || !destino || !fechaSalida) {
            e.preventDefault();
            showNotification('Por favor, complete todos los campos obligatorios.', 'error');
            return;
        }
        
        if (origen === destino) {
            e.preventDefault();
            showNotification('El origen y destino no pueden ser iguales.', 'error');
            return;
        }
        
        // Validar fecha de retorno si no es solo ida
        const soloIda = document.getElementById('solo-ida').checked;
        const fechaRetorno = document.getElementById('fecha-retorno').value;
        
        if (!soloIda && !fechaRetorno) {
            e.preventDefault();
            showNotification('Por favor, seleccione fecha de retorno o marque "Solo ida".', 'error');
            return;
        }
        
        if (!soloIda && fechaRetorno < fechaSalida) {
            e.preventDefault();
            showNotification('La fecha de retorno no puede ser anterior a la fecha de salida.', 'error');
            return;
        }
        
        // Mostrar loading
        showNotification('Buscando pasajes disponibles...', 'loading');
    });
    
    // Función para mostrar notificaciones
    function showNotification(message, type = 'info') {
        // Remover notificación anterior si existe
        const existingNotification = document.querySelector('.notification');
        if (existingNotification) {
            existingNotification.remove();
        }
        
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.innerHTML = `
            <div class="notification-content">
                <i class="fas fa-${getNotificationIcon(type)}"></i>
                <span>${message}</span>
            </div>
        `;
        
        // Estilos para la notificación
        notification.style.cssText = `
            position: fixed;
            top: 100px;
            right: 20px;
            background: ${getNotificationColor(type)};
            color: white;
            padding: 1rem 1.5rem;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            z-index: 10000;
            transform: translateX(400px);
            transition: transform 0.3s ease;
            max-width: 400px;
        `;
        
        document.body.appendChild(notification);
        
        // Animación de entrada
        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
        }, 100);
        
        // Auto-remover después de 5 segundos
        setTimeout(() => {
            notification.style.transform = 'translateX(400px)';
            setTimeout(() => {
                if (notification.parentNode) {
                    notification.parentNode.removeChild(notification);
                }
            }, 300);
        }, 5000);
    }
    
    function getNotificationIcon(type) {
        const icons = {
            error: 'exclamation-circle',
            success: 'check-circle',
            loading: 'spinner fa-spin',
            info: 'info-circle'
        };
        return icons[type] || 'info-circle';
    }
    
    function getNotificationColor(type) {
        const colors = {
            error: '#dc3545',
            success: '#28a745',
            loading: '#17a2b8',
            info: '#007bff'
        };
        return colors[type] || '#007bff';
    }
    
    // Función para reservar pasaje (simulada)
    window.reservarPasaje = function(nombreBus) {
        showNotification(`Reservando pasaje en: ${nombreBus}`, 'success');
        // Aquí iría la lógica real de reserva
    };
    
    // Animación de elementos al hacer scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Observar elementos para animaciones
    document.querySelectorAll('.destination-card, .search-card, .visa-card').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
});
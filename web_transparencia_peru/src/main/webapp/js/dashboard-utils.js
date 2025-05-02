/**
 * Portal de Transparencia Perú - Dashboard Utilities
 * Funciones comunes para todos los paneles de usuario
 */

// Módulo principal de utilidades
const DashboardUtils = {
    /**
     * Inicializa componentes comunes para todas las páginas de panel
     */
    init: function () {
        this.setupTooltips();
        this.setupDataTables();
        this.setupAnimations();
        this.setupChartDefaults();
        this.setupCardHovers();
    },

    /**
     * Configura los tooltips de Bootstrap en toda la página
     */
    setupTooltips: function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl, {
                boundary: document.body
            });
        });
    },

    /**
     * Configura tablas de datos con opciones predeterminadas
     * @param {string} selector - Selector CSS para las tablas que deben inicializarse
     * @param {Object} options - Opciones personalizadas para DataTables
     */
    setupDataTables: function (selector = '.data-table', options = {}) {
        if ($.fn.DataTable && $(selector).length > 0) {
            // Opciones predeterminadas
            const defaultOptions = {
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
                },
                pageLength: 10,
                lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Todos"]],
                responsive: true,
                stateSave: true
            };

            // Combinar opciones predeterminadas con las personalizadas
            const mergedOptions = {...defaultOptions, ...options};

            // Inicializar cada tabla
            $(selector).each(function () {
                // Si ya es una DataTable, destruirla primero
                if ($.fn.DataTable.isDataTable(this)) {
                    $(this).DataTable().destroy();
                }

                // Inicializar con opciones
                $(this).DataTable(mergedOptions);
            });
        }
    },

    /**
     * Añade animaciones a elementos
     */
    setupAnimations: function () {
        $('.fade-in-element').addClass('fade-in');

        // Animaciones al hacer scroll
        this.setupScrollAnimations();
    },

    /**
     * Configura animaciones al hacer scroll para elementos
     */
    setupScrollAnimations: function () {
        const animateElements = document.querySelectorAll('.animate-on-scroll');

        if (animateElements.length > 0) {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('fade-in');
                    }
                });
            });

            animateElements.forEach(el => {
                observer.observe(el);
            });
        }
    },

    /**
     * Configura valores predeterminados para gráficos de Chart.js
     */
    setupChartDefaults: function () {
        if (window.Chart) {
            // Colores coherentes con el sistema
            const primaryColor = getComputedStyle(document.documentElement).getPropertyValue('--primary').trim() || '#2d63c8';
            const secondaryColor = getComputedStyle(document.documentElement).getPropertyValue('--secondary').trim() || '#6c757d';

            // Configuración global para todos los gráficos
            Chart.defaults.font.family = "'Inter', system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif";
            Chart.defaults.color = '#64748b';
            Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(45, 99, 200, 0.9)';
            Chart.defaults.plugins.legend.labels.usePointStyle = true;
        }
    },

    /**
     * Mejora el efecto hover en las tarjetas
     */
    setupCardHovers: function () {
        document.querySelectorAll('.card').forEach(card => {
            card.addEventListener('mouseenter', function () {
                this.classList.add('card-hover');
            });

            card.addEventListener('mouseleave', function () {
                this.classList.remove('card-hover');
            });
        });
    },

    /**
     * Formatea números como moneda en soles (S/)
     * @param {number} amount - Cantidad a formatear
     * @returns {string} Cantidad formateada como moneda
     */
    formatCurrency: function (amount) {
        return new Intl.NumberFormat('es-PE', {
            style: 'currency',
            currency: 'PEN',
            maximumFractionDigits: 2,
            minimumFractionDigits: 2
        }).format(amount);
    },

    /**
     * Formatea fechas en formato peruano (DD/MM/YYYY)
     * @param {Date|string} date - Fecha a formatear
     * @returns {string} Fecha formateada
     */
    formatDate: function (date) {
        const d = new Date(date);
        return d.toLocaleDateString('es-PE', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric'
        });
    }
};

// Inicializar automáticamente cuando se cargue la página
document.addEventListener('DOMContentLoaded', function () {
    DashboardUtils.init();
});
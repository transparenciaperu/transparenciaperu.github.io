/**
 * Funciones para la gestión de presupuestos
 */

// Función para inicializar la tabla de presupuestos
function inicializarTablaPresupuestos() {
    return $('#tablaPresupuestos').DataTable({
        language: {
            url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
        },
        pageLength: 10,
        responsive: true,
        order: [[1, 'desc']], // Ordenar por año descendente
        columnDefs: [
            {targets: 6, orderable: false} // Deshabilitar ordenamiento en columna de acciones
        ]
    });
}

// Función para confirmar eliminación
function confirmarEliminacion(id, nombre) {
    document.getElementById('idPresupuestoEliminar').value = id;
    document.getElementById('nombrePresupuestoEliminar').textContent = nombre;

    var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarPresupuestoModal'));
    eliminarModal.show();
}

// Función para ver detalle de presupuesto
function verDetallePresupuesto(id) {
    // Mostrar modal con spinner de carga
    $('#loadingSpinner').show();
    $('#detallePresupuestoContent').hide();
    $('#errorMessage').hide();

    // Almacenar el ID para el botón de edición
    $('#btnEditarDesdeDetalle').data('id', id);

    // Configurar evento del botón editar
    $('#btnEditarDesdeDetalle').off('click').on('click', function () {
        var detalleModal = bootstrap.Modal.getInstance(document.getElementById('detallePresupuestoModal'));
        detalleModal.hide();
        window.location.href = contextPath + '/admin.do?accion=editarPresupuesto&id=' + id;
    });

    // Mostrar el modal
    var detalleModal = new bootstrap.Modal(document.getElementById('detallePresupuestoModal'));
    detalleModal.show();

    // Obtener datos de la tabla
    setTimeout(function () {
        // Buscar la fila en la tabla para obtener los datos
        var table = $('#tablaPresupuestos').DataTable();
        var datos = null;

        // Recorrer todas las filas buscando el ID
        table.rows().every(function () {
            var data = this.data();
            if (data[0] == id) {
                datos = data;
                return false; // Salir del loop
            }
        });

        if (datos) {
            // Llenar los campos de detalle
            $('#detalleId').text(datos[0]);
            $('#detalleAnio').text(datos[1]);
            $('#detalleEntidad').text(datos[2]);
            // Limpiar formato HTML que pudiera estar en el monto
            var montoTexto = datos[3].replace(/&nbsp;/g, ' ').replace(/<[^>]*>/g, '');
            $('#detalleMonto').text(montoTexto);
            $('#detalleTipoEntidad').text('Entidad Pública');
            $('#detalleNivelGobierno').text('Nacional'); // Valor por defecto

            // Mostrar contenido
            $('#loadingSpinner').hide();
            $('#detallePresupuestoContent').show();
        } else {
            // Mostrar mensaje de error
            $('#loadingSpinner').hide();
            $('#errorText').text('No se pudo cargar la información del presupuesto.');
            $('#errorMessage').show();
        }
    }, 800); // Retardo simulado
}

// Función para inicializar componentes cuando el documento está listo
$(document).ready(function () {
    // Inicializar DataTables
    var tabla = inicializarTablaPresupuestos();

    // Inicializar tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    });

    // Manejar filtros
    $('#btnAplicarFiltros').click(function () {
        var anioFiltro = $('#filtroAnio').val().toLowerCase();
        var entidadFiltro = $('#filtroEntidad').val().toLowerCase();
        var montoFiltro = parseFloat($('#filtroMonto').val()) || 0;

        $.fn.dataTable.ext.search.push(
            function (settings, data, dataIndex) {
                var anio = data[1].toLowerCase(); // Columna Año
                var entidad = data[2].toLowerCase(); // Columna Entidad
                var monto = parseFloat(data[3].replace(/[^\d.-]/g, '')) || 0; // Columna Monto (limpia formato)

                var anioOK = anioFiltro === '' || anio.includes(anioFiltro);
                var entidadOK = entidadFiltro === '' || entidad.includes(entidadFiltro);
                var montoOK = monto >= montoFiltro;

                return anioOK && entidadOK && montoOK;
            }
        );

        tabla.draw();

        // Eliminar el filtro después de aplicarlo
        $.fn.dataTable.ext.search.pop();
    });

    $('#btnLimpiarFiltros').click(function () {
        $('#filtroAnio').val('');
        $('#filtroEntidad').val('');
        $('#filtroMonto').val('');
        tabla.search('').columns().search('').draw();
    });
});
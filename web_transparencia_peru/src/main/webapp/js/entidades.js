/**
 * Script para la gestión de entidades públicas en el panel de administración
 */
$(document).ready(function () {
    console.log("Inicializando funcionalidad de entidades públicas...");

    // Inicializar DataTables
    var tabla = $('#tablaEntidades').DataTable({
        language: {
            url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
        },
        pageLength: 10,
        responsive: true,
        order: [[1, 'asc']], // Ordenar por nombre de entidad
        columnDefs: [
            {orderable: false, targets: 6} // No ordenar la columna de acciones
        ],
        // Opciones para debug
        retrieve: true, // Permite reinicializar la tabla
        searching: true, // Habilitar búsqueda
        info: true, // Mostrar información
        paging: true // Habilitar paginación
    });

    console.log("DataTable inicializado. Columnas detectadas: " + tabla.columns().count());

    // Verificar estructura de la tabla para diagnóstico
    console.log("Estructura de la tabla:");
    console.log("- Columnas en thead: " + $('#tablaEntidades thead th').length);
    console.log("- Filas en tbody: " + $('#tablaEntidades tbody tr').length);
    if ($('#tablaEntidades tbody tr').length > 0) {
        console.log("- Columnas en primera fila: " + $('#tablaEntidades tbody tr:first td').length);
    }

    // Inicializar tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    });

    // Inicializar Select2 para mejorar los selectores
    if ($.fn.select2) {
        $('.select2').select2({
            width: '100%',
            placeholder: "Seleccione una opción"
        });
    }

    // Event listeners para manejo de formularios
    setupFormListeners();

    // Aplicar filtros en la tabla
    $('#btnAplicarFiltros').click(function () {
        aplicarFiltros();
    });

    // Limpiar filtros
    $('#btnLimpiarFiltros').click(function () {
        limpiarFiltros();
    });

    // Manejar cambio de nivel de gobierno
    $('#nivelGobiernoId, #editNivelGobiernoId').change(function () {
        mostrarOcultarRegion($(this).attr('id'));
    });

    console.log("Inicialización completa.");
});

/**
 * Configura los listeners para los formularios
 */
function setupFormListeners() {
    // Formulario de nueva entidad
    $('#formNuevaEntidad').on('submit', function (e) {
        e.preventDefault();

        // Validación básica
        var nombre = $('#nombre').val();
        var tipo = $('#tipo').val();
        var nivelGobierno = $('#nivelGobiernoId').val();

        if (!nombre || !tipo || !nivelGobierno) {
            mostrarAlerta('Debe completar los campos obligatorios (Nombre, Tipo y Nivel de Gobierno)', 'danger');
            return false;
        }

        // Si es nivel regional o municipal, verificar que se seleccionó una región
        if (nivelGobierno !== '1' && !$('#regionId').val()) {
            mostrarAlerta('Debe seleccionar una región para entidades de nivel Regional o Municipal', 'danger');
            return false;
        }

        console.log("Enviando formulario de nueva entidad...");
        this.submit();
    });

    // Formulario de edición de entidad
    $('#formEditarEntidad').on('submit', function (e) {
        e.preventDefault();

        // Validación básica
        var nombre = $('#editNombre').val();
        var tipo = $('#editTipo').val();
        var nivelGobierno = $('#editNivelGobiernoId').val();

        if (!nombre || !tipo || !nivelGobierno) {
            mostrarAlerta('Debe completar los campos obligatorios (Nombre, Tipo y Nivel de Gobierno)', 'danger', 'alertaEditar');
            return false;
        }

        // Si es nivel regional o municipal, verificar que se seleccionó una región
        if (nivelGobierno !== '1' && !$('#editRegionId').val()) {
            mostrarAlerta('Debe seleccionar una región para entidades de nivel Regional o Municipal', 'danger', 'alertaEditar');
            return false;
        }

        // Verificar y preparar el campo sitioWeb
        var sitioWeb = $('#editSitioWeb').val().trim();
        if (sitioWeb && !sitioWeb.startsWith('http://') && !sitioWeb.startsWith('https://')) {
            $('#editSitioWeb').val('https://' + sitioWeb);
        }

        console.log("Enviando formulario de edición de entidad...");
        console.log("Datos del formulario:", {
            id: $('#editId').val(),
            nombre: nombre,
            tipo: tipo,
            nivelGobierno: nivelGobierno,
            regionId: $('#editRegionId').val(),
            direccion: $('#editDireccion').val(),
            telefono: $('#editTelefono').val(),
            email: $('#editEmail').val(),
            sitioWeb: $('#editSitioWeb').val()
        });

        this.submit();
    });
}

/**
 * Función para editar una entidad
 * @param {Object} entidad - Datos de la entidad a editar
 */
function editarEntidad(entidad) {
    console.log("Editando entidad:", entidad);

    try {
        // Sanear y preparar los datos
        if (!entidad.sitioWeb) entidad.sitioWeb = '';
        if (!entidad.direccion) entidad.direccion = '';
        if (!entidad.telefono) entidad.telefono = '';
        if (!entidad.email) entidad.email = '';

        console.log("Datos sanitizados de la entidad:", entidad);

        // Rellenar los campos del modal
        $('#editId').val(entidad.id);
        $('#editNombre').val(entidad.nombre);
        $('#editTipo').val(entidad.tipo);
        $('#editDireccion').val(entidad.direccion);
        $('#editNivelGobiernoId').val(entidad.nivelGobiernoId);
        $('#editRegionId').val(entidad.regionId);
        $('#editTelefono').val(entidad.telefono);
        $('#editEmail').val(entidad.email);
        $('#editSitioWeb').val(entidad.sitioWeb);

        // Mostrar/ocultar el selector de regiones según nivel de gobierno
        mostrarOcultarRegion('editNivelGobiernoId');

        // Mostrar el modal
        var editarModal = new bootstrap.Modal(document.getElementById('editarEntidadModal'));
        editarModal.show();

        console.log("Modal de edición mostrado correctamente");
    } catch (error) {
        console.error("Error al abrir el modal de edición:", error);
        mostrarAlerta("Error al cargar el formulario de edición. Por favor, inténtelo de nuevo.", "danger");
    }
}

/**
 * Función para confirmar la eliminación de una entidad
 * @param {number} id - ID de la entidad
 * @param {string} nombre - Nombre de la entidad
 */
function confirmarEliminacion(id, nombre) {
    console.log("Confirmando eliminación de la entidad:", id, nombre);

    try {
        $('#idEntidadEliminar').val(id);
        $('#nombreEntidadEliminar').text(nombre);

        // Mostrar el modal de confirmación
        var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarEntidadModal'));
        eliminarModal.show();

        console.log("Modal de confirmación mostrado correctamente");
    } catch (error) {
        console.error("Error al abrir el modal de confirmación:", error);
        mostrarAlerta("Error al cargar la confirmación. Por favor, inténtelo de nuevo.", "danger");
    }
}

/**
 * Función para mostrar u ocultar el selector de regiones según el nivel de gobierno
 * @param {string} selectorId - ID del selector de nivel de gobierno
 */
function mostrarOcultarRegion(selectorId) {
    var idPrefix = selectorId === 'nivelGobiernoId' ? '' : 'edit';
    var nivelGobierno = $('#' + selectorId).val();
    var divRegion = $('#' + idPrefix + 'div-region');
    var selectRegion = $('#' + idPrefix + 'regionId');

    if (nivelGobierno === '1') { // Nacional
        divRegion.hide();
        selectRegion.val('');
        selectRegion.prop('required', false);
    } else { // Regional o Municipal
        divRegion.show();
        selectRegion.prop('required', true);
    }
}

/**
 * Función para aplicar filtros a la tabla de entidades
 */
function aplicarFiltros() {
    var nivelFiltro = $('#filtroNivel').val();
    var regionFiltro = $('#filtroRegion').val();
    var tipoFiltro = $('#filtroTipo').val();
    var tabla = $('#tablaEntidades').DataTable();

    // Limpiar filtros anteriores
    tabla.search('').columns().search('').draw();

    // Aplicar filtros personalizados
    $.fn.dataTable.ext.search.push(
        function (settings, data, dataIndex) {
            var nivel = data[3]; // Columna de nivel de gobierno
            var region = data[4]; // Columna de región
            var tipo = data[2];   // Columna de tipo

            var nivelOK = !nivelFiltro || nivel.includes(
                nivelFiltro === '1' ? 'Nacional' :
                    nivelFiltro === '2' ? 'Regional' : 'Municipal'
            );

            var regionOK = !regionFiltro || region.includes($('#filtroRegion option:selected').text());
            var tipoOK = !tipoFiltro || tipo === tipoFiltro;

            return nivelOK && regionOK && tipoOK;
        }
    );

    // Redibujar la tabla con los filtros aplicados
    tabla.draw();

    // Limpiar la función de filtro personalizado
    $.fn.dataTable.ext.search.pop();

    console.log("Filtros aplicados: Nivel=" + nivelFiltro + ", Región=" + regionFiltro + ", Tipo=" + tipoFiltro);
}

/**
 * Función para limpiar los filtros de la tabla
 */
function limpiarFiltros() {
    $('#filtroNivel').val('');
    $('#filtroRegion').val('');
    $('#filtroTipo').val('');

    // Restaurar la tabla a su estado original
    $('#tablaEntidades').DataTable().search('').columns().search('').draw();

    console.log("Filtros limpiados");
}

/**
 * Muestra una alerta con un mensaje específico
 * @param {string} mensaje - Mensaje a mostrar
 * @param {string} tipo - Tipo de alerta (success, danger, warning, info)
 * @param {string} contenedor - ID del elemento donde mostrar la alerta (opcional)
 */
function mostrarAlerta(mensaje, tipo, contenedor) {
    tipo = tipo || 'info';

    var alertHTML = '<div class="alert alert-' + tipo + ' alert-dismissible fade show" role="alert">' +
        '<i class="bi bi-info-circle me-2"></i> ' + mensaje +
        '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
        '</div>';

    if (contenedor) {
        $('#' + contenedor).html(alertHTML);
    } else {
        // Mostrar en la parte superior del contenido principal
        var alertContainer = $('.title-section').next('.alert');
        if (alertContainer.length) {
            alertContainer.remove();
        }
        $('.title-section').after(alertHTML);
    }

    // Desaparecer automáticamente después de 5 segundos
    setTimeout(function () {
        $('.alert').alert('close');
    }, 5000);
}

/**
 * Función para ver detalle de una entidad
 * @param {number} id - ID de la entidad
 */
function verDetalleEntidad(id) {
    window.location.href = contextPath + "/entidades.do?accion=verDetalle&id=" + id;
}
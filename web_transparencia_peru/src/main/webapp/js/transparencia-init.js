/**
 * Script para inicializar la página de transparencia
 * Este script es especializado para manejar los elementos de la interfaz de usuario
 * en transparencia.jsp sin interferir con documento-transparencia-nuevo.js
 */
$(document).ready(function () {
    console.log("Inicializando scripts de transparencia-init.js");

    // Desactivar cualquier otro manejador para verDocumentoModal
    $('#verDocumentoModal').off('show.bs.modal');
    $('#verDocumentoModal').off('shown.bs.modal');

    // Inicializar DataTables en las tablas
    $('table:not(.dataTable)').each(function () {
        $(this).DataTable({
            "language": {
                "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
            },
            "pageLength": 5,
            "lengthChange": false,
            "searching": false,
            "info": false,
            "paging": true
        });
    });

    // Establecer la fecha actual por defecto en los campos de fecha
    const today = new Date();
    const formattedDate = today.toISOString().substr(0, 10);
    $('#fechaPublicacion').val(formattedDate);

    // Manejar la eliminación de documentos
    $('#eliminarDocumentoModal').on('show.bs.modal', function (e) {
        const button = $(e.relatedTarget);
        const id = button.data('id') || 0;
        const titulo = button.data('titulo');

        if (id && id > 0) {
            $('#documentoIdEliminar').val(id);
            $('#nombreDocumentoEliminar').text('"' + (titulo || 'documento seleccionado') + '"');
        } else {
            $('#documentoIdEliminar').val(0);
            $('#nombreDocumentoEliminar').text('documento');
        }
    });

    // Configurar datos dinámicos al abrir los modales de sección
    $('#editarSeccionModal').on('show.bs.modal', function (e) {
        const seccion = $(e.relatedTarget).data('seccion');

        // Aquí se cargarían los datos reales de la sección desde el servidor
        const secciones = {
            'datos-generales': {
                titulo: 'Datos Generales',
                descripcion: 'Información general de la entidad según lo establecido en la Ley de Transparencia.',
                orden: 1
            },
            'planeamiento': {
                titulo: 'Planeamiento y Organización',
                descripcion: 'Información sobre instrumentos de gestión, planes estratégicos y estructura organizativa.',
                orden: 2
            },
            'presupuesto': {
                titulo: 'Presupuesto',
                descripcion: 'Información presupuestal de la entidad.',
                orden: 3
            },
            'proyectos': {
                titulo: 'Proyectos e Inversiones',
                descripcion: 'Información sobre proyectos de inversión e INFOBRAS.',
                orden: 4
            },
            'contrataciones': {
                titulo: 'Contrataciones',
                descripcion: 'Información sobre procesos de selección y adquisiciones.',
                orden: 5
            },
            'personal': {
                titulo: 'Personal',
                descripcion: 'Información sobre personal y remuneraciones.',
                orden: 6
            }
        };

        const seccionData = secciones[seccion] || secciones['datos-generales'];

        $('#tituloSeccion').val(seccionData.titulo);
        $('#descripcionSeccion').val(seccionData.descripcion);
        $('#ordenSeccion').val(seccionData.orden);
    });

    // Validación de formularios
    const formPublicar = document.getElementById('formPublicarDocumento');
    if (formPublicar) {
        formPublicar.addEventListener('submit', function (event) {
            if (!formPublicar.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            formPublicar.classList.add('was-validated');
        }, false);
    }

    const formEditar = document.getElementById('formEditarDocumento');
    if (formEditar) {
        formEditar.addEventListener('submit', function (event) {
            if (!formEditar.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            formEditar.classList.add('was-validated');
        }, false);
    }
});
// Funciones para manejar los documentos de transparencia
$(document).ready(function () {
    // Manejar la visualización del documento
    $('#verDocumentoModal').on('show.bs.modal', function (e) {
        const button = $(e.relatedTarget);
        const documentoId = button.data('id') || 0;

        console.log("Abriendo modal de visualización, ID:", documentoId);

        // Mostrar spinner de carga y ocultar detalles
        $('#loadingDocumento').removeClass('d-none');
        $('#detallesDocumento').addClass('d-none');

        if (documentoId && documentoId > 0) {
            // Construir la URL para la petición AJAX
            const contextPath = $('meta[name="context-path"]').attr('content') || '';
            const ajaxUrl = contextPath + '/funcionario.do';

            // Hacer petición AJAX para obtener los detalles del documento
            $.ajax({
                url: ajaxUrl,
                type: 'GET',
                dataType: 'json',
                data: {
                    accion: 'verDocumento',
                    id: documentoId,
                    format: 'json'
                },
                success: function (data) {
                    console.log("Datos recibidos:", data);

                    if (!data || $.isEmptyObject(data)) {
                        $('#infoDocumento').html('<div class="alert alert-warning">No se encontró información para este documento.</div>');
                        $('#loadingDocumento').addClass('d-none');
                        $('#detallesDocumento').removeClass('d-none');
                        return;
                    }

                    // Llenar la información en el modal
                    let html = `
                        <h5>${data.titulo || 'Sin título'}</h5>
                        <p class="text-muted mb-3">${data.descripcion || 'Sin descripción'}</p>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-2">
                                    <strong>ID del documento:</strong> ${data.id}
                                </div>
                                <div class="mb-2">
                                    <strong>Categoría:</strong> ${data.categoria || 'No especificada'}
                                </div>
                                <div class="mb-2">
                                    <strong>Periodo de Referencia:</strong> ${data.periodoReferencia || 'No especificado'}
                                </div>
                                <div class="mb-2">
                                    <strong>Fecha de publicación:</strong> ${data.fechaPublicacion || 'No disponible'}
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-2">
                                    <strong>Estado:</strong> <span class="badge bg-${data.estado === 'Publicado' ? 'success' : 'warning text-dark'}">${data.estado || 'No definido'}</span>
                                </div>
                                <div class="mb-2">
                                    <strong>Publicado por:</strong> ${data.nombreUsuario || 'No disponible'}
                                </div>
                                <div class="mb-2">
                                    <strong>Entidad:</strong> ${data.nombreEntidad || 'No disponible'}
                                </div>
                                <div class="mb-2">
                                    <strong>Archivo:</strong> 
                                    <a href="${contextPath + '/' + (data.rutaArchivo || '#')}" 
                                       target="_blank" class="btn btn-sm btn-outline-primary ${!data.rutaArchivo ? 'disabled' : ''}">
                                        <i class="bi bi-file-earmark"></i> ${data.rutaArchivo ? data.rutaArchivo.split('/').pop() : 'No disponible'}
                                    </a>
                                </div>
                            </div>
                        </div>
                    `;

                    $('#infoDocumento').html(html);

                    // Actualizar el visor de documentos
                    const rutaCompleta = data.rutaArchivo ? (contextPath + '/' + data.rutaArchivo) : '';

                    if (data.rutaArchivo) {
                        if (data.tipoArchivo && data.tipoArchivo.includes('pdf')) {
                            $('#visorDocumento').attr('src', rutaCompleta);
                        } else {
                            const urlEncode = encodeURIComponent(window.location.origin + rutaCompleta);
                            $('#visorDocumento').attr('src', 'https://docs.google.com/viewer?embedded=true&url=' + urlEncode);
                        }
                    } else {
                        // No hay archivo disponible
                        $('#visorDocumento').attr('src', 'about:blank');
                    }

                    // Ocultar spinner y mostrar detalles
                    $('#loadingDocumento').addClass('d-none');
                    $('#detallesDocumento').removeClass('d-none');

                    // También actualizar el área de depuración
                    $('#debugDocumentoInfo').text(JSON.stringify(data, null, 2));
                },
                error: function (xhr, status, error) {
                    // Mostrar mensaje de error detallado
                    console.error("Error al cargar documento:", error);
                    console.error("Estado:", status);
                    console.error("Respuesta:", xhr.responseText);

                    $('#infoDocumento').html(`
                        <div class="alert alert-danger">
                            <h5><i class="bi bi-exclamation-triangle-fill me-2"></i> Error al cargar los detalles del documento</h5>
                            <p>Se produjo un error al intentar cargar la información. Por favor, intente nuevamente.</p>
                            <p><small>Código: ${xhr.status}, Error: ${error || 'Error desconocido'}</small></p>
                        </div>
                    `);
                    $('#loadingDocumento').addClass('d-none');
                    $('#detallesDocumento').removeClass('d-none');
                }
            });
        } else {
            // ID de documento inválido
            $('#infoDocumento').html('<div class="alert alert-warning">No se especificó un documento válido para visualizar.</div>');
            $('#loadingDocumento').addClass('d-none');
            $('#detallesDocumento').removeClass('d-none');
        }
    });

    // Manejar el modal de edición
    $('#editarDocumentoModal').on('show.bs.modal', function (e) {
        const button = $(e.relatedTarget);
        const id = button.data('id') || 0;

        console.log("Abriendo modal de edición, ID:", id);

        if (id && id > 0) {
            // Establecer el ID del documento a editar
            $('#editDocumentoId').val(id);

            // Obtener el contexto de la aplicación
            const contextPath = $('meta[name="context-path"]').attr('content') || '';

            // Hacer petición AJAX para obtener los datos del documento
            $.ajax({
                url: contextPath + '/funcionario.do',
                type: 'GET',
                dataType: 'json',
                data: {
                    accion: 'verDocumento',
                    id: id,
                    format: 'json'
                },
                success: function (data) {
                    console.log("Datos para edición:", data);

                    // Llenar los campos del formulario con los datos del documento
                    $('#editTituloDocumento').val(data.titulo);
                    $('#editDescripcionDocumento').val(data.descripcion);

                    // Seleccionar la categoría correcta
                    $('#editCategoriaDocumento').val(data.categoria);
                    $('#editCategoriaDocumento').prop('disabled', false); // Habilitar para edición

                    // Establece período de referencia
                    $('#editPeriodoReferencia').val(data.periodoReferencia);

                    // Convertir fecha al formato yyyy-mm-dd para el input date
                    if (data.fechaPublicacion) {
                        $('#editFechaPublicacion').val(data.fechaPublicacion);
                    } else {
                        // Si no hay fecha, usar la fecha actual
                        const hoy = new Date();
                        $('#editFechaPublicacion').val(hoy.toISOString().split('T')[0]);
                    }

                    // Estado del documento (checkbox)
                    $('#editEstadoDocumento').prop('checked', data.estado === 'Publicado');

                    // Campo oculto para la ruta del archivo
                    $('#editRutaArchivo').val(data.rutaArchivo);

                    // Campo oculto para el tipo de archivo
                    $('#editTipoArchivo').val(data.tipoArchivo);

                    // Mostrar el nombre del archivo actual
                    if (data.rutaArchivo) {
                        // Primero eliminamos cualquier mensaje anterior
                        $('#editArchivoDocumento').next('.form-text').nextAll('.form-text').remove();

                        const nombreArchivo = data.rutaArchivo.split('/').pop();
                        $('<div class="form-text mt-2">Archivo actual: <strong>' + nombreArchivo + '</strong></div>')
                            .insertAfter($('#editArchivoDocumento').next('.form-text'));
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error al cargar los datos del documento:', error);
                    alert('Error al cargar los datos del documento. Consulte la consola para más detalles.');
                }
            });
        }
    });

    // Limpiar información adicional al cerrar el modal de edición
    $('#editarDocumentoModal').on('hidden.bs.modal', function () {
        $('#editArchivoDocumento').next('.form-text').nextAll('.form-text').remove();
    });
});
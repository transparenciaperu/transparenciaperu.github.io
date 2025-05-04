/**
 * Script para manejar la visualización de documentos
 * Implementación simplificada y robusta
 */
$(document).ready(function () {
    console.log("Inicializando visor de documentos...");

    // Función para obtener el contexto de la aplicación
    function getContextPath() {
        return $('meta[name="context-path"]').attr('content') || '';
    }

    // Eliminar manejadores anteriores para evitar duplicidad
    $('#verDocumentoModal').off('show.bs.modal');

    // Configurar el modal de visualización de documento
    $('#verDocumentoModal').on('show.bs.modal', function (e) {
        const button = $(e.relatedTarget);
        const documentoId = button.data('id') || 0;

        console.log("Abriendo detalles de documento, ID:", documentoId);

        // Mostrar spinner y ocultar contenido y errores
        $('#loadingDocumentoDetalles').show();
        $('#contenidoDocumentoDetalles').hide();
        $('#errorDocumentoDetalles').hide();

        if (!documentoId || documentoId <= 0) {
            mostrarError("No se especificó un documento válido.");
            return;
        }

        // Construir la URL para la petición AJAX
        const contextPath = getContextPath();
        const ajaxUrl = contextPath + '/funcionario.do';

        // Realizar la petición AJAX para obtener los datos del documento
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
                console.log("Datos del documento recibidos:", data);

                if (!data || $.isEmptyObject(data)) {
                    mostrarError("No se encontraron datos para este documento.");
                    return;
                }

                // Actualizar los campos del modal con los datos recibidos
                $('#tituloDocumentoDetalle').text(data.titulo || 'Sin título');
                $('#descripcionDocumentoDetalle').text(data.descripcion || 'Sin descripción');
                $('#idDocumentoDetalle').text(data.id || '');
                $('#categoriaDocumentoDetalle').text(data.categoria || 'No especificada');
                $('#periodoDocumentoDetalle').text(data.periodoReferencia || 'No especificado');
                $('#fechaDocumentoDetalle').text(data.fechaPublicacion || 'No disponible');

                // Estado con formato de badge
                const estadoHtml = data.estado === 'Publicado'
                    ? '<span class="badge bg-success">Publicado</span>'
                    : '<span class="badge bg-warning text-dark">' + (data.estado || 'No definido') + '</span>';
                $('#estadoDocumentoDetalle').html(estadoHtml);

                $('#autorDocumentoDetalle').text(data.nombreUsuario || 'No disponible');

                // Enlace al archivo
                if (data.rutaArchivo) {
                    const archivoUrl = contextPath + '/' + data.rutaArchivo;
                    const nombreArchivo = data.rutaArchivo.split('/').pop();

                    $('#archivoDocumentoDetalle').html(`
                        <div class="alert alert-info">
                            <strong>Archivo:</strong> 
                            <a href="${archivoUrl}" target="_blank" class="btn btn-sm btn-primary ms-2">
                                <i class="bi bi-file-earmark"></i> ${nombreArchivo}
                            </a>
                        </div>
                    `);

                    // Configurar la vista previa
                    if (data.tipoArchivo && data.tipoArchivo.includes('pdf')) {
                        // Si es PDF, mostrar directamente
                        $('#previewDocumentoDetalle').attr('src', archivoUrl);
                    } else {
                        // Para otros tipos, usar el visor de Google
                        const urlEncode = encodeURIComponent(window.location.origin + archivoUrl);
                        $('#previewDocumentoDetalle').attr('src',
                            'https://docs.google.com/viewer?embedded=true&url=' + urlEncode);
                    }
                } else {
                    $('#archivoDocumentoDetalle').html('<div class="alert alert-warning">No hay archivo disponible para este documento.</div>');
                    $('#previewDocumentoDetalle').attr('src', 'about:blank');
                }

                // Ocultar spinner y mostrar contenido
                $('#loadingDocumentoDetalles').hide();
                $('#contenidoDocumentoDetalles').show();
            },
            error: function (xhr, status, error) {
                console.error("Error al cargar datos del documento:", error);
                console.error("Status:", status);
                console.error("Respuesta:", xhr.responseText);

                mostrarError("Error al cargar los datos del documento: " + (xhr.status + " " + error));
            }
        });
    });

    // Función para mostrar mensajes de error
    function mostrarError(mensaje) {
        $('#mensajeErrorDocumento').text(mensaje || 'No se pudo cargar la información del documento.');
        $('#loadingDocumentoDetalles').hide();
        $('#contenidoDocumentoDetalles').hide();
        $('#errorDocumentoDetalles').show();
    }
});
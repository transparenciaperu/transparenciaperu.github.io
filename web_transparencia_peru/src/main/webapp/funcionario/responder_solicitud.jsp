<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.SolicitudAccesoEntidad" %>
<%
    // Verificar si el usuario está en sesión y es funcionario
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null ||
            (!((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("FUNCIONARIO") &&
                    !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("ADMIN"))) {
        // No es funcionario/admin o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener la solicitud a responder
    SolicitudAccesoEntidad solicitud = (SolicitudAccesoEntidad) request.getAttribute("solicitud");
    if (solicitud == null) {
        // Si no hay solicitud, redirigir a la lista
        response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=listar");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Responder Solicitud - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/funcionario.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body class="funcionario-theme">
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Responder Solicitud</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle me-1"></i><%= usuario.getNombreCompleto() %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="#"><i class="bi bi-person me-1"></i> Perfil</a></li>
                        <li><a class="dropdown-item" href="#"><i class="bi bi-gear me-1"></i> Configuración</a></li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item"
                               href="<%= request.getContextPath() %>/autenticacion.do?accion=cerrar"><i
                                class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
            <div class="sidebar-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="transparencia.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Gestión de Transparencia
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="solicitudes.jsp">
                            <i class="bi bi-envelope-open me-1"></i> Solicitudes de Información
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="reportes.jsp">
                            <i class="bi bi-bar-chart me-1"></i> Reportes
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom title-section">
                <h1 class="h2">Responder Solicitud #<%= solicitud.getId() %>
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="<%= request.getContextPath() %>/solicitud.do?accion=detalle&id=<%= solicitud.getId() %>"
                       class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Volver a Detalle
                    </a>
                </div>
            </div>

            <!-- Resumen de la solicitud -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold">Resumen de la Solicitud</h6>
                    <span class="badge bg-<%= solicitud.getEstadoSolicitudId() == 1 ? "warning text-dark" : solicitud.getEstadoSolicitudId() == 2 ? "primary" : solicitud.getEstadoSolicitudId() == 3 ? "success" : "secondary" %>">
                        <%= solicitud.getEstadoSolicitudId() == 1 ? "Pendiente" : solicitud.getEstadoSolicitudId() == 2 ? "En Proceso" : solicitud.getEstadoSolicitudId() == 3 ? "Atendida" : "Otro" %>
                    </span>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p><strong>Fecha de Solicitud:</strong> <%= solicitud.getFechaSolicitud() %>
                            </p>
                            <p><strong>Ciudadano:</strong> [Nombre del Ciudadano]</p>
                            <p><strong>Tipo de Solicitud:</strong>
                                <%= solicitud.getTipoSolicitudId() == 1 ? "Información Presupuestal" :
                                        solicitud.getTipoSolicitudId() == 2 ? "Información de Proyectos" :
                                                solicitud.getTipoSolicitudId() == 3 ? "Información de Contrataciones" :
                                                        solicitud.getTipoSolicitudId() == 4 ? "Información de Personal" :
                                                                solicitud.getTipoSolicitudId() == 5 ? "Información General" :
                                                                        solicitud.getTipoSolicitudId() == 6 ? "Información Ambiental" : "Otro" %>
                            </p>
                        </div>
                        <div class="col-md-6">
                            <div class="alert alert-warning mb-0">
                                <div class="d-flex">
                                    <div class="me-3">
                                        <i class="bi bi-clock-history fs-4"></i>
                                    </div>
                                    <div>
                                        <strong>Plazo de atención:</strong>
                                        <p class="mb-0">Esta solicitud debe ser atendida antes
                                            del <%= java.time.LocalDate.now().plusDays(10) %> (10 días hábiles).</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <h6 class="mb-3">Descripción de la Solicitud</h6>
                    <div class="p-3 bg-light rounded mb-4">
                        <%= solicitud.getDescripcion() %>
                    </div>
                </div>
            </div>

            <!-- Formulario de respuesta -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Formulario de Respuesta</h6>
                </div>
                <div class="card-body">
                    <form id="formRespuesta" action="<%= request.getContextPath() %>/solicitud.do" method="post"
                          enctype="multipart/form-data">
                        <input type="hidden" name="accion" value="responder">
                        <input type="hidden" name="solicitudId" value="<%= solicitud.getId() %>">

                        <div class="alert alert-info mb-4">
                            <div class="d-flex">
                                <div class="me-3">
                                    <i class="bi bi-info-circle fs-4"></i>
                                </div>
                                <div>
                                    <h5 class="alert-heading">Información Importante</h5>
                                    <p>La respuesta que proporcione será enviada directamente al ciudadano solicitante.
                                        Asegúrese de que la información sea clara, precisa y correcta.</p>
                                    <p class="mb-0">Recuerde que está actuando en nombre de su institución y esta
                                        respuesta queda registrada como documento oficial.</p>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="tipoRespuesta" class="form-label">Tipo de Respuesta</label>
                            <select class="form-select" id="tipoRespuesta" name="tipoRespuesta" required>
                                <option value="">Seleccione tipo de respuesta</option>
                                <option value="completa">Entrega de información completa</option>
                                <option value="parcial">Entrega de información parcial</option>
                                <option value="prorroga">Solicitud de prórroga</option>
                                <option value="rechazo">Denegación de información</option>
                            </select>
                            <div class="invalid-feedback">
                                Por favor seleccione el tipo de respuesta.
                            </div>
                        </div>

                        <div id="bloqueProrroga" class="mb-4" style="display: none;">
                            <div class="card border-primary mb-3">
                                <div class="card-header text-primary">Solicitud de Prórroga</div>
                                <div class="card-body">
                                    <p>La prórroga permite extender el plazo de respuesta por un máximo de 5 días
                                        hábiles adicionales.</p>
                                    <div class="mb-3">
                                        <label for="fechaProrroga" class="form-label">Nueva Fecha de Entrega
                                            Propuesta:</label>
                                        <input type="text" class="form-control date-picker" id="fechaProrroga"
                                               name="fechaProrroga">
                                    </div>
                                    <div class="mb-3">
                                        <label for="motivoProrroga" class="form-label">Justificación de la
                                            Prórroga:</label>
                                        <select class="form-select" id="motivoProrroga" name="motivoProrroga">
                                            <option value="">Seleccione un motivo</option>
                                            <option value="1">Volumen de información solicitada</option>
                                            <option value="2">Complejidad de la búsqueda</option>
                                            <option value="3">Necesidad de análisis especializado</option>
                                            <option value="4">Coordinación con múltiples áreas</option>
                                            <option value="5">Otro motivo (especificar en la respuesta)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="bloqueRechazo" class="mb-4" style="display: none;">
                            <div class="card border-danger mb-3">
                                <div class="card-header text-danger">Denegación de Información</div>
                                <div class="card-body">
                                    <p>Recuerde que toda denegación debe estar justificada en las excepciones
                                        establecidas por ley.</p>
                                    <div class="mb-3">
                                        <label for="motivoRechazo" class="form-label">Motivo del Rechazo:</label>
                                        <select class="form-select" id="motivoRechazo" name="motivoRechazo">
                                            <option value="">Seleccione motivo</option>
                                            <option value="1">Información clasificada como secreta (Seguridad
                                                Nacional)
                                            </option>
                                            <option value="2">Información reservada (Seguridad Pública)</option>
                                            <option value="3">Información confidencial (Datos personales)</option>
                                            <option value="4">Información en proceso deliberativo</option>
                                            <option value="5">Otro motivo (detallar)</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="baseRechazo" class="form-label">Base Legal del Rechazo:</label>
                                        <input type="text" class="form-control" id="baseRechazo" name="baseRechazo"
                                               placeholder="Ej: Artículo 15-B de la Ley N° 27806">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="respuestaTexto" class="form-label">Contenido de la Respuesta</label>
                            <textarea class="form-control" id="respuestaTexto" name="respuestaTexto" rows="10"
                                      required></textarea>
                            <div class="invalid-feedback">
                                Por favor ingrese el contenido de la respuesta.
                            </div>
                            <div class="form-text">
                                Sea claro y específico. Proporcione toda la información solicitada o justifique
                                adecuadamente su denegación.
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="documentosAdjuntos" class="form-label">Documentos Adjuntos (opcional)</label>
                            <input type="file" class="form-control" id="documentosAdjuntos" name="documentosAdjuntos"
                                   multiple>
                            <div class="form-text">
                                Puede adjuntar hasta 5 archivos (máximo 10MB en total). Formatos permitidos: PDF, Word,
                                Excel, PowerPoint, JPG, PNG.
                            </div>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="confirmacion" name="confirmacion"
                                   required>
                            <label class="form-check-label" for="confirmacion">
                                Confirmo que la información proporcionada es correcta, completa y estoy autorizado para
                                enviarla
                            </label>
                            <div class="invalid-feedback">
                                Debe confirmar que la información es correcta y está autorizado.
                            </div>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="<%= request.getContextPath() %>/solicitud.do?accion=listar"
                               class="btn btn-secondary me-md-2">Cancelar</a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send me-1"></i> Enviar Respuesta
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
<script>
    $(document).ready(function () {
        // Inicializar datepicker
        flatpickr(".date-picker", {
            locale: "es",
            dateFormat: "Y-m-d",
            minDate: "today",
            maxDate: new Date().fp_incr(15) // Máximo 15 días desde hoy
        });

        // Mostrar/ocultar secciones según el tipo de respuesta
        $('#tipoRespuesta').change(function () {
            const tipoRespuesta = $(this).val();

            // Ocultar todos los bloques condicionales
            $('#bloqueProrroga, #bloqueRechazo').hide();

            // Mostrar el bloque correspondiente
            if (tipoRespuesta === 'prorroga') {
                $('#bloqueProrroga').show();
                $('#fechaProrroga, #motivoProrroga').prop('required', true);
            } else {
                $('#fechaProrroga, #motivoProrroga').prop('required', false);
            }

            if (tipoRespuesta === 'rechazo') {
                $('#bloqueRechazo').show();
                $('#motivoRechazo, #baseRechazo').prop('required', true);
            } else {
                $('#motivoRechazo, #baseRechazo').prop('required', false);
            }
        });

        // Validación del formulario
        const form = document.querySelector('#formRespuesta');
        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            }
            form.classList.add('was-validated');
        });
    });
</script>
</body>
</html>
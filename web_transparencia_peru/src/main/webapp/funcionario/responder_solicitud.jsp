<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.SolicitudAccesoEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.RespuestaSolicitudEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.SolicitudAccesoModelo" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%
    // Verificar si el usuario está en sesión y es funcionario
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("FUNCIONARIO")) {
        // No es funcionario o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener la solicitud del request attribute
    SolicitudAccesoEntidad solicitud = (SolicitudAccesoEntidad) request.getAttribute("solicitud");
    if (solicitud == null) {
        // No hay solicitud, redirigir a la lista
        session.setAttribute("mensaje", "No se encontró la solicitud solicitada.");
        response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=listar");
        return;
    }

    // Si ya está atendida o rechazada, no se puede responder
    if (solicitud.getEstadoSolicitudId() == 3 || solicitud.getEstadoSolicitudId() == 5) {
        session.setAttribute("mensaje", "Esta solicitud ya ha sido respondida.");
        response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=detalle&id=" + solicitud.getId());
        return;
    }

    // Calcular días restantes
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    final long DIAS_LIMITE = 10; // 10 días hábiles

    String plazoText = "";
    String plazoClass = "";
    boolean esUrgente = false;

    Date fechaSolicitud = solicitud.getFechaSolicitud();
    Date hoy = new Date();
    long diferenciaDias = TimeUnit.DAYS.convert(hoy.getTime() - fechaSolicitud.getTime(), TimeUnit.MILLISECONDS);
    long diasFaltantes = DIAS_LIMITE - diferenciaDias;

    if (diasFaltantes <= 0) {
        plazoText = "VENCIDA - Se requiere respuesta urgente";
        plazoClass = "text-danger fw-bold";
        esUrgente = true;
    } else if (diasFaltantes <= 3) {
        plazoText = diasFaltantes + " días restantes (URGENTE)";
        plazoClass = "text-danger";
        esUrgente = true;
    } else {
        plazoText = diasFaltantes + " días restantes";
        plazoClass = "text-warning";
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
        <a class="navbar-brand" href="#">Portal de Transparencia | Responder Solicitud #<%= solicitud.getId() %>
        </a>
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
                        <i class="bi bi-arrow-left me-1"></i> Volver al Detalle
                    </a>
                </div>
            </div>

            <% if (esUrgente) { %>
            <div class="alert alert-danger fade-in mb-4">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                    </div>
                    <div>
                        <h5 class="mb-1">¡Solicitud urgente!</h5>
                        <p class="mb-0"><%= plazoText %>
                        </p>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="alert alert-warning fade-in mb-4">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <i class="bi bi-info-circle-fill fs-3"></i>
                    </div>
                    <div>
                        <h5 class="mb-1">Plazo de respuesta</h5>
                        <p class="mb-0"><%= plazoText %>
                        </p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Resumen de la solicitud -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Resumen de la Solicitud</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h6 class="fw-bold">Datos del Solicitante</h6>
                            <table class="table table-sm">
                                <tr>
                                    <td width="40%"><strong>Nombres:</strong></td>
                                    <td><%= solicitud.getCiudadano() != null ? solicitud.getCiudadano().getNombreCompleto() : "N/A" %>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>DNI:</strong></td>
                                    <td><%= solicitud.getCiudadano() != null ? solicitud.getCiudadano().getDni() : "N/A" %>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Correo:</strong></td>
                                    <td><%= solicitud.getCiudadano() != null ? solicitud.getCiudadano().getCorreo() : "N/A" %>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <h6 class="fw-bold">Datos de la Solicitud</h6>
                            <table class="table table-sm">
                                <tr>
                                    <td width="40%"><strong>ID:</strong></td>
                                    <td><%= solicitud.getId() %>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Fecha:</strong></td>
                                    <td><%= solicitud.getFechaSolicitud() != null ? sdf.format(solicitud.getFechaSolicitud()) : "N/A" %>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>Estado:</strong></td>
                                    <td>
                                        <span class="badge <%= solicitud.getEstadoSolicitudId() == 1 ? "bg-warning text-dark" : "bg-info" %>">
                                            <%= solicitud.getEstadoSolicitudId() == 1 ? "Pendiente" : "En Proceso" %>
                                        </span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <h6 class="fw-bold">Descripción de la Solicitud</h6>
                    <div class="p-3 bg-light rounded mb-3">
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
                    <form id="formRespuesta" method="post" action="<%= request.getContextPath() %>/solicitud.do"
                          enctype="multipart/form-data">
                        <input type="hidden" name="accion" value="responder">
                        <input type="hidden" name="solicitudId" value="<%= solicitud.getId() %>">
                        <div class="alert alert-warning">
                            <i class="bi bi-exclamation-triangle me-2"></i> La respuesta será enviada
                            directamente al ciudadano. Revise cuidadosamente antes de enviar.
                        </div>

                        <div class="mb-3">
                            <label for="tipoRespuesta" class="form-label">Tipo de Respuesta</label>
                            <select class="form-select" id="tipoRespuesta" name="tipoRespuesta" required>
                                <option value="">Seleccione tipo de respuesta</option>
                                <option value="completa">Entrega de información completa</option>
                                <option value="parcial">Entrega de información parcial</option>
                                <option value="prorroga">Solicitud de prórroga</option>
                                <option value="rechazo">Denegación de información</option>
                            </select>
                        </div>

                        <div id="bloqueProrroga" class="mb-3" style="display: none;">
                            <label for="fechaProrroga" class="form-label">Nueva Fecha de Entrega</label>
                            <input type="text" class="form-control date-picker" id="fechaProrroga"
                                   name="fechaProrroga">
                            <div class="form-text">La prórroga no puede exceder los 5 días hábiles
                                adicionales.
                            </div>
                        </div>

                        <div id="bloqueRechazo" class="mb-3" style="display: none;">
                            <label for="motivoRechazo" class="form-label">Motivo del Rechazo</label>
                            <select class="form-select" id="motivoRechazo" name="motivoRechazo">
                                <option value="">Seleccione motivo</option>
                                <option value="1">Información clasificada como secreta (Seguridad Nacional)
                                </option>
                                <option value="2">Información reservada (Seguridad Pública)</option>
                                <option value="3">Información confidencial (Datos personales)</option>
                                <option value="4">Información en proceso deliberativo</option>
                                <option value="5">Otro motivo (detallar)</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="respuestaTexto" class="form-label">Contenido de la Respuesta</label>
                            <textarea class="form-control" id="respuestaTexto" name="respuestaTexto" rows="8"
                                      required></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="documentosRespuesta" class="form-label">Documentos Adjuntos</label>
                            <input class="form-control" type="file" id="documentosRespuesta"
                                   name="documentosRespuesta" multiple>
                            <div class="form-text">Puede adjuntar múltiples documentos (máximo 10MB en total).
                            </div>
                        </div>

                        <div class="mb-3 form-check">
                            <input type="checkbox" class="form-check-input" id="confirmacionEnvio"
                                   name="confirmacionEnvio" required>
                            <label class="form-check-label" for="confirmacionEnvio">Confirmo que la información
                                proporcionada es correcta y estoy autorizado para enviarla
                            </label>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="<%= request.getContextPath() %>/solicitud.do?accion=detalle&id=<%= solicitud.getId() %>"
                               class="btn btn-secondary">Cancelar</a>
                            <button type="submit" class="btn btn-primary">Enviar Respuesta</button>
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
        // Inicializar selectores de fecha
        flatpickr(".date-picker", {
            locale: "es",
            dateFormat: "d/m/Y",
            allowInput: true
        });

        // Mostrar/ocultar campos según el tipo de respuesta
        $('#tipoRespuesta').change(function () {
            const valor = $(this).val();

            // Ocultar todos los bloques condicionales
            $('#bloqueProrroga, #bloqueRechazo').hide();

            // Mostrar el bloque correspondiente
            if (valor === 'prorroga') {
                $('#bloqueProrroga').show();
            } else if (valor === 'rechazo') {
                $('#bloqueRechazo').show();
            }
        });

        // Validación del formulario
        $('#formRespuesta').on('submit', function (e) {
            if (!this.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }

            const tipoRespuesta = $('#tipoRespuesta').val();

            if (tipoRespuesta === 'prorroga' && $('#fechaProrroga').val() === '') {
                e.preventDefault();
                alert('Para solicitar prórroga debe indicar la nueva fecha de entrega');
                return false;
            }

            if (tipoRespuesta === 'rechazo' && $('#motivoRechazo').val() === '') {
                e.preventDefault();
                alert('Para rechazar la solicitud debe indicar un motivo');
                return false;
            }

            if (!$('#confirmacionEnvio').is(':checked')) {
                e.preventDefault();
                alert('Debe confirmar que está autorizado para enviar esta información');
                return false;
            }

            return true;
        });
    });
</script>
</body>
</html>
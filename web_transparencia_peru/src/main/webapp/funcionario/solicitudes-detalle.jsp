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

    // Calcular días restantes
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat sdfHora = new SimpleDateFormat("dd/MM/yyyy - HH:mm");

    // Calcular plazo (10 días hábiles es el estándar)
    final long DIAS_LIMITE = 10;
    String plazoText = "Atendida";
    String plazoClass = "text-success";

    if (solicitud.getEstadoSolicitudId() != 3 && solicitud.getEstadoSolicitudId() != 5) { // Si no está atendida ni rechazada
        Date fechaSolicitud = solicitud.getFechaSolicitud();
        Date hoy = new Date();
        long diferenciaDias = TimeUnit.DAYS.convert(hoy.getTime() - fechaSolicitud.getTime(), TimeUnit.MILLISECONDS);
        long diasFaltantes = DIAS_LIMITE - diferenciaDias;

        if (diasFaltantes <= 0) {
            plazoText = "VENCIDA";
            plazoClass = "text-danger fw-bold";
        } else if (diasFaltantes <= 3) {
            plazoText = diasFaltantes + " días restantes (URGENTE)";
            plazoClass = "text-danger";
        } else {
            plazoText = diasFaltantes + " días restantes";
            plazoClass = "text-warning";
        }
    }

    // Verificar si existe respuesta
    RespuestaSolicitudEntidad respuesta = null;
    try {
        SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
        respuesta = modelo.buscarRespuestaPorSolicitudId(solicitud.getId());
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Solicitud - Portal de Transparencia Perú</title>
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
        <a class="navbar-brand" href="#">Portal de Transparencia | Detalle de Solicitud #<%= solicitud.getId() %>
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/funcionario/index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/funcionario/transparencia.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Gestión de Transparencia
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/funcionario/solicitudes.jsp">
                            <i class="bi bi-envelope-open me-1"></i> Solicitudes de Información
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom title-section">
                <h1 class="h2">Detalle de Solicitud #<%= solicitud.getId() %>
                </h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="<%= request.getContextPath() %>/funcionario/solicitudes.jsp"
                       class="btn btn-sm btn-outline-secondary me-2">
                        <i class="bi bi-arrow-left me-1"></i> Volver a Solicitudes
                    </a>
                    <% if (solicitud.getEstadoSolicitudId() != 3 && solicitud.getEstadoSolicitudId() != 5) { %>
                    <a href="<%= request.getContextPath() %>/solicitud.do?accion=prepararRespuesta&id=<%= solicitud.getId() %>"
                       class="btn btn-sm btn-primary">
                        <i class="bi bi-reply me-1"></i> Responder
                    </a>
                    <% } %>
                </div>
            </div>

            <%
                // Mostrar mensaje si existe
                String mensaje = (String) session.getAttribute("mensaje");
                String tipoMensaje = (String) session.getAttribute("tipoMensaje");
                if (mensaje != null && !mensaje.isEmpty()) {
                    String alertClass = "alert-info";
                    if (tipoMensaje != null) {
                        if (tipoMensaje.equals("success")) alertClass = "alert-success";
                        else if (tipoMensaje.equals("warning")) alertClass = "alert-warning";
                        else if (tipoMensaje.equals("danger")) alertClass = "alert-danger";
                    }
            %>
            <div class="alert <%= alertClass %> alert-dismissible fade show" role="alert">
                <i class="bi <%= tipoMensaje != null && tipoMensaje.equals("success") ? "bi-check-circle" : "bi-info-circle" %> me-2"></i>
                <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%
                    // Eliminar el mensaje después de mostrarlo
                    session.removeAttribute("mensaje");
                    session.removeAttribute("tipoMensaje");
                }
            %>

            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold">Información de la Solicitud</h6>
                    <span class="badge <%= solicitud.getEstadoSolicitudId() == 1 ? "bg-warning text-dark" :
                                          solicitud.getEstadoSolicitudId() == 2 ? "bg-info" :
                                          solicitud.getEstadoSolicitudId() == 3 ? "bg-success" : 
                                          solicitud.getEstadoSolicitudId() == 4 ? "bg-secondary" :
                                          solicitud.getEstadoSolicitudId() == 5 ? "bg-danger" : "bg-secondary" %>">
                        <%= solicitud.getEstadoSolicitudId() == 1 ? "Pendiente" :
                                solicitud.getEstadoSolicitudId() == 2 ? "En Proceso" :
                                        solicitud.getEstadoSolicitudId() == 3 ? "Atendida" :
                                                solicitud.getEstadoSolicitudId() == 4 ? "Observada" :
                                                        solicitud.getEstadoSolicitudId() == 5 ? "Rechazada" : "Desconocido" %>
                    </span>
                </div>
                <div class="card-body">
                    <ul class="nav nav-tabs" id="myTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="solicitud-tab" data-bs-toggle="tab"
                                    data-bs-target="#solicitud" type="button" role="tab"
                                    aria-controls="solicitud" aria-selected="true">Solicitud
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="documentos-tab" data-bs-toggle="tab"
                                    data-bs-target="#documentos" type="button" role="tab"
                                    aria-controls="documentos" aria-selected="false">Documentos
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="seguimiento-tab" data-bs-toggle="tab"
                                    data-bs-target="#seguimiento" type="button" role="tab"
                                    aria-controls="seguimiento" aria-selected="false">Seguimiento
                            </button>
                        </li>
                    </ul>
                    <div class="tab-content pt-3" id="myTabContent">
                        <div class="tab-pane fade show active" id="solicitud" role="tabpanel"
                             aria-labelledby="solicitud-tab">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <h6 class="fw-bold">Datos del Solicitante</h6>
                                    <table class="table table-sm">
                                        <tr>
                                            <td width="40%"><strong>Nombres:</strong></td>
                                            <td><%= solicitud.getCiudadano() != null ? solicitud.getCiudadano().getNombres() : "N/A" %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Apellidos:</strong></td>
                                            <td><%= solicitud.getCiudadano() != null ? solicitud.getCiudadano().getApellidos() : "N/A" %>
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
                                                <span class="badge <%= solicitud.getEstadoSolicitudId() == 1 ? "bg-warning text-dark" :
                                                                    solicitud.getEstadoSolicitudId() == 2 ? "bg-info" :
                                                                    solicitud.getEstadoSolicitudId() == 3 ? "bg-success" : 
                                                                    solicitud.getEstadoSolicitudId() == 4 ? "bg-secondary" :
                                                                    solicitud.getEstadoSolicitudId() == 5 ? "bg-danger" : "bg-secondary" %>">
                                                    <%= solicitud.getEstadoSolicitudId() == 1 ? "Pendiente" :
                                                            solicitud.getEstadoSolicitudId() == 2 ? "En Proceso" :
                                                                    solicitud.getEstadoSolicitudId() == 3 ? "Atendida" :
                                                                            solicitud.getEstadoSolicitudId() == 4 ? "Observada" :
                                                                                    solicitud.getEstadoSolicitudId() == 5 ? "Rechazada" : "Desconocido" %>
                                                </span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>Plazo:</strong></td>
                                            <td><span class="<%= plazoClass %>"><%= plazoText %></span></td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            <div class="mb-3">
                                <h6 class="fw-bold">Descripción de la Solicitud</h6>
                                <div class="p-3 bg-light rounded">
                                    <%= solicitud.getDescripcion() %>
                                </div>
                            </div>

                            <% if (solicitud.getObservaciones() != null && !solicitud.getObservaciones().isEmpty()) { %>
                            <div class="mb-3">
                                <h6 class="fw-bold">Observaciones Registradas</h6>
                                <div class="p-3 bg-light rounded">
                                    <%= solicitud.getObservaciones() %>
                                </div>
                            </div>
                            <% } %>

                            <div class="mb-3">
                                <h6 class="fw-bold">Registrar Observación</h6>
                                <form id="formObservacion" action="<%= request.getContextPath() %>/solicitud.do"
                                      method="post">
                                    <input type="hidden" name="accion" value="registrarObservacion">
                                    <input type="hidden" name="id" value="<%= solicitud.getId() %>">
                                    <textarea class="form-control" name="observacion" id="observacionesSolicitud"
                                              rows="3"
                                              placeholder="Ingrese observaciones internas sobre esta solicitud (solo visible para funcionarios)"></textarea>
                                    <div class="text-end mt-2">
                                        <button type="submit" class="btn btn-primary btn-sm">
                                            <i class="bi bi-save me-1"></i> Guardar Observación
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="documentos" role="tabpanel"
                             aria-labelledby="documentos-tab">
                            <h6 class="mb-3">Documentos Adjuntos a la Solicitud</h6>
                            <% if (respuesta != null && respuesta.getRutaArchivo() != null && !respuesta.getRutaArchivo().isEmpty()) { %>
                            <ul class="list-group mb-4">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <div>
                                        <i class="bi bi-file-pdf text-danger me-2"></i> <%= respuesta.getRutaArchivo() %>
                                    </div>
                                    <div>
                                        <button class="btn btn-sm btn-primary">
                                            <i class="bi bi-eye"></i> Ver
                                        </button>
                                        <a href="<%= request.getContextPath() %>/funcionario/descargar?archivo=<%= respuesta.getRutaArchivo() %>"
                                           class="btn btn-sm btn-secondary">
                                            <i class="bi bi-download"></i> Descargar
                                        </a>
                                    </div>
                                </li>
                            </ul>
                            <% } else { %>
                            <div class="alert alert-info mb-3">
                                <i class="bi bi-info-circle me-2"></i> No hay documentos adjuntos disponibles para esta
                                solicitud.
                            </div>
                            <% } %>

                            <h6 class="mb-3">Documentos de Respuesta</h6>
                            <% if (solicitud.getEstadoSolicitudId() == 3 || solicitud.getEstadoSolicitudId() == 5) { %>
                            <% if (respuesta != null && respuesta.getRutaArchivo() != null && !respuesta.getRutaArchivo().isEmpty()) { %>
                            <ul class="list-group mb-4">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <div>
                                        <i class="bi bi-file-pdf text-danger me-2"></i> <%= respuesta.getRutaArchivo() %>
                                    </div>
                                    <div>
                                        <button class="btn btn-sm btn-primary">
                                            <i class="bi bi-eye"></i> Ver
                                        </button>
                                        <a href="<%= request.getContextPath() %>/funcionario/descargar?archivo=<%= respuesta.getRutaArchivo() %>"
                                           class="btn btn-sm btn-secondary">
                                            <i class="bi bi-download"></i> Descargar
                                        </a>
                                    </div>
                                </li>
                            </ul>
                            <% } else { %>
                            <div class="alert alert-info mb-3">
                                <i class="bi bi-info-circle me-2"></i> No hay documentos de respuesta disponibles.
                            </div>
                            <% } %>
                            <% } else { %>
                            <form id="formAdjuntarDocumentos" enctype="multipart/form-data"
                                  action="<%= request.getContextPath() %>/solicitud.do" method="post">
                                <input type="hidden" name="accion" value="adjuntarDocumento">
                                <input type="hidden" name="solicitudId" value="<%= solicitud.getId() %>">
                                <div class="mb-3">
                                    <label for="documentoRespuesta" class="form-label">Adjuntar documento</label>
                                    <input class="form-control" type="file" id="documentoRespuesta" name="documento">
                                </div>
                                <div class="mb-3">
                                    <label for="descripcionDocumento" class="form-label">Descripción</label>
                                    <input type="text" class="form-control" id="descripcionDocumento"
                                           name="descripcionDocumento"
                                           placeholder="Describa brevemente el documento">
                                </div>
                                <div class="text-end">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-upload me-1"></i> Subir Documento
                                    </button>
                                </div>
                            </form>
                            <% } %>
                        </div>

                        <div class="tab-pane fade" id="seguimiento" role="tabpanel"
                             aria-labelledby="seguimiento-tab">
                            <div class="timeline mb-4">
                                <div class="timeline-item">
                                    <div class="timeline-date"><%= solicitud.getFechaSolicitud() != null ? sdfHora.format(solicitud.getFechaSolicitud()) : "Fecha desconocida" %>
                                    </div>
                                    <div class="timeline-content">
                                        <h6 class="mb-1"><i
                                                class="bi bi-file-earmark-plus me-2 text-primary"></i> Solicitud
                                            recibida</h6>
                                        <p class="mb-0 text-muted small">La solicitud fue registrada en el
                                            sistema.</p>
                                    </div>
                                </div>

                                <% if (solicitud.getEstadoSolicitudId() > 1) { %>
                                <div class="timeline-item">
                                    <div class="timeline-date">Posterior a la recepción</div>
                                    <div class="timeline-content">
                                        <h6 class="mb-1"><i class="bi bi-person-check me-2 text-info"></i>
                                            Asignada a funcionario</h6>
                                        <p class="mb-0 text-muted small">La solicitud fue asignada
                                            a <%= usuario.getNombreCompleto() %>
                                        </p>
                                    </div>
                                </div>
                                <% } %>

                                <% if (solicitud.getFechaRespuesta() != null) { %>
                                <div class="timeline-item">
                                    <div class="timeline-date"><%= sdfHora.format(solicitud.getFechaRespuesta()) %>
                                    </div>
                                    <div class="timeline-content">
                                        <h6 class="mb-1"><i class="bi bi-check-circle me-2 text-success"></i>
                                            Solicitud respondida</h6>
                                        <p class="mb-0 text-muted small">Se ha registrado una respuesta a la
                                            solicitud.</p>
                                    </div>
                                </div>
                                <% } %>
                            </div>

                            <h6 class="mb-3">Añadir nueva entrada de seguimiento</h6>
                            <form id="formSeguimiento" action="<%= request.getContextPath() %>/solicitud.do"
                                  method="post">
                                <input type="hidden" name="accion" value="agregarSeguimiento">
                                <input type="hidden" name="solicitudId" value="<%= solicitud.getId() %>">
                                <div class="mb-3">
                                    <label for="tipoSeguimiento" class="form-label">Tipo</label>
                                    <select class="form-select" id="tipoSeguimiento" name="tipoSeguimiento">
                                        <option value="nota">Nota interna</option>
                                        <option value="derivacion">Derivación</option>
                                        <option value="comunicacion">Comunicación con ciudadano</option>
                                        <option value="actualizacion">Actualización de estado</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="descripcionSeguimiento" class="form-label">Descripción</label>
                                    <textarea class="form-control" id="descripcionSeguimiento"
                                              name="descripcionSeguimiento"
                                              rows="3"></textarea>
                                </div>
                                <div class="text-end">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-plus-circle me-1"></i> Añadir Seguimiento
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="d-flex justify-content-between">
                        <a href="<%= request.getContextPath() %>/funcionario/solicitudes.jsp" class="btn btn-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Volver
                        </a>
                        <% if (solicitud.getEstadoSolicitudId() != 3 && solicitud.getEstadoSolicitudId() != 5) { %>
                        <a href="<%= request.getContextPath() %>/solicitud.do?accion=prepararRespuesta&id=<%= solicitud.getId() %>"
                           class="btn btn-primary">
                            <i class="bi bi-reply me-1"></i> Responder Solicitud
                        </a>
                        <% } %>
                    </div>
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

        // Manejar la subida de documentos
        $('#formAdjuntarDocumentos').on('submit', function (e) {
            const documento = $('#documentoRespuesta').val();
            if (!documento) {
                e.preventDefault();
                alert('Por favor seleccione un documento para subir');
            }
        });

        // Manejar el formulario de seguimiento
        $('#formSeguimiento').on('submit', function (e) {
            const descripcion = $('#descripcionSeguimiento').val();
            if (!descripcion || descripcion.trim() === '') {
                e.preventDefault();
                alert('Por favor ingrese una descripción para el seguimiento');
            }
        });
    });
</script>
</body>
</html>
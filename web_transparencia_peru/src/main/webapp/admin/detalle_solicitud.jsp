<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.SolicitudAccesoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.SolicitudAccesoModelo" %>
<%@ page import="pe.gob.transparencia.entidades.RespuestaSolicitudEntidad" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Verificar si el usuario está en sesión y es admin
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
        // No es admin o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener la solicitud a mostrar desde el request
    SolicitudAccesoEntidad solicitud = (SolicitudAccesoEntidad) request.getAttribute("solicitud");
    RespuestaSolicitudEntidad respuesta = (RespuestaSolicitudEntidad) request.getAttribute("respuesta");

    if (solicitud == null) {
        response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
        return;
    }

    // Formato para fechas
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat formatoFechaHora = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Solicitud - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <style>
        .status-badge {
            font-size: 0.9em;
            padding: 0.4em 0.8em;
            border-radius: 50px;
        }

        .timeline {
            position: relative;
            padding-left: 30px;
        }

        .timeline::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            width: 2px;
            height: 100%;
            background-color: #dee2e6;
        }

        .timeline-item {
            position: relative;
            padding-bottom: 30px;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: -35px;
            top: 0;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: #0d6efd;
            border: 2px solid #fff;
            z-index: 1;
        }

        .timeline-item.complete::before {
            background-color: #198754;
        }

        .timeline-item.rejected::before {
            background-color: #dc3545;
        }

        .timeline-item.pending::before {
            background-color: #ffc107;
        }
    </style>
</head>
<body>
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Administrador</a>
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios">
                            <i class="bi bi-people me-1"></i> Gestión de Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="entidades.jsp">
                            <i class="bi bi-building me-1"></i> Entidades Públicas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ciudadanos.jsp">
                            <i class="bi bi-person-badge me-1"></i> Ciudadanos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="presupuestos.jsp">
                            <i class="bi bi-cash-coin me-1"></i> Presupuestos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="#">
                            <i class="bi bi-file-earmark-text me-1"></i> Solicitudes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="informes.jsp">
                            <i class="bi bi-graph-up me-1"></i> Informes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="configuracion.jsp">
                            <i class="bi bi-gear me-1"></i> Configuración
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom title-section">
                <h1 class="h2">Detalle de Solicitud de Acceso</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <a href="<%= request.getContextPath() %>/admin/solicitudes.jsp"
                           class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Volver
                        </a>
                        <a href="<%= request.getContextPath() %>/admin.do?accion=editarSolicitud&id=<%= solicitud.getId() %>"
                           class="btn btn-sm btn-primary">
                            <i class="bi bi-pencil me-1"></i> Editar
                        </a>
                        <button type="button" class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                data-bs-target="#eliminarSolicitudModal">
                            <i class="bi bi-trash me-1"></i> Eliminar
                        </button>
                    </div>
                </div>
            </div>

            <!-- Información de la solicitud -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3 d-flex justify-content-between align-items-center bg-gray-200">
                    <h6 class="m-0 font-weight-bold">
                        <i class="bi bi-file-earmark-text me-2"></i>Solicitud #<%= solicitud.getId() %>
                    </h6>
                    <%
                        String badgeClass = "bg-secondary";
                        String badgeIcon = "bi-question-circle";
                        if (solicitud.getEstadoSolicitud() != null) {
                            String estado = solicitud.getEstadoSolicitud().getNombre();
                            if (estado.equals("Pendiente")) {
                                badgeClass = "bg-warning text-dark";
                                badgeIcon = "bi-hourglass-split";
                            } else if (estado.equals("En Proceso")) {
                                badgeClass = "bg-info";
                                badgeIcon = "bi-arrow-clockwise";
                            } else if (estado.equals("Atendida")) {
                                badgeClass = "bg-success";
                                badgeIcon = "bi-check-circle";
                            } else if (estado.equals("Observada")) {
                                badgeClass = "bg-primary";
                                badgeIcon = "bi-exclamation-circle";
                            } else if (estado.equals("Rechazada")) {
                                badgeClass = "bg-danger";
                                badgeIcon = "bi-x-circle";
                            }
                    %>
                    <span class="badge <%= badgeClass %> status-badge">
                        <i class="bi <%= badgeIcon %> me-1"></i> <%= solicitud.getEstadoSolicitud().getNombre() %>
                    </span>
                    <% } else { %>
                    <span class="badge bg-secondary status-badge">
                        <i class="bi bi-question-circle me-1"></i> No definido
                    </span>
                    <% } %>
                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5 class="mb-3">Información General</h5>
                            <p><strong>Fecha de Solicitud:</strong>
                                <%= solicitud.getFechaSolicitud() != null ? formatoFecha.format(solicitud.getFechaSolicitud()) : "No disponible" %>
                            </p>
                            <p><strong>Tipo de Solicitud:</strong>
                                <%= solicitud.getTipoSolicitud() != null ? solicitud.getTipoSolicitud().getNombre() : "No definido" %>
                            </p>
                            <p><strong>Entidad Pública:</strong>
                                <%= solicitud.getEntidadPublica() != null ? solicitud.getEntidadPublica().getNombre() : "No definido" %>
                            </p>
                            <% if (solicitud.getFechaRespuesta() != null) { %>
                            <p><strong>Fecha de
                                Respuesta:</strong> <%= formatoFecha.format(solicitud.getFechaRespuesta()) %>
                            </p>
                            <% } %>
                        </div>
                        <div class="col-md-6">
                            <h5 class="mb-3">Información del Ciudadano</h5>
                            <% if (solicitud.getCiudadano() != null) { %>
                            <p><strong>Nombre:</strong>
                                <%= solicitud.getCiudadano().getNombreCompleto() %>
                            </p>
                            <p><strong>DNI:</strong> <%= solicitud.getCiudadano().getDni() %>
                            </p>
                            <p><strong>Correo:</strong>
                                <a href="mailto:<%= solicitud.getCiudadano().getCorreo() %>">
                                    <%= solicitud.getCiudadano().getCorreo() %>
                                </a>
                            </p>
                            <% if (solicitud.getCiudadano().getTelefono() != null && !solicitud.getCiudadano().getTelefono().isEmpty()) { %>
                            <p><strong>Teléfono:</strong>
                                <a href="tel:<%= solicitud.getCiudadano().getTelefono() %>">
                                    <%= solicitud.getCiudadano().getTelefono() %>
                                </a>
                            </p>
                            <% } %>
                            <% } else { %>
                            <p class="text-danger">Información del ciudadano no disponible</p>
                            <% } %>
                        </div>
                    </div>

                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <h6 class="m-0 font-weight-bold">Descripción de la Solicitud</h6>
                        </div>
                        <div class="card-body">
                            <p class="card-text"><%= solicitud.getDescripcion() != null ? solicitud.getDescripcion() : "Sin descripción" %>
                            </p>
                        </div>
                    </div>

                    <% if (solicitud.getObservaciones() != null && !solicitud.getObservaciones().trim().isEmpty()) { %>
                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <h6 class="m-0 font-weight-bold">Observaciones</h6>
                        </div>
                        <div class="card-body">
                            <p class="card-text"><%= solicitud.getObservaciones() %>
                            </p>
                        </div>
                    </div>
                    <% } %>

                    <% if (respuesta != null) { %>
                    <div class="card mb-4 border-success">
                        <div class="card-header bg-success text-white">
                            <h6 class="m-0 font-weight-bold">Respuesta</h6>
                        </div>
                        <div class="card-body">
                            <p><strong>Fecha de
                                Respuesta:</strong> <%= formatoFecha.format(respuesta.getFechaRespuesta()) %>
                            </p>
                            <p><strong>Responsable:</strong> <%= respuesta.getUsuarioId() %>
                            </p>
                            <div class="mt-3">
                                <h6>Contenido de la Respuesta:</h6>
                                <p><%= respuesta.getContenido() %>
                                </p>
                            </div>
                            <% if (respuesta.getRutaArchivo() != null && !respuesta.getRutaArchivo().trim().isEmpty()) { %>
                            <div class="mt-3">
                                <h6>Archivo adjunto:</h6>
                                <a href="<%= request.getContextPath() %>/documentos/<%= respuesta.getRutaArchivo() %>"
                                   class="btn btn-sm btn-outline-secondary" target="_blank">
                                    <i class="bi bi-file-earmark-arrow-down me-1"></i>
                                    Descargar archivo
                                </a>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } else if (solicitud.getEstadoSolicitudId() == 3) { /* Si está atendida pero no hay respuesta */ %>
                    <div class="card mb-4 border-warning">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <i class="bi bi-exclamation-triangle-fill text-warning me-3"
                                   style="font-size: 2rem;"></i>
                                <div>
                                    <h6 class="mb-1">La solicitud figura como atendida pero no se encontró registro de
                                        respuesta</h6>
                                    <p class="mb-0">Puede agregar una respuesta o cambiar el estado de la solicitud.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>

                    <div class="mt-4 d-flex justify-content-between">
                        <div>
                            <a href="<%= request.getContextPath() %>/admin/solicitudes.jsp" class="btn btn-secondary">
                                <i class="bi bi-arrow-left me-1"></i> Volver a la lista
                            </a>
                        </div>
                        <div class="btn-group">
                            <a href="<%= request.getContextPath() %>/admin.do?accion=editarSolicitud&id=<%= solicitud.getId() %>"
                               class="btn btn-primary">
                                <i class="bi bi-pencil me-1"></i> Editar
                            </a>
                            <% if (respuesta == null) { %>
                            <a href="<%= request.getContextPath() %>/solicitud.do?accion=prepararRespuesta&id=<%= solicitud.getId() %>"
                               class="btn btn-success">
                                <i class="bi bi-reply me-1"></i> Responder
                            </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal Confirmar Eliminación -->
<div class="modal fade" id="eliminarSolicitudModal" tabindex="-1" aria-labelledby="eliminarSolicitudModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarSolicitudModalLabel"><i class="bi bi-exclamation-triangle me-2"></i>Confirmar
                    Eliminación</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro que desea eliminar la solicitud con ID: <strong><%= solicitud.getId() %>
                </strong>?</p>
                <p>Esta acción eliminará también todas las respuestas asociadas y no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <form action="<%= request.getContextPath() %>/admin.do" method="post">
                    <input type="hidden" name="accion" value="eliminarSolicitud">
                    <input type="hidden" name="id" value="<%= solicitud.getId() %>">
                    <input type="hidden" name="redirect" value="solicitudes.jsp">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
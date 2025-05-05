<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.CiudadanoEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.SolicitudAccesoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.SolicitudAccesoModelo" %>
<%@ page import="pe.gob.transparencia.entidades.RespuestaSolicitudEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.UsuarioModelo" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>

<%
    // Verificar si el ciudadano está en sesión
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("ciudadano") == null) {
        // No está logueado como ciudadano, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    CiudadanoEntidad ciudadano = (CiudadanoEntidad) sesion.getAttribute("ciudadano");

    // Obtener la solicitud a mostrar
    SolicitudAccesoEntidad solicitud = (SolicitudAccesoEntidad) request.getAttribute("solicitud");
    if (solicitud == null) {
        // Si no hay solicitud, redirigir a la lista
        response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=listar");
        return;
    }

    // Verificar que la solicitud pertenezca al ciudadano
    if (solicitud.getCiudadanoId() != ciudadano.getId()) {
        // No es su solicitud, redirigir a la lista
        sesion.setAttribute("mensaje", "No tiene permisos para ver esta solicitud");
        response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=listar");
        return;
    }

    // Verificar si la solicitud tiene respuesta
    boolean tieneRespuesta = (solicitud.getEstadoSolicitudId() == 3 || solicitud.getEstadoSolicitudId() == 5)
            && solicitud.getFechaRespuesta() != null;
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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ciudadano.css">
</head>
<body class="ciudadano-theme">
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Detalle de Solicitud</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle me-1"></i><%= ciudadano.getNombreCompleto() %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/ciudadano/perfil.jsp"><i
                                class="bi bi-person me-1"></i> Mi Perfil</a>
                        </li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item"
                               href="<%= request.getContextPath() %>/ciudadano.do?accion=cerrar"><i
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/ciudadano/index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/ciudadano/mis_solicitudes.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Mis Solicitudes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/ciudadano/nueva_solicitud.jsp">
                            <i class="bi bi-file-plus me-1"></i> Nueva Solicitud
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/ciudadano/perfil.jsp">
                            <i class="bi bi-person me-1"></i> Mi Perfil
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/ciudadano/presupuesto.jsp">
                            <i class="bi bi-cash-coin me-1"></i> Presupuesto Público
                        </a>
                    </li>
                </ul>

                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Portal Público</span>
                </h6>
                <ul class="nav flex-column mb-2">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/index.jsp">
                            <i class="bi bi-arrow-left-circle me-1"></i> Volver al Portal
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
                    <a href="<%= request.getContextPath() %>/ciudadano/mis_solicitudes.jsp"
                       class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Volver a Mis Solicitudes
                    </a>
                </div>
            </div>

            <!-- Información de la solicitud -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold">Información de la Solicitud</h6>
                    <span class="badge bg-<%= solicitud.getEstadoSolicitudId() == 1 ? "warning" : 
                                             solicitud.getEstadoSolicitudId() == 2 ? "primary" : 
                                             solicitud.getEstadoSolicitudId() == 3 ? "success" : 
                                             solicitud.getEstadoSolicitudId() == 4 ? "info" : 
                                             solicitud.getEstadoSolicitudId() == 5 ? "danger" : "secondary" %>">
                        <%= solicitud.getEstadoSolicitudId() == 1 ? "Pendiente" :
                                solicitud.getEstadoSolicitudId() == 2 ? "En Proceso" :
                                        solicitud.getEstadoSolicitudId() == 3 ? "Atendida" :
                                                solicitud.getEstadoSolicitudId() == 4 ? "Observada" :
                                                        solicitud.getEstadoSolicitudId() == 5 ? "Rechazada" : "Otro Estado" %>
                    </span>
                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <table class="table table-borderless">
                                <tr>
                                    <th width="40%">ID Solicitud:</th>
                                    <td><%= solicitud.getId() %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Fecha de Solicitud:</th>
                                    <td><%= solicitud.getFechaSolicitud() %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Tipo de Solicitud:</th>
                                    <td>
                                        <%= solicitud.getTipoSolicitudId() == 1 ? "Información Presupuestal" :
                                                solicitud.getTipoSolicitudId() == 2 ? "Información de Proyectos" :
                                                        solicitud.getTipoSolicitudId() == 3 ? "Información de Contrataciones" :
                                                                solicitud.getTipoSolicitudId() == 4 ? "Información de Personal" :
                                                                        solicitud.getTipoSolicitudId() == 5 ? "Información General" :
                                                                                solicitud.getTipoSolicitudId() == 6 ? "Información Ambiental" : "Otro" %>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <table class="table table-borderless">
                                <tr>
                                    <th width="40%">Entidad:</th>
                                    <td><%= solicitud.getEntidadPublica() != null ? solicitud.getEntidadPublica().getNombre() : "No especificada" %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Estado Actual:</th>
                                    <td>
                                        <span class="badge bg-<%= solicitud.getEstadoSolicitudId() == 1 ? "warning" : 
                                                                 solicitud.getEstadoSolicitudId() == 2 ? "primary" : 
                                                                 solicitud.getEstadoSolicitudId() == 3 ? "success" : 
                                                                 solicitud.getEstadoSolicitudId() == 4 ? "info" : 
                                                                 solicitud.getEstadoSolicitudId() == 5 ? "danger" : "secondary" %>">
                                            <%= solicitud.getEstadoSolicitudId() == 1 ? "Pendiente" :
                                                    solicitud.getEstadoSolicitudId() == 2 ? "En Proceso" :
                                                            solicitud.getEstadoSolicitudId() == 3 ? "Atendida" :
                                                                    solicitud.getEstadoSolicitudId() == 4 ? "Observada" :
                                                                            solicitud.getEstadoSolicitudId() == 5 ? "Rechazada" : "Otro Estado" %>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Fecha de Respuesta:</th>
                                    <td><%= solicitud.getFechaRespuesta() != null ? solicitud.getFechaRespuesta() : "Pendiente" %>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <h6 class="mb-2">Descripción de su Solicitud</h6>
                    <div class="p-3 bg-light rounded mb-4">
                        <%= solicitud.getDescripcion() %>
                    </div>

                    <%-- Información del plazo según el estado --%>
                    <% if (solicitud.getEstadoSolicitudId() == 1 || solicitud.getEstadoSolicitudId() == 2) { %>
                    <div class="alert alert-info">
                        <div class="d-flex">
                            <div class="me-3">
                                <i class="bi bi-info-circle fs-4"></i>
                            </div>
                            <div>
                                <h5 class="alert-heading">Plazo de Atención</h5>
                                <p>Las entidades públicas tienen un plazo legal de <strong>10 días hábiles</strong> para
                                    responder a su solicitud, prorrogable por 5 días adicionales en casos excepcionales.
                                </p>
                                <% if (solicitud.getEstadoSolicitudId() == 2) { %>
                                <p class="mb-0">Su solicitud está siendo procesada. La entidad está recopilando la
                                    información solicitada.</p>
                                <% } else { %>
                                <p class="mb-0">Su solicitud está pendiente de atención. Pronto recibirá una
                                    respuesta.</p>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>

            <%-- Respuesta si existe --%>
            <% if (tieneRespuesta) {
                SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
                RespuestaSolicitudEntidad respuesta = modelo.buscarRespuestaPorSolicitudId(solicitud.getId());
            %>
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3 bg-<%= solicitud.getEstadoSolicitudId() == 3 ? "success" : "danger" %> text-white">
                    <h6 class="m-0 font-weight-bold">Respuesta a su Solicitud</h6>
                </div>
                <div class="card-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p><strong>Fecha de Respuesta:</strong> <%= solicitud.getFechaRespuesta() %>
                            </p>
                            <p><strong>Funcionario Responsable:</strong>
                                <%
                                String funcionarioNombre = "No especificado";
                                    if (respuesta != null && respuesta.getUsuarioId() > 0) {
                                        UsuarioModelo usuarioModelo = new UsuarioModelo();
                                        UsuarioEntidad funcionario = usuarioModelo.buscarPorId(respuesta.getUsuarioId());
                                        if (funcionario != null) {
                                            funcionarioNombre = "Ha sido respondido por el funcionario " + funcionario.getNombreCompleto();
                                        } else {
                                            funcionarioNombre = "Funcionario del sistema";
                                    }
                                }
                                %>
                                <%= funcionarioNombre %>
                            </p>
                        </div>
                        <div class="col-md-6">
                            <% if (solicitud.getEstadoSolicitudId() == 5) { %>
                            <div class="alert alert-danger">
                                <strong>IMPORTANTE:</strong> Su solicitud ha sido denegada.
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <h6 class="mb-2">Contenido de la Respuesta</h6>
                    <div class="p-3 bg-light rounded mb-4">
                        <%= solicitud.getObservaciones() != null ? solicitud.getObservaciones() : "No se proporcionaron detalles adicionales." %>
                    </div>

                    <% if (respuesta != null && respuesta.getRutaArchivo() != null && !respuesta.getRutaArchivo().isEmpty()) { %>
                    <h6 class="mb-2">Documentos Adjuntos</h6>
                    <div class="list-group mb-3">
                        <a href="<%= request.getContextPath() %>/descargar?archivo=<%= respuesta.getRutaArchivo() %>"
                           class="list-group-item list-group-item-action">
                            <i class="bi bi-file-earmark me-2"></i> <%= respuesta.getRutaArchivo() %>
                        </a>
                    </div>
                    <% } %>
                </div>
            </div>
            <% } %>

            <%-- Enlaces rápidos --%>
            <div class="text-center py-4">
                <div class="btn-group" role="group">
                    <a href="<%= request.getContextPath() %>/ciudadano/mis_solicitudes.jsp"
                       class="btn btn-outline-primary">
                        <i class="bi bi-arrow-left me-1"></i> Volver a Mis Solicitudes
                    </a>
                    <a href="<%= request.getContextPath() %>/ciudadano/nueva_solicitud.jsp" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-1"></i> Nueva Solicitud
                    </a>
                    <% if (solicitud.getEstadoSolicitudId() == 3 || solicitud.getEstadoSolicitudId() == 5) { %>
                    <button type="button" class="btn btn-outline-secondary" data-bs-toggle="modal"
                            data-bs-target="#calificacionModal">
                        <i class="bi bi-star me-1"></i> Calificar Atención
                    </button>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal de Calificación -->
<% if (solicitud.getEstadoSolicitudId() == 3 || solicitud.getEstadoSolicitudId() == 5) { %>
<div class="modal fade" id="calificacionModal" tabindex="-1" aria-labelledby="calificacionModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="calificacionModalLabel">Calificar Atención de Solicitud</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/ciudadano.do?accion=calificarSolicitud" method="post">
                <input type="hidden" name="solicitudId" value="<%= solicitud.getId() %>">
                <div class="modal-body">
                    <p>Su opinión es importante para mejorar nuestro servicio. Por favor califique la atención
                        recibida:</p>

                    <div class="mb-3">
                        <label class="form-label">Calificación:</label>
                        <div class="rating">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="calificacion" id="cal1" value="1"
                                       required>
                                <label class="form-check-label" for="cal1">1 ⭐</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="calificacion" id="cal2" value="2">
                                <label class="form-check-label" for="cal2">2 ⭐⭐</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="calificacion" id="cal3" value="3">
                                <label class="form-check-label" for="cal3">3 ⭐⭐⭐</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="calificacion" id="cal4" value="4">
                                <label class="form-check-label" for="cal4">4 ⭐⭐⭐⭐</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="calificacion" id="cal5" value="5">
                                <label class="form-check-label" for="cal5">5 ⭐⭐⭐⭐⭐</label>
                            </div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="comentario" class="form-label">Comentarios (opcional):</label>
                        <textarea class="form-control" id="comentario" name="comentario" rows="3"
                                  placeholder="Comparta su experiencia o sugerencias para mejorar"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Enviar Calificación</button>
                </div>
            </form>
        </div>
    </div>
</div>
<% } %>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
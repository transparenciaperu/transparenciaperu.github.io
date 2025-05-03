<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.SolicitudAccesoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.SolicitudAccesoModelo" %>
<%@ page import="pe.gob.transparencia.entidades.CiudadanoEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.EntidadPublicaModelo" %>
<%@ page import="pe.gob.transparencia.modelo.CiudadanoModelo" %>
<%@ page import="pe.gob.transparencia.entidades.TipoSolicitudEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.EstadoSolicitudEntidad" %>
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

    // Obtener la solicitud a editar desde el request
    SolicitudAccesoEntidad solicitud = (SolicitudAccesoEntidad) request.getAttribute("solicitud");
    if (solicitud == null) {
        response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
        return;
    }

    // Obtener listas para los formularios
    EntidadPublicaModelo modeloEntidad = new EntidadPublicaModelo();
    List<EntidadPublicaEntidad> listaEntidades = modeloEntidad.listarEntidades();

    CiudadanoModelo modeloCiudadano = new CiudadanoModelo();
    List<CiudadanoEntidad> listaCiudadanos = modeloCiudadano.listarCiudadanos();

    SolicitudAccesoModelo modeloSolicitud = new SolicitudAccesoModelo();
    List<TipoSolicitudEntidad> listaTipos = modeloSolicitud.listarTiposSolicitud();
    List<EstadoSolicitudEntidad> listaEstados = modeloSolicitud.listarEstadosSolicitud();

    // Formato para fechas
    SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Solicitud - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
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
                <h1 class="h2">Editar Solicitud de Acceso</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <a href="<%= request.getContextPath() %>/admin/solicitudes.jsp"
                           class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Volver
                        </a>
                    </div>
                </div>
            </div>

            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold"><i class="bi bi-pencil me-2"></i>Formulario de Edición - Solicitud
                        #<%= solicitud.getId() %>
                    </h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin.do" method="post">
                        <input type="hidden" name="id" value="<%= solicitud.getId() %>">
                        <input type="hidden" name="accion" value="actualizarSolicitud">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="fechaSolicitud" class="form-label">Fecha de Solicitud</label>
                                <input type="date" class="form-control" id="fechaSolicitud" name="fechaSolicitud"
                                       value="<%= solicitud.getFechaSolicitud() != null ? formatoFecha.format(solicitud.getFechaSolicitud()) : "" %>"
                                       readonly>
                                <div class="form-text">Este campo no se puede editar.</div>
                            </div>
                            <div class="col-md-6">
                                <label for="ciudadanoId" class="form-label">Ciudadano</label>
                                <select class="form-select" id="ciudadanoId" name="ciudadanoId" required>
                                    <% for (CiudadanoEntidad ciudadano : listaCiudadanos) { %>
                                    <option value="<%= ciudadano.getId() %>" <%= solicitud.getCiudadanoId() == ciudadano.getId() ? "selected" : "" %>>
                                        <%= ciudadano.getNombres() + " " + ciudadano.getApellidos() %>
                                        - <%= ciudadano.getDni() %>
                                    </option>
                                    <% } %>
                                </select>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="tipoSolicitudId" class="form-label">Tipo de Solicitud</label>
                                <select class="form-select" id="tipoSolicitudId" name="tipoSolicitudId" required>
                                    <% for (TipoSolicitudEntidad tipo : listaTipos) { %>
                                    <option value="<%= tipo.getId() %>" <%= solicitud.getTipoSolicitudId() == tipo.getId() ? "selected" : "" %>>
                                        <%= tipo.getNombre() %>
                                    </option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="estadoSolicitudId" class="form-label">Estado de Solicitud</label>
                                <select class="form-select" id="estadoSolicitudId" name="estadoSolicitudId" required>
                                    <% for (EstadoSolicitudEntidad estado : listaEstados) { %>
                                    <option value="<%= estado.getId() %>" <%= solicitud.getEstadoSolicitudId() == estado.getId() ? "selected" : "" %>>
                                        <%= estado.getNombre() %>
                                    </option>
                                    <% } %>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="entidadPublicaId" class="form-label">Entidad Pública</label>
                            <select class="form-select" id="entidadPublicaId" name="entidadPublicaId" required>
                                <% for (EntidadPublicaEntidad entidad : listaEntidades) { %>
                                <option value="<%= entidad.getId() %>" <%= solicitud.getEntidadPublicaId() == entidad.getId() ? "selected" : "" %>>
                                    <%= entidad.getNombre() %>
                                </option>
                                <% } %>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label for="descripcion" class="form-label">Descripción de la Solicitud</label>
                            <textarea class="form-control" id="descripcion" name="descripcion" rows="4"
                                      required><%= solicitud.getDescripcion() %></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="observaciones" class="form-label">Observaciones</label>
                            <textarea class="form-control" id="observaciones" name="observaciones"
                                      rows="3"><%= solicitud.getObservaciones() != null ? solicitud.getObservaciones() : "" %></textarea>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="fechaRespuesta" class="form-label">Fecha de Respuesta</label>
                                <input type="date" class="form-control" id="fechaRespuesta" name="fechaRespuesta"
                                       value="<%= solicitud.getFechaRespuesta() != null ? formatoFecha.format(solicitud.getFechaRespuesta()) : "" %>">
                                <div class="form-text">Dejar en blanco si aún no hay respuesta.</div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-end mt-4">
                            <a href="<%= request.getContextPath() %>/admin/solicitudes.jsp"
                               class="btn btn-secondary me-2">
                                <i class="bi bi-x-circle me-1"></i> Cancelar
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-check2-circle me-1"></i> Guardar Cambios
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Script para inicializar componentes y funcionalidades adicionales
    $(document).ready(function () {
        // Inicializar tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });
    });
</script>
</body>
</html>
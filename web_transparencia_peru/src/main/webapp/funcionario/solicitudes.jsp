<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.SolicitudAccesoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.SolicitudAccesoModelo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Verificar si el usuario está en sesión y es funcionario
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("FUNCIONARIO")) {
        // No es funcionario o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener solicitudes
    List<SolicitudAccesoEntidad> solicitudes = new ArrayList<>();
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

    // Obtener valores de filtros si están disponibles en el request
    String filtroEstado = (String) request.getAttribute("filtroEstado");
    String filtroFechaDesde = (String) request.getAttribute("filtroFechaDesde");
    String filtroFechaHasta = (String) request.getAttribute("filtroFechaHasta");
    String filtroBusqueda = (String) request.getAttribute("filtroBusqueda");
    String filtroVencidas = (String) request.getAttribute("filtroVencidas");

    try {
        SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();

        // Si hay filtros en el request, es porque vienen del servlet
        if (request.getAttribute("solicitudes") != null) {
            solicitudes = (List<SolicitudAccesoEntidad>) request.getAttribute("solicitudes");
        } else {
            // Si no hay filtros, obtener todas las solicitudes
            solicitudes = modelo.listarSolicitudes();
        }
    } catch (Exception e) {
        e.printStackTrace();
        // Manejar el error según sea necesario
    }

    // Contar por estado
    int pendientes = 0;
    int enProceso = 0;
    int atendidas = 0;
    int porVencer = 0;

    // Calcular días para vencer (10 días hábiles es el límite estándar)
    final long DIAS_LIMITE = 10;

    for (SolicitudAccesoEntidad sol : solicitudes) {
        // Contar por estado
        switch (sol.getEstadoSolicitudId()) {
            case 1:
                pendientes++;
                break; // Pendiente
            case 2:
                enProceso++;
                break; // En proceso
            case 3:
                atendidas++;
                break; // Atendida
        }

        // Verificar si está por vencer (3 días o menos)
        if (sol.getEstadoSolicitudId() == 1 || sol.getEstadoSolicitudId() == 2) {
            Date fechaSolicitud = sol.getFechaSolicitud();
            Date hoy = new Date();
            long diferenciaDias = TimeUnit.DAYS.convert(hoy.getTime() - fechaSolicitud.getTime(), TimeUnit.MILLISECONDS);

            if (DIAS_LIMITE - diferenciaDias <= 3 && diferenciaDias < DIAS_LIMITE) {
                porVencer++;
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Solicitudes - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/funcionario.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body class="funcionario-theme">
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Solicitudes</a>
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
                <h1 class="h2">Gestión de Solicitudes de Información</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button type="button" class="btn btn-primary me-2" data-bs-toggle="modal"
                            data-bs-target="#exportarModal">
                        <i class="bi bi-file-earmark-excel me-1"></i> Exportar
                    </button>
                    <div class="btn-group">
                        <button type="button" class="btn btn-outline-secondary dropdown-toggle"
                                data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-filter me-1"></i> Filtros
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li><a class="dropdown-item" href="#" id="filtroHoy">Recibidas hoy</a></li>
                            <li><a class="dropdown-item" href="#" id="filtroSemana">Recibidas esta semana</a></li>
                            <li><a class="dropdown-item" href="#" id="filtroPendientes">Pendientes</a></li>
                            <li><a class="dropdown-item" href="#" id="filtroVencidas">Vencidas o por vencer</a></li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item" href="#" id="filtroLimpiar">Limpiar filtros</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="alert alert-info fade-in mb-4">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <i class="bi bi-info-circle-fill fs-3"></i>
                    </div>
                    <div>
                        <h5 class="mb-1">Recuerde los plazos de atención</h5>
                        <p class="mb-0">Las solicitudes de información deben ser atendidas en un plazo máximo de 10 días
                            hábiles, con posibilidad de prórroga excepcional de 5 días hábiles adicionales.</p>
                    </div>
                </div>
            </div>

            <!-- Filtros -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Filtros de búsqueda</h6>
                </div>
                <div class="card-body">
                    <form id="formFiltros" class="row g-3" action="<%= request.getContextPath() %>/solicitud.do"
                          method="get">
                        <input type="hidden" name="accion" value="listar">
                        <div class="col-md-3">
                            <label for="filtroEstado" class="form-label">Estado</label>
                            <select class="form-select" id="filtroEstado" name="filtroEstado">
                                <option value="">Todos</option>
                                <option value="pendiente" <%= "pendiente".equals(filtroEstado) ? "selected" : "" %>>
                                    Pendiente
                                </option>
                                <option value="en-proceso" <%= "en-proceso".equals(filtroEstado) ? "selected" : "" %>>En
                                    Proceso
                                </option>
                                <option value="atendida" <%= "atendida".equals(filtroEstado) ? "selected" : "" %>>
                                    Atendida
                                </option>
                                <option value="observada" <%= "observada".equals(filtroEstado) ? "selected" : "" %>>
                                    Observada
                                </option>
                                <option value="rechazada" <%= "rechazada".equals(filtroEstado) ? "selected" : "" %>>
                                    Rechazada
                                </option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="filtroFechaDesde" class="form-label">Fecha Desde</label>
                            <input type="text" class="form-control date-picker" id="filtroFechaDesde"
                                   name="filtroFechaDesde"
                                   value="<%= filtroFechaDesde != null ? filtroFechaDesde : "" %>"
                                   placeholder="DD/MM/YYYY">
                        </div>
                        <div class="col-md-3">
                            <label for="filtroFechaHasta" class="form-label">Fecha Hasta</label>
                            <input type="text" class="form-control date-picker" id="filtroFechaHasta"
                                   name="filtroFechaHasta"
                                   value="<%= filtroFechaHasta != null ? filtroFechaHasta : "" %>"
                                   placeholder="DD/MM/YYYY">
                        </div>
                        <div class="col-md-3">
                            <label for="filtroBusqueda" class="form-label">Búsqueda</label>
                            <input type="text" class="form-control" id="filtroBusqueda" name="filtroBusqueda"
                                   value="<%= filtroBusqueda != null ? filtroBusqueda : "" %>"
                                   placeholder="DNI, nombre o descripción">
                        </div>
                        <div class="col-12 text-end">
                            <button type="button" class="btn btn-secondary me-2" id="btnLimpiarFiltros">Limpiar</button>
                            <button type="submit" class="btn btn-primary" id="btnAplicarFiltros">Aplicar Filtros
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Resumen estadístico -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card shadow border-warning fade-in">
                        <div class="card-body">
                            <div class="d-flex">
                                <div class="me-3">
                                    <div class="bg-warning p-2 rounded">
                                        <i class="bi bi-hourglass-split text-white"></i>
                                    </div>
                                </div>
                                <div>
                                    <span class="text-muted small">Pendientes</span>
                                    <h4><%= pendientes %>
                                    </h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow border-primary fade-in">
                        <div class="card-body">
                            <div class="d-flex">
                                <div class="me-3">
                                    <div class="bg-primary p-2 rounded">
                                        <i class="bi bi-arrow-repeat text-white"></i>
                                    </div>
                                </div>
                                <div>
                                    <span class="text-muted small">En proceso</span>
                                    <h4><%= enProceso %>
                                    </h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow border-success fade-in">
                        <div class="card-body">
                            <div class="d-flex">
                                <div class="me-3">
                                    <div class="bg-success p-2 rounded">
                                        <i class="bi bi-check-circle text-white"></i>
                                    </div>
                                </div>
                                <div>
                                    <span class="text-muted small">Atendidas</span>
                                    <h4><%= atendidas %>
                                    </h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card shadow border-danger fade-in">
                        <div class="card-body">
                            <div class="d-flex">
                                <div class="me-3">
                                    <div class="bg-danger p-2 rounded">
                                        <i class="bi bi-exclamation-circle text-white"></i>
                                    </div>
                                </div>
                                <div>
                                    <span class="text-muted small">Por vencer</span>
                                    <h4><%= porVencer %>
                                    </h4>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabla de solicitudes -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-striped table-hover" id="tablaSolicitudes">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Fecha</th>
                                <th>Ciudadano</th>
                                <th>Descripción</th>
                                <th>Plazo</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (SolicitudAccesoEntidad sol : solicitudes) {
                                // Calcular días restantes
                                String diasRestantes = "Atendida";
                                String claseBarra = "bg-success";
                                int porcentajeBarra = 100;
                                boolean esPorVencer = false;

                                if (sol.getEstadoSolicitudId() != 3) { // Si no está atendida
                                    Date fechaSolicitud = sol.getFechaSolicitud();
                                    Date hoy = new Date();
                                    long diferenciaDias = TimeUnit.DAYS.convert(hoy.getTime() - fechaSolicitud.getTime(), TimeUnit.MILLISECONDS);
                                    long diasFaltantes = DIAS_LIMITE - diferenciaDias;

                                    if (diasFaltantes <= 0) {
                                        diasRestantes = "Vencida";
                                        claseBarra = "bg-danger";
                                        porcentajeBarra = 100;
                                        esPorVencer = true;
                                    } else if (diasFaltantes <= 3) {
                                        diasRestantes = diasFaltantes + " días";
                                        claseBarra = "bg-danger";
                                        porcentajeBarra = (int) ((DIAS_LIMITE - diasFaltantes) * 100 / DIAS_LIMITE);
                                        esPorVencer = true;
                                    } else {
                                        diasRestantes = diasFaltantes + " días";
                                        claseBarra = "bg-warning";
                                        porcentajeBarra = (int) ((DIAS_LIMITE - diasFaltantes) * 100 / DIAS_LIMITE);
                                    }
                                }

                                // Determinar si es fila por vencer
                                String claseFila = esPorVencer ? "table-danger" : "";
                            %>
                            <tr class="<%= claseFila %>">
                                <td><%= sol.getId() %>
                                </td>
                                <td><%= sol.getFechaSolicitud() != null ? sdf.format(sol.getFechaSolicitud()) : "N/A" %>
                                </td>
                                <td><%= sol.getCiudadano() != null ?
                                        sol.getCiudadano().getNombreCompleto() + " (DNI: " + sol.getCiudadano().getDni() + ")" :
                                        "Ciudadano no especificado" %>
                                </td>
                                <td><%= sol.getDescripcion() %>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                            <div class="progress-bar <%= claseBarra %>" role="progressbar"
                                                 style="width: <%= porcentajeBarra %>%"></div>
                                        </div>
                                        <span class="badge <%= sol.getEstadoSolicitudId() == 3 ? "bg-success" : 
                                                               (esPorVencer ? "bg-danger" : "bg-warning") %>">
                                            <%= diasRestantes %>
                                        </span>
                                    </div>
                                </td>
                                <td>
                                    <% if (sol.getEstadoSolicitudId() == 1) { %>
                                    <span class="badge bg-warning text-dark">Pendiente</span>
                                    <% } else if (sol.getEstadoSolicitudId() == 2) { %>
                                    <span class="badge bg-info">En proceso</span>
                                    <% } else if (sol.getEstadoSolicitudId() == 3) { %>
                                        <span class="badge bg-success">Atendida</span>
                                    <% } else if (sol.getEstadoSolicitudId() == 4) { %>
                                    <span class="badge bg-secondary">Observada</span>
                                    <% } else if (sol.getEstadoSolicitudId() == 5) { %>
                                    <span class="badge bg-danger">Rechazada</span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/solicitud.do?accion=detalle&id=<%= sol.getId() %>"
                                       class="btn btn-sm btn-primary">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <% if (sol.getEstadoSolicitudId() != 3 && sol.getEstadoSolicitudId() != 5) { %>
                                    <a href="<%= request.getContextPath() %>/solicitud.do?accion=prepararRespuesta&id=<%= sol.getId() %>"
                                       class="btn btn-sm btn-success">
                                        <i class="bi bi-reply"></i>
                                    </a>
                                    <% } %>
                                    <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal"
                                            data-bs-target="#historialModal" data-id="<%= sol.getId() %>">
                                        <i class="bi bi-clock-history"></i>
                                    </button>
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Modal de detalle de solicitud -->
            <div class="modal fade" id="detalleModal" tabindex="-1" aria-labelledby="detalleModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="detalleModalLabel">Detalle de Solicitud</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="text-center py-4">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Cargando...</span>
                                </div>
                                <p class="mt-2">Cargando detalles de la solicitud...</p>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal para responder solicitud -->
            <div class="modal fade" id="responderModal" tabindex="-1" aria-labelledby="responderModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="responderModalLabel">Responder Solicitud</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="text-center py-4">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Cargando...</span>
                                </div>
                                <p class="mt-2">Cargando formulario de respuesta...</p>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal para ver historial -->
            <div class="modal fade" id="historialModal" tabindex="-1" aria-labelledby="historialModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="historialModalLabel">Historial de la Solicitud</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="text-center py-4">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Cargando...</span>
                                </div>
                                <p class="mt-2">Cargando historial de la solicitud...</p>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal para exportar -->
            <div class="modal fade" id="exportarModal" tabindex="-1" aria-labelledby="exportarModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="exportarModalLabel">Exportar Datos</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="formatoExportar" class="form-label">Formato</label>
                                <select class="form-select" id="formatoExportar">
                                    <option value="excel">Microsoft Excel (.xlsx)</option>
                                    <option value="csv">CSV (.csv)</option>
                                    <option value="pdf">PDF (.pdf)</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="periodoExportar" class="form-label">Período</label>
                                <select class="form-select" id="periodoExportar">
                                    <option value="todo">Todo</option>
                                    <option value="mes">Este mes</option>
                                    <option value="trimestre">Este trimestre</option>
                                    <option value="anio">Este año</option>
                                    <option value="personalizado">Personalizado</option>
                                </select>
                            </div>
                            <div id="fechasPersonalizadas" class="row" style="display: none;">
                                <div class="col-md-6">
                                    <label for="exportarDesde" class="form-label">Desde</label>
                                    <input type="text" class="form-control date-picker" id="exportarDesde">
                                </div>
                                <div class="col-md-6">
                                    <label for="exportarHasta" class="form-label">Hasta</label>
                                    <input type="text" class="form-control date-picker" id="exportarHasta">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="camposExportar" class="form-label">Campos a exportar</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="campoId" checked>
                                    <label class="form-check-label" for="campoId">ID</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="campoFecha" checked>
                                    <label class="form-check-label" for="campoFecha">Fecha</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="campoCiudadano" checked>
                                    <label class="form-check-label" for="campoCiudadano">Datos del solicitante</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="campoDescripcion" checked>
                                    <label class="form-check-label" for="campoDescripcion">Descripción</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="campoEstado" checked>
                                    <label class="form-check-label" for="campoEstado">Estado</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="campoPlazo" checked>
                                    <label class="form-check-label" for="campoPlazo">Plazo</label>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="button" class="btn btn-primary" id="btnExportar">
                                <i class="bi bi-download me-1"></i> Exportar
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/es.js"></script>
<script>
    $(document).ready(function () {
        // Inicializar DataTables
        $('#tablaSolicitudes').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            pageLength: 10,
            order: [[1, 'desc']], // Ordenar por fecha descendente
            responsive: true
        });

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

        // Mostrar/ocultar fechas personalizadas en exportación
        $('#periodoExportar').change(function () {
            if ($(this).val() === 'personalizado') {
                $('#fechasPersonalizadas').show();
            } else {
                $('#fechasPersonalizadas').hide();
            }
        });

        // Limpiar filtros
        $('#btnLimpiarFiltros').click(function () {
            // Limpiar todos los campos del formulario
            $('#filtroEstado').val('');
            $('#filtroFechaDesde').val('');
            $('#filtroFechaHasta').val('');
            $('#filtroBusqueda').val('');

            // Enviar el formulario sin filtros
            $('#formFiltros').submit();
        });

        // Filtros rápidos del menú desplegable
        $('#filtroHoy').click(function (e) {
            e.preventDefault();
            const hoy = new Date().toLocaleDateString('es-ES', {day: '2-digit', month: '2-digit', year: 'numeric'});
            $('#filtroFechaDesde, #filtroFechaHasta').val(hoy);
            $('#formFiltros').submit();
        });

        $('#filtroSemana').click(function (e) {
            e.preventDefault();
            // Obtener fecha de inicio de semana (lunes)
            const hoy = new Date();
            const inicioSemana = new Date(hoy);
            inicioSemana.setDate(hoy.getDate() - hoy.getDay() + (hoy.getDay() === 0 ? -6 : 1));

            $('#filtroFechaDesde').val(inicioSemana.toLocaleDateString('es-ES', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            }));
            $('#filtroFechaHasta').val(hoy.toLocaleDateString('es-ES', {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric'
            }));
            $('#formFiltros').submit();
        });

        $('#filtroPendientes').click(function (e) {
            e.preventDefault();
            $('#filtroEstado').val('pendiente');
            $('#formFiltros').submit();
        });

        $('#filtroVencidas').click(function (e) {
            e.preventDefault();
            // Para las vencidas o por vencer, redirigimos directamente
            window.location.href = '<%= request.getContextPath() %>/solicitud.do?accion=listar&filtroVencidas=true';
        });

        $('#filtroLimpiar').click(function (e) {
            e.preventDefault();
            $('#btnLimpiarFiltros').click();
        });

        // Configurar modales dinámicos
        $('#detalleModal').on('show.bs.modal', function (e) {
            const id = $(e.relatedTarget).data('id');
            $(this).find('.modal-title').text('Detalle de Solicitud #' + id);

            // Redirigir a la página de detalle en lugar de mostrar el modal
            window.location.href = '<%= request.getContextPath() %>/solicitud.do?accion=detalle&id=' + id;
        });

        $('#responderModal').on('show.bs.modal', function (e) {
            const id = $(e.relatedTarget).data('id');
            $(this).find('.modal-title').text('Responder Solicitud #' + id);

            // Redirigir a la página de respuesta
            window.location.href = '<%= request.getContextPath() %>/solicitud.do?accion=prepararRespuesta&id=' + id;
        });

        $('#historialModal').on('show.bs.modal', function (e) {
            const id = $(e.relatedTarget).data('id');
            $(this).find('.modal-title').text('Historial de la Solicitud #' + id);

            // Aquí se puede implementar la carga del historial mediante AJAX
            // Por ahora, redirigimos a la página de detalle que incluya el historial
            window.location.href = '<%= request.getContextPath() %>/solicitud.do?accion=detalle&id=' + id + '&tab=historial';
        });

        // Manejo del botón de exportación
        $('#btnExportar').click(function () {
            // Aquí iría la lógica para exportar los datos
            // Por ahora solo mostramos un mensaje
            alert('Funcionalidad de exportación no implementada');
            $('#exportarModal').modal('hide');
        });
    });
</script>
</body>
</html>
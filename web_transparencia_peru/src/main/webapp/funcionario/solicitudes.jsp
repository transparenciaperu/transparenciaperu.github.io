<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%
    // Verificar si el usuario está en sesión y es funcionario
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("FUNCIONARIO")) {
        // No es funcionario o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");
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
                    <form id="formFiltros" class="row g-3">
                        <div class="col-md-3">
                            <label for="filtroEstado" class="form-label">Estado</label>
                            <select class="form-select" id="filtroEstado">
                                <option value="">Todos</option>
                                <option value="pendiente">Pendiente</option>
                                <option value="en-proceso">En Proceso</option>
                                <option value="atendida">Atendida</option>
                                <option value="observada">Observada</option>
                                <option value="rechazada">Rechazada</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label for="filtroFechaDesde" class="form-label">Fecha Desde</label>
                            <input type="text" class="form-control date-picker" id="filtroFechaDesde"
                                   placeholder="DD/MM/YYYY">
                        </div>
                        <div class="col-md-3">
                            <label for="filtroFechaHasta" class="form-label">Fecha Hasta</label>
                            <input type="text" class="form-control date-picker" id="filtroFechaHasta"
                                   placeholder="DD/MM/YYYY">
                        </div>
                        <div class="col-md-3">
                            <label for="filtroBusqueda" class="form-label">Búsqueda</label>
                            <input type="text" class="form-control" id="filtroBusqueda"
                                   placeholder="DNI, nombre o descripción">
                        </div>
                        <div class="col-12 text-end">
                            <button type="button" class="btn btn-secondary me-2" id="btnLimpiarFiltros">Limpiar</button>
                            <button type="button" class="btn btn-primary" id="btnAplicarFiltros">Aplicar Filtros
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
                                    <h4>8</h4>
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
                                    <h4>5</h4>
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
                                    <h4>12</h4>
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
                                    <h4>3</h4>
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
                            <tr>
                                <td>2453</td>
                                <td>30/04/2024</td>
                                <td>Juan Rodríguez (DNI: 45678912)</td>
                                <td>Solicitud de información presupuestal sobre proyectos de inversión en educación del
                                    año 2023.
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                            <div class="progress-bar bg-warning" role="progressbar"
                                                 style="width: 60%"></div>
                                        </div>
                                        <span class="badge bg-warning">4 días</span>
                                    </div>
                                </td>
                                <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                            data-bs-target="#detalleModal" data-id="2453">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal"
                                            data-bs-target="#responderModal" data-id="2453">
                                        <i class="bi bi-reply"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal"
                                            data-bs-target="#historialModal" data-id="2453">
                                        <i class="bi bi-clock-history"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>2452</td>
                                <td>29/04/2024</td>
                                <td>María Sánchez (DNI: 76543219)</td>
                                <td>Información sobre proyectos de mejora de infraestructura vial en el distrito.</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                            <div class="progress-bar bg-warning" role="progressbar"
                                                 style="width: 50%"></div>
                                        </div>
                                        <span class="badge bg-warning">5 días</span>
                                    </div>
                                </td>
                                <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                            data-bs-target="#detalleModal" data-id="2452">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal"
                                            data-bs-target="#responderModal" data-id="2452">
                                        <i class="bi bi-reply"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal"
                                            data-bs-target="#historialModal" data-id="2452">
                                        <i class="bi bi-clock-history"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>2451</td>
                                <td>28/04/2024</td>
                                <td>Carlos Torres (DNI: 23456781)</td>
                                <td>Información sobre procesos de contratación pública del último trimestre.</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                            <div class="progress-bar bg-success" role="progressbar"
                                                 style="width: 100%"></div>
                                        </div>
                                        <span class="badge bg-success">Atendida</span>
                                    </div>
                                </td>
                                <td><span class="badge bg-success">Atendida</span></td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                            data-bs-target="#detalleModal" data-id="2451">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal"
                                            data-bs-target="#historialModal" data-id="2451">
                                        <i class="bi bi-clock-history"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>2450</td>
                                <td>27/04/2024</td>
                                <td>Laura Flores (DNI: 34567891)</td>
                                <td>Solicitud de información sobre planilla de personal.</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                            <div class="progress-bar bg-info" role="progressbar"
                                                 style="width: 70%"></div>
                                        </div>
                                        <span class="badge bg-info">En proceso</span>
                                    </div>
                                </td>
                                <td><span class="badge bg-info">En proceso</span></td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                            data-bs-target="#detalleModal" data-id="2450">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal"
                                            data-bs-target="#responderModal" data-id="2450">
                                        <i class="bi bi-reply"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal"
                                            data-bs-target="#historialModal" data-id="2450">
                                        <i class="bi bi-clock-history"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr class="table-danger">
                                <td>2449</td>
                                <td>20/04/2024</td>
                                <td>Pedro González (DNI: 87654321)</td>
                                <td>Solicitud de acceso a expedientes de obras públicas.</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                            <div class="progress-bar bg-danger" role="progressbar"
                                                 style="width: 90%"></div>
                                        </div>
                                        <span class="badge bg-danger">1 día</span>
                                    </div>
                                </td>
                                <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                            data-bs-target="#detalleModal" data-id="2449">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-success" data-bs-toggle="modal"
                                            data-bs-target="#responderModal" data-id="2449">
                                        <i class="bi bi-reply"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal"
                                            data-bs-target="#historialModal" data-id="2449">
                                        <i class="bi bi-clock-history"></i>
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>2448</td>
                                <td>18/04/2024</td>
                                <td>Ana Martínez (DNI: 12345678)</td>
                                <td>Información sobre programas sociales ejecutados en 2023.</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="progress flex-grow-1 me-2" style="height: 8px;">
                                            <div class="progress-bar bg-success" role="progressbar"
                                                 style="width: 100%"></div>
                                        </div>
                                        <span class="badge bg-success">Atendida</span>
                                    </div>
                                </td>
                                <td><span class="badge bg-success">Atendida</span></td>
                                <td>
                                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                            data-bs-target="#detalleModal" data-id="2448">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-info" data-bs-toggle="modal"
                                            data-bs-target="#historialModal" data-id="2448">
                                        <i class="bi bi-clock-history"></i>
                                    </button>
                                </td>
                            </tr>
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
                            <h5 class="modal-title" id="detalleModalLabel">Detalle de Solicitud #2453</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
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
                                                    <td>Juan Rodríguez</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>DNI:</strong></td>
                                                    <td>45678912</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Correo:</strong></td>
                                                    <td>juan.rodriguez@example.com</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Teléfono:</strong></td>
                                                    <td>987654321</td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="fw-bold">Datos de la Solicitud</h6>
                                            <table class="table table-sm">
                                                <tr>
                                                    <td width="40%"><strong>ID:</strong></td>
                                                    <td>2453</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Fecha:</strong></td>
                                                    <td>30/04/2024</td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Estado:</strong></td>
                                                    <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                                                </tr>
                                                <tr>
                                                    <td><strong>Plazo:</strong></td>
                                                    <td><span class="text-warning fw-bold">4 días restantes</span></td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <h6 class="fw-bold">Descripción de la Solicitud</h6>
                                        <div class="p-3 bg-light rounded">
                                            <p>Solicitud de información presupuestal sobre proyectos de inversión en
                                                educación del año 2023.</p>
                                            <p>Solicito detalle de los siguientes aspectos:</p>
                                            <ol>
                                                <li>Presupuesto asignado a cada proyecto de inversión en el sector
                                                    educación durante el año 2023.
                                                </li>
                                                <li>Ejecución presupuestal detallada por proyecto, indicando montos
                                                    ejecutados, saldos y porcentajes de avance.
                                                </li>
                                                <li>Relación de proveedores que ejecutaron dichos proyectos, con montos
                                                    adjudicados.
                                                </li>
                                                <li>Información sobre modificaciones presupuestales realizadas durante
                                                    el ejercicio.
                                                </li>
                                            </ol>
                                            <p>La información solicitada es para un trabajo de investigación académica
                                                en políticas públicas educativas.</p>
                                        </div>
                                    </div>
                                    <div class="mb-3">
                                        <h6 class="fw-bold">Observaciones</h6>
                                        <textarea class="form-control" id="observacionesSolicitud" rows="3"
                                                  placeholder="Ingrese observaciones internas sobre esta solicitud (solo visible para funcionarios)"></textarea>
                                    </div>
                                </div>

                                <div class="tab-pane fade" id="documentos" role="tabpanel"
                                     aria-labelledby="documentos-tab">
                                    <h6 class="mb-3">Documentos Adjuntos a la Solicitud</h6>
                                    <ul class="list-group mb-4">
                                        <li class="list-group-item d-flex justify-content-between align-items-center">
                                            <div>
                                                <i class="bi bi-file-pdf text-danger me-2"></i> Carta_Presentacion.pdf
                                            </div>
                                            <div>
                                                <button class="btn btn-sm btn-primary">
                                                    <i class="bi bi-eye"></i> Ver
                                                </button>
                                                <button class="btn btn-sm btn-secondary">
                                                    <i class="bi bi-download"></i> Descargar
                                                </button>
                                            </div>
                                        </li>
                                    </ul>

                                    <h6 class="mb-3">Documentos de Respuesta</h6>
                                    <div class="alert alert-info mb-3">
                                        <i class="bi bi-info-circle me-2"></i> No hay documentos de respuesta
                                        disponibles.
                                    </div>

                                    <form id="formAdjuntarDocumentos">
                                        <div class="mb-3">
                                            <label for="documentoRespuesta" class="form-label">Adjuntar
                                                documento</label>
                                            <input class="form-control" type="file" id="documentoRespuesta">
                                        </div>
                                        <div class="mb-3">
                                            <label for="descripcionDocumento" class="form-label">Descripción</label>
                                            <input type="text" class="form-control" id="descripcionDocumento"
                                                   placeholder="Describa brevemente el documento">
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-primary">
                                                <i class="bi bi-upload me-1"></i> Subir Documento
                                            </button>
                                        </div>
                                    </form>
                                </div>

                                <div class="tab-pane fade" id="seguimiento" role="tabpanel"
                                     aria-labelledby="seguimiento-tab">
                                    <div class="timeline mb-4">
                                        <div class="timeline-item">
                                            <div class="timeline-date">30/04/2024 - 09:15</div>
                                            <div class="timeline-content">
                                                <h6 class="mb-1"><i
                                                        class="bi bi-file-earmark-plus me-2 text-primary"></i> Solicitud
                                                    recibida</h6>
                                                <p class="mb-0 text-muted small">La solicitud fue registrada en el
                                                    sistema.</p>
                                            </div>
                                        </div>
                                        <div class="timeline-item">
                                            <div class="timeline-date">30/04/2024 - 10:30</div>
                                            <div class="timeline-content">
                                                <h6 class="mb-1"><i class="bi bi-person-check me-2 text-info"></i>
                                                    Asignada a funcionario</h6>
                                                <p class="mb-0 text-muted small">La solicitud fue asignada
                                                    a <%= usuario.getNombreCompleto() %>
                                                </p>
                                            </div>
                                        </div>
                                    </div>

                                    <h6 class="mb-3">Añadir nueva entrada de seguimiento</h6>
                                    <form id="formSeguimiento">
                                        <div class="mb-3">
                                            <label for="tipoSeguimiento" class="form-label">Tipo</label>
                                            <select class="form-select" id="tipoSeguimiento">
                                                <option value="nota">Nota interna</option>
                                                <option value="derivacion">Derivación</option>
                                                <option value="comunicacion">Comunicación con ciudadano</option>
                                                <option value="actualizacion">Actualización de estado</option>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="descripcionSeguimiento" class="form-label">Descripción</label>
                                            <textarea class="form-control" id="descripcionSeguimiento"
                                                      rows="3"></textarea>
                                        </div>
                                        <div class="text-end">
                                            <button type="button" class="btn btn-primary">
                                                <i class="bi bi-plus-circle me-1"></i> Añadir Seguimiento
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="button" class="btn btn-primary" data-bs-dismiss="modal" data-bs-toggle="modal"
                                    data-bs-target="#responderModal" data-id="2453">Responder
                            </button>
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
                            <h5 class="modal-title" id="responderModalLabel">Responder Solicitud #2453</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="formRespuesta" method="post" action="<%= request.getContextPath() %>/funcionario.do">
                            <input type="hidden" name="accion" value="responderSolicitud">
                            <input type="hidden" name="solicitudId" value="2453">
                            <div class="modal-body">
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
                                        proporcionada es correcta y estoy autorizado para enviarla</label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar
                                </button>
                                <button type="submit" class="btn btn-primary">Enviar Respuesta</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Modal para ver historial -->
            <div class="modal fade" id="historialModal" tabindex="-1" aria-labelledby="historialModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="historialModalLabel">Historial de la Solicitud #2453</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="timeline">
                                <div class="timeline-item">
                                    <div class="timeline-date">30/04/2024 - 09:15</div>
                                    <div class="timeline-content">
                                        <h6 class="mb-1"><i class="bi bi-file-earmark-plus me-2 text-primary"></i>
                                            Solicitud recibida</h6>
                                        <p class="mb-0 text-muted small">La solicitud fue registrada en el sistema.</p>
                                    </div>
                                </div>
                                <div class="timeline-item">
                                    <div class="timeline-date">30/04/2024 - 10:30</div>
                                    <div class="timeline-content">
                                        <h6 class="mb-1"><i class="bi bi-person-check me-2 text-info"></i> Asignada a
                                            funcionario</h6>
                                        <p class="mb-0 text-muted small">La solicitud fue asignada
                                            a <%= usuario.getNombreCompleto() %>
                                        </p>
                                    </div>
                                </div>
                                <div class="timeline-item">
                                    <div class="timeline-date">30/04/2024 - 11:45</div>
                                    <div class="timeline-content">
                                        <h6 class="mb-1"><i class="bi bi-chat-left-text me-2 text-success"></i> Nota
                                            interna</h6>
                                        <p class="mb-0 text-muted small">Se requiere consultar con el área de
                                            presupuesto para obtener la información solicitada.</p>
                                    </div>
                                </div>
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
                            <button type="button" class="btn btn-primary">
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

        // Aplicar filtros
        $('#btnAplicarFiltros').click(function () {
            const table = $('#tablaSolicitudes').DataTable();
            table.draw();
        });

        // Limpiar filtros
        $('#btnLimpiarFiltros').click(function () {
            $('#formFiltros')[0].reset();
            const table = $('#tablaSolicitudes').DataTable();
            table.draw();
        });

        // Filtros rápidos del menú desplegable
        $('#filtroHoy').click(function (e) {
            e.preventDefault();
            const hoy = new Date().toLocaleDateString('es-ES', {day: '2-digit', month: '2-digit', year: 'numeric'});
            $('#filtroFechaDesde, #filtroFechaHasta').val(hoy);
            $('#btnAplicarFiltros').click();
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
            $('#btnAplicarFiltros').click();
        });

        $('#filtroPendientes').click(function (e) {
            e.preventDefault();
            $('#filtroEstado').val('pendiente');
            $('#btnAplicarFiltros').click();
        });

        $('#filtroVencidas').click(function (e) {
            e.preventDefault();
            // Esto sería implementado con una búsqueda personalizada en servidor
            // Por ahora simplemente filtramos las filas con clase 'table-danger'
            const table = $('#tablaSolicitudes').DataTable();
            $.fn.dataTable.ext.search.push(function (settings, data, dataIndex) {
                const $row = $(table.row(dataIndex).node());
                return $row.hasClass('table-danger');
            });
            table.draw();
            $.fn.dataTable.ext.search.pop(); // Eliminar el filtro después de usarlo
        });

        $('#filtroLimpiar').click(function (e) {
            e.preventDefault();
            $('#btnLimpiarFiltros').click();
        });

        // Configurar visualización de solicitud en modal
        $('#detalleModal').on('show.bs.modal', function (e) {
            const id = $(e.relatedTarget).data('id');
            $(this).find('.modal-title').text('Detalle de Solicitud #' + id);

            // En un caso real, aquí se cargarían los datos de la solicitud mediante AJAX
        });

        $('#responderModal').on('show.bs.modal', function (e) {
            const id = $(e.relatedTarget).data('id');
            $(this).find('.modal-title').text('Responder Solicitud #' + id);
            $(this).find('input[name="solicitudId"]').val(id);

            // En un caso real, aquí se cargarían datos adicionales mediante AJAX
        });

        $('#historialModal').on('show.bs.modal', function (e) {
            const id = $(e.relatedTarget).data('id');
            $(this).find('.modal-title').text('Historial de la Solicitud #' + id);

            // En un caso real, aquí se cargaría el historial mediante AJAX
        });
    });
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.CiudadanoEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.SolicitudAccesoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.SolicitudAccesoModelo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("ciudadano") == null) {
        // No está logueado como ciudadano, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    CiudadanoEntidad ciudadano = (CiudadanoEntidad) sesion.getAttribute("ciudadano");

    // Obtener solicitudes del ciudadano
    List<SolicitudAccesoEntidad> solicitudes = new ArrayList<>();
    SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();

    try {
        solicitudes = modelo.listarSolicitudesPorCiudadano(ciudadano.getId());
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Contar solicitudes por estado
    int pendientes = 0;
    int enProceso = 0;
    int atendidas = 0;

    for (SolicitudAccesoEntidad sol : solicitudes) {
        switch (sol.getEstadoSolicitudId()) {
            case 1:
                pendientes++;
                break;
            case 2:
                enProceso++;
                break;
            case 3:
                atendidas++;
                break;
        }
    }

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Solicitudes - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ciudadano.css">
</head>
<body class="ciudadano-theme">
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Mis Solicitudes</a>
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
                        <li><a class="dropdown-item" href="perfil.jsp"><i class="bi bi-person me-1"></i> Mi Perfil</a>
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
                        <a class="nav-link" href="index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="mis_solicitudes.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Mis Solicitudes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="nueva_solicitud.jsp">
                            <i class="bi bi-file-plus me-1"></i> Nueva Solicitud
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="perfil.jsp">
                            <i class="bi bi-person me-1"></i> Mi Perfil
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="presupuesto.jsp">
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
                <h1 class="h2">Mis Solicitudes de Información</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="nueva_solicitud.jsp" class="btn btn-primary">
                        <i class="bi bi-plus-circle me-1"></i> Nueva Solicitud
                    </a>
                </div>
            </div>

            <!-- Filtros y búsqueda -->
            <div class="card mb-4 fade-in">
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-8">
                            <h5 class="card-title mb-3">Filtros de búsqueda</h5>
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="filtroEstado" class="form-label">Estado</label>
                                    <select class="form-select" id="filtroEstado" name="filtroEstado">
                                        <option value="">Todos</option>
                                        <option value="pendiente">Pendiente</option>
                                        <option value="en-proceso">En Proceso</option>
                                        <option value="atendida">Atendida</option>
                                        <option value="observada">Observada</option>
                                        <option value="rechazada">Rechazada</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="filtroEntidad" class="form-label">Entidad</label>
                                    <select class="form-select" id="filtroEntidad" name="filtroEntidad">
                                        <option value="">Todas</option>
                                        <%
                                            // Crear un conjunto único de entidades de las solicitudes
                                            java.util.Set<Integer> entidadesIds = new java.util.HashSet<>();
                                            java.util.Map<Integer, String> entidades = new java.util.HashMap<>();

                                            for (SolicitudAccesoEntidad sol : solicitudes) {
                                                if (sol.getEntidadPublica() != null && sol.getEntidadPublicaId() > 0) {
                                                    if (!entidadesIds.contains(sol.getEntidadPublicaId())) {
                                                        entidadesIds.add(sol.getEntidadPublicaId());
                                                        entidades.put(sol.getEntidadPublicaId(), sol.getEntidadPublica().getNombre());
                                                    }
                                                }
                                            }

                                            // Mostrar las entidades en el dropdown
                                            for (java.util.Map.Entry<Integer, String> entry : entidades.entrySet()) {
                                        %>
                                        <option value="<%= entry.getKey() %>"><%= entry.getValue() %>
                                        </option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="filtroFecha" class="form-label">Año</label>
                                    <select class="form-select" id="filtroFecha" name="filtroFecha">
                                        <option value="">Todos</option>
                                        <option value="2024">2024</option>
                                        <option value="2023">2023</option>
                                        <option value="2022">2022</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <h5 class="card-title mb-3">Resumen</h5>
                            <div class="d-flex justify-content-between mb-2">
                                <div><i class="bi bi-circle-fill text-warning me-1"></i> Pendientes</div>
                                <span class="badge bg-light text-dark"><%= pendientes %></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <div><i class="bi bi-circle-fill text-primary me-1"></i> En proceso</div>
                                <span class="badge bg-light text-dark"><%= enProceso %></span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <div><i class="bi bi-circle-fill text-success me-1"></i> Atendidas</div>
                                <span class="badge bg-light text-dark"><%= atendidas %></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-responsive fade-in">
                <table class="table table-striped table-hover" id="tablaSolicitudes">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Fecha Solicitud</th>
                        <th>Entidad</th>
                        <th>Descripción</th>
                        <th>Estado</th>
                        <th>Fecha Respuesta</th>
                        <th>Acciones</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (SolicitudAccesoEntidad sol : solicitudes) { %>
                    <tr>
                        <td><%= sol.getId() %>
                        </td>
                        <td><%= sol.getFechaSolicitud() != null ? sdf.format(sol.getFechaSolicitud()) : "N/A" %>
                        </td>
                        <td><%= sol.getEntidadPublica() != null ? sol.getEntidadPublica().getNombre() : "Entidad no especificada" %>
                        </td>
                        <td><%= sol.getDescripcion() %>
                        </td>
                        <td>
                            <% if (sol.getEstadoSolicitudId() == 1) { %>
                            <span class="badge bg-warning">Pendiente</span>
                            <% } else if (sol.getEstadoSolicitudId() == 2) { %>
                            <span class="badge bg-primary">En proceso</span>
                            <% } else if (sol.getEstadoSolicitudId() == 3) { %>
                            <span class="badge bg-success">Atendida</span>
                            <% } else if (sol.getEstadoSolicitudId() == 4) { %>
                            <span class="badge bg-info">Observada</span>
                            <% } else if (sol.getEstadoSolicitudId() == 5) { %>
                            <span class="badge bg-danger">Rechazada</span>
                            <% } %>
                        </td>
                        <td><%= sol.getFechaRespuesta() != null ? sdf.format(sol.getFechaRespuesta()) : "-" %>
                        </td>
                        <td>
                            <a href="<%= request.getContextPath() %>/solicitud.do?accion=detalle&id=<%= sol.getId() %>"
                               class="btn btn-sm btn-primary">
                                <i class="bi bi-eye"></i> Ver
                            </a>
                            <% if (sol.getEstadoSolicitudId() == 3 || sol.getEstadoSolicitudId() == 5) { %>
                            <a href="<%= request.getContextPath() %>/solicitud.do?accion=verRespuesta&id=<%= sol.getId() %>"
                               class="btn btn-sm btn-success">
                                <i class="bi bi-file-text"></i> Respuesta
                            </a>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Nota: En lugar de usar modales para mostrar detalles, respuestas o rechazos, 
                 se utiliza redirección directa a páginas dedicadas mediante los botones "Ver" y "Respuesta" -->
        </main>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
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

        // Manejar los filtros
        $('#filtroEstado, #filtroEntidad, #filtroFecha').change(function () {
            const table = $('#tablaSolicitudes').DataTable();
            table.draw();
        });

        // Personalizar la búsqueda de DataTables
        $.fn.dataTable.ext.search.push(
            function (settings, data, dataIndex) {
                let filtroEstado = $('#filtroEstado').val().toLowerCase();
                let filtroEntidad = $('#filtroEntidad').val();
                let filtroFecha = $('#filtroFecha').val();

                let estado = data[4].toLowerCase();
                let entidad = data[2];
                let fecha = data[1];

                // Filtro por estado
                if (filtroEstado && !estado.includes(filtroEstado)) {
                    return false;
                }

                // Filtro por entidad
                if (filtroEntidad && filtroEntidad !== "") {
                    // Busca el ID de la entidad en el texto (que contiene nombre y más información)
                    if (entidad.indexOf("ID: " + filtroEntidad) === -1) {
                        return false;
                    }
                }

                // Filtro por año
                if (filtroFecha && filtroFecha !== "") {
                    // Extrae el año de la fecha (formato dd/mm/yyyy)
                    let anio = fecha.split('/')[2];
                    if (anio !== filtroFecha) {
                        return false;
                    }
                }

                return true;
            }
        );

        // Configurar modales dinámicos
        $('#detalleModal').on('show.bs.modal', function (event) {
            const button = $(event.relatedTarget);
            const solicitudId = button.data('solicitud');
            // Aquí se cargarían los datos reales de la solicitud mediante AJAX
            // Por ahora mostramos datos de ejemplo
            $('#detalle-id').text(solicitudId);
            // Los demás campos se cargarían de manera similar
        });

        $('#respuestaModal').on('show.bs.modal', function (event) {
            const button = $(event.relatedTarget);
            const solicitudId = button.data('solicitud');
            // Aquí se cargarían los datos reales de la respuesta mediante AJAX
        });

        $('#rechazoModal').on('show.bs.modal', function (event) {
            const button = $(event.relatedTarget);
            const solicitudId = button.data('solicitud');
            // Aquí se cargarían los datos reales del rechazo mediante AJAX
        });

        // Botón para descargar todos los archivos
        $('#btnDescargarTodo').click(function () {
            alert('La descarga de archivos comenzará en breve');
            // Aquí iría la lógica para descargar todos los archivos
        });
    });
</script>
</body>
</html>
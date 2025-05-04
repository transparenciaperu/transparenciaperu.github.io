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
                                    <select class="form-select" id="filtroEstado">
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
                                    <select class="form-select" id="filtroEntidad">
                                        <option value="">Todas</option>
                                        <option value="1">Ministerio de Educación</option>
                                        <option value="2">Ministerio de Salud</option>
                                        <option value="3">Municipalidad de Lima</option>
                                        <option value="4">OSINERGMIN</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label for="filtroFecha" class="form-label">Año</label>
                                    <select class="form-select" id="filtroFecha">
                                        <option value="">Todos</option>
                                        <option value="2024" selected>2024</option>
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

            <!-- Modal para ver detalle de solicitud -->
            <div class="modal fade" id="detalleModal" tabindex="-1" aria-labelledby="detalleModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="detalleModalLabel">Detalle de la Solicitud</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <h6 class="fw-bold">Información de la Solicitud</h6>
                                    <table class="table table-sm">
                                        <tbody>
                                        <tr>
                                            <td class="fw-bold">ID:</td>
                                            <td id="detalle-id">1018</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold">Fecha:</td>
                                            <td id="detalle-fecha">28/04/2024</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold">Estado:</td>
                                            <td id="detalle-estado"><span class="badge bg-warning">Pendiente</span></td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold">Tipo:</td>
                                            <td id="detalle-tipo">Información Presupuestal</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="fw-bold">Información de la Entidad</h6>
                                    <table class="table table-sm">
                                        <tbody>
                                        <tr>
                                            <td class="fw-bold">Entidad:</td>
                                            <td id="detalle-entidad">Ministerio de Educación</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold">Tipo:</td>
                                            <td id="detalle-tipo-entidad">Ministerio</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-bold">Nivel:</td>
                                            <td id="detalle-nivel">Nacional</td>
                                        </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>

                            <h6 class="fw-bold">Descripción de la Solicitud</h6>
                            <div class="p-3 bg-light rounded mb-3" id="detalle-descripcion">
                                Solicito información detallada sobre los programas de becas estudiantiles implementados
                                por el Ministerio de Educación durante el año 2024, incluyendo:
                                <ol>
                                    <li>Presupuesto asignado a cada programa</li>
                                    <li>Número de beneficiarios por programa</li>
                                    <li>Criterios de selección utilizados</li>
                                    <li>Distribución de beneficiarios por región</li>
                                </ol>
                                Esta información es requerida con fines de investigación académica.
                            </div>

                            <div class="timeline mt-4">
                                <h6 class="fw-bold">Seguimiento de la Solicitud</h6>
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <div class="d-flex justify-content-between">
                                            <span><i class="bi bi-circle-fill text-success me-2"></i> Solicitud recibida</span>
                                            <small>28/04/2024</small>
                                        </div>
                                    </li>
                                    <li class="list-group-item">
                                        <div class="d-flex justify-content-between">
                                            <span><i class="bi bi-circle-fill text-warning me-2"></i> En proceso de evaluación</span>
                                            <small>Pendiente</small>
                                        </div>
                                    </li>
                                    <li class="list-group-item">
                                        <div class="d-flex justify-content-between">
                                            <span><i class="bi bi-circle-fill text-secondary me-2"></i> Respuesta enviada</span>
                                            <small>Pendiente</small>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <a href="nueva_solicitud.jsp" class="btn btn-primary">Nueva Solicitud</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal para ver respuesta -->
            <div class="modal fade" id="respuestaModal" tabindex="-1" aria-labelledby="respuestaModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title" id="respuestaModalLabel">Respuesta a su Solicitud</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle-fill me-2"></i> Su solicitud ha sido atendida
                                satisfactoriamente.
                            </div>

                            <div class="mb-3">
                                <h6 class="fw-bold">Información de la Respuesta</h6>
                                <table class="table">
                                    <tbody>
                                    <tr>
                                        <td width="30%" class="fw-bold">Fecha de respuesta:</td>
                                        <td id="respuesta-fecha">25/04/2024</td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold">Respondido por:</td>
                                        <td id="respuesta-funcionario">Carlos Morales - Director de Transparencia</td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div class="mb-3">
                                <h6 class="fw-bold">Respuesta:</h6>
                                <div class="p-3 bg-light rounded" id="respuesta-contenido">
                                    <p>Estimado ciudadano,</p>
                                    <p>En atención a su solicitud de acceso a la información sobre planos urbanos del
                                        distrito de San Isidro, le remitimos la siguiente información:</p>
                                    <ol>
                                        <li>Se adjunta archivo PDF con los planos solicitados</li>
                                        <li>Se incluye información sobre zonificación actualizada</li>
                                        <li>Se proporciona link para acceso a visualizador de mapas online</li>
                                    </ol>
                                    <p>Para acceder al visualizador online, ingrese a: <a href="#" class="text-primary">http://gis.munlima.gob.pe/mapa</a>
                                    </p>
                                    <p>Quedamos a su disposición para cualquier consulta adicional.</p>
                                </div>
                            </div>

                            <div class="mb-3">
                                <h6 class="fw-bold">Archivos adjuntos:</h6>
                                <ul class="list-group">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="bi bi-file-pdf me-2 text-danger"></i> Planos_SanIsidro_2024.pdf
                                        </div>
                                        <button class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-download"></i> Descargar
                                        </button>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="bi bi-file-excel me-2 text-success"></i>
                                            Zonificación_SanIsidro_2024.xlsx
                                        </div>
                                        <button class="btn btn-sm btn-outline-primary">
                                            <i class="bi bi-download"></i> Descargar
                                        </button>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="button" class="btn btn-primary" id="btnDescargarTodo">
                                <i class="bi bi-download me-1"></i> Descargar todo
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal para motivo de rechazo -->
            <div class="modal fade" id="rechazoModal" tabindex="-1" aria-labelledby="rechazoModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title" id="rechazoModalLabel">Solicitud Rechazada</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> Su solicitud no pudo ser atendida.
                            </div>

                            <div class="mb-3">
                                <h6 class="fw-bold">Motivo del rechazo:</h6>
                                <div class="p-3 bg-light rounded" id="rechazo-motivo">
                                    <p>La solicitud no pudo ser atendida por los siguientes motivos:</p>
                                    <ol>
                                        <li>La información solicitada contiene datos sensibles protegidos por la Ley de
                                            Protección de Datos Personales (Ley N° 29733)
                                        </li>
                                        <li>Los contratos específicos solicitados están bajo investigación fiscal y su
                                            divulgación podría afectar el proceso investigatorio
                                        </li>
                                    </ol>
                                    <p>Base legal: Artículo 17 del TUO de la Ley de Transparencia y Acceso a la
                                        Información Pública.</p>
                                    <p>Tiene derecho a presentar un recurso de apelación ante el Tribunal de
                                        Transparencia y Acceso a la Información Pública en un plazo de 15 días
                                        hábiles.</p>
                                </div>
                            </div>

                            <div class="mb-3">
                                <h6 class="fw-bold">Alternativas:</h6>
                                <ul>
                                    <li>Puede reformular su solicitud excluyendo la información de carácter
                                        confidencial
                                    </li>
                                    <li>Puede solicitar información estadística agregada sobre el tema</li>
                                    <li>Puede consultar la información pública ya disponible en el portal de
                                        transparencia
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <a href="nueva_solicitud.jsp" class="btn btn-primary">
                                <i class="bi bi-pencil-square me-1"></i> Reformular solicitud
                            </a>
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
                if (filtroEntidad && filtroEntidad !== "" && !entidad.includes(filtroEntidad)) {
                    return false;
                }

                // Filtro por año
                if (filtroFecha && filtroFecha !== "" && !fecha.includes(filtroFecha)) {
                    return false;
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
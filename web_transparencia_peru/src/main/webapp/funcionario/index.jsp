<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="java.sql.*" %>
<%@ page import="pe.gob.transparencia.util.ConexionBD" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedHashMap" %>
<%
    // Verificar si el usuario está en sesión y es funcionario
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("FUNCIONARIO")) {
        // No es funcionario o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Variables para estadísticas y datos de gráficos
    int solicitudesPendientes = 0;
    int solicitudesEnProceso = 0;
    int solicitudesAtendidas = 0;

    // Mapas para almacenar datos de gráficos
    Map<String, Integer> datosSolicitudesMensuales = new LinkedHashMap<>();

    // Obtener la entidad del funcionario (simulación)
    int entidadFuncionarioId = 2; // En un caso real, esto vendría de la sesión del usuario
    int anioActual = 2024; // En un caso real, sería el año actual

    // Conexión a la base de datos
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = ConexionBD.getConexion();

        // Obtener estadísticas de solicitudes
        String sqlEstadisticas = "SELECT es.nombre, COUNT(s.id) AS cantidad " +
                "FROM SolicitudAcceso s " +
                "JOIN EstadoSolicitud es ON s.estadoSolicitudId = es.id " +
                "WHERE s.entidadPublicaId = ? " +
                "GROUP BY es.nombre";

        pstmt = conn.prepareStatement(sqlEstadisticas);
        pstmt.setInt(1, entidadFuncionarioId);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String estado = rs.getString("nombre");
            int cantidad = rs.getInt("cantidad");

            if (estado.equalsIgnoreCase("Pendiente")) {
                solicitudesPendientes = cantidad;
            } else if (estado.equalsIgnoreCase("En Proceso")) {
                solicitudesEnProceso = cantidad;
            } else if (estado.equalsIgnoreCase("Atendida")) {
                solicitudesAtendidas = cantidad;
            }
        }

        // Obtener datos para el gráfico de solicitudes mensuales
        String sqlGrafico = "SELECT periodo, totalSolicitudes " +
                "FROM EstadisticasSolicitudes " +
                "WHERE entidadId = ? AND anio = ? " +
                "ORDER BY mes";

        pstmt = conn.prepareStatement(sqlGrafico);
        pstmt.setInt(1, entidadFuncionarioId);
        pstmt.setInt(2, anioActual);
        rs = pstmt.executeQuery();

        // Inicializar todos los meses con 0 para asegurar que tenemos datos para todos los meses
        String[] meses = {"Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"};
        for (String mes : meses) {
            datosSolicitudesMensuales.put(mes, 0);
        }

        // Llenar con los datos de la base de datos
        while (rs.next()) {
            String periodo = rs.getString("periodo"); // Formato: 'ENE-2024'
            int totalSolicitudes = rs.getInt("totalSolicitudes");

            // Extraer el mes del periodo (primeras 3 letras)
            String mes = periodo.substring(0, 3);
            // Convertir a formato de título (primera letra mayúscula, resto minúsculas)
            mes = mes.substring(0, 1) + mes.substring(1).toLowerCase();

            // Actualizar el mapa
            datosSolicitudesMensuales.put(mes, totalSolicitudes);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Convertir datos del gráfico a formato JSON para JavaScript
    StringBuilder labelsJSON = new StringBuilder("[");
    StringBuilder dataJSON = new StringBuilder("[");

    boolean first = true;
    for (Map.Entry<String, Integer> entry : datosSolicitudesMensuales.entrySet()) {
        if (!first) {
            labelsJSON.append(", ");
            dataJSON.append(", ");
        }
        labelsJSON.append("'").append(entry.getKey()).append("'");
        dataJSON.append(entry.getValue());
        first = false;
    }

    labelsJSON.append("]");
    dataJSON.append("]");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Funcionario - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/funcionario.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="funcionario-theme">
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Funcionario</a>
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
                        <a class="nav-link active" href="index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="transparencia.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Gestión de Transparencia
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="solicitudes.jsp">
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
            <div class="welcome-banner fade-in">
                <div class="row">
                    <div class="col-lg-8">
                        <h1>Bienvenido(a), <%= usuario.getNombreCompleto().split(" ")[0] %>
                        </h1>
                        <p class="mb-4">Acceda a todas las herramientas para gestionar las solicitudes de transparencia
                            y la información pública de su entidad.</p>
                        <div class="d-grid gap-2 d-md-flex">
                            <a href="solicitudes.jsp" class="btn btn-light btn-lg px-4 me-md-2">
                                <i class="bi bi-envelope-open me-2"></i>Gestionar Solicitudes
                            </a>
                            <a href="transparencia.jsp" class="btn btn-outline-light btn-lg px-4">
                                <i class="bi bi-file-earmark-text me-2"></i>Gestionar Documentos
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-4 d-none d-lg-block text-center">
                        <i class="bi bi-clipboard-data" style="font-size: 8rem; opacity: 0.5;"></i>
                    </div>
                </div>
            </div>

            <%
                // Mostrar mensaje de redirección si existe
                String mensaje = (String) session.getAttribute("mensaje");
                if (mensaje != null && !mensaje.isEmpty()) {
            %>
            <div class="alert alert-warning fade-in" role="alert">
                <i class="bi bi-exclamation-triangle me-2"></i> <%= mensaje %>
            </div>
            <%
                    // Limpiar el mensaje después de mostrarlo
                    session.removeAttribute("mensaje");
                }
            %>

            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card stat-card warning-accent fade-in">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <div class="title">Solicitudes Pendientes</div>
                                    <div class="value"><%= solicitudesPendientes %>
                                    </div>
                                    <p class="card-text">Solicitudes de información que requieren su atención.</p>
                                    <a href="solicitudes.jsp" class="btn btn-primary">Gestionar solicitudes</a>
                                </div>
                                <div class="col-4">
                                    <i class="bi bi-envelope-exclamation stat-icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card stat-card secondary-accent fade-in">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <div class="title">Documentos de Transparencia</div>
                                    <div class="value">15</div>
                                    <p class="card-text">Documentos publicados por su entidad.</p>
                                    <a href="transparencia.jsp" class="btn btn-primary">Gestionar documentos</a>
                                </div>
                                <div class="col-4">
                                    <i class="bi bi-file-earmark-text stat-icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-8 mb-4">
                    <div class="card shadow fade-in">
                        <div class="card-header py-3">
                            <div class="d-flex justify-content-between align-items-center">
                                <h6 class="m-0 font-weight-bold">Distribución de Solicitudes</h6>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button"
                                            id="chartPeriodDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                        Este Año
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="chartPeriodDropdown">
                                        <li><a class="dropdown-item" href="#">Este Mes</a></li>
                                        <li><a class="dropdown-item" href="#">Este Año</a></li>
                                        <li><a class="dropdown-item" href="#">Todo el Tiempo</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="solicitudesChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card shadow fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Estado de Solicitudes</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="estadoSolicitudesChart"></canvas>
                            </div>
                            <div class="mt-3">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span>Pendientes</span>
                                    <span class="badge bg-warning"><%= solicitudesPendientes %></span>
                                </div>
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar bg-warning" role="progressbar"
                                         style="width: <%= 100.0 * solicitudesPendientes / (solicitudesPendientes + solicitudesEnProceso + solicitudesAtendidas) %>%"
                                         aria-valuenow="<%= solicitudesPendientes %>" aria-valuemin="0"
                                         aria-valuemax="100"></div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span>En proceso</span>
                                    <span class="badge bg-primary"><%= solicitudesEnProceso %></span>
                                </div>
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar" role="progressbar"
                                         style="width: <%= 100.0 * solicitudesEnProceso / (solicitudesPendientes + solicitudesEnProceso + solicitudesAtendidas) %>%"
                                         aria-valuenow="<%= solicitudesEnProceso %>"
                                         aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span>Atendidas</span>
                                    <span class="badge bg-success"><%= solicitudesAtendidas %></span>
                                </div>
                                <div class="progress" style="height: 8px;">
                                    <div class="progress-bar bg-success" role="progressbar"
                                         style="width: <%= 100.0 * solicitudesAtendidas / (solicitudesPendientes + solicitudesEnProceso + solicitudesAtendidas) %>%"
                                         aria-valuenow="<%= solicitudesAtendidas %>" aria-valuemin="0"
                                         aria-valuemax="100"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <h2 class="mt-4 mb-3">Últimas Solicitudes Recibidas</h2>
            <div class="table-responsive fade-in">
                <table class="table table-striped" id="tablaSolicitudes">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Solicitante</th>
                        <th>Tipo</th>
                        <th>Fecha</th>
                        <th>Estado</th>
                        <th>Acción</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>2453</td>
                        <td>Juan Rodríguez</td>
                        <td>Información Presupuestal</td>
                        <td>2024-04-30</td>
                        <td><span class="badge bg-warning">Pendiente</span></td>
                        <td><a href="solicitudes-detalle.jsp?id=2453" class="btn btn-sm btn-primary">Ver detalle</a>
                        </td>
                    </tr>
                    <tr>
                        <td>2452</td>
                        <td>María Sánchez</td>
                        <td>Información de Proyectos</td>
                        <td>2024-04-29</td>
                        <td><span class="badge bg-warning">Pendiente</span></td>
                        <td><a href="solicitudes-detalle.jsp?id=2452" class="btn btn-sm btn-primary">Ver detalle</a>
                        </td>
                    </tr>
                    <tr>
                        <td>2451</td>
                        <td>Carlos Torres</td>
                        <td>Información de Contrataciones</td>
                        <td>2024-04-28</td>
                        <td><span class="badge bg-success">Atendida</span></td>
                        <td><a href="solicitudes-detalle.jsp?id=2451" class="btn btn-sm btn-primary">Ver detalle</a>
                        </td>
                    </tr>
                    <tr>
                        <td>2450</td>
                        <td>Laura Flores</td>
                        <td>Información de Personal</td>
                        <td>2024-04-27</td>
                        <td><span class="badge bg-secondary">En proceso</span></td>
                        <td><a href="solicitudes-detalle.jsp?id=2450" class="btn btn-sm btn-primary">Ver detalle</a>
                        </td>
                    </tr>
                    <tr>
                        <td>2449</td>
                        <td>Pedro González</td>
                        <td>Información General</td>
                        <td>2024-04-26</td>
                        <td><span class="badge bg-success">Atendida</span></td>
                        <td><a href="solicitudes-detalle.jsp?id=2449" class="btn btn-sm btn-primary">Ver detalle</a>
                        </td>
                    </tr>
                    </tbody>
                </table>
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
            pageLength: 5,
            lengthMenu: [[5, 10, 25, -1], [5, 10, 25, "Todos"]],
            responsive: true
        });

        // Inicializar tooltips de Bootstrap
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Gráfico de solicitudes mensuales con datos de la base de datos
        var ctxSolicitudes = document.getElementById('solicitudesChart').getContext('2d');
        var solicitudesChart = new Chart(ctxSolicitudes, {
            type: 'line',
            data: {
                labels: <%= labelsJSON.toString() %>,
                datasets: [{
                    label: 'Solicitudes Recibidas',
                    data: <%= dataJSON.toString() %>,
                    backgroundColor: 'rgba(56, 103, 214, 0.1)',
                    borderColor: '#3867d6',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: true,
                    pointBackgroundColor: '#3867d6',
                    pointRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: false,
                        callbacks: {
                            label: function (context) {
                                return context.dataset.label + ': ' + context.parsed.y + ' solicitudes';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        },
                        grid: {
                            drawBorder: false
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });

        // Gráfico de distribución de estados con datos dinámicos
        var ctxEstados = document.getElementById('estadoSolicitudesChart').getContext('2d');
        var estadosChart = new Chart(ctxEstados, {
            type: 'doughnut',
            data: {
                labels: ['Pendientes', 'En Proceso', 'Atendidas'],
                datasets: [{
                    data: [<%= solicitudesPendientes %>, <%= solicitudesEnProceso %>, <%= solicitudesAtendidas %>],
                    backgroundColor: [
                        '#f59e0b', // Naranja para pendientes
                        '#3867d6', // Azul para en proceso
                        '#10b981'  // Verde para atendidas
                    ],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            usePointStyle: true,
                            padding: 20
                        }
                    }
                }
            }
        });

        // Validar enlaces dinámicamente
        $('a').on('click', function (e) {
            const href = $(this).attr('href');
            if (href === '#' || href === 'javascript:void(0)') {
                e.preventDefault();
                alert('Esta funcionalidad estará disponible próximamente');
            }
        });
    });
</script>
</body>
</html>
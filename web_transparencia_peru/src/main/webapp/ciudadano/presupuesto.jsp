<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.CiudadanoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.PresupuestoModelo" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Calendar" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("ciudadano") == null) {
        // No está logueado como ciudadano, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    CiudadanoEntidad ciudadano = (CiudadanoEntidad) sesion.getAttribute("ciudadano");

    // Inicializar modelo de presupuesto
    PresupuestoModelo presupuestoModelo = new PresupuestoModelo();

    // Obtener año actual para filtros
    int anioActual = Calendar.getInstance().get(Calendar.YEAR);

    // Obtener evolución anual del presupuesto
    List<Map<String, Object>> evolucionAnual = presupuestoModelo.obtenerEvolucionAnual();

    // Obtener datos de categorías
    List<Map<String, Object>> datosCategorias = presupuestoModelo.obtenerDatosCategorias();

    // Obtener estadísticas por nivel de gobierno
    List<Map<String, Object>> estadisticasNivel = presupuestoModelo.obtenerEstadisticasPorNivel(anioActual);

    // Obtener datos de proyectos
    List<Map<String, Object>> datosProyectos = presupuestoModelo.obtenerDatosProyectos();

    // Formateador para montos en soles
    NumberFormat formatoMoneda = NumberFormat.getCurrencyInstance(new Locale("es", "PE"));
    DecimalFormat formatoDecimal = new DecimalFormat("#,###.##");

    // Preparar datos para gráficos
    StringBuilder aniosJson = new StringBuilder("[");
    StringBuilder montosJson = new StringBuilder("[");
    StringBuilder categoriasJson = new StringBuilder("[");
    StringBuilder porcentajesJson = new StringBuilder("[");
    StringBuilder coloresJson = new StringBuilder("[");

    // Colores para el gráfico de categorías
    String[] colores = {"#4e73df", "#1cc88a", "#36b9cc", "#f6c23e", "#e74a3b", "#5a5c69", "#6610f2", "#fd7e14", "#20c997", "#6f42c1"};

    // Preparar datos para el gráfico de evolución anual
    for (int i = 0; i < evolucionAnual.size(); i++) {
        Map<String, Object> dato = evolucionAnual.get(i);
        aniosJson.append("\"").append(dato.get("anio")).append("\"");
        montosJson.append(dato.get("montoTotal"));

        if (i < evolucionAnual.size() - 1) {
            aniosJson.append(",");
            montosJson.append(",");
        }
    }
    aniosJson.append("]");
    montosJson.append("]");

    // Preparar datos para el gráfico de categorías
    for (int i = 0; i < datosCategorias.size() && i < 10; i++) { // Limitar a 10 categorías para el gráfico
        Map<String, Object> categoria = datosCategorias.get(i);
        categoriasJson.append("\"").append(categoria.get("nombre")).append("\"");
        porcentajesJson.append(categoria.get("porcentaje"));
        coloresJson.append("\"").append(colores[i % colores.length]).append("\"");

        if (i < datosCategorias.size() - 1 && i < 9) {
            categoriasJson.append(",");
            porcentajesJson.append(",");
            coloresJson.append(",");
        }
    }
    categoriasJson.append("]");
    porcentajesJson.append("]");
    coloresJson.append("]");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presupuesto Público - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .sidebar {
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 100;
            padding: 48px 0 0;
            box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
            background-color: #f8f9fa;
        }

        .sidebar-sticky {
            position: relative;
            top: 0;
            height: calc(100vh - 48px);
            padding-top: .5rem;
            overflow-x: hidden;
            overflow-y: auto;
        }

        .navbar {
            box-shadow: 0 .125rem .25rem rgba(0, 0, 0, .075);
        }

        main {
            padding-top: 56px;
        }

        .card {
            border-radius: 0.5rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease-in-out;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background: linear-gradient(to right, #4e73df, #224abe);
            color: white;
            border-top-left-radius: 0.5rem;
            border-top-right-radius: 0.5rem;
            font-weight: bold;
        }

        .bg-gradient-primary {
            background: linear-gradient(to right, #4e73df, #224abe);
        }

        .bg-gradient-success {
            background: linear-gradient(to right, #1cc88a, #13855c);
        }

        .bg-gradient-info {
            background: linear-gradient(to right, #36b9cc, #258391);
        }

        .bg-gradient-warning {
            background: linear-gradient(to right, #f6c23e, #dda20a);
        }

        .progress {
            height: 10px;
            margin-bottom: 0.5rem;
        }

        .chart-container {
            position: relative;
            height: 300px;
            width: 100%;
        }
    </style>
</head>
<body>
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Mi Panel</a>
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
                        <a class="nav-link" href="mis_solicitudes.jsp">
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
                        <a class="nav-link active" href="presupuesto.jsp">
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
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Presupuesto Público</h1>
            </div>

            <div class="alert alert-info" role="alert">
                <i class="bi bi-info-circle me-2"></i> Esta sección muestra información transparente sobre el
                presupuesto público, permitiéndole conocer cómo se están utilizando los recursos del Estado.
            </div>

            <!-- Tarjetas con información principal -->
            <div class="row mb-4">
                <%
                    BigDecimal presupuestoTotal = BigDecimal.ZERO;
                    int cantidadEntidades = 0;
                    int cantidadProyectos = datosProyectos.size();

                    for (Map<String, Object> estadistica : estadisticasNivel) {
                        if (estadistica.get("presupuesto_total") != null) {
                            presupuestoTotal = presupuestoTotal.add((BigDecimal) estadistica.get("presupuesto_total"));
                        }
                        if (estadistica.get("cantidad_entidades") != null) {
                            cantidadEntidades += (Integer) estadistica.get("cantidad_entidades");
                        }
                    }
                %>
                <!-- Tarjeta de Presupuesto Total -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-primary shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                        Presupuesto Total <%= anioActual %>
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800"><%= formatoMoneda.format(presupuestoTotal) %>
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <i class="bi bi-currency-dollar fa-2x text-gray-300" style="font-size: 2rem;"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta de Entidades Públicas -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-success shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                        Entidades Públicas
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800"><%= cantidadEntidades %>
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <i class="bi bi-building fa-2x text-gray-300" style="font-size: 2rem;"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta de Proyectos -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-info shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                        Proyectos
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800"><%= cantidadProyectos %>
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <i class="bi bi-clipboard-data fa-2x text-gray-300" style="font-size: 2rem;"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta de Año Fiscal -->
                <div class="col-xl-3 col-md-6 mb-4">
                    <div class="card border-left-warning shadow h-100 py-2">
                        <div class="card-body">
                            <div class="row no-gutters align-items-center">
                                <div class="col mr-2">
                                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                        Año Fiscal
                                    </div>
                                    <div class="h5 mb-0 font-weight-bold text-gray-800"><%= anioActual %>
                                    </div>
                                </div>
                                <div class="col-auto">
                                    <i class="bi bi-calendar-date fa-2x text-gray-300" style="font-size: 2rem;"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Gráficos -->
            <div class="row">
                <!-- Gráfico de Evolución Anual -->
                <div class="col-xl-8 col-lg-7">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                            <h6 class="m-0 font-weight-bold">Evolución Anual del Presupuesto Público</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="evolucionAnualChart"></canvas>
                            </div>
                            <p class="mt-3 mb-0 text-muted text-sm">La gráfica muestra la evolución del presupuesto
                                público a lo largo de los años, reflejando el compromiso del estado con la inversión
                                pública.</p>
                        </div>
                    </div>
                </div>

                <!-- Gráfico de Distribución por Categorías -->
                <div class="col-xl-4 col-lg-5">
                    <div class="card shadow mb-4">
                        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                            <h6 class="m-0 font-weight-bold">Distribución por Categorías</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="distribucionCategoriasChart"></canvas>
                            </div>
                            <p class="mt-3 mb-0 text-muted text-sm">Representación de cómo se distribuye el presupuesto
                                entre las diferentes categorías de gasto.</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Distribución por Nivel de Gobierno -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Distribución por Nivel de Gobierno</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="tablaNivelGobierno" width="100%" cellspacing="0">
                            <thead>
                            <tr>
                                <th>Nivel de Gobierno</th>
                                <th>Presupuesto Total</th>
                                <th>Cantidad de Entidades</th>
                                <th>Distribución</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                for (Map<String, Object> estadistica : estadisticasNivel) {
                                    String nivel = (String) estadistica.get("nivel");
                                    BigDecimal montoNivel = (BigDecimal) estadistica.get("presupuesto_total");
                                    int cantidadEntidadesNivel = (Integer) estadistica.get("cantidad_entidades");

                                    // Calcular el porcentaje
                                    double porcentaje = 0;
                                    if (presupuestoTotal.compareTo(BigDecimal.ZERO) > 0) {
                                        porcentaje = montoNivel.doubleValue() / presupuestoTotal.doubleValue() * 100;
                                    }
                            %>
                            <tr>
                                <td><strong><%= nivel %>
                                </strong></td>
                                <td><%= formatoMoneda.format(montoNivel) %>
                                </td>
                                <td><%= cantidadEntidadesNivel %>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <span class="me-2"><%= formatoDecimal.format(porcentaje) %>%</span>
                                        <div class="progress w-100">
                                            <div class="progress-bar bg-primary" role="progressbar"
                                                 style="width: <%= porcentaje %>%"
                                                 aria-valuenow="<%= porcentaje %>" aria-valuemin="0"
                                                 aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Proyectos Destacados -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Proyectos Destacados</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="tablaProyectos" width="100%" cellspacing="0">
                            <thead>
                            <tr>
                                <th>Proyecto</th>
                                <th>Entidad</th>
                                <th>Región</th>
                                <th>Presupuesto</th>
                                <th>Avance Físico</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                for (int i = 0; i < datosProyectos.size() && i < 10; i++) {
                                    Map<String, Object> proyecto = datosProyectos.get(i);
                                    String nombreProyecto = (String) proyecto.get("nombre");
                                    String entidadNombre = (String) proyecto.get("entidadNombre");
                                    String region = (String) proyecto.get("region");
                                    BigDecimal presupuestoProyecto = (BigDecimal) proyecto.get("presupuestoAsignado");
                                    double avanceFisico = (Double) proyecto.get("avanceFisico");

                                    // Determinar color de la barra de progreso
                                    String colorBarra = "bg-danger";
                                    if (avanceFisico >= 75) {
                                        colorBarra = "bg-success";
                                    } else if (avanceFisico >= 50) {
                                        colorBarra = "bg-info";
                                    } else if (avanceFisico >= 25) {
                                        colorBarra = "bg-warning";
                                    }
                            %>
                            <tr>
                                <td><%= nombreProyecto %>
                                </td>
                                <td><%= entidadNombre %>
                                </td>
                                <td><%= region != null ? region : "Nacional" %>
                                </td>
                                <td><%= formatoMoneda.format(presupuestoProyecto) %>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <span class="me-2"><%= formatoDecimal.format(avanceFisico) %>%</span>
                                        <div class="progress w-100">
                                            <div class="progress-bar <%= colorBarra %>" role="progressbar"
                                                 style="width: <%= avanceFisico %>%"
                                                 aria-valuenow="<%= avanceFisico %>" aria-valuemin="0"
                                                 aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Categorías de Gasto -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Categorías de Gasto</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="tablaCategorias" width="100%" cellspacing="0">
                            <thead>
                            <tr>
                                <th>Categoría</th>
                                <th>Descripción</th>
                                <th>Monto Asignado</th>
                                <th>Porcentaje</th>
                                <th>Variación</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                for (Map<String, Object> categoria : datosCategorias) {
                                    String nombreCategoria = (String) categoria.get("nombre");
                                    String descripcion = (String) categoria.get("descripcion");
                                    double montoCategoria = (Double) categoria.get("montoTotal");
                                    double porcentaje = (Double) categoria.get("porcentaje");
                                    double variacion = (Double) categoria.get("variacion");

                                    // Determinar color para la variación
                                    String colorVariacion = "text-success";
                                    String iconoVariacion = "bi-arrow-up";
                                    if (variacion < 0) {
                                        colorVariacion = "text-danger";
                                        iconoVariacion = "bi-arrow-down";
                                        variacion = Math.abs(variacion);
                                    }
                            %>
                            <tr>
                                <td><strong><%= nombreCategoria %>
                                </strong></td>
                                <td><%= descripcion != null ? descripcion : "Sin descripción disponible" %>
                                </td>
                                <td><%= formatoMoneda.format(montoCategoria) %>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <span class="me-2"><%= formatoDecimal.format(porcentaje) %>%</span>
                                        <div class="progress w-100">
                                            <div class="progress-bar" role="progressbar"
                                                 style="width: <%= porcentaje %>%"
                                                 aria-valuenow="<%= porcentaje %>" aria-valuemin="0"
                                                 aria-valuemax="100"></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="<%= colorVariacion %>">
                                    <i class="bi <%= iconoVariacion %> me-1"></i><%= formatoDecimal.format(variacion) %>
                                    %
                                </td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Scripts JS -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

<!-- Inicialización de DataTables -->
<script>
    $(document).ready(function () {
        $('#tablaNivelGobierno').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            pageLength: 5,
            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Todos"]],
            responsive: true
        });

        $('#tablaProyectos').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            pageLength: 5,
            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Todos"]],
            responsive: true,
            order: [[3, 'desc']] // Ordenar por presupuesto (columna 3) descendente
        });

        $('#tablaCategorias').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            pageLength: 5,
            lengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "Todos"]],
            responsive: true,
            order: [[2, 'desc']] // Ordenar por monto asignado (columna 2) descendente
        });
    });
</script>

<!-- Inicialización de Gráficos -->
<script>
    // Datos para los gráficos
    const anios = <%= aniosJson.toString() %>;
    const montos = <%= montosJson.toString() %>;
    const categorias = <%= categoriasJson.toString() %>;
    const porcentajes = <%= porcentajesJson.toString() %>;
    const colores = <%= coloresJson.toString() %>;

    // Gráfico de Evolución Anual
    const ctxEvolucion = document.getElementById('evolucionAnualChart').getContext('2d');
    const evolucionAnualChart = new Chart(ctxEvolucion, {
        type: 'line',
        data: {
            labels: anios,
            datasets: [{
                label: 'Presupuesto Anual (S/.)',
                data: montos,
                backgroundColor: 'rgba(78, 115, 223, 0.05)',
                borderColor: 'rgba(78, 115, 223, 1)',
                borderWidth: 2,
                pointBackgroundColor: 'rgba(78, 115, 223, 1)',
                pointBorderColor: '#fff',
                pointBorderWidth: 2,
                pointRadius: 5,
                pointHoverRadius: 7,
                pointHitRadius: 10,
                pointHoverBackgroundColor: 'rgba(78, 115, 223, 1)',
                pointHoverBorderColor: '#fff',
                fill: true,
                tension: 0.3
            }]
        },
        options: {
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: false,
                    ticks: {
                        callback: function (value) {
                            if (value >= 1000000000) {
                                return 'S/. ' + (value / 1000000000).toFixed(1) + ' mil millones';
                            } else if (value >= 1000000) {
                                return 'S/. ' + (value / 1000000).toFixed(1) + ' millones';
                            }
                            return 'S/. ' + value;
                        }
                    }
                }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            let label = context.dataset.label || '';
                            if (label) {
                                label += ': ';
                            }
                            let value = context.parsed.y;
                            if (value >= 1000000000) {
                                value = 'S/. ' + (value / 1000000000).toFixed(2) + ' mil millones';
                            } else {
                                value = 'S/. ' + (value / 1000000).toFixed(2) + ' millones';
                            }
                            return label + value;
                        }
                    }
                },
                legend: {
                    display: true,
                    position: 'top'
                },
                title: {
                    display: true,
                    text: 'Evolución del Presupuesto Nacional'
                }
            }
        }
    });

    // Gráfico de Distribución por Categorías
    const ctxCategorias = document.getElementById('distribucionCategoriasChart').getContext('2d');
    const distribucionCategoriasChart = new Chart(ctxCategorias, {
        type: 'doughnut',
        data: {
            labels: categorias,
            datasets: [{
                data: porcentajes,
                backgroundColor: colores,
                hoverBackgroundColor: colores,
                hoverBorderColor: "rgba(234, 236, 244, 1)",
            }]
        },
        options: {
            maintainAspectRatio: false,
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            let label = context.label || '';
                            let value = context.parsed;
                            return label + ': ' + value.toFixed(2) + '%';
                        }
                    }
                },
                legend: {
                    display: true,
                    position: 'bottom',
                    labels: {
                        boxWidth: 12
                    }
                }
            },
            cutout: '60%'
        }
    });
</script>
</body>
</html>
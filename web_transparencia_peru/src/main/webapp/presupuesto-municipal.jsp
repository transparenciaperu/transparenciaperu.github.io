<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.RegionEntidad" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presupuesto Municipal | Portal de Transparencia Perú</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary-red: #D91023;
            --primary-white: #FFFFFF;
            --dark-text: #333333;
            --secondary-blue: #1e3d59;
            --accent-gold: #FFD166;
            --light-gray: #f8f9fa;
        }

        body {
            font-family: 'Roboto', sans-serif;
            color: var(--dark-text);
            background-color: #f5f5f5;
        }

        .navbar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Montserrat', sans-serif;
        }

        .header {
            background-color: var(--primary-red);
            color: white;
            padding: 10px 0;
        }

        .header .logo-text {
            font-size: 0.85rem;
            margin-bottom: 0;
            letter-spacing: 0.5px;
        }

        .section-title {
            position: relative;
            padding-bottom: 15px;
            margin-bottom: 30px;
            color: var(--secondary-blue);
        }

        .section-title:after {
            content: "";
            position: absolute;
            display: block;
            width: 70px;
            height: 3px;
            background: var(--primary-red);
            bottom: 0;
            left: 0;
        }

        .btn-primary {
            background-color: var(--primary-red);
            border-color: var(--primary-red);
        }

        .btn-primary:hover {
            background-color: #b80d1e;
            border-color: #b80d1e;
        }

        .btn-outline-primary {
            color: var(--primary-red);
            border-color: var(--primary-red);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-red);
            border-color: var(--primary-red);
            color: white;
        }

        .card {
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .card-header {
            background-color: rgba(0, 0, 0, 0.02);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .stats-card {
            border-left: 4px solid var(--primary-red);
            transition: transform 0.3s;
        }

        .stats-card:hover {
            transform: translateY(-5px);
        }

        .text-primary {
            color: var(--primary-red) !important;
        }

        .bg-light-grey {
            background-color: #f8f9fa;
        }

        .footer {
            background-color: var(--secondary-blue);
            color: white;
            padding: 20px 0;
        }

        .table-responsive {
            margin-bottom: 1rem;
        }
        
        .stat-icon {
            font-size: 2.5rem;
            color: rgba(217, 16, 35, 0.2);
        }
        
        .nav-pills .nav-link.active {
            background-color: var(--primary-red);
        }
        
        .nav-pills .nav-link {
            color: var(--dark-text);
        }
        
        .municipality-type {
            display: inline-block;
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
            margin-left: 0.5rem;
            border-radius: 10px;
            background-color: #e9ecef;
        }
        
        .provincial {
            background-color: #cfe2ff;
            color: #084298;
        }
        
        .district {
            background-color: #d1e7dd;
            color: #0f5132;
        }
    </style>
</head>
<body>
    <!-- Header Superior -->
    <div class="header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center">
                    <p class="logo-text">REPÚBLICA DEL PERÚ</p>
                </div>
                <div>
                    <p class="logo-text">PORTAL OFICIAL DE TRANSPARENCIA</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Barra de navegación -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <img src="https://www.gob.pe/assets/escudo-af8270af12c1a9bf7f46ca9441eb9116df71ed4e197a4bbd0f87546d246a6f01.svg" alt="Escudo Perú" height="38">
                Portal de Transparencia
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="presupuesto.jsp">Información Presupuestal</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="solicitud-acceso.jsp">Solicitar Información</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login_unificado.jsp">Ingresar</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Contenido Principal -->
    <main class="container py-5">
        <!-- Encabezado con migas de pan -->
        <div class="row mb-4">
            <div class="col-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="index.jsp">Inicio</a></li>
                        <li class="breadcrumb-item"><a href="presupuesto.jsp">Presupuestos</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Presupuesto Municipal</li>
                    </ol>
                </nav>
                <h1 class="display-5 fw-bold mb-3">Presupuesto Municipal</h1>
                <p class="lead text-muted">
                    Presupuesto asignado a las municipalidades provinciales y distritales de todo el Perú.
                </p>
            </div>
        </div>

        <!-- Filtros de navegación -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title mb-3">Explorar presupuestos por niveles de gobierno</h5>
                        <div class="d-flex flex-wrap gap-2">
                            <a href="ServletPresupuesto?accion=nacional" class="btn btn-outline-primary">Nacional</a>
                            <a href="ServletPresupuesto?accion=regional" class="btn btn-outline-primary">Regional</a>
                            <a href="ServletPresupuesto?accion=municipal" class="btn btn-primary">Municipal</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%
            NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("es", "PE"));
            List<Map<String, Object>> estadisticas = (List<Map<String, Object>>) request.getAttribute("estadisticas");
            List<Map<String, Object>> datosPorAnio = (List<Map<String, Object>>) request.getAttribute("datosPorAnio");
            List<EntidadPublicaEntidad> entidades = (List<EntidadPublicaEntidad>) request.getAttribute("entidades");
            List<RegionEntidad> regiones = (List<RegionEntidad>) request.getAttribute("regiones");
        %>

        <!-- Estadísticas Generales -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header py-3">
                        <h5 class="mb-0">Estadísticas Generales - Presupuesto 2024</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <% 
                            if (estadisticas != null && !estadisticas.isEmpty()) {
                                for (Map<String, Object> stat : estadisticas) {
                                    if (stat.get("nivel").equals("Municipal")) {
                            %>
                            <div class="col-md-4 mb-3">
                                <div class="card stats-card h-100">
                                    <div class="card-body d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-subtitle mb-2 text-muted">Municipalidades</h6>
                                            <h4 class="mb-0"><%= stat.get("cantidad_entidades") %></h4>
                                        </div>
                                        <div class="stat-icon">
                                            <i class="fas fa-city"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="card stats-card h-100">
                                    <div class="card-body d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-subtitle mb-2 text-muted">Presupuesto Total Municipal</h6>
                                            <h4 class="mb-0"><%= currencyFormatter.format(stat.get("presupuesto_total")) %></h4>
                                        </div>
                                        <div class="stat-icon">
                                            <i class="fas fa-money-bill-wave"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4 mb-3">
                                <div class="card stats-card h-100">
                                    <div class="card-body d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-subtitle mb-2 text-muted">Promedio por Municipalidad</h6>
                                            <h4 class="mb-0"><%= currencyFormatter.format(Double.parseDouble(stat.get("presupuesto_total").toString()) / Integer.parseInt(stat.get("cantidad_entidades").toString())) %></h4>
                                        </div>
                                        <div class="stat-icon">
                                            <i class="fas fa-chart-line"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                                    }
                                }
                            } else {
                            %>
                            <div class="col-12">
                                <div class="alert alert-warning">
                                    No se encontraron estadísticas disponibles.
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Filtro por Región y Tipo de Municipalidad -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header py-3">
                        <h5 class="mb-0">Filtrar Municipalidades</h5>
                    </div>
                    <div class="card-body">
                        <form action="ServletPresupuesto" method="get" class="mb-3">
                            <input type="hidden" name="accion" value="municipal">
                            <div class="row g-3 align-items-end">
                                <div class="col-md-3">
                                    <label for="region" class="form-label">Región</label>
                                    <select name="regionId" id="region" class="form-select">
                                        <option value="">Todas las regiones</option>
                                        <% 
                                        if (regiones != null && !regiones.isEmpty()) {
                                            for (RegionEntidad region : regiones) {
                                        %>
                                        <option value="<%= region.getId() %>"><%= region.getNombre() %></option>
                                        <% 
                                            }
                                        }
                                        %>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="tipo" class="form-label">Tipo</label>
                                    <select name="tipo" id="tipo" class="form-select">
                                        <option value="">Todos los tipos</option>
                                        <option value="Provincial">Municipalidades Provinciales</option>
                                        <option value="Distrital">Municipalidades Distritales</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <label for="anio" class="form-label">Año</label>
                                    <select name="anio" id="anio" class="form-select">
                                        <option value="2024">2024</option>
                                        <option value="2023">2023</option>
                                        <option value="2022">2022</option>
                                        <option value="2021">2021</option>
                                        <option value="2020">2020</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="fas fa-search me-2"></i>Filtrar
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Gráfico de Tendencia Anual -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header py-3">
                        <h5 class="mb-0">Evolución del Presupuesto Municipal</h5>
                    </div>
                    <div class="card-body">
                        <canvas id="chartPresupuestoAnual" height="300"></canvas>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Gráfico de Distribución Provincial vs Distrital -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header py-3">
                        <h5 class="mb-0">Distribución por Tipo de Municipalidad</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3 mb-md-0">
                                <canvas id="chartDistribucionTipo" height="300"></canvas>
                            </div>
                            <div class="col-md-6">
                                <div class="card h-100">
                                    <div class="card-body">
                                        <h5 class="card-title">Distribución del presupuesto municipal</h5>
                                        <p class="card-text">
                                            El presupuesto municipal se distribuye entre municipalidades provinciales y distritales.
                                            Las municipalidades provinciales generalmente reciben una mayor asignación presupuestal
                                            debido a sus mayores responsabilidades administrativas y de gestión territorial.
                                        </p>
                                        <div class="mt-4">
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Municipalidades Provinciales</span>
                                                <span class="fw-bold">35%</span>
                                            </div>
                                            <div class="progress mb-3" style="height: 10px;">
                                                <div class="progress-bar bg-primary" role="progressbar" style="width: 35%;" aria-valuenow="35" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                            <div class="d-flex justify-content-between mb-2">
                                                <span>Municipalidades Distritales</span>
                                                <span class="fw-bold">65%</span>
                                            </div>
                                            <div class="progress" style="height: 10px;">
                                                <div class="progress-bar bg-success" role="progressbar" style="width: 65%;" aria-valuenow="65" aria-valuemin="0" aria-valuemax="100"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Tabla de Municipalidades -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header py-3">
                        <h5 class="mb-0">Municipalidades</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th scope="col">#</th>
                                        <th scope="col">Entidad</th>
                                        <th scope="col">Región</th>
                                        <th scope="col">Tipo</th>
                                        <th scope="col">Contacto</th>
                                        <th scope="col">Sitio Web</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    if (entidades != null && !entidades.isEmpty()) {
                                        int contador = 1;
                                        for (EntidadPublicaEntidad entidad : entidades) {
                                            String tipoClase = entidad.getTipo().contains("Provincial") ? "provincial" : "district";
                                    %>
                                    <tr>
                                        <th scope="row"><%= contador++ %></th>
                                        <td><%= entidad.getNombre() %></td>
                                        <td><%= entidad.getNombreRegion() != null ? entidad.getNombreRegion() : "-" %></td>
                                        <td>
                                            <span class="municipality-type <%= tipoClase %>">
                                                <%= entidad.getTipo() %>
                                            </span>
                                        </td>
                                        <td>
                                            <% if (entidad.getTelefono() != null && !entidad.getTelefono().isEmpty()) { %>
                                                <i class="fas fa-phone me-1"></i> <%= entidad.getTelefono() %><br>
                                            <% } %>
                                            <% if (entidad.getEmail() != null && !entidad.getEmail().isEmpty()) { %>
                                                <i class="fas fa-envelope me-1"></i> <%= entidad.getEmail() %>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (entidad.getSitioWeb() != null && !entidad.getSitioWeb().isEmpty()) { %>
                                                <a href="<%= entidad.getSitioWeb().startsWith("http") ? entidad.getSitioWeb() : "https://" + entidad.getSitioWeb() %>" target="_blank" class="btn btn-sm btn-outline-primary">
                                                    <i class="fas fa-external-link-alt me-1"></i> Visitar
                                                </a>
                                            <% } else { %>
                                                <span class="text-muted">No disponible</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% 
                                        }
                                    } else { 
                                    %>
                                    <tr>
                                        <td colspan="6" class="text-center">No se encontraron entidades registradas</td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </main>

    <!-- Footer -->
    <footer class="footer mt-auto">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>Portal de Transparencia Perú</h5>
                    <p>Plataforma oficial para la transparencia y acceso a la información pública.</p>
                </div>
                <div class="col-md-3">
                    <h5>Enlaces</h5>
                    <ul class="list-unstyled">
                        <li><a href="index.jsp" class="text-white">Inicio</a></li>
                        <li><a href="presupuesto.jsp" class="text-white">Información Presupuestal</a></li>
                        <li><a href="solicitud-acceso.jsp" class="text-white">Solicitar Información</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h5>Contacto</h5>
                    <ul class="list-unstyled">
                        <li><i class="fas fa-envelope me-2"></i>contacto@transparencia.gob.pe</li>
                        <li><i class="fas fa-phone me-2"></i>(01) 123-4567</li>
                    </ul>
                </div>
            </div>
            <hr class="my-4" style="background-color: rgba(255,255,255,0.2);">
            <div class="row">
                <div class="col-md-6">
                    <p class="mb-0">&copy; <%= java.time.Year.now().getValue() %> Portal de Transparencia Perú. Todos los derechos reservados.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="#" class="me-3 text-white"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="me-3 text-white"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="me-3 text-white"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Gráficos con Chart.js -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Gráfico de tendencia anual
            const ctxPresupuestoAnual = document.getElementById('chartPresupuestoAnual').getContext('2d');
            
            // Datos para el gráfico (desde el backend)
            <% 
            if (datosPorAnio != null && !datosPorAnio.isEmpty()) {
                StringBuilder labels = new StringBuilder("[");
                StringBuilder data = new StringBuilder("[");
                
                for (int i = 0; i < datosPorAnio.size(); i++) {
                    Map<String, Object> item = datosPorAnio.get(i);
                    labels.append("'").append(item.get("anio")).append("'");
                    data.append(item.get("total"));
                    
                    if (i < datosPorAnio.size() - 1) {
                        labels.append(", ");
                        data.append(", ");
                    }
                }
                
                labels.append("]");
                data.append("]");
            %>
            
            const datosAnuales = {
                labels: <%= labels.toString() %>,
                datasets: [{
                    label: 'Presupuesto Municipal (Soles)',
                    data: <%= data.toString() %>,
                    backgroundColor: 'rgba(217, 16, 35, 0.2)',
                    borderColor: 'rgba(217, 16, 35, 1)',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: true
                }]
            };
            
            new Chart(ctxPresupuestoAnual, {
                type: 'line',
                data: datosAnuales,
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: false,
                            ticks: {
                                callback: function(value) {
                                    return 'S/ ' + new Intl.NumberFormat('es-PE').format(value);
                                }
                            }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return 'S/ ' + new Intl.NumberFormat('es-PE').format(context.parsed.y);
                                }
                            }
                        }
                    }
                }
            });
            <% } else { %>
            console.log('No hay datos para generar el gráfico');
            <% } %>
            
            // Gráfico de distribución por tipo de municipalidad
            const ctxDistribucionTipo = document.getElementById('chartDistribucionTipo').getContext('2d');
            
            // Datos para el gráfico de distribución
            const datosDistribucion = {
                labels: ['Municipalidades Provinciales', 'Municipalidades Distritales'],
                datasets: [{
                    label: 'Distribución del Presupuesto Municipal',
                    data: [35, 65],
                    backgroundColor: [
                        'rgba(13, 110, 253, 0.7)',
                        'rgba(25, 135, 84, 0.7)'
                    ],
                    borderColor: [
                        'rgba(13, 110, 253, 1)',
                        'rgba(25, 135, 84, 1)'
                    ],
                    borderWidth: 1
                }]
            };
            
            new Chart(ctxDistribucionTipo, {
                type: 'doughnut',
                data: datosDistribucion,
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    return context.label + ': ' + context.parsed + '%';
                                }
                            }
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presupuestos | Portal de Transparencia Perú</title>
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

        .card {
            box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            border-radius: 0.5rem;
            margin-bottom: 1.5rem;
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            background-color: rgba(0, 0, 0, 0.02);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .bg-light-grey {
            background-color: #f8f9fa;
        }

        .footer {
            background-color: var(--secondary-blue);
            color: white;
            padding: 20px 0;
        }

        .feature-icon {
            font-size: 2.5rem;
            display: inline-block;
            margin-bottom: 1rem;
            color: var(--primary-red);
        }
        
        .nivel-card {
            height: 100%;
        }
        
        .nivel-card .card-body {
            display: flex;
            flex-direction: column;
        }
        
        .nivel-card .mt-auto {
            margin-top: auto;
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
        <!-- Encabezado -->
        <div class="row mb-4">
            <div class="col-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="index.jsp">Inicio</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Presupuestos</li>
                    </ol>
                </nav>
                <h1 class="display-5 fw-bold mb-3">Información Presupuestal</h1>
                <p class="lead text-muted">
                    Acceda a información detallada sobre el presupuesto público del Perú y su ejecución según niveles de gobierno.
                </p>
            </div>
        </div>

        <!-- Niveles de Gobierno -->
        <div class="row mb-5">
            <div class="col-12 mb-4">
                <h2 class="section-title">Presupuestos por Niveles de Gobierno</h2>
            </div>
            
            <!-- Nivel Nacional -->
            <div class="col-md-4 mb-4">
                <div class="card nivel-card">
                    <div class="card-body text-center">
                        <div class="feature-icon">
                            <i class="fas fa-landmark"></i>
                        </div>
                        <h3 class="card-title">Nacional</h3>
                        <p class="card-text">
                            Presupuesto asignado a ministerios y entidades públicas del gobierno central con alcance nacional.
                        </p>
                        <div class="mt-auto">
                            <a href="ServletPresupuesto?accion=nacional" class="btn btn-primary mt-3">Ver Detalle</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Nivel Regional -->
            <div class="col-md-4 mb-4">
                <div class="card nivel-card">
                    <div class="card-body text-center">
                        <div class="feature-icon">
                            <i class="fas fa-map-marked-alt"></i>
                        </div>
                        <h3 class="card-title">Regional</h3>
                        <p class="card-text">
                            Presupuesto asignado a los gobiernos regionales de las 25 regiones del Perú.
                        </p>
                        <div class="mt-auto">
                            <a href="ServletPresupuesto?accion=regional" class="btn btn-primary mt-3">Ver Detalle</a>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Nivel Municipal -->
            <div class="col-md-4 mb-4">
                <div class="card nivel-card">
                    <div class="card-body text-center">
                        <div class="feature-icon">
                            <i class="fas fa-city"></i>
                        </div>
                        <h3 class="card-title">Municipal</h3>
                        <p class="card-text">
                            Presupuesto asignado a las municipalidades provinciales y distritales de todo el país.
                        </p>
                        <div class="mt-auto">
                            <a href="ServletPresupuesto?accion=municipal" class="btn btn-primary mt-3">Ver Detalle</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Secciones Adicionales -->
        <div class="row mb-5">
            <div class="col-12 mb-4">
                <h2 class="section-title">Información Complementaria</h2>
            </div>
            
            <!-- Proyectos de Inversión -->
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <i class="fas fa-chart-line me-3 feature-icon"></i>
                            <h3 class="card-title mb-0">Proyectos de Inversión</h3>
                        </div>
                        <p class="card-text">
                            Consulte información detallada sobre los proyectos de inversión pública en ejecución a nivel nacional, regional y municipal.
                        </p>
                        <a href="ServletPresupuesto?accion=proyectos" class="btn btn-outline-primary mt-3">Ver Proyectos</a>
                    </div>
                </div>
            </div>
            
            <!-- Ejecución Presupuestal -->
            <div class="col-md-6 mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <i class="fas fa-tasks me-3 feature-icon"></i>
                            <h3 class="card-title mb-0">Ejecución Presupuestal</h3>
                        </div>
                        <p class="card-text">
                            Acceda a información sobre el avance en la ejecución del presupuesto público por nivel de gobierno, entidad y proyecto.
                        </p>
                        <a href="ServletPresupuesto?accion=ejecucion" class="btn btn-outline-primary mt-3">Ver Ejecución</a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Recursos -->
        <div class="row">
            <div class="col-12 mb-4">
                <h2 class="section-title">Recursos Útiles</h2>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <h4 class="card-title"><i class="fas fa-file-pdf text-danger me-2"></i> Informes Anuales</h4>
                        <p class="card-text">Descargue los informes anuales sobre la ejecución presupuestaria y resultados obtenidos.</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <h4 class="card-title"><i class="fas fa-table text-success me-2"></i> Datos Abiertos</h4>
                        <p class="card-text">Acceda a los conjuntos de datos abiertos sobre presupuesto público para análisis e investigación.</p>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <h4 class="card-title"><i class="fas fa-question-circle text-info me-2"></i> Preguntas Frecuentes</h4>
                        <p class="card-text">Respuestas a las preguntas más frecuentes sobre el presupuesto público y su ejecución.</p>
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
</body>
</html>
        }

        .card-header {
            background-color: var(--primary-red);
            color: white;
            border-radius: 10px 10px 0 0 !important;
            padding: 1rem 1.5rem;
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
        }

        .chart-container {
            position: relative;
            height: 350px;
            margin-bottom: 2rem;
        }

        .info-box {
            background-color: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05);
        }

        .info-box-title {
            color: var(--primary-red);
            font-weight: 600;
            margin-bottom: 1rem;
            font-family: 'Montserrat', sans-serif;
        }

        .data-card {
            background-color: white;
            border-left: 5px solid var(--primary-red);
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.05);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: #0f2b6b;
            border-color: #0f2b6b;
        }

        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: white;
        }

        .footer {
            background-color: var(--secondary-blue);
            color: white;
            padding: 2rem 0;
            margin-top: 3rem;
        }

        .footer a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
        }

        .footer a:hover {
            color: white;
            text-decoration: underline;
        }

        /* Animaciones para los gráficos */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .chart-animate {
            animation: fadeIn 0.6s ease-out forwards;
        }

        .filter-btn.active {
            background-color: var(--primary-red);
            color: white;
        }

        .btn-primary {
            background-color: var(--primary-red) !important;
            border-color: var(--primary-red) !important;
            box-shadow: 0 4px 6px rgba(217, 16, 35, 0.2);
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #b80d1e !important;
            border-color: #b80d1e !important;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(217, 16, 35, 0.3);
        }

        .btn-outline-primary {
            color: var(--primary-red) !important;
            border-color: var(--primary-red) !important;
        }

        .btn-outline-primary:hover, .btn-outline-primary.active {
            background-color: var(--primary-red) !important;
            color: white !important;
        }
    </style>
</head>
<body>
    <!-- Barra de navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-landmark me-2"></i>
                Portal de Transparencia Perú
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
                        <a class="nav-link active" href="ServletPresupuesto">Presupuesto Público</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ServletSolicitudAcceso">Acceso a la Información</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Datos Abiertos</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Entidades</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Contacto</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-5 fw-bold mb-3">Presupuesto Público</h1>
                    <p class="lead">Información detallada, visualización en tiempo real y comparativas del presupuesto público del Perú, desglosado por proyectos, categorías y regiones.</p>
                </div>
                <div class="col-lg-6">
                    <img src="https://www.gob.pe/institucion/mef/campa%C3%B1as/8086-consulta-amigable" class="img-fluid rounded" alt="Presupuesto Público" style="max-height: 250px; display: none;">
                </div>
            </div>
        </div>
    </div>

    <!-- Contenido Principal -->
    <div class="container">
        <!-- Filtros para visualización -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="info-box">
                    <h4 class="info-box-title">Filtros de Visualización</h4>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="ServletPresupuesto" class="btn btn-primary">Resumen General</a>
                        <a href="ServletPresupuesto?accion=entidades" class="btn btn-outline-primary">Por Entidades</a>
                        <a href="ServletPresupuesto?accion=regiones" class="btn btn-outline-primary">Por Regiones</a>
                        <a href="ServletPresupuesto?accion=anual" class="btn btn-outline-primary">Evolución Anual</a>
                        <a href="ServletPresupuesto?accion=proyectos" class="btn btn-outline-primary">Por Proyectos</a>
                        <a href="ServletPresupuesto?accion=categorias" class="btn btn-outline-primary">Por
                            Categorías</a>
                    </div>

                    <div class="mt-3">
                        <form action="ServletPresupuesto" method="get">
                            <div class="row">
                                <div class="col-md-4 mb-2">
                                    <select class="form-select" id="anioSelect" name="anio">
                                        <option value="">Todos los años</option>
                                        <option value="2025" ${anioSeleccionado == 2025 ? 'selected' : ''}>2025</option>
                                        <option value="2024" ${anioSeleccionado == 2024 ? 'selected' : ''}>2024</option>
                                        <option value="2023" ${anioSeleccionado == 2023 ? 'selected' : ''}>2023</option>
                                        <option value="2022" ${anioSeleccionado == 2022 ? 'selected' : ''}>2022</option>
                                        <option value="2021" ${anioSeleccionado == 2021 ? 'selected' : ''}>2021</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-2">
                                    <select class="form-select" id="regionSelect" name="region">
                                        <option value="">Todas las regiones</option>
                                        <option value="Lima" ${regionSeleccionada == 'Lima' ? 'selected' : ''}>Lima
                                        </option>
                                        <option value="Arequipa" ${regionSeleccionada == 'Arequipa' ? 'selected' : ''}>
                                            Arequipa
                                        </option>
                                        <option value="Cusco" ${regionSeleccionada == 'Cusco' ? 'selected' : ''}>Cusco
                                        </option>
                                        <option value="La Libertad" ${regionSeleccionada == 'La Libertad' ? 'selected' : ''}>
                                            La Libertad
                                        </option>
                                        <option value="Piura" ${regionSeleccionada == 'Piura' ? 'selected' : ''}>Piura
                                        </option>
                                        <!-- Más regiones -->
                                    </select>
                                </div>
                                <div class="col-md-4 mb-2">
                                    <button type="submit" class="btn btn-primary w-100">
                                        <i class="fas fa-filter me-1"></i> Aplicar Filtros
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sección de Resumen -->
        <div class="row mb-4 data-section" id="resumenSection">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Resumen del Presupuesto Nacional ${param.anio != null ? param.anio : '2024'}</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <div class="data-card">
                                    <h3 class="fs-2 fw-bold text-primary">
                                        <c:set var="totalPresupuesto" value="0" />
                                        <c:forEach var="presupuesto" items="${presupuestos}">
                                            <c:set var="totalPresupuesto" value="${totalPresupuesto + presupuesto.montoTotal}" />
                                        </c:forEach>
                                        <c:choose>
                                            <c:when test="${empty presupuestos}">
                                                <span class="text-danger">No disponible</span>
                                            </c:when>
                                            <c:otherwise>
                                                S/ <fmt:formatNumber value="${totalPresupuesto / 1000000}"
                                                                     pattern="#,##0.0"/> MM
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <p class="mb-0 text-muted">Presupuesto Total</p>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="data-card">
                                    <h3 class="fs-2 fw-bold text-success">
                                        <c:choose>
                                            <c:when test="${empty presupuestos}">
                                                <span class="text-danger">No disponible</span>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="porcentajeEjecucion"
                                                       value="${totalPresupuesto > 0 ? 65.8 : 0}"/>
                                                <fmt:formatNumber value="${porcentajeEjecucion}" pattern="#,##0.0"/>%
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <p class="mb-0 text-muted">Ejecución Actual</p>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="data-card">
                                    <h3 class="fs-2 fw-bold text-info">
                                        <c:choose>
                                            <c:when test="${empty presupuestos}">
                                                <span class="text-danger">No disponible</span>
                                            </c:when>
                                            <c:otherwise>
                                                S/ <fmt:formatNumber
                                                    value="${totalPresupuesto * porcentajeEjecucion / 100 / 1000000}"
                                                    pattern="#,##0.0"/> MM
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <p class="mb-0 text-muted">Presupuesto Ejecutado</p>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="data-card">
                                    <h3 class="fs-2 fw-bold text-warning">
                                        <c:choose>
                                            <c:when test="${empty presupuestos}">
                                                <span class="text-danger">No disponible</span>
                                            </c:when>
                                            <c:otherwise>
                                                7.2%
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <p class="mb-0 text-muted">Incremento vs año anterior</p>
                                </div>
                            </div>
                        </div>

                        <div class="chart-container chart-animate mt-4">
                            <c:choose>
                                <c:when test="${empty presupuestos}">
                                    <div class="alert alert-warning text-center p-5">
                                        <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                                        <h4>No hay datos disponibles</h4>
                                        <p class="mb-0">No se pudieron cargar los datos del presupuesto. Por favor,
                                            inténtelo de nuevo más tarde.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <canvas id="presupuestoResumenChart"></canvas>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sección Por Entidades -->
        <div class="row mb-4 data-section" id="entidadesSection" style="display: none;">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Presupuesto por Entidades (2024)</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container chart-animate">
                            <div id="entidadesChartWrapper">
                                <canvas id="entidadesChart"></canvas>
                            </div>
                        </div>

                        <div class="table-responsive mt-4">
                            <table class="table table-hover table-striped">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Entidad</th>
                                        <th>Presupuesto (Millones S/)</th>
                                        <th>% del Total</th>
                                        <th>Ejecución</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="presupuesto" items="${presupuestos}">
                                        <tr>
                                            <td>${presupuesto.entidadPublica.nombre}</td>
                                            <td><fmt:formatNumber value="${presupuesto.montoTotal / 1000000}" pattern="#,##0.0"/></td>
                                            <td>
                                                <fmt:formatNumber value="${presupuesto.montoTotal / totalPresupuesto * 100}" pattern="#,##0.0"/>%
                                            </td>
                                            <td>
                                                <c:set var="ejecucion" value="${Math.random() * 30 + 50}" />
                                                <div class="progress">
                                                    <div class="progress-bar ${ejecucion >= 75 ? 'bg-success' : ejecucion >= 60 ? 'bg-info' : 'bg-warning'}"
                                                         style="width: ${ejecucion}%">
                                                        <fmt:formatNumber value="${ejecucion}" pattern="#,##0"/>%
                                                    </div>
                                                </div>
                                            </td>
                                            <td>
                                                <a href="ServletPresupuesto?accion=detalle&id=${presupuesto.id}" class="btn btn-sm btn-primary">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                                <a href="ServletPresupuesto?accion=formEditar&id=${presupuesto.id}" class="btn btn-sm btn-warning">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sección Por Regiones -->
        <div class="row mb-4 data-section" id="regionesSection" style="display: none;">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Comparativo por Regiones</h5>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-lg-8">
                                <div class="chart-container chart-animate">
                                    <div id="mapaPeruChart"></div>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <h5 class="mb-3">Presupuesto per cápita</h5>
                                <div class="chart-container chart-animate">
                                    <div id="percapitaChartWrapper">
                                        <canvas id="percapitaChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="table-responsive mt-2">
                            <table class="table table-hover table-striped">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Región</th>
                                        <th>Presupuesto 2024 (Millones S/)</th>
                                        <th>Presupuesto 2023 (Millones S/)</th>
                                        <th>Variación</th>
                                        <th>Ejecución</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty presupuestos}">
                                        <c:forEach var="presupuesto" items="${presupuestos}">
                                            <tr>
                                                <td>${presupuesto.region}</td>
                                                <td><fmt:formatNumber value="${presupuesto.montoTotal / 1000000}"
                                                                      pattern="#,##0.0"/></td>
                                                <td><fmt:formatNumber
                                                        value="${presupuesto.montoTotalAnterior / 1000000}"
                                                        pattern="#,##0.0"/></td>
                                                <td class="text-success">+<fmt:formatNumber
                                                        value="${(presupuesto.montoTotal - presupuesto.montoTotalAnterior) / presupuesto.montoTotalAnterior * 100}"
                                                        pattern="#,##0.0"/>%
                                                </td>
                                                <td>
                                                    <div class="progress">
                                                        <div class="progress-bar bg-info" style="width: 74%">74%</div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="5" class="text-center py-4">
                                                <div class="alert alert-warning mb-0">
                                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                                    No hay datos disponibles para las regiones. Por favor, inténtelo de
                                                    nuevo más tarde.
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sección Evolución Anual -->
        <div class="row mb-4 data-section" id="anualSection" style="display: none;">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Evolución Anual del Presupuesto (2018-2024)</h5>
                    </div>
                    <div class="card-body">
                        <div class="chart-container chart-animate">
                            <div id="evolucionChartWrapper">
                                <canvas id="evolucionChart"></canvas>
                            </div>
                        </div>

                        <div class="row mt-4">
                            <div class="col-md-6">
                                <div class="chart-container chart-animate">
                                    <div id="distribucionChartWrapper">
                                        <canvas id="distribucionChart"></canvas>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h5>Análisis de Tendencias</h5>
                                <c:choose>
                                    <c:when test="${not empty presupuestos}">
                                        <ul class="list-group">
                                            <c:forEach var="presupuesto" items="${presupuestos}">
                                                <li class="list-group-item">
                                                    <i class="fas fa-arrow-up text-success me-2"></i>
                                                    <strong>${presupuesto.categoria}: </strong> Incremento sostenido
                                                    del ${presupuesto.porcentajeIncremento}% promedio anual desde 2018
                                                </li>
                                            </c:forEach>
                                        </ul>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            No hay datos disponibles para mostrar análisis de tendencias. Por favor,
                                            inténtelo de nuevo más tarde.
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sección Por Proyectos -->
        <div class="row mb-4 data-section" id="proyectosSection" style="display: none;">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Principales Proyectos de Inversión</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Proyecto</th>
                                        <th>Presupuesto (Millones S/)</th>
                                        <th>Entidad</th>
                                        <th>Región</th>
                                        <th>Avance</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="proyecto" items="${proyectos}" varStatus="status">
                                        <tr>
                                            <td>${proyecto.nombre}</td>
                                            <td>
                                                <c:set var="montoProyecto" value="${Math.random() * 3000 + 500}" />
                                                <fmt:formatNumber value="${montoProyecto / 1000}" pattern="#,##0.0"/>
                                            </td>
                                            <td>${presupuestos[status.index % presupuestos.size()].entidadPublica.nombre}</td>
                                            <td>${presupuestos[status.index % presupuestos.size()].entidadPublica.region}</td>
                                            <td>
                                                <c:set var="avance" value="${Math.random() * 80 + 10}" />
                                                <div class="progress">
                                                    <div class="progress-bar ${avance >= 70 ? 'bg-success' : avance >= 40 ? 'bg-info' : 'bg-warning'}"
                                                         style="width: ${avance}%">
                                                        <fmt:formatNumber value="${avance}" pattern="#,##0"/>%
                                                    </div>
                                                </div>
                                            </td>
                                            <td><a href="#" class="btn btn-sm btn-primary">Detalles</a></td>
                                        </tr>
                                    </c:forEach>

                                    <!-- Si no hay proyectos en la base de datos, mostrar mensaje -->
                                    <c:if test="${empty proyectos}">
                                        <tr>
                                            <td colspan="6" class="text-center py-4">
                                                <div class="alert alert-warning mb-0">
                                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                                    No hay datos disponibles. Por favor, inténtelo de nuevo más tarde.
                                                </div>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>

                        <div class="chart-container chart-animate mt-4">
                            <canvas id="proyectosChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sección Por Categorías -->
        <div class="row mb-4 data-section" id="categoriasSection" style="display: none;">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Distribución por Categorías de Gasto</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="chart-container chart-animate">
                                    <div id="categoriasChartWrapper">
                                        <canvas id="categoriasChart"></canvas>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="chart-container chart-animate">
                                    <div id="tendenciasCategoriasChartWrapper">
                                        <canvas id="tendenciasCategoriasChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="table-responsive mt-4">
                            <table class="table table-hover table-striped">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Categoría</th>
                                        <th>Monto 2024 (Millones S/)</th>
                                        <th>% del Total</th>
                                        <th>Variación vs 2023</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:choose>
                                    <c:when test="${not empty categorias}">
                                        <c:forEach var="categoria" items="${categorias}">
                                            <tr>
                                                <td>${categoria.nombre}</td>
                                                <td><fmt:formatNumber value="${categoria.montoTotal / 1000000}"
                                                                      pattern="#,##0.0"/></td>
                                                <td><fmt:formatNumber value="${categoria.porcentaje}"
                                                                      pattern="#,##0.0"/>%
                                                </td>
                                                <td class="${categoria.variacion >= 0 ? 'text-success' : 'text-danger'}">
                                                        ${categoria.variacion >= 0 ? '+' : ''}<fmt:formatNumber
                                                        value="${categoria.variacion}" pattern="#,##0.0"/>%
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="4" class="text-center py-4">
                                                <div class="alert alert-warning mb-0">
                                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                                    No hay datos disponibles para las categorías de gasto. Por favor,
                                                    inténtelo de nuevo más tarde.
                                                </div>
                                            </td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Información sobre fuentes de datos -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="info-box">
                    <h5 class="info-box-title">Fuentes de Información</h5>
                    <p>Los datos presentados en esta plataforma provienen de fuentes oficiales y son actualizados periódicamente:</p>
                    <ul>
                        <li>Ministerio de Economía y Finanzas (MEF) - Portal de Transparencia Económica</li>
                        <li>Sistema Integrado de Administración Financiera (SIAF)</li>
                        <li>Instituto Nacional de Estadística e Informática (INEI)</li>
                        <li>Consulta Amigable del Presupuesto Público</li>
                    </ul>
                    <p class="mb-0 small">Última actualización: <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd 'de' MMMM 'de' yyyy" /></p>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4 mb-md-0">
                    <h5 class="mb-3">Portal de Transparencia Perú</h5>
                    <p>Facilitando el acceso a la información pública para promover la transparencia y participación ciudadana en la gestión pública.</p>
                </div>
                <div class="col-md-2 mb-4 mb-md-0">
                    <h5 class="mb-3">Enlaces</h5>
                    <ul class="list-unstyled">
                        <li><a href="index.jsp">Inicio</a></li>
                        <li><a href="ServletPresupuesto">Presupuesto</a></li>
                        <li><a href="ServletSolicitudAcceso">Solicitudes</a></li>
                        <li><a href="#">Datos Abiertos</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-4 mb-md-0">
                    <h5 class="mb-3">Entidades Relacionadas</h5>
                    <ul class="list-unstyled">
                        <li><a href="https://www.gob.pe/mef" target="_blank">Ministerio de Economía</a></li>
                        <li><a href="https://www.gob.pe/pcm" target="_blank">Presidencia del Consejo de Ministros</a></li>
                        <li><a href="https://www.gob.pe/contraloria" target="_blank">Contraloría General</a></li>
                        <li><a href="https://www.gob.pe" target="_blank">Portal del Estado Peruano</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h5 class="mb-3">Contacto</h5>
                    <address>
                        <i class="fas fa-map-marker-alt me-2"></i> Av. Abancay 251, Lima<br>
                        <i class="fas fa-phone me-2"></i> (01) 311-5930<br>
                        <i class="fas fa-envelope me-2"></i> <a href="mailto:transparencia@gob.pe">transparencia@gob.pe</a>
                    </address>
                </div>
            </div>
            <hr class="mt-4 mb-4" style="border-color: rgba(255,255,255,0.1);">
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <p class="mb-0">&copy; 2025 Portal de Transparencia Perú. Todos los derechos reservados.</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <ul class="list-inline mb-0">
                        <li class="list-inline-item"><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                        <li class="list-inline-item"><a href="#"><i class="fab fa-twitter"></i></a></li>
                        <li class="list-inline-item"><a href="#"><i class="fab fa-youtube"></i></a></li>
                        <li class="list-inline-item"><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Scripts para los gráficos -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Funcionalidad de filtros
            const filterButtons = document.querySelectorAll('.filter-btn');
            const dataSections = document.querySelectorAll('.data-section');

            // Referencias a los contenedores de gráficos
            const chartContainers = {
                resumen: document.getElementById('presupuestoResumenChart'),
                entidades: document.getElementById('entidadesChart'),
                regiones: document.getElementById('percapitaChart'),
                anual: document.getElementById('evolucionChart'),
                proyectos: document.getElementById('proyectosChart'),
                categorias: document.getElementById('categoriasChart'),
                tendenciasCategorias: document.getElementById('tendenciasCategoriasChart'),
                distribucion: document.getElementById('distribucionChart'),
                mapaPeru: document.getElementById('mapaPeruChart')
            };

            // Almacenamiento para instancias de gráficos
            const charts = {
                resumen: null,
                entidades: null,
                regiones: null,
                anual: null,
                proyectos: null,
                categorias: null,
                tendenciasCategorias: null,
                distribucion: null
            };

            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const filter = this.getAttribute('data-filter');

                    // Actualizar los botones activos
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');

                    // Ocultar todas las secciones
                    dataSections.forEach(section => {
                        section.style.display = 'none';
                    });

                    // Mostrar sección seleccionada
                    const selectedSection = document.getElementById(filter + 'Section');
                    if (selectedSection) {
                        selectedSection.style.display = 'flex';

                        // Actualizar referencias a los elementos DOM
                        updateChartContainerReferences();

                        // Inicializar el gráfico correspondiente si es necesario
                        initializeChart(filter);
                    }
                });
            });

            // Función para actualizar las referencias a los contenedores de gráficos
            function updateChartContainerReferences() {
                chartContainers.resumen = document.getElementById('presupuestoResumenChart');
                chartContainers.entidades = document.getElementById('entidadesChart');
                chartContainers.regiones = document.getElementById('percapitaChart');
                chartContainers.anual = document.getElementById('evolucionChart');
                chartContainers.proyectos = document.getElementById('proyectosChart');
                chartContainers.categorias = document.getElementById('categoriasChart');
                chartContainers.tendenciasCategorias = document.getElementById('tendenciasCategoriasChart');
                chartContainers.distribucion = document.getElementById('distribucionChart');
                chartContainers.mapaPeru = document.getElementById('mapaPeruChart');

                console.log('Referencias actualizadas:', {
                    resumen: !!chartContainers.resumen,
                    entidades: !!chartContainers.entidades,
                    regiones: !!chartContainers.regiones,
                    anual: !!chartContainers.anual,
                    proyectos: !!chartContainers.proyectos,
                    categorias: !!chartContainers.categorias,
                    tendenciasCategorias: !!chartContainers.tendenciasCategorias,
                    distribucion: !!chartContainers.distribucion,
                    mapaPeru: !!chartContainers.mapaPeru
                });
            }

            // Función para inicializar o actualizar un gráfico específico
            function initializeChart(chartType) {
                console.log(`Inicializando gráfico: ${chartType}`);

                // Asegurar que estamos en el contexto correcto
                setTimeout(() => {
                    switch (chartType) {
                        case 'resumen':
                            if (chartContainers.resumen) {
                                if (!charts.resumen) {
                                    console.log('Inicializando gráfico de resumen');
                                    initResumenChart();
                                }
                            } else {
                                console.error('No se encontró el contenedor para el gráfico de resumen');
                            }
                            break;
                        case 'entidades':
                            if (chartContainers.entidades) {
                                if (!charts.entidades) {
                                    console.log('Inicializando gráfico de entidades');
                                    initEntidadesChart();
                                }
                            } else {
                                console.error('No se encontró el contenedor para el gráfico de entidades');
                            }
                            break;
                        case 'regiones':
                            if (chartContainers.regiones) {
                                if (!charts.regiones) {
                                    console.log('Inicializando gráfico de regiones');
                                    initRegionesChart();
                                }
                            } else {
                                console.error('No se encontró el contenedor para el gráfico de regiones');
                            }
                            break;
                        case 'anual':
                            if (chartContainers.anual) {
                                if (!charts.anual) {
                                    console.log('Inicializando gráfico anual');
                                    initAnualChart();
                                }
                            } else {
                                console.error('No se encontró el contenedor para el gráfico anual');
                            }
                            if (chartContainers.distribucion) {
                                if (!charts.distribucion) {
                                    console.log('Inicializando gráfico de distribución');
                                    initDistribucionChart();
                                }
                            } else {
                                console.error('No se encontró el contenedor para el gráfico de distribución');
                            }
                            break;
                        case 'proyectos':
                            if (chartContainers.proyectos) {
                                if (!charts.proyectos) {
                                    console.log('Inicializando gráfico de proyectos');
                                    initProyectosChart();
                                }
                            } else {
                                console.error('No se encontró el contenedor para el gráfico de proyectos');
                            }
                            break;
                        case 'categorias':
                            if (chartContainers.categorias) {
                                if (!charts.categorias) {
                                    console.log('Inicializando gráfico de categorías');
                                    initCategoriasChart();
                                }
                            } else {
                                console.error('No se encontró el contenedor para el gráfico de categorías');
                            }
                            if (chartContainers.tendenciasCategorias) {
                                if (!charts.tendenciasCategorias) {
                                    console.log('Inicializando gráfico de tendencias de categorías');
                                    initTendenciasCategoriasChart();
                                }
                            } else {
                                console.error('No se encontró el contenedor para el gráfico de tendencias de categorías');
                            }
                            break;
                    }
                }, 100); // Pequeño delay para asegurar que el DOM esté listo
            }

            // Preparar datos comunes para los gráficos
            const entidades = [];
            const montos = [];
            const sectorDistribucion = ['Educación', 'Salud', 'Transporte', 'Vivienda', 'Defensa', 'Otros'];
            const porcentajeSector = [19.6, 11.4, 10.8, 8.5, 7.3, 42.4];
            const añosEvolucion = ['2020', '2021', '2022', '2023', '2024'];
            const montosEvolucion = [120, 135, 145, 160, 180];
            const backgroundColor = [
                'rgba(54, 162, 235, 0.7)',
                'rgba(75, 192, 192, 0.7)',
                'rgba(255, 159, 64, 0.7)',
                'rgba(153, 102, 255, 0.7)',
                'rgba(255, 99, 132, 0.7)',
                'rgba(255, 205, 86, 0.7)',
                'rgba(201, 203, 207, 0.7)',
                'rgba(54, 162, 235, 0.4)'
            ];
            const borderColor = [
                'rgb(54, 162, 235)',
                'rgb(75, 192, 192)',
                'rgb(255, 159, 64)',
                'rgb(153, 102, 255)',
                'rgb(255, 99, 132)',
                'rgb(255, 205, 86)',
                'rgb(201, 203, 207)',
                'rgb(54, 162, 235)'
            ];

            <c:forEach var="presupuesto" items="${presupuestos}" varStatus="status">
            entidades.push("${presupuesto.entidadPublica.nombre}");
            montos.push(${presupuesto.montoTotal});
            </c:forEach>

            // Si hay demasiados datos, combinar los más pequeños en "Otros"
            if (entidades.length > 7) {
                // Ordenar por monto y mantener solo los 7 más grandes
                const combinedData = entidades.map((ent, idx) => ({entidad: ent, monto: montos[idx]}));
                combinedData.sort((a, b) => b.monto - a.monto);

                const topEntidades = combinedData.slice(0, 7).map(item => item.entidad);
                const topMontos = combinedData.slice(0, 7).map(item => item.monto);

                // Sumar el resto como "Otros"
                const otrosMontos = combinedData.slice(7).reduce((sum, item) => sum + item.monto, 0);

                entidades.length = 0;
                montos.length = 0;

                entidades.push(...topEntidades, "Otros");
                montos.push(...topMontos, otrosMontos);
            }

            // Preparar datos para gráficos de categorías
            const categorias = [];
            const montosCategorias = [];
            const porcentajesCategorias = [];

            <c:forEach var="categoria" items="${categorias}" varStatus="status">
            categorias.push("${categoria.nombre}");
            montosCategorias.push(${categoria.montoTotal});
            porcentajesCategorias.push(${categoria.porcentaje});
            </c:forEach>

            // Imprimir estado de los contenedores de gráficos para depuración
            console.log('Estado de contenedores de gráficos:', {
                resumen: !!chartContainers.resumen,
                entidades: !!chartContainers.entidades,
                regiones: !!chartContainers.regiones,
                anual: !!chartContainers.anual,
                proyectos: !!chartContainers.proyectos,
                categorias: !!chartContainers.categorias,
                tendenciasCategorias: !!chartContainers.tendenciasCategorias,
                distribucion: !!chartContainers.distribucion
            });

            // Gráfico de Resumen
            function initResumenChart() {
                if (!chartContainers.resumen) {
                    console.error('No se pudo encontrar el contenedor del gráfico de resumen');
                    showChartError('resumen');
                    return;
                }

                try {
                    const ctxResumen = chartContainers.resumen.getContext('2d');
                    charts.resumen = new Chart(ctxResumen, {
                    type: 'bar',
                    data: {
                        labels: entidades,
                        datasets: [{
                            label: 'Presupuesto (Millones S/)',
                            data: montos.map(monto => monto / 1000000), // Convertir a millones
                            backgroundColor: backgroundColor.slice(0, entidades.length),
                            borderColor: borderColor.slice(0, entidades.length),
                            borderWidth: 1
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
                                callbacks: {
                                    label: function (context) {
                                        let label = context.dataset.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        if (context.parsed.y !== null) {
                                            label += 'S/ ' + context.parsed.y.toLocaleString('es-PE');
                                        }
                                        return label;
                                    }
                                }
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    callback: function (value) {
                                        return 'S/ ' + value.toLocaleString('es-PE');
                                    }
                                }
                            }
                        }
                    }
                });
            }

            // Gráfico por Entidades
            function initEntidadesChart() {
                if (!chartContainers.entidades) return;

                const ctxEntidades = chartContainers.entidades.getContext('2d');
                charts.entidades = new Chart(ctxEntidades, {
                    type: 'bar',
                    data: {
                        labels: entidades,
                        datasets: [{
                            label: 'Presupuesto (Millones S/)',
                            data: montos.map(monto => monto / 1000000), // Convertir a millones
                            backgroundColor: backgroundColor.slice(0, entidades.length),
                            borderColor: borderColor.slice(0, entidades.length),
                            borderWidth: 1
                        }]
                    },
                    options: {
                        indexAxis: 'y',
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        let label = context.dataset.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        if (context.parsed.x !== null) {
                                            label += 'S/ ' + context.parsed.x.toLocaleString('es-PE');
                                        }
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });
            }

            // Gráfico de Regiones - Per cápita
            function initRegionesChart() {
                if (!chartContainers.regiones) return;

                try {
                    const ctxRegiones = chartContainers.regiones.getContext('2d');
                    charts.regiones = new Chart(ctxRegiones, {
                        type: 'bar',
                        data: {
                            labels: regionesNombres,
                            datasets: [{
                                label: 'Presupuesto per cápita (S/)',
                                data: regionesPresupuestoPerCapita,
                                backgroundColor: 'rgba(54, 162, 235, 0.7)',
                                borderColor: 'rgb(54, 162, 235)',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    display: false
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        callback: function (value) {
                                            return 'S/ ' + value;
                                        }
                                    }
                                }
                            }
                        }
                    });
                } catch (error) {
                    console.error('Error al inicializar gráfico de regiones:', error);
                    showChartError('regiones');
                }
            }

            // Gráfico de Evolución Anual
            function initAnualChart() {
                if (!chartContainers.anual) return;

                try {
                    const ctxAnual = chartContainers.anual.getContext('2d');
                    charts.anual = new Chart(ctxAnual, {
                        type: 'line',
                        data: {
                            labels: añosEvolucion,
                            datasets: [{
                                label: 'Presupuesto Total (Miles de millones S/)',
                                data: montosEvolucion,
                                borderColor: 'rgb(54, 162, 235)',
                                backgroundColor: 'rgba(54, 162, 235, 0.1)',
                                tension: 0.4,
                                fill: true
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                tooltip: {
                                    callbacks: {
                                        label: function (context) {
                                            let label = context.dataset.label || '';
                                            if (label) {
                                                label += ': ';
                                            }
                                            if (context.parsed.y !== null) {
                                                label += 'S/ ' + context.parsed.y.toLocaleString('es-PE') + ' mil millones';
                                            }
                                            return label;
                                        }
                                    }
                                }
                            },
                            scales: {
                                y: {
                                    beginAtZero: false,
                                    ticks: {
                                        callback: function (value) {
                                            return 'S/ ' + value;
                                        }
                                    }
                                }
                            }
                        }
                    });
                } catch (error) {
                    console.error('Error al inicializar gráfico anual:', error);
                    showChartError('anual');
                }
            }

            // Gráfico de Distribución por sectores
            function initDistribucionChart() {
                if (!chartContainers.distribucion) return;

                try {
                    const ctxDistribucion = chartContainers.distribucion.getContext('2d');
                    charts.distribucion = new Chart(ctxDistribucion, {
                        type: 'doughnut',
                        data: {
                            labels: sectorDistribucion,
                            datasets: [{
                                label: 'Distribución del Presupuesto',
                                data: porcentajeSector,
                                backgroundColor: backgroundColor,
                                borderColor: borderColor,
                                borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'right'
                            },
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        let label = context.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        if (context.parsed !== null) {
                                            label += context.parsed + '%';
                                        }
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });
                } catch (error) {
                    console.error('Error al inicializar gráfico de distribución:', error);
                    showChartError('distribucion');
                }
            }

            // Gráfico de Proyectos
            function initProyectosChart() {
                if (!chartContainers.proyectos) return;

                const ctxProyectos = chartContainers.proyectos.getContext('2d');

                // Nombres simplificados para los proyectos
                const nombresSimplificados = [
                    'Línea 2 Metro Lima',
                    'Hospital Loreto',
                    'Carretera Cusco',
                    'Agua SJL',
                    'Colegios Piura'
                ];

                charts.proyectos = new Chart(ctxProyectos, {
                    type: 'bar',
                    data: {
                        labels: nombresSimplificados,
                        datasets: [{
                            label: 'Presupuesto (Millones S/)',
                            data: [3850, 2940, 1850, 1500, 1200],
                            backgroundColor: backgroundColor,
                            borderColor: borderColor,
                            borderWidth: 1
                        }, {
                            label: 'Avance (%)',
                            data: [45, 65, 80, 70, 95],
                            backgroundColor: 'rgba(255, 99, 132, 0.7)',
                            borderColor: 'rgb(255, 99, 132)',
                            borderWidth: 1,
                            yAxisID: 'y1'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Millones de soles'
                                }
                            },
                            y1: {
                                beginAtZero: true,
                                position: 'right',
                                title: {
                                    display: true,
                                    text: 'Porcentaje de avance'
                                },
                                grid: {
                                    drawOnChartArea: false
                                },
                                max: 100,
                                ticks: {
                                    callback: function (value) {
                                        return value + '%';
                                    }
                                }
                            }
                        }
                    }
                });
            }

            // Gráfico de Categorías
            function initCategoriasChart() {
                if (!chartContainers.categorias) return;

                const ctxCategorias = chartContainers.categorias.getContext('2d');
                charts.categorias = new Chart(ctxCategorias, {
                    type: 'pie',
                    data: {
                        labels: categorias,
                        datasets: [{
                            label: '% del Presupuesto',
                            data: porcentajesCategorias,
                            backgroundColor: backgroundColor.slice(0, categorias.length),
                            borderColor: borderColor.slice(0, categorias.length),
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: {
                                position: 'bottom'
                            },
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        let label = context.label || '';
                                        if (label) {
                                            label += ': ';
                                        }
                                        if (context.parsed !== null) {
                                            label += context.parsed.toFixed(1) + '%';
                                        }
                                        return label;
                                    }
                                }
                            }
                        }
                    }
                });
            }

            // Gráfico de Tendencias por Categorías
            function initTendenciasCategoriasChart() {
                if (!chartContainers.tendenciasCategorias) return;

                const ctxTendencias = chartContainers.tendenciasCategorias.getContext('2d');
                charts.tendenciasCategorias = new Chart(ctxTendencias, {
                    type: 'line',
                    data: {
                        labels: ['2020', '2021', '2022', '2023', '2024'],
                        datasets: categorias.slice(0, 3).map((cat, index) => ({
                            label: cat,
                            data: generateRandomTrend(5, 10, 30),
                            borderColor: borderColor[index],
                            backgroundColor: backgroundColor[index],
                            tension: 0.4,
                            fill: false
                        }))
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Porcentaje del presupuesto total'
                                },
                                ticks: {
                                    callback: function (value) {
                                        return value + '%';
                                    }
                                }
                            }
                        }
                    }
                });
            }

                // Función para mostrar mensajes de error cuando una gráfica no se puede cargar
                function showChartError(chartType) {
                    const errorMessage = document.createElement('div');
                    errorMessage.className = 'alert alert-danger text-center';
                    errorMessage.innerHTML = '<i class="fas fa-exclamation-circle me-2"></i>Error al cargar la gráfica. Por favor, intente de nuevo más tarde.';

                    let container;
                    switch (chartType) {
                        case 'resumen':
                            container = document.getElementById('presupuestoResumenChart');
                            break;
                        case 'entidades':
                            container = document.getElementById('entidadesChart');
                            break;
                        case 'regiones':
                            container = document.getElementById('percapitaChart');
                            break;
                        case 'anual':
                            container = document.getElementById('evolucionChart');
                            break;
                        case 'distribucion':
                            container = document.getElementById('distribucionChart');
                            break;
                        case 'proyectos':
                            container = document.getElementById('proyectosChart');
                            break;
                        case 'categorias':
                            container = document.getElementById('categoriasChart');
                            break;
                        case 'tendenciasCategorias':
                            container = document.getElementById('tendenciasCategoriasChart');
                            break;
                    }

                    if (container) {
                        // Reemplazar el canvas con el mensaje de error
                        container.parentNode.replaceChild(errorMessage, container);
                    }
                }

                // Función auxiliar para generar datos de tendencia aleatorios
            function generateRandomTrend(count, min, max) {
                const result = [];
                let current = min + Math.random() * (max - min);

                for (let i = 0; i < count; i++) {
                    result.push(current);
                    // Cambio aleatorio pero controlado
                    current = Math.max(min, Math.min(max, current + (Math.random() * 6 - 3)));
                }

                return result;
            }

            // Iniciar con el gráfico de resumen
            initResumenChart();

                // Ya no es necesario el evento para el botón de filtros, ahora usamos un formulario

                // Inicializar el gráfico de resumen
                initResumenChart();
        });
    </script>
</body>
</html>

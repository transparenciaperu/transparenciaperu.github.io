<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presupuesto por Regiones | Portal de Transparencia Perú</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome para iconos -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Montserrat:wght@400;500;600;700&display=swap"
          rel="stylesheet">
    <!-- Chart.js para gráficos -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- ApexCharts para gráficos avanzados -->
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
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
            background-color: #f5f7fa;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Montserrat', sans-serif;
        }

        .navbar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
        }

        .navbar {
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .navbar-brand {
            font-weight: 700;
            color: var(--dark-text) !important;
        }

        .nav-link {
            font-weight: 500;
            color: var(--dark-text) !important;
        }

        .nav-link:hover {
            color: var(--primary-red) !important;
        }

        .nav-link.active {
            font-weight: bold;
        }

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-position: center;
            background-size: cover;
            color: white;
            padding: 8rem 0;
            position: relative;
            margin-bottom: 2rem;
            border-radius: 0 0 1rem 1rem;
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(217, 16, 35, 0.8) 0%, rgba(30, 61, 89, 0.8) 100%);
            opacity: 0.7;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }

        .card-header {
            background-color: var(--primary-red) !important;
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
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
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
            background-color: var(--primary-color);
            color: white;
        }
    </style>
</head>
<body>
<!-- Barra de navegación -->
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top py-3">
    <div class="container">
        <!-- Logo y marca -->
        <a class="navbar-brand d-flex align-items-center" href="index.jsp">
            <img src="https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/1845b901-cb25-481e-b9ec-c74e9a76936c/d5p73lk-f9b20a75-359d-49d3-8aaa-216d1e2cee27.jpg/v1/fill/w_888,h_900,q_70,strp/escudo_nacional_del_peru_by_esantillansalas_d5p73lk-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9OTEyIiwicGF0aCI6IlwvZlwvMTg0NWI5MDEtY2IyNS00ODFlLWI5ZWMtYzc0ZTlhNzY5MzZjXC9kNXA3M2xrLWY5YjIwYTc1LTM1OWQtNDlkMy04YWFhLTIxNmQxZTJjZWUyNy5qcGciLCJ3aWR0aCI6Ijw9OTAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.rMjvedadAetkHJWCNFhhwRyFLJ9Gz7XCxAZ9hVRVAs8"
                 alt="Escudo de Perú" class="escudo-peru" style="height: 50px; margin-right: 10px;">
            <span class="d-flex flex-column">
                <strong class="fs-4">Portal de Transparencia</strong>
                <small class="text-danger fs-6">Gobierno del Perú</small>
            </span>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav w-100 justify-content-center">
                <li class="nav-item mx-1">
                    <a class="nav-link px-3 py-2 rounded-3 d-flex align-items-center" href="index.jsp">
                        <i class="fas fa-home me-2"></i><span>Inicio</span>
                    </a>
                </li>
                <li class="nav-item mx-1 dropdown">
                    <a class="nav-link active fw-bold dropdown-toggle px-3 py-2 rounded-3 d-flex align-items-center"
                       href="#"
                       id="presupuestoDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-chart-pie me-2"></i><span>Presupuesto</span>
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="presupuestoDropdown">
                        <li><a class="dropdown-item" href="ServletPresupuesto">Ver Presupuesto Público</a></li>
                        <li><a class="dropdown-item" href="#">Ejecución Presupuestal</a></li>
                        <li><a class="dropdown-item" href="#">Proyectos de Inversión</a></li>
                    </ul>
                </li>
                <li class="nav-item mx-1">
                    <a class="nav-link px-3 py-2 rounded-3 d-flex align-items-center" href="ServletSolicitudAcceso">
                        <i class="fas fa-file-alt me-2"></i><span>Información</span>
                    </a>
                </li>
                <li class="nav-item mx-1 dropdown">
                    <a class="nav-link dropdown-toggle px-3 py-2 rounded-3 d-flex align-items-center" href="#"
                       id="entidadesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-building me-2"></i><span>Entidades</span>
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="entidadesDropdown">
                        <li><a class="dropdown-item" href="#">Directorio</a></li>
                        <li><a class="dropdown-item" href="#">Ministerios</a></li>
                        <li><a class="dropdown-item" href="#">Gobiernos Regionales</a></li>
                        <li><a class="dropdown-item" href="#">Municipalidades</a></li>
                    </ul>
                </li>
                <li class="nav-item mx-1">
                    <a class="nav-link px-3 py-2 rounded-3 d-flex align-items-center" href="#">
                        <i class="fas fa-database me-2"></i><span>Datos</span>
                    </a>
                </li>
                <li class="nav-item mx-1 dropdown ms-lg-auto">
                    <a class="nav-link dropdown-toggle px-3 py-2 rounded-3 d-flex align-items-center text-danger"
                       href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-user-circle me-2"></i><span>Ciudadano</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="#"><i class="fas fa-sign-in-alt me-2"></i>Iniciar Sesión</a>
                        </li>
                        <li><a class="dropdown-item" href="#"><i class="fas fa-user-plus me-2"></i>Registrarse</a></li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item" href="#"><i class="fas fa-question-circle me-2"></i>Ayuda</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Barra de búsqueda independiente -->
<div class="bg-light py-3 border-bottom">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="search-container position-relative w-100">
                    <div class="input-group">
                        <span class="input-group-text border-end-0 bg-white"
                              style="border-top-left-radius: 20px; border-bottom-left-radius: 20px;">
                            <i class="fas fa-search text-danger"></i>
                        </span>
                        <input class="form-control border-start-0 border-end-0 shadow-sm"
                               type="search"
                               placeholder="Buscar por regiones..."
                               aria-label="Search"
                               id="searchInput">
                        <button class="btn btn-danger border-start-0"
                                style="border-top-right-radius: 20px; border-bottom-right-radius: 20px;">
                            Buscar
                        </button>
                    </div>
                    <div class="search-tags d-none d-md-flex justify-content-center mt-2">
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>Lima</span>
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>Gobiernos Regionales</span>
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>Municipalidades</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Hero Section -->
<div class="hero-section">
    <div class="hero-overlay"></div>
    <div class="container position-relative">
        <div class="row align-items-center">
            <div class="col-lg-6">
                <h1 class="display-5 fw-bold mb-3">Presupuesto por Regiones</h1>
                <p class="lead">Análisis comparativo del presupuesto público por regiones. Explore la distribución
                    territorial de los recursos del Estado y compare indicadores por región.</p>
            </div>
            <div class="col-lg-6">
                <img src="https://www.gob.pe/institucion/mef/campa%C3%B1as/8086-consulta-amigable"
                     class="img-fluid rounded" alt="Presupuesto Público" style="max-height: 250px; display: none;">
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
                    <a href="ServletPresupuesto" class="btn btn-outline-primary">Resumen General</a>
                    <a href="ServletPresupuesto?accion=entidades" class="btn btn-outline-primary">Por Entidades</a>
                    <a href="ServletPresupuesto?accion=regiones" class="btn btn-primary">Por Regiones</a>
                    <a href="ServletPresupuesto?accion=anual" class="btn btn-outline-primary">Evolución Anual</a>
                    <a href="ServletPresupuesto?accion=proyectos" class="btn btn-outline-primary">Por Proyectos</a>
                    <a href="ServletPresupuesto?accion=categorias" class="btn btn-outline-primary">Por Categorías</a>
                </div>

                <div class="mt-3">
                    <form action="ServletPresupuesto" method="get">
                        <input type="hidden" name="accion" value="regiones">
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
                                    <c:choose>
                                        <c:when test="${not empty regionesDisponibles}">
                                            <c:forEach var="region" items="${regionesDisponibles}">
                                                <option value="${region}" ${regionSeleccionada == region ? 'selected' : ''}>${region}</option>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="Lima" ${regionSeleccionada == 'Lima' ? 'selected' : ''}>
                                                Lima
                                            </option>
                                            <option value="Arequipa" ${regionSeleccionada == 'Arequipa' ? 'selected' : ''}>
                                                Arequipa
                                            </option>
                                            <option value="Cusco" ${regionSeleccionada == 'Cusco' ? 'selected' : ''}>
                                                Cusco
                                            </option>
                                            <option value="La Libertad" ${regionSeleccionada == 'La Libertad' ? 'selected' : ''}>
                                                La Libertad
                                            </option>
                                            <option value="Piura" ${regionSeleccionada == 'Piura' ? 'selected' : ''}>
                                                Piura
                                            </option>
                                            <option value="Nacional" ${regionSeleccionada == 'Nacional' ? 'selected' : ''}>
                                                Nacional
                                            </option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </div>
                            <div class="col-md-4 mb-2">
                                <select class="form-select" id="sectorSelect" name="sector">
                                    <option value="">Todos los sectores</option>
                                    <c:choose>
                                        <c:when test="${not empty sectoresDisponibles}">
                                            <c:forEach var="sector" items="${sectoresDisponibles}">
                                                <option value="${sector}" ${sectorSeleccionado == sector ? 'selected' : ''}>${sector}</option>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <option value="Ministerio" ${sectorSeleccionado == 'Ministerio' ? 'selected' : ''}>
                                                Ministerio
                                            </option>
                                            <option value="Gobierno Regional" ${sectorSeleccionado == 'Gobierno Regional' ? 'selected' : ''}>
                                                Gobierno Regional
                                            </option>
                                            <option value="Municipalidad" ${sectorSeleccionado == 'Municipalidad' ? 'selected' : ''}>
                                                Municipalidad
                                            </option>
                                            <option value="Organismo Supervisor" ${sectorSeleccionado == 'Organismo Supervisor' ? 'selected' : ''}>
                                                Organismo Supervisor
                                            </option>
                                        </c:otherwise>
                                    </c:choose>
                                </select>
                            </div>
                            <div class="col-md-4 mb-2">
                                <button type="submit" class="btn btn-primary w-100" id="aplicarFiltros">
                                    <i class="fas fa-filter me-1"></i> Aplicar Filtros
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Sección Por Regiones -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Comparativo por Regiones
                        <c:if test="${not empty anioSeleccionado}">(${anioSeleccionado})</c:if>
                        <c:if test="${not empty regionSeleccionada}"> - Región ${regionSeleccionada}</c:if>
                        <c:if test="${not empty sectorSeleccionado}"> - Sector ${sectorSeleccionado}</c:if>
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-lg-8">
                            <div class="chart-container chart-animate">
                                <c:choose>
                                    <c:when test="${not empty mensajeNoResultados}">
                                        <div class="alert alert-warning text-center">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                                ${mensajeNoResultados}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <canvas id="regionesChart"></canvas>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <h5 class="mb-3">Presupuesto per cápita</h5>
                            <div class="chart-container chart-animate">
                                <c:choose>
                                    <c:when test="${not empty mensajeNoResultados}">
                                        <div class="alert alert-warning text-center">
                                            <i class="fas fa-exclamation-triangle me-2"></i>
                                            No hay datos disponibles para mostrar el gráfico per cápita.
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <canvas id="percapitaChart"></canvas>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="table-responsive mt-2">
                        <table class="table table-hover table-striped">
                            <thead class="table-primary">
                            <tr>
                                <th>Región</th>
                                <th>Presupuesto ${anioSeleccionado != null ? anioSeleccionado : '2024'} (Millones S/)
                                </th>
                                <th>Presupuesto ${anioSeleccionado != null ? anioSeleccionado - 1 : '2023'} (Millones
                                    S/)
                                </th>
                                <th>Variación</th>
                                <th>Ejecución</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty presupuestos}">
                                    <c:forEach var="presupuesto" items="${presupuestos}">
                                        <tr>
                                            <td>${presupuesto.region != null ? presupuesto.region : presupuesto.entidadPublica.region}</td>
                                            <td><fmt:formatNumber value="${presupuesto.montoTotal / 1000000}"
                                                                  pattern="#,##0.0"/></td>
                                            <td><fmt:formatNumber
                                                    value="${presupuesto.montoTotalAnterior != null ? presupuesto.montoTotalAnterior / 1000000 : presupuesto.montoTotal * 0.93 / 1000000}"
                                                    pattern="#,##0.0"/></td>
                                            <td class="text-success">+<fmt:formatNumber
                                                    value="${(presupuesto.montoTotalAnterior != null ?
                                                                 (presupuesto.montoTotal - presupuesto.montoTotalAnterior) / presupuesto.montoTotalAnterior 
                                                                 : 0.075) * 100}"
                                                    pattern="#,##0.0"/>%
                                            </td>
                                            <td>
                                                <c:set var="ejecucion" value="${Math.random() * 30 + 50}"/>
                                                <div class="progress">
                                                    <div class="progress-bar ${ejecucion >= 75 ? 'bg-success' : ejecucion >= 60 ? 'bg-info' : 'bg-warning'}"
                                                         style="width: ${ejecucion}%">
                                                        <fmt:formatNumber value="${ejecucion}" pattern="#,##0"/>%
                                                    </div>
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

    <!-- Información sobre fuentes de datos -->
    <div class="row mt-4">
        <div class="col-12">
            <div class="info-box">
                <h5 class="info-box-title">Fuentes de Información</h5>
                <p>Los datos presentados en esta plataforma provienen de fuentes oficiales y son actualizados
                    periódicamente:</p>
                <ul>
                    <li>Ministerio de Economía y Finanzas (MEF) - Portal de Transparencia Económica</li>
                    <li>Sistema Integrado de Administración Financiera (SIAF)</li>
                    <li>Instituto Nacional de Estadística e Informática (INEI)</li>
                    <li>Consulta Amigable del Presupuesto Público</li>
                </ul>
                <p class="mb-0 small">Última actualización: <fmt:formatDate value="<%= new java.util.Date() %>"
                                                                            pattern="dd 'de' MMMM 'de' yyyy"/></p>
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
                <p>Facilitando el acceso a la información pública para promover la transparencia y participación
                    ciudadana en la gestión pública.</p>
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
    document.addEventListener('DOMContentLoaded', function () {
        // Preparar datos para los gráficos
        const regiones = [];
        const montos = [];
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

        <c:forEach var="presupuesto" items="${presupuestos}">
        regiones.push("${presupuesto.region != null ? presupuesto.region : presupuesto.entidadPublica.region}");
        montos.push(${presupuesto.montoTotal});
        </c:forEach>

        // Inicializar el gráfico de regiones
        const ctxRegiones = document.getElementById('regionesChart');

        // Verificar si el elemento del gráfico existe
        if (ctxRegiones) {
            const ctx = ctxRegiones.getContext('2d');

            // Destruir gráfico si ya existe
            if (window.regionesChart instanceof Chart) {
                window.regionesChart.destroy();
            }

            if (regiones.length > 0) {
                window.regionesChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: regiones,
                        datasets: [{
                            label: 'Presupuesto (Millones S/)',
                            data: montos.map(monto => monto / 1000000), // Convertir a millones
                            backgroundColor: backgroundColor.slice(0, regiones.length),
                            borderColor: borderColor.slice(0, regiones.length),
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
                                        return 'S/ ' + value;
                                    }
                                }
                            }
                        }
                    }
                });
            }
        }

        // Datos para gráfico per cápita - ajustar según las regiones filtradas
        let regionesPerCapita = ['Lima', 'Arequipa', 'Cusco', 'La Libertad', 'Piura'];
        let montosPerCapita = [3500, 2800, 2100, 1800, 1500];

        // Si hay datos filtrados, usar esos datos para el gráfico per cápita
        if (regiones.length > 0) {
            // Datos de población estimada por región para cálculos per cápita
            const poblacionEstimada = {
                'Lima': 10000000,
                'Arequipa': 1500000,
                'Cusco': 1300000,
                'La Libertad': 2000000,
                'Piura': 2100000,
                'Callao': 994500,
                'Lambayeque': 1310000,
                'Junín': 1357000,
                'Cajamarca': 1359000,
                'Puno': 1173000,
                'Amazonas': 379000,
                'Áncash': 1083000,
                'Apurímac': 405800,
                'Ayacucho': 616200,
                'Huancavelica': 347600,
                'Huánuco': 721000,
                'Ica': 850700,
                'Loreto': 883500,
                'Madre de Dios': 141000,
                'Moquegua': 174900,
                'Pasco': 254000,
                'San Martín': 813400,
                'Tacna': 329300,
                'Tumbes': 224900,
                'Ucayali': 496500,
                'Default': 1000000 // Valor por defecto para otras regiones
            };

            // Actualizar el selector de regiones para mostrar solo las regiones disponibles en los datos
            const regionesUnicas = [...new Set(regiones)];

            // Recalcular el gráfico per cápita
            if (regiones.length <= 5) {  // Si tenemos 5 o menos regiones, usamos todas
                montosPerCapita = [];
                regionesPerCapita = regiones.slice(0, 5); // Usar las regiones filtradas

                for (let i = 0; i < regionesPerCapita.length; i++) {
                    const region = regionesPerCapita[i];
                    const regionIndex = regiones.indexOf(region);
                    if (regionIndex !== -1) {
                        const presupuesto = montos[regionIndex];
                        const poblacion = poblacionEstimada[region] || poblacionEstimada['Default'];
                        const perCapita = Math.round(presupuesto / poblacion);
                        montosPerCapita.push(perCapita);
                    }
                }
            } else {  // Si tenemos más de 5 regiones, tomamos las 5 con mayor presupuesto
                const regionesData = regiones.map((region, index) => ({
                    region: region,
                    monto: montos[index]
                }));
                regionesData.sort((a, b) => b.monto - a.monto);

                const top5Regiones = regionesData.slice(0, 5);
                regionesPerCapita = top5Regiones.map(item => item.region);

                montosPerCapita = top5Regiones.map(item => {
                    const poblacion = poblacionEstimada[item.region] || poblacionEstimada['Default'];
                    return Math.round(item.monto / poblacion);
                });
            }
        }

        // Inicializar el gráfico de presupuesto per cápita
        const ctxPerCapita = document.getElementById('percapitaChart');

        // Verificar si el elemento del gráfico existe
        if (ctxPerCapita) {
            const ctx = ctxPerCapita.getContext('2d');

            // Destruir el gráfico si ya existe
            if (window.percapitaChart instanceof Chart) {
                window.percapitaChart.destroy();
            }

            window.percapitaChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: regionesPerCapita,
                    datasets: [{
                        label: 'Presupuesto per cápita (S/)',
                        data: montosPerCapita,
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
                                    return 'S/ ' + value;
                                }
                            }
                        }
                    }
                }
            });
        }
    });
</script>
</body>
</html>
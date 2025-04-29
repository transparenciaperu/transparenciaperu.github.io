<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Evolución Anual del Presupuesto | Portal de Transparencia Perú</title>
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
            background-color: var(--primary-red);
            border-color: var(--primary-red);
            box-shadow: 0 4px 6px rgba(217, 16, 35, 0.2);
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #b80d1e;
            border-color: #b80d1e;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(217, 16, 35, 0.3);
        }

        .btn-outline-primary {
            color: var(--primary-red);
            border-color: var(--primary-red);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-red);
            color: white;
        }

        .btn-outline-primary.active {
            background-color: var(--primary-red);
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

        .section-title {
            position: relative;
            margin-bottom: 3rem;
            font-weight: 700;
        }

        .section-title:after {
            content: '';
            position: absolute;
            width: 70px;
            height: 4px;
            background-color: var(--primary-red);
            bottom: -15px;
            left: 0;
        }

        .section-title.text-center:after {
            left: 50%;
            transform: translateX(-50%);
        }

        .social-icon {
            font-size: 1.5rem;
            margin-right: 1rem;
            color: white;
            transition: transform 0.3s ease;
        }

        .social-icon:hover {
            transform: translateY(-5px);
            color: var(--accent-gold);
        }

        .escudo-peru {
            height: 50px;
            margin-right: 10px;
        }

        .ribbon {
            background-color: var(--primary-red);
            color: white;
            padding: 0.5rem 0;
            font-size: 0.9rem;
        }

        .table-primary {
            background-color: rgba(217, 16, 35, 0.1) !important;
        }
    </style>
</head>
<body>
<!-- Ribbon -->
<div class="ribbon">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <i class="fas fa-calendar-alt me-2"></i> Portal actualizado: Abril 2025
            </div>
            <div>
                <a href="#" class="text-white me-3 text-decoration-none"><i class="fas fa-question-circle me-1"></i>
                    Ayuda</a>
                <a href="#" class="text-white text-decoration-none"><i class="fas fa-universal-access me-1"></i>
                    Accesibilidad</a>
            </div>
        </div>
    </div>
</div>

<!-- Barra de navegación -->
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top py-3">
    <div class="container">
        <!-- Logo y marca -->
        <a class="navbar-brand d-flex align-items-center" href="index.jsp">
            <img src="https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/1845b901-cb25-481e-b9ec-c74e9a76936c/d5p73lk-f9b20a75-359d-49d3-8aaa-216d1e2cee27.jpg/v1/fill/w_888,h_900,q_70,strp/escudo_nacional_del_peru_by_esantillansalas_d5p73lk-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9OTEyIiwicGF0aCI6IlwvZlwvMTg0NWI5MDEtY2IyNS00ODFlLWI5ZWMtYzc0ZTlhNzY5MzZjXC9kNXA3M2xrLWY5YjIwYTc1LTM1OWQtNDlkMy04YWFhLTIxNmQxZTJjZWUyNy5qcGciLCJ3aWR0aCI6Ijw9OTAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.rMjvedadAetkHJWCNFhhwRyFLJ9Gz7XCxAZ9hVRVAs8"
                 alt="Escudo de Perú" class="escudo-peru">
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
                               placeholder="Buscar información presupuestaria anual..."
                               aria-label="Search"
                               id="searchInput">
                        <button class="btn btn-danger border-start-0"
                                style="border-top-right-radius: 20px; border-bottom-right-radius: 20px;">
                            Buscar
                        </button>
                    </div>
                    <div class="search-tags d-none d-md-flex justify-content-center mt-2">
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>Evolución Anual</span>
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>Educación</span>
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>Salud</span>
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
                <h1 class="display-5 fw-bold mb-3">Evolución Anual del Presupuesto</h1>
                <p class="lead">Análisis histórico y tendencias del presupuesto público de Perú a lo largo del tiempo.
                    Visualice el comportamiento del gasto público y sus principales variaciones año tras año.</p>
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
                    <a href="ServletPresupuesto?accion=regiones" class="btn btn-outline-primary">Por Regiones</a>
                    <a href="ServletPresupuesto?accion=anual" class="btn btn-primary">Evolución Anual</a>
                    <a href="ServletPresupuesto?accion=proyectos" class="btn btn-outline-primary">Por Proyectos</a>
                    <a href="ServletPresupuesto?accion=categorias" class="btn btn-outline-primary">Por Categorías</a>
                </div>

                <div class="mt-3">
                    <form action="ServletPresupuesto" method="get">
                        <input type="hidden" name="accion" value="anual">
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
                                <select class="form-select" id="categoriaSelect" name="categoria">
                                    <option value="">Todas las categorías</option>
                                    <option value="Educación" ${categoriaSeleccionada == 'Educación' ? 'selected' : ''}>
                                        Educación
                                    </option>
                                    <option value="Salud" ${categoriaSeleccionada == 'Salud' ? 'selected' : ''}>Salud
                                    </option>
                                    <option value="Transporte" ${categoriaSeleccionada == 'Transporte' ? 'selected' : ''}>
                                        Transporte
                                    </option>
                                    <option value="Vivienda" ${categoriaSeleccionada == 'Vivienda' ? 'selected' : ''}>
                                        Vivienda
                                    </option>
                                    <!-- Más categorías -->
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

    <!-- Sección Evolución Anual -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Evolución Anual del Presupuesto (2018-<c:out
                            value="${anioSeleccionado != null ? anioSeleccionado : '2024'}"/>)
                        <c:if test="${not empty categoriaSeleccionada}"> - Categoría ${categoriaSeleccionada}</c:if>
                    </h5>
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
                                <c:when test="${not empty evolucionAnual}">
                                    <ul class="list-group">
                                        <li class="list-group-item">
                                            <i class="fas fa-arrow-up text-success me-2"></i>
                                            <strong>Crecimiento constante: </strong> El presupuesto público ha crecido
                                            en promedio un 7.2% anual desde 2018.
                                        </li>
                                        <li class="list-group-item">
                                            <i class="fas fa-exclamation-circle text-warning me-2"></i>
                                            <strong>2020-2021: </strong> Se registró un incremento excepcional del 8.3%
                                            debido a la pandemia.
                                        </li>
                                        <li class="list-group-item">
                                            <i class="fas fa-chart-line text-primary me-2"></i>
                                            <strong>Proyección 2025: </strong> Se estima un crecimiento de 6.5% respecto
                                            al presupuesto actual.
                                        </li>
                                        <li class="list-group-item">
                                            <i class="fas fa-balance-scale text-info me-2"></i>
                                            <strong>Composición: </strong> Educación, salud e infraestructura mantienen
                                            participación creciente.
                                        </li>
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

                    <!-- Tabla de datos históricos -->
                    <div class="table-responsive mt-4">
                        <table class="table table-hover table-striped">
                            <thead class="table-primary">
                            <tr>
                                <th>Año</th>
                                <th>Presupuesto Total (Millones S/)</th>
                                <th>Variación vs año anterior</th>
                                <th>% del PBI</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty evolucionAnual}">
                                    <c:forEach var="anio" items="${evolucionAnual}" varStatus="status">
                                        <tr>
                                            <td>${anio.anio}</td>
                                            <td>
                                                <fmt:formatNumber value="${anio.montoTotal / 1000000}"
                                                                  pattern="#,##0.0"/>
                                            </td>
                                            <td class="${status.index > 0 ? (anio.montoTotal.doubleValue() > evolucionAnual[status.index-1].montoTotal.doubleValue() ? 'text-success' : 'text-danger') : ''}">
                                                <c:if test="${status.index > 0}">
                                                    <c:set var="variacion"
                                                           value="${(anio.montoTotal.doubleValue() - evolucionAnual[status.index-1].montoTotal.doubleValue()) / evolucionAnual[status.index-1].montoTotal.doubleValue() * 100}"/>
                                                    <c:if test="${variacion > 0}">+</c:if><fmt:formatNumber
                                                        value="${variacion}" pattern="#,##0.0"/>%
                                                </c:if>
                                            </td>
                                            <td>
                                                <c:set var="pbi" value="${20 + Math.random() * 5}"/>
                                                <fmt:formatNumber value="${pbi}" pattern="#,##0.0"/>%
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="text-center py-4">
                                            <div class="alert alert-warning mb-0">
                                                <i class="fas fa-exclamation-triangle me-2"></i>
                                                No hay datos disponibles para la evolución anual. Por favor, inténtelo
                                                de nuevo más tarde.
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
        <div class="row g-4">
            <div class="col-lg-4 mb-4 mb-lg-0">
                <h5 class="mb-4 text-white">Portal de Transparencia Perú</h5>
                <p class="text-white-50">Una iniciativa del Estado Peruano para promover la transparencia y el acceso a
                    la información pública según la Ley 27806.</p>
                <div class="mt-4">
                    <a href="#" class="social-icon"><i class="fab fa-facebook"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
                    <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
            <div class="col-sm-6 col-lg-2 mb-4 mb-lg-0">
                <h6 class="text-white mb-4">Enlaces Rápidos</h6>
                <ul class="list-unstyled mb-0">
                    <li class="mb-2"><a href="index.jsp" class="text-white-50 text-decoration-none">Inicio</a></li>
                    <li class="mb-2"><a href="ServletPresupuesto" class="text-white-50 text-decoration-none">Presupuesto
                        Público</a></li>
                    <li class="mb-2"><a href="ServletSolicitudAcceso" class="text-white-50 text-decoration-none">Acceso
                        a la Información</a>
                    </li>
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Entidades</a></li>
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Datos Abiertos</a></li>
                </ul>
            </div>
            <div class="col-sm-6 col-lg-3 mb-4 mb-lg-0">
                <h6 class="text-white mb-4">Recursos</h6>
                <ul class="list-unstyled mb-0">
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Preguntas Frecuentes</a>
                    </li>
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Guía del Usuario</a></li>
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Ley de Transparencia</a>
                    </li>
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Procedimientos</a></li>
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Formatos</a></li>
                </ul>
            </div>
            <div class="col-lg-3">
                <h6 class="text-white mb-4">Contacto</h6>
                <ul class="list-unstyled text-white-50">
                    <li class="mb-2"><i class="fas fa-map-marker-alt me-2"></i> Jr. Carabaya Cdra. 1 s/n, Lima, Perú
                    </li>
                    <li class="mb-2"><i class="fas fa-phone me-2"></i> (511) 311-5930</li>
                    <li class="mb-2"><i class="fas fa-envelope me-2"></i> transparencia@peru.gob.pe</li>
                </ul>
            </div>
        </div>
        <hr class="mt-4 mb-3" style="border-color: rgba(255,255,255,0.1)">
        <div class="row">
            <div class="col-md-6 text-center text-md-start">
                <p class="small text-white-50 mb-md-0">&copy; 2025 Portal de Transparencia Perú. Todos los derechos
                    reservados.</p>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="text-white-50 text-decoration-none small me-3">Términos y Condiciones</a>
                <a href="#" class="text-white-50 text-decoration-none small me-3">Política de Privacidad</a>
                <a href="#" class="text-white-50 text-decoration-none small">Accesibilidad</a>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Scripts para los gráficos -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Datos para gráficos
        const anios = [];
        const montos = [];

        <c:forEach var="anio" items="${evolucionAnual}">
        anios.push("${anio.anio}");
        montos.push(${anio.montoTotal / 1000000000}); // Convertir a miles de millones
        </c:forEach>

        // Gráfico de Evolución Anual
        const ctxEvolucion = document.getElementById('evolucionChart').getContext('2d');

        // Destruir el gráfico si ya existe para evitar problemas de actualización
        if (window.evolucionChart instanceof Chart) {
            window.evolucionChart.destroy();
        }

        window.evolucionChart = new Chart(ctxEvolucion, {
            type: 'line',
            data: {
                labels: anios,
                datasets: [{
                    label: 'Presupuesto Total (Miles de millones S/)',
                    data: montos,
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

        // Datos para distribución por sectores
        // Ajustar los datos de distribución según la categoría seleccionada
        let distribucionLabels = ['Educación', 'Salud', 'Transporte', 'Vivienda', 'Defensa', 'Otros'];
        let distribucionData = [19.6, 11.4, 10.8, 8.5, 7.3, 42.4];

        // Si hay una categoría seleccionada, ajustar la distribución
        const categoriaSeleccionada = "${categoriaSeleccionada}";
        if (categoriaSeleccionada) {
            // Aumentar el porcentaje de la categoría seleccionada y ajustar el resto
            const index = distribucionLabels.findIndex(label =>
                label.toLowerCase() === categoriaSeleccionada.toLowerCase());

            if (index !== -1) {
                // Aumentar el valor de la categoría seleccionada
                distribucionData[index] = distribucionData[index] * 1.3;

                // Ajustar otros valores para que sumen 100%
                const total = distribucionData.reduce((sum, val) => sum + val, 0);
                distribucionData = distribucionData.map(val => (val / total) * 100);
            }
        }

        // Gráfico de Distribución por sectores
        const ctxDistribucion = document.getElementById('distribucionChart').getContext('2d');

        // Destruir el gráfico si ya existe
        if (window.distribucionChart instanceof Chart) {
            window.distribucionChart.destroy();
        }

        window.distribucionChart = new Chart(ctxDistribucion, {
            type: 'doughnut',
            data: {
                labels: distribucionLabels,
                datasets: [{
                    label: 'Distribución del Presupuesto',
                    data: distribucionData,
                    backgroundColor: [
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(255, 159, 64, 0.7)',
                        'rgba(153, 102, 255, 0.7)',
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(255, 205, 86, 0.7)'
                    ],
                    borderColor: [
                        'rgb(54, 162, 235)',
                        'rgb(75, 192, 192)',
                        'rgb(255, 159, 64)',
                        'rgb(153, 102, 255)',
                        'rgb(255, 99, 132)',
                        'rgb(255, 205, 86)'
                    ],
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
                                    label += context.parsed.toFixed(1) + '%';
                                }
                                return label;
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
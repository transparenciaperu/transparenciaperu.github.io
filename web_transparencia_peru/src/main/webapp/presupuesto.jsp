<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presupuesto Público | Portal de Transparencia Perú</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome para iconos -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Chart.js para gráficos -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- ApexCharts para gráficos avanzados -->
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
    <style>
        :root {
            --primary-color: #1a3c8a;
            --secondary-color: #e63946;
            --accent-color: #f1faee;
            --text-color: #1d3557;
            --light-bg: #f8f9fa;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-color);
            background-color: #f5f7fa;
        }
        
        .navbar {
            background-color: var(--primary-color);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .navbar-brand {
            font-weight: 700;
            color: white !important;
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.85) !important;
        }
        
        .nav-link:hover {
            color: white !important;
        }
        
        .hero-section {
            background: linear-gradient(135deg, #1a3c8a 0%, #4361ee 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 1rem 1rem;
        }
        
        .card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
            margin-bottom: 1.5rem;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card-header {
            background-color: var(--primary-color);
            color: white;
            border-radius: 1rem 1rem 0 0 !important;
            padding: 1rem;
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
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .data-card {
            background-color: white;
            border-left: 5px solid var(--primary-color);
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
            background-color: var(--primary-color);
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
                        <button class="btn btn-outline-primary filter-btn active" data-filter="resumen">Resumen General</button>
                        <button class="btn btn-outline-primary filter-btn" data-filter="entidades">Por Entidades</button>
                        <button class="btn btn-outline-primary filter-btn" data-filter="regiones">Por Regiones</button>
                        <button class="btn btn-outline-primary filter-btn" data-filter="anual">Evolución Anual</button>
                        <button class="btn btn-outline-primary filter-btn" data-filter="proyectos">Por Proyectos</button>
                        <button class="btn btn-outline-primary filter-btn" data-filter="categorias">Por Categorías</button>
                    </div>
                    
                    <div class="mt-3">
                        <div class="row">
                            <div class="col-md-4 mb-2">
                                <select class="form-select" id="anioSelect">
                                    <option value="">Todos los años</option>
                                    <option value="2025">2025</option>
                                    <option value="2024" selected>2024</option>
                                    <option value="2023">2023</option>
                                    <option value="2022">2022</option>
                                    <option value="2021">2021</option>
                                </select>
                            </div>
                            <div class="col-md-4 mb-2">
                                <select class="form-select" id="regionSelect">
                                    <option value="">Todas las regiones</option>
                                    <option value="Lima">Lima</option>
                                    <option value="Arequipa">Arequipa</option>
                                    <option value="Cusco">Cusco</option>
                                    <option value="La Libertad">La Libertad</option>
                                    <option value="Piura">Piura</option>
                                    <!-- Más regiones -->
                                </select>
                            </div>
                            <div class="col-md-4 mb-2">
                                <button class="btn btn-primary w-100" id="aplicarFiltros">
                                    <i class="fas fa-filter me-1"></i> Aplicar Filtros
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Sección de Resumen -->
        <div class="row mb-4 data-section" id="resumenSection">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Resumen del Presupuesto Nacional 2024</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <div class="data-card">
                                    <h3 class="fs-2 fw-bold text-primary">S/ 214.8 MM</h3>
                                    <p class="mb-0 text-muted">Presupuesto Total</p>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="data-card">
                                    <h3 class="fs-2 fw-bold text-success">72.6%</h3>
                                    <p class="mb-0 text-muted">Ejecución Actual</p>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="data-card">
                                    <h3 class="fs-2 fw-bold text-info">S/ 155.9 MM</h3>
                                    <p class="mb-0 text-muted">Presupuesto Ejecutado</p>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="data-card">
                                    <h3 class="fs-2 fw-bold text-warning">8.6%</h3>
                                    <p class="mb-0 text-muted">Incremento vs 2023</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="chart-container chart-animate mt-4">
                            <canvas id="presupuestoResumenChart"></canvas>
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
                            <canvas id="entidadesChart"></canvas>
                        </div>
                        
                        <div class="table-responsive mt-4">
                            <table class="table table-hover table-striped">
                                <thead class="table-primary">
                                    <tr>
                                        <th>Entidad</th>
                                        <th>Presupuesto (Millones S/)</th>
                                        <th>% del Total</th>
                                        <th>Ejecución</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Ministerio de Educación</td>
                                        <td>36,420.5</td>
                                        <td>16.9%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-success" style="width: 78%">78%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ministerio de Salud</td>
                                        <td>23,860.2</td>
                                        <td>11.1%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-success" style="width: 82%">82%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ministerio de Transportes</td>
                                        <td>18,450.7</td>
                                        <td>8.6%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-warning" style="width: 65%">65%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ministerio del Interior</td>
                                        <td>15,620.3</td>
                                        <td>7.3%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-info" style="width: 70%">70%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ministerio de Defensa</td>
                                        <td>12,840.9</td>
                                        <td>6.0%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-success" style="width: 80%">80%</div>
                                            </div>
                                        </td>
                                    </tr>
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
                                    <canvas id="percapitaChart"></canvas>
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
                                    <tr>
                                        <td>Lima</td>
                                        <td>45,620.8</td>
                                        <td>42,350.5</td>
                                        <td class="text-success">+7.7%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-info" style="width: 74%">74%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Cusco</td>
                                        <td>12,840.5</td>
                                        <td>11,250.2</td>
                                        <td class="text-success">+14.1%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-success" style="width: 82%">82%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Arequipa</td>
                                        <td>10,520.3</td>
                                        <td>9,850.7</td>
                                        <td class="text-success">+6.8%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-warning" style="width: 68%">68%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>La Libertad</td>
                                        <td>8,940.2</td>
                                        <td>8,120.3</td>
                                        <td class="text-success">+10.1%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-info" style="width: 76%">76%</div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Piura</td>
                                        <td>7,850.6</td>
                                        <td>7,230.5</td>
                                        <td class="text-success">+8.6%</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-warning" style="width: 65%">65%</div>
                                            </div>
                                        </td>
                                    </tr>
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
                            <canvas id="evolucionChart"></canvas>
                        </div>
                        
                        <div class="row mt-4">
                            <div class="col-md-6">
                                <div class="chart-container chart-animate">
                                    <canvas id="distribucionChart"></canvas>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h5>Análisis de Tendencias</h5>
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <i class="fas fa-arrow-up text-success me-2"></i>
                                        <strong>Educación:</strong> Incremento sostenido del 12% promedio anual desde 2018
                                    </li>
                                    <li class="list-group-item">
                                        <i class="fas fa-arrow-up text-success me-2"></i>
                                        <strong>Salud:</strong> Aumento significativo del 15% en 2023-2024 post pandemia
                                    </li>
                                    <li class="list-group-item">
                                        <i class="fas fa-arrow-down text-danger me-2"></i>
                                        <strong>Defensa:</strong> Reducción del 3% respecto al año anterior
                                    </li>
                                    <li class="list-group-item">
                                        <i class="fas fa-arrow-up text-success me-2"></i>
                                        <strong>Infraestructura:</strong> Aumento del 9.3% para proyectos de reconstrucción
                                    </li>
                                    <li class="list-group-item">
                                        <i class="fas fa-equals text-warning me-2"></i>
                                        <strong>Administración:</strong> Mantenimiento de niveles similares a 2023
                                    </li>
                                </ul>
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
                                    <tr>
                                        <td>Línea 2 del Metro de Lima</td>
                                        <td>3,850.5</td>
                                        <td>MTC</td>
                                        <td>Lima</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-warning" style="width: 45%">45%</div>
                                            </div>
                                        </td>
                                        <td><button class="btn btn-sm btn-primary">Detalles</button></td>
                                    </tr>
                                    <tr>
                                        <td>Aeropuerto Internacional de Chinchero</td>
                                        <td>2,950.8</td>
                                        <td>MTC</td>
                                        <td>Cusco</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-success" style="width: 60%">60%</div>
                                            </div>
                                        </td>
                                        <td><button class="btn btn-sm btn-primary">Detalles</button></td>
                                    </tr>
                                    <tr>
                                        <td>Hospitales de Alta Complejidad (Red Nacional)</td>
                                        <td>2,450.3</td>
                                        <td>MINSA</td>
                                        <td>Nacional</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-info" style="width: 35%">35%</div>
                                            </div>
                                        </td>
                                        <td><button class="btn btn-sm btn-primary">Detalles</button></td>
                                    </tr>
                                    <tr>
                                        <td>Mejoramiento de la Carretera Central</td>
                                        <td>1,840.2</td>
                                        <td>MTC</td>
                                        <td>Varios</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-success" style="width: 80%">80%</div>
                                            </div>
                                        </td>
                                        <td><button class="btn btn-sm btn-primary">Detalles</button></td>
                                    </tr>
                                    <tr>
                                        <td>Sistemas de Tratamiento de Agua Potable</td>
                                        <td>1,650.7</td>
                                        <td>MVCS</td>
                                        <td>Nacional</td>
                                        <td>
                                            <div class="progress">
                                                <div class="progress-bar bg-warning" style="width: 50%">50%</div>
                                            </div>
                                        </td>
                                        <td><button class="btn btn-sm btn-primary">Detalles</button></td>
                                    </tr>
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
                                    <canvas id="categoriasChart"></canvas>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="chart-container chart-animate">
                                    <canvas id="tendenciasCategoriasChart"></canvas>
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
                                    <tr>
                                        <td>Personal y Obligaciones Sociales</td>
                                        <td>58,640.5</td>
                                        <td>27.3%</td>
                                        <td class="text-success">+4.2%</td>
                                    </tr>
                                    <tr>
                                        <td>Inversión en Infraestructura</td>
                                        <td>42,350.8</td>
                                        <td>19.7%</td>
                                        <td class="text-success">+8.7%</td>
                                    </tr>
                                    <tr>
                                        <td>Programas Sociales</td>
                                        <td>36,720.4</td>
                                        <td>17.1%</td>
                                        <td class="text-success">+6.5%</td>
                                    </tr>
                                    <tr>
                                        <td>Bienes y Servicios</td>
                                        <td>32,850.6</td>
                                        <td>15.3%</td>
                                        <td class="text-success">+3.2%</td>
                                    </tr>
                                    <tr>
                                        <td>Servicio de Deuda</td>
                                        <td>24,520.3</td>
                                        <td>11.4%</td>
                                        <td class="text-danger">-2.1%</td>
                                    </tr>
                                    <tr>
                                        <td>Otros Gastos</td>
                                        <td>19,740.2</td>
                                        <td>9.2%</td>
                                        <td class="text-success">+1.8%</td>
                                    </tr>
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
                    <p class="mb-0 small">Última actualización: 15 de Abril de 2025</p>
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
            
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const filter = this.getAttribute('data-filter');
                    
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                    
                    dataSections.forEach(section => {
                        section.style.display = 'none';
                    });
                    
                    document.getElementById(filter + 'Section').style.display = 'flex';
                });
            });
            
            // Gráfico de Resumen
            const ctxResumen = document.getElementById('presupuestoResumenChart').getContext('2d');
            new Chart(ctxResumen, {
                type: 'bar',
                data: {
                    labels: ['Educación', 'Salud', 'Transporte', 'Interior', 'Defensa', 'Vivienda', 'Producción', 'Otros'],
                    datasets: [{
                        label: 'Presupuesto 2024 (Millones S/)',
                        data: [36420.5, 23860.2, 18450.7, 15620.3, 12840.9, 8520.6, 7450.3, 91638.5],
                        backgroundColor: [
                            'rgba(54, 162, 235, 0.7)',
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(255, 159, 64, 0.7)',
                            'rgba(153, 102, 255, 0.7)',
                            'rgba(255, 99, 132, 0.7)',
                            'rgba(255, 205, 86, 0.7)',
                            'rgba(201, 203, 207, 0.7)',
                            'rgba(54, 162, 235, 0.4)'
                        ],
                        borderColor: [
                            'rgb(54, 162, 235)',
                            'rgb(75, 192, 192)',
                            'rgb(255, 159, 64)',
                            'rgb(153, 102, 255)',
                            'rgb(255, 99, 132)',
                            'rgb(255, 205, 86)',
                            'rgb(201, 203, 207)',
                            'rgb(54, 162, 235)'
                        ],
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
                                label: function(context) {
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
                                callback: function(value) {
                                    return 'S/ ' + value.toLocaleString('es-PE');
                                }
                            }
                        }
                    }
                }
            });
            
            // Gráfico por Entidades (se inicializará al cambiar de sección)
            const ctxEntidades = document.getElementById('entidadesChart').getContext('2d');
            new Chart(ctxEntidades, {
                type: 'horizontalBar',
                data: {
                    labels: ['Ministerio de Educación', 'Ministerio de Salud', 'Ministerio de Transportes', 'Ministerio del Interior', 'Ministerio de Defensa'],
                    datasets: [{
                        label: 'Presupuesto 2024 (Millones S/)',
                        data: [36420.5, 23860.2, 18450.7, 15620.3, 12840.9],
                        backgroundColor: [
                            'rgba(54, 162, 235, 0.7)',
                            'rgba(75, 192, 192, 0.7)',
                            'rgba(255, 159, 64, 0.7)',
                            'rgba(153, 102, 255, 0.7)',
                            'rgba(255, 99, 132, 0.7)'
                        ],
                        borderColor: [
                            'rgb(54, 162, 235)',
                            'rgb(75, 192, 192)',
                            'rgb(255, 159, 64)',
                            'rgb(153, 102, 255)',
                            'rgb(255, 99, 132)'
                        ],
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
                                label: function(context) {
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
            
            // Inicialización de otros gráficos se haría bajo demanda al cambiar entre secciones
        });
    </script>
</body>
</html>

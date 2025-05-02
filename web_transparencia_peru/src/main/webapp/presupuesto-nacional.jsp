<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="pe.gob.transparencia.modelo.PresupuestoModelo" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Presupuesto Nacional - Portal de Transparencia</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&family=Roboto:wght@300;400;500;700&display=swap"
          rel="stylesheet">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --primary-color: #0F4C75;
            --secondary-color: #3282B8;
            --accent-color: #BBE1FA;
            --dark-color: #1B262C;
            --light-color: #F8F9FA;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f8f9fa;
        }

        h1, h2, h3, h4, h5, h6 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
        }

        .header-section {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }

        .nav-pills .nav-link {
            color: var(--dark-color);
        }

        .nav-pills .nav-link.active {
            background-color: var(--primary-color);
        }

        .budget-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            transition: transform 0.3s ease;
        }

        .budget-card:hover {
            transform: translateY(-5px);
        }

        .info-box {
            border-left: 5px solid var(--secondary-color);
            background-color: var(--accent-color);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .table-hover tbody tr:hover {
            background-color: rgba(187, 225, 250, 0.3);
        }

        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .chart-container {
            position: relative;
            height: 320px;
            margin-bottom: 2rem;
        }

        .progress-bar {
            background-color: var(--primary-color);
        }

        .page-header {
            position: relative;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
        }

        .page-header:after {
            content: '';
            position: absolute;
            width: 100px;
            height: 3px;
            background-color: var(--primary-color);
            bottom: 0;
            left: 0;
        }
    </style>
</head>
<body>
<!-- Cabecera -->
<div class="header-section">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h1 class="display-5 fw-bold">Presupuesto Nacional</h1>
                <p class="fs-5">Información sobre la ejecución y distribución del presupuesto a nivel nacional</p>
            </div>
            <div class="col-md-4 text-md-end">
                <a href="ServletPresupuesto" class="btn btn-light me-2">Visión General</a>
                <a href="ServletPresupuesto?accion=regional" class="btn btn-outline-light me-2">Nivel Regional</a>
                <a href="ServletPresupuesto?accion=municipal" class="btn btn-outline-light">Nivel Municipal</a>
            </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Resumen principales indicadores -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header bg-white">
                        <h4>Resumen del Presupuesto Nacional</h4>
                    </div>
                    <div class="card-body">
                        <div class="row g-4">
                            <!-- Indicadores clave -->
                            <div class="col-md-3">
                                <div class="border-end border-2 pe-3">
                                    <p class="text-muted mb-0">Presupuesto Total</p>
                                    <p class="stats-number mb-0">S/ 132,701 MM</p>
                                    <small class="text-success"><i class="fas fa-caret-up"></i> +2.8% vs 2023</small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="border-end border-2 pe-3">
                                    <p class="text-muted mb-0">Ejecución</p>
                                    <p class="stats-number mb-0">68.5%</p>
                                    <div class="progress mt-1" style="height: 5px;">
                                        <div class="progress-bar" role="progressbar" style="width: 68.5%"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="border-end border-2 pe-3">
                                    <p class="text-muted mb-0">Entidades</p>
                                    <p class="stats-number mb-0">90</p>
                                    <small class="text-muted">Ministerios y organismos</small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div>
                                    <p class="text-muted mb-0">Proyectos</p>
                                    <p class="stats-number mb-0">1,245</p>
                                    <small class="text-muted">En ejecución</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mb-4">
            <!-- Distribución por ministerios -->
            <div class="col-lg-7">
                <div class="card budget-card h-100">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Distribución por Ministerios</h5>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                    id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
                                2024
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton">
                                <li><a class="dropdown-item" href="#">2024</a></li>
                                <li><a class="dropdown-item" href="#">2023</a></li>
                                <li><a class="dropdown-item" href="#">2022</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="ministeriosChart"></canvas>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-sm table-hover">
                                <thead>
                                <tr>
                                    <th>Ministerio</th>
                                    <th>Monto Asignado (MM S/)</th>
                                    <th>% del Total</th>
                                    <th>Ejecución (%)</th>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td>Educación</td>
                                    <td>32,580</td>
                                    <td>24.6%</td>
                                    <td>
                                        <div class="progress" style="height: 5px;">
                                            <div class="progress-bar" role="progressbar" style="width: 72%"></div>
                                        </div>
                                        <small>72%</small>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Economía y Finanzas</td>
                                    <td>42,500</td>
                                    <td>32.0%</td>
                                    <td>
                                        <div class="progress" style="height: 5px;">
                                            <div class="progress-bar" role="progressbar" style="width: 84%"></div>
                                        </div>
                                        <small>84%</small>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Salud</td>
                                    <td>24,300</td>
                                    <td>18.3%</td>
                                    <td>
                                        <div class="progress" style="height: 5px;">
                                            <div class="progress-bar" role="progressbar" style="width: 68%"></div>
                                        </div>
                                        <small>68%</small>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Transportes y Comunicaciones</td>
                                    <td>9,250</td>
                                    <td>7.0%</td>
                                    <td>
                                        <div class="progress" style="height: 5px;">
                                            <div class="progress-bar" role="progressbar" style="width: 62%"></div>
                                        </div>
                                        <small>62%</small>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Interior</td>
                                    <td>10,150</td>
                                    <td>7.7%</td>
                                    <td>
                                        <div class="progress" style="height: 5px;">
                                            <div class="progress-bar" role="progressbar" style="width: 78%"></div>
                                        </div>
                                        <small>78%</small>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ejecución Presupuestal -->
            <div class="col-lg-5">
                <div class="card budget-card h-100">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Evolución de Ejecución Presupuestal</h5>
                        <div class="dropdown">
                            <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button"
                                    id="dropdownMenuButton2" data-bs-toggle="dropdown" aria-expanded="false">
                                Mensual
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton2">
                                <li><a class="dropdown-item" href="#">Mensual</a></li>
                                <li><a class="dropdown-item" href="#">Trimestral</a></li>
                                <li><a class="dropdown-item" href="#">Anual</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="card-body">
                        <div class="chart-container">
                            <canvas id="ejecucionChart"></canvas>
                        </div>

                        <div class="info-box p-3 rounded">
                            <h6>Datos importantes</h6>
                            <p class="mb-0 small">La ejecución presupuestal a nivel nacional muestra una aceleración en
                                el último trimestre (15% más que en el mismo periodo del año anterior), especialmente en
                                los sectores de Educación y Salud.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Proyectos principales -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card budget-card">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">Principales Proyectos de Inversión Nacional</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>Proyecto</th>
                                        <th>Entidad</th>
                                        <th>Presupuesto</th>
                                        <th>Avance</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Ampliación del sistema de agua potable en zonas urbano-marginales</td>
                                        <td>Ministerio de Vivienda</td>
                                        <td>S/ 520 millones</td>
                                        <td>
                                            <div class="progress" style="height: 5px;">
                                                <div class="progress-bar" role="progressbar" style="width: 48%"></div>
                                            </div>
                                            <small>48%</small>
                                        </td>
                                        <td><span class="badge bg-success">En ejecución</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary">
                                                <i class="fas fa-info-circle"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Programa Nacional de Infraestructura Educativa</td>
                                        <td>Ministerio de Educación</td>
                                        <td>S/ 1,250 millones</td>
                                        <td>
                                            <div class="progress" style="height: 5px;">
                                                <div class="progress-bar" role="progressbar" style="width: 35%"></div>
                                            </div>
                                            <small>35%</small>
                                        </td>
                                        <td><span class="badge bg-success">En ejecución</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary">
                                                <i class="fas fa-info-circle"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Modernización de hospitales regionales</td>
                                        <td>Ministerio de Salud</td>
                                        <td>S/ 780 millones</td>
                                        <td>
                                            <div class="progress" style="height: 5px;">
                                                <div class="progress-bar" role="progressbar" style="width: 52%"></div>
                                            </div>
                                            <small>52%</small>
                                        </td>
                                        <td><span class="badge bg-success">En ejecución</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary">
                                                <i class="fas fa-info-circle"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Mejoramiento de la red vial nacional</td>
                                        <td>Ministerio de Transportes</td>
                                        <td>S/ 1,420 millones</td>
                                        <td>
                                            <div class="progress" style="height: 5px;">
                                                <div class="progress-bar" role="progressbar" style="width: 65%"></div>
                                            </div>
                                            <small>65%</small>
                                        </td>
                                        <td><span class="badge bg-success">En ejecución</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary">
                                                <i class="fas fa-info-circle"></i>
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Enlaces a informes -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card budget-card">
                    <div class="card-header bg-white">
                        <h5 class="mb-0">Informes y Documentos</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-6 col-lg-3">
                                <div class="d-flex p-3 border rounded align-items-center">
                                    <i class="fas fa-file-pdf fa-2x text-danger me-3"></i>
                                    <div>
                                        <h6 class="mb-0">Presupuesto Nacional 2024</h6>
                                        <small class="text-muted">PDF, 3.2 MB</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <div class="d-flex p-3 border rounded align-items-center">
                                    <i class="fas fa-file-excel fa-2x text-success me-3"></i>
                                    <div>
                                        <h6 class="mb-0">Ejecución trimestral</h6>
                                        <small class="text-muted">XLSX, 1.8 MB</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <div class="d-flex p-3 border rounded align-items-center">
                                    <i class="fas fa-file-powerpoint fa-2x text-primary me-3"></i>
                                    <div>
                                        <h6 class="mb-0">Presentación MEF</h6>
                                        <small class="text-muted">PPTX, 5.4 MB</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6 col-lg-3">
                                <div class="d-flex p-3 border rounded align-items-center">
                                    <i class="fas fa-file-alt fa-2x text-info me-3"></i>
                                    <div>
                                        <h6 class="mb-0">Memoria anual 2024</h6>
                                        <small class="text-muted">PDF, 6.7 MB</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts para las visualizaciones -->
    <script>
        // Gráfico de ministerios
        const ministeriosCtx = document.getElementById('ministeriosChart').getContext('2d');
        const ministeriosChart = new Chart(ministeriosCtx, {
            type: 'bar',
            data: {
                labels: ['Economía', 'Educación', 'Salud', 'Interior', 'Transportes', 'Otros'],
                datasets: [{
                    label: 'Presupuesto 2024 (millones S/)',
                    data: [42500, 32580, 24300, 10150, 9250, 13921],
                    backgroundColor: [
                        'rgba(15, 76, 117, 0.8)',
                        'rgba(50, 130, 184, 0.8)',
                        'rgba(187, 225, 250, 0.8)',
                        'rgba(27, 38, 44, 0.8)',
                        'rgba(15, 76, 117, 0.6)',
                        'rgba(15, 76, 117, 0.4)'
                    ],
                    borderColor: [
                        'rgba(15, 76, 117, 1)',
                        'rgba(50, 130, 184, 1)',
                        'rgba(187, 225, 250, 1)',
                        'rgba(27, 38, 44, 1)',
                        'rgba(15, 76, 117, 0.8)',
                        'rgba(15, 76, 117, 0.6)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return 'S/ ' + value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                            }
                        }
                    }
                }
            }
        });

        // Gráfico de ejecución presupuestal
        const ejecucionCtx = document.getElementById('ejecucionChart').getContext('2d');
        const ejecucionChart = new Chart(ejecucionCtx, {
            type: 'line',
            data: {
                labels: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                datasets: [{
                    label: '2024',
                    data: [5.4, 11.2, 18.5, 25.3, 31.9, 38.6, 46.2, 53.7, 59.4, 65.8, 75.2, 83.7],
                    borderColor: 'rgba(15, 76, 117, 1)',
                    backgroundColor: 'rgba(15, 76, 117, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4
                }, {
                    label: '2023',
                    data: [4.8, 9.6, 17.2, 22.9, 29.1, 35.8, 43.5, 51.2, 56.8, 62.1, 72.5, 81.3],
                    borderColor: 'rgba(187, 225, 250, 1)',
                    backgroundColor: 'rgba(187, 225, 250, 0.1)',
                    borderWidth: 2,
                    borderDash: [5, 5],
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
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
    </script>

    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

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

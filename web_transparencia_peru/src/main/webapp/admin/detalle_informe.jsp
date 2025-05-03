<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.InformeEntidad" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // Verificar si el usuario está en sesión y es admin
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
        // No es admin o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener el informe de los atributos de solicitud
    InformeEntidad informe = (InformeEntidad) request.getAttribute("informe");
    if (informe == null) {
        // Si no hay informe, redirigir a la lista
        response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
        return;
    }

    // Formato para fechas
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Informe - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Chart.js para gráficos -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
</head>
<body>
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Administrador</a>
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios">
                            <i class="bi bi-people me-1"></i> Gestión de Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/entidades.jsp">
                            <i class="bi bi-building me-1"></i> Entidades Públicas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/ciudadanos.jsp">
                            <i class="bi bi-person-badge me-1"></i> Ciudadanos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarPresupuestos">
                            <i class="bi bi-cash-coin me-1"></i> Presupuestos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarSolicitudes">
                            <i class="bi bi-file-earmark-text me-1"></i> Solicitudes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active"
                           href="<%= request.getContextPath() %>/admin.do?accion=listarInformes">
                            <i class="bi bi-graph-up me-1"></i> Informes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/configuracion.jsp">
                            <i class="bi bi-gear me-1"></i> Configuración
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom title-section">
                <div>
                    <h1 class="h2">Detalle del Informe</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/admin/informes.jsp">Informes</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Ver detalle</li>
                        </ol>
                    </nav>
                </div>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <a href="<%= request.getContextPath() %>/admin.do?accion=editarInforme&id=<%= informe.getId() %>"
                           class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-pencil me-1"></i> Editar
                        </a>
                        <a href="<%= request.getContextPath() %>/admin/informes.jsp"
                           class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-arrow-left me-1"></i> Volver
                        </a>
                    </div>
                </div>
            </div>

            <!-- Tarjeta de información del informe -->
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h6 class="m-0 font-weight-bold text-primary">Información del Informe</h6>
                    <div>
                        <span class="badge <%= informe.getEstado().equals("Activo") ? "bg-success" : "bg-secondary" %>"><%= informe.getEstado() %></span>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <h5>Título</h5>
                            <p class="mb-3"><%= informe.getTitulo() %>
                            </p>

                            <h5>Tipo de Informe</h5>
                            <p class="mb-3">
                                <% if (informe.getTipo().equals("presupuesto")) { %>
                                Presupuestos por Nivel de Gobierno
                                <% } else if (informe.getTipo().equals("ejecucion")) { %>
                                Ejecución Presupuestal
                                <% } else if (informe.getTipo().equals("solicitudes")) { %>
                                Solicitudes de Información
                                <% } else if (informe.getTipo().equals("entidades")) { %>
                                Entidades Públicas
                                <% } else { %>
                                <%= informe.getTipo() %>
                                <% } %>
                            </p>

                            <h5>Año</h5>
                            <p class="mb-3"><%= informe.getAnio() %>
                            </p>

                            <h5>Nivel de Gobierno</h5>
                            <p class="mb-3"><%= informe.getNivelGobierno() %>
                            </p>
                        </div>
                        <div class="col-md-6 mb-3">
                            <h5>ID</h5>
                            <p class="mb-3"><%= informe.getId() %>
                            </p>

                            <h5>Fecha de Generación</h5>
                            <p class="mb-3"><%= formatoFecha.format(informe.getFechaGeneracion()) %>
                            </p>

                            <h5>Descripción</h5>
                            <p class="mb-3"><%= informe.getDescripcion() != null ? informe.getDescripcion() : "Sin descripción" %>
                            </p>

                            <% if (informe.getRutaArchivo() != null && !informe.getRutaArchivo().isEmpty()) { %>
                            <h5>Descargar Informe</h5>
                            <p>
                                <a href="<%= request.getContextPath() %><%= informe.getRutaArchivo() %>"
                                   class="btn btn-sm btn-outline-primary" target="_blank">
                                    <i class="bi bi-file-earmark-arrow-down me-1"></i> Descargar informe
                                </a>
                            </p>
                            <% } %>
                        </div>
                    </div>

                    <% if (informe.getDatosJson() != null && !informe.getDatosJson().isEmpty()) { %>
                    <!-- Datos del informe (visualización) -->
                    <div class="row mt-4">
                        <div class="col-12">
                            <h5>Datos del Informe</h5>
                            <div class="card">
                                <div class="card-body">
                                    <div class="chart-container">
                                        <canvas id="informeChart" style="height: 300px;"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <% } %>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function () {
        // Inicializar tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        <% if (informe.getDatosJson() != null && !informe.getDatosJson().isEmpty()) { %>
        try {
            // Intentar parsear los datos JSON del informe
            const datosInforme = JSON.parse(`<%= informe.getDatosJson().replace("\"", "'") %>`);

            if (datosInforme) {
                const ctx = document.getElementById('informeChart');

                // Crear un gráfico basado en el tipo de informe
                <% if (informe.getTipo().equals("presupuesto")) { %>
                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: datosInforme.labels || ['Nacional', 'Regional', 'Municipal'],
                        datasets: [{
                            data: datosInforme.datos || [60, 25, 15],
                            backgroundColor: [
                                'rgba(78, 115, 223, 0.8)',
                                'rgba(54, 185, 204, 0.8)',
                                'rgba(246, 194, 62, 0.8)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        plugins: {
                            title: {
                                display: true,
                                text: 'Distribución Presupuestal por Nivel de Gobierno'
                            },
                            legend: {
                                position: 'bottom'
                            }
                        }
                    }
                });
                <% } else if (informe.getTipo().equals("ejecucion")) { %>
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: datosInforme.labels || ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],
                        datasets: [{
                            label: 'Ejecución Presupuestal',
                            data: datosInforme.datos || [12, 19, 3, 5, 2, 3],
                            backgroundColor: 'rgba(78, 115, 223, 0.8)'
                        }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        plugins: {
                            title: {
                                display: true,
                                text: 'Ejecución Presupuestal'
                            }
                        }
                    }
                });
                <% } else if (informe.getTipo().equals("solicitudes")) { %>
                new Chart(ctx, {
                    type: 'pie',
                    data: {
                        labels: datosInforme.labels || ['Atendidas', 'En proceso', 'Pendientes'],
                        datasets: [{
                            data: datosInforme.datos || [65, 20, 15],
                            backgroundColor: [
                                'rgba(40, 167, 69, 0.8)',
                                'rgba(255, 193, 7, 0.8)',
                                'rgba(220, 53, 69, 0.8)'
                            ],
                            borderWidth: 1
                        }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        plugins: {
                            title: {
                                display: true,
                                text: 'Solicitudes por Estado'
                            },
                            legend: {
                                position: 'bottom'
                            }
                        }
                    }
                });
                <% } else { %>
                // Tipo de gráfico genérico para otros tipos
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: datosInforme.labels || ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun'],
                        datasets: [{
                            label: 'Datos del Informe',
                            data: datosInforme.datos || [12, 19, 3, 5, 2, 3],
                            borderColor: 'rgba(78, 115, 223, 1)',
                            tension: 0.1
                        }]
                    },
                    options: {
                        maintainAspectRatio: false,
                        plugins: {
                            title: {
                                display: true,
                                text: 'Datos del Informe'
                            }
                        }
                    }
                });
                <% } %>
            }
        } catch (error) {
            console.error("Error al parsear datos JSON:", error);
        }
        <% } %>
    });
</script>
</body>
</html>
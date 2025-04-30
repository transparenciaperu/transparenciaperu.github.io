<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%
    // Verificar si el usuario está en sesión y es funcionario
    UsuarioEntidad usuario = (UsuarioEntidad) session.getAttribute("usuario");
    if (usuario == null || !"FUNCIONARIO".equals(usuario.getCodRol())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=No tiene permisos para acceder a esta área");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Funcionario - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
    </style>
</head>
<body>
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
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/autenticacion?accion=cerrar"><i
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
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h1 class="h2">Panel de Funcionario</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-outline-secondary">Compartir</button>
                        <button type="button" class="btn btn-sm btn-outline-secondary">Exportar</button>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Solicitudes Pendientes</h5>
                            <h1 class="display-4">8</h1>
                            <p class="card-text">Solicitudes de información que requieren su atención.</p>
                            <a href="solicitudes.jsp" class="btn btn-primary">Gestionar solicitudes</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Documentos de Transparencia</h5>
                            <h1 class="display-4">15</h1>
                            <p class="card-text">Documentos publicados por su entidad.</p>
                            <a href="transparencia.jsp" class="btn btn-primary">Gestionar documentos</a>
                        </div>
                    </div>
                </div>
            </div>

            <h2>Últimas Solicitudes Recibidas</h2>
            <div class="table-responsive">
                <table class="table table-striped table-sm">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
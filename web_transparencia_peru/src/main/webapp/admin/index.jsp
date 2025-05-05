<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="pe.gob.transparencia.db.MySQLConexion" %>
<%
    // Verificar si el usuario está en sesión y es admin
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
        // No es admin o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administrador - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
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
                        <a class="nav-link active" href="index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios">
                            <i class="bi bi-people me-1"></i> Gestión de Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="entidades.jsp">
                            <i class="bi bi-building me-1"></i> Entidades Públicas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarCiudadanos">
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
                </ul>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom title-section">
                <h1 class="h2">Panel de Control</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="tooltip"
                                data-bs-placement="bottom" title="Configuración del sistema">
                            <i class="bi bi-gear me-1"></i> Configuración
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="tooltip"
                                data-bs-placement="bottom" title="Generar reportes">
                            <i class="bi bi-file-earmark-arrow-down me-1"></i> Reportes
                        </button>
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
                <div class="col-md-4 mb-4">
                    <div class="card stat-card primary-border fade-in">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                        Usuarios del Sistema
                                    </div>
                                    <%
                                        int totalUsuarios = 0;
                                        try {
                                            Connection con = MySQLConexion.getConexion();
                                            if (con != null) {
                                                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS total FROM usuario");
                                                ResultSet rs = ps.executeQuery();
                                                if (rs.next()) {
                                                    totalUsuarios = rs.getInt("total");
                                                }
                                                rs.close();
                                                ps.close();
                                                con.close();
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                    <h1 class="display-4"><%= totalUsuarios %>
                                    </h1>
                                    <p class="card-text">Total de funcionarios y administradores.</p>
                                    <a href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios"
                                       class="btn btn-primary">Ver detalles</a>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="bi bi-people text-primary"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card stat-card success-border fade-in">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                        Ciudadanos Registrados
                                    </div>
                                    <%
                                        int totalCiudadanos = 0;
                                        try {
                                            Connection con = MySQLConexion.getConexion();
                                            if (con != null) {
                                                PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) AS total FROM Ciudadano");
                                                ResultSet rs = ps.executeQuery();
                                                if (rs.next()) {
                                                    totalCiudadanos = rs.getInt("total");
                                                }
                                                rs.close();
                                                ps.close();
                                                con.close();
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                    <h1 class="display-4"><%= totalCiudadanos %>
                                    </h1>
                                    <p class="card-text">Total de ciudadanos registrados en el portal.</p>
                                    <a href="<%= request.getContextPath() %>/admin.do?accion=listarCiudadanos"
                                       class="btn btn-primary">Ver detalles</a>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="bi bi-person-badge text-success"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card stat-card warning-border fade-in">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                        Solicitudes Pendientes
                                    </div>
                                    <%
                                        int solicitudesPendientes = 0;
                                        try {
                                            Connection con = MySQLConexion.getConexion();
                                            if (con != null) {
                                                // Asumiendo que en EstadoSolicitud existe un estado "Pendiente" con id 1
                                                PreparedStatement ps = con.prepareStatement(
                                                        "SELECT COUNT(*) AS total FROM SolicitudAcceso WHERE estadoSolicitudId = 1");
                                                ResultSet rs = ps.executeQuery();
                                                if (rs.next()) {
                                                    solicitudesPendientes = rs.getInt("total");
                                                }
                                                rs.close();
                                                ps.close();
                                                con.close();
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                    <h1 class="display-4"><%= solicitudesPendientes %>
                                    </h1>
                                    <p class="card-text">Solicitudes que requieren atención.</p>
                                    <a href="<%= request.getContextPath() %>/admin.do?accion=listarSolicitudes"
                                       class="btn btn-primary">Ver detalles</a>
                                </div>
                                <div class="col-4 text-end">
                                    <i class="bi bi-file-earmark-text text-warning"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <h2 class="mt-4 mb-3">Actividad Reciente</h2>
            <div class="table-responsive fade-in">
                <table class="table table-striped" id="tablaActividad">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Usuario</th>
                        <th>Acción</th>
                        <th>Fecha</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        try {
                            Connection con = MySQLConexion.getConexion();
                            if (con != null) {
                                // Esta consulta es un ejemplo y deberá adaptarse según la estructura real de tu base de datos
                                // Podría ser una tabla de auditoría o actividades recientes
                                PreparedStatement ps = con.prepareStatement(
                                        "SELECT sa.id, c.nombres, c.apellidos, es.nombre as accion, sa.fechaSolicitud " +
                                                "FROM SolicitudAcceso sa " +
                                                "JOIN Ciudadano c ON sa.ciudadanoId = c.id " +
                                                "JOIN EstadoSolicitud es ON sa.estadoSolicitudId = es.id " +
                                                "ORDER BY sa.fechaSolicitud DESC LIMIT 5");

                                ResultSet rs = ps.executeQuery();
                                while (rs.next()) {
                    %>
                    <tr>
                        <td><%= rs.getInt("id") %>
                        </td>
                        <td><%= rs.getString("nombres") + " " + rs.getString("apellidos") %>
                        </td>
                        <td><%= rs.getString("accion") %>
                        </td>
                        <td><%= rs.getDate("fechaSolicitud") %>
                        </td>
                    </tr>
                    <%
                                }
                                rs.close();
                                ps.close();
                                con.close();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    %>
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
        $('#tablaActividad').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            pageLength: 5,
            lengthMenu: [[5, 10, 25, -1], [5, 10, 25, "Todos"]],
            responsive: true,
            order: [[3, 'desc']] // Ordenar por fecha (columna 3) descendente
        });

        // Inicializar tooltips de Bootstrap
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Añadir animación a las cards de estadísticas
        $('.card').addClass('fade-in');
    });
</script>
</body>
</html>
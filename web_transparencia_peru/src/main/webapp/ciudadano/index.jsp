<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.CiudadanoEntidad" %>
<%@ page import="java.sql.*" %>
<%@ page import="pe.gob.transparencia.util.ConexionBD" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("ciudadano") == null) {
        // No está logueado como ciudadano, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    CiudadanoEntidad ciudadano = (CiudadanoEntidad) sesion.getAttribute("ciudadano");

    // Conexión a la base de datos para obtener datos dinámicos
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Datos para las estadísticas de solicitudes
    int solicitudesPendientes = 0;
    int solicitudesEnProceso = 0;
    int solicitudesAtendidas = 0;

    // Lista para almacenar las últimas solicitudes
    List<Map<String, Object>> ultimasSolicitudes = new ArrayList<>();

    try {
        conn = ConexionBD.getConexion();

        // Obtener estadísticas de solicitudes
        String sqlEstadisticas = "SELECT e.nombre, COUNT(s.id) as cantidad " +
                "FROM SolicitudAcceso s " +
                "JOIN EstadoSolicitud e ON s.estadoSolicitudId = e.id " +
                "WHERE s.ciudadanoId = ? " +
                "GROUP BY e.nombre";

        pstmt = conn.prepareStatement(sqlEstadisticas);
        pstmt.setInt(1, ciudadano.getId());
        rs = pstmt.executeQuery();

        while (rs.next()) {
            String estado = rs.getString("nombre");
            int cantidad = rs.getInt("cantidad");

            if (estado.equals("Pendiente")) {
                solicitudesPendientes = cantidad;
            } else if (estado.equals("En Proceso")) {
                solicitudesEnProceso = cantidad;
            } else if (estado.equals("Atendida")) {
                solicitudesAtendidas = cantidad;
            }
        }

        // Obtener las últimas solicitudes
        String sqlUltimasSolicitudes = "SELECT s.id, s.fechaSolicitud, e.nombre as entidad, " +
                "s.descripcion, es.nombre as estado, s.fechaRespuesta " +
                "FROM SolicitudAcceso s " +
                "JOIN EstadoSolicitud es ON s.estadoSolicitudId = es.id " +
                "JOIN EntidadPublica e ON s.entidadPublicaId = e.id " +
                "WHERE s.ciudadanoId = ? " +
                "ORDER BY s.fechaSolicitud DESC LIMIT 3";

        pstmt = conn.prepareStatement(sqlUltimasSolicitudes);
        pstmt.setInt(1, ciudadano.getId());
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> solicitud = new HashMap<>();
            solicitud.put("id", rs.getInt("id"));
            solicitud.put("fecha", rs.getDate("fechaSolicitud"));
            solicitud.put("entidad", rs.getString("entidad"));
            solicitud.put("descripcion", rs.getString("descripcion"));
            solicitud.put("estado", rs.getString("estado"));
            solicitud.put("fechaRespuesta", rs.getDate("fechaRespuesta"));

            ultimasSolicitudes.add(solicitud);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Panel Ciudadano - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ciudadano.css">
</head>
<body class="ciudadano-theme">
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
                        <a class="nav-link active" href="index.jsp">
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
                        <a class="nav-link" href="presupuesto.jsp">
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
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom title-section">
                <h1 class="h2">Mi Panel Ciudadano</h1>
            </div>

            <div class="hero-banner fade-in">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <h1>Bienvenido(a), <%= ciudadano.getNombreCompleto().split(" ")[0] %>
                        </h1>
                        <p class="lead mb-4">Al Portal de Transparencia, donde puedes acceder a información pública y
                            realizar solicitudes de acceso de manera fácil y rápida.</p>
                        <div class="d-grid gap-2 d-md-flex">
                            <a href="nueva_solicitud.jsp" class="btn btn-light btn-lg px-4 me-md-2">
                                <i class="bi bi-plus-circle me-2"></i>Nueva Solicitud
                            </a>
                            <a href="presupuesto.jsp" class="btn btn-outline-light btn-lg px-4">
                                <i class="bi bi-cash-coin me-2"></i>Ver Presupuesto
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-4 d-none d-lg-block">
                        <img src="<%= request.getContextPath() %>/assets/img/transparency.svg" alt="Transparencia"
                             class="img-fluid float-animation" style="max-height: 200px;">
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
                <div class="col-md-6 mb-4">
                    <div class="card stat-card primary-border fade-in">
                        <div class="card-body">
                            <h5 class="card-title">Mis Solicitudes</h5>
                            <p>Estado de sus solicitudes de acceso a la información:</p>
                            <div class="row">
                                <div class="col-6">
                                    <div class="d-flex align-items-center">
                                        <div class="badge bg-warning me-2">P</div>
                                        <div>Pendientes <span class="fw-bold"><%= solicitudesPendientes %></span></div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="d-flex align-items-center">
                                        <div class="badge bg-success me-2">A</div>
                                        <div>Atendidas <span class="fw-bold"><%= solicitudesAtendidas %></span></div>
                                    </div>
                                </div>
                            </div>
                            <hr>
                            <a href="mis_solicitudes.jsp" class="btn btn-primary">Ver todas mis solicitudes</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card stat-card success-border fade-in">
                        <div class="card-body">
                            <h5 class="card-title">Nueva Solicitud de Información</h5>
                            <p>Realice una nueva solicitud de acceso a la información pública.</p>
                            <p class="small text-muted">Las entidades públicas tienen un plazo legal para responder a su
                                solicitud.</p>
                            <a href="nueva_solicitud.jsp" class="btn btn-success">Crear nueva solicitud</a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Accesos Rápidos</h6>
                        </div>
                        <div class="card-body">
                            <div class="row g-4">
                                <div class="col-6 text-center">
                                    <a href="presupuesto.jsp" class="text-decoration-none">
                                        <div class="feature-icon mx-auto">
                                            <i class="bi bi-cash-coin"></i>
                                        </div>
                                        <h5>Presupuesto Público</h5>
                                        <p class="text-muted">Consulta información detallada</p>
                                    </a>
                                </div>
                                <div class="col-6 text-center">
                                    <a href="nueva_solicitud.jsp" class="text-decoration-none">
                                        <div class="feature-icon mx-auto">
                                            <i class="bi bi-file-plus"></i>
                                        </div>
                                        <h5>Nueva Solicitud</h5>
                                        <p class="text-muted">Crea un nuevo requerimiento</p>
                                    </a>
                                </div>
                                <div class="col-6 text-center">
                                    <a href="mis_solicitudes.jsp" class="text-decoration-none">
                                        <div class="feature-icon mx-auto">
                                            <i class="bi bi-list-check"></i>
                                        </div>
                                        <h5>Mis Solicitudes</h5>
                                        <p class="text-muted">Revisa el estado de tus pedidos</p>
                                    </a>
                                </div>
                                <div class="col-6 text-center">
                                    <a href="perfil.jsp" class="text-decoration-none">
                                        <div class="feature-icon mx-auto">
                                            <i class="bi bi-person"></i>
                                        </div>
                                        <h5>Mi Perfil</h5>
                                        <p class="text-muted">Actualiza tu información</p>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Estado del Sistema</h6>
                        </div>
                        <div class="card-body">
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    Servidor Portal de Transparencia
                                    <span class="badge bg-success rounded-pill">Activo</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    Base de Datos
                                    <span class="badge bg-success rounded-pill">Activo</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    API de Integración
                                    <span class="badge bg-success rounded-pill">Activo</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    Siguientes Mantenimientos Programados
                                    <span class="text-muted small">30 de mayo, 2025 - 01:00-05:00 AM</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <h2 class="mt-4 mb-3">Últimas Solicitudes</h2>
            <div class="table-responsive fade-in">
                <table class="table table-striped" id="tablaSolicitudes">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Fecha</th>
                        <th>Entidad</th>
                        <th>Descripción</th>
                        <th>Estado</th>
                        <th>Acción</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        // Mostrar las últimas solicitudes obtenidas de la base de datos
                        for (Map<String, Object> solicitud : ultimasSolicitudes) {
                            String estado = (String) solicitud.get("estado");
                            String badgeClass = "bg-warning"; // Por defecto

                            if (estado.equalsIgnoreCase("Atendida")) {
                                badgeClass = "bg-success";
                            } else if (estado.equalsIgnoreCase("En Proceso")) {
                                badgeClass = "bg-primary";
                            } else if (estado.equalsIgnoreCase("Rechazada")) {
                                badgeClass = "bg-danger";
                            }
                    %>
                    <tr>
                        <td><%= solicitud.get("id") %>
                        </td>
                        <td><%= solicitud.get("fecha") %>
                        </td>
                        <td><%= solicitud.get("entidad") %>
                        </td>
                        <td><%= solicitud.get("descripcion").toString().length() > 70 ? solicitud.get("descripcion").toString().substring(0, 70) + "..." : solicitud.get("descripcion") %>
                        </td>
                        <td><span class="badge <%= badgeClass %>"><%= estado %></span></td>
                        <td><a href="solicitud_detalle.jsp?id=<%= solicitud.get("id") %>"
                               class="btn btn-sm btn-primary">Ver detalle</a></td>
                    </tr>
                    <% } %>

                    <%
                        // Si no hay solicitudes, mostrar mensaje
                        if (ultimasSolicitudes.isEmpty()) {
                    %>
                    <tr>
                        <td colspan="6" class="text-center">No hay solicitudes registradas</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        // Inicializar elementos con animación fade-in
        $('.card, .alert, .table-responsive').addClass('fade-in');
    });
</script>
</body>
</html>
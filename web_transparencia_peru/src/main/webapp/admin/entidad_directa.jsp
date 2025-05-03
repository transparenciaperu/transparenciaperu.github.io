<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.EntidadPublicaModelo" %>
<%@ page import="pe.gob.transparencia.modelo.NivelGobiernoModelo" %>
<%@ page import="pe.gob.transparencia.modelo.RegionModelo" %>
<%@ page import="pe.gob.transparencia.entidades.NivelGobiernoEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.RegionEntidad" %>
<%@ page import="java.util.List" %>
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

    // Entidad a mostrar
    EntidadPublicaEntidad entidad = null;

    // Mensajes de diagnóstico
    StringBuilder diagnostico = new StringBuilder();

    // 1. Obtener el ID de la URL
    String idStr = request.getParameter("id");
    diagnostico.append("<p>ID recibido: " + idStr + "</p>");

    if (idStr != null && !idStr.isEmpty()) {
        try {
            int id = Integer.parseInt(idStr);
            diagnostico.append("<p>ID convertido a entero: " + id + "</p>");

            // 2. Intentar recuperar la entidad directamente de la base de datos
            diagnostico.append("<h4>Consultando directamente la base de datos:</h4>");

            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                con = MySQLConexion.getConexion();
                if (con != null) {
                    diagnostico.append("<p class='text-success'>✓ Conexión establecida correctamente</p>");

                    // Verificar la estructura de la tabla EntidadPublica
                    diagnostico.append("<h5>Estructura de la tabla EntidadPublica:</h5>");
                    try {
                        java.sql.DatabaseMetaData metaData = con.getMetaData();
                        ResultSet columns = metaData.getColumns(null, null, "EntidadPublica", null);

                        diagnostico.append("<table class='table table-sm table-bordered'>");
                        diagnostico.append("<thead><tr><th>Columna</th><th>Tipo</th><th>Nullable</th></tr></thead><tbody>");

                        boolean hasRucColumn = false;
                        while (columns.next()) {
                            String columnName = columns.getString("COLUMN_NAME");
                            String columnType = columns.getString("TYPE_NAME");
                            String nullable = columns.getString("IS_NULLABLE");

                            diagnostico.append("<tr>");
                            diagnostico.append("<td>" + columnName + "</td>");
                            diagnostico.append("<td>" + columnType + "</td>");
                            diagnostico.append("<td>" + nullable + "</td>");
                            diagnostico.append("</tr>");

                            if (columnName.equalsIgnoreCase("ruc")) {
                                hasRucColumn = true;
                            }
                        }

                        diagnostico.append("</tbody></table>");

                        columns.close();
                    } catch (Exception ex) {
                        diagnostico.append("<p class='text-danger'>Error al obtener estructura de tabla: " + ex.getMessage() + "</p>");
                    }

                    // Consultar si la entidad existe
                    String sqlCheck = "SELECT COUNT(*) as total FROM EntidadPublica WHERE id = ?";
                    ps = con.prepareStatement(sqlCheck);
                    ps.setInt(1, id);
                    rs = ps.executeQuery();

                    if (rs.next() && rs.getInt("total") > 0) {
                        diagnostico.append("<p class='text-success'>✓ La entidad con ID " + id + " existe en la base de datos</p>");

                        // Obtener datos completos
                        rs.close();
                        ps.close();

                        String sql = "SELECT e.id, e.nombre, e.tipo, e.nivelGobiernoId, e.regionId, e.direccion, " +
                                "e.telefono, e.email, e.sitioWeb " +
                                "FROM EntidadPublica e " +
                                "WHERE e.id = ?";

                        ps = con.prepareStatement(sql);
                        ps.setInt(1, id);
                        rs = ps.executeQuery();

                        if (rs.next()) {
                            entidad = new EntidadPublicaEntidad();
                            entidad.setId(rs.getInt("id"));
                            entidad.setNombre(rs.getString("nombre"));
                            entidad.setTipo(rs.getString("tipo"));
                            entidad.setNivelGobiernoId(rs.getInt("nivelGobiernoId"));
                            entidad.setRegionId(rs.getInt("regionId"));
                            entidad.setDireccion(rs.getString("direccion"));
                            entidad.setTelefono(rs.getString("telefono"));
                            entidad.setEmail(rs.getString("email"));
                            entidad.setSitioWeb(rs.getString("sitioWeb"));

                            diagnostico.append("<p class='text-success'>✓ Entidad recuperada correctamente: " + entidad.getNombre() + "</p>");
                        } else {
                            diagnostico.append("<p class='text-danger'>✗ Error: No se pudo recuperar los datos de la entidad</p>");
                        }
                    } else {
                        diagnostico.append("<p class='text-danger'>✗ Error: No existe una entidad con el ID " + id + "</p>");
                    }
                } else {
                    diagnostico.append("<p class='text-danger'>✗ Error: No se pudo establecer conexión con la base de datos</p>");
                }
            } catch (Exception ex) {
                diagnostico.append("<p class='text-danger'>✗ Error en la consulta SQL: " + ex.getMessage() + "</p>");
                ex.printStackTrace();
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                } catch (Exception ex) {
                    // Ignorar
                }
            }
        } catch (NumberFormatException e) {
            diagnostico.append("<p class='text-danger'>✗ Error: El ID proporcionado no es un número válido</p>");
        }
    } else {
        diagnostico.append("<p class='text-danger'>✗ Error: No se proporcionó un ID de entidad</p>");
    }

    // Intentar obtener nombres de nivel de gobierno y región si tenemos la entidad
    String nivelGobiernoNombre = "No definido";
    String regionNombre = "-";

    if (entidad != null) {
        // Obtener niveles de gobierno
        NivelGobiernoModelo nivelModelo = new NivelGobiernoModelo();
        List<NivelGobiernoEntidad> niveles = nivelModelo.listar();

        // Obtener regiones
        RegionModelo regionModelo = new RegionModelo();
        List<RegionEntidad> regiones = regionModelo.listar();

        // Obtener nombre del nivel de gobierno
        if (entidad.getNivelGobiernoId() > 0) {
            for (NivelGobiernoEntidad nivel : niveles) {
                if (nivel.getId() == entidad.getNivelGobiernoId()) {
                    nivelGobiernoNombre = nivel.getNombre();
                    break;
                }
            }
        }

        // Obtener nombre de la región
        if (entidad.getRegionId() > 0) {
            for (RegionEntidad region : regiones) {
                if (region.getId() == entidad.getRegionId()) {
                    regionNombre = region.getNombre();
                    break;
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vista Directa de Entidad - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <style>
        .debug-info {
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            padding: 15px;
            margin-bottom: 20px;
        }

        .text-success {
            color: green;
            font-weight: bold;
        }

        .text-danger {
            color: red;
            font-weight: bold;
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/usuarios.jsp">
                            <i class="bi bi-people me-1"></i> Gestión de Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/admin/entidades.jsp">
                            <i class="bi bi-building me-1"></i> Entidades Públicas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/ciudadanos.jsp">
                            <i class="bi bi-person-badge me-1"></i> Ciudadanos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/presupuestos.jsp">
                            <i class="bi bi-cash-coin me-1"></i> Presupuestos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/solicitudes.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Solicitudes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/informes.jsp">
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
                <h1 class="h2">Vista Directa de Entidad</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <a href="<%= request.getContextPath() %>/admin/entidades.jsp"
                           class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-arrow-left me-1"></i> Volver
                        </a>
                    </div>
                </div>
            </div>

            <div class="alert alert-info">
                <i class="bi bi-info-circle me-2"></i> Esta es una página de vista directa que muestra los detalles de
                la entidad.
                <button class="btn btn-sm btn-outline-info float-end" onclick="toggleDiagnostico()">
                    <i class="bi bi-bug"></i> Ver diagnóstico técnico
                </button>
            </div>

            <div class="card shadow mb-4" id="diagnose-section" style="display: none;">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold">Diagnóstico de Acceso a Datos</h6>
                    <button class="btn btn-sm btn-outline-secondary" onclick="toggleDiagnostico()">
                        <i class="bi bi-x-lg"></i> Cerrar
                    </button>
                </div>
                <div class="card-body">
                    <div class="debug-info">
                        <%= diagnostico.toString() %>
                    </div>
                </div>
            </div>

            <% if (entidad != null) { %>
            <!-- Datos de la entidad -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold"><i class="bi bi-building me-2"></i>Información de la Entidad</h6>
                    <div>
                        <a href="<%= request.getContextPath() %>/admin/entidades.jsp"
                           class="btn btn-sm btn-outline-secondary me-2">
                            <i class="bi bi-arrow-left me-1"></i> Volver
                        </a>
                        <span class="badge bg-primary"><%= entidad.getTipo() %></span>
                    </div>
                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-md-8">
                            <h3><%= entidad.getNombre() %>
                            </h3>
                            <p class="text-secondary mb-1">
                                <i class="bi bi-geo-alt me-1"></i> <%= entidad.getDireccion() != null ? entidad.getDireccion() : "Sin dirección registrada" %>
                            </p>
                            <p class="mb-0">
                                <strong>Nivel de Gobierno:</strong> <%= nivelGobiernoNombre %> |
                                <strong>Región:</strong> <%= regionNombre %>
                            </p>
                        </div>
                        <div class="col-md-4 text-md-end">
                            <p class="mb-1"><strong>ID:</strong> <%= entidad.getId() %>
                            </p>
                            <div class="text-primary">
                                <% if (entidad.getSitioWeb() != null && !entidad.getSitioWeb().isEmpty()) { %>
                                <a href="<%= entidad.getSitioWeb() %>" target="_blank" class="text-decoration-none">
                                    <i class="bi bi-globe me-1"></i> Visitar sitio web
                                </a>
                                <% } else { %>
                                <span class="text-muted"><i
                                        class="bi bi-globe me-1"></i> Sin sitio web registrado</span>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <div class="row g-4 mb-4">
                        <div class="col-md-6">
                            <div class="card h-100 border-0 bg-light">
                                <div class="card-body">
                                    <h5 class="card-title">Información Gubernamental</h5>
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item bg-transparent border-0 ps-0">
                                            <strong><i class="bi bi-diagram-3 me-2"></i>ID Nivel de Gobierno:</strong>
                                            <%= entidad.getNivelGobiernoId() %> (<%= nivelGobiernoNombre %>)
                                        </li>
                                        <li class="list-group-item bg-transparent border-0 ps-0">
                                            <strong><i class="bi bi-geo me-2"></i>ID Región:</strong>
                                            <%= entidad.getRegionId() %> (<%= regionNombre %>)
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card h-100 border-0 bg-light">
                                <div class="card-body">
                                    <h5 class="card-title">Contacto</h5>
                                    <ul class="list-group list-group-flush">
                                        <% if (entidad.getTelefono() != null && !entidad.getTelefono().isEmpty()) { %>
                                        <li class="list-group-item bg-transparent border-0 ps-0">
                                            <strong><i class="bi bi-telephone me-2"></i>Teléfono:</strong>
                                            <a href="tel:<%= entidad.getTelefono() %>" class="text-decoration-none">
                                                <%= entidad.getTelefono() %>
                                            </a>
                                        </li>
                                        <% } else { %>
                                        <li class="list-group-item bg-transparent border-0 ps-0">
                                            <strong><i class="bi bi-telephone me-2"></i>Teléfono:</strong>
                                            <span class="text-muted">No registrado</span>
                                        </li>
                                        <% } %>

                                        <% if (entidad.getEmail() != null && !entidad.getEmail().isEmpty()) { %>
                                        <li class="list-group-item bg-transparent border-0 ps-0">
                                            <strong><i class="bi bi-envelope me-2"></i>Correo electrónico:</strong>
                                            <a href="mailto:<%= entidad.getEmail() %>" class="text-decoration-none">
                                                <%= entidad.getEmail() %>
                                            </a>
                                        </li>
                                        <% } else { %>
                                        <li class="list-group-item bg-transparent border-0 ps-0">
                                            <strong><i class="bi bi-envelope me-2"></i>Correo electrónico:</strong>
                                            <span class="text-muted">No registrado</span>
                                        </li>
                                        <% } %>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="mt-4">
                    <div class="d-flex justify-content-between">
                        <div class="btn-group">
                            <a href="<%= request.getContextPath() %>/admin/entidades.jsp" class="btn btn-secondary">
                                <i class="bi bi-arrow-left me-1"></i> Volver a la lista
                            </a>
                            <button type="button" class="btn btn-primary"
                                    onclick="window.location.href='<%= request.getContextPath() %>/entidades.do?accion=formEditar&id=<%= entidad.getId() %>'">
                                <i class="bi bi-pencil me-1"></i> Editar entidad
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            <% } else { %>
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> No se pudo recuperar la información de la entidad.
            </div>
            <% } %>
        </main>
    </div>
</div>

<footer class="footer py-3 mt-5 bg-light border-top">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-6 small text-muted">
                &copy; <%= java.time.Year.now().getValue() %> Portal de Transparencia Perú | Todos los derechos
                reservados
            </div>
            <div class="col-md-6 text-md-end small">
                <a href="#" class="text-decoration-none text-muted me-3">Términos de Uso</a>
                <a href="#" class="text-decoration-none text-muted me-3">Política de Privacidad</a>
                <a href="#" class="text-decoration-none text-muted">Contacto</a>
            </div>
        </div>
    </div>
</footer>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleDiagnostico() {
        var section = document.getElementById('diagnose-section');
        if (section.style.display === 'none') {
            section.style.display = 'block';
        } else {
            section.style.display = 'none';
        }
    }
</script>
</body>
</html>
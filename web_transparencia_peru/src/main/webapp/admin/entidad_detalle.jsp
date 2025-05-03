<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.EntidadPublicaModelo" %>
<%@ page import="pe.gob.transparencia.modelo.NivelGobiernoModelo" %>
<%@ page import="pe.gob.transparencia.modelo.RegionModelo" %>
<%@ page import="pe.gob.transparencia.entidades.NivelGobiernoEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.RegionEntidad" %>
<%@ page import="java.util.List" %>
<%
    // Verificar si el usuario está en sesión y es admin
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
        // No es admin o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener la entidad desde el atributo de la petición
    EntidadPublicaEntidad entidad = (EntidadPublicaEntidad) request.getAttribute("entidad");
    if (entidad == null) {
        // Si no hay entidad, redirigir a la lista
        response.sendRedirect(request.getContextPath() + "/entidades.do?accion=listar");
        return;
    }

    // Obtener niveles de gobierno
    NivelGobiernoModelo nivelModelo = new NivelGobiernoModelo();
    List<NivelGobiernoEntidad> niveles = nivelModelo.listar();

    // Obtener regiones
    RegionModelo regionModelo = new RegionModelo();
    List<RegionEntidad> regiones = regionModelo.listar();

    // Obtener nombre del nivel de gobierno
    String nivelGobiernoNombre = "No definido";
    if (entidad.getNivelGobiernoId() > 0) {
        for (NivelGobiernoEntidad nivel : niveles) {
            if (nivel.getId() == entidad.getNivelGobiernoId()) {
                nivelGobiernoNombre = nivel.getNombre();
                break;
            }
        }
    }

    // Obtener nombre de la región
    String regionNombre = "-";
    if (entidad.getRegionId() > 0) {
        for (RegionEntidad region : regiones) {
            if (region.getId() == entidad.getRegionId()) {
                regionNombre = region.getNombre();
                break;
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Entidad - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
                <h1 class="h2">Detalle de Entidad Pública</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-outline-primary" onclick="history.back()">
                            <i class="bi bi-arrow-left me-1"></i> Volver
                        </button>
                        <button type="button" class="btn btn-sm btn-primary"
                                onclick="window.location.href='<%= request.getContextPath() %>/entidades.do?accion=formEditar&id=<%= entidad.getId() %>'">
                            <i class="bi bi-pencil me-1"></i> Editar
                        </button>
                    </div>
                </div>
            </div>

            <!-- Datos de la entidad -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold"><i class="bi bi-building me-2"></i>Información de la Entidad</h6>
                    <span class="badge bg-primary"><%= entidad.getTipo() %></span>
                </div>
                <div class="card-body">
                    <div class="row mb-4">
                        <div class="col-md-8">
                            <h3><%= entidad.getNombre() %>
                            </h3>
                            <p class="text-secondary">
                                <i class="bi bi-geo-alt me-1"></i> <%= entidad.getDireccion() != null ? entidad.getDireccion() : "Sin dirección registrada" %>
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
                                            <strong><i class="bi bi-diagram-3 me-2"></i>Nivel de Gobierno:</strong>
                                            <%= nivelGobiernoNombre %>
                                        </li>
                                        <li class="list-group-item bg-transparent border-0 ps-0">
                                            <strong><i class="bi bi-geo me-2"></i>Región:</strong>
                                            <%= regionNombre %>
                                        </li>
                                        <% if (entidad.getRuc() != null && !entidad.getRuc().isEmpty()) { %>
                                        <li class="list-group-item bg-transparent border-0 ps-0">
                                            <strong><i class="bi bi-card-text me-2"></i>RUC:</strong>
                                            <%= entidad.getRuc() %>
                                        </li>
                                        <% } %>
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

                    <div class="mt-4">
                        <h5>Acciones</h5>
                        <div class="btn-group">
                            <button type="button" class="btn btn-outline-primary"
                                    onclick="window.location.href='<%= request.getContextPath() %>/entidades.do?accion=formEditar&id=<%= entidad.getId() %>'">
                                <i class="bi bi-pencil me-1"></i> Editar
                            </button>
                            <button type="button" class="btn btn-outline-danger"
                                    onclick="confirmarEliminacion(<%= entidad.getId() %>, '<%= entidad.getNombre().replace("'", "\\'") %>')">
                                <i class="bi bi-trash me-1"></i> Eliminar
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Presupuestos asociados (si los hubiera) -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold"><i class="bi bi-cash-coin me-2"></i>Presupuestos Asignados</h6>
                </div>
                <div class="card-body">
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i>
                        Esta sección mostrará los presupuestos asociados a esta entidad.
                        Actualmente no hay presupuestos registrados.
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal Confirmar Eliminación -->
<div class="modal fade" id="eliminarEntidadModal" tabindex="-1" aria-labelledby="eliminarEntidadModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarEntidadModalLabel"><i class="bi bi-exclamation-triangle me-2"></i>Confirmar
                    Eliminación</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro que desea eliminar la entidad <strong id="nombreEntidadEliminar"></strong>?</p>
                <p>Esta acción no se puede deshacer y podría afectar a presupuestos, solicitudes y otros datos
                    relacionados.</p>
            </div>
            <div class="modal-footer">
                <form action="<%= request.getContextPath() %>/entidades.do" method="post">
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" name="id" id="idEntidadEliminar">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </form>
            </div>
        </div>
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
    function confirmarEliminacion(id, nombre) {
        document.getElementById('idEntidadEliminar').value = id;
        document.getElementById('nombreEntidadEliminar').textContent = nombre;

        var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarEntidadModal'));
        eliminarModal.show();
    }
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.EntidadPublicaModelo" %>
<%
    // Verificar si el usuario está en sesión y es admin
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
        // No es admin o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener la entidad a mostrar
    EntidadPublicaEntidad entidad = (EntidadPublicaEntidad) request.getAttribute("entidad");
    if (entidad == null) {
        response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        return;
    }

    // Obtener modelo para obtener nombres de referencias
    EntidadPublicaModelo modelo = new EntidadPublicaModelo();

    // Obtener nombres descriptivos
    String nivelGobierno = "";
    switch (entidad.getNivelGobiernoId()) {
        case 1:
            nivelGobierno = "Nacional";
            break;
        case 2:
            nivelGobierno = "Regional";
            break;
        case 3:
            nivelGobierno = "Municipal";
            break;
        default:
            nivelGobierno = "No definido";
    }

    String nombreRegion = "-";
    if (entidad.getRegionId() != 0) {
        nombreRegion = modelo.obtenerNombreRegion(entidad.getRegionId());
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
                        <a class="nav-link" href="index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios">
                            <i class="bi bi-people me-1"></i> Gestión de Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="entidades.jsp">
                            <i class="bi bi-building me-1"></i> Entidades Públicas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ciudadanos.jsp">
                            <i class="bi bi-person-badge me-1"></i> Ciudadanos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="presupuestos.jsp">
                            <i class="bi bi-cash-coin me-1"></i> Presupuestos
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="solicitudes.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Solicitudes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="informes.jsp">
                            <i class="bi bi-graph-up me-1"></i> Informes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="configuracion.jsp">
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
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <a href="<%= request.getContextPath() %>/admin.do?accion=editarEntidad&id=<%= entidad.getId() %>"
                           class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-pencil me-1"></i> Editar
                        </a>
                        <button type="button" class="btn btn-sm btn-outline-danger"
                                onclick="confirmarEliminacion(<%= entidad.getId() %>, '<%= entidad.getNombre() %>')">
                            <i class="bi bi-trash me-1"></i> Eliminar
                        </button>
                    </div>
                    <a href="<%= request.getContextPath() %>/admin/entidades.jsp"
                       class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Volver
                    </a>
                </div>
            </div>

            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card shadow fade-in">
                        <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                            <h6 class="m-0 font-weight-bold">Información General</h6>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-4">
                                <div class="display-1 text-primary mb-3">
                                    <i class="bi bi-building"></i>
                                </div>
                                <h4><%= entidad.getNombre() %>
                                </h4>
                                <p class="text-muted"><%= entidad.getTipo() %>
                                </p>
                                <p><span class="badge bg-primary"><i
                                        class="bi bi-activity me-1"></i> <%= nivelGobierno %></span></p>
                                <% if (entidad.getSitioWeb() != null && !entidad.getSitioWeb().isEmpty()) { %>
                                <a href="<%= entidad.getSitioWeb() %>" class="btn btn-sm btn-outline-primary"
                                   target="_blank">
                                    <i class="bi bi-globe me-1"></i> Visitar Sitio Web
                                </a>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-8 mb-4">
                    <div class="card shadow fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Datos Generales</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-borderless">
                                    <tbody>
                                    <tr>
                                        <th style="width: 30%">ID:</th>
                                        <td><%= entidad.getId() %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Nombre:</th>
                                        <td><%= entidad.getNombre() %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Tipo:</th>
                                        <td><%= entidad.getTipo() %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Nivel de Gobierno:</th>
                                        <td><%= nivelGobierno %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Región:</th>
                                        <td><%= nombreRegion %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Dirección:</th>
                                        <td><%= entidad.getDireccion() != null ? entidad.getDireccion() : "No especificada" %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Teléfono:</th>
                                        <td><%= entidad.getTelefono() != null ? entidad.getTelefono() : "No especificado" %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Correo Electrónico:</th>
                                        <td>
                                            <% if (entidad.getEmail() != null && !entidad.getEmail().isEmpty()) { %>
                                            <a href="mailto:<%= entidad.getEmail() %>"><%= entidad.getEmail() %>
                                            </a>
                                            <% } else { %>
                                            No especificado
                                            <% } %>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Sitio Web:</th>
                                        <td>
                                            <% if (entidad.getSitioWeb() != null && !entidad.getSitioWeb().isEmpty()) { %>
                                            <a href="<%= entidad.getSitioWeb() %>"
                                               target="_blank"><%= entidad.getSitioWeb() %>
                                            </a>
                                            <% } else { %>
                                            No especificado
                                            <% } %>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Sección de presupuestos asignados -->
                    <div class="card shadow mt-4 fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Presupuestos Asignados</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered" id="tablaPresupuestos">
                                    <thead>
                                    <tr>
                                        <th>Año</th>
                                        <th>Presupuesto</th>
                                        <th>Ejecución</th>
                                        <th>% Avance</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>2023</td>
                                        <td>S/. 12,450,000.00</td>
                                        <td>S/. 10,235,850.80</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="progress flex-grow-1 me-2" style="height: 10px;">
                                                    <div class="progress-bar bg-success" role="progressbar"
                                                         style="width: 82%" aria-valuenow="82" aria-valuemin="0"
                                                         aria-valuemax="100"></div>
                                                </div>
                                                <span>82%</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2022</td>
                                        <td>S/. 10,823,600.00</td>
                                        <td>S/. 9,782,450.15</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="progress flex-grow-1 me-2" style="height: 10px;">
                                                    <div class="progress-bar bg-success" role="progressbar"
                                                         style="width: 90%" aria-valuenow="90" aria-valuemin="0"
                                                         aria-valuemax="100"></div>
                                                </div>
                                                <span>90%</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2021</td>
                                        <td>S/. 9,345,800.00</td>
                                        <td>S/. 8,732,456.42</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="progress flex-grow-1 me-2" style="height: 10px;">
                                                    <div class="progress-bar bg-success" role="progressbar"
                                                         style="width: 93%" aria-valuenow="93" aria-valuemin="0"
                                                         aria-valuemax="100"></div>
                                                </div>
                                                <span>93%</span>
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
                <p>Esta acción no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <form action="<%= request.getContextPath() %>/admin.do" method="post">
                    <input type="hidden" name="accion" value="eliminarEntidad">
                    <input type="hidden" name="id" id="idEntidadEliminar">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>

<script>
    $(document).ready(function () {
        // Inicializar DataTables
        $('#tablaPresupuestos').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            paging: false,
            info: false,
            searching: false,
            ordering: false
        });
    });

    // Función para confirmar eliminación
    function confirmarEliminacion(id, nombre) {
        document.getElementById('idEntidadEliminar').value = id;
        document.getElementById('nombreEntidadEliminar').textContent = nombre;

        var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarEntidadModal'));
        eliminarModal.show();
    }
</script>
<style>
    /* Estilos para las tarjetas */
    .card {
        border: none;
        border-radius: 0.5rem;
    }

    .card-header {
        background-color: #f8f9fa;
        border-bottom: 1px solid #e3e6f0;
    }

    .font-weight-bold {
        font-weight: 600;
    }

    /* Estilo para las barras de progreso */
    .progress {
        border-radius: 0.25rem;
        background-color: #e9ecef;
    }
</style>
</body>
</html>
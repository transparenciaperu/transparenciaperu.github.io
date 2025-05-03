<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%
    // Verificar si el usuario está en sesión y es admin
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
        // No es admin o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener el usuario a mostrar
    UsuarioEntidad usuarioDetalle = (UsuarioEntidad) request.getAttribute("usuario");
    if (usuarioDetalle == null) {
        // Si no hay usuario a mostrar, redirigir a la lista
        response.sendRedirect(request.getContextPath() + "/admin.do?accion=listarUsuarios");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalle de Usuario - Portal de Transparencia Perú</title>
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
                        <a class="nav-link active"
                           href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios">
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
                <h1 class="h2">Detalle de Usuario</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <div class="btn-group me-2">
                        <a href="<%= request.getContextPath() %>/admin.do?accion=editarUsuario&id=<%= usuarioDetalle.getId() %>"
                           class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-pencil me-1"></i> Editar
                        </a>
                        <button type="button" class="btn btn-sm btn-outline-danger" data-bs-toggle="modal"
                                data-bs-target="#eliminarUsuarioModal">
                            <i class="bi bi-trash me-1"></i> Eliminar
                        </button>
                    </div>
                    <a href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios"
                       class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Volver
                    </a>
                </div>
            </div>

            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Información del Usuario</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <table class="table table-borderless">
                                <tr>
                                    <th width="30%">ID:</th>
                                    <td><%= usuarioDetalle.getId() %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Usuario:</th>
                                    <td><%= usuarioDetalle.getUsuario() %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Nombre Completo:</th>
                                    <td><%= usuarioDetalle.getNombreCompleto() %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Correo:</th>
                                    <td><%= usuarioDetalle.getCorreo() %>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <div class="col-md-6">
                            <table class="table table-borderless">
                                <tr>
                                    <th width="30%">Rol:</th>
                                    <td>
                                        <% if (usuarioDetalle.getCodRol().equals("ADMIN")) { %>
                                        <span class="badge bg-danger">Administrador</span>
                                        <% } else if (usuarioDetalle.getCodRol().equals("FUNCIONARIO")) { %>
                                        <span class="badge bg-primary">Funcionario</span>
                                        <% } else { %>
                                        <span class="badge bg-secondary"><%= usuarioDetalle.getCodRol() %></span>
                                        <% } %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Estado:</th>
                                    <td>
                                        <% if (usuarioDetalle.getActivo()) { %>
                                        <span class="badge bg-success">Activo</span>
                                        <% } else { %>
                                        <span class="badge bg-secondary">Inactivo</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Última Conexión:</th>
                                    <td>
                                        <span class="text-muted">No disponible</span>
                                    </td>
                                </tr>
                                <tr>
                                    <th>Fecha de Registro:</th>
                                    <td>
                                        <span class="text-muted">No disponible</span>
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>

                    <div class="card mt-4">
                        <div class="card-header">
                            <h6 class="mb-0">Últimas Actividades</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Fecha</th>
                                        <th>Acción</th>
                                        <th>Detalles</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>2024-05-01 09:35:12</td>
                                        <td>Inicio de sesión</td>
                                        <td>Acceso desde IP: 192.168.1.10</td>
                                    </tr>
                                    <tr>
                                        <td>2024-04-30 16:22:45</td>
                                        <td>Actualización de información</td>
                                        <td>Se actualizó la información de entidad "Ministerio de Economía y Finanzas"
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>2024-04-29 11:05:30</td>
                                        <td>Inicio de sesión</td>
                                        <td>Acceso desde IP: 192.168.1.10</td>
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
<div class="modal fade" id="eliminarUsuarioModal" tabindex="-1" aria-labelledby="eliminarUsuarioModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarUsuarioModalLabel"><i class="bi bi-exclamation-triangle me-2"></i>Confirmar
                    Eliminación</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro que desea eliminar al usuario <strong><%= usuarioDetalle.getNombreCompleto() %>
                </strong>?</p>
                <p>Esta acción no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <form action="<%= request.getContextPath() %>/admin.do" method="post">
                    <input type="hidden" name="accion" value="eliminarUsuario">
                    <input type="hidden" name="id" value="<%= usuarioDetalle.getId() %>">
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

</body>
</html>
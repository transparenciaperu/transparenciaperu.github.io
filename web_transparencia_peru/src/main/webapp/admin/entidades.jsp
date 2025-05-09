<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.EntidadPublicaModelo" %>
<%@ page import="pe.gob.transparencia.modelo.NivelGobiernoModelo" %>
<%@ page import="pe.gob.transparencia.modelo.RegionModelo" %>
<%@ page import="pe.gob.transparencia.entidades.NivelGobiernoEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.RegionEntidad" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // Verificar si el usuario está en sesión y es admin
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
        // No es admin o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener mensaje de confirmación (si existe)
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");

    // Limpiar mensajes de sesión después de obtenerlos
    if (mensaje != null) {
        session.removeAttribute("mensaje");
        session.removeAttribute("tipoMensaje");
    }

    // Obtener lista de entidades desde el modelo
    EntidadPublicaModelo modelo = new EntidadPublicaModelo();
    List<EntidadPublicaEntidad> listaEntidades = modelo.listarEntidades();

    // Obtener niveles de gobierno para el formulario
    NivelGobiernoModelo nivelModelo = new NivelGobiernoModelo();
    List<NivelGobiernoEntidad> niveles = nivelModelo.listar();

    // Obtener regiones para el formulario
    RegionModelo regionModelo = new RegionModelo();
    List<RegionEntidad> regiones = regionModelo.listar();

    // Verificar si hay entidades
    if (listaEntidades == null) {
        listaEntidades = new ArrayList<>();
        System.out.println("No se encontraron entidades públicas en la base de datos.");
    } else {
        System.out.println("Se encontraron " + listaEntidades.size() + " entidades públicas.");
        for (EntidadPublicaEntidad e : listaEntidades) {
            System.out.println("Entidad #" + e.getId() + ": " + e.getNombre() + ", Nivel: " + e.getNivelGobiernoId());
        }
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Entidades Públicas - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
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
                        <a class="nav-link active" href="#">
                            <i class="bi bi-building me-1"></i> Entidades Públicas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ciudadanos.jsp">
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
                <h1 class="h2">Gestión de Entidades Públicas</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                data-bs-target="#nuevaEntidadModal">
                            <i class="bi bi-building-add me-1"></i> Nueva Entidad
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="tooltip"
                                data-bs-placement="bottom" title="Exportar entidades">
                            <i class="bi bi-file-earmark-excel me-1"></i> Exportar
                        </button>
                    </div>
                </div>
            </div>

            <% if (mensaje != null) { %>
            <div class="alert alert-<%= tipoMensaje != null ? tipoMensaje : "info" %> fade-in" role="alert">
                <i class="bi bi-info-circle me-2"></i> <%= mensaje %>
            </div>
            <% } %>

            <!-- Filtros -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Filtros</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label for="filtroNivel" class="form-label">Nivel de Gobierno</label>
                            <select class="form-select" id="filtroNivel">
                                <option value="">Todos</option>
                                <% for (NivelGobiernoEntidad nivel : niveles) { %>
                                <option value="<%= nivel.getId() %>"><%= nivel.getNombre() %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="filtroRegion" class="form-label">Región</label>
                            <select class="form-select" id="filtroRegion">
                                <option value="">Todas</option>
                                <% for (RegionEntidad region : regiones) { %>
                                <option value="<%= region.getId() %>"><%= region.getNombre() %>
                                </option>
                                <% } %>
                                <option value="0">Nacional</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="filtroTipo" class="form-label">Tipo</label>
                            <select class="form-select" id="filtroTipo">
                                <option value="">Todos</option>
                                <option value="Ministerio">Ministerio</option>
                                <option value="Gobierno Regional">Gobierno Regional</option>
                                <option value="Municipalidad Provincial">Municipalidad Provincial</option>
                                <option value="Municipalidad Distrital">Municipalidad Distrital</option>
                                <option value="Organismo Supervisor">Organismo Supervisor</option>
                            </select>
                        </div>
                    </div>
                    <div class="text-end">
                        <button type="button" class="btn btn-primary" id="btnAplicarFiltros">
                            <i class="bi bi-funnel me-1"></i> Aplicar Filtros
                        </button>
                        <button type="button" class="btn btn-secondary" id="btnLimpiarFiltros">
                            <i class="bi bi-x-circle me-1"></i> Limpiar Filtros
                        </button>
                    </div>
                </div>
            </div>

            <!-- Tabla de Entidades -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Listado de Entidades Públicas</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="tablaEntidades" width="100%" cellspacing="0">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Tipo</th>
                                <th>Nivel de Gobierno</th>
                                <th>Región</th>
                                <th>Contacto</th>
                                <th>Acciones</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if (listaEntidades != null && !listaEntidades.isEmpty()) { %>
                            <% for (EntidadPublicaEntidad entidad : listaEntidades) { %>
                            <tr>
                                <td><%= entidad.getId() %>
                                </td>
                                <td><%= entidad.getNombre() != null ? entidad.getNombre() : "" %>
                                </td>
                                <td><%= entidad.getTipo() != null ? entidad.getTipo() : "" %>
                                </td>
                                <td>
                                    <%
                                        String nivelGobierno = "No definido";
                                        if (entidad.getNivelGobiernoId() > 0) {
                                            for (NivelGobiernoEntidad nivel : niveles) {
                                                if (nivel.getId() == entidad.getNivelGobiernoId()) {
                                                    nivelGobierno = nivel.getNombre();
                                                    break;
                                                }
                                            }
                                        }
                                    %>
                                    <%= nivelGobierno %>
                                </td>
                                <td>
                                    <%
                                        String nombreRegion = "-";
                                        if (entidad.getRegionId() > 0) {
                                            for (RegionEntidad region : regiones) {
                                                if (region.getId() == entidad.getRegionId()) {
                                                    nombreRegion = region.getNombre();
                                                    break;
                                                }
                                            }
                                        }
                                    %>
                                    <%= nombreRegion %>
                                </td>
                                <td>
                                    <small>
                                        <%= entidad.getEmail() != null ? entidad.getEmail() : "" %><br>
                                        <%= entidad.getTelefono() != null ? entidad.getTelefono() : "" %>
                                    </small>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <button type="button" class="btn btn-outline-primary" data-bs-toggle="tooltip"
                                                title="Editar"
                                                onclick="editarEntidad({
                                                        id: <%= entidad.getId() %>,
                                                        nombre: '<%= entidad.getNombre() != null ? entidad.getNombre().replace("'", "\\'") : "" %>',
                                                        tipo: '<%= entidad.getTipo() != null ? entidad.getTipo().replace("'", "\\'") : "" %>',
                                                        direccion: '<%= entidad.getDireccion() != null ? entidad.getDireccion().replace("'", "\\'") : "" %>',
                                                        nivelGobiernoId: <%= entidad.getNivelGobiernoId() %>,
                                                        regionId: <%= entidad.getRegionId() %>,
                                                        telefono: '<%= entidad.getTelefono() != null ? entidad.getTelefono().replace("'", "\\'") : "" %>',
                                                        email: '<%= entidad.getEmail() != null ? entidad.getEmail().replace("'", "\\'") : "" %>',
                                                        sitioWeb: '<%= entidad.getSitioWeb() != null ? entidad.getSitioWeb().replace("'", "\\'") : "" %>'
                                                        })">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="tooltip"
                                                title="Eliminar"
                                                onclick="confirmarEliminacion(<%= entidad.getId() %>, '<%= entidad.getNombre() != null ? entidad.getNombre().replace("'", "\\'") : "" %>')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                        <a href="<%= request.getContextPath() %>/admin/entidad_directa.jsp?id=<%= entidad.getId() %>"
                                           class="btn btn-outline-info" data-bs-toggle="tooltip" title="Ver detalle">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                            <% } else { %>
                            <tr>
                                <td colspan="7" class="text-center">No hay entidades públicas registradas</td>
                            </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Modal Nueva Entidad -->
<div class="modal fade" id="nuevaEntidadModal" tabindex="-1" aria-labelledby="nuevaEntidadModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="nuevaEntidadModalLabel"><i class="bi bi-building-add me-2"></i>Nueva Entidad
                    Pública</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/entidades.do" method="post" id="formNuevaEntidad"
                  onsubmit="return validarFormulario(this)">
                <input type="hidden" name="accion" value="registrar">
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-8">
                            <label for="nombre" class="form-label">Nombre de Entidad <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="nombre" name="nombre" required>
                            <div class="invalid-feedback">El nombre de la entidad es obligatorio</div>
                        </div>
                        <div class="col-md-4">
                            <label for="tipo" class="form-label">Tipo <span class="text-danger">*</span></label>
                            <select class="form-select" id="tipo" name="tipo" required>
                                <option value="">Seleccione tipo</option>
                                <option value="Ministerio">Ministerio</option>
                                <option value="Gobierno Regional">Gobierno Regional</option>
                                <option value="Municipalidad Provincial">Municipalidad Provincial</option>
                                <option value="Municipalidad Distrital">Municipalidad Distrital</option>
                                <option value="Organismo Supervisor">Organismo Supervisor</option>
                                <option value="Otro">Otro</option>
                            </select>
                            <div class="invalid-feedback">Debe seleccionar un tipo de entidad</div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="nivelGobiernoId" class="form-label">Nivel de Gobierno <span class="text-danger">*</span></label>
                            <select class="form-select" id="nivelGobiernoId" name="nivelGobiernoId" required
                                    onchange="mostrarOcultarRegion('nivelGobiernoId')">
                                <option value="">Seleccione nivel</option>
                                <% for (NivelGobiernoEntidad nivel : niveles) { %>
                                <option value="<%= nivel.getId() %>"><%= nivel.getNombre() %>
                                </option>
                                <% } %>
                            </select>
                            <div class="invalid-feedback">Debe seleccionar un nivel de gobierno</div>
                        </div>
                        <div class="col-md-6" id="div-region" style="display:none;">
                            <label for="regionId" class="form-label">Región <span class="text-danger">*</span></label>
                            <select class="form-select" id="regionId" name="regionId" required>
                                <option value="">Seleccione región</option>
                                <% for (RegionEntidad region : regiones) { %>
                                <option value="<%= region.getId() %>"><%= region.getNombre() %>
                                </option>
                                <% } %>
                                <option value="0">Nacional</option>
                            </select>
                            <div class="invalid-feedback">Debe seleccionar una región</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="direccion" class="form-label">Dirección</label>
                        <input type="text" class="form-control" id="direccion" name="direccion">
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="telefono" class="form-label">Teléfono</label>
                            <input type="text" class="form-control" id="telefono" name="telefono">
                        </div>
                        <div class="col-md-6">
                            <label for="email" class="form-label">Correo Electrónico</label>
                            <input type="email" class="form-control" id="email" name="email">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="sitioWeb" class="form-label">Sitio Web</label>
                        <input type="text" class="form-control" id="sitioWeb" name="sitioWeb" placeholder="https://">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Guardar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Editar Entidad -->
<div class="modal fade" id="editarEntidadModal" tabindex="-1" aria-labelledby="editarEntidadModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="editarEntidadModalLabel"><i class="bi bi-pencil-square me-2"></i>Editar
                    Entidad
                    Pública</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/entidades.do" method="post" id="formEditarEntidad">
                <input type="hidden" name="accion" value="actualizar">
                <input type="hidden" name="id" id="editId">
                <div class="modal-body">
                    <div id="alertaEditar"></div>

                    <div class="row mb-3">
                        <div class="col-md-8">
                            <label for="editNombre" class="form-label">Nombre de Entidad <span
                                    class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="editNombre" name="nombre" required>
                            <div class="invalid-feedback">El nombre de la entidad es obligatorio</div>
                        </div>
                        <div class="col-md-4">
                            <label for="editTipo" class="form-label">Tipo <span class="text-danger">*</span></label>
                            <select class="form-select" id="editTipo" name="tipo" required>
                                <option value="">Seleccione tipo</option>
                                <option value="Ministerio">Ministerio</option>
                                <option value="Gobierno Regional">Gobierno Regional</option>
                                <option value="Municipalidad Provincial">Municipalidad Provincial</option>
                                <option value="Municipalidad Distrital">Municipalidad Distrital</option>
                                <option value="Organismo Supervisor">Organismo Supervisor</option>
                                <option value="Otro">Otro</option>
                            </select>
                            <div class="invalid-feedback">Debe seleccionar un tipo de entidad</div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="editNivelGobiernoId" class="form-label">Nivel de Gobierno <span
                                    class="text-danger">*</span></label>
                            <select class="form-select" id="editNivelGobiernoId" name="nivelGobiernoId" required
                                    onchange="mostrarOcultarRegion('editNivelGobiernoId')">
                                <option value="">Seleccione nivel</option>
                                <% for (NivelGobiernoEntidad nivel : niveles) { %>
                                <option value="<%= nivel.getId() %>"><%= nivel.getNombre() %>
                                </option>
                                <% } %>
                            </select>
                            <div class="invalid-feedback">Debe seleccionar un nivel de gobierno</div>
                        </div>
                        <div class="col-md-6" id="editdiv-region">
                            <label for="editRegionId" class="form-label">Región <span
                                    class="text-danger">*</span></label>
                            <select class="form-select" id="editRegionId" name="regionId" required>
                                <option value="">Seleccione región</option>
                                <% for (RegionEntidad region : regiones) { %>
                                <option value="<%= region.getId() %>"><%= region.getNombre() %>
                                </option>
                                <% } %>
                                <option value="0">Nacional</option>
                            </select>
                            <div class="invalid-feedback">Debe seleccionar una región</div>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="editDireccion" class="form-label">Dirección</label>
                        <input type="text" class="form-control" id="editDireccion" name="direccion">
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="editTelefono" class="form-label">Teléfono</label>
                            <input type="text" class="form-control" id="editTelefono" name="telefono">
                        </div>
                        <div class="col-md-6">
                            <label for="editEmail" class="form-label">Correo Electrónico</label>
                            <input type="email" class="form-control" id="editEmail" name="email">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="editSitioWeb" class="form-label">Sitio Web</label>
                        <input type="text" class="form-control" id="editSitioWeb" name="sitioWeb"
                               placeholder="https://">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Actualizar</button>
                </div>
            </form>
        </div>
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
                <p>Esta acción no se puede deshacer. Si la entidad está siendo utilizada en presupuestos,
                    solicitudes u otros registros, no se podrá eliminar.</p>
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

<!-- Modal de Alertas -->
<div class="modal fade" id="modalAlerta" tabindex="-1" aria-labelledby="modalAlertaLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-warning">
                <h5 class="modal-title" id="modalAlertaLabel"><i class="bi bi-exclamation-triangle-fill me-2"></i>Atención
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="modalAlertaBody">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">Entendido</button>
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
        var tabla = $('#tablaEntidades').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            pageLength: 10,
            responsive: true,
            order: [[0, 'asc']]
        });

        // Inicializar tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Filtros personalizados
        $('#btnAplicarFiltros').click(function () {
            var nivelFiltro = $('#filtroNivel').val();
            var regionFiltro = $('#filtroRegion').val();
            var tipoFiltro = $('#filtroTipo').val();

            // Obtener texto seleccionado para comparaciones
            var nivelTexto = nivelFiltro ? $('#filtroNivel option:selected').text().trim() : '';
            var regionTexto = regionFiltro ? $('#filtroRegion option:selected').text().trim() : '';

            // Limpiar filtros previos
            $.fn.dataTable.ext.search.pop();

            $.fn.dataTable.ext.search.push(
                function (settings, data, dataIndex) {
                    var nivelData = data[3].trim(); // Índice de la columna Nivel de Gobierno
                    var regionData = data[4].trim(); // Índice de la columna Región
                    var tipoData = data[2].trim();   // Índice de la columna Tipo

                    // Verificar coincidencia exacta o sin filtro
                    var nivelOK = nivelFiltro === '' || nivelData === nivelTexto;
                    var regionOK = regionFiltro === '' || regionData === regionTexto;
                    var tipoOK = tipoFiltro === '' || tipoData === tipoFiltro;

                    return nivelOK && regionOK && tipoOK;
                }
            );

            tabla.draw();
        });

        $('#btnLimpiarFiltros').click(function () {
            // Resetear valores de filtros
            $('#filtroNivel').val('');
            $('#filtroRegion').val('');
            $('#filtroTipo').val('');

            // Limpiar cualquier filtro personalizado
            $.fn.dataTable.ext.search.pop();

            // Restablecer la tabla a su estado original
            tabla.search('').columns().search('').draw();
        });
    });

    function mostrarOcultarRegion(idSelect) {
        var nivelGobierno = document.getElementById(idSelect).value;
        var divRegion = document.getElementById(idSelect === 'nivelGobiernoId' ? 'div-region' : 'editdiv-region');
        var selectRegion = document.getElementById(idSelect === 'nivelGobiernoId' ? 'regionId' : 'editRegionId');
        var regionRequired = document.querySelector(idSelect === 'nivelGobiernoId' ? '.region-required' : '.edit-region-required');

        if (nivelGobierno === '1') { // Nacional
            // Para nivel nacional, permitimos seleccionar cualquier región
            divRegion.style.display = 'block'; // Mantener visible
            selectRegion.disabled = false; // Permitir cambiar
            selectRegion.required = false; // No es obligatorio para nivel nacional

            if (regionRequired) regionRequired.innerHTML = '';
            console.log("Nivel nacional seleccionado. Se permite seleccionar cualquier región.");
        } else { // Regional o Municipal
            divRegion.style.display = 'block';
            selectRegion.disabled = false; // Habilitar para permitir selección
            selectRegion.required = true;
            if (regionRequired) regionRequired.innerHTML = '<span class="text-danger">*</span>';
            console.log("Nivel NO nacional seleccionado. Se requiere seleccionar una región.");
        }
    }

    // Función para confirmar eliminación
    function confirmarEliminacion(id, nombre) {
        document.getElementById('idEntidadEliminar').value = id;
        document.getElementById('nombreEntidadEliminar').textContent = nombre;

        var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarEntidadModal'));
        eliminarModal.show();
    }

    function editarEntidad(entidad) {
        console.log("Datos de entidad a editar:", entidad);
        document.getElementById('editId').value = entidad.id;
        document.getElementById('editNombre').value = entidad.nombre;
        document.getElementById('editTipo').value = entidad.tipo;
        document.getElementById('editDireccion').value = entidad.direccion;
        document.getElementById('editNivelGobiernoId').value = entidad.nivelGobiernoId;
        document.getElementById('editRegionId').value = entidad.regionId;
        document.getElementById('editTelefono').value = entidad.telefono;
        document.getElementById('editEmail').value = entidad.email;
        document.getElementById('editSitioWeb').value = entidad.sitioWeb;

        // Verificar si se mostró correctamente la región para depuración
        console.log("ID de región establecido en formulario de edición: " + entidad.regionId);
        console.log("Valor actual del select de región: " + document.getElementById('editRegionId').value);

        // Asegurar que la región se seleccione correctamente
        var regionSelect = document.getElementById('editRegionId');
        var regionEncontrada = false;

        // Buscar si existe la opción con el valor de la región
        for (var i = 0; i < regionSelect.options.length; i++) {
            if (regionSelect.options[i].value == entidad.regionId) {
                regionSelect.selectedIndex = i;
                regionEncontrada = true;
                console.log("Región encontrada en la posición " + i);
                break;
            }
        }

        if (!regionEncontrada) {
            console.log("ADVERTENCIA: No se encontró la opción para la región ID " + entidad.regionId);
        }

        // Llamar a mostrarOcultarRegion para ajustar la visibilidad y requerimiento de la región según el nivel de gobierno seleccionado
        mostrarOcultarRegion('editNivelGobiernoId');

        var editarModal = new bootstrap.Modal(document.getElementById('editarEntidadModal'));
        editarModal.show();
    }

    // Función para validar el formulario antes de enviar
    function validarFormulario(form) {
        console.log("Validando formulario...");

        // Habilitar campos deshabilitados para que sus valores sean enviados
        var camposDeshabilitados = form.querySelectorAll('select:disabled');
        camposDeshabilitados.forEach(function (campo) {
            campo.disabled = false;
        });

        // Resetear validaciones previas
        var campos = form.querySelectorAll('.form-control, .form-select');
        campos.forEach(function (campo) {
            campo.classList.remove('is-invalid');
        });

        // Obtener valores de los campos
        var nombre = form.nombre.value.trim();
        var tipo = form.tipo.value;
        var nivelGobiernoId = form.nivelGobiernoId.value;
        var regionId = form.regionId.value;

        // Si es nivel nacional, aseguramos que regionId tenga un valor por defecto
        if (nivelGobiernoId === "1") {
            form.regionId.value = "0"; // Asignamos 0 como valor por defecto para nivel Nacional
            regionId = "0";
            console.log("Validación: Nivel Nacional detectado, forzando regionId=0");
        }

        console.log("Datos del formulario:", {
            nombre: nombre,
            tipo: tipo,
            nivelGobiernoId: nivelGobiernoId,
            regionId: regionId,
            direccion: form.direccion.value,
            telefono: form.telefono.value,
            email: form.email.value,
            sitioWeb: form.sitioWeb.value
        });

        var errores = [];

        // Validaciones básicas
        if (nombre === "") {
            form.nombre.classList.add('is-invalid');
            errores.push("El nombre de la entidad es obligatorio");
        }

        if (tipo === "") {
            form.tipo.classList.add('is-invalid');
            errores.push("Debe seleccionar un tipo de entidad");
        }

        if (nivelGobiernoId === "") {
            form.nivelGobiernoId.classList.add('is-invalid');
            errores.push("Debe seleccionar un nivel de gobierno");
        }

        // Si no es nivel nacional (id=1), la región es obligatoria
        if (nivelGobiernoId !== "1" && regionId === "") {
            form.regionId.classList.add('is-invalid');
            errores.push("Debe seleccionar una región para este nivel de gobierno");
        }

        // Si hay errores, mostrarlos y detener el envío
        if (errores.length > 0) {
            var mensajeError = "Por favor corrija los siguientes errores:<br><ul>";
            errores.forEach(function (error) {
                mensajeError += "<li>" + error + "</li>";
            });
            mensajeError += "</ul>";

            mostrarAlerta(mensajeError);
            return false;
        }

        return true;
    }

    // Función para mostrar alerta con mensaje personalizado
    function mostrarAlerta(mensaje) {
        document.getElementById('modalAlertaBody').innerHTML = mensaje;
        var modal = new bootstrap.Modal(document.getElementById('modalAlerta'));
        modal.show();
    }

    // Inicializar validación en cambio de campos
    document.addEventListener('DOMContentLoaded', function () {
        var formNuevaEntidad = document.getElementById('formNuevaEntidad');
        var formEditarEntidad = document.getElementById('formEditarEntidad');

        // Configuración inicial de la región según el nivel de gobierno
        var nivelGobiernoSelect = document.getElementById('nivelGobiernoId');
        if (nivelGobiernoSelect) {
            // Ejecutar mostrarOcultarRegion al inicio por si hay un valor predeterminado
            mostrarOcultarRegion('nivelGobiernoId');

            // Y también al cambiar
            nivelGobiernoSelect.addEventListener('change', function () {
                console.log("Nivel de gobierno cambiado a: " + this.value);
                mostrarOcultarRegion('nivelGobiernoId');
            });
        }

        // Lo mismo para el formulario de edición
        var editNivelGobiernoSelect = document.getElementById('editNivelGobiernoId');
        if (editNivelGobiernoSelect) {
            mostrarOcultarRegion('editNivelGobiernoId');

            editNivelGobiernoSelect.addEventListener('change', function () {
                console.log("Nivel de gobierno (edición) cambiado a: " + this.value);
                mostrarOcultarRegion('editNivelGobiernoId');
            });
        }

        // Añadir validación en tiempo real para nueva entidad
        if (formNuevaEntidad) {
            var campos = formNuevaEntidad.querySelectorAll('.form-control, .form-select');
            campos.forEach(function (campo) {
                campo.addEventListener('change', function () {
                    if (this.value.trim() === '') {
                        this.classList.add('is-invalid');
                    } else {
                        this.classList.remove('is-invalid');
                    }
                });
            });
        }

        // Añadir validación en tiempo real para editar entidad
        if (formEditarEntidad) {
            var camposEdit = formEditarEntidad.querySelectorAll('.form-control, .form-select');
            camposEdit.forEach(function (campo) {
                campo.addEventListener('change', function () {
                    if (this.value.trim() === '') {
                        this.classList.add('is-invalid');
                    } else {
                        this.classList.remove('is-invalid');
                    }
                });
            });

            // Añadir evento de envío para habilitar campos deshabilitados
            formEditarEntidad.addEventListener('submit', function () {
                var camposDeshabilitados = this.querySelectorAll('select:disabled');
                camposDeshabilitados.forEach(function (campo) {
                    campo.disabled = false;
                });
                return true;
            });
        }
    });

    // Debug function
    function debug() {
        console.log("Iniciando depuración...");
        $.ajax({
            url: '<%= request.getContextPath() %>/debug.do',
            method: 'GET',
            success: function (data) {
                console.log("Respuesta del servidor:", data);
                alert("Consulta el log del servidor y la consola del navegador.");
            },
            error: function (xhr, status, error) {
                console.error("Error:", error);
                alert("Error al ejecutar la depuración.");
            }
        });
    }
</script>
</body>
</html>
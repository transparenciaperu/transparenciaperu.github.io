<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.SolicitudAccesoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.SolicitudAccesoModelo" %>
<%@ page import="pe.gob.transparencia.entidades.CiudadanoEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.EntidadPublicaModelo" %>
<%@ page import="java.util.List" %>
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

    // Obtener mensaje de confirmación (si existe)
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");

    // Limpiar mensajes de sesión después de obtenerlos
    if (mensaje != null) {
        session.removeAttribute("mensaje");
        session.removeAttribute("tipoMensaje");
    }

    // Obtener lista de solicitudes desde el modelo
    SolicitudAccesoModelo modeloSolicitud = new SolicitudAccesoModelo();
    List<SolicitudAccesoEntidad> listaSolicitudes = modeloSolicitud.listarSolicitudes();

    // Obtener lista de entidades públicas para filtros
    EntidadPublicaModelo modeloEntidad = new EntidadPublicaModelo();
    List<EntidadPublicaEntidad> listaEntidades = modeloEntidad.listarEntidades();

    // Formato para fechas
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Solicitudes - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
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
                        <a class="nav-link" href="entidades.jsp">
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
                        <a class="nav-link active" href="#">
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
                <h1 class="h2">Gestión de Solicitudes de Acceso a Información</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                data-bs-target="#nuevaSolicitudModal">
                            <i class="bi bi-file-earmark-plus me-1"></i> Nueva Solicitud
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="tooltip"
                                data-bs-placement="bottom" title="Exportar solicitudes">
                            <i class="bi bi-file-earmark-excel me-1"></i> Exportar
                        </button>
                    </div>
                </div>
            </div>

            <% if (mensaje != null) { %>
            <div class="alert alert-<%= tipoMensaje != null ? tipoMensaje : "info" %> fade-in alert-dismissible fade show"
                 role="alert">
                <i class="bi bi-info-circle me-2"></i> <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <!-- Filtros -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Filtros</h6>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label for="filtroEstado" class="form-label">Estado</label>
                            <select class="form-select" id="filtroEstado">
                                <option value="">Todos</option>
                                <option value="Pendiente">Pendiente</option>
                                <option value="En Proceso">En Proceso</option>
                                <option value="Atendida">Atendida</option>
                                <option value="Observada">Observada</option>
                                <option value="Rechazada">Rechazada</option>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="filtroEntidad" class="form-label">Entidad</label>
                            <select class="form-select" id="filtroEntidad">
                                <option value="">Todas</option>
                                <% for (EntidadPublicaEntidad entidad : listaEntidades) { %>
                                <option value="<%= entidad.getNombre() %>"><%= entidad.getNombre() %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3">
                            <label for="filtroTipo" class="form-label">Tipo</label>
                            <select class="form-select" id="filtroTipo">
                                <option value="">Todos</option>
                                <option value="Información Presupuestal">Información Presupuestal</option>
                                <option value="Información de Proyectos">Información de Proyectos</option>
                                <option value="Información de Contrataciones">Información de Contrataciones</option>
                                <option value="Información de Personal">Información de Personal</option>
                                <option value="Información General">Información General</option>
                                <option value="Información Ambiental">Información Ambiental</option>
                            </select>
                        </div>
                        <div class="col-md-3 mb-3 d-flex align-items-end">
                            <button type="button" class="btn btn-primary me-2" id="btnAplicarFiltros">
                                <i class="bi bi-funnel me-1"></i> Aplicar
                            </button>
                            <button type="button" class="btn btn-secondary" id="btnLimpiarFiltros">
                                <i class="bi bi-x-circle me-1"></i> Limpiar
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tabla de Solicitudes -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Listado de Solicitudes</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="tablaSolicitudes" width="100%" cellspacing="0">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Fecha Solicitud</th>
                                <th>Ciudadano</th>
                                <th>Entidad Pública</th>
                                <th>Tipo</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (SolicitudAccesoEntidad solicitud : listaSolicitudes) { %>
                            <tr>
                                <td><%= solicitud.getId() %>
                                </td>
                                <td><%= solicitud.getFechaSolicitud() != null ? formatoFecha.format(solicitud.getFechaSolicitud()) : "No disponible" %>
                                </td>
                                <td>
                                    <% if (solicitud.getCiudadano() != null) { %>
                                    <%= solicitud.getCiudadano().getNombres() + " " + solicitud.getCiudadano().getApellidos() %>
                                    <% } else { %>
                                    No disponible
                                    <% } %>
                                </td>
                                <td>
                                    <% if (solicitud.getEntidadPublica() != null) { %>
                                    <%= solicitud.getEntidadPublica().getNombre() %>
                                    <% } else { %>
                                    No disponible
                                    <% } %>
                                </td>
                                <td><%= solicitud.getTipoSolicitud() != null ? solicitud.getTipoSolicitud().getNombre() : "No disponible" %>
                                </td>
                                <td>
                                    <%
                                        String badgeClass = "bg-secondary";
                                        if (solicitud.getEstadoSolicitud() != null) {
                                            String estado = solicitud.getEstadoSolicitud().getNombre();
                                            if (estado.equals("Pendiente")) {
                                                badgeClass = "bg-warning text-dark";
                                            } else if (estado.equals("En Proceso")) {
                                                badgeClass = "bg-info";
                                            } else if (estado.equals("Atendida")) {
                                                badgeClass = "bg-success";
                                            } else if (estado.equals("Observada")) {
                                                badgeClass = "bg-primary";
                                            } else if (estado.equals("Rechazada")) {
                                                badgeClass = "bg-danger";
                                            }
                                    %>
                                    <span class="badge <%= badgeClass %>"><%= estado %></span>
                                    <% } else { %>
                                    <span class="badge bg-secondary">No definido</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <a href="<%= request.getContextPath() %>/admin.do?accion=editarSolicitud&id=<%= solicitud.getId() %>"
                                           class="btn btn-outline-primary" data-bs-toggle="tooltip" title="Editar">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="tooltip"
                                                title="Eliminar"
                                                onclick="confirmarEliminacion(<%= solicitud.getId() %>)">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                        <a href="<%= request.getContextPath() %>/admin.do?accion=verDetalleSolicitud&id=<%= solicitud.getId() %>"
                                           class="btn btn-outline-info" data-bs-toggle="tooltip" title="Ver detalle">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                    </div>
                                </td>
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

<!-- Modal Confirmar Eliminación -->
<div class="modal fade" id="eliminarSolicitudModal" tabindex="-1" aria-labelledby="eliminarSolicitudModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarSolicitudModalLabel"><i class="bi bi-exclamation-triangle me-2"></i>Confirmar
                    Eliminación</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro que desea eliminar la solicitud con ID: <strong id="idSolicitudEliminarText"></strong>?
                </p>
                <p>Esta acción eliminará también todas las respuestas asociadas y no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <form action="<%= request.getContextPath() %>/admin.do" method="post" id="eliminarSolicitudForm">
                    <input type="hidden" name="accion" value="eliminarSolicitud">
                    <input type="hidden" name="id" id="idSolicitudEliminar">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Nueva Solicitud -->
<div class="modal fade" id="nuevaSolicitudModal" tabindex="-1" aria-labelledby="nuevaSolicitudModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="nuevaSolicitudModalLabel"><i class="bi bi-file-earmark-plus me-2"></i>Nueva
                    Solicitud de Acceso</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/admin.do" method="post">
                <input type="hidden" name="accion" value="registrarSolicitud">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="ciudadanoId" class="form-label">Ciudadano</label>
                        <select class="form-select" id="ciudadanoId" name="ciudadanoId" required>
                            <option value="">Seleccione un ciudadano</option>
                            <%
                                // Obtener lista de ciudadanos
                                pe.gob.transparencia.modelo.CiudadanoModelo ciudadanoModelo = new pe.gob.transparencia.modelo.CiudadanoModelo();
                                List<CiudadanoEntidad> listaCiudadanos = ciudadanoModelo.listarCiudadanos();
                                for (CiudadanoEntidad ciudadano : listaCiudadanos) {
                            %>
                            <option value="<%= ciudadano.getId() %>"><%= ciudadano.getNombreCompleto() %>
                                - <%= ciudadano.getDni() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="entidadPublicaId" class="form-label">Entidad Pública</label>
                        <select class="form-select" id="entidadPublicaId" name="entidadPublicaId" required>
                            <option value="">Seleccione una entidad</option>
                            <% for (EntidadPublicaEntidad entidad : listaEntidades) { %>
                            <option value="<%= entidad.getId() %>"><%= entidad.getNombre() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="tipoSolicitudId" class="form-label">Tipo de Solicitud</label>
                        <select class="form-select" id="tipoSolicitudId" name="tipoSolicitudId" required>
                            <option value="">Seleccione un tipo</option>
                            <%
                                // Obtener lista de tipos de solicitud
                                SolicitudAccesoModelo solicitudModeloTipos = new SolicitudAccesoModelo();
                                List<pe.gob.transparencia.entidades.TipoSolicitudEntidad> listaTipos = solicitudModeloTipos.listarTiposSolicitud();
                                for (pe.gob.transparencia.entidades.TipoSolicitudEntidad tipo : listaTipos) {
                            %>
                            <option value="<%= tipo.getId() %>"><%= tipo.getNombre() %>
                            </option>
                            <% } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="descripcion" class="form-label">Descripción de la Solicitud</label>
                        <textarea class="form-control" id="descripcion" name="descripcion" rows="5" required
                                  placeholder="Describa detalladamente la información que solicita..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Registrar Solicitud</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

<script>
    $(document).ready(function () {
        // Inicializar DataTables
        var tabla = $('#tablaSolicitudes').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            pageLength: 10,
            responsive: true,
            order: [[0, 'desc']],
            columnDefs: [
                {targets: 6, orderable: false} // Deshabilitar ordenamiento en columna de acciones
            ]
        });

        // Inicializar tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Inicializar selects con búsqueda
        $('#ciudadanoId, #entidadPublicaId, #tipoSolicitudId').select2({
            theme: 'bootstrap-5',
            dropdownParent: $('#nuevaSolicitudModal'),
            width: '100%',
            placeholder: 'Seleccione una opción'
        });

        // Filtros personalizados
        $('#btnAplicarFiltros').click(function () {
            var estadoFiltro = $('#filtroEstado').val().toLowerCase();
            var entidadFiltro = $('#filtroEntidad').val().toLowerCase();
            var tipoFiltro = $('#filtroTipo').val().toLowerCase();

            $.fn.dataTable.ext.search.push(
                function (settings, data, dataIndex) {
                    var estado = data[5].toLowerCase(); // Columna Estado
                    var entidad = data[3].toLowerCase(); // Columna Entidad
                    var tipo = data[4].toLowerCase(); // Columna Tipo

                    var estadoOK = estadoFiltro === '' || estado.includes(estadoFiltro);
                    var entidadOK = entidadFiltro === '' || entidad.includes(entidadFiltro);
                    var tipoOK = tipoFiltro === '' || tipo.includes(tipoFiltro);

                    return estadoOK && entidadOK && tipoOK;
                }
            );

            tabla.draw();

            // Eliminar el filtro después de aplicarlo
            $.fn.dataTable.ext.search.pop();
        });

        $('#btnLimpiarFiltros').click(function () {
            $('#filtroEstado').val('');
            $('#filtroEntidad').val('');
            $('#filtroTipo').val('');
            tabla.search('').columns().search('').draw();
        });
    });

    // Función para confirmar eliminación
    function confirmarEliminacion(id) {
        document.getElementById('idSolicitudEliminar').value = id;
        document.getElementById('idSolicitudEliminarText').textContent = id;

        // Configurar el evento de envío del formulario
        document.getElementById('eliminarSolicitudForm').addEventListener('submit', function (e) {
            console.log("Enviando formulario para eliminar solicitud con ID: " + id);
        });

        var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarSolicitudModal'));
        eliminarModal.show();
    }
</script>
</body>
</html>
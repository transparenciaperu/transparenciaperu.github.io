<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.PresupuestoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.PresupuestoModelo" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.EntidadPublicaModelo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
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

    // Obtener lista de presupuestos desde el modelo
    PresupuestoModelo modeloPresupuesto = new PresupuestoModelo();
    List<PresupuestoEntidad> listaPresupuestos = modeloPresupuesto.listar();

    // Obtener lista de entidades públicas para el formulario
    EntidadPublicaModelo modeloEntidad = new EntidadPublicaModelo();
    List<EntidadPublicaEntidad> listaEntidades = modeloEntidad.listarEntidades();

    // Formato para montos
    NumberFormat formatoMoneda = NumberFormat.getCurrencyInstance(new Locale("es", "PE"));
    // Formato para fechas
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Presupuestos - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
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
                        <a class="nav-link active" href="#">
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
                <h1 class="h2">Gestión de Presupuestos</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                data-bs-target="#nuevoPresupuestoModal">
                            <i class="bi bi-plus-circle me-1"></i> Nuevo Presupuesto
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="tooltip"
                                data-bs-placement="bottom" title="Exportar presupuestos">
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
                            <label for="filtroAnio" class="form-label">Año</label>
                            <select class="form-select" id="filtroAnio">
                                <option value="">Todos</option>
                                <option value="2024">2024</option>
                                <option value="2023">2023</option>
                                <option value="2022">2022</option>
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
                            <label for="filtroMonto" class="form-label">Monto Mayor a</label>
                            <input type="number" class="form-control" id="filtroMonto" placeholder="0">
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

            <!-- Tabla de Presupuestos -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Listado de Presupuestos</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered" id="tablaPresupuestos" width="100%" cellspacing="0">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Año</th>
                                <th>Entidad Pública</th>
                                <th>Monto Total</th>
                                <th>Fecha Aprobación</th>
                                <th>Acciones</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (PresupuestoEntidad presupuesto : listaPresupuestos) { %>
                            <tr>
                                <td><%= presupuesto.getId() %>
                                </td>
                                <td><%= presupuesto.getAnio() %>
                                </td>
                                <td><%= presupuesto.getEntidadPublica().getNombre() %>
                                </td>
                                <td><%= formatoMoneda.format(presupuesto.getMontoTotal()) %>
                                </td>
                                <td>
                                    <% if (presupuesto.getFechaAprobacion() != null) { %>
                                    <%= formatoFecha.format(presupuesto.getFechaAprobacion()) %>
                                    <% } else { %>
                                    No disponible
                                    <% } %>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <button type="button" class="btn btn-outline-primary" data-bs-toggle="tooltip"
                                                title="Editar" onclick="editarPresupuesto(<%= presupuesto.getId() %>)">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="tooltip"
                                                title="Eliminar"
                                                onclick="confirmarEliminacion(<%= presupuesto.getId() %>, '<%= presupuesto.getAnio() %> - <%= presupuesto.getEntidadPublica().getNombre() %>')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                        <button type="button" class="btn btn-outline-info" data-bs-toggle="tooltip"
                                                title="Ver detalle"
                                                onclick="verDetallePresupuesto(<%= presupuesto.getId() %>)">
                                            <i class="bi bi-eye"></i>
                                        </button>
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

<!-- Modal Nuevo Presupuesto -->
<div class="modal fade" id="nuevoPresupuestoModal" tabindex="-1" aria-labelledby="nuevoPresupuestoModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="nuevoPresupuestoModalLabel"><i class="bi bi-cash-coin me-2"></i>Nuevo
                    Presupuesto</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/admin.do" method="post" id="formNuevoPresupuesto">
                <input type="hidden" name="accion" value="registrarPresupuesto">
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="anio" class="form-label">Año</label>
                            <select class="form-select" id="anio" name="anio" required>
                                <option value="">Seleccione año</option>
                                <option value="2024">2024</option>
                                <option value="2023">2023</option>
                                <option value="2022">2022</option>
                                <option value="2021">2021</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="entidadPublicaId" class="form-label">Entidad Pública</label>
                            <select class="form-select" id="entidadPublicaId" name="entidadPublicaId" required>
                                <option value="">Seleccione entidad</option>
                                <% for (EntidadPublicaEntidad entidad : listaEntidades) { %>
                                <option value="<%= entidad.getId() %>"><%= entidad.getNombre() %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="montoTotal" class="form-label">Monto Total</label>
                            <div class="input-group">
                                <span class="input-group-text">S/.</span>
                                <input type="number" class="form-control" id="montoTotal" name="montoTotal" step="0.01"
                                       min="0" value="0.00" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="fechaAprobacion" class="form-label">Fecha Aprobación</label>
                            <input type="date" class="form-control" id="fechaAprobacion" name="fechaAprobacion">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="descripcion" class="form-label">Descripción</label>
                        <textarea class="form-control" id="descripcion" name="descripcion" rows="3"></textarea>
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

<!-- Modal Confirmar Eliminación -->
<div class="modal fade" id="eliminarPresupuestoModal" tabindex="-1" aria-labelledby="eliminarPresupuestoModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarPresupuestoModalLabel"><i
                        class="bi bi-exclamation-triangle me-2"></i>Confirmar Eliminación</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro que desea eliminar el presupuesto <strong id="nombrePresupuestoEliminar"></strong>?</p>
                <p>Esta acción eliminará también todos los gastos asociados y no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <form action="<%= request.getContextPath() %>/admin.do" method="post">
                    <input type="hidden" name="accion" value="eliminarPresupuesto">
                    <input type="hidden" name="id" id="idPresupuestoEliminar">
                    <button type="submit" class="btn btn-danger">Eliminar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal Editar Presupuesto -->
<div class="modal fade" id="editarPresupuestoModal" tabindex="-1" aria-labelledby="editarPresupuestoModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="editarPresupuestoModalLabel"><i class="bi bi-pencil-square me-2"></i>Editar
                    Presupuesto</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/admin.do" method="post">
                <input type="hidden" name="accion" value="actualizarPresupuesto">
                <input type="hidden" name="id" id="editId">
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="editAnio" class="form-label">Año</label>
                            <select class="form-select" id="editAnio" name="anio" required>
                                <option value="">Seleccione año</option>
                                <option value="2024">2024</option>
                                <option value="2023">2023</option>
                                <option value="2022">2022</option>
                                <option value="2021">2021</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="editEntidadPublicaId" class="form-label">Entidad Pública</label>
                            <select class="form-select" id="editEntidadPublicaId" name="entidadPublicaId" required>
                                <option value="">Seleccione entidad</option>
                                <% for (EntidadPublicaEntidad entidad : listaEntidades) { %>
                                <option value="<%= entidad.getId() %>"><%= entidad.getNombre() %>
                                </option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="editMontoTotal" class="form-label">Monto Total</label>
                            <div class="input-group">
                                <span class="input-group-text">S/.</span>
                                <input type="number" class="form-control" id="editMontoTotal" name="montoTotal"
                                       step="0.01"
                                       min="0" value="0.00" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="editFechaAprobacion" class="form-label">Fecha Aprobación</label>
                            <input type="date" class="form-control" id="editFechaAprobacion" name="fechaAprobacion">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="editDescripcion" class="form-label">Descripción</label>
                        <textarea class="form-control" id="editDescripcion" name="descripcion" rows="3"></textarea>
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

<!-- Modal Detalle Presupuesto -->
<div class="modal fade" id="detallePresupuestoModal" tabindex="-1" aria-labelledby="detallePresupuestoModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-info text-white">
                <h5 class="modal-title" id="detallePresupuestoModalLabel"><i class="bi bi-info-circle me-2"></i>Detalle
                    de Presupuesto</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="loadingSpinner" class="text-center">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Cargando...</span>
                    </div>
                    <p class="mt-2">Cargando detalles del presupuesto...</p>
                </div>
                <div id="detallePresupuestoContent" style="display: none;">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h5 class="border-bottom pb-2">Información General</h5>
                            <p><strong>ID:</strong> <span id="detalleId"></span></p>
                            <p><strong>Año Fiscal:</strong> <span id="detalleAnio"></span></p>
                            <p><strong>Monto Total:</strong> <span id="detalleMonto"></span></p>
                            <p><strong>Fecha Aprobación:</strong> <span id="detalleFechaAprobacion"></span></p>
                        </div>
                        <div class="col-md-6">
                            <h5 class="border-bottom pb-2">Entidad Responsable</h5>
                            <p><strong>Entidad:</strong> <span id="detalleEntidad"></span></p>
                            <p><strong>Tipo:</strong> <span id="detalleTipoEntidad"></span></p>
                            <p><strong>Nivel de Gobierno:</strong> <span id="detalleNivelGobierno"></span></p>
                        </div>
                    </div>
                    <div class="border-top pt-3 mt-2">
                        <h5 class="border-bottom pb-2">Descripción</h5>
                        <p id="detalleDescripcion"></p>
                    </div>
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle me-2"></i> Este presupuesto representa los fondos asignados a la
                        entidad para el año fiscal indicado.
                    </div>
                </div>
                <div id="errorMessage" class="alert alert-danger" style="display: none;">
                    <i class="bi bi-exclamation-triangle me-2"></i> <span id="errorText"></span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" id="btnEditarDesdeDetalle">Editar</button>
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
        var tabla = $('#tablaPresupuestos').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            pageLength: 10,
            responsive: true,
            order: [[1, 'desc']], // Ordenar por año descendente
            columnDefs: [
                {targets: 5, orderable: false} // Deshabilitar ordenamiento en columna de acciones
            ]
        });

        // Inicializar tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Filtros personalizados
        $('#btnAplicarFiltros').click(function () {
            var anioFiltro = $('#filtroAnio').val().toLowerCase();
            var entidadFiltro = $('#filtroEntidad').val().toLowerCase();
            var montoFiltro = parseFloat($('#filtroMonto').val()) || 0;

            $.fn.dataTable.ext.search.push(
                function (settings, data, dataIndex) {
                    var anio = data[1].toLowerCase(); // Columna Año
                    var entidad = data[2].toLowerCase(); // Columna Entidad
                    var monto = parseFloat(data[3].replace(/[^\d.-]/g, '')) || 0; // Columna Monto (limpia formato)

                    var anioOK = anioFiltro === '' || anio.includes(anioFiltro);
                    var entidadOK = entidadFiltro === '' || entidad.includes(entidadFiltro);
                    var montoOK = monto >= montoFiltro;

                    return anioOK && entidadOK && montoOK;
                }
            );

            tabla.draw();

            // Eliminar el filtro después de aplicarlo
            $.fn.dataTable.ext.search.pop();
        });

        $('#btnLimpiarFiltros').click(function () {
            $('#filtroAnio').val('');
            $('#filtroEntidad').val('');
            $('#filtroMonto').val('');
            tabla.search('').columns().search('').draw();
        });

        // Validación de formulario de nuevo presupuesto
        $("#formNuevoPresupuesto").on('submit', function (e) {
            var anio = $("#anio").val();
            var entidadId = $("#entidadPublicaId").val();
            var monto = $("#montoTotal").val();

            if (!anio || !entidadId || !monto) {
                alert("Por favor complete todos los campos obligatorios.");
                e.preventDefault();
                return false;
            }

            if (parseFloat(monto) <= 0) {
                alert("El monto debe ser mayor que cero.");
                e.preventDefault();
                return false;
            }

            return true;
        });
    });

    // Función para confirmar eliminación
    function confirmarEliminacion(id, nombre) {
        document.getElementById('idPresupuestoEliminar').value = id;
        document.getElementById('nombrePresupuestoEliminar').textContent = nombre;

        var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarPresupuestoModal'));
        eliminarModal.show();
    }

    // Función para editar presupuesto en modal
    function editarPresupuesto(id) {
        // Mostrar loading spinner
        $('#editId').val(id);

        // Hacer una solicitud AJAX para obtener los datos del presupuesto
        $.ajax({
            url: "<%= request.getContextPath() %>/admin.do",
            type: "GET",
            data: {
                accion: "verDetallePresupuesto",
                id: id,
                format: "json"
            },
            dataType: "json",
            success: function (data) {
                // Si obtenemos datos correctamente, llenar el formulario
                if (data && data.id) {
                    $('#editAnio').val(data.anio);
                    $('#editEntidadPublicaId').val(data.entidadPublicaId);
                    $('#editMontoTotal').val(data.montoTotal);
                    $('#editDescripcion').val(data.descripcion || '');

                    // Formatear la fecha para input date (YYYY-MM-DD)
                    if (data.fechaAprobacion) {
                        // Extraer solo YYYY-MM-DD si la fecha tiene más información
                        let fechaFormateada = data.fechaAprobacion.split('T')[0];
                        $('#editFechaAprobacion').val(fechaFormateada);
                    } else {
                        $('#editFechaAprobacion').val('');
                    }
                } else {
                    // Si no hay datos JSON válidos, buscar en la tabla
                    buscarDatosEnTabla(id);
                }

                // Mostrar el modal
                var editarModal = new bootstrap.Modal(document.getElementById('editarPresupuestoModal'));
                editarModal.show();
            },
            error: function () {
                // En caso de error, intentar obtener datos de la tabla
                buscarDatosEnTabla(id);

                // Mostrar el modal
                var editarModal = new bootstrap.Modal(document.getElementById('editarPresupuestoModal'));
                editarModal.show();
            }
        });
    }

    // Función auxiliar para buscar datos en la tabla cuando falla AJAX
    function buscarDatosEnTabla(id) {
        var table = $('#tablaPresupuestos').DataTable();
        var encontrado = false;

        // Recorrer todas las filas buscando el ID
        table.rows().every(function () {
            var data = this.data();
            if (data[0] == id) {
                // Encontramos la fila con el ID buscado
                $('#editAnio').val(data[1]); // Columna de año

                // Usar el elemento select para encontrar la opción que corresponde a esta entidad
                var nombreEntidad = data[2];
                $("#editEntidadPublicaId option").each(function () {
                    if ($(this).text().trim() === nombreEntidad) {
                        $('#editEntidadPublicaId').val($(this).val());
                        return false;
                    }
                });

                // Limpiar formateo del monto (quitar símbolos y espacios)
                var montoLimpio = data[3].replace(/[^\d.,]/g, '').replace(/\./g, '').replace(',', '.');
                $('#editMontoTotal').val(parseFloat(montoLimpio) || 0);

                // Fecha de aprobación - Columna 4
                var fechaAprobacion = data[4];
                if (fechaAprobacion && fechaAprobacion !== "No disponible") {
                    var partsFecha = fechaAprobacion.split('/');
                    if (partsFecha.length === 3) {
                        var fechaFormateada = partsFecha[2] + '-' +
                            (partsFecha[1].length === 1 ? '0' + partsFecha[1] : partsFecha[1]) + '-' +
                            (partsFecha[0].length === 1 ? '0' + partsFecha[0] : partsFecha[0]);
                        $('#editFechaAprobacion').val(fechaFormateada);
                    } else {
                        $('#editFechaAprobacion').val(fechaAprobacion);
                    }
                } else {
                    $('#editFechaAprobacion').val('');
                }

                // No podemos recuperar descripción desde la tabla
                $('#editDescripcion').val('');

                encontrado = true;
                return false; // Salir del loop
            }
        });

        if (!encontrado) {
            // Si no encontramos datos, establecemos valores predeterminados
            $('#editAnio').val(new Date().getFullYear());
            $('#editMontoTotal').val(0);
            $('#editFechaAprobacion').val('');
            $('#editDescripcion').val('');
        }

        // Mostrar el modal
        var editarModal = new bootstrap.Modal(document.getElementById('editarPresupuestoModal'));
        editarModal.show();
    }

    // Función para ver detalle de presupuesto
    function verDetallePresupuesto(id) {
        // Mostrar modal con spinner de carga
        $('#loadingSpinner').show();
        $('#detallePresupuestoContent').hide();
        $('#errorMessage').hide();

        // Almacenar el ID para el botón de edición
        $('#btnEditarDesdeDetalle').data('id', id);

        // Configurar evento del botón editar
        $('#btnEditarDesdeDetalle').off('click').on('click', function () {
            var detalleModal = bootstrap.Modal.getInstance(document.getElementById('detallePresupuestoModal'));
            detalleModal.hide();
            editarPresupuesto($(this).data('id'));
        });

        // Hacer una solicitud AJAX para obtener los datos del presupuesto
        $.ajax({
            url: "<%= request.getContextPath() %>/admin.do",
            type: "GET",
            data: {
                accion: "verDetallePresupuesto",
                id: id,
                format: "json"
            },
            dataType: "json",
            success: function (data) {
                // Si obtenemos datos correctamente, llenar el modal
                if (data && data.id) {
                    $('#detalleId').text(data.id);
                    $('#detalleAnio').text(data.anio);
                    $('#detalleEntidad').text(data.entidadPublica.nombre);
                    $('#detalleMonto').text(String.format("S/. %.2f", data.montoTotal));
                    $('#detalleTipoEntidad').text(data.entidadPublica.tipo || 'Entidad Pública');
                    $('#detalleNivelGobierno').text(data.entidadPublica.nivelGobierno || 'Nacional');
                    var fechaAprobacion = data.fechaAprobacion;
                    if (fechaAprobacion && fechaAprobacion !== "No disponible") {
                        var partsFecha = fechaAprobacion.split('/');
                        if (partsFecha.length === 3) {
                            var fechaFormateada = partsFecha[2] + '-' +
                                (partsFecha[1].length === 1 ? '0' + partsFecha[1] : partsFecha[1]) + '-' +
                                (partsFecha[0].length === 1 ? '0' + partsFecha[0] : partsFecha[0]);
                            $('#detalleFechaAprobacion').text(fechaFormateada);
                        } else {
                            $('#detalleFechaAprobacion').text(fechaAprobacion);
                        }
                    } else {
                        $('#detalleFechaAprobacion').text("No disponible");
                    }
                    $('#detalleDescripcion').text(data.descripcion || "Sin descripción");

                    // Mostrar contenido
                    $('#loadingSpinner').hide();
                    $('#detallePresupuestoContent').show();
                } else {
                    // Si no hay datos JSON válidos, buscar en la tabla
                    buscarDetalleEnTabla(id);
                }
            },
            error: function () {
                // En caso de error, intentar obtener datos de la tabla
                buscarDetalleEnTabla(id);
            }
        });

        // Mostrar el modal
        var detalleModal = new bootstrap.Modal(document.getElementById('detallePresupuestoModal'));
        detalleModal.show();
    }

    // Función auxiliar para buscar detalles en la tabla cuando falla AJAX
    function buscarDetalleEnTabla(id) {
        var table = $('#tablaPresupuestos').DataTable();
        var encontrado = false;

        // Recorrer todas las filas buscando el ID
        table.rows().every(function () {
            var data = this.data();
            if (data[0] == id) {
                // Encontramos la fila con el ID buscado
                $('#detalleId').text(data[0]);
                $('#detalleAnio').text(data[1]);
                $('#detalleEntidad').text(data[2]);
                // Limpiar formateo del monto (quitar símbolos y espacios)
                var montoLimpio = data[3].replace(/[^\d.,]/g, '').replace(/\./g, '').replace(',', '.');
                $('#detalleMonto').text(String.format("S/. %.2f", parseFloat(montoLimpio) || 0));
                $('#detalleTipoEntidad').text('Entidad Pública');
                $('#detalleNivelGobierno').text('Nacional');
                var fechaAprobacion = data[4];
                if (fechaAprobacion && fechaAprobacion !== "No disponible") {
                    var partsFecha = fechaAprobacion.split('/');
                    if (partsFecha.length === 3) {
                        var fechaFormateada = partsFecha[2] + '-' +
                            (partsFecha[1].length === 1 ? '0' + partsFecha[1] : partsFecha[1]) + '-' +
                            (partsFecha[0].length === 1 ? '0' + partsFecha[0] : partsFecha[0]);
                        $('#detalleFechaAprobacion').text(fechaFormateada);
                    } else {
                        $('#detalleFechaAprobacion').text(fechaAprobacion);
                    }
                } else {
                    $('#detalleFechaAprobacion').text("No disponible");
                }
                $('#detalleDescripcion').text(data[5] !== undefined ? data[5] : "Sin descripción");

                // Mostrar contenido
                $('#loadingSpinner').hide();
                $('#detallePresupuestoContent').show();

                encontrado = true;
                return false; // Salir del loop
            }
        });

        if (!encontrado) {
            // Si no encontramos datos, mostrar mensaje de error
            $('#loadingSpinner').hide();
            $('#errorText').text('No se pudo cargar la información del presupuesto.');
            $('#errorMessage').show();
        }
    }

    // Función auxiliar para formatear montos como moneda
    function formatCurrency(amount) {
        try {
            // Asegurar que amount es un número
            if (typeof amount === 'string') {
                amount = parseFloat(amount.replace(/[^\d.-]/g, ''));
            }

            if (isNaN(amount)) {
                amount = 0;
            }

            return new Intl.NumberFormat('es-PE', {
                style: 'currency',
                currency: 'PEN',
                minimumFractionDigits: 2
            }).format(amount);
        } catch (e) {
            console.error("Error al formatear moneda:", e);
            return "S/. 0.00";
        }
    }
</script>
</body>
</html>
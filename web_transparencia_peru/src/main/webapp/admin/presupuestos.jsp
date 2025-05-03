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
                                <th>Estado</th>
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
                                <td><%= presupuesto.getFechaAprobacion() != null ? formatoFecha.format(presupuesto.getFechaAprobacion()) : "No disponible" %>
                                </td>
                                <td>
                                    <% if (presupuesto.getEstado() != null) { %>
                                    <span class="badge <%= presupuesto.getEstado().equals("Activo") ? "bg-success" : (presupuesto.getEstado().equals("Planificado") ? "bg-primary" : "bg-secondary") %>">
                                            <%= presupuesto.getEstado() %>
                                        </span>
                                    <% } else { %>
                                    <span class="badge bg-secondary">No definido</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <a href="<%= request.getContextPath() %>/admin.do?accion=editarPresupuesto&id=<%= presupuesto.getId() %>"
                                           class="btn btn-outline-primary" data-bs-toggle="tooltip" title="Editar">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="tooltip"
                                                title="Eliminar"
                                                onclick="confirmarEliminacion(<%= presupuesto.getId() %>, '<%= presupuesto.getAnio() %> - <%= presupuesto.getEntidadPublica().getNombre() %>')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                        <a href="<%= request.getContextPath() %>/admin.do?accion=verDetallePresupuesto&id=<%= presupuesto.getId() %>"
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
            <form action="<%= request.getContextPath() %>/admin.do" method="post">
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
                                       min="0" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="fechaAprobacion" class="form-label">Fecha Aprobación</label>
                            <input type="date" class="form-control" id="fechaAprobacion" name="fechaAprobacion">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="periodoFiscalId" class="form-label">Periodo Fiscal</label>
                            <select class="form-select" id="periodoFiscalId" name="periodoFiscalId">
                                <option value="">Seleccione periodo</option>
                                <option value="3">2024</option>
                                <option value="2">2023</option>
                                <option value="1">2022</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="estado" class="form-label">Estado</label>
                            <select class="form-select" id="estado" name="estado">
                                <option value="Activo">Activo</option>
                                <option value="Planificado">Planificado</option>
                                <option value="Cerrado">Cerrado</option>
                            </select>
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
                <form action="<%= request.getContextPath() %>/admin.do" method="post">
                    <input type="hidden" name="accion" value="eliminarPresupuesto">
                    <input type="hidden" name="id" id="idPresupuestoEliminar">
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
        var tabla = $('#tablaPresupuestos').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            pageLength: 10,
            responsive: true,
            order: [[0, 'asc']],
            columnDefs: [
                {targets: 6, orderable: false} // Deshabilitar ordenamiento en columna de acciones
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
    });

    // Función para confirmar eliminación
    function confirmarEliminacion(id, nombre) {
        document.getElementById('idPresupuestoEliminar').value = id;
        document.getElementById('nombrePresupuestoEliminar').textContent = nombre;

        var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarPresupuestoModal'));
        eliminarModal.show();
    }
</script>
</body>
</html>
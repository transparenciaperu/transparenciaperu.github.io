<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.EntidadPublicaModelo" %>
<%@ page import="pe.gob.transparencia.modelo.NivelGobiernoModelo" %>
<%@ page import="pe.gob.transparencia.modelo.RegionModelo" %>
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
    List<?> niveles = nivelModelo.listarNivelesGobierno();

    // Obtener regiones para el formulario
    RegionModelo regionModelo = new RegionModelo();
    List<?> regiones = regionModelo.listarRegiones();
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
                                <option value="1">Nacional</option>
                                <option value="2">Regional</option>
                                <option value="3">Municipal</option>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label for="filtroRegion" class="form-label">Región</label>
                            <select class="form-select" id="filtroRegion">
                                <option value="">Todas</option>
                                <option value="1">Lima</option>
                                <option value="2">Arequipa</option>
                                <option value="3">Cusco</option>
                                <option value="4">La Libertad</option>
                                <option value="5">Piura</option>
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
                            <% for (EntidadPublicaEntidad entidad : listaEntidades) { %>
                            <tr>
                                <td><%= entidad.getId() %>
                                </td>
                                <td><%= entidad.getNombre() %>
                                </td>
                                <td><%= entidad.getTipo() %>
                                </td>
                                <td>
                                    <%
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
                                    %>
                                    <%= nivelGobierno %>
                                </td>
                                <td>
                                    <% if (entidad.getRegionId() != 0) { %>
                                    <%= modelo.obtenerNombreRegion(entidad.getRegionId()) %>
                                    <% } else { %>
                                    -
                                    <% } %>
                                </td>
                                <td>
                                    <small>
                                        <%= entidad.getEmail() != null ? entidad.getEmail() : "" %><br>
                                        <%= entidad.getTelefono() != null ? entidad.getTelefono() : "" %>
                                    </small>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <a href="<%= request.getContextPath() %>/admin.do?accion=editarEntidad&id=<%= entidad.getId() %>"
                                           class="btn btn-outline-primary" data-bs-toggle="tooltip" title="Editar">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="tooltip"
                                                title="Eliminar"
                                                onclick="confirmarEliminacion(<%= entidad.getId() %>, '<%= entidad.getNombre() %>')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                        <a href="<%= request.getContextPath() %>/admin.do?accion=verDetalleEntidad&id=<%= entidad.getId() %>"
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
            <form action="<%= request.getContextPath() %>/admin.do" method="post">
                <input type="hidden" name="accion" value="registrarEntidad">
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-8">
                            <label for="nombre" class="form-label">Nombre de Entidad</label>
                            <input type="text" class="form-control" id="nombre" name="nombre" required>
                        </div>
                        <div class="col-md-4">
                            <label for="tipo" class="form-label">Tipo</label>
                            <select class="form-select" id="tipo" name="tipo" required>
                                <option value="">Seleccione tipo</option>
                                <option value="Ministerio">Ministerio</option>
                                <option value="Gobierno Regional">Gobierno Regional</option>
                                <option value="Municipalidad Provincial">Municipalidad Provincial</option>
                                <option value="Municipalidad Distrital">Municipalidad Distrital</option>
                                <option value="Organismo Supervisor">Organismo Supervisor</option>
                                <option value="Otro">Otro</option>
                            </select>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="nivelGobiernoId" class="form-label">Nivel de Gobierno</label>
                            <select class="form-select" id="nivelGobiernoId" name="nivelGobiernoId" required
                                    onchange="mostrarRegion()">
                                <option value="">Seleccione nivel</option>
                                <option value="1">Nacional</option>
                                <option value="2">Regional</option>
                                <option value="3">Municipal</option>
                            </select>
                        </div>
                        <div class="col-md-6" id="div-region" style="display:none;">
                            <label for="regionId" class="form-label">Región</label>
                            <select class="form-select" id="regionId" name="regionId">
                                <option value="">Seleccione región</option>
                                <option value="1">Lima</option>
                                <option value="2">Arequipa</option>
                                <option value="3">Cusco</option>
                                <option value="4">La Libertad</option>
                                <option value="5">Piura</option>
                                <option value="6">Amazonas</option>
                                <option value="7">Áncash</option>
                                <option value="8">Apurímac</option>
                                <option value="9">Ayacucho</option>
                                <option value="10">Cajamarca</option>
                                <option value="11">Callao</option>
                                <option value="12">Huancavelica</option>
                                <option value="13">Huánuco</option>
                                <option value="14">Ica</option>
                                <option value="15">Junín</option>
                                <option value="16">Lambayeque</option>
                                <option value="17">Loreto</option>
                                <option value="18">Madre de Dios</option>
                                <option value="19">Moquegua</option>
                                <option value="20">Pasco</option>
                                <option value="21">Puno</option>
                                <option value="22">San Martín</option>
                                <option value="23">Tacna</option>
                                <option value="24">Tumbes</option>
                                <option value="25">Ucayali</option>
                            </select>
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
                        <input type="url" class="form-control" id="sitioWeb" name="sitioWeb" placeholder="https://">
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

            $.fn.dataTable.ext.search.push(
                function (settings, data, dataIndex) {
                    var nivel = data[3]; // Índice de la columna Nivel de Gobierno
                    var region = data[4]; // Índice de la columna Región
                    var tipo = data[2];   // Índice de la columna Tipo

                    var nivelOK = nivelFiltro === '' || nivel.includes(nivelFiltro === '1' ? 'Nacional' : nivelFiltro === '2' ? 'Regional' : 'Municipal');
                    var regionOK = regionFiltro === '' || region.includes($('#filtroRegion option:selected').text());
                    var tipoOK = tipoFiltro === '' || tipo === tipoFiltro;

                    return nivelOK && regionOK && tipoOK;
                }
            );

            tabla.draw();

            // Limpiar el filtro después de aplicarlo
            $.fn.dataTable.ext.search.pop();
        });

        $('#btnLimpiarFiltros').click(function () {
            $('#filtroNivel').val('');
            $('#filtroRegion').val('');
            $('#filtroTipo').val('');
            tabla.search('').columns().search('').draw();
        });
    });

    function mostrarRegion() {
        var nivelGobierno = document.getElementById('nivelGobiernoId').value;
        var divRegion = document.getElementById('div-region');
        var selectRegion = document.getElementById('regionId');

        if (nivelGobierno === '1') { // Nacional
            divRegion.style.display = 'none';
            selectRegion.value = '';
            selectRegion.required = false;
        } else { // Regional o Municipal
            divRegion.style.display = 'block';
            selectRegion.required = true;
        }
    }

    // Función para confirmar eliminación
    function confirmarEliminacion(id, nombre) {
        document.getElementById('idEntidadEliminar').value = id;
        document.getElementById('nombreEntidadEliminar').textContent = nombre;

        var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarEntidadModal'));
        eliminarModal.show();
    }
</script>
</body>
</html>
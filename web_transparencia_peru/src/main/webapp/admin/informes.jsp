<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="pe.gob.transparencia.modelo.InformeModelo" %>
<%@ page import="pe.gob.transparencia.entidades.InformeEntidad" %>

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

    // Formato para montos
    NumberFormat formatoMoneda = NumberFormat.getCurrencyInstance(new Locale("es", "PE"));
    // Formato para fechas
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");

    // Año actual
    int anioActual = Calendar.getInstance().get(Calendar.YEAR);

    // Obtener lista de informes desde la base de datos
    InformeModelo informeModelo = new InformeModelo();
    List<InformeEntidad> listaInformes = informeModelo.listarInformes();

    // Parámetros de filtrado
    String tipoInforme = request.getParameter("tipoInforme");
    String anioInforme = request.getParameter("anioInforme");
    String nivelGobierno = request.getParameter("nivelGobierno");

    // Aplicar filtros si están definidos
    if (tipoInforme != null && !tipoInforme.equals("todos")) {
        listaInformes = informeModelo.listarInformesPorTipo(tipoInforme);
    }

    if (anioInforme != null && !anioInforme.isEmpty()) {
        try {
            int anio = Integer.parseInt(anioInforme);
            listaInformes = informeModelo.listarInformesPorAnio(anio);
        } catch (NumberFormatException e) {
            // Ignorar error de formato
        }
    }

    if (nivelGobierno != null && !nivelGobierno.equals("todos")) {
        listaInformes = informeModelo.listarInformesPorNivelGobierno(nivelGobierno);
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Generación de Informes - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Chart.js para gráficos -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                        <a class="nav-link active" href="#">
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
                <h1 class="h2">Generación de Informes</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-file-earmark-pdf me-1"></i> Exportar a PDF
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-success">
                            <i class="bi bi-file-earmark-excel me-1"></i> Exportar a Excel
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

            <!-- Filtros para informes -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold">Parámetros del Informe</h6>
                    <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                            data-bs-target="#nuevoInformeModal">
                        <i class="bi bi-plus-circle me-1"></i> Nuevo Informe
                    </button>
                </div>
                <div class="card-body">
                    <form id="formInforme" action="<%= request.getContextPath() %>/admin/informes.jsp" method="get">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <label for="tipoInforme" class="form-label">Tipo de Informe</label>
                                <select class="form-select" id="tipoInforme" name="tipoInforme">
                                    <option value="todos">Todos</option>
                                    <option value="presupuesto" <%= tipoInforme != null && tipoInforme.equals("presupuesto") ? "selected" : "" %>>
                                        Presupuestos por Nivel de Gobierno
                                    </option>
                                    <option value="ejecucion" <%= tipoInforme != null && tipoInforme.equals("ejecucion") ? "selected" : "" %>>
                                        Ejecución Presupuestal
                                    </option>
                                    <option value="solicitudes" <%= tipoInforme != null && tipoInforme.equals("solicitudes") ? "selected" : "" %>>
                                        Solicitudes de Información
                                    </option>
                                    <option value="entidades" <%= tipoInforme != null && tipoInforme.equals("entidades") ? "selected" : "" %>>
                                        Entidades Públicas
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="anioInforme" class="form-label">Año</label>
                                <select class="form-select" id="anioInforme" name="anioInforme">
                                    <option value="">Todos</option>
                                    <option value="<%= anioActual %>" <%= anioInforme != null && anioInforme.equals(String.valueOf(anioActual)) ? "selected" : "" %>><%= anioActual %>
                                    </option>
                                    <option value="<%= anioActual - 1 %>" <%= anioInforme != null && anioInforme.equals(String.valueOf(anioActual - 1)) ? "selected" : "" %>><%= anioActual - 1 %>
                                    </option>
                                    <option value="<%= anioActual - 2 %>" <%= anioInforme != null && anioInforme.equals(String.valueOf(anioActual - 2)) ? "selected" : "" %>><%= anioActual - 2 %>
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="nivelGobierno" class="form-label">Nivel de Gobierno</label>
                                <select class="form-select" id="nivelGobierno" name="nivelGobierno">
                                    <option value="todos">Todos</option>
                                    <option value="Nacional" <%= nivelGobierno != null && nivelGobierno.equals("Nacional") ? "selected" : "" %>>
                                        Nacional
                                    </option>
                                    <option value="Regional" <%= nivelGobierno != null && nivelGobierno.equals("Regional") ? "selected" : "" %>>
                                        Regional
                                    </option>
                                    <option value="Municipal" <%= nivelGobierno != null && nivelGobierno.equals("Municipal") ? "selected" : "" %>>
                                        Municipal
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100" id="btnFiltrarInformes">
                                    <i class="bi bi-funnel me-1"></i> Filtrar
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Resultados del informe -->
            <div id="resultadoInforme" class="mt-4">
                <!-- Listado de informes -->
                <div class="card shadow mb-4 fade-in">
                    <div class="card-header py-3">
                        <h6 class="m-0 font-weight-bold">Listado de Informes</h6>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-bordered" id="tablaInformes" width="100%" cellspacing="0">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Título</th>
                                    <th>Tipo</th>
                                    <th>Año</th>
                                    <th>Nivel de Gobierno</th>
                                    <th>Fecha Generación</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% for (InformeEntidad informe : listaInformes) { %>
                                <tr>
                                    <td><%= informe.getId() %>
                                    </td>
                                    <td><%= informe.getTitulo() %>
                                    </td>
                                    <td><%= informe.getTipo() %>
                                    </td>
                                    <td><%= informe.getAnio() %>
                                    </td>
                                    <td><%= informe.getNivelGobierno() %>
                                    </td>
                                    <td><%= formatoFecha.format(informe.getFechaGeneracion()) %>
                                    </td>
                                    <td>
                                        <% if (informe.getEstado().equals("Activo")) { %>
                                        <span class="badge bg-success">Activo</span>
                                        <% } else { %>
                                        <span class="badge bg-secondary">Inactivo</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <div class="btn-group btn-group-sm" role="group">
                                            <a href="<%= request.getContextPath() %>/admin.do?accion=verDetalleInforme&id=<%= informe.getId() %>"
                                               class="btn btn-outline-primary" data-bs-toggle="tooltip"
                                               title="Ver detalle">
                                                <i class="bi bi-eye"></i>
                                            </a>
                                            <a href="<%= request.getContextPath() %>/admin.do?accion=editarInforme&id=<%= informe.getId() %>"
                                               class="btn btn-outline-secondary" data-bs-toggle="tooltip"
                                               title="Editar">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <button type="button" class="btn btn-outline-danger"
                                                    data-bs-toggle="tooltip"
                                                    title="Eliminar"
                                                    onclick="confirmarEliminacion(<%= informe.getId() %>, '<%= informe.getTitulo() %>')">
                                                <i class="bi bi-trash"></i>
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

                <% if (!listaInformes.isEmpty() && listaInformes.get(0).getTipo().equals("presupuesto")) { %>
                <!-- Sección de presupuestos por nivel de gobierno -->
                <div id="seccionPresupuesto" class="mb-5">
                    <h3 class="h4 mb-3">Presupuesto por Nivel de Gobierno - <%= listaInformes.get(0).getAnio() %>
                    </h3>

                    <div class="row">
                        <!-- Gráfico de distribución -->
                        <div class="col-lg-8 col-md-7">
                            <div class="card shadow mb-4">
                                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                    <h6 class="m-0 font-weight-bold">Distribución Presupuestal</h6>
                                </div>
                                <div class="card-body">
                                    <div style="height: 300px;">
                                        <canvas id="presupuestoChart"></canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Resumen en tarjetas -->
                        <div class="col-lg-4 col-md-5">
                            <div class="row">
                                <div class="col-md-12 mb-4">
                                    <div class="card border-left-primary shadow h-100 py-2">
                                        <div class="card-body">
                                            <div class="row no-gutters align-items-center">
                                                <div class="col mr-2">
                                                    <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                                        Presupuesto Total
                                                    </div>
                                                    <div class="h5 mb-0 font-weight-bold text-gray-800">S/
                                                        130,850,000,000.00
                                                    </div>
                                                </div>
                                                <div class="col-auto">
                                                    <i class="bi bi-currency-dollar fa-2x text-gray-300"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-12 mb-4">
                                    <div class="card border-left-success shadow h-100 py-2">
                                        <div class="card-body">
                                            <div class="row no-gutters align-items-center">
                                                <div class="col mr-2">
                                                    <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                                        Ejecución Presupuestal
                                                    </div>
                                                    <div class="h5 mb-0 font-weight-bold text-gray-800">75.3%</div>
                                                </div>
                                                <div class="col-auto">
                                                    <i class="bi bi-bar-chart fa-2x text-gray-300"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-12 mb-4">
                                    <div class="card border-left-info shadow h-100 py-2">
                                        <div class="card-body">
                                            <div class="row no-gutters align-items-center">
                                                <div class="col mr-2">
                                                    <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                                        Total de Entidades
                                                    </div>
                                                    <div class="h5 mb-0 font-weight-bold text-gray-800">28</div>
                                                </div>
                                                <div class="col-auto">
                                                    <i class="bi bi-building fa-2x text-gray-300"></i>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Tabla de datos -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Detalle por Nivel de Gobierno</h6>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-bordered" width="100%" cellspacing="0">
                                    <thead>
                                    <tr>
                                        <th>Nivel de Gobierno</th>
                                        <th>Presupuesto Asignado</th>
                                        <th>Presupuesto Ejecutado</th>
                                        <th>% Avance</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>Nacional</td>
                                        <td>S/ 102,450,000,000.00</td>
                                        <td>S/ 78,380,000,000.00</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="progress flex-grow-1 me-2" style="height: 10px;">
                                                    <div class="progress-bar bg-success" role="progressbar"
                                                         style="width: 76%" aria-valuenow="76" aria-valuemin="0"
                                                         aria-valuemax="100"></div>
                                                </div>
                                                <span>76%</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Regional</td>
                                        <td>S/ 18,750,000,000.00</td>
                                        <td>S/ 13,800,000,000.00</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="progress flex-grow-1 me-2" style="height: 10px;">
                                                    <div class="progress-bar bg-success" role="progressbar"
                                                         style="width: 73%" aria-valuenow="73" aria-valuemin="0"
                                                         aria-valuemax="100"></div>
                                                </div>
                                                <span>73%</span>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Municipal</td>
                                        <td>S/ 9,650,000,000.00</td>
                                        <td>S/ 6,560,000,000.00</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="progress flex-grow-1 me-2" style="height: 10px;">
                                                    <div class="progress-bar bg-warning" role="progressbar"
                                                         style="width: 68%" aria-valuenow="68" aria-valuemin="0"
                                                         aria-valuemax="100"></div>
                                                </div>
                                                <span>68%</span>
                                            </div>
                                        </td>
                                    </tr>
                                    </tbody>
                                    <tfoot>
                                    <tr class="table-primary">
                                        <th>TOTAL</th>
                                        <th>S/ 130,850,000,000.00</th>
                                        <th>S/ 98,740,000,000.00</th>
                                        <th>
                                            <div class="d-flex align-items-center">
                                                <div class="progress flex-grow-1 me-2" style="height: 10px;">
                                                    <div class="progress-bar bg-success" role="progressbar"
                                                         style="width: 75%" aria-valuenow="75" aria-valuemin="0"
                                                         aria-valuemax="100"></div>
                                                </div>
                                                <span>75%</span>
                                            </div>
                                        </th>
                                    </tr>
                                    </tfoot>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
        </main>
    </div>
</div>

<!-- Modal Nuevo Informe -->
<div class="modal fade" id="nuevoInformeModal" tabindex="-1" aria-labelledby="nuevoInformeModalLabel"
     aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="nuevoInformeModalLabel"><i class="bi bi-file-earmark-plus me-2"></i>Nuevo
                    Informe</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/admin.do" method="post">
                <input type="hidden" name="accion" value="registrarInforme">
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="titulo" class="form-label">Título del Informe</label>
                            <input type="text" class="form-control" id="titulo" name="titulo" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="tipo" class="form-label">Tipo de Informe</label>
                            <select class="form-select" id="tipo" name="tipo" required>
                                <option value="presupuesto">Presupuestos por Nivel de Gobierno</option>
                                <option value="ejecucion">Ejecución Presupuestal</option>
                                <option value="solicitudes">Solicitudes de Información</option>
                                <option value="entidades">Entidades Públicas</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="anio" class="form-label">Año</label>
                            <select class="form-select" id="anio" name="anio" required>
                                <option value="<%= anioActual %>"><%= anioActual %>
                                </option>
                                <option value="<%= anioActual - 1 %>"><%= anioActual - 1 %>
                                </option>
                                <option value="<%= anioActual - 2 %>"><%= anioActual - 2 %>
                                </option>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="nivelGobiernoForm" class="form-label">Nivel de Gobierno</label>
                            <select class="form-select" id="nivelGobiernoForm" name="nivelGobierno" required>
                                <option value="Nacional">Nacional</option>
                                <option value="Regional">Regional</option>
                                <option value="Municipal">Municipal</option>
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
<div class="modal fade" id="eliminarInformeModal" tabindex="-1" aria-labelledby="eliminarInformeModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarInformeModalLabel"><i class="bi bi-exclamation-triangle me-2"></i>Confirmar
                    Eliminación</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro que desea eliminar el informe <strong id="tituloInformeEliminar"></strong>?</p>
                <p>Esta acción no se puede deshacer.</p>
            </div>
            <div class="modal-footer">
                <form action="<%= request.getContextPath() %>/admin.do" method="post">
                    <input type="hidden" name="accion" value="eliminarInforme">
                    <input type="hidden" name="id" id="idInformeEliminar">
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
<script src="https://cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"></script>

<!-- Script para los gráficos -->
<script>
    $(document).ready(function () {
        // Inicializar tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Inicializar DataTable en tabla de informes
        $('#tablaInformes').DataTable({
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json'
            },
            responsive: true,
            order: [[0, 'desc']]
        });

        <% if (!listaInformes.isEmpty() && listaInformes.get(0).getTipo().equals("presupuesto")) { %>
        // Gráfico de presupuesto por nivel
        const ctxPresupuesto = document.getElementById('presupuestoChart');
        new Chart(ctxPresupuesto, {
            type: 'doughnut',
            data: {
                labels: ['Nacional', 'Regional', 'Municipal'],
                datasets: [{
                    data: [78.3, 14.3, 7.4],
                    backgroundColor: [
                        'rgba(78, 115, 223, 0.8)',
                        'rgba(54, 185, 204, 0.8)',
                        'rgba(246, 194, 62, 0.8)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
        <% } %>

        // Gráfico de solicitudes por estado
        const ctxSolicitudesEstado = document.getElementById('solicitudesEstadoChart');
        new Chart(ctxSolicitudesEstado, {
            type: 'pie',
            data: {
                labels: ['Atendidas', 'En proceso', 'Pendientes', 'Observadas', 'Rechazadas'],
                datasets: [{
                    data: [68, 12, 10, 6, 4],
                    backgroundColor: [
                        'rgba(40, 167, 69, 0.8)',
                        'rgba(23, 162, 184, 0.8)',
                        'rgba(255, 193, 7, 0.8)',
                        'rgba(13, 110, 253, 0.8)',
                        'rgba(220, 53, 69, 0.8)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Gráfico de solicitudes por tipo
        const ctxSolicitudesTipo = document.getElementById('solicitudesTipoChart');
        new Chart(ctxSolicitudesTipo, {
            type: 'bar',
            data: {
                labels: ['Presupuestal', 'Proyectos', 'Contrataciones', 'Personal', 'General', 'Ambiental'],
                datasets: [{
                    label: 'Cantidad de solicitudes',
                    data: [35, 28, 22, 15, 18, 7],
                    backgroundColor: 'rgba(78, 115, 223, 0.8)',
                    borderWidth: 1
                }]
            },
            options: {
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Función para confirmar eliminación
        function confirmarEliminacion(id, titulo) {
            document.getElementById('idInformeEliminar').value = id;
            document.getElementById('tituloInformeEliminar').textContent = titulo;

            var eliminarModal = new bootstrap.Modal(document.getElementById('eliminarInformeModal'));
            eliminarModal.show();
        }
    });
</script>
</body>
</html>
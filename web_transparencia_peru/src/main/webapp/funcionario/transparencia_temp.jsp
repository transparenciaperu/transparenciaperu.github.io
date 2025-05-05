<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.DocumentoTransparenciaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.DocumentoTransparenciaModelo" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.EntidadPublicaModelo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%
    // Verificar si el usuario está en sesión y es funcionario
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("FUNCIONARIO")) {
        // No es funcionario o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Verificar si hay mensajes en la sesión
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");

    // Eliminar mensajes de la sesión después de obtenerlos
    if (mensaje != null) {
        session.removeAttribute("mensaje");
        session.removeAttribute("tipoMensaje");
    }

    // Obtener documentos de transparencia
    DocumentoTransparenciaModelo modeloDocumento = new DocumentoTransparenciaModelo();

    // Intentar crear la tabla si no existe
    try {
        modeloDocumento.crearTabla();
    } catch (Exception e) {
        // Ignora errores, la tabla puede ya existir
    }

    // Obtener lista de documentos por categoría
    Map<String, List<DocumentoTransparenciaEntidad>> documentosPorCategoria = new HashMap<>();
    documentosPorCategoria.put("datos-generales", modeloDocumento.listarPorCategoria("datos-generales"));
    documentosPorCategoria.put("planeamiento", modeloDocumento.listarPorCategoria("planeamiento"));
    documentosPorCategoria.put("presupuesto", modeloDocumento.listarPorCategoria("presupuesto"));
    documentosPorCategoria.put("proyectos", modeloDocumento.listarPorCategoria("proyectos"));
    documentosPorCategoria.put("contrataciones", modeloDocumento.listarPorCategoria("contrataciones"));
    documentosPorCategoria.put("personal", modeloDocumento.listarPorCategoria("personal"));

    // Obtener lista de entidades públicas
    EntidadPublicaModelo modeloEntidad = new EntidadPublicaModelo();
    List<EntidadPublicaEntidad> entidades = modeloEntidad.listarEntidades();

    // Formato para fechas
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Transparencia - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/funcionario.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
</head>
<body class="funcionario-theme">
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Gestión de Transparencia</a>
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
                        <a class="nav-link active" href="transparencia.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Gestión de Transparencia
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="solicitudes.jsp">
                            <i class="bi bi-envelope-open me-1"></i> Solicitudes de Información
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom title-section">
                <h1 class="h2">Gestión de Información de Transparencia</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button type="button" class="btn btn-primary" data-bs-toggle="modal"
                            data-bs-target="#publicarDocumentoModal">
                        <i class="bi bi-cloud-upload me-1"></i> Publicar Documento
                    </button>
                </div>
            </div>

            <% if (mensaje != null) { %>
            <div class="alert alert-<%= tipoMensaje != null ? tipoMensaje : "info" %> fade-in alert-dismissible fade show"
                 role="alert">
                <i class="bi bi-info-circle me-2"></i> <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <div class="alert alert-info fade-in mb-4">
                <div class="d-flex align-items-center">
                    <div class="me-3">
                        <i class="bi bi-info-circle-fill fs-3"></i>
                    </div>
                    <div>
                        <h5 class="mb-1">Portal de Transparencia Estándar</h5>
                        <p class="mb-0">De acuerdo a la Ley de Transparencia y Acceso a la Información Pública, todas
                            las entidades del Estado deben publicar y actualizar periódicamente la información en sus
                            portales de transparencia.</p>
                    </div>
                </div>
            </div>

            <!-- Pestañas de categorías -->
            <ul class="nav nav-tabs mb-4" id="categoriasTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="datos-generales-tab" data-bs-toggle="tab"
                            data-bs-target="#datos-generales"
                            type="button" role="tab" aria-controls="datos-generales" aria-selected="true">
                        Datos Generales
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="planeamiento-tab" data-bs-toggle="tab" data-bs-target="#planeamiento"
                            type="button" role="tab" aria-controls="planeamiento" aria-selected="false">
                        Planeamiento y Organización
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="presupuesto-tab" data-bs-toggle="tab" data-bs-target="#presupuesto"
                            type="button" role="tab" aria-controls="presupuesto" aria-selected="false">
                        Presupuesto
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="proyectos-tab" data-bs-toggle="tab" data-bs-target="#proyectos"
                            type="button" role="tab" aria-controls="proyectos" aria-selected="false">
                        Proyectos e Inversiones
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="contrataciones-tab" data-bs-toggle="tab"
                            data-bs-target="#contrataciones"
                            type="button" role="tab" aria-controls="contrataciones" aria-selected="false">
                        Contrataciones
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="personal-tab" data-bs-toggle="tab" data-bs-target="#personal"
                            type="button" role="tab" aria-controls="personal" aria-selected="false">
                        Personal
                    </button>
                </li>
            </ul>

            <!-- Contenido de las pestañas -->
            <div class="tab-content" id="categoriasTabsContent">
                <div class="tab-pane fade show active" id="datos-generales" role="tabpanel"
                     aria-labelledby="datos-generales-tab">
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Datos Generales de la Entidad</h6>
                            <div>
                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal"
                                        data-bs-target="#editarSeccionModal" data-seccion="datos-generales">
                                    <i class="bi bi-pencil-square me-1"></i> Editar
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Documento</th>
                                        <th>Descripción</th>
                                        <th>Fecha Publicación</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        List<DocumentoTransparenciaEntidad> documentosDatosGenerales = documentosPorCategoria.get("datos-generales");
                                        if (documentosDatosGenerales != null && !documentosDatosGenerales.isEmpty()) {
                                            for (DocumentoTransparenciaEntidad documento : documentosDatosGenerales) {
                                    %>
                                    <tr>
                                        <td><%= documento.getTitulo() %>
                                        </td>
                                        <td><%= documento.getDescripcion() %>
                                        </td>
                                        <td>
                                            <% if (documento.getFechaPublicacion() != null) { %>
                                            <%= formatoFecha.format(documento.getFechaPublicacion()) %>
                                            <% } else { %>
                                            No disponible
                                            <% } %>
                                        </td>
                                        <td><span
                                                class="badge bg-<%= documento.getEstado().equals("Publicado") ? "success" : "warning text-dark" %>">
                                            <%= documento.getEstado() %></span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal"
                                                    data-id="<%= documento.getId() %>"
                                                    data-titulo="<%= documento.getTitulo() %>">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="5" class="text-center">No hay documentos disponibles en esta
                                            categoría.
                                        </td>
                                    </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="planeamiento" role="tabpanel" aria-labelledby="planeamiento-tab">
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Planeamiento y Organización</h6>
                            <div>
                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal"
                                        data-bs-target="#editarSeccionModal" data-seccion="planeamiento">
                                    <i class="bi bi-pencil-square me-1"></i> Editar
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Documento</th>
                                        <th>Descripción</th>
                                        <th>Fecha Publicación</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>Instrumentos de Gestión</td>
                                        <td>ROF, MOF, CAP, MAPRO, Indicadores de Desempeño</td>
                                        <td>15/01/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Plan Estratégico Institucional</td>
                                        <td>Plan Estratégico Institucional 2023-2026</td>
                                        <td>20/01/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Plan Operativo Institucional</td>
                                        <td>Plan Operativo Institucional 2024</td>
                                        <td>05/02/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Organigrama</td>
                                        <td>Estructura organizacional de la entidad</td>
                                        <td>10/02/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="presupuesto" role="tabpanel" aria-labelledby="presupuesto-tab">
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Presupuesto</h6>
                            <div>
                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal"
                                        data-bs-target="#editarSeccionModal" data-seccion="presupuesto">
                                    <i class="bi bi-pencil-square me-1"></i> Editar
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Documento</th>
                                        <th>Descripción</th>
                                        <th>Fecha Publicación</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>Información Presupuestal</td>
                                        <td>Presupuesto Institucional de Apertura (PIA) 2024</td>
                                        <td>10/01/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Información Presupuestal</td>
                                        <td>Presupuesto Institucional Modificado (PIM) - I Trimestre 2024</td>
                                        <td>10/04/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ejecución de Gastos</td>
                                        <td>Ejecución del Presupuesto de Gastos - I Trimestre 2024</td>
                                        <td>15/04/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr class="table-warning">
                                        <td>Ejecución de Ingresos</td>
                                        <td>Ejecución del Presupuesto de Ingresos - I Trimestre 2024</td>
                                        <td>-</td>
                                        <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-upload"></i> Publicar
                                            </button>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="proyectos" role="tabpanel" aria-labelledby="proyectos-tab">
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Proyectos de Inversión e INFOBRAS</h6>
                            <div>
                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal"
                                        data-bs-target="#editarSeccionModal" data-seccion="proyectos">
                                    <i class="bi bi-pencil-square me-1"></i> Editar
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Documento</th>
                                        <th>Descripción</th>
                                        <th>Fecha Publicación</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        List<DocumentoTransparenciaEntidad> documentosProyectos = documentosPorCategoria.get("proyectos");
                                        if (documentosProyectos != null && !documentosProyectos.isEmpty()) {
                                            for (DocumentoTransparenciaEntidad documento : documentosProyectos) {
                                    %>
                                    <tr>
                                        <td><%= documento.getTitulo() %>
                                        </td>
                                        <td><%= documento.getDescripcion() %>
                                        </td>
                                        <td>
                                            <% if (documento.getFechaPublicacion() != null) { %>
                                            <%= formatoFecha.format(documento.getFechaPublicacion()) %>
                                            <% } else { %>
                                            No disponible
                                            <% } %>
                                        </td>
                                        <td><span
                                                class="badge bg-<%= documento.getEstado().equals("Publicado") ? "success" : "warning text-dark" %>"><%= documento.getEstado() %></span>
                                        </td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal"
                                                    data-id="<%= documento.getId() %>"
                                                    data-titulo="<%= documento.getTitulo() %>">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                    <tr>
                                        <td colspan="5" class="text-center">No hay documentos disponibles en esta
                                            categoría.
                                        </td>
                                    </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="contrataciones" role="tabpanel" aria-labelledby="contrataciones-tab">
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Información de Contrataciones</h6>
                            <div>
                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal"
                                        data-bs-target="#editarSeccionModal" data-seccion="contrataciones">
                                    <i class="bi bi-pencil-square me-1"></i> Editar
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Documento</th>
                                        <th>Descripción</th>
                                        <th>Fecha Publicación</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>Procesos de Selección</td>
                                        <td>Procesos de Selección de Bienes y Servicios - I Trimestre 2024</td>
                                        <td>15/04/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Ordenes de Compra</td>
                                        <td>Órdenes de Compra y Servicio - I Trimestre 2024</td>
                                        <td>20/04/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Penalidades Aplicadas</td>
                                        <td>Registro de penalidades aplicadas a proveedores - I Trimestre 2024</td>
                                        <td>25/04/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="tab-pane fade" id="personal" role="tabpanel" aria-labelledby="personal-tab">
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Información de Personal</h6>
                            <div>
                                <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal"
                                        data-bs-target="#editarSeccionModal" data-seccion="personal">
                                    <i class="bi bi-pencil-square me-1"></i> Editar
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th>Documento</th>
                                        <th>Descripción</th>
                                        <th>Fecha Publicación</th>
                                        <th>Estado</th>
                                        <th>Acciones</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <tr>
                                        <td>Remuneraciones</td>
                                        <td>Remuneraciones, bonificaciones y beneficios del personal</td>
                                        <td>15/03/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Personal por modalidad</td>
                                        <td>Relación de personal contratado (CAS, Locación, etc.)</td>
                                        <td>20/03/2024</td>
                                        <td><span class="badge bg-success">Publicado</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#editarDocumentoModal">
                                                <i class="bi bi-pencil"></i>
                                            </button>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr class="table-warning">
                                        <td>Personal para I Trimestre 2024</td>
                                        <td>Actualización trimestral de datos de personal</td>
                                        <td>-</td>
                                        <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-success" data-bs-toggle="modal"
                                                    data-bs-target="#publicarDocumentoModal">
                                                <i class="bi bi-upload"></i> Publicar
                                            </button>
                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modales -->
            <!-- Modal para publicar nuevo documento -->
            <div class="modal fade" id="publicarDocumentoModal" tabindex="-1"
                 aria-labelledby="publicarDocumentoModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="publicarDocumentoModalLabel">Publicar Documento de
                                Transparencia</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="formPublicarDocumento" action="<%= request.getContextPath() %>/funcionario.do"
                              method="post" enctype="multipart/form-data">
                            <input type="hidden" name="accion" value="publicarDocumento">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="categoriaDocumento" class="form-label">Categoría</label>
                                    <select class="form-select" id="categoriaDocumento" name="categoriaDocumento"
                                            required>
                                        <option value="">Seleccione una categoría</option>
                                        <option value="datos-generales">Datos Generales</option>
                                        <option value="planeamiento">Planeamiento y Organización</option>
                                        <option value="presupuesto">Presupuesto</option>
                                        <option value="proyectos">Proyectos e Inversiones</option>
                                        <option value="contrataciones">Contrataciones</option>
                                        <option value="personal">Personal</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="tituloDocumento" class="form-label">Título del Documento</label>
                                    <input type="text" class="form-control" id="tituloDocumento" name="tituloDocumento"
                                           required>
                                </div>

                                <div class="mb-3">
                                    <label for="descripcionDocumento" class="form-label">Descripción</label>
                                    <textarea class="form-control" id="descripcionDocumento" name="descripcionDocumento"
                                              rows="3" required></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="periodoReferencia" class="form-label">Periodo de Referencia</label>
                                    <input type="text" class="form-control" id="periodoReferencia"
                                           name="periodoReferencia" placeholder="Ej: I Trimestre 2024">
                                </div>

                                <div class="mb-3">
                                    <label for="fechaPublicacion" class="form-label">Fecha de Publicación</label>
                                    <input type="date" class="form-control" id="fechaPublicacion"
                                           name="fechaPublicacion" required>
                                </div>

                                <div class="mb-3">
                                    <label for="archivoDocumento" class="form-label">Archivo</label>
                                    <input type="file" class="form-control" id="archivoDocumento"
                                           name="archivoDocumento" required>
                                    <div class="form-text">Formatos permitidos: PDF, XLS, XLSX, DOC, DOCX. Tamaño
                                        máximo: 10MB.
                                    </div>
                                </div>

                                <div class="mb-3 form-check">
                                    <input type="checkbox" class="form-check-input" id="publicarInmediatamente"
                                           name="publicarInmediatamente" checked>
                                    <label class="form-check-label" for="publicarInmediatamente">Publicar
                                        inmediatamente</label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar
                                </button>
                                <button type="submit" class="btn btn-primary">Publicar Documento</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Modal para ver documento -->
            <div class="modal fade" id="verDocumentoModal" tabindex="-1" aria-labelledby="verDocumentoModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-xl">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="verDocumentoModalLabel">Detalles del Documento</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row mb-3">
                                <div class="col-md-8">
                                    <h5>Marco Legal</h5>
                                    <p class="text-muted">Normas de creación, organización y funcionamiento</p>
                                    <div class="mb-2">
                                        <strong>Categoría:</strong> Datos Generales
                                    </div>
                                    <div class="mb-2">
                                        <strong>Fecha de publicación:</strong> 15/01/2024
                                    </div>
                                    <div class="mb-2">
                                        <strong>Última actualización:</strong> 15/01/2024
                                    </div>
                                    <div class="mb-2">
                                        <strong>Publicado por:</strong> José García Morales
                                    </div>
                                </div>
                                <div class="col-md-4 text-end">
                                    <span class="badge bg-success mb-2">Publicado</span>
                                    <div class="btn-group-vertical w-100">
                                        <a href="#" class="btn btn-outline-primary mb-2">
                                            <i class="bi bi-download me-1"></i> Descargar Documento
                                        </a>
                                        <button class="btn btn-outline-secondary" data-bs-toggle="modal"
                                                data-bs-target="#editarDocumentoModal" data-dismiss="modal">
                                            <i class="bi bi-pencil me-1"></i> Editar Documento
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <hr>

                            <div class="document-preview">
                                <div class="ratio ratio-16x9">
                                    <iframe src="https://docs.google.com/viewer?url=https://example.com/sample.pdf&embedded=true"
                                            frameborder="0"></iframe>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal para editar documento -->
            <div class="modal fade" id="editarDocumentoModal" tabindex="-1" aria-labelledby="editarDocumentoModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editarDocumentoModalLabel">Editar Documento</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="formEditarDocumento" action="<%= request.getContextPath() %>/funcionario.do"
                              method="post" enctype="multipart/form-data">
                            <input type="hidden" name="accion" value="editarDocumento">
                            <input type="hidden" name="documentoId" value="1">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="editCategoriaDocumento" class="form-label">Categoría</label>
                                    <select class="form-select" id="editCategoriaDocumento" name="categoriaDocumento"
                                            required>
                                        <option value="datos-generales" selected>Datos Generales</option>
                                        <option value="planeamiento">Planeamiento y Organización</option>
                                        <option value="presupuesto">Presupuesto</option>
                                        <option value="proyectos">Proyectos e Inversiones</option>
                                        <option value="contrataciones">Contrataciones</option>
                                        <option value="personal">Personal</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label for="editTituloDocumento" class="form-label">Título del Documento</label>
                                    <input type="text" class="form-control" id="editTituloDocumento"
                                           name="tituloDocumento" value="Marco Legal" required>
                                </div>

                                <div class="mb-3">
                                    <label for="editDescripcionDocumento" class="form-label">Descripción</label>
                                    <textarea class="form-control" id="editDescripcionDocumento"
                                              name="descripcionDocumento" rows="3" required>Normas de creación, organización y funcionamiento</textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="editPeriodoReferencia" class="form-label">Periodo de Referencia</label>
                                    <input type="text" class="form-control" id="editPeriodoReferencia"
                                           name="periodoReferencia" value="2024">
                                </div>

                                <div class="mb-3">
                                    <label for="editFechaPublicacion" class="form-label">Fecha de Publicación</label>
                                    <input type="date" class="form-control" id="editFechaPublicacion"
                                           name="fechaPublicacion" value="2024-01-15" required>
                                </div>

                                <div class="mb-3">
                                    <label for="editArchivoDocumento" class="form-label">Reemplazar Archivo</label>
                                    <input type="file" class="form-control" id="editArchivoDocumento"
                                           name="archivoDocumento">
                                    <div class="form-text">Deje en blanco si no desea cambiar el archivo actual.</div>
                                </div>

                                <div class="mb-3 form-check">
                                    <input type="checkbox" class="form-check-input" id="editEstadoDocumento"
                                           name="estadoDocumento" checked>
                                    <label class="form-check-label" for="editEstadoDocumento">Publicado</label>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar
                                </button>
                                <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Modal para confirmar eliminación -->
            <div class="modal fade" id="eliminarDocumentoModal" tabindex="-1"
                 aria-labelledby="eliminarDocumentoModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="eliminarDocumentoModalLabel">Confirmar Eliminación</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="alert alert-danger">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <strong>¡Atención!</strong> Esta acción no se puede deshacer.
                            </div>
                            <p>¿Está seguro que desea eliminar el documento <strong>"Marco Legal"</strong>?</p>
                            <p>Este documento será eliminado del portal de transparencia y ya no estará disponible para
                                los ciudadanos.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="button" class="btn btn-danger" id="confirmarEliminacion">
                                <i class="bi bi-trash me-1"></i> Eliminar Documento
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal para editar sección -->
            <div class="modal fade" id="editarSeccionModal" tabindex="-1" aria-labelledby="editarSeccionModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editarSeccionModalLabel">Configuración de Sección</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="mb-3">
                                <label for="tituloSeccion" class="form-label">Título de la Sección</label>
                                <input type="text" class="form-control" id="tituloSeccion" value="Datos Generales">
                            </div>
                            <div class="mb-3">
                                <label for="descripcionSeccion" class="form-label">Descripción</label>
                                <textarea class="form-control" id="descripcionSeccion" rows="3">Información general de la entidad según lo establecido en la Ley de Transparencia.</textarea>
                            </div>
                            <div class="mb-3">
                                <label for="ordenSeccion" class="form-label">Orden de visualización</label>
                                <input type="number" class="form-control" id="ordenSeccion" min="1" value="1">
                            </div>
                            <div class="mb-3 form-check">
                                <input type="checkbox" class="form-check-input" id="seccionVisible" checked>
                                <label class="form-check-label" for="seccionVisible">Sección visible en portal
                                    público</label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="button" class="btn btn-primary">Guardar Cambios</button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
<script>
    $(document).ready(function () {
        // Manejar la eliminación de documentos
        $('#confirmarEliminacion').click(function () {
            // Aquí iría la lógica para eliminar el documento
            // Por ahora, simplemente cerramos el modal y mostramos un mensaje
            $('#eliminarDocumentoModal').modal('hide');

            const alerta = `<div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> El documento ha sido eliminado correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>`;

            $('main').prepend(alerta);

            // Eliminar la fila correspondiente en la tabla (en un caso real esto se haría después de confirmar la eliminación desde el servidor)
            // $("tr").has("button[data-id='1']").remove();
        });

        // Configurar datos dinámicos al abrir los modales
        $('#editarSeccionModal').on('show.bs.modal', function (e) {
            const seccion = $(e.relatedTarget).data('seccion');

            // Aquí se cargarían los datos reales de la sección desde el servidor
            const secciones = {
                'datos-generales': {
                    titulo: 'Datos Generales',
                    descripcion: 'Información general de la entidad según lo establecido en la Ley de Transparencia.',
                    orden: 1
                },
                'planeamiento': {
                    titulo: 'Planeamiento y Organización',
                    descripcion: 'Información sobre instrumentos de gestión, planes estratégicos y estructura organizativa.',
                    orden: 2
                },
                'presupuesto': {
                    titulo: 'Presupuesto',
                    descripcion: 'Información presupuestal de la entidad.',
                    orden: 3
                },
                'proyectos': {
                    titulo: 'Proyectos e Inversiones',
                    descripcion: 'Información sobre proyectos de inversión e INFOBRAS.',
                    orden: 4
                },
                'contrataciones': {
                    titulo: 'Contrataciones',
                    descripcion: 'Información sobre procesos de selección y adquisiciones.',
                    orden: 5
                },
                'personal': {titulo: 'Personal', descripcion: 'Información sobre personal y remuneraciones.', orden: 6}
            };

            const seccionData = secciones[seccion] || secciones['datos-generales'];

            $('#tituloSeccion').val(seccionData.titulo);
            $('#descripcionSeccion').val(seccionData.descripcion);
            $('#ordenSeccion').val(seccionData.orden);
        });

        // Inicializar DataTables en las tablas
        $('table:not(.dataTable)').each(function () {
            $(this).DataTable({
                "language": {
                    "url": "//cdn.datatables.net/plug-ins/1.13.7/i18n/es-ES.json"
                },
                "pageLength": 5,
                "lengthChange": false,
                "searching": false,
                "info": false,
                "paging": true
            });
        });

        // Establecer la fecha actual por defecto en los campos de fecha
        const today = new Date();
        const formattedDate = today.toISOString().substr(0, 10);
        $('#fechaPublicacion').val(formattedDate);

        // Validación de formularios
        const formPublicar = document.getElementById('formPublicarDocumento');
        if (formPublicar) {
            formPublicar.addEventListener('submit', function (event) {
                if (!formPublicar.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                formPublicar.classList.add('was-validated');
            }, false);
        }

        const formEditar = document.getElementById('formEditarDocumento');
        if (formEditar) {
            formEditar.addEventListener('submit', function (event) {
                if (!formEditar.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                formEditar.classList.add('was-validated');
            }, false);
        }
    });
</script>
</body>
</html>
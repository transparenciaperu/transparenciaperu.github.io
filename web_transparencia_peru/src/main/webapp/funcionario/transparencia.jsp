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
    <meta name="context-path" content="<%= request.getContextPath() %>">
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
                    <li class="nav-item">
                        <a class="nav-link" href="reportes.jsp">
                            <i class="bi bi-bar-chart me-1"></i> Reportes
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

                        <!-- Sección para debug -->
                        <div class="modal-footer bg-light border-top border-bottom">
                            <div class="container-fluid">
                                <div class="row">
                                    <div class="col-12">
                                        <details>
                                            <summary class="text-muted small">Información de depuración</summary>
                                            <div class="mt-2">
                                                <pre id="debugDocumentoInfo"
                                                     class="bg-dark text-light p-3 rounded small"
                                                     style="max-height: 200px; overflow-y: auto;"></pre>
                                            </div>
                                        </details>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- AJAX Mock Response (para simular respuesta del servidor) -->
                        <script type="text/template" id="mockDocumentoData">
                            {
                            "id": {{id}},
                            "titulo": "{{titulo}}",
                            "descripcion": "{{descripcion}}",
                            "categoria": "{{categoria}}",
                            "periodoReferencia": "{{periodoReferencia}}",
                            "fechaPublicacion": "{{fechaPublicacion}}",
                            "rutaArchivo": "{{rutaArchivo}}",
                            "tipoArchivo": "{{tipoArchivo}}",
                            "estado": "{{estado}}"
                            }
                        </script>
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
                                    <%
                                        List<DocumentoTransparenciaEntidad> documentosPlaneamiento = documentosPorCategoria.get("planeamiento");
                                        if (documentosPlaneamiento != null && !documentosPlaneamiento.isEmpty()) {
                                            for (DocumentoTransparenciaEntidad documento : documentosPlaneamiento) {
                                    %>
                                    <tr<%= documento.getEstado().equals("Pendiente") ? " class=\"table-warning\"" : "" %>>
                                        <td><%= documento.getTitulo() %>
                                        </td>
                                        <td><%= documento.getDescripcion() %>
                                        </td>
                                        <td>
                                            <% if (documento.getFechaPublicacion() != null) { %>
                                            <%= formatoFecha.format(documento.getFechaPublicacion()) %>
                                            <% } else { %>
                                            -
                                            <% } %>
                                        </td>
                                        <td><span
                                                class="badge bg-<%= documento.getEstado().equals("Publicado") ? "success" : "warning text-dark" %>">
                                            <%= documento.getEstado() %></span>
                                        </td>
                                        <td>
                                            <% if (documento.getEstado().equals("Publicado")) { %>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <% } %>
                                            <button class="btn btn-sm btn-<%= documento.getEstado().equals("Publicado") ? "success" : "primary" %>"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="<%= documento.getEstado().equals("Publicado") ? "#editarDocumentoModal" : "#publicarDocumentoModal" %>"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-<%= documento.getEstado().equals("Publicado") ? "pencil" : "upload" %>"></i><%= documento.getEstado().equals("Publicado") ? "" : " Publicar" %>
                                            </button>
                                            <% if (documento.getEstado().equals("Publicado")) { %>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal"
                                                    data-id="<%= documento.getId() %>"
                                                    data-titulo="<%= documento.getTitulo() %>">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                            <% } %>
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
                                    <%
                                        List<DocumentoTransparenciaEntidad> documentosPresupuesto = documentosPorCategoria.get("presupuesto");
                                        if (documentosPresupuesto != null && !documentosPresupuesto.isEmpty()) {
                                            for (DocumentoTransparenciaEntidad documento : documentosPresupuesto) {
                                    %>
                                    <tr<%= documento.getEstado().equals("Pendiente") ? " class=\"table-warning\"" : "" %>>
                                        <td><%= documento.getTitulo() %>
                                        </td>
                                        <td><%= documento.getDescripcion() %>
                                        </td>
                                        <td>
                                            <% if (documento.getFechaPublicacion() != null) { %>
                                            <%= formatoFecha.format(documento.getFechaPublicacion()) %>
                                            <% } else { %>
                                            -
                                            <% } %>
                                        </td>
                                        <td><span
                                                class="badge bg-<%= documento.getEstado().equals("Publicado") ? "success" : "warning text-dark" %>">
                                            <%= documento.getEstado() %></span>
                                        </td>
                                        <td>
                                            <% if (documento.getEstado().equals("Publicado")) { %>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <% } %>
                                            <button class="btn btn-sm btn-<%= documento.getEstado().equals("Publicado") ? "success" : "primary" %>"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="<%= documento.getEstado().equals("Publicado") ? "#editarDocumentoModal" : "#publicarDocumentoModal" %>"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-<%= documento.getEstado().equals("Publicado") ? "pencil" : "upload" %>"></i><%= documento.getEstado().equals("Publicado") ? "" : " Publicar" %>
                                            </button>
                                            <% if (documento.getEstado().equals("Publicado")) { %>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal"
                                                    data-id="<%= documento.getId() %>"
                                                    data-titulo="<%= documento.getTitulo() %>">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                            <% } %>
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
                                    <%
                                        List<DocumentoTransparenciaEntidad> documentosContrataciones = documentosPorCategoria.get("contrataciones");
                                        if (documentosContrataciones != null && !documentosContrataciones.isEmpty()) {
                                            for (DocumentoTransparenciaEntidad documento : documentosContrataciones) {
                                    %>
                                    <tr<%= documento.getEstado().equals("Pendiente") ? " class=\"table-warning\"" : "" %>>
                                        <td><%= documento.getTitulo() %>
                                        </td>
                                        <td><%= documento.getDescripcion() %>
                                        </td>
                                        <td>
                                            <% if (documento.getFechaPublicacion() != null) { %>
                                            <%= formatoFecha.format(documento.getFechaPublicacion()) %>
                                            <% } else { %>
                                            -
                                            <% } %>
                                        </td>
                                        <td><span
                                                class="badge bg-<%= documento.getEstado().equals("Publicado") ? "success" : "warning text-dark" %>">
                                            <%= documento.getEstado() %></span>
                                        </td>
                                        <td>
                                            <% if (documento.getEstado().equals("Publicado")) { %>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <% } %>
                                            <button class="btn btn-sm btn-<%= documento.getEstado().equals("Publicado") ? "success" : "primary" %>"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="<%= documento.getEstado().equals("Publicado") ? "#editarDocumentoModal" : "#publicarDocumentoModal" %>"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-<%= documento.getEstado().equals("Publicado") ? "pencil" : "upload" %>"></i><%= documento.getEstado().equals("Publicado") ? "" : " Publicar" %>
                                            </button>
                                            <% if (documento.getEstado().equals("Publicado")) { %>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal"
                                                    data-id="<%= documento.getId() %>"
                                                    data-titulo="<%= documento.getTitulo() %>">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                            <% } %>
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
                                    <%
                                        List<DocumentoTransparenciaEntidad> documentosPersonal = documentosPorCategoria.get("personal");
                                        if (documentosPersonal != null && !documentosPersonal.isEmpty()) {
                                            for (DocumentoTransparenciaEntidad documento : documentosPersonal) {
                                    %>
                                    <tr<%= documento.getEstado().equals("Pendiente") ? " class=\"table-warning\"" : "" %>>
                                        <td><%= documento.getTitulo() %>
                                        </td>
                                        <td><%= documento.getDescripcion() %>
                                        </td>
                                        <td>
                                            <% if (documento.getFechaPublicacion() != null) { %>
                                            <%= formatoFecha.format(documento.getFechaPublicacion()) %>
                                            <% } else { %>
                                            -
                                            <% } %>
                                        </td>
                                        <td><span
                                                class="badge bg-<%= documento.getEstado().equals("Publicado") ? "success" : "warning text-dark" %>">
                                            <%= documento.getEstado() %></span>
                                        </td>
                                        <td>
                                            <% if (documento.getEstado().equals("Publicado")) { %>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                                    data-bs-target="#verDocumentoModal"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-eye"></i>
                                            </button>
                                            <% } %>
                                            <button class="btn btn-sm btn-<%= documento.getEstado().equals("Publicado") ? "success" : "primary" %>"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="<%= documento.getEstado().equals("Publicado") ? "#editarDocumentoModal" : "#publicarDocumentoModal" %>"
                                                    data-id="<%= documento.getId() %>">
                                                <i class="bi bi-<%= documento.getEstado().equals("Publicado") ? "pencil" : "upload" %>"></i><%= documento.getEstado().equals("Publicado") ? "" : " Publicar" %>
                                            </button>
                                            <% if (documento.getEstado().equals("Publicado")) { %>
                                            <button class="btn btn-sm btn-danger" data-bs-toggle="modal"
                                                    data-bs-target="#eliminarDocumentoModal"
                                                    data-id="<%= documento.getId() %>"
                                                    data-titulo="<%= documento.getTitulo() %>">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                            <% } %>
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
                            <!-- Campo oculto para la ruta del archivo -->
                            <input type="hidden" id="editRutaArchivo" name="rutaArchivo" value="">
                            <!-- Campo oculto para el tipo de archivo -->
                            <input type="hidden" id="editTipoArchivo" name="tipoArchivo" value="">
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
                            <!-- Spinner de carga -->
                            <div id="loadingDocumentoDetalles" class="text-center">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Cargando...</span>
                                </div>
                                <p class="mt-2">Cargando información...</p>
                            </div>

                            <!-- Contenido del documento -->
                            <div id="contenidoDocumentoDetalles" style="display:none;">
                                <div class="card mb-4">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0" id="tituloDocumentoDetalle">Título del documento</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3" id="descripcionDocumentoDetalle"></div>

                                        <div class="row">
                                            <div class="col-md-6">
                                                <ul class="list-group mb-3">
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        <strong>ID:</strong>
                                                        <span id="idDocumentoDetalle" class="badge bg-secondary"></span>
                                                    </li>
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        <strong>Categoría:</strong>
                                                        <span id="categoriaDocumentoDetalle"></span>
                                                    </li>
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        <strong>Período de Referencia:</strong>
                                                        <span id="periodoDocumentoDetalle"></span>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="col-md-6">
                                                <ul class="list-group mb-3">
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        <strong>Fecha de publicación:</strong>
                                                        <span id="fechaDocumentoDetalle"></span>
                                                    </li>
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        <strong>Estado:</strong>
                                                        <span id="estadoDocumentoDetalle"></span>
                                                    </li>
                                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                                        <strong>Publicado por:</strong>
                                                        <span id="autorDocumentoDetalle"></span>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>

                                        <div class="mt-3" id="archivoDocumentoDetalle">
                                            <!-- Aquí va el enlace al archivo -->
                                        </div>
                                    </div>
                                </div>

                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h5 class="mb-0">Vista previa</h5>
                                    </div>
                                    <div class="card-body p-0">
                                        <div class="ratio ratio-16x9 border">
                                            <iframe id="previewDocumentoDetalle" src="" allowfullscreen></iframe>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Mensaje de error -->
                            <div id="errorDocumentoDetalles" class="alert alert-danger" style="display:none;">
                                <h5><i class="bi bi-exclamation-triangle-fill me-2"></i> Error</h5>
                                <p id="mensajeErrorDocumento">No se pudo cargar la información del documento.</p>
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
                            <input type="hidden" name="documentoId" id="editDocumentoId" value="">
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="editCategoriaDocumento" class="form-label">Categoría</label>
                                    <select class="form-select" id="editCategoriaDocumento" name="categoriaDocumento"
                                            required disabled>
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
                                           name="tituloDocumento" value="" required>
                                </div>

                                <div class="mb-3">
                                    <label for="editDescripcionDocumento" class="form-label">Descripción</label>
                                    <textarea class="form-control" id="editDescripcionDocumento"
                                              name="descripcionDocumento" rows="3" required></textarea>
                                </div>

                                <div class="mb-3">
                                    <label for="editPeriodoReferencia" class="form-label">Periodo de Referencia</label>
                                    <input type="text" class="form-control" id="editPeriodoReferencia"
                                           name="periodoReferencia" value="">
                                </div>

                                <div class="mb-3">
                                    <label for="editFechaPublicacion" class="form-label">Fecha de Publicación</label>
                                    <input type="date" class="form-control" id="editFechaPublicacion"
                                           name="fechaPublicacion" value="" required>
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
                            <p>¿Está seguro que desea eliminar el documento <strong
                                    id="nombreDocumentoEliminar"></strong>?</p>
                            <p>Este documento será eliminado del portal de transparencia y ya no estará disponible para
                                los ciudadanos.</p>
                        </div>
                        <form id="formEliminarDocumento" action="<%= request.getContextPath() %>/funcionario.do"
                              method="post">
                            <input type="hidden" name="accion" value="eliminarDocumento">
                            <input type="hidden" name="id" id="documentoIdEliminar" value="0">
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar
                                </button>
                                <button type="submit" class="btn btn-danger" id="confirmarEliminacion">
                                    <i class="bi bi-trash me-1"></i> Eliminar Documento
                                </button>
                            </div>
                        </form>
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
<script src="<%= request.getContextPath() %>/js/documento-visor.js"></script>
<script src="<%= request.getContextPath() %>/js/transparencia-page.js"></script>
<script>
    $(document).ready(function () {
        // Manejar la eliminación de documentos
        $('#eliminarDocumentoModal').on('show.bs.modal', function (e) {
            // Aquí iría la lógica para eliminar el documento
            const button = $(e.relatedTarget);
            const id = button.data('id') || 0;
            const titulo = button.data('titulo');

            if (id && id > 0) {
                $('#documentoIdEliminar').val(id);
                $('#nombreDocumentoEliminar').text('"' + (titulo || 'documento seleccionado') + '"');
            } else {
                $('#documentoIdEliminar').val(0);
                $('#nombreDocumentoEliminar').text('documento');
            }
        });

        // Manejar el modal de visualización de documento
        $('#verDocumentoModal').on('show.bs.modal', function (e) {
            const button = $(e.relatedTarget);
            const documentoId = button.data('id') || 0;

            // Mostrar spinner de carga y ocultar detalles
            $('#loadingDocumento').removeClass('d-none');
            $('#detallesDocumento').addClass('d-none');

            if (documentoId && documentoId > 0) {
                // En un caso real, aquí se haría una petición AJAX para obtener los detalles del documento
                // del servidor usando el ID

                // Simulamos una demora de carga real (500ms)
                setTimeout(function () {
                    // Obtener información del documento de la fila seleccionada
                    const titulo = button.closest('tr').find('td:nth-child(1)').text().trim();
                    const descripcion = button.closest('tr').find('td:nth-child(2)').text().trim();
                    const fechaPublicacion = button.closest('tr').find('td:nth-child(3)').text().trim();
                    const estado = button.closest('tr').find('td:nth-child(4)').text().trim();
                    const categoria = $('#' + button.closest('.tab-pane').attr('id') + '-tab').text().trim();

                    // Llenar la información en el modal
                    let html = `
                        <h5>${titulo}</h5>
                        <p class="text-muted mb-3">${descripcion}</p>
                        <div class="mb-2">
                            <strong>ID del documento:</strong> ${documentoId}
                        </div>
                        <div class="mb-2">
                            <strong>Categoría:</strong> ${categoria}
                        </div>
                        <div class="mb-2">
                            <strong>Fecha de publicación:</strong> ${fechaPublicacion}
                        </div>
                        <div class="mb-2">
                            <strong>Estado:</strong> ${estado}
                        </div>
                    `;

                    $('#infoDocumento').html(html);
                    $('#visorDocumento').attr('src', 'https://docs.google.com/viewer?embedded=true');

                    // Ocultar spinner y mostrar detalles
                    $('#loadingDocumento').addClass('d-none');
                    $('#detallesDocumento').removeClass('d-none');
                }, 500);
            }
        });

        // Manejar el modal de edición
        $('#editarDocumentoModal').on('show.bs.modal', function (e) {
            const button = $(e.relatedTarget);
            const id = button.data('id') || '';

            if (id) {
                // Establecer el ID del documento a editar
                $('#editDocumentoId').val(id);

                // Debería hacerse una petición AJAX para obtener todos los datos del documento
                // Por ahora, obtenemos los datos visibles en la tabla
                const fila = button.closest('tr');
                const titulo = fila.find('td:nth-child(1)').text().trim();
                const descripcion = fila.find('td:nth-child(2)').text().trim();
                let fechaPublicacion = fila.find('td:nth-child(3)').text().trim();

                // Convertir fecha del formato dd/mm/yyyy a yyyy-mm-dd para el input date
                if (fechaPublicacion && fechaPublicacion !== 'No disponible' && fechaPublicacion !== '-') {
                    const partes = fechaPublicacion.split('/');
                    if (partes.length === 3) {
                        fechaPublicacion = `${partes[2]}-${partes[1].padStart(2, '0')}-${partes[0].padStart(2, '0')}`;
                    } else {
                        // Si la fecha no tiene el formato esperado, usamos la fecha actual
                        const hoy = new Date();
                        fechaPublicacion = hoy.toISOString().split('T')[0];
                    }
                } else {
                    // Si no hay fecha, usar la fecha actual
                    const hoy = new Date();
                    fechaPublicacion = hoy.toISOString().split('T')[0];
                }

                $('#editTituloDocumento').val(titulo);
                $('#editDescripcionDocumento').val(descripcion);
                $('#editFechaPublicacion').val(fechaPublicacion);
                $('#editPeriodoReferencia').val(''); // Dejamos en blanco si no tenemos el dato
            }
        });

        // Manejar el formulario de eliminación
        $('#formEliminarDocumento').on('submit', function (e) {
            // Validar que haya un ID de documento antes de enviar
            const idDocumento = $('#documentoIdEliminar').val();

            if (!idDocumento || idDocumento === '0' || idDocumento === 0) {
                e.preventDefault();
                alert('Error: No se ha seleccionado ningún documento para eliminar');
            } else if (isNaN(parseInt(idDocumento))) {
                e.preventDefault();
                alert('Error: No se ha seleccionado ningún documento para eliminar');
            }
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

    // Manejar la visualización del documento
    $('#verDocumentoModal').on('show.bs.modal', function (e) {
        const button = $(e.relatedTarget);
        const documentoId = button.data('id') || 0;

        // Mostrar spinner de carga y ocultar detalles
        $('#loadingDocumento').removeClass('d-none');
        $('#detallesDocumento').addClass('d-none');

        if (documentoId && documentoId > 0) {
            // Hacer petición AJAX para obtener los detalles del documento
            $.ajax({
                url: '<%= request.getContextPath() %>/funcionario.do',
                type: 'GET',
                dataType: 'json',
                data: {
                    accion: 'verDocumento',
                    id: documentoId,
                    format: 'json'
                },
                success: function (data) {
                    // Llenar la información en el modal
                    let html = `
                        <h5>${data.titulo}</h5>
                        <p class="text-muted mb-3">${data.descripcion}</p>
                        <div class="mb-2">
                            <strong>ID del documento:</strong> ${data.id}
                        </div>
                        <div class="mb-2">
                            <strong>Categoría:</strong> ${data.categoria}
                        </div>
                        <div class="mb-2">
                            <strong>Periodo de Referencia:</strong> ${data.periodoReferencia || 'No especificado'}
                        </div>
                        <div class="mb-2">
                            <strong>Fecha de publicación:</strong> ${data.fechaPublicacion || 'No disponible'}
                        </div>
                        <div class="mb-2">
                            <strong>Estado:</strong> ${data.estado}
                        </div>
                        <div class="mb-2">
                            <strong>Archivo:</strong> <a href="${data.rutaArchivo}" target="_blank">${data.rutaArchivo}</a>
                        </div>
                    `;

                    $('#infoDocumento').html(html);

                    // Actualizar el visor de documentos
                    if (data.tipoArchivo && data.tipoArchivo.includes('pdf')) {
                        $('#visorDocumento').attr('src', '<%= request.getContextPath() %>/' + data.rutaArchivo);
                    } else {
                        $('#visorDocumento').attr('src', 'https://docs.google.com/viewer?embedded=true&url=' +
                            encodeURIComponent(window.location.origin + '<%= request.getContextPath() %>/' + data.rutaArchivo));
                    }

                    // Ocultar spinner y mostrar detalles
                    $('#loadingDocumento').addClass('d-none');
                    $('#detallesDocumento').removeClass('d-none');

                    // También actualizar el área de depuración
                    $('#debugDocumentoInfo').text(JSON.stringify(data, null, 2));
                },
                error: function () {
                    // Mostrar mensaje de error
                    $('#infoDocumento').html('<div class="alert alert-danger">Error al cargar los detalles del documento.</div>');
                    $('#loadingDocumento').addClass('d-none');
                    $('#detallesDocumento').removeClass('d-none');
                }
            });
        }
    });

    // Manejar el modal de edición
    $('#editarDocumentoModal').on('show.bs.modal', function (e) {
        const button = $(e.relatedTarget);
        const id = button.data('id') || 0;

        if (id && id > 0) {
            // Establecer el ID del documento a editar
            $('#editDocumentoId').val(id);

            // Hacer petición AJAX para obtener los datos del documento
            $.ajax({
                url: '<%= request.getContextPath() %>/funcionario.do',
                type: 'GET',
                dataType: 'json',
                data: {
                    accion: 'verDocumento',
                    id: id,
                    format: 'json'
                },
                success: function (data) {
                    // Llenar los campos del formulario con los datos del documento
                    $('#editTituloDocumento').val(data.titulo);
                    $('#editDescripcionDocumento').val(data.descripcion);

                    // Seleccionar la categoría correcta
                    $('#editCategoriaDocumento').val(data.categoria);
                    $('#editCategoriaDocumento').prop('disabled', false);

                    // Establece período de referencia
                    $('#editPeriodoReferencia').val(data.periodoReferencia);

                    // Convertir fecha al formato yyyy-mm-dd para el input date
                    if (data.fechaPublicacion) {
                        $('#editFechaPublicacion').val(data.fechaPublicacion);
                    }

                    // Estado del documento (checkbox)
                    $('#editEstadoDocumento').prop('checked', data.estado === 'Publicado');

                    // Campo oculto para la ruta del archivo
                    $('#editRutaArchivo').val(data.rutaArchivo);

                    // Campo oculto para el tipo de archivo
                    $('#editTipoArchivo').val(data.tipoArchivo);

                    // Mostrar el nombre del archivo actual
                    if (data.rutaArchivo) {
                        // Primero eliminamos cualquier mensaje anterior
                        $('#editArchivoDocumento').next('.form-text').nextAll('.form-text').remove();

                        const nombreArchivo = data.rutaArchivo.split('/').pop();
                        $('<div class="form-text mt-2">Archivo actual: <strong>' + nombreArchivo + '</strong></div>')
                            .insertAfter($('#editArchivoDocumento').next('.form-text'));
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error al cargar los datos del documento:', error);
                    alert('Error al cargar los datos del documento. Consulte la consola para más detalles.');
                }
            });
        }
    });

    // Limpiar información adicional al cerrar el modal de edición
    $('#editarDocumentoModal').on('hidden.bs.modal', function () {
        $('#editArchivoDocumento').next('.form-text').nextAll('.form-text').remove();
    });
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.InformeEntidad" %>
<%@ page import="java.util.Date" %>
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

    // Obtener el informe de los atributos de solicitud
    InformeEntidad informe = (InformeEntidad) request.getAttribute("informe");
    if (informe == null) {
        // Si no hay informe, redirigir a la lista
        response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
        return;
    }

    // Formato para fechas
    SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat formatoFechaVisual = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Informe - Portal de Transparencia Perú</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios">
                            <i class="bi bi-people me-1"></i> Gestión de Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/entidades.jsp">
                            <i class="bi bi-building me-1"></i> Entidades Públicas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/ciudadanos.jsp">
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
                        <a class="nav-link active"
                           href="<%= request.getContextPath() %>/admin.do?accion=listarInformes">
                            <i class="bi bi-graph-up me-1"></i> Informes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin/configuracion.jsp">
                            <i class="bi bi-gear me-1"></i> Configuración
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom title-section">
                <div>
                    <h1 class="h2">Editar Informe</h1>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="<%= request.getContextPath() %>/admin/informes.jsp">Informes</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Editar informe</li>
                        </ol>
                    </nav>
                </div>
            </div>

            <!-- Formulario de edición -->
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Actualizar Informe</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin.do" method="post">
                        <input type="hidden" name="accion" value="actualizarInforme">
                        <input type="hidden" name="id" value="<%= informe.getId() %>">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="titulo" class="form-label">Título del Informe</label>
                                <input type="text" class="form-control" id="titulo" name="titulo"
                                       value="<%= informe.getTitulo() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label for="tipo" class="form-label">Tipo de Informe</label>
                                <select class="form-select" id="tipo" name="tipo" required>
                                    <option value="presupuesto" <%= informe.getTipo().equals("presupuesto") ? "selected" : "" %>>
                                        Presupuestos por Nivel de Gobierno
                                    </option>
                                    <option value="ejecucion" <%= informe.getTipo().equals("ejecucion") ? "selected" : "" %>>
                                        Ejecución Presupuestal
                                    </option>
                                    <option value="solicitudes" <%= informe.getTipo().equals("solicitudes") ? "selected" : "" %>>
                                        Solicitudes de Información
                                    </option>
                                    <option value="entidades" <%= informe.getTipo().equals("entidades") ? "selected" : "" %>>
                                        Entidades Públicas
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="anio" class="form-label">Año</label>
                                <input type="number" class="form-control" id="anio" name="anio"
                                       value="<%= informe.getAnio() %>" min="2000" max="2050" required>
                            </div>
                            <div class="col-md-4">
                                <label for="nivelGobierno" class="form-label">Nivel de Gobierno</label>
                                <select class="form-select" id="nivelGobierno" name="nivelGobierno" required>
                                    <option value="Nacional" <%= informe.getNivelGobierno().equals("Nacional") ? "selected" : "" %>>
                                        Nacional
                                    </option>
                                    <option value="Regional" <%= informe.getNivelGobierno().equals("Regional") ? "selected" : "" %>>
                                        Regional
                                    </option>
                                    <option value="Municipal" <%= informe.getNivelGobierno().equals("Municipal") ? "selected" : "" %>>
                                        Municipal
                                    </option>
                                    <option value="Todos" <%= informe.getNivelGobierno().equals("Todos") ? "selected" : "" %>>
                                        Todos
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="estado" class="form-label">Estado</label>
                                <select class="form-select" id="estado" name="estado" required>
                                    <option value="Activo" <%= informe.getEstado().equals("Activo") ? "selected" : "" %>>
                                        Activo
                                    </option>
                                    <option value="Inactivo" <%= informe.getEstado().equals("Inactivo") ? "selected" : "" %>>
                                        Inactivo
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="descripcion" class="form-label">Descripción</label>
                            <textarea class="form-control" id="descripcion" name="descripcion"
                                      rows="3"><%= informe.getDescripcion() != null ? informe.getDescripcion() : "" %></textarea>
                        </div>

                        <div class="mb-3">
                            <label for="datosJson" class="form-label">Datos del informe (formato JSON)</label>
                            <textarea class="form-control" id="datosJson" name="datosJson"
                                      rows="5"><%= informe.getDatosJson() != null ? informe.getDatosJson() : "" %></textarea>
                            <div class="form-text">Formato esperado: {"labels": ["Etiqueta1", "Etiqueta2"], "datos":
                                [valor1, valor2]}
                            </div>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                            <a href="<%= request.getContextPath() %>/admin/informes.jsp"
                               class="btn btn-secondary me-md-2">
                                <i class="bi bi-x-circle me-1"></i> Cancelar
                            </a>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save me-1"></i> Guardar Cambios
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function () {
        // Inicializar tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });

        // Validación del formato JSON para los datos
        $('#datosJson').on('change', function () {
            try {
                if ($(this).val().trim() !== '') {
                    JSON.parse($(this).val());
                    $(this).removeClass('is-invalid').addClass('is-valid');
                } else {
                    $(this).removeClass('is-invalid').removeClass('is-valid');
                }
            } catch (e) {
                $(this).removeClass('is-valid').addClass('is-invalid');
            }
        });
    });
</script>
</body>
</html>
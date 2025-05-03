<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.EntidadPublicaEntidad" %>
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

    // Obtener la entidad a editar
    EntidadPublicaEntidad entidad = (EntidadPublicaEntidad) request.getAttribute("entidad");
    if (entidad == null) {
        response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        return;
    }

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
    <title>Editar Entidad - Portal de Transparencia Perú</title>
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
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios">
                            <i class="bi bi-people me-1"></i> Gestión de Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="entidades.jsp">
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
                <h1 class="h2">Editar Entidad Pública</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="<%= request.getContextPath() %>/admin/entidades.jsp"
                       class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Volver
                    </a>
                </div>
            </div>

            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Información de la Entidad</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin.do" method="post">
                        <input type="hidden" name="accion" value="actualizarEntidad">
                        <input type="hidden" name="id" value="<%= entidad.getId() %>">
                        <div class="row mb-3">
                            <div class="col-md-8">
                                <label for="nombre" class="form-label">Nombre de Entidad</label>
                                <input type="text" class="form-control" id="nombre" name="nombre"
                                       value="<%= entidad.getNombre() %>" required>
                            </div>
                            <div class="col-md-4">
                                <label for="tipo" class="form-label">Tipo</label>
                                <select class="form-select" id="tipo" name="tipo" required>
                                    <option value="">Seleccione tipo</option>
                                    <option value="Ministerio" <%= entidad.getTipo().equals("Ministerio") ? "selected" : "" %>>
                                        Ministerio
                                    </option>
                                    <option value="Gobierno Regional" <%= entidad.getTipo().equals("Gobierno Regional") ? "selected" : "" %>>
                                        Gobierno Regional
                                    </option>
                                    <option value="Municipalidad Provincial" <%= entidad.getTipo().equals("Municipalidad Provincial") ? "selected" : "" %>>
                                        Municipalidad Provincial
                                    </option>
                                    <option value="Municipalidad Distrital" <%= entidad.getTipo().equals("Municipalidad Distrital") ? "selected" : "" %>>
                                        Municipalidad Distrital
                                    </option>
                                    <option value="Organismo Supervisor" <%= entidad.getTipo().equals("Organismo Supervisor") ? "selected" : "" %>>
                                        Organismo Supervisor
                                    </option>
                                    <option value="Otro" <%= entidad.getTipo().equals("Otro") ? "selected" : "" %>>
                                        Otro
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="nivelGobiernoId" class="form-label">Nivel de Gobierno</label>
                                <select class="form-select" id="nivelGobiernoId" name="nivelGobiernoId" required
                                        onchange="mostrarRegion()">
                                    <option value="">Seleccione nivel</option>
                                    <option value="1" <%= entidad.getNivelGobiernoId() == 1 ? "selected" : "" %>>
                                        Nacional
                                    </option>
                                    <option value="2" <%= entidad.getNivelGobiernoId() == 2 ? "selected" : "" %>>
                                        Regional
                                    </option>
                                    <option value="3" <%= entidad.getNivelGobiernoId() == 3 ? "selected" : "" %>>
                                        Municipal
                                    </option>
                                </select>
                            </div>
                            <div class="col-md-6" id="div-region"
                                 style="display:<%= entidad.getNivelGobiernoId() == 1 ? "none" : "block" %>;">
                                <label for="regionId" class="form-label">Región</label>
                                <select class="form-select" id="regionId"
                                        name="regionId" <%= entidad.getNivelGobiernoId() != 1 ? "required" : "" %>>
                                    <option value="">Seleccione región</option>
                                    <option value="1" <%= entidad.getRegionId() == 1 ? "selected" : "" %>>Lima</option>
                                    <option value="2" <%= entidad.getRegionId() == 2 ? "selected" : "" %>>Arequipa
                                    </option>
                                    <option value="3" <%= entidad.getRegionId() == 3 ? "selected" : "" %>>Cusco</option>
                                    <option value="4" <%= entidad.getRegionId() == 4 ? "selected" : "" %>>La Libertad
                                    </option>
                                    <option value="5" <%= entidad.getRegionId() == 5 ? "selected" : "" %>>Piura</option>
                                    <option value="6" <%= entidad.getRegionId() == 6 ? "selected" : "" %>>Amazonas
                                    </option>
                                    <option value="7" <%= entidad.getRegionId() == 7 ? "selected" : "" %>>Áncash
                                    </option>
                                    <option value="8" <%= entidad.getRegionId() == 8 ? "selected" : "" %>>Apurímac
                                    </option>
                                    <option value="9" <%= entidad.getRegionId() == 9 ? "selected" : "" %>>Ayacucho
                                    </option>
                                    <option value="10" <%= entidad.getRegionId() == 10 ? "selected" : "" %>>Cajamarca
                                    </option>
                                    <option value="11" <%= entidad.getRegionId() == 11 ? "selected" : "" %>>Callao
                                    </option>
                                    <option value="12" <%= entidad.getRegionId() == 12 ? "selected" : "" %>>
                                        Huancavelica
                                    </option>
                                    <option value="13" <%= entidad.getRegionId() == 13 ? "selected" : "" %>>Huánuco
                                    </option>
                                    <option value="14" <%= entidad.getRegionId() == 14 ? "selected" : "" %>>Ica</option>
                                    <option value="15" <%= entidad.getRegionId() == 15 ? "selected" : "" %>>Junín
                                    </option>
                                    <option value="16" <%= entidad.getRegionId() == 16 ? "selected" : "" %>>Lambayeque
                                    </option>
                                    <option value="17" <%= entidad.getRegionId() == 17 ? "selected" : "" %>>Loreto
                                    </option>
                                    <option value="18" <%= entidad.getRegionId() == 18 ? "selected" : "" %>>Madre de
                                        Dios
                                    </option>
                                    <option value="19" <%= entidad.getRegionId() == 19 ? "selected" : "" %>>Moquegua
                                    </option>
                                    <option value="20" <%= entidad.getRegionId() == 20 ? "selected" : "" %>>Pasco
                                    </option>
                                    <option value="21" <%= entidad.getRegionId() == 21 ? "selected" : "" %>>Puno
                                    </option>
                                    <option value="22" <%= entidad.getRegionId() == 22 ? "selected" : "" %>>San Martín
                                    </option>
                                    <option value="23" <%= entidad.getRegionId() == 23 ? "selected" : "" %>>Tacna
                                    </option>
                                    <option value="24" <%= entidad.getRegionId() == 24 ? "selected" : "" %>>Tumbes
                                    </option>
                                    <option value="25" <%= entidad.getRegionId() == 25 ? "selected" : "" %>>Ucayali
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="direccion" class="form-label">Dirección</label>
                            <input type="text" class="form-control" id="direccion" name="direccion"
                                   value="<%= entidad.getDireccion() != null ? entidad.getDireccion() : "" %>">
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="telefono" class="form-label">Teléfono</label>
                                <input type="text" class="form-control" id="telefono" name="telefono"
                                       value="<%= entidad.getTelefono() != null ? entidad.getTelefono() : "" %>">
                            </div>
                            <div class="col-md-6">
                                <label for="email" class="form-label">Correo Electrónico</label>
                                <input type="email" class="form-control" id="email" name="email"
                                       value="<%= entidad.getEmail() != null ? entidad.getEmail() : "" %>">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="sitioWeb" class="form-label">Sitio Web</label>
                            <input type="url" class="form-control" id="sitioWeb" name="sitioWeb" placeholder="https://"
                                   value="<%= entidad.getSitioWeb() != null ? entidad.getSitioWeb() : "" %>">
                        </div>

                        <hr>
                        <div class="text-end">
                            <a href="<%= request.getContextPath() %>/admin/entidades.jsp" class="btn btn-secondary">Cancelar</a>
                            <button type="submit" class="btn btn-primary">Guardar Cambios</button>
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
    // Función para mostrar/ocultar el selector de región según el nivel de gobierno
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
</script>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%
    // Verificar si el usuario está en sesión y es admin
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
        // No es admin o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener el usuario a editar
    UsuarioEntidad usuarioEditar = (UsuarioEntidad) request.getAttribute("usuario");
    if (usuarioEditar == null) {
        // Si no hay usuario a editar, redirigir a la lista
        response.sendRedirect(request.getContextPath() + "/admin.do?accion=listarUsuarios");
        return;
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Usuario - Portal de Transparencia Perú</title>
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
                        <a class="nav-link active"
                           href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios">
                            <i class="bi bi-people me-1"></i> Gestión de Usuarios
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="entidades.jsp">
                            <i class="bi bi-building me-1"></i> Entidades Públicas
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/admin.do?accion=listarCiudadanos">
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
                <h1 class="h2">Editar Usuario</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="<%= request.getContextPath() %>/admin.do?accion=verDetalleUsuario&id=<%= usuarioEditar.getId() %>"
                       class="btn btn-sm btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i> Volver a Detalles
                    </a>
                </div>
            </div>

            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Formulario de Edición</h6>
                </div>
                <div class="card-body">
                    <form action="<%= request.getContextPath() %>/admin.do" method="post" class="needs-validation"
                          novalidate>
                        <input type="hidden" name="accion" value="actualizarUsuario">
                        <input type="hidden" name="id" value="<%= usuarioEditar.getId() %>">

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="usuario" class="form-label">Usuario</label>
                                <input type="text" class="form-control" id="usuario" name="usuario"
                                       value="<%= usuarioEditar.getUsuario() %>" required>
                                <div class="invalid-feedback">
                                    Por favor ingrese un nombre de usuario.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="correo" class="form-label">Correo Electrónico</label>
                                <input type="email" class="form-control" id="correo" name="correo"
                                       value="<%= usuarioEditar.getCorreo() %>" required>
                                <div class="invalid-feedback">
                                    Por favor ingrese un correo electrónico válido.
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="nombre" class="form-label">Nombre Completo</label>
                            <input type="text" class="form-control" id="nombre" name="nombre"
                                   value="<%= usuarioEditar.getNombreCompleto() %>" required>
                            <div class="invalid-feedback">
                                Por favor ingrese el nombre completo.
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="clave" class="form-label">Nueva Contraseña (opcional)</label>
                                <input type="password" class="form-control" id="clave" name="clave"
                                       placeholder="Dejar en blanco para mantener la actual">
                                <div class="form-text">
                                    Si no desea cambiar la contraseña, deje este campo en blanco.
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="confirmarClave" class="form-label">Confirmar Nueva Contraseña</label>
                                <input type="password" class="form-control" id="confirmarClave" name="confirmarClave">
                                <div class="invalid-feedback">
                                    Las contraseñas no coinciden.
                                </div>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="rol" class="form-label">Rol</label>
                                <select class="form-select" id="rol" name="rol" required>
                                    <option value="">Seleccione un rol</option>
                                    <option value="ADMIN" <%= usuarioEditar.getCodRol().equals("ADMIN") ? "selected" : "" %>>
                                        Administrador
                                    </option>
                                    <option value="FUNCIONARIO" <%= usuarioEditar.getCodRol().equals("FUNCIONARIO") ? "selected" : "" %>>
                                        Funcionario
                                    </option>
                                </select>
                                <div class="invalid-feedback">
                                    Por favor seleccione un rol.
                                </div>
                            </div>
                            <div class="col-md-6 d-flex align-items-end">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="activo"
                                           name="activo" <%= usuarioEditar.getActivo() ? "checked" : "" %>>
                                    <label class="form-check-label" for="activo">Usuario activo</label>
                                </div>
                            </div>
                        </div>

                        <div class="alert alert-info">
                            <i class="bi bi-info-circle me-2"></i> Los cambios realizados en este formulario
                            actualizarán la información del usuario en el sistema.
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <a href="<%= request.getContextPath() %>/admin.do?accion=listarUsuarios"
                               class="btn btn-secondary me-md-2">Cancelar</a>
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
    // Validación del formulario
    (function () {
        'use strict';

        // Obtener todos los formularios a los que queremos aplicar estilos de validación personalizados
        var forms = document.querySelectorAll('.needs-validation');

        // Validar contraseñas coincidentes
        var password = document.getElementById("clave");
        var confirmPassword = document.getElementById("confirmarClave");

        function validatePassword() {
            if (password.value !== confirmPassword.value) {
                confirmPassword.setCustomValidity("Las contraseñas no coinciden");
            } else {
                confirmPassword.setCustomValidity('');
            }
        }

        password.onchange = validatePassword;
        confirmPassword.onkeyup = validatePassword;

        // Evitar envíos de formulario si no son válidos
        Array.prototype.slice.call(forms).forEach(function (form) {
            form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }

                form.classList.add('was-validated');
            }, false);
        });
    })();
</script>
</body>
</html>
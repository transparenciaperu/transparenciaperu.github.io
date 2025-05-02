<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.CiudadanoEntidad" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("ciudadano") == null) {
        // No está logueado como ciudadano, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    CiudadanoEntidad ciudadano = (CiudadanoEntidad) sesion.getAttribute("ciudadano");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ciudadano.css">
</head>
<body class="ciudadano-theme">
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Mi Perfil</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle me-1"></i><%= ciudadano.getNombreCompleto() %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="perfil.jsp"><i class="bi bi-person me-1"></i> Mi Perfil</a>
                        </li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item"
                               href="<%= request.getContextPath() %>/ciudadano.do?accion=cerrar"><i
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
                        <a class="nav-link" href="mis_solicitudes.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Mis Solicitudes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="nueva_solicitud.jsp">
                            <i class="bi bi-file-plus me-1"></i> Nueva Solicitud
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="perfil.jsp">
                            <i class="bi bi-person me-1"></i> Mi Perfil
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="presupuesto.jsp">
                            <i class="bi bi-cash-coin me-1"></i> Presupuesto Público
                        </a>
                    </li>
                </ul>

                <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                    <span>Portal Público</span>
                </h6>
                <ul class="nav flex-column mb-2">
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/index.jsp">
                            <i class="bi bi-arrow-left-circle me-1"></i> Volver al Portal
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom title-section">
                <h1 class="h2">Mi Perfil</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal"
                            data-bs-target="#cambiarClaveModal">
                        <i class="bi bi-key me-1"></i> Cambiar Contraseña
                    </button>
                </div>
            </div>

            <%
                // Mostrar mensaje de redirección si existe
                String mensaje = (String) session.getAttribute("mensaje");
                String tipoMensaje = (String) session.getAttribute("tipoMensaje");
                if (mensaje != null && !mensaje.isEmpty()) {
                    String alertClass = "alert-warning";
                    String iconClass = "bi-exclamation-triangle";

                    if ("success".equals(tipoMensaje)) {
                        alertClass = "alert-success";
                        iconClass = "bi-check-circle";
                    } else if ("danger".equals(tipoMensaje)) {
                        alertClass = "alert-danger";
                        iconClass = "bi-exclamation-triangle";
                    }
            %>
            <div class="alert <%= alertClass %> alert-dismissible fade show" role="alert">
                <i class="bi <%= iconClass %> me-2"></i> <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%
                    // Limpiar el mensaje después de mostrarlo
                    session.removeAttribute("mensaje");
                    session.removeAttribute("tipoMensaje");
                }
            %>

            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card shadow fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Información Personal</h6>
                        </div>
                        <div class="card-body text-center">
                            <div class="mb-3">
                                <div class="avatar-circle mx-auto">
                                    <span class="avatar-text"><%= ciudadano.getNombres().substring(0, 1).toUpperCase() %><%= ciudadano.getApellidos().substring(0, 1).toUpperCase() %></span>
                                </div>
                            </div>
                            <h5><%= ciudadano.getNombreCompleto() %>
                            </h5>
                            <p class="text-muted">Ciudadano registrado</p>
                            <div class="d-flex justify-content-between mt-4">
                                <div>
                                    <small class="text-muted d-block">Fecha de registro</small>
                                    <strong><%= ciudadano.getFechaRegistro() %>
                                    </strong>
                                </div>
                                <div>
                                    <small class="text-muted d-block">Solicitudes</small>
                                    <strong>12</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Datos Personales</h6>
                            <button type="button" class="btn btn-sm btn-primary" id="btnEditarPerfil">
                                <i class="bi bi-pencil-square me-1"></i> Editar
                            </button>
                        </div>
                        <div class="card-body">
                            <form id="formPerfil" action="<%= request.getContextPath() %>/ciudadano.do" method="post"
                                  class="needs-validation" novalidate>
                                <input type="hidden" name="accion" value="actualizarPerfil">
                                <input type="hidden" name="id" value="<%= ciudadano.getId() %>">

                                <div class="mb-3 row">
                                    <label for="nombres" class="col-sm-3 col-form-label">Nombres:</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control" id="nombres" name="nombres"
                                               value="<%= ciudadano.getNombres() %>" readonly required>
                                        <div class="invalid-feedback">Por favor ingrese sus nombres.</div>
                                    </div>
                                </div>

                                <div class="mb-3 row">
                                    <label for="apellidos" class="col-sm-3 col-form-label">Apellidos:</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control" id="apellidos" name="apellidos"
                                               value="<%= ciudadano.getApellidos() %>" readonly required>
                                        <div class="invalid-feedback">Por favor ingrese sus apellidos.</div>
                                    </div>
                                </div>

                                <div class="mb-3 row">
                                    <label for="dni" class="col-sm-3 col-form-label">DNI:</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control" id="dni" name="dni"
                                               value="<%= ciudadano.getDni() %>" readonly required>
                                        <div class="invalid-feedback">Por favor ingrese su DNI.</div>
                                    </div>
                                </div>

                                <div class="mb-3 row">
                                    <label for="correo" class="col-sm-3 col-form-label">Correo:</label>
                                    <div class="col-sm-9">
                                        <input type="email" class="form-control" id="correo" name="correo"
                                               value="<%= ciudadano.getCorreo() %>" readonly required>
                                        <div class="invalid-feedback">Por favor ingrese un correo válido.</div>
                                    </div>
                                </div>

                                <div class="mb-3 row">
                                    <label for="telefono" class="col-sm-3 col-form-label">Teléfono:</label>
                                    <div class="col-sm-9">
                                        <input type="tel" class="form-control" id="telefono" name="telefono"
                                               value="<%= ciudadano.getTelefono() %>" readonly required>
                                        <div class="invalid-feedback">Por favor ingrese su número de teléfono.</div>
                                    </div>
                                </div>

                                <div class="mb-3 row">
                                    <label for="direccion" class="col-sm-3 col-form-label">Dirección:</label>
                                    <div class="col-sm-9">
                                        <input type="text" class="form-control" id="direccion" name="direccion"
                                               value="<%= ciudadano.getDireccion() %>" readonly required>
                                        <div class="invalid-feedback">Por favor ingrese su dirección.</div>
                                    </div>
                                </div>

                                <div class="row mt-4 justify-content-end" id="botonesGuardar" style="display: none;">
                                    <div class="col-sm-9 d-flex justify-content-end">
                                        <button type="button" class="btn btn-secondary me-2" id="btnCancelar">Cancelar
                                        </button>
                                        <button type="submit" class="btn btn-primary">Guardar Cambios</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card shadow fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Preferencias de Notificación</h6>
                        </div>
                        <div class="card-body">
                            <form id="formNotificaciones" action="<%= request.getContextPath() %>/ciudadano.do"
                                  method="post">
                                <input type="hidden" name="accion" value="actualizarNotificaciones">
                                <input type="hidden" name="id" value="<%= ciudadano.getId() %>">

                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="notificacionCorreo"
                                           name="notificacionCorreo" checked>
                                    <label class="form-check-label" for="notificacionCorreo">
                                        Recibir notificaciones por correo electrónico
                                    </label>
                                </div>

                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="notificacionSMS"
                                           name="notificacionSMS">
                                    <label class="form-check-label" for="notificacionSMS">
                                        Recibir notificaciones por SMS (mensaje de texto)
                                    </label>
                                </div>

                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="notificacionNuevasSolicitudes"
                                           name="notificacionNuevasSolicitudes" checked>
                                    <label class="form-check-label" for="notificacionNuevasSolicitudes">
                                        Recibir alertas cuando cambie el estado de mis solicitudes
                                    </label>
                                </div>

                                <div class="form-check form-switch mb-3">
                                    <input class="form-check-input" type="checkbox" id="notificacionNoticias"
                                           name="notificacionNoticias">
                                    <label class="form-check-label" for="notificacionNoticias">
                                        Recibir noticias y actualizaciones del Portal de Transparencia
                                    </label>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save me-1"></i> Guardar Preferencias
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row mt-4">
                <div class="col-md-12">
                    <div class="card shadow fade-in">
                        <div class="card-header py-3 bg-light">
                            <h6 class="m-0 font-weight-bold">Actividad Reciente</h6>
                        </div>
                        <div class="card-body">
                            <div class="timeline">
                                <div class="timeline-item">
                                    <div class="timeline-date">28/04/2024</div>
                                    <div class="timeline-content">
                                        <h6>Nueva solicitud creada</h6>
                                        <p>Solicitud de información sobre programas de becas estudiantiles enviada al
                                            Ministerio de Educación.</p>
                                    </div>
                                </div>
                                <div class="timeline-item">
                                    <div class="timeline-date">25/04/2024</div>
                                    <div class="timeline-content">
                                        <h6>Respuesta recibida</h6>
                                        <p>La Municipalidad de Lima respondió a su solicitud sobre planos urbanos del
                                            distrito de San Isidro.</p>
                                    </div>
                                </div>
                                <div class="timeline-item">
                                    <div class="timeline-date">15/04/2024</div>
                                    <div class="timeline-content">
                                        <h6>Nueva solicitud creada</h6>
                                        <p>Solicitud de planos urbanos del distrito de San Isidro enviada a la
                                            Municipalidad de Lima.</p>
                                    </div>
                                </div>
                                <div class="timeline-item">
                                    <div class="timeline-date">02/04/2024</div>
                                    <div class="timeline-content">
                                        <h6>Respuesta recibida</h6>
                                        <p>El Ministerio de Salud respondió a su solicitud sobre campañas de
                                            vacunación.</p>
                                    </div>
                                </div>
                                <div class="timeline-item">
                                    <div class="timeline-date">22/03/2024</div>
                                    <div class="timeline-content">
                                        <h6>Nueva solicitud creada</h6>
                                        <p>Solicitud de información sobre campañas de vacunación enviada al Ministerio
                                            de Salud.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal para cambiar contraseña -->
            <div class="modal fade" id="cambiarClaveModal" tabindex="-1" aria-labelledby="cambiarClaveModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="cambiarClaveModalLabel">Cambiar Contraseña</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="formCambiarClave" action="<%= request.getContextPath() %>/ciudadano.do" method="post"
                              class="needs-validation" novalidate>
                            <input type="hidden" name="accion" value="cambiarClave">
                            <input type="hidden" name="id" value="<%= ciudadano.getId() %>">

                            <div class="modal-body">
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle-fill me-2"></i> Por seguridad, tu nueva contraseña debe
                                    tener al menos 8 caracteres, incluir letras mayúsculas, minúsculas, números y al
                                    menos un carácter especial.
                                </div>

                                <div class="mb-3">
                                    <label for="claveActual" class="form-label">Contraseña Actual:</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="claveActual" name="claveActual"
                                               required>
                                        <button class="btn btn-outline-secondary toggle-password" type="button"
                                                data-target="claveActual">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Por favor ingrese su contraseña actual.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="nuevaClave" class="form-label">Nueva Contraseña:</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="nuevaClave" name="nuevaClave"
                                               required
                                               pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$">
                                        <button class="btn btn-outline-secondary toggle-password" type="button"
                                                data-target="nuevaClave">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">La contraseña debe tener al menos 8 caracteres,
                                        incluir mayúsculas, minúsculas, números y al menos un carácter especial.
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="confirmarClave" class="form-label">Confirmar Nueva Contraseña:</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="confirmarClave"
                                               name="confirmarClave" required>
                                        <button class="btn btn-outline-secondary toggle-password" type="button"
                                                data-target="confirmarClave">
                                            <i class="bi bi-eye"></i>
                                        </button>
                                    </div>
                                    <div class="invalid-feedback">Las contraseñas no coinciden.</div>
                                </div>

                                <div class="progress mb-3" style="height: 8px;">
                                    <div id="passwordStrength" class="progress-bar" role="progressbar"
                                         style="width: 0%;" aria-valuenow="0" aria-valuemin="0"
                                         aria-valuemax="100"></div>
                                </div>
                                <p id="passwordFeedback" class="small text-muted"></p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar
                                </button>
                                <button type="submit" class="btn btn-primary">Cambiar Contraseña</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function () {
        // Habilitar/deshabilitar campos para edición
        $('#btnEditarPerfil').click(function () {
            const form = $('#formPerfil');
            const inputs = form.find('input');
            const botonesGuardar = $('#botonesGuardar');

            // No permitir editar ciertos campos
            inputs.not('#dni, #correo').prop('readonly', false);
            botonesGuardar.show();
            $(this).hide();
        });

        // Cancelar edición
        $('#btnCancelar').click(function () {
            const form = $('#formPerfil');
            const inputs = form.find('input');
            const botonesGuardar = $('#botonesGuardar');

            inputs.prop('readonly', true);
            botonesGuardar.hide();
            $('#btnEditarPerfil').show();

            // Restaurar valores originales
            form[0].reset();
        });

        // Mostrar/ocultar contraseña
        $('.toggle-password').click(function () {
            const target = $(this).data('target');
            const input = $('#' + target);
            const icon = $(this).find('i');

            if (input.attr('type') === 'password') {
                input.attr('type', 'text');
                icon.removeClass('bi-eye').addClass('bi-eye-slash');
            } else {
                input.attr('type', 'password');
                icon.removeClass('bi-eye-slash').addClass('bi-eye');
            }
        });

        // Validación de contraseña
        $('#nuevaClave').on('input', function () {
            const password = $(this).val();
            const confirmPassword = $('#confirmarClave').val();
            const strength = checkPasswordStrength(password);

            $('#passwordStrength').css('width', strength.score + '%')
                .removeClass('bg-danger bg-warning bg-success')
                .addClass(strength.class);

            $('#passwordFeedback').text(strength.feedback);

            // Validar coincidencia con confirmar contraseña
            if (confirmPassword && password !== confirmPassword) {
                $('#confirmarClave')[0].setCustomValidity('Las contraseñas no coinciden');
            } else {
                $('#confirmarClave')[0].setCustomValidity('');
            }
        });

        $('#confirmarClave').on('input', function () {
            const password = $('#nuevaClave').val();
            const confirmPassword = $(this).val();

            if (password !== confirmPassword) {
                this.setCustomValidity('Las contraseñas no coinciden');
            } else {
                this.setCustomValidity('');
            }
        });

        // Validación de formularios
        const formPerfil = document.getElementById('formPerfil');
        if (formPerfil) {
            formPerfil.addEventListener('submit', function (event) {
                if (!formPerfil.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                formPerfil.classList.add('was-validated');
            }, false);
        }

        const formCambiarClave = document.getElementById('formCambiarClave');
        if (formCambiarClave) {
            formCambiarClave.addEventListener('submit', function (event) {
                if (!formCambiarClave.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }

                // Validar que las contraseñas coincidan
                const password = $('#nuevaClave').val();
                const confirmPassword = $('#confirmarClave').val();

                if (password !== confirmPassword) {
                    $('#confirmarClave')[0].setCustomValidity('Las contraseñas no coinciden');
                    event.preventDefault();
                    event.stopPropagation();
                } else {
                    $('#confirmarClave')[0].setCustomValidity('');
                }

                formCambiarClave.classList.add('was-validated');
            }, false);
        }

        // Función para evaluar la fortaleza de la contraseña
        function checkPasswordStrength(password) {
            let score = 0;
            let feedback = 'Sin contraseña';
            let colorClass = 'bg-danger';

            if (!password) {
                return {score: 0, feedback: feedback, class: colorClass};
            }

            // Contraseña corta
            if (password.length < 6) {
                return {score: 20, feedback: 'Contraseña demasiado corta', class: 'bg-danger'};
            }

            // Evaluar fortaleza
            score += password.length * 4;
            score += countUniqueChars(password) * 3;

            // Bonificaciones
            if (/[A-Z]/.test(password)) score += 10;
            if (/[a-z]/.test(password)) score += 10;
            if (/[0-9]/.test(password)) score += 10;
            if (/[^A-Za-z0-9]/.test(password)) score += 15;

            // Limitar el score máximo a 100
            score = Math.min(100, score);

            // Determinar la fortaleza
            if (score < 30) {
                feedback = 'Contraseña muy débil';
                colorClass = 'bg-danger';
            } else if (score < 60) {
                feedback = 'Contraseña media';
                colorClass = 'bg-warning';
            } else if (score < 80) {
                feedback = 'Contraseña fuerte';
                colorClass = 'bg-success';
            } else {
                feedback = 'Contraseña muy fuerte';
                colorClass = 'bg-success';
            }

            return {score: score, feedback: feedback, class: colorClass};
        }

        function countUniqueChars(str) {
            return [...new Set(str.split(''))].length;
        }

        // Añadir estilos dinámicos para la timeline
        $('.timeline-item').each(function (index) {
            $(this).css('animation-delay', (index * 0.2) + 's');
        });
    });
</script>
</body>
</html>
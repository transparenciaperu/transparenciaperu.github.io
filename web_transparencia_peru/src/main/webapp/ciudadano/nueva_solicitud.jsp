<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.CiudadanoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.SolicitudAccesoModelo" %>
<%@ page import="pe.gob.transparencia.entidades.TipoSolicitudEntidad" %>
<%@ page import="java.util.List" %>
<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("ciudadano") == null) {
        // No está logueado como ciudadano, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    CiudadanoEntidad ciudadano = (CiudadanoEntidad) sesion.getAttribute("ciudadano");

    // Obtener tipos de solicitud desde el modelo
    SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
    List<TipoSolicitudEntidad> tiposSolicitud = null;
    try {
        tiposSolicitud = modelo.listarTiposSolicitud();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Verificar si hay un mensaje de sesión
    String mensaje = "";
    String tipoMensaje = "";
    if (session.getAttribute("mensaje") != null) {
        mensaje = (String) session.getAttribute("mensaje");
        tipoMensaje = (String) session.getAttribute("tipoMensaje");
        session.removeAttribute("mensaje");
        session.removeAttribute("tipoMensaje");
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nueva Solicitud - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/ciudadano.css">
</head>
<body class="ciudadano-theme">
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Nueva Solicitud</a>
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
                        <a class="nav-link active" href="nueva_solicitud.jsp">
                            <i class="bi bi-file-plus me-1"></i> Nueva Solicitud
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="perfil.jsp">
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
                <h1 class="h2">Nueva Solicitud de Información</h1>
                <div class="btn-toolbar mb-2 mb-md-0">
                    <a href="mis_solicitudes.jsp" class="btn btn-outline-primary">
                        <i class="bi bi-arrow-left me-1"></i> Mis Solicitudes
                    </a>
                </div>
            </div>

            <% if (!mensaje.isEmpty()) { %>
            <div class="alert alert-<%= tipoMensaje %> alert-dismissible fade show">
                <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <div class="alert alert-info mb-4">
                <div class="d-flex">
                    <div class="me-3">
                        <i class="bi bi-info-circle-fill fs-3"></i>
                    </div>
                    <div>
                        <h5>¿Qué es una solicitud de acceso a la información pública?</h5>
                        <p>Es un derecho ciudadano establecido en la Ley de Transparencia y Acceso a la Información
                            Pública (Ley N° 27806), que le permite solicitar y recibir información de cualquier entidad
                            pública, sin expresión de causa.</p>
                        <p class="mb-0">Las entidades tienen un plazo legal de <strong>10 días hábiles</strong> para
                            responder (prorrogable por 5 días adicionales en casos excepcionales).</p>
                    </div>
                </div>
            </div>

            <!-- Formulario de solicitud -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h5 class="mb-0 font-weight-bold">Formulario de Solicitud</h5>
                </div>
                <div class="card-body">
                    <form id="formSolicitud" action="<%= request.getContextPath() %>/solicitud.do" method="post"
                          enctype="multipart/form-data" class="needs-validation" novalidate>
                        <input type="hidden" name="accion" value="registrar">
                        <input type="hidden" name="ciudadanoId" value="<%= ciudadano.getId() %>">

                        <div class="row mb-4">
                            <div class="col-md-6">
                                <h6 class="mb-3">1. Datos del Solicitante</h6>
                                <div class="card bg-light">
                                    <div class="card-body">
                                        <div class="mb-3 row">
                                            <label class="col-sm-4 col-form-label">Nombres:</label>
                                            <div class="col-sm-8">
                                                <p class="form-control-plaintext"><%= ciudadano.getNombres() %>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="mb-3 row">
                                            <label class="col-sm-4 col-form-label">Apellidos:</label>
                                            <div class="col-sm-8">
                                                <p class="form-control-plaintext"><%= ciudadano.getApellidos() %>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="mb-3 row">
                                            <label class="col-sm-4 col-form-label">DNI:</label>
                                            <div class="col-sm-8">
                                                <p class="form-control-plaintext"><%= ciudadano.getDni() %>
                                                </p>
                                            </div>
                                        </div>
                                        <div class="mb-3 row">
                                            <label class="col-sm-4 col-form-label">Correo:</label>
                                            <div class="col-sm-8">
                                                <p class="form-control-plaintext"><%= ciudadano.getCorreo() %>
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6 class="mb-3">2. Seleccione la Entidad</h6>
                                <div class="mb-3">
                                    <label for="nivelGobierno" class="form-label">Nivel de Gobierno:</label>
                                    <select class="form-select" id="nivelGobierno" name="nivelGobierno" required>
                                        <option value="" selected>Seleccione nivel de gobierno</option>
                                        <option value="1">Nacional</option>
                                        <option value="2">Regional</option>
                                        <option value="3">Municipal</option>
                                    </select>
                                    <div class="invalid-feedback">Por favor seleccione un nivel de gobierno.</div>
                                </div>

                                <div class="mb-3" id="regionContainer" style="display: none;">
                                    <label for="region" class="form-label">Región:</label>
                                    <select class="form-select" id="region" name="region">
                                        <option value="" selected>Seleccione una región</option>
                                        <option value="1">Lima</option>
                                        <option value="2">Arequipa</option>
                                        <option value="3">Cusco</option>
                                        <option value="4">La Libertad</option>
                                        <option value="5">Piura</option>
                                        <!-- Otras regiones -->
                                    </select>
                                    <div class="invalid-feedback">Por favor seleccione una región.</div>
                                </div>

                                <div class="mb-3">
                                    <label for="entidad" class="form-label">Entidad Pública:</label>
                                    <select class="form-select" id="entidad" name="entidadPublicaId" required>
                                        <option value="" selected>Primero seleccione un nivel de gobierno</option>
                                    </select>
                                    <div class="invalid-feedback">Por favor seleccione una entidad pública.</div>
                                </div>
                            </div>
                        </div>

                        <hr class="my-4">

                        <h6 class="mb-3">3. Información Solicitada</h6>
                        <div class="mb-3">
                            <label for="tipoSolicitud" class="form-label">Tipo de Información:</label>
                            <select class="form-select" id="tipoSolicitud" name="tipoSolicitudId" required>
                                <option value="" selected>Seleccione un tipo de información</option>
                                <% if (tiposSolicitud != null) {
                                    for (TipoSolicitudEntidad tipo : tiposSolicitud) { %>
                                <option value="<%= tipo.getId() %>"><%= tipo.getNombre() %>
                                </option>
                                <% }
                                } else { %>
                                <option value="1">Información Presupuestal</option>
                                <option value="2">Información de Proyectos</option>
                                <option value="3">Información de Contrataciones</option>
                                <option value="4">Información de Personal</option>
                                <option value="5">Información General</option>
                                <option value="6">Información Ambiental</option>
                                <% } %>
                            </select>
                            <div class="invalid-feedback">Por favor seleccione un tipo de información.</div>
                        </div>

                        <div class="mb-3">
                            <label for="descripcion" class="form-label">Descripción Detallada:</label>
                            <textarea class="form-control" id="descripcion" name="descripcion" rows="5" required
                                      placeholder="Describa claramente la información que solicita. Sea específico en cuanto a fechas, documentos, áreas, proyectos, etc."></textarea>
                            <div class="invalid-feedback">Por favor ingrese una descripción detallada.</div>
                            <div class="form-text mt-2">
                                <i class="bi bi-info-circle-fill me-1"></i> Cuanto más específico sea, más fácil será
                                para la entidad atender su solicitud.
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="archivosAdjuntos" class="form-label">Archivos Adjuntos (opcional):</label>
                            <input type="file" class="form-control" id="archivosAdjuntos" name="archivosAdjuntos"
                                   multiple>
                            <div class="form-text">
                                Puede adjuntar hasta 3 archivos (máximo 5MB cada uno) para complementar su solicitud.
                            </div>
                        </div>

                        <hr class="my-4">

                        <h6 class="mb-3">4. Formato de entrega de información</h6>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="formatoEntrega" id="formatoDigital"
                                       value="digital" checked>
                                <label class="form-check-label" for="formatoDigital">
                                    Digital (a través del portal)
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="formatoEntrega" id="formatoFisico"
                                       value="fisico">
                                <label class="form-check-label" for="formatoFisico">
                                    Físico (sujeto a costos de reproducción)
                                </label>
                            </div>
                        </div>

                        <div class="form-check mb-4">
                            <input class="form-check-input" type="checkbox" id="terminos" name="terminos" required>
                            <label class="form-check-label" for="terminos">
                                Acepto los <a href="#" data-bs-toggle="modal" data-bs-target="#terminosModal">términos y
                                condiciones</a> y declaro que la información proporcionada es verdadera.
                            </label>
                            <div class="invalid-feedback">Debe aceptar los términos y condiciones para continuar.</div>
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                            <button type="button" class="btn btn-outline-secondary me-md-2"
                                    onClick="window.location='index.jsp';">Cancelar
                            </button>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send me-1"></i> Enviar Solicitud
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Modal de términos y condiciones -->
            <div class="modal fade" id="terminosModal" tabindex="-1" aria-labelledby="terminosModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="terminosModalLabel">Términos y Condiciones</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <h6>Solicitud de Acceso a la Información Pública</h6>
                            <p>Al utilizar este sistema, usted acepta los siguientes términos:</p>
                            <ol>
                                <li><strong>Veracidad de la información:</strong> Declaro que la información
                                    proporcionada en el formulario es verdadera y precisa.
                                </li>
                                <li><strong>Uso apropiado:</strong> Me comprometo a utilizar este servicio de manera
                                    responsable, sin saturar el sistema con solicitudes repetitivas o infundadas.
                                </li>
                                <li><strong>Finalidad:</strong> La información solicitada será utilizada exclusivamente
                                    para los fines declarados en mi solicitud.
                                </li>
                                <li><strong>Plazos:</strong> Entiendo que la entidad tiene un plazo legal de 10 días
                                    hábiles (prorrogables por 5 días adicionales en casos justificados) para responder a
                                    mi solicitud.
                                </li>
                                <li><strong>Responsabilidad:</strong> Soy responsable del uso que dé a la información
                                    que me sea proporcionada.
                                </li>
                                <li><strong>Protección de datos personales:</strong> Mis datos personales serán tratados
                                    conforme a la Ley N° 29733, Ley de Protección de Datos Personales.
                                </li>
                                <li><strong>Limitaciones:</strong> Entiendo que existen excepciones legales al acceso a
                                    la información pública (seguridad nacional, investigaciones en curso, datos
                                    personales, etc.).
                                </li>
                                <li><strong>Costos de reproducción:</strong> En caso de solicitar copias físicas, podría
                                    existir un costo por reproducción que deberé asumir.
                                </li>
                            </ol>

                            <h6>Marco Legal</h6>
                            <ul>
                                <li>Ley N° 27806, Ley de Transparencia y Acceso a la Información Pública</li>
                                <li>Decreto Supremo N° 021-2019-JUS, TUO de la Ley N° 27806</li>
                                <li>Decreto Supremo N° 072-2003-PCM, Reglamento de la Ley N° 27806</li>
                            </ul>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                            <button type="button" class="btn btn-primary" data-bs-dismiss="modal"
                                    onclick="document.getElementById('terminos').checked = true;">Aceptar
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Modal de confirmación -->
            <div class="modal fade" id="confirmacionModal" tabindex="-1" aria-labelledby="confirmacionModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title" id="confirmacionModalLabel">Solicitud Enviada</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="text-center mb-4">
                                <i class="bi bi-check-circle-fill text-success" style="font-size: 3rem;"></i>
                                <h4 class="mt-3">¡Solicitud enviada correctamente!</h4>
                                <p>Su solicitud ha sido registrada con el número: <strong
                                        id="numeroSolicitud">1020</strong></p>
                            </div>

                            <div class="alert alert-info">
                                <i class="bi bi-info-circle-fill me-2"></i> La entidad tiene un plazo de <strong>10 días
                                hábiles</strong> para responder a su solicitud.
                            </div>

                            <p>Puede hacer seguimiento del estado de su solicitud en la sección "Mis Solicitudes".</p>
                        </div>
                        <div class="modal-footer">
                            <a href="index.jsp" class="btn btn-secondary">Ir al inicio</a>
                            <a href="mis_solicitudes.jsp" class="btn btn-primary">Ver mis solicitudes</a>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
    $(document).ready(function () {
        // Inicializar Select2 para los selectores
        $('#entidad, #tipoSolicitud').select2({
            theme: 'bootstrap-5',
            width: '100%'
        });

        // Controlar la visibilidad del selector de región
        $('#nivelGobierno').change(function () {
            const nivel = $(this).val();
            const regionContainer = $('#regionContainer');
            const entidadSelect = $('#entidad');

            // Limpiar el selector de entidades
            entidadSelect.empty().append('<option value="" selected>Seleccione una entidad</option>');

            if (nivel === '2' || nivel === '3') { // Regional o Municipal
                regionContainer.show();
                $('#region').prop('required', true);
            } else {
                regionContainer.hide();
                $('#region').prop('required', false);
            }

            // Cargar las entidades correspondientes al nivel seleccionado
            if (nivel) {
                cargarEntidades(nivel);
            }
        });

        // Cuando cambia la región, actualizar las entidades disponibles
        $('#region').change(function () {
            const nivel = $('#nivelGobierno').val();
            const region = $(this).val();

            if (nivel && region) {
                cargarEntidades(nivel, region);
            }
        });

        // Función para cargar entidades (simulada)
        function cargarEntidades(nivel, region = null) {
            const entidadSelect = $('#entidad');
            entidadSelect.empty().append('<option value="" selected>Cargando entidades...</option>');

            // Simulación de carga de datos desde el servidor
            setTimeout(function () {
                entidadSelect.empty().append('<option value="" selected>Seleccione una entidad</option>');

                // Datos de ejemplo según el nivel
                if (nivel === '1') { // Nacional
                    entidadSelect.append('<option value="1">Ministerio de Economía y Finanzas</option>');
                    entidadSelect.append('<option value="2">Ministerio de Educación</option>');
                    entidadSelect.append('<option value="3">Ministerio de Salud</option>');
                    entidadSelect.append('<option value="9">OSINERGMIN</option>');
                    entidadSelect.append('<option value="10">SUNASS</option>');
                } else if (nivel === '2') { // Regional
                    if (region === '1') { // Lima
                        entidadSelect.append('<option value="15">Gobierno Regional de Lima</option>');
                    } else if (region === '2') { // Arequipa
                        entidadSelect.append('<option value="11">Gobierno Regional de Arequipa</option>');
                    } else {
                        entidadSelect.append('<option value="11">Gobierno Regional de Arequipa</option>');
                        entidadSelect.append('<option value="12">Gobierno Regional de Cusco</option>');
                        entidadSelect.append('<option value="13">Gobierno Regional de La Libertad</option>');
                    }
                } else if (nivel === '3') { // Municipal
                    if (region === '1') { // Lima
                        entidadSelect.append('<option value="19">Municipalidad Provincial de Lima</option>');
                        entidadSelect.append('<option value="24">Municipalidad Distrital de Miraflores</option>');
                        entidadSelect.append('<option value="25">Municipalidad Distrital de San Isidro</option>');
                    } else if (region === '2') { // Arequipa
                        entidadSelect.append('<option value="20">Municipalidad Provincial de Arequipa</option>');
                    } else {
                        entidadSelect.append('<option value="20">Municipalidad Provincial de Arequipa</option>');
                        entidadSelect.append('<option value="21">Municipalidad Provincial de Cusco</option>');
                        entidadSelect.append('<option value="22">Municipalidad Provincial de Trujillo</option>');
                    }
                }

                // Recargar Select2 para reflejar los cambios
                entidadSelect.trigger('change');
            }, 500);
        }

        // Validación del formulario
        const form = document.getElementById('formSolicitud');

        form.addEventListener('submit', function (event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
                form.classList.add('was-validated');
            } else {
                // Si el formulario es válido, mostrar el modal de confirmación
                event.preventDefault();
                // Aquí normalmente enviaríamos los datos por AJAX
                // Simulamos una respuesta exitosa
                $('#numeroSolicitud').text(Math.floor(1000 + Math.random() * 9000));
                $('#confirmacionModal').modal('show');
            }

            form.classList.add('was-validated');
        }, false);

        // Contador de caracteres para la descripción
        $('#descripcion').on('input', function () {
            const maxLength = 2000;
            const currentLength = $(this).val().length;

            if (currentLength > maxLength) {
                $(this).val($(this).val().substring(0, maxLength));
            }
        });
    });
</script>
</body>
</html>
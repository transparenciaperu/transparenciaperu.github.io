<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.UsuarioModelo" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="pe.gob.transparencia.db.MySQLConexion" %>
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

    // Asegurar que existe al menos un usuario administrador 
    try {
        Connection conn = MySQLConexion.getConexion();
        if (conn != null) {
            // Verificar si hay usuarios
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM usuario");
            ResultSet rs = ps.executeQuery();
            int countUsuarios = 0;
            if (rs.next()) {
                countUsuarios = rs.getInt(1);
            }

            // Si no hay usuarios, crear uno administrador
            if (countUsuarios == 0) {
                System.out.println("No hay usuarios en la base de datos. Creando un administrador por defecto...");

                // 1. Verificar si existe la tabla rol
                try {
                    ps.close();
                    ps = conn.prepareStatement("SELECT COUNT(*) FROM rol");
                    rs = ps.executeQuery();
                    int countRoles = 0;
                    if (rs.next()) {
                        countRoles = rs.getInt(1);
                    }

                    // Si no hay roles, crearlos
                    if (countRoles == 0) {
                        System.out.println("Creando roles...");
                        ps.close();
                        ps = conn.prepareStatement("INSERT INTO rol (cod_rol, descrip_rol) VALUES (?, ?)");
                        ps.setString(1, "ADMIN");
                        ps.setString(2, "Administrador con acceso total al sistema");
                        ps.executeUpdate();
                        ps.setString(1, "FUNCIONARIO");
                        ps.setString(2, "Funcionario encargado de la gestión de transparencia");
                        ps.executeUpdate();
                    }
                } catch (Exception e) {
                    System.out.println("Error al verificar roles: " + e.getMessage());
                }

                // 2. Crear persona
                ps.close();
                ps = conn.prepareStatement(
                        "INSERT INTO persona (nombre_completo, correo, dni, genero, fech_nac) VALUES (?, ?, ?, ?, ?)",
                        Statement.RETURN_GENERATED_KEYS
                );
                ps.setString(1, "Administrador del Sistema");
                ps.setString(2, "admin@transparencia.gob.pe");
                ps.setString(3, "00000000");
                ps.setString(4, "M");
                ps.setDate(5, new java.sql.Date(System.currentTimeMillis()));
                ps.executeUpdate();

                rs = ps.getGeneratedKeys();
                int idPersona = 0;
                if (rs.next()) {
                    idPersona = rs.getInt(1);
                }

                // 3. Obtener id del rol ADMIN
                ps.close();
                rs.close();
                ps = conn.prepareStatement("SELECT id_rol FROM rol WHERE cod_rol = ?");
                ps.setString(1, "ADMIN");
                rs = ps.executeQuery();
                int idRol = 0;
                if (rs.next()) {
                    idRol = rs.getInt("id_rol");
                }

                // 4. Crear usuario
                if (idPersona > 0 && idRol > 0) {
                    ps.close();
                    ps = conn.prepareStatement(
                            "INSERT INTO usuario (cod_usuario, id_persona, id_rol, clave, activo) VALUES (?, ?, ?, ?, ?)"
                    );
                    ps.setString(1, "admin");
                    ps.setInt(2, idPersona);
                    ps.setInt(3, idRol);
                    ps.setString(4, "admin");  // Contraseña: admin
                    ps.setBoolean(5, true);
                    ps.executeUpdate();

                    System.out.println("Usuario administrador creado - Usuario: admin, Clave: admin");
                }
            }

            if (ps != null) ps.close();
            if (rs != null) rs.close();
            if (conn != null) conn.close();
        }
    } catch (Exception e) {
        System.out.println("Error al verificar/crear usuario administrador: " + e.getMessage());
        e.printStackTrace();
    }

    // Obtener lista de usuarios - MÉTODO MEJORADO DIRECTO A BD
    List<UsuarioEntidad> listaUsuarios = new java.util.ArrayList<>();
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = MySQLConexion.getConexion();
        if (conn != null) {
            String sql = "SELECT u.id_usuario, u.cod_usuario, p.nombre_completo, p.correo, r.cod_rol, r.descrip_rol, " +
                    "CASE WHEN u.activo IS NULL THEN TRUE ELSE u.activo END as activo " +
                    "FROM usuario u " +
                    "LEFT JOIN persona p ON u.id_persona = p.id_persona " +
                    "LEFT JOIN rol r ON u.id_rol = r.id_rol";

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            int count = 0;
            while (rs.next()) {
                count++;
                UsuarioEntidad user = new UsuarioEntidad();
                user.setId(rs.getInt("id_usuario"));
                user.setUsuario(rs.getString("cod_usuario"));
                user.setNombreCompleto(rs.getString("nombre_completo"));
                user.setCorreo(rs.getString("correo"));
                user.setCodRol(rs.getString("cod_rol"));
                user.setDescripRol(rs.getString("descrip_rol"));
                user.setActivo(rs.getBoolean("activo"));

                listaUsuarios.add(user);
            }

            System.out.println("Usuarios recuperados directamente de la base de datos: " + count);
        }
    } catch (Exception e) {
        System.out.println("Error al obtener usuarios de la base de datos: " + e.getMessage());
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Si no hay usuarios, mostrar una alerta pero crear una lista vacía
    if (listaUsuarios == null) {
        listaUsuarios = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios - Portal de Transparencia Perú</title>
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
                        <a class="nav-link active" href="usuarios.jsp">
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
                <h1 class="h2">Gestión de Usuarios</h1>
                <div class="btn-toolbar">
                    <div class="btn-group me-2">
                        <button type="button" class="btn btn-sm btn-primary" data-bs-toggle="modal"
                                data-bs-target="#nuevoUsuarioModal">
                            <i class="bi bi-person-plus me-1"></i> Nuevo Usuario
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-toggle="tooltip"
                                data-bs-placement="bottom" title="Exportar usuarios">
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

            <!-- Tabla de Usuarios -->
            <div class="card shadow mb-4 fade-in">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold">Listado de Usuarios</h6>
                </div>
                <div class="card-body">
                    <% if (listaUsuarios.isEmpty()) { %>
                    <div class="alert alert-warning">
                        <strong>No se encontraron usuarios en la base de datos.</strong>
                        <p>Verifica que la conexión a la base de datos esté correctamente configurada.</p>
                    </div>
                    <% } else { %>
                    <div class="alert alert-info">
                        <strong>Se encontraron <%= listaUsuarios.size() %> usuarios en la base de datos.</strong>
                    </div>
                    <% } %>

                    <div class="table-responsive">
                        <table class="table table-bordered" id="tablaUsuarios" width="100%" cellspacing="0">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Usuario</th>
                                <th>Nombre Completo</th>
                                <th>Correo</th>
                                <th>Rol</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (UsuarioEntidad user : listaUsuarios) { %>
                            <tr>
                                <td><%= user.getId() %>
                                </td>
                                <td><%= user.getUsuario() %>
                                </td>
                                <td><%= user.getNombreCompleto() %>
                                </td>
                                <td><%= user.getCorreo() %>
                                </td>
                                <td>
                                    <% if (user.getCodRol() != null && user.getCodRol().equals("ADMIN")) { %>
                                    <span class="badge bg-danger">Administrador</span>
                                    <% } else if (user.getCodRol() != null && user.getCodRol().equals("FUNCIONARIO")) { %>
                                    <span class="badge bg-primary">Funcionario</span>
                                    <% } else { %>
                                    <span class="badge bg-secondary"><%= user.getCodRol() != null ? user.getCodRol() : "Sin rol" %></span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (user.getActivo()) { %>
                                    <span class="badge bg-success">Activo</span>
                                    <% } else { %>
                                    <span class="badge bg-danger">Inactivo</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <button type="button" class="btn btn-outline-primary" data-bs-toggle="tooltip"
                                                title="Editar"
                                                onclick="editarUsuario(<%= user.getId() %>, '<%= user.getUsuario().replace("'", "\\'") %>', '<%= user.getNombreCompleto().replace("'", "\\'") %>', '<%= user.getCorreo().replace("'", "\\'") %>', '<%= user.getCodRol() != null ? user.getCodRol() : "FUNCIONARIO" %>', <%= user.getActivo() ? "true" : "false" %>)">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <button type="button" class="btn btn-outline-danger" data-bs-toggle="tooltip"
                                                title="Eliminar"
                                                onclick="confirmarEliminacion(<%= user.getId() %>, '<%= user.getNombreCompleto().replace("'", "\\'") %>')">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                        <a href="<%= request.getContextPath() %>/usuarios.do?accion=ver&id=<%= user.getId() %>"
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

<!-- Modal Nuevo Usuario -->
<div class="modal fade" id="nuevoUsuarioModal" tabindex="-1" aria-labelledby="nuevoUsuarioModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="nuevoUsuarioModalLabel"><i class="bi bi-person-plus me-2"></i>Nuevo Usuario
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/usuarios.do" method="post" id="formNuevoUsuario">
                <input type="hidden" name="accion" value="registrar">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="usuario" class="form-label">Usuario</label>
                        <input type="text" class="form-control" id="usuario" name="usuario" required>
                    </div>
                    <div class="mb-3">
                        <label for="nombre" class="form-label">Nombre Completo</label>
                        <input type="text" class="form-control" id="nombre" name="nombre" required>
                    </div>
                    <div class="mb-3">
                        <label for="correo" class="form-label">Correo Electrónico</label>
                        <input type="email" class="form-control" id="correo" name="correo" required>
                    </div>
                    <div class="mb-3">
                        <label for="clave" class="form-label">Contraseña</label>
                        <input type="password" class="form-control" id="clave" name="clave" required>
                    </div>
                    <div class="mb-3">
                        <label for="rol" class="form-label">Rol</label>
                        <select class="form-select" id="rol" name="rol" required>
                            <option value="">Seleccione un rol</option>
                            <option value="ADMIN">Administrador</option>
                            <option value="FUNCIONARIO">Funcionario</option>
                        </select>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="activo" name="activo" checked>
                        <label class="form-check-label" for="activo">Usuario activo</label>
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

<!-- Modal Editar Usuario -->
<div class="modal fade" id="editarUsuarioModal" tabindex="-1" aria-labelledby="editarUsuarioModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="editarUsuarioModalLabel"><i class="bi bi-pencil me-2"></i>Editar Usuario
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <form action="<%= request.getContextPath() %>/usuarios.do" method="post" id="formEditarUsuario">
                <input type="hidden" name="accion" value="actualizar">
                <input type="hidden" name="id" id="editId">
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="editUsuario" class="form-label">Usuario</label>
                        <input type="text" class="form-control" id="editUsuario" name="usuario" required>
                    </div>
                    <div class="mb-3">
                        <label for="editNombre" class="form-label">Nombre Completo</label>
                        <input type="text" class="form-control" id="editNombre" name="nombre" required>
                    </div>
                    <div class="mb-3">
                        <label for="editCorreo" class="form-label">Correo Electrónico</label>
                        <input type="email" class="form-control" id="editCorreo" name="correo" required>
                    </div>
                    <div class="mb-3">
                        <label for="editClave" class="form-label">Nueva Contraseña (dejar vacío para mantener la
                            actual)</label>
                        <input type="password" class="form-control" id="editClave" name="clave">
                    </div>
                    <div class="mb-3">
                        <label for="editRol" class="form-label">Rol</label>
                        <select class="form-select" id="editRol" name="rol" required>
                            <option value="">Seleccione un rol</option>
                            <option value="ADMIN">Administrador</option>
                            <option value="FUNCIONARIO">Funcionario</option>
                        </select>
                    </div>
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="editActivo" name="activo">
                        <label class="form-check-label" for="editActivo">Usuario activo</label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-primary">Actualizar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Modal Confirmar Eliminación -->
<div class="modal fade" id="eliminarUsuarioModal" tabindex="-1" aria-labelledby="eliminarUsuarioModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header bg-danger text-white">
                <h5 class="modal-title" id="eliminarUsuarioModalLabel"><i class="bi bi-exclamation-triangle me-2"></i>Confirmar
                    Desactivación</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                        aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro que desea desactivar al usuario <strong id="nombreUsuarioEliminar"></strong>?</p>
                <p>El usuario ya no podrá acceder al sistema, pero sus datos permanecerán almacenados.</p>
            </div>
            <div class="modal-footer">
                <form action="<%= request.getContextPath() %>/usuarios.do" method="post" id="formEliminarUsuario">
                    <input type="hidden" name="accion" value="eliminar">
                    <input type="hidden" name="id" id="idUsuarioEliminar">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-danger">Desactivar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<footer class="footer py-3 mt-5 bg-light border-top">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-6 small text-muted">
                &copy; <%= java.time.Year.now().getValue() %> Portal de Transparencia Perú | Todos los derechos
                reservados
            </div>
            <div class="col-md-6 text-md-end small">
                <a href="#" class="text-decoration-none text-muted me-3">Términos de Uso</a>
                <a href="#" class="text-decoration-none text-muted me-3">Política de Privacidad</a>
                <a href="#" class="text-decoration-none text-muted">Contacto</a>
            </div>
        </div>
    </div>
</footer>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/dataTables.bootstrap5.min.js"></script>
<script src="<%= request.getContextPath() %>/js/usuarios.js"></script>
</body>
</html>
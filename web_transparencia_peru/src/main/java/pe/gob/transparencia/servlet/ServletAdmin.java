package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.gob.transparencia.dao.DAOFactory;
import pe.gob.transparencia.entidades.UsuarioEntidad;
import pe.gob.transparencia.interfaces.UsuarioInterface;
import pe.gob.transparencia.modelo.UsuarioModelo;
import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.modelo.EntidadPublicaModelo;
import pe.gob.transparencia.entidades.CiudadanoEntidad;
import pe.gob.transparencia.modelo.CiudadanoModelo;
import pe.gob.transparencia.entidades.PresupuestoEntidad;
import pe.gob.transparencia.modelo.PresupuestoModelo;
import pe.gob.transparencia.entidades.SolicitudAccesoEntidad;
import pe.gob.transparencia.modelo.SolicitudAccesoModelo;
import pe.gob.transparencia.entidades.InformeEntidad;
import pe.gob.transparencia.modelo.InformeModelo;
import pe.gob.transparencia.entidades.TipoSolicitudEntidad;
import pe.gob.transparencia.entidades.EstadoSolicitudEntidad;
import pe.gob.transparencia.entidades.RespuestaSolicitudEntidad;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ServletAdmin", urlPatterns = {"/admin.do"})
public class ServletAdmin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();
        System.out.println("ServletAdmin doGet - acción: " + accion);

        // Verificar autenticación
        if (session.getAttribute("usuario") == null ||
                !((UsuarioEntidad) session.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
            return;
        }

        if (accion == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            return;
        }

        switch (accion) {
            case "listarUsuarios":
                listarUsuarios(request, response);
                break;
            case "listarEntidades":
                response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
                break;
            case "listarCiudadanos":
                response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
                break;
            case "eliminarUsuario":
                eliminarUsuario(request, response);
                break;
            case "editarUsuario":
                editarUsuario(request, response);
                break;
            case "verDetalleUsuario":
                verDetalleUsuario(request, response);
                break;
            case "verDetalleEntidad":
                verDetalleEntidad(request, response);
                break;
            case "editarEntidad":
                editarEntidad(request, response);
                break;
            case "eliminarEntidad":
                eliminarEntidad(request, response);
                break;
            case "verDetalleCiudadano":
                verDetalleCiudadano(request, response);
                break;
            case "editarCiudadano":
                editarCiudadano(request, response);
                break;
            case "verDetallePresupuesto":
                verDetallePresupuesto(request, response);
                break;
            case "editarPresupuesto":
                editarPresupuesto(request, response);
                break;
            case "listarPresupuestos":
                response.sendRedirect(request.getContextPath() + "/admin/presupuestos.jsp");
                break;
            case "verDetalleSolicitud":
                verDetalleSolicitud(request, response);
                break;
            case "editarSolicitud":
                editarSolicitud(request, response);
                break;
            case "listarSolicitudes":
                response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
                break;
            case "listarInformes":
                response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
                break;
            case "verDetalleInforme":
                verDetalleInforme(request, response);
                break;
            case "editarInforme":
                editarInforme(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();
        System.out.println("ServletAdmin doPost - acción: " + accion);

        // Verificar autenticación
        if (session.getAttribute("usuario") == null ||
                !((UsuarioEntidad) session.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
            return;
        }

        if (accion == null) {
            response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
            return;
        }

        switch (accion) {
            case "registrarUsuario":
                registrarUsuario(request, response);
                break;
            case "actualizarUsuario":
                actualizarUsuario(request, response);
                break;
            case "registrarEntidad":
                registrarEntidad(request, response);
                break;
            case "actualizarEntidad":
                actualizarEntidad(request, response);
                break;
            case "eliminarEntidad":
                eliminarEntidad(request, response);
                break;
            case "registrarCiudadano":
                registrarCiudadano(request, response);
                break;
            case "actualizarCiudadano":
                actualizarCiudadano(request, response);
                break;
            case "eliminarCiudadano":
                eliminarCiudadano(request, response);
                break;
            case "registrarPresupuesto":
                registrarPresupuesto(request, response);
                break;
            case "actualizarPresupuesto":
                actualizarPresupuesto(request, response);
                break;
            case "eliminarPresupuesto":
                eliminarPresupuesto(request, response);
                break;
            case "actualizarSolicitud":
                actualizarSolicitud(request, response);
                break;
            case "eliminarSolicitud":
                eliminarSolicitud(request, response);
                break;
            case "registrarInforme":
                registrarInforme(request, response);
                break;
            case "actualizarInforme":
                actualizarInforme(request, response);
                break;
            case "eliminarInforme":
                eliminarInforme(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/index.jsp");
                break;
        }
    }

    private void registrarUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        String usuario = request.getParameter("usuario");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");
        String rol = request.getParameter("rol");
        boolean activo = request.getParameter("activo") != null;

        HttpSession session = request.getSession();

        try {
            // Validar datos
            if (usuario == null || usuario.isEmpty() || nombre == null || nombre.isEmpty() ||
                    correo == null || correo.isEmpty() || clave == null || clave.isEmpty() ||
                    rol == null || rol.isEmpty()) {

                session.setAttribute("mensaje", "Todos los campos son obligatorios.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                return;
            }

            // Crear objeto de usuario
            UsuarioEntidad nuevoUsuario = new UsuarioEntidad();
            nuevoUsuario.setUsuario(usuario);
            nuevoUsuario.setNombreCompleto(nombre);
            nuevoUsuario.setCorreo(correo);
            nuevoUsuario.setClave(clave);
            nuevoUsuario.setCodRol(rol);
            nuevoUsuario.setActivo(activo);

            // Registrar usuario usando el modelo
            UsuarioModelo modelo = new UsuarioModelo();
            int resultado = modelo.registrarUsuario(nuevoUsuario);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Usuario registrado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else if (resultado == -1) {
                session.setAttribute("mensaje", "El nombre de usuario ya existe en el sistema.");
                session.setAttribute("tipoMensaje", "danger");
            } else if (resultado == -2) {
                session.setAttribute("mensaje", "El correo electrónico ya está registrado en el sistema.");
                session.setAttribute("tipoMensaje", "danger");
            } else {
                session.setAttribute("mensaje", "Error al registrar usuario.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
    }

    private void actualizarUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        int id = Integer.parseInt(request.getParameter("id"));
        String usuario = request.getParameter("usuario");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave"); // Puede ser nulo o vacío si no se actualiza
        String rol = request.getParameter("rol");
        boolean activo = request.getParameter("activo") != null;

        HttpSession session = request.getSession();

        try {
            // Validar datos
            if (usuario == null || usuario.isEmpty() || nombre == null || nombre.isEmpty() ||
                    correo == null || correo.isEmpty() || rol == null || rol.isEmpty()) {

                session.setAttribute("mensaje", "Los campos usuario, nombre, correo y rol son obligatorios.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                return;
            }

            // Obtener usuario actual
            UsuarioModelo modelo = new UsuarioModelo();
            UsuarioEntidad usuarioActual = modelo.buscarPorId(id);

            if (usuarioActual == null) {
                session.setAttribute("mensaje", "No se encontró el usuario a actualizar.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                return;
            }

            // Actualizar datos
            usuarioActual.setUsuario(usuario);
            usuarioActual.setNombreCompleto(nombre);
            usuarioActual.setCorreo(correo);
            // Solo actualizar clave si se proporcionó una nueva
            if (clave != null && !clave.isEmpty()) {
                usuarioActual.setClave(clave);
            }
            usuarioActual.setCodRol(rol);
            usuarioActual.setActivo(activo);

            // Actualizar usuario
            int resultado = modelo.actualizarUsuario(usuarioActual);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Usuario actualizado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else if (resultado == -1) {
                session.setAttribute("mensaje", "Error: El nombre de usuario ya existe en el sistema.");
                session.setAttribute("tipoMensaje", "danger");
            } else if (resultado == -2) {
                session.setAttribute("mensaje", "Error: El correo electrónico ya está registrado en el sistema.");
                session.setAttribute("tipoMensaje", "danger");
            } else {
                session.setAttribute("mensaje", "Error al actualizar usuario.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
    }

    private void eliminarUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener ID a eliminar
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();

        try {
            // Verificar que no se esté eliminando al usuario actual
            UsuarioEntidad usuarioActual = (UsuarioEntidad) session.getAttribute("usuario");
            if (usuarioActual != null && usuarioActual.getId() == id) {
                session.setAttribute("mensaje", "No puede desactivar su propio usuario.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                return;
            }

            // Eliminar usuario
            UsuarioModelo modelo = new UsuarioModelo();

            // Verificar que el usuario existe
            UsuarioEntidad usuario = modelo.buscarPorId(id);
            if (usuario == null) {
                session.setAttribute("mensaje", "Error: El usuario que intenta desactivar no existe.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                return;
            }

            int resultado = modelo.eliminarUsuario(id);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Usuario desactivado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al desactivar usuario: No se pudo completar la operación.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error al desactivar usuario: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
    }

    private void editarUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            UsuarioModelo modelo = new UsuarioModelo();
            UsuarioEntidad usuario = modelo.buscarPorId(id);

            if (usuario != null) {
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher("/admin/editar_usuario.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Usuario no encontrado");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
        }
    }

    private void verDetalleUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            UsuarioModelo modelo = new UsuarioModelo();
            UsuarioEntidad usuario = modelo.buscarPorId(id);

            if (usuario != null) {
                request.setAttribute("usuario", usuario);
                request.getRequestDispatcher("/admin/detalle_usuario.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Usuario no encontrado");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
        }
    }

    private void listarUsuarios(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
    }

    // Métodos para gestión de Entidades Públicas
    private void editarEntidad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            EntidadPublicaEntidad entidad = modelo.buscarPorId(id);

            if (entidad != null) {
                request.setAttribute("entidad", entidad);
                request.getRequestDispatcher("/admin/editar_entidad.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Entidad no encontrada");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        }
    }

    private void verDetalleEntidad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            EntidadPublicaEntidad entidad = modelo.buscarPorId(id);

            if (entidad != null) {
                request.setAttribute("entidad", entidad);
                request.getRequestDispatcher("/admin/detalle_entidad.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Entidad no encontrada");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        }
    }

    private void registrarEntidad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        String nombre = request.getParameter("nombre");
        String tipo = request.getParameter("tipo");
        int nivelGobiernoId = Integer.parseInt(request.getParameter("nivelGobiernoId"));
        String regionIdParam = request.getParameter("regionId");
        int regionId = 0;
        if (regionIdParam != null && !regionIdParam.isEmpty()) {
            regionId = Integer.parseInt(regionIdParam);
        }
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String sitioWeb = request.getParameter("sitioWeb");

        HttpSession session = request.getSession();

        try {
            // Validar datos
            if (nombre == null || nombre.isEmpty() || tipo == null || tipo.isEmpty()) {
                session.setAttribute("mensaje", "El nombre y tipo de entidad son obligatorios.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
                return;
            }

            // Crear objeto de entidad
            EntidadPublicaEntidad nuevaEntidad = new EntidadPublicaEntidad();
            nuevaEntidad.setNombre(nombre);
            nuevaEntidad.setTipo(tipo);
            nuevaEntidad.setNivelGobiernoId(nivelGobiernoId);
            nuevaEntidad.setRegionId(regionId);
            nuevaEntidad.setDireccion(direccion);
            nuevaEntidad.setTelefono(telefono);
            nuevaEntidad.setEmail(email);
            nuevaEntidad.setSitioWeb(sitioWeb);

            // Registrar entidad usando el modelo
            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            int resultado = modelo.registrarEntidad(nuevaEntidad);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Entidad registrada correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al registrar entidad. La entidad ya podría existir.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
    }

    private void actualizarEntidad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        int id = Integer.parseInt(request.getParameter("id"));
        String nombre = request.getParameter("nombre");
        String tipo = request.getParameter("tipo");
        int nivelGobiernoId = Integer.parseInt(request.getParameter("nivelGobiernoId"));
        String regionIdParam = request.getParameter("regionId");
        int regionId = 0;
        if (regionIdParam != null && !regionIdParam.isEmpty()) {
            regionId = Integer.parseInt(regionIdParam);
        }
        String direccion = request.getParameter("direccion");
        String telefono = request.getParameter("telefono");
        String email = request.getParameter("email");
        String sitioWeb = request.getParameter("sitioWeb");

        HttpSession session = request.getSession();

        try {
            // Validar datos
            if (nombre == null || nombre.isEmpty() || tipo == null || tipo.isEmpty()) {
                session.setAttribute("mensaje", "El nombre y tipo de entidad son obligatorios.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
                return;
            }

            // Obtener entidad actual
            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            EntidadPublicaEntidad entidadActual = modelo.buscarPorId(id);

            if (entidadActual == null) {
                session.setAttribute("mensaje", "No se encontró la entidad a actualizar.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
                return;
            }

            // Actualizar datos
            entidadActual.setNombre(nombre);
            entidadActual.setTipo(tipo);
            entidadActual.setNivelGobiernoId(nivelGobiernoId);
            entidadActual.setRegionId(regionId);
            entidadActual.setDireccion(direccion);
            entidadActual.setTelefono(telefono);
            entidadActual.setEmail(email);
            entidadActual.setSitioWeb(sitioWeb);

            // Actualizar entidad
            int resultado = modelo.actualizarEntidad(entidadActual);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Entidad actualizada correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al actualizar entidad.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
    }

    private void eliminarEntidad(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener ID a eliminar
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();

        try {
            // Eliminar entidad
            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            int resultado = modelo.eliminarEntidad(id);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Entidad eliminada correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al eliminar entidad.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
    }

    // Métodos para gestión de Ciudadanos
    private void editarCiudadano(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            CiudadanoModelo modelo = new CiudadanoModelo();
            CiudadanoEntidad ciudadano = modelo.buscarPorId(id);

            if (ciudadano != null) {
                request.setAttribute("ciudadano", ciudadano);
                request.getRequestDispatcher("/admin/editar_ciudadano.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Ciudadano no encontrado");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
        }
    }

    private void verDetalleCiudadano(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            CiudadanoModelo modelo = new CiudadanoModelo();
            CiudadanoEntidad ciudadano = modelo.buscarPorId(id);

            if (ciudadano != null) {
                request.setAttribute("ciudadano", ciudadano);
                request.getRequestDispatcher("/admin/detalle_ciudadano.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Ciudadano no encontrado");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
        }
    }

    private void registrarCiudadano(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String dni = request.getParameter("dni");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        try {
            // Validar datos
            if (nombres == null || nombres.isEmpty() || apellidos == null || apellidos.isEmpty() ||
                    dni == null || dni.isEmpty() || correo == null || correo.isEmpty() ||
                    password == null || password.isEmpty()) {
                session.setAttribute("mensaje", "Los campos nombres, apellidos, DNI, correo y contraseña son obligatorios.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
                return;
            }

            // Crear objeto de ciudadano
            CiudadanoModelo modelo = new CiudadanoModelo();
            // Llamar al método con todos los parámetros requeridos
            int resultado = modelo.registrarCiudadano(nombres, apellidos, dni, correo, telefono, direccion, password);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Ciudadano registrado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al registrar ciudadano. El DNI o correo ya podrían existir.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
    }

    private void actualizarCiudadano(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        int id = Integer.parseInt(request.getParameter("id"));
        String nombres = request.getParameter("nombres");
        String apellidos = request.getParameter("apellidos");
        String dni = request.getParameter("dni");
        String correo = request.getParameter("correo");
        String telefono = request.getParameter("telefono");
        String direccion = request.getParameter("direccion");
        String password = request.getParameter("password"); // Puede ser nulo si no se actualiza

        HttpSession session = request.getSession();

        try {
            // Validar datos
            if (nombres == null || nombres.isEmpty() || apellidos == null || apellidos.isEmpty() ||
                    dni == null || dni.isEmpty() || correo == null || correo.isEmpty()) {
                session.setAttribute("mensaje", "Los campos nombres, apellidos, DNI y correo son obligatorios.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
                return;
            }

            // Obtener ciudadano actual
            CiudadanoModelo modelo = new CiudadanoModelo();
            CiudadanoEntidad ciudadanoActual = modelo.buscarPorId(id);

            if (ciudadanoActual == null) {
                session.setAttribute("mensaje", "No se encontró el ciudadano a actualizar.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
                return;
            }

            // Actualizar datos básicos
            int resultado = modelo.actualizarCiudadano(id, nombres, apellidos, dni, correo, telefono, direccion);

            // Si se proporcionó una nueva contraseña, actualizarla
            if (password != null && !password.isEmpty()) {
                modelo.actualizarPassword(id, password);
            }

            if (resultado > 0) {
                session.setAttribute("mensaje", "Ciudadano actualizado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al actualizar ciudadano.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
    }

    private void eliminarCiudadano(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener ID a eliminar
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();

        try {
            // Eliminar ciudadano
            CiudadanoModelo modelo = new CiudadanoModelo();

            // Verificar que el ciudadano existe
            CiudadanoEntidad ciudadano = modelo.buscarPorId(id);
            if (ciudadano == null) {
                session.setAttribute("mensaje", "Error: El ciudadano que intenta eliminar no existe.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
                return;
            }

            // Proceder con la eliminación
            int resultado = modelo.eliminarCiudadano(id);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Ciudadano eliminado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al eliminar ciudadano: No se pudo completar la operación.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error al eliminar ciudadano: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
    }

    // Métodos para gestión de Presupuestos
    private void editarPresupuesto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            PresupuestoModelo modelo = new PresupuestoModelo();
            PresupuestoEntidad presupuesto = modelo.buscarPorId(id);

            if (presupuesto != null) {
                // Obtener entidades para el formulario
                EntidadPublicaModelo modeloEntidad = new EntidadPublicaModelo();
                List<EntidadPublicaEntidad> listaEntidades = modeloEntidad.listarEntidades();

                request.setAttribute("presupuesto", presupuesto);
                request.setAttribute("listaEntidades", listaEntidades);
                request.getRequestDispatcher("/admin/editar_presupuesto.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Presupuesto no encontrado");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/presupuestos.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/presupuestos.jsp");
        }
    }

    private void verDetallePresupuesto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            PresupuestoModelo modelo = new PresupuestoModelo();
            PresupuestoEntidad presupuesto = modelo.buscarPorId(id);

            if (presupuesto != null) {
                request.setAttribute("presupuesto", presupuesto);
                request.getRequestDispatcher("/admin/detalle_presupuesto.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Presupuesto no encontrado");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/presupuestos.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/presupuestos.jsp");
        }
    }

    private void registrarPresupuesto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        int anio = Integer.parseInt(request.getParameter("anio"));
        int entidadPublicaId = Integer.parseInt(request.getParameter("entidadPublicaId"));
        double montoTotal = Double.parseDouble(request.getParameter("montoTotal"));
        String fechaAprobacionStr = request.getParameter("fechaAprobacion");
        String descripcion = request.getParameter("descripcion");
        String estado = request.getParameter("estado");
        String periodoFiscalIdStr = request.getParameter("periodoFiscalId");

        HttpSession session = request.getSession();

        try {
            // Crear objeto de presupuesto
            PresupuestoEntidad nuevoPpto = new PresupuestoEntidad();
            nuevoPpto.setAnio(anio);

            EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
            entidad.setId(entidadPublicaId);
            nuevoPpto.setEntidadPublica(entidad);
            nuevoPpto.setEntidadPublicaId(entidadPublicaId);

            // Convertir double a BigDecimal
            nuevoPpto.setMontoTotal(new java.math.BigDecimal(String.valueOf(montoTotal)));

            // Registrar presupuesto usando el modelo
            PresupuestoModelo modelo = new PresupuestoModelo();
            int resultado = modelo.insertar(nuevoPpto);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Presupuesto registrado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al registrar presupuesto.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/presupuestos.jsp");
    }

    private void actualizarPresupuesto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        int id = Integer.parseInt(request.getParameter("id"));
        int anio = Integer.parseInt(request.getParameter("anio"));
        int entidadPublicaId = Integer.parseInt(request.getParameter("entidadPublicaId"));
        double montoTotal = Double.parseDouble(request.getParameter("montoTotal"));
        String fechaAprobacionStr = request.getParameter("fechaAprobacion");
        String descripcion = request.getParameter("descripcion");
        String estado = request.getParameter("estado");
        String periodoFiscalIdStr = request.getParameter("periodoFiscalId");

        HttpSession session = request.getSession();

        try {
            // Obtener presupuesto actual
            PresupuestoModelo modelo = new PresupuestoModelo();
            PresupuestoEntidad presupuesto = modelo.buscarPorId(id);

            if (presupuesto == null) {
                session.setAttribute("mensaje", "No se encontró el presupuesto a actualizar.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/presupuestos.jsp");
                return;
            }

            // Actualizar datos
            presupuesto.setAnio(anio);

            EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
            entidad.setId(entidadPublicaId);
            presupuesto.setEntidadPublica(entidad);
            presupuesto.setEntidadPublicaId(entidadPublicaId);

            // Convertir double a BigDecimal
            presupuesto.setMontoTotal(new java.math.BigDecimal(String.valueOf(montoTotal)));

            // Actualizar presupuesto
            int resultado = modelo.actualizar(presupuesto);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Presupuesto actualizado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al actualizar presupuesto.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/presupuestos.jsp");
    }

    private void eliminarPresupuesto(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener ID a eliminar
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();

        try {
            // Eliminar presupuesto
            PresupuestoModelo modelo = new PresupuestoModelo();
            int resultado = modelo.eliminar(id);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Presupuesto eliminado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al eliminar presupuesto.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/presupuestos.jsp");
    }

    // Métodos para gestión de Solicitudes
    private void editarSolicitud(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            SolicitudAccesoEntidad solicitud = modelo.buscarPorId(id);

            if (solicitud != null) {
                // Obtener datos para los selectores
                EntidadPublicaModelo modeloEntidad = new EntidadPublicaModelo();
                List<EntidadPublicaEntidad> listaEntidades = modeloEntidad.listarEntidades();

                // Buscar tipos y estados de solicitudes
                List<TipoSolicitudEntidad> listaTipos = modelo.listarTiposSolicitud();
                List<EstadoSolicitudEntidad> listaEstados = modelo.listarEstadosSolicitud();

                request.setAttribute("solicitud", solicitud);
                request.setAttribute("listaEntidades", listaEntidades);
                request.setAttribute("listaTipos", listaTipos);
                request.setAttribute("listaEstados", listaEstados);
                request.getRequestDispatcher("/admin/editar_solicitud.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Solicitud no encontrada");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
        }
    }

    private void verDetalleSolicitud(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            SolicitudAccesoEntidad solicitud = modelo.buscarPorId(id);

            if (solicitud != null) {
                // Verificar si tiene respuesta
                RespuestaSolicitudEntidad respuesta = modelo.buscarRespuestaPorSolicitudId(id);
                if (respuesta != null) {
                    request.setAttribute("respuesta", respuesta);
                }

                request.setAttribute("solicitud", solicitud);
                request.getRequestDispatcher("/admin/detalle_solicitud.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Solicitud no encontrada");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
        }
    }

    private void actualizarSolicitud(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        int id = Integer.parseInt(request.getParameter("id"));
        String descripcion = request.getParameter("descripcion");
        int tipoSolicitudId = Integer.parseInt(request.getParameter("tipoSolicitudId"));
        int estadoSolicitudId = Integer.parseInt(request.getParameter("estadoSolicitudId"));
        int entidadPublicaId = Integer.parseInt(request.getParameter("entidadPublicaId"));
        String observaciones = request.getParameter("observaciones");

        HttpSession session = request.getSession();

        try {
            // Obtener solicitud actual
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            SolicitudAccesoEntidad solicitud = modelo.buscarPorId(id);

            if (solicitud == null) {
                session.setAttribute("mensaje", "No se encontró la solicitud a actualizar.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
                return;
            }

            // Actualizar datos
            solicitud.setDescripcion(descripcion);

            // Actualizar tipo de solicitud
            TipoSolicitudEntidad tipoSolicitud = new TipoSolicitudEntidad();
            tipoSolicitud.setId(tipoSolicitudId);
            solicitud.setTipoSolicitud(tipoSolicitud);

            // Actualizar estado de solicitud
            EstadoSolicitudEntidad estadoSolicitud = new EstadoSolicitudEntidad();
            estadoSolicitud.setId(estadoSolicitudId);
            solicitud.setEstadoSolicitud(estadoSolicitud);

            // Actualizar entidad pública
            EntidadPublicaEntidad entidadPublica = new EntidadPublicaEntidad();
            entidadPublica.setId(entidadPublicaId);
            solicitud.setEntidadPublica(entidadPublica);

            solicitud.setObservaciones(observaciones);

            // Actualizar solicitud
            int resultado = modelo.actualizarSolicitud(solicitud);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Solicitud actualizada correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al actualizar solicitud.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
    }

    private void eliminarSolicitud(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener ID a eliminar
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();

        try {
            // Eliminar solicitud
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            int resultado = modelo.eliminarSolicitud(id);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Solicitud eliminada correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al eliminar solicitud.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
    }

    // Métodos para gestión de Informes
    private void editarInforme(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            InformeModelo modelo = new InformeModelo();
            InformeEntidad informe = modelo.buscarPorId(id);

            if (informe != null) {
                request.setAttribute("informe", informe);
                request.getRequestDispatcher("/admin/editar_informe.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Informe no encontrado");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
        }
    }

    private void verDetalleInforme(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            InformeModelo modelo = new InformeModelo();
            InformeEntidad informe = modelo.buscarPorId(id);

            if (informe != null) {
                request.setAttribute("informe", informe);
                request.getRequestDispatcher("/admin/detalle_informe.jsp").forward(request, response);
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Informe no encontrado");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
            }
        } catch (Exception e) {
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
        }
    }

    private void registrarInforme(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        String titulo = request.getParameter("titulo");
        String tipo = request.getParameter("tipo");
        int anio = Integer.parseInt(request.getParameter("anio"));
        String nivelGobierno = request.getParameter("nivelGobierno");
        String descripcion = request.getParameter("descripcion");
        String datosJson = request.getParameter("datosJson");
        String estado = "Activo";

        HttpSession session = request.getSession();

        try {
            // Validar datos
            if (titulo == null || titulo.isEmpty() || tipo == null || tipo.isEmpty()) {
                session.setAttribute("mensaje", "El título y tipo de informe son obligatorios.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
                return;
            }

            // Crear objeto de informe
            InformeEntidad nuevoInforme = new InformeEntidad();
            nuevoInforme.setTitulo(titulo);
            nuevoInforme.setTipo(tipo);
            nuevoInforme.setAnio(anio);
            nuevoInforme.setFechaGeneracion(new java.util.Date()); // Fecha actual
            nuevoInforme.setNivelGobierno(nivelGobierno);
            nuevoInforme.setDescripcion(descripcion);
            nuevoInforme.setEstado(estado);
            nuevoInforme.setRutaArchivo(""); // Se puede implementar la carga de archivos después
            nuevoInforme.setDatosJson(datosJson);

            // Registrar informe usando el modelo
            InformeModelo modelo = new InformeModelo();
            int resultado = modelo.registrarInforme(nuevoInforme);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Informe registrado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al registrar informe.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
    }

    private void actualizarInforme(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener parámetros
        int id = Integer.parseInt(request.getParameter("id"));
        String titulo = request.getParameter("titulo");
        String tipo = request.getParameter("tipo");
        int anio = Integer.parseInt(request.getParameter("anio"));
        String nivelGobierno = request.getParameter("nivelGobierno");
        String descripcion = request.getParameter("descripcion");
        String estado = request.getParameter("estado");
        String datosJson = request.getParameter("datosJson");

        HttpSession session = request.getSession();

        try {
            // Validar datos
            if (titulo == null || titulo.isEmpty() || tipo == null || tipo.isEmpty()) {
                session.setAttribute("mensaje", "El título y tipo de informe son obligatorios.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
                return;
            }

            // Obtener informe actual
            InformeModelo modelo = new InformeModelo();
            InformeEntidad informe = modelo.buscarPorId(id);

            if (informe == null) {
                session.setAttribute("mensaje", "No se encontró el informe a actualizar.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
                return;
            }

            // Actualizar datos
            informe.setTitulo(titulo);
            informe.setTipo(tipo);
            informe.setAnio(anio);
            informe.setNivelGobierno(nivelGobierno);
            informe.setDescripcion(descripcion);
            informe.setEstado(estado);
            if (datosJson != null && !datosJson.isEmpty()) {
                informe.setDatosJson(datosJson);
            }

            // Actualizar informe
            int resultado = modelo.actualizarInforme(informe);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Informe actualizado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al actualizar informe.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
    }

    private void eliminarInforme(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Obtener ID a eliminar
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();

        try {
            // Eliminar informe
            InformeModelo modelo = new InformeModelo();
            int resultado = modelo.eliminarInforme(id);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Informe eliminado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al eliminar informe.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/informes.jsp");
    }
}
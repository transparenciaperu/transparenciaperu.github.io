package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.gob.transparencia.entidades.UsuarioEntidad;
import pe.gob.transparencia.modelo.UsuarioModelo;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet dedicado específicamente para las operaciones CRUD de usuarios
 */
@WebServlet(name = "ServletUsuarios", urlPatterns = {"/usuarios.do"})
public class ServletUsuarios extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();

        System.out.println("ServletUsuarios doGet - acción: " + accion);

        // Verificar autenticación
        if (session.getAttribute("usuario") == null ||
                !((UsuarioEntidad) session.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
            return;
        }

        if (accion == null) {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
            return;
        }

        switch (accion) {
            case "listar":
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                break;
            case "ver":
                verDetalleUsuario(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();

        System.out.println("ServletUsuarios doPost - acción: " + accion);

        // Verificar autenticación
        if (session.getAttribute("usuario") == null ||
                !((UsuarioEntidad) session.getAttribute("usuario")).getCodRol().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
            return;
        }

        if (accion == null) {
            response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
            return;
        }

        // Formato de respuesta
        boolean esAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));

        try {
            int resultado = -1;
            String mensaje = "";

            switch (accion) {
                case "registrar":
                    resultado = registrarUsuario(request);
                    mensaje = (resultado > 0) ? "Usuario registrado correctamente" : "Error al registrar el usuario";
                    break;
                case "actualizar":
                    resultado = actualizarUsuario(request);
                    mensaje = (resultado > 0) ? "Usuario actualizado correctamente" : "Error al actualizar el usuario";
                    break;
                case "eliminar":
                    resultado = eliminarUsuario(request);
                    mensaje = (resultado > 0) ? "Usuario desactivado correctamente" : "Error al desactivar el usuario";
                    break;
                default:
                    mensaje = "Acción no reconocida";
                    break;
            }

            // Si es una petición AJAX, devolver respuesta JSON
            if (esAjax) {
                response.setContentType("application/json");
                Map<String, Object> respuesta = new HashMap<>();
                respuesta.put("exito", resultado > 0);
                respuesta.put("mensaje", mensaje);

                PrintWriter out = response.getWriter();
                out.print(respuesta.toString());
                out.flush();
            }
            // Si no es AJAX, usar el enfoque tradicional con redirección
            else {
                if (resultado > 0) {
                    session.setAttribute("mensaje", mensaje);
                    session.setAttribute("tipoMensaje", "success");
                } else {
                    session.setAttribute("mensaje", mensaje);
                    session.setAttribute("tipoMensaje", "danger");
                }
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
            }

        } catch (Exception e) {
            System.out.println("Error en ServletUsuarios: " + e.getMessage());
            e.printStackTrace();

            if (esAjax) {
                response.setContentType("application/json");
                Map<String, Object> respuesta = new HashMap<>();
                respuesta.put("exito", false);
                respuesta.put("mensaje", "Error en el servidor: " + e.getMessage());

                PrintWriter out = response.getWriter();
                out.print(respuesta.toString());
                out.flush();
            } else {
                session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
            }
        }
    }

    /**
     * Registra un nuevo usuario
     */
    private int registrarUsuario(HttpServletRequest request) throws Exception {
        // Obtener parámetros
        String usuario = request.getParameter("usuario");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave");
        String rol = request.getParameter("rol");
        boolean activo = request.getParameter("activo") != null;

        // Validar datos
        if (usuario == null || usuario.isEmpty() || nombre == null || nombre.isEmpty() ||
                correo == null || correo.isEmpty() || clave == null || clave.isEmpty() ||
                rol == null || rol.isEmpty()) {
            throw new Exception("Todos los campos son obligatorios");
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
        return modelo.registrarUsuario(nuevoUsuario);
    }

    /**
     * Actualiza un usuario existente
     */
    private int actualizarUsuario(HttpServletRequest request) throws Exception {
        // Obtener parámetros
        int id = Integer.parseInt(request.getParameter("id"));
        String usuario = request.getParameter("usuario");
        String nombre = request.getParameter("nombre");
        String correo = request.getParameter("correo");
        String clave = request.getParameter("clave"); // Puede ser nulo o vacío si no se actualiza
        String rol = request.getParameter("rol");
        boolean activo = request.getParameter("activo") != null;

        // Validar datos
        if (usuario == null || usuario.isEmpty() || nombre == null || nombre.isEmpty() ||
                correo == null || correo.isEmpty() || rol == null || rol.isEmpty()) {
            throw new Exception("Los campos usuario, nombre, correo y rol son obligatorios");
        }

        // Obtener usuario actual
        UsuarioModelo modelo = new UsuarioModelo();
        UsuarioEntidad usuarioActual = modelo.buscarPorId(id);

        if (usuarioActual == null) {
            throw new Exception("No se encontró el usuario a actualizar");
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
        return modelo.actualizarUsuario(usuarioActual);
    }

    /**
     * Elimina/desactiva un usuario
     */
    private int eliminarUsuario(HttpServletRequest request) throws Exception {
        // Obtener ID a eliminar
        int id = Integer.parseInt(request.getParameter("id"));
        HttpSession session = request.getSession();

        // Verificar que no se esté eliminando al usuario actual
        UsuarioEntidad usuarioActual = (UsuarioEntidad) session.getAttribute("usuario");
        if (usuarioActual != null && usuarioActual.getId() == id) {
            throw new Exception("No puede desactivar su propio usuario");
        }

        // Eliminar usuario
        UsuarioModelo modelo = new UsuarioModelo();

        // Verificar que el usuario existe
        UsuarioEntidad usuario = modelo.buscarPorId(id);
        if (usuario == null) {
            throw new Exception("El usuario que intenta desactivar no existe");
        }

        return modelo.eliminarUsuario(id);
    }

    /**
     * Muestra la vista detalle de un usuario
     */
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
}
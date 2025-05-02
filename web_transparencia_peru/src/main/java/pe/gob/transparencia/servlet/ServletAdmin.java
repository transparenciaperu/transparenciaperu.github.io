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

import java.io.IOException;

@WebServlet(name = "ServletAdmin", urlPatterns = {"/admin.do"})
public class ServletAdmin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();

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
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                break;
            case "listarEntidades":
                response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
                break;
            case "listarCiudadanos":
                response.sendRedirect(request.getContextPath() + "/admin/ciudadanos.jsp");
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
            case "eliminarUsuario":
                eliminarUsuario(request, response);
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
            nuevoUsuario.setClave(clave); // En implementación real, esto debería estar encriptado
            nuevoUsuario.setCodRol(rol);
            nuevoUsuario.setActivo(activo);

            // Registrar usuario usando el modelo
            UsuarioModelo modelo = new UsuarioModelo();
            int resultado = modelo.registrarUsuario(nuevoUsuario);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Usuario registrado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al registrar usuario. El usuario o correo ya podría existir.");
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
                usuarioActual.setClave(clave); // En implementación real, esto debería estar encriptado
            }
            usuarioActual.setCodRol(rol);
            usuarioActual.setActivo(activo);

            // Actualizar usuario
            int resultado = modelo.actualizarUsuario(usuarioActual);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Usuario actualizado correctamente.");
                session.setAttribute("tipoMensaje", "success");
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
                session.setAttribute("mensaje", "No puede eliminar su propio usuario.");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
                return;
            }

            // Eliminar usuario
            UsuarioModelo modelo = new UsuarioModelo();
            int resultado = modelo.eliminarUsuario(id);

            if (resultado > 0) {
                session.setAttribute("mensaje", "Usuario eliminado correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al eliminar usuario.");
                session.setAttribute("tipoMensaje", "danger");
            }
        } catch (Exception e) {
            session.setAttribute("mensaje", "Error en el sistema: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/usuarios.jsp");
    }
}
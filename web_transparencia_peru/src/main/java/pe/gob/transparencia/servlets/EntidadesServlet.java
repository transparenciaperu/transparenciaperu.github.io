package pe.gob.transparencia.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.entidades.UsuarioEntidad;
import pe.gob.transparencia.modelo.EntidadPublicaModelo;
import pe.gob.transparencia.modelo.NivelGobiernoModelo;
import pe.gob.transparencia.modelo.RegionModelo;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "EntidadesServlet", urlPatterns = {"/entidades.do"})
public class EntidadesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        System.out.println("EntidadesServlet - doGet - Acción: " + accion);

        // Verificar si el usuario tiene permiso
        HttpSession session = request.getSession();
        UsuarioEntidad usuario = (UsuarioEntidad) session.getAttribute("usuario");

        if (usuario == null || !usuario.getCodRol().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
            return;
        }

        if (accion != null) {
            switch (accion) {
                case "listar":
                    listarEntidades(request, response);
                    break;
                case "verDetalle":
                    verDetalleEntidad(request, response);
                    break;
                case "formEditar":
                    mostrarFormularioEditar(request, response);
                    break;
                default:
                    // Por defecto, mostrar lista
                    listarEntidades(request, response);
                    break;
            }
        } else {
            // Sin acción especificada, mostrar lista
            listarEntidades(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        System.out.println("EntidadesServlet - doPost - Acción: " + accion);

        // Verificar si el usuario tiene permiso
        HttpSession session = request.getSession();
        UsuarioEntidad usuario = (UsuarioEntidad) session.getAttribute("usuario");

        if (usuario == null || !usuario.getCodRol().equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
            return;
        }

        if (accion != null) {
            switch (accion) {
                case "registrar":
                    registrarEntidad(request, response);
                    break;
                case "actualizar":
                    actualizarEntidad(request, response);
                    break;
                case "eliminar":
                    eliminarEntidad(request, response);
                    break;
                default:
                    // Por defecto, redirigir a la lista
                    response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
                    break;
            }
        } else {
            // Sin acción especificada, redirigir a la lista
            response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        }
    }

    /**
     * Método para listar todas las entidades y redirigir a la vista correspondiente
     */
    private void listarEntidades(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            List<EntidadPublicaEntidad> entidades = modelo.listarEntidades();

            // Obtener niveles de gobierno y regiones para los formularios
            NivelGobiernoModelo nivelModelo = new NivelGobiernoModelo();
            RegionModelo regionModelo = new RegionModelo();

            request.setAttribute("entidades", entidades);
            request.setAttribute("niveles", nivelModelo.listar());
            request.setAttribute("regiones", regionModelo.listar());

            request.getRequestDispatcher("/admin/entidades.jsp").forward(request, response);
        } catch (Exception e) {
            System.out.println("Error al listar entidades: " + e.getMessage());
            e.printStackTrace();

            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error al cargar las entidades: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");

            response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        }
    }

    /**
     * Método para registrar una nueva entidad
     */
    private void registrarEntidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();

            // Obtener datos del formulario
            entidad.setNombre(request.getParameter("nombre"));
            entidad.setTipo(request.getParameter("tipo"));
            entidad.setDireccion(request.getParameter("direccion"));

            // Convertir parámetros numéricos
            String nivelGobiernoStr = request.getParameter("nivelGobiernoId");
            if (nivelGobiernoStr != null && !nivelGobiernoStr.isEmpty()) {
                entidad.setNivelGobiernoId(Integer.parseInt(nivelGobiernoStr));
            }

            String regionIdStr = request.getParameter("regionId");
            if (regionIdStr != null && !regionIdStr.isEmpty()) {
                entidad.setRegionId(Integer.parseInt(regionIdStr));
            } else if ("1".equals(nivelGobiernoStr)) {
                // Para nivel nacional, no se requiere región
                entidad.setRegionId(0);
            }

            entidad.setTelefono(request.getParameter("telefono"));
            entidad.setEmail(request.getParameter("email"));
            entidad.setSitioWeb(request.getParameter("sitioWeb"));

            // Registrar la entidad
            int resultado = modelo.registrarEntidad(entidad);

            HttpSession session = request.getSession();
            if (resultado > 0) {
                session.setAttribute("mensaje", "Entidad pública registrada correctamente.");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "No se pudo registrar la entidad pública.");
                session.setAttribute("tipoMensaje", "warning");
            }
        } catch (Exception e) {
            System.out.println("Error al registrar entidad: " + e.getMessage());
            e.printStackTrace();

            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error al registrar la entidad: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
    }

    /**
     * Método para mostrar el detalle de una entidad
     */
    private void verDetalleEntidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            System.out.println("EntidadesServlet - verDetalleEntidad - ID recibido: " + idStr);

            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);

                EntidadPublicaModelo modelo = new EntidadPublicaModelo();
                EntidadPublicaEntidad entidad = modelo.buscarPorId(id);

                System.out.println("EntidadesServlet - verDetalleEntidad - Entidad recuperada: " + (entidad != null ? "ID " + entidad.getId() + ", Nombre: " + entidad.getNombre() : "NULL"));

                if (entidad != null) {
                    request.setAttribute("entidad", entidad);
                    System.out.println("EntidadesServlet - verDetalleEntidad - Redirigiendo a la vista de detalle");
                    request.getRequestDispatcher("/admin/entidad_detalle.jsp").forward(request, response);
                    return;
                } else {
                    System.out.println("EntidadesServlet - verDetalleEntidad - La entidad con ID " + id + " no fue encontrada");
                }
            } else {
                System.out.println("EntidadesServlet - verDetalleEntidad - ID no proporcionado o inválido");
            }

            // Si no se encontró la entidad o el ID no es válido
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "No se pudo encontrar la entidad solicitada.");
            session.setAttribute("tipoMensaje", "warning");
            response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        } catch (Exception e) {
            System.out.println("Error al ver detalle de entidad: " + e.getMessage());
            e.printStackTrace();

            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error al cargar el detalle de la entidad: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        }
    }

    /**
     * Método para mostrar el formulario de edición con datos de la entidad
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);

                EntidadPublicaModelo modelo = new EntidadPublicaModelo();
                EntidadPublicaEntidad entidad = modelo.buscarPorId(id);

                if (entidad != null) {
                    // Obtener niveles de gobierno y regiones para los formularios
                    NivelGobiernoModelo nivelModelo = new NivelGobiernoModelo();
                    RegionModelo regionModelo = new RegionModelo();

                    request.setAttribute("entidad", entidad);
                    request.setAttribute("niveles", nivelModelo.listar());
                    request.setAttribute("regiones", regionModelo.listar());
                    request.setAttribute("modoEdicion", true);

                    request.getRequestDispatcher("/admin/entidad_editar.jsp").forward(request, response);
                    return;
                }
            }

            // Si no se encontró la entidad o el ID no es válido
            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "No se pudo encontrar la entidad para editar.");
            session.setAttribute("tipoMensaje", "warning");
            response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        } catch (Exception e) {
            System.out.println("Error al preparar edición de entidad: " + e.getMessage());
            e.printStackTrace();

            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error al preparar la edición de la entidad: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
        }
    }

    /**
     * Método para actualizar una entidad existente
     */
    private void actualizarEntidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            System.out.println("EntidadesServlet - actualizarEntidad - ID recibido: " + idStr);

            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);

                EntidadPublicaModelo modelo = new EntidadPublicaModelo();
                EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();

                // Establecer ID
                entidad.setId(id);

                // Obtener datos del formulario
                entidad.setNombre(request.getParameter("nombre"));
                entidad.setTipo(request.getParameter("tipo"));
                entidad.setDireccion(request.getParameter("direccion"));

                // Convertir parámetros numéricos
                String nivelGobiernoStr = request.getParameter("nivelGobiernoId");
                if (nivelGobiernoStr != null && !nivelGobiernoStr.isEmpty()) {
                    entidad.setNivelGobiernoId(Integer.parseInt(nivelGobiernoStr));
                }

                String regionIdStr = request.getParameter("regionId");
                if (regionIdStr != null && !regionIdStr.isEmpty()) {
                    entidad.setRegionId(Integer.parseInt(regionIdStr));
                } else if ("1".equals(nivelGobiernoStr)) {
                    // Para nivel nacional, no se requiere región
                    entidad.setRegionId(0);
                }

                String telefono = request.getParameter("telefono");
                String email = request.getParameter("email");
                String sitioWeb = request.getParameter("sitioWeb");

                entidad.setTelefono(telefono);
                entidad.setEmail(email);
                entidad.setSitioWeb(sitioWeb);

                System.out.println("EntidadesServlet - actualizarEntidad - Datos a actualizar: " + entidad.getNombre() +
                        ", Tipo: " + entidad.getTipo() +
                        ", Nivel: " + entidad.getNivelGobiernoId() +
                        ", Región: " + entidad.getRegionId() +
                        ", Email: " + email +
                        ", Sitio Web: " + sitioWeb);

                // Actualizar la entidad
                int resultado = modelo.actualizarEntidad(entidad);
                System.out.println("EntidadesServlet - actualizarEntidad - Resultado de la actualización: " + resultado);

                HttpSession session = request.getSession();
                if (resultado > 0) {
                    session.setAttribute("mensaje", "Entidad pública actualizada correctamente.");
                    session.setAttribute("tipoMensaje", "success");
                } else {
                    session.setAttribute("mensaje", "No se pudo actualizar la entidad pública.");
                    session.setAttribute("tipoMensaje", "warning");
                }
            } else {
                System.out.println("EntidadesServlet - actualizarEntidad - ID no válido");
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "ID de entidad no válido para actualización.");
                session.setAttribute("tipoMensaje", "warning");
            }
        } catch (Exception e) {
            System.out.println("Error al actualizar entidad: " + e.getMessage());
            e.printStackTrace();

            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error al actualizar la entidad: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
    }

    /**
     * Método para eliminar una entidad
     */
    private void eliminarEntidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                int id = Integer.parseInt(idStr);

                EntidadPublicaModelo modelo = new EntidadPublicaModelo();
                int resultado = modelo.eliminarEntidad(id);

                HttpSession session = request.getSession();
                if (resultado > 0) {
                    session.setAttribute("mensaje", "Entidad pública eliminada correctamente.");
                    session.setAttribute("tipoMensaje", "success");
                } else {
                    session.setAttribute("mensaje", "No se pudo eliminar la entidad pública.");
                    session.setAttribute("tipoMensaje", "warning");
                }
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "ID de entidad no válido para eliminación.");
                session.setAttribute("tipoMensaje", "warning");
            }
        } catch (Exception e) {
            System.out.println("Error al eliminar entidad: " + e.getMessage());
            e.printStackTrace();

            HttpSession session = request.getSession();
            session.setAttribute("mensaje", "Error al eliminar la entidad: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
    }
}
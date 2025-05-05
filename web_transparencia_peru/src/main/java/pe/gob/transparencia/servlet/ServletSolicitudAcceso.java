package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import pe.gob.transparencia.entidades.CiudadanoEntidad;
import pe.gob.transparencia.entidades.RespuestaSolicitudEntidad;
import pe.gob.transparencia.entidades.SolicitudAccesoEntidad;
import pe.gob.transparencia.entidades.UsuarioEntidad;
import pe.gob.transparencia.modelo.SolicitudAccesoModelo;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet(name = "ServletSolicitudAcceso", urlPatterns = {"/solicitud.do"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,     // 1 MB
        maxFileSize = 1024 * 1024 * 10,      // 10 MB
        maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class ServletSolicitudAcceso extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public ServletSolicitudAcceso() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();

        if (accion.equals("listar")) {
            listarSolicitudes(request, response);
        } else if (accion.equals("detalle")) {
            detalleSolicitud(request, response);
        } else if (accion.equals("verRespuesta")) {
            verRespuesta(request, response);
        } else if (accion.equals("prepararRespuesta")) {
            prepararRespuesta(request, response);
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();

        if (accion.equals("registrar")) {
            registrarSolicitud(request, response);
        } else if (accion.equals("responder")) {
            responderSolicitud(request, response);
        } else if (accion.equals("cambiarEstado")) {
            cambiarEstadoSolicitud(request, response);
        } else if (accion.equals("registrarObservacion")) {
            registrarObservacion(request, response);
        }
    }

    private void listarSolicitudes(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            List<SolicitudAccesoEntidad> solicitudes;

            // Obtener parámetros de filtro si existen
            String estado = request.getParameter("filtroEstado");
            String fechaDesde = request.getParameter("filtroFechaDesde");
            String fechaHasta = request.getParameter("filtroFechaHasta");
            String busqueda = request.getParameter("filtroBusqueda");
            String filtroVencidas = request.getParameter("filtroVencidas");

            // Verificar si hay filtros activos
            boolean hayFiltros = (estado != null && !estado.isEmpty()) ||
                    (fechaDesde != null && !fechaDesde.isEmpty()) ||
                    (fechaHasta != null && !fechaHasta.isEmpty()) ||
                    (busqueda != null && !busqueda.isEmpty()) ||
                    (filtroVencidas != null && filtroVencidas.equals("true"));

            // Verificar el tipo de usuario para mostrar las solicitudes correspondientes
            if (session.getAttribute("ciudadano") != null) {
                // Si es ciudadano, mostrar solo sus solicitudes
                CiudadanoEntidad ciudadano = (CiudadanoEntidad) session.getAttribute("ciudadano");
                solicitudes = modelo.listarSolicitudesPorCiudadano(ciudadano.getId());
                request.setAttribute("solicitudes", solicitudes);
                request.getRequestDispatcher("/ciudadano/mis_solicitudes.jsp").forward(request, response);
            } else if (session.getAttribute("usuario") != null) {
                UsuarioEntidad usuario = (UsuarioEntidad) session.getAttribute("usuario");
                if (usuario.getCodRol().equals("FUNCIONARIO")) {
                    // Si es funcionario y hay filtros, usar el método con filtros
                    if (hayFiltros) {
                        solicitudes = modelo.listarSolicitudesConFiltros(estado, fechaDesde, fechaHasta, busqueda, filtroVencidas);
                    } else {
                        // Si no hay filtros, mostrar todas las solicitudes
                        solicitudes = modelo.listarSolicitudes();
                    }
                    request.setAttribute("solicitudes", solicitudes);
                    request.setAttribute("filtroEstado", estado);
                    request.setAttribute("filtroFechaDesde", fechaDesde);
                    request.setAttribute("filtroFechaHasta", fechaHasta);
                    request.setAttribute("filtroBusqueda", busqueda);
                    request.setAttribute("filtroVencidas", filtroVencidas);

                    request.getRequestDispatcher("/funcionario/solicitudes.jsp").forward(request, response);
                } else if (usuario.getCodRol().equals("ADMIN")) {
                    // Si es admin y hay filtros, usar el método con filtros
                    if (hayFiltros) {
                        solicitudes = modelo.listarSolicitudesConFiltros(estado, fechaDesde, fechaHasta, busqueda, filtroVencidas);
                    } else {
                        // Si no hay filtros, mostrar todas las solicitudes
                        solicitudes = modelo.listarSolicitudes();
                    }
                    request.setAttribute("solicitudes", solicitudes);
                    request.setAttribute("filtroEstado", estado);
                    request.setAttribute("filtroFechaDesde", fechaDesde);
                    request.setAttribute("filtroFechaHasta", fechaHasta);
                    request.setAttribute("filtroBusqueda", busqueda);
                    request.setAttribute("filtroVencidas", filtroVencidas);

                    request.getRequestDispatcher("/admin/solicitudes.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error al listar solicitudes: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void registrarSolicitud(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Obtener datos del formulario
            int ciudadanoId = Integer.parseInt(request.getParameter("ciudadanoId"));
            int entidadPublicaId = Integer.parseInt(request.getParameter("entidadPublicaId"));
            int tipoSolicitudId = Integer.parseInt(request.getParameter("tipoSolicitudId"));
            String descripcion = request.getParameter("descripcion");

            // Crear entidad
            SolicitudAccesoEntidad solicitud = new SolicitudAccesoEntidad();
            solicitud.setCiudadanoId(ciudadanoId);
            solicitud.setEntidadPublicaId(entidadPublicaId);
            solicitud.setTipoSolicitudId(tipoSolicitudId);
            solicitud.setDescripcion(descripcion);
            solicitud.setFechaSolicitud(Date.valueOf(LocalDate.now()));
            // Estado inicial: Pendiente (ID 1)
            solicitud.setEstadoSolicitudId(1);

            // Registrar solicitud
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            int idGenerado = modelo.registrarSolicitud(solicitud);

            if (idGenerado > 0) {
                session.setAttribute("mensaje", "Solicitud registrada correctamente con ID: " + idGenerado);
                session.setAttribute("tipoMensaje", "success");
                response.sendRedirect(request.getContextPath() + "/ciudadano/mis_solicitudes.jsp");
            } else {
                session.setAttribute("mensaje", "Error al registrar la solicitud");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/ciudadano/nueva_solicitud.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/ciudadano/nueva_solicitud.jsp");
        }
    }

    private void detalleSolicitud(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            int solicitudId = Integer.parseInt(request.getParameter("id"));
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            // Cambiado a obtenerSolicitud en lugar de obtenerSolicitudPorId
            SolicitudAccesoEntidad solicitud = modelo.obtenerSolicitud(solicitudId);

            if (solicitud != null) {
                request.setAttribute("solicitud", solicitud);

                // Verificar tipo de usuario para redirigir a la vista correspondiente
                if (session.getAttribute("ciudadano") != null) {
                    CiudadanoEntidad ciudadano = (CiudadanoEntidad) session.getAttribute("ciudadano");

                    // Verificar que la solicitud pertenezca al ciudadano
                    if (solicitud.getCiudadanoId() == ciudadano.getId()) {
                        request.getRequestDispatcher("/ciudadano/solicitud_detalle.jsp").forward(request, response);
                    } else {
                        session.setAttribute("mensaje", "No tiene permiso para ver esta solicitud");
                        response.sendRedirect(request.getContextPath() + "/ciudadano/mis_solicitudes.jsp");
                    }
                } else if (session.getAttribute("usuario") != null) {
                    UsuarioEntidad usuario = (UsuarioEntidad) session.getAttribute("usuario");

                    if (usuario.getCodRol().equals("FUNCIONARIO")) {
                        request.getRequestDispatcher("/funcionario/solicitudes-detalle.jsp").forward(request, response);
                    } else if (usuario.getCodRol().equals("ADMIN")) {
                        request.getRequestDispatcher("/admin/solicitud-detalle.jsp").forward(request, response);
                    }
                }
            } else {
                session.setAttribute("mensaje", "Solicitud no encontrada");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void prepararRespuesta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            int solicitudId = Integer.parseInt(request.getParameter("id"));
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            // Cambiado a obtenerSolicitud en lugar de obtenerSolicitudPorId
            SolicitudAccesoEntidad solicitud = modelo.obtenerSolicitud(solicitudId);

            if (solicitud != null) {
                request.setAttribute("solicitud", solicitud);

                // Solo funcionarios y administradores pueden responder solicitudes
                if (session.getAttribute("usuario") != null) {
                    UsuarioEntidad usuario = (UsuarioEntidad) session.getAttribute("usuario");

                    if (usuario.getCodRol().equals("FUNCIONARIO") || usuario.getCodRol().equals("ADMIN")) {
                        request.getRequestDispatcher("/funcionario/responder_solicitud.jsp").forward(request, response);
                    } else {
                        session.setAttribute("mensaje", "No tiene permisos para realizar esta acción");
                        response.sendRedirect(request.getContextPath() + "/index.jsp");
                    }
                } else {
                    session.setAttribute("mensaje", "Debe iniciar sesión como funcionario para responder solicitudes");
                    response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
                }
            } else {
                session.setAttribute("mensaje", "Solicitud no encontrada");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void responderSolicitud(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Verificar que el usuario sea funcionario o admin
            if (session.getAttribute("usuario") == null ||
                    (!"FUNCIONARIO".equals(((UsuarioEntidad) session.getAttribute("usuario")).getCodRol()) &&
                            !"ADMIN".equals(((UsuarioEntidad) session.getAttribute("usuario")).getCodRol()))) {
                session.setAttribute("mensaje", "No tiene permiso para realizar esta acción");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            UsuarioEntidad usuario = (UsuarioEntidad) session.getAttribute("usuario");

            // Obtener datos del formulario
            int solicitudId = Integer.parseInt(request.getParameter("solicitudId"));
            String respuestaTexto = request.getParameter("respuestaTexto");
            String tipoRespuesta = request.getParameter("tipoRespuesta");

            // Obtener la solicitud original para verificar su estado
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            SolicitudAccesoEntidad solicitud = modelo.obtenerSolicitud(solicitudId);

            if (solicitud == null) {
                session.setAttribute("mensaje", "La solicitud no existe");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/funcionario/solicitudes.jsp");
                return;
            }

            // Verificar si la solicitud ya fue respondida
            if (solicitud.getEstadoSolicitudId() == 3 || solicitud.getEstadoSolicitudId() == 5) {
                session.setAttribute("mensaje", "Esta solicitud ya ha sido respondida");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=detalle&id=" + solicitudId);
                return;
            }

            // Implementación alternativa para manejar la respuesta
            // Esto se adaptará según los métodos disponibles en SolicitudAccesoModelo
            solicitud.setFechaRespuesta(Date.valueOf(LocalDate.now()));
            solicitud.setObservaciones(respuestaTexto);

            // Actualizar estado de la solicitud según el tipo de respuesta
            int nuevoEstadoId;
            switch (tipoRespuesta) {
                case "completa":
                case "parcial":
                    nuevoEstadoId = 3; // Atendida
                    break;
                case "prorroga":
                    nuevoEstadoId = 2; // En proceso
                    break;
                case "rechazo":
                    nuevoEstadoId = 5; // Rechazada
                    break;
                default:
                    nuevoEstadoId = 2; // En proceso por defecto
                    break;
            }

            solicitud.setEstadoSolicitudId(nuevoEstadoId);

            // Guardar la respuesta 
            RespuestaSolicitudEntidad respuesta = new RespuestaSolicitudEntidad();
            respuesta.setSolicitudId(solicitudId);
            respuesta.setUsuarioId(usuario.getId());
            respuesta.setFechaRespuesta(new java.util.Date());
            respuesta.setContenido(respuestaTexto);

            // Procesar archivos adjuntos
            Part archivoPart = null;
            try {
                archivoPart = request.getPart("documentosRespuesta");
            } catch (Exception e) {
                // Si hay error al obtener la parte, probablemente no haya archivo
                System.out.println("No se encontró archivo adjunto: " + e.getMessage());
            }

            if (archivoPart != null && archivoPart.getSize() > 0) {
                String nombreArchivo = guardarArchivo(archivoPart, solicitudId);
                respuesta.setRutaArchivo(nombreArchivo);
            }

            // Llamar al modelo para actualizar
            int resultadoActualizacion = modelo.actualizarSolicitud(solicitud);

            if (resultadoActualizacion > 0) {
                session.setAttribute("mensaje", "Respuesta registrada correctamente");
                session.setAttribute("tipoMensaje", "success");

                // Registrar la respuesta en la base de datos
                try {
                    int respuestaId = modelo.registrarRespuesta(respuesta);
                    if (respuestaId > 0) {
                        session.setAttribute("mensaje", "Respuesta registrada correctamente");
                    }
                } catch (Exception ex) {
                    // La actualización de la solicitud fue exitosa, pero hubo un error al registrar la respuesta
                    ex.printStackTrace();
                    session.setAttribute("mensaje", "La solicitud fue actualizada, pero hubo un error al guardar la respuesta");
                    session.setAttribute("tipoMensaje", "warning");
                }
            } else {
                session.setAttribute("mensaje", "Error al registrar respuesta");
                session.setAttribute("tipoMensaje", "danger");
            }

            // Redirigir según rol
            if ("FUNCIONARIO".equals(usuario.getCodRol())) {
                response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=listar");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/solicitudes.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private String guardarArchivo(Part archivoPart, int solicitudId) {
        // Implementación para guardar el archivo en el servidor
        // Debe incluir la lógica para manejar el nombre del archivo y su ubicación
        // Por simplicidad, se asume que se guardará en una carpeta llamada "archivos"
        // dentro del contexto de la aplicación
        String nombreArchivo = archivoPart.getSubmittedFileName();

        // Crear un directorio de archivos si no existe
        File directorioArchivos = new File(getServletContext().getRealPath("/archivos"));
        if (!directorioArchivos.exists()) {
            directorioArchivos.mkdirs();
        }

        String rutaArchivo = getServletContext().getRealPath("/archivos/" + nombreArchivo);

        try {
            archivoPart.write(rutaArchivo);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }

        return nombreArchivo;
    }

    private void cambiarEstadoSolicitud(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Verificar que el usuario sea funcionario o admin
            if (session.getAttribute("usuario") == null ||
                    (!"FUNCIONARIO".equals(((UsuarioEntidad) session.getAttribute("usuario")).getCodRol()) &&
                            !"ADMIN".equals(((UsuarioEntidad) session.getAttribute("usuario")).getCodRol()))) {
                session.setAttribute("mensaje", "No tiene permiso para realizar esta acción");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            // Obtener datos del formulario
            int solicitudId = Integer.parseInt(request.getParameter("id"));
            int nuevoEstadoId = Integer.parseInt(request.getParameter("estadoId"));
            String observacion = request.getParameter("observacion");

            // Actualizar estado de solicitud
            SolicitudAccesoEntidad solicitud = new SolicitudAccesoEntidad();
            solicitud.setId(solicitudId);
            solicitud.setEstadoSolicitudId(nuevoEstadoId);
            solicitud.setObservaciones(observacion);

            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            int resultadoActualizacion = modelo.actualizarEstadoSolicitud(solicitud.getId(), nuevoEstadoId);

            if (resultadoActualizacion > 0) {
                session.setAttribute("mensaje", "Estado de solicitud actualizado correctamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al actualizar estado de solicitud");
                session.setAttribute("tipoMensaje", "danger");
            }

            // Redirigir al detalle de la solicitud
            response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=detalle&id=" + solicitudId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void registrarObservacion(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            // Verificar que el usuario sea funcionario o admin
            if (session.getAttribute("usuario") == null ||
                    (!"FUNCIONARIO".equals(((UsuarioEntidad) session.getAttribute("usuario")).getCodRol()) &&
                            !"ADMIN".equals(((UsuarioEntidad) session.getAttribute("usuario")).getCodRol()))) {
                session.setAttribute("mensaje", "No tiene permiso para realizar esta acción");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }

            // Obtener datos del formulario
            int solicitudId = Integer.parseInt(request.getParameter("id"));
            String observacion = request.getParameter("observacion");

            if (observacion == null || observacion.trim().isEmpty()) {
                session.setAttribute("mensaje", "La observación no puede estar vacía");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=detalle&id=" + solicitudId);
                return;
            }

            // Obtener la solicitud actual
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            SolicitudAccesoEntidad solicitud = modelo.obtenerSolicitud(solicitudId);

            if (solicitud == null) {
                session.setAttribute("mensaje", "La solicitud no existe");
                session.setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/funcionario/solicitudes.jsp");
                return;
            }

            // Actualizar la observación (preservar observaciones existentes si hay)
            String observacionesActuales = solicitud.getObservaciones();
            String nuevasObservaciones;

            if (observacionesActuales != null && !observacionesActuales.trim().isEmpty()) {
                nuevasObservaciones = observacionesActuales + "\n\n" + observacion;
            } else {
                nuevasObservaciones = observacion;
            }

            solicitud.setObservaciones(nuevasObservaciones);

            // Actualizar en base de datos
            int resultadoActualizacion = modelo.actualizarSolicitud(solicitud);

            if (resultadoActualizacion > 0) {
                session.setAttribute("mensaje", "Observación registrada correctamente");
                session.setAttribute("tipoMensaje", "success");
            } else {
                session.setAttribute("mensaje", "Error al registrar observación");
                session.setAttribute("tipoMensaje", "danger");
            }

            // Redirigir al detalle de la solicitud
            response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=detalle&id=" + solicitudId);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            session.setAttribute("tipoMensaje", "danger");
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }

    private void verRespuesta(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        try {
            int solicitudId = Integer.parseInt(request.getParameter("id"));
            SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
            // En lugar de obtenerRespuestaPorSolicitud, usamos obtenerSolicitud
            // y obtenemos la respuesta desde el objeto solicitud
            SolicitudAccesoEntidad solicitud = modelo.obtenerSolicitud(solicitudId);

            if (solicitud != null && solicitud.getFechaRespuesta() != null) {
                // Si la solicitud tiene fecha de respuesta, consideramos que tiene respuesta
                request.setAttribute("solicitud", solicitud);

                // Verificar el tipo de usuario para dirigir a la vista correspondiente
                if (session.getAttribute("ciudadano") != null) {
                    CiudadanoEntidad ciudadano = (CiudadanoEntidad) session.getAttribute("ciudadano");

                    // Verificar que la solicitud pertenezca al ciudadano
                    if (solicitud.getCiudadanoId() == ciudadano.getId()) {
                        request.getRequestDispatcher("/ciudadano/respuesta_detalle.jsp").forward(request, response);
                    } else {
                        session.setAttribute("mensaje", "No tiene permiso para ver esta respuesta");
                        response.sendRedirect(request.getContextPath() + "/ciudadano/mis_solicitudes.jsp");
                    }
                } else if (session.getAttribute("usuario") != null) {
                    // Si es usuario funcionario o admin, puede ver la respuesta
                    request.getRequestDispatcher("/funcionario/respuesta_detalle.jsp").forward(request, response);
                }
            } else {
                session.setAttribute("mensaje", "No se encontró respuesta para esta solicitud");
                session.setAttribute("tipoMensaje", "warning");
                response.sendRedirect(request.getContextPath() + "/solicitud.do?accion=detalle&id=" + solicitudId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("mensaje", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
}
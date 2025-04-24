package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.gob.transparencia.entidades.SolicitudAccesoEntidad;
import pe.gob.transparencia.modelo.SolicitudAccesoModelo;

import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet(name = "ServletSolicitudAcceso", urlPatterns = {"/ServletSolicitudAcceso"})
public class ServletSolicitudAcceso extends HttpServlet {
    private SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "listar";
        }
        
        switch (accion) {
            case "listar":
                listarSolicitudes(request, response);
                break;
            case "misSolicitudes":
                listarMisSolicitudes(request, response);
                break;
            case "detalle":
                mostrarDetalleSolicitud(request, response);
                break;
            case "formNuevo":
                mostrarFormularioNuevo(request, response);
                break;
            case "seguimiento":
                mostrarSeguimiento(request, response);
                break;
            default:
                listarSolicitudes(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        switch (accion) {
            case "registrar":
                registrarSolicitud(request, response);
                break;
            case "actualizar":
                actualizarSolicitud(request, response);
                break;
            case "cambiarEstado":
                cambiarEstadoSolicitud(request, response);
                break;
            default:
                response.sendRedirect("solicitud-acceso.jsp");
        }
    }
    
    private void listarSolicitudes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SolicitudAccesoEntidad> solicitudes = modelo.listarSolicitudes();
        request.setAttribute("solicitudes", solicitudes);
        request.getRequestDispatcher("solicitud-acceso.jsp").forward(request, response);
    }
    
    private void listarMisSolicitudes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Aquí se obtendría el ID del ciudadano de la sesión
        // Por ahora usaremos un valor de ejemplo
        int ciudadanoId = 1; // Este valor se debería obtener de la sesión
        
        List<SolicitudAccesoEntidad> solicitudes = modelo.listarSolicitudesPorCiudadano(ciudadanoId);
        request.setAttribute("solicitudes", solicitudes);
        request.getRequestDispatcher("mis-solicitudes.jsp").forward(request, response);
    }
    
    private void mostrarDetalleSolicitud(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        SolicitudAccesoEntidad solicitud = modelo.obtenerSolicitud(id);
        request.setAttribute("solicitud", solicitud);
        request.getRequestDispatcher("detalle-solicitud.jsp").forward(request, response);
    }
    
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("form-solicitud.jsp").forward(request, response);
    }
    
    private void mostrarSeguimiento(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        SolicitudAccesoEntidad solicitud = modelo.obtenerSolicitud(id);
        request.setAttribute("solicitud", solicitud);
        request.getRequestDispatcher("seguimiento-solicitud.jsp").forward(request, response);
    }
    
    private void registrarSolicitud(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String descripcion = request.getParameter("descripcion");
        int ciudadanoId = Integer.parseInt(request.getParameter("ciudadanoId"));
        int tipoSolicitudId = Integer.parseInt(request.getParameter("tipoSolicitudId"));
        
        SolicitudAccesoEntidad solicitud = new SolicitudAccesoEntidad();
        solicitud.setFechaSolicitud(new Date());
        solicitud.setDescripcion(descripcion);
        solicitud.setCiudadanoId(ciudadanoId);
        solicitud.setTipoSolicitudId(tipoSolicitudId);
        solicitud.setEstadoSolicitudId(1); // Por defecto, estado "Pendiente" o el ID correspondiente
        
        modelo.registrarSolicitud(solicitud);
        response.sendRedirect("ServletSolicitudAcceso?accion=misSolicitudes");
    }
    
    private void actualizarSolicitud(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String descripcion = request.getParameter("descripcion");
        int tipoSolicitudId = Integer.parseInt(request.getParameter("tipoSolicitudId"));
        
        SolicitudAccesoEntidad solicitud = modelo.obtenerSolicitud(id);
        solicitud.setDescripcion(descripcion);
        solicitud.setTipoSolicitudId(tipoSolicitudId);
        
        modelo.actualizarSolicitud(solicitud);
        response.sendRedirect("ServletSolicitudAcceso?accion=detalle&id=" + id);
    }
    
    private void cambiarEstadoSolicitud(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int nuevoEstadoId = Integer.parseInt(request.getParameter("estadoId"));
        
        modelo.actualizarEstadoSolicitud(id, nuevoEstadoId);
        response.sendRedirect("ServletSolicitudAcceso?accion=detalle&id=" + id);
    }
}

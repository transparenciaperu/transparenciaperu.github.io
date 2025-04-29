package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.gob.transparencia.entidades.SolicitudAccesoEntidad;
import pe.gob.transparencia.modelo.SolicitudAccesoModelo;
import pe.gob.transparencia.db.MySQLConexion;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.HashSet;

@WebServlet(name = "ServletSolicitudAcceso", urlPatterns = {"/ServletSolicitudAcceso"})
public class ServletSolicitudAcceso extends HttpServlet {
    private SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");
        
        if (accion == null) {
            accion = "inicio";
        }
        
        switch (accion) {
            case "inicio":
                mostrarPaginaInicio(request, response);
                break;
            case "listar":
                listarSolicitudes(request, response);
                break;
            case "misSolicitudes":
                listarMisSolicitudes(request, response);
                break;
            case "detalle":
                mostrarDetalleSolicitud(request, response);
                break;
            case "form":
                mostrarFormularioNuevo(request, response);
                break;
            case "seguimiento":
                mostrarSeguimiento(request, response);
                break;
            default:
                mostrarPaginaInicio(request, response);
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
                response.sendRedirect("ServletSolicitudAcceso");
        }
    }

    private void mostrarPaginaInicio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Cargar algunas solicitudes recientes
        List<SolicitudAccesoEntidad> solicitudes = modelo.listarSolicitudes();
        request.setAttribute("solicitudes", solicitudes);

        // Para la sección de estadísticas
        request.setAttribute("solicitudesTotal", solicitudes);

        // Calcular el tiempo promedio de atención (en días)
        double tiempoPromedio = 0;
        int solicitudesAtendidas = 0;

        for (SolicitudAccesoEntidad sol : solicitudes) {
            if (sol.getEstadoSolicitudId() == 3) { // Estado "Atendida"
                // Si tenemos fechaRespuesta, calculamos la diferencia en días
                if (sol.getFechaRespuesta() != null && sol.getFechaSolicitud() != null) {
                    long diferencia = sol.getFechaRespuesta().getTime() - sol.getFechaSolicitud().getTime();
                    long dias = diferencia / (1000 * 60 * 60 * 24);
                    tiempoPromedio += dias;
                    solicitudesAtendidas++;
                }
            }
        }

        if (solicitudesAtendidas > 0) {
            tiempoPromedio = tiempoPromedio / solicitudesAtendidas;
        }

        request.setAttribute("tiempoPromedioAtencion", tiempoPromedio);

        // Contar entidades participantes
        Set<Integer> entidadesUnicas = new HashSet<>();
        for (SolicitudAccesoEntidad sol : solicitudes) {
            entidadesUnicas.add(sol.getEntidadPublicaId());
        }

        int totalEntidades = entidadesUnicas.size();
        request.setAttribute("totalEntidadesParticipantes", totalEntidades);

        request.getRequestDispatcher("solicitud-acceso.jsp").forward(request, response);
    }

    private void listarSolicitudes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<SolicitudAccesoEntidad> solicitudes = modelo.listarSolicitudes();
        request.setAttribute("solicitudes", solicitudes);
        request.setAttribute("solicitudesTotal", solicitudes);

        // Calcular tiempo promedio de atención
        Connection cn = null;
        CallableStatement cstm = null;
        ResultSet rs = null;
        double tiempoPromedio = 0.0;

        try {
            cn = MySQLConexion.getConexion();
            cstm = cn.prepareCall("{CALL sp_obtener_tiempo_promedio_atencion()}");
            rs = cstm.executeQuery();

            if (rs.next()) {
                tiempoPromedio = rs.getDouble("diasPromedio");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (cstm != null) cstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("tiempoPromedioAtencion", tiempoPromedio);

        // Calcular total de entidades participantes
        int totalEntidades = 0;
        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT COUNT(DISTINCT entidadPublicaId) AS totalEntidades FROM SolicitudAcceso";
            PreparedStatement pstm = cn.prepareStatement(sql);
            rs = pstm.executeQuery();

            if (rs.next()) {
                totalEntidades = rs.getInt("totalEntidades");
            }

            if (rs != null) rs.close();
            if (pstm != null) pstm.close();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("totalEntidadesParticipantes", totalEntidades);

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

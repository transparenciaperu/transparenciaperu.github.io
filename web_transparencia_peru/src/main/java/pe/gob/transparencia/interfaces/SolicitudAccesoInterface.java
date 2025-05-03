package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.SolicitudAccesoEntidad;
import pe.gob.transparencia.entidades.RespuestaSolicitudEntidad;
import pe.gob.transparencia.entidades.TipoSolicitudEntidad;
import pe.gob.transparencia.entidades.EstadoSolicitudEntidad;

import java.util.List;

public interface SolicitudAccesoInterface {
    List<SolicitudAccesoEntidad> listarSolicitudes();
    List<SolicitudAccesoEntidad> listarSolicitudesPorCiudadano(int ciudadanoId);
    List<SolicitudAccesoEntidad> listarSolicitudesPorEstado(int estadoId);
    SolicitudAccesoEntidad obtenerSolicitud(int id);
    int registrarSolicitud(SolicitudAccesoEntidad solicitud);
    int actualizarSolicitud(SolicitudAccesoEntidad solicitud);
    int actualizarEstadoSolicitud(int solicitudId, int nuevoEstadoId);

    // Métodos adicionales
    SolicitudAccesoEntidad buscarPorId(int id);

    List<TipoSolicitudEntidad> listarTiposSolicitud();

    List<EstadoSolicitudEntidad> listarEstadosSolicitud();

    RespuestaSolicitudEntidad buscarRespuestaPorSolicitudId(int solicitudId);

    int eliminarSolicitud(int id);
}
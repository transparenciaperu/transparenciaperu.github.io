package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.SolicitudAccesoEntidad;
import java.util.List;

public interface SolicitudAccesoInterface {
    List<SolicitudAccesoEntidad> listarSolicitudes();
    List<SolicitudAccesoEntidad> listarSolicitudesPorCiudadano(int ciudadanoId);
    List<SolicitudAccesoEntidad> listarSolicitudesPorEstado(int estadoId);
    SolicitudAccesoEntidad obtenerSolicitud(int id);
    int registrarSolicitud(SolicitudAccesoEntidad solicitud);
    int actualizarSolicitud(SolicitudAccesoEntidad solicitud);
    int actualizarEstadoSolicitud(int solicitudId, int nuevoEstadoId);
}

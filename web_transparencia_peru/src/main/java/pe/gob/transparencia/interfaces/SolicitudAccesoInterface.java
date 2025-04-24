package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.SolicitudAccesoEntidad;
import java.util.List;

public interface SolicitudAccesoInterface {
    public List<SolicitudAccesoEntidad> listarSolicitudes();
    public List<SolicitudAccesoEntidad> listarSolicitudesPorCiudadano(int ciudadanoId);
    public List<SolicitudAccesoEntidad> listarSolicitudesPorEstado(int estadoId);
    public SolicitudAccesoEntidad obtenerSolicitud(int id);
    public int registrarSolicitud(SolicitudAccesoEntidad solicitud);
    public int actualizarSolicitud(SolicitudAccesoEntidad solicitud);
    public int actualizarEstadoSolicitud(int solicitudId, int nuevoEstadoId);
}

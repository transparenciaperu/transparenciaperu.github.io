package pe.gob.transparencia.entidades;

import java.util.Date;

public class SolicitudAccesoEntidad {
    private int id;
    private Date fechaSolicitud;
    private String descripcion;
    private int ciudadanoId;
    private int tipoSolicitudId;
    private int estadoSolicitudId;
    private CiudadanoEntidad ciudadano;
    private TipoSolicitudEntidad tipoSolicitud;
    private EstadoSolicitudEntidad estadoSolicitud;

    public SolicitudAccesoEntidad() {
    }

    public SolicitudAccesoEntidad(int id, Date fechaSolicitud, String descripcion, int ciudadanoId, int tipoSolicitudId, int estadoSolicitudId) {
        this.id = id;
        this.fechaSolicitud = fechaSolicitud;
        this.descripcion = descripcion;
        this.ciudadanoId = ciudadanoId;
        this.tipoSolicitudId = tipoSolicitudId;
        this.estadoSolicitudId = estadoSolicitudId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getFechaSolicitud() {
        return fechaSolicitud;
    }

    public void setFechaSolicitud(Date fechaSolicitud) {
        this.fechaSolicitud = fechaSolicitud;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public int getCiudadanoId() {
        return ciudadanoId;
    }

    public void setCiudadanoId(int ciudadanoId) {
        this.ciudadanoId = ciudadanoId;
    }

    public int getTipoSolicitudId() {
        return tipoSolicitudId;
    }

    public void setTipoSolicitudId(int tipoSolicitudId) {
        this.tipoSolicitudId = tipoSolicitudId;
    }

    public int getEstadoSolicitudId() {
        return estadoSolicitudId;
    }

    public void setEstadoSolicitudId(int estadoSolicitudId) {
        this.estadoSolicitudId = estadoSolicitudId;
    }

    public CiudadanoEntidad getCiudadano() {
        return ciudadano;
    }

    public void setCiudadano(CiudadanoEntidad ciudadano) {
        this.ciudadano = ciudadano;
    }

    public TipoSolicitudEntidad getTipoSolicitud() {
        return tipoSolicitud;
    }

    public void setTipoSolicitud(TipoSolicitudEntidad tipoSolicitud) {
        this.tipoSolicitud = tipoSolicitud;
    }

    public EstadoSolicitudEntidad getEstadoSolicitud() {
        return estadoSolicitud;
    }

    public void setEstadoSolicitud(EstadoSolicitudEntidad estadoSolicitud) {
        this.estadoSolicitud = estadoSolicitud;
    }
}

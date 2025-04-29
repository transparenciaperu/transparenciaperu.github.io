package pe.gob.transparencia.entidades;

import java.util.Date;

public class SolicitudAccesoEntidad {
    private int id;
    private Date fechaSolicitud;
    private String descripcion;
    private int ciudadanoId;
    private int tipoSolicitudId;
    private int estadoSolicitudId;
    private int entidadPublicaId;
    private Date fechaRespuesta;
    private String observaciones;

    private CiudadanoEntidad ciudadano;
    private TipoSolicitudEntidad tipoSolicitud;
    private EstadoSolicitudEntidad estadoSolicitud;
    private EntidadPublicaEntidad entidadPublica;

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

    public SolicitudAccesoEntidad(int id, Date fechaSolicitud, String descripcion, int ciudadanoId, int tipoSolicitudId,
                                  int estadoSolicitudId, int entidadPublicaId, Date fechaRespuesta, String observaciones) {
        this.id = id;
        this.fechaSolicitud = fechaSolicitud;
        this.descripcion = descripcion;
        this.ciudadanoId = ciudadanoId;
        this.tipoSolicitudId = tipoSolicitudId;
        this.estadoSolicitudId = estadoSolicitudId;
        this.entidadPublicaId = entidadPublicaId;
        this.fechaRespuesta = fechaRespuesta;
        this.observaciones = observaciones;
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

    public int getEntidadPublicaId() {
        return entidadPublicaId;
    }

    public void setEntidadPublicaId(int entidadPublicaId) {
        this.entidadPublicaId = entidadPublicaId;
    }

    public Date getFechaRespuesta() {
        return fechaRespuesta;
    }

    public void setFechaRespuesta(Date fechaRespuesta) {
        this.fechaRespuesta = fechaRespuesta;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
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

    public EntidadPublicaEntidad getEntidadPublica() {
        return entidadPublica;
    }

    public void setEntidadPublica(EntidadPublicaEntidad entidadPublica) {
        this.entidadPublica = entidadPublica;
    }
}
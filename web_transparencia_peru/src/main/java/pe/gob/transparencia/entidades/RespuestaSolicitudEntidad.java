package pe.gob.transparencia.entidades;

import java.util.Date;

public class RespuestaSolicitudEntidad {
    private int id;
    private int solicitudAccesoId;
    private String respuesta;
    private Date fechaRespuesta;
    private SolicitudAccesoEntidad solicitudAcceso;

    public RespuestaSolicitudEntidad() {
    }

    public RespuestaSolicitudEntidad(int id, int solicitudAccesoId, String respuesta, Date fechaRespuesta) {
        this.id = id;
        this.solicitudAccesoId = solicitudAccesoId;
        this.respuesta = respuesta;
        this.fechaRespuesta = fechaRespuesta;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSolicitudAccesoId() {
        return solicitudAccesoId;
    }

    public void setSolicitudAccesoId(int solicitudAccesoId) {
        this.solicitudAccesoId = solicitudAccesoId;
    }

    public String getRespuesta() {
        return respuesta;
    }

    public void setRespuesta(String respuesta) {
        this.respuesta = respuesta;
    }

    public Date getFechaRespuesta() {
        return fechaRespuesta;
    }

    public void setFechaRespuesta(Date fechaRespuesta) {
        this.fechaRespuesta = fechaRespuesta;
    }

    public SolicitudAccesoEntidad getSolicitudAcceso() {
        return solicitudAcceso;
    }

    public void setSolicitudAcceso(SolicitudAccesoEntidad solicitudAcceso) {
        this.solicitudAcceso = solicitudAcceso;
    }
}

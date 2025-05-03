package pe.gob.transparencia.entidades;

import java.util.Date;

public class RespuestaSolicitudEntidad {
    private int id;
    private int solicitudId;
    private int usuarioId;
    private Date fechaRespuesta;
    private String contenido;
    private String rutaArchivo;

    public RespuestaSolicitudEntidad() {
    }

    public RespuestaSolicitudEntidad(int id, int solicitudId, int usuarioId, Date fechaRespuesta, String contenido, String rutaArchivo) {
        this.id = id;
        this.solicitudId = solicitudId;
        this.usuarioId = usuarioId;
        this.fechaRespuesta = fechaRespuesta;
        this.contenido = contenido;
        this.rutaArchivo = rutaArchivo;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSolicitudId() {
        return solicitudId;
    }

    public void setSolicitudId(int solicitudId) {
        this.solicitudId = solicitudId;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public Date getFechaRespuesta() {
        return fechaRespuesta;
    }

    public void setFechaRespuesta(Date fechaRespuesta) {
        this.fechaRespuesta = fechaRespuesta;
    }

    public String getContenido() {
        return contenido;
    }

    public void setContenido(String contenido) {
        this.contenido = contenido;
    }

    public String getRutaArchivo() {
        return rutaArchivo;
    }

    public void setRutaArchivo(String rutaArchivo) {
        this.rutaArchivo = rutaArchivo;
    }
}
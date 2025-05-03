package pe.gob.transparencia.entidades;

import java.util.Date;

public class InformeEntidad {
    private int id;
    private String titulo;
    private String tipo;
    private int anio;
    private Date fechaGeneracion;
    private String nivelGobierno;
    private String descripcion;
    private String estado;
    private String rutaArchivo;
    private String datosJson;

    public InformeEntidad() {
    }

    public InformeEntidad(int id, String titulo, String tipo, int anio, Date fechaGeneracion, String nivelGobierno,
                          String descripcion, String estado, String rutaArchivo, String datosJson) {
        this.id = id;
        this.titulo = titulo;
        this.tipo = tipo;
        this.anio = anio;
        this.fechaGeneracion = fechaGeneracion;
        this.nivelGobierno = nivelGobierno;
        this.descripcion = descripcion;
        this.estado = estado;
        this.rutaArchivo = rutaArchivo;
        this.datosJson = datosJson;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public int getAnio() {
        return anio;
    }

    public void setAnio(int anio) {
        this.anio = anio;
    }

    public Date getFechaGeneracion() {
        return fechaGeneracion;
    }

    public void setFechaGeneracion(Date fechaGeneracion) {
        this.fechaGeneracion = fechaGeneracion;
    }

    public String getNivelGobierno() {
        return nivelGobierno;
    }

    public void setNivelGobierno(String nivelGobierno) {
        this.nivelGobierno = nivelGobierno;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getRutaArchivo() {
        return rutaArchivo;
    }

    public void setRutaArchivo(String rutaArchivo) {
        this.rutaArchivo = rutaArchivo;
    }

    public String getDatosJson() {
        return datosJson;
    }

    public void setDatosJson(String datosJson) {
        this.datosJson = datosJson;
    }
}
package pe.gob.transparencia.entidades;

import java.util.Date;

/**
 * Entidad que representa un documento de transparencia en el portal
 */
public class DocumentoTransparenciaEntidad {
    private int id;
    private String titulo;
    private String descripcion;
    private String categoria;
    private String periodoReferencia;
    private Date fechaPublicacion;
    private Date fechaActualizacion;
    private String rutaArchivo;
    private String tipoArchivo;
    private String estado;
    private int usuarioId;
    private int entidadPublicaId;
    private String nombreUsuario;
    private String nombreEntidad;

    public DocumentoTransparenciaEntidad() {
    }

    public DocumentoTransparenciaEntidad(String titulo, String descripcion, String categoria,
                                         String periodoReferencia, Date fechaPublicacion,
                                         String rutaArchivo, String tipoArchivo, String estado,
                                         int usuarioId, int entidadPublicaId) {
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.categoria = categoria;
        this.periodoReferencia = periodoReferencia;
        this.fechaPublicacion = fechaPublicacion;
        this.rutaArchivo = rutaArchivo;
        this.tipoArchivo = tipoArchivo;
        this.estado = estado;
        this.usuarioId = usuarioId;
        this.entidadPublicaId = entidadPublicaId;
        this.fechaActualizacion = new Date();
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

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getPeriodoReferencia() {
        return periodoReferencia;
    }

    public void setPeriodoReferencia(String periodoReferencia) {
        this.periodoReferencia = periodoReferencia;
    }

    public Date getFechaPublicacion() {
        return fechaPublicacion;
    }

    public void setFechaPublicacion(Date fechaPublicacion) {
        this.fechaPublicacion = fechaPublicacion;
    }

    public Date getFechaActualizacion() {
        return fechaActualizacion;
    }

    public void setFechaActualizacion(Date fechaActualizacion) {
        this.fechaActualizacion = fechaActualizacion;
    }

    public String getRutaArchivo() {
        return rutaArchivo;
    }

    public void setRutaArchivo(String rutaArchivo) {
        this.rutaArchivo = rutaArchivo;
    }

    public String getTipoArchivo() {
        return tipoArchivo;
    }

    public void setTipoArchivo(String tipoArchivo) {
        this.tipoArchivo = tipoArchivo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public int getEntidadPublicaId() {
        return entidadPublicaId;
    }

    public void setEntidadPublicaId(int entidadPublicaId) {
        this.entidadPublicaId = entidadPublicaId;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getNombreEntidad() {
        return nombreEntidad;
    }

    public void setNombreEntidad(String nombreEntidad) {
        this.nombreEntidad = nombreEntidad;
    }
}
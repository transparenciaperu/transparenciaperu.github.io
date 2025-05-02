package pe.gob.transparencia.entidades;

/**
 * Clase que representa la entidad Usuario en la base de datos
 */
public class UsuarioEntidad {
    private int idUsuario;
    private String codUsuario;
    private int idPersona;
    private int idRol;
    private String clave;
    private String correo;
    private boolean activo;

    // Propiedades adicionales que no están en la tabla pero son útiles
    private String nombreCompleto;
    private String codRol;
    private String descripRol;

    public UsuarioEntidad() {
    }

    public UsuarioEntidad(int idUsuario, String codUsuario, int idPersona, int idRol, String clave) {
        this.idUsuario = idUsuario;
        this.codUsuario = codUsuario;
        this.idPersona = idPersona;
        this.idRol = idRol;
        this.clave = clave;
    }

    public UsuarioEntidad(int idUsuario, String codUsuario, String nombreCompleto, String correo, String codRol, boolean activo) {
        this.idUsuario = idUsuario;
        this.codUsuario = codUsuario;
        this.nombreCompleto = nombreCompleto;
        this.correo = correo;
        this.codRol = codRol;
        this.activo = activo;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getCodUsuario() {
        return codUsuario;
    }

    public void setCodUsuario(String codUsuario) {
        this.codUsuario = codUsuario;
    }

    public int getIdPersona() {
        return idPersona;
    }

    public void setIdPersona(int idPersona) {
        this.idPersona = idPersona;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

    public String getClave() {
        return clave;
    }

    public void setClave(String clave) {
        this.clave = clave;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getCodRol() {
        return codRol;
    }

    public void setCodRol(String codRol) {
        this.codRol = codRol;
    }

    public String getDescripRol() {
        return descripRol;
    }

    public void setDescripRol(String descripRol) {
        this.descripRol = descripRol;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public boolean getActivo() {
        return activo;
    }

    public void setActivo(boolean activo) {
        this.activo = activo;
    }

    // Métodos auxiliares para compatibilidad con el código del admin
    public String getUsuario() {
        return this.codUsuario;
    }

    public void setUsuario(String usuario) {
        this.codUsuario = usuario;
    }

    public int getId() {
        return this.idUsuario;
    }

    public void setId(int id) {
        this.idUsuario = id;
    }

    @Override
    public String toString() {
        return "UsuarioEntidad{" +
                "idUsuario=" + idUsuario +
                ", codUsuario='" + codUsuario + '\'' +
                ", idPersona=" + idPersona +
                ", idRol=" + idRol +
                ", nombreCompleto='" + nombreCompleto + '\'' +
                ", codRol='" + codRol + '\'' +
                ", descripRol='" + descripRol + '\'' +
                ", correo='" + correo + '\'' +
                ", activo=" + activo +
                '}';
    }
}
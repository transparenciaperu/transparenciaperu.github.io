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

    // Constructor completo con propiedades adicionales
    public UsuarioEntidad(int idUsuario, String codUsuario, int idPersona, int idRol, String clave, String nombreCompleto, String codRol, String descripRol) {
        this.idUsuario = idUsuario;
        this.codUsuario = codUsuario;
        this.idPersona = idPersona;
        this.idRol = idRol;
        this.clave = clave;
        this.nombreCompleto = nombreCompleto;
        this.codRol = codRol;
        this.descripRol = descripRol;
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
                '}';
    }
}
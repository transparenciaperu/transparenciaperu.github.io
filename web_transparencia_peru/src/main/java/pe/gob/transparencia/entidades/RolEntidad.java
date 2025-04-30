package pe.gob.transparencia.entidades;

/**
 * Clase que representa la entidad Rol en la base de datos
 */
public class RolEntidad {
    private int idRol;
    private String codRol;
    private String descripRol;

    public RolEntidad() {
    }

    public RolEntidad(int idRol, String codRol, String descripRol) {
        this.idRol = idRol;
        this.codRol = codRol;
        this.descripRol = descripRol;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
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
        return "RolEntidad{" +
                "idRol=" + idRol +
                ", codRol='" + codRol + '\'' +
                ", descripRol='" + descripRol + '\'' +
                '}';
    }
}
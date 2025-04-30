package pe.gob.transparencia.entidades;

import java.util.Date;

/**
 * Clase que representa la entidad Persona en la base de datos
 */
public class PersonaEntidad {
    private int idPersona;
    private String nombreCompleto;
    private String correo;
    private String dni;
    private String genero;
    private Date fechNac;

    public PersonaEntidad() {
    }

    public PersonaEntidad(int idPersona, String nombreCompleto, String correo, String dni, String genero, Date fechNac) {
        this.idPersona = idPersona;
        this.nombreCompleto = nombreCompleto;
        this.correo = correo;
        this.dni = dni;
        this.genero = genero;
        this.fechNac = fechNac;
    }

    public int getIdPersona() {
        return idPersona;
    }

    public void setIdPersona(int idPersona) {
        this.idPersona = idPersona;
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getGenero() {
        return genero;
    }

    public void setGenero(String genero) {
        this.genero = genero;
    }

    public Date getFechNac() {
        return fechNac;
    }

    public void setFechNac(Date fechNac) {
        this.fechNac = fechNac;
    }

    @Override
    public String toString() {
        return "PersonaEntidad{" +
                "idPersona=" + idPersona +
                ", nombreCompleto='" + nombreCompleto + '\'' +
                ", correo='" + correo + '\'' +
                ", dni='" + dni + '\'' +
                ", genero='" + genero + '\'' +
                ", fechNac=" + fechNac +
                '}';
    }
}
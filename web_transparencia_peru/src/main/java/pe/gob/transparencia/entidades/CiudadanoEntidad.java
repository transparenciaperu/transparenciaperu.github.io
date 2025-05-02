package pe.gob.transparencia.entidades;

import java.util.Date;

/**
 * Clase entidad que representa a un ciudadano en el sistema
 */
public class CiudadanoEntidad {

    private int id;
    private String nombres;
    private String apellidos;
    private String dni;
    private String correo;
    private String telefono;
    private String direccion;
    private Date fechaRegistro;
    private String password; // Solo para uso en registro y login, no se debe retornar en consultas

    /**
     * Constructor por defecto
     */
    public CiudadanoEntidad() {
    }

    /**
     * Constructor completo
     */
    public CiudadanoEntidad(int id, String nombres, String apellidos, String dni, String correo,
                            String telefono, String direccion, Date fechaRegistro) {
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.dni = dni;
        this.correo = correo;
    }

    public CiudadanoEntidad(int id, String nombres, String apellidos, String dni, String correo, String telefono, String direccion, Date fechaRegistro, String password) {
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.dni = dni;
        this.correo = correo;
        this.telefono = telefono;
        this.direccion = direccion;
        this.fechaRegistro = fechaRegistro;
        this.password = password;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getDni() {
        return dni;
    }

    public void setDni(String dni) {
        this.dni = dni;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }
    
    public String getNombreCompleto() {
        return nombres + " " + apellidos;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "CiudadanoEntidad{" +
                "id=" + id +
                ", nombres='" + nombres + '\'' +
                ", apellidos='" + apellidos + '\'' +
                ", dni='" + dni + '\'' +
                ", correo='" + correo + '\'' +
                ", telefono='" + telefono + '\'' +
                ", direccion='" + direccion + '\'' +
                ", fechaRegistro=" + fechaRegistro +
                '}';
    }
}
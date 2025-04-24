package pe.gob.transparencia.entidades;

public class CiudadanoEntidad {
    private int id;
    private String nombres;
    private String apellidos;
    private String dni;
    private String correo;

    public CiudadanoEntidad() {
    }

    public CiudadanoEntidad(int id, String nombres, String apellidos, String dni, String correo) {
        this.id = id;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.dni = dni;
        this.correo = correo;
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
}

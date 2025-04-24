package pe.gob.transparencia.entidades;

public class EstadoSolicitudEntidad {
    private int id;
    private String nombre;

    public EstadoSolicitudEntidad() {
    }

    public EstadoSolicitudEntidad(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
}

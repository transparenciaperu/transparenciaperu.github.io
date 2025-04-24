package pe.gob.transparencia.entidades;

public class DepartamentoEntidad {
    private int id;
    private String nombre;

    public DepartamentoEntidad() {
    }

    public DepartamentoEntidad(int id, String nombre) {
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

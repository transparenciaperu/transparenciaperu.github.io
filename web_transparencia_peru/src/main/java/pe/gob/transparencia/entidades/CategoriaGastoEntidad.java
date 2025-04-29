package pe.gob.transparencia.entidades;

public class CategoriaGastoEntidad {
    private int id;
    private String nombre;
    private String descripcion;

    // Campos calculados (no están en la tabla)
    private double montoTotal;
    private double porcentaje;
    private double variacion;

    public CategoriaGastoEntidad() {
    }

    public CategoriaGastoEntidad(int id, String nombre) {
        this.id = id;
        this.nombre = nombre;
    }

    public CategoriaGastoEntidad(int id, String nombre, String descripcion) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
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

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public double getMontoTotal() {
        return montoTotal;
    }

    public void setMontoTotal(double montoTotal) {
        this.montoTotal = montoTotal;
    }

    public double getPorcentaje() {
        return porcentaje;
    }

    public void setPorcentaje(double porcentaje) {
        this.porcentaje = porcentaje;
    }

    public double getVariacion() {
        return variacion;
    }

    public void setVariacion(double variacion) {
        this.variacion = variacion;
    }
}
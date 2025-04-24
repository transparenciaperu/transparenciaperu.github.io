package pe.gob.transparencia.entidades;

public class ProyectoEntidad {
    private int id;
    private String nombre;
    private String descripcion;
    private int presupuestoId;
    private int categoriaGastoId;
    private PresupuestoEntidad presupuesto;
    private CategoriaGastoEntidad categoriaGasto;

    public ProyectoEntidad() {
    }

    public ProyectoEntidad(int id, String nombre, String descripcion, int presupuestoId, int categoriaGastoId) {
        this.id = id;
        this.nombre = nombre;
        this.descripcion = descripcion;
        this.presupuestoId = presupuestoId;
        this.categoriaGastoId = categoriaGastoId;
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

    public int getPresupuestoId() {
        return presupuestoId;
    }

    public void setPresupuestoId(int presupuestoId) {
        this.presupuestoId = presupuestoId;
    }

    public int getCategoriaGastoId() {
        return categoriaGastoId;
    }

    public void setCategoriaGastoId(int categoriaGastoId) {
        this.categoriaGastoId = categoriaGastoId;
    }

    public PresupuestoEntidad getPresupuesto() {
        return presupuesto;
    }

    public void setPresupuesto(PresupuestoEntidad presupuesto) {
        this.presupuesto = presupuesto;
    }

    public CategoriaGastoEntidad getCategoriaGasto() {
        return categoriaGasto;
    }

    public void setCategoriaGasto(CategoriaGastoEntidad categoriaGasto) {
        this.categoriaGasto = categoriaGasto;
    }
}

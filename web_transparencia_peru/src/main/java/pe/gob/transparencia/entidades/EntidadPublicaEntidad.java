package pe.gob.transparencia.entidades;

public class EntidadPublicaEntidad {
    private int id;
    private String nombre;
    private String tipo;
    private String ruc;
    private String direccion;
    private String region;

    public EntidadPublicaEntidad() {
    }

    public EntidadPublicaEntidad(int id, String nombre, String tipo, String ruc, String direccion, String region) {
        this.id = id;
        this.nombre = nombre;
        this.tipo = tipo;
        this.ruc = ruc;
        this.direccion = direccion;
        this.region = region;
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

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getRuc() {
        return ruc;
    }

    public void setRuc(String ruc) {
        this.ruc = ruc;
    }

    public String getDireccion() {
        return direccion;
    }

    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }

    public String getRegion() {
        return region;
    }

    public void setRegion(String region) {
        this.region = region;
    }
}

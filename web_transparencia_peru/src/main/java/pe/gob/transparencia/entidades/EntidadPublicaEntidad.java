package pe.gob.transparencia.entidades;

public class EntidadPublicaEntidad {
    private int id;
    private String nombre;
    private String tipo;
    private String ruc;
    private String direccion;
    private String region;
    private String nivelGobierno;
    private int nivelGobiernoId;
    private int regionId;
    private String telefono;
    private String email;
    private String sitioWeb;

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

    public String getNivelGobierno() {
        return nivelGobierno;
    }

    public void setNivelGobierno(String nivelGobierno) {
        this.nivelGobierno = nivelGobierno;
    }

    public int getNivelGobiernoId() {
        return nivelGobiernoId;
    }

    public void setNivelGobiernoId(int nivelGobiernoId) {
        this.nivelGobiernoId = nivelGobiernoId;
    }

    public int getRegionId() {
        return regionId;
    }

    public void setRegionId(int regionId) {
        this.regionId = regionId;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSitioWeb() {
        return sitioWeb;
    }

    public void setSitioWeb(String sitioWeb) {
        this.sitioWeb = sitioWeb;
    }
}
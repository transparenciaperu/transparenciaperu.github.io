package pe.gob.transparencia.entidades;

public class PeriodoFiscalEntidad {
    private int id;
    private int anio;

    public PeriodoFiscalEntidad() {
    }

    public PeriodoFiscalEntidad(int id, int anio) {
        this.id = id;
        this.anio = anio;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAnio() {
        return anio;
    }

    public void setAnio(int anio) {
        this.anio = anio;
    }
}

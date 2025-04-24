package pe.gob.transparencia.entidades;

import java.math.BigDecimal;

public class PresupuestoEntidad {
    private int id;
    private int anio;
    private BigDecimal montoTotal;
    private int entidadPublicaId;
    private EntidadPublicaEntidad entidadPublica;

    public PresupuestoEntidad() {
    }

    public PresupuestoEntidad(int id, int anio, BigDecimal montoTotal, int entidadPublicaId) {
        this.id = id;
        this.anio = anio;
        this.montoTotal = montoTotal;
        this.entidadPublicaId = entidadPublicaId;
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

    public BigDecimal getMontoTotal() {
        return montoTotal;
    }

    public void setMontoTotal(BigDecimal montoTotal) {
        this.montoTotal = montoTotal;
    }

    public int getEntidadPublicaId() {
        return entidadPublicaId;
    }

    public void setEntidadPublicaId(int entidadPublicaId) {
        this.entidadPublicaId = entidadPublicaId;
    }

    public EntidadPublicaEntidad getEntidadPublica() {
        return entidadPublica;
    }

    public void setEntidadPublica(EntidadPublicaEntidad entidadPublica) {
        this.entidadPublica = entidadPublica;
    }
}

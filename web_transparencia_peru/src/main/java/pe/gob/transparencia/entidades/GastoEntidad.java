package pe.gob.transparencia.entidades;

import java.math.BigDecimal;
import java.util.Date;

public class GastoEntidad {
    private int id;
    private BigDecimal monto;
    private Date fecha;
    private int proyectoId;
    private int fuenteFinanciamientoId;
    private ProyectoEntidad proyecto;
    private FuenteFinanciamientoEntidad fuenteFinanciamiento;

    public GastoEntidad() {
    }

    public GastoEntidad(int id, BigDecimal monto, Date fecha, int proyectoId, int fuenteFinanciamientoId) {
        this.id = id;
        this.monto = monto;
        this.fecha = fecha;
        this.proyectoId = proyectoId;
        this.fuenteFinanciamientoId = fuenteFinanciamientoId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public BigDecimal getMonto() {
        return monto;
    }

    public void setMonto(BigDecimal monto) {
        this.monto = monto;
    }

    public Date getFecha() {
        return fecha;
    }

    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }

    public int getProyectoId() {
        return proyectoId;
    }

    public void setProyectoId(int proyectoId) {
        this.proyectoId = proyectoId;
    }

    public int getFuenteFinanciamientoId() {
        return fuenteFinanciamientoId;
    }

    public void setFuenteFinanciamientoId(int fuenteFinanciamientoId) {
        this.fuenteFinanciamientoId = fuenteFinanciamientoId;
    }

    public ProyectoEntidad getProyecto() {
        return proyecto;
    }

    public void setProyecto(ProyectoEntidad proyecto) {
        this.proyecto = proyecto;
    }

    public FuenteFinanciamientoEntidad getFuenteFinanciamiento() {
        return fuenteFinanciamiento;
    }

    public void setFuenteFinanciamiento(FuenteFinanciamientoEntidad fuenteFinanciamiento) {
        this.fuenteFinanciamiento = fuenteFinanciamiento;
    }
}

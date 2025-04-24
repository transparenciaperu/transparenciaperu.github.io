package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.PresupuestoEntidad;
import java.util.List;

public interface PresupuestoInterface {
    public List<PresupuestoEntidad> listarPresupuestos();
    public List<PresupuestoEntidad> listarPresupuestosPorEntidad(int entidadId);
    public List<PresupuestoEntidad> listarPresupuestosPorAnio(int anio);
    public PresupuestoEntidad obtenerPresupuesto(int id);
    public int registrarPresupuesto(PresupuestoEntidad presupuesto);
    public int actualizarPresupuesto(PresupuestoEntidad presupuesto);
    public int eliminarPresupuesto(int id);
}

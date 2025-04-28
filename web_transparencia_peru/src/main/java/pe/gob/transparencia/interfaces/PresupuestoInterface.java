package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.PresupuestoEntidad;
import java.util.List;

public interface PresupuestoInterface {
    List<PresupuestoEntidad> listarPresupuestos();
    List<PresupuestoEntidad> listarPresupuestosPorEntidad(int entidadId);
    List<PresupuestoEntidad> listarPresupuestosPorAnio(int anio);
    PresupuestoEntidad obtenerPresupuesto(int id);
    int registrarPresupuesto(PresupuestoEntidad presupuesto);
    int actualizarPresupuesto(PresupuestoEntidad presupuesto);
    int eliminarPresupuesto(int id);
}

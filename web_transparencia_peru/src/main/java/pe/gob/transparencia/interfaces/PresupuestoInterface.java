package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.PresupuestoEntidad;
import java.util.List;
import java.util.Map;

public interface PresupuestoInterface {
    List<PresupuestoEntidad> listarPresupuestos();
    List<PresupuestoEntidad> listarPresupuestosPorEntidad(int entidadId);
    List<PresupuestoEntidad> listarPresupuestosPorAnio(int anio);
    PresupuestoEntidad obtenerPresupuesto(int id);
    int registrarPresupuesto(PresupuestoEntidad presupuesto);
    int actualizarPresupuesto(PresupuestoEntidad presupuesto);
    int eliminarPresupuesto(int id);

    List<Map<String, Object>> obtenerEvolucionAnual();

    List<Map<String, Object>> obtenerDatosProyectos();

    List<Map<String, Object>> obtenerDatosCategorias();

    List<Map<String, Object>> obtenerEstadisticasPorNivel(int anio);

    List<Map<String, Object>> obtenerPresupuestosPorNivelYAnio(int nivelId);
}
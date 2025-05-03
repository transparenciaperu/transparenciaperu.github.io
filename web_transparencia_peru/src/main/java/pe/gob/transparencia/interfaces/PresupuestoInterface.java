package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.PresupuestoEntidad;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

public interface PresupuestoInterface {
    List<PresupuestoEntidad> listar();

    PresupuestoEntidad buscarPorId(int id);

    int insertar(PresupuestoEntidad presupuesto);

    int actualizar(PresupuestoEntidad presupuesto);

    int eliminar(int id);

    // Métodos adicionales
    List<PresupuestoEntidad> listarPorAnio(int anio);

    List<PresupuestoEntidad> listarPresupuestosPorAnio(int anio);

    List<PresupuestoEntidad> listarPorEntidad(int entidadId);

    List<PresupuestoEntidad> listarPresupuestosPorEntidad(int entidadId);

    List<PresupuestoEntidad> listarPresupuestos();

    double obtenerTotalPorAnio(int anio);

    // Nuevos métodos para obtener datos dinámicamente
    List<Map<String, Object>> obtenerEvolucionAnual();
    List<Map<String, Object>> obtenerDatosProyectos();
    List<Map<String, Object>> obtenerDatosCategorias();
    List<Map<String, Object>> obtenerEstadisticasPorNivel(int anio);
    List<Map<String, Object>> obtenerPresupuestosPorNivelYAnio(int nivelId);

    // Nuevos métodos para obtener datos dinámicamente
    List<Map<String, Object>> obtenerDatosProyectosNacionales();

    List<Map<String, Object>> obtenerDistribucionPresupuestoMinisterios();

    BigDecimal obtenerPresupuestoTotalPorNivel(int nivelId, int anio);

    Double obtenerPorcentajeEjecucionPorNivel(int nivelId, int anio);

    List<Map<String, Object>> obtenerEjecucionMensualPorNivel(int nivelId);
}
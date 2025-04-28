package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.ProyectoEntidad;
import java.util.List;

public interface ProyectoInterface {
    List<ProyectoEntidad> listarProyectos();
    List<ProyectoEntidad> listarProyectosPorPresupuesto(int presupuestoId);
    List<ProyectoEntidad> listarProyectosPorCategoria(int categoriaId);
    ProyectoEntidad obtenerProyecto(int id);
    int registrarProyecto(ProyectoEntidad proyecto);
    int actualizarProyecto(ProyectoEntidad proyecto);
    int eliminarProyecto(int id);
}

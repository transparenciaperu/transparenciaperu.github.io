package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.ProyectoEntidad;
import java.util.List;

public interface ProyectoInterface {
    public List<ProyectoEntidad> listarProyectos();
    public List<ProyectoEntidad> listarProyectosPorPresupuesto(int presupuestoId);
    public List<ProyectoEntidad> listarProyectosPorCategoria(int categoriaId);
    public ProyectoEntidad obtenerProyecto(int id);
    public int registrarProyecto(ProyectoEntidad proyecto);
    public int actualizarProyecto(ProyectoEntidad proyecto);
    public int eliminarProyecto(int id);
}

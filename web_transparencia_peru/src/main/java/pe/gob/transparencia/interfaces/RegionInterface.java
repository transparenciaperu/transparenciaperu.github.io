package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.RegionEntidad;
import java.util.List;

public interface RegionInterface {
    public List<RegionEntidad> listar();
    public RegionEntidad buscarPorId(int id);
    public int insertar(RegionEntidad region);
    public int actualizar(RegionEntidad region);
    public int eliminar(int id);
}

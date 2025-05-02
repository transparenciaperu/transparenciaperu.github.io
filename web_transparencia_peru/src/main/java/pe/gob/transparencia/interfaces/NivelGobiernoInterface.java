package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.NivelGobiernoEntidad;
import java.util.List;

public interface NivelGobiernoInterface {
    public List<NivelGobiernoEntidad> listar();
    public NivelGobiernoEntidad buscarPorId(int id);
    public int insertar(NivelGobiernoEntidad nivel);
    public int actualizar(NivelGobiernoEntidad nivel);
    public int eliminar(int id);
}

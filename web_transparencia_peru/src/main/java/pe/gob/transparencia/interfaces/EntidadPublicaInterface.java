package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import java.util.List;

public interface EntidadPublicaInterface {
    public List<EntidadPublicaEntidad> listar();
    public List<EntidadPublicaEntidad> listarPorNivel(int nivelId);
    public EntidadPublicaEntidad buscarPorId(int id);
    public int insertar(EntidadPublicaEntidad entidad);
    public int actualizar(EntidadPublicaEntidad entidad);
    public int eliminar(int id);
}

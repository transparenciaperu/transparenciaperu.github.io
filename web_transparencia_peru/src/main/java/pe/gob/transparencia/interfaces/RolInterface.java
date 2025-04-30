package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.RolEntidad;

import java.util.List;

public interface RolInterface {
    public List<RolEntidad> listarRoles();

    public RolEntidad buscarPorId(int idRol);

    public RolEntidad buscarPorCodigo(String codRol);
}
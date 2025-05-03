package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.UsuarioEntidad;

import java.util.List;

public interface UsuarioInterface {
    public UsuarioEntidad autenticar(String codUsuario, String clave);

    public List<UsuarioEntidad> listarUsuarios();

    public int registrarUsuario(String codUsuario, int idPersona, int idRol, String clave);

    public int registrarUsuario(UsuarioEntidad usuario);

    public int actualizarUsuario(int idUsuario, String codUsuario, int idPersona, int idRol);

    public int actualizarUsuario(UsuarioEntidad usuario);

    public UsuarioEntidad buscarPorId(int idUsuario);

    public int actualizarClave(int idUsuario, String nuevaClave);

    public int eliminarUsuario(int idUsuario);

    public int cambiarEstadoUsuario(int idUsuario, boolean activo);

    public boolean verificarUsuarioExistente(String codUsuario);

    public boolean verificarCorreoExistente(String correo);
}
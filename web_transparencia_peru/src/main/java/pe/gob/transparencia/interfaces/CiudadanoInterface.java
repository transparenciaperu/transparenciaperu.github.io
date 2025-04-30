package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.CiudadanoEntidad;

import java.util.List;

public interface CiudadanoInterface {
    public CiudadanoEntidad buscarPorCredenciales(String correo, String password);

    public CiudadanoEntidad buscarPorId(int idCiudadano);

    public CiudadanoEntidad buscarPorDni(String dni);

    public CiudadanoEntidad buscarPorCorreo(String correo);

    public List<CiudadanoEntidad> listarCiudadanos();

    public int registrarCiudadano(String nombres, String apellidos, String dni, String correo, String telefono, String direccion, String password);

    public int actualizarCiudadano(int idCiudadano, String nombres, String apellidos, String dni, String correo, String telefono, String direccion);

    public int actualizarPassword(int idCiudadano, String nuevoPassword);
}
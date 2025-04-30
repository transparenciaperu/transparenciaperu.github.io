package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.PersonaEntidad;

import java.util.Date;
import java.util.List;

public interface PersonaInterface {
    public int registrarPersona(String nombreCompleto, String correo, String dni, String genero, Date fechNac);

    public List<PersonaEntidad> listarPersonas();

    public PersonaEntidad buscarPorId(int idPersona);

    public int actualizarPersona(int idPersona, String nombreCompleto, String correo, String dni, String genero, Date fechNac);

    public int eliminarPersona(int idPersona);
}
package pe.gob.transparencia.dao;

import pe.gob.transparencia.interfaces.CiudadanoInterface;
import pe.gob.transparencia.interfaces.PersonaInterface;
import pe.gob.transparencia.interfaces.PresupuestoInterface;
import pe.gob.transparencia.interfaces.ProyectoInterface;
import pe.gob.transparencia.interfaces.RolInterface;
import pe.gob.transparencia.interfaces.SolicitudAccesoInterface;
import pe.gob.transparencia.interfaces.UsuarioInterface;
import pe.gob.transparencia.modelo.CiudadanoModelo;
import pe.gob.transparencia.modelo.PersonaModelo;
import pe.gob.transparencia.modelo.PresupuestoModelo;
import pe.gob.transparencia.modelo.ProyectoModelo;
import pe.gob.transparencia.modelo.RolModelo;
import pe.gob.transparencia.modelo.SolicitudAccesoModelo;
import pe.gob.transparencia.modelo.UsuarioModelo;

public class MySqlDAOFactory extends DAOFactory {
    @Override
    public PresupuestoInterface getPresupuestoDAO() {
        return new PresupuestoModelo();
    }

    @Override
    public ProyectoInterface getProyectoDAO() {
        return new ProyectoModelo();
    }

    @Override
    public SolicitudAccesoInterface getSolicitudAccesoDAO() {
        return new SolicitudAccesoModelo();
    }

    @Override
    public UsuarioInterface getUsuarioDAO() {
        return new UsuarioModelo();
    }

    @Override
    public PersonaInterface getPersonaDAO() {
        return new PersonaModelo();
    }

    @Override
    public RolInterface getRolDAO() {
        return new RolModelo();
    }

    @Override
    public CiudadanoInterface getCiudadanoDAO() {
        return new CiudadanoModelo();
    }
}
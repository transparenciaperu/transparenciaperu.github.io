package pe.gob.transparencia.dao;

import pe.gob.transparencia.interfaces.CiudadanoInterface;
import pe.gob.transparencia.interfaces.PersonaInterface;
import pe.gob.transparencia.interfaces.PresupuestoInterface;
import pe.gob.transparencia.interfaces.ProyectoInterface;
import pe.gob.transparencia.interfaces.RolInterface;
import pe.gob.transparencia.interfaces.SolicitudAccesoInterface;
import pe.gob.transparencia.interfaces.UsuarioInterface;

public abstract class DAOFactory {
    // Constantes para los diferentes tipos de DAO
    public static final int MYSQL = 1;
    public static final int SQLSERVER = 2;
    public static final int ORACLE = 3;

    // Métodos abstractos para obtener los DAOs específicos
    public abstract PresupuestoInterface getPresupuestoDAO();
    public abstract ProyectoInterface getProyectoDAO();
    public abstract SolicitudAccesoInterface getSolicitudAccesoDAO();
    public abstract UsuarioInterface getUsuarioDAO();
    public abstract PersonaInterface getPersonaDAO();
    public abstract RolInterface getRolDAO();

    public abstract CiudadanoInterface getCiudadanoDAO();

    // Método estático para obtener la fábrica adecuada
    public static DAOFactory getDAOFactory(int whichFactory) {
        switch (whichFactory) {
            case MYSQL:
                return new MySqlDAOFactory();
            case SQLSERVER:
                // Para implementar en el futuro
                return null;
            case ORACLE:
                // Para implementar en el futuro
                return null;
            default:
                return null;
        }
    }
}

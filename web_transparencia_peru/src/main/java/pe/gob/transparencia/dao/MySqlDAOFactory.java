package pe.gob.transparencia.dao;

import pe.gob.transparencia.interfaces.PresupuestoInterface;
import pe.gob.transparencia.interfaces.ProyectoInterface;
import pe.gob.transparencia.interfaces.SolicitudAccesoInterface;
import pe.gob.transparencia.modelo.PresupuestoModelo;
import pe.gob.transparencia.modelo.ProyectoModelo;
import pe.gob.transparencia.modelo.SolicitudAccesoModelo;

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
}

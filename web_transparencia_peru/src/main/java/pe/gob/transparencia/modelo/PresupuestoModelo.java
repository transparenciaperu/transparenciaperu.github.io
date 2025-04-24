package pe.gob.transparencia.modelo;

import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.entidades.PresupuestoEntidad;
import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.interfaces.PresupuestoInterface;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PresupuestoModelo implements PresupuestoInterface {

    @Override
    public List<PresupuestoEntidad> listarPresupuestos() {
        List<PresupuestoEntidad> lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT p.*, e.nombre AS entidad_nombre, e.tipo, e.region FROM Presupuesto p " +
                         "INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id";
            pstm = cn.prepareStatement(sql);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                PresupuestoEntidad presupuesto = new PresupuestoEntidad();
                presupuesto.setId(rs.getInt("id"));
                presupuesto.setAnio(rs.getInt("anio"));
                presupuesto.setMontoTotal(rs.getBigDecimal("montoTotal"));
                presupuesto.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                
                EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
                entidad.setId(rs.getInt("entidadPublicaId"));
                entidad.setNombre(rs.getString("entidad_nombre"));
                entidad.setTipo(rs.getString("tipo"));
                entidad.setRegion(rs.getString("region"));
                
                presupuesto.setEntidadPublica(entidad);
                
                lista.add(presupuesto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return lista;
    }

    @Override
    public List<PresupuestoEntidad> listarPresupuestosPorEntidad(int entidadId) {
        List<PresupuestoEntidad> lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT p.*, e.nombre AS entidad_nombre, e.tipo, e.region FROM Presupuesto p " +
                         "INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id " +
                         "WHERE p.entidadPublicaId = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, entidadId);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                PresupuestoEntidad presupuesto = new PresupuestoEntidad();
                presupuesto.setId(rs.getInt("id"));
                presupuesto.setAnio(rs.getInt("anio"));
                presupuesto.setMontoTotal(rs.getBigDecimal("montoTotal"));
                presupuesto.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                
                EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
                entidad.setId(rs.getInt("entidadPublicaId"));
                entidad.setNombre(rs.getString("entidad_nombre"));
                entidad.setTipo(rs.getString("tipo"));
                entidad.setRegion(rs.getString("region"));
                
                presupuesto.setEntidadPublica(entidad);
                
                lista.add(presupuesto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return lista;
    }

    @Override
    public List<PresupuestoEntidad> listarPresupuestosPorAnio(int anio) {
        List<PresupuestoEntidad> lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT p.*, e.nombre AS entidad_nombre, e.tipo, e.region FROM Presupuesto p " +
                         "INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id " +
                         "WHERE p.anio = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, anio);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                PresupuestoEntidad presupuesto = new PresupuestoEntidad();
                presupuesto.setId(rs.getInt("id"));
                presupuesto.setAnio(rs.getInt("anio"));
                presupuesto.setMontoTotal(rs.getBigDecimal("montoTotal"));
                presupuesto.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                
                EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
                entidad.setId(rs.getInt("entidadPublicaId"));
                entidad.setNombre(rs.getString("entidad_nombre"));
                entidad.setTipo(rs.getString("tipo"));
                entidad.setRegion(rs.getString("region"));
                
                presupuesto.setEntidadPublica(entidad);
                
                lista.add(presupuesto);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return lista;
    }

    @Override
    public PresupuestoEntidad obtenerPresupuesto(int id) {
        PresupuestoEntidad presupuesto = null;
        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT p.*, e.nombre AS entidad_nombre, e.tipo, e.region FROM Presupuesto p " +
                         "INNER JOIN EntidadPublica e ON p.entidadPublicaId = e.id " +
                         "WHERE p.id = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();
            
            if (rs.next()) {
                presupuesto = new PresupuestoEntidad();
                presupuesto.setId(rs.getInt("id"));
                presupuesto.setAnio(rs.getInt("anio"));
                presupuesto.setMontoTotal(rs.getBigDecimal("montoTotal"));
                presupuesto.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                
                EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
                entidad.setId(rs.getInt("entidadPublicaId"));
                entidad.setNombre(rs.getString("entidad_nombre"));
                entidad.setTipo(rs.getString("tipo"));
                entidad.setRegion(rs.getString("region"));
                
                presupuesto.setEntidadPublica(entidad);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return presupuesto;
    }

    @Override
    public int registrarPresupuesto(PresupuestoEntidad presupuesto) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cstm = null;
        
        try {
            cn = MySQLConexion.getConexion();
            String sql = "{CALL sp_registrar_presupuesto(?, ?, ?)}";
            cstm = cn.prepareCall(sql);
            cstm.setInt(1, presupuesto.getAnio());
            cstm.setBigDecimal(2, presupuesto.getMontoTotal());
            cstm.setInt(3, presupuesto.getEntidadPublicaId());
            
            resultado = cstm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (cstm != null) cstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }

    @Override
    public int actualizarPresupuesto(PresupuestoEntidad presupuesto) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cstm = null;
        
        try {
            cn = MySQLConexion.getConexion();
            String sql = "{CALL sp_actualizar_presupuesto(?, ?, ?, ?)}";
            cstm = cn.prepareCall(sql);
            cstm.setInt(1, presupuesto.getId());
            cstm.setInt(2, presupuesto.getAnio());
            cstm.setBigDecimal(3, presupuesto.getMontoTotal());
            cstm.setInt(4, presupuesto.getEntidadPublicaId());
            
            resultado = cstm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (cstm != null) cstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }

    @Override
    public int eliminarPresupuesto(int id) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cstm = null;
        
        try {
            cn = MySQLConexion.getConexion();
            String sql = "{CALL sp_eliminar_presupuesto(?)}";
            cstm = cn.prepareCall(sql);
            cstm.setInt(1, id);
            
            resultado = cstm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (cstm != null) cstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }
}

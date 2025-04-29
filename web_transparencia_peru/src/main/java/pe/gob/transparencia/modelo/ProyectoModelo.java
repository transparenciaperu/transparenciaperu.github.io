package pe.gob.transparencia.modelo;

import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.entidades.ProyectoEntidad;
import pe.gob.transparencia.entidades.PresupuestoEntidad;
import pe.gob.transparencia.entidades.CategoriaGastoEntidad;
import pe.gob.transparencia.interfaces.ProyectoInterface;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProyectoModelo implements ProyectoInterface {

    @Override
    public List<ProyectoEntidad> listarProyectos() {
        List<ProyectoEntidad> lista = new ArrayList<>();

        // Si la base de datos no está disponible, retorna una lista vacía
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. Retornando lista vacía de proyectos.");
            return lista;
        }

        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            cn = MySQLConexion.getConexion();

            // Si no se pudo establecer la conexión, retornar lista vacía
            if (cn == null) {
                return lista;
            }

            String sql = "SELECT p.*, pr.anio, cg.nombre AS categoria_nombre " +
                         "FROM Proyecto p " +
                         "INNER JOIN Presupuesto pr ON p.presupuestoId = pr.id " +
                         "INNER JOIN CategoriaGasto cg ON p.categoriaGastoId = cg.id";
            pstm = cn.prepareStatement(sql);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                ProyectoEntidad proyecto = mapearProyecto(rs);
                lista.add(proyecto);
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
    public List<ProyectoEntidad> listarProyectosPorPresupuesto(int presupuestoId) {
        List<ProyectoEntidad> lista = new ArrayList<>();

        // Si la base de datos no está disponible, retorna una lista vacía
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. Retornando lista vacía de proyectos por presupuesto.");
            return lista;
        }

        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            cn = MySQLConexion.getConexion();

            // Si no se pudo establecer la conexión, retornar lista vacía
            if (cn == null) {
                return lista;
            }

            String sql = "SELECT p.*, pr.anio, cg.nombre AS categoria_nombre " +
                         "FROM Proyecto p " +
                         "INNER JOIN Presupuesto pr ON p.presupuestoId = pr.id " +
                         "INNER JOIN CategoriaGasto cg ON p.categoriaGastoId = cg.id " +
                         "WHERE p.presupuestoId = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, presupuestoId);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                ProyectoEntidad proyecto = mapearProyecto(rs);
                lista.add(proyecto);
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
    public List<ProyectoEntidad> listarProyectosPorCategoria(int categoriaId) {
        List<ProyectoEntidad> lista = new ArrayList<>();

        // Si la base de datos no está disponible, retorna una lista vacía
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. Retornando lista vacía de proyectos por categoría.");
            return lista;
        }

        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            cn = MySQLConexion.getConexion();

            // Si no se pudo establecer la conexión, retornar lista vacía
            if (cn == null) {
                return lista;
            }

            String sql = "SELECT p.*, pr.anio, cg.nombre AS categoria_nombre " +
                         "FROM Proyecto p " +
                         "INNER JOIN Presupuesto pr ON p.presupuestoId = pr.id " +
                         "INNER JOIN CategoriaGasto cg ON p.categoriaGastoId = cg.id " +
                         "WHERE p.categoriaGastoId = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, categoriaId);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                ProyectoEntidad proyecto = mapearProyecto(rs);
                lista.add(proyecto);
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
    public ProyectoEntidad obtenerProyecto(int id) {
        ProyectoEntidad proyecto = null;

        // Si la base de datos no está disponible, retorna null
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. Retornando null para proyecto.");
            return null;
        }

        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            cn = MySQLConexion.getConexion();

            // Si no se pudo establecer la conexión, retornar null
            if (cn == null) {
                return null;
            }

            String sql = "SELECT p.*, pr.anio, cg.nombre AS categoria_nombre " +
                         "FROM Proyecto p " +
                         "INNER JOIN Presupuesto pr ON p.presupuestoId = pr.id " +
                         "INNER JOIN CategoriaGasto cg ON p.categoriaGastoId = cg.id " +
                         "WHERE p.id = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();
            
            if (rs.next()) {
                proyecto = mapearProyecto(rs);
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
        
        return proyecto;
    }

    @Override
    public int registrarProyecto(ProyectoEntidad proyecto) {
        int resultado = 0;

        // Si la base de datos no está disponible, retorna 0 (sin éxito)
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. No se puede registrar proyecto.");
            return resultado;
        }

        Connection cn = null;
        PreparedStatement pstm = null;
        
        try {
            cn = MySQLConexion.getConexion();

            // Si no se pudo establecer la conexión, retornar 0
            if (cn == null) {
                return resultado;
            }

            String sql = "INSERT INTO Proyecto (nombre, descripcion, presupuestoId, categoriaGastoId) " +
                         "VALUES (?, ?, ?, ?)";
            pstm = cn.prepareStatement(sql);
            pstm.setString(1, proyecto.getNombre());
            pstm.setString(2, proyecto.getDescripcion());
            pstm.setInt(3, proyecto.getPresupuestoId());
            pstm.setInt(4, proyecto.getCategoriaGastoId());
            
            resultado = pstm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstm != null) pstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }

    @Override
    public int actualizarProyecto(ProyectoEntidad proyecto) {
        int resultado = 0;

        // Si la base de datos no está disponible, retorna 0 (sin éxito)
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. No se puede actualizar proyecto.");
            return resultado;
        }

        Connection cn = null;
        PreparedStatement pstm = null;
        
        try {
            cn = MySQLConexion.getConexion();

            // Si no se pudo establecer la conexión, retornar 0
            if (cn == null) {
                return resultado;
            }

            String sql = "UPDATE Proyecto SET nombre = ?, descripcion = ?, presupuestoId = ?, categoriaGastoId = ? " +
                         "WHERE id = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setString(1, proyecto.getNombre());
            pstm.setString(2, proyecto.getDescripcion());
            pstm.setInt(3, proyecto.getPresupuestoId());
            pstm.setInt(4, proyecto.getCategoriaGastoId());
            pstm.setInt(5, proyecto.getId());
            
            resultado = pstm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstm != null) pstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }

    @Override
    public int eliminarProyecto(int id) {
        int resultado = 0;

        // Si la base de datos no está disponible, retorna 0 (sin éxito)
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. No se puede eliminar proyecto.");
            return resultado;
        }

        Connection cn = null;
        PreparedStatement pstm = null;
        
        try {
            cn = MySQLConexion.getConexion();

            // Si no se pudo establecer la conexión, retornar 0
            if (cn == null) {
                return resultado;
            }

            String sql = "DELETE FROM Proyecto WHERE id = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, id);
            
            resultado = pstm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstm != null) pstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        return resultado;
    }
    
    // Método auxiliar para mapear los resultados de la consulta a un objeto ProyectoEntidad
    private ProyectoEntidad mapearProyecto(ResultSet rs) throws SQLException {
        ProyectoEntidad proyecto = new ProyectoEntidad();
        proyecto.setId(rs.getInt("id"));
        proyecto.setNombre(rs.getString("nombre"));
        proyecto.setDescripcion(rs.getString("descripcion"));
        proyecto.setPresupuestoId(rs.getInt("presupuestoId"));
        proyecto.setCategoriaGastoId(rs.getInt("categoriaGastoId"));
        
        // Configurar la relación con Presupuesto
        PresupuestoEntidad presupuesto = new PresupuestoEntidad();
        presupuesto.setId(rs.getInt("presupuestoId"));
        presupuesto.setAnio(rs.getInt("anio"));
        proyecto.setPresupuesto(presupuesto);
        
        // Configurar la relación con CategoriaGasto
        CategoriaGastoEntidad categoriaGasto = new CategoriaGastoEntidad();
        categoriaGasto.setId(rs.getInt("categoriaGastoId"));
        categoriaGasto.setNombre(rs.getString("categoria_nombre"));
        proyecto.setCategoriaGasto(categoriaGasto);
        
        return proyecto;
    }
}
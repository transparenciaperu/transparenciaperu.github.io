package pe.gob.transparencia.modelo;

import pe.gob.transparencia.entidades.NivelGobiernoEntidad;
import pe.gob.transparencia.interfaces.NivelGobiernoInterface;
import pe.gob.transparencia.db.MySQLConexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class NivelGobiernoModelo implements NivelGobiernoInterface {

    @Override
    public List<NivelGobiernoEntidad> listar() {
        List<NivelGobiernoEntidad> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT id, nombre, descripcion FROM NivelGobierno ORDER BY id";
            pstm = con.prepareStatement(sql);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                NivelGobiernoEntidad nivel = new NivelGobiernoEntidad();
                nivel.setId(rs.getInt("id"));
                nivel.setNombre(rs.getString("nombre"));
                nivel.setDescripcion(rs.getString("descripcion"));
                lista.add(nivel);
            }
            
        } catch (SQLException e) {
            System.out.println("Error en NivelGobiernoModelo.listar: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }
        
        return lista;
    }

    @Override
    public NivelGobiernoEntidad buscarPorId(int id) {
        NivelGobiernoEntidad nivel = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT id, nombre, descripcion FROM NivelGobierno WHERE id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();
            
            if (rs.next()) {
                nivel = new NivelGobiernoEntidad();
                nivel.setId(rs.getInt("id"));
                nivel.setNombre(rs.getString("nombre"));
                nivel.setDescripcion(rs.getString("descripcion"));
            }
            
        } catch (SQLException e) {
            System.out.println("Error en NivelGobiernoModelo.buscarPorId: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }
        
        return nivel;
    }

    @Override
    public int insertar(NivelGobiernoEntidad nivel) {
        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "INSERT INTO NivelGobierno (nombre, descripcion) VALUES (?, ?)";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, nivel.getNombre());
            pstm.setString(2, nivel.getDescripcion());
            resultado = pstm.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error en NivelGobiernoModelo.insertar: " + e.getMessage());
        } finally {
            try {
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }
        
        return resultado;
    }

    @Override
    public int actualizar(NivelGobiernoEntidad nivel) {
        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE NivelGobierno SET nombre = ?, descripcion = ? WHERE id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, nivel.getNombre());
            pstm.setString(2, nivel.getDescripcion());
            pstm.setInt(3, nivel.getId());
            resultado = pstm.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error en NivelGobiernoModelo.actualizar: " + e.getMessage());
        } finally {
            try {
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }
        
        return resultado;
    }

    @Override
    public int eliminar(int id) {
        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "DELETE FROM NivelGobierno WHERE id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            resultado = pstm.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error en NivelGobiernoModelo.eliminar: " + e.getMessage());
        } finally {
            try {
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }
        
        return resultado;
    }
    
    public List<NivelGobiernoEntidad> listarPorProcedimiento() {
        List<NivelGobiernoEntidad> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "CALL sp_listar_niveles_gobierno()";
            pstm = con.prepareStatement(sql);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                NivelGobiernoEntidad nivel = new NivelGobiernoEntidad();
                nivel.setId(rs.getInt("id"));
                nivel.setNombre(rs.getString("nombre"));
                nivel.setDescripcion(rs.getString("descripcion"));
                lista.add(nivel);
            }
            
        } catch (SQLException e) {
            System.out.println("Error en NivelGobiernoModelo.listarPorProcedimiento: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }
        
        return lista;
    }
}

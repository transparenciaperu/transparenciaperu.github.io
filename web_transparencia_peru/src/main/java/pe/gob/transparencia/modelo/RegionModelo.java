package pe.gob.transparencia.modelo;

import pe.gob.transparencia.entidades.RegionEntidad;
import pe.gob.transparencia.interfaces.RegionInterface;
import pe.gob.transparencia.db.MySQLConexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RegionModelo implements RegionInterface {

    @Override
    public List<RegionEntidad> listar() {
        List<RegionEntidad> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT id, nombre, codigo FROM Region ORDER BY nombre";
            pstm = con.prepareStatement(sql);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                RegionEntidad region = new RegionEntidad();
                region.setId(rs.getInt("id"));
                region.setNombre(rs.getString("nombre"));
                region.setCodigo(rs.getString("codigo"));
                lista.add(region);
            }
            
        } catch (SQLException e) {
            System.out.println("Error en RegionModelo.listar: " + e.getMessage());
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
    public RegionEntidad buscarPorId(int id) {
        RegionEntidad region = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT id, nombre, codigo FROM Region WHERE id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();
            
            if (rs.next()) {
                region = new RegionEntidad();
                region.setId(rs.getInt("id"));
                region.setNombre(rs.getString("nombre"));
                region.setCodigo(rs.getString("codigo"));
            }
            
        } catch (SQLException e) {
            System.out.println("Error en RegionModelo.buscarPorId: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }
        
        return region;
    }

    @Override
    public int insertar(RegionEntidad region) {
        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "INSERT INTO Region (nombre, codigo) VALUES (?, ?)";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, region.getNombre());
            pstm.setString(2, region.getCodigo());
            resultado = pstm.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error en RegionModelo.insertar: " + e.getMessage());
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
    public int actualizar(RegionEntidad region) {
        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE Region SET nombre = ?, codigo = ? WHERE id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, region.getNombre());
            pstm.setString(2, region.getCodigo());
            pstm.setInt(3, region.getId());
            resultado = pstm.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error en RegionModelo.actualizar: " + e.getMessage());
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
            String sql = "DELETE FROM Region WHERE id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            resultado = pstm.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error en RegionModelo.eliminar: " + e.getMessage());
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
}

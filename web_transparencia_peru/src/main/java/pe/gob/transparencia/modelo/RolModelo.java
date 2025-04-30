package pe.gob.transparencia.modelo;

import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.entidades.RolEntidad;
import pe.gob.transparencia.interfaces.RolInterface;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RolModelo implements RolInterface {

    @Override
    public List<RolEntidad> listarRoles() {
        List<RolEntidad> roles = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM rol ORDER BY id_rol";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                RolEntidad rol = new RolEntidad();
                rol.setIdRol(rs.getInt("id_rol"));
                rol.setCodRol(rs.getString("cod_rol"));
                rol.setDescripRol(rs.getString("descrip_rol"));
                roles.add(rol);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return roles;
    }

    @Override
    public RolEntidad buscarPorId(int idRol) {
        RolEntidad rol = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM rol WHERE id_rol = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idRol);
            rs = ps.executeQuery();

            if (rs.next()) {
                rol = new RolEntidad();
                rol.setIdRol(rs.getInt("id_rol"));
                rol.setCodRol(rs.getString("cod_rol"));
                rol.setDescripRol(rs.getString("descrip_rol"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return rol;
    }

    @Override
    public RolEntidad buscarPorCodigo(String codRol) {
        RolEntidad rol = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM rol WHERE cod_rol = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, codRol);
            rs = ps.executeQuery();

            if (rs.next()) {
                rol = new RolEntidad();
                rol.setIdRol(rs.getInt("id_rol"));
                rol.setCodRol(rs.getString("cod_rol"));
                rol.setDescripRol(rs.getString("descrip_rol"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return rol;
    }
}
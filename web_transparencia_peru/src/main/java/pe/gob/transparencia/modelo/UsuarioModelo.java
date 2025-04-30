package pe.gob.transparencia.modelo;

import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.entidades.UsuarioEntidad;
import pe.gob.transparencia.interfaces.UsuarioInterface;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UsuarioModelo implements UsuarioInterface {

    @Override
    public UsuarioEntidad autenticar(String codUsuario, String clave) {
        UsuarioEntidad usuario = null;
        Connection cn = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            cs = cn.prepareCall("{call sp_autenticar_usuario(?, ?)}");
            cs.setString(1, codUsuario);
            cs.setString(2, clave);

            rs = cs.executeQuery();

            if (rs.next()) {
                usuario = new UsuarioEntidad();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setCodUsuario(rs.getString("cod_usuario"));
                usuario.setNombreCompleto(rs.getString("nombre_completo"));
                usuario.setCodRol(rs.getString("cod_rol"));
                usuario.setDescripRol(rs.getString("descrip_rol"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (cs != null) cs.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return usuario;
    }

    @Override
    public List<UsuarioEntidad> listarUsuarios() {
        List<UsuarioEntidad> usuarios = new ArrayList<>();
        Connection cn = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            cs = cn.prepareCall("{call sp_listar_usuarios()}");
            rs = cs.executeQuery();

            while (rs.next()) {
                UsuarioEntidad usuario = new UsuarioEntidad();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setCodUsuario(rs.getString("cod_usuario"));
                usuario.setNombreCompleto(rs.getString("nombre_completo"));
                usuario.setDescripRol(rs.getString("descrip_rol"));
                usuarios.add(usuario);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (cs != null) cs.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return usuarios;
    }

    @Override
    public int registrarUsuario(String codUsuario, int idPersona, int idRol, String clave) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            cn = MySQLConexion.getConexion();
            cs = cn.prepareCall("{call sp_registrar_usuario(?, ?, ?, ?)}");
            cs.setString(1, codUsuario);
            cs.setInt(2, idPersona);
            cs.setInt(3, idRol);
            cs.setString(4, clave);

            resultado = cs.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (cs != null) cs.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    @Override
    public int actualizarUsuario(int idUsuario, String codUsuario, int idPersona, int idRol) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "UPDATE usuario SET cod_usuario = ?, id_persona = ?, id_rol = ? WHERE id_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, codUsuario);
            ps.setInt(2, idPersona);
            ps.setInt(3, idRol);
            ps.setInt(4, idUsuario);

            resultado = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    @Override
    public int actualizarClave(int idUsuario, String nuevaClave) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "UPDATE usuario SET clave = ? WHERE id_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nuevaClave);
            ps.setInt(2, idUsuario);

            resultado = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    @Override
    public int eliminarUsuario(int idUsuario) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "DELETE FROM usuario WHERE id_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);

            resultado = ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) cn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }
}
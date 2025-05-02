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
                usuario.setCorreo(rs.getString("correo"));
                usuario.setCodRol(rs.getString("cod_rol"));
                usuario.setDescripRol(rs.getString("descrip_rol"));
                usuario.setActivo(rs.getBoolean("activo"));
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
    public UsuarioEntidad buscarPorId(int idUsuario) {
        UsuarioEntidad usuario = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT u.id_usuario, u.cod_usuario, p.nombre_completo, p.correo, r.cod_rol, r.descrip_rol, u.activo " +
                    "FROM usuario u " +
                    "JOIN persona p ON u.id_persona = p.id_persona " +
                    "JOIN rol r ON u.id_rol = r.id_rol " +
                    "WHERE u.id_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                usuario = new UsuarioEntidad();
                usuario.setIdUsuario(rs.getInt("id_usuario"));
                usuario.setCodUsuario(rs.getString("cod_usuario"));
                usuario.setNombreCompleto(rs.getString("nombre_completo"));
                usuario.setCorreo(rs.getString("correo"));
                usuario.setCodRol(rs.getString("cod_rol"));
                usuario.setDescripRol(rs.getString("descrip_rol"));
                usuario.setActivo(rs.getBoolean("activo"));
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

        return usuario;
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
    public int registrarUsuario(UsuarioEntidad usuario) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            if (verificarUsuarioExistente(usuario.getCodUsuario())) {
                return 0;
            }

            if (verificarCorreoExistente(usuario.getCorreo())) {
                return 0;
            }

            cn = MySQLConexion.getConexion();

            int idPersona = registrarPersona(usuario.getNombreCompleto(), usuario.getCorreo());

            if (idPersona > 0) {
                int idRol = obtenerIdRol(usuario.getCodRol());

                cs = cn.prepareCall("{call sp_registrar_usuario(?, ?, ?, ?)}");
                cs.setString(1, usuario.getCodUsuario());
                cs.setInt(2, idPersona);
                cs.setInt(3, idRol);
                cs.setString(4, usuario.getClave());

                resultado = cs.executeUpdate();

                if (resultado > 0 && !usuario.getActivo()) {
                    actualizarEstadoUsuario(usuario.getCodUsuario(), usuario.getActivo());
                }
            }

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

    private int registrarPersona(String nombreCompleto, String correo) {
        int idPersona = 0;
        Connection cn = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            cs = cn.prepareCall("{call sp_registrar_persona(?, ?, ?)}");
            cs.setString(1, nombreCompleto);
            cs.setString(2, correo);
            cs.registerOutParameter(3, java.sql.Types.INTEGER);

            cs.executeUpdate();
            idPersona = cs.getInt(3);

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

        return idPersona;
    }

    private int obtenerIdRol(String codRol) {
        int idRol = 0;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT id_rol FROM rol WHERE cod_rol = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, codRol);
            rs = ps.executeQuery();

            if (rs.next()) {
                idRol = rs.getInt("id_rol");
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

        return idRol;
    }

    private int actualizarEstadoUsuario(String codUsuario, boolean activo) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "UPDATE usuario SET activo = ? WHERE cod_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setBoolean(1, activo);
            ps.setString(2, codUsuario);

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
    public int actualizarUsuario(UsuarioEntidad usuario) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            UsuarioEntidad usuarioActual = buscarPorId(usuario.getIdUsuario());

            if (usuarioActual == null) {
                return 0;
            }

            cn = MySQLConexion.getConexion();

            String sqlPersona = "UPDATE persona p " +
                    "JOIN usuario u ON p.id_persona = u.id_persona " +
                    "SET p.nombre_completo = ?, p.correo = ? " +
                    "WHERE u.id_usuario = ?";
            ps = cn.prepareStatement(sqlPersona);
            ps.setString(1, usuario.getNombreCompleto());
            ps.setString(2, usuario.getCorreo());
            ps.setInt(3, usuario.getIdUsuario());
            ps.executeUpdate();
            ps.close();

            int idRol = obtenerIdRol(usuario.getCodRol());
            String sqlUsuario = "UPDATE usuario SET cod_usuario = ?, id_rol = ?, activo = ? WHERE id_usuario = ?";
            ps = cn.prepareStatement(sqlUsuario);
            ps.setString(1, usuario.getCodUsuario());
            ps.setInt(2, idRol);
            ps.setBoolean(3, usuario.getActivo());
            ps.setInt(4, usuario.getIdUsuario());

            resultado = ps.executeUpdate();

            if (usuario.getClave() != null && !usuario.getClave().isEmpty()) {
                actualizarClave(usuario.getIdUsuario(), usuario.getClave());
            }

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

    @Override
    public boolean verificarUsuarioExistente(String codUsuario) {
        boolean existe = false;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT COUNT(*) as contador FROM usuario WHERE cod_usuario = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, codUsuario);
            rs = ps.executeQuery();

            if (rs.next()) {
                existe = rs.getInt("contador") > 0;
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

        return existe;
    }

    @Override
    public boolean verificarCorreoExistente(String correo) {
        boolean existe = false;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT COUNT(*) as contador FROM persona WHERE correo = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();

            if (rs.next()) {
                existe = rs.getInt("contador") > 0;
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

        return existe;
    }
}
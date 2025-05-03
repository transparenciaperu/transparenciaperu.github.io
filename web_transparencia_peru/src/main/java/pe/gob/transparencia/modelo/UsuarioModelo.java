package pe.gob.transparencia.modelo;

import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.entidades.UsuarioEntidad;
import pe.gob.transparencia.interfaces.UsuarioInterface;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();

            System.out.println("Intentando listar usuarios...");

            // Verificar si hay usuarios (consulta simple)
            String sqlSimple = "SELECT * FROM usuario";
            ps = cn.prepareStatement(sqlSimple);
            rs = ps.executeQuery();

            System.out.println("Usuarios encontrados (consulta simple):");
            while (rs.next()) {
                try {
                    int idUsuario = rs.getInt("id_usuario");
                    String codUsuario = rs.getString("cod_usuario");
                    int idPersona = rs.getInt("id_persona");
                    int idRol = rs.getInt("id_rol");
                    System.out.println("ID: " + idUsuario + ", Usuario: " + codUsuario + ", IDPersona: " + idPersona + ", IDRol: " + idRol);

                    // Crear usuario básico
                    UsuarioEntidad usuario = new UsuarioEntidad();
                    usuario.setIdUsuario(idUsuario);
                    usuario.setCodUsuario(codUsuario);

                    // Obtener nombre completo y correo de persona
                    try {
                        PreparedStatement psPersona = cn.prepareStatement("SELECT * FROM persona WHERE id_persona = ?");
                        psPersona.setInt(1, idPersona);
                        ResultSet rsPersona = psPersona.executeQuery();
                        if (rsPersona.next()) {
                            usuario.setNombreCompleto(rsPersona.getString("nombre_completo"));
                            usuario.setCorreo(rsPersona.getString("correo"));
                        } else {
                            usuario.setNombreCompleto("Usuario #" + idUsuario);
                            usuario.setCorreo("Sin correo");
                        }
                        rsPersona.close();
                        psPersona.close();
                    } catch (Exception e) {
                        System.out.println("Error al obtener datos de persona: " + e.getMessage());
                        usuario.setNombreCompleto("Usuario #" + idUsuario);
                        usuario.setCorreo("Sin correo");
                    }

                    // Obtener rol
                    try {
                        PreparedStatement psRol = cn.prepareStatement("SELECT * FROM rol WHERE id_rol = ?");
                        psRol.setInt(1, idRol);
                        ResultSet rsRol = psRol.executeQuery();
                        if (rsRol.next()) {
                            usuario.setCodRol(rsRol.getString("cod_rol"));
                            usuario.setDescripRol(rsRol.getString("descrip_rol"));
                        } else {
                            usuario.setCodRol("Sin rol");
                            usuario.setDescripRol("Sin descripción");
                        }
                        rsRol.close();
                        psRol.close();
                    } catch (Exception e) {
                        System.out.println("Error al obtener datos de rol: " + e.getMessage());
                        usuario.setCodRol("Sin rol");
                        usuario.setDescripRol("Sin descripción");
                    }

                    // Asignar estado activo por defecto
                    usuario.setActivo(true);

                    usuarios.add(usuario);
                } catch (Exception e) {
                    System.out.println("Error procesando usuario: " + e.getMessage());
                }
            }

            System.out.println("Total usuarios encontrados: " + usuarios.size());

        } catch (Exception e) {
            System.out.println("Error al listar usuarios: " + e.getMessage());
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

        return usuarios;
    }

    /**
     * Método para diagnosticar si hay datos en las tablas relevantes
     */
    private void diagnosticarTablas(Connection cn) {
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Verificar tabla usuario
            ps = cn.prepareStatement("SELECT * FROM usuario");
            rs = ps.executeQuery();
            int countUsuarios = 0;
            while (rs.next()) {
                countUsuarios++;
                int idUsuario = rs.getInt("id_usuario");
                String codUsuario = rs.getString("cod_usuario");
                System.out.println("Usuario #" + countUsuarios + ": ID=" + idUsuario + ", código=" + codUsuario);
            }
            System.out.println("Total registros en tabla usuario: " + countUsuarios);
            rs.close();
            ps.close();

            // Verificar tabla persona
            ps = cn.prepareStatement("SELECT * FROM persona");
            rs = ps.executeQuery();
            int countPersonas = 0;
            while (rs.next()) {
                countPersonas++;
                int idPersona = rs.getInt("id_persona");
                String nombre = rs.getString("nombre_completo");
                String correo = rs.getString("correo");
                System.out.println("Persona #" + countPersonas + ": ID=" + idPersona + ", nombre=" + nombre + ", correo=" + correo);
            }
            System.out.println("Total registros en tabla persona: " + countPersonas);
            rs.close();
            ps.close();

            // Verificar tabla rol
            ps = cn.prepareStatement("SELECT * FROM rol");
            rs = ps.executeQuery();
            int countRoles = 0;
            while (rs.next()) {
                countRoles++;
                int idRol = rs.getInt("id_rol");
                String codRol = rs.getString("cod_rol");
                System.out.println("Rol #" + countRoles + ": ID=" + idRol + ", código=" + codRol);
            }
            System.out.println("Total registros en tabla rol: " + countRoles);
            rs.close();
            ps.close();

        } catch (Exception e) {
            System.out.println("Error en diagnóstico de tablas: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
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
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Validamos que el usuario y el correo sean únicos
            if (verificarUsuarioExistente(usuario.getCodUsuario())) {
                return -1; // Código para indicar que el usuario ya existe
            }

            if (verificarCorreoExistente(usuario.getCorreo())) {
                return -2; // Código para indicar que el correo ya existe
            }

            cn = MySQLConexion.getConexion();
            cn.setAutoCommit(false); // Iniciamos transacción

            // 1. Registrar persona
            String sqlPersona = "INSERT INTO persona (nombre_completo, correo, dni, genero, fech_nac) VALUES (?, ?, NULL, NULL, NULL)";
            ps = cn.prepareStatement(sqlPersona, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, usuario.getNombreCompleto());
            ps.setString(2, usuario.getCorreo());
            ps.executeUpdate();

            // Obtenemos el ID generado para la persona
            rs = ps.getGeneratedKeys();
            int idPersona = 0;
            if (rs.next()) {
                idPersona = rs.getInt(1);
            } else {
                cn.rollback();
                return 0;
            }

            // 2. Obtener ID del rol
            rs.close();
            ps.close();
            int idRol = obtenerIdRol(usuario.getCodRol());
            if (idRol == 0) {
                cn.rollback();
                return 0;
            }

            // 3. Registrar usuario
            String sqlUsuario = "INSERT INTO usuario (cod_usuario, id_persona, id_rol, clave, activo) VALUES (?, ?, ?, ?, ?)";
            ps = cn.prepareStatement(sqlUsuario);
            ps.setString(1, usuario.getCodUsuario());
            ps.setInt(2, idPersona);
            ps.setInt(3, idRol);
            ps.setString(4, usuario.getClave());
            ps.setBoolean(5, usuario.getActivo());

            resultado = ps.executeUpdate();

            // Confirmar transacción si todo ha ido bien
            if (resultado > 0) {
                cn.commit();
            } else {
                cn.rollback();
            }

        } catch (Exception e) {
            try {
                if (cn != null) cn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            System.out.println("Error al registrar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) {
                    cn.setAutoCommit(true);
                    cn.close();
                }
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

    @Override
    public int cambiarEstadoUsuario(int idUsuario, boolean activo) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            System.out.println("Actualizando estado de usuario #" + idUsuario + " a " + (activo ? "activo" : "inactivo"));
            cn = MySQLConexion.getConexion();
            cn.setAutoCommit(false);

            // Verificar que el campo activo existe
            DatabaseMetaData metaData = cn.getMetaData();
            ResultSet columnsRS = metaData.getColumns(null, null, "usuario", "activo");
            boolean campoActivoExiste = columnsRS.next();
            columnsRS.close();

            if (campoActivoExiste) {
                String sql = "UPDATE usuario SET activo = ? WHERE id_usuario = ?";
                ps = cn.prepareStatement(sql);
                ps.setBoolean(1, activo);
                ps.setInt(2, idUsuario);

                resultado = ps.executeUpdate();

                if (resultado > 0) {
                    cn.commit();
                    System.out.println("Estado de usuario #" + idUsuario + " actualizado con éxito a " + (activo ? "activo" : "inactivo"));
                } else {
                    cn.rollback();
                    System.out.println("No se actualizó el estado del usuario #" + idUsuario);
                }
            } else {
                // Si el campo no existe, no podemos actualizar el estado
                System.out.println("No se pudo actualizar el estado del usuario porque el campo 'activo' no existe en la tabla");
                cn.rollback();
            }

        } catch (Exception e) {
            try {
                if (cn != null) cn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            System.out.println("Error al actualizar el estado del usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) {
                    cn.setAutoCommit(true);
                    cn.close();
                }
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
        DatabaseMetaData metaData = null;
        ResultSet columnsRS = null;

        try {
            UsuarioEntidad usuarioActual = buscarPorId(usuario.getIdUsuario());

            if (usuarioActual == null) {
                return 0;
            }

            // Verificar si el código de usuario ya existe (si se está cambiando)
            if (!usuarioActual.getCodUsuario().equals(usuario.getCodUsuario()) &&
                    verificarUsuarioExistente(usuario.getCodUsuario())) {
                return -1; // Usuario ya existe
            }

            // Verificar si el correo ya existe (si se está cambiando)
            if (!usuarioActual.getCorreo().equals(usuario.getCorreo()) &&
                    verificarCorreoExistente(usuario.getCorreo())) {
                return -2; // Correo ya existe
            }

            cn = MySQLConexion.getConexion();
            cn.setAutoCommit(false); // Iniciamos una transacción

            // 1. Actualizar datos de persona
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

            // 2. Obtener ID del rol
            int idRol = obtenerIdRol(usuario.getCodRol());
            if (idRol == 0) {
                cn.rollback();
                return 0;
            }

            // Consulta más segura que verifica primero que el campo activo exista
            metaData = cn.getMetaData();
            columnsRS = metaData.getColumns(null, null, "usuario", "activo");
            boolean campoActivoExiste = columnsRS.next();
            columnsRS.close();

            // 3. Actualizar usuario
            String sqlUsuario;
            if (campoActivoExiste) {
                System.out.println("Actualizando usuario #" + usuario.getIdUsuario() + " con campo activo = " + usuario.getActivo());
                sqlUsuario = "UPDATE usuario SET cod_usuario = ?, id_rol = ?, activo = ? WHERE id_usuario = ?";
                ps = cn.prepareStatement(sqlUsuario);
                ps.setString(1, usuario.getCodUsuario());
                ps.setInt(2, idRol);
                ps.setBoolean(3, usuario.getActivo());
                ps.setInt(4, usuario.getIdUsuario());
            } else {
                System.out.println("Actualizando usuario #" + usuario.getIdUsuario() + " sin campo activo (no existe en la tabla)");
                sqlUsuario = "UPDATE usuario SET cod_usuario = ?, id_rol = ? WHERE id_usuario = ?";
                ps = cn.prepareStatement(sqlUsuario);
                ps.setString(1, usuario.getCodUsuario());
                ps.setInt(2, idRol);
                ps.setInt(3, usuario.getIdUsuario());
            }

            resultado = ps.executeUpdate();

            // 4. Actualizar clave si se proporcionó una nueva
            if (usuario.getClave() != null && !usuario.getClave().isEmpty()) {
                ps.close();
                resultado = actualizarClave(usuario.getIdUsuario(), usuario.getClave());
                if (resultado <= 0) {
                    cn.rollback();
                    return 0;
                }
            }

            // Confirmar cambios si todo ha ido bien
            if (resultado > 0) {
                cn.commit();
            } else {
                cn.rollback();
            }

        } catch (Exception e) {
            try {
                if (cn != null) cn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            System.out.println("Error al actualizar usuario: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (cn != null) {
                    cn.setAutoCommit(true);
                    cn.close();
                }
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
        return cambiarEstadoUsuario(idUsuario, false);
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
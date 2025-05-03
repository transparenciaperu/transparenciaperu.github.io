package pe.gob.transparencia.modelo;

import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.entidades.CiudadanoEntidad;
import pe.gob.transparencia.interfaces.CiudadanoInterface;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CiudadanoModelo implements CiudadanoInterface {

    @Override
    public CiudadanoEntidad buscarPorCredenciales(String correo, String password) {
        CiudadanoEntidad ciudadano = null;
        Connection cn = null;
        CallableStatement cs = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            cs = cn.prepareCall("{call sp_autenticar_ciudadano(?, ?)}");
            cs.setString(1, correo);
            cs.setString(2, password);
            rs = cs.executeQuery();

            if (rs.next()) {
                ciudadano = new CiudadanoEntidad();
                ciudadano.setId(rs.getInt("id"));
                ciudadano.setNombres(rs.getString("nombres"));
                ciudadano.setApellidos(rs.getString("apellidos"));
                ciudadano.setDni(rs.getString("dni"));
                ciudadano.setCorreo(rs.getString("correo"));
                ciudadano.setTelefono(rs.getString("telefono"));
                ciudadano.setDireccion(rs.getString("direccion"));
                ciudadano.setFechaRegistro(rs.getDate("fechaRegistro"));
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

        return ciudadano;
    }

    @Override
    public CiudadanoEntidad buscarPorId(int idCiudadano) {
        CiudadanoEntidad ciudadano = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM Ciudadano WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setInt(1, idCiudadano);
            rs = ps.executeQuery();

            if (rs.next()) {
                ciudadano = new CiudadanoEntidad();
                ciudadano.setId(rs.getInt("id"));
                ciudadano.setNombres(rs.getString("nombres"));
                ciudadano.setApellidos(rs.getString("apellidos"));
                ciudadano.setDni(rs.getString("dni"));
                ciudadano.setCorreo(rs.getString("correo"));
                ciudadano.setTelefono(rs.getString("telefono"));
                ciudadano.setDireccion(rs.getString("direccion"));
                ciudadano.setFechaRegistro(rs.getDate("fechaRegistro"));
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

        return ciudadano;
    }

    @Override
    public CiudadanoEntidad buscarPorDni(String dni) {
        CiudadanoEntidad ciudadano = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM Ciudadano WHERE dni = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, dni);
            rs = ps.executeQuery();

            if (rs.next()) {
                ciudadano = new CiudadanoEntidad();
                ciudadano.setId(rs.getInt("id"));
                ciudadano.setNombres(rs.getString("nombres"));
                ciudadano.setApellidos(rs.getString("apellidos"));
                ciudadano.setDni(rs.getString("dni"));
                ciudadano.setCorreo(rs.getString("correo"));
                ciudadano.setTelefono(rs.getString("telefono"));
                ciudadano.setDireccion(rs.getString("direccion"));
                ciudadano.setFechaRegistro(rs.getDate("fechaRegistro"));
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

        return ciudadano;
    }

    @Override
    public CiudadanoEntidad buscarPorCorreo(String correo) {
        CiudadanoEntidad ciudadano = null;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM Ciudadano WHERE correo = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();

            if (rs.next()) {
                ciudadano = new CiudadanoEntidad();
                ciudadano.setId(rs.getInt("id"));
                ciudadano.setNombres(rs.getString("nombres"));
                ciudadano.setApellidos(rs.getString("apellidos"));
                ciudadano.setDni(rs.getString("dni"));
                ciudadano.setCorreo(rs.getString("correo"));
                ciudadano.setTelefono(rs.getString("telefono"));
                ciudadano.setDireccion(rs.getString("direccion"));
                ciudadano.setFechaRegistro(rs.getDate("fechaRegistro"));
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

        return ciudadano;
    }

    @Override
    public List<CiudadanoEntidad> listarCiudadanos() {
        List<CiudadanoEntidad> ciudadanos = new ArrayList<>();
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT * FROM Ciudadano ORDER BY apellidos, nombres";
            ps = cn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                CiudadanoEntidad ciudadano = new CiudadanoEntidad();
                ciudadano.setId(rs.getInt("id"));
                ciudadano.setNombres(rs.getString("nombres"));
                ciudadano.setApellidos(rs.getString("apellidos"));
                ciudadano.setDni(rs.getString("dni"));
                ciudadano.setCorreo(rs.getString("correo"));
                ciudadano.setTelefono(rs.getString("telefono"));
                ciudadano.setDireccion(rs.getString("direccion"));
                ciudadano.setFechaRegistro(rs.getDate("fechaRegistro"));
                ciudadanos.add(ciudadano);
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

        return ciudadanos;
    }

    @Override
    public int registrarCiudadano(String nombres, String apellidos, String dni, String correo, String telefono, String direccion, String password) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cs = null;

        try {
            cn = MySQLConexion.getConexion();
            cs = cn.prepareCall("{call sp_registrar_ciudadano(?, ?, ?, ?, ?, ?, ?)}");
            cs.setString(1, nombres);
            cs.setString(2, apellidos);
            cs.setString(3, dni);
            cs.setString(4, correo);
            cs.setString(5, telefono);
            cs.setString(6, direccion);
            cs.setString(7, password);

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
    public int actualizarCiudadano(int idCiudadano, String nombres, String apellidos, String dni, String correo, String telefono, String direccion) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "UPDATE Ciudadano SET nombres = ?, apellidos = ?, dni = ?, correo = ?, telefono = ?, direccion = ? WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nombres);
            ps.setString(2, apellidos);
            ps.setString(3, dni);
            ps.setString(4, correo);
            ps.setString(5, telefono);
            ps.setString(6, direccion);
            ps.setInt(7, idCiudadano);

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
    public int actualizarPassword(int idCiudadano, String nuevoPassword) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "UPDATE Ciudadano SET password = ? WHERE id = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, nuevoPassword);
            ps.setInt(2, idCiudadano);

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
    public int eliminarCiudadano(int idCiudadano) {
        int resultado = 0;
        Connection cn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            cn.setAutoCommit(false); // Iniciamos una transacción para asegurar integridad

            // 1. Verificar y eliminar respuestas a solicitudes del ciudadano
            String sqlCheckRespuestas = "SELECT rs.id FROM RespuestaSolicitud rs " +
                    "INNER JOIN SolicitudAcceso sa ON rs.solicitudAccesoId = sa.id " +
                    "WHERE sa.ciudadanoId = ?";
            ps = cn.prepareStatement(sqlCheckRespuestas);
            ps.setInt(1, idCiudadano);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Si hay respuestas, las eliminamos
                ps.close();
                String sqlDeleteRespuestas = "DELETE FROM RespuestaSolicitud " +
                        "WHERE solicitudAccesoId IN (SELECT id FROM SolicitudAcceso WHERE ciudadanoId = ?)";
                ps = cn.prepareStatement(sqlDeleteRespuestas);
                ps.setInt(1, idCiudadano);
                ps.executeUpdate();
            }

            // 2. Eliminar todas las solicitudes de acceso del ciudadano
            if (rs != null) rs.close();
            ps.close();
            String sqlDeleteSolicitudes = "DELETE FROM SolicitudAcceso WHERE ciudadanoId = ?";
            ps = cn.prepareStatement(sqlDeleteSolicitudes);
            ps.setInt(1, idCiudadano);
            ps.executeUpdate();

            // 3. Finalmente eliminamos al ciudadano
            ps.close();
            String sqlDeleteCiudadano = "DELETE FROM Ciudadano WHERE id = ?";
            ps = cn.prepareStatement(sqlDeleteCiudadano);
            ps.setInt(1, idCiudadano);

            resultado = ps.executeUpdate();

            // Si todo ha ido bien, confirmar los cambios
            if (resultado > 0) {
                cn.commit();
            } else {
                cn.rollback();
            }

        } catch (Exception e) {
            // En caso de error, revertimos los cambios
            try {
                if (cn != null) cn.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            System.out.println("Error al eliminar ciudadano: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (cn != null) {
                    cn.setAutoCommit(true); // Restauramos el autocommit
                    cn.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }
}
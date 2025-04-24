package pe.gob.transparencia.modelo;

import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.entidades.SolicitudAccesoEntidad;
import pe.gob.transparencia.entidades.CiudadanoEntidad;
import pe.gob.transparencia.entidades.TipoSolicitudEntidad;
import pe.gob.transparencia.entidades.EstadoSolicitudEntidad;
import pe.gob.transparencia.interfaces.SolicitudAccesoInterface;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SolicitudAccesoModelo implements SolicitudAccesoInterface {

    @Override
    public List<SolicitudAccesoEntidad> listarSolicitudes() {
        List<SolicitudAccesoEntidad> lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT s.*, c.nombres, c.apellidos, c.dni, c.correo, " +
                    "t.nombre AS tipo_nombre, e.nombre AS estado_nombre " +
                    "FROM SolicitudAcceso s " +
                    "INNER JOIN Ciudadano c ON s.ciudadanoId = c.id " +
                    "INNER JOIN TipoSolicitud t ON s.tipoSolicitudId = t.id " +
                    "INNER JOIN EstadoSolicitud e ON s.estadoSolicitudId = e.id " +
                    "ORDER BY s.fechaSolicitud DESC";
            pstm = cn.prepareStatement(sql);
            rs = pstm.executeQuery();

            while (rs.next()) {
                SolicitudAccesoEntidad solicitud = new SolicitudAccesoEntidad();
                solicitud.setId(rs.getInt("id"));
                solicitud.setFechaSolicitud(rs.getDate("fechaSolicitud"));
                solicitud.setDescripcion(rs.getString("descripcion"));
                solicitud.setCiudadanoId(rs.getInt("ciudadanoId"));
                solicitud.setTipoSolicitudId(rs.getInt("tipoSolicitudId"));
                solicitud.setEstadoSolicitudId(rs.getInt("estadoSolicitudId"));

                CiudadanoEntidad ciudadano = new CiudadanoEntidad();
                ciudadano.setId(rs.getInt("ciudadanoId"));
                ciudadano.setNombres(rs.getString("nombres"));
                ciudadano.setApellidos(rs.getString("apellidos"));
                ciudadano.setDni(rs.getString("dni"));
                ciudadano.setCorreo(rs.getString("correo"));

                TipoSolicitudEntidad tipoSolicitud = new TipoSolicitudEntidad();
                tipoSolicitud.setId(rs.getInt("tipoSolicitudId"));
                tipoSolicitud.setNombre(rs.getString("tipo_nombre"));

                EstadoSolicitudEntidad estadoSolicitud = new EstadoSolicitudEntidad();
                estadoSolicitud.setId(rs.getInt("estadoSolicitudId"));
                estadoSolicitud.setNombre(rs.getString("estado_nombre"));

                solicitud.setCiudadano(ciudadano);
                solicitud.setTipoSolicitud(tipoSolicitud);
                solicitud.setEstadoSolicitud(estadoSolicitud);

                lista.add(solicitud);
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
    public List<SolicitudAccesoEntidad> listarSolicitudesPorCiudadano(int ciudadanoId) {
        List<SolicitudAccesoEntidad> lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT s.*, c.nombres, c.apellidos, c.dni, c.correo, " +
                    "t.nombre AS tipo_nombre, e.nombre AS estado_nombre " +
                    "FROM SolicitudAcceso s " +
                    "INNER JOIN Ciudadano c ON s.ciudadanoId = c.id " +
                    "INNER JOIN TipoSolicitud t ON s.tipoSolicitudId = t.id " +
                    "INNER JOIN EstadoSolicitud e ON s.estadoSolicitudId = e.id " +
                    "WHERE s.ciudadanoId = ? " +
                    "ORDER BY s.fechaSolicitud DESC";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, ciudadanoId);
            rs = pstm.executeQuery();

            while (rs.next()) {
                SolicitudAccesoEntidad solicitud = new SolicitudAccesoEntidad();
                solicitud.setId(rs.getInt("id"));
                solicitud.setFechaSolicitud(rs.getDate("fechaSolicitud"));
                solicitud.setDescripcion(rs.getString("descripcion"));
                solicitud.setCiudadanoId(rs.getInt("ciudadanoId"));
                solicitud.setTipoSolicitudId(rs.getInt("tipoSolicitudId"));
                solicitud.setEstadoSolicitudId(rs.getInt("estadoSolicitudId"));

                CiudadanoEntidad ciudadano = new CiudadanoEntidad();
                ciudadano.setId(rs.getInt("ciudadanoId"));
                ciudadano.setNombres(rs.getString("nombres"));
                ciudadano.setApellidos(rs.getString("apellidos"));
                ciudadano.setDni(rs.getString("dni"));
                ciudadano.setCorreo(rs.getString("correo"));

                TipoSolicitudEntidad tipoSolicitud = new TipoSolicitudEntidad();
                tipoSolicitud.setId(rs.getInt("tipoSolicitudId"));
                tipoSolicitud.setNombre(rs.getString("tipo_nombre"));

                EstadoSolicitudEntidad estadoSolicitud = new EstadoSolicitudEntidad();
                estadoSolicitud.setId(rs.getInt("estadoSolicitudId"));
                estadoSolicitud.setNombre(rs.getString("estado_nombre"));

                solicitud.setCiudadano(ciudadano);
                solicitud.setTipoSolicitud(tipoSolicitud);
                solicitud.setEstadoSolicitud(estadoSolicitud);

                lista.add(solicitud);
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
    public List<SolicitudAccesoEntidad> listarSolicitudesPorEstado(int estadoId) {
        List<SolicitudAccesoEntidad> lista = new ArrayList<>();
        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT s.*, c.nombres, c.apellidos, c.dni, c.correo, " +
                    "t.nombre AS tipo_nombre, e.nombre AS estado_nombre " +
                    "FROM SolicitudAcceso s " +
                    "INNER JOIN Ciudadano c ON s.ciudadanoId = c.id " +
                    "INNER JOIN TipoSolicitud t ON s.tipoSolicitudId = t.id " +
                    "INNER JOIN EstadoSolicitud e ON s.estadoSolicitudId = e.id " +
                    "WHERE s.estadoSolicitudId = ? " +
                    "ORDER BY s.fechaSolicitud DESC";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, estadoId);
            rs = pstm.executeQuery();

            while (rs.next()) {
                SolicitudAccesoEntidad solicitud = new SolicitudAccesoEntidad();
                solicitud.setId(rs.getInt("id"));
                solicitud.setFechaSolicitud(rs.getDate("fechaSolicitud"));
                solicitud.setDescripcion(rs.getString("descripcion"));
                solicitud.setCiudadanoId(rs.getInt("ciudadanoId"));
                solicitud.setTipoSolicitudId(rs.getInt("tipoSolicitudId"));
                solicitud.setEstadoSolicitudId(rs.getInt("estadoSolicitudId"));

                CiudadanoEntidad ciudadano = new CiudadanoEntidad();
                ciudadano.setId(rs.getInt("ciudadanoId"));
                ciudadano.setNombres(rs.getString("nombres"));
                ciudadano.setApellidos(rs.getString("apellidos"));
                ciudadano.setDni(rs.getString("dni"));
                ciudadano.setCorreo(rs.getString("correo"));

                TipoSolicitudEntidad tipoSolicitud = new TipoSolicitudEntidad();
                tipoSolicitud.setId(rs.getInt("tipoSolicitudId"));
                tipoSolicitud.setNombre(rs.getString("tipo_nombre"));

                EstadoSolicitudEntidad estadoSolicitud = new EstadoSolicitudEntidad();
                estadoSolicitud.setId(rs.getInt("estadoSolicitudId"));
                estadoSolicitud.setNombre(rs.getString("estado_nombre"));

                solicitud.setCiudadano(ciudadano);
                solicitud.setTipoSolicitud(tipoSolicitud);
                solicitud.setEstadoSolicitud(estadoSolicitud);

                lista.add(solicitud);
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
    public SolicitudAccesoEntidad obtenerSolicitud(int id) {
        SolicitudAccesoEntidad solicitud = null;
        Connection cn = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "SELECT s.*, c.nombres, c.apellidos, c.dni, c.correo, " +
                    "t.nombre AS tipo_nombre, e.nombre AS estado_nombre " +
                    "FROM SolicitudAcceso s " +
                    "INNER JOIN Ciudadano c ON s.ciudadanoId = c.id " +
                    "INNER JOIN TipoSolicitud t ON s.tipoSolicitudId = t.id " +
                    "INNER JOIN EstadoSolicitud e ON s.estadoSolicitudId = e.id " +
                    "WHERE s.id = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();

            if (rs.next()) {
                solicitud = new SolicitudAccesoEntidad();
                solicitud.setId(rs.getInt("id"));
                solicitud.setFechaSolicitud(rs.getDate("fechaSolicitud"));
                solicitud.setDescripcion(rs.getString("descripcion"));
                solicitud.setCiudadanoId(rs.getInt("ciudadanoId"));
                solicitud.setTipoSolicitudId(rs.getInt("tipoSolicitudId"));
                solicitud.setEstadoSolicitudId(rs.getInt("estadoSolicitudId"));

                CiudadanoEntidad ciudadano = new CiudadanoEntidad();
                ciudadano.setId(rs.getInt("ciudadanoId"));
                ciudadano.setNombres(rs.getString("nombres"));
                ciudadano.setApellidos(rs.getString("apellidos"));
                ciudadano.setDni(rs.getString("dni"));
                ciudadano.setCorreo(rs.getString("correo"));

                TipoSolicitudEntidad tipoSolicitud = new TipoSolicitudEntidad();
                tipoSolicitud.setId(rs.getInt("tipoSolicitudId"));
                tipoSolicitud.setNombre(rs.getString("tipo_nombre"));

                EstadoSolicitudEntidad estadoSolicitud = new EstadoSolicitudEntidad();
                estadoSolicitud.setId(rs.getInt("estadoSolicitudId"));
                estadoSolicitud.setNombre(rs.getString("estado_nombre"));

                solicitud.setCiudadano(ciudadano);
                solicitud.setTipoSolicitud(tipoSolicitud);
                solicitud.setEstadoSolicitud(estadoSolicitud);
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

        return solicitud;
    }

    @Override
    public int registrarSolicitud(SolicitudAccesoEntidad solicitud) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cstm = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "{CALL sp_registrar_solicitud(?, ?, ?, ?, ?)}";
            cstm = cn.prepareCall(sql);
            cstm.setDate(1, new java.sql.Date(solicitud.getFechaSolicitud().getTime()));
            cstm.setString(2, solicitud.getDescripcion());
            cstm.setInt(3, solicitud.getCiudadanoId());
            cstm.setInt(4, solicitud.getTipoSolicitudId());
            cstm.setInt(5, solicitud.getEstadoSolicitudId());

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
    public int actualizarSolicitud(SolicitudAccesoEntidad solicitud) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cstm = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "{CALL sp_actualizar_solicitud(?, ?, ?, ?, ?)}";
            cstm = cn.prepareCall(sql);
            cstm.setInt(1, solicitud.getId());
            cstm.setString(2, solicitud.getDescripcion());
            cstm.setInt(3, solicitud.getCiudadanoId());
            cstm.setInt(4, solicitud.getTipoSolicitudId());
            cstm.setInt(5, solicitud.getEstadoSolicitudId());

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
    public int actualizarEstadoSolicitud(int solicitudId, int nuevoEstadoId) {
        int resultado = 0;
        Connection cn = null;
        CallableStatement cstm = null;

        try {
            cn = MySQLConexion.getConexion();
            String sql = "{CALL sp_actualizar_estado_solicitud(?, ?)}";
            cstm = cn.prepareCall(sql);
            cstm.setInt(1, solicitudId);
            cstm.setInt(2, nuevoEstadoId);

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

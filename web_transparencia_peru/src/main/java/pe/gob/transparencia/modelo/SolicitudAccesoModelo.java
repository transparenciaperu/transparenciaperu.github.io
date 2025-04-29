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

        // Si la base de datos no está disponible, retorna una lista vacía
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. Retornando lista vacía de solicitudes.");
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
                solicitud.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                solicitud.setFechaRespuesta(rs.getDate("fechaRespuesta"));
                solicitud.setObservaciones(rs.getString("observaciones"));

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

        // Si la base de datos no está disponible, retorna una lista vacía
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. Retornando lista vacía de solicitudes por ciudadano.");
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
                solicitud.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                solicitud.setFechaRespuesta(rs.getDate("fechaRespuesta"));
                solicitud.setObservaciones(rs.getString("observaciones"));

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

        // Si la base de datos no está disponible, retorna una lista vacía
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. Retornando lista vacía de solicitudes por estado.");
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
                solicitud.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                solicitud.setFechaRespuesta(rs.getDate("fechaRespuesta"));
                solicitud.setObservaciones(rs.getString("observaciones"));

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

        // Si la base de datos no está disponible, retorna null
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. Retornando null para solicitud.");
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
                solicitud.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                solicitud.setFechaRespuesta(rs.getDate("fechaRespuesta"));
                solicitud.setObservaciones(rs.getString("observaciones"));

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

        // Si la base de datos no está disponible, retorna 0 (sin éxito)
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. No se puede registrar solicitud.");
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

            String sql = "INSERT INTO SolicitudAcceso (fechaSolicitud, descripcion, ciudadanoId, tipoSolicitudId, estadoSolicitudId, entidadPublicaId, fechaRespuesta, observaciones) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstm = cn.prepareStatement(sql);
            pstm.setDate(1, new java.sql.Date(solicitud.getFechaSolicitud().getTime()));
            pstm.setString(2, solicitud.getDescripcion());
            pstm.setInt(3, solicitud.getCiudadanoId());
            pstm.setInt(4, solicitud.getTipoSolicitudId());
            pstm.setInt(5, solicitud.getEstadoSolicitudId());
            pstm.setInt(6, solicitud.getEntidadPublicaId());
            if (solicitud.getFechaRespuesta() != null) {
                pstm.setDate(7, new java.sql.Date(solicitud.getFechaRespuesta().getTime()));
            } else {
                pstm.setNull(7, java.sql.Types.DATE);
            }
            pstm.setString(8, solicitud.getObservaciones());

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
    public int actualizarSolicitud(SolicitudAccesoEntidad solicitud) {
        int resultado = 0;

        // Si la base de datos no está disponible, retorna 0 (sin éxito)
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. No se puede actualizar solicitud.");
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

            String sql = "UPDATE SolicitudAcceso SET descripcion = ?, ciudadanoId = ?, tipoSolicitudId = ?, " +
                    "estadoSolicitudId = ?, entidadPublicaId = ?, fechaRespuesta = ?, observaciones = ? WHERE id = ?";
            pstm = cn.prepareStatement(sql);
            pstm.setString(1, solicitud.getDescripcion());
            pstm.setInt(2, solicitud.getCiudadanoId());
            pstm.setInt(3, solicitud.getTipoSolicitudId());
            pstm.setInt(4, solicitud.getEstadoSolicitudId());
            pstm.setInt(5, solicitud.getEntidadPublicaId());
            if (solicitud.getFechaRespuesta() != null) {
                pstm.setDate(6, new java.sql.Date(solicitud.getFechaRespuesta().getTime()));
            } else {
                pstm.setNull(6, java.sql.Types.DATE);
            }
            pstm.setString(7, solicitud.getObservaciones());
            pstm.setInt(8, solicitud.getId());

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
    public int actualizarEstadoSolicitud(int solicitudId, int nuevoEstadoId) {
        int resultado = 0;

        // Si la base de datos no está disponible, retorna 0 (sin éxito)
        if (!MySQLConexion.isDbDisponible()) {
            System.out.println("Base de datos no disponible. No se puede actualizar estado de solicitud.");
            return resultado;
        }

        Connection cn = null;
        CallableStatement cstm = null;

        try {
            cn = MySQLConexion.getConexion();

            // Si no se pudo establecer la conexión, retornar 0
            if (cn == null) {
                return resultado;
            }

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
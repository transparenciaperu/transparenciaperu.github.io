package pe.gob.transparencia.modelo;

import pe.gob.transparencia.entidades.DocumentoTransparenciaEntidad;
import pe.gob.transparencia.interfaces.DocumentoTransparenciaInterface;
import pe.gob.transparencia.db.MySQLConexion;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Modelo para gestionar documentos de transparencia en la base de datos
 */
public class DocumentoTransparenciaModelo implements DocumentoTransparenciaInterface {

    /**
     * Crea la tabla DocumentoTransparencia si no existe
     */
    public void crearTabla() {
        Connection con = null;
        PreparedStatement stmt = null;

        try {
            con = MySQLConexion.getConexion();

            String sql = "CREATE TABLE IF NOT EXISTS DocumentoTransparencia (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "titulo VARCHAR(255) NOT NULL, " +
                    "descripcion TEXT, " +
                    "categoria VARCHAR(100) NOT NULL, " +
                    "periodoReferencia VARCHAR(100), " +
                    "fechaPublicacion DATE NOT NULL, " +
                    "fechaActualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
                    "rutaArchivo VARCHAR(255), " +
                    "tipoArchivo VARCHAR(50), " +
                    "estado VARCHAR(20) NOT NULL DEFAULT 'Publicado', " +
                    "usuarioId INT, " +
                    "entidadPublicaId INT, " +
                    "FOREIGN KEY (usuarioId) REFERENCES usuario(id_usuario), " +
                    "FOREIGN KEY (entidadPublicaId) REFERENCES EntidadPublica(id) " +
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";

            stmt = con.prepareStatement(sql);
            stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public int registrar(DocumentoTransparenciaEntidad documento) {
        Connection con = null;
        PreparedStatement stmt = null;
        int resultado = 0;

        try {
            con = MySQLConexion.getConexion();

            String sql = "INSERT INTO DocumentoTransparencia (titulo, descripcion, categoria, periodoReferencia, " +
                    "fechaPublicacion, rutaArchivo, tipoArchivo, estado, usuarioId, entidadPublicaId) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            stmt = con.prepareStatement(sql);
            stmt.setString(1, documento.getTitulo());
            stmt.setString(2, documento.getDescripcion());
            stmt.setString(3, documento.getCategoria());
            stmt.setString(4, documento.getPeriodoReferencia());
            stmt.setDate(5, new java.sql.Date(documento.getFechaPublicacion().getTime()));
            stmt.setString(6, documento.getRutaArchivo());
            stmt.setString(7, documento.getTipoArchivo());
            stmt.setString(8, documento.getEstado());
            stmt.setInt(9, documento.getUsuarioId());
            stmt.setInt(10, documento.getEntidadPublicaId());

            resultado = stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    @Override
    public int actualizar(DocumentoTransparenciaEntidad documento) {
        Connection con = null;
        PreparedStatement stmt = null;
        int resultado = 0;

        try {
            con = MySQLConexion.getConexion();

            String sql = "UPDATE DocumentoTransparencia SET titulo=?, descripcion=?, categoria=?, " +
                    "periodoReferencia=?, fechaPublicacion=?, rutaArchivo=?, tipoArchivo=?, " +
                    "estado=?, usuarioId=?, entidadPublicaId=? WHERE id=?";

            stmt = con.prepareStatement(sql);
            stmt.setString(1, documento.getTitulo());
            stmt.setString(2, documento.getDescripcion());
            stmt.setString(3, documento.getCategoria());
            stmt.setString(4, documento.getPeriodoReferencia());
            stmt.setDate(5, new java.sql.Date(documento.getFechaPublicacion().getTime()));
            stmt.setString(6, documento.getRutaArchivo());
            stmt.setString(7, documento.getTipoArchivo());
            stmt.setString(8, documento.getEstado());
            stmt.setInt(9, documento.getUsuarioId());
            stmt.setInt(10, documento.getEntidadPublicaId());
            stmt.setInt(11, documento.getId());

            resultado = stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    @Override
    public int eliminar(int id) {
        Connection con = null;
        PreparedStatement stmt = null;
        int resultado = 0;

        try {
            con = MySQLConexion.getConexion();

            String sql = "DELETE FROM DocumentoTransparencia WHERE id=?";

            stmt = con.prepareStatement(sql);
            stmt.setInt(1, id);

            resultado = stmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    @Override
    public DocumentoTransparenciaEntidad obtenerPorId(int id) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        DocumentoTransparenciaEntidad documento = null;

        try {
            con = MySQLConexion.getConexion();

            String sql = "SELECT d.*, u.cod_usuario, p.nombre_completo, e.nombre " +
                    "FROM DocumentoTransparencia d " +
                    "LEFT JOIN usuario u ON d.usuarioId = u.id_usuario " +
                    "LEFT JOIN persona p ON u.id_persona = p.id_persona " +
                    "LEFT JOIN EntidadPublica e ON d.entidadPublicaId = e.id " +
                    "WHERE d.id=?";

            stmt = con.prepareStatement(sql);
            stmt.setInt(1, id);

            rs = stmt.executeQuery();

            if (rs.next()) {
                documento = new DocumentoTransparenciaEntidad();
                documento.setId(rs.getInt("id"));
                documento.setTitulo(rs.getString("titulo"));
                documento.setDescripcion(rs.getString("descripcion"));
                documento.setCategoria(rs.getString("categoria"));
                documento.setPeriodoReferencia(rs.getString("periodoReferencia"));
                documento.setFechaPublicacion(rs.getDate("fechaPublicacion"));
                documento.setFechaActualizacion(rs.getTimestamp("fechaActualizacion"));
                documento.setRutaArchivo(rs.getString("rutaArchivo"));
                documento.setTipoArchivo(rs.getString("tipoArchivo"));
                documento.setEstado(rs.getString("estado"));
                documento.setUsuarioId(rs.getInt("usuarioId"));
                documento.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                documento.setNombreUsuario(rs.getString("nombre_completo"));
                documento.setNombreEntidad(rs.getString("nombre"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return documento;
    }

    @Override
    public List<DocumentoTransparenciaEntidad> listar() {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<DocumentoTransparenciaEntidad> lista = new ArrayList<>();

        try {
            con = MySQLConexion.getConexion();

            String sql = "SELECT d.*, u.cod_usuario, p.nombre_completo, e.nombre " +
                    "FROM DocumentoTransparencia d " +
                    "LEFT JOIN usuario u ON d.usuarioId = u.id_usuario " +
                    "LEFT JOIN persona p ON u.id_persona = p.id_persona " +
                    "LEFT JOIN EntidadPublica e ON d.entidadPublicaId = e.id " +
                    "ORDER BY d.fechaPublicacion DESC";

            stmt = con.prepareStatement(sql);

            rs = stmt.executeQuery();

            while (rs.next()) {
                DocumentoTransparenciaEntidad documento = new DocumentoTransparenciaEntidad();
                documento.setId(rs.getInt("id"));
                documento.setTitulo(rs.getString("titulo"));
                documento.setDescripcion(rs.getString("descripcion"));
                documento.setCategoria(rs.getString("categoria"));
                documento.setPeriodoReferencia(rs.getString("periodoReferencia"));
                documento.setFechaPublicacion(rs.getDate("fechaPublicacion"));
                documento.setFechaActualizacion(rs.getTimestamp("fechaActualizacion"));
                documento.setRutaArchivo(rs.getString("rutaArchivo"));
                documento.setTipoArchivo(rs.getString("tipoArchivo"));
                documento.setEstado(rs.getString("estado"));
                documento.setUsuarioId(rs.getInt("usuarioId"));
                documento.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                documento.setNombreUsuario(rs.getString("nombre_completo"));
                documento.setNombreEntidad(rs.getString("nombre"));

                lista.add(documento);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return lista;
    }

    @Override
    public List<DocumentoTransparenciaEntidad> listarPorCategoria(String categoria) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<DocumentoTransparenciaEntidad> lista = new ArrayList<>();

        try {
            con = MySQLConexion.getConexion();

            String sql = "SELECT d.*, u.cod_usuario, p.nombre_completo, e.nombre " +
                    "FROM DocumentoTransparencia d " +
                    "LEFT JOIN usuario u ON d.usuarioId = u.id_usuario " +
                    "LEFT JOIN persona p ON u.id_persona = p.id_persona " +
                    "LEFT JOIN EntidadPublica e ON d.entidadPublicaId = e.id " +
                    "WHERE d.categoria=? " +
                    "ORDER BY d.fechaPublicacion DESC";

            stmt = con.prepareStatement(sql);
            stmt.setString(1, categoria);

            rs = stmt.executeQuery();

            while (rs.next()) {
                DocumentoTransparenciaEntidad documento = new DocumentoTransparenciaEntidad();
                documento.setId(rs.getInt("id"));
                documento.setTitulo(rs.getString("titulo"));
                documento.setDescripcion(rs.getString("descripcion"));
                documento.setCategoria(rs.getString("categoria"));
                documento.setPeriodoReferencia(rs.getString("periodoReferencia"));
                documento.setFechaPublicacion(rs.getDate("fechaPublicacion"));
                documento.setFechaActualizacion(rs.getTimestamp("fechaActualizacion"));
                documento.setRutaArchivo(rs.getString("rutaArchivo"));
                documento.setTipoArchivo(rs.getString("tipoArchivo"));
                documento.setEstado(rs.getString("estado"));
                documento.setUsuarioId(rs.getInt("usuarioId"));
                documento.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                documento.setNombreUsuario(rs.getString("nombre_completo"));
                documento.setNombreEntidad(rs.getString("nombre"));

                lista.add(documento);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return lista;
    }

    @Override
    public List<DocumentoTransparenciaEntidad> listarPorEntidad(int entidadPublicaId) {
        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<DocumentoTransparenciaEntidad> lista = new ArrayList<>();

        try {
            con = MySQLConexion.getConexion();

            String sql = "SELECT d.*, u.cod_usuario, p.nombre_completo, e.nombre " +
                    "FROM DocumentoTransparencia d " +
                    "LEFT JOIN usuario u ON d.usuarioId = u.id_usuario " +
                    "LEFT JOIN persona p ON u.id_persona = p.id_persona " +
                    "LEFT JOIN EntidadPublica e ON d.entidadPublicaId = e.id " +
                    "WHERE d.entidadPublicaId=? " +
                    "ORDER BY d.fechaPublicacion DESC";

            stmt = con.prepareStatement(sql);
            stmt.setInt(1, entidadPublicaId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                DocumentoTransparenciaEntidad documento = new DocumentoTransparenciaEntidad();
                documento.setId(rs.getInt("id"));
                documento.setTitulo(rs.getString("titulo"));
                documento.setDescripcion(rs.getString("descripcion"));
                documento.setCategoria(rs.getString("categoria"));
                documento.setPeriodoReferencia(rs.getString("periodoReferencia"));
                documento.setFechaPublicacion(rs.getDate("fechaPublicacion"));
                documento.setFechaActualizacion(rs.getTimestamp("fechaActualizacion"));
                documento.setRutaArchivo(rs.getString("rutaArchivo"));
                documento.setTipoArchivo(rs.getString("tipoArchivo"));
                documento.setEstado(rs.getString("estado"));
                documento.setUsuarioId(rs.getInt("usuarioId"));
                documento.setEntidadPublicaId(rs.getInt("entidadPublicaId"));
                documento.setNombreUsuario(rs.getString("nombre_completo"));
                documento.setNombreEntidad(rs.getString("nombre"));

                lista.add(documento);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return lista;
    }
}
package pe.gob.transparencia.modelo;

import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.entidades.RegionEntidad;
import pe.gob.transparencia.interfaces.EntidadPublicaInterface;
import pe.gob.transparencia.db.MySQLConexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class EntidadPublicaModelo implements EntidadPublicaInterface {

    @Override
    public List<EntidadPublicaEntidad> listar() {
        List<EntidadPublicaEntidad> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT e.id, e.nombre, e.tipo, e.ruc, e.direccion, " +
                    "r.nombre as region " +
                         "FROM EntidadPublica e " +
                         "LEFT JOIN Region r ON e.regionId = r.id " +
                         "ORDER BY e.nombre";
            pstm = con.prepareStatement(sql);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
                entidad.setId(rs.getInt("id"));
                entidad.setNombre(rs.getString("nombre"));
                entidad.setTipo(rs.getString("tipo"));
                entidad.setRuc(rs.getString("ruc"));
                entidad.setDireccion(rs.getString("direccion"));
                entidad.setRegion(rs.getString("region"));
                lista.add(entidad);
            }
            
        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.listar: " + e.getMessage());
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
    public List<EntidadPublicaEntidad> listarPorNivel(int nivelId) {
        List<EntidadPublicaEntidad> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT e.id, e.nombre, e.tipo, e.ruc, e.direccion, " +
                    "r.nombre as region " +
                    "FROM EntidadPublica e " +
                    "INNER JOIN NivelGobierno n ON e.nivelGobiernoId = n.id " +
                    "LEFT JOIN Region r ON e.regionId = r.id " +
                    "WHERE n.id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, nivelId);
            rs = pstm.executeQuery();
            
            while (rs.next()) {
                EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
                entidad.setId(rs.getInt("id"));
                entidad.setNombre(rs.getString("nombre"));
                entidad.setTipo(rs.getString("tipo"));
                entidad.setRuc(rs.getString("ruc"));
                entidad.setDireccion(rs.getString("direccion"));
                entidad.setRegion(rs.getString("region"));
                lista.add(entidad);
            }
            
        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.listarPorNivel: " + e.getMessage());
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
    public EntidadPublicaEntidad buscarPorId(int id) {
        EntidadPublicaEntidad entidad = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT e.id, e.nombre, e.tipo, e.nivelGobiernoId, e.regionId, e.direccion, " +
                    "e.telefono, e.email, e.sitioWeb, e.ruc " +
                    "FROM EntidadPublica e " +
                    "WHERE e.id = ?";

            System.out.println("EntidadPublicaModelo - buscarPorId - Buscando entidad con ID: " + id);
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();
            
            if (rs.next()) {
                entidad = new EntidadPublicaEntidad();
                entidad.setId(rs.getInt("id"));
                entidad.setNombre(rs.getString("nombre"));
                entidad.setTipo(rs.getString("tipo"));
                entidad.setNivelGobiernoId(rs.getInt("nivelGobiernoId"));
                entidad.setRegionId(rs.getInt("regionId"));
                entidad.setDireccion(rs.getString("direccion"));
                entidad.setTelefono(rs.getString("telefono"));
                entidad.setEmail(rs.getString("email"));
                entidad.setSitioWeb(rs.getString("sitioWeb"));
                entidad.setRuc(rs.getString("ruc"));

                System.out.println("EntidadPublicaModelo - buscarPorId - Entidad encontrada: " + entidad.getNombre());
            } else {
                System.out.println("EntidadPublicaModelo - buscarPorId - No se encontró entidad con ID: " + id);
            }
            
        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.buscarPorId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }
        
        return entidad;
    }

    @Override
    public int insertar(EntidadPublicaEntidad entidad) {
        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "INSERT INTO EntidadPublica (nombre, tipo, ruc, direccion, regionId) VALUES (?, ?, ?, ?, " +
                    "(SELECT id FROM Region WHERE nombre = ?))";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, entidad.getNombre());
            pstm.setString(2, entidad.getTipo());
            pstm.setString(3, entidad.getRuc());
            pstm.setString(4, entidad.getDireccion());
            pstm.setString(5, entidad.getRegion());
            resultado = pstm.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.insertar: " + e.getMessage());
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
    public int actualizar(EntidadPublicaEntidad entidad) {
        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        
        try {
            con = MySQLConexion.getConexion();
            String sql = "UPDATE EntidadPublica SET nombre = ?, tipo = ?, ruc = ?, direccion = ?, " +
                    "regionId = (SELECT id FROM Region WHERE nombre = ?) WHERE id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setString(1, entidad.getNombre());
            pstm.setString(2, entidad.getTipo());
            pstm.setString(3, entidad.getRuc());
            pstm.setString(4, entidad.getDireccion());
            pstm.setString(5, entidad.getRegion());
            pstm.setInt(6, entidad.getId());
            resultado = pstm.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.actualizar: " + e.getMessage());
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
            String sql = "DELETE FROM EntidadPublica WHERE id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            resultado = pstm.executeUpdate();
            
        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.eliminar: " + e.getMessage());
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

    public List<EntidadPublicaEntidad> listarEntidades() {
        List<EntidadPublicaEntidad> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT e.id, e.nombre, e.tipo, e.nivelGobiernoId, e.regionId, e.direccion, " +
                    "e.telefono, e.email, e.sitioWeb " +
                    "FROM EntidadPublica e " +
                    "ORDER BY e.nombre";
            pstm = con.prepareStatement(sql);
            rs = pstm.executeQuery();

            System.out.println("Ejecutando consulta SQL para listar entidades...");

            int count = 0;
            while (rs.next()) {
                count++;
                EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
                entidad.setId(rs.getInt("id"));
                entidad.setNombre(rs.getString("nombre"));
                entidad.setTipo(rs.getString("tipo"));
                entidad.setNivelGobiernoId(rs.getInt("nivelGobiernoId"));
                entidad.setRegionId(rs.getInt("regionId"));
                entidad.setDireccion(rs.getString("direccion"));
                entidad.setTelefono(rs.getString("telefono"));
                entidad.setEmail(rs.getString("email"));
                entidad.setSitioWeb(rs.getString("sitioWeb"));
                lista.add(entidad);
            }

            System.out.println("Entidades recuperadas de la base de datos: " + count);

        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.listarEntidades: " + e.getMessage());
            e.printStackTrace();
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

    public int registrarEntidad(EntidadPublicaEntidad entidad) {
        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            con = MySQLConexion.getConexion();
            String sql = "INSERT INTO EntidadPublica (nombre, tipo, direccion, nivelGobiernoId, regionId, telefono, email, sitioWeb) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            pstm = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstm.setString(1, entidad.getNombre());
            pstm.setString(2, entidad.getTipo());
            pstm.setString(3, entidad.getDireccion());
            pstm.setInt(4, entidad.getNivelGobiernoId());
            pstm.setInt(5, entidad.getRegionId());
            pstm.setString(6, entidad.getTelefono());
            pstm.setString(7, entidad.getEmail());
            pstm.setString(8, entidad.getSitioWeb());

            resultado = pstm.executeUpdate();

            if (resultado > 0) {
                rs = pstm.getGeneratedKeys();
                if (rs.next()) {
                    resultado = rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.registrarEntidad: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }

        return resultado;
    }

    public int actualizarEntidad(EntidadPublicaEntidad entidad) {
        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;

        try {
            System.out.println("EntidadPublicaModelo - actualizarEntidad - Iniciando actualización para entidad ID: " + entidad.getId());

            // Validar datos de entrada
            if (entidad.getNombre() == null || entidad.getNombre().trim().isEmpty()) {
                System.out.println("EntidadPublicaModelo - actualizarEntidad - Error: Nombre es obligatorio");
                return 0;
            }

            if (entidad.getTipo() == null || entidad.getTipo().trim().isEmpty()) {
                System.out.println("EntidadPublicaModelo - actualizarEntidad - Error: Tipo es obligatorio");
                return 0;
            }

            if (entidad.getNivelGobiernoId() <= 0) {
                System.out.println("EntidadPublicaModelo - actualizarEntidad - Error: Nivel de Gobierno es obligatorio");
                return 0;
            }

            // Si no es nivel nacional (id=1) y no tiene región
            if (entidad.getNivelGobiernoId() != 1 && entidad.getRegionId() <= 0) {
                System.out.println("EntidadPublicaModelo - actualizarEntidad - Error: Región es obligatoria para este nivel de gobierno");
                return 0;
            }

            // Sanear datos opcionales
            String direccion = (entidad.getDireccion() != null) ? entidad.getDireccion() : "";
            String telefono = (entidad.getTelefono() != null) ? entidad.getTelefono() : "";
            String email = (entidad.getEmail() != null) ? entidad.getEmail() : "";
            String sitioWeb = (entidad.getSitioWeb() != null) ? entidad.getSitioWeb() : "";

            System.out.println("EntidadPublicaModelo - actualizarEntidad - Conectando a BD...");
            con = MySQLConexion.getConexion();

            if (con == null) {
                System.out.println("EntidadPublicaModelo - actualizarEntidad - Error: No se pudo conectar a la base de datos");
                return 0;
            }

            String sql = "UPDATE EntidadPublica SET nombre = ?, tipo = ?, direccion = ?, " +
                    "nivelGobiernoId = ?, regionId = ?, telefono = ?, email = ?, sitioWeb = ? WHERE id = ?";

            System.out.println("EntidadPublicaModelo - actualizarEntidad - SQL a ejecutar: " + sql);
            System.out.println("EntidadPublicaModelo - actualizarEntidad - Parámetros: " +
                    "nombre=" + entidad.getNombre() + ", " +
                    "tipo=" + entidad.getTipo() + ", " +
                    "direccion=" + direccion + ", " +
                    "nivelGobiernoId=" + entidad.getNivelGobiernoId() + ", " +
                    "regionId=" + entidad.getRegionId() + ", " +
                    "telefono=" + telefono + ", " +
                    "email=" + email + ", " +
                    "sitioWeb=" + sitioWeb + ", " +
                    "id=" + entidad.getId());

            pstm = con.prepareStatement(sql);
            pstm.setString(1, entidad.getNombre());
            pstm.setString(2, entidad.getTipo());
            pstm.setString(3, direccion);
            pstm.setInt(4, entidad.getNivelGobiernoId());
            pstm.setInt(5, entidad.getRegionId());
            pstm.setString(6, telefono);
            pstm.setString(7, email);
            pstm.setString(8, sitioWeb);
            pstm.setInt(9, entidad.getId());

            resultado = pstm.executeUpdate();
            System.out.println("EntidadPublicaModelo - actualizarEntidad - Resultados afectados: " + resultado);

        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.actualizarEntidad: " + e.getMessage());
            e.printStackTrace();
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

    public int eliminarEntidad(int id) {
        return this.eliminar(id);
    }

    public String obtenerNombreRegion(int regionId) {
        String nombreRegion = null;
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            con = MySQLConexion.getConexion();
            String sql = "SELECT nombre FROM Region WHERE id = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, regionId);
            rs = pstm.executeQuery();

            if (rs.next()) {
                nombreRegion = rs.getString("nombre");
            }

        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.obtenerNombreRegion: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }

        return nombreRegion;
    }

    public List<RegionEntidad> listarRegiones() {
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
            System.out.println("Error en EntidadPublicaModelo.listarRegiones: " + e.getMessage());
            e.printStackTrace();
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

    public List<EntidadPublicaEntidad> listarPorNivelYRegion(int nivelId, Integer regionId) {
        List<EntidadPublicaEntidad> lista = new ArrayList<>();
        Connection con = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            con = MySQLConexion.getConexion();

            String sql = "SELECT e.id, e.nombre, e.tipo, e.nivelGobiernoId, e.regionId, " +
                    "r.nombre as region_nombre " +
                    "FROM EntidadPublica e " +
                    "LEFT JOIN Region r ON e.regionId = r.id " +
                    "WHERE e.nivelGobiernoId = ?";

            // Si se especifica una región, agregar el filtro
            if (regionId != null && regionId > 0) {
                sql += " AND e.regionId = ?";
            }

            sql += " ORDER BY e.nombre";

            pstm = con.prepareStatement(sql);
            pstm.setInt(1, nivelId);

            if (regionId != null && regionId > 0) {
                pstm.setInt(2, regionId);
            }

            rs = pstm.executeQuery();

            while (rs.next()) {
                EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
                entidad.setId(rs.getInt("id"));
                entidad.setNombre(rs.getString("nombre"));
                entidad.setTipo(rs.getString("tipo"));
                entidad.setNivelGobiernoId(rs.getInt("nivelGobiernoId"));
                entidad.setRegionId(rs.getInt("regionId"));

                // Agregar región si existe
                String regionNombre = rs.getString("region_nombre");
                if (regionNombre != null) {
                    entidad.setRegion(regionNombre);
                }

                lista.add(entidad);
            }

        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.listarPorNivelYRegion: " + e.getMessage());
            e.printStackTrace();
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
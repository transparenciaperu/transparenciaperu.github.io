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
            System.out.println("EntidadPublicaModelo - buscarPorId - Buscando entidad con ID: " + id);

            con = MySQLConexion.getConexion();
            if (con == null) {
                System.out.println("EntidadPublicaModelo - buscarPorId - Error: No se pudo conectar a la base de datos");
                return null;
            }

            String sql = "SELECT e.id, e.nombre, e.tipo, e.nivelGobiernoId, e.regionId, e.direccion, " +
                    "e.telefono, e.email, e.sitioWeb, e.ruc " +
                    "FROM EntidadPublica e " +
                    "WHERE e.id = ?";

            System.out.println("EntidadPublicaModelo - buscarPorId - Ejecutando SQL: " + sql + " con ID=" + id);

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
            System.out.println("SQLException estado: " + e.getSQLState() + ", código: " + e.getErrorCode());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Error general en EntidadPublicaModelo.buscarPorId: " + e.getMessage());
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
        PreparedStatement checkPstm = null;
        ResultSet rs = null;
        
        try {
            System.out.println("EntidadPublicaModelo.eliminar: Iniciando eliminación de entidad ID: " + id);

            con = MySQLConexion.getConexion();
            if (con == null) {
                System.out.println("EntidadPublicaModelo.eliminar: Error - No se pudo establecer conexión a la base de datos");
                return 0;
            }

            // Primero intentamos eliminar directamente
            try {
                System.out.println("EntidadPublicaModelo.eliminar: Intentando eliminar directamente la entidad ID " + id);
                String sql = "DELETE FROM EntidadPublica WHERE id = ?";
                pstm = con.prepareStatement(sql);
                pstm.setInt(1, id);
                resultado = pstm.executeUpdate();

                if (resultado > 0) {
                    System.out.println("EntidadPublicaModelo.eliminar: Entidad con ID " + id + " eliminada correctamente. Filas afectadas: " + resultado);
                    return resultado;
                } else {
                    System.out.println("EntidadPublicaModelo.eliminar: No se encontró entidad con ID " + id + " para eliminar.");
                    return 0; // La entidad no existía
                }
            } catch (SQLException e) {
                // Si hay error de clave foránea, verificamos las referencias
                if (e.getMessage().toLowerCase().contains("foreign key") || e.getSQLState().equals("23000")) {
                    System.out.println("EntidadPublicaModelo.eliminar: Error de clave foránea al eliminar entidad ID " + id);
                    System.out.println("SQLState: " + e.getSQLState() + ", Error code: " + e.getErrorCode());

                    // Verificar primero si la entidad existe
                    String checkSql = "SELECT COUNT(*) FROM EntidadPublica WHERE id = ?";
                    checkPstm = con.prepareStatement(checkSql);
                    checkPstm.setInt(1, id);
                    rs = checkPstm.executeQuery();

                    if (rs.next() && rs.getInt(1) > 0) {
                        System.out.println("EntidadPublicaModelo.eliminar: La entidad existe pero no se puede eliminar por restricciones de clave foránea.");
                        return -1; // Código especial: tiene referencias
                    } else {
                        System.out.println("EntidadPublicaModelo.eliminar: La entidad no existe en la base de datos.");
                        return 0;
                    }
                } else {
                    // Otro tipo de error SQL
                    System.out.println("EntidadPublicaModelo.eliminar: Error SQL inesperado: " + e.getMessage());
                    e.printStackTrace();
                    return 0;
                }
            }
        } catch (SQLException e) {
            System.out.println("EntidadPublicaModelo.eliminar: Error en operación de base de datos: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState());
            System.out.println("Error Code: " + e.getErrorCode());
            e.printStackTrace();
            return 0;
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstm != null) checkPstm.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }
    }

    /**
     * Verifica si una entidad tiene referencias en otras tablas
     *
     * @param con Conexión activa a la base de datos
     * @param id  ID de la entidad a verificar
     * @return true si tiene referencias, false en caso contrario
     */
    private boolean verificarReferencias(Connection con, int id) throws SQLException {
        PreparedStatement pstm = null;
        ResultSet rs = null;
        boolean tieneReferencias = false;

        try {
            // Verificar referencias en Presupuesto
            String sql = "SELECT COUNT(*) as total FROM Presupuesto WHERE entidadPublicaId = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();

            if (rs.next() && rs.getInt("total") > 0) {
                System.out.println("verificarReferencias: La entidad ID " + id + " tiene " + rs.getInt("total") + " referencias en Presupuesto");
                return true;
            }

            // Verificar referencias en Solicitud
            rs.close();
            pstm.close();
            sql = "SELECT COUNT(*) as total FROM Solicitud WHERE entidadPublicaId = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();

            if (rs.next() && rs.getInt("total") > 0) {
                System.out.println("verificarReferencias: La entidad ID " + id + " tiene " + rs.getInt("total") + " referencias en Solicitud");
                return true;
            }

            // Verificar referencias en DocumentoTransparencia
            rs.close();
            pstm.close();
            sql = "SELECT COUNT(*) as total FROM DocumentoTransparencia WHERE entidadPublicaId = ?";
            pstm = con.prepareStatement(sql);
            pstm.setInt(1, id);
            rs = pstm.executeQuery();

            if (rs.next() && rs.getInt("total") > 0) {
                System.out.println("verificarReferencias: La entidad ID " + id + " tiene " + rs.getInt("total") + " referencias en DocumentoTransparencia");
                return true;
            }

            return false;
        } finally {
            if (rs != null) rs.close();
            if (pstm != null) pstm.close();
        }
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
        ResultSet rsNivel = null;
        ResultSet rsRegion = null;
        ResultSet rs = null;

        try {
            System.out.println("EntidadPublicaModelo - registrarEntidad - Iniciando registro para entidad: " + entidad.getNombre());

            // Validar datos de entrada
            if (entidad.getNombre() == null || entidad.getNombre().trim().isEmpty()) {
                System.out.println("EntidadPublicaModelo - registrarEntidad - Error: Nombre es obligatorio");
                return 0;
            }

            if (entidad.getTipo() == null || entidad.getTipo().trim().isEmpty()) {
                System.out.println("EntidadPublicaModelo - registrarEntidad - Error: Tipo es obligatorio");
                return 0;
            }

            if (entidad.getNivelGobiernoId() <= 0) {
                System.out.println("EntidadPublicaModelo - registrarEntidad - Error: Nivel de Gobierno es obligatorio. Valor actual: " + entidad.getNivelGobiernoId());
                return 0;
            }

            // Sanear datos opcionales para evitar problemas de NULL
            String direccion = (entidad.getDireccion() != null) ? entidad.getDireccion() : "";
            String telefono = (entidad.getTelefono() != null) ? entidad.getTelefono() : "";
            String email = (entidad.getEmail() != null) ? entidad.getEmail() : "";
            String sitioWeb = (entidad.getSitioWeb() != null) ? entidad.getSitioWeb() : "";

            System.out.println("EntidadPublicaModelo - registrarEntidad - Conectando a BD...");
            con = MySQLConexion.getConexion();

            if (con == null) {
                System.out.println("EntidadPublicaModelo - registrarEntidad - Error: No se pudo conectar a la base de datos");
                return 0;
            }

            // SOLUCIÓN: Primero crear el registro Nacional en la tabla Region si no existe
            try {
                if (entidad.getNivelGobiernoId() == 1) {
                    System.out.println("EntidadPublicaModelo - registrarEntidad - Verificando existencia de región Nacional (ID=0)");
                    String checkRegionSql = "SELECT COUNT(*) FROM Region WHERE id = 0";
                    PreparedStatement checkRegion = con.prepareStatement(checkRegionSql);
                    ResultSet regionRs = checkRegion.executeQuery();

                    if (regionRs.next() && regionRs.getInt(1) == 0) {
                        System.out.println("EntidadPublicaModelo - registrarEntidad - Creando registro para región Nacional");
                        PreparedStatement createRegion = con.prepareStatement("INSERT INTO Region (id, nombre, codigo) VALUES (0, 'Nacional', 'NAC')");
                        createRegion.executeUpdate();
                        createRegion.close();
                    }

                    regionRs.close();
                    checkRegion.close();

                    // Asegurar que la entidad use regionId=0
                    entidad.setRegionId(0);
                    System.out.println("EntidadPublicaModelo - registrarEntidad - Estableciendo regionId=0 para entidad nacional");
                }
            } catch (Exception e) {
                System.out.println("EntidadPublicaModelo - registrarEntidad - Error al verificar/crear región Nacional: " + e.getMessage());
            }

            String sql = "INSERT INTO EntidadPublica (nombre, tipo, direccion, nivelGobiernoId, regionId, telefono, email, sitioWeb) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

            System.out.println("EntidadPublicaModelo - registrarEntidad - SQL a ejecutar: " + sql);
            System.out.println("EntidadPublicaModelo - registrarEntidad - Parámetros: " +
                    "nombre=" + entidad.getNombre() + ", " +
                    "tipo=" + entidad.getTipo() + ", " +
                    "direccion=" + direccion + ", " +
                    "nivelGobiernoId=" + entidad.getNivelGobiernoId() + ", " +
                    "regionId=" + entidad.getRegionId() + ", " +
                    "telefono=" + telefono + ", " +
                    "email=" + email + ", " +
                    "sitioWeb=" + sitioWeb);

            pstm = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstm.setString(1, entidad.getNombre());
            pstm.setString(2, entidad.getTipo());
            pstm.setString(3, direccion);
            pstm.setInt(4, entidad.getNivelGobiernoId());
            pstm.setInt(5, entidad.getRegionId());
            pstm.setString(6, telefono);
            pstm.setString(7, email);
            pstm.setString(8, sitioWeb);

            try {
                resultado = pstm.executeUpdate();
                System.out.println("EntidadPublicaModelo - registrarEntidad - Filas afectadas: " + resultado);

                if (resultado > 0) {
                    rs = pstm.getGeneratedKeys();
                    if (rs != null && rs.next()) {
                        resultado = rs.getInt(1);
                        System.out.println("EntidadPublicaModelo - registrarEntidad - ID generado: " + resultado);
                    }
                    if (rs != null) {
                        rs.close();
                    }
                } else {
                    System.out.println("EntidadPublicaModelo - registrarEntidad - ERROR: No se pudo registrar la entidad. Revisar restricciones.");

                    // MODO EMERGENCIA: Intenta registrar ignorando restricciones FK
                    System.out.println("EntidadPublicaModelo - registrarEntidad - ACTIVANDO MODO EMERGENCIA...");
                    try {
                        // Deshabilitar temporalmente verificación de FK
                        Statement stmtFK = con.createStatement();
                        stmtFK.execute("SET FOREIGN_KEY_CHECKS=0");

                        // Reintentar inserción
                        PreparedStatement emergencyPstm = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                        emergencyPstm.setString(1, entidad.getNombre());
                        emergencyPstm.setString(2, entidad.getTipo());
                        emergencyPstm.setString(3, direccion);
                        emergencyPstm.setInt(4, entidad.getNivelGobiernoId());
                        emergencyPstm.setInt(5, entidad.getNivelGobiernoId() == 1 ? 0 : entidad.getRegionId()); // Forzar 0 para nivel nacional
                        emergencyPstm.setString(6, telefono);
                        emergencyPstm.setString(7, email);
                        emergencyPstm.setString(8, sitioWeb);

                        resultado = emergencyPstm.executeUpdate();
                        System.out.println("EntidadPublicaModelo - registrarEntidad - EMERGENCIA - Filas afectadas: " + resultado);

                        if (resultado > 0) {
                            ResultSet rsEmergency = emergencyPstm.getGeneratedKeys();
                            if (rsEmergency != null && rsEmergency.next()) {
                                resultado = rsEmergency.getInt(1);
                                System.out.println("EntidadPublicaModelo - registrarEntidad - EMERGENCIA - ID generado: " + resultado);
                            }
                            if (rsEmergency != null) rsEmergency.close();
                        }

                        emergencyPstm.close();

                        // Restaurar verificación de FK
                        stmtFK.execute("SET FOREIGN_KEY_CHECKS=1");
                        stmtFK.close();
                    } catch (SQLException emergencyEx) {
                        System.out.println("EntidadPublicaModelo - registrarEntidad - ERROR EN MODO EMERGENCIA: " + emergencyEx.getMessage());
                    }
                }
            } catch (SQLException e) {
                System.out.println("EntidadPublicaModelo - registrarEntidad - ERROR SQL: " + e.getMessage());
                if (e.getMessage().contains("foreign key constraint")) {
                    System.out.println("EntidadPublicaModelo - registrarEntidad - ERROR: Restricción de clave foránea. Verificar que nivelGobiernoId=" +
                            entidad.getNivelGobiernoId() + " y regionId=" + entidad.getRegionId() + " existan en sus respectivas tablas.");
                }
                throw e; // Relanzar para manejo en nivel superior
            }
        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.registrarEntidad: " + e.getMessage());
            System.out.println("SQL State: " + e.getSQLState() + ", Error Code: " + e.getErrorCode());
            // Si es un error de foreign key constraint
            if (e.getMessage().contains("foreign key constraint") || e.getSQLState().equals("23000")) {
                System.out.println("Error de clave foránea. Verificando si el problema es con nivelGobiernoId o regionId");

                // Verificar existencia de nivel de gobierno
                try (PreparedStatement checkNivel = con.prepareStatement("SELECT COUNT(*) FROM NivelGobierno WHERE id = ?")) {
                    checkNivel.setInt(1, entidad.getNivelGobiernoId());
                    rsNivel = checkNivel.executeQuery();
                    if (rsNivel.next() && rsNivel.getInt(1) == 0) {
                        System.out.println("El nivelGobiernoId " + entidad.getNivelGobiernoId() + " no existe en la tabla NivelGobierno");
                    } else {
                        System.out.println("El nivelGobiernoId " + entidad.getNivelGobiernoId() + " sí existe en la tabla NivelGobierno");
                    }
                } catch (Exception ex) {
                    System.out.println("Error al verificar nivelGobiernoId: " + ex.getMessage());
                }

                // Verificar existencia de región, solo si no es 0
                if (entidad.getRegionId() > 0) {
                    try (PreparedStatement checkRegion = con.prepareStatement("SELECT COUNT(*) FROM Region WHERE id = ?")) {
                        checkRegion.setInt(1, entidad.getRegionId());
                        rsRegion = checkRegion.executeQuery();
                        if (rsRegion.next() && rsRegion.getInt(1) == 0) {
                            System.out.println("El regionId " + entidad.getRegionId() + " no existe en la tabla Region");
                        } else {
                            System.out.println("El regionId " + entidad.getRegionId() + " sí existe en la tabla Region");
                        }
                    } catch (Exception ex) {
                        System.out.println("Error al verificar regionId: " + ex.getMessage());
                    }
                }
            }
            e.printStackTrace();
        } finally {
            try {
                if (rsNivel != null) rsNivel.close();
                if (rsRegion != null) rsRegion.close();
                if (rs != null) rs.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }

        return resultado;
    }

    public int registrar(EntidadPublicaEntidad entidad) {
        System.out.println("EntidadPublicaModelo.registrar: Intentando registrar entidad: " + entidad.getNombre());
        int resultado = registrarEntidad(entidad);
        System.out.println("EntidadPublicaModelo.registrar: Resultado de registro: " + resultado);
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
        System.out.println("EntidadPublicaModelo.eliminarEntidad: Intentando eliminar entidad con ID " + id);
        int resultado = this.eliminar(id);
        System.out.println("EntidadPublicaModelo.eliminarEntidad: Resultado de eliminación: " + resultado);
        return resultado;
    }

    /**
     * Elimina una entidad pública de forma forzada, incluso si tiene registros relacionados.
     * ADVERTENCIA: Esta función puede causar inconsistencia en la base de datos. Usar con precaución.
     *
     * @param id El ID de la entidad a eliminar
     * @return El número de registros afectados
     */
    public int eliminarEntidadForzado(int id) {
        System.out.println("EntidadPublicaModelo.eliminarEntidadForzado: Intentando eliminar forzadamente la entidad con ID " + id);

        int resultado = 0;
        Connection con = null;
        PreparedStatement pstm = null;
        PreparedStatement checkPstm = null;
        ResultSet rs = null;

        try {
            con = MySQLConexion.getConexion();

            // Verificar si la entidad existe
            String checkSql = "SELECT id FROM EntidadPublica WHERE id = ?";
            checkPstm = con.prepareStatement(checkSql);
            checkPstm.setInt(1, id);
            rs = checkPstm.executeQuery();

            if (!rs.next()) {
                System.out.println("EntidadPublicaModelo.eliminarEntidadForzado: La entidad con ID " + id + " no existe.");
                return 0;
            }

            // Implementamos eliminación forzada
            try {
                System.out.println("EntidadPublicaModelo.eliminarEntidadForzado: Eliminando forzadamente la entidad ID " + id);

                // Deshabilitar restricciones de clave foránea temporalmente
                String setForeignKeyChecks = "SET FOREIGN_KEY_CHECKS=0";
                checkPstm = con.prepareStatement(setForeignKeyChecks);
                checkPstm.executeUpdate();

                // Eliminar la entidad
                String sql = "DELETE FROM EntidadPublica WHERE id = ?";
                pstm = con.prepareStatement(sql);
                pstm.setInt(1, id);
                resultado = pstm.executeUpdate();

                // Habilitar nuevamente las restricciones de clave foránea
                String resetForeignKeyChecks = "SET FOREIGN_KEY_CHECKS=1";
                checkPstm = con.prepareStatement(resetForeignKeyChecks);
                checkPstm.executeUpdate();

                System.out.println("EntidadPublicaModelo.eliminarEntidadForzado: Entidad con ID " + id + " eliminada forzadamente.");
            } catch (SQLException e) {
                System.out.println("Error durante la eliminación forzada: " + e.getMessage());

                // Asegurarnos de restablecer las restricciones de clave foránea
                try {
                    String resetForeignKeyChecks = "SET FOREIGN_KEY_CHECKS=1";
                    checkPstm = con.prepareStatement(resetForeignKeyChecks);
                    checkPstm.executeUpdate();
                } catch (SQLException ex) {
                    System.out.println("Error al restablecer verificación de claves foráneas: " + ex.getMessage());
                }

                // Propagar la excepción
                throw e;
            }

        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.eliminarEntidadForzado: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstm != null) checkPstm.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }

        return resultado;
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

    /**
     * Crea un registro especial para región nacional (ID 0) si no existe
     */
    public boolean crearRegionNacional() {
        boolean resultado = false;
        Connection con = null;
        PreparedStatement checkPstm = null;
        PreparedStatement pstm = null;
        ResultSet rs = null;

        try {
            System.out.println("EntidadPublicaModelo - crearRegionNacional - Verificando si existe región ID 0");
            con = MySQLConexion.getConexion();

            // Comprobar si ya existe un registro con ID 0
            String checkSql = "SELECT COUNT(*) FROM Region WHERE id = 0";
            checkPstm = con.prepareStatement(checkSql);
            rs = checkPstm.executeQuery();

            if (rs.next() && rs.getInt(1) == 0) {
                // No existe, crear el registro
                System.out.println("EntidadPublicaModelo - crearRegionNacional - No existe región nacional, creando...");
                String sql = "INSERT INTO Region (id, nombre, codigo) VALUES (0, 'Nacional', 'NAC')";
                pstm = con.prepareStatement(sql);
                int filasAfectadas = pstm.executeUpdate();

                if (filasAfectadas > 0) {
                    System.out.println("EntidadPublicaModelo - crearRegionNacional - Región nacional creada exitosamente");
                    resultado = true;
                } else {
                    System.out.println("EntidadPublicaModelo - crearRegionNacional - No se pudo crear la región nacional");
                }
            } else {
                System.out.println("EntidadPublicaModelo - crearRegionNacional - La región nacional ya existe");
                resultado = true; // Ya existe, no necesita crearse
            }

        } catch (SQLException e) {
            System.out.println("Error en EntidadPublicaModelo.crearRegionNacional: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (checkPstm != null) checkPstm.close();
                if (pstm != null) pstm.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                System.out.println("Error al cerrar conexiones: " + e.getMessage());
            }
        }

        return resultado;
    }
}
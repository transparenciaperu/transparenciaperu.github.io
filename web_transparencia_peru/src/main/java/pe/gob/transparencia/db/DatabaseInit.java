package pe.gob.transparencia.db;

import java.sql.*;

/**
 * Clase para inicializar estructuras necesarias de la base de datos
 */
public class DatabaseInit {

    /**
     * Inicializa las estructuras necesarias en la base de datos
     */
    public static void init() {
        Connection conn = null;
        Statement stmt = null;

        try {
            // Obtener conexión
            conn = MySQLConexion.getConexion();
            if (conn == null) {
                System.out.println("No se pudo conectar a la base de datos para inicializar estructuras");
                return;
            }

            // Verificar si existe el campo activo en la tabla usuario
            boolean existeCampoActivo = verificarExistenciaCampoActivo(conn);

            // Si no existe el campo activo, agregarlo
            if (!existeCampoActivo) {
                System.out.println("Agregando campo 'activo' a la tabla usuario...");
                stmt = conn.createStatement();
                String sql = "ALTER TABLE usuario ADD COLUMN activo BOOLEAN DEFAULT TRUE";
                stmt.executeUpdate(sql);
                System.out.println("Campo 'activo' agregado correctamente a la tabla usuario");
            } else {
                System.out.println("Campo 'activo' ya existe en la tabla usuario");
            }

        } catch (Exception e) {
            System.out.println("Error al inicializar estructuras de la base de datos: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Verifica si existe el campo activo en la tabla usuario
     *
     * @param conn Conexión a la base de datos
     * @return true si existe el campo, false en caso contrario
     */
    private static boolean verificarExistenciaCampoActivo(Connection conn) {
        ResultSet rs = null;
        try {
            DatabaseMetaData metaData = conn.getMetaData();
            rs = metaData.getColumns(null, null, "usuario", "activo");
            return rs.next(); // Si hay resultados, el campo existe
        } catch (Exception e) {
            System.out.println("Error al verificar la existencia del campo 'activo': " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Imprime información detallada sobre los usuarios en la base de datos para depuración
     */
    public static void imprimirInformacionUsuarios() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            conn = MySQLConexion.getConexion();
            if (conn == null) {
                System.out.println("No se pudo conectar a la base de datos para obtener información de usuarios");
                return;
            }

            stmt = conn.createStatement();

            // Imprimir información de tabla rol
            System.out.println("=== INFORMACIÓN DE TABLA ROL ===");
            rs = stmt.executeQuery("SELECT * FROM rol");
            int countRol = 0;
            while (rs.next()) {
                countRol++;
                System.out.println("Rol #" + countRol + ": id=" + rs.getInt("id_rol") +
                        ", código=" + rs.getString("cod_rol") +
                        ", descripción=" + rs.getString("descrip_rol"));
            }
            System.out.println("Total registros en tabla rol: " + countRol);

            // Imprimir información de tabla persona
            System.out.println("=== INFORMACIÓN DE TABLA PERSONA ===");
            rs = stmt.executeQuery("SELECT * FROM persona");
            int countPersona = 0;
            while (rs.next()) {
                countPersona++;
                System.out.println("Persona #" + countPersona + ": id=" + rs.getInt("id_persona") +
                        ", nombre=" + rs.getString("nombre_completo") +
                        ", correo=" + rs.getString("correo"));
            }
            System.out.println("Total registros en tabla persona: " + countPersona);

            // Imprimir información de tabla usuario
            System.out.println("=== INFORMACIÓN DE TABLA USUARIO ===");
            rs = stmt.executeQuery("SELECT * FROM usuario");
            int countUsuario = 0;
            while (rs.next()) {
                countUsuario++;
                System.out.println("Usuario #" + countUsuario + ": id=" + rs.getInt("id_usuario") +
                        ", código=" + rs.getString("cod_usuario") +
                        ", id_persona=" + rs.getInt("id_persona") +
                        ", id_rol=" + rs.getInt("id_rol"));

                // Verificar si existe el campo activo
                try {
                    boolean activo = rs.getBoolean("activo");
                    System.out.println("  - Campo activo: " + activo);
                } catch (SQLException e) {
                    System.out.println("  - Campo activo no encontrado");
                }
            }
            System.out.println("Total registros en tabla usuario: " + countUsuario);

            // Imprimir información de los usuarios completos (con joins)
            System.out.println("=== USUARIOS COMPLETOS (CON JOINS) ===");
            rs = stmt.executeQuery("SELECT u.id_usuario, u.cod_usuario, p.nombre_completo, p.correo, r.cod_rol " +
                    "FROM usuario u " +
                    "LEFT JOIN persona p ON u.id_persona = p.id_persona " +
                    "LEFT JOIN rol r ON u.id_rol = r.id_rol");
            int countCompleto = 0;
            while (rs.next()) {
                countCompleto++;
                System.out.println("Usuario completo #" + countCompleto + ": id=" + rs.getInt("id_usuario") +
                        ", código=" + rs.getString("cod_usuario") +
                        ", nombre=" + rs.getString("nombre_completo") +
                        ", correo=" + rs.getString("correo") +
                        ", rol=" + rs.getString("cod_rol"));
            }
            System.out.println("Total registros completos: " + countCompleto);

        } catch (Exception e) {
            System.out.println("Error al imprimir información de usuarios: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
package pe.gob.transparencia.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase utilitaria para manejar la conexión a la base de datos
 */
public class ConexionBD {

    // Configuración de la base de datos
    private static final String URL = "jdbc:mysql://localhost:3306/db_transparencia_peru";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Establece una contraseña si es necesario

    /**
     * Obtiene una conexión a la base de datos
     *
     * @return Objeto Connection con la conexión establecida
     * @throws SQLException Si ocurre un error al establecer la conexión
     */
    public static Connection getConexion() throws SQLException {
        try {
            // Cargar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establecer y retornar la conexión
            return DriverManager.getConnection(URL, USER, PASSWORD);

        } catch (ClassNotFoundException e) {
            throw new SQLException("No se encontró el driver de MySQL", e);
        } catch (SQLException e) {
            throw new SQLException("Error al conectar a la base de datos", e);
        }
    }

    /**
     * Cierra la conexión a la base de datos
     *
     * @param conn La conexión a cerrar
     */
    public static void cerrarConexion(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
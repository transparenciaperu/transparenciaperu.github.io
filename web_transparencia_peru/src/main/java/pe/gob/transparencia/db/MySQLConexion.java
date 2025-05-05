package pe.gob.transparencia.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MySQLConexion {
    private static boolean dbDisponible = true;

    public static Connection getConexion() {
        Connection con = null;
        try {
            System.out.println("MySQLConexion - getConexion - Intentando conectar a la base de datos...");

            Class.forName("com.mysql.cj.jdbc.Driver");

            // Ajusta estos parámetros según tu configuración
            String host = "localhost"; // Host de la base de datos
            String port = "3306";      // Puerto estándar de MySQL
            String database = "db_transparencia_peru"; // Nombre de la base de datos
            String user = "root";     // Usuario de la base de datos
            String password = "cibertec";     // Contraseña

            String url = "jdbc:mysql://" + host + ":" + port + "/" + database +
                    "?useSSL=false&useTimezone=true&serverTimezone=UTC&allowPublicKeyRetrieval=true";

            System.out.println("MySQLConexion - getConexion - URL de conexión: " + url);
            System.out.println("MySQLConexion - getConexion - Usuario: " + user);

            con = DriverManager.getConnection(url, user, password);
            if (con != null) {
                System.out.println("Conexión exitosa a la base de datos");
                dbDisponible = true;
            }
        } catch (ClassNotFoundException e) {
            System.out.println("Error >> Driver no Instalado!! " + e.getMessage());
            System.out.println("Por favor asegúrese de que el driver JDBC esté en el classpath");
            e.printStackTrace();
            dbDisponible = false;
        } catch (SQLException e) {
            System.out.println("Error >> de conexión con la BD " + e.getMessage());
            System.out.println("Código de error SQL: " + e.getErrorCode());
            System.out.println("Estado SQL: " + e.getSQLState());
            System.out.println("Verifique que la base de datos esté en ejecución y que las credenciales sean correctas");
            e.printStackTrace();
            dbDisponible = false;
        } catch (Exception e) {
            System.out.println("Error >> general : " + e.getMessage());
            System.out.println("Tipo de excepción: " + e.getClass().getName());
            if (e.getCause() != null) {
                System.out.println("Causa: " + e.getCause().getMessage());
            }
            e.printStackTrace();
            dbDisponible = false;
        }
        return con;
    }

    public static void closeConexion(Connection con) {
        try {
            if (con != null) {
                con.close();
            }
        } catch (SQLException e) {
            System.out.println("Problemas al cerrar la conexion");
        }
    }

    public static boolean isDbDisponible() {
        if (!dbDisponible) {
            Connection testCon = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Usar los mismos parámetros que en getConexion()
                String host = "localhost";
                String port = "3306";
                String database = "db_transparencia_peru";
                String user = "root";
                String password = "cibertec";

                String url = "jdbc:mysql://" + host + ":" + port + "/" + database +
                        "?useSSL=false&useTimezone=true&serverTimezone=UTC&allowPublicKeyRetrieval=true";

                testCon = DriverManager.getConnection(url, user, password);
                if (testCon != null) {
                    dbDisponible = true;
                }
            } catch (Exception e) {
                dbDisponible = false;
            } finally {
                closeConexion(testCon);
            }
        }
        return dbDisponible;
    }

}
package pe.gob.transparencia.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MySQLConexion {    public static Connection getConexion() {
        Connection con = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/db_transparencia_peru?useSSL=false&useTimezone=true&serverTimezone=UTC";
            String usr = "root";
            String psw = "cibertec";  // Ajusta la contraseña según tu configuración
            con = DriverManager.getConnection(url, usr, psw);
            if (con != null) {
                System.out.println("Conexión exitosa a la base de datos");
            }
        } catch (ClassNotFoundException e) {
            System.out.println("Error >> Driver no Instalado!! " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Error >> de conexión con la BD " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Error >> general : " + e.getMessage());
            e.printStackTrace();
        }
        return con;
    }

    public static void closeConexion(Connection con) {
        try {
            con.close();
        } catch (SQLException e) {
            System.out.println("Problemas al cerrar la conexion");
        }
    }

}

package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.gob.transparencia.db.MySQLConexion;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet(name = "DebugServlet", urlPatterns = {"/debug.do"})
public class DebugServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            Connection con = MySQLConexion.getConexion();
            if (con == null) {
                System.out.println("DebugServlet: Error - No se pudo conectar a la base de datos");
                out.print("{\"status\": \"error\", \"message\": \"No se pudo conectar a la base de datos\"}");
                return;
            }

            // Verificar estructura de la tabla EntidadPublica
            System.out.println("\n======= DEPURACIÓN DE BASE DE DATOS =======");
            System.out.println("Verificando estructura de la tabla EntidadPublica:");

            DatabaseMetaData dbmd = con.getMetaData();

            // Verificar columnas
            ResultSet columnas = dbmd.getColumns(null, null, "EntidadPublica", null);
            System.out.println("\nColumnas en tabla EntidadPublica:");
            while (columnas.next()) {
                String columnName = columnas.getString("COLUMN_NAME");
                String dataType = columnas.getString("TYPE_NAME");
                String isNullable = columnas.getString("IS_NULLABLE");
                System.out.println("- " + columnName + " (" + dataType + ") " + (isNullable.equals("YES") ? "Nullable" : "NOT NULL"));
            }

            // Verificar claves foráneas
            ResultSet foreignKeys = dbmd.getImportedKeys(null, null, "EntidadPublica");
            System.out.println("\nClaves foráneas en tabla EntidadPublica:");
            while (foreignKeys.next()) {
                String fkColumnName = foreignKeys.getString("FKCOLUMN_NAME");
                String pkTableName = foreignKeys.getString("PKTABLE_NAME");
                String pkColumnName = foreignKeys.getString("PKCOLUMN_NAME");
                System.out.println("- " + fkColumnName + " referencia " + pkTableName + "." + pkColumnName);
            }

            // Verificar datos en NivelGobierno
            System.out.println("\nDatos en tabla NivelGobierno:");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT id, nombre FROM NivelGobierno");
            while (rs.next()) {
                System.out.println("- ID: " + rs.getInt("id") + ", Nombre: " + rs.getString("nombre"));
            }

            // Verificar datos en Region
            System.out.println("\nDatos en tabla Region:");
            rs = stmt.executeQuery("SELECT id, nombre FROM Region LIMIT 5");
            while (rs.next()) {
                System.out.println("- ID: " + rs.getInt("id") + ", Nombre: " + rs.getString("nombre"));
            }

            // Verificar si existe regionId=0 en Region
            System.out.println("\nVerificando si existe regionId=0:");
            rs = stmt.executeQuery("SELECT COUNT(*) as count FROM Region WHERE id=0");
            if (rs.next()) {
                int count = rs.getInt("count");
                System.out.println("- Registros con regionId=0: " + count);
                if (count == 0) {
                    System.out.println("  ¡ALERTA! No existe regionId=0 en la tabla Region. Esto podría causar problemas con las restricciones de clave foránea.");

                    // Intentar crear la región nacional
                    try {
                        System.out.println("  Intentando crear región nacional...");
                        Statement createStmt = con.createStatement();
                        String insertSql = "INSERT INTO Region (id, nombre, codigo) VALUES (0, 'Nacional', 'NAC')";
                        int result = createStmt.executeUpdate(insertSql);
                        if (result > 0) {
                            System.out.println("  ¡ÉXITO! Se ha creado la región nacional con ID 0.");
                        } else {
                            System.out.println("  No se pudo crear la región nacional.");
                        }
                        createStmt.close();
                    } catch (SQLException ex) {
                        System.out.println("  Error al crear región nacional: " + ex.getMessage());
                    }
                }
            }

            // Verificar si hay entidades nacionales con regionId = 0
            System.out.println("\nVerificando entidades nacionales con regionId=0:");
            rs = stmt.executeQuery("SELECT COUNT(*) as count FROM EntidadPublica WHERE nivelGobiernoId=1 AND regionId=0");
            if (rs.next()) {
                System.out.println("- Entidades nacionales con regionId=0: " + rs.getInt("count"));
            }

            // Modificar esquema para permitir nulos en regionId
            System.out.println("\nRECOMENDACIÓN: Para solucionar el problema, ejecutar:");
            System.out.println("ALTER TABLE EntidadPublica MODIFY COLUMN regionId INT NULL;");

            // Respuesta al cliente
            out.print("{\"status\": \"success\", \"message\": \"Depuración completa. Consulta el log del servidor.\"}");

        } catch (SQLException e) {
            System.out.println("Error en DebugServlet: " + e.getMessage());
            e.printStackTrace();
            out.print("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}
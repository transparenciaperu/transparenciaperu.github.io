package pe.gob.transparencia.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.db.MySQLConexion;
import pe.gob.transparencia.modelo.EntidadPublicaModelo;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

@WebServlet(name = "DiagnosticoServlet", urlPatterns = {"/diagnostico.do"})
public class DiagnosticoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html>");
        out.println("<head>");
        out.println("<title>Diagnóstico del Sistema</title>");
        out.println("<style>body{font-family:Arial,sans-serif; margin:20px;} " +
                ".success{color:green;} .error{color:red;} " +
                "table{border-collapse:collapse; width:100%;} " +
                "th,td{border:1px solid #ddd; padding:8px; text-align:left;}</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Diagnóstico del Sistema - Portal de Transparencia</h1>");

        // 1. Verificar conexión a la base de datos
        out.println("<h2>1. Verificación de conexión a la base de datos</h2>");
        try {
            Connection conn = MySQLConexion.getConexion();
            if (conn != null) {
                out.println("<p class='success'>✓ Conexión a la base de datos establecida correctamente.</p>");

                // Verificar metadata de la conexión
                out.println("<p>Detalles de la conexión:</p>");
                out.println("<ul>");
                out.println("<li>URL: " + conn.getMetaData().getURL() + "</li>");
                out.println("<li>Usuario: " + conn.getMetaData().getUserName() + "</li>");
                out.println("<li>Driver: " + conn.getMetaData().getDriverName() + " " + conn.getMetaData().getDriverVersion() + "</li>");
                out.println("<li>Base de datos: " + conn.getCatalog() + "</li>");
                out.println("</ul>");

                // Verificar disponibilidad de la tabla EntidadPublica
                out.println("<h3>Verificando tabla EntidadPublica</h3>");
                try {
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SHOW TABLES LIKE 'EntidadPublica'");
                    if (rs.next()) {
                        out.println("<p class='success'>✓ Tabla EntidadPublica existe.</p>");

                        // Verificar estructura de la tabla
                        rs = stmt.executeQuery("DESCRIBE EntidadPublica");
                        out.println("<p>Estructura de la tabla EntidadPublica:</p>");
                        out.println("<table>");
                        out.println("<tr><th>Campo</th><th>Tipo</th><th>Nulo</th><th>Llave</th><th>Default</th><th>Extra</th></tr>");
                        while (rs.next()) {
                            out.println("<tr>");
                            out.println("<td>" + rs.getString("Field") + "</td>");
                            out.println("<td>" + rs.getString("Type") + "</td>");
                            out.println("<td>" + rs.getString("Null") + "</td>");
                            out.println("<td>" + rs.getString("Key") + "</td>");
                            out.println("<td>" + (rs.getString("Default") != null ? rs.getString("Default") : "") + "</td>");
                            out.println("<td>" + (rs.getString("Extra") != null ? rs.getString("Extra") : "") + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</table>");

                        // Verificar datos en la tabla
                        rs = stmt.executeQuery("SELECT COUNT(*) as total FROM EntidadPublica");
                        if (rs.next()) {
                            int total = rs.getInt("total");
                            if (total > 0) {
                                out.println("<p class='success'>✓ La tabla EntidadPublica contiene " + total + " registros.</p>");

                                // Mostrar algunos registros
                                rs = stmt.executeQuery("SELECT id, nombre, tipo, nivelGobiernoId, regionId FROM EntidadPublica LIMIT 10");
                                out.println("<p>Primeros 10 registros en EntidadPublica:</p>");
                                out.println("<table>");
                                out.println("<tr><th>ID</th><th>Nombre</th><th>Tipo</th><th>NivelGobiernoId</th><th>RegionId</th></tr>");
                                while (rs.next()) {
                                    out.println("<tr>");
                                    out.println("<td>" + rs.getInt("id") + "</td>");
                                    out.println("<td>" + rs.getString("nombre") + "</td>");
                                    out.println("<td>" + rs.getString("tipo") + "</td>");
                                    out.println("<td>" + rs.getInt("nivelGobiernoId") + "</td>");
                                    out.println("<td>" + rs.getInt("regionId") + "</td>");
                                    out.println("</tr>");
                                }
                                out.println("</table>");
                            } else {
                                out.println("<p class='error'>✗ La tabla EntidadPublica no contiene registros.</p>");
                            }
                        }

                    } else {
                        out.println("<p class='error'>✗ La tabla EntidadPublica no existe.</p>");
                    }

                    rs.close();
                    stmt.close();
                } catch (Exception e) {
                    out.println("<p class='error'>✗ Error al verificar la tabla EntidadPublica: " + e.getMessage() + "</p>");
                    e.printStackTrace(new PrintWriter(out));
                }

                conn.close();
            } else {
                out.println("<p class='error'>✗ No se pudo establecer conexión a la base de datos.</p>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>✗ Error al conectar con la base de datos: " + e.getMessage() + "</p>");
            e.printStackTrace(new PrintWriter(out));
        }

        // 2. Verificar el modelo EntidadPublicaModelo
        out.println("<h2>2. Verificación del modelo EntidadPublicaModelo</h2>");
        try {
            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            List<EntidadPublicaEntidad> entidades = modelo.listarEntidades();

            if (entidades != null) {
                out.println("<p>Método listarEntidades() devuelve una lista con " + entidades.size() + " entidades.</p>");

                if (entidades.isEmpty()) {
                    out.println("<p class='error'>✗ La lista está vacía. Verifica la consulta SQL o los datos en la tabla.</p>");
                } else {
                    out.println("<p class='success'>✓ Se encontraron entidades. Mostrando las primeras 10:</p>");
                    out.println("<table>");
                    out.println("<tr><th>ID</th><th>Nombre</th><th>Tipo</th><th>NivelGobiernoId</th><th>RegionId</th></tr>");

                    int count = 0;
                    for (EntidadPublicaEntidad entidad : entidades) {
                        if (count++ >= 10) break;

                        out.println("<tr>");
                        out.println("<td>" + entidad.getId() + "</td>");
                        out.println("<td>" + entidad.getNombre() + "</td>");
                        out.println("<td>" + entidad.getTipo() + "</td>");
                        out.println("<td>" + entidad.getNivelGobiernoId() + "</td>");
                        out.println("<td>" + entidad.getRegionId() + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }
            } else {
                out.println("<p class='error'>✗ El método listarEntidades() devolvió NULL.</p>");
            }
        } catch (Exception e) {
            out.println("<p class='error'>✗ Error al intentar listar entidades: " + e.getMessage() + "</p>");
            e.printStackTrace(new PrintWriter(out));
        }

        // 3. Instrucciones para solucionar problemas
        out.println("<h2>3. Recomendaciones para solucionar problemas</h2>");
        out.println("<ul>");
        out.println("<li>Asegúrate de que la base de datos exista y esté correctamente configurada.</li>");
        out.println("<li>Verifica los parámetros de conexión (usuario, contraseña, URL) en la clase MySQLConexion.</li>");
        out.println("<li>Comprueba que las tablas existan y tengan la estructura esperada.</li>");
        out.println("<li>Verifica que existan datos en las tablas.</li>");
        out.println("<li>Revisa los logs del servidor para detectar errores específicos.</li>");
        out.println("<li>Si has modificado el código, reinicia el servidor para aplicar los cambios.</li>");
        out.println("</ul>");

        out.println("<p><a href='" + request.getContextPath() + "/admin/entidades.jsp'>Volver a la página de Entidades</a></p>");

        out.println("</body>");
        out.println("</html>");
    }
}
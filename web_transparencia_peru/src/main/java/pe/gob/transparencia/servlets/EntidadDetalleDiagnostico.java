package pe.gob.transparencia.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.modelo.EntidadPublicaModelo;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/diagnosticoEntidades")
public class EntidadDetalleDiagnostico extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<html><head><title>Diagnóstico de Entidades</title>");
        out.println("<style>body{font-family:Arial,sans-serif;margin:20px;line-height:1.6}");
        out.println(".success{color:green;font-weight:bold}.error{color:red;font-weight:bold}");
        out.println("pre{background:#f5f5f5;padding:10px;border:1px solid #ddd;overflow:auto}");
        out.println("table{border-collapse:collapse;width:100%}th,td{border:1px solid #ddd;padding:8px}");
        out.println("</style></head><body>");

        out.println("<h1>Diagnóstico de Ver Detalle de Entidad</h1>");

        // Verifica si se proporcionó un ID como parámetro
        String idStr = request.getParameter("id");
        out.println("<h2>Paso 1: Verificar Parámetro ID</h2>");
        if (idStr != null && !idStr.isEmpty()) {
            out.println("<p class='success'>✓ ID recibido: " + idStr + "</p>");

            try {
                int id = Integer.parseInt(idStr);
                out.println("<p class='success'>✓ ID válido como número: " + id + "</p>");

                // Intentar recuperar la entidad por ID
                out.println("<h2>Paso 2: Buscar Entidad por ID</h2>");
                EntidadPublicaModelo modelo = new EntidadPublicaModelo();
                EntidadPublicaEntidad entidad = modelo.buscarPorId(id);

                if (entidad != null) {
                    out.println("<p class='success'>✓ Entidad encontrada con ID " + id + "</p>");
                    out.println("<h3>Datos de la entidad:</h3>");
                    out.println("<table>");
                    out.println("<tr><th>Campo</th><th>Valor</th></tr>");
                    out.println("<tr><td>ID</td><td>" + entidad.getId() + "</td></tr>");
                    out.println("<tr><td>Nombre</td><td>" + (entidad.getNombre() != null ? entidad.getNombre() : "<em>null</em>") + "</td></tr>");
                    out.println("<tr><td>Tipo</td><td>" + (entidad.getTipo() != null ? entidad.getTipo() : "<em>null</em>") + "</td></tr>");
                    out.println("<tr><td>nivelGobiernoId</td><td>" + entidad.getNivelGobiernoId() + "</td></tr>");
                    out.println("<tr><td>regionId</td><td>" + entidad.getRegionId() + "</td></tr>");
                    out.println("<tr><td>Dirección</td><td>" + (entidad.getDireccion() != null ? entidad.getDireccion() : "<em>null</em>") + "</td></tr>");
                    out.println("<tr><td>Teléfono</td><td>" + (entidad.getTelefono() != null ? entidad.getTelefono() : "<em>null</em>") + "</td></tr>");
                    out.println("<tr><td>Email</td><td>" + (entidad.getEmail() != null ? entidad.getEmail() : "<em>null</em>") + "</td></tr>");
                    out.println("<tr><td>Sitio Web</td><td>" + (entidad.getSitioWeb() != null ? entidad.getSitioWeb() : "<em>null</em>") + "</td></tr>");
                    out.println("<tr><td>RUC</td><td>" + (entidad.getRuc() != null ? entidad.getRuc() : "<em>null</em>") + "</td></tr>");
                    out.println("</table>");

                    // Simular lo que haría el servlet de Entidades
                    out.println("<h2>Paso 3: Simulación de Forward a entidad_detalle.jsp</h2>");
                    out.println("<p>En un escenario normal, estos son los pasos que se seguirían:</p>");
                    out.println("<ol>");
                    out.println("<li>Se coloca la entidad en el request con: request.setAttribute(\"entidad\", entidad);</li>");
                    out.println("<li>Se reenvía la petición a entidad_detalle.jsp con: request.getRequestDispatcher(\"/admin/entidad_detalle.jsp\").forward(request, response);</li>");
                    out.println("</ol>");

                    out.println("<h3>Probemos ahora una redirección directa:</h3>");
                    out.println("<p><a href='" + request.getContextPath() +
                            "/entidades.do?accion=verDetalle&id=" + id +
                            "' target='_blank' class='btn'>Probar redirección directa al detalle</a></p>");

                } else {
                    out.println("<p class='error'>✗ No se encontró ninguna entidad con ID " + id + "</p>");
                    out.println("<h3>Posibles causas:</h3>");
                    out.println("<ul>");
                    out.println("<li>No existe una entidad con ese ID en la base de datos.</li>");
                    out.println("<li>Hay un problema en la consulta SQL en el método buscarPorId().</li>");
                    out.println("<li>Hay un problema de conexión con la base de datos.</li>");
                    out.println("</ul>");

                    // Verificar la conexión y la tabla
                    out.println("<h3>Verificación de la tabla EntidadPublica:</h3>");
                    out.println("<p>Ejecutando diagnóstico de conexión...</p>");
                    out.println("<p>URL: <a href='" + request.getContextPath() + "/diagnostico.do'>Ejecutar diagnóstico completo</a></p>");
                }
            } catch (NumberFormatException e) {
                out.println("<p class='error'>✗ El ID proporcionado no es un número válido: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p class='error'>✗ No se proporcionó un ID como parámetro</p>");
            out.println("<p>Por favor, añade un parámetro 'id' a la URL (ej: ?id=1)</p>");
        }

        out.println("<h2>Instrucciones de depuración:</h2>");
        out.println("<ol>");
        out.println("<li>Asegúrate de que la entidad existe en la base de datos</li>");
        out.println("<li>Verifica que el ID que estás pasando es correcto</li>");
        out.println("<li>Revisa los logs del servidor para ver posibles errores durante la buscarPorId()</li>");
        out.println("<li>Verifica que el archivo entidad_detalle.jsp existe y está correctamente configurado</li>");
        out.println("<li>Prueba una entidad diferente para ver si el problema es con una entidad específica</li>");
        out.println("</ol>");

        out.println("<p><a href='" + request.getContextPath() + "/admin/entidades.jsp'>Volver a la lista de entidades</a></p>");

        out.println("</body></html>");
    }
}
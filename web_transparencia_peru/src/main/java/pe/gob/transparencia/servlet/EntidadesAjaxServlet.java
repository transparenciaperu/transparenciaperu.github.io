package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.modelo.EntidadPublicaModelo;

@WebServlet(name = "EntidadesAjaxServlet", urlPatterns = {"/entidades.do"})
public class EntidadesAjaxServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public EntidadesAjaxServlet() {
        super();
    }

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            String nivelParam = request.getParameter("nivel");
            String regionParam = request.getParameter("region");

            // Validar parámetros
            if (nivelParam == null || nivelParam.isEmpty()) {
                out.print("[]"); // Retornar array vacío si no hay nivel
                return;
            }

            Integer nivel = Integer.parseInt(nivelParam);
            Integer region = null;

            if (regionParam != null && !regionParam.isEmpty()) {
                try {
                    region = Integer.parseInt(regionParam);
                } catch (NumberFormatException e) {
                    // Ignorar si no es un número válido
                }
            }

            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            List<EntidadPublicaEntidad> entidades = modelo.listarPorNivelYRegion(nivel, region);

            // Construir manualmente el JSON para evitar dependencias adicionales
            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            for (EntidadPublicaEntidad entidad : entidades) {
                if (!first) {
                    json.append(",");
                }
                first = false;

                json.append("{");
                json.append("\"id\":").append(entidad.getId()).append(",");
                json.append("\"nombre\":\"").append(escape(entidad.getNombre())).append("\",");
                json.append("\"tipo\":\"").append(escape(entidad.getTipo())).append("\",");
                json.append("\"nivel\":").append(entidad.getNivelGobiernoId());

                if (entidad.getRegionId() > 0) {
                    json.append(",");
                    json.append("\"region_id\":").append(entidad.getRegionId());
                    if (entidad.getRegion() != null && !entidad.getRegion().isEmpty()) {
                        json.append(",");
                        json.append("\"region\":\"").append(escape(entidad.getRegion())).append("\"");
                    }
                }

                json.append("}");
            }

            json.append("]");
            out.print(json.toString());

        } catch (Exception e) {
            System.out.println("Error en EntidadesAjaxServlet: " + e.getMessage());
            e.printStackTrace();

            // Enviar respuesta de error
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("[]");
        }
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Escapar caracteres especiales para JSON
     */
    private String escape(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
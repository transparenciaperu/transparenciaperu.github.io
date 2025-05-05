package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.modelo.EntidadPublicaModelo;
import pe.gob.transparencia.db.MySQLConexion;

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
        // Obtener el parámetro de acción
        String accion = request.getParameter("accion");
        HttpSession session = request.getSession();

        try {
            if (accion == null) {
                // Si no hay acción especificada, delegar al doGet para compatibilidad
                doGet(request, response);
                return;
            }

            EntidadPublicaModelo modelo = new EntidadPublicaModelo();
            int resultado = 0;
            String mensaje = "";
            String tipoMensaje = "danger"; // Por defecto, asumimos error
            boolean redirigir = true;

            switch (accion) {
                case "registrar":
                    // Obtener datos del formulario
                    String nombre = request.getParameter("nombre");
                    String tipo = request.getParameter("tipo");
                    Integer nivelGobiernoId = null;

                    try {
                        nivelGobiernoId = Integer.parseInt(request.getParameter("nivelGobiernoId"));
                    } catch (NumberFormatException e) {
                        mensaje = "El nivel de gobierno es obligatorio";
                        break;
                    }

                    Integer regionId = null;
                    // Buscar todos los posibles nombres de parámetros para regionId
                    String[] posiblesParametrosRegion = {
                            "regionId", "hiddenRegionId", "fixed_regionId", "respaldo_regionId",
                            "nacional_regionId", "region_id", "region"
                    };
                    String valorRegionUsado = null;

                    // Si no es nivel nacional, buscar el regionId en los parámetros
                    for (String paramName : posiblesParametrosRegion) {
                        String paramValue = request.getParameter(paramName);
                        if (paramValue != null && !paramValue.isEmpty()) {
                            try {
                                regionId = Integer.parseInt(paramValue);
                                valorRegionUsado = paramName;
                                System.out.println("Usando valor de regionId desde parámetro: " + paramName + " = " + regionId);
                                break; // Usar el primer valor válido que encontremos
                            } catch (NumberFormatException e) {
                                System.out.println("Error al parsear " + paramName + ": " + e.getMessage());
                            }
                        }
                    }

                    // Para depuración, mostrar todos los parámetros de la solicitud
                    System.out.println("Parámetros de la solicitud:");
                    java.util.Enumeration<String> paramNames = request.getParameterNames();
                    while (paramNames.hasMoreElements()) {
                        String paramName = paramNames.nextElement();
                        String paramValue = request.getParameter(paramName);
                        System.out.println("  " + paramName + " = " + paramValue);
                    }

                    String direccion = request.getParameter("direccion");
                    String telefono = request.getParameter("telefono");
                    String email = request.getParameter("email");
                    String sitioWeb = request.getParameter("sitioWeb");

                    // Debug
                    System.out.println("EntidadesAjaxServlet - registrar - Datos recibidos:");
                    System.out.println("nombre: " + nombre);
                    System.out.println("tipo: " + tipo);
                    System.out.println("nivelGobiernoId: " + nivelGobiernoId);
                    System.out.println("regionId: " + regionId);
                    System.out.println("direccion: " + direccion);
                    System.out.println("telefono: " + telefono);
                    System.out.println("email: " + email);
                    System.out.println("sitioWeb: " + sitioWeb);

                    // Verificando el valor de regionId recibido
                    String regionIdParam = request.getParameter("regionId");
                    System.out.println("regionId (parámetro crudo): '" + regionIdParam + "'");
                    System.out.println("regionId (parseado): " + regionId);
                    System.out.println("direccion: " + direccion);
                    System.out.println("telefono: " + telefono);
                    System.out.println("email: " + email);
                    System.out.println("sitioWeb: " + sitioWeb);

                    try {
                        // Validaciones básicas
                        if (nombre == null || nombre.trim().isEmpty()) {
                            mensaje = "El nombre de la entidad es obligatorio";
                            break;
                        }

                        if (tipo == null || tipo.trim().isEmpty()) {
                            mensaje = "El tipo de entidad es obligatorio";
                            break;
                        }

                        if (nivelGobiernoId == 0) {
                            mensaje = "Debe seleccionar un nivel de gobierno";
                            break;
                        }

                        // Crear entidad y guardar
                        EntidadPublicaEntidad entidad = new EntidadPublicaEntidad();
                        entidad.setNombre(nombre);
                        entidad.setTipo(tipo);
                        entidad.setNivelGobiernoId(nivelGobiernoId);

                        // Asegurar que regionId sea el valor seleccionado
                        if (regionId != null) {
                            entidad.setRegionId(regionId);
                            System.out.println("Establecido regionId=" + regionId + " para entidad");
                        } else if (nivelGobiernoId == 1) {
                            entidad.setRegionId(0); // Para nivel nacional, siempre es 0
                            System.out.println("Establecido regionId=0 para entidad nacional");
                        }

                        entidad.setDireccion(direccion);
                        entidad.setTelefono(telefono);
                        entidad.setEmail(email);
                        entidad.setSitioWeb(sitioWeb);

                        // Mostrar objeto antes de guardarlo
                        System.out.println("EntidadesAjaxServlet - registrar - Entidad a guardar:");
                        System.out.println("ID: " + entidad.getId());
                        System.out.println("Nombre: " + entidad.getNombre());
                        System.out.println("Tipo: " + entidad.getTipo());
                        System.out.println("NivelGobiernoId: " + entidad.getNivelGobiernoId());
                        System.out.println("RegionId: " + entidad.getRegionId());

                        // Log antes de registrar
                        System.out.println("EntidadesAjaxServlet - registrar - Intentando registrar entidad: " + entidad.getNombre());

                        try {
                            // MODO DEBUG - Crear registro de región Nacional si no existe
                            if (entidad.getNivelGobiernoId() == 1) {
                                System.out.println("EntidadesAjaxServlet - Verificando si existe región Nacional (ID=0)");
                                Connection con = MySQLConexion.getConexion();
                                if (con != null) {
                                    try {
                                        Statement stmt = con.createStatement();
                                        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Region WHERE id = 0");
                                        if (rs.next() && rs.getInt(1) == 0) {
                                            System.out.println("EntidadesAjaxServlet - Creando región Nacional faltante");
                                            stmt.executeUpdate("INSERT INTO Region (id, nombre, codigo) VALUES (0, 'Nacional', 'NAC')");
                                            System.out.println("EntidadesAjaxServlet - Región Nacional creada correctamente");
                                        }
                                        rs.close();
                                        stmt.close();
                                        con.close();
                                    } catch (Exception e) {
                                        System.out.println("Error comprobando/creando región Nacional: " + e.getMessage());
                                    }
                                }
                            }

                            resultado = modelo.registrarEntidad(entidad);
                        } catch (Exception e) {
                            System.out.println("ERROR CRÍTICO AL REGISTRAR ENTIDAD: " + e.getMessage());
                            e.printStackTrace();
                        }

                        System.out.println("EntidadesAjaxServlet - registrar - Resultado: " + resultado);

                        if (resultado > 0) {
                            mensaje = "Entidad registrada correctamente";
                            tipoMensaje = "success";
                        } else {
                            mensaje = "Error al registrar la entidad. Verifique que todos los campos obligatorios estén completos.";
                            System.out.println("DIAGNOSTICO: Registro de entidad falló. Verificando valores obligatorios:");
                            System.out.println("- Nombre: " + (entidad.getNombre() != null && !entidad.getNombre().isEmpty()));
                            System.out.println("- Tipo: " + (entidad.getTipo() != null && !entidad.getTipo().isEmpty()));
                            System.out.println("- NivelGobiernoId: " + entidad.getNivelGobiernoId() + " (debe ser > 0)");
                            System.out.println("- RegionId: " + entidad.getRegionId() + " (debe ser > 0)");
                            System.out.println("La entidad NO fue registrada en la base de datos.");
                        }
                    } catch (Exception e) {
                        System.out.println("EntidadesAjaxServlet - registrar - Error: " + e.getMessage());
                        e.printStackTrace();
                        mensaje = "Error al registrar la entidad: " + e.getMessage();

                        // Para errores técnicos, registramos detalles adicionales en el log
                        System.out.println("Detalles técnicos del error:");
                        System.out.println("Clase: " + e.getClass().getName());
                        System.out.println("Mensaje: " + e.getMessage());
                        if (e.getCause() != null) {
                            System.out.println("Causa: " + e.getCause().getMessage());
                        }
                    }
                    break;

                case "actualizar":
                    // Obtener ID y datos del formulario
                    Integer id = null;

                    try {
                        id = Integer.parseInt(request.getParameter("id"));
                    } catch (NumberFormatException e) {
                        mensaje = "ID de entidad inválido";
                        break;
                    }

                    nombre = request.getParameter("nombre");
                    tipo = request.getParameter("tipo");

                    try {
                        nivelGobiernoId = Integer.parseInt(request.getParameter("nivelGobiernoId"));
                    } catch (NumberFormatException e) {
                        mensaje = "El nivel de gobierno es obligatorio";
                        break;
                    }

                    regionId = null;
                    if (request.getParameter("regionId") != null && !request.getParameter("regionId").isEmpty()) {
                        try {
                            regionId = Integer.parseInt(request.getParameter("regionId"));
                        } catch (NumberFormatException e) {
                            mensaje = "Valor de región inválido";
                            break;
                        }
                    }

                    // Si es nivel nacional, asegurar que regionId sea 0
                    if (nivelGobiernoId == 1) {
                        regionId = 0;
                        System.out.println("Actualización: Nivel nacional detectado. Estableciendo regionId=0.");
                    }

                    // Reutilizar variables ya declaradas
                    direccion = request.getParameter("direccion");
                    telefono = request.getParameter("telefono");
                    email = request.getParameter("email");
                    sitioWeb = request.getParameter("sitioWeb");

                    // Crear entidad y actualizar
                    EntidadPublicaEntidad entidadActualizar = new EntidadPublicaEntidad();
                    entidadActualizar.setId(id);
                    entidadActualizar.setNombre(nombre);
                    entidadActualizar.setTipo(tipo);
                    entidadActualizar.setNivelGobiernoId(nivelGobiernoId);
                    entidadActualizar.setRegionId(regionId != null ? regionId : 0);
                    entidadActualizar.setDireccion(direccion);
                    entidadActualizar.setTelefono(telefono);
                    entidadActualizar.setEmail(email);
                    entidadActualizar.setSitioWeb(sitioWeb);

                    resultado = modelo.actualizarEntidad(entidadActualizar);
                    if (resultado > 0) {
                        mensaje = "Entidad actualizada correctamente";
                        tipoMensaje = "success";
                    } else {
                        mensaje = "Error al actualizar la entidad";
                    }
                    break;

                case "eliminar":
                    // Obtener ID para eliminar
                    Integer idEliminar = null;

                    try {
                        idEliminar = Integer.parseInt(request.getParameter("id"));
                    } catch (NumberFormatException e) {
                        mensaje = "ID de entidad inválido";
                        break;
                    }

                    System.out.println("EntidadesAjaxServlet.doPost - Acción eliminar: Intentando eliminar entidad con ID " + idEliminar);

                    // Intentamos eliminar directamente sin verificación previa
                    System.out.println("EntidadesAjaxServlet.doPost - Acción eliminar: Procediendo directamente a eliminar la entidad");

                    resultado = modelo.eliminarEntidad(idEliminar);
                    System.out.println("EntidadesAjaxServlet.doPost - Acción eliminar: Resultado de eliminación: " + resultado);

                    if (resultado > 0) {
                        mensaje = "Entidad eliminada correctamente";
                        tipoMensaje = "success";
                        System.out.println("EntidadesAjaxServlet.doPost - Acción eliminar: Entidad eliminada con éxito");
                    } else if (resultado == -1) {
                        // Código especial que indica que hay referencias
                        mensaje = "No se puede eliminar la entidad porque está siendo utilizada en otros registros";
                        System.out.println("EntidadesAjaxServlet.doPost - Acción eliminar: La entidad tiene referencias y no puede ser eliminada");
                    } else {
                        mensaje = "No se pudo eliminar la entidad. La entidad posiblemente no existe.";
                        System.out.println("EntidadesAjaxServlet.doPost - Acción eliminar: La entidad no existe o ya fue eliminada");
                    }
                    break;

                default:
                    // Acción no reconocida, delegar al doGet
                    doGet(request, response);
                    return;
            }

            // Guardar mensaje en sesión y redirigir
            session.setAttribute("mensaje", mensaje);
            session.setAttribute("tipoMensaje", tipoMensaje);

            if (redirigir) {
                response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
            } else {
                // Si no redirigimos, enviamos una respuesta JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                PrintWriter out = response.getWriter();
                out.print("{\"success\":" + (tipoMensaje.equals("success")) + ",\"mensaje\":\"" + mensaje + "\"}");
                out.flush();
            }

        } catch (Exception e) {
            System.out.println("Error procesando la solicitud POST en EntidadesAjaxServlet: " + e.getMessage());
            e.printStackTrace();

            // Determinar el tipo de error para mostrar un mensaje apropiado
            String mensajeError = "Error en la operación: " + e.getMessage();

            if (e instanceof NumberFormatException) {
                mensajeError = "Error: Formato de número inválido en los parámetros";
            } else if (e.getMessage() != null && e.getMessage().toLowerCase().contains("foreign key")) {
                mensajeError = "No se puede realizar la operación porque existen registros relacionados";
            }

            session.setAttribute("mensaje", mensajeError);
            session.setAttribute("tipoMensaje", "danger");

            try {
                response.sendRedirect(request.getContextPath() + "/admin/entidades.jsp");
            } catch (IOException ex) {
                System.out.println("Error al redirigir después de un error: " + ex.getMessage());
            }
        }
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